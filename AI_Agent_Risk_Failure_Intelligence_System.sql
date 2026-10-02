CREATE DATABASE AI_Agent_Risk_Failure_Intelligence_System;

USE AI_Agent_Risk_Failure_Intelligence_System;
SELECT DATABASE();

# CREATE AGENT_RUNS TABLE
CREATE TABLE agent_runs (
    run_id INT PRIMARY KEY,
    agent_name VARCHAR(100),
    ai_model VARCHAR(50),
    harness_type VARCHAR(50),
    environment VARCHAR(50)
);

# CREATE AGENT_EXECUTIONS TABLE

CREATE TABLE agent_executions (
    execution_id INT PRIMARY KEY,
    run_id INT,
    execution_date DATE,
    status VARCHAR(30),
    execution_time_sec DECIMAL(10,2),
    input_tokens INT,
    output_tokens INT,
    risk_score DECIMAL(5,2),

    FOREIGN KEY (run_id)
        REFERENCES agent_runs(run_id)
);

# CREATE COST_DETAILS TABLE

CREATE TABLE cost_details (
    cost_id INT PRIMARY KEY,
    execution_id INT,
    input_token_cost_usd DECIMAL(10,5),
    output_token_cost_usd DECIMAL(10,5),
    total_cost_usd DECIMAL(10,5),

    FOREIGN KEY (execution_id)
        REFERENCES agent_executions(execution_id)
);

# CREATE FAILURE_EVENTS TABLE

CREATE TABLE failure_events (
    failure_id INT PRIMARY KEY,
    execution_id INT,
    failure_type VARCHAR(100),
    severity VARCHAR(30),
    failure_description VARCHAR(255),

    FOREIGN KEY (execution_id)
        REFERENCES agent_executions(execution_id)
);

# CHECK WHETHER ALL TABLES WERE CREATED
SHOW TABLES;

# Check agent_runs data
SELECT * FROM agent_runs;

# Count number of records
SELECT COUNT(*) AS total_runs
FROM agent_runs;

# Check agent_executions data
SELECT * FROM agent_executions;

# Count number of records
SELECT COUNT(*) AS total_executions
FROM agent_executions;

# Check cost_details data
SELECT * FROM cost_details;

# Count number of records
SELECT COUNT(*) AS total_cost_records
FROM cost_details;

# Check failure_events data
SELECT * FROM failure_events;

# Count number of records
SELECT COUNT(*) AS total_failure_events
FROM failure_events;

# AGGREGATE FUNCTIONS
# 1. Find the average execution time.

SELECT AVG(execution_time_sec) AS average_execution_time
FROM agent_executions;

# 2.Find the highest risk score

SELECT MAX(risk_score) AS highest_risk_score
FROM agent_executions;

# 3.Find the total execution cost

SELECT SUM(total_cost_usd) AS total_execution_cost
FROM cost_details;

# Clauses
# 4.Find executions with a risk score greater than 70.
SELECT execution_id,
       risk_score,
       status
FROM agent_executions
WHERE risk_score > 70;

# 5.Display executions from highest to lowest risk score.

SELECT execution_id,
       risk_score,
       status
FROM agent_executions
ORDER BY risk_score DESC;

# 6.Which are the top 3 execution statuses with the highest number of executions?

SELECT status,
       COUNT(*) AS total_executions
FROM agent_executions
GROUP BY status
ORDER BY total_executions DESC
LIMIT 3;

# SUBQUERIES
# 7.Executions above average risk score
SELECT execution_id,
       run_id,
       status,
       risk_score
FROM agent_executions
WHERE risk_score > (
    SELECT AVG(risk_score)
    FROM agent_executions
)
ORDER BY risk_score DESC;

# 8.Find executions that have a failure event
SELECT execution_id,
       status,
       risk_score
FROM agent_executions
WHERE execution_id IN (
    SELECT execution_id
    FROM failure_events
)
ORDER BY risk_score DESC;

# 9.Most expensive execution
SELECT execution_id,
       total_cost_usd
FROM cost_details
WHERE total_cost_usd = (
    SELECT MAX(total_cost_usd)
    FROM cost_details
);

# 10.Executions taking longer than average.

SELECT execution_id,
       execution_time_sec,
       status
FROM agent_executions
WHERE execution_time_sec > (
    SELECT AVG(execution_time_sec)
    FROM agent_executions
)
ORDER BY execution_time_sec DESC;

#.11 Find executions that have NO failure event

SELECT execution_id,
       status,
       risk_score
FROM agent_executions
WHERE execution_id NOT IN (
    SELECT execution_id
    FROM failure_events
)
ORDER BY risk_score DESC;

# 12.Find runs using the most frequently used AI model

SELECT run_id,
       agent_name,
       ai_model
FROM agent_runs
WHERE ai_model = (
    SELECT ai_model
    FROM agent_runs
    GROUP BY ai_model
    ORDER BY COUNT(*) DESC
    LIMIT 1
);

# 13.Find agent runs in the most commonly used environment

SELECT run_id,
       agent_name,
       environment
FROM agent_runs
WHERE environment = (
    SELECT environment
    FROM agent_runs
    GROUP BY environment
    ORDER BY COUNT(*) DESC
    LIMIT 1
);

# 14.Find the execution with the highest risk score

