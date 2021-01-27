--===========================================================================
--system 관리자 계정
--===========================================================================
-- 한줄 주석
/*
여러줄 주석
*/

show user;

-- 현재 등록된 사용자목록 조회
-- sys  슈퍼관리자 : db 생성/삭제 권한 있음.
-- DB자체를 여러가지 만들 수 있음 -> 할 수 있는 것 더 많아서 실수하면 큰일

-- system 일반관리자 : db 생성/삭제 권한 없음.
-- 우리는 일반 관리자
select * 
from dba_users;

--sql은 대소문자를 구분하지 않는다
--사용자 계정의 비밀번호, 테이블내의 데이터는 대소문자 구분한다.
SELECT *
FROM DBA_USERS;

--관리자는 일반사용자를 생성할 수 있다
create user kh
identified by kh --비밀번호(대소문자 구분)
default tablespace users; --데이터가 저장될 영역 system | users

create user qwerty
identified by qwerty
default tablespace users;

--drop user qwerty;

--사용자 삭제
--drop user kh; ctrl+/ => 주석 단축키

--접속권한 create session이 포함된 role(권한묶음)connect부여
--grant connect to kh;
--grant connect to qwerty;

--테이블등 객체 생성권한이 포함된 role resource 부여
grant resource to kh;
--테이블 생성권한만 부여
--grant create table to kh;

--한번에 부여하기
grant connect resource to kh;

--chun계정 생성
creat user chun
identified by chun
default table users;

--connect, resource를 부여
grant connect, resource to chun;

--role(권한 묶음)에 포함된 권한 확인
--DataDictionary db의 각 객체에 대한 메타정보를 확인할 수 있는 read-me 테이블
select *
from dba_sys_privs
where grantee in('CONNECT','RESOURCE');

