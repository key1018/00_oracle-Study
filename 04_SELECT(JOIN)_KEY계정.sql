/*
    < JOIN >
    두 개 이상의 테이블에서 데이터를 조회하고자 할 때 사용되는 구문
    조회 결과는 한 개로 나옴
    
    관계형 데이터베이스는 최소한의 데이터를 보관하기 위해 각각의 테이블에 따로 데이터를 담고 있음 (중복된 데이터를 최소화하기 위해)
    테이블간의 "관계"를 맺어서 데이터를 가져와야됨 => JOIN
    
            JOIN은 크게 "오라클전용구문"과 "ANSI구문(미국국립표준협회)" 
            
            오라클 전용 구문          |               ANSI구문(오라클 이외의 다른 프로그램에서도 적용 가능)
 ==================================================================================
              등가 조인              |   내부 조인 (INNER JOIN) => JOIN ON / USING
            (EQUAL JOIN)           |   자연 조인 (NATURAL JOIN) => JOIN USING
------------------------------------------------------------------------------------
             포괄 조인               |   왼쪽 외부 조인 (LEFT OUTER JOIN)
          (LEFT OUTHER)            |   오른쪽 외부 조인 (RIGHT OUTER JOIN)
          (RIGHT OUTER)            |   전체 외부 조인 (FULL OUTER JOIN)
------------------------------------------------------------------------------------
         자체 조인 (SELF JOIN)       |      JOIN ON
       비등가 조인 (NON EQUAL JOIN)  |
------------------------------------------------------------------------------------
    카테시안 곱 (CATESIAN PRODUCT)   |       교차 조인 (CROSS JOIN)

*/

/*
    1. 등가 조인 (EQUAL JOIN) / 내부 조인 (INNER JOIN)
     연결시킨 컬럼의 값이 "일치하는 행들만" 조인돼서 조회 (== 일치하는 값이 없으면 조회에서 제외)

       ** 등가 교환 (EQUAL JOIN) 적용 후 : 오라클 전용 구문
         FROM절에 조회하고자하는 테이블들을 나열 ( ',' 구분자로)
         WHERE절에 매칭시킬 컬럼(연결고리)에 대한 조건을 제시함
         
       ** 내부 조인 (INNER JOIN) 적용 후 : ANSI 구문
         FROM절에 기준이 되는 테이블을 하나 기술한 수
         JOIN절에 같이 조회하고자하는 테이블 기술하고 뿐만 아니라 매칭시킬 컬럼에 대한 조건도 같이 기술
         JOIN USING, JOIN ON
*/

-- 1) 연결시킬 컬럼명이 서로 다른 경우
-- 전체 사원들의 사번, 사원명, 부서코드, 부서명을 조회하고자 할 때 (EMPLOYEE : DEPT_CODE / DEPARTMENT : DEPT_ID)
-->> 등가 교환 / 내부조인 적용 전
SELECT EMP_ID, EMP_NAME, DEPT_CODE
FROM EMPLOYEE;

SELECT DEPT_TITLE
FROM DEPARTMENT;

-->> 등가 교환 (EQUAL JOIN) 적용 후 : 오라클 전용 구문
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID;
-- NULL 값은 서로 일치하는 값이 없으므로 조회에서 제외 (일치하는 값만 찾아서 조회)
-- DEPT_CODE가 NULL인 두 명의 사원 조회X, DEPARTMENT에서 DEPT_ID가 D3,4,7 조회X

-->> 내부 조인 (INNER JOIN) 적용 후 : ANSI 구문
-- 컬럼명이 다른 경우 : JOIN ON 구문만 적용 가능
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);

-- 2) 연결시킬 컬럼명이 동일한 경우
-- 사번, 사원명, 직급코드, 직급명을 조회 (EMPLOYEE : JOB_CODE / JOB : JOB_CODE)
-->> 오라클 전용 구문
-- 방법1) 테이블명을 이용하는 방법
SELECT EMP_ID, EMP_NAME, EMPLOYEE.JOB_CODE, JOB_NAME
FROM EMPLOYEE, JOB
WHERE EMPLOYEE.JOB_CODE = JOB.JOB_CODE;

