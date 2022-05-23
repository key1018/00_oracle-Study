/*
    * 서브쿼리 (SUBQUERY)
    - 하나의 SQL문 안에 포함된 또다른 SELECT문(쿼리문)
    - 메인 SQL문을 위해 보조 역할을 하는 쿼리문
*/
-- 간단 서브쿼리 예시1. 
-- 하이유 사원과 같은 직급에 속한 사원을 조회
-- 1) 하이유 사원의 직급코드 조회
SELECT JOB_CODE
FROM EMPLOYEE
WHERE EMP_NAME = '하이유'; -- J5

-- 2) 직급코드가 J5인 사원들 조회
SELECT EMP_NAME
FROM EMPLOYEE
WHERE JOB_CODE = 'J5';

-- 3) 위의 두 구문을 합치기
SELECT EMP_NAME
FROM EMPLOYEE
WHERE JOB_CODE = (SELECT JOB_CODE
                    FROM EMPLOYEE
                    WHERE EMP_NAME = '하이유')
AND EMP_NAME <> '하이유';

-- 간단 서브쿼리 예시 2.
-- 전 사원의 평균 급여보다 더 많은 급여를 받는 사원들의 사번, 이름, 직급코드, 급여 조회
-- 1) 전 사원의 평균 급여 조회
SELECT ROUND(AVG(SALARY))
FROM EMPLOYEE; -- 3047663

-- 2) 급여가 3047663원 이상인 사원들 조회
SELECT EMP_NAME
FROM EMPLOYEE
WHERE SALARY >= 3047663; 

-- 3) 위의 구문 합치기
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY >= (SELECT ROUND(AVG(SALARY))
                   FROM EMPLOYEE);
--------------------------------------------------------------------------------
/*
    * 서브쿼리 구분
    서브쿼리를 수행한 결과값이 몇 행 몇 열이냐에 따라서 분류됨
    
    - 단일행 서브쿼리 : 서브쿼리의 조회 결과값의 갯수가 오로지 1개일 때 (1행 1열)
    - 다중행 [단일열] 서브쿼리 : 서브쿼리의 조회 결과값이 여러행일 때 (여러행 1열 - 하나의 컬럼으로 조회될 때)
    - [단일행] 다중열 서브쿼리 : 서브쿼리의 조회 결과값이 한 행이지만 컬럼이 여러개일 때 (1행 여러열)
    - 다중행 다중열 서브쿼리 : 서브쿼리의 조회 결과값이 여러행 여러컬럼일 때
*/

/*
    1. 단일행 서브쿼리 (SINGLE ROW SUBQUERY)
    서브쿼리의 조회 결과값의 갯수가 1개 일 때 (1행 1열)
    
    비교연산자 사용 가능 ( =, != , >, <, ...)
*/
-- 1) 최대 급여를 받는 사원의 사번, 이름, 급여, 입사일(XXXX년 XX월 XX일(X)) 조회
SELECT EMP_ID, EMP_NAME, SALARY, TO_CHAR(HIRE_DATE , 'YYYY"년" MM"월" DD"일" (DY)') "입사일"
FROM EMPLOYEE
WHERE SALARY = (SELECT MAX(SALARY)
                  FROM EMPLOYEE);

-- 2) 전지연 사원보다 급여를 많게 받는 사원들의 사번, 이름, 부서명, 직급명, 급여, 연봉 구하기
-->> ANSI 구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, SALARY, SALARY * 12
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN JOB USING(JOB_CODE)
WHERE SALARY >= (SELECT SALARY -- 3660000
                  FROM EMPLOYEE
                  WHERE EMP_NAME = '전지연');

-->> 오라클 구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, J.JOB_NAME, SALARY, SALARY * 12
FROM EMPLOYEE E, DEPARTMENT, JOB J
WHERE SALARY >= (SELECT SALARY
                FROM EMPLOYEE
                WHERE EMP_NAME = '전지연')
AND DEPT_CODE = DEPT_ID
AND E.JOB_CODE = J.JOB_CODE;

