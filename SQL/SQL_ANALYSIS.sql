/*
=============================================================
    JOB MARKET & AI DEMAND ANALYSIS
=============================================================

Database: my_jobs_db
Table:    job_postings

Purpose:
Analyze global job postings to identify:
- Hiring demand by company and role
- AI-related hiring demand
- AI demand across seniority levels
- Remote vs non-remote AI demand
- AI technology trends
- Geographic differences in AI hiring

Tools:
- MySQL
- SQL

=============================================================
*/



USE my_jobs_db;


/*
=============================================================
    SECTION 1 — COMPANY & ROLE ANALYSIS
=============================================================
*/


/*
-------------------------------------------------------------
Q1. For each company, which role type has the highest number
    of job postings?
-------------------------------------------------------------
*/

WITH role_counts AS (
    SELECT
        company,
        role_type,
        COUNT(*) AS total_job_postings
    FROM job_postings
    GROUP BY
        company,
        role_type
),

ranked_roles AS (
    SELECT
        company,
        role_type,
        total_job_postings,
        ROW_NUMBER() OVER (
            PARTITION BY company
            ORDER BY total_job_postings DESC
        ) AS role_rank
    FROM role_counts
)

SELECT
    company,
    role_type,
    total_job_postings
FROM ranked_roles
WHERE role_rank = 1
ORDER BY total_job_postings DESC;


/*
=============================================================
    SECTION 2 — AI DEMAND ANALYSIS
=============================================================
*/


/*
-------------------------------------------------------------
Q2. For each company, how many job postings fall into each
    AI relevance category?
-------------------------------------------------------------
*/

SELECT
    company,
    ai_relevance,
    COUNT(*) AS job_count
FROM job_postings
GROUP BY
    company,
    ai_relevance
ORDER BY
    job_count DESC;


/*
-------------------------------------------------------------
Q3. What AI relevance categories exist in the dataset?
-------------------------------------------------------------
*/

SELECT DISTINCT
    ai_relevance
FROM job_postings
ORDER BY ai_relevance;


/*
-------------------------------------------------------------
Q4. What percentage of job postings at each company are
    AI-related?

    AI-related =
    AI Required / Responsibility
    OR
    AI Preferred
-------------------------------------------------------------
*/

WITH company_ai_demand AS (
    SELECT
        company,
        COUNT(*) AS total_job_postings,

        COUNT(
            CASE
                WHEN ai_relevance IN (
                    'AI Required / Responsibility',
                    'AI Preferred'
                )
                THEN 1
            END
        ) AS ai_related_jobs

    FROM job_postings
    GROUP BY company
)

SELECT
    company,
    total_job_postings,
    ai_related_jobs,

    ROUND(
        (ai_related_jobs / total_job_postings) * 100,
        2
    ) AS ai_demand_percentage

FROM company_ai_demand
ORDER BY ai_demand_percentage DESC;


/*
-------------------------------------------------------------
Q5. Which role types have the highest AI demand?
-------------------------------------------------------------
*/

WITH role_ai_demand AS (
    SELECT
        role_type,
        COUNT(*) AS total_job_postings,

        COUNT(
            CASE
                WHEN ai_relevance IN (
                    'AI Required / Responsibility',
                    'AI Preferred'
                )
                THEN 1
            END
        ) AS ai_related_job_postings

    FROM job_postings
    GROUP BY role_type
)

SELECT
    role_type,
    total_job_postings,
    ai_related_job_postings,

    ROUND(
        (ai_related_job_postings / total_job_postings) * 100,
        2
    ) AS ai_demand_percentage

FROM role_ai_demand
ORDER BY ai_demand_percentage DESC;


/*
-------------------------------------------------------------
Q6. Which seniority levels have the highest AI demand?
-------------------------------------------------------------
*/

WITH seniority_ai_demand AS (
    SELECT
        seniority,
        COUNT(*) AS total_job_postings,

        COUNT(
            CASE
                WHEN ai_relevance IN (
                    'AI Required / Responsibility',
                    'AI Preferred'
                )
                THEN 1
            END
        ) AS ai_related_job_postings

    FROM job_postings
    GROUP BY seniority
)

SELECT
    seniority,
    total_job_postings,
    ai_related_job_postings,

    ROUND(
        (ai_related_job_postings / total_job_postings) * 100,
        2
    ) AS ai_demand_percentage

FROM seniority_ai_demand
ORDER BY ai_demand_percentage DESC;


