Markdown
# 🏫 School Enterprise Database System (Core Back-End)

![Database](https://img.shields.io/badge/Database-SQLite%20%7C%20PostgreSQL-blue?style=for-the-badge&logo=sqlite&logoColor=white)
![Security](https://img.shields.io/badge/Security-Data%20Integrity%20Enforced-red?style=for-the-badge&logo=shiled)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

An enterprise-grade, highly normalized relational database schema designed for modern educational institutions. This repository showcases advanced database architecture, structural data integrity using strict constraints, smart indexing, and complex analytical queries (BI) like weighted GPA calculation and financial tracking.

---

## ⚡ Tech Stack & Skills Showcased

Here is the tech leverage used to architect and test this enterprise hub:

* **Database Engines:** `SQLite` (Development/Testing), `PostgreSQL` / `MySQL` (Production Ready)
* **Architecture Standard:** 3NF (Third Normal Form) Alignment
* **Advanced SQL Techniques:** Multi-stage `JOIN`s, Aggregate Windows, Custom Mathematical Aggregations (`Weighted GPA`), Performance Tuning via `INDEX` mapping.

[  Database Architecture  ] █████████████████████████ 100%
[  Query Optimization     ] ████████████████████░░░░░ 85%
[  Data Integrity & ACL   ] ██████████████████████░░░ 90%


---

## 🗺️ Database Architecture & Entities

The system architecture is strictly split into 4 core operational logical layers to ensure maximum modularity and zero data anomalies:

### 1. 👥 Core Infrastructure
* `classes`: High-school track segregation (Mathematics / Experimental science).
* `students`: Comprehensive profiles with status control (`Active`, `Graduated`, `Suspended`).
* `teachers`: Core registries linked with subject specializations and constraints.
* `teacher_classes`: A robust many-to-many junction mapping teacher workloads.

### 2. 📝 Academics & Grading Matrix
* `subjects`: Contains courses mapped with unique unit coefficients (*Zarib*).
* `exams`: Tracks examination seasons (`Continuous`, `Finals`).
* `student_grades`: Safe evaluation logs with strict `CHECK` constraints to lock scores between `0.0` and `20.0`.

### 3. 📅 Operational Logs
* `attendance`: Daily tracking of student attendance patterns (`Present`, `Absent_Unjustified`, etc.).
* `student_payments`: Financial accounting Ledger for tuition fees and transaction methods.

---

## 🚀 Advanced Analytical Queries Included (`queries.sql`)

This repo doesn't just store data; it extracts intelligence. Inside `queries.sql`, you will find production-grade scripts for:

1.  **The Revenue Leaderboard:** Real-time financial ranking of student tuition deposits.
2.  **Class Performance Matrix:** Deep educational analytics breaking down class averages, highest, and lowest scores per exam.
3.  **Teacher Workload Report:** Operational HR overview tracking the total student count under each instructor.
4.  **Absenteeism Red Flag Report:** Disciplinary monitor using `GROUP_CONCAT` string aggregation to isolate problematic attendance habits.
5.  **Weighted GPA Calculator:** An advanced mathematical script syncing exam results with course coefficients to output exact student rankings.

---

## 🛠️ How To Run & Deploy

### Prerequisites
Make sure you have `SQLite3` or any modern relational DBMS client installed.

### Execution Flow
1. Clone the repository to your local machine.
2. Build the database structure:
   ```bash
   sqlite3 school_hub.db < schema.sql
Populate the tables with scalable production mock data:

Bash
sqlite3 school_hub.db < seed.sql
Run analytics to see the magic:

Bash
sqlite3 school_hub.db < queries.sql
📄 License
This architecture is completely open-source and released under the MIT License. Feel free to fork, optimize, or deploy!