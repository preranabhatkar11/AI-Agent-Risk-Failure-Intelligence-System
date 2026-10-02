# 🤖 AI Agent Risk and Failure Intelligence System Using MySQL

**A SQL-based analytical system for analyzing AI agent executions, risk scores, token usage, execution costs, and failure events.**

---

## 📌 Project Overview

The **AI Agent Risk and Failure Intelligence System** is a MySQL-based data analysis project designed to analyze and monitor AI agent execution data.

The project uses relational database concepts and SQL techniques to analyze **execution performance, risk levels, token consumption, execution costs, failure patterns, and system-level KPIs**.

It demonstrates the practical application of SQL for transforming structured operational data into meaningful analytical insights.

---

## 🎯 Project Objectives

The main objectives of this project are to:

* Analyze AI agent execution data.
* Identify high-risk and low-risk executions.
* Analyze execution performance and token usage.
* Monitor execution-related costs.
* Analyze failure types and severity levels.
* Combine information from multiple related tables using SQL JOINs.
* Perform comparative analysis using subqueries.
* Apply window functions for ranking and row-level analysis.
* Create a KPI view for overall system-level analysis.

---

## 🗄️ Database Structure

The database consists of **four relational tables**.

| Table              | Description                             |
| ------------------ | --------------------------------------- |
| `agent_runs`       | Stores information about AI agent runs  |
| `agent_executions` | Stores execution-level information      |
| `cost_details`     | Stores execution-related token costs    |
| `failure_events`   | Stores failure information and severity |

### 1. `agent_runs`

Stores information about individual AI agent runs.

**Columns:**

* `run_id`
* `agent_name`
* `ai_model`
* `harness_type`
* `environment`

### 2. `agent_executions`

Stores execution-level information associated with agent runs.

**Columns:**

* `execution_id`
* `run_id`
* `execution_date`
* `status`
* `execution_time_sec`
* `input_tokens`
* `output_tokens`
* `risk_score`

### 3. `cost_details`

Stores token-related execution cost information.

**Columns:**

* `cost_id`
* `execution_id`
* `input_token_cost_usd`
* `output_token_cost_usd`
* `total_cost_usd`

### 4. `failure_events`

Stores information about failures associated with executions.

**Columns:**

* `failure_id`
* `execution_id`
* `failure_type`
* `severity`
* `failure_description`

---

## 🔗 Database Relationships

The tables are connected using primary and foreign key relationships.

```text
agent_runs
     │
     │ run_id
     ▼
agent_executions
     │
     ├──────────────► cost_details
     │
     └──────────────► failure_events
```

The relationship flow is:

```text
agent_runs → agent_executions → cost_details
                         │
                         └──────→ failure_events
```

---

## 🛠️ Technologies Used

* **MySQL**
* **MySQL Workbench**
* **SQL**

---

## 📚 SQL Concepts Applied

This project demonstrates the following SQL concepts:

* Aggregate Functions
* `COUNT()`
* `SUM()`
* `AVG()`
* `MIN()`
* `MAX()`
* `GROUP BY`
* `HAVING`
* `ORDER BY`
* Subqueries
* `INNER JOIN`
* `LEFT JOIN`
* `RIGHT JOIN`
* Views
* `RANK()`
* `DENSE_RANK()`
* `ROW_NUMBER()`
* `PARTITION BY`
* `CASE` Statements

---

## 📊 SQL Analysis

The project contains **30 SQL analysis queries** covering multiple SQL concepts.

### 🔹 Aggregate Function Analysis

Aggregate functions are used to analyze execution and failure data, including:

* Total execution records
* Average execution metrics
* Highest and lowest risk scores
* Failure frequency
* Group-based analysis
* Conditional grouped results using `HAVING`

### 🔹 Subquery Analysis

Subqueries are used for comparative analysis, such as identifying executions whose risk scores are above the overall average.

### 🔹 JOIN Analysis

JOIN queries combine information from related tables to analyze:

* Executions and failures
* Executions and costs
* Risk scores and failure information
* Execution status and failure events

### 🔹 KPI View

A KPI view named `ai_agent_kpis` provides a high-level summary of the system.

The KPI view includes:

* **Total Runs**
* **Total Executions**
* **Average Risk Score**
* **Maximum Risk Score**
* **Total Cost**
* **Total Failures**

Example:

