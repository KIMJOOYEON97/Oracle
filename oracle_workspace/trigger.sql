--@실습문제:
--emo_copy에서 사원을 삭제할 경우, emp_copy_del 테이블로 데이터를 이전시키는 trigger를 생성하세요
--quit_date에 현재날짜를 기록할 것

--사원삭제 로그 테이블
--drop table emp_copy_del_log
create table emp_copy_del_log
as
select E.*
from emp_copy E
where 1=2;

create or replace trigger trig_emp_del
   before
   delete on emp_copy
   for each row
begin
   dbms_output.put_line('삭제할 사원:' || :old.emp_name);

   insert into emp_copy_del_log(emp_id, emp_name, emp_no, email, phone, dept_code, 
                                job_code,sal_level,salary,bonus,manager_id,hire_date,quit_date)
   values(:old.emp_id, :old.emp_name, :old.emp_no, :old.email, :old.phone, :old.dept_code, 
                                :old.job_code, :old.sal_level,:old.salary,:old.bonus,:old.manager_id,:old.hire_date, sysdate);
end;
/

--사원 삭제
delete from emp_copy
where emp_id = '&사원번호';


select * from emp_copy;
select * from emp_copy_del_log;

rollback;