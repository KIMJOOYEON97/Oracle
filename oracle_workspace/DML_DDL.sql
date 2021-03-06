--1. 첫번째 테이블 명 : EX_MEMBER
--* MEMBER_CODE(NUMBER) - 기본키                       -- 회원전용코드 
--* MEMBER_ID (varchar2(20) ) - 중복금지                  -- 회원 아이디
--* MEMBER_PWD (char(20)) - NULL 값 허용금지                 -- 회원 비밀번호
--* MEMBER_NAME(varchar2(30))                             -- 회원 이름
--* MEMBER_ADDR (varchar2(100)) - NULL값 허용금지                    -- 회원 거주지
--* GENDER (char(3)) - '남' 혹은 '여'로만 입력 가능             -- 성별
--* PHONE(char(11)) - NULL 값 허용금지                   -- 회원 연락처

create table EX_MEMBER(
  member_code number,  
  member_id varchar2(20),
  member_pwd char(20) not null,
  member_name varchar2(30),
  memner_addr varchar2(100) not null,
  gender char(3),
  phone char(11) not null,
  constraints pk_member_code primary key(member_code),
  constraints uq_member_id unique (member_id),
  constraints ck_gender check(gender in ('남','여'))
); 
--drop table EX_MEMBER;
select constraint_name,
       uc.table_name,
       ucc.column_name,
       uc.constraint_type,
       uc.search_condition
from user_constraints uc
    join user_cons_columns ucc
        using(constraint_name)
where uc.table_name = 'EX_MEMBER';

--2. EX_MEMBER_NICKNAME 테이블을 생성하자. (제약조건 이름 지정할것)
--(참조키를 다시 기본키로 사용할 것.)
--* MEMBER_CODE(NUMBER) - 외래키(EX_MEMBER의 기본키를 참조), 중복금지       -- 회원전용코드
--* MEMBER_NICKNAME(varchar2(100)) - 필수                       -- 회원 이름
create table EX_MEMBER_NICKNAME(
    member_code number,
    member_nickname varchar2(100),
    constraint pk_member_nickname primary key(member_nickname),
    constraint fk_member_code foreign key (member_code)
                              references EX_MEMBER(member_code)
);
select constraint_name,
       uc.table_name,
       ucc.column_name,
       uc.constraint_type,
       uc.search_condition
from user_constraints uc
    join user_cons_columns ucc
        using(constraint_name)
where uc.table_name = 'EX_MEMBER_NICKNAME';