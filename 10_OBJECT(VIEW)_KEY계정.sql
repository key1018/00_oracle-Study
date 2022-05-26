/*
    * VIEW 뷰
    
    SELECT(쿼리문)을 저장해둘 수 있는 객체
    (자주쓰는 긴 SELECT문을 저장해두면 그 긴 SELECT문을 매번 다시 기술할 필요 없음)
    임시테이블같은 존재 (실제 데이터가 담겨있는 건 아님 -> 논리적인 테이블)
*/

-- '한국'에서 근무하는 사원들의 사번, 이름, 부서명, 급여, 근무국가명 조회
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME
FROM EMPLOYEE 
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN LOCATION L ON (LOCATION_ID = LOCAL_CODE)
JOIN NATIONAL N ON (L.NATIONAL_CODE = N.NATIONAL_CODE)
WHERE NATIONAL_NAME = '한국';
-- '러시아'에서 근무하는 사원들의 사번, 이름, 부서명, 급여, 근무국가명 조회
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME
FROM EMPLOYEE 
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN LOCATION L ON (LOCATION_ID = LOCAL_CODE)
JOIN NATIONAL N ON (L.NATIONAL_CODE = N.NATIONAL_CODE)
WHERE NATIONAL_NAME = '러시아';
-- '일본'에서 근무하는 사원들의 사번, 이름, 부서명, 급여, 근무국가명 조회
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME
FROM EMPLOYEE 
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN LOCATION L ON (LOCATION_ID = LOCAL_CODE)
JOIN NATIONAL N ON (L.NATIONAL_CODE = N.NATIONAL_CODE)
WHERE NATIONAL_NAME = '일본';

--------------------------------------------------------------------------------

/*
    * VIEW 생성
    
    [기본 표현법]
    CREATE [OR REPLAVE] VIEW 뷰명
    AS 저장시키고자하는구문(=서브쿼리);
    
    [OR REPLACE] : 뷰 생성시 중복된 이름의 뷰가 있다면 해당 뷰를 변경(갱신)하는 옵션
                   중복된 이름의 뷰가 없다면 새로이 뷰를 생성
                   => ALTER로 변경 X
    
    > 유의사항 : 관리자로부터 뷰를 생성할 수 있는 권한(CREATE VIEW)을 부여받아야됨
*/

-- 뷰 권한 부여 (관리자계정에서 실행)
GRANT CREATE VIEW TO KEY;

-- 뷰 생생 (위의 구문을 조회할 수 있는)
CREATE OR REPLACE VIEW VW_CONTRY
AS SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME
    FROM EMPLOYEE 
    JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
    JOIN LOCATION L ON (LOCATION_ID = LOCAL_CODE)
    JOIN NATIONAL N ON (L.NATIONAL_CODE = N.NATIONAL_CODE);

-- '한국'에서 근무하는 사원들의 사번, 이름, 부서명, 급여, 근무국가명 조회
SELECT * FROM VW_CONTRY
WHERE NATIONAL_NAME = '한국';

-- '중국'에서 근무하는 사원들의 사번, 이름, 부서명, 급여, 근무국가명 조회
SELECT * FROM VW_CONTRY
WHERE NATIONAL_NAME = '중국';

-- [참고] USER_VIEWS : 현재 이 사용자가 가지고 있는 뷰 객체들에 대한 정보를 조회할 수 있는 시스템 테이블
SELECT * FROM USER_VIEWS;
-- 현재 사용자가 가지고 있는 모든 VIEW 객체들에 대한 정보 조회

--------------------------------------------------------------------------------

/*
    * 뷰 컬럼에 별칭 부여
      서브쿼리의 SELECT절에 산술연산식, 함수식을 기술했을 경우 '반드시 별칭을 지정'해야됨
*/

-- 사번, 사원명, 나이, 성별, 부서명, 직급, 연봉을 볼 수 있는 VIEW 생성
-- 사번, 사원명, 나이, 성별,  부서명, 직급, 연봉 조회
SELECT EMP_ID, EMP_NAME,
        DECODE(SUBSTR(EMP_NO, 8,1), '1', '남', '2', '여') "성별",
        EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM TO_DATE(SUBSTR(EMP_NO, 1,2), 'RRRR')) "나이",
        DEPT_TITLE, JOB_NAME,
        TO_CHAR(SALARY * 12, '999,999,999') "연봉"
