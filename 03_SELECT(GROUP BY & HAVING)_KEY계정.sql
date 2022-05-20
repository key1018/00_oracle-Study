/*
    < GROUP BY 절 >
    그룹 기준을 제시할 수 있는 구문
    여러개의 값들을 여러 그룹으로 묶어서 처리할 목적으로 사용
*/
-- 부서별 총 급여합
/*
SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE;
-- 오류 발생 => 그룹 함수는 단일함수와 함께 사용 불가능
*/

SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
ORDER BY DEPT_CODE;
-- GROUP BY 절을 활용하여 단일함수와 함꼐 사용할 수 있음

-- 부서별 사원 수
SELECT DEPT_CODE, COUNT(*)
FROM EMPLOYEE
GROUP BY DEPT_CODE
ORDER BY DEPT_CODE;

-- 직급 코드별 사원 수 및 급여합
SELECT JOB_CODE, COUNT(*)"사원수", SUM(SALARY)"급여합"
FROM EMPLOYEE
GROUP BY JOB_CODE;

-- 각 부서별 300만원 이상 받는 사원수, 보너스를 받는 사원수, 평균 급여, 최저급여, 최대급여
SELECT COUNT(*) "사원수", COUNT(BONUS) "보너스받는 사원 수", ROUND(AVG(SALARY)) "평균급여",
       MIN(SALARY) "최저급여" , MAX(SALARY) "최대급여"
FROM EMPLOYEE
WHERE SALARY >= 3000000;

-- 여자, 남자 사원 수
SELECT DECODE(SUBSTR(EMP_NO,8,1) ,'1', '남자', '2', '여자') "성별", COUNT(*) "사원 수"
FROM EMPLOYEE
GROUP BY SUBSTR(EMP_NO,8,1);

SELECT DECODE(SUBSTR(EMP_NO,8,1) ,'1', '남자', '2', '여자') "성별",
            CASE WHEN SUBSTR(EMP_NO,8,1) = '1' THEN COUNT(*)
            WHEN SUBSTR(EMP_NO,8,1) = '2' THEN COUNT(*)
            END "사원 수"
FROM EMPLOYEE
GROUP BY SUBSTR(EMP_NO,8,1);

-- 여러 컬럼 조회하기
SELECT DEPT_CODE, JOB_CODE, SUM(SALARY), COUNT(*)
FROM EMPLOYEE
GROUP BY DEPT_CODE, JOB_CODE;

SELECT DEPT_CODE, BONUS, COUNT(*), TO_CHAR(SUM(SALARY * BONUS), '9,999,999') "월 보너스"
FROM EMPLOYEE
GROUP BY DEPT_CODE, BONUS;

--------------------------------------------------------------------------------
/*
    < HAVING 절 >
    그룹에 대한 조건을 제시할 때 사용되는 구문 (주로 그룹함수식을 가지고 조건을 제시할 때 사용)
*/
-- 각 부서의 평균 급여
SELECT DEPT_CODE, ROUND(AVG(SALARY)) "평균급여"
FROM EMPLOYEE
GROUP BY DEPT_CODE
ORDER BY ROUND(AVG(SALARY)) DESC;

-- 부서별 평균 급여값이 300만원 이상인 부서들만 조회
SELECT DEPT_CODE, TO_CHAR(ROUND(AVG(SALARY)),'99,999,999') "평균급여"
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING ROUND(AVG(SALARY)) >= 3000000;

-- 부서별 연봉 합이 1억 이상인 부서들만 조회
SELECT DEPT_CODE, TO_CHAR(SUM(SALARY*12),'999,999,999') "연봉합"
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING SUM(SALARY*12) >= 100000000
ORDER BY 2 DESC;

-- 부서별 평균 55이상인 부서들만 조회
SELECT DEPT_CODE, 
       CEIL(AVG(EXTRACT(YEAR FROM TO_DATE(SUBSTR(EMP_NO,1,6),'YYMMDD'))  - EXTRACT (YEAR FROM SYSDATE))) "평균연령"
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING CEIL(AVG(EXTRACT(YEAR FROM TO_DATE(SUBSTR(EMP_NO,1,6),'YYMMDD'))  - EXTRACT (YEAR FROM SYSDATE))) >= 55;

-- 직급별 급여합이 1000만원 이상인 직급별 급여합, 직급코드 조회
SELECT DEPT_CODE, SUM(SALARY) "급여합"
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING SUM(SALARY) >= 10000000
ORDER BY 2;

-- 부서별 보너스를 받는 사원이 없는 부서코드만 조회
SELECT DEPT_CODE
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING COUNT(BONUS) = 0;

