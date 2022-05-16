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

/*
    < DISTINCT >
    컬럼에 중복된 값들을 한번씩만 조회하고자 할 때 사용
*/

SELECT * FROM EMPLOYEE;

-- EMPLOYEE에서 직급코드(JOB_CODE) 중복제거
SELECT DISTINCT JOB_CODE
FROM EMPLOYEE;

-- EMPLOYEE에서 사수(MANAGER_ID) 중복제거
SELECT DISTINCT MANAGER_ID
FROM EMPLOYEE;

-- EMPLOYEE에서 부서코드 중복제거
SELECT DISTINCT DEPT_CODE
FROM EMPLOYEE; 
-- NULL값은 신입사원

-- EMPLOYEE에서 부서코드, 직급코드 중복제거
SELECT DISTINCT DEPT_CODE, JOB_CODE
FROM EMPLOYEE;
-- 쌍으로 묶어서 중복판별 가능함

-- EMPLOYEE에서 부서코드, 직급코드, 사수, 보너스 중복제거
SELECT DISTINCT DEPT_CODE, JOB_CODE, MANAGER_ID, BONUS
FROM EMPLOYEE;

-- 유의사항 : DISTINCT는 SELECT절에 한 번만 기술 가능
--SELECT DISTINCT JOB_CODE, DISTICT DEPT_CODE -- 조회되는 행수가 다를 수 있어서 애초에 조회가 불가능함
--FROM EMPLOYEE;

-- =============================================================================

/*
    * WHERE절
    조회하고자하는 테이블로부터 특정 조건에 만족하는 테이블만을 조회하고자 할 때 사용
    이 때 WHERE절에는 조건식을 제시하게됨
    조건식에서는 다양한 연산자들 사용 가능
    
    [표현법]
    SELECT 조회하고자하는칼럼, 칼럼, 산술연산식, .. 
    FROM 테이블명
    WHERE 조건식;
    
    < 비교 연산자 > 
    >, <, >=, <=    : 대소비교연산자
    =               : 동등비교연산자(같은지 비교)
    !=, ^=, <>      : 동등비교연산자(같지않은지 비교)

*/

-- EMPLOYEE에서 부서코드가 D9인 사원들만 조회
SELECT EMP_NAME, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE='D9';

-- EMPLOYEE에서 부서코드가 D1인 사원들의 이름, 부서코드, 월급 조회
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE= 'D1';

-- EMPLOYEE에서 부서코드가 D1이 아닌 사원들의 이름, 이메일, 핸드폰번호 조회
SELECT EMP_NAME, EMAIL, PHONE
FROM EMPLOYEE
-- WHERE DEPT_CODE != 'D1';
-- WHERE DEPT_CODE <> 'D1';
WHERE DEPT_CODE ^= 'D1';

/*
-- EMPLOYEE에서 핸드폰번호가 NULL인 사원들의 이름 조회
SELECT EMP_NAME
FROM EMPLOYEE
WHERE PHONE = NULL;
-- NULL은 일반 비교 연산자로 조회 안됨
-- 즉, NULL값은 데이터가 조건식에서 자동으로 제거된다
*/

-- 급여가 400만원 이상인 사원들의 이름명, 부서코드, 급여 조회
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY >= 4000000;

-- 급여가 200만원 이상 500만원 이하인 사원들의 이름명, 부서코드, 급여, 입사년도 조회
SELECT EMP_NAME, DEPT_CODE, SALARY, HIRE_DATE
FROM EMPLOYEE
WHERE 2000000 <= SALARY AND SALARY <= 5000000;

-- 연봉이 4000만원 이상인 사원들의 이름명, 급여, 연봉, 입사년도 조회
SELECT EMP_NAME, SALARY, SALARY * 12, HIRE_DATE
FROM EMPLOYEE
WHERE SALARY * 12 >= 40000000;


-- 현재 퇴사한 모든 사원들의 사번, 이름, 입사년도, 퇴사년도 조회
SELECT EMP_ID, EMP_NAME, HIRE_DATE, ENT_DATE
FROM EMPLOYEE
WHERE ENT_YN = 'Y';

-- 실행순서 : FROM절 => SELECT절 => WHERE절


--------------------------------------------------------------------------------

/*
    < 논리 연산자 >
    여러개의 조건을 엮어서 하나로 제시하고자 할 때 사용
    
    AND (~이면서, 그리고) : 자바에서의 &&와 같은 의미
    OR (~이거나, 또는) : 자바에서의 ||와 같은 의미

*/

