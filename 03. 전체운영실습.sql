show databases;
use shopdb;
show tables;

-- 1. Database 구축
-- 1) Data 활용

-- 데이타 조회
select * from memberTbl;
select memberName, memberAddress from membertbl;
select * from membertbl where membername='Park';

-- 데이타 입력
insert into membertbl values('10005', 'Hong', '경기 군포시');

-- 데이타 수정
update membertbl set memberaddress='서울 마포구' where membername='Hong';

-- 데이타 삭제
delete from membertbl where membername='Hong';

-- 2) Index 생성
-- table 생성
create table indextbl 
(
	first_name varchar(14),
	last_name varchar(16),
	hire_date DATE
);

-- data insert
insert into indextbl
select first_name, last_name, hire_date
  from employees.employees;

-- data 확인
select * from indextbl;

-- 실행경로 확인(인덱스 생성전)
explain select * from indextbl where first_name = 'Mary';

-- index 생성
create index idx_indextbl_first_name on indextbl(first_name);

-- 실행경로 확인(인덱스 생성후)
explain select * from indextbl where first_name = 'Mary';

-- 3) View
-- view 생성
create view uv_member
as
select memberid, memberaddress 
  from membertbl;

 -- view 조회
select * from uv_member;

-- 3) Stored Procedure
-- 프로그램
DELIMITER //
CREATE PROCEDURE myproc()
BEGIN
    SELECT * FROM membertbl WHERE membername = 'Lee';
    SELECT * FROM producttbl WHERE productname = '냉장고';
END //
DELIMITER ;

-- 프로시저 실행
CALL myproc();

-- 4) Trigger
-- 백업 테이블 생성
CREATE TABLE deletedMemberTBL
(memberID CHAR(8),
  memberName CHAR(5),
  memberAddress CHAR(20),
  deleteDate date
  );
 
-- trigger 생성
DELIMITER //
CREATE TRIGGER trg_deletedMemberTBL		-- 트리거 이름
AFTER DELETE							-- 삭제 후에 작동하게 지정
ON memberTBL							-- 트리거를 부착할 테이블
FOR EACH ROW							-- 각 행마다 적용
BEGIN
INSERT INTO deletedMemberTBL
	  -- OLD 테이블의 내용을 백업테이블에 삽입
      VALUES (OLD.memberID, OLD.memberName, OLD.memberAddress, CURDATE() );
 END //
 
 DELIMITER ; 

-- membertbl 데이타 확인 
select * from membertbl;

-- delete membertbl
delete from membertbl where membername='Lee';

-- membertbl 데이타 확인 
select * from membertbl;

-- deletedMemberTBL 데이타 확인
select * from deletedMemberTBL;