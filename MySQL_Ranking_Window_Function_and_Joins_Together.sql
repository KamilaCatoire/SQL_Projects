use employees;

select 
	d.dept_no, d.dept_name, dm.emp_no,
	rank() over w as department_salary_ranking,
    s.salary,
    s.from_date as salary_from_date,
    s.to_date as salary_to_date,
    dm.from_date as dept_manager_from_date,
    dm.to_date as dept_manager_to_date
from dept_manager dm
	join salaries s on s.emp_no = dm.emp_no
    and s.from_date between dm.from_date and dm.to_date
    and s.to_date between dm.from_date and dm.to_date
	join departments d on d.dept_no = dm.dept_no
window w as (partition by dm.dept_no order by s.salary desc);

select e.emp_no,
rank() over w as employee_salary_ranking,
s.salary
from employees e
join salaries s on s.emp_no = e.emp_no
where e.emp_no between 10500 and 10600
window w as (partition by e.emp_no order by s.salary desc);

select e.emp_no,
dense_rank() over w as employee_salary_ranking,
s.salary, e.hire_date, s.from_date,
(YEAR(s.from_date)-YEAR(e.hire_date)) as years_from_start
from employees e
join salaries s on s.emp_no = e.emp_no
and (YEAR(s.from_date)-YEAR(e.hire_date)) >= 5
where e.emp_no between 10500 and 10600
window w as (partition by e.emp_no order by s.salary desc);