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

--------------------------------------------------------------------------------

/*
    * CHECK(조건식) 제약조건
    해당 컬럼에 들어올 수 있는 값에 대한 조건을 제시해줄 수 있음
    해당 조건에 만족하는 데이터값만 담길 수 있음

    --> 컬럼명 자료형 CHECK(컬럼명 IN (조건))

    * PRIMARY KEY (기본키) 제약조건
      테이블에서 각 행들을 식별하기 위해 사용될 컬럼에 부여하는 제약조건 (식별자의 역할 컬럼)
      
      EX) 회원번호, 학번, 사원번호, 주문번호, 예약번호, 운송장번호, ...
      
      PRIMARY KEY 제약조건을 부여하면 그 컬럼에 자동으로 NOT NULL + UNIQUE 제약조건을 의미
      
      > 유의사항 : 한 테이블당 오로지 한 개만 설정 가능
*/

CREATE TABLE MEM_PRI_CHECK(
    MEM_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL CONSTRAINT MEMID_UQ2 UNIQUE,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('여', '남')),
    PHONE VARCHAR2(13)
);
SELECT * FROM MEM_PRI_CHECK;

COMMENT ON COLUMN MEM_PRI_CHECK.MEM_NO IS '회원번호';
COMMENT ON COLUMN MEM_PRI_CHECK.MEM_ID IS '아이디';
COMMENT ON COLUMN MEM_PRI_CHECK.MEM_PWD IS '비밀번호';
COMMENT ON COLUMN MEM_PRI_CHECK.MEM_NAME IS '회원명';
COMMENT ON COLUMN MEM_PRI_CHECK.GENDER IS '성별';
COMMENT ON COLUMN MEM_PRI_CHECK.PHONE IS '연락처';

INSERT INTO MEM_PRI_CHECK VALUES(1, 'uesr01', 'pass01', '홍길동', '남', null);
INSERT INTO MEM_PRI_CHECK VALUES(1, 'uesr02', 'pass02', '홍길녀', '여', null); -- 유효한 데이터 X
-- 오류 보고 -
-- ORA-00001: unique constraint (DDL.SYS_C007128) violated
--> PRIMAEY KEY는 NOT NULL & UNIQUE 제약조건이 설정되어있는데 '1'이라는 중복값이 입력되어 오류 발생
INSERT INTO MEM_PRI_CHECK VALUES(2, 'uesr02', 'pass02', '홍길녀', 'F', null); -- 유효한 데이터 X
-- 오류 보고 -
-- ORA-02290: check constraint (DDL.SYS_C007127) violated
-- CHECK 제약조건을 이용하여 '남', '여'의 데이터만 입력될 수 있도록 설정했기때문에 그 외의 데이터가 들어가면 오류발생
INSERT INTO MEM_PRI_CHECK VALUES(2, 'uesr02', 'pass02', '홍길녀', '여', null);
INSERT INTO MEM_PRI_CHECK VALUES(3, 'uesr03', 'pass03', '강개똥', '남', null);
INSERT INTO MEM_PRI_CHECK VALUES(4, 'uesr04', 'pass04', '강개똥', NULL , null);
--> 기본적으로 NULL 허용 => NULL이 못들어오게 하려면 NOT NULL 제약조건까지 부여
-- 체크제약 조건은 비교연산자도 가능
-- EX) EMPLOYEE CHECK IN (SALARY >= 2000000);

--------------------------------------------------------------------------------

-- 복합기(여러컬럼을 묶어서 PRIMARY KEY로 지정) 사용 예시 --> 테이블레벨 방식 밖에 안됨!!
-- "어떤 회원이" "어떤 상품을" 어느날짜에 찜했는지 보관하는 테이블
CREATE TABLE TB_LIKE(
    MEM_NO NUMBER,
    MEM_ID VARCHAR2(20) NOT NULL,
    PRODUCT_NAME VARCHAR2(30),
    LIKE_DATE DATE,
    PRIMARY KEY(MEM_NO, PRODUCT_NAME) --> 테이블레벨 방식
);

