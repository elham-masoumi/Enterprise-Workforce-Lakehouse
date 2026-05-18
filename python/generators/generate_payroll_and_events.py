import pandas as pd
import numpy as np
from datetime import datetime
from pathlib import Path

# مسیر پروژه
base_path = Path("D:/Projects/Enterprise_Workforce_Lakehouse")

# تعداد کارمندان (همون 1M)
NUM_EMPLOYEES = 1_000_000

# لیست EmployeeNaturalId ها
employee_ids = [f"E{str(i).zfill(7)}" for i in range(1, NUM_EMPLOYEES + 1)]

# --- تنظیم ماه‌ها ---
pay_months = ["2026-01", "2026-02", "2026-03"]
load_dates = ["2026-01-29", "2026-02-28", "2026-03-31"]  # برای dt partition

# --- Payroll Generation ---
# پایه حقوق اولیه (تصادفی ولی منطقی)
base_salary = np.random.randint(2200, 7000, size=NUM_EMPLOYEES)  # GBP
pay_grade = np.random.choice(["G3", "G4", "G5", "G6", "G7"], size=NUM_EMPLOYEES)

for pay_month, load_date in zip(pay_months, load_dates):
    # فرض: 90% Active هستند (برای ساده‌سازی)
    active_mask = np.random.choice([True, False], size=NUM_EMPLOYEES, p=[0.90, 0.10])

    # رشد حقوق ماه به ماه برای Active ها
    increment = np.random.randint(0, 120, size=NUM_EMPLOYEES)  # افزایش کوچک
    base_salary = base_salary + (increment * active_mask.astype(int))

    bonus = np.where(
        np.random.rand(NUM_EMPLOYEES) < 0.15,
        np.random.randint(100, 1200, size=NUM_EMPLOYEES),
        0
    )

    payroll_df = pd.DataFrame({
        "EmployeeNaturalId": np.array(employee_ids)[active_mask],
        "PayMonth": pay_month,
        "BaseSalary": base_salary[active_mask],
        "Bonus": bonus[active_mask],
        "Currency": "GBP",
        "PayGrade": pay_grade[active_mask]
    })

    out_dir = base_path / "data" / "raw" / "payroll" / f"dt={load_date}"
    out_dir.mkdir(parents=True, exist_ok=True)

    out_file = out_dir / f"payroll_{pay_month.replace('-', '')}.csv"
    payroll_df.to_csv(out_file, index=False)

    print(f"Payroll {pay_month} written: {len(payroll_df)} rows")

# --- Events Generation ---
# تعداد eventها (مثلاً 3% کارکنان در هر load_date یک event دارند)
event_types = ["Promotion", "Transfer", "SalaryChange"]
event_id_counter = 1

for load_date in load_dates:
    # تعداد eventها
    n_events = int(0.03 * NUM_EMPLOYEES)

    # کارکنانی که event می‌گیرند
    event_emp_idx = np.random.choice(np.arange(NUM_EMPLOYEES), n_events, replace=False)
    event_emp_ids = np.array(employee_ids)[event_emp_idx]

    event_type_col = np.random.choice(event_types, n_events, p=[0.25, 0.45, 0.30])

    # Late arriving: 30% رویدادها effective date قدیمی‌تر دارند
    load_dt = datetime.strptime(load_date, "%Y-%m-%d")
    late_mask = np.random.choice([True, False], size=n_events, p=[0.30, 0.70])

    effective_dates = []
    for is_late in late_mask:
        if is_late:
            # 15 تا 90 روز عقب‌تر
            days_back = np.random.randint(15, 90)
            effective_dates.append((load_dt - pd.Timedelta(days=days_back)).date())
        else:
            # نزدیک به load date (0 تا 7 روز قبل)
            days_back = np.random.randint(0, 7)
            effective_dates.append((load_dt - pd.Timedelta(days=days_back)).date())

    # Old/New values ساده (برای شروع)
    old_values = np.where(event_type_col == "Transfer", "D002",
                 np.where(event_type_col == "Promotion", "G4", "3000"))
    new_values = np.where(event_type_col == "Transfer", "D003",
                 np.where(event_type_col == "Promotion", "G5", "3300"))

    events_df = pd.DataFrame({
        "EventId": [f"EVT{str(i).zfill(9)}" for i in range(event_id_counter, event_id_counter + n_events)],
        "EmployeeNaturalId": event_emp_ids,
        "EventType": event_type_col,
        "EventEffectiveDate": effective_dates,
        "EventLoadDate": load_date,
        "OldValue": old_values,
        "NewValue": new_values,
        "SourceSystem": "HRSystem"
    })

    event_id_counter += n_events

    out_dir = base_path / "data" / "raw" / "hr_events" / f"dt={load_date}"
    out_dir.mkdir(parents=True, exist_ok=True)

    out_file = out_dir / f"hr_events_{load_date.replace('-', '')}.csv"
    events_df.to_csv(out_file, index=False)

    print(f"Events load {load_date} written: {len(events_df)} rows")
