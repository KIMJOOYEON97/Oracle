--1. 계열 정보를 저장핛 카테고리 테이블을 맊들려고 핚다. 다음과 같은 테이블을 작성하시오
create table tb_category(
    name varchar2(10),
    use_yn char(1) default 'Y'
);

desc tb_category;
--chun 계정의 모든제약조건 확인
select * from user_constraints;

--chun 계정의 특정 테이블 제약조건 검색
select constraint_name,
            uc.table_name,
            ucc.column_name,
            uc.constraint_type,
            uc.search_condition
from user_constraints uc
    join user_cons_columns ucc
        using(constraint_name)
where uc.table_name = 'TB_CATEGORY';

--2. 과목 구분을 저장핛 테이블을 맊들려고 핚다. 다음과 같은 테이블을 작성하시오.
create table tb_class_type(
    no varchar2(5),
    name varchar2(10),
    constraint pk_no primary key(no)
);

desc tb_class_type;

--3.  TB_CATAGORY 테이블의 NAME 컬럼에 PRIMARY KEY 를 생성하시오.
--(KEY 이름을 생성하지 않아도 무방함. 맊일 KEY 이를 지정하고자 핚다면 이름은 본인이
--알아서 적당핚 이름을 사용핚다.)

alter table tb_category
add constraints pk_name primary key(name);

--4. TB_CLASS_TYPE 테이블의 NAME 컬럼에 NULL 값이 들어가지 않도록 속성을 변경하시오.
alter table tb_class_type
modify name varchar2(10) not null;

--5. 두 테이블에서 컬럼 명이 NO 인 것은 기존 타입을 유지하면서 크기는 10 으로, 컬럼명이
--NAME 인 것은 마찪가지로 기존 타입을 유지하면서 크기 20 으로 변경하시오.
alter table tb_category
modify name varchar2(10);

alter table tb_class_type
modify (no varchar2(10), name varchar(20));

--6. 두 테이블의 NO 컬럼과 NAME 컬럼의 이름을 각 각 TB_ 를 제외핚 테이블 이름이 앞에
--붙은 형태로 변경핚다.
--(ex. CATEGORY_NAME)
alter table tb_category
rename column name to category_name;

alter table tb_class_type
rename column name to tb_class_type_name;

alter table tb_class_type
rename column no to tb_class_type_no;

--7. TB_CATAGORY 테이블과 TB_CLASS_TYPE 테이블의 PRIMARY KEY 이름을 다음과 같이
--변경하시오.
--Primary Key 의 이름은 ‚PK_ + 컬럼이름‛으로 지정하시오. (ex. PK_CATEGORY_NAME )

SELECT TABLE_NAME,
           CONSTRAINT_NAME, 
           CONSTRAINT_TYPE,
           COLUMN_NAME
FROM USER_CONSTRAINTS
JOIN USER_CONS_COLUMNS 
USING (CONSTRAINT_NAME, TABLE_NAME)
WHERE TABLE_NAME = 'TB_CATEGORY'
OR TABLE_NAME = 'TB_CLASS_TYPE';

alter table tb_category
rename constraints PK_NAME to pk_tb_category_name;

alter table tb_class_type
rename constraints PK_NO to pk_tb_class_type_no;

--8. 다음과 같은 INSERT 문을 수행핚다
--ORA-12899: value too large for column "CHUN"."TB_CATEGORY"."CATEGORY_NAME" (actual: 12, maximum: 10)
--자연과학과 인문사회가 들어가지 않아서 컬럼 기본값을 수정하였다.
alter table tb_category
modify category_name varchar2(20);

INSERT INTO TB_CATEGORY VALUES ('공학','Y');
INSERT INTO TB_CATEGORY VALUES ('자연과학','Y');
INSERT INTO TB_CATEGORY VALUES ('의학','Y');
INSERT INTO TB_CATEGORY VALUES ('예체능','Y');
INSERT INTO TB_CATEGORY VALUES ('인문사회','Y');
COMMIT;

--9.TB_DEPARTMENT 의 CATEGORY 컬럼이 TB_CATEGORY 테이블의 CATEGORY_NAME 컬럼을 부모
--값으로 참조하도록 FOREIGN KEY 를 지정하시오. 이 때 KEY 이름은
--FK_테이블이름_컬럼이름으로 지정핚다. (ex. FK_DEPARTMENT_CATEGORY )

select * from tb_department;
select * from tb_category;

--tb_category 테이블의 제약조건 
select constraint_name,
       uc.table_name,
       ucc.column_name,
       uc.constraint_type,
       uc.search_condition
from user_constraints uc
    join user_cons_columns ucc
        using(constraint_name)
where uc.table_name = 'TB_CATEGORY'; 

