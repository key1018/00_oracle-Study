--       CHAR : 최대 2000BYTE의 크기, 고정 길이(지정한 크기보다 적게 입력되면 빈 공간은 공백으로 채움)
--              => 데이터의 크기가 명확할 때 사용
--   VARCHAR2 : 최대 4000BYTE의 크기, 가변 길이(지정한 크기보다 적게 입력되면 크기가 입력된 데이터 크기에 맞춰지게됨 - 공백으로 채워지지 않음!!)
--              => 데이터의 크기가 불명확할 때 사용
--      공통점 : 지정한 크기보다 크게 입력되면 오류 발생!

/*
    * DDL (DATA DEFINITION LANGUAGE) : 데이터 정의 언어
    오라클에서 제공하는 객체(OBJECT)를 새로이 생성(CREATE), 변경(ALTER), 삭제(DROP)하는 구문
    즉, 실제 데이터값이 아닌 구조 자체를 정의하는 언어
    
    오라클에서의 객체(구조) : 테이블(TABLE), 뷰(VIEW), 시퀀스(SEQUENCE),
                        인덱스(INDEX), 패키지(PACKAGE), 트리거(TRIGGER),
                        프로시져(PROCEDURE), 함수(FUNCTION), 동의어(SYNONYM), 사용자(USER)
                         
   < CREATE > 
   오라클에서 객체를 새로이 '생성'하는 구문
   
   1. 테이블 생성
        - 테이블이란? 행(ROW)과 열(COLUMN)로 구성되는 가장 기본적인 데이터베이스 객체
                    모든 데이터들은 테이블을 통해서 저장됨 EX) BR 계정의 EMPLOYEE, DEPARTMENT 등등
    
    [표현법]
    CREATE TABLE 테이블명(
        컬럼명 자료형(크기),
        컬럼명 자료형(크기),
        컬럼명 자료형(크기),
        ...
    );
    
        * 자료형(DATA TYPE)
    - 문자 (CHAR(바이트크기) | VARCHAR2(바이트크기)) -- 문자는 반드시 "크기 지정"해야함
      > CHAR : 최대 2000BYTE까지 지정 가능 / 고정 길지 (지정한 크기보다 더 적은 값이 들어오면 공백으로라도 채워 보관)
               고정된 글자수의 데이터만이 담길 경우 사용 (EX : 성별)
                
      > VARCHAR2 : 최대 4000BYTE까지 지정 가능 / 가변길이 (담기는 값에 따라서 공간의 크기가 맞춰짐)
                   몇글자의 데이터가 들어올지 모를 경우 사용
    - 숫자 (NUMBER)
    - 날짜 (DATE)
                            
*/

-- DDL계정에 회원에 대한 데이터를 담기 위한 테이블 MEMBER 생성하기 (테이블 및 컬럼명은 '_'를 자주 사용한다)
CREATE TABLE MEMBER(
    MEM_NO NUMBER,
    MEM_ID VARCHAR2(20),
    MEM_PWD VARCHAR2(20),
    MEM_NAME VARCHAR2(20),
    PHONE VARCHAR2(13),
    GENDER CHAR(3), -- 한글은 한 글자당 3BYTE
    EMAIL VARCHAR2(25)
);

SELECT * FROM MEMBER;

-- 데이터 딕셔너리 : 다양한 객체들의 정보를 저장하고있는 시스템테이블
-- [참고] USER_TABLES : 이 사용자가 가지고 있는 테이블들의 전반적인 구조를 확인할 수 있는 시스템 테이블
SELECT * FROM USER_TABLES;
-- [참고] USER_TAB_COLUMNS : 이 사용자가 가지고 있는 테이블의 모든 컬럼의 전박적인 구조를 확인할 수 있는 시스템 테이블
SELECT * FROM USER_TAB_COLUMNS;

--------------------------------------------------------------------------------
/*
    2. 컬럼에 주석 달기 (컬럼에 대한 설명 달기) - COMMIT에 주석넣기
    
    [표현법]
    COMMENT ON COLUMN 테이블명.컬럼명 IS '주석내용';
    
    >> 잘못 작성했을 경우 표현법을 다시 작성하는 것이 아니라 주석내용만 수정하면됨!
*/  
COMMENT ON COLUMN MEMBER.MEM_NO IS '회원번호';
COMMENT ON COLUMN MEMBER.MEM_ID IS '회원아이디';
COMMENT ON COLUMN MEMBER.MEM_PWD IS '회원비밀번호';
COMMENT ON COLUMN MEMBER.MEM_NAME IS '회원이름';
COMMENT ON COLUMN MEMBER.PHONE IS '핸드폰번호';
COMMENT ON COLUMN MEMBER.GENDER IS '성별';
COMMENT ON COLUMN MEMBER.EMAIL IS '이메일';

