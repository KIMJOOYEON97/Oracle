--1. 직원명과 이메일 , 이메일 길이를 출력하시오
--          이름        이메일       이메일길이
--    ex)     홍길동 , hong@kh.or.kr         13

select emp_name 이름,
       email 이메일,
       length(email)이메일길이
from employee;

select to_char(round(avg(salary)),'fmL999,999,999,999')
from employee
where dept_code = 'D1';

select min(hire_date),
       max(hire_date),
       min(emp_name),
       max(emp_name)
from employee;


select to_char(
        sysdate+to_yminterval('+2-3')
        +to_dsinterval('5 05:05:06')
        ,'yyyy/mm/dd hh:mi:ss am'
        ) 값
from dual;

select extract(year from(
       numtoyminterval(
       to_date('20250708','yyyymmdd')-sysdate,
       'year'
       ))/365)diff
from dual;

select sysdate,
       to_char(sysdate - numtodsinterval(2,'hour'),'hh24')
from dual;


select to_date('2021/02/26','yyyy/mm/dd') + 3,
       add_months(to_date('2021/06/30','yyyy/mm/dd')+1,1)
from dual;

select emp_id 사번,
emp_name 사원명,
emp_no 주민번호
from employee
where substr(emp_no,8,1) in ('1','3');
--2. 직원의 이름과 이메일 주소중 아이디 부분만 출력하시오
--    ex) 노옹철   no_hc
--    ex) 정중하   jung_jh
--3. 60년대에 태어난 직원명과 년생, 보너스 값을 출력하시오 
--    그때 보너스 값이 null인 경우에는 0 이라고 출력 되게 만드시오
--        직원명    년생      보너스
--    ex) 선동일   1962    0.3
--    ex) 송은희   1963    0
--4. '010' 핸드폰 번호를 쓰지 않는 사람의 수를 출력하시오 (뒤에 단위는 명을 붙이시오)
--       인원
--    ex) 3명
--5. 직원명과 입사년월을 출력하시오 
--    단, 아래와 같이 출력되도록 만들어 보시오
--        직원명       입사년월
--    ex) 전형돈       2012년12월
--    ex) 전지연       1997년 3월
--6. 사원테이블에서 다음과 같이 조회하세요.
--[현재나이 = 현재년도 - 태어난년도 +1] 한국식 나이를 적용.
---------------------------------------------------------------------------
--사원번호    사원명       주민번호            성별      현재나이
---------------------------------------------------------------------------
--200        선동일      621235-1*******      남      57
--201        송종기      631156-1*******      남      56
--202        노옹철      861015-1*******      남      33
--7. 직원명, 직급코드, 연봉(원) 조회
--  단, 연봉은 ￦57,000,000 으로 표시되게 함
--     연봉은 보너스포인트가 적용된 1년치 급여임
--8. 부서코드가 D5, D9인 직원들 중에서 2004년도에 입사한 직원중에 조회함.
--   사번 사원명 부서코드 입사일
--9. 직원명, 입사일, 오늘까지의 근무일수 조회 
--    * 주말도 포함 , 소수점 아래는 버림
--10. 직원명, 부서코드, 생년월일, 만나이 조회
--   단, 생년월일은 주민번호에서 추출해서, 
--   ㅇㅇㅇㅇ년 ㅇㅇ월 ㅇㅇ일로 출력되게 함.
--   나이는 주민번호에서 추출해서 날짜데이터로 변환한 다음, 계산함
--11. 직원들의 입사일로 부터 년도만 가지고, 각 년도별 입사인원수를 구하시오.
--  아래의 년도에 입사한 인원수를 조회하시오. 마지막으로 전체직원수도 구하시오
--  => decode, sum 사용
--    -------------------------------------------------------------------------
--     1998년   1999년   2000년   2001년   2002년   2003년   2004년  전체직원수
--    -------------------------------------------------------------------------
--12.  부서코드가 D5이면 총무부, D6이면 기획부, D9이면 영업부로 처리하시오.(case 사용)
--   단, 부서코드가 D5, D6, D9 인 직원의 정보만 조회하고, 부서코드 기준으로 오름차순 정렬함.