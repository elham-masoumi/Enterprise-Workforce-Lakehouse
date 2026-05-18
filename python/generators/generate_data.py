{
 "cells": [
  {
   "cell_type": "code",
   "execution_count": 5,
   "id": "46751410-18d2-4234-89b8-f41df795fed0",
   "metadata": {},
   "outputs": [
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "Snapshot for 2026-01-23 written\n",
      "Snapshot for 2026-01-24 written\n",
      "Snapshot for 2026-01-25 written\n",
      "Snapshot for 2026-01-26 written\n",
      "Snapshot for 2026-01-27 written\n",
      "Snapshot for 2026-01-28 written\n",
      "Snapshot for 2026-01-29 written\n"
     ]
    }
   ],
   "source": [
    "import pandas as pd\n",
    "import numpy as np\n",
    "from faker import Faker\n",
    "from datetime import datetime, timedelta\n",
    "from pathlib import Path\n",
    "\n",
    "fake = Faker()\n",
    "\n",
    "NUM_EMPLOYEES = 1_000_000\n",
    "\n",
    "departments = [\"D001\", \"D002\", \"D003\", \"D004\", \"D005\"]\n",
    "jobs = [\"J010\", \"J020\", \"J030\", \"J040\"]\n",
    "locations = [\"Newcastle\", \"London\", \"Manchester\"]\n",
    "\n",
    "base_path = Path(\"D:/Projects/Enterprise_Workforce_Lakehouse\")\n",
    "\n",
    "# تاریخ شروع و تعداد روزها\n",
    "start_date = datetime(2026, 1, 23)\n",
    "num_days = 7\n",
    "\n",
    "# دیتای پایه (روز اول)\n",
    "df = pd.DataFrame({\n",
    "    \"EmployeeNaturalId\": [f\"E{str(i).zfill(7)}\" for i in range(1, NUM_EMPLOYEES + 1)],\n",
    "    \"Gender\": np.random.choice([\"Male\", \"Female\"], NUM_EMPLOYEES),\n",
    "    \"HireDate\": [fake.date_between(start_date='-10y', end_date='-1y') for _ in range(NUM_EMPLOYEES)],\n",
    "    \"DepartmentCode\": np.random.choice(departments, NUM_EMPLOYEES),\n",
    "    \"JobCode\": np.random.choice(jobs, NUM_EMPLOYEES),\n",
    "    \"Location\": np.random.choice(locations, NUM_EMPLOYEES),\n",
    "    \"EmploymentStatus\": np.random.choice(\n",
    "        [\"Active\", \"Active\", \"Active\", \"Terminated\"], NUM_EMPLOYEES\n",
    "    )\n",
    "})\n",
    "\n",
    "# تولید Snapshot روزانه\n",
    "for d in range(num_days):\n",
    "    load_date = (start_date + timedelta(days=d)).strftime(\"%Y-%m-%d\")\n",
    "\n",
    "    # --- شبیه‌سازی تغییرات ---\n",
    "    # 2% تغییر دپارتمان\n",
    "    dept_idx = np.random.choice(df.index, int(0.02 * NUM_EMPLOYEES), replace=False)\n",
    "    df.loc[dept_idx, \"DepartmentCode\"] = np.random.choice(departments, len(dept_idx))\n",
    "\n",
    "    # 1% تغییر شغل\n",
    "    job_idx = np.random.choice(df.index, int(0.01 * NUM_EMPLOYEES), replace=False)\n",
    "    df.loc[job_idx, \"JobCode\"] = np.random.choice(jobs, len(job_idx))\n",
    "\n",
    "    # مسیر خروجی\n",
    "    output_path = (\n",
    "        base_path\n",
    "        / \"data\" / \"raw\" / \"hr_core\"\n",
    "        / f\"dt={load_date}\"\n",
    "        / f\"hr_employees_{load_date.replace('-', '')}.csv\"\n",
    "    )\n",
    "\n",
    "    # 🔹 ساخت خودکار فولدر\n",
    "    output_path.parent.mkdir(parents=True, exist_ok=True)\n",
    "\n",
    "    # ذخیره فایل\n",
    "    df.to_csv(output_path, index=False)\n",
    "\n",
    "    print(f\"Snapshot for {load_date} written\")\n"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "id": "1c375b78-ccc1-4c23-853a-9a37c3f2181e",
   "metadata": {},
   "outputs": [],
   "source": []
  }
 ],
 "metadata": {
  "kernelspec": {
   "display_name": "Python 3",
   "language": "python",
   "name": "python3"
  },
  "language_info": {
   "codemirror_mode": {
    "name": "ipython",
    "version": 3
   },
   "file_extension": ".py",
   "mimetype": "text/x-python",
   "name": "python",
   "nbconvert_exporter": "python",
   "pygments_lexer": "ipython3",
   "version": "3.8.8"
  }
 },
 "nbformat": 4,
 "nbformat_minor": 5
}
