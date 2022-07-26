/*
 * MVP Questions
*/

/*
 * Q1
*/
SELECT *
FROM employees 
WHERE department = 'Human Resources';


/*
 * Q2
*/
SELECT 
	first_name,
	last_name,
	country
FROM employees 
WHERE department = 'Legal';


/*
 * Q3
*/
SELECT 
	count(*) AS employees_in_portugal
FROM employees 
WHERE country = 'Portugal';


/*
 * Q4
*/
SELECT 
	count(*) AS employees_in_portugal_or_spain
FROM employees 
WHERE country IN ('Portugal', 'Spain');


/*
 * Q5
*/
SELECT 
	count(*) AS null_values
FROM pay_details
WHERE local_account_no IS NULL;


/*
 * Q6
*/
SELECT *
FROM pay_details 
WHERE (local_account_no IS NULL) AND (iban IS NULL);


/*
 * Q7
*/
SELECT
	first_name,
	last_name
FROM employees 
ORDER BY last_name ASC NULLS LAST;


/*
 * Q8
*/
SELECT
	first_name,
	last_name,
	country 
FROM employees 
ORDER BY
	country ASC NULLS LAST,
	last_name ASC NULLS LAST;


/*
 * Q9
*/
SELECT *
FROM employees 
ORDER BY salary DESC NULLS LAST 
LIMIT 10;


/*
 * Q10
*/
SELECT 
	first_name,
	last_name,
	salary
FROM employees 
WHERE country = 'Hungary'
ORDER BY salary ASC NULLS LAST 
LIMIT 1;


/*
 * Q11
*/
SELECT 
	count(*) AS f_first_name
FROM employees 
WHERE first_name LIKE 'F%';


/*
 * Q12
*/
SELECT *
FROM employees 
WHERE email LIKE '%yahoo%';


/*
 * Q13
*/
SELECT 
	count(*) AS pension_employees
FROM employees 
WHERE (pension_enrol = TRUE) AND (country NOT IN ('France', 'Germany'))


/*
 * Q14
*/
SELECT 
	salary
FROM employees 
WHERE (department = 'Engineering') AND (fte_hours = 1)
ORDER BY salary DESC NULLS LAST 
LIMIT 1;


/*
 * Q15
*/
SELECT 
	first_name,
	last_name,
	fte_hours,
	salary, 
	fte_hours * salary AS effective_yearly_salary
FROM employees;


/*
 * Extension Questions
 */


/*
 * Q1
 */
SELECT 
	first_name,
	last_name,
	department,
	concat(first_name, ' ', last_name, ' - ', department) AS badge_label 
FROM employees
WHERE (first_name IS NOT NULL) AND (last_name IS NOT NULL) AND (department IS NOT NULL);


/*
 * Q2
 */
SELECT
	start_date,
	first_name,
	last_name,
	department,
	concat(first_name, ' ', last_name, ' - ', department, ' (joined ', EXTRACT(YEAR FROM start_date), ')') AS badge_label
FROM employees
WHERE (first_name IS NOT NULL) AND (last_name IS NOT NULL) AND (department IS NOT NULL) AND (start_date IS NOT NULL);


/*
 * Q2 Ext
 */
SELECT
	start_date,
	first_name,
	last_name,
	department,
	concat(first_name, ' ', last_name, ' - ', department, ' (joined ', EXTRACT(MONTH FROM start_date), ' ', EXTRACT(YEAR FROM start_date), ')') AS badge_label
FROM employees
WHERE (first_name IS NOT NULL) AND (last_name IS NOT NULL) AND (department IS NOT NULL) AND (start_date IS NOT NULL);


SELECT
	start_date,
	first_name,
	last_name,
	department,
	concat(first_name, ' ', last_name, ' - ', department, ' (joined ', TO_CHAR(start_date, 'Month'), ' ', EXTRACT(YEAR FROM start_date), ')') AS badge_label
FROM employees
WHERE (first_name IS NOT NULL) AND (last_name IS NOT NULL) AND (department IS NOT NULL) AND (start_date IS NOT NULL);


/*
 * Q3
 */
SELECT 
	first_name,
	last_name,
	salary,
	CASE
		WHEN salary <  40000 THEN 'low'
		WHEN salary >= 40000 THEN 'high'
	END salary_class
FROM employees 
WHERE salary IS NOT NULL;
	