-- 테이블에 데이터 추가시키는 구문 (DML : INSERT)
-- INSERT INTO 테이블명 VALUES(값, 값, 값, ...);
INSERT INTO MEMBER VALUES(1, 'user01', 'pass01', '홍길동', '010-1111-2222', '남', 'aaa@naver.com');
INSERT INTO MEMBER VALUES(NULL, 'user01', NULL, '홍길녀', NULL,'F', NULL); -- 부정확한데이터
-->> 완벽한 테이블을 만들기 위해서는 '제약조건'을 고려해야함

--------------------------------------------------------------------------------\
/*
    < 제약조건 CONSTRAINTS >
    - 원하는 데이터값(유효한 형식의 값)만 유지하기 위해서 특정 칼럼에 설정하는 조건
    
    * 종류 : NOT NULL(데이터에 NULL 입력 불가능), UNIQUE(데이터중복X), CHECK(해당 조건에 만족하는 데이터만 들어오기),
            PRIMARY KEY(데이터에 NULL과 중복 불가능), FOREIGN KEY
            
    제약조건을 부여하는 방식은 크게 2가지가 있음 (컬럼레벨 방식 / 데이터레벨 방식)
    --> NOT NULL은 '컬럼레벨 방식만 가능'하다!!
*/

/*
    * NOT NULL 제약조건
      특정 컬럼에 반드시 값이 존재해야만 하는 경우 (즉, 해당 컬럼에 절대 NULL이 들어와서는 안되는 경우)
      데이터 삽입 / 수정시 NULL을 허용하지 않도록 제한
      
     >> 주의사항 : NOT NULL은 오로지 컬럼레벨방식 밖에 안됨

    * UNIQUE 제약조건
      특정 컬럼에 중복된 값이 들어가서는 안되는 경우
      컬럼값에 중복값을 제한      
*/

-- 테이블 생성
--> 컬럼레벨 방식 -- 제약조건은 따로 ','대신 공백을 통해 나눈다
CREATE TABLE MEM_UNIQUE_NOTNULL(
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3),
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(30)
);
-->> NOT NULL을 제한조건으로 설정한 후 : NULLABLE의 값이 YES -> NO 변경됨

-- 테이블 삭제
DROP TABLE MEM_UNIQUE_NOTNULL;

--> 테이블레벨 방식 : 모든 컬럼들 다 나열한 후 마지막에 기술
--                  제약조건 (컬럼명)
CREATE TABLE MEM_UNIQUE_NOTNULL(
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3),
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(30),
    UNIQUE(MEM_ID) -->> 테이블레벨 방식 (NOT NULL은 불가능)
);

-- 테이블에 주석달기
COMMENT ON COLUMN MEM_UNIQUE_NOTNULL.MEM_NO IS '회원번호';
COMMENT ON COLUMN MEM_UNIQUE_NOTNULL.MEM_ID IS '회원아이디';
COMMENT ON COLUMN MEM_UNIQUE_NOTNULL.MEM_PWD IS '회원비밀번호';
COMMENT ON COLUMN MEM_UNIQUE_NOTNULL.MEM_NAME IS '회원명';
COMMENT ON COLUMN MEM_UNIQUE_NOTNULL.GENDER IS '성별';
COMMENT ON COLUMN MEM_UNIQUE_NOTNULL.PHONE IS '핸드폰번호';
COMMENT ON COLUMN MEM_UNIQUE_NOTNULL.EMAIL IS '이메일';

