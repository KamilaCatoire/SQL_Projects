use employees;

select sysdate();

SELECT 
    emp_no, salary, from_date, to_date
FROM
    salaries
WHERE
    to_date > SYSDATE();

SELECT 
    emp_no, salary, max(from_date), to_date
FROM
    salaries
WHERE
    to_date > SYSDATE()
group by emp_no;

select s1.emp_no, s.salary, s.from_date, s.to_date
FROM
    salaries s
join(
SELECT 
    emp_no, max(from_date) as from_date
from salaries
group by emp_no) s1 on s.emp_no = s1.emp_no
WHERE
    s.to_date > SYSDATE()
    and s.from_date = s1.from_date;
    
select s1.emp_no, s.salary, s.from_date, s.to_date
FROM
    salaries s
join(
SELECT 
    emp_no, min(from_date) as from_date
from salaries
group by emp_no) s1 on s.emp_no = s1.emp_no
WHERE
    s.to_date > SYSDATE()
    and s.from_date = s1.from_date;

select de2.emp_no, d.dept_name, s2.salary, avg(s2.salary) over w as average_salary_per_departement
from (select de.emp_no, de.dept_no, de.from_date, de.to_date
from dept_emp de
join 
(select emp_no, max(from_date) as from_date
from dept_emp
group by emp_no) de1 on de1.emp_no = de.emp_no
where de.to_date > sysdate()
and de.from_date = de1.from_date) de2
join
(select s1.emp_no, s.salary, s.from_date, s.to_date
from salaries s
join
(select emp_no, max(from_date) as from_date
from salaries
group by emp_no) s1 on s.emp_no = s1.emp_no
where s.to_date > sysdate()
and s.from_date = s1.from_date) s2 on s2.emp_no = de2.emp_no
join departments d on d.dept_no = de2.dept_no
group by de2.emp_no, d.dept_no
window w as (partition by de2.dept_no)
order by de2.emp_no;

select de2.emp_no, d.dept_name, s2.salary, avg(s2.salary) over w as average_salary_per_departement
from (select de.emp_no, de.dept_no, de.from_date, de.to_date
from dept_emp de
join 
(select emp_no, max(from_date) as from_date
from dept_emp
group by emp_no) de1 on de1.emp_no = de.emp_no
where de.to_date < '2002-01-01' and de.from_date > '2000-01-01'
and de.from_date = de1.from_date) de2
join
(select s1.emp_no, s.salary, s.from_date, s.to_date
from salaries s
join
(select emp_no, max(from_date) as from_date
from salaries
group by emp_no) s1 on s.emp_no = s1.emp_no
where s.to_date < '2002-01-01' and s.from_date > '2000-01-01'
and s.from_date = s1.from_date) s2 on s2.emp_no = de2.emp_no
join departments d on d.dept_no = de2.dept_no
group by de2.emp_no, d.dept_no
window w as (partition by de2.dept_no)
order by de2.emp_no;