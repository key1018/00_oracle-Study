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


