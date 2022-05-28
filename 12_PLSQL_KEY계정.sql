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





