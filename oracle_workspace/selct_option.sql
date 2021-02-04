--1
select student_name "학생 이름",
       student_address "주소지"
from tb_student
order by student_name;

--2
select student_name,
       student_ssn
from tb_student
where absence_yn = 'Y'
order by 2 desc;

--3
select student_name 학생이름,
       student_no 학번,
       student_address "거주지 주소"
from tb_student
where student_no not like 'A%' 
      and (student_address like '%강원도%' or student_address like '%경기도%')
order by student_name;

--4
select professor_name,
       professor_ssn
from tb_professor
where department_no 
        = (select department_no from tb_department where department_name ='법학과')
order by 2;

--5
select student_no,
       to_char(point,'0.00') 
from tb_grade
where class_no = 'C3118100' and term_no ='200402'
order by 2 desc, 1;

--6--
select student_no,
       student_name,
       (select department_name from tb_department where S.department_no = department_no)
from tb_student S
order by 
    case 
        when 3 between '가' and '힣' then 1
        end;

--7
select class_name,
       (select department_name from tb_department where C.department_no=department_no)
from tb_class C;

--8
select (select class_name from tb_class where CP.class_no = class_no),
       (select professor_name from tb_professor where CP.professor_no = professor_no)
from tb_class_professor CP
order by 1;

--9--
select C.class_name,
       P.professor_name
from tb_class_professor CP
    join tb_class C
      on CP.class_no = C.class_no
    join tb_professor P
      on CP.professor_no = P.professor_no
    join tb_department D
      on C.department_no = D.department_no
where D.category ='인문사회'
order by 2,1;

--10
select S.student_no 학번,
       S.student_name "학생 이름",
       round(avg(G.point),1) "전체 평점"
from tb_student S
    join tb_grade G
      on G.student_no = S.student_no
where S.department_no = (
                        select department_no
                        from tb_department
                        where department_name = '음악학과')
group by S.student_no, S.student_name
order by 1;
                        
--11
select D.department_name 학과이름,
       S.student_name 학생이름,
       P.professor_name 지도교수이름
from tb_student S
    join tb_department D
      on S.department_no = D.department_no
    join tb_professor P
      on S.coach_professor_no = P.professor_no
where S.student_no = 'A313047';

--12
select S.student_name,
       G.term_no
from tb_grade G
    join tb_student S
      on G.student_no = S.student_no
where G.term_no like '2007%' 
    and class_no = (
                        select class_no
                        from tb_class
                        where class_name = '인간관계론'
                        );

--13--
select C.class_name,
       D.department_name
from tb_department D
    join tb_class C
      on D.department_no = C.department_no
where category = '예체능';

--14
select S.student_name 학생이름,
    nvl(P.professor_name,'지도교수 미지정') 지도교수
from tb_student S
    join tb_professor P
      on S.coach_professor_no = P.professor_no
where S.department_no = (
                        select department_no
                        from tb_department
                        where department_name = '서반아어학과'
                        )
order by S.student_no;

--15
select S.student_no 학번,
       S.student_name 이름,
       D.department_name 학과이름,
       round(avg(G.point),8) 평점
from tb_student S
    join tb_grade G
      on S.student_no = G.student_no
    join tb_department D
      on D.department_no = S.department_no
where absence_yn ='N' 
group by S.student_no,S.student_name,  D.department_name 
having avg(point)>4;

--16
select C.class_no class_no,
       C.class_name class_name,
       round(avg(G.point),8)
from tb_grade G
    join tb_class C
      on G.class_no = C.class_no
    join tb_department D
      on D.department_no = C.department_no
where D.department_name = '환경조경학과'
group by C.class_no, C.class_name;

--17
select S.student_name,
       S.student_address
from tb_student S
    join tb_department D
      on D.department_no = S.department_no
where S.department_no
        = (
        select department_no
        from tb_student
        where student_name ='최경희');

--18
select student_no,
       student_name
from(
        select S.student_no,
               S.student_name,
               avg(point)
        from tb_student S
            join tb_grade G
              on S.student_no = G.student_no
            join tb_department D
              on D.department_no = S.department_no
        where D.department_name = '국어국문학과' 
        group by  S.student_no, S.student_name
        order by 3 desc
    )
where rownum = 1;

--19
select D.department_name "계절 학과명",
       round(avg(G.point),1) "전공평점"
from tb_grade G
    join tb_class C
      on G.class_no = C.class_no
    join tb_department D
      on C.department_no = D.department_no
where D.category = (
                    select category
                    from tb_department
                    where department_name = '환경조경학과'
                    )
group by D.department_name
order by 1;

