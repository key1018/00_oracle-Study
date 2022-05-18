/*
    * 함수 FUNCTION
    전달된 컬럼값을 읽어들여서 특정 내용을 수행시킨 후 실행한 결과를 반환함
    
    - 단일행함수 : N개의 값을 읽어들여서 N개의 결과값을 리턴 (매 행마다 함수 실행되서 그 결과값 반환)
    - 그룹함수 : N개의 값을 읽어들여서 1개의 결과값을 리턴 (여러행이 하나의 그룹으로 묶은 후 그룹별로 함수 실행 결과 반환)
    
    > 유의사항 : SELECT절에 단일행함수와 그룹함수를 함께 사용 못함
               왜? 결과 행의 갯수가 다르기 때문에
               
    > 함수를 기술할 수 있는 위치 : SELECT절, WHERE절, ORDER BY절, GROUP BY절, HAVING절, 그 외의 DML문 등 ...

*/

-- =========================== < 단일행 함수 > ===================================

/*
    < 문자 처리 함수 >
    
    * LENGTH / LENGTHB           => 결과값 NUMBER타입으로 반환
    
    LENGTH(컬럼 | '임의의 문자열값') : 해당 문자열값의 글자수 반환
    LENGTHB(컬럼 | '임의의 문자열값') : 해당 문자열값의 바이트수 반환
    
    '강' '나' 'ㄱ' 'ㅏ' 한글의 경우 : 한글자당 3BYTE
    영문자, 숫자, 특수문자 의 경우 : 한글자당 1BYTE    
    
*/

SELECT LENGTH('가나다라마바사'), LENGTHB('가나다라마바사')
FROM DUAL;

SELECT LENGTH('ABC'), LENGTHB('ABC')
FROM DUAL;

SELECT EMP_NAME, LENGTH(EMP_NAME), LENGTHB(EMP_NAME)
       EMAIL, LENGTH(EMAIL), LENGTHB(EMAIL)
       PHONE, LENGTH(PHONE), LENGTHB(PHONE)
FROM EMPLOYEE;


/*
    * INSTR
    문자열로부터 특정 문자의 시작위치를 찾아서 반환
    
    INSTR(컬럼 | '문자열값', '찾고자하는문자', [찾을위치의 시작값, [순번]]) => 결과값을 NUMBER타입
    
    찾을위치의 시작값
    1 : 앞에서부터 찾겠다.
    -1 : 뒤에서부터 찾겠다.
    => 찾을위치의 시작값 및 순번을 생략했을시 기본값 : 1
*/

SELECT INSTR ('가가가나나나다다다' , '나', 1)
FROM DUAL;

SELECT INSTR ('가가가나나나다다다' , '나', -1)
FROM DUAL;

SELECT INSTR ('가가가나나나다다다' , '나', -1, 3)
FROM DUAL;

SELECT INSTR ('AAAabCCAB' ,'a')
FROM DUAL;

SELECT INSTR ('AAAabCCAB' ,'C', 1, 2) -- 앞에서 찾고 2번째 위치의 C의 위치
FROM DUAL;


-- 사원들의 이메일 중 '_'의 첫번째 위치 조회
SELECT INSTR(EMAIL, '_', 1, 1) "_의 위치",
INSTR(EMAIL, '@', 1) "@의 위치" , EMAIL
FROM EMPLOYEE
ORDER BY "@의 위치" ASC;

--------------------------------------------------------------------------------

/*
    * SUBSTR
    문자열에서 특정 문자열을 추출해서 반환 (자바에서의 substring() 메소드와 유사)
    
    SUBSTR(STRING, POSITION, [LENGTH])          => 결과값이 CHARACTER(문자열) 타입
    - STRING : 문자타입컬럼 또는 '문자열값'
    - POSITION : 문자열을 추출할 시작위치값 (음수값으로도 제시 가능)
    - LENGTH : 추출할 문자 갯수 (생략시 끝까지 추출하는 것을 의미)
*/

SELECT SUBSTR('AAABBBCCC', 2, 5) FROM DUAL; -- 앞에서 2번째에서 5개 추출
SELECT SUBSTR('AAABBBCCC', -7, 5) FROM DUAL; -- 뒤에서 7번째에서 5개 추출
SELECT SUBSTR('AAABBBCCC', -40, 5) FROM DUAL; -- 적절한 위치를 제시하지 않았기 때문에 NULL값 반환

-- 010 뒷번호 조회
SELECT PHONE, SUBSTR(PHONE, 4)
FROM EMPLOYEE;

-- EMPLOYEE에 있는 주민번호 값에서 성별 조회
SELECT SUBSTR(EMP_NO, 8,1) "성별" , EMP_NAME
FROM EMPLOYEE
ORDER BY 성별;


-- 여자사원들만 조회
SELECT SUBSTR(EMP_NO, 8, 1) "성별", EMP_NAME
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) = '2';

-- 남자사원들만 조회
SELECT SUBSTR(EMP_NO, 8, 1) "성별", EMP_NAME
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) = '1';

