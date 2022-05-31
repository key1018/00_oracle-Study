/*
    < TRIGGER 트리거 > 
    내가 지정한 테이블에 INSERT, UPDATE, DELETE등의 DML문에 의해 변경사항이 생길 때 (테이블에 이벤트가 발생했을 때)
    자동으로(묵시적으로) 매번 실행할 내용을 미리 정의해둘 수 있는 객체
    
   ex) 
   회원탈퇴시 기존의 회원테이블(A)에 데이터 DELETE 후 곧바로 탈퇴된 회원들만 따로 보관하는 테이블(B)에 자동으로 INSERT시키고자 할 때
   회원 신고횟수가 일정수를 넘었을 때 묵시적으로 해당 회원을 블랙리스트로 처리되게끔
   입출고에 대한 데이터가 기록(INSERT)될 때마다 해당 상품에 대한 재고수량을 매번 수정(UPDATE)해야될 때
   
   * TRIGGER의 종류
   - SQL문의 실행시기에 따른 분류
   > AFTER TRIGGER : 내가 지정한 테이블에 이벤트가 발생된 후에 트리거 실행
   > BEFORE TRIGGER : 내가 지정한 테이블에 이벤트가 발생되기 전에 트리거 실행
   
   - SQL에 의해 영향을 받는 각 행에 따른 분류
   > STATEMENT TRIGGER(문장트리거) : 이벤트가 발생한 SQL문에 대해서 딱 한번만 트리거 실행
   > ROW TRIGGER(행 트리거) : 해당 SQL문 실행할 때 마다 매번 트리거 실행 (FOR EACH ROW 옵션 기술해야함)
                            이전 자료 > :OLD - BEFORE UPDATE(수정전 자료), BEFORE DELETE(삭제전 자료)
                            최신 자료 > :NEW - AFTER INSERT(새로 추가된 자료), AFTER UPDATE(수정 후 자료)       -> AFTER DELETE는 이미 삭제됐기 때문에 불가능!!!
                            
    * TRIGGER 생성구문
    
    CREATE [OR REPLACE] TRIGGER 트리거명
    BEFORE|AFTER    INSERT|UPDATE|DELETE ON 테이블명
    [FOR EACH ROW]
    [DECLARE 
        변수선언;]
    BEGIN
        실행내용; (위에 지정한 이벤트 발생시 자동으로 실행할 구문)      => 핵심!!
    [EXCEPTION
        예외처리구문]
    END;
    /
                             
*/

-- EMPLOYEE 테이블에 새로운 행이 INSERT된 후에 매번 자동으로 메세지 출력되는 트리거 정의
CREATE OR REPLACE TRIGGER TRG_01
AFTER INSERT ON EMPLOYEE
FOR EACH ROW
BEGIN
    DBMS_OUTPUT.PUT_LINE('새로운 행이 추가되었습니다.');
END;
/

-- 트리거 실행 문구 
SET SERVEROUTPUT ON;

-- EMPLOYEE에 행 삽입하기
INSERT INTO EMPLOYEE VALUES(500, '김보라', '991012-1234566', NULL, NULL, 'D1', 'J7', 2800000, NULL, NULL, SYSDATE, NULL, DEFAULT);
INSERT INTO EMPLOYEE VALUES(501, '홍미나', '961231-1234567', NULL, NULL, 'D1', 'J6', 2600000, NULL, NULL, SYSDATE, NULL, DEFAULT);

--------------------------------------------------------------------------------

-- 상품 입고 및 출고 관련 예시
--> 필요한 테이블 및 시퀀스 생성

-- 1. 상품에 대한 정보를 담을 테이블 생성 (TB_PRODUCT) - 상품테이블
CREATE TABLE TB_PRODUCT
(
    P_NO VARCHAR2(20) PRIMARY KEY,
    P_NAME VARCHAR2(50) NOT NULL,
    BRAND VARCHAR2(20) NOT NULL,
    P_PRICE NUMBER,
    STOCK NUMBER DEFAULT 0 NOT NULL
);

DROP TABLE TB_PRODUCT;


