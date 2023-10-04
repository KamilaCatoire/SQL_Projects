use employees;

select emp_no, salary,
lag(salary) over w as previous_salary,
lead(salary) over w as next_salary,
salary - lag(salary) over w as diff_salary_current_previous,
lead(salary) over w - salary as diff_salary_next_current
from salaries
where emp_no = 10001
window w as (order by salary);

select emp_no, salary,
lag(salary) over w as previous_salary,
lag(salary, 2) over w as 1_before_previous_salary,
lead(salary) over w as next_salary,
lead(salary, 2) over w as 1_after_next_salary


from salaries
window w as (partition by emp_no order by salary)
limit 1000;