-- 함수 중첩 사용 가능
-- 아이디 조회 : EMAIL에서 '@' 앞 문자열
SELECT EMAIL, SUBSTR(EMAIL, 1, INSTR(EMAIL, '@')-1) "아이디"
FROM EMPLOYEE;

-- DEPARTMENT에서 '영업', '관리' 앞 조회
SELECT DEPT_TITLE, SUBSTR(DEPT_TITLE, 1, INSTR(DEPT_TITLE,'영업')-1) "영업부서",
       SUBSTR(DEPT_TITLE, 1, INSTR(DEPT_TITLE, '관리')-1) "관리부서"
FROM DEPARTMENT
WHERE SUBSTR(DEPT_TITLE, 1, INSTR(DEPT_TITLE,'영업')-1) IS NOT NULL OR
      SUBSTR(DEPT_TITLE, 1, INSTR(DEPT_TITLE, '관리')-1) IS NOT NULL;

--------------------------------------------------------------------------------
/*
    * LPAD / RPAD
    문자열을 조회할 때 통일감있게 조회하고자 할 때 사용
    
    LPAD / RPAD(STRING, 최종적으로반환할문자의길이, [덧붙이고자하는문자])   => 결과값은 CHARACTER 타입
    => 생략하면 기본적으로 '공백'이 덧붙여짐
    
    문자열에 덧붙이고자하는 문자를 왼쪽 또는 오른쪽에 덧붙여서 최종 N길이만큼의 문자열을 반환
*/

-- 이메일에 문자의길이를 15로 설정하여 조회
SELECT EMP_NAME, LPAD(EMAIL, 15) -- 이메일 문자열 왼쪽에 공백이 추가돼서 출력 
FROM EMPLOYEE;

-- 이메일에 문자의길이를 15로 설정하고 *추가해서 조회
SELECT LPAD(EMAIL, 15, '*')
FROM EMPLOYEE;

-- 부서명 문자열 길이 10으로 설정하고 오른쪽으로 통일감있게 한 뒤 조회
SELECT RPAD(DEPT_TITLE, 10)
FROM DEPARTMENT;

-- 부서명 문자열 길이 13으로 설정하고 왼쪽으로 통일감있게 한 뒤 조회
SELECT LPAD(DEPT_TITLE, 13) "부서명"
FROM DEPARTMENT;

-- 951018-2****** 조회
SELECT RPAD('951018-2', 14, '*') "주민번호 앞자리"
FROM DUAL;

-- 사원들의 주민번호를 조회하고 8번째 자리부터는 '*'로 조회
SELECT EMP_NAME "이름", RPAD(SUBSTR(EMP_NO, 1, 8), 14, '*') "성별"
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8,1) IN ('2', '4')
ORDER BY 이름;

-- 사원들의 이메일 @앞글자만 딴뒤 '아이디 : ' 라는 문자열을 붙여서 조회
SELECT EMP_NAME, LPAD(SUBSTR(EMAIL, 1, INSTR(EMAIL, '@')-1), 15, '아이디 : ') "아이디"
FROM EMPLOYEE;

-- 해외영업에서 '부'앞글자만 딴 뒤 '부서 : '라는 문자열 붙여서 조회
SELECT LPAD(SUBSTR(DEPT_TITLE, 1, INSTR(DEPT_TITLE, '부')-1), 15, '부서:  ') "부서"
FROM DEPARTMENT;

--------------------------------------------------------------------------------

/*
     * LTRIM / RTRIM
     문자열에서 특정 문자를 제거한 나머지를 반환
     
     LTRIM / RTRIM(STRING, [제거하고자하는문자들]) : 결과값은 CHARACTER타입
     -> 구문 생략시 기본적으로 '공백'이 제거됨
*/
SELECT LTRIM('    ABC    ') "LTRIM" FROM DUAL;
-- 제거하고자하는 문자를 명시하지 않았기 때문에 왼쪽 '공백'이 제거됨

SELECT RTRIM('    ABC    ') "RTRIM" FROM DUAL;
-- 제거하고자하는 문자를 명시하지 않았기 때문에 오른쪽 '공백'이 제거됨

SELECT LTRIM('123123ABC123123', '123') FROM DUAL;
-- 왼쪽의 '123'문구들이 제거됨

SELECT RTRIM('123123ABC123123', '123') FROM DUAL;
-- 왼쪽의 '123'문구들이 제거됨

SELECT RTRIM('123123ABC123123', 'ABC') FROM DUAL;
-- 오른쪽 첫번째 문자가 ABC가 아니므로 제거 안됨

/*
    * TRIM
    문자열의 앞/뒤/양쪽에 있는 특정문자들을 제거한 나머지 문자열 반환
    
    TRIM([[LEADING/ TRAILING / BOTH] 제거하고자하는문자 FROM] STRING)
*/
SELECT TRIM('    A B C    ') "TRIM" FROM DUAL;
--[[LEADING/ TRAILING / BOTH] 제거하고자하는문자 FROM]이 생략된 경우 기본적으로 양쪽에 있는 문자들을 제거