-- 방법2) 테이블에 별칭을 부여해서 이용하는 방법
SELECT EMP_ID, EMP_NAME, J.JOB_CODE, JOB_NAME
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE;

-->> ANSI구문 
-- 컬럼명이 같은 경우 : JOIN ON, JOIN USING 구문 적용 가능
-- 방법1) JOIN ON 구문에서 별칭을 부여해서 이용하는 방법
SELECT EMP_ID, EMP_NAME, J.JOB_CODE, JOB_NAME
FROM EMPLOYEE E
JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE);

-- 방법2) JOIN USING 구문 이용하는 방법
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE 
JOIN JOB USING (JOB_CODE);
-- 매칭시키고자하는 컬럼만 작성 가능

-- 방법3) 자연조인(NATURAL JOIN)을 이용하는 방법
-- 각 테이블마다 동일한 이름의 컬럼이 딱 한개 존재할 경우 사용
-- 동일한 이름의 컬럼이 2개 이상이면 사용 X
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE
NATURAL JOIN JOB;

-- 3) 직급이 대리이며 급여가 250~300만원 사이 사원의 사번, 이름, 급여 조회
-->> 오라클 전용 구문
SELECT EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE
AND J.JOB_NAME = '대리'
AND E.SALARY BETWEEN 2500000 AND 3000000;

-->> ANSI 구문
-- JOIN ON 구문
SELECT EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE E
JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
WHERE J.JOB_NAME = '대리'
AND E.SALARY BETWEEN 2500000 AND 3000000;

-- JOIN USING 구문
SELECT EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '대리'
AND SALARY BETWEEN 2500000 AND 3000000;

--------------------------------------------------------------------------------
-- 1) 부서명에 '영업'이 포함된 사원들의 사번, 이름, 부서명, 급여 조회 (EMPLOYEE : DEPT_CODE, DEPARTMENT : DEPT_ID)
-->> 오라클 전용 구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID
AND DEPT_TITLE LIKE '%영업%';

-->> ANSI 구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE DEPT_TITLE LIKE '%영업%';

-- 2) 보너스를 받은 사원들의 사번, 사원명, 직급명, 급여, 보너스 포함 급여 조회 (EMPLOYEE : JOB_CODE, JOB : JOB_CODE)
-->> 오라클 전용 구문
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY, SALARY + (SALARY*BONUS)
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE
AND BONUS IS NOT NULL;

-->> ANSI 구문
-- JOIN ON 구문
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY, SALARY + (SALARY*BONUS) "보너스 포함 급여"
FROM EMPLOYEE E
JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
WHERE BONUS IS NOT NULL;

-- JOIN USING 구문
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY, SALARY + (SALARY*BONUS) "보너스 포함 급여"
FROM EMPLOYEE 
JOIN JOB USING (JOB_CODE)
WHERE BONUS IS NOT NULL;

-- 3) DEPARTMENT와 LOCATION을 참고해서 전체 부서들의 부서코드, 부서명, 지역코드, 지역명 조회
-- 단, 영업이 들어간 부서는 조회 X
-- DEPARTMENT : LOCATION_ID, LOCATION : LOCAL_CODE 
-->> 오라클 전용 구문
SELECT DEPT_ID, DEPT_TITLE, LOCAL_CODE, LOCAL_NAME
FROM DEPARTMENT, LOCATION
WHERE LOCATION_ID = LOCAL_CODE
AND DEPT_TITLE NOT LIKE '%영업%';

-->> ANSI구문
SELECT DEPT_ID, DEPT_TITLE, LOCAL_CODE, LOCAL_NAME
FROM DEPARTMENT
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
WHERE DEPT_TITLE NOT LIKE '%영업%';