-- 3) 송종기 사원과 같은 부서원들의 사번, 사원명, 전화번호, 입사일, 부서명, 직급명 조회
-->> 오라클 구문
SELECT EMP_ID, EMP_NAME, PHONE, HIRE_DATE, JOB_NAME
FROM EMPLOYEE E, JOB J, DEPARTMENT
WHERE DEPT_CODE = (SELECT DEPT_CODE
                   FROM EMPLOYEE
                   WHERE EMP_NAME = '송종기')
AND E.JOB_CODE = J.JOB_CODE
AND DEPT_CODE = DEPT_ID
AND EMP_NAME != '송종기';

-->> ANSI 구문
SELECT EMP_ID, EMP_NAME, PHONE, HIRE_DATE, JOB_NAME
FROM EMPLOYEE E
JOIN JOB J USING(JOB_CODE)
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE DEPT_CODE = (SELECT DEPT_CODE
                   FROM EMPLOYEE
                   WHERE EMP_NAME = '송종기')
AND EMP_NAME ^= '송종기';

-- 4) 부서별 급여합 가장 큰 부서의 부서코드, 급여합 조회
SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING SUM(SALARY) = (SELECT MAX(SUM(SALARY))
                               FROM EMPLOYEE
                          GROUP BY DEPT_CODE);

-- 5) 부서별 급여합 가장 작은 부서의 부서코드, 부서명, 급여합 조회
SELECT DEPT_CODE, DEPT_TITLE, SUM(SALARY)
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
GROUP BY DEPT_CODE, DEPT_TITLE
HAVING SUM(SALARY) = (SELECT MIN(SUM(SALARY))
                            FROM EMPLOYEE
                            JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
                            GROUP BY DEPT_CODE, DEPT_TITLE);

--------------------------------------------------------------------------------
/*
    2. 다중행 서브쿼리 (MULTI ROW SUBQUERY)
    
    IN 서브쿼리 : 여러개의 결과값 중에 한개라도 일치하는 값이 있으면 조회 (동등비교연산자)
    > ANY 서브쿼리 : 여러개의 결과값 중에 "한개라도 클 경우" 조회 (여러 개의 결과값 중에 가장 작은 값보다 클 경우 조회)
    < ANY 서브쿼리 : 여러개의 결과값 중에 "한개라도 작을 경우" 조회 (여러 개의 결과값 중에 가장 큰 값보다 작을 경우 조회)
        
    비교대상 > ANY (값1, 값2, 값3)
    비교대상 > 값1 OR 비교대상 > 값2 OR 비교대상 > 값3
    
    > ALL 서브쿼리 : 여러개의 "모든" 결과값들보다 클 경우 조회
    < ALL 서브쿼리 : 여러개의 "모든" 결과값들보다 작을 경우 조회
    
     비교대상 > ALL (값1, 값2, 값3)
     비교대상 > 값1 AND 비교대상 > 값2 AND 비교대상 > 값3
*/
-- 1. IN / =ANY 서브쿼리 : 여러개의 결과값 중에 한개라도 일치하는 값이 있으면 조회 (동등비교연산자)
-- 1) 노옹철 또는 유재식 사원과 같은 직급인 사원들의 사번, 사원명, 직급코드, 급여 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE JOB_CODE IN (SELECT JOB_CODE
                    FROM EMPLOYEE
                    WHERE EMP_NAME IN ('유재식', '노옹철'));
                    
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE JOB_CODE = ANY (SELECT JOB_CODE
                    FROM EMPLOYEE
                    WHERE EMP_NAME = ANY ('유재식', '노옹철'));
-- IN 과 =ANY 모두 써도됨!!!

-- 2) 장쯔위 또는 임시환 사원과 부서명이 동일한 사원의 이름, 부서명, 핸드폰번호, 이메일 조회
SELECT EMP_NAME, DEPT_TITLE "부서명", PHONE, EMAIL
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE DEPT_TITLE IN (SELECT DEPT_TITLE
                     FROM EMPLOYEE
                     JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
                     WHERE EMP_NAME IN ('장쯔위', '임시환'))
ORDER BY 부서명;

SELECT EMP_NAME, DEPT_TITLE "부서명", PHONE, EMAIL
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE DEPT_TITLE = ANY (SELECT DEPT_TITLE
                     FROM EMPLOYEE
                     JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
                     WHERE EMP_NAME = ANY ('장쯔위', '임시환'))