-- 시퀀스 생성
CREATE SEQUENCE SEQ_PRO
NOCACHE;

DROP SEQUENCE SEQ_PRO;


-- 샘플 데이터 추가
INSERT INTO TB_PRODUCT VALUES ('PRO_' || LPAD(SEQ_PRO.NEXTVAL,3, '0'), '마우스', '엘쥐', 19900, 10);
INSERT INTO TB_PRODUCT VALUES ('PRO_' || LPAD(SEQ_PRO.NEXTVAL,3, '0'), '키보드', '삼송', 24800, 3);
INSERT INTO TB_PRODUCT VALUES ('PRO_' || LPAD(SEQ_PRO.NEXTVAL,3, '0'), '아이패드', '사과', 700000, 8);

DELETE FROM TB_PRODUCT;

COMMIT;

-- 2. 상품 입출고 상세 이력을 보관하는 테이블 생성 (TB_PRODETAIL)
--    어떤 상품이 어떤 날짜에 몇 개가 입고 또는 출고가 되었는지에 대한 데이터를 기록하는 테이블 (이력 테이블)
CREATE TABLE TB_PRODETAIL
(
    DETAIL_NO NUMBER PRIMARY KEY,
    P_NO VARCHAR2(20) REFERENCES TB_PRODUCT(P_NO),
    PDATE DATE DEFAULT SYSDATE NOT NULL,
    AMOUNT NUMBER NOT NULL,
    STATUS CHAR(6) CHECK(STATUS IN ('입고', '출고'))
);

DROP TABLE TB_PRODETAIL;

-- 이력번호로 매번 새로운 번호를 발생시켜서 들어갈 수 있게 도와주는 시퀀스 생성 (SEQ_DNO)
CREATE SEQUENCE SEQ_DNO
NOCACHE;

DROP SEQUENCE SEQ_DNO;


--------------------------- 트리거 정의 안했을 경우 ---------------------------------

-- 'PRO_001' 상품이 오늘날짜로 10개 입고
INSERT INTO TB_PRODETAIL
    VALUES(SEQ_DNO.NEXTVAL, 'PRO_004', SYSDATE, 10, '입고');

-- 'PRO_002' 상품이 오늘날짜로 128개 입고 
INSERT INTO TB_PRODETAIL
    VALUES(SEQ_DNO.NEXTVAL, 'PRO_005', DEFAULT, 128, '입고');
    
-- 'PRO_003' 상품이 오늘 날짜로 5개 출고
INSERT INTO TB_PRODETAIL
    VALUES(SEQ_DNO.NEXTVAL, 'PRO_006', DEFAULT, 5, '출고');
    
-- TB_PRODUCT에 입고 및 출고된 결과 넣기

-- 'PRO_004' 상품이 오늘날짜로 10개 입고된 결과 입력
UPDATE TB_PRODUCT 
    SET STOCK = STOCK + 10
    WHERE P_NO = 'PRO_004';

-- 'PRO_005' 상품이 오늘날짜로 128개 입고된 결과 입력
UPDATE TB_PRODUCT
    SET STOCK = STOCK + 128
    WHERE P_NO = 'PRO_005';

-- 'PRO_006' 상품이 오늘 날짜로 5개 출고된 결과 입력
UPDATE TB_PRODUCT
    SET STOCK = STOCK - 5
    WHERE P_NO = 'PRO_006';
    
-->>> 트리거를 실행하기 전에는 하나하나 입력을 통해 수정해야함!!!


---------------------------- 트리거 정의 했을 경우 ---------------------------------

-- TB_PRODETAIL 테이블에 INSERT 이벤트 발생시
-- TB_PRODUCT에 매번 자동으로 재고수량 UPDATE 되게끔 트리거 실행

/*
    - 상품이 입고된 경우 => 해당 상품 찾아서 재고수량을 증가시키는 UPDATE 실행
        
        UPDATE TB_PRODUCT
            SET STOCK = STOCK + 입고된수량 (INSERT된 자료의 AMOUNT값)
            WHERE P_NO = 입고된상품코드 (INSERT된 자료의 P_NO값);
            
    - 상품이 출고된 경우 => 해당 상품 찾아서 재고수량을 감소시키는 UPDATE 실행
    
        UPDATE TB_PRODUCT
            SET STOCK = STOCK - 출고된수량 (INSERT된 자료의 AMOUNT값)
            WHERE P_CO = 출고된상품코드 (INSERT된 자료의 P_NO값);    
*/