--------------------------------------------------------------------------------
-- 전체 사원들의 사원명, 부서명, 급여, 연봉 조회
SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY*12
FROM EMPLOYEE
/*INNER*/JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE);
-- 내부조인 : 두 테이블 간에 일치하는 행이 없으면 제외

/*
    2. 포괄 조인 / 외부 조인 (OUTER JOIN)
    두 테이블간의 JOIN시 일치하지 않는 행도 포함시켜서 조회가능 (내부조인과 달리 NULL값도 조회가능)
    단, 반드시 LEFT / RIGHT를 지정해야됨!! (기준이 되는 테이블 지정)
*/
-- 1) LEFT [OUTER] JOIN : 두 테이블 중 왼편에 기술된 테이블을 기준으로 JOIN
--> 즉, 왼편에 기술된 테이블의 행은 무조건 조회

-- 사원들의 사원코드, 사원명, 부서코드, 부서명, 급여, 연봉 조회
-->> 오라클 전용 구문 (EMPLOYEE = DEPT_CODE, DEPARTMENT = DEPT_ID)
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE, SALARY, SALARY * 12
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID(+);
-- 오라클 구문의 경우 LEFT / RIGHT를 붙이는 것이 아닌 반대편 구문에 있는 컬럼명에 '(+)' 를 붙임
-- 즉, 조회의 기준이 되는 코드는 EMPLOYEE

-->> ANSI 구문
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE, SALARY, SALARY * 12
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);
-- EMPLOYEE테이블 기준으로 무조건 사원에 대한 데이터는 다 나오게끔
--> EMPLOYEE의 DEPT_CODE가 NULL이였던 이요리, 하동운 조회

-- 2) RIGHT [OUTER] JOIN : 두 테이블 중 오른쪽에 기술된 테이블을 기준으로 JOIN
--> 즉, 오른쪽에 기술된 테이블의 행은 무조건 조회

-- 사원들의 사원코드, 사원명, 부서코드, 부서명, 급여, 연봉 조회
-->> 오라클 전용 구문 (EMPLOYEE = DEPT_CODE, DEPARTMENT = DEPT_ID)
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE, SALARY, SALARY * 12
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE(+) = DEPT_ID;
-- 조회의 기준이 되는 코드는 DEPARTMENT

-->> ANSI 구문
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE, SALARY, SALARY * 12
FROM EMPLOYEE
RIGHT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);
-- DEPARTMENT 테이블 기준으로 무조건 부서에 대한 데이터는 다 나오게끔
--> DEPARTMENT의 NULL이었던 '해외영업3부, 마케팅부, 국내영업부' 모두 조회

-- 3) FULL [OUTER] JOIN : 두 테이블이 가진 모든 행을 조회할 수 있음
-- 단, 오라클전용구문으로는 불가능
SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY*12
FROM EMPLOYEE
FULL JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE);
-- EMPLOYEE, DEPARTMENT 기준으로 모두 조회

--------------------------------------------------------------------------------
/*
    < 다중 조인 > 
    한개 이상의 테이블을 조인해서 조회가능
*/
-- 1) 사번, 사원명, 직급코드, 직급명, 부서코드, 부서명 조회
-->> 오라클 전용 구문
SELECT EMP_ID, EMP_NAME, J.JOB_CODE, JOB_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE E, JOB J, DEPARTMENT
WHERE DEPT_ID(+) = DEPT_CODE 
AND E.JOB_CODE = J.JOB_CODE;

-->> ANSI 구문
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE E
LEFT JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
JOIN JOB J USING(JOB_CODE);

-- 2) 사번, 사원명, 부서명, 지역명, 국가명 조회
-->> 오라클 전용 구문
-- (EMPLOYEE : DEPT_CODE, DEPARTMENT : DEPT_ID, LOCATION_ID, 
--  LOCATION : LOCAL_CODE, NATIONAL_CODE, NATIONAL : NATIONAL_CODE)
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE, LOCAL_NAME, NATIONAL_NAME
FROM EMPLOYEE, DEPARTMENT, LOCATION L , NATIONAL N
WHERE DEPT_CODE = DEPT_ID
AND LOCATION_ID = LOCAL_CODE
AND L.NATIONAL_CODE = N.NATIONAL_CODE;