SELECT TRIM('1' FROM '111ABC111') "TRIM" FROM DUAL;
SELECT TRIM('1' FROM '123ABC321') FROM DUAL;
-- TRIM함수같은경우는 제거하고자하는 문자들 여러개를 쓸수 없고 한개만 쓸수있다

SELECT TRIM(LEADING '1' FROM '111ABC111'),
       LTRIM('111ABC111', '1') 
       FROM DUAL;
-- LEADING : 앞 => LTIRM과 유사

SELECT TRIM(TRAILING '1' FROM '111ABC111'),
       RTRIM('111ABC111', '1')
       FROM DUAL;
-- TRAILING : 뒤 => RTRIM과 유사

SELECT TRIM(BOTH '1' FROM '111ABC111') "TRIM" FROM DUAL;
-- TRIM : 양쪽 => 생략시 기본값

-- SELECT TRIM ('ABC' FROM '111ABC111') FROM DUAL;
-- 앞/뒤/양쪽에 있는 구문이 아닌 문장 사이에 있는 구문은 제거 불가능 => REPLACE 함수 활용하기!!

--------------------------------------------------------------------------------

/*
    * LOWER / UPPER / INITCAP
    
    LOWER / UPPER / INITCAP => 결과값은 CHARACTER타입
    
    LOWER : 다 소문자로 변경한 문자열 반환 (자바에서 toLowerCase()와 유사
    UPPER : 다 대문자로 변경한 문자열 반환 (자바에서 toUpperCase()와 유사
    INITCAP : 공백 기준으로 단어마다 앞글자를 대문자로 변경한 문자열 반환
*/    

SELECT LOWER ('ORACLE Great!') FROM DUAL;
SELECT UPPER ('ORACLE Great!') FROM DUAL;
SELECT INITCAP ('oracle is great!') FROM DUAL; -- Oracle Is Great!
-- 공백을 기준으로 하나하나의 단어로 취급함

--------------------------------------------------------------------------------

/*
    * REPLACE
    
    REPLACE(STRING, STR1, STR2) => 결과값은 CHARACTER타입
    
    STR1 : 대체/제거를 원하는 문자열
    STR2 : 대체/제거하고자하는 문자
*/
SELECT REPLACE('111ABC111', 'ABC', '') "REPLACE" FROM DUAL;
-- 문자사이의 문자를 TRIM과 달리 REPLACE함수로 제거/대체 할 수 있음

SELECT EMP_NAME, LPAD(EMAIL, 15, ' ') "변경 전", LPAD(REPLACE(EMAIL, 'br.com', 'gmail.com'), 18, ' ') "변경 후"
FROM EMPLOYEE;

--------------------------------------------------------------------------------
/*
    * ABS
    숫자의 절대값을 구해주는 함수
    
    ABS(NUMBER) => 결과값을 NUMBER타입
*/  
SELECT ABS(-10) FROM DUAL;
SELECT ABS(123.345) FROM DUAL;
SELECT ABS(-123.345) FROM DUAL;

--------------------------------------------------------------------------------

/*
    * MOD
    두 수를 나눈 값을 반환해주는 함수 (자바에서의 %와 동일)
    
    MOD(NUMBER, NUMBER)     => 결과값은 NUMBER타입
*/
SELECT MOD(10,2) FROM DUAL; -- 0
SELECT MOD(10,3) FROM DUAL; -- 1
SELECT MOD(-10.9, 3) FROM DUAL;

SELECT 10 / 3 FROM DUAL; -- 3.333...
-- 정수값이 반환되는 것이 아니라 실제 나누기값이 반환됨 
-- SELECT 10 % 3 FROM DUAL; -- 자바처럼 % 연산자 없음

--------------------------------------------------------------------------------
/*
    * ROUND
    반올림한 결과를 반환
    
    ROUND(NUMNER, [위치]) => 결과값은 NUMBER타입
*/
SELECT ROUND(123.123) FROM DUAL;
-- 위치 생략시 0(소수점이 시작되기 바로 전)까지 표현이 기본값

SELECT ROUND(123.123, 1) FROM DUAL;
-- 소수점 첫번째 자리까지 반올림돼서 표현
-- 소수점 아래부터는 1,2,3,... 순으로 정렬됨

SELECT ROUND(1233.1234, -2) FROM DUAL;
-- 10의 자리까지 반올림돼서 표현
-- 정수값부터는 1의 자리 : 0, 10의 자리 : -1, 100의 자리 : -2,... 순으로 정렬됨

SELECT ROUND(12.54, 5) FROM DUAL;
-- 존재하지않는 위치를 지정하면 기본값으로 조회

--------------------------------------------------------------------------------
/*
    * CEIL
    올림처리해주는 함수 (위치지정 불가능)
    
    CEIL(NUMBER)
*/
SELECT CEIL(199.999) FROM DUAL; -- 200
SELECT CEIL(199.001) FROM DUAL; -- 200
-- 소수점 아래값이 아무리 작아도 올림처리해서 출력