/*
    복합기의 경우는 PRIMARY KEY로 지정한 컬럼의 데이터가 
    '동시에 중복' 되어서는 안됨
    
    EX) MEM_NO | PRODUCT_NAME
          1    |      A
          1    |      A        => 데이터 입력 불가능 (중복)
          1    |      B        => 데이터 입력 가능
          2    |      B        => 데이터 입력 가능
          2    |      B        => 데이터 입력 불가능 (중복)
    
    --> MEM_NO과 PRODUCT_NAME의 두 값을 가지고 중복 판별함
        즉, MEM_NO과 PRODUCT_NAME 둘 다 중복이 되는 경우에 오류 발생
*/

INSERT INTO TB_LIKE VALUES (1, '홍길동', 'A', SYSDATE);
INSERT INTO TB_LIKE VALUES (1, '홍길동', 'A', SYSDATE); -- 유효한 데이터 X
--> MEM_NO와 PRODUCT_NAME 둘 다 중복되기 떄문에 오류 발생
INSERT INTO TB_LIKE VALUES (1, '홍길동', 'B', SYSDATE); -- 데이터 입력 가능
INSERT INTO TB_LIKE VALUES (1, '홍길동', 'C', SYSDATE);
INSERT INTO TB_LIKE VALUES (2, '강개순', 'A', '19/02/04');
INSERT INTO TB_LIKE VALUES (2, '강개순', 'C', '22/04/28');

--> 홍길동 회원이 찜한 상품목록 조회
SELECT PRODUCT_NAME 상품명
FROM TB_LIKE
WHERE MEM_ID = '홍길동';

--------------------------------------------------------------------------------

/*
    * FOREIGN KEY (외래키) 제약조건
    다른 데이블에 존재하는 값만 들어와야되는 특정 컬럼에 부여하는 제약조건
    --> 다른 테이블을 참고한다고 표현
    
    > 컬럼레벨 방식
    컬럼명 자료형 [CONSTRAINT 제약조건명] REFERENCES 참조할테이블명[(참조할컬럼명)]
    
    > 테이블레벨 방식
    [CONSTRAINT 제약조건명] FOREIGN KEY(컬럼명) REFERENCES 참조할테이블명[(참조할컬럼명)]
    
    --> 참조할 컬럼명 생략시 참조할테이블에 PRIMARY KEY로 지정된 컬럼으로 매칭
*/
-- 회원 등급에 대한 데이터를 따로 보관하는 테이블
CREATE TABLE MEM_GRADE(
    GRADE_CODE NUMBER PRIMARY KEY,
    GRADE_NAME VARCHAR2(20) NOT NULL
);

COMMENT ON COLUMN MEM_GRADE.GRADE_CODE IS '회원등급';
COMMENT ON COLUMN MEM_GRADE.GRADE_NAME IS '회원등급명';

INSERT INTO MEM_GRADE VALUES(10, '일반회원');
INSERT INTO MEM_GRADE VALUES(20, '우수회원');
INSERT INTO MEM_GRADE VALUES(30, '특별회원');

CREATE TABLE MEM( -- 한 계정 내에서 제약조건명은 중복 불가능
    MEM_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남' , '여')),
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(30),
    GRADE_NO NUMBER --> 회원등급번호 같이 보관할 컬럼
);

INSERT INTO MEM 
VALUES(1, 'user01', 'pass01', '홍길남', '남', null, null, null);

INSERT INTO MEM 
VALUES(2, 'user02', 'pass02', '김말똥', null, null, null, 10);

INSERT INTO MEM 
VALUES(3, 'user03', 'pass03', '강개순', null, null, null, 40);
--> 유효한 회원등급번호가 아님에도 불구하고 잘 insert됨

DROP TABLE MEM;