-->> ANSI 구문
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE, LOCAL_NAME, NATIONAL_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
JOIN NATIONAL USING (NATIONAL_CODE);

--------------------------------------------------------------------------------

/*
    3. 비동가 조인 (NON EQUAL JOIN)
    매칭시킬 컬럼에 대한 조건 작성시 '='를 사용하지 않는 조인문
    ANSI구문으로는 USING 사용 불가능 (조건식을 입력할 수 없기 때문에)
    오로지 JOIN ON 구문으로만 사용 가능 (조건식을 입력할 수 있기 때문에)
*/
-- 사번, 사원명, 직급명, 급여, 급여 등급 조회
-->> 오라클 전용 구문
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY, SAL_LEVEL
FROM EMPLOYEE E, JOB J, SAL_GRADE
WHERE SALARY BETWEEN MIN_SAL AND MAX_SAL
AND E.JOB_CODE = J.JOB_CODE
ORDER BY SALARY DESC;

-->> ANSI 구문
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY, SAL_LEVEL
FROM EMPLOYEE E
JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
JOIN SAL_GRADE ON (SALARY BETWEEN MIN_SAL AND MAX_SAL)
ORDER BY SALARY DESC;

--------------------------------------------------------------------------------
/*
    4. 자체 조인 (SELF JOIN)
    동일한 테이블을 다시 한 번 조인하는 경우
*/
-- 1) 전체 사원들의 사원사번, 사원명, 사원부서코드    => EMPLOYEE E
--             사수사번, 사수명, 사수부서코드   => EMPLOYEE M

-->> 오라클 전용 구문
SELECT E.EMP_ID, E.EMP_NAME, E.DEPT_CODE,
        E.MANAGER_ID, M.EMP_NAME, M.DEPT_CODE
    -- M.MANEGER_ID인 경우 사수의 사수코드를 조회 ==> E.MANAGER_ID를 해야 사원의 사수코드를 조회함
FROM EMPLOYEE E, EMPLOYEE M
WHERE E.MANAGER_ID = M.EMP_ID;

-->> ANSI 구문
SELECT E.EMP_ID, E.EMP_NAME, E.DEPT_CODE,
        E.MANAGER_ID, M.EMP_NAME, M.DEPT_CODE
FROM EMPLOYEE E
JOIN EMPLOYEE M ON (E.MANAGER_ID = M.EMP_ID);

-- 2) 전체 사원들의 사원사번, 사원명, 사원부서코드, 사원 부서명, 사원 직급코드, 사원 직급명    => EMPLOYEE E
--             사수사번, 사수명, 사수부서코드, 사수 부서명, 사수 직급코드, 사수 직급명   => EMPLOYEE M
-->> ANSI 구문
SELECT E.EMP_ID, E.EMP_NAME, E.DEPT_CODE, ED.DEPT_TITLE, E.JOB_CODE, EJ.JOB_NAME,
        E.MANAGER_ID, M.EMP_NAME, M.DEPT_CODE, MD.DEPT_TITLE, M.JOB_CODE, MJ.JOB_NAME
FROM EMPLOYEE E
JOIN EMPLOYEE M ON (E.MANAGER_ID = M.EMP_ID)
JOIN DEPARTMENT ED ON (E.DEPT_CODE = ED.DEPT_ID)
JOIN DEPARTMENT MD ON (M.DEPT_CODE = MD.DEPT_ID)
JOIN JOB EJ ON (E.JOB_CODE = EJ.JOB_CODE)
JOIN JOB MJ ON (M.JOB_CODE = MJ.JOB_CODE);

