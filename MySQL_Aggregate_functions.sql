use employees;

SELECT 
    COUNT(DISTINCT dept_no)
FROM
    dept_emp;

SELECT 
    SUM(salary)
FROM
    salaries
WHERE
    from_date > '1997-01-01';
    
SELECT 
    MIN(emp_no)
FROM
    employees;

SELECT 
    MAX(emp_no)
FROM
    employees;
    
SELECT 
    ROUND(AVG(salary),2)
FROM
    salaries
WHERE
    from_date > '1997-01-01';

SELECT 
    *
FROM
    departments;
    
CREATE TABLE departments_dup (
    dept_no CHAR(4) NOT NULL,
    dept_name VARCHAR(40) NOT NULL
);

SELECT 
    *
FROM
    departments_dup;

insert into departments_dup(dept_no, dept_name) 
select * from departments;

SELECT 
    dept_no,
    dept_name,
    COALESCE(dept_no, dept_name) AS dept_info
FROM
    departments_dup
ORDER BY dept_no ASC;

SELECT
    IFNULL(dept_no, 'N/A') as dept_no,
    IFNULL(dept_name,
            'Department name not provided') AS dept_name,
    COALESCE(dept_no, dept_name) AS dept_info
FROM
    departments_dup
ORDER BY dept_no ASC; 

insert into departments_dup values ('d011','Public Relations');
select * from departments_dup;

DROP TABLE IF EXISTS departments_dup;
delete from departments_dup where dept_no = 'd002';

CREATE TABLE departments_dup (
  dept_no char(4) NULL,
  dept_name varchar(40) NULL
  );
CREATE TABLE dept_manager_dup (
  emp_no int(11) NOT NULL,
  dept_no char(4) NULL,
  from_date date NOT NULL,
  to_date date NULL
  );
INSERT INTO departments_dup
select * from departments;


INSERT INTO dept_manager_dup (emp_no, from_date)
VALUES(999904, '2017-01-01'),
	(999905, '2017-01-01'),
	(999906, '2017-01-01'),
	(999907, '2017-01-01');

DELETE FROM dept_manager_dup
WHERE
    dept_no = 'd001';
INSERT INTO departments_dup (dept_name) VALUES ('Public Relations');
INSERT INTO departments_dup (dept_no) VALUES ('d010');
DELETE FROM departments_dup
WHERE
    dept_no = 'd002';

DELETE FROM departments_dup
WHERE
    dept_no = 'd011';

select * from dept_manager_dup;
select * from departments_dup;

SELECT 
    m.dept_no, m.emp_no, d.dept_name
FROM
    dept_manager_dup m
        INNER JOIN
    departments_dup d ON m.dept_no = d.dept_no
GROUP BY m.emp_no
ORDER BY m.dept_no;

SELECT 
    e.emp_no, e.first_name, e.last_name, dm.dept_no, e.hire_date
FROM
    employees e
        INNER JOIN
    dept_manager dm ON e.emp_no = dm.emp_no
ORDER BY e.emp_no;

insert into dept_manager_dup values ('110228', 'd003', '1992-03-21','9999-01-01');
insert into departments_dup values ('d009','Customer Service');

select * from dept_manager_dup order by dept_no asc;
select * from departments_dup order by dept_no asc;

delete from dept_manager_dup where emp_no = '110228';
delete from departments_dup where dept_no = 'd009';

insert into dept_manager_dup values ('110228','d003','1992-03-21','9999-01-01');
insert into departments_dup values ('d009','Customer Service');

SELECT 
    m.dept_no, m.emp_no, d.dept_name
FROM
    dept_manager_dup m
        LEFT JOIN
    departments_dup d ON m.dept_no = d.dept_no
GROUP BY m.emp_no
ORDER BY m.dept_no;

SELECT 
    e.emp_no, e.first_name, e.last_name, dm.dept_no, e.hire_date
FROM
    employees e
        left JOIN
    dept_manager dm ON e.emp_no = dm.emp_no
