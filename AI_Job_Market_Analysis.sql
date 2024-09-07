--Top five jobs with the highest pay and the location
SELECT job_title, 
       location, 
	required_skills,
       MAX(salary_usd) AS max_salary
FROM Job_Analysis
GROUP BY job_title, location, required_skills
ORDER BY max_salary DESC
	limit 5;

--IMPACT OF REMOTE JOBS YES /NO
SELECT 
    remote_friendly, 
    COUNT(*) AS job_openings
FROM Job_Analysis
GROUP BY remote_friendly
order by job_openings desc;

--Analysis of Remote Job Percentages Across Job Titles
SELECT 
    job_title,
    (COUNT(CASE WHEN remote_friendly = 'Yes' THEN 1 END) * 100.0 / NULLIF(COUNT(*), 0)) AS remote_percentage
from Job_analysis
GROUP BY job_title
ORDER BY remote_percentage DESC;

--Comprehensive Job Market Analysis
SELECT industry,
       COUNT(*) AS total_jobs,
       MIN(salary_usd) AS min_salary,
       MAX(salary_usd) AS max_salary,
       AVG(salary_usd) AS average_salary,
       COUNT(CASE WHEN remote_friendly = 'Yes' THEN 1 END) * 100.0 / COUNT(*) AS remote_percentage
FROM Job_Analysis
GROUP BY industry
ORDER BY average_salary DESC;

-- Average Salary by Automation Risk and Job Growth Projection
SELECT
    Automation_Risk,
    Job_Growth_Projection,
    AVG(Salary_USD) AS average_salary
FROM Job_Analysis
GROUP BY Automation_Risk, Job_Growth_Projection
ORDER BY Automation_Risk, average_salary DESC;

--Top-Paying Location for Each Job Title
WITH RankedSalaries AS (
    SELECT
        job_title,
        location,
        salary_usd,
        RANK() OVER (PARTITION BY job_title ORDER BY salary_usd DESC) AS rank
    FROM Job_Analysis
)
SELECT
    job_title,
    location,
    salary_usd
FROM RankedSalaries
WHERE rank = 1
ORDER BY salary_usd desc;

--Compare Salary Ranges by AI Adoption Level
SELECT 
    AI_Adoption_Level,
    MIN(Salary_USD) AS Min_Salary,
    MAX(Salary_USD) AS Max_Salary,
    AVG(Salary_USD) AS Avg_Salary
FROM 
    Job_Analysis
WHERE 
    Salary_USD IS NOT NULL
GROUP BY 
    AI_Adoption_Level
ORDER BY 
    Avg_Salary DESC;

