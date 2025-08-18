use DdlCheckpoint

ALTER TABLE EMPLOYEE ADD CONSTRAINT Fk_Num_S FOREIGN KEY (Department_Num_S) REFERENCES DEPARTMENT(Num_S)
ALTER TABLE PROJECT ADD CONSTRAINT Fk_Num_S_Project FOREIGN KEY (Department_Num_S) REFERENCES DEPARTMENT(Num_S)
ALTER TABLE Employee_Project ADD CONSTRAINT Fk_Num_E FOREIGN KEY (Employee_Num_E) REFERENCES EMPLOYEE(Num_E)
ALTER TABLE Employee_Project ADD CONSTRAINT Fk_Num_P FOREIGN KEY (Project_Num_P) REFERENCES PROJECT(Num_P)

INSERT INTO DEPARTMENT VALUES
(1,'IT','Alice Johnson'),
(2,'HR','Bob Smith'),
(3,'Marketing','Clara Bennett')

INSERT INTO EMPLOYEE VALUES
(101,'John Doe','Developer',60000.00, 1),
(102,'Jane Smith', 'Analyst', 55000.00, 2),
(103, 'Mike Brown', 'Designer', 50000.00, 3),
(104, 'Sarah Johnson', 'Data Scientist', 70000.00, 1),
(105, 'Emma Wilson', 'HR Specialist', 52000.00, 2)

INSERT INTO PROJECT VALUES
(201, 'Website Redesign', '2024-01-15', '2024-06-30', 1),
(202, 'Employee Onboarding', '2024-03-01', '2024-09-01', 2),
(203, 'Market Research', '2024-02-01', '2024-07-31', 3),
(204, 'IT Infrastructure Setup', '2024-04-01', '2024-12-31', 1)

INSERT INTO Employee_Project VALUES 
(101, 201, 'Frontend Developer'),
(104, 201, 'Backend Developer'),
(102, 202, 'Trainer'),
(105, 202, 'Coordinator'),
(103, 203, 'Research Lead'),
(101, 204, 'Network Specialist')

UPDATE Employee_Project 
SET Employee_Role = 'Full Stack Developer'
WHERE Employee_Num_E = 101

SELECT * FROM EMPLOYEE

DELETE FROM Employee_Project
WHERE Employee_Num_E = 103

DELETE FROM Employee
WHERE Num_E = 103