-- TB_PRODETAIL에 INSERT될 때마다 TB_PRODUCT의 재고수량이 증감되는 트리거 실행
CREATE OR REPLACE TRIGGER TRG_02
AFTER INSERT ON TB_PRODETAIL
FOR EACH ROW
BEGIN
    
    -- 상품이 입고되는 경우
    IF (:NEW.STATUS = '입고')
        THEN 
            UPDATE TB_PRODUCT
                SET STOCK = STOCK + :NEW.AMOUNT
                WHERE P_NO = :NEW.P_NO;
    END IF;
    
    -- 상품이 출고되는 경우
    IF (:NEW.STATUS = '출고')
       THEN
          UPDATE TB_PRODUCT
            SET STOCK = STOCK - :NEW.AMOUNT
            WHERE P_NO = :NEW.P_NO;
    END IF;
    
END;
/

-- 'PRO_001' 상품이 오늘날짜로 7개 입고
INSERT INTO TB_PRODETAIL VALUES (SEQ_DNO.NEXTVAL, 'PRO_001', SYSDATE, 7, '입고');

-- 'PRO_003' 상품이 오늘날짜로 88개 출고
INSERT INTO TB_PRODETAIL VALUES (SEQ_DNO.NEXTVAL, 'PRO_003', SYSDATE, 88, '출고');

-- 'PRO_003' 상품이 오늘날짜로 101개 입고
INSERT INTO TB_PRODETAIL VALUES(SEQ_DNO.NEXTVAL, 'PRO_003', SYSDATE, 101, '입고');

-- 'PRO_002' 상품이 오늘날짜로 17개 입고
INSERT INTO TB_PRODETAIL VALUES (SEQ_DNO.NEXTVAL, 'PRO_002', SYSDATE, 17, '입고');

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- 1. 상품 품목을 넣을 테이블 생성 (상품 테이블)
CREATE TABLE 상품
(
    품번 NUMBER PRIMARY KEY,
    상품 VARCHAR2(20) NOT NULL,
    가격 NUMBER NOT NULL
);

ALTER TABLE 상품 MODIFY 품번 VARCHAR2(20);

-- 상품 품번 시퀀스 생성
CREATE SEQUENCE SEQ_상품
NOCACHE;


-- 상품 테이블에 상품 추가하기
INSERT INTO 상품 VALUES ('상품_' || LPAD(SEQ_상품.NEXTVAL, 3, '0'), '새우', 1500);
INSERT INTO 상품 VALUES ('상품_' || LPAD(SEQ_상품.NEXTVAL, 3, '0'), '감사', 1200);
INSERT INTO 상품 VALUES ('상품_' || LPAD(SEQ_상품.NEXTVAL, 3, '0'), '토마토', 2100);
INSERT INTO 상품 VALUES ('상품_' || LPAD(SEQ_상품.NEXTVAL, 3, '0'), '고구마', 5000);
INSERT INTO 상품 VALUES ('상품_' || LPAD(SEQ_상품.NEXTVAL, 3, '0'), '양배추', 1800);
INSERT INTO 상품 VALUES ('상품_' || LPAD(SEQ_상품.NEXTVAL, 3, '0'), '호박', 3900);

-- 2. 입고 테이블 생성 (입고 테이블)
CREATE TABLE 입고
(
    품번 VARCHAR2(20) REFERENCES 상품(품번),
    수량 NUMBER,
    금액 NUMBER
);

INSERT INTO 입고 VALUES('상품_001',2,1500);

-- 3. 출고 테이블 만들기
CREATE TABLE 출고
(
    품번 VARCHAR2(20) REFERENCES 상품(품번),
    수량 NUMBER,
    금액 NUMBER
);