--------------------------------------------------------------------------------
/*
    < SELECT문 실행순서 > 
   5 : SELECT      * | 조회하고자하는컬럼 AS "별칭"| 산술식 "별칭" | 함수식 AS 별칭
   1 : FROM        조회하고자하는 테이블명
   2 : WHERE       조건식
   3 : GROUP BY    그룹기준으로 삼을 컬럼 | 함수식
   4 : HAVING      조건식 (그룹함수를 가지고 기술)
   6 : ORDER BY    컬럼 | 별칭 | 컬럼순번 [ASC | DESC] [NULLS FIRST | NULLS LAST]
*/

--------------------------------------------------------------------------------

/*
    < 집계 함수 >
    그룹별 산출된 결과 값에 중간 집계를 계산해주는 함수
    
    ROLLUP, CUBE
    
    => GROUP BY 절에 기술하는 함수
*/
-- 각 직급별 급여합
SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
ORDER BY 2;

-- 마지막 행에 전체 총 급여합까지 같이 조회하고자 할 때
SELECT JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY CUBE(JOB_CODE) -- CUBE구문을 삽입을 통해 총 급여합이 조회됨
ORDER BY JOB_CODE NULLS FIRST;

SELECT JOB_CODE, TO_CHAR(SUM(SALARY), '99,999,999') "총 급여합"
FROM EMPLOYEE
GROUP BY ROLLUP(JOB_CODE)
ORDER BY 2;
-- 그룹 기준의 컬럼이 하나일 때는 CUBE, ROLLUP의 차이점이 딱히 없음
-- 두 차이점을 보고자 한다면 그룹 기준의 컬럼이 두개는 있어야됨

-- ROLLUP(컬럼1, 컬럼2) : 컬럼1을 가지고 다시 중간집계를 내는 함수
SELECT DEPT_CODE, JOB_CODE,  SUM(SALARY)
FROM EMPLOYEE
GROUP BY ROLLUP(DEPT_CODE, JOB_CODE);
-- DEPT_CODE를 가지고 중간합계를 내는 함수 => 중간합계명 : NULL

-- CUBE(컬럼1, 컬럼2) : 컬럼1을 가지고 중간합계도 내고, 컬럼2를 가지고도 중간합계를 내는 함수
SELECT DEPT_CODE, JOB_CODE,  SUM(SALARY)
FROM EMPLOYEE
GROUP BY CUBE(DEPT_CODE, JOB_CODE)
ORDER BY 1;

SELECT DEPT_CODE, BONUS, SUM(SALARY)
FROM EMPLOYEE
GROUP BY ROLLUP(DEPT_CODE, BONUS)
ORDER BY 1;

SELECT DEPT_CODE, BONUS, SUM(SALARY)
FROM EMPLOYEE
GROUP BY CUBE(DEPT_CODE, BONUS)
ORDER BY 1;

--------------------------------------------------------------------------------

/*
    < 집합 연산자 == SET OPERATION >
    여러개의 쿼리문을 가지고 하나의 쿼리문으로 만드는 연산자
    
    UNION       : OR | 합집합 (두 쿼리문 수행한 결과값을 더한 후 중복값은 한 번만 조회)
    INTERSETION : AND | 교집합 (두 쿼리문 수행한 결과값에 중복된 결과값)
    UNION ALL   : 합집합 + 교집합 (중복되는 값이 2번 표현될 수 있음) => 조회하는 전체 값 출력
    MINUS       : 차집합 (선행쿼리의 결과값에서 후행쿼리의 결과값을 뺀 나머지) 
*/
-- 1. UNION (합집합 : 중복되는 값 1번만 출력)
-- 1) 부서코드가 D5인 사원 또는 급여가 300만원 초과인 사원들 조회 (사번, 이름, 부서코드, 급여)
-->> UNION 적용 전
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'; -- "박나라", 하이유, 김해술, "심봉선", 윤은해, "대북혼" 6개의 행 조회

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000; -- 선동일, 송종기, 송은희, 유재식, "박나라", "심봉선", "대북혼", 전지연 8개의 행 조회

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5' OR SALARY > 3000000; -- 선동일, 송종기, 송은희, 유재식, "박나라", "심봉선", "대북혼", 하이유, 김해술, 윤은해 총 11개의 행 출력

-->> UNION 적용 후
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
UNION
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000; 
-- 선동일, 송종기, 송은희, 유재식, "박나라", "심봉선", "대북혼", 하이유, 김해술, 윤은해 총 11개의 행 출력
--> 중복값 1번씩만 출력

-- 2) 입사년도가 90년대인 사원 또는 급여가 300만원 이상인 사원들 조회 (사번, 사원명, 급여, 입사일)
-->> UNION 적용 전
-- 입사년도가 90년대인 사원 조회
SELECT EMP_ID, EMP_NAME, SALARY, HIRE_DATE
FROM EMPLOYEE
-- WHERE EXTRACT (YEAR FROM HIRE_DATE) >= 1990 AND EXTRACT (YEAR FROM HIRE_DATE) <  2000;
WHERE EXTRACT(YEAR FROM HIRE_DATE) BETWEEN 1990 AND 1999;

