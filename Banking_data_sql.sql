-- create database banking_case;
use banking_case;
select * from customer limit 10;

-- Q: Total Clients
-- select count(*) as Total_count from customer;

-- Question: What is the distribution of customers by gender(Male= 1, Female=2)?
-- SELECT gender_id, COUNT(*) AS count
-- FROM customer
-- GROUP BY gender_id;

-- Question: What is the age distribution of customers?
-- SELECT age, COUNT(*) AS count
-- FROM customer
-- GROUP BY age
-- ORDER BY count Desc;

-- Question: What is the average income of customers?
-- select Avg(estimated_income) as 
-- AvgIncome FROM customer;

-- Question: What is the total loan and total deposit amount?
-- SELECT 
--     SUM(bank_loans) AS total_loans,
--     SUM(bank_deposits) AS total_deposits
-- FROM customer;

-- Question: Which customers have high loans but low deposits?
-- SELECT client_id, estimated_income, bank_loans, bank_deposits
-- FROM customer
-- WHERE bank_loans > bank_deposits
-- ORDER BY bank_loans DESC;

-- Question: Count of Customers with more than 1 credit cards
-- SELECT COUNT(*) AS amount_of_credit_cards
-- FROM customer
-- WHERE amount_of_credit_cards >=2;

-- Question: What is the average credit card balance?
-- SELECT AVG(credit_card_balance) AS 
-- avg_cc_balance

-- Question: Segment customers by income level
-- SELECT 
--     CASE 
--         WHEN estimated_income < 60000 THEN 'Low Income'
--         WHEN estimated_income BETWEEN 60000 AND 120000 THEN 'Medium Income'
--         ELSE 'High Income'
--     END AS income_group,
--     COUNT(*) AS customer_count
-- FROM customer
-- GROUP BY income_group;

-- Question: Customer distribution by loyalty classification
-- SELECT loyalty_classification, COUNT(*) AS count
-- FROM customer
-- GROUP BY loyalty_classification;

-- Question: What is the distribution of customers by risk weighting?
-- SELECT risk_weighting, COUNT(*) AS customer_count
-- FROM customer
-- GROUP BY risk_weighting
-- ORDER BY risk_weighting DESC;

-- Question: Which customers are high risk?
-- SELECT client_id, estimated_income, bank_loans, bank_deposits, risk_weighting
-- FROM customer
-- WHERE risk_weighting >=4
-- ORDER BY risk_weighting DESC;

-- Question: Is there a relationship between income and risk?
-- SELECT 
--     CASE 
--         WHEN estimated_income < 60000 THEN 'Low Income'
--         WHEN estimated_income BETWEEN 60000 AND 120000 THEN 'Medium Income'
--         ELSE 'High Income'
--     END AS income_group,
--     AVG(risk_weighting) AS avg_risk
-- FROM customer
-- GROUP BY income_group;

-- Q: Customers with high loans, low income, and high risk
-- SELECT client_id, estimated_income, bank_loans, risk_weighting
-- FROM customer
-- WHERE estimated_income < 80000
--   AND bank_loans > 300000
--   AND risk_weighting > 2
-- ORDER BY risk_weighting DESC;

-- Q: Customers with strong financial position(Low Risk)
-- SELECT client_id, estimated_income, bank_deposits, risk_weighting
-- FROM customer
-- WHERE estimated_income > 80000
--   AND bank_deposits > bank_loans
--   AND risk_weighting <= 3;
