CREATE DATABASE IF NOT EXISTS supply_chain;
USE supply_chain;

CREATE TABLE IF NOT EXISTS supply_chain_data (
  `Product type`                VARCHAR(100),
  `SKU`                         VARCHAR(100),
  `Price`                       DECIMAL(12,2),
  `Availability`                INT,
  `Number of products sold`     INT,
  `Revenue generated`           DECIMAL(14,2),
  `Customer demographics`       VARCHAR(255),
  `Stock levels`                INT,
  `Lead times`                  INT,
  `Order quantities`            INT,
  `Shipping times`              INT,
  `Shipping carriers`           VARCHAR(100),
  `Shipping costs`              DECIMAL(12,2),
  `Supplier name`               VARCHAR(100),
  `Location`                    VARCHAR(100),
  `Lead time`                   INT,
  `Production volumes`          INT,
  `Manufacturing lead time`     INT,
  `Manufacturing costs`         DECIMAL(12,2),
  `Inspection results`          VARCHAR(50),
  `Defect rates`                DECIMAL(6,3),
  `Transportation modes`        VARCHAR(50),
  `Routes`                      VARCHAR(50),
  `Costs`                       DECIMAL(12,2)
);

ALTER TABLE supply_chain_data
  ADD COLUMN env_score INT NULL,
  ADD COLUMN soc_score INT NULL,
  ADD COLUMN gov_score INT NULL,
  ADD COLUMN esg_score INT NULL;
SET SQL_SAFE_UPDATES = 0;
UPDATE supply_chain_data
SET env_score = 40 + (CRC32(`Supplier name`) % 56),
    soc_score = 40 + (CRC32(CONCAT(`Supplier name`, 'S')) % 56),
    gov_score = 40 + (CRC32(CONCAT(`Supplier name`, 'G')) % 56);

UPDATE supply_chain_data
SET esg_score = ROUND((env_score + soc_score + gov_score) / 3);
 
SELECT 
    `Supplier name`, 
    env_score, 
    soc_score, 
    gov_score, 
    esg_score
FROM supply_chain_data
GROUP BY `Supplier name`, env_score, soc_score, gov_score, esg_score
ORDER BY `Supplier name`;

UPDATE supply_chain_data sc
JOIN (
    SELECT 
        `Supplier name`, 
        ROUND((AVG(env_score) + AVG(soc_score) + AVG(gov_score)) / 3) AS avg_esg
    FROM supply_chain_data
    GROUP BY `Supplier name`
) t
ON sc.`Supplier name` = t.`Supplier name`
SET sc.esg_score = t.avg_esg;
ALTER TABLE supply_chain_data
DROP COLUMN `Supplier lead time`;
SELECT * FROM supply_chain_data LIMIT 10;

#OPERATIONAL ANALYSIS- Supplier Summary
USE supply_chain;

CREATE OR REPLACE VIEW supplier_summary AS
SELECT 
  `Supplier name`                        AS supplier,
  COUNT(*)                                AS orders,
  ROUND(AVG(`Lead times`),2)              AS avg_lead_days,
  ROUND(AVG(`Shipping times`),2)          AS avg_ship_days,
  ROUND(AVG(`Defect rates`),3)            AS avg_defect_rate,
  ROUND(AVG(`Shipping costs`),2)          AS avg_ship_cost,
  ROUND(AVG(`Costs`),2)                   AS avg_total_cost,
  SUM(`Revenue generated`)                AS revenue,
  ROUND(AVG(env_score),0)                 AS env_score,
  ROUND(AVG(soc_score),0)                 AS soc_score,
  ROUND(AVG(gov_score),0)                 AS gov_score,
  ROUND(AVG(esg_score),0)                 AS esg_score
FROM supply_chain_data
GROUP BY `Supplier name`;

#OPERATIONAL ANALYSIS- Supplier Risk Summary
SET @DEFECT_HIGH := 0.08;   -- 8%
SET @DEFECT_MED  := 0.05;   -- 5%
SET @LEAD_HIGH   := 20;     -- days
SET @LEAD_MED    := 12;     -- days
SET @ESG_LOW     := 55;     -- 0–100
SET @ESG_MED     := 65;     -- 0–100

SELECT
  MIN(avg_defect_rate) AS min_defect, MAX(avg_defect_rate) AS max_defect,
  MIN(avg_lead_days)   AS min_lead,   MAX(avg_lead_days)   AS max_lead,
  MIN(esg_score)       AS min_esg,    MAX(esg_score)       AS max_esg
FROM supplier_summary;
CREATE OR REPLACE VIEW supplier_risk_summary AS
SELECT
  *,
  CASE
    WHEN (avg_defect_rate >= 2.60 AND avg_lead_days >= 16.8) OR esg_score < 58 THEN 'High'
    WHEN (avg_defect_rate BETWEEN 2.30 AND 2.60)
      OR (avg_lead_days BETWEEN 15.5 AND 16.8)
      OR (esg_score BETWEEN 58 AND 66)
    THEN 'Medium'
    ELSE 'Low'
  END AS risk_level
FROM supplier_summary;

SELECT * 
FROM supplier_risk_summary
ORDER BY (risk_level='High') DESC, esg_score ASC, avg_defect_rate DESC;

#RISK LEVEL BREAKDOWN BY ORDERS AND SUMMARY
SELECT 
    risk_level,
    COUNT(DISTINCT supplier) AS supplier_count,
    SUM(orders) AS total_orders,
    ROUND(SUM(revenue), 2) AS total_revenue
FROM supplier_risk_summary
GROUP BY risk_level
ORDER BY FIELD(risk_level, 'High', 'Medium', 'Low');

#ESG SCORE VS DEFECT RATE CORRELATION TABLE
SELECT 
    supplier,
    esg_score,
    avg_defect_rate,
    ROUND((esg_score / avg_defect_rate), 2) AS esg_to_defect_ratio
FROM supplier_risk_summary
ORDER BY esg_to_defect_ratio DESC;

#SHIPPING EFFICIENCY BY RISK LEVEL
SELECT 
    risk_level,
    ROUND(AVG(avg_ship_days), 2) AS avg_shipping_days,
    ROUND(AVG(avg_ship_cost), 2) AS avg_shipping_cost
FROM supplier_risk_summary
GROUP BY risk_level;

#IDENTIFY HIDDEN RISKS
SELECT *
FROM supplier_risk_summary
WHERE esg_score >= 60
  AND avg_defect_rate > 2.0
  AND avg_lead_days > 15;
  
  
 
 SELECT * FROM supplier_risk_summary;
 
 CREATE TABLE IF NOT EXISTS ai_recommendations (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  supplier VARCHAR(100),
  risk_level VARCHAR(10),
  revenue DECIMAL(14,2),
  avg_defect_rate DECIMAL(6,3),
  avg_lead_days DECIMAL(6,2),
  esg_score INT,
  trigger_summary VARCHAR(255),
  recommendation TEXT,
  confidence INT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);