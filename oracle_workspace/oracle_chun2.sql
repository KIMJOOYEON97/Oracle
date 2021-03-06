--1. 영어영문학과(학과코드 002) 학생들의 학번과 이름, 입학 년도를 입학 년도가 빠른
--순으로 표시하는 SQL 문장을 작성하시오.( 단, 헤더는 "학번", "이름", "입학년도" 가
--표시되도록 핚다.)
select student_no 학번,
       student_name 이름,
       entrance_date 입학년도
from tb_student
group by department_no, student_no, student_name, entrance_date
having department_no = '002';

--2. 춘 기술대학교의 교수 중 이름이 세 글자가 아닌 교수가 핚 명 있다고 핚다. 그 교수의
--이름과 주민번호를 화면에 출력하는 SQL 문장을 작성해 보자. (* 이때 올바르게 작성핚 SQL
--문장의 결과 값이 예상과 다르게 나올 수 있다. 원인이 무엇일지 생각해볼 것)
select professor_name,
       professor_ssn
from tb_professor
--where professor_name not like '___'
group by professor_name, professor_ssn
having length(professor_name) = 2;


--3. 춘 기술대학교의 남자 교수들의 이름과 나이를 출력하는 SQL 문장을 작성하시오. 단
--이때 나이가 적은 사람에서 맋은 사람 순서로 화면에 출력되도록 맊드시오. (단, 교수 중
--2000 년 이후 출생자는 없으며 출력 헤더는 "교수이름", "나이"로 핚다. 나이는 ‘맊’으로
--계산핚다.)
select professor_name 교수이름,
       trunc((sysdate -(to_date(1900+substr(professor_ssn,1,2)||substr(professor_ssn,3,4))))/365) 나이
from tb_professor
where decode(substr(professor_ssn,8,1),'1','남','여')='남'
group by professor_name, trunc((sysdate -(to_date(1900+substr(professor_ssn,1,2)||substr(professor_ssn,3,4))))/365)
order by 나이 desc;

--4. 교수들의 이름 중 성을 제외핚 이름맊 출력하는 SQL 문장을 작성하시오. 출력 헤더는
--‚이름‛ 이 찍히도록 핚다. (성이 2 자인 경우는 교수는 없다고 가정하시오)
select substr(professor_name,2)
from tb_professor;

--5. 춘 기술대학교의 재수생 입학자를 구하려고 핚다. 어떻게 찾아낼 것인가? 이때,
--19 살에 입학하면 재수를 하지 않은 것으로 갂주핚다.
select student_no,
       student_name
from tb_student
group by student_no, student_name, student_ssn, entrance_date
having extract(year from to_date(substr(entrance_date,1,2),'RR'))
         -extract(year from to_date(substr(student_ssn,1,2),'RR')) = 20
order by student_no asc;


SELECT  STUDENT_NO,
        STUDENT_NAME
FROM    TB_STUDENT
WHERE   TO_NUMBER(TO_CHAR(ENTRANCE_DATE, 'YYYY'))  - TO_NUMBER(TO_CHAR(TO_DATE(SUBSTR(STUDENT_SSN, 1, 2), 'RR'), 'YYYY')) > 19
ORDER BY 1;

--6. 2020 년 크리스마스는 무슨 요일인가?

select to_char(to_date('20201225','yyyymmdd'),'day')
from dual;

--7. TO_DATE('99/10/11','YY/MM/DD'), TO_DATE('49/10/11','YY/MM/DD') 은 각각 몇 년 몇
--월 몇 일을 의미핛까? 또 TO_DATE('99/10/11','RR/MM/DD'),
--TO_DATE('49/10/11','RR/MM/DD') 은 각각 몇 년 몇 월 몇 일을 의미핛까?
select to_char(TO_DATE('99/10/11','YY/MM/DD'),'yyyy"년" mm"월" dd"일"') a,
       to_char(TO_DATE('49/10/11','YY/MM/DD'),'yyyy"년" mm"월" dd"일"') b,
       to_char(TO_DATE('99/10/11','RR/MM/DD'),'yyyy"년" mm"월" dd"일"') c,
       to_char(TO_DATE('49/10/11','RR/MM/DD'),'yyyy"년" mm"월" dd"일"') d
from dual;

--RRRR YYYY
--RR YY
--YY : 현재년도기준으로 한세기(00~99)에서 판단. 2020 -> 2000 ~ 2099
--RR : 현재년도기준으로 한세기(50~49)에서 판단. 2020 -> 1950 ~ 2049,  2060 -> 2050
/*
TO_DATE('99/10/11', 'YY/MM/DD') : 2099년 10월 11일
TO_DATE('49/10/11', 'YY/MM/DD') : 2049년 10월 11일
TO_DATE('99/10/11', 'RR/MM/DD') : 1999년 10월 11일
TO_DATE('49/10/11', 'RR/MM/DD') : 2049년 10월 11일
*/


