--=============================
--kh계정
--=============================
show user;

--table sample 생성
create table sample(
   id number 
);

--현재 계정의 소유 테이블 목록 조회
select * from tab;

--사원테이블
select*from employee;
--부서 테이블
select*from department;
--직급테이블
select*from job;
--지역테이블
select*from location;
--국가테이블
select*from nation;
--급여등급테이블
select*from sal_grade;

--table entity relation
--데이터를 보관하는 객체

--열 column field attridute(속성) 세로 데이터가 담길 형식
--행 row recode tuple 가로 실제 데이터
--도메인 domain 하나의 컬럼에 취할 수 있는 값의 그룹(범위)

--테이블 명세
-- 컬럼명    널여부    자료형
DESCRIBE employee;
desc employee;

--============================
--DATA TYPE
--============================
--컬럼에 지정해서 값을 제한적으로 허용.
--1.문자형 varchar2 |char
--2.숫자형 number
--3.날짜시간형 date | timestamp
--4.LOB

--==============================
--문자형
--==============================
--고정형 char(byte) : 최대 2000byte
--    char(10) 'korea' 영소문자는 글자당 1byte이므로 실제크기 5byte 고정형 10byte 저장됨.
--               '안녕' 한글은 글자당 3byte(llg XE)이므로 실제크기 6byte 고정형 10byte 저장됨.
                --다른 곳에서는 한글은 2byte

--가변형 varchar2(byte) : 최대 4000byte
--      varchar2(10) 'korea' 영소문자는 글자당 1byte이므로 실제크기 5byte. 가변형 5byte로 저장됌
--                  '안녕' 한글은 글자당 3byte(llg XE)이므로 실제크기 6byte 가변형 6byte 저장됨.
--고정형, 가변형 모두 지정한 크기 이상의 값은 추가할 수 없다.

--가변형 long : 최대 2GB
--LOB타입(Large Object) 중의 CLOB(Character LOB)는 단일컬럼 최대 4GB까지 지원

create table tb_datatype (
--컬럼명 자료형
    a char(10),  --컬럼 a
    b varchar2(10) --컬럼b
);

--테이블 조회
select * -- *모든 컬럼
from tb_datatype;

--데이터 추가: 한행을 추가
insert into tb_datatype
values('hello','hello');

insert into tb_datatype
values('안녕','안녕');

insert into tb_datatype
values('에브리바디','안녕');
--ORA-12899: value too large for column "KH"."TB_DATATYPE"."A" (actual: 15, maximum: 10)

--데이터가 변경(insert,update,delete)되는 경우, 메모리 상에서 먼저처리된다.
-- commit을 통해 실제 database에 적용해야 한다.
commit;

--lengthb(컬럼명):number -저장된 데이터의 실제크기를 리턴
select a,lengthb(a),b,length(b)
from tb_datatype;

--==============================
--숫자형
--==============================
-- 정수, 실수를 구분치 않는다.
-- number(p,s)
--p : 표현가능한 전체 자리수
--s : p 중 소수점이하 자리수
/*
값 1234.567
------------------------
number          1234.567
number(7)       1235   --반올림     
number(7,1)     1234.6 --자동 반올림 처리
number(7,-2)    1200   --자동 반올림 처리
*/

create table tb_datatype_number(
    a number,
    b number(7),
    c number(7,1),
    d number(7,-2)
);

select * from tb_datatype_number;

--데이터 추가
insert into tb_datatype_number
values(1234.567,1234.567,1234.567,1234.567);

--지정한 크기보다 큰 숫자는 ORA-01438: value larger than specified precision allowed for this column
insert into tb_datatype_number
values(123456,234567.567,234567.5678,1234.567);

--마지막 commit시점 이후 변경사항은 취소된다.
ROLLBACK;

--==============================
--날짜시간형
--==============================
--date 년월일시분초
--timestamp 년월일시분초 밀리초 지역대

create table tb_datatype_date(
    a date,
    b timestamp
);

--to_char 날짜/숫자를 문자열로 표현
select to_char(a,'yyyy/mm/dd hh24:mi:ss'),b
from tb_datatype_date;

insert into tb_datatype_date
values (sysdate,systimestamp);

--날짜형 +- 숫자(1=하루) = 날짜형
select to_char(a+1,'yyyy/mm/dd hh24:mi:ss'),
       to_char(a-1,'yyyy/mm/dd hh24:mi:ss'),
       b
from tb_datatype_date;

--날짜형-날짜형 = 숫자(1=하루)
select sysdate - a ---0.009일차
from tb_datatype_date;

--to date 문자열을 날짜형으로 변환 함수
select to_date('2021/1/23')-a --토요일 자정이 될려면 1.15일 남음
from tb_datatype_date;

--dual 가상테이블
select (sysdate+1) - sysdate --내일 이시각 지금 이시각을 빼면 = 1
from dual --dual : 가상테이블

--==============================
--DQL
--==============================
-- Data Query Language 데이터 조회(검색)을 위한 언어
-- select문
-- 쿼리 조회결과를 ResultSet(결과집합)라고 하며, 0행 이상을 포함한다. ->조회된 결과가 없을 수 도 있음

-- from절에 조회하고자 하는 테이블 명시
-- where절에 의해 특정행을 filtering 가능.
-- select절에 의해 컬럼을 filtering 또는 추가가능
-- order by절에 의해서 행을 정렬할 수 있다.

/*
select 컬럼명 (5)          필수
from 테이블명 (1)           필수
where 조건절 (2)           선택
group by 그룹기준컬럼 (3)   선택
having 그룹조건절 (4)       선택
order by 정렬기준컬럼 (6)    선택
*/

select *
from employee
where dept_code = 'D9' --데이터는 대소문자 구분
order by emp_name asc; --오름차순

--1. job테이블에서 job_name컬럼정보만 출력

select job_name
from job;


--2. department테이블에서 모든 컬럼을 출력

select *
from department;

--3. employee테이블에서 이름, 이메일, 전화번호, 입사일을 출력

select emp_name,email,phone,hire_date
from employee;

--4. employee테이블에서 급여가 2,500,000원 이상이 사원의 이름과 급여를 출력

select emp_name, salary
from employee
where salary >=2500000;

--5. employee테이블에서 급여가 3,500,000원 이상이면서, 직급코드가 'J3'인 사원을 조회
-- && || 이 아닌 and or만 사용가능

select *
from employee
where salary>=3500000 and job_code ='J3';

--6. employee테이블에서 현재 근무중인 사원을 이름 오름차순으로 정렬해서 출력.

select emp_name
from employee
where quit_yn ='N'
order by emp_name asc;
