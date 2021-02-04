--@실습문제
--
--1. 2020년 12월 25일이 무슨 요일인지 조회하시오.


--2. 주민번호가 70년대 생이면서 성별이 여자이고, 성이 전씨인 직원들의 
--사원명, 주민번호, 부서명, 직급명을 조회하시오.

select *
from employee
where substr(emp_no,1,2) between 70 and 79 and emp_name like '전%';

--3. 가장 나이가 적은 직원의 사번, 사원명, 나이, 부서명, 직급명을 조회하시오.

select *
from employee
where (select min(extract(year from sysdate)-(decode(substr(emp_no,8,1),'1',1900,'2',1900,2000))-substr(emp_no,1,2))+1 min_age from employee);


--4. 이름에 '형'자가 들어가는 직원들의 사번, 사원명, 부서명을 조회하시오.
select emp_no 사번,
       emp_name 사원명,
       nvl((
        select dept_title 
        from department 
        where E.dept_code = dept_id
        ),'인턴')부서명
from employee E
where emp_name like '%형%';

--5. 해외영업팀에 근무하는 사원명, 직급명, 부서코드, 부서명을 조회하시오.
select emp_name 사원명,
       (
       select job_name 
       from job
       where job_code = E.job_code
       ) 직급명,
       dept_code 부서코드,
       (
       select dept_title
       from department
       where E.dept_code = dept_id
       ) 부서명
from employee E
where dept_code in (select dept_id from department where dept_title like '%해외영업%'); 


--6. 보너스포인트를 받는 직원들의 사원명, 보너스포인트, 부서명, 근무지역명을 조회하시오.

select emp_name 사원명,
       nvl(bonus,0)*salary 보너스포인트,
       (
       select dept_title
       from departmet
       where E.dept_code = dept_id
       ) 부서명
       (
       select national_name
       from nation N
       where national_code =(
                            select national_code 
                            from location L 
                            where N.national_code = (
                                                        select 
from employee E
where bonus is not null;

--7. 부서코드가 D2인 직원들의 사원명, 직급명, 부서명, 근무지역명을 조회하시오.

select emp_name 사원명,
       (
        select job_name
        from job
        where E.job_code = job_code
        ) 직급명,
        (
        select dept_title
        from department
        where E.dept_code = dept_id
        )부서명
from employee E
where dept_code = 'D2';


--8. 급여등급테이블의 등급별 최대급여(MAX_SAL)보다 많이 받는 직원들의 사원명, 직급명, 급여, 연봉을 조회하시오.
--(사원테이블과 급여등급테이블을 SAL_LEVEL컬럼기준으로 동등 조인할 것)




--9. 한국(KO)과 일본(JP)에 근무하는 직원들의 
--사원명, 부서명, 지역명, 국가명을 조회하시오.
--
--
--10. 같은 부서에 근무하는 직원들의 사원명, 부서코드, 동료이름을 조회하시오.
--self join 사용
--
--
--
--11. 보너스포인트가 없는 직원들 중에서 직급이 차장과 사원인 직원들의 사원명, 직급명, 급여를 조회하시오.
--
--
--12. 재직중인 직원과 퇴사한 직원의 수를 조회하시오.
