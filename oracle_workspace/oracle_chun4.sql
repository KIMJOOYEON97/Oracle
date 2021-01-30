--@실습문제 : INNER JOIN & OUTER JOIN
--1. 학번, 학생명, 학과명을 출력
select S.student_no 학번,
       S.student_name 학생명,
       D.department_name 학과명
from tb_student S
    join tb_department D
      on S.department_no = D.department_no;
      
--2. 학번, 학생명, 담당교수명을 출력하세요.
--담당교수가 없는 학생은 '없음'으로 표시
select S.student_no,
       S.student_name,
       nvl(P.professor_name,'없음')
from tb_student S
    left join tb_professor P
      on S.coach_professor_no = P.professor_no;

--3. 학과별 교수명과 인원수를 모두 표시하세요.
select D.department_name,
       count(*)
from tb_department D
    join tb_professor P
      on  D.department_no = P.department_no 
group by D.department_name;

-- 4. 이름이 [~람]인 학생의 평균학점을 구해서 학생명과 평균학점(반올림해서 소수점둘째자리까지)과 같이 출력.
-- (동명이인일 경우에 대비해서 student_name만으로 group by 할 수 없다.)
select S.student_name,
       round(avg(G.point),2)
from tb_grade G
    join tb_student S
      on G.student_no = S.student_no
where S.student_name like '%람'
group by S.student_no, S.student_name;

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
select S.student_name 학생명,
       G.term_no 학기,
       C.class_name 과목명,
       G.point 학점
from tb_grade G
    join tb_student S
      on G.student_no = S.student_no
    join tb_class C
      on G.class_no = C.class_no
order by 1,2,4 desc;