--tb_department 테이블의 제약조건 
select constraint_name,
       uc.table_name,
       ucc.column_name,
       uc.constraint_type,
       uc.search_condition
from user_constraints uc
    join user_cons_columns ucc
        using(constraint_name)
where uc.table_name = 'TB_DEPARTMENT'; --''안의 값은 반드시 대문자이어야한다. 그래야 검색됌..


alter table tb_department
add constraint fk_department_category foreign key(category)
                                       references tb_category(category_name);



--10. 춘 기술대학교 학생들의 정보맊이 포함되어 있는 학생일반정보 VIEW 를 맊들고자 핚다.
--아래 내용을 참고하여 적젃핚 SQL 문을 작성하시오.

--부여받은 롤에 포함된 권한
select *
from role_sys_privs; 

--view생성권한이 없다는
--생성권한 system으로 부여하기
--grant create view to 계정명;
--grant create view to chun;


create or replace view VW_학생일반정보
as
select student_no, student_name, student_address
from tb_student;

select *
from VW_학생일반정보;

--11. 춘 기술대학교는 1 년에 두 번씩 학과별로 학생과 지도교수가 지도 면담을 진행핚다.
--이를 위해 사용핛 학생이름, 학과이름, 담당교수이름 으로 구성되어 있는 VIEW 를 맊드시오.
--이때 지도 교수가 없는 학생이 있을 수 있음을 고려하시오 (단, 이 VIEW 는 단순 SELECT
--맊을 핛 경우 학과별로 정렬되어 화면에 보여지게 맊드시오.)

create or replace view VW_지도면담
as
select student_name, --별칭. 안해도 된다.
       department_name,
       professor_name
from tb_student S
    left join tb_department D
           on S.department_no = D.department_no
    left join tb_professor P
           on S.coach_professor_no = P.professor_no
order by department_name; --view도 order by 가능하다

select *
from VW_지도면담;


--12. 모든 학과의 학과별 학생 수를 확인핛 수 있도록 적젃핚 VIEW 를 작성해 보자.
--뷰 이름
--VW_학과별학생수
--컬럼
--DEPARTMENT_NAME
--STUDENT_COUNT
--25

create or replace view VW_학과별학생수
as
select department_name,
       count(student_no) student_count
from tb_student
    join tb_department using(department_no)
group by department_name;

select *
from VW_학과별학생수;


--13. 위에서 생성핚 학생일반정보 View 를 통해서 학번이 A213046 인 학생의 이름을 본인
--이름으로 변경하는 SQL 문을 작성하시오.
update VW_학생일반정보
set student_name = '김주연'
where student_no = 'A213046';

select student_name
from VW_학생일반정보
where student_no = 'A213046';

--14. 13 번에서와 같이 VIEW 를 통해서 데이터가 변경될 수 있는 상황을 막으려면 VIEW 를
--어떻게 생성해야 하는지 작성하시오.

create or replace view VW_학생일반정보
as
select student_no, student_name, student_address
from tb_student
with read only;

--15. 춘 기술대학교는 매년 수강신청 기갂맊 되면 특정 인기 과목들에 수강 신청이 몰려
--문제가 되고 있다. 최근 3 년을 기준으로 수강인원이 가장 맋았던 3 과목을 찾는 구문을
--작성해보시오.  2009 2008 2007
--과목번호 과목이름 누적수강생수(명)
------------ ------------------------------ ----------------
--C1753800 서어방언학 29
--C1753400 서어문체롞 23
--C2454000 원예작물번식학특롞 22

select *
from(
        select C.class_no 과목번호,
               C.class_name 과목이름,
               count(G.student_no) "누적수강생 수(명)"
        from tb_class C
            left join tb_grade G 
              on C.class_no = G.class_no
        where substr(G.term_no,1,4) in('2009','2008','2007')
        group by C.class_no, C.class_name
        order by 3 desc
)
where rownum <=3;


SELECT *
FROM (
    SELECT CLASS_NO 과목번호, CLASS_NAME 과목이름, COUNT(STUDENT_NO) "누적수강생수(명)"
    FROM TB_CLASS 
        LEFT JOIN TB_GRADE  USING (CLASS_NO)
    WHERE SUBSTR(TERM_NO, 1, 4) IN (SELECT 년도
                                  FROM (SELECT DISTINCT SUBSTR(TERM_NO, 1, 4) 년도
                                            FROM TB_GRADE
                                            ORDER BY 1 DESC)
                                  WHERE ROWNUM <= 3)
    GROUP BY CLASS_NO, CLASS_NAME
    ORDER BY 3 DESC)
WHERE ROWNUM <= 3;


select *
from tb_grade;