-- 부서코드가 'D9'이면서 급여가 500만원 이상인 사원들의 사원명, 부서코드, 급여 조회
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9' AND SALARY >= 5000000;

-- 급여가 330만원 이상 600만원 이하인 사원중에 부서코드가 'D9'인 사원들의 사원명, 부서코드, 급여 조회
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE (3300000 <= SALARY AND SALARY <= 6000000) AND DEPT_CODE = 'D9';

-- 부서코드가 'D6'이거나 급여가 300만원 이상인 사원들의 사원명, 부서코드, 급여 조회
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D6' OR SALARY >= 3000000;


--------------------------------------------------------------------------------

/*
    < BETWEEN AND >
    조건식에서 사용되는 구문
    특정 값 이상 특정 값 이하인 범위에 대한 조건을 제시할 때 사용되는 연산자
    
    [표현법]
    비교대상칼럼 BETWEEN 특정값(이상) AND 특정값(이하);

*/  

-- 350만원 이상 600만원 이하 사원 검색
SELECT EMP_NAME, SALARY
FROM EMPLOYEE
WHERE SALARY BETWEEN 3500000 AND 6000000;


SELECT EMP_NAME, EMP_ID, SALARY
FROM EMPLOYEE
-- WHERE SALARY < 3500000 OR SALARY > 6000000;
-- WHERE SALARY NOT BETWEEN 3500000 AND 6000000;
WHERE NOT SALARY BETWEEN 3500000 AND 6000000;
-- 350만원 미만 600만원 초과하는 사원 검색 (위 3개 항목 모두 가능)
-- NOT : 논리부정연산자 (자바에서의 ! 같은 존재)
-- 컬럼명 앞 또는 BETWEEN 앞에 기입 가능


-- 입사일이 '90/01/01' ~ '01/01/01'인 사원 전체 조회
SELECT *
FROM EMPLOYEE
WHERE HIRE_DATE BETWEEN '90/01/01' AND '01/01/01';

-- 입사일이 '90/01/01' ~ '01/01/01'인 사원 중 부서코드가 'D6'인 사원 조회
SELECT *
FROM EMPLOYEE
WHERE (HIRE_DATE BETWEEN '90/01/01' AND '01/01/01') AND DEPT_CODE = 'D6';

--------------------------------------------------------------------------------

/*
    < LIKE >
    비교대상의 컬럼값이 내가 제시한 특정 패턴에 "만족"할 경우 조회
    
    [표현법]
    비교대상칼럼 LIKE '특정패턴'
    - 특정패턴 제시시 %, _ 와 같은 와일드 카드로 작성 가능
    
    >> % : 0글자 이상
    EX) 비교대상컬럼 LIKE '문자%' => 비교대상의 컬럼값이 해당 문자로 "시작"될 경우 조회 (뒤가 어떤 문자, 몇글자가 오든 상관 없음)
        비교대상컬럼 LIKE '%문자' => 비교대상의 컬럼값이 해당 문자로 "끝"날 경우 조회 (앞이 어떤 문자, 몇글자가 오든 상관 없음)
        비교대상컬럼 LIKE '%문자%' => 비교대상의 컬럼값에 해당 글자가 "포함"되어 있을 경우 조회 (키워드 검색 : 앞 뒤에 어떤문자, 몇글자가 오든 상관없음) 
                                  - 앞, 뒤, 중간에 "포함"만 되어있으면 조회됨
                                  
    >> _ : 1글자 
    EX) 비교대상의컬럼 LIKE '__문자' => 비교대상의 컬럼값이 특정 "두 글자"뒤에 해당 문자가 올 경우 조회 (특정 글자는 어떤 글자인지 모름)
        비교대상의컬럼 LIKE '_문자_' => 비교대상의 컬럼값에 해당 문자 "앞과 뒤에 한글자"씩 올 경우 조회
*/

-- 사원들 중 성이 이씨인 사원들의 사원명, 급여, 연봉 조회
SELECT EMP_NAME, SALARY, SALARY * 12 "연봉"
FROM EMPLOYEE
WHERE EMP_NAME LIKE '이%';


-- 이름 중에 '하'가 포함된 사원들의 사원명, 급여, 부서코드, 입사일 조회
SELECT EMP_NAME, SALARY, DEPT_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE EMP_NAME LIKE '%하%';

-- 이름의 가운데 글자가 '은'인 사원들의 사원명, 주민번호, 이메일 조회
SELECT EMP_NAME, EMP_NO, EMAIL
FROM EMPLOYEE
WHERE EMP_NAME LIKE '_은_';

