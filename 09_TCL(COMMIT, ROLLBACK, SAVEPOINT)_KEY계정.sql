
/*
    * TCL (TRANSCATION CONTROL LANGUAGE 트랜잭션 언어)
    
    변경사항들을 실제 DB에 반영(COMMIT)하거나 변경사항들을 취소(ROLLBACK)시키는 구문
    임시저장점을 정의(SAVEPOINT)하는 구문
    
    * 트랜잭션 (TRANSACTION)
    - 데이터베이스의 논리적 연산단위
    - 데이터의 변경사항(DML)들을 하나의 트랜잭션에 묶어서 처리
      DML문을 한 번 수행할 때 트랜잭션 존재하지 않으면 하나의 트랜잭션을 만들어서 묶음
                          트랜잭션이 존재하면 해당 트랜잭션에 같이 묶어서 처리
    
    COMMIT (트랜잭션 종료 처리 후 확정)    => 실제 DB에 반영됨
    ROLLBACK (트랜잭션 취소)
    SAVEPOINT (임시저장점 정의)
    
     - COMMIT; 진행 : 한 트랜잭션에 담겨있는 변경사항들을 실제 DB에 반영시키겠다는 의미 (후에 트랜잭션은 사라짐) => COMMIT 실행 전은 실제 DB에 반영된게 아님
     - ROLLBACK; 진행 : 한 트랜잭션에 담겨있는 변경사항들을 삭제(취소)한 후 마지막 COMMIT시점으로 돌아감
     - SAVEPOINT 포인트명; 진행 : 현재 이 시점에 해당 포인트명으로 임시저장점을 정의해두는 거
                                ROLLBACK 진행시 전체 변경사항을 삭제하는게 아니라 일부만 삭제 가능 => SAVEPOINT 시점으로 돌아감
*/

-- 222번 사원 지우기
DELETE FROM EMP_01
    WHERE EMP_ID = 222;

-- 송종기 이름을 송나식으로 변경
UPDATE EMP_01
    SET EMP_NAME = '송나식'
    WHERE EMP_NAME = '송종기';
    
-- 900, 홍길동, 마케팅부 추가
INSERT INTO EMP_01 VALUES(900, '홍길동', '마케팅부');

ROLLBACK; --> 실행했던 변경 사항들을 취소처리

-- 901, 잔돈근, 국내영업부
-- 902, 베르무트, 해외영업3부 추가
INSERT INTO EMP_01  VALUES (901, '잔돈근', '국내영업부');
INSERT INTO EMP_01  VALUES (902, '베르무트', '해외영업3부');

-- 208번 사원 삭제
DELETE FROM EMP_01
    WHERE EMP_ID = 208;
    
COMMIT; --> 실행했던 변경 사항들을 확정처리하여 실제 DB에 반영
-- ROLLBACK하면 COMMIT을 실행하여 변경된 상태로 돌아감

-- 217, 216, 214 사원 지움
DELETE FROM EMP_01 WHERE EMP_ID IN (217,216,214);

-- 송은희 => 송나라로 변경
UPDATE EMP_01
    SET EMP_NAME = '송나라'
    WHERE EMP_NAME = '송은희';

SAVEPOINT SP; -- 'SP'라는 이름으로 SAVEPOINT 생성

-- 901, 902번 사원 삭제
DELETE FROM EMP_01 WHERE EMP_ID IN (901, 902);

ROLLBACK TO SP;
-- SAVEPOINT 이후 상태로 돌아감
-- 즉, SAVEPOINT된 이름변경 및 200번대 사원들은 그래도 변경사항이 적용되고 901,902번 사원들의 변경사항은 취소됨

COMMIT;

-- 204번 사원 지우기
DELETE FROM EMP_01 WHERE EMP_ID = 204;

-- 변경사항 확정이나 취소 전에 테이블 생성 => 실제 데이터를 DB에 반영하는 COMMIT이 자동으로 실행됨
CREATE TABLE TCL_TEST(
    TCODE NUMBER
);

ROLLBACK; -- 204번 사원의 정보가 COMMIT을 하지 않았는데 자동으로 COMMIT되어서 ROLLBACK이 불가능하게됨
--> DDL문(CREAT, ALTER, DROP) 실행하는 순간 바로 기존에 트랙잭션에 있던 변경사항들을 무조건 COMMIT해버림
--> 즉, DDL문을 수행 전 변경사항이 있었다면 정확히 픽스(COMMIT / ROLLBACk) 하고 해라!!