-->> MEM_GRADE와 외래키연결하는 테이블 생성
CREATE TABLE MEM( 
    MEM_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남' , '여')),
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(30),
    GRADE_NO NUMBER,
    CONSTRAINT GRADE_FK FOREIGN KEY(GRADE_NO) REFERENCES MEM_GRADE(GRADE_CODE) -- 테이블레벨 방식
    --,  GRADE_NO NUMBER REFERENCES MEM_GRADE(GRADE_CODE) -- 컬럼레벨 방식
    --> MEM_GRADE의 GRADE_CODE를 외래키로 설정하였으므로 MEM_GRADE컬럼의 GRADE_CODE값만 들어갈 수 있음
);
-- 외래키 제약 조건을 설정하는 순간 부모-자식 간의 관계가 설정됨
-- MEM_GRADE(부모테이블)를 참조하고있는 MEM은 자식테이블이 됨

INSERT INTO MEM 
VALUES(1, 'user01', 'pass01', '홍길남', '남', null, null, null);

INSERT INTO MEM 
VALUES(2, 'user02', 'pass02', '김말똥', null, null, null, 10);

INSERT INTO MEM 
VALUES(3, 'user03', 'pass03', '강개순', null, null, null, 40); -- 유효한 데이터 X
-- 오류 보고 -
-- ORA-02291: integrity constraint (DDL.GRADE_FK) violated - parent key not found
--> 부모테이블의 MEM_GRADE의 GRADE_CODE의 데이터에는 40이 없기 때문에 오류 발생
INSERT INTO MEM 
VALUES(3, 'user03', 'pass03', '강개순', null, null, null, 20); 

INSERT INTO MEM 
VALUES(4, 'user04', 'pass04', '이순신', null, null, null, 10);

INSERT INTO MEM 
VALUES(5, 'user05', 'pass05', '강개순', null, null, null, 20);

-- 회원명, 회원등급, 회원등급명 조회
SELECT MEM_NAME 회원명, GRADE_CODE 회원등급, GRADE_NAME 회원등급명
FROM MEM M
LEFT JOIN MEM_GRADE  G ON (M.GRADE_NO = G.GRADE_CODE);

--> PARENT KEY NOT FOUND (부모테이블로부터 해당 데이터를 찾을 수 없음)

-- MEM_GRADE(부모테이블) -|---<- MEM(자식테이블)
--          1            :          N
--> 1 : 다(N) 관계에서는 무조건 1이 부모, 다(N)가 자식테이블

--> 부모테이블(MEM_GRADE)로부터 데이터값을 삭제할 경우 어떤 문제
--  데이터 삭제 : DELETE FROM 테이블명 WHERE 조건;
 
--> MEM_GRADE 부모테이블에서 회원등급 10번 삭제
DELETE FROM MEM_GRADE WHERE GRADE_CODE = 10;
--> MEM(자식테이블)에서 부모테이블의 데이터를 사용하고 있기 때문에 삭제 불가능!!

--> MEM_GRADE 부모테이블에서 회원등급 30번 삭제
DELETE FROM MEM_GRADE WHERE GRADE_CODE = 30;
--> MEM(자식테이블)에서 부모테이블의 데이터를 사용하고 있지 않기 때문에 삭제 가능!!

--> 현재 MEM테이블에 외래키 제약조건 설정시
--  자식테이블에 이미 사용하고 있는 값이 존재할 경우
--  부모테이블로부터 무조건 삭제가 안되는 "삭제 제한" 옵션이 걸려있음

--------------------------------------------------------------------------------
INSERT INTO MEM_GRADE VALUES(30, '특별회원');

/*
    자식테이블 생성시 외래키 제약조건 부여할 때 삭제옵션 지정가능
    * 삭제옵션 : 부모테이블의 데이터 삭제 시 그 데이터를 사용하고있는 자식테이블의 값을 어떻게 처리할건지
    
    - ON DELETE RESTRICTED (기본값) : 삭제제한 옵션으로, 자식데이터로 쓰이는 부모데이터는 삭제 아예 안되게끔
    - ON DELETE SET NULL : 부모데이터 삭제시 해당 데이터를 쓰고 있는 자식데이터의 값을 NULL로 변경
    - ON DELETE CASCADE : 부모데이터 삭제시 해당 데이터를 쓰고 있는 자식데이터의 값도 같이 삭제
*/
DROP TABLE MEM;