-- 3) 전체 사원들의 사원사번, 사원명, 사원부서코드, 사원 부서명, 사원 근무지역, 사원 나라명    => EMPLOYEE E
--             사수사번, 사수명, 사수부서코드, 사수 부서명, 사수 근무지역, 사수 나라명   => EMPLOYEE M
SELECT E.EMP_ID "사원사번", E.EMP_NAME "사원명", E.DEPT_CODE "사원 부서코드", ED.DEPT_TITLE "사원 부서명", EDL.LOCAL_NAME "사원 근무지역", EDLN.NATIONAL_NAME "사원 나라명",
        E.MANAGER_ID "사수사번", M.EMP_NAME "사수명", M.DEPT_CODE "사수 부서코드", MD.DEPT_TITLE "사수 부서명", MDL.LOCAL_NAME "사수 근무지역", MDLN.NATIONAL_NAME "사수 나라명"
FROM EMPLOYEE E
JOIN EMPLOYEE M ON (E.MANAGER_ID = M.EMP_ID)
JOIN DEPARTMENT ED ON (E.DEPT_CODE = ED.DEPT_ID) -- 부서명
JOIN DEPARTMENT MD ON (M.DEPT_CODE = MD.DEPT_ID)
JOIN LOCATION EDL ON (ED.LOCATION_ID = EDL.LOCAL_CODE) -- 근무지역
JOIN LOCATION MDL ON (MD.LOCATION_ID = MDL.LOCAL_CODE)
JOIN NATIONAL EDLN ON (EDL.NATIONAL_CODE = EDLN.NATIONAL_CODE) -- 나라명
JOIN NATIONAL MDLN ON (MDL.NATIONAL_CODE = MDLN.NATIONAL_CODE);

--------------------------------------------------------------------------------
/*
    5. 카테시안곱 (CARTESIAN PRODUCT) / 교차조인 (CROSS JOIN)
     모든 케이블의 각 행들이 서로서로 매핑된 데이터 조회됨 (곱집합)
     
     두 테이블의 행들이 모두 곱해진 행들의 조합이 출력 => 방대한 데이터 출력 => 과부화의 위험
*/
-->> 오라클
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT; --> 23 * 9 => 207행

--> ANSI 구문
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
CROSS JOIN DEPARTMENT;

--------------------------------------------------------------------------------
-- 사원들의 사번, 사원명, 부서명, 직급명, 지역명, 국가명, 급여등급, 사수명 조회

-->> 오라클
SELECT E.EMP_ID
     , E.EMP_NAME
     , D.DEPT_TITLE
     , J.JOB_NAME
     , L.LOCAL_NAME
     , N.NATIONAL_NAME
     , S.SAL_LEVEL
     , M.EMP_NAME
FROM EMPLOYEE E
   , DEPARTMENT D
   , JOB J
   , LOCATION L
   , NATIONAL N
   , SAL_GRADE S
   , EMPLOYEE M
WHERE E.DEPT_CODE = D.DEPT_ID
    AND E.JOB_CODE = J.JOB_CODE
    AND D.LOCATION_ID = L.LOCAL_CODE
    AND L.NATIONAL_CODE = N.NATIONAL_CODE
    AND E.SALARY BETWEEN MIN_SAL AND MAX_SAL
    AND E.MANAGER_ID = M.EMP_ID;

-- 사원들의 사번, 사원명, 부서명, 직급명, 지역명, 국가명, 급여등급, 사수명 조회
-->> ANSI 구문
SELECT E.EMP_ID
     , E.EMP_NAME
     , D.DEPT_TITLE
     , J.JOB_NAME
     , L.LOCAL_NAME
     , N.NATIONAL_NAME
     , S.SAL_LEVEL
     , M.EMP_NAME
FROM EMPLOYEE E
JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE)
JOIN NATIONAL N ON (L.NATIONAL_CODE = N.NATIONAL_CODE)
JOIN SAL_GRADE S ON (E.SALARY BETWEEN MIN_SAL AND MAX_SAL)
JOIN EMPLOYEE M ON (E.MANAGER_ID = M.EMP_ID);
