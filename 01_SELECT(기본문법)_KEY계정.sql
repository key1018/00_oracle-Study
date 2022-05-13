/*
    * SELECT문
    데이터 조회할 때 사용되는 구문
    
    >> RESULT SET : SELECT문을 통해서 조회된 결과물 (즉, 조회된 행들의 집합을 의미)
    
    [기본표현법]
    SELECT 칼럼명, 칼럼명, ...
    FROM 테이블명;
*/

-- EMPLOYEE 테이블에 있는 모든 칼럼 조회
SELECT * FROM EMPLOYEE;

-- EMPLOYEE 테이블에 있는 사번, 이름, 핸드폰 번호 조회
SELECT EMP_ID, EMP_NAME, PHONE FROM EMPLOYEE;

-- EMPLOYEE 테이블에 있는 이름, 월급, 입사일 조회
select emp_name, salary, hire_date from employee;
-- 위의 구문 처럼 오라클에 있는 기본 키워드, 테이블명, 칼럼명들을 대소문자를 가리지 않는다

-- EMPLOYEE 테이블에 있는 이름, 주민번호, 이메일 조회
SELECT emp_name, emp_no, EMAIL FROM employee;
-- 더불어 낙타 표기법도 가능하다
-- 단! '데이터 값(칼럼값)'을 제시할 경우 대소문자 가림

-- JOB 테이블에 있는 모든 데이터 조회
SELECT * FROM JOB;

-- DEPARTMENT 테이블에 있는 부서코드, 부서명만 조회
SELECT DEPT_ID, DEPT_TITLE FROM DEPARTMENT;

--------------------------------------------------------------------------------

/*
    < 칼럼값을 통한 산술연산 >
    SELECT절에 칼럼명 작성시 산술연산식 기술 가능(이때 산술결과가 조회됨)
*/

-- EMPLOYEE 테이블에 있는 월급 칼럼값을 통해 연봉 조회
-- 연봉 : 월급 * 12
SELECT SALARY * 12 FROM EMPLOYEE;

-- EMPLOYEE 테이블에 있는 사원코드, 사원명, 연봉 조회
SELECT EMP_ID, EMP_NAME, SALARY * 12 FROM EMPLOYEE;

-- EMPLOYEE 테이블에 있는 사원명, 연봉, 보너스가 포함된 연봉 조회
-- 보너스가 보함된 연봉 : (월급 + 월급 * 보너스) * 12
SELECT EMP_NAME, SALARY * 12 , (SALARY + SALARY * BONUS)*12
FROM EMPLOYEE;
-- 산술연산 과정 중 NULL값이 존재할 경우 결과값은 무조건 NULL로 조회됨

-- EMPLOYEE 테이블에 있는 사원명, 입사일, 근무일수 조회
-- 근무일수 : 오늘날짜 - 입사일 (DATE 타입)
-- ** 오늘날짜 : SYSDATE (DATE 타입)
SELECT EMP_NAME, HIRE_DATE, SYSDATE - HIRE_DATE
FROM EMPLOYEE;
-- 근무일수, 오늘날짜 모두 DATE 타입
-- DATE - DATE 끼리의 산술결과는 '일' 단위가 맞음
-- 단! .뒤에 소수점들도 같이 조회되는 것은 DATE 형식은 년/월/일/시/분/초 단위로 시간정보까지도 관리하기 때문에 같이 조회됨
-- 이러한 이유때문에 산술연산을 할 때마다 소수점의 결과값이 바뀐다!

-- 현재 날짜 및 시간만 조회하기
SELECT SYSDATE FROM DUAL;
-- DUAL은 오라클에서 제공하는 가상 테이블(더미테이블)
-- SELECT를 활용할 때는 무조건 FROM을 사용해야하기 때문에 시스템에 있는 날짜를 조회할 때는 가상테이블(DUAL)을 지정한다

--------------------------------------------------------------------------------

/*
    < 칼럼명에 별칭 지정하기 >
    
   1) 칼럼명 | 산술식 (공백) 별칭
   2) 칼럼명 | 산술식 AS 별칭
   3) 칼럼명 | 산술식 "별칭"
   4) 칼럼명 | 산술식 AS "별칭"
   ==> 차이점이 없으므로 원하는 것 아무거나 사용할 수 있다
*/

-- EMPLOYEE 테이블에서 사원코드, 사원명, 연봉, 보너스 포함된 연봉 조회
-- 별칭 : 사원코드, 사원명, 연봉(원), 총 소득
SELECT EMP_NAME 사원코드, EMP_NAME AS 사원명, SALARY * 12 "연봉(원)", (SALARY + SALARY * BONUS) * 12 AS "총 소득"
FROM EMPLOYEE;
-- 별칭에 공백 또는 특수문자가 포함되어있는 경우 : 무조건 더블쿼테이션("")로 기술해야함

-- DEPARTMENT 테이블에서 부서코드, 부서명 조회
-- 별칭 : 부서코드, 부서명
SELECT DEPT_ID 부서코드, DEPT_TITLE AS 부서명
FROM DEPARTMENT;

--------------------------------------------------------------------------------

/*
    < 리터럴 >
    임의로 지정한 문자열(' ')
    
    SELECT절에 리터럴을 제시하면 조회되는 모든 행에 반복적으로 같이 출력
*/

-- EMPLOYEE 테이블에서 사원명, 이메일, 핸드폰번호, 월급 조회
-- 단, 월급에 '원'이라는 리터럴을 추가하기
SELECT EMP_NAME, EMAIL, PHONE, SALARY, '원'
FROM EMPLOYEE;

-- 월급 '원' 리터럴데 "단위"라는 별칭 추가하기
SELECT EMP_NAME, EMAIL, PHONE, SALARY, '원' "단위"
FROM EMPLOYEE;

--------------------------------------------------------------------------------

/*
    < 연결 연산자 || >
    - 자바에서의 || 의 의미 : OR
    - 오라클에서의 || 의 의미 : +
      => 여러 값들을 마치 하나인거 처럼 연결시켜주는 연산자
    
    System.out.println("num : " + num); => 여기서의 + 를 의미함
*/

-- EMPLOYEE 테이블에서 사번, 'XXX님의 월급은 XXX원 입니다.' 조회
SELECT EMP_ID, EMP_NAME || '님의 월급은 ' || SALARY || '원 입니다.'
FROM EMPLOYEE;

-- EMPLOYEE 테이블에서 사번, 'XXX님의 월급은 XXX원이고, 연봉은 XXX원 입니다.' 조회
-- 별칭 : 사번, 총 소득
SELECT EMP_ID "사번" , EMP_NAME || '님의 월급은 ' || SALARY || '원 이고, 연봉은 ' || SALARY * 12 || '원 입니다.' "총 소득"
FROM EMPLOYEE;

-- DEPARTMENT 테이블에서 '코드 XXX의 부서명은 XXX입니다.' 조회
-- XXX : 부서코드, 부서명
-- 별칭 : 부서명 조회
SELECT '코드 ' || DEPT_ID || '의 부서명은 ' || DEPT_TITLE || '입니다.' AS "부서명 조회"
FROM DEPARTMENT;

--------------------------------------------------------------------------------