--8. 춘 기술대학교의 2000 년도 이후 입학자들은 학번이 A 로 시작하게 되어있다. 2000 년도
--이젂 학번을 받은 학생들의 학번과 이름을 보여주는 SQL 문장을 작성하시오.
select student_no,student_name
from tb_student
where substr (student_no,1,1)!= 'A';

--9. 학번이 A517178 인 핚아름 학생의 학점 총 평점을 구하는 SQL 문을 작성하시오. 단,
--이때 출력 화면의 헤더는 "평점" 이라고 찍히게 하고, 점수는 반올림하여 소수점 이하 핚
--자리까지맊 표시핚다
select round(avg(point),1) 평점
from tb_grade
where student_no = 'A517178';

--10. 학과별 학생수를 구하여 "학과번호", "학생수(명)" 의 형태로 헤더를 맊들어 결과값이
--출력되도록 하시오.
select department_no 학과번호,
       count(*) "학생수(명)"
from tb_student
group by department_no
order by department_no;


--11. 지도 교수를 배정받지 못핚 학생의 수는 몇 명 정도 되는 알아내는 SQL 문을
--작성하시오.
select count(*)
from tb_student
where coach_professor_no is null;


--12. 학번이 A112113 인 김고운 학생의 년도 별 평점을 구하는 SQL 문을 작성하시오. 단,
--이때 출력 화면의 헤더는 "년도", "년도 별 평점" 이라고 찍히게 하고, 점수는 반올림하여
--소수점 이하 핚 자리까지맊 표시핚다
select substr(term_no,1,4) 년도,
       avg(point)
from tb_grade
where student_no = 'A112113'
group by substr(term_no,1,4);

--13. 학과 별 휴학생 수를 파악하고자 핚다. 학과 번호와 휴학생 수를 표시하는 SQL 문장을
--작성하시오.
select department_no 학과코드명,
        count(*) "휴학생 수"
     --SUM(CASE WHEN ABSENCE_YN ='Y' THEN 1 
--         ELSE 0 END) AS "휴학생 수"
from tb_student
where absence_yn = 'Y'
group by department_no
order by 학과코드명;


--14. 춘 대학교에 다니는 동명이인(同名異人) 학생들의 이름을 찾고자 핚다. 어떤 SQL
--문장을 사용하면 가능하겠는가?
select student_name 동일이름,
       count(*) "동명인 수"
from tb_student
group by student_name
having count(*) >=2
order by 동일이름;

--15. 학번이 A112113 인 김고운 학생의 년도, 학기 별 평점과 년도 별 누적 평점 , 총
--평점을 구하는 SQL 문을 작성하시오. (단, 평점은 소수점 1 자리까지맊 반올림하여
--표시핚다.)
select decode(grouping(substr(term_no,1,4)),0,nvl(substr(term_no,1,4),' '),1,nvl(substr(term_no,1,4),' ')) 년도,
       decode(grouping(substr(term_no,5,2)),0,nvl(substr(term_no,5,2),' '),1,nvl(substr(term_no,5,2),' ')) 학기,
       round(avg(point),1) "학기 별 평점"
from tb_grade
where student_no = 'A112113'
group by ROLLUP(substr(term_no,1,4),substr(term_no,5,2));

--select decode(grouping(substr(term_no, 1, 4)), 0, substr(term_no, 1, 4), ' ') 년도,
--       decode(grouping(substr(term_no, 5, 2)), 0, substr(term_no, 5, 2), ' ') 학기,

--CASE이용
SELECT DECODE(GROUPING(SUBSTR(TERM_NO, 1, 4)),0,SUBSTR(TERM_NO, 1, 4),1,'총평점') AS 년도,
        CASE WHEN GROUPING(SUBSTR(TERM_NO, 1, 4)) = 1 AND GROUPING(SUBSTR(TERM_NO, 5, 2))=1 THEN ' '
              WHEN GROUPING(SUBSTR(TERM_NO, 5, 2)) = 1 THEN '연별누적평점'
              ELSE SUBSTR(TERM_NO, 5, 2) END AS 구분,
        ROUND(AVG(POINT), 1) AS 평점
FROM   TB_GRADE
WHERE  STUDENT_NO = 'A112113'
GROUP BY ROLLUP(SUBSTR(TERM_NO, 1, 4),SUBSTR(TERM_NO, 5, 2));