```sql
SELECT * FROM ai_agent_kpis;
```

### 🔹 Window Function Analysis

Window functions are used for ranking and row-level analysis.

The project demonstrates:

```text
RANK()
DENSE_RANK()
ROW_NUMBER()
```

along with:

```text
PARTITION BY
ORDER BY
```

### 🔹 CASE Statement Analysis

`CASE` statements are used to categorize numerical risk scores into meaningful categories:

* **High Risk**
* **Medium Risk**
* **Low Risk**

---

## 📈 Key Analytical Areas

| Analysis Area         | Purpose                                    |
| --------------------- | ------------------------------------------ |
| Execution Performance | Analyze execution time and status          |
| Risk Analysis         | Identify and categorize execution risk     |
| Token Usage           | Analyze input and output token consumption |
| Cost Analysis         | Monitor execution-related costs            |
| Failure Analysis      | Analyze failure types and severity         |
| Ranking Analysis      | Rank executions based on risk scores       |
| KPI Analysis          | Generate system-level performance metrics  |

---

## 📸 Project Screenshots

The following screenshots demonstrate selected SQL queries and their outputs from **MySQL Workbench**.

### 1. High-Risk Executions with Failures

Identifies high-risk executions that experienced failures.

---

### 2. Executions Above Average Risk Score

Uses a subquery to identify executions with risk scores above the overall average.

---

### 3. AI Agent KPI Summary

Displays the overall KPI summary generated using the `ai_agent_kpis` view.

---

### 4. Risk Ranking Using Window Functions

Uses the `RANK()` window function to rank executions according to their risk scores.

---

### 5. Risk Categorization Using CASE

Categorizes executions into High Risk, Medium Risk, and Low Risk using a `CASE` statement.

---

## 📁 Project Structure

```text
AI-Agent-Risk-Failure-Intelligence-System/
│
├── README.md
│
├── AI_Agent_Risk_Failure_Intelligence_System.sql
│
└── screenshots/
    │
    ├── risk_failure_analysis.png
    ├── subquery_risk_analysis.png
    ├── kpi_view.png
    ├── window_risk_ranking.png
    └── risk_categorization.png
```

---

## 🚀 How to Run the Project

### Step 1: Open MySQL Workbench

Open **MySQL Workbench** and create a new SQL tab.

### Step 2: Open the SQL File

Open:

```text
AI_Agent_Risk_Failure_Intelligence_System.sql
```

### Step 3: Create and Select the Database

Run:

```sql
CREATE DATABASE AI_Agent_Risk_Failure_Intelligence_System;

USE AI_Agent_Risk_Failure_Intelligence_System;
```

### Step 4: Create the Tables

Execute the table creation queries for:

```text
agent_runs
agent_executions
cost_details
failure_events
```

### Step 5: Load the Data

Execute the INSERT statements included in the SQL file to populate the tables.

### Step 6: Execute the Analysis Queries

Run the numbered SQL queries to perform the required analysis of:

* Execution performance
* Risk scores
* Token usage
* Costs
* Failures
* Rankings
* KPIs

### Step 7: View the KPI Summary

Run:

```sql
SELECT * FROM ai_agent_kpis;
```

---

## 💡 Project Purpose

This project demonstrates the practical use of **MySQL and SQL for analytical problem-solving**.

It combines:

* Database design
* Relational data analysis
* Aggregate functions
* Subqueries
* JOINs
* Window functions
* CASE statements
* Risk categorization
* Token and cost analysis
* Failure analysis
* KPI generation

The project provides hands-on experience in using SQL to analyze structured operational data and derive meaningful insights.

---

## 👩‍💻 Author

**Prerana Bhatkar**

**M.Sc. Data Science**

---

## ⭐ Skills Demonstrated

**SQL** • **MySQL** • **MySQL Workbench** • **Database Management** • **Data Analysis** • **Aggregate Functions** • **Subqueries** • **JOINs** • **Window Functions** • **CASE Statements** • **KPI Analysis**

---

## 📌 Project Highlights

* **30 SQL Analysis Queries**
* **4 Relational Tables**
* **Aggregate Functions**
* **Subqueries**
* **INNER / LEFT / RIGHT JOINs**
* **Window Functions**
* **CASE Statements**
* **KPI View**
* **Risk & Failure Analysis**
* **Token & Cost Analysis**

---

⭐ **Thank you for visiting this project!**