FROM EMPLOYEE E
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE);

-- 뷰 테이블 생성
CREATE OR REPLACE VIEW VW_EMP
AS SELECT EMP_ID, EMP_NAME,
        DECODE(SUBSTR(EMP_NO, 8,1), '1', '남', '2', '여') "성별",
        EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM TO_DATE(SUBSTR(EMP_NO, 1,2), 'RRRR')) "나이",
        DEPT_TITLE, JOB_NAME,
        TO_CHAR(SALARY * 12, '999,999,999') "연봉"
    FROM EMPLOYEE E
    JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
    JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE);
    
-- 조회시 별칭으로 조회
SELECT * FROM VW_EMP
WHERE 성별 = '여'
ORDER BY 나이;

SELECT 성별, ROUND(AVG(나이)) "평균연령"
FROM VW_EMP
GROUP BY 성별;

-- 아래와 같은 방식으로도 별칭 부여가능(모든 컬럼에 별칭 부여하는 방법)
-- 이때는 모든 컬럼에 대한 별칭을 작성해야됨
CREATE OR REPLACE VIEW VW_EMP(사번, 이름, 성별, 나이, 부서명, 직급, 연봉)
AS SELECT EMP_ID, EMP_NAME,
        DECODE(SUBSTR(EMP_NO, 8,1), '1', '남', '2', '여'),
        EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM TO_DATE(SUBSTR(EMP_NO, 1,2), 'RRRR')) ,
        DEPT_TITLE, JOB_NAME,
        TO_CHAR(SALARY * 12, '999,999,999') 
    FROM EMPLOYEE E
    JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
    JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE);

--------------------------------------------------------------------------------

-- 생성된 뷰를 이용해서 DML(INSERT, UPDATE, DELETE) 사용 가능하긴 함
-- 단, 안되는 기능이 많아서 웬만해서는 '조회'목적으로 사용하길 권장함
-- 뷰를 통해서 조작하게 되면 실제 데이터가 담겨있는 "베이스테이블"에 반영됨

-- 테스트할 뷰 생성
CREATE OR REPLACE VIEW VW_DEPT_TEST
AS SELECT DEPT_ID, 부서명, LOCATION_ID
     FROM DEPT_COPY;
     
-- INSERT
INSERT INTO VW_DEPT_TEST VALUES ('D10', '혁신부', 'L1');

SELECT * FROM VW_DEPT_TEST; -- 논리적인 테이블 (실제데이터가 담겨있진 않음)
SELECT * FROM DEPT_COPY; -- 베이스 테이블 (실제데이터가 담겨있음)
-- 뷰 뿐만 아니라 베이스 테이블(DEPT_COPY)에도 생성한 구문 같이 생성됨

-- UPDATE
UPDATE VW_DEPT_TEST
    SET 부서명 = 'IT부'
    WHERE DEPT_ID = 'D10'; --> 베이스 테이블(DEPT_COPY)에도 데이터가 변경됨
    
-- DELETE 
DELETE FROM VW_DEPT_TEST
    WHERE DEPT_ID = 'D10'; --> 베이스 테이블(DEPT_COPY)에도 데이터가 삭제됨
    
--------------------------------------------------------------------------------

/*  
    * 단, DML로 조작이 불가능한 경우가 더 많음
    
    1) 뷰에 정의되어있지 않은 컬럼을 가지고 조작하려고 하는 경우
    2) 뷰에 정의되어있지 않은 컬럼 중에 베이스테이블 상에 NOT NULL 제약 조건이 걸려있는 경우
    3) 산술연산식 또는 함수식으로 정의되어있는 경우
    4) 그룹함수나 GROUP BY 절로 정의되어있는 경우
    5) DISTINCT 구문이 포함되어있는 경우
    6) JOIN을 이용해서 여러테이블을 연결시켜놓은 경우
*/   

