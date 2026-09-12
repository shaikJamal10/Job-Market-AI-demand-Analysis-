# Project Methodology

## 1. Data Collection

Job postings were collected using Python-based web scraping from publicly accessible company job board APIs.

The project uses the Greenhouse Job Board API to collect publicly available job posting information from selected companies.

The final dataset contains **1,751 job postings** across **10 companies**.

---

## 2. Data Preparation

The collected job posting data was cleaned and standardized before analysis.

Key preparation steps included:

- Standardizing company and location information
- Extracting country information from job locations
- Identifying remote and non-remote opportunities
- Extracting publication and update dates
- Calculating description and title length
- Removing unnecessary fields
- Standardizing job titles
- Preparing fields for SQL and Power BI analysis

---

## 3. Role Classification

Job titles were classified into broader job-function categories to make cross-company analysis easier.

Examples of role categories include:

- Engineering / Technology
- Sales / Business Development
- Product
- AI / Data Science
- Data / Analytics
- Security
- Finance / Accounting
- Marketing
- Operations
- Customer Support / Success
- HR / Recruiting
- Legal / Compliance
- Design
- IT / Infrastructure
- Professional Services / Solutions

---

## 4. Seniority Classification

Job titles were also classified into seniority levels based on title keywords.

The categories include:

- Entry/Junior
- Mid
- Senior
- Lead
- Manager
- Director
- VP/Executive

---

## 5. AI Relevance Classification

Job descriptions and job titles were analyzed for AI-related terminology.

The classification separates postings into:

- **No AI Mention**
- **AI Mention Only**
- **AI Preferred**
- **AI Required / Responsibility**

This allows the analysis to distinguish between jobs that simply mention AI and jobs where AI is a preferred or required skill.

---

## 6. AI Technology Categorization

AI-related postings were further categorized into specific AI technology areas.

Categories include:

- Artificial Intelligence
- Machine Learning
- LLM
- Generative AI
- AI Agents
- Foundation Models
- Prompt Engineering
- Deep Learning
- NLP
- Reinforcement Learning
- Computer Vision
- Transformer Models

A single job posting can belong to multiple AI categories.

---

## 7. SQL Analysis

The cleaned dataset was imported into MySQL for structured analysis.

SQL was used to investigate:

- Job posting volume by company
- Job functions by volume
- AI demand by company
- AI demand by job function
- AI demand by seniority
- Remote vs non-remote AI demand
- AI technology frequency
- Geographic AI demand
- AI-required vs AI-mentioned jobs

Advanced SQL techniques such as window functions and `JSON_TABLE()` were also used.

---

## 8. Power BI Analysis

Power BI was used to transform the SQL dataset into an interactive dashboard.

The dashboard analyzes:

- Overall job market size
- AI-related job demand
- Company-level hiring patterns
- Job-function demand
- Seniority patterns
- Remote opportunities
- AI technology landscape
- AI demand across different job functions

Interactive slicers allow users to explore the data by:

- Year
- Country
- Company
- Role Type

---

## 9. Key Objective

The primary objective of this project is to understand **how AI is influencing the current job market**.

The analysis focuses not only on the number of AI-related jobs, but also on **where AI skills are being demanded, which job functions are most affected, and which AI technologies appear most frequently in job postings**.