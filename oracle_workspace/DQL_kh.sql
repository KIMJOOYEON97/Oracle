--<DQL종합실습문제>
--@ 실습 문제
--문제1
--기술지원부에 속한 사람들의 사람의 이름,부서코드,급여를 출력하시오
select emp_name 이름,
       dept_code 부서코드,
       salary 급여
from employee
where dept_code =(select dept_id from department where dept_title = '기술지원부') ;

--문제2
--기술지원부에 속한 사람들 중 가장 연봉이 높은 사람의 이름,부서코드,급여를 출력하시오
select E.* 
from( 
    select emp_name 이름,
           dept_code 부서코드,
           (salary*nvl(bonus,0)+salary) 연봉
    from employee E
    where dept_code = (select dept_id from department where dept_title = '기술지원부')
    order by 3 desc
    ) E
where rownum = 1;
    
--문제3
--매니저가 있는 사원중에 월급이 전체사원 평균을 넘고 
--사번,이름,매니저 이름, 월급을 구하시오. 
--    1. JOIN을 이용하시오
select E1.emp_id 사번,
       E1.emp_name 이름,
       E1.salary 월급
from employee E1
    cross join (select avg(salary) avg from employee)
where E1.manager_id is not null 
    and E1.salary > avg;
      

--    2. JOIN하지 않고, 스칼라상관쿼리(SELECT)를 이용하기

select emp_id 사번,
       emp_name 이름,
       salary 월급
from employee 
where manager_id is not null 
     and salary >(select avg(salary) from employee);


--문제4
--같은 직급의 평균급여보다 같거나 많은 급여를 받는 직원의 이름, 직급코드, 급여, 급여등급 조회

select E.이름,
       E.직급코드,
       E.급여,
       E.급여등급
from(
    select emp_name 이름,
           job_code 직급코드,
           salary 급여,
           sal_level 급여등급,
           trunc(avg(salary) over(partition by dept_code)) "부서별 급여평균"
    from employee
    )E
where "급여" >"부서별 급여평균"; 

--문제5
--부서별 평균 급여가 3000000 이상인 부서명, 평균 급여 조회
--단, 평균 급여는 소수점 버림, 부서명이 없는 경우 '인턴'처리

select nvl(D.dept_title,'인턴')"부서명",
       trunc(avg(salary) over(partition by dept_title)) "평균급여"
from employee E
    join department D
      on E.dept_code = D.dept_id
group by D.dept_title, salary
having avg(salary) >= 3000000;

--문제6
--직급의 연봉 평균보다 적게 받는 여자사원의
--사원명,직급명,부서명,연봉을 이름 오름차순으로 조회하시오
--연봉 계산 => (급여+(급여*보너스))*12    

select emp_name 사원명,
     (select job_name from job where job_code = E.job_code) 직급,
     (select dept_title from department where E.dept_code = dept_id) 부서,
     (salary*nvl(bonus,0)+salary)*12 연봉
from employee E
where decode(substr(emp_no,8,1),'1','남','3','남','여') = '여'
    and (salary*nvl(bonus,0)+salary)*12 < (select avg((salary*nvl(bonus,0)+salary)*12) from employee where job_code = E.job_code)
order by 1;

---문제7
--다음 도서목록테이블을 생성하고, 공저인 도서만 출력하세요.
create table tbl_books (
book_title  varchar2(50)
,author     varchar2(50)
,loyalty     number(5)
);
insert into tbl_books values ('반지나라 해리포터', '박나라', 200);
insert into tbl_books values ('대화가 필요해', '선동일', 500);
insert into tbl_books values ('나무', '임시환', 300);
insert into tbl_books values ('별의 하루', '송종기', 200);
insert into tbl_books values ('별의 하루', '윤은해', 400);
insert into tbl_books values ('개미', '장쯔위', 100);
insert into tbl_books values ('아지랑이 피우기', '이오리', 200);
insert into tbl_books values ('아지랑이 피우기', '전지연', 100);
insert into tbl_books values ('삼국지', '노옹철', 200);

select  book_title
from tbl_books
group by book_title
having count(book_title)>=2;
