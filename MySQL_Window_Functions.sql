use employees;

SELECT 
    emp_no, salary,
    row_number() over () as row_num
FROM
    salaries;
    
SELECT 
    emp_no, salary,
    row_number() over (partition by emp_no) as row_num
FROM
    salaries;

SELECT 
    emp_no, salary,
    row_number() over(partition by emp_no order by salary desc) as row_num
FROM
    salaries;

select emp_no, dept_no,
row_number() over (order by emp_no) as row_num
from dept_manager;

select emp_no, first_name, last_name,
row_number() over (partition by first_name order by last_name asc) as row_num
from employees;

select emp_no, salary,
# row_number() over () as row_num1,
row_number() over (partition by emp_no) as row_num2,
row_number() over (partition by emp_no order by salary desc) as row_num3
# row_number() over (order by salary desc) as row_num4
from salaries;
# order by emp_no, salary;

select dm.emp_no, s.salary,
row_number() over () as row_num1,
row_number() over (partition by dm.emp_no order by s.salary) as row_num2
from dept_manager dm
join salaries s on dm.emp_no = s.emp_no
order by row_num1, s.emp_no, s.salary asc;

select dm.emp_no, s.salary,
row_number() over (partition by s.emp_no order by s.salary asc) as row_num1,
row_number() over (partition by dm.emp_no order by s.salary) as row_num2
from dept_manager dm
join salaries s on dm.emp_no = s.emp_no;

select emp_no, first_name, last_name,
row_number() over w as row_num
from employees
window w as (partition by first_name order by emp_no asc);