where e.last_name = 'Markovitch'
ORDER BY dm.dept_no desc, e.emp_no;

SELECT 
    e.emp_no, e.first_name, e.last_name, dm.dept_no, e.hire_date
FROM
    employees e,
    dept_manager dm
WHERE
    e.emp_no = dm.emp_no
ORDER BY e.emp_no;

SELECT 
    e.emp_no, e.first_name, e.last_name, s.salary
FROM
    employees e
        JOIN
    salaries s ON e.emp_no = s.emp_no
WHERE
    s.salary > 145000;
    
set @@global.sql_mode := replace(@@global.sql_mode, 'ONLY_FULL_GROUP_BY', '');
select @@global.sql_mode;

SELECT 
    e.emp_no, e.first_name, e.last_name, e.hire_date, t.title
FROM
    employees e
        JOIN
    titles t ON e.emp_no = t.emp_no
WHERE
    e.last_name = 'Markovitch'
        AND e.first_name = 'Margareta'
ORDER BY e.emp_no;

SELECT 
    dm.*, d.*
FROM
    departments d
        CROSS JOIN
    dept_manager dm
WHERE
    d.dept_no = 'd009'
ORDER BY d.dept_no;

SELECT 
    e.*, d.*
FROM
    employees e
        CROSS JOIN
    departments d
WHERE
    e.emp_no < 10011
ORDER BY e.emp_no , d.dept_no;

SELECT 
    e.first_name,
    e.last_name,
    t.title,
    dm.from_date,
    d.dept_name
FROM
    employees e
        JOIN
    dept_manager dm ON e.emp_no = dm.emp_no
        JOIN
    departments d ON dm.dept_no = d.dept_no
       JOIN
    titles t ON e.emp_no = t.emp_no
WHERE
    t.title = 'Manager'
ORDER BY e.emp_no;

SELECT 
    d.dept_name, AVG(salary) AS average_salary
FROM
    departments d
        JOIN
    dept_manager m ON d.dept_no = m.dept_no
        JOIN
    salaries s ON m.emp_no = s.emp_no
GROUP BY d.dept_name
HAVING average_salary > 60000
ORDER BY d.dept_no DESC;

SELECT 
    e.gender, count(dm.emp_no)
FROM
    employees e
        JOIN
    dept_manager dm ON e.emp_no = dm.emp_no
GROUP BY e.gender;

-- create employees_dup
drop table if exists employees_dup;
CREATE TABLE employees_dup (
    emp_no INT(11),
    birth_date DATE,
    first_name VARCHAR(14),
    last_name VARCHAR(16),
    gender ENUM('M', 'F'),
    hire_date DATE
);
-- duplicate the structure of the 'employees' table
insert into employees_dup
select e.* from employees e
limit 20;
-- check 
SELECT 
    *
FROM
    employees_dup;
-- insert a duplicate of the first row
insert into employees_dup values
('10001', '1953-09-02', 'Georgi', 'Facello', 'M', '1986-06-26');

-- UNION vs UNION ALL
select
e.emp_no,
e.first_name,
e.last_name,
null as dept_no,
null as from_date
from employees_dup e
where e.emp_no = 10001
union all select
null as emp_no,
null as first_name,
null as last_name,
m.dept_no,
m.from_date
from dept_manager m;

select * from( select
e.emp_no,
e.first_name,
e.last_name,
null as dept_no,
null as from_date
from employees e
where last_name = 'Denis'
union select
null as emp_no,
null as first_name,
null as last_name,
dm.dept_no,
dm.from_date
from dept_manager dm) as a
order by -a.emp_no desc ;

SELECT 
    *
FROM
    dept_manager
WHERE
   emp_no IN (SELECT 
            emp_no
        FROM
            employees
            where
            hire_date BETWEEN '1990-01-01' AND '1995-01-01');

SELECT 
    *
FROM
    employees e
WHERE
    EXISTS( SELECT 
            *
        FROM
            titles t
        WHERE
            t.emp_no = e.emp_no
                AND title = 'Assistant Engineer');