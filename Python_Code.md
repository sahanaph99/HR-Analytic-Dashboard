
## HR Analytics Dashboard 

This document walks through every cell of `HR Analytic Dashboard.ipynb`, explaining what each block of code does and why. Run the cells in Colab or Jupyter Notebook in the order shown below.

---

## Cell 1 — Load and verify the data

```python
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

df = pd.read_csv('Data.csv')
print(df.shape)
print(df['Attrition'].value_counts())
```

**What it does:** Imports the three libraries needed — pandas for data handling, matplotlib for basic plotting, seaborn for nicer statistical charts. Loads the CSV into a dataframe called `df` and prints its shape and how many employees fall into each attrition category.

**Why:** This is always the first step — confirm the file loaded correctly before doing anything else. If `df.shape` doesn't show `(1470, 32)`, something is wrong with the file itself, not the code.

**Expected output:**
```
(1470, 32)
No     1233
Yes     237
```

---

## Cell 2 — Create helper columns

```python
df['AttritionNum'] = (df['Attrition'] == 'Yes').astype(int)
df['SatisfactionScore'] = (df['JobSatisfaction'] + df['EnvironmentSatisfaction'] +
                            df['RelationshipSatisfaction'] + df['WorkLifeBalance']) / 4
df['AgeBucket'] = pd.cut(df['Age'], bins=[17,25,35,45,60], labels=['18-25','26-35','36-45','46+'])
```

**What it does:**
- Line 1: `df['Attrition'] == 'Yes'` checks every row and returns True/False. `.astype(int)` converts that to 1/0, stored as a new column `AttritionNum`.
- Line 2: Adds four satisfaction-related columns together and divides by 4 to get one average score per employee.
- Line 3: `pd.cut()` slices the continuous `Age` column into 4 buckets based on the `bins` given. Anyone aged 18-25 gets labeled `'18-25'`, and so on.

**Why:** Text values like "Yes"/"No" can't be averaged or summed — converting to 1/0 lets `.mean()` return a percentage directly later. The satisfaction score combines four separate 1-4 ratings into one more reliable number. Age buckets let attrition be compared across life-stage groups instead of 43 individual ages.

---

## Cell 3 — Print key KPIs

```python
total = len(df)
left = df['AttritionNum'].sum()
print(f"Total Employees: {total}")
print(f"Attrition Rate: {round(left/total*100,1)}%")
print(f"Avg Income: ${df['MonthlyIncome'].mean():,.0f}")
print(f"Avg Satisfaction: {df['SatisfactionScore'].mean():.2f}")
```

**What it does:** `len(df)` counts total rows. `df['AttritionNum'].sum()` adds up all the 1s, giving the count of employees who left. The rest are formatted print statements — `,.0f` adds comma separators with no decimals, `.2f` shows exactly 2 decimal places.

**Why:** These four numbers are the headline KPIs — the same ones shown on the Power BI dashboard cards. Printing them here confirms the dashboard numbers match the raw data analysis.

**Expected output:**
```
Total Employees: 1470
Attrition Rate: 16.1%
Avg Income: $6,503
Avg Satisfaction: 2.73
```

---

## Cell 4 — Attrition by Department (chart)

```python
dept = df.groupby('Department')['AttritionNum'].mean().mul(100).sort_values()

plt.figure(figsize=(8,5))
colors = ['#E24B4A' if v>16 else '#378ADD' for v in dept.values]
plt.barh(dept.index, dept.values, color=colors)
for i, v in enumerate(dept.values):
    plt.text(v+0.3, i, f'{v:.1f}%', va='center')
plt.title('Attrition Rate by Department')
plt.xlabel('Attrition Rate (%)')
plt.tight_layout()
plt.show()
```

**What it does:**
- `groupby('Department')` splits the dataframe into separate groups, one per department.
- `['AttritionNum'].mean()` calculates the average of the 0/1 column within each group — since it's 0s and 1s, the average is literally the attrition rate as a decimal (e.g. 0.206).
- `.mul(100)` converts that decimal to a percentage (20.6).
- `.sort_values()` orders departments from lowest to highest attrition.
- The `colors` line loops through every department's value and picks red if attrition is above 16% (company average), blue otherwise.
- `plt.barh()` draws a horizontal bar chart; the `for` loop adds percentage labels next to each bar.
- `plt.tight_layout()` prevents labels from being cut off at the edges.