-- 급여가 300만원 이상인 사원들 조회
SELECT EMP_ID, EMP_NAME, SALARY, HIRE_DATE
FROM EMPLOYEE
WHERE SALARY >= 3000000;

SELECT EMP_ID, EMP_NAME, SALARY, HIRE_DATE
FROM EMPLOYEE
WHERE EXTRACT(YEAR FROM HIRE_DATE) BETWEEN 1990 AND 1999 
  OR SALARY >= 3000000;

-->> UNION 적용 후
SELECT EMP_ID, EMP_NAME, SALARY, HIRE_DATE
FROM EMPLOYEE
WHERE EXTRACT(YEAR FROM HIRE_DATE) BETWEEN 1990 AND 1999
UNION
SELECT EMP_ID, EMP_NAME, SALARY, HIRE_DATE
FROM EMPLOYEE
WHERE SALARY >= 3000000;

-- 2. INTERSECT (교집합) : 두 쿼리문 중 중복된 값만 조회
-- 1) 부서코드가 D5이면서 급여가 300만원 초과인 사원들 조회 (사번, 이름, 부서코드, 급여)
-->> INTERSECT 적용 전
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5' AND SALARY > 3000000; -- 박나라, 심봉선, 대북혼

-->> INTERSECT 적용 후
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
INTERSECT
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000; -- 박나라, 심봉선, 대북혼


-- 2) 입사년도가 90년대인 사원이면서 급여가 300만원 이상인 사원들 조회 (사번, 사원명, 급여, 입사일)
-->> INTERSECT 적용 전
SELECT EMP_ID, EMP_NAME, SALARY, HIRE_DATE
FROM EMPLOYEE
WHERE EXTRACT(YEAR FROM HIRE_DATE) BETWEEN 1990 AND 1999 AND SALARY > 3000000; -- 성동일, 송은희

-->> INTERSECT 적용 후
SELECT EMP_ID, EMP_NAME, SALARY, HIRE_DATE
FROM EMPLOYEE
WHERE EXTRACT(YEAR FROM HIRE_DATE) BETWEEN 1990 AND 1999
INTERSECT
SELECT EMP_ID, EMP_NAME, SALARY, HIRE_DATE
FROM EMPLOYEE
WHERE SALARY > 3000000; -- 성동일, 송은희

-- 3. UNION ALL (합집합 + 교집합) : 조회되는 값 전체 출력 (중복값이 2번 이상 출력될 수 있음)
-- 1) 부서코드가 D5인 사원 또는 급여가 300만원 초과인 사원들 조회 (사번, 이름, 부서코드, 급여)
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
UNION ALL
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000
ORDER BY EMP_NAME; -- 대북혼, 박나라, 심봉선 2번 출력

-- 2) 입사년도가 90년대인 사원 또는  급여가 300만원 이상인 사원들 조회 (사번, 사원명, 급여, 입사일)
SELECT EMP_ID, EMP_NAME, SALARY, HIRE_DATE
FROM EMPLOYEE
WHERE EXTRACT(YEAR FROM HIRE_DATE) BETWEEN 1990 AND 1999
UNION ALL
SELECT EMP_ID, EMP_NAME, SALARY, HIRE_DATE
FROM EMPLOYEE
WHERE SALARY > 3000000
ORDER BY EMP_NAME; -- 선동일, 송은희 2번 출력

-- 4. MINUS (차집합) : 첫번째 쿼리값에서 두번쨰 쿼리값을 제외해서 출력
-- 1) 부서코드가 D5인 사원 또는 급여가 300만원 초과인 사원들 제외해서 출력(사번, 이름, 부서코드, 급여)
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5' -- "박나라", 하이유, 김해술, "심봉선", 윤은해, "대북혼"
MINUS
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000 -- 선동일, 송종기, 송은희, 유재식, "박나라", "심봉선", "대북혼", 전지연 
ORDER BY EMP_NAME;
--> 하이유, 윤은해, 김해술 최종 출력

-- 2) 입사년도가 90년대인 사원 중에서  급여가 300만원 이상인 사원들 제외해서 조회 (사번, 사원명, 급여, 입사일)
SELECT EMP_ID, EMP_NAME, SALARY, HIRE_DATE
FROM EMPLOYEE
WHERE EXTRACT(YEAR FROM HIRE_DATE) BETWEEN 1990 AND 1999 -- "선동일", "송은희", 정중하, 하이유, 하동운, 임시환, 유하진, 이태림
MINUS
SELECT EMP_ID, EMP_NAME, SALARY, HIRE_DATE
FROM EMPLOYEE
WHERE SALARY > 3000000
ORDER BY EMP_NAME; -- "선동일", "송종기", 송은희, 유재식, 박나라, 심봉선, 대북혼, 전지연
--> 정중하, 하이유, 하동운, 임시환, 유하진, 이태림 최종 출력