SELECT execution_id,
       risk_score,
       status
FROM agent_executions
WHERE risk_score = (
    SELECT MAX(risk_score)
    FROM agent_executions
);

# 15.Find executions where the output token cost is higher than the average output token cost

SELECT execution_id,
       output_token_cost_usd
FROM cost_details
WHERE output_token_cost_usd > (
    SELECT AVG(output_token_cost_usd)
    FROM cost_details
)
ORDER BY output_token_cost_usd DESC;

# 16.Find failure types occurring more frequently than average

SELECT failure_type,
       COUNT(*) AS total_failures
FROM failure_events
GROUP BY failure_type
HAVING COUNT(*) > (
    SELECT AVG(failure_count)
    FROM (
        SELECT COUNT(*) AS failure_count
        FROM failure_events
        GROUP BY failure_type
    ) AS failure_summary
)
ORDER BY total_failures DESC;

# 17.Find executions that experienced Critical failures

SELECT execution_id,
       failure_type,
       severity
FROM failure_events
WHERE execution_id IN (
    SELECT execution_id
    FROM failure_events
    WHERE severity = 'Critical'
);

# Joins Query
# 18.Which AI agent performed each execution, and what was the risk score of that execution?

SELECT ar.agent_name,
       ae.execution_id,
       ae.risk_score
FROM agent_runs ar
JOIN agent_executions ae
ON ar.run_id = ae.run_id;

# 19. What is the risk score and total cost of each execution, including executions that have no cost details?

SELECT ae.execution_id,
       ae.risk_score,
       cd.total_cost_usd
FROM agent_executions ae
LEFT JOIN cost_details cd
ON ae.execution_id = cd.execution_id;

# 20. Which failures occurred and what was their execution status?

SELECT ae.execution_id,
       ae.status,
       fe.failure_type
FROM agent_executions ae
RIGHT JOIN failure_events fe
ON ae.execution_id = fe.execution_id
ORDER BY ae.status;

# 21. Which AI agent experienced which type of failure and what was its severity?

SELECT ar.agent_name,
       ae.execution_id,
       fe.failure_type,
       fe.severity
FROM agent_runs ar
JOIN agent_executions ae
ON ar.run_id = ae.run_id
JOIN failure_events fe
ON ae.execution_id = fe.execution_id;


# 22.Find high-risk executions that experienced failures

SELECT ae.execution_id,
       ae.risk_score,
       fe.failure_type,
       fe.severity
FROM agent_executions ae
JOIN failure_events fe
ON ae.execution_id = fe.execution_id
WHERE ae.risk_score >= 70
ORDER BY ae.risk_score DESC;

#23. Show agent name with execution status
SELECT ar.agent_name,
       ae.execution_id,
       ae.status
FROM agent_runs ar
JOIN agent_executions ae
ON ar.run_id = ae.run_id;

# 24. KPI View
CREATE OR REPLACE VIEW ai_agent_kpis AS
SELECT
    (SELECT COUNT(*) FROM agent_runs) AS total_runs,
    (SELECT COUNT(*) FROM agent_executions) AS total_executions,
    (SELECT ROUND(AVG(risk_score), 2) FROM agent_executions) AS avg_risk_score,
    (SELECT MAX(risk_score) FROM agent_executions) AS max_risk_score,
    (SELECT ROUND(SUM(total_cost_usd), 4) FROM cost_details) AS total_cost,
    (SELECT COUNT(*) FROM failure_events) AS total_failures;

SELECT * FROM ai_agent_kpis;

# WINDOW FUNCTIONS
# 25.Rank executions based on risk score

SELECT execution_id,
       risk_score,
       RANK() OVER (ORDER BY risk_score DESC) AS risk_rank
FROM agent_executions;

# 26. Rank executions based on execution time

SELECT execution_id,
       execution_time_sec,
       DENSE_RANK() OVER (ORDER BY execution_time_sec DESC) AS time_rank
FROM agent_executions;

# 27. Number the failure records within each severity level.

SELECT failure_id,
       failure_type,
       severity,
       ROW_NUMBER() OVER (
           PARTITION BY severity
           ORDER BY failure_id
       ) AS severity_row_number
FROM failure_events;

# 28.Rank failures based on severity
SELECT failure_id,
       failure_type,
       severity,
       ROW_NUMBER() OVER (
           ORDER BY 
               CASE severity
                   WHEN 'Critical' THEN 1
                   WHEN 'High' THEN 2
                   WHEN 'Medium' THEN 3
                   WHEN 'Low' THEN 4
               END
       ) AS severity_rank
FROM failure_events;

# CASE
# 29.Categorize executions based on risk score
SELECT execution_id,
       risk_score,
       CASE
           WHEN risk_score >= 70 THEN 'High Risk'
           WHEN risk_score >= 40 THEN 'Medium Risk'
           ELSE 'Low Risk'
       END AS risk_category
FROM agent_executions;

#30.Categorize failures based on severity
SELECT failure_id,
       failure_type,
       severity,
       CASE
           WHEN severity = 'Critical' THEN 'Immediate Attention'
           WHEN severity = 'High' THEN 'High Priority'
           WHEN severity = 'Medium' THEN 'Monitor'
           ELSE 'Low Priority'
       END AS action_required
FROM failure_events;