**Why:** `groupby().mean()` is the single most useful pandas pattern in this project — the same structure repeats for every other "rate by category" chart. The conditional coloring instantly flags problem departments without requiring the viewer to read numbers.

---

## Cell 5 — Attrition by Job Role (chart)

```python
jr = df.groupby('JobRole')['AttritionNum'].mean().mul(100).sort_values()

plt.figure(figsize=(8,5))
colors = ['#E24B4A' if v>20 else '#FFA500' if v>10 else '#378ADD' for v in jr.values]
plt.barh(jr.index, jr.values, color=colors)
plt.title('Attrition Rate by Job Role')
plt.xlabel('Attrition Rate (%)')
plt.tight_layout()
plt.show()
```

**What it does:** Identical logic to Cell 4, grouped by `JobRole` instead of `Department`, with a 3-tier color scale (red above 20%, orange 10-20%, blue below 10%).

**Why:** Job role is more granular than department, and this is where the strongest finding in the project lives — Sales Representative shows roughly 39.8% attrition, the highest bar in the whole analysis.

---

## Cell 6 — Overtime vs Attrition (chart)

```python
ot = df.groupby('OverTime')['AttritionNum'].mean().mul(100)

plt.figure(figsize=(6,5))
bars = plt.bar(ot.index, ot.values, color=['#1D9E75','#E24B4A'])
for bar, val in zip(bars, ot.values):
    plt.text(bar.get_x()+bar.get_width()/2, val+0.5, f'{val:.1f}%', ha='center', fontweight='bold')
plt.title('Overtime vs Attrition Rate')
plt.ylabel('Attrition Rate (%)')
plt.tight_layout()
plt.show()
```

**What it does:** Same `groupby().mean()` pattern, but only two categories (Yes/No for overtime), so no sorting is needed. `plt.bar()` draws vertical columns. The `zip(bars, ot.values)` loop pairs each bar object with its value so the percentage label sits centered above each bar (`bar.get_x()+bar.get_width()/2` finds the horizontal center).

**Why:** Produces the second-strongest finding in the project — employees working overtime leave at roughly 3x the rate of those who don't.

---

## Cell 7 — Salary Distribution (histogram)

```python
plt.figure(figsize=(10,5))
df[df['Attrition']=='No']['MonthlyIncome'].hist(bins=30, alpha=0.6, color='#1D9E75', label='Stayed', density=True)
df[df['Attrition']=='Yes']['MonthlyIncome'].hist(bins=30, alpha=0.6, color='#E24B4A', label='Left', density=True)
plt.axvline(df[df['Attrition']=='No']['MonthlyIncome'].mean(), color='#1D9E75', linestyle='--')
plt.axvline(df[df['Attrition']=='Yes']['MonthlyIncome'].mean(), color='#E24B4A', linestyle='--')
plt.legend()
plt.title('Salary Distribution: Stayed vs Left')
plt.xlabel('Monthly Income ($)')
plt.tight_layout()
plt.show()
```

**What it does:** `df[df['Attrition']=='No']` filters the dataframe down to only rows where Attrition equals "No" — boolean filtering, a core pandas technique. `.hist()` draws a histogram of `MonthlyIncome` for that filtered subset. `bins=30` controls how many bars the histogram splits into. `alpha=0.6` makes both histograms semi-transparent so they overlap visibly. `density=True` normalizes both to the same scale — necessary because there are 1,233 "stayed" rows but only 237 "left" rows, and without normalizing, the "left" histogram would look artificially tiny just from having fewer rows. `plt.axvline()` draws a vertical dashed line at the mean of each group.

**Why:** A histogram shows the full shape of the distribution, not just the average — revealing whether leavers cluster at low salaries or are more spread out.

---

## Cell 8 — Correlation Heatmap

