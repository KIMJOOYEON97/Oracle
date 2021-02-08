--@실습문제 : tb_number테이블에 난수 100개(0~999)를 저장하는 익명블럭을 생성하세요.
--실행시마다 생성된 모든 난수의 합을 콘솔에 출력
create table tb_number(
    id number, --pk sequence 객체로 부터 채번
    num number, --난수
    reg_date date default sysdate,
    constraints pk_tb_number_id primary key(id)
);

desc tb_number;

--1. pk sequence 객체 생성
create sequence seq_rnd;

--drop sequence seq_rnd;
select * from tb_number;

declare
   summ number := 0;
   rnd number; 
begin
  for n in 1..100 loop
-- 2. 난수 100개 저장하는 익명 블럭
    rnd := trunc(dbms_random.value(0,1000));
    dbms_output.put_line('합 : '||summ);
    insert into tb_number(id, num)
    values(seq_rnd.nextval,rnd);    
    summ := summ + rnd;   
  end loop;
  dbms_output.put_line('총합 : '||summ);
-- 3. transaction 처리
  commit;
end;
/