-- 4. 재고 테이블 만들기
CREATE TABLE 재고
(
    품번 VARCHAR2(20) REFERENCES 상품(품번),
    수량 NUMBER,
    금액 NUMBER
);

INSERT INTO 재고 VALUES('상품_001',2,3000);
DELETE FROM 재고;


-- 5. 입고 트리거 시작
-- 있던 상품이면 수량과 금액만 바꾸고 (UPDATE), 없는 상품이면 전부 INSERT시키기

CREATE OR REPLACE TRIGGER TRG_입고
AFTER INSERT ON 입고
FOR EACH ROW
DECLARE 
    TRG_CNT NUMBER; -- 재고의 수량을 파악하는 변수
BEGIN
    SELECT COUNT(*) -- 입고 테이블에 재고가 있으면 COUNT >= 1, 없으면 COUNT = 0
    INTO TRG_CNT
    FROM 재고
    WHERE 품번 = :NEW.품번;
    -- :NEW.품번 : 입고에서 INSERT되어 들어온 값이 NEW임
    -- 품번 : 재고 테이블에 존재하던 품번
    
    IF (TRG_CNT = 0) -- 재고가 없는 상품이 들어온 경우
        THEN
            INSERT INTO 재고 VALUES (:NEW.품번, :NEW.수량, :NEW.금액*:NEW.수량);
        ELSE -- 재고가 있는 상품이 들어온 경우
            UPDATE 재고
                SET 수량 = 수량 + :NEW.수량, -- 재고에 들어간 총 입고된 수량 구하기
                    금액 = 금액 + (:NEW.금액 * :NEW.수량) -- 재고에 들어간 입고된 총 금액 구하기
                WHERE 품번 = :NEW.품번;
        END IF;
        
END;
/

-- 입고 테이블에 상품 넣기

-- 재고가 있는 상품 추가
INSERT INTO 입고 VALUES ('상품_001', 4, 1500);
-- 재고가 없는 상품 추가
INSERT INTO 입고 VALUES ('상품_002', 3, 1200);
INSERT INTO 입고 VALUES ('상품_003', 10, 2100);
INSERT INTO 입고 VALUES ('상품_005', 8, 1800);

COMMIT;

-- 6. 출고 트리거 시작
-- 출고되면 재고에서 빼고, 총 수량이 0이 되면 DELETE
CREATE OR REPLACE TRIGGER TRG_출고
AFTER INSERT ON 출고
FOR EACH ROW
DECLARE 
    TRG_CNT NUMBER;
BEGIN
    
        /*
        재고 100 5 7500
        출고 INSERT INTO 출고 VALUES(100,3,1500)
        재고 100 2 3000
        출고 INSERT INTO 출고 VALUES(100,2,1500)
        재고 100 0 0 => DELETE
        */
        
    SELECT 수량 - :NEW.수량 -- (재고의 기존 수량 - 출고 테이블에 추가된 수량)
    INTO TRG_CNT
    FROM 재고
    WHERE 품번 = :NEW.품번;
    -- 수량 = 재고 테이블에 있는 수량
    -- 품번 = 재고 테이블에 있는 품번
    -- :NEW.수량 = 출고 데이블에 INSERT된 수량
    -- :NEW.품번 = 출고 테이블에 INSERT된 품번
    
    IF (TRG_CNT = 0) -- 출고하는 품목의 재고가 없는 경우
        THEN 
            DELETE FROM 재고
            WHERE 품번 = :NEW.품번;
        ELSE -- 출고하는 품목의 재고가 있는 경우
           UPDATE 재고
                SET 수량 = 수량 - :NEW.수량,
                    금액 = 금액 - (:NEW.수량 * :NEW.금액)
                WHERE 품번 = :NEW.품번;
        END IF;

END;
/

-- 출고 테이블에 상품 넣기

-- 상품의 재고가 남아있는 경우
INSERT INTO 출고 VALUES ('상품_001', 3, 1500);
INSERT INTO 출고 VALUES ('상품_003', 5, 2100);
-- 상품의 재고가 남아있지 않은 경우
INSERT INTO 출고 VALUES ('상품_005', 8, 1800);

COMMIT;
    