ORDER BY 부서명;

-- 2. > / < ANY 서브쿼리
-- 1) 대리 직급임에도 불구하고 과장 직급 급여들 중 최소 급여보다 많이 받는 직원 조회 (사번, 이름, 직급명, 급여)
-- > ANY 서브쿼리 : 여러개의 결과값 중에 "한개라도 클 경우" 조회 (여러 개의 결과값 중에 가장 작은 값보다 클 경우 조회)
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE E
JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
WHERE SALARY > ANY (SELECT SALARY 
                      FROM EMPLOYEE
                      JOIN JOB USING(JOB_CODE)
                      WHERE JOB_NAME = '과장') -- 2200000
AND JOB_NAME = '대리';

-- 2) 부장직급임에도 불구하고 차장직급인 사원들의 급여보다도 더 적게 받는 사원들의 사번, 사원명, 직급명, 급여
-- < ANY 서브쿼리 : 여러개의 결과값 중에 "한개라도 작을 경우" 조회 (여러 개의 결과값 중에 가장 큰 값보다 작을 경우 조회)
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)
WHERE SALARY < ANY (SELECT SALARY
                     FROM EMPLOYEE E
                     JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
                     WHERE JOB_NAME = '차장') -- 3900000
AND JOB_NAME = '부장';

-- 3. > / < ALL 서브쿼리
-- 1) 차장직급임에도 불구하고 부장직급인 사원들의 모든 급여보다도 더 많이 받는 사원들의 사번, 사원명, 직급명, 급여\
-- > ALL 서브쿼리 : 여러개의 "모든" 결과값들보다 클 경우 조회
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE SALARY > ALL (SELECT SALARY 
                     FROM EMPLOYEE
                     JOIN JOB USING (JOB_CODE)
                     WHERE JOB_NAME = '부장') -- 3400000, 2800000, 3500000
AND JOB_NAME = '차장'; -- 3900000

-- 2) 과장 직급인데도 불구하고 사원직급의 모든 나이보다도 더 적은 사원들의 사번, 사원명, 직급명, 나이
-- < ALL 서브쿼리 : 여러개의 "모든" 결과값들보다 작을 경우 조회
SELECT EMP_ID, EMP_NAME, J.JOB_CODE, EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM TO_DATE(SUBSTR(EMP_NO,1,2), 'RR')) "나이"
FROM EMPLOYEE E
JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
WHERE JOB_NAME = '과장' -- 34
AND EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM TO_DATE(SUBSTR(EMP_NO,1,2), 'RR')) < ALL (SELECT EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM TO_DATE(SUBSTR(EMP_NO,1,2), 'RR'))
                                                                                        FROM EMPLOYEE 
                                                                                        JOIN JOB USING (JOB_CODE)
                                                                                        WHERE JOB_NAME = '사원'); -- 59, 57, 37, 35

--------------------------------------------------------------------------------
/*
    3. 다중열 서브쿼리
    결과행은 한 행이지만 나열된 컬럼수가 여러개일 경우
*/
-- 1) 하이유 사원과 같은 부서, 같은 직급에 해당하는 사원들 조회 (사원명, 부서코드, 직급코드, 입사일)
SELECT EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE (DEPT_CODE, JOB_CODE) = (SELECT DEPT_CODE, JOB_CODE
                                 FROM EMPLOYEE
                                 WHERE EMP_NAME = '하이유');

-- 2) 윤은해 사원과 같은 직급, 같은 사수를 가진 사원들의 사번, 사원명, 직급코드, 사수사번 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, MANAGER_ID
FROM EMPLOYEE
WHERE (DEPT_CODE, MANAGER_ID) = (SELECT DEPT_CODE, MANAGER_ID
                                   FROM EMPLOYEE
                                   WHERE EMP_NAME = '윤은해');

--------------------------------------------------------------------------------
/*
    4. 다중행 다중열 서브쿼리
    서브쿼리 조회 결과값이 여러행이면서 여러 컬럼일 경우
*/
-- 1) 각 직급별 최소급여를 받는 사원들 조회 (사번, 사원명, 직급코드, 급여)
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE (JOB_CODE, SALARY) IN (SELECT JOB_CODE, MIN(SALARY)
                                     FROM EMPLOYEE
                                     GROUP BY JOB_CODE);
                                     

SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE (JOB_CODE, SALARY) = ANY (SELECT JOB_CODE, MIN(SALARY)
                             FROM EMPLOYEE
                             GROUP BY JOB_CODE);
-- 여러행을 비교할 때는 IN 또는 = ANY를 활용

-- 2) 각 부서별 최고급여를 받는 사원들의 사번, 사원명, 부서코드, 급여
SELECT EMP_ID, EMP_NAME, NVL(DEPT_CODE,'-'), SALARY
FROM EMPLOYEE
WHERE (NVL(DEPT_CODE,'-'), SALARY) IN (SELECT NVL(DEPT_CODE,'-'), MAX(SALARY)
                                FROM EMPLOYEE
                                GROUP BY DEPT_CODE)
ORDER BY SALARY;
                                

SELECT EMP_ID, EMP_NAME, NVL(DEPT_CODE,'-'), SALARY
FROM EMPLOYEE
WHERE (NVL(DEPT_CODE,'-'), SALARY) = ANY (SELECT NVL(DEPT_CODE,'-'), MAX(SALARY)
                                FROM EMPLOYEE
                                GROUP BY DEPT_CODE)
ORDER BY SALARY;
-- DEPT_CODE = NULL인 사원 조회 X (동등비교로 단순히 비교할 수 없음)=> NULL을 다른이름(존재하는값)으로 바꿔서 조회하기

-- 3) 각 부서별 가장 높은 보너스를 받는 사원들의 사번, 사원명, 부서코드, 보너스
SELECT EMP_ID, EMP_NAME, NVL(DEPT_CODE, '-') "부서코드" , NVL(BONUS, '0') "보너스"
FROM EMPLOYEE
WHERE (NVL(DEPT_CODE, '-'), NVL(BONUS, '0')) IN (SELECT NVL(DEPT_CODE, '-'), MAX(BONUS)
                                                    FROM EMPLOYEE
                                                    GROUP BY DEPT_CODE);

--------------------------------------------------------------------------------
/*
    5. 인라인 뷰 (INLINE - VIEW)
    FROM 절에 서브쿼리를 작성한거
    
    서브쿼리를 수행한 결과를 마치 테이블처럼 사용
*/
-- 1) 사원들의 사번, 이름, 보너스포함연봉(별칭부여), 부서코드 조회 => 보너스포함연봉이 절대 NULL로 나오지 않도록
-- 단, 보너스 포함 연봉이 3000만원 이상인 사원들만 조회
SELECT *
FROM (SELECT EMP_ID, EMP_NAME, (SALARY + (SALARY * NVL(BONUS, 0))) * 12 "보너스포함연봉", DEPT_CODE
        FROM EMPLOYEE)
WHERE 보너스포함연봉 >= 30000000;

-- 2) 사원들의 아이디 중 'j'가 들어가는 사원들의 사번, 사원명, 아이디, 이메일 조회
SELECT *
FROM (SELECT EMP_ID, EMP_NAME, SUBSTR(EMAIL, 1, INSTR(EMAIL, '@')-1) "아이디"
        FROM EMPLOYEE)
WHERE 아이디 LIKE '%j%';
--------------------------------------------------------------------------------
-- >> 인라인 뷰를 주로 사용하는 경우 => TOP-N 분석 (인라인 뷰 이외의 방법은 없음)

-- 1) 전 직원 중 급여가 가장 높은 상위 5명만 조회
-- 전 직원 중 급여가 가장 높은 상위 5명만 조회
-- * ROWNUM : 오라클에서 제공해주는 컬럼, 조회된 순서대로 1부터 순번을 부여해주는 컬럼
SELECT ROWNUM, EMP_NAME, SALARY
FROM EMPLOYEE
WHERE ROWNUM <= 5
ORDER BY 3 DESC;
-- 정렬이 진행되기도 전에 이미 5명이 추려지고나서(순번이 정해지고나서) 정렬

