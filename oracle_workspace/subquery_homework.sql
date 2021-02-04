--@실습문제 : INNER JOIN & OUTER JOIN
--1. 학번, 학생명, 학과명을 출력
select  S.student_no 학번,
        S.student_name 학생명,
        D.department_name 학과명
from tb_student S
    join tb_department D
      on S.department_no = D.department_no;
      
--2. 학번, 학생명, 담당교수명을 출력하세요.
--담당교수가 없는 학생은 '없음'으로 표시
select student_no 학번,
       student_name 학생명,
       nvl(P.professor_name,'없음')
from tb_student S
    left join tb_professor P
      on S.coach_professor_no = P.professor_no;

--3. 학과별 교수명과 인원수를 모두 표시하세요.

select decode(grouping(department_name),0,nvl(department_name,'미지정'),1,'총계') 학과명,
       decode(grouping(professor_name),0,professor_name,1,count(*)) 교수명
from tb_professor p
    left join tb_department d
      on p.department_no =d.department_no
group by rollup(department_name, professor_name)
order by d.department_name;

-- 4. 이름이 [~람]인 학생의 평균학점을 구해서 학생명과 평균학점(반올림해서 소수점둘째자리까지)과 같이 출력.
-- (동명이인일 경우에 대비해서 student_name만으로 group by 할 수 없다.)
select round(avg(point),2)
from tb_grade
where student_no in (select student_no from tb_student where student_name like '%람')
group by student_no;

--5. 학생별 다음정보를 구하라.
/*
--------------------------------------------
학생명  학기     과목명    학점
--------------------------------------------
감현제	200401	전기생리학 	4.5
            .
            .
--------------------------------------------

*/


