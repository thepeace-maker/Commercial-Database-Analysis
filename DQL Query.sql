use DdlCheckpoint;

-- 1. Write a query to retrieve the names of employees who are assigned to more than one project,
--including the total number of projects for each employee.


SELECT employee_name, COUNT(num_p) AS total_projects
FROM EMPLOYEE 
left join PROJECT on EMPLOYEE.Department_Num_S=PROJECT.Department_Num_S 
GROUP BY employee_name 
HAVING COUNT(Num_P) > 1;


-- 2. Write a query to retrieve the list of projects managed by each department, 
--including the department label and manager’s name.


SELECT d.department_label, d.Manager_Name, p.Project_Title as Projects_managed
FROM  PROJECT p
INNER JOIN DEPARTMENT d ON p.Department_Num_S = d.Num_S;

-- 3. Write a query to retrieve the names of employees working on the project "Website Redesign,"
--including their roles in the project.

SELECT  e.Employee_Name, ep.Employee_Role
FROM  EMPLOYEE e
INNER JOIN PROJECT p ON e.Department_Num_S = p.Department_Num_S
INNER JOIN Employee_Project ep ON e.Num_E = ep.Employee_Num_E
WHERE p.Project_Title = 'Website Redesign';


-- 4. Write a query to retrieve the department with the highest number of employees,
--including the department label, manager name, and the total number of employees.

SELECT TOP 1 d.department_label, d.Manager_Name, COUNT(e.Num_E) AS total_employees
FROM  DEPARTMENT d
INNER JOIN EMPLOYEE e ON d.Num_S = e.Department_Num_S
GROUP BY  d.Department_Label, d.Manager_Name
ORDER BY  total_employees DESC;

-- 5. Write a query to retrieve the names and positions of employees earning a salary greater than 60,000, 
--including their department names.

SELECT e.Employee_Name, e.Position, d.Department_Label
FROM EMPLOYEE e
INNER JOIN DEPARTMENT d on e.Department_Num_S = d.Num_S
WHERE Salary > 60000;


-- 6. Write a query to retrieve the number of employees assigned to each project, 
--including the project title.

select p.Project_Title, count(num_e) as Total_employees
from EMPLOYEE e
left join PROJECT p on e.Department_Num_S = p.Department_Num_S
group by p.Project_Title;


-- 7. Write a query to retrieve a summary of roles employees have across different projects, 
--including the employee name, project title, and role.

SELECT e.Employee_Name, p.Project_Title, ep.Employee_Role
FROM  Employee_Project ep
INNER JOIN EMPLOYEE e ON ep.Employee_Num_E = e.Num_E
INNER JOIN  PROJECT p ON ep.Project_Num_P = p.Num_P
ORDER BY  e.employee_name, p.Project_Title;


-- 8. Write a query to retrieve the total salary expenditure for each department, 
--including the department label and manager name.

SELECT  d.Department_Label, d.Manager_Name, SUM(e.Salary) AS Total_Salary_Expenditure
FROM DEPARTMENT d
JOIN EMPLOYEE e ON d.Num_S = e.Department_Num_S
GROUP BY  d.department_label, d.Manager_Name;