SELECT CEIL(199.00) FROM DUAL; -- 199
-- 소수점 아래가 모두 0이면 정수값이기 때문에 올림처리 안됨

-- SELECT CEIL(199.123, 2) FROM DUAL; -- 위치지정 불가능

--------------------------------------------------------------------------------
/*
    * FLOOR
    소수점 아래값 버림처리하는 함수 (위치지정 불가능)
    
    FLOOR(NUMBER)
*/
SELECT FLOOR(123.999) FROM DUAL; -- 123
SELECT FLOOR(123.001) FROM DUAL; -- 123
-- 소수점 아래값의 크기 상관없이 무조건 내림처리

SELECT FLOOR(123.000) FROM DUAL; -- 123
-- 소수점 아래가 모두 0이면 정수값이기 때문에 내림처리 안됨
-- SELECT FLOOR(123.123, 1) FROM DUAL; -- 위치지정 불가능

--------------------------------------------------------------------------------
/*
    * TRUNC
    위치 지정 가능한 버림처리해주는 함수
    
    TRUNC(NUMBER, [위치])
*/
SELECT TRUNC(123.123) FROM DUAL; -- 123
-- 위치 지정 안했을 때는 소수점 아래값 모두 버림 
SELECT TRUNC(123.123, 2) FROM DUAL; -- 123.12
-- 소수점 둘째 자리까지 버림
SELECT TRUNC(123.123, -1) FROM DUAL; -- 120
-- 십의 자리까지 버림 (음수값도 가능)

--------------------------------------------------------------------------------
-- * SYSDATE : 시스템 날짜 및 시간 반환 (현재 날짜 및 시간)
SELECT SYSDATE FROM DUAL;

/*
    < 날짜 처리 함수 >
*/

/* MONTHS_BETWEEN(DATE1, DATE2)
-- 두 날짜 사이의 개월 수를 반환해주는 함수 => 결과값은 NUMBER타입
-- 내부적으로 DATE1 - DATE2 후 나누기 30 또는 31이 진행됨
*/
SELECT MONTHS_BETWEEN(SYSDATE,HIRE_DATE) FROM EMPLOYEE;
-- 시스템에는 년/월/일/시/분/초가 내장되어있기 때문에 산술연산하면 소수점 아래자리가 같이 출력됨
SELECT ROUND(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)) "근무개월수" FROM EMPLOYEE;
-- CEIL, FLOOR, ROUND 처리를 통해 정수값만 반환되도록 설정

-- 사원들의 이름, 근무일수, 근무개월수 조회
SELECT EMP_NAME "사원명",
       ROUND(SYSDATE - HIRE_DATE) "근무일수",
       CEIL(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)) "근무개월수"
FROM EMPLOYEE
ORDER BY 근무개월수 DESC;


/*
    * ADD_MONTHS(DATE, NUMBER) : 특정 날짜에서 해당 숫자만큼의 개월 수를 더해서 그 날짜 변환
                         => 결과값은 DATE타입
    특정 날짜로부터 몇 개월 후의 날짜를 알아내고자 할 때 사용                   
*/
SELECT ADD_MONTHS(SYSDATE, 5) FROM DUAL; 

-- 사원명, 입사일, 입사일로부터 1년 후의 날짜를 조회
SELECT EMP_NAME "사원명", HIRE_DATE "입사일", ADD_MONTHS(HIRE_DATE, 12) "입사 1년후" 
FROM EMPLOYEE
ORDER BY HIRE_DATE DESC;

-- 사원명, 입사일, 입사일로부터 1년 후의 날짜를 조회
SELECT EMP_NAME "사원명", HIRE_DATE "입사일", ADD_MONTHS(HIRE_DATE, 120) "입사 10년후" 
FROM EMPLOYEE
ORDER BY HIRE_DATE;

/*
    * NEXT_DAY(DATE, 요일(문자|숫자))
     특정 날짜 이후에 가장 가까운 해당 요일의 날짜를 반환해주는 함수
     => 결과값은 DATE 타입
*/
SELECT NEXT_DAY(SYSDATE, '금') FROM DUAL;
SELECT NEXT_DAY(SYSDATE, '수요일') FROM DUAL;
SELECT NEXT_DAY(SYSDATE, 1) FROM DUAL; -- 일요일
SELECT NEXT_DAY(SYSDATE, 2), -- 월요일
       NEXT_DAY(SYSDATE,4) -- 수요일
       FROM DUAL;
-- 문자, 숫자 모두 출력 가능
-- 1 : 일요일, 2 : 월요일, 3 : 화요일, 4 : 수요일, 5 : 목요일, 6 : 금요일, 7 : 토요일

SELECT NEXT_DAY(SYSDATE, 'FRIDAY') FROM DUAL; -- 오류 발생
-- 현재 시스템의 언어가 KOREAN으로 되어있어서 한글, 숫자만 출력가능

-- 언어 번경
ALTER SESSION SET NLS_LANGUAGE = AMERICAN; 
-- 언어를 AMERICAN으로 변경