-- 1) 뷰에 정의되어있지 않은 컬럼을 가지고 조작하려고 하는 경우

-- 뷰 테이블 재정의
CREATE OR REPLACE VIEW VW_DEPT_TEST
AS SELECT DEPT_ID FROM DEPT_COPY;

-- INSERT (에러)
INSERT INTO VW_DEPT_TEST(DEPT_ID, 부서명) VALUES ('D10', '전산부');

-- UPDATE (에러)
UPDATE VW_DEPT_TEST
   SET 부서명 = '전산부'
   WHERE DEPT_ID = 'D1';

-- DELETE (에러)
DELETE FROM VW_DEPT_TEST
        WHERE LOCATION_ID = 'L1';
        
--> VW_DEPT_TEST에는 없는 컬럼들을 삽입, 수정, 삭제하려고해서 오류 발생

-- 2) 뷰에 정의되어있지 않은 컬럼 중에 베이스테이블 상에 NOT NULL 제약 조건이 걸려있는 

CREATE OR REPLACE VIEW VW_DEPT_TEST
AS SELECT 부서명 FROM DEPT_COPY;

-- INSERT
INSERT INTO VW_DEPT_TEST VALUES ('전산부'); -- 실제 베이스테이블에 INSERT시 (NULL, '전산부') 추가
--> DEPT_ID가 NOT NULL 제약조건이므로 오류 발생
-- cannot insert NULL into

-- UPDATE (가능)
UPDATE VW_DEPT_TEST
    SET 부서명 = '혁신부'
    WHERE 부서명 = '인사관리부';
ROLLBACK;

-- DELETE (해당데이터를 쓰고 있는 자식데이터가 존재하기 때문에 삭제 불가 / 없다면 삭제 성공)
DELETE FROM VW_JOB
    WHERE JOB_NAME = '사원';

-- 3) 산술연산식 또는 함수식으로 정의되어있는 경우

--INSERT(에러)
INSERT INTO VW_EMP(사번, 이름, 성별, 나이, 부서명, 직급) VALUES (500, '나보람', '여', 24, '마케팅부', '사원');
-- "virtual column not allowed here" 오류 발생

-- UPDATE 
UPDATE VW_EMP 
    SET 나이 = 47
    WHERE 사번 = 216; -- 에러

-- DELETE 
DELETE FROM VW_EMP
WHERE 나이 = 42;
--> 산술연산 및 함수식으로 조건을 제시하는 것은 가능하다!

-- 4) 그룹함수나 GROUP BY 절을 포함하는 경우
CREATE OR REPLACE VIEW VW_GROUPDEPT
AS SELECT DEPT_CODE, SUM(SALARY) "합계", FLOOR(AVG(SALARY)) "평균"
    FROM EMPLOYEE
    GROUP BY DEPT_CODE;

-- INSERT (에러)
INSERT INTO VW_GROUPDEPT VALUES('D3', 8000000, 4000000);

-- UPDATE (에러)
UPDATE VW_GROUPDEPT
 SET 평균 = 3000000
 WHERE DEPT_CODE = 'D1';
 
-- DELETE (에러)
DELETE FROM VW_GROUPDEPT
    WHERE 합계 = 7820000;

-- 5) DISTINCT가 포함된 경우
CREATE OR REPLACE VIEW VW_DEPT_TEST
AS SELECT DISTINCT DEPT_CODE 
            FROM EMPLOYEE;

-- INSERT (에러)
INSERT INTO VW_DEPT_TEST VALUES ('D0');

-- UPDATE (에러)
UPDATE VW_DEPT_TEST
 SET DEPT_CODE = 'D0'
 WHERE DEPT_CODE = 'D2';

-- DELETE 
DELETE FROM VW_DEPT_CODE
WHERE DEPT_CODE = 'D6';

-- 6) JOIN으로 여러테이블을 연결한 경우 
CREATE OR REPLACE VIEW VW_JOINEMP
AS SELECT EMP_ID, EMP_NAME, DEPT_TITLE
    FROM EMPLOYEE
    JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);
    
