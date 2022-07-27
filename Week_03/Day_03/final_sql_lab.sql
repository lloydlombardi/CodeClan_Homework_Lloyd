/*
 * Final SQL Lab and Homework
*/

/*
 * MVP Questions 
*/

/*
 * Question 1 
*/

SELECT
	count(id)
FROM 
	employees
WHERE
	salary IS NULL AND 
	grade IS NULL;


/*
 * Question 2 
*/
SELECT 
	first_name,
	last_name,
	department
FROM 
	employees 
ORDER BY 
	department, 
	last_name ;


/*
 * Question 3 
*/
SELECT *
FROM 
	employees 
WHERE
	last_name LIKE  'A%'
ORDER BY 
	salary DESC NULLS LAST 
LIMIT 10;



/*
 * Question 4 
*/
SELECT
	department,
	count(id) AS employee_per_dept
FROM 
	employees 
WHERE 
	start_date BETWEEN '2003-01-01' AND '2003-12-31'
GROUP BY 
	department;



/*
 * Question 5 
*/
SELECT
	department,
	fte_hours,
	count(id) AS employees_per_fte
FROM 
	employees 
GROUP BY 
	department,
	fte_hours 
ORDER BY 
	department,
	fte_hours;


/*
 * Question 6 
*/
SELECT 
	count(id) AS pension_count,
	pension_enrol 
FROM 
	employees 
GROUP BY 
	pension_enrol
ORDER BY 
	pension_enrol;

/*
 * Question 7
 */
SELECT 
	*
FROM 
	employees 
WHERE 
	department = 'Accounting' AND 
	pension_enrol IS FALSE
ORDER BY
	salary DESC NULLS LAST
LIMIT 1;



/*
 * Question 8
 */
SELECT
	country,
	count(id) AS employees_per_country,
	ROUND(avg(salary), 2) AS avg_country_salary
FROM 
	employees
GROUP BY 
	country 
HAVING 
	count(id) > 30;



/*
 * Question 9 
 */
SELECT
	first_name,
	last_name, 
	fte_hours,
	salary,
	salary * fte_hours AS effective_yearly_salary
FROM 
	employees
WHERE 
	salary * fte_hours > 30000;


/*
 * Question 10
 */
SELECT
	* 
FROM 
	employees AS e 
INNER JOIN 
	teams AS t ON e.team_id = t.id 
WHERE 
	t."name" = 'Data Team 1' OR 
	t."name" = 'Data Team 2';


/*
 * Question 11
 */
SELECT 
	e.first_name,
	e.last_name
FROM 
	employees AS e
LEFT JOIN 
	pay_details AS p_d ON e.pay_detail_id = p_d.id
WHERE
	p_d.local_tax_code IS NULL;



/*
 * Question 12
 */
SELECT
	e.first_name ,
	e.last_name ,
	(48 * 35 * CAST(t.charge_cost AS NUMERIC) - e.salary) * e.fte_hours AS expected_profit
FROM 
	employees AS e
LEFT JOIN 
	teams AS t ON e.team_id = t.id;



/*
 * Question 13
 */
SELECT
	first_name,
	last_name,
	salary,
	country,
	fte_hours  
FROM employees 
WHERE 
	country = 'Japan' AND 
	fte_hours = (
	SELECT
		fte_hours 
	FROM 
		employees
	GROUP BY 
		fte_hours
	ORDER BY
		count(id)
	LIMIT 1)
ORDER BY salary;
		


/*
 * Question 14
 */
SELECT 
	department,
	count(id) AS num_null_name
FROM 
	employees
WHERE 
	first_name IS  NULL 
GROUP BY 
	department
HAVING 
	count(id) >= 2
ORDER BY 
	num_null_name DESC, department ;


/*
 * Quesiton 15
 */
SELECT
	first_name,
	count(id) AS shared_first_name
FROM 
	employees 
WHERE 
	first_name IS NOT NULL 