-- 전화번호의 3번째 자리가 1인 사원들의 사번, 사원명, 이메일 조회
-- 와일드카드 : _(1글자), %(0글자이상)
SELECT EMP_ID, EMP_NAME, EMAIL, PHONE
FROM EMPLOYEE
WHERE PHONE LIKE '__1%';

-- 이메일 값 중 세번째 자리가 _인 사원들의 사번, 이름, 이메일 조회
SELECT EMP_ID, EMP_NAME, EMAIL
FROM EMPLOYEE
WHERE EMAIL LIKE '___%'; -- 원하는 결과 도출 불가
-- 어떤 값이 와일드카드고 데이터값인지 구분되지 않음 => 기본적으로 와일드카드로 인식

-- 위의 사원들이 아닌 그 외의 사원들 조회 (이메일 값 중 세번째 자리가 _가 아닌 사람들)
SELECT EMP_ID, EMP_NAME, EMAIL
FROM EMPLOYEE
WHERE EMAIL NOT LIKE '__!_%' ESCAPE '!';

SELECT EMP_ID, EMP_NAME, EMAIL
FROM EMPLOYEE
WHERE EMAIL LIKE '__$_%' ESCAPE '$';
-- ESCAPE 구문을 통해 '$'는 나만의 와일드카드라는 것을 명시해햐함 (ESCATE OPTION으로 등록)

-- 주민번호 중 네번째 자리가 2인 사원들의 사번, 이름, 주민번호 조회
SELECT EMP_ID, EMP_NAME, EMP_NO
FROM EMPLOYEE
WHERE EMP_NO LIKE '___2%';


-- 입사일 중 월이 '09'월인 사원들의 사원명, 부서코드, 입사일 조회
SELECT EMP_NAME, DEPT_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE HIRE_DATE LIKE '___09%';

-- EMPLOYEE에서 전화번호 처음 3자리가 010이 아닌 사원들의 사원명, 전화번호 조회
SELECT EMP_NAME, PHONE
FROM EMPLOYEE
WHERE PHONE NOT LIKE '010%';

-- EMPLOYEE에서 이름에 '하'가 포함되어있으면서 급여가 240만원 이상인 사원들의 사원명, 급여 조회
SELECT EMP_NAME, SALARY
FROM EMPLOYEE
WHERE EMP_NAME LIKE '%하%' AND SALARY >= 2400000;

-- DEPARTMENT에서 해외영업관련한 부서들의 부서코드, 부서명 조회
SELECT DEPT_ID, DEPT_TITLE
FROM DEPARTMENT
WHERE DEPT_TITLE LIKE '해외영업%';

--------------------------------------------------------------------------------

/*
    < IS NULL / IS NOT NULL >
    컬럼값에 NULL이 존재할 경우
    해당 컬럼에 담긴 값이 NULL인지 아닌지 비교할 때 사용되는 연산자
    
*/

-- 보너스를 받지 않는 사원들의 사번, 사원명, 급여, 보너스 조회
-- 보너스를 받지 않은 사원(BONUS = NULL)
SELECT EMP_ID, EMP_NAME, SALARY, BONUS
FROM EMPLOYEE
WHERE BONUS IS NULL;

-- 보너스를 받는 사원들의 사번, 사원명, 급여, 보너스 조회
SELECT EMP_ID, EMP_NAME, SALARY, BONUS
FROM EMPLOYEE
WHERE BONUS IS NOT NULL;
-- NOT은 컬럼명 앞 또는 IS 뒤에 기입 가능
-- NULL값은 동등비교연산자로 조회 불가능

-- 사수가 없는 사원들의 사원명, 사수사번, 부서코드 조회
SELECT EMP_NAME, MANAGER_ID, DEPT_CODE
FROM EMPLOYEE
WHERE MANAGER_ID IS NULL;

-- 부서배치를 아직 받지 않았지만 보너스는 받는 사원의 이름, 보너스, 부서코드 조회
SELECT EMP_NAME, BONUS, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE IS NULL AND BONUS IS NOT NULL;

-- 사원들 중 퇴사한 사원의 사원명, 입사일, 퇴사일 조회
SELECT EMP_NAME, HIRE_DATE, ENT_DATE
FROM EMPLOYEE
WHERE ENT_DATE IS NOT NULL;


--------------------------------------------------------------------------------

/*
    < IN >
    비교대상컬럼값이 내가 제시한 목록중에 일치하는 값이 있는지
    있으면 조회, 없으면 조회X
    
    [표현법] 
    비교대상컬럼 IN (값1, 값2, ...) 
*/

