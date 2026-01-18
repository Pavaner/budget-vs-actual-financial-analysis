DROP DATABASE IF EXISTS finance_analysis;

CREATE DATABASE finance_analysis;
USE finance_analysis;

CREATE TABLE budget_vs_actual (
    transaction_date DATE,
    department VARCHAR(50),
    category VARCHAR(50),
    region VARCHAR(30),
    budget_amount DECIMAL(12,2),
    actual_amount DECIMAL(12,2),
    payment_mode VARCHAR(30),
    transaction_id VARCHAR(50)
);
SELECT COUNT(*) FROM budget_vs_actual;
SELECT * FROM budget_vs_actual LIMIT 10;
SELECT *
FROM budget_vs_actual
WHERE
    transaction_date IS NULL OR
    department IS NULL OR
    category IS NULL OR
    region IS NULL OR
    budget_amount IS NULL OR
    actual_amount IS NULL;

SELECT transaction_id, COUNT(*)
FROM budget_vs_actual
GROUP BY transaction_id
HAVING COUNT(*) > 1;

-- Create variance column

ALTER TABLE budget_vs_actual
ADD variance DECIMAL(12,2);

UPDATE budget_vs_actual
SET variance = actual_amount - budget_amount;

SELECT
    budget_amount,
    actual_amount,
    variance
FROM budget_vs_actual
LIMIT 10;

SET SQL_SAFE_UPDATES = 0;


-- Overspending analysis
SELECT
    department,
    category,
    region,
    budget_amount,
    actual_amount,
    variance
FROM budget_vs_actual
WHERE variance > 0
ORDER BY variance DESC;


-- Department performance summary
SELECT
    department,
    SUM(budget_amount) AS total_budget,
    SUM(actual_amount) AS total_actual,
    SUM(variance) AS total_variance
FROM budget_vs_actual
GROUP BY department
ORDER BY total_variance DESC;

-- Category-level cost analysis
SELECT
    category,
    SUM(actual_amount) AS total_spend,
    SUM(budget_amount) AS total_budget,
    SUM(variance) AS variance
FROM budget_vs_actual
GROUP BY category
ORDER BY variance DESC;

 -- Regional financial performance

SELECT
    region,
    SUM(budget_amount) AS budget,
    SUM(actual_amount) AS actual,
    SUM(variance) AS variance
FROM budget_vs_actual
GROUP BY region
ORDER BY variance DESC;
 