```python
numeric_cols = ['Age','MonthlyIncome','JobSatisfaction','EnvironmentSatisfaction',
                 'WorkLifeBalance','YearsAtCompany','YearsSinceLastPromotion',
                 'AttritionNum','SatisfactionScore']
plt.figure(figsize=(10,8))
sns.heatmap(df[numeric_cols].corr(), annot=True, fmt='.2f', cmap='RdYlGn', center=0)
plt.title('Correlation Heatmap')
plt.tight_layout()
plt.show()
```

**What it does:** `df[numeric_cols]` selects only the listed columns. `.corr()` calculates the correlation coefficient between every pair of those columns, producing a grid of values between -1 and +1. `sns.heatmap()` draws that grid as a colored table; `annot=True` prints the actual number inside each cell. `cmap='RdYlGn'` sets red-yellow-green as the color scale, and `center=0` keeps 0 correlation at the yellow midpoint, with negative trending red and positive trending green.

**Why:** Instead of building a separate chart for every possible pair of variables, this single chart scans all of them at once. The `AttritionNum` row is the one to focus on — any strongly negative number there (red) means that variable tends to be lower when someone leaves. `MonthlyIncome` and `YearsAtCompany` typically show the strongest negative correlation with attrition.

**Caveat:** correlation shows relationship, not cause — avoid claiming low salary "causes" attrition, only that they move together.

---

## Cell 9 — Find high-risk employees

```python
high_risk = df[
    (df['Attrition']=='No') &
    (df['OverTime']=='Yes') &
    (df['JobSatisfaction']<=2) &
    (df['YearsSinceLastPromotion']>=3)
][['EmployeeNumber','Department','JobRole','MonthlyIncome','JobSatisfaction']]

print(f"High risk employees: {len(high_risk)}")
print(high_risk.head(10))
high_risk.to_csv('high_risk_employees.csv', index=False)
```

**What it does:** Combines four filter conditions with `&` (AND) — every condition must be true for a row to be included. Filters for employees still at the company (`Attrition=='No'`), currently working overtime, reporting low job satisfaction (2 or below out of 4), and not promoted in 3+ years. The `[[...]]` selects only specific columns to display rather than all 32. `.head(10)` shows the first 10 results. `.to_csv()` saves the full list to a new file.

**Why:** This is the most actionable output in the whole project. Every condition was already proven to correlate with attrition in the earlier charts, so anyone meeting all four is a strong signal rather than a guess — turning the analysis from "here's what happened" into "here's who to talk to today."

---

## Cell 10 — Optional: Predict attrition

```python
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LogisticRegression
from sklearn.preprocessing import LabelEncoder

df_model = df.copy()
le = LabelEncoder()
df_model['OverTime_enc'] = le.fit_transform(df_model['OverTime'])

X = df_model[['Age','MonthlyIncome','JobSatisfaction','YearsAtCompany','OverTime_enc']]
y = df_model['AttritionNum']

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
model = LogisticRegression(max_iter=1000)
model.fit(X_train, y_train)
print(f"Accuracy: {model.score(X_test, y_test):.2%}")
```

**What it does:**
- `df.copy()` makes a separate copy so the main dataframe isn't accidentally modified.
- `LabelEncoder()` converts text categories into numbers — `OverTime` has values "Yes"/"No", and the model needs numbers, so this turns them into 1/0.
- `X` is the set of input features used to predict. `y` is the target — whether the employee left.
- `train_test_split` splits the data into a training set (80%) and a test set (20%) the model never sees during training. `random_state=42` makes the split reproducible.
- `LogisticRegression()` creates the model. `.fit()` trains it. `.score()` checks accuracy on the unseen test data.

**Why:** This goes one step beyond "here's what correlates with attrition" to "here's a model that estimates the probability any individual employee will leave." Logistic regression is chosen here over more complex models because it's easy to explain and the dataset is small — an explainable model is more valuable in a portfolio project than a complex one that can't be talked through confidently.

**Important caveat:** only about 16% of employees actually leave, so a model that always predicts "stays" would already be roughly 84% accurate without learning anything. Mention this when quoting the accuracy number — it demonstrates an understanding of the limitation.

