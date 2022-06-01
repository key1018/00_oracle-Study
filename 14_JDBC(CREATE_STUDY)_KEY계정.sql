-- 영화 정보를 담는 테이블 생성
CREATE TABLE TB_영화
(
    MOVIE_NO VARCHAR2(20) PRIMARY KEY,
    MOVIE_TITLE VARCHAR2(300) NOT NULL,
    MOVIE_AGE VARCHAR2(30) NOT NULL,
    OPEN_DATE DATE DEFAULT SYSDATE NOT NULL,
    RATE NUMBER DEFAULT 0,
    AUDIENCE NUMBER DEFAULT 0
);

-- 영화 정보에 주석 고멘트
COMMENT ON COLUMN TB_영화.MOVIE_NO IS '영화번호';
COMMENT ON COLUMN TB_영화.MOVIE_TITLE IS '영화명';
COMMENT ON COLUMN TB_영화.MOVIE_AGE IS '등급';
COMMENT ON COLUMN TB_영화.OPEN_DATE IS '개봉일';
COMMENT ON COLUMN TB_영화.RATE IS '평점';
COMMENT ON COLUMN TB_영화.AUDIENCE IS '관객수';

DROP TABLE TB_영화;

-- 영화 예매 현황 테이블 생성
CREATE TABLE TB_예매
(
    MOVIE_NO VARCHAR2(20) REFERENCES TB_영화(MOVIE_NO) ON DELETE CASCADE,
    MOVIE_TITLE VARCHAR2(300),
    AUDIENCE NUMBER DEFAULT 1 NOT NULL,
    CONFIRMED CHAR(6) CHECK(CONFIRMED IN ('확정', '취소')) 
);

DROP TABLE TB_예매;

COMMENT ON COLUMN TB_예매.MOVIE_NO IS '영화번호';
COMMENT ON COLUMN TB_예매.MOVIE_TITLE IS '영화명';
COMMENT ON COLUMN TB_예매.AUDIENCE IS '예약인원';
COMMENT ON COLUMN TB_예매.CONFIRMED IS '예매상태';

-- 영화 평점 테이블 생성
CREATE TABLE TB_리뷰
(
    MOVIE_NO VARCHAR2(20) REFERENCES TB_영화(MOVIE_NO) ON DELETE CASCADE,
    MOVIE_TITLE VARCHAR2(300),
    CONTENT VARCHAR2(600),
    RATE NUMBER CHECK(RATE BETWEEN 1 AND 5)
);
COMMENT ON COLUMN TB_리뷰.MOVIE_NO IS '영화번호';
COMMENT ON COLUMN TB_리뷰.MOVIE_TITLE IS '영화명';
COMMENT ON COLUMN TB_리뷰.CONTENT IS '리뷰내용';
COMMENT ON COLUMN TB_리뷰.RATE IS '평점';

-- TB_리뷰와 TB_영화의 외래키 연결 끊기
ALTER TABLE TB_영화 ENABLE CONSTRAINT SYS_C007378;
ALTER TABLE TB_리뷰 DISABLE CONSTRAINT SYS_C007383 CASCADE;
ALTER TABLE TB_리뷰 ENABLE CONSTRAINT SYS_C007383;

DROP TABLE TB_리뷰;
    
-- 영화 번호 시퀀스 생성
CREATE SEQUENCE SEQ_영화
NOCACHE;

DROP SEQUENCE SEQ_영화;

-- 영화를 예매/취소할때마다 TB_영화의 관객수가 증감되는 TRIGGER 실행
CREATE OR REPLACE TRIGGER TRG_예매
AFTER INSERT ON TB_예매
FOR EACH ROW
BEGIN
    
    -- 예매가 '확정'되는 경우
    IF(:NEW.CONFIRMED = '확정')
        THEN UPDATE TB_영화
                SET AUDIENCE = AUDIENCE + :NEW.AUDIENCE
                    WHERE MOVIE_TITLE = :NEW.MOVIE_TITLE;
    END IF;


    IF(:NEW.CONFIRMED = '취소')
        THEN UPDATE TB_영화
                SET AUDIENCE = AUDIENCE - :NEW.AUDIENCE
                        WHERE MOVIE_TITLE = :NEW.MOVIE_TITLE;
    END IF;
    
END;
/

-- 영화 평점이 기록될때마다 평점의 평균을 구하는 TRIGGER 생성
CREATE OR REPLACE TRIGGER TRG_리뷰
AFTER INSERT ON TB_리뷰
FOR EACH ROW
BEGIN   
        IF (:NEW.RATE BETWEEN 1 AND 5)
            THEN UPDATE TB_영화
                    SET RATE = ROUND((RATE + :NEW.RATE * AUDIENCE) / AUDIENCE)
                        WHERE MOVIE_TITLE = :NEW.MOVIE_TITLE;
        END IF;
END;
/