-- INSERT (에러)
INSERT INTO VW_JOINEMP VALUES (300, '조세오', '기술지원부');

-- UPDATE 
UPDATE VW_JOINEMP
    SET EMP_NAME = '서동일'
    WHERE EMP_ID = 200; --> 문제없이 수정

-- 200번 사원 총무부 => 회계부로 변경
UPDATE VW_JOINEMP
    SET DEPT_TITLE = '회계부'
    WHERE EMP_ID = 200; -- 오류 발생

-- DELETE 
DELETE VW_JOINEMP
    WHERE DEPT_TITLE = '총무부'; -- 성공
    
DELETE VW_JOINEMP
    WHERE EMP_ID = 203; -- 성공

ROLLBACK;
--------------------------------------------------------------------------------

/*
    * VIEW 옵션
    
    [상세표현법]
    CREATE [OR REPLACE] [FORCE | "NOFORCE" ] VIEW 뷰명
    AS 서브쿼리
    [WITH CHECK OPTION]
    [WIRH READ ONRY];
    
    1) OR REPLACE : 기존에 동일한 뷰가 있을 경우 갱신시키고, 존재하지 않으면 새로이 생성시킴 
    2) FORCE | NOFORCE 
        > FORCE : 서브쿼리에 기술된 테이블이 존재하지 않아도 뷰 생성 가능
        > NOFORCE : 서브쿼리에 기술된 테이블이 존재하는 테이블이어야만 뷰 생성 가능 (생략시 기본값)
    3) WITH CHECK OPTION : DML시 서브쿼리에 기술된 조건에 부합한 값으로만 DML이 가능하도록 설정
    4) WITH READ ONLY : 뷰에 대해서 조회만 가능 (DML문 수행불가)

*/

-- * NOFORCE
CREATE OR REPLACE /*NOFORCE*/ VIEW VW_RR
AS SELECT RRCODE 
    FROM RR; -- 오류발생 : 테이블이 존재해야만 생성 가능

-- * FORCE 
CREATE OR REPLACE FORCE VIEW  VW_RR
AS SELECT RRCODE
    FROM RR; --  경고: 컴파일 오류와 함께 뷰가 생성되었습니다.
-- 테이블이 존재하지않는데도 강제로 생성가능
-- 단, RR이라는 테이블이 생성되어야지 VW_RR을 사용가능하다
CREATE TABLE RR(
    RRCODE NUMBER
);

-- * WITH CHECK OPION
CREATE OR REPLACE VIEW VW_EMP_CK
AS SELECT EMP_ID, EMP_NAME, DEPT_CODE
    FROM EMPLOYEE
    WHERE EMP_ID >= 210;

UPDATE VW_EMP_CK
    SET EMP_ID = 199
    WHERE EMP_ID = 211; --> WITH CHECK OPTION을 사용하지 않았으므로 쉽게 수정 가능
    
ROLLBACK;

-- WITH CHECK OPTION 사용
CREATE OR REPLACE VIEW VW_EMP_CK
AS SELECT EMP_ID, EMP_NAME, DEPT_CODE
    FROM EMPLOYEE
    WHERE EMP_ID >= 210
WITH CHECK OPTION;

UPDATE VW_EMP_CK
    SET EMP_ID = 199
    WHERE EMP_ID = 211; --> 옵션을 사용하였으므로 조건문에 도달하지 않는 번호로 수정 불가능!!
      
UPDATE VW_EMP_CK
    SET EMP_ID = 400
    WHERE EMP_ID = 211; --> 단, 조건문에 포함되어있는 범위로는 수정 가능
    
-- WITH READ ONLY : 뷰에 대해 조회만 가능 (DML 불가능)   

CREATE OR REPLACE VIEW VW_EMP_CK
AS SELECT EMP_ID, EMP_NAME, DEPT_CODE
    FROM EMPLOYEE
    WHERE EMP_ID >= 210
WITH READ ONLY;

UPDATE VW_EMP_CK
    SET EMP_ID = 400
    WHERE EMP_ID = 211; --> 오직 조회만 가능하도록 설정해서 조건에 부합하는데도 수정 불가능
