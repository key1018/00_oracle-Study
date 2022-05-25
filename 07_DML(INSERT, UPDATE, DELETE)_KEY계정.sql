/*
    DQL (QUERY 데이터질의언어) : SELECT
    DML (MANIPULAION  데이터조작언어) : [SELECT], INSERT, DELETE, UPDATE
    DDL (DEFINITION 데이터정의언어) : CREATE, DROP, ALTER
    DCL (CONTROL 데이터제어언어) : GRANT, REVOKE
    TCL (TRANSACTION 트랜잭션언어) : COMMIT, ROLLBACK
    
    < DML : 데이터조작언어 >
    테이블에 데이터를 삽입(INSERT), 수정(UPDATE), 삭제(DELETE)하는 구문
*/  
/*
    * INSERT 
    테이블에 새로운 행(데이터)를 추가해주는 구문
    
    [표현법1] : 특정 컬럼을 지정하지 않고 삽입하고자 할 때
    INSERT INTO 테이블명 VALUES (값, 값, 값, ..);
    컬럼 순번을 지켜서 VALUES에 값을 입력해야함!! (컬럼의 갯수와 딱 맞춰서 입력)
    
    > 부족하게 값을 제시했을 경우 : not enough values 오류 발생
    > 값을 더 많이 제시했을 경우 : too many values 오류 발생
*/
INSERT INTO EMPLOYEE_COPY 
   VALUES (900, '장채현', '980615-2451666', 'jang_ch@br.com', '01011112222', 'D1',
        'J7', 4000000, 0.2, 200, SYSDATE, NULL, 'N');

/*
    [표현법2] : 특정 컬럼을 선택해서 값을 제시하고자 할 때
    INSERT TABLE 테이블명(컬럼명, 컬럼명, 컬럼명) VALUES(값, 값, 값);
    
    똑같이 한 행으로 추가되기 때문에 선택안된 컬럼은 기본적으로 NULL로 들어감 (DEFAULT 값이 지정됐으면 NULL이 아닌 DEFAULT값으로 들어감)
    => 단, NOT NULL이 제약조건으로 걸려있으면 해당 컬럼은 반드시 지정해서 직접 값 제시해야됨
       기본값(DEFAULT)이 지정되어있으면 NULL이 아닌 기본값이 들어감
*/

INSERT 
INTO EMPLOYEE_COPY
    (EMP_ID
    , EMP_NAME
    , EMP_NO
    , JOB_CODE
    , SALARY
    , BONUS
    )
VALUES (
    901
    , '강미나'
    , '961028-2088192'
    , 'J7'
    , 3400000
    , 0.2
    );

--------------------------------------------------------------------------------

/*
    [표현법3] : VALUES로 값을 지정하는 것 대신에 서브쿼리로 조회되는 결과값을 통채로 INSERT 가능
    INSERT INTO 테이블명 (서브쿼리);
*/
-- EMP_01 테이블 생성하기
CREATE TABLE EMP_01 (
    EMP_ID NUMBER PRIMARY KEY,
    EMP_NAME VARCHAR2(20),
    DEPT_TITLE VARCHAR2(30)
);

-- EMP_01에 값 입력하기
INSERT 
INTO EMP_01
    ( SELECT EMP_ID, EMP_NAME, DEPT_TITLE
        FROM EMPLOYEE
        JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID));

-- ENPLOYEE_COPY2에 데이터 입력하기
INSERT 
INTO EMPLOYEE_COPY2
    ( SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE
        FROM EMPLOYEE);

--------------------------------------------------------------------------------
/*
    * INSERT ALL
    두 개 이상의 테이블에 각각 INSERT할 때
    이 때 사용되는 서브쿼리가 동일할 경우
    
    [표현법1]
    INSERT ALL
    INTO 테이블명1 VALUES(컬럼명, 컬럼명, 컬럼명, ...)
    INTO 테이블명2 VALUES(컬럼명, 컬럼명, ...)
         서브쿼리;
*/
-- EMPLOYEE_COPY2와 EMPLOYEE_COPY3 테이블의 데이터 전부 삭제
DELETE FROM EMPLOYEE_COPY2;
DELETE FROM EMPLOYEE_COPY3;

--> EMPLOYEE_COPY2와 EMPLOYEE_COPY3 테이블의 동일한 칼럼명 : EMP_ID, EMP_NAME
INSERT ALL
    INTO EMPLOYEE_COPY2 VALUES (EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE)
    INTO EMPLOYEE_COPY3 VALUES (EMP_ID, EMP_NAME, SALARY, SALARY*12 )
SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE, SALARY, SALARY*12
 FROM EMPLOYEE;

--> EMPLOYEE_COPY2와 EMPLOYEE_COPY3 테이블의 동일한 칼럼명 : EMP_ID, EMP_NAME
--> JOB_CODE가 J6인 사원들의 데이터 입력
INSERT ALL
    INTO EMPLOYEE_COPY2 VALUES (EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE)
    INTO EMPLOYEE_COPY3 VALUES (EMP_ID, EMP_NAME, SALARY, SALARY * 12)
SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE, SALARY, SALARY * 12
  FROM EMPLOYEE
  WHERE JOB_CODE = 'J6';

/*  
    [표현법2]
    INSERT ALL
        WHEN 조건1 THEN
            INTO 테이블명1 VALUES(컬럼명, 컬럼명, ..)
        WHEN 조건2 THEN
            INTO 테이블명2 VALUES(컬럼명, 컬럼명, ..)
        서브쿼리;
*/

-- 임의의 테이블2개 생성
CREATE TABLE TB_OLD -- 2000년도 이전에 입사한 사원들
AS SELECT EMP_ID, EMP_NAME, D.DEPT_TITLE, J.JOB_NAME, HIRE_DATE, SALARY
    FROM EMPLOYEE E
    FULL JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
    JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
    WHERE 1=0;


CREATE TABLE TB_NEW -- 2000년도 이후에 입사한 사원들
AS SELECT EMP_ID, EMP_NAME, D.DEPT_TITLE, J.JOB_NAME, HIRE_DATE, ENT_YN
    FROM EMPLOYEE E
    FULL JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
    JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
    WHERE 1=0;
DROP TABLE TB_OLD;
-- * 조건을 사용해서도 각 테이블에 값 INSERT 가능
-- 2000년도 이전/이후에 입사한 입사자들에 대한 정보 담을 테이블

INSERT ALL
    WHEN HIRE_DATE < '2000/01/01' THEN 
        INTO TB_OLD VALUES (EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, HIRE_DATE, SALARY)
    WHEN HIRE_DATE > '2000/01/01' THEN
        INTO TB_NEW VALUES (EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, HIRE_DATE, ENT_YN)
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, HIRE_DATE, SALARY, ENT_YN
 FROM EMPLOYEE E, DEPARTMENT D, JOB J
 WHERE E.DEPT_CODE = D.DEPT_ID
   AND E.JOB_CODE = J.JOB_CODE;

--------------------------------------------------------------------------------

/*
    * UPDATE
    테이블에 기록되어 있는 기존의 데이터를 수정하는 구문
    
    [표현법1]
    UPDATE 테이블명
      SET 컬럼명 = 바꿀값,
          컬럼명 = 바꿀값,
          컬럼명 = 바꿀값,
          ...            --> 여러개의 칼럼값 동시에 수정가능
    [WHERE 조건];         --> 조건문을 생략하면 전체 모든 행의 데이터가 변경된다!
*/

-- EMPLOYEE_COPY2의 하동운의 DEPT_CODE를 'D2'로 변경
UPDATE EMPLOYEE_COPY2
   SET DEPT_CODE = 'D2';
--> 조건문을 생략했을 시 전체 데이터의 모든 DEPT_CODE값 변경

ROLLBACK;
--> ROLLBACK 구문을 통해 '수정 전'상태로 되돌림

UPDATE EMPLOYEE_COPY2
   SET DEPT_CODE = 'D2'
   WHERE EMP_NAME = '하동운';
   
-- 전체사원의 급여를 기존의 급여에 10% 인상한 금액 (기존급여 * 1.1)
UPDATE EMPLOYEE_COPY
 SET SALARY = SALARY * 1.1;

-- * UPDATE시 서브쿼리 사용 가능
/*
    UPDATE 테이블명 
    SET 컬럼명 = (서브쿼리)
    WHERE 조건식(서브쿼리활용);
*/
-- TB_OLD테이블의 임시환의 월급, 부서명 변경
UPDATE TB_OLD
    SET SALARY = 3000000,
        DEPT_TITLE = (SELECT DEPT_TITLE
                        FROM DEPARTMENT
                        WHERE DEPT_ID = 'D1')
    WHERE EMP_NAME = '임시환';

