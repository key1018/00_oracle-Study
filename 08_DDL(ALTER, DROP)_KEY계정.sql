/*
    * DDL (DATA DEFINITION LANGUAGE : 데의터정의언어)
    
    < ALTER >
    오라클에서 객체(구조)를 변경하고자 할 때 사용되는 구문
    
    [표현법]
    ALTER TABLE 테이블명 변경할내용;
    
    * 변경할 내용
    1) 컬럼 추가/수정/삭제
    2) 제약조건 추가/삭제   -> 수정은 불가능 (수정하려면 삭제한 후 새로이 추가해야됨)
    3) 컬럼명/제약조건명/테이블명 변경
*/

-- 1) 컬럼 추가/수정/삭제
-- 1_1) 컬럼 추가 (ADD) : ADD 컬럼명 데이터타입 [ DEFAULT 기본값 ]
-- EMP_DEPT에 CNAME 컬럼 추가
ALTER TABLE EMP_DEPT ADD CNAME VARCHAR2(20);
--> 새로운 컬럼이 만들어지고 기본적으로 NULL로 채워짐

-- EMP_DEPT에 LNAME 컬럼 추가 (DEFAULT 기본값 추가)
ALTER TABLE EMP_DEPT ADD LNAME VARCHAR2(20) DEFAULT '한국';

-- 1_2) 컬럼 수정 (MODIFY)
--      > 데이터타입 수정 : MODIFY 컬럼명 바꾸고자하는데이터타입
--      > DEFAULT값 수정 : MODIFY 컬럼명 DEFAULT 바꾸고자하는기본값

-- EMP_DEPT의 DEPT_ID의 데이터타입변경
ALTER TABLE EMP_DEPT DISABLE CONSTRAINT SYS_C007197 CASCADE;
ALTER TABLE EMP_DEPT MODIFY DEPT_ID CHAR(3);

-- EMP_DEPT의 DEPT_TITLE 컬럼을 VARCHAR2(35)로
-- LOCATION_ID의 컬럼을 VARCHAR2(4)로 변경
-- LNAME의 컬럼을 '중국'으로 변경
ALTER TABLE EMP_DEPT MODIFY DEPT_TITLE VARCHAR2(40)
                     MODIFY LOCATION_ID VARCHAR2(4)
                     MODIFY LNAME DEFAULT '중국'; --> 동일한 테이블의 값을 변경할 때는 다중변경 가능
--> LNAME을 추가하는 순간 '한국'이 데이터로 들어갔기 때문에 DEFAULT로 변경했다고해도 데이터가 이미 들어간 값은 변경 안됨

-- 1_3) 컬럼 삭제 (DROP COLUMN) : DROP COLUMN 삭제하고자하는컬럼명
ALTER TABLE EMP_DEPT DROP COLUMN CNAME;
ALTER TABLE EMP_DEPT DROP COLUMN LNAME;
--> 컬럼 삭제는 다중명령문으로 삭제 불가능!!!!

-- 컬럼 삭제 취소하기
ROLLBACK;   --> 삭제한 컬럼은 복구 불가능
--> ROLLBACK으로 데이터를 이전 상태로 돌아가는 방법은 DML(DELETE, UPDATE, INSERT)구문만 가능
--> DDL(ALTER, DROP)구문의 경우 실행시키는 순간 COMMIT까지 동시에 진행됨

--------------------------------------------------------------------------------

-- 2) 제약조건 추가/삭제    => 수정은 불가능!! EX) UNIQUE => NOT NULL로 수정 안됨

/*
    2_1) 제약조건 추가
    PRIMARY KEY : ADD PRIMARY KEY(컬럼명)
    FOREIGN KEY : ADD FOREIGN KEY(컬럼명) REFERENCES 참조할테이블 [(참조할컬럼명)] [삭제 옵션]
    UNIQUE      : ADD UNIQUE(컬럼명)
    CHECK       : ADD CHECK(컬럼에대한조건)
    NOT NULL    : MODIFY 컬럼명 NOT NULL
    NULL        : MODIFY 컬럼명 NULL
*/

-- EMPLOYEE_COPY2 테이블로부터
-- DEPT_CODE에 FOREIGN KEY 제약조건추가 ADD
-- MANAGER_ID에 NOT NULL 제약조건 추가 MODIFY
ALTER TABLE EMPLOYEE_COPY2 ADD MANAGER_ID VARCHAR2(20);
ALTER TABLE EMP_DEPT ENABLE CONSTRAINT SYS_C007197;
ALTER TABLE EMPLOYEE_COPY2
        ADD FOREIGN KEY(DEPT_CODE) REFERENCES EMP_DEPT(DEPT_ID)
        MODIFY MANAGER_ID NOT NULL;
             --> 다중 명령문 가능

-- 2_2) 제약조건 삭제 : DROP CONSTRAINT 제약조건명 / MODIFY 컬럼명 NULL (NOT NULL 제약조건일 경우)
ALTER TABLE DEPT_COPY DROP CONSTRAINT DCOPY_PK;
ALTER TABLE DEPT_COPY 
        DROP CONSTRAINT DCOPY_UQ
        MODIFY LNAME NULL;      --> 다중 명령문 가능

-- 2_2) 제약조건 삭제 : DROP CONSTRAINT 제약조건명 / MODIFY 컬럼명 NULL (NOT NULL 제약조건일 경우)
ALTER TABLE EMPLOYEE_COPY2 DROP CONSTRAINT SYS_C007178;
ALTER TABLE EMPLOYEE_COPY2 MODIFY MANAGER_ID NULL;

--------------------------------------------------------------------------------

/*
    3. 컬럼명 / 제약조건명 / 테이블명 변경 ( RENAME )
*/

-- 3_1) 컬럼명 변경 : RENAME COLUMN 기존컬럼명 TO 바꿀컬럼명;
ALTER TABLE EMP_DEPT RENAME COLUMN DEPT_TITLE TO 부서명;

-- 3_2) 제약조건명 변경 : RENAME CONSTRAINT 기존제약조건명 TO 바꿀제약조건명;
ALTER TABLE EMP_DEPT RENAME CONSTRAINT SYS_C007197 TO EMPDEPT_PK;

-- 3_3) 테이블명 변경 : RENAME TABLE [기존테이블명] TO 바꿀테이블명;
ALTER TABLE EMP_DEPT RENAME TO DEPT_COPY;

--------------------------------------------------------------------------------

-- 테이블 삭제
DROP TABLE DEPT_COPY;
-- 참조되고있는 부모테이블이 아니므로 삭제가 잘됨
-- 단, 어딘가에  참조되고있는 부모테이블은 함부로 삭제 안됨!!!!

-- 만약에 삭제하고자 한다면
-- 방법1. 자식테이블을 먼저 삭제한 후 부모테이블 삭제하는 방법
-- 방법2. 그냥 부모테이블만 삭제하는데 제약조건까지 같이 삭제하는 방법
--       DROP TABLE 테이블명 CASCADE CONSTRAINT;    => 자식테이블은 유지, 부모테이블 및 맞물려있는 제약조건까지 삭제
