/*
    < PL / SQL >
    PROCEDURE LANGUAGE EXTENSION TO SQL
    
    오라클 자체에 내장되어있는 절차적 언어
    SQL문 내에서 변수의 정의, 조건처리(IF), 반복처리(LOOP, FOR WHILE)등을 지원하여 SQL의 단점을 보완
    
    * PL / SQL의 구조
    - [선언부 (DECLARE SECTION)] : DECLARE로 시작, 변수나 상수를 선언 및 초기화하는 부분
    - 실행부 (EXCUTABLE SECTION) : BEGIN로 시작, SQL문 또는 제어문(조건문, 반복문)등의 로직을 기술하는 부분      => 핵심!!!!
    - [예외처리부 (EXCEPTON SECTION)] : EXCEPTION로 시작, 예외발생시 해결하기 위한 구문을 미리 기술해둘 수 있는 부분
*/
-- 출력을 위해 한 번 실행시켜야되는 구문(위 구문을 먼저 실행해야지 프로시져가 출력될 수 있음)
-- 오라클 종료와 동시에 같이 종료되므로 실행할때마다 재실행해야함!!
SET SERVEROUTPUT ON;

-- 실행문 작성
BEGIN
    DBMS_OUTPUT.PUT_LINE('HELLO WORLD');   
    -- 원하는 구문을 출력하는 문구
    -- 자바의 System.out.println과 동일    
END;
/

--------------------------------------------------------------------------------

/*
    1. DECLARE 선언부
    변수 및 상수 선언하는 구간 (선언과 동시에 초기화도 가능)
    일반타입변수, 레퍼런스변수, ROW타입변수
    
    1_1) 일반타입변수 선언 및 초기화
        -> 변수명 [CONSTANT] 자료형 [ := 값];  -> 변수초기화(:=) - 선언만할때는 생략가능
                                            -> CONSTANT : 상수선언
*/
-- 변수 선언 및 초기화
DECLARE 
    TICKET_NO NUMBER; 
    MOVIE_NAME VARCHAR2(30);
    CINEMA CONSTANT VARCHAR2(20) := '매너박스';

BEGIN
    /* 직접 값 대입
    TICKET_NO := '123592';
    MOVIE_NAME := '범죄도로';  
    */
    
    -- 사용자에게 값 입력받기
    TICKET_NO := &예약번호;
   MOVIE_NAME := '&영화명';
    
    DBMS_OUTPUT.PUT_LINE ('예약번호 : ' || TICKET_NO);
    DBMS_OUTPUT.PUT_LINE ('영화명 : ' || MOVIE_NAME);
    DBMS_OUTPUT.PUT_LINE('영화관 : ' || CINEMA);
END;
/

--------------------------------------------------------------------------------
/*
    1_2) 레퍼런스타입변수 선언 및 초기화
         변수명 테이블명.컬럼명%TYPE;     -> 특정 테이블의 특정 컬럼의 데이터타입을 참조해서 그 타입으로 지정
*/

DECLARE
    EID EMPLOYEE.EMP_NO%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    DCODE EMPLOYEE.DEPT_CODE%TYPE;
    JCODE EMPLOYEE.JOB_CODE%TYPE;
    SALARY EMPLOYEE.SALARY%TYPE;