-- ON DELETE SET NULL : 부모데이터 삭제시 해당 데이터를 쓰고 있는 자식데이터의 값을 NULL로 변경
CREATE TABLE MEM(
    MEM_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남', '여')), 
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(30),
    GRADE_NO REFERENCES MEM_GRADE(GRADE_CODE) ON DELETE SET NULL
);

INSERT INTO MEM
VALUES(1, 'user01', 'pass01', '홍길남', '남', null, null, null);

INSERT INTO MEM
VALUES(2, 'user02', 'pass02', '김말똥', null, null, null, 10);

INSERT INTO MEM
VALUES(3, 'user03', 'pass03', '강개순', null, null, null, 20);

INSERT INTO MEM
VALUES(4, 'user04', 'pass04', '이순신', null, null, null, 10);

-- MEM_GRADE 부모테이블에서 GRADE_CODE = 10 삭제
DELETE FROM MEM_GRADE WHERE GRADE_CODE = 10;
--> 자식테이블에서 쓰고있는 GRADE_NO의 데이터가 NULL로 변경됨!!!

DROP TABLE MEM;
INSERT INTO MEM_GRADE VALUES (10, '일반회원');
-- ON DELETE CASCADE : 부모테이블의 데이터가 삭제되면 해당 데이터를 쓰고있는 자식테이블의 데이터도 삭제
CREATE TABLE MEM(
    MEM_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남', '여')), 
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(30),
    GRADE_NO REFERENCES MEM_GRADE(GRADE_CODE) ON DELETE CASCADE
);

INSERT INTO MEM
VALUES(1, 'user01', 'pass01', '홍길남', '남', null, null, null);

INSERT INTO MEM
VALUES(2, 'user02', 'pass02', '김말똥', null, null, null, 10);

INSERT INTO MEM
VALUES(3, 'user03', 'pass03', '강개순', null, null, null, 20);

INSERT INTO MEM
VALUES(4, 'user04', 'pass04', '이순신', null, null, null, 10);

-- MEM_GRADE 부모테이블에서 GRADE_CODE = 10 삭제
DELETE FROM MEM_GRADE WHERE GRADE_CODE = 10;
--> 자식테이블에서 쓰고있는 GRADE_NO의 데이터도 같이 삭제됨!!

--------------------------------------------------------------------------------

/*
    < DEFAULT 기본값 > ** 제약조건 아님!!!! **
    컬럼을 지정하지 않고 INSERT시 NULL이 아닌 INSERT 시키고자 할 때 세팅해 줄 수 있는 값
*/

CREATE TABLE MEM_DEFAULT(
    MEM_ID NUMBER PRIMARY KEY,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(1) CHECK(GENDER IN ('M', 'F')),
    HOBBY VARCHAR2(30) DEFAULT '-',
    ENROLL_DATE DATE DEFAULT SYSDATE
);
-- INSERT INTO 테이블명 VALUES(컬럼값, 컬럼값, 컬럼값, ...);  => 모든컬럼에 넣고자하는 값을 다 제시  
INSERT INTO MEM_DEFAULT VALUES (1, '홍길동', 'M', DEFAULT, '19/05/02');
INSERT INTO MEM_DEFAULT VALUES (2, '김보라', 'F', '킥봉싱', NULL);
INSERT INTO MEM_DEFAULT VALUES (3, '최월남', 'M', DEFAULT, DEFAULT);
-- INSERT INTO 테이블명(컬럼명, 컬럼명) VALUES(컬럼값, 컬럼값); => 선택한컬럼에 넣고자하는 값만 제시 
--> 선택되지 않은 컬럼에는 기본적으로 NULL이 들어감 (단, 해당 컬럼에 DEFAULT값이 부여되어있을 경우 NULL 아닌 DEFAULT값이 들어감)
INSERT INTO MEM_DEFAULT(MEM_ID, MEM_NAME, HOBBY) VALUES (4, '정주나', '맛집탐방');
INSERT INTO MEM_DEFAULT(MEM_ID, MEM_NAME, ENROLL_DATE) VALUES (5, '유재나', '18/07/18');
INSERT INTO MEM_DEFAULT(MEM_ID, MEM_NAME, GENDER, HOBBY) VALUES (6, '박조나', 'F', '독서');