-- 테이더 삽입
INSERT INTO MEM_UNIQUE_NOTNULL VALUES (1, 'user01', 'pass01', '홍길동', '남', '010-1111-2222', 'goodee@goodee.com');
INSERT INTO MEM_UNIQUE_NOTNULL VALUES (2, 'user02', null, null, '여', null, null);
-- ** NOT NULL 오류 보고 ** -
-- ORA-01400: cannot insert NULL into ("DDL"."MEM_UNIQUE_NOTNULL"."MEM_PWD")
-->> NOT NULL이라는 제한 조건을 설정했기 때문에 NULL값이 들어가면 오류 발생!
INSERT INTO MEM_UNIQUE_NOTNULL VALUES (2, 'user02', 'pass02', '홍길녀', '여', null, null);
-->> NULL값 대신 데이터를 삽입하면 정상 작동됨

INSERT INTO MEM_UNIQUE_NOTNULL VALUES (3, 'user02', 'pass03', '강개똥', '여', null, null);
-- ** UNIQUE 오류 보고 ** -
-- 아이디 중복 입력으로 오류 발생
-- ORA-00001: unique constraint (DDL.SYS_C007111) violated  ==> 여기서 아이디의 임의의 제약조건명은 SYS_C007111 이다
-->> UNIQUE 제약조건에서 오류발생하는 경우 :  오류 구문을 컬럼명대신 '제약조건명'을 알려줌 (쉽게 파악하기 어려움)
-- 제약조건 부여시 제약조건명을 지정해주지 않으면 시스템에서 임의의 제약조건명을 부여해버림

/*
    * 제약조건 부여시 제약조건명까지 지어주는 방법
    
    > 컬럼레벨 방식
    CREATE TABLE 테이블명 (
        컬럼명 자료형 [CONSTRAINT 제약조건명] 제약조건, -- 제약조건명은 생략 가능!
        컬럼명 자료형,
        컬럼명 자료형,
        ...
    );
    
    > 테이블레벨 방식
    CREATE TABLE 테이블명 (
        컬럼명 자료형,
        컬럼명 자료형,
        컬럼명 자료형,
        ...
        [CONSTRAINT 제약조건명] 제약조건(컬럼명) -- 제약조건명은 생략 가능!
    );
*/

-- 테이블 삭제
DROP TABLE MEM_UNIQUE_NOTNULL;

-->> 컬럼레벨 방식 : 제약조건이 2개인 경우 따로따로 달아줌
CREATE TABLE MEM_UNIQUE_NOTNULL(
    MEM_NO NUMBER CONSTRAINT MEMNO_NN NOT NULL,
    MEM_ID VARCHAR2(20) CONSTRAINT MEMID_NN NOT NULL CONSTRAINT MEMID_UQ UNIQUE,
    MEM_PWD VARCHAR2(20) CONSTRAINT MEMPWD_NN NOT NULL,
    MEM_NAME VARCHAR2(20) CONSTRAINT MEMNAME_NN NOT NULL,
    GENDER CHAR(3),
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(30)
);

INSERT INTO MEM_UNIQUE_NOTNULL VALUES (1, 'user01', 'pass01', '홍길동', null, null, null);
INSERT INTO MEM_UNIQUE_NOTNULL VALUES (2, 'user01', 'pass02', '강개똥', null, null, null);
-- UNIQUE 오류 보고 --
-- ORA-00001: unique constraint (DDL.MEMID_UQ) violated => 임의의 제약조건명 대신 제시한 제약조건명인 'MEMID_UQ'이 나옴


-- 테이블 삭제
DROP TABLE MEM_UNIQUE_NOTNULL;

-->> 테이블레벨 방식
CREATE TABLE MEM_UNIQUE_NOTNULL(
    MEM_NO NUMBER CONSTRAINT MEMNO_NN NOT NULL,
    MEM_ID VARCHAR2(20) CONSTRAINT MEMID_NN NOT NULL,
    MEM_PWD VARCHAR2(20) CONSTRAINT MEMPWD_NN NOT NULL,
    MEM_NAME VARCHAR2(20) CONSTRAINT MEMNAME_NN NOT NULL,
    GENDER CHAR(3),
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(30),
    CONSTRAINT MEMID_UQ UNIQUE(MEM_ID)
);

INSERT INTO MEM_UNIQUE_NOTNULL VALUES (1, 'user01', 'pass01', '홍길동', null, null, null);
INSERT INTO MEM_UNIQUE_NOTNULL VALUES (2, 'user01', 'pass02', '강개똥', null, null, null);
--> 오류 발생
INSERT INTO MEM_UNIQUE_NOTNULL VALUES (2, 'user02', 'pass02', '강개똥', null, null, null);
--> 정상적으로 데이터 삽입 가능!