--> ORDER BY절이 다 수행된 결과를 가지고 ROWNUM부여 후 5명 추려야됨
SELECT ROWNUM, E.*
-- * 은 다른 컬럼과 함께 사용할 수 없음
-- 별칭.* 은 가능
FROM (SELECT EMP_ID, EMP_NAME, SALARY
        FROM EMPLOYEE
        ORDER BY SALARY DESC) E -- 서브쿼리 자체에 'E'별칭 부여
        -- 내부적으로 ROWNUM은 부여되어있음
WHERE ROWNUM <= 5;

-- 2) 가장 나이가 많은 사원 5명 조회(사원명, 나이, 입사일)
SELECT ROWNUM, E.*
FROM (SELECT EMP_NAME, EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM TO_DATE(SUBSTR(EMP_NO, 1, 2),'RR')) "나이", HIRE_DATE
      FROM EMPLOYEE
      ORDER BY 나이 DESC) E
WHERE ROWNUM <= 5;

-- 3) 각 부서별 평균급여가 높은 3개의 부서 조회
SELECT ROWNUM, E.*
FROM (SELECT DEPT_CODE "부서코드", ROUND(AVG(SALARY)) "평균급여"
         FROM EMPLOYEE
         GROUP BY DEPT_CODE
         ORDER BY 2 DESC) E
WHERE ROWNUM <= 3;

-- 4) 전 직원 중 입사일이 빠른 순 중에서 5위까지 조회
SELECT ROWNUM, E.*
FROM (SELECT EMP_NAME, HIRE_DATE
        FROM EMPLOYEE
        ORDER BY HIRE_DATE ASC) E
WHERE ROWNUM <= 5;

-- 5) 전 직원 중 입사일이 느린 순 중에서 10위까지 조회
SELECT *
FROM (SELECT EMP_NAME, HIRE_DATE
        FROM EMPLOYEE
        ORDER BY HIRE_DATE DESC)
WHERE ROWNUM <= 10;

-- 6) 전 직원 중 연봉이 가장 낮은 사람 5위까지 조회 (사원명, 직급명, 부서명 조회)
SELECT ROWNUM 순번, E.*
FROM (SELECT EMP_NAME "사원명", J.JOB_NAME "직급", D.DEPT_TITLE "부서명", SALARY * 12 "연봉"
        FROM EMPLOYEE E
        JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
        JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
        ORDER BY 연봉) E
WHERE ROWNUM <= 5;

--------------------------------------------------------------------------------
/*
    * 순위 매기는 함수 (WINDOW FUNTION)    ==> SELECT 절에만 서술 가능!!! WHERE절 불가능
    RANK() OVER(정렬기준) | DENSE_RANK() OVER(정렬기준)
    
    - RANK() OVER(정렬기준) : 동일한 순위의 등수를 동일한 인원 수 만큼 건너띄고 순위 계산
                            EX) 1위가 3명인 경우 : 1, 1, 1, 4 위로 함
    - DENSE() OVER(정렬기준) : 동일한 순위의 등수가 있다 해도 그 다음 등수를 무조건 1 증가시킨 순위
                            EX) 1위가 3명인 경우 : 1, 1, 1, 2 위로 함
                        
*/  
-- 연봉이 높은 순대로 순위를 매겨서 조회
SELECT EMP_NAME, SALARY * 12, RANK() OVER(ORDER BY SALARY * 12 DESC) "연봉"
FROM EMPLOYEE;
-->> RANK() OVER(정렬기준) : 공동 19위가 있음 -> 19, 19, 21로 조회됨

SELECT EMP_NAME, SALARY * 12, DENSE_RANK() OVER(ORDER BY SALARY * 12 DESC) "연봉"
FROM EMPLOYEE;
-->> DENSE_RANK() OVER(정렬기준) : 공동 19위가 있음 -> 19, 19, 20로 조회됨

-- 급여가 높은 상위 5위만 조회
-- RANK() OVER(정렬기준)
SELECT *
FROM (SELECT EMP_NAME, SALARY, RANK() OVER(ORDER BY SALARY DESC) "순위"
        FROM EMPLOYEE)
WHERE ROWNUM <= 5;

-- DENSE_RANK() OVER(정렬기준)
SELECT *
FROM (SELECT EMP_NAME, SALARY, DENSE_RANK() OVER(ORDER BY SALARY DESC) "순위"
        FROM EMPLOYEE)
WHERE ROWNUM <= 5;
