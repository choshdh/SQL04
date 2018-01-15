--서브쿼리(SUBQUERY) SQL 문제입니다.
--문제1.
--평균 급여보다 적은 급여을 받는 직원은 몇 명이나 있습니까?
--//56명

select count(employee_id)
from employees
where salary < (select avg(salary)
				from employees);


--문제2.
--각 부서별로 최고의 급여를 받는 사원의 직원번호(employee_id), 성(last_name)과 급여(salary)
--부서번호(department_id)를 조회하세요 단 조회결과는 급여의 내림차순으로 정렬되어 나타나야
--합니다.
--//11명

--1)조건절 비교 0.001초
select employee_id,
		last_name,
		salary,
		department_id
from employees
where (department_id , salary) in (select department_id,
											max(salary)
								   from employees
								   group by department_id)
order by salary desc;

--2)테이블 생성 비교 0.002초
select es.employee_id,
        es.last_name,
        es.salary,
        es.department_id
from employees es, (select department_id,
                            max(salary) salary
                            from employees
                            group by department_id) ms
where es.department_id = ms.department_id and es.salary = ms.salary
order by es.salary desc;


--문제3.
--각 업무(job) 별로 연봉(salary)의 총합을 구하고자 합니다. 연봉 총합이 가장 높은 업무부터
--업무명(job_title)과 연봉 총합을 조회하시오
--//19부서

select js.job_title "업무명",
		ss.salary "연봉 총합"
from  (select job_id,
	  sum(salary) salary
	  from employees
	  group by job_id) ss,
	  jobs js
where ss.job_id = js.job_id
order by ss.salary desc;


--문제4.
--자신의 부서 평균 급여보다 연봉(salary)이 많은 직원의 직원번호(employee_id), 성(last_name)과
--급여(salary)을 조회하세요
--//38명

select es.employee_id "부서아이디",
		es.last_name "이름" ,
		es.salary "급여"
from employees es, (select department_id,
                            avg(salary) salary
                    from employees
                    group by department_id) avgs
where es.department_id = avgs.department_id and es.salary > avgs.salary;