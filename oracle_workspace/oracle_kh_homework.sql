--@실습문제

--1. 2020년 12월 25일이 무슨 요일인지 조회하시오.

select to_char(to_date('2020/12/25','yyyy/mm/dd'), 'day')
from dual;

--2. 주민번호가 70년대 생이면서 성별이 여자이고, 성이 전씨인 직원들의 
--사원명, 주민번호, 부서명, 직급명을 조회하시오.
select E.emp_name 사원명,
       E.emp_no 주민번호,
       D.dept_title 부서명,
       J.job_name 직급명
from employee E
    join department D
      on E.dept_code = D.dept_id
    join job J
      on J.job_code = J.job_code
where substr(emp_no,1,1) ='7'
      and emp_name like '전__'
      and substr(emp_no,8,1) in ('2','4');


--3. 가장 나이가 적은 직원의 사번, 사원명, 나이, 부서명, 직급명을 조회하시오.

select E.emp_no 사번,
       E.emp_name 사원명,
       trunc((sysdate - (to_date((decode(substr(emp_no,8,1),'1',1900,'2',1900,2000)+substr(emp_no,1,2)) || substr(emp_no,3,4))))/365) 나이,
       D.dept_title 부서명,
       J.job_name 직급명
from employee E
    join department D
      on E.dept_code = D.dept_id
    join job J
      on E.job_code = J.job_code
where trunc((sysdate - (to_date((decode(substr(emp_no,8,1),'1',1900,'2',1900,2000)+substr(emp_no,1,2)) || substr(emp_no,3,4))))/365)
        =(select min(trunc((sysdate - (to_date((decode(substr(emp_no,8,1),'1',1900,'2',1900,2000)+substr(emp_no,1,2)) || substr(emp_no,3,4))))/365)) from employee);

select emp_id 사번
     , emp_name 사원명
     , extract(year from sysdate)-(decode(substr(emp_no,8,1),'1',1900,'2',1900,2000))-substr(emp_no,1,2)+1 나이
     , dept_title 부서명
     , job_name 직급명
from employee 
    cross join (select min(extract(year from sysdate)-(decode(substr(emp_no,8,1),'1',1900,'2',1900,2000))-substr(emp_no,1,2))+1 min_age from employee)
    left join department on dept_code = dept_id
    left join job  using(job_code)
where 
    extract(year from sysdate)-(decode(substr(emp_no,8,1),'1',1900,'2',1900,2000))-substr(emp_no,1,2)+1 = min_age;
--4. 이름에 '형'자가 들어가는 직원들의 사번, 사원명, 부서명을 조회하시오.

select E.emp_id 사번,
       E.emp_name 사원명,
       D.dept_title 부서명
from employee E
    join department D
      on E.dept_code = D.dept_id
where E.emp_name like '%형%';

--5. 해외영업팀에 근무하는 사원명, 직급명, 부서코드, 부서명을 조회하시오.

select E.emp_name 사원명,
       J.job_name 직급명,
       E.dept_code 부서코드,
       D.dept_title 부서명
from employee E
    join job J
      on E.job_code = J.job_code
    join department D
      on E.dept_code = D.dept_id
where dept_title like '%해외영업%';

--6. 보너스포인트를 받는 직원들의 사원명, 보너스포인트, 부서명, 근무지역명을 조회하시오.

select E.emp_name 사원명,
       E.bonus*E.salary 보너스포인트,
       D.dept_title 부서명,
       N.national_name 근무지역명 
from employee E
    join department D
      on E.dept_code = D.dept_id
    join location L
      on D.location_id = L.local_code
    join nation N
      on L.national_code = N.national_code
where E.bonus is not null;


--7. 부서코드가 D2인 직원들의 사원명, 직급명, 부서명, 근무지역명을 조회하시오.
select E.emp_name 사원명,
       J.job_name  직급명,
       D.dept_title 부서명,
       N.national_name 근무지역명 
from employee E
    join job J
      on E.job_code = J.job_code
    join department D
      on E.dept_code = D.dept_id
    join location L
      on D.location_id = L.local_code
    join nation N
      on L.national_code = N.national_code
where D.dept_id ='D2';

--8. 급여등급테이블의 등급별 최대급여(MAX_SAL)보다 많이 받는 직원들의 사원명, 직급명, 급여, 연봉을 조회하시오.
--(사원테이블과 급여등급테이블을 SAL_LEVEL컬럼기준으로 동등 조인할 것)



select E.emp_name 사원명,
       J.job_name 직급명,
       E.salary 급여,
       (E.salary*nvl(E.bonus,0)+salary)*12 연봉
from employee E
    join sal_grade S
      on E.sal_level = S.sal_level
     join job J
      on E.job_code = J.job_code
where E.salary > S.max_sal;

--9. 한국(KO)과 일본(JP)에 근무하는 직원들의 
--사원명, 부서명, 지역명, 국가명을 조회하시오.

select E.emp_name 사원명,
       D.dept_title 부서명,
       L.local_name 지역명,
       N.national_name 국가명
from employee E
    join job J
      on E.job_code = J.job_code
    join department D
      on E.dept_code = D.dept_id
    join location L
      on D.location_id = L.local_code
    join nation N
      on L.national_code = N.national_code
where  L.national_code in('KO','JP');

--10. 같은 부서에 근무하는 직원들의 사원명, 부서코드, 동료이름을 조회하시오.
--self join 사용
select E1.emp_name 사원명,
       E1.dept_code 부서코드,
       E2.emp_name 동료이름
from employee E1 
    join employee E2 
      on E1.dept_code = E2.dept_code
order by 2;



--11. 보너스포인트가 없는 직원들 중에서 직급이 차장과 사원인 직원들의 사원명, 직급명, 급여를 조회하시오.
select E.emp_name 사원명,
       J.job_name 직급명,
       E.salary 급여
from employee E
    join job J
      on E.job_code = J.job_code 
where E.bonus is null and  J.job_name in('차장','사원');

--12. 재직중인 직원과 퇴사한 직원의 수를 조회하시오.
select sum(decode(quit_yn,'N',1,0)) "재직중인 직원",
       sum(decode(quit_yn,'Y',1,0)) "퇴사한 직원의 수"
from employee;

select dept_code 부서명,
       sum(salary) 급여합
from employee
group by dept_code
having sum(salary)>9000000;

select emp_name 사원명,
       rpad(substr(emp_no,1,8),13,'*')주민번호
from employee
where substr(emp_no,8,1) in('1','3');

--merit_rating이 'A'라면 salary의 20%만큼 보너스를 부여한다.
--merit_rating이 'B'라면 salary의 15%만큼 보너스를 부여한다.
--merit_rating이 'C'라면 salary의 10%만큼 보너스를 부여한다.
--그 외 merit_rating값은 보너스가 없다.
select dept_code,
        case dept_code
          when 'D1' then salary*0.2
          when 'D2' then salary*0.15
          when 'D5' then salary*0.1
          else 0
          end 성과급
from employee;

SELECT

NVL(EMP_NAME,'그룹별 총합')

, JOB_CODE

, COUNT(*) AS 사원수

FROM

employee

WHERE

BONUS is not NULL

GROUP BY ROLLUP(EMP_NAME),job_code

ORDER BY JOB_CODE;


SELECT

DEPT_CODE

, SUM(SALARY) 합계

, FLOOR(AVG(SALARY)) 평균

, COUNT(*) 인원수

FROM

EMPLOYEE

GROUP BY DEPT_CODE
--HAVING AVG(SALARY) >2800000
ORDER BY DEPT_CODE ASC;


SELECT*
FROM EMPLOYEE;


