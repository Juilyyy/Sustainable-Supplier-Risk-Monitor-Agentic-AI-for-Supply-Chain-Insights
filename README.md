# Sustainable Supplier Risk Monitor

## 📌 Project Overview
The **Sustainable Supplier Risk Monitor** is an end-to-end analytics project designed to evaluate and monitor supplier performance through both operational and sustainability metrics.  
The solution combines **AWS-hosted MySQL databases**, **SQL-based aggregations**, **Agentic AI for intelligent recommendations**, and **a Google Looker Studio dashboard** for interactive insights.

The system identifies high-risk suppliers based on defect rates, lead times, and ESG (Environmental, Social, and Governance) scores, providing actionable recommendations for mitigating supply chain risks.

---

## 📊 Features
- **Data Integration:**  
  - Source dataset from [Kaggle: Supply Chain Analysis](https://www.kaggle.com/datasets/harshsingh2209/supply-chain-analysis?resource=download)  
  - Extended with SQL-derived supplier summary and risk classification tables
  - AI-generated recommendations via Agentic AI
- **Risk Scoring:**
  - Classifies suppliers into `Low`, `Medium`, and `High` risk
  - Incorporates ESG score thresholds for sustainable decision-making
- **Interactive Dashboard:**
  - Built in **Google Looker Studio**
  - Includes KPIs, trend charts, ESG vs. Defect Rate correlations, and route/mode analysis
- **AI Recommendations:**
  - Uses `qwen2.5:0.5b-instruct` via Ollama for local inference
  - Strict JSON output contract for easy integration with BI tools

---

## 🖥️ Dashboard
**[[https://lookerstudio.google.com/s/iOkI2e-PEbU]]**

---

## 🧠 Agentic AI Component
- **Model:** `qwen2.5:0.5b-instruct` (via Ollama, runs locally)
- **Purpose:** Generate supplier-specific recommendations based on risk, defect rate, lead time, ESG score, revenue share, and transport route/mode hints
- **Output:** Strict JSON with:
  - `trigger_summary`
  - `recommendation`
  - `confidence` (0–100)
- **Fallback:** Rule-based engine if JSON parsing fails

---

## 🗄️ AWS Setup
- **AWS S3:** Storage for raw CSV uploads
- **AWS RDS (MySQL):**  
  - Stores the supplier datasets and computed views
  - Hosts tables such as:
    - `supplier_summary`
    - `supplier_risk_summary`
    - `ai_recommendations`
- **SQL Examples:**
  - Risk classification using CASE conditions
  - Joins for combining operational metrics with ESG data

---