SELECT NEXT_DAY(SYSDATE, 'FRIDAY') FROM DUAL; -- 금요일
SELECT NEXT_DAY(SYSDATE, 'FRI') FROM DUAL; -- 금요일
-- 언어를 AMERICAN으로 변경 후 오류 발생X
SELECT NEXT_DAY(SYSDATE, '수요일') FROM DUAL;
-- 오류 발생
SELECT NEXT_DAY(SYSDATE, 5) FROM DUAL; -- 목요일
-- 숫자는 언어 상관없이 똑같이 출력
-- 언어가 불명확할 경우 숫자를 쓰는것을 권장
ALTER SESSION SET NLS_LANGUAGE = KOREAN;


/*
    * LAST_DAY(DATE) 
    해당 월의 마지막 날짜(30/31)를 구해서 반환 => 결과값 DATE타입
*/
SELECT LAST_DAY(SYSDATE) FROM DUAL; 

-- 사원명, 입사일, 입사일의 마지막 날짜
SELECT EMP_NAME, HIRE_DATE, LAST_DAY(HIRE_DATE) FROM EMPLOYEE;

-- 사원명, 입사일, 입사한일의 마지막 날짜, 근무일수
SELECT EMP_NAME, HIRE_DATE, LAST_DAY(HIRE_DATE) "달의 마지막 날짜", 
       (LAST_DAY(HIRE_DATE) - HIRE_DATE) "근무일수"
FROM EMPLOYEE;
-- LAST_DAY(HIRE_DATE) - HIRE_DATE은 시/분/초가 없음
-- SYSDATE에는 시/분/초가 있어서 결과값이 복잡하게 나옴

-- 사원명, 입사일, 입사한일의 마지막날짜, 현재까지의 근무일수
SELECT EMP_NAME, HIRE_DATE, LAST_DAY(HIRE_DATE) "달의 마지막 날", 
       ROUND(SYSDATE - HIRE_DATE) "근무일수"
FROM EMPLOYEE;

-- 사원명, 입사일, 입사한일의 마지막날짜, 달의 마지막날부터 현재까지의 근무일수
SELECT EMP_NAME, HIRE_DATE, LPAD(LAST_DAY(HIRE_DATE),9) "달의 마지막", 
       ROUND(SYSDATE - (LAST_DAY(HIRE_DATE))) "근무일수"
FROM EMPLOYEE
ORDER BY 근무일수 ASC;

/*
    * EXTRACT 
    특정 날짜로부터 년/월/일 값을 추출해서 반환
    
    EXTRACT(YEAR FROM DATE) : 년도만을 추출
    EXTRACT(MONTH FROM DATE) : 월만을 추출
    EXTRACT(DAY FROM DATE) : 일만을 추출
    => 결과값은 DATE타입
*/
SELECT SYSDATE, EXTRACT(YEAR FROM SYSDATE) "년도" FROM DUAL;
SELECT SYSDATE, EXTRACT(MONTH FROM SYSDATE) "월" FROM DUAL;
SELECT SYSDATE, EXTRACT(DAY FROM SYSDATE) "일" FROM DUAL;

-- 사원명, 입사일, 입사일의 년/월/일
SELECT EMP_NAME, HIRE_DATE 입사일,
       EXTRACT(YEAR FROM HIRE_DATE) 년도,
       EXTRACT(MONTH FROM HIRE_DATE) 월, 
       EXTRACT(DAY FROM HIRE_DATE) 일
FROM EMPLOYEE
ORDER BY 입사일;

--------------------------------------------------------------------------------
/*
    < 형변환 함수 >
    *TO_CHAR : 숫자 또는 날짜 타입의 값을 문자열로 반환시켜주는 함수
    
    TO_CHAR(숫자|날짜, [포맷])    => 결과값은 CHARACTER타입
*/
SELECT TO_CHAR(123) FROM DUAL; -- '123'
SELECT TO_CHAR(SYSDATE) FROM DUAL; -- '22/05/18'

SELECT TO_CHAR(12345, '999999') "문자" FROM DUAL;
-- '999999'은 자리수를 의미, 빈칸은 기본적으로 '공백'으로 채워짐
-- 다섯칸이 확보되고 나머지 한 칸은 공백으로 출력 => ORACLE의 경우 무의미한 공백이 같이 출력될 수 있음
SELECT TO_CHAR(12345, '9999999999') "문자" FROM DUAL; -- '      12345'

SELECT TO_CHAR(12345, '0000000') "문자" FROM DUAL; -- ' 0012345'
-- '00000000' 또한 자리수를 의미, 하지만 9와 달리 0은 빈칸에 공백 대신 '0'으로 채워짐

SELECT TO_CHAR(12345, 'FM0000000') "문자" FROM DUAL; -- '0012345'
-- FM : 포맷앞에 붙이면 ORACLE의 무의미한 공백이 사라짐

SELECT TO_CHAR(12345, 'FML99999') "화폐" FROM DUAL;
-- L : 포맷 앞에 붙이면 현재 설정된 나라(LOCAL)의 화폐단위로 출력됨

