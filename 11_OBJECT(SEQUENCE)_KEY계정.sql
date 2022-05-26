/*
    < 시퀀스 SEQUENCE >
    자동으로 번호 발생시켜주는 역할의 객체
    정수값을 순차적으로 일정값씩 증가시키면서 생성해줌
    
    EX) 회원번호, 사원번호, 게시글번호, ... 
*/

/*
    1. 시퀀스 객체 생성
    
    [표현법]
    CREATE SEQUENCE 시퀀스명
    [START WITH 시작숫자]        --> 처음 발생시킬 시작값 지정, (기본값 : 1)
    [INCREMENT BY 숫자]         --> 몇 씩 증가시킬 것인지, (기본값 : 1)
    [MAXVALUE 숫자]             --> 최대값 지정 : 최대 몇까지 증가시킬 것인지, (기본값 : 엄청 큼)
    [MINVALUE 숫자]             --> 최소값 지정, (기본값 : 1)
    [CYCLE | NOCYCLE]          --> 값 순환 여부 지정, (기본값 : NOCYCLE)
    [NOCACHE | CACHE 바이트크기] --> 캐시메모리 할당
    
    * 캐시메모리 : 미리 발생될 값들을 생성해서 저장해두는 공간
                 매번 호출할 때 마다 새로이 번호를 생성하는게 아니라 
                 캐시메모리 공간에 미리 생성된 값을 가져다 쓸 수 있음 (속도가 빨라짐)
                 접속이 해제되면 캐시메모리에 미리 만들어 둔 번호들은 다 날라감 
                 => 1~20번까지의 메모리가 캐시메모리에 저장되어있는데 13번까지 번호가 지정되고 접속이 해제되는 경우 다시 연결했을 때 저장해둔 값은 사라지고 21번부터 시작됨
                 
    ** 각 번호들이 안겹치게 하는 것이 핵심!
    
    테이블명 : TB
    뷰명    : VW
    시쿼스명 : SEQ
    트리거명 : TRG
    
    수정시 삭제했다가 다시 만들거나 ALTER로 수정
*/

CREATE SEQUENCE SEQ_TEST;

CREATE SEQUENCE SEQ_EMPNO
START WITH 200
INCREMENT BY 3
MAXVALUE 215
NOCYCLE
NOCACHE;

/*
    2. 시퀀스 사용 (호출)
    
    시퀀스명.CURRVAL    -> 현재 시퀀스의 값을 알아낼 수 있음(마지막으로 수행시킨 NEXTVAL의 값)
    시퀀스명.NEXTVAL    -> 시퀀스 값에 일정값을 증가시켜서 새로이 발생된 값
                         현재 시퀀스 값에서 INCREMENT BY값 만큼 증가된 값
*/

SELECT SEQ_EMPNO.CURRVAL FROM DUAL; -- 현재 시퀀스의 값을 조회하기 위해서는 NEXTVAL를 실행한 후에 조회가능함
SELECT SEQ_EMPNO.NEXTVAL FROM DUAL;
-- 왜? CURRVAL은 마지막으로 성공적으로 수행된 NEXTVAL의 값을 저장해서 보여주는 임시값

-- NEXTVAL값 조회
SELECT SEQ_EMPNO.NEXTVAL FROM DUAL; -- 203
SELECT SEQ_EMPNO.NEXTVAL FROM DUAL; -- 206
SELECT SEQ_EMPNO.NEXTVAL FROM DUAL; -- 209
--> INCREMENT BY로 지정한 3씩 증가
-- NEXTVAL을 수행할 때 마다 INCREMENT BY 값만큼 증가하여 LAST_NUMBER(FIRST_NUMBER)값 증가

SELECT SEQ_EMPNO.CURRVAL FROM DUAL; -- 209

SELECT SEQ_EMPNO.NEXTVAL FROM DUAL; 
-- 지정한 MAXVALUE값을 초과하면 오류 발생 (실패)

/*
    3. 시퀀스 변경
    
    ALTER SEQUENCE 시퀀스명
    [INCREMENT BY 숫자]         --> 몇 씩 증가시킬 것인지, (기본값 : 1)
    [MAXVALUE 숫자]             --> 최대값 지정 : 최대 몇까지 증가시킬 것인지, (기본값 : 엄청 큼)
    [MINVALUE 숫자]             --> 최소값 지정, (기본값 : 1)
    [CYCLE | NOCYCLE]          --> 값 순환 여부 지정, (기본값 : NOCYCLE)
    [NOCACHE | CACHE 바이트크기] --> 캐시메모리 할당
    
   * 단, START WITH(시작숫자)는 변경 불가능!!!!    -> 이미 시퀀스가 진행됐기 때문에
*/

ALTER SEQUENCE SEQ_EMPNO
INCREMENT BY 5
MAXVALUE 230
NOCYCLE
NOCACHE;
--> 기존의 시퀀스의 조건 변경

SELECT SEQ_EMPNO.NEXTVAL FROM DUAL;
SELECT SEQ_EMPNO.CURRVAL FROM DUAL;

-- 4. 시퀀스 삭제
DROP SEQUENCE SEQ_EMPNO;

--------------------------------------------------------------------------------

-- * INSERT문에서 시퀀스 활용
-- 사원번호로 활용할 시퀀스 생성

CREATE SEQUENCE SEQ_EID
START WITH 400
NOCACHE;

INSERT INTO EMPLOYEE_COPY
            ( EMP_ID
            , EMP_NAME
            , EMP_NO
            , DEPT_CODE
            , JOB_CODE
            , SALARY
            )
    VALUES 
          ( SEQ_EID.NEXTVAL
          , '홍길동'
          , '941010-1234567'
          , 'D1'
          , 'J7'
          , 3500000
          );


INSERT INTO EMPLOYEE_COPY
            ( EMP_ID
            , EMP_NAME
            , EMP_NO
            , DEPT_CODE
            , JOB_CODE
            , SALARY
            )
    VALUES 
          ( SEQ_EID.NEXTVAL --> 직접 값을 지정하는 것이 SEQUENCE 구문에서 지정한 숫자부터 자동으로 값이 증가하도록 설정 
          , '강개솔'
          , '931210-2234127'
          , 'D2'
          , 'J5'
          , 4200000
          );