-- 부서코드가 D6이거나 D8이거나 D5인 부서원들의 사원명, 부서코드, 급여 조회
SELECT EMP_NAME, DEPT_CODE, SALARY 
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D6', 'D8', 'D5');

-- 사수코드가 200이거나 207인 사원의 사원명, 이메일, 핸드폰번호, 사수코드 조회
SELECT EMP_NAME, EMAIL, PHONE, MANAGER_ID
FROM EMPLOYEE
WHERE MANAGER_ID IN ('200', '207');

--------------------------------------------------------------------------------

-- 직급코드(JOB_CODE)가 J7이거나 J2인 사원들 중 급여가 200만원 이상인 사원들의 모든 컬럼 조회
SELECT *
FROM EMPLOYEE
-- WHERE JOB_CODE IN ('J7', 'J2') AND SALARY >= 2000000;
WHERE (JOB_CODE = 'J7' OR JOB_CODE = 'J2') AND SALARY >= 2000000;
-- OR 연산보다 AND연산이 기본적으로 먼저 수행

/*
    < 연산자 우선 순위 >
    0. ()
    1. 산술연산자
    2. 연결연산자 ( || )
    3. 비교연산자
    4. IS NULL / LIKE '특정패턴' / IN 
    5. BETWEEN AND
    6. NOT 논리연산자
    7. AND
    8. OR
*/

-- =============================================================================

/*
    * ORDER BY 절
    SELECT문 가장 마지막 줄에 작성하면됨
    뿐만아니라 실행순서 또한 마지막에 실행
    
    [표현법]
    3. SELECT 조회할컬럼, 컬럼, 산술연산식 [AS] "별칭", ...
    1. FROM 조회할테이블명
    2. WHERE 조건식 
    4. ORDER BY 정렬기준의컬럼명 | 별칭 | 컬럼순번   [ASC(오름차순) | DESC(내림차순)]  [NULLS FIRST | NULLS LAST];
    
    - ASC : 오름차순 정렬(생략시 기본값)
    - DESC : 내림차순 정렬
    
    - NULLS FIRST : 정렬하고자 하는 컬럼값에 NULL이 있을 경우 해당 데이터를 앞에 배치 (DESC일때 기본값)
    - NULLS LAST :                                     해당 데이터를 뒤에 배치 (ASC일때 기본값)
*/

-- 전체사원들의 이름 오름차순 정렬
SELECT EMP_NAME, PHONE, EMAIL, SALARY
FROM EMPLOYEE
WHERE EMP_NAME LIKE '송%'
ORDER BY SALARY DESC;

-- 전체사원들의 급여 오름차순 정렬
SELECT *
FROM EMPLOYEE
ORDER BY SALARY;

-- 전체사원들의 급여 내림차순 정렬
SELECT *
FROM EMPLOYEE
ORDER BY SALARY DESC;

-- 전체사원들의 보너스 오름차순, NULL 값 앞에 비치
SELECT *
FROM EMPLOYEE
ORDER BY BONUS NULLS FIRST;

-- 전체 사원들의 사원명, 보너스, 급여 중 보너스는 내림차순, 급여는 오름차순으로 조회
SELECT EMP_NAME, BONUS, SALARY
FROM EMPLOYEE
ORDER BY BONUS DESC, SALARY ASC;
-- DESC는 NULLS FIRST가 기본값
-- 정렬기준 여러개 제시 가능 (첫번째 기준의 칼럼값이 동일할 경우 두번쨰 기준의 칼럼값으로 정렬)

-- 전체 사원들의 이름, 주민번호 중 주민번호 오름차순으로 조회
SELECT EMP_NAME, EMP_NO
FROM EMPLOYEE
ORDER BY EMP_NO ASC;

-- 전체 사원들의 이름, 주민번호, 입사일중 입사일 내림차순으로 조회
SELECT EMP_NAME, EMP_NO, HIRE_DATE
FROM EMPLOYEE
ORDER BY HIRE_DATE DESC;
-- DATE도 설정가능

SELECT EMP_NAME, SALARY * 12 "연봉"
FROM EMPLOYEE
-- ORDER BY SALARY * 12 DESC;
-- ORDER BY 연봉 DESC; -- 별칭 사용 가능
ORDER BY 2 DESC; -- 컬럼 순번 사용 가능 

SELECT HIRE_DATE, ENT_DATE
FROM EMPLOYEE
ORDER BY 1 DESC;