SELECT TO_CHAR(10000000, 'FML999,999,999') "화폐" FROM DUAL;
-- 돈 단위로도 출력 가능

-- 사원명, 급여, 연봉
SELECT EMP_NAME "사원명",
       TO_CHAR(SALARY, '999,999,999') "급여",
       TO_CHAR(SALARY * 12, '999,999,999') "연봉"
FROM EMPLOYEE
ORDER BY 연봉 DESC;

-- 날짜 타입 => 문자 타입
SELECT TO_CHAR(SYSDATE) FROM DUAL;

SELECT TO_CHAR(SYSDATE, 'HH:MI:SS') "시간" FROM DUAL;
-- HH : 시간, MI : 분, SS : 초
SELECT TO_CHAR(SYSDATE, 'AM HH:MI:SS') "시간" FROM DUAL;
-- AM/PM : 오전/오후 => 아무거나 붙여도 상관없음(시스템시간에 따라 저정도 출력됨)
SELECT TO_CHAR(SYSDATE, 'AM HH24:MI:SS') "시간" FROM DUAL;
-- HH24 : 시간을 24시간대로 출력해줌

-- 사원명, 입사일(월과 일에 0을 뺵 출력)
SELECT EMP_NAME, TO_CHAR(HIRE_DATE, 'YYYY-FMMM-DD') "입사일" FROM EMPLOYEE;
-- FM : 날짜에서 0을 뺴고 출력(단, FM이 붙은 자리 이후 모두 적용)

-- 년도와 관련된 포맷
SELECT TO_CHAR(SYSDATE, 'YYYY'), -- 2022
       TO_CHAR(SYSDATE, 'YY'), -- 22
       TO_CHAR(SYSDATE, 'RR'), -- 22
       TO_CHAR(SYSDATE, 'YEAR') -- 영문으로 출력
FROM DUAL;

-- 월과 관련된 포맷
SELECT TO_CHAR(SYSDATE, 'MM'), -- 'xx'
       TO_CHAR(SYSDATE, 'MON'), -- 'X월'로 출력
       TO_CHAR(SYSDATE, 'MONTH'), -- 'X월'로 출력
       TO_CHAR(SYSDATE, 'RM') -- 로마기호로 출력
FROM DUAL;

-- 일과 관련된 포맷
SELECT TO_CHAR(SYSDATE, 'DDD'), -- 해당 년도에서 며칠이 지났는지
       TO_CHAR(SYSDATE, 'DD'), -- 해당 월에서 며칠이 지났는지
       TO_CHAR(SYSDATE, 'D') -- 해당 주에서 며칠이 지났는지
FROM DUAL;

-- 요일과 관련된 포맷
SELECT TO_CHAR(SYSDATE, 'DAY'), -- 'X요일'
       TO_CHAR(SYSDATE, 'DY') -- 'X'
FROM DUAL;

-- EX) 'XXXX년 XX월 XX일 (X요일)로 출력하기
SELECT TO_CHAR(SYSDATE, 'YYYY"년" MM"월" DD"일" (DAY)') FROM DUAL;

-- 사원명, 입사일, 입사일을 'XXXX년 XX월 XX일 (X)로 출력하기
SELECT EMP_NAME, HIRE_DATE,
       TO_CHAR(HIRE_DATE, 'YYYY"년" MM"월" DD"일" (DY)') "입사일"
FROM EMPLOYEE;

--------------------------------------------------------------------------------
/*
    * TO_DATE : 숫자타입 또는 문자타입 데이터를 날짜타입으로 변환시켜주는 함수
    
    TO_DATE(숫자|문자, [포맷])    => 결과값은 DATE 타입
*/
SELECT TO_DATE(20101215) FROM DUAL;
SELECT TO_DATE(101215) FROM DUAL;
SELECT TO_DATE(1215) FROM DUAL; -- 오류 발생
SELECT TO_DATE(071215) FROM DUAL; -- 맨 앞의 0은 인식 X : 오류 발생
-- 숫자이기 때문에 발생하는 오류
SELECT TO_DATE('071215') FROM DUAL;
-- 문자로 감싸고 출력하면 정상출력됨

SELECT TO_DATE(20151106, 'YYYYMMDD') FROM DUAL;

SELECT TO_DATE(111111, 'YYMMDD'), -- 2011
       TO_DATE(951018, 'YYMMDD') -- 2095
FROM DUAL;
-- YY의 경우 : 무조건 현재세기로 반영
SELECT TO_DATE(111111, 'RRMMDD'), -- 2011
       TO_DATE(951018, 'RRMMDD') -- 1995
FROM DUAL;
-- RR의 경우 : 50을 기준으로 50미만은 현재세기, 50이상은 이전세기로 반영
SELECT TO_DATE(491111, 'RRMMDD'), -- 2049
       TO_DATE(501018, 'RRMMDD'), -- 1950
       TO_DATE(511018, 'RRMMDD') -- 1951
FROM DUAL;