-- 다중열 서브쿼리 활용
UPDATE TB_OLD
    SET (SALARY, DEPT_TITLE) = (SELECT SALARY, DEPT_TITLE
                                  FROM DEPARTMENT
                                  JOIN EMPLOYEE ON (DEPT_ID = DEPT_CODE)
                                  WHERE EMP_NAME = '송은희')
    WHERE EMP_NAME = '유하진';

-- 해외영업 지역에서 근무하는 사원들의 부서명을 국내영업으로 변경
UPDATE TB_NEW
  SET DEPT_TITLE = (SELECT DEPT_TITLE
                     FROM DEPARTMENT
                     WHERE DEPT_ID = 'D4')
WHERE DEPT_TITLE IN (SELECT DEPT_TITLE
                      FROM DEPARTMENT
                      WHERE DEPT_TITLE LIKE '해외영업%');

--------------------------------------------------------------------------------
COMMIT; --> 변경사항 확정 (변경사항을 이전으로 더이상 되돌릴 수 없음)
-- COMMIT이후에는 ROLLBACK을 하면 COMMIT이후 까지의 데이터로만 변경 취소가 가능

/*
    * DELETE 
    테이블에 기록된 데이터를 삭제하는 구문 (한 행 단위로 삭제됨)
    
    [표현법]
    DELETE FROM 테이블명
    [WHERE 조건];         => 조건문 생략시 전체 행 다 삭제됨
*/  
--> TB_OLD테이블의 '이태림' 데이터 삭제
DELETE FROM TB_OLD
WHERE EMP_NAME = '이태림';

ROLLBACK; --> COMMIT 이전 상태로 돌아감

CREATE TABLE EMP_DEPT
AS SELECT DEPT_ID, DEPT_TITLE, LOCATION_ID
    FROM DEPARTMENT;
    
--> EMPLOYEE_COPY에 외래키 제약조건 설정
ALTER TABLE EMP_DEPT ADD PRIMARY KEY(DEPT_ID);
ALTER TABLE EMPLOYEE_COPY ADD FOREIGN KEY(DEPT_CODE) REFERENCES EMP_DEPT(DEPT_ID);

-- DEPT_ID 가 D1인 부서를 삭제
DELETE FROM EMP_DEPT
WHERE DEPT_ID = 'D1'; --> D1의 값을 가져다 쓰는 자식데이터가 있기 때문에 삭제 안됨

-- DEPT_ID 가 D3인 부서를 삭제
DELETE FROM EMP_DEPT
WHERE DEPT_ID = 'D3'; --> D3의 값을 가져다 쓰는 자식데이터가 없기 때문에 삭제됨

ROLLBACK;

-- 제약조건을 비활성화 
-- ALTER TABLE 테이블명 DISABLE CONSTRAINT 제약조건명 CASCADE;
ALTER TABLE EMPLOYEE_COPY DISABLE CONSTRAINT SYS_C007198 CASCADE;
-- STATUS의 ENABLED => DISABLED로 변경됨

DELETE FROM EMP_DEPT
WHERE DEPT_ID = 'D1'; --> TKRWPEHLA
--> DEPT_CODE의 'D1'데이터는 삭제 안됨 => 연결고리를 끊어놨기 때문에 자식데이터에는 변동사항 없음

ROLLBACK;

-- 제약조건을 다시 활성화
-- ALTER TABLE 테이블명 ENABLE CONSTRAINT 제약조건명;
ALTER TABLE EMPLOYEE_COPY ENABLE CONSTRAINT SYS_C007198;
-- STATUS의 DISABLED => ENABLED로 변경됨

--------------------------------------------------------------------------------

/*
    * TRUNCATE : 테이블의 전체 행을 삭제할 때 사용되는 구문 (별도의 조건 제시 불가)
                 DELETE보다 수행속도가 더 빠름
                 
    > 단점 : ROLLBACK이 불가능!! => 이전 상태로 되돌아갈 수 없음
    
    [표현법]
    TRUNCATE TABLE 테이블명;    => 테이블의 모든 행들을 절삭시키겠다
*/

-- EMPLOYEE_COPY2 테이블 절삭하기
SELECT * FROM EMPLOYEE_COPY2;

TRUNCATE TABLE EMPLOYEE_COPY2;
-- Table EMPLOYEE_COPY2이(가) 잘렸습니다.

ROLLBACK; -- TRUNCATE로 자른 테이블은 ROLLBACK불가능!!