GROUP BY 
	first_name
HAVING
	count(id) > 1
ORDER BY 
	shared_first_name DESC, first_name;


/*
 * Question 16
 */

-- CTE solution
WITH dep_count AS (
	SELECT
		department,
		count(id) AS emp_count_dep
	FROM 
		employees
	GROUP BY 
		department),
	grade_count AS (
	SELECT
		department,
		count(id) AS emp_count_grade
	FROM
		employees
	WHERE 
		grade = 1
	GROUP BY 
		department)
SELECT 
	e.department,
	(CAST(gr.emp_count_grade AS REAL)) / (CAST(dep.emp_count_dep AS REAL)) AS proportion
FROM
	employees AS e
INNER JOIN 
	dep_count AS dep
	ON e.department = dep.department
INNER JOIN
	grade_count AS gr 
	ON e.department = gr.department
GROUP BY
	e.department, gr.emp_count_grade, dep.emp_count_dep 
ORDER BY 
	e.department ;


-- Neil's solution
SELECT 	department,
		round(sum(CAST((grade = 1) AS int))/CAST(count(id) AS real)*100) AS proportion_grade_ones
		FROM employees 
GROUP BY department
ORDER BY 
	department;



/*
 * Extension Questions
 */


/*
 * Question 1
 */

WITH dep_salary AS (
	SELECT
		department,
		avg(salary) AS dep_avg_salary
	FROM 
		employees
	GROUP BY 
		department),
	dep_fte AS (
	SELECT
		department,
		avg(fte_hours) AS dep_avg_fte
	FROM 
		employees 
	GROUP BY 
		department),
	dep_count AS (
	SELECT
		department,
		count(id)
	FROM 
		employees 
	GROUP BY 
		department
	ORDER BY
		count (id) DESC
	LIMIT 1)
SELECT
	e.first_name ,
	e.last_name ,
	e.department ,
	e.salary ,
	e.fte_hours ,
	ROUND(e.salary / d_s.dep_avg_salary, 2) AS salary_ratio,
	ROUND(e.fte_hours / d_f.dep_avg_fte, 2) AS fte_ratio
FROM 
	employees AS e
INNER JOIN 
	dep_salary AS d_s 
	ON e.department  = d_s.department
INNER JOIN 
	dep_fte AS d_f 
	ON e.department = d_f.department
INNER JOIN 
	dep_count AS d_c 
	ON e.department = d_c.department;


/*
 * Question 1 Extensions
 */
WITH dep_salary AS (
	SELECT
		department,
		avg(salary) AS dep_avg_salary
	FROM 
		employees
	GROUP BY 
		department),
	dep_fte AS (
	SELECT
		department,
		avg(fte_hours) AS dep_avg_fte
	FROM 
		employees 
	GROUP BY 
		department),
	dep_count AS (
	SELECT
		department,
		count(id)
	FROM 
		employees 
	GROUP BY 
		department
	ORDER BY
		count (id) DESC
	FETCH FIRST 6 ROWS WITH TIES)
SELECT
	e.first_name ,
	e.last_name ,
	e.department ,
	e.salary ,
	e.fte_hours ,
	ROUND(e.salary / d_s.dep_avg_salary, 2) AS salary_ratio,
	ROUND(e.fte_hours / d_f.dep_avg_fte, 2) AS fte_ratio
FROM 
	employees AS e
INNER JOIN 
	dep_salary AS d_s 
	ON e.department  = d_s.department
INNER JOIN 
	dep_fte AS d_f 
	ON e.department = d_f.department
INNER JOIN 
	dep_count AS d_c 
	ON e.department = d_c.department;


/*
 * Question 2
 */
SELECT 
	count(id) AS pension_count,
	COALESCE ((CAST(pension_enrol AS varchar)), 'uknown')
FROM 
	employees 
GROUP BY 
	pension_enrol
ORDER BY 
	pension_enrol;	