--------------------------------------------------------------------------------
/*
    * TO_NUMBER
    문자타입의 데이터를 숫자타입으로 변환시키는 함수
    
    TO_NUMBER(문자, [포맷])     => 결과값은 NUMBER
*/
SELECT TO_NUMBER('12345') FROM DUAL;

SELECT TO_NUMBER('1,000,000', '999,999,999') + TO_NUMBER('333,333', '999,999,999') "숫자" FROM DUAL;
-- 1333333
SELECT '1000000' + '5500000' FROM DUAL; -- 산술연산이 진행돼서 출력
-- ORACALE은 자동형변환이 잘 되어있음

-- SELECT '1,000,000' + '550,000' FROM DUAL;  -- 오류발생
SELECT TO_NUMBER ('1,000,000') + TO_NUMBER('550,000') FROM DUAL; -- 오류발생
SELECT TO_NUMBER ('1,000,000', '9,999,999') + TO_NUMBER('550,000', '9,999,999') FROM DUAL;
-- 포맷에 옮겨서 포맷형식으로 출력해야함

--------------------------------------------------------------------------------

/*
    < NULL 처리 함수 >
*/
-- * NVL (컬럼, 반환값)
-- 해당 컬럼값이 존재할 경우 기존의 값 반환
-- 해당 컬럼값이 존재하지 않을 경우 (NULL일 경우) 반환값 반환
SELECT EMP_NAME, NVL(BONUS, 0) "보너스유무" FROM EMPLOYEE;

SELECT EMP_NAME, NVL(DEPT_CODE, '-') FROM EMPLOYEE;
-- 부서코드가 NULL이면 X 값으로 반환
SELECT EMP_NAME, NVL(DEPT_CODE, '부서없음') "부서유무"-- 반환값은 'ANYTYPE' 가능
FROM EMPLOYEE;