/*
-------------------------------------------------------------
Q7. Are remote jobs more likely to be AI-related than
    non-remote jobs?
-------------------------------------------------------------
*/

WITH remote_ai_demand AS (
    SELECT
        is_remote,
        COUNT(*) AS total_job_postings,

        COUNT(
            CASE
                WHEN ai_relevance IN (
                    'AI Required / Responsibility',
                    'AI Preferred'
                )
                THEN 1
            END
        ) AS ai_related_job_postings

    FROM job_postings
    GROUP BY is_remote
)

SELECT
    is_remote,
    total_job_postings,
    ai_related_job_postings,

    ROUND(
        (ai_related_job_postings / total_job_postings) * 100,
        2
    ) AS ai_demand_percentage

FROM remote_ai_demand
ORDER BY ai_demand_percentage DESC;


/*
=============================================================
    SECTION 3 — AI TECHNOLOGY LANDSCAPE
=============================================================
*/


/*
-------------------------------------------------------------
Q8. Which AI technology/category is mentioned in the highest
    number of job postings?
    
    Note:
    A single job posting can mention multiple AI categories.
-------------------------------------------------------------
*/

SELECT
    jt.category,
    COUNT(*) AS total_job_postings

FROM job_postings

CROSS JOIN JSON_TABLE(
    CONCAT(
        '["',
        REPLACE(ai_categories, ', ', '", "'),
        '"]'
    ),
    '$[*]'
    COLUMNS (
        category VARCHAR(100) PATH '$'
    )
) AS jt

GROUP BY jt.category
ORDER BY total_job_postings DESC;


/*
-------------------------------------------------------------
Q9. Which companies have job postings mentioning the widest
    variety of AI technologies/categories?
-------------------------------------------------------------
*/

SELECT
    company,
    COUNT(DISTINCT jt.category) AS distinct_ai_categories

FROM job_postings

CROSS JOIN JSON_TABLE(
    CONCAT(
        '["',
        REPLACE(ai_categories, ', ', '", "'),
        '"]'
    ),
    '$[*]'
    COLUMNS (
        category VARCHAR(100) PATH '$'
    )
) AS jt

GROUP BY company
ORDER BY distinct_ai_categories DESC;


/*
=============================================================
    SECTION 4 — GEOGRAPHIC AI DEMAND
=============================================================
*/


/*
-------------------------------------------------------------
Q10. Which countries have the highest percentage of
     AI-related job postings?
-------------------------------------------------------------
*/

WITH country_ai_demand AS (
    SELECT
        country,
        COUNT(*) AS total_jobs,

        COUNT(
            CASE
                WHEN ai_relevance IN (
                    'AI Required / Responsibility',
                    'AI Preferred'
                )
                THEN 1
            END
        ) AS ai_related_jobs

    FROM job_postings
    GROUP BY country
)

SELECT
    country,
    total_jobs,
    ai_related_jobs,

    ROUND(
        (ai_related_jobs / total_jobs) * 100,
        2
    ) AS ai_related_jobs_percentage

FROM country_ai_demand
ORDER BY ai_related_jobs_percentage DESC;


/*
=============================================================
    SECTION 5 — AI REQUIREMENT INTENSITY
=============================================================
*/


/*
-------------------------------------------------------------
Q11. Which role types have the highest
     AI-required-to-AI-mentioned ratio?

     Ratio =
     AI Required / (AI Mention Only + AI Required)

     This measures how often AI is a requirement rather than
     simply being mentioned in the job posting.
-------------------------------------------------------------
*/

SELECT
    role_type,

    COUNT(
        CASE
            WHEN ai_relevance = 'AI Mention Only'
            THEN 1
        END
    ) AS ai_mentioned_jobs,

    COUNT(
        CASE
            WHEN ai_relevance = 'AI Required / Responsibility'
            THEN 1
        END
    ) AS ai_required_jobs,

    ROUND(
        COUNT(
            CASE
                WHEN ai_relevance = 'AI Required / Responsibility'
                THEN 1
            END
        )
        /
        NULLIF(
            COUNT(
                CASE
                    WHEN ai_relevance IN (
                        'AI Mention Only',
                        'AI Required / Responsibility'
                    )
                    THEN 1
                END
            ),
            0
        ) * 100,
        2
    ) AS ai_required_to_mentioned_ratio

FROM job_postings

GROUP BY role_type

ORDER BY ai_required_to_mentioned_ratio DESC;


/*
=============================================================
    END OF SQL ANALYSIS
=============================================================
*/