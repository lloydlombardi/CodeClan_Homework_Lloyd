/*
 * MVP Questions
 */


/*
 * Question 1a
 */
SELECT
	E.first_name,
	E.last_name,
	T."name" AS team_name
FROM 
	employees AS E 
INNER JOIN 
	teams AS T ON E.team_id = T.id;


/*
 * Question 1b
 */
SELECT
	E.first_name,
	E.last_name,
	T."name" AS team_name
FROM 
	employees AS E 
INNER JOIN 
	teams AS T ON E.team_id = T.id
WHERE E.pension_enrol IS TRUE;


/*
 * Question 1c
 */
SELECT
	E.first_name,
	E.last_name,
	T."name" AS team_name,
	T.charge_cost
FROM 
	employees AS E 
INNER JOIN 
	teams AS T ON E.team_id = T.id
WHERE 
	CAST(T.charge_cost AS integer) > 80
ORDER BY 
	charge_cost;


/*
 * Question 2a
 */
SELECT 
	E.*,
	PD.local_account_no,
	PD.local_sort_code 
FROM 
	employees AS E
LEFT JOIN 
	pay_details AS PD ON E.pay_detail_id = PD.id;


/*
 * Question 2b
 */
SELECT 
	E.*,
	PD.local_account_no,
	PD.local_sort_code,
	T."name" 
FROM 
	employees AS E
LEFT JOIN 
	pay_details AS PD ON E.pay_detail_id = PD.id
LEFT JOIN 
	teams AS T ON E.team_id  = T.id;


/*
 * Question 3a
 */
SELECT
	E.id,
	T."name" 
FROM 
	employees AS E
INNER JOIN 
	teams AS T ON E.team_id = T.id; 


/*
 * Question 3b
 */
SELECT
	T."name" AS team_name,
	count(E.id)
FROM 
	employees AS E
INNER JOIN 
	teams AS T ON E.team_id = T.id
GROUP BY 
	team_name;


/*
 * Question 3c
 */
SELECT
	T."name" AS team_name,
	count(E.id) AS team_members
FROM 
	employees AS E
INNER JOIN 
	teams AS T ON E.team_id = T.id
GROUP BY 
	team_name
ORDER BY 
	team_members;


/*
 * Question 4a
 */
SELECT
	T.id AS team_id,
	T."name" AS team_name,
	count(E.id) AS team_members
FROM 
	employees AS E
INNER JOIN 
	teams AS T ON E.team_id = T.id 
GROUP BY 
	T."name", T.id;


/*
 * Question 4b
 */
SELECT
	T.id AS team_id,
	T."name" AS team_name,
	count(E.id) AS team_members,
	CAST(T.charge_cost AS INTEGER) * count(E.id) AS total_daily_charge
FROM 
	employees AS E
INNER JOIN 
	teams AS T ON E.team_id = T.id 
GROUP BY 
	T.id
ORDER BY
	T.id;


/*
 * Question 4c
 */
SELECT
	T.id AS team_id,
	T."name" AS team_name,
	count(E.id) AS team_members,
	CAST(T.charge_cost AS INTEGER) * count(E.id) AS total_daily_charge
FROM 
	employees AS E
INNER JOIN 
	teams AS T ON E.team_id = T.id 
GROUP BY 
	T.id
HAVING 
	(CAST(T.charge_cost AS INTEGER) * count(E.id)) > 5000
ORDER BY 
	T.id;


/*
 * Extension Questions
 */


/*
 * Question 5
 */
SELECT
	DISTINCT employee_id,
	count(employee_id) AS num_of_committees
FROM 
	employees_committees 
GROUP BY employee_id ;


/*
 * Question 6
 */
SELECT
	count(E.id)
FROM 
	employees AS E
LEFT JOIN 
	employees_committees AS EC ON E.id = EC.employee_id 
WHERE committee_id IS NULL;






