-- 보너스가 포함된 연봉값 반환 (보너스가 없으면 기존 연봉값 반환
SELECT EMP_NAME, BONUS, SALARY, NVL((SALARY + (SALARY * BONUS)) * 12, SALARY * 12) "연봉" FROM EMPLOYEE;
-- 또는
SELECT EMP_NAME, BONUS, SALARY, (SALARY + (SALARY * NVL(BONUS,0))) * 12 "연봉" FROM EMPLOYEE;

-- * NVL2 (컬럼, 반환값1, 반환값2)
-- 해당 컬럼값이 존재할 경우 반환값1 반환
-- 해당 컬럼값이 NULL일 경우 반환값2 반환
SELECT EMP_NAME,
       NVL2(BONUS, '보너스O', '보너스X') "보너스유무"
FROM EMPLOYEE;

SELECT EMP_NAME,
       NVL2(DEPT_CODE, DEPT_CODE, 'X') "부서유무"
FROM EMPLOYEE;

-- * NULLIF(비교대상1, 비교대상2)
-- 두 개의 값이 일치하면 NULL 반환
-- 두 개의 값이 일치하지 않으면 비교대상1 값을 반환
SELECT NULLIF('123','123') FROM DUAL;
SELECT NULLIF('EMP_NAME', 'EMP_NAME') "이름" FROM EMPLOYEE;

--------------------------------------------------------------------------------

/*
    < 선택 함수 >
    * DECODE(비교대상(컬럼|산술연산|함수), 비교값1, 결과값1, 비교값2, 결과값2, ...결과값N)
    마지막에 쓰이는 결과값은 비교값을 안ㅆ고 출력할 수 있음 (자바의 SWITCH문에서 default와 동일)
*/
SELECT EMP_NAME, DECODE(SUBSTR(EMP_NO, 8 , 1), '1', '남자', '2', '여자') "성별"
FROM EMPLOYEE;

SELECT EMP_NAME, DECODE(SUBSTR(EMP_NAME, 1, 1), '김' ,'김씨' , 'X') "김씨확인"
FROM EMPLOYEE
ORDER BY EMP_NAME;

-- 사원명, 직급코드, 기존급여, 인상된 급여
-- J7인 사원은 급여를 10%인상 (SALARY * 1.1)
-- J6인 사원은 급여를 15%인상 (SALARY * 1.15)
-- J5인 사원은 급여를 20%인상 (SALARY * 1.2)
-- 그 외의 사원은 급여를 5%인상 (SALARY * 1.05)

SELECT EMP_NAME, JOB_CODE, SALARY "기존 급여",
       DECODE(JOB_CODE, 'J7', SALARY * 1.1,
                      'J6', SALARY * 1.15,
                      'J5', SALARY * 1.2,
                      SALARY * 1.05) "인상된 급여"
FROM EMPLOYEE;

/*
    < CASE WHEN THEN >
    
    CASE WHEN 조건식1 THEN 결과값1   => WHEN뒤에 값이 TRUE면 결과값 반환
         WHEN 조건식2 THEN 결과값2
         ...
         ELSE 결과값N               => 모든 값이 FALSE인 경우 ELSE 뒤에 결과값N반환
         END                       => CASE 뒤에는 무조건 'END'를 표시해야함
*/
SELECT EMP_NAME, SALARY,
       CASE WHEN SALARY >= 5000000 THEN '고연봉'
            WHEN SALARY >= 3000000 THEN '중간연봉'
                 ELSE '신입'
                 END "연봉등급"
FROM EMPLOYEE
ORDER BY SALARY DESC;

-- 나이에 따라 조회
SELECT EMP_NAME, EMP_NO,
       CASE WHEN SUBSTR(EMP_NO,1,2) >= 90 THEN '90년대'
            WHEN SUBSTR(EMP_NO,1,2) >= 80 THEN '80년대'
            WHEN SUBSTR(EMP_NO,1,2) >= 70 THEN '70년대'
            WHEN SUBSTR(EMP_NO,1,2) >= 60 THEN '60년대'
            ELSE '퇴사'
            END "태어난 년도"
FROM EMPLOYEE
ORDER BY SUBSTR(EMP_NO,1,2);

-- 사원 주민번호에 따른 성별 조회
SELECT EMP_NAME, EMP_NO,
       CASE WHEN(SUBSTR(EMP_NO, 8, 1)) IN ('1', '3') THEN '남자'
            WHEN(SUBSTR(EMP_NO, 8, 1)) IN ('2', '4') THEN '여자'
            END "성별"
FROM EMPLOYEE;

-------------------------------< 그룹 함수 >--------------------------------------

-- 1. SUM(NUMBER컬럼) : 해당 컬럼 값들의 총 합계를 구해서 반환해주는 함수
SELECT SUM(SALARY) FROM EMPLOYEE;

-- 부서코드가 'D5'인 사람들의 총 급여 합계
SELECT SUM(SALARY)
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5';

-- 2. AVG(NUMBER컬럼) : 해당 컬럼값들의 평균값을 구해서 반환
SELECT TO_CHAR(ROUND( AVG(SALARY) ), '999,999,999') "평균급여" FROM EMPLOYEE;

SELECT TO_CHAR(ROUND(AVG(SALARY*12)), '999,999,999') || '원' "평균연봉"
FROM EMPLOYEE
WHERE DEPT_CODE = 'D1';

-- SELECT EMP_NAME, AVG(SALARY) FROM EMPLOYEE; -- 오류 발생
-- EMP_NAME는 23개가 조회되어야하지만 AVG(SALARY)는 1개가 조회되어야한다
-- 행의 갯수가 맞지않아서 오류발생

-- SELECT SUBSTR(EMP_NO, 8,1), AVG(SALARY) FROM EMPLOYEE; -- 오류 발생
-- 즉, 단일행 함수랑 그룹함수랑 SELECT절에 같이 기술 불가!!!

-- 3. MIN (ANY타입컬럼) : 해당 컬럼값들 중에 가장 작은 값 구해서 반환
SELECT MIN(EMP_NAME), MIN(EMP_NO), MIN(SALARY)
FROM EMPLOYEE;
-- 각각 컬럼들 중 가장 작은값이 조회

-- 4. MAX (ANY타입컬럼) : 해당 컬럼값들 중에 가장 큰 값 구해서 반환
SELECT MAX(EMP_NAME), MAX(EMP_NO), MAX(SALARY)
FROM EMPLOYEE;

-- 5. COUNT (*|컬럼|DISTINCT 컬럼) : 행 갯수를 세서 반환
--    COUNT(*) : 조회된 결과에 모든 행 갯수를 세서 반환
--    COUNT(컬럼) : 제시된 해당 컬럼값이 NULL이 아닌 것만 행 갯수를 세서 반환
--    COUNT(DISTINCT 컬럼) : 해당 컬럼값 중복을 제거한 후 행 갯수 세서 반환
SELECT COUNT(*)
FROM EMPLOYEE;

SELECT COUNT(*)
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9';

-- 남자 사원들의 수
SELECT COUNT(*)
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) IN ('1','3');

-- 여자 사원들의 수
SELECT COUNT(*)
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) IN ('2','4');

-- 보너스를 받는 사원 수
SELECT COUNT(*)
FROM EMPLOYEE
WHERE BONUS IS NOT NULL;

SELECT COUNT(BONUS)
FROM EMPLOYEE;
-- NULL값은 갯수에 포함안됨

-- 현재 사원들이 총 몇개의 부서에 분포되어있는지
SELECT COUNT(DISTINCT DEPT_CODE) "부서배치"
FROM EMPLOYEE;
-- NULL은 갯수에 포함 안됨

-- D6부서의 부서원수, 총 급여합, 평균급여, 최소급여, 최대급여
SELECT COUNT(*), SUM(SALARY), ROUND( AVG(SALARY) ), MIN(SALARY), MAX(SALARY)
FROM EMPLOYEE
WHERE DEPT_CODE = 'D6';

-- 부서원 중에 급여가 300만원 이상인 사람들의 수, 총 급여합, 평균급여, 최소급여, 최대급여
SELECT COUNT(*), SUM(SALARY), ROUND( AVG(SALARY) ), MIN(SALARY), MAX(SALARY)
FROM EMPLOYEE
WHERE SALARY >= 3000000;