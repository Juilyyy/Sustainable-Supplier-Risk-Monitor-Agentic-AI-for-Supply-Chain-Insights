Sustainable Supplier Risk Monitor (Agentic AI + ESG)
One-line pitch: Cloud-backed supply chain analytics with ESG integration and an Agentic AI that generates supplier-specific, prescriptive recommendations.

Overview
This project analyzes supply chain performance while factoring in ESG (Environmental, Social, and Governance) scores to evaluate supplier sustainability. Using MySQL for backend data processing, Google Looker Studio for interactive visualizations, and a free Hugging Face LLM for AI-powered recommendations, the system delivers both quantitative metrics and qualitative insights for decision-making.

Tech Stack
Database: MySQL (local or AWS RDS)

AI Model: HuggingFaceH4/zephyr-7b-beta (local inference, free to use)

Visualization: Google Looker Studio

Languages: SQL, Python

Data Source: Kaggle – Supply Chain Analysis

Workflow
1. Data Preparation
Original dataset imported from Kaggle into MySQL

Created views:

supplier_summary – aggregated defect rates, lead times, ESG scores

supplier_risk_summary – assigned High/Medium/Low risk levels based on thresholds

Exported processed CSVs for visualization

2. AI Recommendations
For each supplier, metrics were passed into a structured prompt for HuggingFaceH4/zephyr-7b-beta:

“You are an expert supply chain analyst. Given this supplier’s performance and ESG profile, suggest actionable steps to reduce risk and improve sustainability while maintaining cost efficiency.”

Model output stored in ai_recommendations_<date>.csv

Recommendations integrated into the dashboard alongside metrics

3. Visualization
Data blended in Looker Studio to allow cross-filtering across datasets

KPIs, correlation tables, efficiency charts, and AI recommendations combined into one interactive view

Dashboard Features
(Live dashboard link here — replace with your own)

Best ESG Score Supplier (KPI)

Lowest Risk Supplier (KPI)

ESG vs Defect Rate (Correlation Table)

Shipping Efficiency by Risk Level (Bar Chart)

Product Type Distribution (Donut Chart)

Performance Over Time (Time Series)

AI Recommendation Cards for each supplier

Model Prompting & Workflow
SQL Aggregation: Extracted supplier performance metrics from MySQL views

Prompt Context: Merged ESG, operational, and delivery performance

LLM Processing: Ran locally using HuggingFaceH4/zephyr-7b-beta

Recommendation Output: Short, prioritized suggestions per supplier

Dashboard Integration: Combined structured data with AI text output

Future Work
Convert Looker Studio dashboard to real-time refresh via cloud integration

Expand AI to multi-scenario simulations (cost vs. ESG trade-offs)

Explore Tableau Public as alternative (limited features compared to Looker Studio)

License
MIT © 2025 [Juily Pachundkar]
