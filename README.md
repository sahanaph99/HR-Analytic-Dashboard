# HR Analytics Dashboard

A complete HR analytics project analyzing employee attrition, salary trends, satisfaction, and retention risk using SQL, Python, and Power BI — built on the IBM HR Analytics Employee Attrition dataset (1,470 employees).

![Dashboard Preview](HR%20Analytics%20Dashboard%20Overview.jpeg)

## Business Problem

Employee attrition is one of the most expensive problems an organization can face — replacing an employee typically costs 50-200% of their annual salary. This project analyzes 1,470 employee records to answer:

- Which departments and roles have the highest attrition?
- What factors most strongly predict an employee leaving?
- Which currently active employees are at the highest risk of leaving next?

## Key Findings

| Metric | Value |
|---|---|
| Total Employees | 1,470 |
| Overall Attrition Rate | 16.1% |
| Average Monthly Income | $6,503 |
| Average Satisfaction Score | 2.73 / 4.0 |

**1. Overtime is the strongest attrition driver.** Employees working overtime leave at 30.5% versus 10.4% for those who don't — nearly 3x higher.

**2. Sales Representatives are the highest-risk role.** This role has a 39.8% attrition rate, far above the company average and the highest of any job role in the dataset.

**3. Pay gap between leavers and stayers is significant.** Employees who left earned $4,787/month on average, compared to $6,833/month for those who stayed — a gap of over $2,000/month.

**4. Single employees leave at more than double the rate of divorced employees** (25.5% vs 10.1%), suggesting engagement programs should focus on early-career, unmarried employees.

**5. Most attrition happens early.** Employees who left had an average tenure of 5.1 years versus 7.4 years for those who stayed — retention efforts should focus on the first 2-3 years.

## Tools Used

- **SQL** — data aggregation and KPI calculations
- **Python** (Pandas, Matplotlib, Seaborn, scikit-learn) — exploratory analysis, correlation analysis, and a basic attrition prediction model
- **Power BI** — interactive two-page dashboard with KPI cards, charts, and slicers

## Dashboard

The Power BI dashboard has two pages:

**Overview** — KPI cards (Total Employees, Attrition Rate, Attrition Count, Active Employees, Avg Income, Avg Satisfaction), attrition by department, age group, marital status, overtime, salary comparison, and gender distribution, with interactive filters for Department, Gender, Job Role, OverTime, and Age Group.

**Deep Analysis** — Attrition by job role, a job role vs. satisfaction matrix, education field analysis, and written business insights.

![Deep Analysis Page](HR%20Analytics%20Dashboard%20Deepanalysis.jpeg)

## Repository Structure

```
HR-Analytic-Dashboard/
├── Data.csv
├── HR Analytic Dashboard.ipynb
├── HR Analytic Dashboard.pbix
├── HR Analytics Dashboard Overview.jpeg
├── HR Analytics Dashboard Deepanalysis.jpeg
├── HR_Analytics_Presentation.pptx
├── SQL Queries For Hr Analytic dashboard.sql
└── README.md
```

## How to Use

1. Clone or download this repository
2. Open `HR Analytic Dashboard.pbix` in Power BI Desktop to explore the interactive dashboard
3. Run `SQL Queries For Hr Analytic dashboard.sql` against the dataset in any SQL environment to reproduce the KPI calculations
4. Open `HR Analytic Dashboard.ipynb` in Jupyter Notebook or Google Colab to reproduce the charts and the attrition prediction model
5. View `HR_Analytics_Presentation.pptx` for a slide-deck summary of the findings

## Dataset Source

[IBM HR Analytics Employee Attrition & Performance](https://www.kaggle.com/datasets/pavansubhasht/ibm-hr-analytics-attrition-dataset) — 1,470 employee records, 35 original columns (3 constant columns removed during cleaning).

## Author

Built as a portfolio project to demonstrate data cleaning, SQL analysis, Python visualization, and Power BI dashboard design skills.
