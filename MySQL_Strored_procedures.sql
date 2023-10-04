use employees;

-- return the first 1000 rows from the 'employees' table

DROP procedure if exists select_employees;

delimiter $$
create procedure select_employees()
begin
	select * from employees 
	limit 1000;
end$$
delimiter ;

call employees.select_employees();

-- Create a procedure that will provide the average salary of all employees.
DROP procedure if exists avg_salary;
delimiter $$
create procedure avg_salary()
begin
	select avg(salary) from salaries;
end$$
delimiter ;
call avg_salary;

drop procedure select_employees;

drop procedure if exists emp_salary;

delimiter $$
use employees $$
create procedure emp_salary(in p_emp_no INTEGER)
begin
	select e.first_name, e.last_name, s.salary, s.from_date, s.to_date
	from employees e
		join salaries s on e.emp_no = s.emp_no
where e.emp_no = p_emp_no;
end$$
delimiter ;

drop procedure if exists emp_avg_salary;

delimiter $$
use employees $$
create procedure emp_avg_salary(in p_emp_no INTEGER)
begin
	select e.first_name, e.last_name, avg(s.salary) as avg_salary
	from employees e
		join salaries s on e.emp_no = s.emp_no
where e.emp_no = p_emp_no;
end$$
delimiter ;

call emp_avg_salary(11300);

drop procedure if exists emp_avg_salary_out;

delimiter $$
use employees $$
create procedure emp_avg_salary_out(in p_emp_no INTEGER, out p_avg_salary decimal(10,2))
begin
	select avg(s.salary) as avg_salary
    into p_avg_salary from employees e
		join salaries s on e.emp_no = s.emp_no
where e.emp_no = p_emp_no;
end$$
delimiter ;

-- Create a procedure called ‘emp_info’ that uses as parameters 
-- the first and the last name of an individual, and returns their employee number.

drop procedure if exists emp_info;

delimiter $$
use employees $$
create procedure emp_info(in p_first_name VARCHAR(255), in p_last_name VARCHAR(255), out p_emp_no INTEGER)
begin
	select emp_no
    into p_emp_no from employees e
where e.first_name = p_first_name and e.last_name = p_last_name
group by e.first_name and e.last_name;
end$$
delimiter ;

-- variables
set @v_avg_salary = 0;
call employees.emp_avg_salary_out(11300, @v_avg_salary);
select @v_avg_salary;

set @v_emp_no = 0;
call employees.emp_info('Aruna', 'Journel', @v_emp_no);
select @v_emp_no;

-- Functions
use employees;
drop function if exists f_emp_avg_salary;

delimiter $$
create function f_emp_avg_salary (p_emp_no INTEGER) returns decimal(10,2)
deterministic no sql reads sql data
begin
declare v_avg_salary decimal(10,2);
select avg(s.salary) INTO v_avg_salary from employees e
join salaries s on e.emp_no = s.emp_no
where e.emp_no = p_emp_no;
return v_avg_salary;
end$$
delimiter ;

select f_emp_avg_salary(11300);

drop function if exists f_emp_info;

delimiter $$
create function f_emp_info (p_first_name varchar(255), p_last_name varchar(255)) returns decimal(10,2)
deterministic no sql reads sql data
begin
declare v_salary decimal(10,2);
declare v_max_from_date date;
select max(from_date) INTO v_max_from_date from employees e
join salaries s on e.emp_no = s.emp_no
where e.first_name = p_first_name 
and e.last_name = p_last_name;
select s.salary into v_salary from employees e
join salaries s on e.emp_no = s.emp_no
where e.first_name = p_first_name 
and e.last_name = p_last_name
and s.from_date = v_max_from_date;
return v_salary;
end$$
delimiter ;