BEGIN
    
    -- SELECT문으로 조회된 결과를 변수에 담을 수 있음 (무조건 한 행으로 조회되어야함)
    -- 사용자에게 입력받은 사번 조회
    SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE, SALARY
    INTO EID, ENAME, DCODE, JCODE, SALARY
    FROM EMPLOYEE
    WHERE EMP_ID = &사번;
    
    DBMS_OUTPUT.PUT_LINE('사번 : ' || EID);
    DBMS_OUTPUT.PUT_LINE('이름 : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('부서코드 : ' || DCODE);
    DBMS_OUTPUT.PUT_LINE('직급코드 : ' || JCODE);
    DBMS_OUTPUT.PUT_LINE('급여 : ' || SALARY);

END;
/
    
-------------------------------- 실습 문제 ---------------------------------------

/*
    레퍼런스타입의 변수로 EID, ENAME, JCODE, SAL, DTITLE를 선언하고
    각 자료형은 EMPLOYEE(EMP_ID, EMP_NAME, JOB_CODE, SALARY), DEPARTMENT (DEPT_TITLE)들을 참조하도록
    
    사용자가 입력한 사번에 해당하는 사원을 조회해서
    각 변수에 대입한 후 출력
*/   
DECLARE 
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    JCODE EMPLOYEE.JOB_CODE%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
    DTITLE DEPARTMENT.DEPT_TITLE%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY, DEPT_TITLE
    INTO EID, ENAME, JCODE, SAL, DTITLE
    FROM EMPLOYEE
    JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
    WHERE EMP_ID = &사번;
    
    DBMS_OUTPUT.PUT_LINE('사번 : ' || EID);
    DBMS_OUTPUT.PUT_LINE('이름 : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('부서명 : ' || DTITLE);
    DBMS_OUTPUT.PUT_LINE('직급코드 : ' || JCODE);
    DBMS_OUTPUT.PUT_LINE('급여 : ' || SAL);
END;
/
--------------------------------------------------------------------------------
/*
    1_3) ROW타입 변수 선언
         테이블의 한 행에 대한 모든 컬럼값을 담을 수 있는 변수
         변수명 테이블명%ROWTYPE;
*/
DECLARE 
    E EMPLOYEE%ROWTYPE;
BEGIN
    
    SELECT *
    INTO E
    FROM EMPLOYEE
    WHERE EMP_ID = &사번;
    
    DBMS_OUTPUT.PUT_LINE('사번 : ' || E.EMP_ID);
    DBMS_OUTPUT.PUT_LINE('이름 : ' || E.EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('직급코드 : ' || E.JOB_CODE);
    DBMS_OUTPUT.PUT_LINE('급여 : ' || E.SALARY);

END;
/

-------------------------------- 실습 문제 ---------------------------------------

/*
    ROW타입의 변수로 EMPLOYEE(EMP_ID, EMP_NAME, SALARY, BONUS, SALARY * 12)를 조회하세요
    
    사용자가 입력한 사번에 해당하는 사원을 조회해서
    각 변수에 대입한 후 출력
*/   

DECLARE 
    E EMPLOYEE%ROWTYPE;
BEGIN
    SELECT *
    INTO E
    FROM EMPLOYEE
    WHERE EMP_ID = &사번;

    DBMS_OUTPUT.PUT_LINE('사번 : ' || E.EMP_ID);
    DBMS_OUTPUT.PUT_LINE('이름 : ' || E.EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('급여 : ' || E.SALARY);
    DBMS_OUTPUT.PUT_LINE('보너스 : ' || NVL(E.BONUS,0) * 10 || '%');
    DBMS_OUTPUT.PUT_LINE('연봉 : ' || E.SALARY * 12);
END;
/

--------------------------------------------------------------------------------

/*
    2. BEGIN조건문
    
    < 조건문 >
    
    1) IF 조건식 THEN 실행내용 END IF; (단일 IF문)
*/

-- 특정 사원의 사번, 이름, 급여, 보너스율(%) 출력
-- 단, 보너스를 받지 않는 사원은 보너스율을 출력 전, '보너스를 지급받지 않는 사원입니다.' 출력

DECLARE 
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
    BONUS EMPLOYEE.BONUS%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, SALARY, NVL(BONUS, 0)
    INTO EID, ENAME, SAL, BONUS
    FROM EMPLOYEE
    WHERE EMP_ID = &사번;
    
    DBMS_OUTPUT.PUT_LINE('사번 : ' || EID);
    DBMS_OUTPUT.PUT_LINE('이름 : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('급여 : ' || SAL);
    
    
    IF BONUS = 0
       THEN DBMS_OUTPUT.PUT_LINE('보너스를 지급받지 않는 사원입니다.');
     END IF;
     
    DBMS_OUTPUT.PUT_LINE('보너스율 : ' || BONUS * 100 || '%');
     
END;
/

-------------------------------- 실습 문제 ---------------------------------------

-- 특정 사원의 사번, 이름, 급여, 보너스율, 연봉(보너스율을 합한 연봉), 직급 출력
-- 단, 보너스를 받지 않는 사원은 '보너스를 지급받지 않는 사원입니다.' 조회

DECLARE 
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SALARY EMPLOYEE.SALARY%TYPE;
    BONUS EMPLOYEE.BONUS%TYPE;
    JNAME JOB.JOB_NAME%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, SALARY, NVL(BONUS, 0), JOB_NAME
    INTO EID, ENAME, SALARY, BONUS, JNAME
    FROM EMPLOYEE E 
    JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
    WHERE EMP_ID = &사번;
    
    DBMS_OUTPUT.PUT_LINE ('사번 : ' || EID);
    DBMS_OUTPUT.PUT_LINE ('이름 : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE ('급여 : ' || SALARY);
    DBMS_OUTPUT.PUT_LINE ('보너스율 : ' || BONUS * 100 || '%');
    DBMS_OUTPUT.PUT_LINE ('연봉 : ' || (SALARY + (SALARY * BONUS)) * 12);
    DBMS_OUTPUT.PUT_LINE ('직급 : ' || JNAME);
    
    IF BONUS = 0
        THEN DBMS_OUTPUT.PUT_LINE('보너스를 받지 않는 사원입니다.');
    END IF;
    
END;
/

--------------------------------------------------------------------------------

-- 2) IF 조건식 THEN 실행내용 ELSE 실행내용 END IF;    (IF-ELSE문)

DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
    BONUS EMPLOYEE.SALARY%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, SALARY, NVL(BONUS, 0)
    INTO EID, ENAME, SAL, BONUS
    FROM EMPLOYEE
    WHERE EMP_ID = &사번;
    
    DBMS_OUTPUT.PUT_LINE ('사번 : ' || EID);
    DBMS_OUTPUT.PUT_LINE ('이름 : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE ('급여 : ' || SAL);
    
    IF BONUS = 0
        THEN DBMS_OUTPUT.PUT_LINE('보너스를 지급받지 않는 사원입니다.');
    ELSE 
        DBMS_OUTPUT.PUT_LINE ('보너스율 : ' || BONUS * 100 || '%');
    END IF;
    
END;
/

-------------------------------- 실습 문제 ---------------------------------------

-- 1) 특정 사원의 사번, 이름, 급여, 보너스율, 연봉(보너스율을 합한 연봉), 부서 출력
-- 단, 보너스를 받지 않는 사원은 'XX부서의 XX 사원은 보너스를 지급받지 않는 사원입니다.' 조회

DECLARE 
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SALARY EMPLOYEE.SALARY%TYPE;
    BONUS EMPLOYEE.BONUS%TYPE;
    DNAME DEPARTMENT.DEPT_TITLE%TYPE;
    JNAME JOB.JOB_NAME%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, SALARY, NVL(BONUS, 0), DEPT_TITLE, JOB_NAME
    INTO EID, ENAME, SALARY, BONUS, DNAME, JNAME
    FROM EMPLOYEE E
    JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
    JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
    WHERE EMP_ID = &사번;
      
    DBMS_OUTPUT.PUT_LINE ('사번 : ' || EID);
    DBMS_OUTPUT.PUT_LINE ('이름 : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE ('급여 : ' || SALARY);  
    
    IF BONUS = 0
        THEN DBMS_OUTPUT.PUT_LINE (DNAME || '의 ' || ENAME || JNAME || '은 보너스를 받지 않는 사원입니다.');
    ELSE  
        DBMS_OUTPUT.PUT_LINE('보너스율 : ' || BONUS * 100 || '%');
        DBMS_OUTPUT.PUT_LINE('연봉 : ' || (SALARY + (SALARY * BONUS)) * 12);
    END IF;

END;
/

-- 2) 특정사원의 사번, 이름, 부서명, 근무국가코드 조회 후 각 변수에 대입
--    근무국가코드가 KO일 경우 -> TEAM에 '국내팀'대입
--                아닐 경우 -> TEAM에 '해외팀'대입

DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    DTITLE DEPARTMENT.DEPT_TITLE%TYPE;
    NCODE LOCATION.NATIONAL_CODE%TYPE;
    TEAM VARCHAR2(20); -- '국내팀' 또는 '해외팀'을 담을 변수
BEGIN
    
    SELECT EMP_ID, EMP_NAME, DEPT_TITLE, NATIONAL_CODE
    INTO EID, ENAME, DTITLE, NCODE
    FROM EMPLOYEE 
    JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
    JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
    WHERE EMP_ID = &사번;
    
    IF NCODE = 'KO'
        THEN TEAM := '국내팀';
        ELSE TEAM := '해외팀';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE ('사번 : ' || EID);
    DBMS_OUTPUT.PUT_LINE ('이름 : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE ('부서 : ' || DTITLE);  
    DBMS_OUTPUT.PUT_LINE ('소속 : ' || TEAM);
    
END;
/

--------------------------------------------------------------------------------

-- 3) IF 조건식1 THEN 실행내용1 ELSIF 조건식2 THEN 실행내용2 ... [ELSE 실행내용N] END IF;     
-- 자바에서의 (IF-ELSE IF)

DECLARE 
    SCORE NUMBER;
    GRADE VARCHAR2(20);
BEGIN
    SCORE := &점수;
    
    IF SCORE >= 90 THEN GRADE := 'A';
    ELSIF SCORE >= 80 THEN GRADE := 'B';
    ELSIF SCORE >= 70 THEN GRADE := 'C';
    ELSIF SCORE >= 60 THEN GRADE := 'D';
    ELSE GRADE := 'F';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('점수 : ' || SCORE);
    DBMS_OUTPUT.PUT_LINE('학점 : ' || GRADE);
    
END;
/

-------------------------------  실습 문제 ---------------------------------------

-- 특정 사원의 급여를 조회해서 SAL변수에 대입 
-- SAL변수에 담긴 값이
-- 500만원 이상이면 '고급'등급
-- 300만원 이상이면 '중급'등급
-- 300만원 미만이면 '초급'등급 부여
-- '해당 사원의 급여 등급은 XX입니다.' 로 출력

DECLARE 
    EID EMPLOYEE.EMP_ID%TYPE;
    SALARY EMPLOYEE.SALARY%TYPE;
    GRADE VARCHAR2(20);
BEGIN       

    SELECT SALARY
    INTO SALARY
    FROM EMPLOYEE
    WHERE EMP_ID = &사번;
    
    IF SALARY >= 5000000 THEN GRADE := '고급';
    ELSIF SALARY >= 3000000 THEN GRADE := '중급';
    ELSE GRADE := '초급';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE ('해당사원의 급여는 ' || SALARY ||'원 입니다. 급여 등급은 ' || GRADE || '입니다.');
    
END;
/

--------------------------------------------------------------------------------

-- 4) CASE 비교대상자 WHEN 동등비교값1 THEN 반환값1 WHEN 동등비교값2 THEN 반환값2.. ELSE 반환값N END;
--    자바에서의 SWITCH문

DECLARE
    EMP EMPLOYEE%ROWTYPE;
    DNAME VARCHAR2(30);
BEGIN 
    SELECT *
    INTO EMP
    FROM EMPLOYEE
    WHERE EMP_ID = &사번;
    
    DNAME := CASE EMP.DEPT_CODE
             WHEN 'D1' THEN '인사팀'
             WHEN 'D2' THEN '회계팀'
             WHEN 'D3' THEN '마케팅팀'
             ELSE '기타팀'
             END;
            
    DBMS_OUTPUT.PUT_LINE ('이름 : ' || EMP.EMP_NAME);
    DBMS_OUTPUT.PUT_LINE ('부서 : ' || DNAME);
    
END;
/

-------------------------------  실습 문제 ---------------------------------------

-- 사번, 이름, 퇴사유무 확인
UPDATE EMPLOYEE
    SET ENT_YN = 'Y'
    WHERE EMP_ID BETWEEN 200 AND 208;
    
UPDATE EMPLOYEE
    SET ENT_YN = 'M'
    WHERE EMP_ID BETWEEN 211 AND 215;
    
ROLLBACK;

DECLARE 
    EMP EMPLOYEE%ROWTYPE;
    RETIRE VARCHAR2(30);
BEGIN
    
    SELECT *
    INTO EMP
    FROM EMPLOYEE
    WHERE EMP_ID = &사번;
    
    RETIRE := CASE EMP.ENT_YN
        WHEN 'Y' THEN '재직중'
        WHEN 'N' THEN '퇴사'
        WHEN 'M' THEN '이직'
    END;
    
    DBMS_OUTPUT.PUT_LINE('이름 : ' || EMP.EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('재직상태 : ' || RETIRE);
    
END;
/

--------------------------------------------------------------------------------

/*
    < 반복문 >
    
    1. BASIC LOOP문
    
    LOOP
        반복적으로 수행할 구문;
            
        * 반복문을 빠져나갈 구문
    END LOOP; 
    
    * 반복문을 빠져나갈 구문 (2가지)
    1) IF 조건식 THEN EXIT; END IF;    -- EXIT = 자바에서의 BREAK;
    2) EXIT WHEN 조건식;
    
*/

-- 1 ~ 5까지 순차적으로 1씩 증가하는 값 출력 (6이되는 순간 반복문 종료)

DECLARE 
    NUM NUMBER := 1;
BEGIN   
    LOOP
        DBMS_OUTPUT.PUT_LINE(NUM);
        
        NUM := NUM + 1;
        
       /* 반복문빠져나가는구문1)
        IF NUM = 6
        THEN EXIT;
        END IF;
        */
        
        -- 반복문빠져나가는구문2)
        EXIT WHEN NUM = 6;
        
END LOOP;

END;
/

-------------------------------  실습 문제 ---------------------------------------
/*
    번호에 따른 문제와 정답 출력
*/
DECLARE 
    QUESTION VARCHAR2(100);
    ANSWER VARCHAR2(50);
    SCORE VARCHAR2(20);
    NUM NUMBER := 1;
    
BEGIN

    LOOP

    QUESTION := CASE NUM
                WHEN 1 THEN '1 + 10을 구하시오.'
                WHEN 2 THEN '4 * 5을 구하시오.'
                WHEN 3 THEN '20 / 2을 구하시오.'
                END;

    DBMS_OUTPUT.PUT_LINE('문제' || NUM || ') ' || QUESTION);
              
    ANSWER := CASE NUM
                WHEN 1 THEN '&정답'
                WHEN 2 THEN '&정답'
                WHEN 3 THEN '&정답'
                END;

    DBMS_OUTPUT.PUT_LINE(NUM || '번 정답 : ' || ANSWER);

    NUM := NUM +1;
 
        IF NUM = 4
        THEN EXIT;
        END IF;
 
END LOOP;
END;
/

--------------------------------------------------------------------------------

/*
    2. FOR LOOP문
    
    FOR 변수 IN [REVERSE] 초기값..최종값    --> 증가값을 마음대로 조작할 수 없음, 즉 1씩 증감만 가능함!!
    LOOP
        반복적으로 실행할 구문;
    END LOOP;
*/  

-- 1 ~ 10까지 순차적으로 1씩 증가하는 값을 출력

BEGIN

    FOR NUM IN 1..10 -- FOR LOOP문은 DECLARE 작성 생략가능
    LOOP
        DBMS_OUTPUT.PUT_LINE(NUM);
    END LOOP;
    
END;
/
-- 10 ~ 1까지 순차적으로 감소하는 값을 출력
BEGIN 
    
    FOR NUM IN REVERSE 1..10
    LOOP
        DBMS_OUTPUT.PUT_LINE(NUM);
    END LOOP;
    
END;
/

--------------------------------------------------------------------------------

/*
    3. WHILE LOOP문
    
    WHILE 반복문이수행될조건     --> 거짓이 되는 순간 반복 종료
    LOOP
        반복적으로 수행할 구문;
    END LOOP;
*/

-- 1 ~ 5 까지 반복
DECLARE
    NUM NUMBER := 1;
BEGIN

    WHILE NUM < 6 --> I = 6 되면 '거짓'이므로 반복 종료
    LOOP
        DBMS_OUTPUT.PUT_LINE(NUM);
        NUM := NUM + 1;
    END LOOP;
    
END;
/

-- 5 ~ 1 까지 반복
DECLARE 
    NUM NUMBER := 5;
BEGIN 
    WHILE NUM > 0
    LOOP
        DBMS_OUTPUT.PUT_LINE(NUM);
        NUM := NUM-1;
    END LOOP;
END;
/

-------------------------------  실습 문제 ---------------------------------------

CREATE TABLE TEST
(
    BOARD_NO NUMBER PRIMARY KEY,
    BOARD_TITLE VARCHAR2(200) NOT NULL,
    BOARD_CONTENT VARCHAR2(300) NOT NULL,
    RESIST_DATE DATE
);

-- DROP TABLE TEST;

CREATE SEQUENCE SEQ_NUM
NOCACHE;

-- DROP SEQUENCE SEQ_NUM;

BEGIN
    FOR NUM IN 1..150
    LOOP
        INSERT INTO TEST 
            VALUES (SEQ_NUM.NEXTVAL, '제목' || SEQ_NUM.NEXTVAL, '내용' || SEQ_NUM.NEXTVAL, SYSDATE);
    END LOOP;
END;
/

--------------------------------------------------------------------------------

/*
    3. 예외처리부
    
    예외 (EXCEPTION) : 실행 중 발생하는 오류
    
    [표현법]
    EXCEPTION   
        WHEN 예외명1 THEN 예외처리구문1;     --> 자바에서의 TRY ~ CATCH블럭
        WHEN 예외명2 THEN 예외처리구문2;
        ...
        WHEN OTHERS THEN 예외처리구문N;   -> 어떤 예외가 발생하든 하나의 예외처리구문으로 해결
        
    * 시스템예외
    1) NO_DATA_FOUND : SELECT한 결과가 한 행도 없는 경우
    2) TOO_MANY_ROWS : SELECT한 결과가 여러행일 경우
    3) ZEOR_DIVIDE : 0으로 나눗셈 연산했을 경우
    4) DUP_VAL_ON_INDEX : UNIQUE 제약조건에 위배했을 경우
    ...
    
*/
-- 사용자가 입력한 수로 나눗셈 연산한 결과 출력
DECLARE
    RESULT NUMBER;
BEGIN 
    RESULT := 20 / &숫자;
    DBMS_OUTPUT.PUT_LINE('결과값 : ' || RESULT);
EXCEPTION
    WHEN ZERO_DIVIDE THEN DBMS_OUTPUT.PUT_LINE('0으로 나눌 수 없습니다.');
END;
/

-- 사용자에게 값 입력받아서 산술연산하기

DECLARE 
    NUM1 NUMBER;
    NUM2 NUMBER;
    STR VARCHAR2(10);
    RESULT NUMBER;
BEGIN 
    
    NUM1 := &숫자;
    NUM2 := &숫자;
    STR := '&산술연산';

    RESULT := CASE STR 
              WHEN '+' THEN NUM1 + NUM2
              WHEN '-' THEN NUM1 - NUM2
              WHEN '*' THEN NUM1 * NUM2
              WHEN '/' THEN NUM1 / NUM2
              END;
    
    DBMS_OUTPUT.PUT_LINE('결과 : ' || RESULT);
    
    EXCEPTION
        WHEN ZERO_DIVIDE THEN DBMS_OUTPUT.PUT_LINE('0으로 나눌 수 없습니다.');
    
END;
/
    
-- UNIQUE 제약조건에 위배
BEGIN

    UPDATE EMPLOYEE
        SET EMP_ID = &변경할사번
        WHERE EMP_NAME = '방명수';
        
        DBMS_OUTPUT.PUT_LINE('사번이 변경되었습니다.');

EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN DBMS_OUTPUT.PUT_LINE('이미 존재하는 사번입니다.');

END;
/

ROLLBACK;

-- TOO_MANY_ROWS / NO_DATA_FOUND 예외 발생

DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME
    INTO EID, ENAME
    FROM EMPLOYEE
    WHERE MANAGER_ID = &사번;

    DBMS_OUTPUT.PUT_LINE('사번 : ' || EID);
    DBMS_OUTPUT.PUT_LINE('이름 : ' || ENAME); 

EXCEPTION
    -- WHEN TOO_MANY_ROWS THEN DBMS_OUTPUT.PUT_LINE('너무 많은 사원들이 조회되었습니다.');
    -- WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('조회 결과가 없습니다.');
    WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('너무 많은 사원이 조회되거나 조회 결과가 없습니다.');
    
END;
/