-- ============================================================================

/*
    !!!!!!!!!!!!!!!!!!!!! 지금부터 KEY계정에서 !!!!!!!!!!!!!!!!!!!!!!!!!!!
    
    < SUBQUERY를 이용한 테이블 생성 >
    테이블 복사뜨는 개념 
    
    [표현법]
    CREATE TABLE 테이블명
    AS 서브쿼리;
*/

CREATE TABLE EMPLOYEE_COPY
AS SELECT * FROM EMPLOYEE;

SELECT * FROM EMPLOYEE_COPY;
-- 컬럼명 & 타입, 조회되는데이터값, 제약조건같은경우 NOT NULL만 복사

CREATE TABLE EMPLOYEE_COPY2
AS SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE
     FROM EMPLOYEE
     WHERE 1=0; --> 구조만을 복사하고자 할 때 쓰이는 구문 (데이터값은 필요없을때)

CREATE TABLE EMPLOYEE_COPY3
AS SELECT EMP_ID, EMP_NAME, SALARY, SALARY*12 "연봉"
   FROM EMPLOYEE;
--> 서브쿼리 SELECT절에 산술식 또는 함수식 기술된 경우 반드시 별칭 지정해야됨

--------------------------------------------------------------------------------
/*
    * 테이블 다 생성된 후에 뒤늦게 제약조건 추가
    
    ALTER TABLE 테이블명 변경할내용;
    
    - PRIMARY KEY : ALTER TABLE 테이블명 ADD PRIMARY KEY(컬럼명);
    - FOREIGN KEY : ALTER TABLE 테이블명 ADD FOREIGN KEY(컬럼명) REFERENCES 참조할테이블명 [(참조할컬럼명)];
    - UNIQUE      : ALTER TABLE 테이블명 ADD UNIQUE(컬럼명);
    - CHECK       : ALTER TABLE 테이블명 ADD CHECK(컬럼에대한 조건);
    - NOT NULL    : ALTER TABLE 테이블명 MODIFY 컬럼명 NOT NULL;
    
    제약조건명을 추가하고자 한다면 [CONSTRAINT 제약조건명] 제약조건
*/

-- EMPLOYEE_COPY테이블에 EMP_ID에 PRIMARY KEY(기본키) 추가
ALTER TABLE EMPLOYEE_COPY ADD PRIMARY KEY(EMP_ID);

-- EMPLOYEE_COPY2테이블에 EMP_ID에 UNIQUE와 NOT NULL 추가
ALTER TABLE EMPLOYEE_COPY2 ADD UNIQUE(EMP_ID);
ALTER TABLE EMPLOYEE_COPY2 MODIFY EMP_ID NOT NULL;

-- EMPLOYEE 테이블에 DEPT_CODE에 외래키 제약조건 추가 (참조하는테이블(부모) : DEPARTMENT(DEPT_ID)) 
ALTER TABLE EMPLOYEE ADD FOREIGN KEY(DEPT_CODE) REFERENCES DEPARTMENT(DEPT_ID);
-- EMPLOYEE 테이블에 JOB_CODE에 외래키 제약조건 추가 (참조하는테이블(부모) : JOB(JOB_CODE))
ALTER TABLE EMPLOYEE ADD FOREIGN KEY(JOB_CODE) REFERENCES JOB(JOB_CODE);
-- DEPARTMENT 테이블에 LOCATION_ID에 외래키 제약조건 추가 (LOCATION테이블 참조)
ALTER TABLE DEPARTMENT ADD FOREIGN KEY(LOCATION_ID) REFERENCES LOCATION(LOCAL_CODE);

