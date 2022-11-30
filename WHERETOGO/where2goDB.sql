-- Where to go : App project DataBase 
-- team members : Sujin Kang, Gahyun Son, Sihyun Jeon, 
-- Host:     Database: where2goDB
-- Made by Sujin Kang
-- ------------------------------------------------------


DROP database IF EXISTS `where2goDB`;
CREATE database where2goDB;
use where2goDB;

CREATE TABLE AreaCodeTBL
(
    `aCode`  integer       NOT NULL, 
    `aName`  VARCHAR(7)    NOT NULL, 
     PRIMARY KEY (aCode)
);


ALTER TABLE AreaCodeTBL COMMENT '광역시/도 단위 지역 코드 테이블. 지역코드 저장 테이블';


CREATE TABLE AreaCodeDetailTBL
(
    `aCode`   integer        NOT NULL, 
    `aDCode`  integer        NOT NULL, 
    `aDName`  VARCHAR(10)    NOT NULL, 
     PRIMARY KEY (aCode, aDCode)
);

ALTER TABLE AreaCodeDetailTBL COMMENT '시/군/구 단위 지역코드 테이블. 세부 지역코드 저장 테이블';

ALTER TABLE AreaCodeDetailTBL
    ADD CONSTRAINT FK_AreaCodeDetailTBL_aCode_AreaCodeTBL_aCode FOREIGN KEY (aCode)
        REFERENCES AreaCodeTBL (aCode) ON DELETE RESTRICT ON UPDATE RESTRICT;

CREATE TABLE CategoryTBL(
   cCode VARCHAR(20) NOT NULL PRIMARY KEY
  ,cName VARCHAR(20) NOT NULL
);


CREATE TABLE UserTBL
(
    `userID`      BIGINT          NOT NULL    AUTO_INCREMENT, 
    `email`       varchar(50)     NOT NULL, 
    `nickName`    varchar(50)     NOT NULL, 
    `pw`    varchar(200)    NOT NULL, 
    `sex`         varchar(1)      NULL        DEFAULT NULL, 
    `age`         int(1)          NULL        DEFAULT NULL, 
    `pic`    text 	NULL,
    `last_login`  datetime        NOT NULL    DEFAULT '2001-03-26', 
    `deviceToken` text	NULL DEFAULT NULL,
     PRIMARY KEY (userID)
);

ALTER TABLE UserTBL COMMENT '회원 테이블';


CREATE TABLE EventTBL
(
    `eventID`         BIGINT           NOT NULL, 
    `eventName`       TEXT       		NOT NULL, 
	`startDate`  	  DATE              NOT NULL, 
    `endDate`    	  DATE              NOT NULL, 
    
    `addr1`           TEXT       NULL  DEFAULT NULL,
    `addr2`           TEXT        NULL DEFAULT NULL,
    `kind`            VARCHAR(20)         NOT NULL,
    `pic`      TEXT       NULL ,
    `mapx`            NUMERIC(14,10)    NULL	DEFAULT NULL, 
    `mapy`            NUMERIC(13,10)    NULL	DEFAULT NULL, 
    `mlevel`          integer           NULL	DEFAULT NULL, 
    `areacode`        integer           NOT NULL, 
    `sigungucode`     integer           NOT NULL, 
    `tel`             TEXT      		NULL	DEFAULT NULL, 
	`homepage`        TEXT  			NULL 	DEFAULT NULL, 
	`overview`        TEXT 				NULL	DEFAULT NULL,
    
	`eventplace`      TEXT				NULL	DEFAULT NULL,
  `bookingplace`      TEXT				NULL	DEFAULT NULL,
  `subevent`          TEXT				NULL	DEFAULT NULL,
  `price`   TEXT				NULL	DEFAULT NULL,
  `agelimit` TEXT				NULL	DEFAULT NULL,
  `eventtime` TEXT 	NULL	DEFAULT NULL,
  `createdAt` DATETIME NULL DEFAULT NOW(),
  `updatedAt` DATETIME NULL DEFAULT NOW(),
     PRIMARY KEY (eventID)
);

 ALTER TABLE EventTBL
    ADD CONSTRAINT FK_EventTBL_kind_CategoryTBL_cCode FOREIGN KEY (kind)
        REFERENCES CategoryTBL (cCode) ON DELETE RESTRICT ON UPDATE CASCADE;
        
ALTER TABLE EventTBL
    ADD CONSTRAINT FK_EventTBL_areacode_AreaCodeDetailTBL_aCode FOREIGN KEY (areacode, sigungucode)
        REFERENCES AreaCodeDetailTBL (aCode, aDCode) ON DELETE RESTRICT ON UPDATE CASCADE;
        

CREATE TABLE UserVisitedTBL
(
    `userID`      BIGINT        NOT NULL, 
    `eventID`     BIGINT        NOT NULL, 
    `assessment`  varchar(1)    NOT NULL, 
     PRIMARY KEY (userID, eventID)
);

ALTER TABLE UserVisitedTBL COMMENT '사용자가 방문한 이벤트 테이블';

ALTER TABLE UserVisitedTBL
    ADD CONSTRAINT FK_UserVisitedTBL_eventID_EventTBL_eventID FOREIGN KEY (eventID)
        REFERENCES EventTBL (eventID) ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE UserVisitedTBL
    ADD CONSTRAINT FK_UserVisitedTBL_userID_UserTBL_userID FOREIGN KEY (userID)
        REFERENCES UserTBL (userID) ON DELETE RESTRICT ON UPDATE RESTRICT;
        
        


CREATE TABLE MainEventTBL
(
    `mainEventID`  BIGINT         NOT NULL    AUTO_INCREMENT, 
    `ment`         varchar(80)    NOT NULL, 
    `prePic`       text           NOT NULL, 
    `eventID`     BIGINT         NULL, 
     PRIMARY KEY (mainEventID)
);

ALTER TABLE MainEventTBL COMMENT '메인 이벤트 테이블 (홈 상단)';

ALTER TABLE MainEventTBL
    ADD CONSTRAINT FK_MainEventTBL_eventID_EventTBL_eventID FOREIGN KEY (eventID)
        REFERENCES EventTBL (eventID) ON DELETE CASCADE ON UPDATE RESTRICT;




CREATE TABLE SearchTBL
(
    `searchID`  BIGINT         NOT NULL    AUTO_INCREMENT, 
    `word`      VARCHAR(45)    NOT NULL, 
     PRIMARY KEY (searchID)
);

ALTER TABLE SearchTBL COMMENT '검색어 테이블';




CREATE TABLE KeywordTBL
(
    `userID`     BIGINT         NOT NULL, 
    `content`    varchar(10)    NOT NULL, 
     PRIMARY KEY (userID, content)
);

ALTER TABLE KeywordTBL COMMENT '사용자가 등록한 키워드 테이블';

ALTER TABLE KeywordTBL
    ADD CONSTRAINT FK_KeywordTBL_userID_UserTBL_userID FOREIGN KEY (userID)
        REFERENCES UserTBL (userID) ON DELETE RESTRICT ON UPDATE RESTRICT;



CREATE TABLE UserSavedTBL
(
    `userID`   BIGINT    NOT NULL, 
    `eventID`  BIGINT    NOT NULL, 
     PRIMARY KEY (userID, eventID)
);

ALTER TABLE UserSavedTBL COMMENT '사용자가 담아둔 이벤트 테이블';

ALTER TABLE UserSavedTBL
    ADD CONSTRAINT FK_UserSavedTBL_eventID_EventTBL_eventID FOREIGN KEY (eventID)
        REFERENCES EventTBL (eventID) ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE UserSavedTBL
    ADD CONSTRAINT FK_UserSavedTBL_userID_UserTBL_userID FOREIGN KEY (userID)
        REFERENCES UserTBL (userID) ON DELETE RESTRICT ON UPDATE RESTRICT;


-- 지역 코드 입력 ---------
INSERT INTO AreaCodeTBL(aCode,aName) VALUES (1,'서울');
INSERT INTO AreaCodeTBL(aCode,aName) VALUES (2,'인천');
INSERT INTO AreaCodeTBL(aCode,aName) VALUES (3,'대전');
INSERT INTO AreaCodeTBL(aCode,aName) VALUES (4,'대구');
INSERT INTO AreaCodeTBL(aCode,aName) VALUES (5,'광주');
INSERT INTO AreaCodeTBL(aCode,aName) VALUES (6,'부산');
INSERT INTO AreaCodeTBL(aCode,aName) VALUES (7,'울산');
INSERT INTO AreaCodeTBL(aCode,aName) VALUES (8,'세종특별자치시');
INSERT INTO AreaCodeTBL(aCode,aName) VALUES (31,'경기도');
INSERT INTO AreaCodeTBL(aCode,aName) VALUES (32,'강원도');
INSERT INTO AreaCodeTBL(aCode,aName) VALUES (33,'충청북도');
INSERT INTO AreaCodeTBL(aCode,aName) VALUES (34,'충청남도');
INSERT INTO AreaCodeTBL(aCode,aName) VALUES (35,'경상북도');
INSERT INTO AreaCodeTBL(aCode,aName) VALUES (36,'경상남도');
INSERT INTO AreaCodeTBL(aCode,aName) VALUES (37,'전라북도');
INSERT INTO AreaCodeTBL(aCode,aName) VALUES (38,'전라남도');
INSERT INTO AreaCodeTBL(aCode,aName) VALUES (39,'제주도');
INSERT INTO AreaCodeTBL(aCode,aName) VALUES (100,'기타지역');


-- 지역 상세 코드 입력 ------------
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (1,1,'강남구'); /*서울*/
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (1,2,'강동구');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (1,3,'강북구');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (1,4,'강서구');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (1,5,'관악구');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (1,6,'광진구');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (1,7,'구로구');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (1,8,'금천구');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (1,9,'노원구');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (1,10,'도봉구');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (1,11,'동대문구');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (1,12,'동작구');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (1,13,'마포구');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (1,14,'서대문구');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (1,15,'서초구');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (1,16,'성동구');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (1,17,'성북구');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (1,18,'송파구');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (1,19,'양천구');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (1,20,'영등포구');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (1,21,'용산구');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (1,22,'은평구');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (1,23,'종로구');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (1,24,'중구');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (1,25,'중랑구');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (1,100,'기타지역');

INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (2,1,'강화군');/*인천*/
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (2,2,'계양구');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (2,3,'미추홀구');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (2,4,'남동구');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (2,5,'동구');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (2,6,'부평구');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (2,7,'서구');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (2,8,'연수구');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (2,9,'옹진군');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (2,10,'중구');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (2,100,'기타지역');

INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (3,1,'대덕구'); /*대전*/
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (3,2,'동구');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (3,3,'서구');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (3,4,'유성구');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (3,5,'중구');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (3,100,'기타지역');

INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (4,1,'남구');/*대구*/
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (4,2,'달서구');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (4,3,'달성군');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (4,4,'동구');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (4,5,'북구');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (4,6,'서구');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (4,7,'수성구');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (4,8,'중구');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (4,100,'기타지역');

INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (5,1,'광산구');/*광주*/
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (5,2,'남구');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (5,3,'동구');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (5,4,'북구');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (5,5,'서구');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (5,100,'기타지역');

INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (6,1,'강서구');/*부산*/
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (6,2,'금정구');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (6,3,'기장군');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (6,4,'남구');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (6,5,'동구');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (6,6,'동래구');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (6,7,'부산진구');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (6,8,'북구');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (6,9,'사상구');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (6,10,'사하구');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (6,11,'서구');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (6,12,'수영구');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (6,13,'연제구');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (6,14,'영도구');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (6,15,'중구');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (6,16,'해운대구');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (6,100,'기타지역');

INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (7,1,'중구');/*울산*/
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (7,2,'남구');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (7,3,'동구');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (7,4,'북구');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (7,5,'을주군');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (7,100,'기타지역');

INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (8,1,'세종특별자치시');/*세종특별자치시*/
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (8,100,'기타지역');

INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (31,1, '가평군');/*경기도*/
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (31,2,'고양시');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (31,3,'과천시');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (31,4,'광명시');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (31,5,'광주시');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (31,6,'구리시');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (31,7,'군포시');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (31,8,'김포시');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (31,9,'남양주시');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (31,10,'동두천시');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (31,11,'부천시');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (31,12,'성남시');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (31,13,'수원시');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (31,14,'시흥시');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (31,15,'안산시');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (31,16,'안성시');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (31,17,'안양시');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (31,18,'양주시');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (31,19,'양평군');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (31,20,'여주시');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (31,21,'연천군');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (31,22,'오산시');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (31,23,'용인시');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (31,24,'의왕시');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (31,25,'의정부시');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (31,26,'이천시');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (31,27,'파주시');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (31,28,'평택시');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (31,29,'포천시');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (31,30,'하남시');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (31,31,'화성시');
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (31,100,'기타지역');

INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 32, 1 , '강릉시' ); /*강원도*/
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 32, 2 , '고성군' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 32, 3 , '동해시' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 32, 4 , '삼척시' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 32, 5 , '속초시' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 32, 6 , '양구군' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 32, 7 , '양양군' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 32, 8 , '영월군' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 32, 9 , '원주시' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 32, 10 , '인제군' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 32, 11 , '정선군' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 32, 12 , '철원군' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 32, 13 , '춘천시' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 32, 14 , '태백시' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 32, 15 , '평창군' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 32, 16 , '홍천군' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 32, 17 , '화천군' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 32, 18 , '횡성군' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (32,100,'기타지역');

INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 33, 1 , '괴산군' ); /*충청북도*/
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 33, 2 , '단양군' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 33, 3 , '보은군' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 33, 4 , '영동군' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 33, 5 , '옥천군' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 33, 6 , '음성군' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 33, 7 , '제천시' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 33, 8 , '진천군' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 33, 9 , '청원군' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 33, 10 , '청주시' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 33, 11 , '충주시' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 33, 12 , '증평군' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (33,100,'기타지역');

INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 34, 1 , '공주시' ); /*충청남도*/
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 34, 2 , '금산군' ); 
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 34, 3 , '논산시' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 34, 4 , '당진시' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 34, 5 , '보령시' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 34, 6 , '부여군' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 34, 7 , '서산시' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 34, 8 , '서천군' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 34, 9 , '아산시' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 34, 11 , '예산군' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 34, 12 , '천안시' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 34, 13 , '청양군' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 34, 14 , '태안군' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 34, 15 , '홍성군' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 34, 16 , '계룡시' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (34,100,'기타지역');

INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 35, 1 , '경산시' ); /*경상북도*/
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 35, 2 , '경주시' ); 
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 35, 3 , '고령군' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 35, 4 , '구미시' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 35, 5 , '군위군' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 35, 6 , '김천시' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 35, 7 , '문경시' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 35, 8 , '봉화군' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 35, 9 , '상주시' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 35, 10 , '성주군' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 35, 11 , '안동시' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 35, 12 , '영덕군' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 35, 13 , '영양군' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 35, 14 , '영주시' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 35, 15 , '영천시' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 35, 16 , '예천군' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 35, 17 , '울릉군' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 35, 18 , '울진군' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 35, 19 , '의성군' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 35, 20 , '청도군' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 35, 21 , '청송군' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 35, 22 , '칠곡군' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 35, 23 , '포항시' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (35,100,'기타지역');

INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 36, 1 , '거제시' ); /*경상남도*/
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 36, 2 , '거창군' ); 
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 36, 3 , '고성군' ); 
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 36, 4 , '김해시' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 36, 5 , '남해군' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 36, 6 , '마산시' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 36, 7 , '밀양시' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 36, 8 , '사천시' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 36, 9 , '산청군' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 36, 10 , '양산시' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 36, 12 , '의령군' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 36, 13 , '진주시' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 36, 14 , '진해시' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 36, 15 , '창녕군' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 36, 16 , '창원시' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 36, 17 , '통영시' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 36, 18 , '하동군' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 36, 19 , '함안군' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 36, 20 , '함양군' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 36, 21 , '합천군' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (36,100,'기타지역');

INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 37, 1 , '고창군' ); /*전라북도*/
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 37, 2 , '군산시' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 37, 3 , '김제시' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 37, 4 , '남원시' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 37, 5 , '무주군' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 37, 6 , '부안군' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 37, 7 , '순창군' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 37, 8 , '완주군' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 37, 9 , '익산시' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 37, 10 , '임실군' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 37, 11 , '장수군' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 37, 12 , '전주시' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 37, 13 , '정읍시' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 37, 14 , '진안군' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (37,100,'기타지역');

INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 38, 1 , '강진군' );  /*전라남도*/
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 38, 2 , '고흥군' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 38, 3 , '곡성군' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 38, 4 , '광양시' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 38, 5 , '구례군' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 38, 6 , '나주시' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 38, 7 , '담양군' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 38, 8 , '목포시' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 38, 9 , '무안군' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 38, 10 , '보성군' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 38, 11 , '순천시' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 38, 12 , '신안군' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 38, 13 , '여수시' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 38, 16 , '영광군' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 38, 17 , '영암군' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 38, 18 , '완도군' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 38, 19 , '장성군' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 38, 20 , '장흥군' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 38, 21 , '진도군' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 38, 22 , '함평군' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 38, 23 , '해남군' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 38, 24 , '화순군' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (38,100,'기타지역');

INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 39, 1 , '남제주군' ); /*제주도*/
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 39, 2 , '북제주군' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 39, 3 , '서귀포시' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES ( 39, 4 , '제주시' );
INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (39,100,'기타지역');

INSERT INTO AreaCodeDetailTBL(aCode,aDCode,aDName) VALUES (100,100,'기타지역');

-- 카테고리 데이터 입력 ---------------------------------------------------------------------------
INSERT INTO CategoryTBL(cCode,cName) VALUES ('A02070100','문화관광축제'); /*축제*/
INSERT INTO CategoryTBL(cCode,cName) VALUES ('A02070200','일반축제');
INSERT INTO CategoryTBL(cCode,cName) VALUES ('A02080100','전통공연');/*공연/행사*/
INSERT INTO CategoryTBL(cCode,cName) VALUES ('A02080200','연극');
INSERT INTO CategoryTBL(cCode,cName) VALUES ('A02080300','뮤지컬');
INSERT INTO CategoryTBL(cCode,cName) VALUES ('A02080400','오페라');
INSERT INTO CategoryTBL(cCode,cName) VALUES ('A02080500','전시회');
INSERT INTO CategoryTBL(cCode,cName) VALUES ('A02080600','박람회');
INSERT INTO CategoryTBL(cCode,cName) VALUES ('A02080700','컨벤션');
INSERT INTO CategoryTBL(cCode,cName) VALUES ('A02080800','무용');
INSERT INTO CategoryTBL(cCode,cName) VALUES ('A02080900','클래식음악회');
INSERT INTO CategoryTBL(cCode,cName) VALUES ('A02081000','대중콘서트');
INSERT INTO CategoryTBL(cCode,cName) VALUES ('A02081100','영화');
INSERT INTO CategoryTBL(cCode,cName) VALUES ('A02081200','스포츠경기');
INSERT INTO CategoryTBL(cCode,cName) VALUES ('A02081300','기타행사');


-- 사용자 데이터 입력 -------------------------------------
-- 10대 여성 --
INSERT INTO `UserTBL` (email, nickName, pw, sex, age, last_login) VALUES ('bear@gmail.com', '곰돌이', "$2a$10$sm454B3JeElqcatMKRVhweISBzb4Eng4Huzxkf857xhCzy2yW9MuG", 'w', 1, NOW());  /*pw : bearbear*/
INSERT INTO `UserTBL` (email, nickName, pw, sex, age, last_login) VALUES ('sugar@gmail.com', '사탕', "$2a$10$iUq5jMK2jTFI7ZdHIoOUx.a8ApXX1B/.09ul29PhLOh4CbauSGZhq", 'w', 1, NOW());  /*pw : candysugar*/
INSERT INTO `UserTBL` (email, nickName, pw, sex, age, last_login) VALUES ('doll@gmail.com', '인형좋아', "$2a$10$CTu/WGf6S2XFFUQMnDUVTuL61Cs92dsoi6rp9ptLEMNhxGDLiWq.K", 'w', 1, NOW());  /*pw : dollybabe*/
INSERT INTO `UserTBL` (email, nickName, pw, sex, age, last_login) VALUES ('mypop@gmail.com', '마이팝', "$2a$10$fhmfCyLP7ucqrV8B27QN4.SksrOr7dHHd4MJugwfytpR0P8hr6W22", 'w', 1, NOW());  /*pw : mypopmypop*/
INSERT INTO `UserTBL` (email, nickName, pw, sex, age, last_login) VALUES ('heyU@gmail.com', '너누', "$2a$10$/2Sisforynvo8spBRPXZHu8.8CEzxBLdPR9rx3VJnb0czYzn.abaG", 'w', 1, NOW());  /*pw : heyyouu*/

-- 20대 여성 -- 
INSERT INTO `UserTBL` (email, nickName, pw, sex, age, last_login) VALUES ('sujin@gmail.com', '수지니', "$2a$10$pNZAd/ie7/Ipr6Go30ane.GhiRyflwGQgIXwQR7ux91jr.yK7IxrS", 'w', 2, NOW());  /*pw : heysusu*/
INSERT INTO `UserTBL` (email, nickName, pw, sex, age, last_login) VALUES ('gahyun@gmail.com', '가가', "$2a$10$4RS0v3ayGHIbYVp1NmFS8uslgH8j4VL1ECcCq1.g0iqs.F7iTP4v6", 'w', 2, NOW());  /*pw : heygaga*/
INSERT INTO `UserTBL` (email, nickName, pw, sex, age, last_login) VALUES ('sihyun@gmail.com', '셔니', "$2a$10$743m9YcvXtU8lH2YJYObbuJPdRCGbOq3dB7GKJLuZEUXOgsW908D2", 'w', 2, NOW());  /*pw : heysisi*/
INSERT INTO `UserTBL` (email, nickName, pw, sex, age, last_login) VALUES ('sungshin@gmail.com', '성신', "$2a$10$WBYzbW2Yb9fefIx6ZqdK1.eY7.hysMAueYi8tXtus3CuEKkAV7xGG", 'w', 2, NOW());  /*pw : heysung*/
INSERT INTO `UserTBL` (email, nickName, pw, sex, age, last_login) VALUES ('sooryong@gmail.com', '수룡이', "$2a$10$IZk4SMRabjcjD0WZfSHN7OtOPB6Qy4JWiWetOOJtiiDsXP3dN6oE2", 'w', 2, NOW());  /*pw : sooryong*/

-- 30대 여성 --
INSERT INTO `UserTBL` (email, nickName, pw, sex, age, last_login) VALUES ('company@gmail.com', '회사싫어', "$2a$10$MndpzBlzUugqXuo72Gb.CedMLth30.fjkx0AS8oBL0ghYeCXZ/J2u", 'w', 3, NOW());  /*pw : company*/
INSERT INTO `UserTBL` (email, nickName, pw, sex, age, last_login) VALUES ('leavenow@gmail.com', '떠나요', "$2a$10$lzvMsIEYuf0syToGzQC7KO0tCqgpC8tA.JuIqClZEv6K2LyEFmpGm", 'w', 3, NOW());  /*pw : leavenow*/
INSERT INTO `UserTBL` (email, nickName, pw, sex, age, last_login) VALUES ('makemoney@gmail.com', '돈벌자', "$2a$10$VjE6THxyyasqSeY3mpaceeYLWdARNf7.aViyUg4ocni.Wm5yGC5oi", 'w', 3, NOW());  /*pw : makemoney*/
INSERT INTO `UserTBL` (email, nickName, pw, sex, age, last_login) VALUES ('iamapple@gmail.com', '나는사과', "$2a$10$ZQLqFgzGnVBKc1SLdU4ZGOtiB.rTKBqPxxt.YegqD0tjmFEvO0HHG", 'w', 3, NOW());  /*pw : iamapple*/
INSERT INTO `UserTBL` (email, nickName, pw, sex, age, last_login) VALUES ('whatever@gmail.com', '어쩌라고', "$2a$10$hOnQIXkKoBP5/JAosAH0Uug/potnK0FpI0BN4f3BXFDBZF/V2QDGe", 'w', 3, NOW());  /*pw : whatever*/

-- 40대~50대 여성 --
INSERT INTO `UserTBL` (email, nickName, pw, sex, age, last_login) VALUES ('momcame@gmail.com', '엄마왔다', "$2a$10$ryLBMAAgKqcceZ1becAjse7UAswndYwQrxdTPPmhURsXLRPzDatOC", 'w', 4, NOW());  /*pw : momcame*/
INSERT INTO `UserTBL` (email, nickName, pw, sex, age, last_login) VALUES ('jihunmom@gmail.com', '지훈맘', "$2a$10$HKWbSAKr/Wm9RraxPFoLB.5m4xQHf5m/U/tSHWRD4MDAXF5TuU1pG", 'w', 4, NOW());  /*pw : jihunmom*/
INSERT INTO `UserTBL` (email, nickName, pw, sex, age, last_login) VALUES ('dorokdorok@gmail.com', '도록도록', "$2a$10$EYq3uYhdO7CFqvKRY7nfuuLLuac7tlkNCjNgXrNsjOHbEUxIGPLUm", 'w', 4, NOW());  /*pw : dorokdorok*/
INSERT INTO `UserTBL` (email, nickName, pw, sex, age, last_login) VALUES ('greengreen@gmail.com', '연두새싹', "$2a$10$wbqdAMT8Jue6hxc.N0JDG.31tJ0lgtkFGAV/RVCUjj4Me6kFqt5Da", 'w', 4, NOW());  /*pw : greengreen*/
INSERT INTO `UserTBL` (email, nickName, pw, sex, age, last_login) VALUES ('gogoworld@gmail.com', '덤벼라 세상아', "$2a$10$2x4Hui3nZgW9CbK.NQs0nOqS0yNn6RWi11AFqvgOrSAZB9wJ/wyaa", 'w', 4, NOW());  /*pw : gogoworld*/

-- 60대 이상 여성
INSERT INTO `UserTBL` (email, nickName, pw, sex, age, last_login) VALUES ('hikinggo@gmail.com', '등산가자', "$2a$10$6wB7DkobECOkphcxL.k.4./JFmAeSomwB.z6/wcWF99vbFw0tBrm2", 'w', 6, NOW());  /*pw : hikinggo*/
INSERT INTO `UserTBL` (email, nickName, pw, sex, age, last_login) VALUES ('coolerthan@gmail.com', '멋쟁이', "$2a$10$9A.NEBPNX/JgvTKtqFWaC.4ZyCbfdw4q9sfaoJOirLQY/l9D4wR3i", 'w', 6, NOW());  /*pw : coolerthan*/
INSERT INTO `UserTBL` (email, nickName, pw, sex, age, last_login) VALUES ('jucyjucy@gmail.com', '주스', "$2a$10$CJJcH9OqBVEXUBdCrduq8.ZLj7TABoJRBwY9TX5U3YGf0xz1rQjN.", 'w', 6, NOW());  /*pw : jucyjucy*/
INSERT INTO `UserTBL` (email, nickName, pw, sex, age, last_login) VALUES ('unnieunnie@gmail.com', '아는언니', "$2a$10$sb.3LfOCzIPTjIeHW/Lbi.8S6qp35tSGs8qJS1Aj9GqxctVbud77S", 'w', 6, NOW());  /*pw : unnieunnie*/
INSERT INTO `UserTBL` (email, nickName, pw, sex, age, last_login) VALUES ('wavewave@gmail.com', '파도가 온다', "$2a$10$Wg1nUCjoVc6QluG4srTrtO6bdKVcsAw70SWxmCLhyas3ndBPyE4E2", 'w', 6, NOW());  /*pw : wavewave*/

-- 10대 남성
INSERT INTO `UserTBL` (email, nickName, pw, sex, age, last_login) VALUES ('gamegame@gmail.com', '겜돌이', "$2a$10$hgfTj/sdiNIOvhL8TUNqROf0xakUiJNAT/uEEdgg/zYTOHG4rK98G", 'm', 1, NOW());  /*pw : gamegame*/
INSERT INTO `UserTBL` (email, nickName, pw, sex, age, last_login) VALUES ('sohotdude@gmail.com', '아 더워', "$2a$10$zNylvHhE95Pci7eU7SH7D.RkZliqCYTc1mft.2ciYx0/aiBEEFe7K", 'm', 1, NOW());  /*pw : sohotdude*/
INSERT INTO `UserTBL` (email, nickName, pw, sex, age, last_login) VALUES ('television@gmail.com', '어쩔티비', "$2a$10$TChJQ4LadWKUZ7.0nYEBZOO9/z.MEqwUhkOP2n4fB1oe0NzQEfnvy", 'm', 1, NOW());  /*pw : television*/
INSERT INTO `UserTBL` (email, nickName, pw, sex, age, last_login) VALUES ('pccafegogo@gmail.com', '피방가자', "$2a$10$Gk2Pkb7aFUsJc.cp.FRyrO1iyFWmq7fHMvMLntPTvCkkIsNDfgCVO", 'm', 1, NOW());  /*pw : pccafegogo*/
INSERT INTO `UserTBL` (email, nickName, pw, sex, age, last_login) VALUES ('youngboy@gmail.com', '어린이', "$2a$10$GZ.qlrQhinIkoeO4EwSI9O6lQYNrJONRnRqPnjEWGyFo8rDvZmjMa", 'm', 1, NOW());  /*pw : youngboy*/

-- 20대 남성
INSERT INTO `UserTBL` (email, nickName, pw, sex, age, last_login) VALUES ('dusickk@gmail.com', '두식', "$2a$10$65ecGxcxrnKHgphfbIR.QO5l.PFpHqqSFv34nVF8eiI1LVu03r.Hm", 'm', 2, NOW());  /*pw : dusickk*/
INSERT INTO `UserTBL` (email, nickName, pw, sex, age, last_login) VALUES ('chulsoo@gmail.com', '철수', "$2a$10$89M65jt8BOiUEPzItMorX.Wi4HASaI3KOyAUbBwZ3H.vgiZfFZjbG", 'm', 2, NOW());  /*pw : chulsoo*/
INSERT INTO `UserTBL` (email, nickName, pw, sex, age, last_login) VALUES ('zzanggu@gmail.com', '짱구', "$2a$10$S1OW2ztFG.kTpG16KczwzuNAX/ia05t9ficvzacWI0M7/Tpgrj9xe", 'm', 2, NOW());  /*pw : zzanggu*/
INSERT INTO `UserTBL` (email, nickName, pw, sex, age, last_login) VALUES ('thisishyg@gmail.com', '형이야', "$2a$10$/J6Ix70uZim0E.T.tYKOdeH6yJPbl0j1bv8X9KvGeJkWfnPrgCFei", 'm', 2, NOW());  /*pw : thisishyg*/
INSERT INTO `UserTBL` (email, nickName, pw, sex, age, last_login) VALUES ('daehakyes@gmail.com', '대학어제', "$2a$10$SAFRlzPAHYmvL5EUrqvutekfn.mCYxWk3VISB96pH63Es.A/J8MXK", 'm', 2, NOW());  /*pw : daehakyes*/

-- 30대 남성
INSERT INTO `UserTBL` (email, nickName, pw, sex, age, last_login) VALUES ('dontenvy@gmail.com', '부럽지가 않아', "$2a$10$L2MHrBcbSk5Bzg3cG8Z2vuYiZasXA3eSsgB88DPSh/73LIsSCIvDW", 'm', 3, NOW());  /*pw : dontenvy*/
INSERT INTO `UserTBL` (email, nickName, pw, sex, age, last_login) VALUES ('vennomm@gmail.com', '베놈', "$2a$10$tsFJwaCoPV1aJzIMWlBgsevNkCF8/ncrZRqX4uSp2fKHTWDLWeC1K", 'm', 3, NOW());  /*pw : vennomm*/
INSERT INTO `UserTBL` (email, nickName, pw, sex, age, last_login) VALUES ('yerinsdad@gmail.com', '예린이아빠', "$2a$10$8ChbC1LE9UI.6lIKqfSlHeWLLBMxkzLFTVeLdWRDhivfgI32T27c6", 'm', 3, NOW());  /*pw : yerinsdad*/
INSERT INTO `UserTBL` (email, nickName, pw, sex, age, last_login) VALUES ('golfgolf@gmail.com', '골프치자', "$2a$10$YaW7ZrSxpG69gq1maZ/UcOeLreB3Jn89bGKYAQD3oimnr1D8Duhzi", 'm', 3, NOW());  /*pw : golfgolf*/
INSERT INTO `UserTBL` (email, nickName, pw, sex, age, last_login) VALUES ('goodboy@gmail.com', '멋진형', "$2a$10$npmhD7j8fw.S5JKa.z9SK.eUlh9mlFFWCMRLeR2zcr5x63/25XdHW", 'm', 3, NOW());  /*pw : goodboy*/

-- 40대 ~50대 남성
INSERT INTO `UserTBL` (email, nickName, pw, sex, age, last_login) VALUES ('hwahwa@gmail.com', '화려강산', "$2a$10$NHkFJNPh0J2UQpYOfWajkeWawpsKGMGOjhFNLjXxsf6qMsJ/.Q6kS", 'm', 4, NOW());  /*pw : hwahwa*/
INSERT INTO `UserTBL` (email, nickName, pw, sex, age, last_login) VALUES ('mugoong@gmail.com', '무궁화', "$2a$10$EvrvKsyQgDNreoXaIWMyweU92.RGmUYl7S2ngkIR5oZ0oao2Wk2Y.", 'm', 4, NOW());  /*pw : mugoong*/
INSERT INTO `UserTBL` (email, nickName, pw, sex, age, last_login) VALUES ('samcheon@gmail.com', '삼천리 자전거', "$2a$10$xF70yNffWATnuGUF11SY1eugdivxhdn6k/Xbv7ruDrws.b.NtOUdS", 'm', 4, NOW());  /*pw : samcheon*/
INSERT INTO `UserTBL` (email, nickName, pw, sex, age, last_login) VALUES ('daehann@gmail.com', '대한사람', "$2a$10$8/NGlgnK/6gcutoZu3MC9O3evGlhAaf9fDnkMLxB6fwAOYFF/TYFi", 'm', 4, NOW());  /*pw : daehann*/
INSERT INTO `UserTBL` (email, nickName, pw, sex, age, last_login) VALUES ('taegukki@gmail.com', '태극기', "$2a$10$OwkSaHoyc0jl/Iv0eMyj0eeR1wyAhfmWiS6V4WJEa.nIu1qVcXeUu", 'm', 4, NOW());  /*pw : taegukki*/

-- 60대 이상 남성
INSERT INTO `UserTBL` (email, nickName, pw, sex, age, last_login) VALUES ('together@gmail.com', '님과함께', "$2a$10$hXLIFtfWsl.g0jBPjMnj1OP0QBbKdMYdPOdgYWs5aIpMFQg4Je8Ge", 'm', 6, NOW());  /*pw : together*/
INSERT INTO `UserTBL` (email, nickName, pw, sex, age, last_login) VALUES ('songgain@gmail.com', '송가인이 나라를 구한다', "$2a$10$cwLta.5vhtJu3PrMqeSs0eViK/yfAfqVIuCaXxSdc0dF.LR4KsTTS", 'm', 6, NOW());  /*pw : songgain*/
INSERT INTO `UserTBL` (email, nickName, pw, sex, age, last_login) VALUES ('jaokkaa@gmail.com', '자옥아', "$2a$10$.IfIHNMf0cppjQ2UCygNC.9zhnJq4xjJvI8vokUggw04c6SERvGAq", 'm', 6, NOW());  /*pw : jaokkaa*/
INSERT INTO `UserTBL` (email, nickName, pw, sex, age, last_login) VALUES ('noreason@gmail.com', '무조건이야', "$2a$10$Csn4CC27mcH6JjqX3WzbIO2Irbq0Ow/t6ZH/3iuccaFfIKX.2JHrW", 'm', 6, NOW());  /*pw : noreason*/
INSERT INTO `UserTBL` (email, nickName, pw, sex, age, last_login) VALUES ('jinjinja@gmail.com', '진진자라', "$2a$10$SffPDhslr3.3K0n/RefgKu4U6wI2YPx0uXN3PetVrb5pRfIx1opKG", 'm', 6, NOW());  /*pw : jinjinja*/

-- 이벤트 정보 입력 ------------------------------------------------------------------------------
INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2852424 , 'DMZ RUN 평화 걷기' , 20221029 , 20221029 , '경기도 파주시 임진각로 148-40 평화누리', NULL, 'A02081200', 'http://tong.visitkorea.or.kr/cms/resource/22/2852422_image2_1.jpg', 126.7447609198, 37.8920676942, 6, 31, 27, '02-540-3462', 
'<a href="http://www.dmzrun.or.kr/" target="_blank" title="새창 : DMZ RUN 평화 걷기">http://www.dmzrun.or.kr/</a>', "DMZ 일원을 스포츠로 즐긴다.<br>DMZ 일원으로 떠나는 평화와 희망의 대질주! <br>DMZ RUN을 파주 임진각 평화누리 일원에서 개최한다.<br><br>DMZ RUN은 평화 마라톤, 평화 자전거, 평화 걷기 총 3개 행사를 아우르는 말로 DMZ 일원을 직접 뛰고, 타고, 걸으며 평화의 의미를 되새기고 생태적 가치를 몸소 느끼는 체험의 장이다.<br>특히 평화 걷기는 군 순찰로를 활용한 임진강변 생태탐방로 코스를 포함하고 있어 철책을 옆에 끼고 임진강 너머 민통선 풍광을 즐길 수 있는 트레킹이 될 것이다.", 
'평화누리 야외공연장', NULL, NULL, '유료 (20km 10,000원 / 10km 10,000원)','누구나', '4시간');

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2852421 , 'DMZ RUN 평화 자전거' , 20221015 , 20221015 , '경기도 파주시 임진각로 148-40 평화누리', NULL, 'A02081200', 'http://tong.visitkorea.or.kr/cms/resource/20/2852420_image2_1.jpg', 126.7447609198, 37.8920676942, 6, 31, 27, '02-540-3462', 
'<a href="http://www.dmzrun.or.kr/" target="_blank" title="새창 : DMZ RUN 평화 자전거">http://www.dmzrun.or.kr/</a>', "DMZ 일원을 스포츠로 즐긴다.<br>DMZ 일원으로 떠나는 평화와 희망의 대질주! <br>DMZ RUN을 파주 임진각 평화누리 일원에서 개최한다.<br><br>DMZ RUN은 평화 마라톤, 평화 자전거, 평화 걷기 총 3개 행사를 아우르는 말로 DMZ 일원을 직접 뛰고, 타고, 걸으며 평화의 의미를 되새기고 생태적 가치를 몸소 느끼는 체험의 장이다.<br>특히 평화 자전거는 민간인 통제구역은 물론 남북출입사무소(CIQ) 앞까지 총 75km를 달릴 수 있어 더욱 특별한 경험이 될 예정이다.", 
'평화누리 야외공연장', NULL, NULL, '유료 (현장참가 15,000원 / 버스참가 30,000원)',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2852365 , 'DMZ RUN 평화 마라톤' , 20221002 , 20221002 , '경기도 파주시 임진각로 148-40 평화누리', NULL, 'A02081200', 'http://tong.visitkorea.or.kr/cms/resource/64/2852364_image2_1.jpg', 126.7447609198, 37.8920676942, 6, 31, 27, '02-540-3462', 
'<a href="http://www.dmzrun.or.kr/" target="_blank" title="새창 : DMZ RUN 평화 마라톤">http://www.dmzrun.or.kr</a>', "DMZ 일원을 스포츠로 즐긴다.<br>DMZ 일원으로 떠나는 평화와 희망의 대질주! <br>DMZ RUN을 파주 임진각 평화누리 일원에서 개최한다.<br>DMZ RUN은 평화 마라톤, 평화 자전거, 평화 걷기 총 3개 행사를 아우르는 말로 DMZ 일원을 직접 뛰고, 타고, 걸으며 평화의 의미를 되새기고 생태적 가치를 몸소 느끼는 체험의 장이다.<br>특히 평화 마라톤은 민간인 통제구역은 물론 남북출입사무소(CIQ) 앞까지 달릴 수 있어 더욱 특별한 경험이 될 예정이다.", 
'평화누리 야외공연장', NULL, NULL, '유료 (21km 35,000원 / 10km 30,000원)',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2852362 , '반려동물라이프스타일페어 (반려동물건강박람회)' , 20221104 , 20221106 , '서울특별시 강남구 영동대로 513 코엑스', NULL, 'A02080600', 'http://tong.visitkorea.or.kr/cms/resource/61/2852361_image2_1.jpg', 127.0592179950, 37.5119175967, 6, 1, 1, '02-761-2864', 
'<a href="http://www.withcreature.com" target="_blank" title="새창 : 반려동물라이프스타일페어 (반려동물건강박람회)">www.withcreature.com</a>', "반려동물의 신체적 건강과 정신적 안정, 그리고 반려동물의 삶의 질을 개선하기 위한 제품과 컨텐츠를 중심으로 반려인 및 반려동물 산업계 종사자, 제조업체, 유통업체, 동물병원 등이 함께 참여하는 반려동물 헬스케어 전문 박람회이다.", 
'코엑스 3층 D홀', NULL, NULL, '현장구매 : 7,000원<br>사전등록 및 온라인구매 : 5,000원(~11/3)',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2852354 , '2022청도세계코미디아트페스티벌' , 20221014 , 20221016 , '경상북도 청도군 청려로 1846', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/53/2852353_image2_1.jpg', 128.7202383285, 35.6512053494, 6, 35, 20, '054-370-6376', 
NULL, "한국코미디타운 등 지역의 코미디 문화 인프라를 기반으로 한 차별화된 문화관광콘텐츠 육성으로 대한민국 코미디 1번지 청도의 브랜드 정체성 확립에 기여하기 위해 개최하는 청도세계코미디아트페스티벌은 2015년 제1회 개최를 시작으로 매년 10월, 청도야외공연장 일원에서 지역 대표 축제인 청도반시축제와 연계하여 진행된다. 국내외 초청 코미디 및 마술 공연, 전시‧체험 프로그램 등 각종 볼거리가 풍성하다.", 
'청도야외공연장', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2852199 , '2022 순천문화도시박람회' , 20221014 , 20221016 , '전라남도 순천시 행동', '81-12', 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/21/2852121_image2_1.jpg', 127.4830182188, 34.9548367139, 6, 38, 11, '061-749-3577', 
'<a href="http://scculture.co.kr/" target="_blank" title="새창 : 순천문화도시박람회">http://scculture.co.kr</a>', "2022년 10월 14일 부터 16일 까지 3일 간 개최되는 순천문화도시박람회는 전시, 공연, 투어, 플리마켓을 포함한 종합 문화예술축제이며, 지난 5년간 순천문화도시센터가 걸어온 발자취를 돌아보는 <문화도시 아카이브展>, 시민의 이야기로 광장을 수 놓는 <시민이야기꾼> 지역 예술인들의 창작/창의문화를 엿볼 수 있는 <아트마켓>, <예술품 하프옥션>, <문화의거리 갤러리투어> 및 다채로운 무대공연 등을 즐길 수 있다.", 
'순천문화의거리 일원', NULL, NULL, '무료','연령 제한 없음', '8시간');

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2852051 , '목포미식페스타' , 20220923 , 20220924 , '전라남도 목포시 해안로 179 버스전용공영주차장', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/34/2852034_image2_1.jpg', 126.3833832278, 34.7826098407, 6, 38, 8, '061-270-3512', 
'인스타그램 <a href="https://www.instagram.com/mokpotastyfoodfesta" target="_blank" title="새창 : 목포미식페스타">www.instagram.com</a><br>페이스북 <a href="https://www.facebook.com/mokpotastyfoodfesta/" target="_blank" title="새창 : 목포미식페스타">www.facebook.com</a>', "대한민국에서 음식이 가장 맛있는 도시라고 하면 단연 목포를 언급한다.<br>대한민국 음식의 깊이와 미래의 청사진을 함께 제시하는 목포미식페스타는 음식관련한 다큐멘터리 상영, 음식 인문학콘서트, 음식 시식회 등 목포음식과 관련한 모든 것이 한자리에 모여 있다.", 
'목포미식문화갤러리 해관1897', NULL, NULL, '무료<br>일부유료(다큐멘터리 및 시식회 10,000원)','전연령', NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2852022 , '2022 레저스포츠페스티벌 in 구미' , 20221001 , 20221003 , '경상북도 구미시 낙동제방길 200', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/08/2852008_image2_1.jpg', 128.3677280976, 36.1376965336, 6, 35, 4, '02-2039-0049', 
'<a href="https://leisure-sports.co.kr/" target="_blank" title="새창 : 2022 레저스포츠페스티벌 in 구미 홈페이지로 이동">https://leisure-sports.co.kr/</a>', "'재미있게 즐기고 안전하게 체험하는 레저스포츠'를 주제로 도심에서 다양하게 펼쳐지는 레저스포츠를 무료로 체험할 수 있는 국내 최대의 스포츠 행사다.<br>레저스포츠가 어렵고 위험하다는 인식을 깨기 위해 안전하고 다양한 레저스포츠대회와 체험을 즐길 수 있는 행사가 구미에서 이루어진다.<br>관련 동호인과 선수들도 대거 참여해 이색적인 시범 경기와 각종 이벤트 대회 및 체험전이 진행되며 레저스포츠와 문화가 만나 새롭고 이색적인 페스티벌을 선사할 예정이다.<br>이번 페스티벌은 레저 스포츠의 인기와 트렌드를 반영해 스케이트보드, 드론축구, 서바이벌, 플라잉디스크, 스포츠클라이밍(인공 암벽등반) 등 최근 관심이 높은 프로그램들로 구성되었다.<br>뿐만아니라 구미시장배 유소년 전국드론축구대회, 플라잉디스크 챔피온쉽, 구미 단체 대항전 서바이벌 대회 종목에서는 선수들과 동호인들의 멋진 시범 경기 및 시민들이 직접 체험할 수 있는 프로그램, 부대행사와 축하공연도 준비되어 즐거운 기억을 안겨줄 것이다.", 
'낙동강체육공원', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2851985 , '2022년의왕백운호수축제' , 20220924 , 20220925 , '경기도 의왕시 백운로 526', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/73/2851973_image2_1.jpg', 127.0006158435, 37.3832509208, 6, 31, 24, '031-345-2565', 
'<a href="https://www.uwfest.com" target="_blank" title="새창 : 2022년의왕백운호수축제">https://www.uwfest.com</a>', "시민이 참여하고 즐기는 참여형 축제, 공연, 다양한 체험, 먹거리, 백운호수에서 열린다.", 
'백운호수공영주차장', NULL, NULL, '무료<br>일부 체험 및 먹거리 유료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2851888 , '광주청년주간' , 20220923 , 20220925 , '광주광역시 동구 금남로 210 금남지하상가', NULL, 'A02081300', 'http://tong.visitkorea.or.kr/cms/resource/81/2851881_image2_1.jpg', 126.9148244566, 35.1505799644, 6, 5, 3, '062-383-6526', 
'<a href="https://blog.naver.com/kkotdae/222865105886" target="_blank" title="새창 : 광주청년주간">https://blog.naver.com/kkotdae</a>', "청년에게 묻는다! WHAT'S YOUR COLOR?<br>광주청년주간은 광주광역시에서 청년들을 위해 개최하는 행사로, 올해로 8회째 진행되는 축제다.<br>2022 광주청년주간은 청년들의 다양성과 개성을 존중하고, 청년들이  스스로를 정의하자는 의미를 담고자 'WHAT'S YOUR COLOR?' 라는 슬로건을 내세웠다. 본 행사는 여러가지 테마로 이뤄진 문화예술공연(EDM Festival, K-pop 공연, 힙합 공연 등)과 다양한 색깔을 지닌 길거리 버스킹으로 구성된다.<br>또한 청년 창업가들의 다양한 상품을 접할 수 있고, 청년들을 위한 다양한 정책 소개는 물론, MBTI 성격 진단 검사 및 퍼스널컬러 진단이 가능하니 광주청년주간에 방문하여 자신만의 색깔을 찾길 바란다.", 
'금남로 일대', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2849159 , '2022  제10회 연수능허대문화축제' , 20220930 , 20221001 , '인천광역시 연수구 송도동', '14', 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/48/2849148_image2_1.jpg', 126.6588132791, 37.3954517696, 6, 2, 8, '032-749-8932~8934', 
NULL, "연수능허대문화축제는 고대 해양문화강국 백제의 해상관문인 능허대의 역사를 기념하고 이를 현대적으로 재해석하는 축제의 장으로서 지역대표축제로 자리매김하고 있다. 올해로 10회째를 맞이하는 <2022년 연수능허대문화축제>는 4년만에 개최됨으로써 코로나19로 인하여 지치고 힘든 구민을 위로하고 연수구를 방문하는 관광객들과 함께 즐기고 어울릴 수 있는 축제이다.", 
'송도달빛공원 및 능허대공원', NULL, NULL, '무료','전연령', NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2849140 , '2022 제주 반려동물 문화축제' , 20220924 , 20220925 , '제주특별자치도 제주시 연삼로 286', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/26/2849126_image2_1.jpg', 126.5238621803, 33.4918756720, 6, 39, 4, '064-710-2665', 
'<a href="http://www.jejufairs.com" target="_blank" title="새창 : 제주 반려동물 문화축제">http://www.jejufairs.com</a>', "\"2022 제주 반려동물 문화축제\"는 올바른 반려동물 문화 정착으로 사람과 동물이 행복한 제주를 위한 축제이다. 펫티켓 교육, 성숙한 반려동물 문화 홍보 캠페인부터 각종 반려동물 관련 체험 프로그램까지 반려인과 일반인을 포함한 모든 사람이 함께 즐길 수 있는 다양한 프로그램이 진행될 예정이다. (코로나19 방역 지침에 따라 행사 내용은 변경될 수 있다.)", 
'제주 시민복지타운광장 일원', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2849025 , '2022 남한산성 세계유산 활용 프로그램' , 20220826 , 20221127 , '경기도 광주시 남한산성면 산성리', '935-1', 'A02081300', 'http://tong.visitkorea.or.kr/cms/resource/05/2849005_image2_1.jpg', 127.1809161601, 37.4801512546, 6, 31, 5, '02-482-7647', 
'<a href="https://play-namhansansung.notion.site/2022-09adf187fb53460db4ede25aa79b7aec" target="_blank" title="새창 : 2022 남한산성 세계유산 활용 프로그램">https://play-namhansansung</a>', "유네스코 세계유산 남한산성에서 진행되는 2022 남한산성 세계유산 활용 프로그램<br>국가사적 제 57호이자 세계유산으로 등재된 남한산성은 험준한 자연지형을 따라 12km에 이르는 성벽을 쌓고 유사시 임시수도의 역할을 한 산성도시이다. 오랜 역사 속 다양한 이야기를 품은 세계유산 남한산성에서 다양한 볼거리와 체험거리를 즐겨보는 시간을 가지길 바란다.", 
'남한산성행궁', NULL, NULL, '행궁입장료 / 다담(2000원) / 다담 외 모든 프로그램 무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2848984 , '거리예술 캬라반 ‘가을’' , 20220910 , 20220925 , '서울특별시 종로구 세종대로 175', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/81/2848981_image2_1.jpg', 126.9763210635, 37.5720618985, 6, 1, 23, '02-3437-0059', 
'홈페이지 <a href="https://www.sfac.or.kr/artspace/artspace/streetArts_notice.do?cbIdx=984&bcIdx=133216&type=" target="_blank" title="새창 : 거리예술 캬라반 \'가을\'">https://www.sfac.or.kr</a><br>페이스북 <a href="https://www.facebook.com/SeoulStreetArtsCreationCenter/" target="_blank" title="새창 : 거리예술 캬라반 \'가을\'">https://www.facebook.com</a>', "2014년 '거리예술 시즌제'로 시작된 거리예술 캬라반은 도심 속 시민 일상 공간인 광장, 공원 등을 찾아가 거리예술 작품을 선보이는 서울문화재단 서울거리예술창작센터의 프로그램이다. 오는 10일부터 9월 25일까지 매주말마다 광화문광장, 서울숲, 선유도공원에서 음악극·무용·서커스·연희 총 6편의 거리공연이 24회 이어진다.", 
NULL, NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2848913 , '영남알프스 숲페스타' , 20220917 , 20221023 , '울산광역시 울주군 운문로 117-10', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/75/2848875_image2_1.jpg', 129.0491907604, 35.6257809842, 6, 7, 5, '052-254-0522', 
'<a href="https://ynsupgil.modoo.at" target="_blank" title="새창 : 영남알프스 숲페스타’">https://ynalps.co.kr</a><br>행사접수 <a href="https://event-us.kr/ynalps/event/47903" target="_blank" title="새창 : 영남알프스 숲페스타’">https://event-us.kr</a>', "영남알프스의 본고장 울주군 상북면 주민들이 만든 ‘영남알프스숲길 사회적협동조합’에서 주민들이 만드는 공정여행.<br>상북 주민들은 지난 8월, 한여름 뙤약볕에서 가을날 하얀 꽃밭을 상상하며 1만평에 이르는 영남알프스 숲정원에 메밀꽃 씨앗을 뿌렸다.<br>적게는 100년 많게는 500년에 이르는 큰 나무들을 찾아가고 숲과 나무 그늘이 경이로움을 선사하는영남알프스 숲정원에서 머물고, 느끼고, 체험하며 숲이 주는 위로를 경험하자.", 
'울산광역시 울주군 상북면 덕현리 산96-3 ', NULL, NULL, '유료<br>체험별 요금 상이',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2848979 , '2022 기형도문학관 창작시 공모전 ‘어느 푸른 저녁’' , 20220909 , 20221112 , '경기도 광명시 오리로 268', NULL, 'A02081300', 'http://tong.visitkorea.or.kr/cms/resource/75/2848575_image2_1.jpg', 126.8815921252, 37.4264604500, 6, 31, 4, '02-2621-8860', 
'<a href="http://www.kihyungdo.co.kr" target="_blank" title="새창 : 2022 기형도문학관 창작시 공모전 ‘어느 푸른 저녁’">http://www.kihyungdo.co.kr</a>', "(재)광명문화재단 기형도문학관에서는 시인 기형도를 기념하고, 새로운 예비 작가들의 발굴을 위해 전국단위 청년 대상 창작시 공모전을 개최한다. 세기와 지역, 그리고 장르를 뛰어넘는 기형도의 시처럼 무궁무진한 가능성을 지닌 청년들의 많은 참여를 기다린다.", 
'기형도문학관', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2848926 , '부평향교 춘추x청춘 감성인문학교' , 20220917 , 20220917 , '인천광역시 계양구 향교로 19 부평향교(지정문화재)', NULL, 'A02081300', 'http://tong.visitkorea.or.kr/cms/resource/07/2848507_image2_1.jpg', 126.7207175131, 37.5395472304, 6, 2, 2, '032-450-5753', 
'공식홈페이지 <a href="http://www.igycc.or.kr/" target="_blank" title="새창 :  부평향교 춘추x청춘 감성인문학교">http://www.igycc.or.kr</a><br>블로그 <a href="https://blog.naver.com/PostList.naver?blogId=gycc5753&from=postList&categoryNo=14" target="_blank" title="새창 :  부평향교 춘추x청춘 감성인문학교">https://blog.naver.com</a><br>인스타그램 <a href="https://www.instagram.com/gyeyang_cultural_center/" target="_blank" title="새창 :  부평향교 춘추x청춘 감성인문학교">https://www.instagram.com</a>', "2022 부평향교 <춘추x청춘 감성인문학교>는 가을날의 고즈넉한 향교에서 인문학 강연을 통해 지성을 채우고 전통 음악공연을 감상하며 낭만적인 감성을 충전할 수 있는 토크콘서트 프로그램이다.", 
'부평향교 (인천 계양구 향교로19)', NULL, NULL, '무료','성인', '13:00~17:00 (4시간)');

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2848498 , '감성농부의 도시 나들이' , 20220917 , 20220918 , '경기도 수원시 영통구 법조로 76', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/96/2848496_image2_1.jpg', 127.0679652328, 37.2860245036, 6, 31, 13, '02-554-9570<br>031-8008-9395', 
'<a href="https://nongup.gg.go.kr/" target="_blank" title="새창 :  감성농부의 도시 나들이">https://nongup.gg.go.kr</a>', "경기도 농촌을 지키는 청년농업인 감성농부들이 2022년 9월 17일(토)~18일(일)까지 도시민을 찾아간다. 경기도농업기술원에서 주최하고 한국4-H경기도본부, 경기도4-H연합회에서 주관하는 감성농부의 도시 나들이는 청년농업인과 도시민이 함께 즐기는 도심 속 팜파티이다. 청년농부들이 땀 흘려 키운 농산물 및 가공상품과 다양한 농촌체험(곤충, 원예 등) 프로그램이 준비되어 있으니, 수확의 계절 가을 도심속 팜파티를 즐겨보자! 청년농부! 감성농부들이 여러분을 초대한다.", 
NULL, NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2847562 , '풍요로움을 전하는 동아시아의 등불 - 빛의 화원' , 20220902 , 20221016 , '경상북도 경주시 경감로 614', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/57/2847557_image2_1.jpg', 129.2895443842, 35.8340564631, 6, 35, 2, '054-740-3031', 
'<a href="https://www.gyeongju.go.kr/cceagj/index.do" target="_blank" title="새창 : 풍요로움을 전하는 동아시아의 등불 - 빛의 화원">www.gyeongju.go.kr</a>', "가을밤을 수놓는 동아시아 평화의 불빛!<br>'풍요로움을 전하는 동아시아의 등불 - 빛의 화원' 행사가 2022. 9. 2.(금) ~ 10. 16.(일) 45일 간 경주엑스포대공원에서 개최된다.<br>한·중·일 3국 문화의 화합(和)과 이야기(話), 평화를 밝히는(華) 동아시아 등불을 주제로 펼쳐지는 행사에 여러분의 많은 관심과 참여 바란다.", 
'경주엑스포대공원', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2847555 , '2022 명동우주맥주페스티벌' , 20220923 , 20220924 , '서울특별시 중구 명동길 9', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/54/2847554_image2_1.jpg', 126.9827845963, 37.5638240828, 6, 1, 24, '070-8670-2182', 
'<a href="https://instagram.com/myeongdong_beer_festival?igshid=YmMyMTA2M2Y=" target="_blank" title="새창 : 명동우주맥주페스티벌">https://instagram.com</a>', "맹동우주맥주페스티벌은 미지의 수제 맥주들을 탐험하며 새로운 맥주 생태계를 정복하는 오락과 일탈을 넘어 맥주의 무한한 가치를 탐색하는 페스티벌이다.<br>일 년에 단 2일, 명동에서 펼쳐지는 맥주 다중 우주 공간에서 기존의 맥주 궤도를 넘어 새로운 맥주 탐험의 시대를 맞이해 보자!", 
'중구 명동길 일대', NULL, NULL, '우주맥주 3잔+더쎄를라잇브루잉 한정판 기념잔 9,900원',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2847471 , '2022 서울새활용주간' , 20220901 , 20220906 , '서울특별시 성동구 자동차시장길 49 서울새활용플라자', NULL, 'A02081300', 'http://tong.visitkorea.or.kr/cms/resource/69/2847469_image2_1.jpg', 127.0578667897, 37.5587371344, 6, 1, 16, '02-2153-0474', 
'<a href="https://2022seoulupcycling.modoo.at/" target="_blank" title="새창 : 2022 서울새활용주간">https://2022seoulupcycling.modoo.at</a>', "[2022 서울새활용주간 : 아름다운 제로 웨이스트]<br>서울새활용플라자가 개관 5주년과 더불에 [2022 서울새활용주간 : 아름다운 제로 웨이스트] 행사를 진행하게 되었다.<br>업사이클링과 제로 웨이스트에 관심 있는 여러분들의 많은 참여 바란다.<br><br>*공식 홈페이지 : <a href=\"https://2022seoulupcycling.modoo.at/\" target=\"_blank\" title=\"새창 : 2022 서울새활용주간\">https://2022seoulupcycling.modoo.at</a><br>*프로그램 참여 신청 : <a href=\"https://linktr.ee/2022seoulupcycling\" target=\"_blank\" title=\"새창 : 2022 서울새활용주간\">https://linktr.ee/2022seoulupcycling</a>", 
'서울새활용플라자', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2847463 , '거제몽돌야시장' , 20220805 , 20221231 , '경상남도 거제시 거제중앙로17길 6', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/53/2847453_image2_1.jpg', 128.6240397115, 34.8854673826, 6, 36, 1, '055-633-0533', 
'<a href="https://blog.naver.com/ghmarket2021" target="_blank" title="새창 : 거제몽돌야시장">https://blog.naver.com</a>', "거제몽돌야시장은 거제 전통시장에서 처음으로 개장한 야시장으로 거제고현시장에서 이번해 말까지 매주 금요일과 토요일에 열린다.<br>거제고현시장을 대상으로 2021년부터 추진하고 있는 문화관광형시장 육성사업의 일환으로 기획되었다. 야시장을 통해 거제고현시장의 야간시간대 소비자 유입수를 증가시켜 전통시장을 활성화시키는 것이 거제몽돌야시장의 추진 목표이다.", 
'거제고현시장 공영주차장 옆 공원', NULL, NULL, '매대음식  5,000원~ 10,000원 대',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2846873 , '2022 천안 빵빵데이' , 20221009 , 20221010 , '충청남도 천안시 서북구 번영로 156 천안시청', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/41/2846841_image2_1.jpg', 127.1124242843, 36.8146491745, 6, 34, 12, '041-561-0429', 
'<a href="https://pangpangday.co.kr/" target="_blank" title="새창 : 천안 빵빵데이 ">https://pangpangday.co.kr</a>', "빵의 도시 천안은 다양한 빵을 맛볼 수 있도록 10월 1일을 빵빵데이로 지정하고 빵지순례 등 다양한 체험 프로그램으로 가족, 친구와 함께 삼삼오오 모여 먹으며, 보고 즐기는 축제로 함께 호흡하는 참여형 축제이다. 톡톡 튀는 레시피와 건강하고 트랜디한 메뉴가 가득한 천안으로 빵지순례를 떠나볼까?", 
'충청남도 천안시 서북구 번영로 156, 천안시청 버들광장', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2846398 , '낙동강 감동포구 생태여행' , 20220925 , 20220925 , '부산광역시 북구 금곡동', '1511-3', 'A02081300', 'http://tong.visitkorea.or.kr/cms/resource/93/2846393_image2_1.jpg', 129.0035280221, 35.2267388732, 6, 6, 8, '051-781-2437', 
'<a href="http://bukgutour.com/" target="_blank" title="새창 : 낙동강 감동포구 생태여행">http://bukgutour.com</a>', "화명생태공원을 중심으로 낙동강 일원의 생태환경과 문화를 관광 자원화하여 시민들의 생태 인식 조성을 돕고 지역문화 홍보 및 관광 활성화 도모와 힐링 그리고 재미가 더해진 경쟁력 있는 관광 콘텐츠를 발굴하여 지역경제 활성화에 기여하겠다.", 
'화명생태공원 일대 (프로그램 별 상이 홈페이지 및 예약사이트 확인)', NULL, NULL, '프로그램 별 상이',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2846379 , '2022 D-MEDI FESTA' , 20221028 , 20221030 , '대구광역시 중구 동성로2길 80 2.28 기념중앙공원', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/74/2846374_image2_1.jpg', 128.5971819845, 35.8693367591, 6, 4, 8, '053-381-8071', 
'<a href="http://www.dmedifesta.kr/" target="_blank" title="새창 :  2022 D-MEDI FESTA">http://www.dmedifesta.kr</a>', "대한민국 의료메카 가장 행복한 의료특별시 메디시티대구에서 펼쳐지는 3일 간의 의료관광 축제!<br>D-MEDI WEEK 진료비 할인 주간 (참여 의료기관 외국인 할인 적용), 금 한 돈을 놓고 펼쳐지는 ○△□게임 'K-컬쳐 게임의 제왕', 대구의 우수한 의료 인프라를 경험할 수 있는 'D-MEDI ZONE' 등 다양한 볼거리와 즐길거리, 놀거리가 있는 <2022 D-MEDI FESTA>에 초대한다!", 
'2.28기념중앙공원', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2846353 , '영덕 문화재 야행' , 20221008 , 20221009 , '경상북도 영덕군 예주3길 7', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/37/2846237_image2_1.jpg', 129.4072885579, 36.5371623790, 6, 35, 12, '010-9239-1419', 
'<a href="http://www.ydnight.com/" target="_blank" title="새창 : 영덕 문화재 야행">http://www.ydnight.com</a>', "1919년 3·18만세운동이 격렬히 벌어진 역사의 현장, 영덕군 영해장터거리. 이곳에서 빛(光)과 함께 펼쳐질 2022 영덕문화재야행(夜行)으로 당신을 초대한다.", 
'경북 영덕군 영해면 영해장터거리 일대', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2846192 , '동아시아문화도시 2022 경주 - 난장! 동아시아를 즐겨라!' , 20221007 , 20221009 , '경상북도 경주시 봉황로 21-4', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/43/2846043_image2_1.jpg', 129.2098567093, 35.8415207806, 6, 35, 2, '054-777-5952~4', 
'<a href="https://www.gyeongju.go.kr/cceagj/index.do" target="_blank" title="새창 : 동아시아문화도시 2022 경주 - 난장! 동아시아를 즐겨라!">www.gyeongju.go.kr</a>', "난장! 동아시아를 즐겨라!<br>3개국 문화 교류의 장이 동아시아 문화도시, 경주에서 펼쳐진다.<br>한·중·일 문화공연, 체험, 부대행사가 가득한 축제이다.<br>동아시아문화도시는 한·중·일 3국간 문화다양성 존중이라는 기치 아래, \"동아시아의 의식, 문화교류와 융합, 상대문화 이해\"의 정신을 실천하기 위해 매년 개최하는 문화교류행사이다. 2022년 동아시아문화도시로는 한국 경주시, 중국 원저우시와 지난시, 일본 오이타현이 선정되었다.", 
'경주 시내(봉황대 광장, 중심상가) 일원', NULL, NULL, '무료','전 연령', NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2846135 , '허브아일랜드 핑크뮬리축제' , 20220910 , 20221031 , '경기도 포천시 청신로947번길 51', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/17/2846117_image2_1.jpg', 127.1334898415, 37.9662355012, 6, 31, 29, '031-535-6494', 
'<a href="http://www.herbisland.co.kr/" target="_blank" title="새창 : 허브아일랜드 핑크뮬리축제">http://www.herbisland.co.kr</a>', "허브아일랜드의 가을 대표 축제인 핑크뮬리축제. 마음의 여유를 찾고, 핑크뮬리와 인생 사진을 남길 수 있다. 히비스커스 아이스크림은 핑크뮬리축제 기간에만 먹을 수 있는 이색 먹거리!", 
'10:00 - 21:00', NULL, NULL, '입장료 성인: 9,000원 우대: 7,000원 36개월 이하 유아: 무료','전 연령', NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2846113 , '2022 New York Arts Society Festival in Seoul' , 20220801 , 20221231 , NULL, '비대면 대회', 'A02080900', 'http://tong.visitkorea.or.kr/cms/resource/69/2846069_image2_1.jpg', 0, 0, NULL, 100, 100, 'kpmakorea@aol.com', 
'<a href="https://conservatory.modoo.at/" target="_blank" title="새창 : New York Arts Society Festival in Seoul">https://conservatory.modoo.at</a>', "전국민 예술가 만들기 프로젝트 비대면 대회 <내가 미래의 예술가> 라는 취지 아래 대한민국과 재외동포 예술가와 애호가들를 위해 따듯한 손길들이 모여 만들어진 캠페인 입니다. 공동 성장, 상생, 협업 을 슬로건으로 다양한 예술단체들간의 협업을 통하여 대한민국 예술 전파를 위해 힘쓰고 있다.<br>﻿2014년 부터 매년 4회(음악4회, 미술1회, 댄스1회)개최 하였으며, 각 대회마다 평균 약 200명이 참여 하였다.", 
'<a href="https://www.youtube.com/channel/UC1HBI703kLcwg2kq_0k7_kw" target="_blank" title="새창 : New York Arts Society Festival in Seoul">www.youtube.com</a>', NULL, NULL, '유료<br>탈락시 전액 환불',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2846034 , '제3회 안양청년축제 ‘안양랜드’' , 20220917 , 20220917 , '경기도 안양시 동안구 관평로 149 중앙공원관리부속', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/16/2846016_image2_1.jpg', 126.9613442188, 37.3901883031, 6, 31, 17, '031-8045-5786', 
'<a href="https://www.instagram.com/anyangland_acf/" target="_blank" title="새창 : 제3회 안양청년축제">www.instagram.com</a>', "갓(God)생(生) 사는 청년들의 동심찾기 페스티벌!<br>어린이에게 ‘꿈과 희망’을 전달하는 놀이공원과 같이 청년들에게 ‘삶의 활력’과 ‘꿈의 원동력’을 줄 수 있는 축제", 
'평촌중앙공원', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2846009 , '10월은 정동의 달 ‘시월정동’' , 20221006 , 20221008 , '서울특별시 중구 정동길 21-18 정동공원', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/84/2845984_image2_1.jpg', 117.9925662504, 19.6944274800, 6, 1, 24, '02-120', 
'<a href="http://www.xn--2q1br8zd3cypb.kr/" target="_blank" title="새창 : 10월은 정동의 달 시월정동">www.시월정동.kr</a>', "깊어가는 가을, 한국의 중심지 서울 ‘정동’에서 역사와 문화, 다양한 볼거리가 넘치는 축제의 향연이 펼쳐진다.", 
'정동일대', NULL, NULL, '무료','전체관람가능', NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2845975 , '용인패밀리페스티벌' , 20221022 , 20221023 , '경기도 용인시 처인구 중부대로 1199 용인시청', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/98/2847298_image2_1.jpg', 127.1780370910, 37.2402956597, 6, 31, 23, '031-324-3044', 
NULL, "코로나 블루로 지친 시민들을 위로하고 가족과 친구, 동료 등 주변 사람들의 소중함과 감사함을 느낄 수 있는 시민 힐링의 장", 
'용인시청 광장', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2845956 , '백두대간 산림치유 페스티벌' , 20220930 , 20221002 , '경상북도 영주시 테라피로 209 건강증진센터', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/07/2847607_image2_1.jpg', 128.4726898984, 36.8577690602, 6, 35, 14, '054-639-3400', 
'<a href="https://daslim.fowi.or.kr/" target="_blank" title="새창 : 백두대간 산림치유 페스티벌">https://daslim.fowi.or.kr/</a>', "코로나 이후 대체 백신으로 각광받는 산림치유를 'K-힐링' 으로 전파하며 일상에 지친 시민들의 몸과 마음을 회복하고 남녀노소 구분없이 즐기는 오감만족 페스티벌", 
'국립산림치유원 일대', NULL, NULL, '홈페이지 참고',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2845946 , '2022 청춘, 커피페스티벌' , 20221008 , 20221009 , '서울특별시 송파구 올림픽로 300 롯데월드타워앤드롯데월드몰', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/41/2845941_image2_1.jpg', 127.1040305171, 37.5142459111, 6, 1, 18, '02-360-4520', 
'<a href="https://youthcoffee.co.kr" target="_blank" title="새창 : 청춘, 커피페스티벌">https://youthcoffee.co.kr</a>', "\"청춘로스팅, 꿈의 향이 퍼지다.\"<br>로스팅에 따라 무한한 향의 커피가 만들어지듯 청춘의 다양한 꿈과 미래을 응원한다.<br>반복되는 삶과 지친 일상 속에서 똑같은 하루를 살아가는 청춘들에게 작은 쉼이 될 수 있도록 커피 한 잔의 여유와 온기와 희망을 전한다.", 
'서울 롯데월드타워 잔디광장', NULL, NULL, '무료','전체관람가능', NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2845940 , '2022장애인창착아트페어' , 20220905 , 20220908 , '서울특별시 서초구 강남대로 27 AT센터', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/39/2845939_image2_1.jpg', 127.0407514903, 37.4673918780, 6, 1, 15, '02-567-9623', 
'<a href="https://aaartfair.co.kr/" target="_blank" title="새창 : 장애인창착아트페어">https://aaartfair.co.kr</a>', "2014년 장애미술인들의 창작의욕을 고취시키고 장애인미술 발전의 새로운 교두보를 만들자는 취지로 시작한 장애인창작아트페어(Able Access Art Fair)는 “한국 최대규모의 장애인미술 아트페어”로 자리매김하였다.<br>2022 장애인창작아트페어는 기억에 남는 전시를 제공하고 성공적인 결과를 이끌어내 한국 장애인미술의 새로운 지표가 되어 나가겠다.<br>올해 문화체육관광부와 한국 장애인 문화예술원이 후원하는 가장 권위있는 장애인 미술행사인 2022장애인창작아트페어는 ‘DI.VERSE - Eye & Mind’ 으로 \"작품은 눈으로 보는 것이 아닌 마음으로 읽는 것이다. - 그 안에 담긴 작가의 세계를\" 라는 주제로 다양한 작가들의 작품들과 프로그램들이 진행된다.", 
'서울 양재 At센터 제2전시장 A홀', NULL, NULL, '무료','전 연령', '자유롭게 관람가능');

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2844577 , '2022 단양 한여름 수상 썸머 페스티벌' , 20220827 , 20220828 , '충청북도 단양군 단양읍 상진리', '116-1', 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/66/2844566_image2_1.jpg', 128.3509222304, 36.9799499782, 6, 33, 2, '043-423-0701', 
'<a href="http://danyang.go.kr" target="_blank" title="새창 : 단양 한여름 수상 썸머 페스티벌">http://danyang.go.kr</a>', "대한민국 관광1번지 단양군이 전국 제일의 수상관광 도시로의 첫발을 내딛어 개최하는 수상 페스티벌이며 가족 및 연인과 함께 플라이보드 공연을 즐기고 윈드서핑, 모터보트, 제트스키, 카누, 패들보드, 수상자전거 등 다양한 수상레저기구 체험을 할 수 있는 행사이다.", 
'단양읍 상진계류장 일원', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2844254 , '제4회 금천과학축제「2022. G-Science Festival」' , 20220901 , 20220904 , '서울특별시 금천구 시흥대로73길 70 금천구청종합청사', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/53/2844253_image2_1.jpg', 126.8955205706, 37.4564933229, 6, 1, 8, '02-2627-2300', 
'<a href="https://www.gscience.kr" target="_blank" title="새창 : 금천과학축제">www.gscience.kr</a>', "제4회 금천과학축제「2022. G-Science Festival」은 2022년 9월 1일(목) ~ 9월 4일(일) <4일간> 금천구청 광장, 금나래 공원 일대, 금천사이언스큐브와 온라인 사이트, 메타버스에서 진행된다. 4차 산업 기술을 직접 체험하고 즐길 수 있는 기회를 제공하여 미래 창의과학인재를 양성하고, 과학 특화 도시 금천의 과학 문화 붐을 조성하고자 한다.", 
'금천구청 및 금나래 공원 일대, 금천사이언스큐브', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2843904 , '진주문화재야행' , 20220826 , 20220828 , '경상남도 진주시 남강로 626 진주성', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/03/2843903_image2_1.jpg', 128.0801041570, 35.1905317730, 6, 36, 13, '055)795-3200', 
'<a href="https://jjnightfest.com/" target="_blank" title="새창 : 진주문화재야행">https://jjnightfest.com</a>', "문화재를 배경으로 구성된 8야(夜)의 야행 공간을 체험하고 쇄미록(관광일기)을 기록하는 이색 문화재 야간 탐방<br>25개 행사(진주문화재야행 8야(夜) 21, 동반행사 4)<br>- 야경(夜景) : 문화재 야간개방<br>- 야로(夜路) : 탐방 프로그램<br>- 야사(夜史) : 체험 프로그램<br>- 야화(夜畵) : 전시 프로그램<br>- 야설(夜設) : 공연 프로그램<br>- 야식(夜食) : 음식 프로그램<br>- 야시(夜市) : 시장 프로그램<br>- 야숙(夜宿) : 숙박 프로그램", 
'진주성 및 원도심 전통시장 일원', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2843892 , '원주옥상영화제' , 20220901 , 20220810 , '강원도 원주시 상지대길 83 상지대학교', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/90/2843890_image2_1.jpg', 127.9324679021, 37.3706527090, 6, 32, 9, '070-7711-8221<br>070-7711-8222', 
'<a href="https://wrff.wonjumc.kr/" target="_blank" title="새창 : 원주옥상영화제">https://wrff.wonjumc.kr</a>', "올해로 6회를 맞이한 원주옥상영화제는 영화의 즐거움을 나누고자 원주 지역 청년들이 모여 만든 비경쟁 무료 영화제다. 지역에서 쉽게 접할 수 없는 독립예술영화를 상영하여 시민들에게 다양성 영화의 향유 기회를 제공한다. 원주옥상영화제는 지역 영화 섹션 <강원단편선>을 상영하고 영화인들을 초청하여 도내의 감독을 발굴하고, 시민프로그래머 양성교육을 통해 시민들의 적극적인 영화 활동을 장려하며, 지역 영화 활동가, 예술인, 문화단체와 협업하는 지역 밀착형 영화제이다. 현재 최신 도내 영화를 상영하는 <강원단편선>, 화제를 모은 단편 영화를 상영하는 <옥상단편>과 <옥상장편>뿐만 아니라 밤을 새서 영화를 보는 <모두밤샘>과 부대 프로그램 <영.사.다.방>으로 구성되어 있다.", 
NULL, NULL, NULL, '무료','<강원단편선> 15세 관람가 <옥상단편1> 전체 관람가 <옥상단편2> 15세 관람가 <옥상단편3> 12세 관람가 <옥상단편4> 15세 관람가 <옥상장편1> 12세 관람가 <옥상장편2> 15세 관람가 <모두밤샘> 청소년 관람불가', '<강원단편선> 96분 <옥상단편1> 77분 <옥상단편2> 83분 <옥상단편3> 91분 <옥상단편4> 96분 <옥상장편1> 107분 <옥상장편2> 81분 <모두밤샘> 7시간');

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2843865 , '아세안 문화유산 VR 체험' , 20220701 , 20221231 , '부산광역시 해운대구 좌동로 162 아세안문화원', NULL, 'A02081300', 'http://tong.visitkorea.or.kr/cms/resource/49/2843849_image2_1.jpg', 129.1820750100, 35.1751757315, 6, 6, 16, '051-775-2001', 
'<a href="https://www.ach.or.kr/ach/ru/cnts.do?resveMasterSn=11420&mi=2329" target="_blank" title="새창 : 아세안 문화유산 VR 체험">https://www.ach.or.kr</a>', "코로나 19로 쉽게 떠나지 못하는 여행의 아쉬움을 달래기 위해 아세안문화원에서 아세안 국가로의 디지털 여행을 떠나보자!<br>부산 해운대구에 위치한 아세안문화원은 아세안 10개국의 UNESCO 세계문화유산을 3D VR 콘텐츠로 체험할 수 있는 국내 유일한 공간이다.<br>신규 상영 중인 VR 콘텐츠는 현존 최고의 디지털 첨단 기술을 적용하여, 관람객들에게 현장에 있다는 착각이 들 정도로 최고의 경험을 선사하고 있다. <br>현재 태국의 수코타이 역사공원, 베트남의 카이딘 황제릉 콘텐츠를 상영 중이며, 9월부터 브루나이, 라오스, 말레이시아, 필리핀 싱가포르 콘텐츠를 추가 공개한다.<br>부산 여행을 계획 중이시라면, 최신형 기기인 오큘러스 Quest 2와 함께 하는 최고의 아세안 디지털 여행을 즐겨보자!<br><br>※ 아세안 10개국: 브루나이, 캄보디아, 인도네시아, 라오스, 말레이시아, 미얀마, 필리핀, 싱가포르, 태국, 베트남", 
NULL, NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2843652 , '2022 전국풍물 상설공연 <어울마당 풍물세상>' , 20220903 , 20221105 , '충청남도 계룡시 신도안면 정장리', '14-1', 'A02080100', 'http://tong.visitkorea.or.kr/cms/resource/95/2843595_image2_1.jpg', 127.2377157212, 36.3066458062, 6, 34, 16, '02-580-3263', 
'<a href="https://www.kotpa.org/ucms/main/indexmain.do" target="_blank" title="새창 : 제3회 전국풍물 상설공연">www.kotpa.org</a>', "전국풍물 상설공연 <어울마당 풍물세상>은 2013년부터 지역 풍물단체의 인지도 확산과 대중들의 전통예술 향유 기회 확대를 위해 시작됐다.<br>전국에 분포한 특색있는 연희·풍물 단체들을 지원하여, 각 지역의 도심·관광지를 찾는 방문객들에게 흥겨운 공연을 선보이고자 합니다. 2013년부터 지금까지 총 665회의 공연을 통해 24만여명이 함께한 본 공연은 청주, 계룡, 경주 3개지역에서 9월부터 11월까지 만나볼 수 있다.", 
'계룡세계군문화엑스포, 국립경주박물관, 청남대', NULL, NULL, '관람료 무료','관람연령 제한없음', '30분');

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2843521 , '제3회 예산황새축제' , 20220902 , 20220903 , '충청남도 예산군 시목대리길 62-19 예산황새공원, 문화관', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/09/2843509_image2_1.jpg', 126.7970711575, 36.5430637642, 6, 34, 11, '041-335-9970', 
'<a href="https://www.yesan.go.kr/stork.do" target="_blank" title="새창 : 제3회 예산황새축제">www.yesan.go.kr/stork.do</a>', "생태,재미,가족 그리고 마을의 가치를 축제에 담아 다양한 프로그램으로 황새축제를 운영하고자 한다.", 
'예산황새공원', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2842412 , '7일간의 동행축제' , 20220901 , 20220907 , NULL, '온라인 개최', 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/75/2842975_image2_1.jpg', 0, 0, NULL, 100, 100, '02-6678-9326', 
'<a href="https://www.ksale.org/" target="_blank" title="새창 : 7일간의 동행축제">www.ksale.org</a>', "1. 7일간의 동핵축제는 국내외 유통사 및 전통시장, 상점가 등이 참여하는 국내 최대규모의 중소기업 소상공인 제품 소비촉진 행사<br>2. 역대 최대규모인 230개 유통채널(온라인 몰 등)에 약 6,000개사 소상공인 및 중소기업 제품 참여, 최대 80% 할인 판매 등<br>3. 전통시장, 지역상관, 지역축제 등에서 댄스, 버스킹, 패션쇼 등 문화공연과 연계한 특별판매전도 추진<br>- 한강달빛야시장*동행축제(9.2~3), 이천 도자기축제*동행축제(9.2~4) 등<br>- 상생소비 복권(총 12억원, 3,500명), 온누리상품권 할인 등 다양한 참여 이벤트 개최", 
'전야제(광화문), 백화점 및 쇼핑몰 및 전통시장 등 230개 유통채널', NULL, NULL, '할인- 최대 80%까지 할인 제공','전연령', '사전 부대행사는 모두 관람가능, 전야제 행사는 19시~20시');

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2842411 , '2022 숲 속 모두의, 포레포레' , 20220827 , 20221126 , '경기도 수원시 권선구 서둔로 166', NULL, 'A02081300', 'http://tong.visitkorea.or.kr/cms/resource/08/2842408_image2_1.jpg', 126.9811903187, 37.2665807612, 6, 31, 13, '031-296-1863/1987', 
'<a href="https://sscampus.kr/" target="_blank" title="새창 : 2022 숲 속 모두의, 포레포레">https://sscampus.kr</a>', "경기상상캠퍼스 대표 문화축제 '숲 속 모두의, 포레포레'가 3년만에 개최된다. 2019년 개최 이후 3년만에 만나는 포레포레는 월별로 다른 컨셉으로 도심 숲 속 경기상상캠퍼스에서 8월~11월 매월 넷째 주 토요일에 진행된다. 8월 '친환경', 9월 '독서', 10월 '할로윈', 11월 '공연' 컨셉으로 월마다 각각의 테마에 맞춘 재미있는 프로그램을 선보일 예정이다. 포레포레는 2016년 경기상상캠퍼스 입주단체의 창작물을 판매하는 숲 속 장터를 시초로 하여, 공연, 교육, 체험 등 다양한 콘텐츠로 도심에서 즐기는 숲 속 문화축제 브랜드로 자리 잡아왔다. '숲 속 모두의, 포레포레'는 무료 행사로 누구나 자유롭게 참여할 수 있으며, 월별 상세 안내는 경기상상캠퍼스 홈페이지에서 확인할 수 있다.", 
'경기상상캠퍼스', NULL, NULL, NULL,NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2841134 , '2022 울산문화축전' , 20221007 , 20221013 , '울산광역시 중구 염포로 55 울산종합운동장', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/33/2841133_image2_1.jpg', 129.3473804138, 35.5610160884, 6, 7, 1, '052-259-7932', 
'제103회 전국체육대회 <a href="https://www.ulsan.go.kr/s/103_sports/main.ulsan" target="_blank" title="새창: 홈페이지로 이동">https://www.ulsan.go.kr/s/103_sports/main.ulsan</a><br>제42회 전국장애인체육대회 <a href="https://www.ulsan.go.kr/s/42_sports/main.ulsan" target="_blank" title="새창: 홈페이지로 이동">https://www.ulsan.go.kr/s/42_sports/main.ulsan</a>', "「2022 울산문화축전」은 울산광역시에서 17년 만에 다시 개최되는 2022년 전국(장애인)체전을 기념하는 문화예술축제이다. 제103회 전국체육기간에 울산종합운동장과 태화강 국가정원에서 17개 광역시·도별 특색을 담은 예술공연, 거리공연, 체험 및 전시 프로그램을 선보일 예정이다. 또한, 「2022 울산문화축전」을 통해 전국에서 모인 모든 참가선수에게 응원의 메시지를 전달하고, 시민과 방문객에게 볼거리와 즐거움을 선사한다.", 
'울산종합운동장 이벤트광장<br>태화강국가정원 왕버들마당', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2841120 , '대전 피파 토너먼트' , 20220904 , 20220904 , '대전광역시 유성구 대덕대로 480 대전 C.T센터, 스튜디오큐브', NULL, 'A02081200', 'http://tong.visitkorea.or.kr/cms/resource/10/2841110_image2_1.jpg', 127.3802705364, 36.3759931713, 6, 3, 4, '042-867-9645', 
'<a href="https://dje.dicia.or.kr/" target="_blank" title="새창 : 대전 피파 토너먼트">https://dje.dicia.or.kr</a>', "대전시 소재 중고등학생 대상 피파 토너먼트 대회 개최(9.4.)", 
'대전 이스포츠경기장', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2841098 , '<이야기하는 아세안: 종교, 예술, 삶> 프로그램' , 20220701 , 20221231 , '부산광역시 해운대구 좌동로 162 아세안문화원', NULL, 'A02081300', 'http://tong.visitkorea.or.kr/cms/resource/88/2841088_image2_1.jpg', 129.1820750100, 35.1751757315, 6, 6, 16, '051-775-2001', 
'<a href="https://www.ach.or.kr/ach/ru/cnts.do?srchOrdtmOperAt=&srchTxt=&sysId=ach&resveMasterSn=11300&ongoingAt=&mi=2330" target="_blank" title="새창 : <이야기하는 아세안: 종교, 예술, 삶> 프로그램">https://www.ach.or.kr</a>', "코로나 19로 쉽게 떠나지 못하는 여행의 아쉬움을 달래기 위해 아세안 국가로의 여행을 떠나보자!<br>부산 해운대구에 위치한 아세안문화원은 아세안 10개국의 대표적인 문화유산, 종교와 예술, 그리고 삶의 지혜를 엿볼 수 있는 각종 예술작품, 공예품, 의복 등을 선보이는 상설전시 <이야기하는 아세안: 종교, 예술, 삶> 및 체험활동을 운영 중이다.<br>관람객은 모바일 웹 “아세안 스토리텔러”를 통해 전시 안내를 받고 나만의 스토리를 지닌 아세안 콜렉션을 수집하는 흥미로운 체험을 할 수 있다. 또한 아세안의 종교, 예술, 삶을 퀴즈로 풀어보는 “아세안 탐구여행” 7종(유치원용, 초·중·고급)과 아세안 국가 지도에 스티커를 붙이며 아세안의 자연, 랜드마크, 문화유산 등을 알아가는 “아세안 지도여행” 체험활동에도 참여 가능하다.<br>부산 여행을 계획 중이시라면, 아세안문화원에서 가깝고도 먼 아세안 국가로의 여행을 즐겨보자!", 
'아세안문화원 2층 상설전시실', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2841087 , '부안문화재야행' , 20220930 , 20221001 , '전라북도 부안군 동문안1길 20', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/81/2841081_image2_1.jpg', 126.7339867980, 35.7360049751, 6, 37, 6, '063-244-3177', 
'<a href="http://ifaf.kr" target="_blank" title="새창 : 서해바다를 품은 부안, 오대양을 향하다">http://ifaf.kr</a>', "부안읍 내의 당산을 비롯한 문화재를 활용한 6夜를 가족과 친구, 연인간의 행복한 추억을 만들수 있도록 풍성한 프로그램이 준비되어 있다. 많은 관심과 참여를 부탁한다.", 
'부안동문안당산 및 일대 역사문화자원', NULL, NULL, '무료<br>일부 유료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2841074 , '영도커피페스티벌' , 20221104 , 20221106 , '부산광역시 영도구 해양로301번길 55', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/73/2841073_image2_1.jpg', 129.0819836173, 35.0772042891, 6, 6, 14, '051-419-4472, 051-714-7309', 
'<a href="https://www.yeongdo.go.kr/yd_coffee_festival.web" target="_blank" title="새창 : 영도커피페스티벌">www.yeongdo.go.kr</a>', "영도, 커피로 물들다.<br>커피 도시로 거듭날 부산의 축제!<br>글로벌 커피산업의 문화 중심지, 영도구에서 커피페스티벌에서 다양한 커피문화 컨텐츠를 경험해보자!", 
'아미르공원', NULL, NULL, '무료(체험비제외)',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2838316 , '국립무형유산원 나들이' , 20220820 , 20220827 , '전라북도 전주시 완산구 서학로 95 국립무형유산원', NULL, 'A02081300', 'http://tong.visitkorea.or.kr/cms/resource/11/2838211_image2_1.jpg', 127.1596636399, 35.8099038819, 6, 37, 12, '063-232-9937~8', 
'네이버 블로그 <a href="https://blog.naver.com/artf9938" target="_blank" title="새창 : 국립무형유산원 나들이">https://blog.naver.com</a><br>인스타그램 <a href="https://www.instagram.com/culture__art/" target="_blank" title="새창 : 국립무형유산원 나들이">www.instagram.com/culture__art</a><br>페이스북 <a href="https://www.facebook.com/문화예술공작소-107018241074868" target="_blank" title="새창 : 국립무형유산원 나들이">www.facebook.com</a>', "'국립무형유산원 나들이'는 국립무형유산원을 거닐며 전문 배우들의 살아있는 해설을 듣고, 고품격 체험 및 공연까지 즐길 수 있는 투어 프로그램이다.", 
'국립무형유산원 어울마루 앞', NULL, NULL, '유료 / 1인 5,000원',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2837811 , '원더티켓-수호나무의 부활' , 20220908 , 20220918 , '경기도 파주시 임진각로 148-40 평화누리', NULL, 'A02080300', NULL, 126.7447609198, 37.8920676942, 6, 31, 27, '한국관광공사', 
'<예매><br>파주 <a href="https://tickets.interpark.com/goods/22010002?app_tapbar_state=hide&amp;" target="_blank" title="새창 : 원더티켓-수호나무의 부활">https://tickets.interpark.com</a><br>인제 <a href="https://tickets.interpark.com/goods/22010264"target="_blank" title="새창 : 원더티켓-수호나무의 부활">https://tickets.interpark.com</a>', "분단의 아픔과 평화에 대한 염원을 소재로 한 줄거리의 ICT기술을 가미한 공연으로 경기도 파주 임진각 평화누리 야외공연장과 인제 하늘 내린센터 대공연장에서 9월 7일부터 18일까지 진행된다, 현재 원더티켓 구매시 지역 기념품이 제공된다.<br><br>[줄거리] 625 전쟁으로 헤어진 옛사랑과 고향을 그리워하는 노신사가 단군신화 속 풍백, 운사, 단야 등의 도움으로 과거로 돌아가는 여정을 통해 평화의 소중함을 일깨우는 판타지 쇼", 
'파주- 평화누리 여외대공연장<br>인제- 하늘내린센터 일대', NULL, NULL, '15,000원',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2837375 , '2022 부산국제가요제' , 20221022 , 20221022 , '부산광역시 중구 용미길9번길 6-45', NULL, 'A02081000', 'http://tong.visitkorea.or.kr/cms/resource/23/2837323_image2_1.jpg', 129.0359065412, 35.0964901712, 6, 6, 15, '1670-7894', 
'<a href="http://hbs.aub.kr/bbs/board.php?bo_table=bo_44662&wr_id=11" target="_blank" title="새창 : 부산국제가요제">http://hbs.aub.kr</a>', "부산국제가요제는 부산을 국제적으로 우수성을 알리고 부산국제가요제를 통해 대한민국을 문화와 예술을 아는 고품격 국민임을 알리고 남녀노소,지역주민,외국인이 참여하는 세계적인 부산국제가요제로 우뚝솟아 특별한 추억과 새로운 도약을 보여 주고자 목적을 두고 기획하였다.", 
'부산광역시 중구 유라리광장 특설무대', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2836510 , '2022 아시아 태평양  국제해양디지털 콘퍼런스(Digital@Sea Asia-Pacific region Conference)' , 20220915 , 20220916 , '서울특별시 중구 을지로 30 롯데호텔', NULL, 'A02081300', 'http://tong.visitkorea.or.kr/cms/resource/09/2836509_image2_1.jpg', 126.9810458210, 37.5654016461, 6, 1, 24, '02-578-0223', 
'<a href="http://www.digitalsea-ap.org/" target="_blank" title="새창 : 아시아 태평양  국제해양디지털 콘퍼런스">www.digitalsea-ap.org</a>', "1. 다가오는 2D(Decarbonization, Digitalization) 시대를 맞이하여 해양디지털 기술의 국제 표준화를 선도하기 위한 기술협력의 장 마련을 위하여 개최하는 행사이다.<br>2. 온라인 및 오프라인 병행 하이브리드 행사이다.<br>3. 라이브 스트리밍은 홈페이지 접속후 시청 가능하다.", 
'롯데호텔 서울 3층 사파이어볼룸', NULL, NULL, '온라인 : 무료, 오프라인 : 20만원(홈페이지 사전등록시 20%할인)',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2835954 , '2022 거제비어페스타' , 20220817 , 20220820 , '경상남도 거제시 장승로 146-19', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/38/2835938_image2_1.jpeg', 128.7265368359, 34.8673073742, 6, 36, 1, '010-5418-7412', 
'<a href="https://2022gbf.modoo.at/" target="_blank" title="새창 :  2022 거제비어페스타">https://2022gbf.modoo.a</a>', "8월에 더위를 물리칠 8배 강력한 맥주축제가 올라호프와 함께 돌아왔다.<br>한여름밤 장승포 밤바다에서 펼쳐지는 쿨(김성수), DJ DOC(이하늘)와 함께하는 화끈한 EDM 파뤼, 가슴까지 시원하게 적셔줄 테라생맥주가 단돈 만원에 무제한, 장승포차의 JMT 먹거리와 플리마켓 등<br>즐거움이 멈추지 않는 거제비어페스타에 여러분을 초대한다.", 
'장승포항 수변공원', NULL, NULL, '1만원/인 (사전예매시 8,500원)',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2835921 , '2022 제주청년의 날' , 20220916 , 20220920 , '제주특별자치도 제주시 중앙로 53', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/87/2835887_image2_1.jpg', 126.5249449273, 33.5135732874, 6, 39, 4, '2022 제주청년의 날 운영사무국 064. 727. 0521', 
'홈페이지 <a href="http://jejuyouthday2022.kr" target="_blank" title="새창 : 제주청년의 날">http://jejuyouthday2022.kr</a><br>인스타그램 <a href="https://www.instagram.com/jejuyouthday_2022" target="_blank" title="새창 : 제주청년의 날">www.instagram.com/jejuyouthday</a>', "매년 9월 셋째 주 토요일, 법정기념일 청년의 날을 맞이하여, 섬이라는 제주 안에서 각기 다른 이야기를 품고 있는 제주 청년들이 코로나 시대 이후에 움츠린 어깨를 피고 마음껏 난리 칠 수 있는 장을 만들고자 '우리들의 난리-블루스'라는 주제로 5일간 제주 전역에서 펼쳐지는 약 20여개의 다양한 프로그램으로 개최되는 청년주간 행사이다.", 
'제주청년센터 및 제주도 일원', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2835883 , '2022 서울청년봉사제' , 20220827 , 20220827 , '서울특별시 성동구 왕십리로 63 언더 스탠드 에비뉴', NULL, 'A02081300', 'http://tong.visitkorea.or.kr/cms/resource/62/2835862_image2_1.jpg', 127.0436018495, 37.5436747388, 6, 1, 16, '02-468-0601', 
'<a href="https://blog.naver.com/livewith_korea/222839239715" target="_blank" title="새창 : 2022 서울청년봉사제">blog.naver.com/livewith_korea</a>', "2022 서울청년봉사제는 청년들이 봉사에 대해 이야기하는 축제로 단순히 봉사활동을 한다는 것과는 달리 누구나 봉사, 사회공헌과 관련된 정보를 확인하고 참여할 수 있도록 기업, 기관, 단체 및 청년이 모인다. 봉사제에서 진행되는 대담에서는 민간단체에서 시행하는 다양한 콘텐츠와 대학교 동아리까지 ‘봉사’를 어떻게 하고, 무엇을 하고, 어떻게 커리어에 활용할 수 있는지에 대해 이야기한다. 대담 이외에 성수동 일대에서 진행하는 ‘갓생 플로깅’, 서울숲 카페 테디스 오븐에서 진행하는 ‘다양한 체험부스’ 및 예술 작품을 관람 및 경매를 통해 구매하는 ‘미니 옥션’까지 경험할 수 있다.", 
'서울숲 언더스탠드애비뉴', NULL, NULL, '플로깅 - 1만원(전액 기부) / 그 외 - 무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2835832 , '글로벌 메타버스 컨퍼런스 & 한아세안 포럼' , 20220818 , 20220819 , '부산광역시 해운대구 APEC로 55 벡스코', NULL, 'A02081300', 'http://tong.visitkorea.or.kr/cms/resource/07/2835807_image2_1.jpg', 129.1355209016, 35.1687450332, 6, 6, 16, '070-4365-8539', 
'<a href="https://busanmetaverse2022.modoo.at/" target="_blank" title="새창 : 글로벌 메타버스 컨퍼런스 & 한아세안 포럼">https://busanmetaverse</a>', "'메타버스, 새로운 세상의 시작'이라는 주제로 부산에서 개최되는 이번행사는 메타버스, NFT, 주요 산업 동향에 대한 강연과 함께 한-아세안 지역의 메타버스 산업의 연계협력 및 교류 활성화를 위해 마련되었습니다. 자세한 컨퍼런스 소개 및 참가신청방법은 
@ict_convergence_village(한아세안 ICT융합빌리지) 또는 (<a href=\"https://busanmetaverse2022.modoo.at/\" target=\"_blank\" title=\"새창 : 글로벌 메타버스 컨퍼런스 & 한아세안 포럼\">https://busanmetaverse</a>)홈페이지를 확인해 바란다.", 
'BEXCO 컨벤션홀 1F', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2833934 , '국립생태원 반려식물 특별전(나와 지구, 모두의 힐링)' , 20220426 , 20220912 , '충청남도 서천군 금강로 1210', NULL, 'A02080700', 'http://tong.visitkorea.or.kr/cms/resource/00/2833900_image2_1.jpg', 126.7194583721, 36.0271354218, 6, 34, 8, '041-950-5300', 
'<a href="https://www.nie.re.kr/" target="_blank" title="새창 : 국립생태원 반려식물 특별전">www.nie.re.kr</a>', "집에서, 학교에서, 사무실에서, 늘 가까이에 둘 수 있는 새로운 식구 ‘반려식물’과 함께 해보자.<br>식물돌보기는 생명체를 다루는 활동으로서 정서적 유대감을 형성할 수 있고 스트레스 해소에도 도움이 된다. 사람의 신체적, 교육적, 사회적 능력을 기를 수 있는 ‘원예치료’는 다양한 분야에서 사람에게 치료․치유의 효과를 입증하고 있다. 가까운 실내공간에 두면 유해화학물질을 제거하고 맑은 산소를 내뱉으면서 깨끗한 공기를 유지하는데 도움이 되기도 한다.<br>사람에게 이토록 유익한 식물이 지구에게는 해열제, 소화제가 될 수 있습니다. 식물은 공기 중 탄소를 흡수하고, 식물이 뿌리내린 흙은  탄소를 저장하여 탄소배출량을 줄일 수 있다. 생산․분해 과정에서 많은 탄소를 배출하고 오랫동안 썩지 않는 재료인 플라스틱 대신에 식물성 재료로 만든 화분과 천연비료를 사용하여 반려식물을 돌보는 것은 어떨까? <br>`NO PLASTIC`을 몸소 실천하고 있는 모범적인 그대에게 반려식물 총 500본을 나눔한다.<br>식물은 나와 지구, 우리 모두를 힐링하게 하는 생명의 원천이다.", 
'국립생태원 에코리움 에코파티오', NULL, NULL, '어른:5,000원 / 청소년: 3,000원 / 어린이: 2,000원 / 유아,경로우대자, 장애인, 국가유공자, 기초생활수급자: 무료 20인 이상 단체의 인솔자 1인 무료 유아, 경로우대자, 장애인, 국가유공자, 기초생활수급자는 증명서 필히 지참 장애 1~3급 장애인 동반 1인 무료, 장애4급 이상 본인만 무료 50% 할인 서천군민(본인에 한함)<br>다자녀 가정(다자녀카드 소지자에 한함)<br>30%할인그린카드 소지자(본인에 한함) 4D영상관 관람료는 1,000원 할인 없이 동일 금액',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2833886 , '힐링폴링 수원화성' , 20220923 , 20221023 , '경기도 수원시 장안구 영화동', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/62/2833862_image2_1.jpg', 127.0119147215, 37.2875511031, 6, 31, 13, '031-290-3613(정조대왕능행차)<br>031-290-3622(수원화성미디어아트)<br>031-248-9851~4(수원화성문화제&세계유산축전)', 
'<a href="https://www.swcf.or.kr/shcf/" target="_blank" title="새창 : 힐링폴링 수원화성">www.swcf.or.kr</a>', "2022년 가을, 세계유산 수원화성을 배경으로 진행되는 4개 축제 '힐링폴링 수원화성'이다. '힐링폴링 수원화성'은 수원화성 미디어아트쇼, 2022 세계유산축전 수원화성, 제59회 수원화성문화제, 정조대왕 능행차 재현 등 4개 가을 축제를 말한다. 9월 23일부터 10월 23일까지 한 달간 각 축제별로 미디어파사트, 능행차 재현, 수원화성 축성의 토대인 의궤를 기반으로 한 공연/전시/체험 프로그램까지 수원 화성을 즐길 수 있는 다양한 콘텐츠를 제공한다.", 
'수원화성 일원<br>(*정조대왕 능행차 공동재현 : 서울→경기→수원→화성)', NULL, NULL, '축제별 상이',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2833343 , '락 페스티벌 달그락' , 20220820 , 20220820 , '충청남도 아산시 신정로 616 신정호공원', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/99/2833299_image2_1.jpg', 126.9839287142, 36.7715713070, 6, 34, 9, '041-545-2222', 
NULL, "2022락페스티벌 ‘달그락’은 충청남도와 아산시가 주최하고, 온양문화원이 주관하며 아산시밴드연합회가 협력하는 행사로 충남 및 세종 권역에서 활동하고 있는 청소년밴드와 직장인 밴드들의 콘텐츠 발표기회, 자생력을 구축시켜주고자 행사를 추진하고 있다. 올해는 아산 신정호 아트밸리에서 “다시 뛰는 아산” Good bye hot summer concert 주제로 13개 밴드팀 공연과 요즘 최고로 유명한 국카스텐 밴드팀을 초청하여 수준높은 공연을 제공하고자 한다.", 
'신정호국민관광지야외음악당', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2833256 , '제7회 전남독서문화한마당 (서書로 통하는 우리)' , 20220916 , 20220917 , '전라남도 나주시 중야2길 26', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/27/2833227_image2_1.jpg', 126.7861585968, 35.0170345358, 6, 38, 6, '061-330-6723', 
'<a href="https://bglib.jne.go.kr/index.es?sid=c7" target="_blank" title="새창 : 전남독서문화한마당">https://bglib.jne.go.kr</a>', "행사의 주제는 '서書로 통하는 우리' 로 책을 통해 공감하고 소통할 수 있는 모두가 즐기는 독서문화축제이다. 행사는 크게 책마당, 사람마당, 도서관마당으로 이루어져있다. 책마당에서는 전시, 북마켓, 디지털 북 체험, 인형극으로 구성되어 있으며, 사람마당은 북콘서트, 그림책 상상여행으로 유명 작가들의 강연을 감상할 수 있다. 마지막 도서관 마당은 전남교육청 소속 도서관 외 55개 기관이 참여하는 체험부스에서 독서 관련 체험 프로그램을 체험할 수 있다.", 
'나주시 빛가람호수공원 수변문화마당', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2833186 , '2022 시흥시청소년동아리축제' , 20221022 , 20221022 , '경기도 시흥시 소래산길 11 시흥ABC행복학습타운', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/74/2833174_image2_1.JPG', 126.7853863703, 37.4489033560, 6, 31, 14, '031-315-1890(내선2)', 
'<a href="http://www.shyouth.or.kr/" target="_blank" title="새창 : 2022 시흥시청소년동아리축제\'적Show\'">www.shyouth.or.kr</a>', "시흥시청소년동아리축제는 자기주도적인 청소년동아리 활동을 활성화하고 청소년동아리와 지역사회의 소통, 교류, 참여의 장으로써 시흥시 관내 사회참여, 봉사, 수학, 스포츠, 댄스, 밴드 등 다양한 분야의 360여개 동아리가 만들어가는 전국 최대 규모의 청소년 축제이다.", 
'ABC 행복학습타운', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2833084 , '아산시 물총페스티벌 ‘적Show’' , 20220821 , 20220821 , '충청남도 아산시 온천대로 1496 온양온천역', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/74/2833074_image2_1.jpg', 127.0035044825, 36.7805372863, 6, 34, 9, '070-4242-4545', 
'<a href="https://afesta.modoo.at/" target="_blank" title="새창 : 아산시 물총페스티벌 \'적Show\'">https://afesta.modoo.at</a>', "물총페스티벌 ‘적Show’는 아산시가 후원하고 협동조합 와트(WATT)가 주관하는 사업으로, 주관단체가 마을축제 명소화 지원사업으로 선정돼 개최된다.<br>‘적Show’는 시민이 직접 참여하고 협업하는 놀이형태의 행사로 코로나19로 지친 시민의 몸과 마음을 회복하고자 준비됐다.<br>온양온천역에서 개최될 물총페스티벌 ‘적Show’는 다채로운 프로그램으로 채워진다.", 
'온양온천역 광장', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2833059 , '2022 서울거리공연 [버스커페스티벌]' , 20220826 , 20220828 , '서울특별시 용산구 양녕로 445', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/51/2833051_image2_1.jpg', 126.9580520415, 37.5177178854, 6, 1, 21, '02-332-2965', 
'<a href="https://www.seoulbusking.com/" target="_blank" title="새창 : 2022 서울거리공연 [버스커페스티벌]">www.seoulbusking.com</a>', "다양한 아티스트! 다양한 구성의 다양한 공연!<br>버스커콘서트와 노들섬 다양한 공간에서의 거리공연<br>(노들스퀘어 / 뮤직라운지'류' /노들서가 루프탑, 테라스)", 
'노들섬', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2833003 , '2022 유성 재즈&맥주페스타' , 20220819 , 20220820 , '대전광역시 유성구 어은로 27 유림공원 관리사', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/93/2833093_image2_1.jpg', 127.3577063021, 36.3607306283, 6, 3, 4, '042-611-2080', 
'<a href="http://ysfesta.com/" target="_blank" title="새창 : 2022 유성 재즈&맥주페스타 ">http://ysfesta.com</a>', "유성온천문화축제의 계절별 분산개최 방안으로 개최되는 2022 유성 재즈&맥주페스타는 한여름밤 재즈음악회와 수제맥주가 어우러지는 고품격 여름문화행사이다.", 
'유림공원(잔디광장)', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2832761 , '2022 서울뷰티위크' , 20220930 , 20221002 , '서울특별시 중구 을지로 281', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/60/2832760_image2_1.jpg', 127.0095709797, 37.5661076320, 6, 1, 24, '02-550-2547 서울뷰티위크 운영사무국', 
'서울뷰티위크 <a href="https://seoulbeautyweek.or.kr/" target="_blank" title="새창 : 2022 서울뷰티위크 홈페이지로 이동">https://seoulbeautyweek.or.kr</a><br>서울시뷰티먼스 <a href="http://www.seoulbeautymonth.or.kr" target="_blank" title="새창 : 서울시뷰티먼스 홈페이지로 이동">www.seoulbeautymonth.or.kr</a>', "올해 처음으로 개최되는 2022 서울뷰티위크는 최신 뷰티 트렌드가 한자리에 모이는 글로벌 뷰티 페스티벌로, 뷰티산업을 활성화하기 위한 다양한 프로그램과 이벤트가 진행된다.<br>'산업의 낮'과 '축제의 밤'으로 구성된 서울뷰티위크는 뷰티산업 활성화를 위한 지원 프로그램 및 뷰티 문화와 한류를 즐길 수 있는 콘텐츠가 제공되어 기업,시민,관광객 누구나 즐길 수 있다.<br>공식 홈페이지를 통한 사전관람신청을 하면 현장방문시 원활한 행사 관람이 가능하다.<br>오는 2022.09.30.금 - 2022.10.02.일 , 서울 동대문디자인 플라자에서 2022 서울뷰티위크를 만나볼 수 있다.", 
'프로그램별 상이', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2832757 , '전주모래내시장 치맥가맥페스티벌' , 20220819 , 20220820 , '전라북도 전주시 덕진구 모래내4길 8-8', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/54/2832754_image2_1.jpg', 127.1438866461, 35.8336092448, 6, 37, 12, '063-278-5802', 
NULL, "3년만에 다시 돌아온 제5회 전주모래내시장 치맥가맥 페스티벌!<br>더욱 맛있어진 치킨과 맥주, 수제맥주, 다양한 안주까지!<br>우리는_지금_치맥이_땡긴다!<br>8월 19일(금)부터 20일(토) 이틀간!<br>무더운 여름 시원하게 날려버리자!", 
'전주모래내시장길 일원', NULL, NULL, '입장료 무료 (치킨, 맥주등 먹거리 구입은 별도)',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2832458 , '2022 시흥 매직페스티벌' , 20220827 , 20220828 , '경기도 시흥시 소래산길 11 시흥ABC행복학습타운', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/41/2832441_image2_1.jpg', 126.7853863703, 37.4489033560, 6, 31, 14, '031-310-2917', 
'<a href="https://blog.naver.com/siheungblog/222836177246" target="_blank" title="새창 : 시흥 매직페스티벌">https://blog.naver.com</a>', "한여름의 꿈, 마술의 세계로 초대한다!<br>마술의 세계가 8월27일부터 28일까지 2일간 ABC 행복학습타운에서 펼쳐진다.<br>특별한 마술사와 함께 즐기는 다양한 공연과 마술체험!<br>갈라쇼, 원맨쇼등 특별공연관람과 딜러쇼, 버블공연, 마임공연 등 마술 버스킹 공연까지 다양한 마술쇼를 경험할 수 있다.<br>트릭아트존 체험, 마술도구 체험, 마술의상 체험 등 체험형 프로그램도 누구나 참여 가능하다.", 
'ABC 행복학습타운', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2832436 , '기라델리 초콜릿 베이킹 경연대회' , 20221028 , 20221028 , '서울특별시 서초구 강남대로 27 AT센터', NULL, 'A02081300', 'http://tong.visitkorea.or.kr/cms/resource/58/2832358_image2_1.jpg', 127.0407514903, 37.4673918780, 6, 1, 15, '02)802-7666/7669', 
'<a href="http://www.kcf90.com" target="_blank" title="새창 : 기라델리 초콜릿 베이킹 경연대회 ">http://www.kcf90.com</a>', "미국에서 가장 오래된 초콜릿 제조사인 [기라델리]의 초콜릿을 활용한 국내 최초의 초콜릿 베이킹 경연대회이다.<br>경연 참가 신청자들에게 기라델리 초콜릿칩 7종, 기라델리 웨이퍼 2종, 기라델리 마제스틱 파우더를 제공하며, 대회 당일 필요한 베이킹 원재료 또한 모두 기라델리의 제품으로 주최에서 제공한다.<br>디저트 분야 전문가들의 다양한 레시피를 통해 국내 디저트 산업 발전에 도움을 주고, 평소 접할 수 없는 색다른 디저트를 접할 수 있는 기회를 제공한다.", 
'서울특별시 서초구 강남대로 27 AT Center 제 1전시장', NULL, NULL, '미정(추후 홈페이지 공지)',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2830836 , '대전 동구 문화재 야행' , 20220826 , 20220828 , '대전광역시 동구 철갑2길 2 대전전통나래관', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/00/2833100_image2_1.jpg', 127.4374054282, 36.3350238727, 6, 3, 2, '042-282-1141', 
'<a href="https://daejeonnigrt.co.kr" target="_blank" title="새창 : 대전 동구 문화재 야행">https://daejeonnigrt.co.kr</a>', "대전의 역사와 문화를 100년이란 시간 동안 간직해온 소제동에서 2022 대전 동구 문화재 야행이란 행사로 새롭게 태어난다. 슬로건은 소제호 달밤 수다로, 한여름 밤 도심 한가운데서 달빛을 받으며 친구, 가족, 연인 간에 특별한 추억을 만들 수 있도록 멋진 공연과 전시, 먹거리와 다양한 프로그램과 이벤트들이 준비되어 있다. 방문객들과 입주민들이 직접 만들고 참여하여 함께하는 행사인 만큼 더욱 보람찬 행사가 될 것으로 기대되며 많은 관심과 참여를 부탁드린다. 올여름 대전 동구 문화재 야행에서 희망찬 미래를 꿈꿔보자.", 
'대전 전통 나래관, 소제동, 대동천일원', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2830569 , '아프리카 아트페어' , 20220720 , 20220831 , '서울특별시 종로구 율곡로 24', NULL, 'A02080700', 'http://tong.visitkorea.or.kr/cms/resource/53/2830553_image2_1.jpg', 126.9820260031, 37.5754393858, 6, 1, 23, '010-4418-9237', 
'인스타그램  <a href="https://www.instagram.com/africart_with/" target="_blank" title="새창 : 아프리카 아트페어">www.instagram.com</a><br>네이버 예약 <a href="https://booking.naver.com/booking/5/bizes/736559" target="_blank" title="새창 : 아프리카 아트페어">https://booking.naver.com</a>', "피카소가 사랑한 아프리카 미술을 한자리에서 감상할 수 있는 아프리카 아트페어<br><br>아프리카아트페어는 아프리카를 대표하는 4인의 작가의 작품들로 구성되어 천재적인 조화 ‘조엘 음파두’, 여럿이 함께라는 테마를 휴머니티로 풀어낸 낙천주의자 ‘헨드릭 릴랑가’, 유목민의 유전자를 동화적으로 풀어내는 색채의 마술사 ‘압두나 카사’, 그리고 아프리카 미술계의 새로운 역사를 연 ‘팅가팅가’의 작품을 감상할 수 있다.<br>아프리카 아트페어는 ‘지금이다 나중은 늦다 NOW OR NEVER’라는 화두를 주로 담고 있는 아프리카 미술을 통해 어떤 문을 열고 닫을 것인가, 어떤 시간을 선택할 것인가를 생각해 볼 수 있는 기회를 제공한다.", 
'도화서길', NULL, NULL, '성인 10,000원, 청소년 8,000원, 5세미만 무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2830526 , '노원탈축제' , 20221008 , 20221009 , '서울특별시 노원구 상계동', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/16/2830516_image2_1.jpg', 127.0627163625, 37.6557537222, 6, 1, 9, '02-2289-3487', 
'<a href="https://maskfesta.kr/" target="_blank" title="새창 : 노원탈축제">https://maskfesta.kr</a>', "[노원탈축제]는 매년 10월 초에 '탈'을 주제로 개최되는 노원의 대표 퍼레이드 축제이며, 서울시 자치구 브랜드 축제이다.<br>탈퍼레이드, 탈패션쇼, 구민합창단 등 직접 참여하며 즐길 수 있는 프로그램들이 진행되며, 개,폐막식 공연과 탈연희퍼포먼스 등 다양한 볼거리 공연도 준비되어있다.<br>또한, 체험플리마켓과 거리공연, 어린이마당 존이 있어, 누구나 즐길 수 있는 축제이다.", 
'노원 문화의거리 앞 도로', NULL, NULL, NULL,NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2829875 , '강원일자리박람회' , 20220914 , 20220928 , '강원도 횡성군 문예로 75 횡성 문화체육공원', NULL, 'A02080600', 'http://tong.visitkorea.or.kr/cms/resource/74/2829874_image2_1.png', 127.9782824672, 37.4907202341, 6, 32, 18, '강원일자리재단 : 033-256-9602<br>운영사무국 : 1644-4845', 
'홈페이지 <a href="https://gwjob.kr/gwjob" target="_blank" title="새창 : 강원일자리박람회">https://gwjob.kr</a><br>인스타그램 <a href="https://www.instagram.com/jobfair_2022/" target="_blank" title="새창 : 강원일자리박람회">www.instagram.com</a><br>페이스북 <a href="https://www.facebook.com/%EA%B0%95%EC%9B%90%EC%9D%BC%EC%9E%90%EB%A6%AC%EB%B0%95%EB%9E%8C%ED%9A%8C-106030628858060" target="_blank" title="새창 : 강원일자리박람회">www.facebook.com</a>', "새로운 강원도! 특별 자치시대!<br>강원도와 손JOB GO 취업 성공하자 2022 강원 일자리박람회는 9월 14일(수) ~ 28일(수) 2주간 진행된다.<br>온·오프라인 하이브리드형 박람회로 강원일자리정보망 채용관을 통해 참기 기업을 확인 할 수 있으며, 횡성, 강릉, 춘천, 원주 그리고 온라인 메타버스에서 박람회를 만날 수 있다.", 
'온라인 메타버스 박람회 : 2022.09.15(목) ~ 09.17(토)<br>오프라인 박람회<br>횡성 국민 체육센터 - 09.14(수)<br>강릉 아이스아레나 - 09.19(월)<br>춘천 춘천농협농수산물종합유통센터 - 09.23(금)<br>원주 국민체육센터 - 09.28(수)', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2829592 , '렛츠런파크 서울 여름 수국축제' , 20220730 , 20220821 , '경기도 과천시 경마공원대로 107', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/90/2829590_image2_1.jpg', 127.0086495110, 37.4441273360, 6, 31, 3, '1566-3333', 
'<a href="https://park.kra.co.kr/seoul_main.do" target="_blank" title="새창 : 렛츠런파크 서울 2022년 여름 수국축제 <수국 산책>">https://park.kra.co.kr</a>', "렛츠런파크 서울 2022 여름 수국축제를 개최한다. 산책로 곳곳에 마련된 포토존으로 인생샷을 찍을 수 있으며 플라워 카페, 일회용 타투 체험 등 다양한 이벤트 부스를 즐길 수 있다. 또한, 푸드트럭 존에서 빙수, 아이스크림을 구매할 수 있으며 주말 저녁에는 인디 뮤지션들의 버스킹 공연도 진행된다.", 
'렛츠런파크 서울', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2829143 , '2022 김해시복지박람회' , 20220923 , 20220924 , '경상남도 김해시 분성로261번길 35 김해민속박물관', NULL, 'A02080600', 'http://tong.visitkorea.or.kr/cms/resource/37/2829137_image2_1.jpg', 128.8759611362, 35.2350661468, 6, 36, 4, '055-336-2400', 
'<a href="https://www.gowf.co.kr/index.html" target="_blank" title="새창 : 김해시복지박람회 ">http://www.ghwf.or.kr</a>', "1. 다양한 스마트 복지를 소개 및 연계한 미래지향적 스마트 복지박람회 추진<br>2. 사회복지 기관 연계 다양한 공동행사 및 부대행사 운영<br>3. 시민중심의 나눔 및 기부문화 정착을 위한나눔 바자회 행사 진행<br>4. 코로나 19에 따른 온오프라인 병행 복지박람회 추진", 
'김해시수릉원', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2829118 , '시민창작예술축제 <학산마당극\'놀래\'>' , 20221015 , 20221028 , '인천광역시 미추홀구 인하로 126 학산소극장', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/14/2829114_image2_1.jpg', 126.6618920537, 37.4495594272, 6, 2, 3, '032-866-3994', 
'<a href="https://www.haksanculture.or.kr" target="_blank" title="새창 : 시민창작예술축제 <학산마당극\'놀래\'> ">www.haksanculture.or.kr</a>', "마을, 이웃, 우리의 이야기가 작품이 되어 무대에서 펼쳐진다!<br>2014년에 시작된 학산마당극놀래는 시민들이 직접 만들고 즐기는 대표적인 시민창작예술축제이다. 주민들이 마을에서 모여 문화로 소통하며 지역의 이슈나 삶의 이야기를 담아 창작한 작품을 이웃과 나누는 신명나는 마당으로, 예술적 표현의 다양한 형식을 넘나드는 장(場)으로 거듭나고 있다. 모두 함께 즐기고 나누는 축제를 위해 주민과 예술가, 관련 단체 및 기관 등이 연대하여 공동체 예술의 성장과 지역문화의 발전을 이루어 가고 있다.", 
'수봉공원 인공폭포 앞 야외마당', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2828692 , '2022 유니버설디자인 공감주간' , 20220820 , 20220828 , '부산광역시 부산진구 시민공원로 73 부산시민공원', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/88/2828688_image2_1.png', 129.0572361352, 35.1654495102, 6, 6, 7, '02-3433-0777', 
'<a href="https://www.koddi.or.kr/ud" target="_blank" title="새창 : 유니버설디자인 공감주간">https://www.koddi.or.kr</a>', "올해 여름 부산에서 만나는 편안한 유니버설디자인 휴식공간! 유니버설디자인이란(이하 UD) 성별, 연령, 국적, 장애유무 등에 관계없이 누구나 제품, 환경, 서비스 등을 편리하고 안전하게 이용할 수 있도록 하는 디자인 개념이다. 한국장애인개발원은 시민들과 유니버설디자인에 대한 정보를 공유하고 공감대를 형성하고자, '모두가 누리는 휴식'을 주제로 오는 8월 20일부터 8월 28일까지 부산시민공원에서 국제세미나 및 전시·체험을 운영한다.", 
'부산시민공원(다솜관, 백산홀)', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2828537 , '2022 대구 떡볶이 페스티벌' , 20220827 , 20220827 , '대구광역시 북구 고성로 191', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/36/2828536_image2_1.jpg', 128.5867964789, 35.8804436428, 6, 4, 5, '053-665-2172', 
'<a href="https://www.instagram.com/daegu_tteokbokki/" target="_blank" title="새창 : 2022 대구 떡볶이 페스티벌">www.instagram.com</a>', "1. 10대부터 60대까지 떡볶이와 함께한 우리들의 이야기를 담고, 느끼고, 즐기는 축제이다.<br>2. 대구 북구 및 대구 전 지역의 맛집 떡볶이를 시식할 수 있는 떡볶이 ZONE이 있다.<br>3. 그 시절 추억의 떡볶이집 DJ를 연상시키는 떡페 DJ부스와 여름의 마지막 밤을 화끈하게 보낼 EDM DJ 파티를 구성하였다.<br>4. 떡볶이를 주제로 재미있게 놀 수 있는 체험 참여 프로그램이 많이 준비되어 있다.<br>5. 먹거리, 공연, 체험과 더불어 다채로운 볼거리 제공할 수 있는 프리마켓 및 협찬 부스를 구성하였다.", 
'DGB 대구은행파크 중앙광장', NULL, NULL, '유료<br>현장 결제, 대구 떡볶이 페스티벌 공식 SNS에 업로드 된 게시물 리그램을 통한 할인쿠폰 발급 예정',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2828336 , '시흥월곶포구축제' , 20221021 , 20221023 , '경기도 시흥시 월곶중앙로 37-1', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/88/2852388_image2_1.jpg', 126.7408199144, 37.3876152382, 6, 31, 14, '031)318-4061', 
'<a href="https://www.siheung.go.kr/portal/contents.do?mId=0801010900" target="_blank" title="새창 : 월곶포구축제">www.siheung.go.kr</a>', "2021년 경기문화관광축제로 선정된 월곶포구축제는 10월 21일부터 23일까지 3일간 개최되며, 바다와 도시가 어우러진 월곶만의 지역적 특색을 살려 포구 특성과 도시 풍경을 접목한 다양한 체험 프로그램을 운영한다. 대표프로그램으로는 ▲어선승선체험, ▲맨손고기잡이체험, ▲왕새우잡이체험, ▲새우젓담그기체험 ▲어구전시행사 등이 있다. 또한 태권트롯 나태주, 트로트 신동 김태연, 트로트의 신 김연자와 남진, 박영수 등 감동이 있는 초대가수 공연과 포구의 다양한 해산물을 활용한 풍부한 먹거리, 밤하늘을 화려하게 수놓은 불꽃놀이, 플리마켓 운영 등 남녀노소가 즐길 수 있는 다채로운 행사가 축제장 곳곳에서 펼쳐질 예정이다.", 
'월곶포구 미래탑공원 및 해안가 일원', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2827828 , 'K-Metaverse Festival & K-Metaverse Expo 2022' , 20221013 , 20221015 , '서울특별시 강남구 영동대로 513 코엑스', NULL, 'A02080600', 'http://tong.visitkorea.or.kr/cms/resource/59/2827859_image2_1.jpg', 127.0592179950, 37.5119175967, 6, 1, 1, '02-6000-4279', 
'<a href="https://www.kmetaverseexpo.com:492/seoul/" target="_blank" title="새창 : K-Metaverse Festival & K-Metaverse Expo 2022">www.kmetaverseexpo.com</a>', "10월 서울 코엑스에서 개최되는 \"K-Metaverse Festival & K-Metaverse Expo 2022\"는 여러 산업분야와 융합된 메타버스 콘텐츠 및 지역특화 콘텐츠, NFT, VFX, 디지털트윈 기술 등 다양한 메타버스 관련 기술들과 국내외 메타버스 최신 동향을 만나볼 수 있는 메타버스 전문 전시회이다.", 
'서울 코엑스 1층 B 홀 전관', NULL, NULL, NULL,NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2827820 , '대한민국 4차산업혁명 페스티벌 2022' , 20220915 , 20220917 , '서울특별시 강남구 영동대로 513 코엑스', NULL, 'A02080600', 'http://tong.visitkorea.or.kr/cms/resource/19/2827819_image2_1.jpg', 127.0592179950, 37.5119175967, 6, 1, 1, '02-6000-4290', 
'<a href="http://www.4thfestival.net/Home/Main" target="_blank" title="새창 : 대한민국 4차산업혁명 페스티벌">www.4thfestival.net</a>', "국내 디지털 대전환을 선도하는 \"대한민국 4차산업혁명 페스티벌 2022\"는 4차 산업혁명의 핵심기술인 AI와 빅데이터 뿐만 아니라 메타버스&NFT, 디지털 헬스케어, 미래 혁신 교통수단(드론, 로봇, 자율주행차, 전기차 등), 코로나 펜더믹 이후 새로운 소비 트렌드로 자리잡은 구독경제 등 다양한 4차 산업혁명 관련 분야들과 최신 기술 트렌드를 만나볼 수 있는 전문 산업 박람회이다.", 
'서울 코엑스 B홀', NULL, NULL, NULL,NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2827675 , 'K-Metaverse Expo Busan 2022' , 20220818 , 20220820 , '부산광역시 해운대구 APEC로 55 벡스코', NULL, 'A02080600', 'http://tong.visitkorea.or.kr/cms/resource/46/2828346_image2_1.jpg', 129.1355209016, 35.1687450332, 6, 6, 16, '02-6000-4279', 
'<a href="https://www.kmetaverseexpo.com:492/busan/" target="_blank" title="새창 : K-Metaverse Expo Busan 2022">www.kmetaverseexpo.com</a>', "메타버스 산업 HUB 부산에서 최초로 개최되는 대한민국 대표 메타버스 전시회 \"K-메타버스 엑스포\"는 블록체인&NFT, CG/VFX, 메타버스 서비스 요소기술 뿐만 아니라 다양한 산업분야의 메타버스 생태계를 경험할 수 있는 자리이다.", 
'부산 벡스코 제1전시장', NULL, NULL, NULL,NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2827632 , '2022 <슬기로운 방학생활: 아세안>' , 20220819 , 20220821 , '부산광역시 해운대구 좌동로 162 아세안문화원', NULL, 'A02081300', 'http://tong.visitkorea.or.kr/cms/resource/16/2827616_image2_1.jpg', 129.1820750100, 35.1751757315, 6, 6, 16, '051-775-2034', 
'<a href="https://www.ach.or.kr/ach/main.do" target="_blank" title="새창 : 2022 <슬기로운 방학생활: 아세안> ">www.ach.or.kr</a>', "한국국제교류재단이 운영하는 아세안문화원은 여름방학을 맞은 초등학생들을 위해 <슬기로운 방학생활: 아세안>을 준비했다.<br>부산에서 아세안 나라를 경험할 수 있다.<br>동 프로그램은 체험 중심의 교육, 놀이, 강연 등을 통해 아세안 10개 회원국에 대한 이해 증진을 목적으로 한다.", 
'아세안문화원', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2827060 , '제5회 무중력영화제(MUFF)' , 20220916 , 20220917 , '서울특별시 양천구 오목로 359 무중력지대 양천', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/59/2827059_image2_1.png', 126.8773230917, 37.5246489705, 6, 1, 19, '02-2646-2030', 
'홈페이지 <a href="https://youth.seoul.go.kr/site/youthzone/center/CT00008/intro" target="_blank" title="새창 : 제5회 무중력영화제(MUFF)">https://youth.seoul.go.kr</a><br>인스타그램 <a href="https://www.instagram.com/youthzone_muff/" target="_blank" title="새창 : 제5회 무중력영화제(MUFF)">www.instagram.com</a><br>블로그 <a href="https://blog.naver.com/youthzone0_0" target="_blank" title="새창 : 제5회 무중력영화제(MUFF)">https://blog.naver.com</a><br>페이스북 <a href="https://www.facebook.com/youthzone3" target="_blank" title="새창 : 제5회 무중력영화제(MUFF)">www.facebook.com</a><br>유튜브 <a href="https://www.youtube.com/channel/UCroz39rvXjicL8SQedEQZMA" target="_blank" title="새창 : 제5회 무중력영화제(MUFF)">www.youtube.com</a>', "서울특별시 청년공간 무중력지대 양천은 2018년부터 매년 무중력영화제(MUFF)를 개최하고 있다. MUFF는 MUjungryuck Film Festival의 줄임말로, 청년들이 영화제 기획과 운영을 맡으며, 출품작 또한 청년 영화인들의 작품으로 채워지는 청년 영화제이다. 무중력영화제는 앞으로 한국 영화계를 이끌어 나갈 청년 영화인들의 훌륭한 작품을 미리 선보이고, 그들이 서로 활발하게 소통할 수 있는 교류의 장을 마련하고 있다. 2020년부터는 개막작은 화면을 음성으로 설명해주는 화면해설과 화자, 대사, 음악, 소리정보를 알려주는 자막을 넣은 가치봄영화로 상영하고, 나머지 상영작에는 한글 자막을 넣어 상영하여 누구나 함께 할 수 있는 축제의 장을 만들기 위해 노력하고 있다.<br>제5회 무중력영화제는 9월 16일(금)부터 17일(토)까지 메가박스 목동에서 \"찬란할 내일의 우리에게\"라는 슬로건으로 진행되며, '함께', '공존', '상생'의 주제를 담은 10편의 작품을 상영한다.", 
'메가박스 목동', NULL, NULL, '개막작 관람 : 3,000원<br>섹션1, 2, 3 : 5,000원',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2826992 , '제 4회 대구데이 페스티벌' , 20220819 , 20220820 , '대구광역시 수성구 동대구로14길 14', NULL, 'A02070200', NULL, 128.6249998794, 35.8369631583, 6, 4, 7, '053-763-1908', 
'<a href="http://ea2005.org/html/" target="_blank" title="새창 : 제 4회 대구데이 페스티벌">http://ea2005.org</a>', "2019년 부터 시작된 대구데이페스티벌은 대구의 다양한 문화를 7가지 주제 (볼거리,먹거리,놀거리,팔거리,잠잘거리,탈거리,느낄거리)로 나누어 각 주제별로 공연, 전시, 체험 등 다양한 콘텐츠로 구성한 대구의 모든 것을 담은 대구의 축제이다. 특히 대구의 역사, 인물, 예술을 소재로 영상, 음악, 춤, 퍼포먼스가 어우러진 스토리텔링형 융복합 주제공연 ‘대구를 잇다’와 ‘대구, 이곳은’ 은 
대구의 서사를 한 번에 담아낸 감동적인 공연이다.<br>또한 올 해는 청소년 댄스 경연대회 ‘코리아 유스 댄스 챔피언쉽’ 이 총상금 1,020만원 규모의 대형이벤트로 처음 개최되어 전국에 있는 청소년 춤꾼들의 많은 관심과 참가가 예상되며 이 외에도 납작만두, 치킨 등 대구를 대표하는 먹거리와 주제관, 체험관 등 재미와 힐링이 가득한 풍성한 프로그램으로 진행된다.", 
'대구시 수성구 수성못 상화동산', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2826964 , '2022 Groove In Gwanak STREETDANCE FESTIVAL' , 20220716 , 20220831 , '서울특별시 관악구 관천로 53', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/47/2826947_image2_1.jpg', 126.9257892588, 37.4841656500, 6, 1, 5, '02-828-5763', 
'<a href="https://www.instagram.com/groove_in_gwanak/" target="_blank" title="새창 :  2022 Groove In Gwanak STREETDANCE FESTIVAL">www.instagram.com</a>', "관악을 움직이다 - Groove in Gwanak<br>특별히 열정적인 댄서들이 모인 스트릿댄스 페스티벌이 2022년 여름, 관악구 도림천(별빛내린천)을 꾸민다. 한때 청년들의 거리문화로 치부되었던 스트릿댄스 장르는 최근 방송 매체와 여러 플랫폼을 통해 그 대중성과 예술성을 인정받고 있다. 이에 발 맞추어 관악에서 처음으로 스트릿댄스를 독립적인 현대 문화 예술로 바라보고 그들의 열정을 마음껏 표현할 수 있는 축제를 마련했다.<br>2022년 7월 16일 토요일, 그 첫 무대가 여러분을 찾아간다.", 
'신림역 인근 별빛내린천, S1472관천로문화플랫폼', NULL, NULL, '관람료 전액 무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2826731 , '해비치 스타라이트 드론쇼' , 20220902 , 20220912 , '제주특별자치도 서귀포시 민속해안로 537', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/71/2844271_image2_1.jpg', 126.8447799096, 33.3206636168, 6, 39, 3, '064-780-8100', 
'<a href="https://www.haevichi.com/jeju/ko/offers/event/detail/20220823105724361004" target="_blank" title="새창 : 해비치 스타라이트 드론쇼">www.haevichi.com/jeju</a>', "해비치호텔앤드리조트 제주에서 열리는 '해비치 스타라이트 드론쇼'는 100대의 드론이 동원되는 쇼이다.<br>제주의 밤하늘을 수놓을 드론쇼로, 제주 동부지역 야간 관광 볼거리를 제공 할 예정이다.<br>'제주에서만 볼 수 있는 자연환경' 및 '제주 여행 중 경험하는 풍경과 에피소드'를 주제로 펼쳐질 예정이다.<br>▶9월 2일부터 9월 12일까지◀ 11일간 매일밤 해비치 리조트 잔디광장에서 총 20회 진행되는 공연이다.<br>기상 상황에 따라 예고 없이 일정이 변경 또는 취소될 수 있다.", 
'해비치 호텔앤드리조트 제주', NULL, NULL, '관람 무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2826640 , '2023 새만금 제25회 세계스카우트잼버리' , 20230801 , 20230812 , '전라북도 부안군 신재생에너지로 28 컨벤션센터', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/37/2826637_image2_1.jpg', 126.5969913140, 35.7112554693, 6, 37, 6, '063-581-8309', 
'<a href="https://www.2023wsjkorea.org/" target="_blank" title="새창 : 2023 새만금 제25회 세계스카우트잼버리">www.2023wsjkorea.org</a>', "세계스카우트잼버리는 세계스카우트연맹에서 주최하는 가장 큰 스카우트 국제행사로서, 전 세계적인 청소년 야영활동이다. 본 행사는 전 세계 회원국 5만여 명 이상의 청소년 및 지도자자들이 참가하여 인종, 종교, 이념, 문화의 차이를 뛰어넘어 문화교류 및 우애를 자니는 세계 최고의 청소년 국제 행사이다.세계스카우트잼버리는 매 4년마다 스카우트 회원국을 돌며 개최되며, 3년마다 개최되는 세계스카우트총회에서 회원국 대표의 투표를 통해 개최지를 결정한다.", 
'새만금 관광레저용지 제1지구', NULL, NULL, NULL,NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2826119 , '2022 제2회 춘천술페스타' , 20221007 , 20221008 , '강원도 춘천시 스포츠타운길399번길 25 KT&G상상마당 춘천아트센터', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/94/2849894_image2_1.jpg', 127.7021517672, 37.8735012283, 6, 32, 13, '1644-4845', 
'홈페이지 <a href="http://www.ccsool.co.kr/" target="_blank" title="새창 : 2022 제2회 춘천술페스타">www.ccsool.co.kr</a><br>인스타그램 <a href="https://www.facebook.com/%EC%B6%98%EC%B2%9C-%EC%88%A0-%ED%8E%98%EC%8A%A4%ED%83%80-109269715152584" target="_blank" title="새창 : 2022 제2회 춘천술페스타">www.instagram.com</a><br>페이스북 <a href="https://www.instagram.com/chuncheon_sool_festa/" target="_blank" title="새창 : 2022 제2회 춘천술페스타">www.facebook.com</a>', "우리 쌀 소비 촉진과 전통주 인식 개선을 위한 춘천 지역 전통주 페스티벌이다.<br>6월부터 10월까지 춘천 곳곳에서 사전행사가 진행되고 10월 7일~8일에는 본행사가 진행된다.", 
'KT&G 상상마당 춘천', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2826051 , '2022 한옥자원활용 야간상설공연 남원창극 “가인춘향”' , 20220514 , 20220924 , '전라북도 남원시 월매길 12', NULL, 'A02080100', 'http://tong.visitkorea.or.kr/cms/resource/49/2826049_image2_1.jpg', 127.3808851544, 35.4034538163, 6, 37, 4, '063)636-1855', 
'<a href="http://www.seomjingang.co.kr/" target="_blank" title="새창 : 한옥자원활용 야간상설공연 남원창극 "가인춘향"">http://www.seomjingang.co.kr/</a>', "남원창극 가인춘향은 기존의 특정 바디소리나 스토리에 연연하지 않고 모든 바디소리의 창본 및 다양한 소설 춘향전에서 스토리를 채택하고 새로운 상상력을 발휘하여 그간 잘 알려져 있지 않았던 춘향전의 이본 이야기를 적극 활용하여 작품도의 신선도를 높이고 극 진행을 위해 스토리의 연결고리 또는 진행과정을 현대적 기법을 활용하여 간략하면서도 담백하게 구성하여 판소리의 백미를 만끽할 수 있는 작품의 수준 높은 창극 공연이다.
*우천 시 취소 된 공연으로 인해 9월 24일 연장 공연 진행합니다. 9월 16일(금)에도 공연을 진행하니 많은 관심 부탁드립니다.", 
'화인당 야외공연장<br>(우천취소 시 공연일정 연장)', NULL, NULL, '일반 10,000 / 인터넷예매(인터파크) 5,000 / 남원시민 5,000 / 청소년,어린이 5,000 / 문화누리카드 5,000',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2825667 , '이탈리아마을 제2회 베니스가면축제' , 20220701 , 20220831 , '경기도 가평군 호반로 1063 쁘띠프랑스', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/66/2825666_image2_1.jpg', 127.4909256481, 37.7150574078, 6, 31, 1, '031-584-8200', 
'<a href="http://www.pfcamp.com/#__90501__item3" target="_blank" title="새창 : 베니스가면축제">www.pfcamp.com</a>', "가평에 위치한 국내 유일의 이탈리아 마을 ‘피노키오와 다빈치’는 말 그대로 전 세계적으로 유명한 피노키오와 레오나르도 다빈치를 주요 컨텐츠로 하는 문화 테마파크이다. 다가오는 여름을 맞이하여 귀여운 말썽꾸러기 ‘피노키오’와 세계 10대 축제 중 하나로 손꼽히는 이탈리아 베니치아의 가면을 주요 테마로 행사를 진행한다. 행사 제목은 ‘이탈리아마을 제2회 베니스가면축제’ 이다.", 
'쁘띠프랑스', NULL, NULL, '유료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2825580 , '2022 대전 세계지방정부연합(UCLG) 총회' , 20221010 , 20221014 , '대전광역시 유성구 엑스포로 107 대전컨벤션센터', NULL, 'A02081300', 'http://tong.visitkorea.or.kr/cms/resource/77/2825577_image2_1.jpg', 127.3916945410, 36.3750212633, 6, 3, 4, 'daejeon2022uclg@gmail.com', 
'<a href="https://daejeon2022uclg.kr/fairDash.do?hl=KOR" target="_blank" title="새창 : 2022 대전 세계지방정부연합(UCLG) 총회">https://daejeon2022uclg.kr</a>', "UCLG 총회는 스페인 바르셀로나에 위치한 UCLG 세계사무국이 주관하는 회의이며, 전 세계 지방정부 간 협력 증진 및 글로벌 과제 해결, 전문가 및 시민과의 정보와 아이디어 공유 및 확산 및 향후 방향성을 설정하기 위해 각국 지방정부 수장들이 한데 모이는 대규모의 행사이다.<br><br>3년마다 개최되는 총회는 올해로 7회 차를 맞이한다.<br>시민 공모로 선정된 ‘위기를 이겨내고 미래로 나아가는 시민의 도시’라는 주제 하에 개최되는 이번 행사에서는, ‘대전 트랙’ 이라는 특별한 회의를 통해 도시외교를 선도하는 대전의 모습을 만날 수 있을 것이다.<br>또한 총회 기간 동안의 기조강연, 대륙 별 회의, 집행이사회, 세계이사회, 주제별 토론 등의 다양한 형태의 회의는 궁극적인 목표 달성을 위한 원활한 논의가 가능하게 할 것이며 스마트시티 전시회, K-POP 콘서트 등 30개가 넘는 이색적인 행사들을 통해서는 대전의 매력을 가득 느낄 수 있을 것이다.<br>2022 대전 UCLG 세계총회 그리고 전세계 140개국의 참가자와 시민이 함께 즐길 수 있는 세계 축제에 많은 관심과 참여 바란다.", 
'대전컨벤션센터(DCC)', NULL, NULL, '홈페이지 등록 안내 참고',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2825283 , '제1회 어쩌다 연극 페스티벌' , 20220801 , 20220830 , '서울특별시 종로구 창경궁로 254 동원빌딩', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/82/2825282_image2_1.jpg', 126.9999657976, 37.5838054019, 6, 1, 23, '010-2684-3843', 
NULL, "2022년 제1회를 맞는 '어쩌다 연극' 페스티벌은 예술가로서 새로운 것에 대한 도전과 예술관, 세계관, 가치관을 펼칠 수 있는 창작의 장, 예술가의 놀이터로 자리매김하고자 한다. 매년 새로운 주제를 선정해 다양한 시선으로 마음껏 표출하되, 자유를 표방하다 오히려 자유에 구속이 되는 것을 지양하는 [어쩌다 연극] 페스티벌은 '고전을 비틀다'라는 슬로건으로 2022년 8월, 4명의 연출가들이 모여 셰익스피어의 4대 비극을 선보인다.", 
NULL, NULL, NULL, '전석 30,000원',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2824865 , '프리미엄 맥주축제' , 20220817 , 20220821 , '경기도 고양시 일산동구 호수로 595 고양꽃전시관', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/64/2824864_image2_1.jpg', 126.7689209714, 37.6553373919, 6, 31, 2, '070-7954-3088', 
'홈페이지 <a href="https://beer-festival.kr/" target="_blank" title="새창 : 프리미엄 맥주축제">https://beer-festival.kr</a><br>인스타그램 <a href="https://www.instagram.com/gbeerfestivals/" target="_blank" title="새창 : 프리미엄 맥주축제">https://www.instagram.com/gbeerfestivals/</a><br>페이스북 <a href="https://www.instagram.com/gbeerfestivals/" target="_blank" title="새창 : 프리미엄 맥주축제">www.instagram.com/gbeerfestivals</a>', "2022 프리미엄 맥주축제는 뜨거운 여름, 전국민이 사랑하는 맥주와 음악을 접목시킨  초대형 페스티발로 국내 유명가수, 트롯트, 힙합, 인디뮤지션부터 EDM DJ파티까지~<br>다채로운 장르 공연과 함께, 탁트인 공원에서 기분 좋게 취하고 , 기분 좋게 즐기자!", 
'고양꽃전시관 야외무대', NULL, NULL, '사전등록 : 15,000원 (2022년 8월 16일(화)까지 등록시)<br> 현장등록 : 20,000원',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2824857 , '2022 괴산세계유기농산업엑스포' , 20220930 , 20221016 , '충청북도 괴산군 임꺽정로 113', NULL, 'A02080600', 'http://tong.visitkorea.or.kr/cms/resource/56/2824856_image2_1.jpg', 127.7834944865, 36.8147417924, 6, 33, 1, '043-219-6622', 
'<a href="https://2022gosean-organic.co.kr" target="_blank" title="새창 : 2022 괴산세계유기농산업엑스포">https://2022gosean-organic.co.kr</a>', "o 주제 : 유기농이 여는 건강한 세상<br>o 기간 : 2022. 9.30.~10.16<br>o 장소 : 충북 괴산군 유기농엑스포 광장 일원<br>o 주최 : 충청북도, 괴산군, IFAOM(국제유기농국제본부)<br>o 주관 : 2022 괴산세계유기농산업엑스포 조직위원회", 
'충북 괴산군 유기농엑스포 광장 일원', NULL, NULL, 'o 일반(19~64세) 10,000원<br>청소년(13~18세) 8,000원<br>어린이(4~12세) 4,000원<br>* 단체관람(15명 이상) 2,000원 할인',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2824778 , '광화원 도심 속 미디어 정원' , 20220114 , 20231231 , '서울특별시 종로구 사직로 130 3호선 경복궁역', NULL, 'A02080700', 'http://tong.visitkorea.or.kr/cms/resource/67/2824867_image2_1.jpg', 126.9730879153, 37.5759169480, 6, 1, 23, '02-2068-1176', 
'<a href="https://www.gwanghwasidae.kr/playground" target="_blank" title="새창 : 광화원 도심 속 미디어 정원">www.gwanghwasidae.kr</a>', "팬데믹 시대에 5G 기술은 우리에게 단순히 편리함을 주는 수단이 아니라, 바삐 오가는 답답한 일상 가운데 쉼을 주는 따스한 빛으로 다가온다. 시원한 바람이 부는 바다로 데려다주기도 하고, 다시 힘을 낼 수 있는 위로의 말을 건네기도 하며, 변화하는 자연의 생명력을 느낄 수도 있다. 이 모든 것을 가능하게 하는 힐링의 빛으로 연결해 주는 정원, 광화원에서 함께 산책해보자.<br>광화문은 조선시대에서부터 현재에 이르기까지 국내외 많은 사람들을 연결해주는 장소이다. 광화원은 광화문과 기술의 연결성을 빛으로 이어 몰입형 미디어 아트 전시로 재해석하였다. 5G 기술이라는 빛은 광화문과 함께 시간과 공간을 초월해 전세계의 과거와 현재, 그리고 미래가 연결된다. 이렇게 하나로 연결된 빛은 자연과 사람을 연결하고, 전세계 도시와 사람을 연결해 하나가 되어 광화원으로 모인다. 실시간으로 변화하는 정원 속 빛의 풍경을 느끼며, 우리들의 삶 속에 연결되어 있는 관계에 대해 고요히 돌아보는 명상의 시간을 가질 수 있게 한다.", 
'서울메트로미술관 2관', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2824374 , '2022 목포 뮤직플레이' , 20220930 , 20221002 , '전라남도 목포시 남농로 135 목포자연사박물관', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/59/2824359_image2_1.jpg', 126.4210768521, 34.7937647574, 6, 38, 8, '061-270-8991/8992/8654', 
'<a href="http://www.mokpomusicplay.com/main.php" target="_blank" title="새창 : 목포 뮤직플레이">www.mokpomusicplay.com</a>', "「2022 목포 뮤직플레이」는 음악의 도시로 도약하는 목포에서 올해 최초로 개최하는 목포만의 뮤직 페스티벌이다. 뮤직 플레이(Music Play)는 [Play : 놀다, 재생하다 등] 다양한 의미에서 목포와 음악을 즐기자는 뜻을 함축하고 있다. 목포는 가수 이난영을 비롯해 김시스터즈, 남진, 김경호, 슈퍼주니어 동해, 갓세븐 영재 등 과거에서 현재에 이르기까지 우리나라 대표적 대중음악 가수를 배출한 대중음악의 본거지이다. 이러한 음악전 자산을 토대로 지금까지 볼 수 없었던 새로운 형태의 음악축제를 오는 2022년 9월 30일부터 10월 2일까지 목포 갓바위문화타운 일원에서 개최한다.", 
'목포 갓바위문화타운 일원', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2824176 , 'MBC 강변가요제 뉴챌린지' , 20220903 , 20220903 , '강원도 원주시 소금산길 12', NULL, 'A02081300', 'http://tong.visitkorea.or.kr/cms/resource/72/2824172_image2_1.jpg', 127.8340575195, 37.3646293574, 6, 32, 9, '02-789-0011', 
'홈페이지 <a href="https://riversidesong.com/" target="_blank" title="새창 : MBC 강변가요제 뉴챌린지">https://riversidesong.com/</a><br>인스타그램 <a href="https://www.instagram.com/mbc_riversidesong/" target="_blank" title="새창 : MBC 강변가요제 뉴챌린지">www.instagram.com/mbc</a><br>트위터 <a href="https://www.twitter.com/riversidesong/" target="_blank" title="새창 : MBC 강변가요제 뉴챌린지">www.twitter.com/riversidesong/</a><br>방송사 홈페이지(MBC) <a href="https://program.imbc.com/riversidesong" target="_blank" title="새창 : MBC 강변가요제 뉴챌린지">https://program.imbc.com</a>', "MBC 강변가요제가 뉴챌린지로 다시 돌아왔다. 강변가요제는 싱어송라이터들의 창작곡으로 실력을 겨루는 노래경연으로, 스타의 산실이자 신인 등용문으로서 수많은 스타들을 배출해왔다. 이번 가요제 참가자 모집은 5월 30일부터 6월 30일까지 진행, 심사와 멘토링을 거쳐 9월 3일 원주 간현관광지 야외무대에서 진행될 본선 경연에 진출할 12팀을 가릴 예정이다. 강변가요제 수상자들에게는 총 1억원의 상금과 음원 발매 기회가 제공될 예정이다.<br>MBC 강변가요제 뉴챌린지는 싱어송라이터들이 본인의 창작곡으로 자신의 끼를 마음껏 발산하며, 코로나에 지친 관객들에게도 새로운 활력을 불어넣어주는 기회가 될 것이다.", 
NULL, NULL, NULL, NULL,NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2823604 , 'VACATION IN SNOOPY GARDEN' , 20220609 , 20220831 , '제주특별자치도 제주시 금백조로 930', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/96/2823596_image2_1.jpg', 126.7786189466, 33.4434017790, 6, 39, 4, '064-1899-3929', 
'홈페이지 <a href="http://www.snoopygarden.com/" target="_blank" title="새창 : VACATION IN SNOOPY GARDEN">http://www.snoopygarden.com</a><br>인스타그램 <a href="https://www.instagram.com/snoopygardenkorea" target="_blank" title="새창 : VACATION IN SNOOPY GARDEN">https://www.instagram.com</a>', "VACATION IN SNOOPY GARDEN<br>-올 여름 휴가철 피서도 스누피가든에서 즐기자<br><br> 6월 9일부터 8월 31일까지 진행되는 VACATION IN SNOOPY GARDEN 축제는 제주도 구좌읍 송당리에 위치한 스누피 가든 박물관과 2만5천평의 정원 곳곳에서 진행될 예정이다.<br>이번 축제에서는 여름을 즐길 수 있는 컨셉으로 특별 전시가 진행된다.<br>여름을 맞아 해변에서 서핑을 즐기는 스누피와 모래성을 쌓고 있는 피너츠 친구들의 모습을 볼 수 있다. <br>전시관도 일부 새롭게 개편되어 다시 찾는 방문객들에게도 새로운 즐거움을 선사할 예정이다. <br>VACATION IN SNOOPYGARDEN 축제를 통해 스누피가든에서 피너츠 친구들과 함께 다가오는 여름 휴가에 함께 피서를 즐기며 스누피가든이 건내는 휴식과 위로를 경험해 보기를 기대 한다.<br><br>- 일정 : 2022. 06. 09(목) ~ 2022. 08. 31(수)<br>- 장소 : 제주특별자치도 제주시 구좌읍 금백조로 930 스누피가든<br>- 홈페이지 : <a href=\"http://www.snoopygarden.com/\" target=\"_blank\" title=\"새창 : VACATION IN SNOOPY GARDEN\">http://www.snoopygarden.com</a><br>  인스타그램: <a href=\"https://www.instagram.com/snoopygardenkorea\" target=\"_blank\" title=\"새창 : VACATION IN SNOOPY GARDEN\">https://www.instagram.com</a><br>- 문의 : 064-1899-3929", 
'스누피가든 전역', NULL, NULL, '성인 18,000원<br>청소년 15,000원<br>어린인 12,000원',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2823594 , '2022 세계 라면 축제' , 20221001 , 20221120 , '부산광역시 부산진구 신천대로65번길 9 다인로얄팰리스', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/39/2841139_image2_1.jpg', 129.0583198017, 35.1498429450, 6, 6, 7, '010-2585-6557', 
'<a href="https://www.instagram.com/ramenfestival2022" target="_blank" title="새창 : 2022 세계 라면 축제">www.ramenbank1.com</a>', "부산국제영화제의 성공 된 축제와 국제 문화 도시에 걸맞은 창조적인 다양한 문화 예술이 공존하고 젊은 Contents 문화를 선도하는 지역의 이미지를 지향하며 시민의 자긍심을 고취 시키고자 기획된 축제이다.", 
'부산광역시 일원', NULL, NULL, '10,000원',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2823581 , '미디어아트 아이스 쇼 G-SHOW : DRAGON FLOWER' , 20220805 , 20220904 , '강원도 강릉시 수리골길 98 강릉하키센터', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/80/2823580_image2_1.jpg', 128.9012655551, 37.7762825949, 6, 32, 1, '033-651-0338<br>02-6738-0338', 
'홈페이지 <a href="https://g-show.co.kr" target="_blank" title="새창 : 미디어아트 아이스 쇼 G-SHOW : DRAGON FLOWER">https://g-show.co.kr</a><br>블로그 <a href="https://blog.naver.com/livearena" target="_blank" title="새창 : 미디어아트 아이스 쇼 G-SHOW : DRAGON FLOWER">https://blog.naver.com/livearena</a><br>인스타그램 <a href="https://instagram.com/gshow_official" target="_blank" title="새창 : 미디어아트 아이스 쇼 G-SHOW : DRAGON FLOWER">https://instagram.com/gshow_official</a><br>유튜브 <a href="https://youtube.com/channel/UCrT2mZ17fObQQUcLEdnUeyQ" target="_blank" title="새창 : 미디어아트 아이스 쇼 G-SHOW : DRAGON FLOWER">https://youtube.com/channel</a>', "강릉에서 시작되는 대한민국 최초의 오리지널 아이스쇼 G-SHOW: DRAGON FLOWER<br>미디어예술과 뮤지컬을 결합하여 국내 빙상실력으로 시도하는 국내 최초의 창작 아이스 쇼.<br>피겨스케이팅 국가대표 출신 배우들 및 경력파 배우들의 합으로 이루어진 판타지의 경계선을 넘나드는 퍼포먼스와 함께 동계 올림픽 빙상장에서 펼쳐지는 3D 바닷속 판타지 로맨스 올 여름, 환상적인 판타지 SHOW가 강릉에서 펼쳐진다.", 
'강릉하키센터', NULL, NULL, '티켓정가 : VIP석 - 66,000원 / R석 44,000원<br><br>[할인정보]<br>- 프리뷰 할인: 15% (1인 4매) * 8/5(금) ~ 8/7(일) 공연에 한함<br>- 강원도민 할인: 30%(1인 4매)<br>(강원도에 거주중인 주민 대상 할인(거주지 주소가 확인 가능한 신분증,등본 등 증빙서류 확인 후 수령/미지참시 차액지불))<br>- 재관람 할인: 40%(1인 1매) <br>(2022 G-SHOW 유료 티켓 소지자 할인(본인에 한함)/실물티켓지참필수/미지참시차액지불)<br>- 3/4인 가족 할인:20%(1인 4매) / 3인or4인 동반 관람시 할인 적용<br>- 장애인 할인: 40% 1-3급(동반1인). 4-6급(본인한정) / 장애인 본인(실관람자 기준 적용)<br>(*관람당일 티켓수령시 복지카드+신분증 본인확인(본인 미관람 혹은 증빙서류 미지참시 차액지불))<br>- 국가유공자 할인: 40%(본인한정) / 국가유공자 본인(실관람자 기준 적용)<br>(*관람당일 티켓수령시 유공자증+신분증 본인확인(본인 미관람 혹은 증빙서류 미지참시 차액지불)) <br>- 문화가있는날 할인: 15%(1인 4매) / 8월 마지막 주 회차(8/24-8/26)관람시 문화가있는날 할인 혜택 적용',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2823483 , '2022 달밤소풍' , 20220701 , 20220821 , '대전광역시 유성구 도룡동', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/82/2823482_image2_1.jpg', 127.3843173298, 36.3784457403, 6, 3, 4, '070-4267-6881', 
'홈페이지 <a href="http://planin.kr" target="_blank" title="새창 : 2022 달밤소풍">http://planin.kr</a><br>인스타그램 <a href="https://www.instagram.com/dal.bam_" target="_blank" title="새창 : 2022 달밤소풍">www.instagram.com/dal.bam</a>', "'2022 한 여름 밤의 나들이 달밤소풍'은 한 여름밤, 무더위에 지친 시민들이 도시를 떠나지 않고 소풍 가듯 가볍게 피서를 즐길 수 있는 여름축제로 7월1일(금)부터 8월 15일(월)까지 약 40일간 대전 한빛탑광장에서 진행된다.<br>해마다 지역의 청년 소상공인·청년 예술인· 청년 서포터즈와 함께 지역 예술축제를 구성해왔으며, 올해는 환경을 생각하는 ‘지속가능한 녹색축제’, 시민이 함께 만드는 ’시민참여축제’, 여름밤 도시에서 즐기는 ’도심형 축제’라는 3가지 키워드를 가지고 다양한 활동들을 이어갈 예정이다.", 
'대전 엑스포과학공원 한빛탑 광장 일원', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2823481 , '아산문화재야행' , 20221022 , 20221022 , '충청남도 아산시 외암민속길 5', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/70/2823470_image2_1.jpg', 127.0138521393, 36.7303126952, 6, 34, 9, '010-4889-3581', 
'홈페이지 <a href="https://www.asannight.kr" target="_blank" title="새창 : 아산문화재야행">https://www.asannight.kr</a><br>인스타그램 <a href="https://www.instagram.com/asannight/" target="_blank" title="새창 : 아산문화재야행">www.instagram.com/asannight</a><br>블로그 <a href="https://blog.naver.com/asannight" target="_blank" title="새창 : 아산문화재야행">blog.naver.com/asannight</a><br>유튜브 <a href="https://www.youtube.com/channel/UCvmHx-hQwIzNCkGDOAAlXVg" target="_blank" title="새창 : 아산문화재야행">www.youtube.com</a>', "중부권 유일의 민속마을인 아산 외암마을에서 조선시대의 품격 있는 선비문화와 마을공동체 문화를 체험해 볼 수 있는 야간 문화향유 프로그램 <아산 문화재야행>으로 여러분을 초대한다.<br>오래된 장승과 마을 숲, 냇가와 들판, 어느 것 하나 조화를 거스르지 않는 존재감으로 600년의 역사를 지켜온 외암마을은 마을 자체가 문화유산으로 국가 민속문화재로지정된 살아있는 민속박물관이다.<br><2021년 한국 관광 100선>에 선정된 외암마을에서 밤에 펼쳐지는 다양한 체험과 공연, 이야기를 올해 6월과 10월에 아산 문화재야행 <선비의 숨결, 외암마을 야행> 6야(夜) 프로그램으로 특별하고 재미있게 만나볼 수 있다.<br>조선 선비의 숨결이 살아 숨 쉬는 민속 마을이자, 밤이 되면 아름다운 정취을 자아내는 외암마을에서 가족, 연인과 함께 돌담길을 걸으며 다양한 선비문화를 체험해보자.", 
'아산 외암마을 일대', NULL, NULL, '유/무료 프로그램별 상이',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2822571 , '의왕 청계사 이야기 인쇄소' , 20220201 , 20221130 , '경기도 의왕시 청계로 475 청계사', NULL, 'A02081300', 'http://tong.visitkorea.or.kr/cms/resource/63/2822563_image2_1.jpg', 127.0343647526, 37.4117232224, 6, 31, 24, '02-719-1495', 
NULL, "청계사의 사찰문화유산인 의왕 청계사 소장 목판, 의왕 청계사 신중도를 중심으로 음악, 미술, 답사, 교육 등의 다양한 체험프로그램을 통해 청계사로 쉽게 접근하여 청계사만의 특별한 사찰문화를 충분히 향유할 수 있는 프로그램을 제공한다.", 
'의왕 청계사', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2822323 , '2022 버스킹홀릭 inn 강릉' , 20220611 , 20221030 , '강원도 강릉시 경강로 2111 임당시장', NULL, 'A02081300', 'http://tong.visitkorea.or.kr/cms/resource/22/2822322_image2_1.jpg', 128.8976276267, 37.7558321116, 6, 32, 1, '033-650-2145', 
'<a href="https://www.gn.go.kr/tour/prog/lodFesta/Festa/sub02_05/list.do" target="_blank" title="새창 : 2022 버스킹홀릭 inn 강릉">https://www.gn.go.kr</a>', "버스킹홀릭inn강릉은 예향의 도시 강릉에서 올해부터 시작하는 펼쳐지는 버스킹 축제로, 사전 선정된 전국의 버스커들이 월화거리, 경포해변, 안목해변 등 강릉의 아름다운 대표 관광지에서 오감만족 퍼포먼스를 펼치며 관객들에게 눈과 귀가 즐거운 공연을 선사한다.", 
'강릉 월화거리, 경포해변, 안목해변', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2822295 , '생생문화재 중랑구 체험학습' , 20220123 , 20221203 , '서울특별시 중랑구 망우로91길 2', NULL, 'A02081300', 'http://tong.visitkorea.or.kr/cms/resource/92/2822292_image2_1.jpg', 127.1143993819, 37.5990306940, 6, 1, 25, '010-8465-1945', 
'<a href="https://cafe.naver.com/jnsangsang" target="_blank" title="새창 : 중랑구 생생문화재 체험 행사">https://cafe.naver.com</a>', "일제강점기 독립군이 사용하였던 각종 통신체계와 암호를 접목한 체험형 답사", 
'망우역사문화공원, 봉수대공원', NULL, NULL, '1인 1,000원 이상의 자율기부금(가족 3인 예시: 3000원~ , 현장 현금납부)<br>※ 참가비 전액기부(기부처: 공익법인 일제강제동원피해자지원재단)','유아/초등학생/청소년(체험), 성인(답사)', NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2821777 , '영재국악회 국악공연' , 20220501 , 20231231 , '서울특별시 중구 퇴계로34길 28 남산골한옥마을', NULL, 'A02080100', 'http://tong.visitkorea.or.kr/cms/resource/67/2821767_image2_1.jpg', 126.9932865315, 37.5597775194, 6, 1, 24, NULL, 
'<a href="https://www.youngjaegugakhue.co.kr/" target="_blank" title="새창 : 영재국악회 국악공연">https://www.youngjaegugakhue.co.kr</a><br>
<a href="https://tickets.interpark.com/goods/22005267" target="_blank" title="새창 : 영재국악회 티켓예매 사이트">https://tickets.interpark.com/goods/22005267</a>', "대한민국 최고기량의 국악 영재들이 공연하는 유일한 영재국악공연", 
'남산골한옥마을내 남산국악당-크라운해태홀', NULL, NULL, '30000원(할인율- 티켓예매창 참조)',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2821766 , '2022 한강크로스스위밍챌린지' , 20220903 , 20220903 , '서울특별시 송파구 한가람로 65 한강사업본부 잠실안내센터', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/58/2821758_image2_1.jpg', 127.0867542138, 37.5176785349, 6, 1, 18, '070-4705-2008', 
'<a href="https://urbansports.kr/" target="_blank" title="새창 : 한강크로스스위밍챌린지">https://urbansports.kr</a>', "대한민국 서울의 상징, 한강.<br>한강을 수영으로 건너기에 도전하다!<br><br>한강크로스스위밍챌린지는 대국민의 수상안전사고 예방과 건강증진을 도모한다.<br>또, 참가자들에게 도전 정신과 성취감을 심어줌으로써 삶의 활력소를 제공하고자 한다.<br>서울의 관광특구인 잠실지역의 글로벌 축제의 장, 한강크로스스위밍챌린지에 도전하자!", 
'한강잠실대교 수중보(잠실대교 남단) 및 한강공원 일대', NULL, NULL, '49,000원',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2821101 , '한국민속촌 ‘귀굴 두 번째 이야기’' , 20220521 , 20221106 , '경기도 용인시 기흥구 민속촌로 90 한국민속촌', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/99/2821099_image2_1.JPG', 127.1145951569, 37.2567648379, 6, 31, 23, '031-288-0000', 
'<a href="https://www.koreanfolk.co.kr/event/event_now.asp?seq=156" target="_blank" title="새창 : 한국민속촌">https://www.koreanfolk.co.kr</a>', "'귀굴 두 번째 이야기'는 기근으로 변해버린 조선시대 한 마을의 이야기를 다룬다.<br>관람객은 음산한 분위기의 조선 시대 기와집을 지나며 약 15분간 극한의 공포를 체험한다. 사람이 살지 않아 방치된 가옥에선 퀴퀴한 냄새와 음침함이 가득 묻어 나게 했으며 '끼익' 소리 등 오감을 자극하는 요소들을 넣었다.<br>이번 행사는 공포 수위가 높아 초등학생 이하, 노약자, 임산부, 심장 질환자 등은 참여할 수 없다.", 
NULL, NULL, NULL, 'After4 할인 17,000원 (16시 이후 입장 고객 대상)',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2819807 , '강천섬 휴[休]콘서트' , 20220917 , 20220917 , '경기도 여주시 강천면 강천리', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/00/2838900_image2_1.jpg', 127.6956182305, 37.2342502022, 6, 31, 20, '010-2814-1055', 
'<a href="http://artvillage.or.kr/" target="_blank" title="새창 : 휴콘서트">www.artvillage.or.kr</a>', "현대차 정몽구 재단이 주최하고, 한국예술종합학교가 주관하며, 경기도 여주시가 함께하는 ‘2022 예술마을 프로젝트: 강천섬 휴[休]콘서트’가 오는 9월 17일(토) 경기도 여주시 강천면 강천리 627, 강천섬 일대에서 열린다.", 
'강천섬 일대', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2819403 , '강남디자인위크' , 20220826 , 20220904 , '서울특별시 강남구 논현동', '논현동 가구거리', 'A02080600', 'http://tong.visitkorea.or.kr/cms/resource/81/2838381_image2_1.jpg', 127.0225157989, 37.5112531257, 6, 1, 1, '02-3423-5532', 
'<a href="http://gangnamdesignweek.co.kr" target="_blank" title="새창 : 강남인테리어디자인위크">http://gangnamdesignweek.co.kr</a>', "강남디자인위크는 2020.11월, 2021.5월에 이어 3회째 개최되는 행사로 논현동 가구거리 인프라를 활용한 테마형 거리 페스티벌이다. 가구거리내 입점한 기업들과 협업을 통해 민관 경제문화융합형 프로그램을 제공하여 관광객 유치와 지역경제 활성화를 도모한다.", 
'논현동 가구거리 및 청담명품거리 일대', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2819336 , '광태소극장 독립영화관 2022 감독전' , 20220424 , 20221127 , '서울특별시 관악구 호암로22길 51', NULL, 'A02081100', 'http://tong.visitkorea.or.kr/cms/resource/52/2819252_image2_1.jpg', 126.9356471260, 37.4688426049, 6, 1, 5, '<a href="https://www.instagram.com/p/CdLEB4DrDBb/?igshid=YmMyMTA2M2Y=" target="_blank" title="새창 : 광태소극장 독립영화관 2022 감독전">www.instagram.com</a>', 
'<a href="https://booking.naver.com/booking/12/bizes/691208
" target="_blank" title="새창 : 광태소극장 독립영화관 2022 감독전">booking.naver.com</a>', "2022 감독전은 2015년 시작됐다 잠시 문을 닫았던 광태소극장 독립영화관이 다시금 문을 활짝 열었음을 알리는 Reborn Project이다. 본 프로젝트는 <2022 생활문화공동체 활성화 사업>의 일환으로 문화체육관광부가 주최 및 국민체육진흥공단의 후원을 받아 지역문화진흥원과 광야의태양Company가 주관하며 ㈜ 앤노엔이 협력하는 사업이다. 4월 부터 11월까지 매월 마지막 주 일요일 오후 3시에 이루어지며 독립영화도 보고 감독과 이야기도 나누고 관람객들과 네트워킹도 하는 다양한 커뮤니티를 형성할 수 있는 프로그램이다.", 
'광태소극장', NULL, NULL, '10,000원 (광태vip 멤버십은 20% 할인)',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2819167 , '남산 한국의 맛 축제' , 20220922 , 20220925 , '서울특별시 중구 퇴계로34길 28 남산골한옥마을', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/37/2844337_image2_1.jpg', 126.9932865315, 37.5597775194, 6, 1, 24, '02-2000-5806', 
'<a href="http://kfoodfesta.com/" target="_blank" title="새창 : 남산 한국의 맛 축제">http://kfoodfesta.com</a>', "한국 고유의 맛, 한국 고유의 음식 문화를 알리는 글로벌 축제<br>대한민국 대표 맛집을 한 장소에서 방문할 수 있는 축제<br>남녀노소 누구나 즐길 수 있는 대중적인 프로그램으로 구성<br>참관객이 함께 참여하는 체험형 축제", 
'남산한옥마을', NULL, NULL, NULL,NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2818844 , '2022 광주 국화전시회' , 20221007 , 20221023 , '광주광역시 서구 상무누리로 30 김대중컨벤션센터', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/40/2818840_image2_1.jpg', 126.8405588979, 35.1467152588, 6, 5, 5, '062-611-2165', 
'<a href="http://www.gwangjugukhwa.com/" target="_blank" title="새창 : 광주 국화전시회">www.gwangjugukhwa.com</a>', "김대중컨벤션센터는 호남권 최대 전시컨벤션센터이다.<br>2022년 10월, 김대중컨벤션센터 야외광장에서 국화축제가 열린다.<br>공연 및 체험행사, 플리마켓, 화훼직거래장터 등 다양한 부대행사가 함께 진행된다.<br>푸드트럭도 준비되어있어 다양한 먹거리와 함께 국화를 즐길 수 있다.<br>가을의 꽃내음을 김대중컨벤션센터 야외광장에서 만끽하길 바란다.", 
'김대중컨벤션센터 야외광장', NULL, NULL, '입장료 : 무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2818215 , '한반도의 범과 생태계' , 20220426 , 20220912 , '충청남도 서천군 금강로 1210', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/10/2818210_image2_1.jpg', 126.7194583721, 36.0271354218, 6, 34, 8, '041-950-5846', 
'<a href="https://www.nie.re.kr/nie/bbs/BMSR00053/view.do?boardId=59595868&menuNo=200225" target="_blank" title="새창 : 한반도의 범과 생태계">https://www.nie.re.kr</a>', "국립생태원은 2022년 임인년(壬寅年)을 맞아 한반도의 문화와 생태계 속 범을 만나는 ‘한반도의 범과 생태계’ 기획전을 에코리움 기획전시실(충남 서천군 소재)에서 9월 12일까지 개최한다. 이번 기획전은 한반도 범의 생태계 보호와 공존 메시지를 전달하기 위해 다양한 유물(민화, 목인, 석호 등)을 한곳으로 모아 범의 새로운 발견과 인식을 전환하는 전시 및 체험 등을 마련했다. 기획전시실은 총 240㎡의 공간을 활용하여 실제처럼 생생한 호랑이를 만나는 경험을 선사하는 입체영상 연출을 시작으로 △범 내려온다 △범 다가온다 △범 찾아간다 △범 타러가세 △범 몰고가세 등 각종 전시와 체험공간으로 구성됐다.", 
'국립생태원 에코리움 기획전시실', NULL, NULL, '어른:5,000원 / 청소년: 3,000원 / 어린이: 2,000원 / 유아,경로우대자, 장애인, 국가유공자, 기초생활수급자: 무료 20인 이상 단체의 인솔자 1인 무료 유아, 경로우대자, 장애인, 국가유공자, 기초생활수급자는 증명서 필히 지참 장애 1~3급 장애인 동반 1인 무료, 장애4급 이상 본인만 무료 50% 할인 서천군민(본인에 한함)',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2818138 , '2022 창경궁 야연' , 20220922 , 20221006 , '서울특별시 종로구 창경궁로 185 창경궁', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/33/2852433_image2_1.jpg', 126.9964634775, 37.5789336838, 6, 1, 23, '02-3210-4802', 
'<a href="https://www.chf.or.kr/chf" target="_blank" title="새창 : 2022 창경궁 야연">https://www.chf.or.kr</a>', "창경궁 야연은 ‘효심’을 주제로 창경궁의 역사·문화적 가치를 반영하여 기획한 야간 체험 프로그램이다. 창경궁 야연은 기존 궁궐 체험과 달리 부모님 중 한 분이 체험자로 직접 참여하고 가족들이 관람객이 되는 프로그램이다. 체험자는 궁중의상과 전통음식을 체험할 수 있으며, 장수사진 및 가족사진을 촬영하여 행사가 끝난 후에는 액자에 담아 기념품으로 증정한다. 자세한 내용은 한국문화재재단 누리집(<a href=\"https://www.chf.or.kr/chf\" target=\"_blank\" title=\"새창 : 2022 창경궁 야연\">https://www.chf.or.kr</a>)에서 확인할 수 있다.", 
'창경궁 통명전', NULL, NULL, '1인 100,000원(체험객 1인 외 가족 관람객 최대 4인 참가), 할인정보: 장애인 1-6급(본인) 50% 할인, 국가유공자(본인) 50% 할인',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2816941 , '지성(知性)애(愛) 빠지다, 부평향교' , 20220513 , 20221022 , '인천광역시 계양구 향교로 19 부평향교(지정문화재)', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/36/2816936_image2_1.jpg', 126.7207175131, 37.5395472304, 6, 2, 2, '032-450-5753', 
'공식홈페이지: <a href=http://www.igycc.or.kr/" target="_blank" title="새창 : 지성(知性)애(愛) 빠지다, 부평향교">http://www.igycc.or.kr/</a><br>블로그: <a href="https://blog.naver.com/PostList.naver?blogId=gycc5753&from=postList&categoryNo=14" target="_blank" title="새창 : 지성(知性)애(愛) 빠지다, 부평향교">https://blog.naver.com</a><br>인스타그램: <a href="https://www.instagram.com/gyeyang_cultural_center/" target="_blank" title="새창 : 지성(知性)애(愛) 빠지다, 부평향교">https://www.instagram.com</a>', "2022 <지성(知性)애(愛) 빠지다, 부평향교>는 고려시대에 세워져 오랜 기간 유생들의 역사를 간직하고 인문정신이 살아 숨 쉬는 유서 깊은 문화유산 부평향교에서 다양한 주제의 교육·체험·공연 프로그램을 통해 구민들이 즐겁게 지성(知性)을 함양하고, 내가 사는 지역 문화재 향교에 대한 애정을 키우며 남녀노소 빠져들 수 있게 한다.", 
'부평향교 (계양구 향교로 19)', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2816502 , '서커스 캬바레&서커스 캬라반' , 20220909 , 20220925 , '서울특별시 마포구 증산로 87', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/89/2844289_image2_1.jpg', 126.8951646315, 37.5699856862, 6, 1, 13, '02-3437-0095', 
'<a href="https://www.facebook.com/SeoulStreetArtsCreationCenter" target="_blank" title="새창 : 서커스 캬라반 ‘봄’">https://www.facebook.com</a>', "서울 서커스 페스티벌 <서커스 캬바레>는 2018년 문화비축기지에서 첫 선을 보인 국내 유일한 서커스 축제이다. 서울거리예술창작센터의 작품 제작 지원을 받은 단체의 신작과 국내에는 처음으로 발표하는 해외단체의 작품을 비롯하여 누구나 참여해 볼 수 있는 서커스 체험 프로그램, 전시 등을 운영한다. 반면 다수의 축제에서 작품성을 인정받은 국내 중·소규모 작품으로 구성한 서커스 시즌 프로그램 <서커스 캬라반>은 시민 누구나 일상에서 신나고 즐겁게 관람할 수 있는 프로그램이다.", 
'문화비축기지', NULL, NULL, '무료<br>예매링크(<a href="https://booking.naver.com/booking/12/bizes/739468" target="_blank" title="새창 : 서커스 캬바레&서커스 캬라반">https://booking.naver.com</a>)',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2816278 , '2022 영등포 관광 세일 페스타' , 20220401 , 20221031 , NULL, '서울시 영등포구', 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/52/2816652_image2_1.jpg', 0, 0, NULL, 1, 20, '02-6964-7959', 
'<a href="https://ydp.redtable.global/ko/store" target="_blank" title="새창 : 2022 영등포 관광 세일 페스타">https://ydp.redtable.global</a>', "봄꽃도시 영등포에서 2022 영등포 관광 세일 페스타가 4월부터 10월까지 온라인으로 개최된다.<br>온라인으로 음식점 예약/주문/결제 시, 최대 50% 할인(최대 할인금액 10,000원)이 적용되며 영등포를 방문하는 국내외 관광객들에게 쿠폰 이벤트를 제공한다.<br> 영등포 내 관광지와 관련한 정보들도 제공하고 있으니 많은 참여 바란다.", 
'서울시 영등포구', NULL, NULL, NULL,NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2815107 , '2022 초·중·고등학생 문화공연 관람 지원 [공연봄날]' , 20220601 , 20221231 , NULL, NULL, 'A02080200', 'http://tong.visitkorea.or.kr/cms/resource/32/2827932_image2_1.jpg', 0, 0, NULL, 1, 100, '02-542-2695', 
'<a href="http://springday.or.kr/" target="_blank" title="새창 : 2022 초·중·고등학생 문화공연 관람 지원 [공연봄날]">http://springday.or.kr/</a>', "서울시 공연봄날은 학생들에게는 문화공연 관람 기회를 제공함으로써 문화예술을 향유하는 어른으로 성장할 수 있도록 도와주는 동시에, 공연예술계에는 무대를 오를 기회를 제공하면서 미래의 관객층까지 형성해주는 선순환 구조의 사업이다.", 
'서울 소재 공연장', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2810502 , '동아시아문화도시 경주' , 20220325 , 20221118 , '경상북도 경주시 양정로 260 경주시청', NULL, 'A02081300', 'http://tong.visitkorea.or.kr/cms/resource/01/2810501_image2_1.jpg', 129.2244133550, 35.8559722016, 6, 35, 2, '054-779-8585', 
'홈페이지 <a href="https://www.gyeongju.go.kr/cceagj/index.do" target="_blank" title="새창 : 2022 동아시아문화도시 경주">https://www.gyeongju.go.kr/cceagj/index.do</a><br>인스타그램 <a href="https://www.instagram.com/culturecity_gyeongju_/" target="_blank" title="새창 : 동아시아문화도시 경주">www.instagram.com</a><br>페이스북 <a href="https://www.facebook.com/2022-%EB%8F%99%EC%95%84%EC%8B%9C%EC%95%84%EB%AC%B8%ED%99%94%EB%8F%84%EC%8B%9C-%EA%B2%BD%EC%A3%BC-109102388394787" target="_blank" title="새창 : 동아시아문화도시 경주">https://www.facebook.com</a>', "동아시아문화도시는 한·중·일 3국간 문화다양성 존중이라는 기치 아래, \"동아시아의 의식, 문화교류와 융합, 상대문화 이해\"의 정신을 실천하기 위해 매년 개최하는 문화교류행사이다. 2022년 동아시아문화도시로는 한국 경주시, 중국 원저우시와 지난시, 일본 오이타현이 선정되었다. 연중 펼쳐지는 한·중·일 3국의 다채로운 문화교류행사에 여러분의 많은 관심과 참여 부탁드린다.", 
'19:00-21:00', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2809535 , '남산봉수의식 등 전통문화 재현행사' , 20220101 , 20221231 , '서울특별시 종로구 종로 54 보신각', NULL, 'A02080100', 'http://tong.visitkorea.or.kr/cms/resource/29/2809529_image2_1.jpg', 126.9836898995, 37.5698206245, 6, 1, 23, '02-120', 
'<a href="https://namsanbongsu.kr/" target="_blank" title="새창 : 남산봉수의식 등 전통문화 재현행사">https://namsanbongsu.kr/</a>', "- 보신각 타종행사<br>시민과 함께하는 천년의 종소리 ! 보신각 타종행사<br>매일 정오에 타종하는  보신각 상설타종행사는 시민 여러분이 함께 참여하는 행사이다.<br>가족, 친구, 연인과 함께 신청하여 타종의 감동을 느낄 수 있다.<br>(※매주 월요일 제외, 화요일은 외국인 참여 프로그램 실시)<br><br>- 남산봉수대 봉화의식<br>남산봉수대는 조선시대에 전국의 봉화대에서 올라오는 봉화를 최종적으로 집결해 상황을 도성에 알리는 중요한 통신수단 이였다.<br>남산봉수대에 오셔서 남산봉수의식과 역사 해설 안내를 들어볼 수 있다.<br><br>- 사물놀이공연 및 전통무예시범<br>서울 남산타워 팔각정 광장에서 사물놀이 공연 및 전통무예시범을 관람하고 직접 체험해보는 전통문화 재현행사이다.", 
'서울 남산봉수대, 서울 남산 팔각정, 서울 보신각<br>보신각 : 서울 종로구 종로 54 보신각<br>남산봉수대 : 서울 중구 예장동 8-1 남산봉수대', NULL, NULL, '무료',NULL, '프로그램별 상이');

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2809281 , '고창농촌영화제' , 20221028 , 20221030 , '전라북도 고창군 녹두로 1265 고창군농산물유통센타', NULL, 'A02081300', 'http://tong.visitkorea.or.kr/cms/resource/80/2809280_image2_1.jpg', 126.6846960753, 35.4337773663, 6, 37, 1, '010-3568-7907', 
'<a href="http://www.grff.co.kr/" target="_blank" title="새창 : 고창농촌영화제 ">http://www.grff.co.kr/</a>', "고창농촌영화제는 국내 최초 농촌을 테마로 하며 오는10월28일(금) 개막식을 시작으로 30일(일)까지 3일간 개최된다. 공식홈페이지를 통해 사전예약으로 진행되며 한국장편경쟁, 단평경쟁등 다양한 시선의 영화상영 및 드라이브시네마를 진행해 차량안에서 친구 연인 가족 또는 욜로라이프에 맞는 추억을 선물한다.", 
NULL, NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2807072 , '2022 선한영향력가게와 함께하는 공익 캠페인 Korea Music Festival' , 20220101 , 20221231 , '서울특별시 강남구  선릉로111길 (33)', NULL, 'A02080900', 'http://tong.visitkorea.or.kr/cms/resource/70/2807070_image2_1.jpg', 127.0409280431, 37.5101313642, 6, 1, 1, 'kpmakorea@aol.com', 
'<a href="https://music1998.modoo.at/" target="_blank" title="새창 : 2022 선한영향력가게와 함께하는 공익 캠페인 Korea Music Festival">https://music1998.modoo.at/</a>', "KMF는 공동 성장, 상생, 협업 을 슬로건으로, 독립운동 책을 통한 해설 과 독립운동 창작곡 및 일제강점기 시대의 클래식 곡 들로 이루어진 음악회를 무료로 제공하여, 잊지 말아야 할 독립운동가와 대한독립역사를 끊임 없이 국민들에게 상기 시키고자 한다. 독립운동 음악회 티켓 판매 사업의 수입금 전액은 독립운동 역사를 알리는, 무료 음악회 제작에 전액 사용 된다.<br>KMF는 비영리 사업으로서 정부기관인 수도박물관, 무중력 지대 강남, 예술청 의 협조 와 한국전문연주자협회(이하 한전협), 베세토Symphony&Opera(이하 BSO)가 주최주관 하며, Atto Strings, 로맨틱 한 오케스트라, 사회적기업(주)클래식아츠, International Horn Society 의 협업으로, 선한영향력 전파를 위해, 힘써 주시고 있다.", 
'비대면 공연: <a href="https://www.youtube.com/channel/UC1HBI703kLcwg2kq_0k7_kw" target="_blank" title="새창 : 2022 선한영향력가게와 함께하는 공익 캠페인 Korea Music Festival">https://www.youtube.com/channel</a>', NULL, NULL, '무료',NULL, '60분');

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2805988 , '제7회 서울커피페스티벌 The 7th Seoul Coffee Festival' , 20221123 , 20221126 , '서울특별시 강남구  영동대로 (513, 코엑스)', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/49/2806349_image2_1.png', 127.0594429796, 37.5117148467, 6, 1, 1, '02-6000-6709', 
'<a href="http://www.cafeshow.com/kor/event/festival9.asp" target="_blank" title="새창 : 제6회 서울커피페스티벌 The 6th Seoul Coffee Festival">www.cafeshow.com</a>', "커피를 사랑하는 사람들이 커피를 즐길 수 있는 도심 속 글로벌 커피 문화 축제, '서울커피페스티벌'.<br>글로벌 대표 커피 비즈니스플랫폼 제21회 서울카페쇼와 동시개최되는 서울커피페스티벌은 전시장 뿐 아니라 도심 곳곳에서 커피 문화를 즐길 수 있는 프로그램이다. 다양한 영역의 아티스트 및 문화 예술 기관과 함께 선보이는 예술 프로그램, 서울 곳곳의 유니크한 카페를 경험할 수 있는 여행 프로그램 등을 선보인다.", 
'코엑스 전시장, 로비 및 서울 도심 카페', NULL, NULL, '세부 프로그램별 상이<br>*동시개최행사인 서울카페쇼 전시장 내 프로그램의 경우, 서울카페쇼 입장권 구매 필요<br>1일권 : 20,000원<br>다일권 : 40,000원<br>*코엑스 로비, 서울 도심 카페에서 진행하는 프로그램일 경우, 별도의 입장권은 필요없음','8세 이상 입장 가능<br>*비즈니스데이의 경우, 미성년자 출입 제한<br>*행사 전일 유모차 진입 금지', NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2805957 , '제11회 월드커피리더스포럼' , 20221123 , 20221126 , '서울특별시 강남구  영동대로 (513, 코엑스)', NULL, 'A02081300', 'http://tong.visitkorea.or.kr/cms/resource/41/2805941_image2_1.JPG', 127.0594429796, 37.5117148467, 6, 1, 1, '02-6000-6698', 
'<a href="https://www.wclforum.org/kr/index.asp" target="_blank" title="새창 : 제11회 월드커피리더스포럼">www.wclforum.org</a>', "아시아를 대표하는 커피 전문 컨퍼런스 월드커피리더스포럼은 UN 산하 국제커피기구(International Coffee Organization)가 전세계 최초로 공식 후원하는 국제회의로써 2012년 첫 개최 이후로 글로벌 커피 시장의 지속가능한 성장을 위해 매회 논의가 필요한 이슈를 선정해 세계 최고 커피 전문가들의 인사이트를 공유하며 시장이 직면한 변화를 짚어보고 산업의 미래에 대한 새로운 패러다임을 모색해왔다.<br><br>커피의 높은 품질에 대한 니즈로 인해 스페셜티 커피 시장의 확산, 이에 다른 원가 부담과 커피 가격 상승, 지구 온난화 현상으로 인한 커피 병충해 및 재배 온도 부적절 현상, 커피 생산자와 소비국과의 관계, 팬데믹 이후 커피 시장의 변화와 이에 대응하는 솔루션 등 글로벌 커피 산업의 전반적인 문제점을 극복하기 위해 국내외 초청 연사들은 새로운 가능성을 제시하고 참가자들은 세계 커피 시장의 경향과 도전의 방향을 모색하는 자리를 제공한다.", 
'코엑스 컨퍼런스룸', NULL, NULL, '세부 프로그램별 상이<br>프로페셔널세션: 40,000(vat 제외)',NULL, '프로그램별 상이');

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2787200 , '서울국제정원박람회' , 20220930 , 20221006 , '서울특별시 강북구 월계로 173 북서울꿈의숲', NULL, 'A02080600', 'http://tong.visitkorea.or.kr/cms/resource/37/2791037_image2_1.jpg', 127.0445440464, 37.6197242510, 6, 1, 3, NULL, 
'<a href="https://festival.seoul.go.kr/garden/introduce/introduce2020" target="_blank" title="새창 : 서울국제정원박람회 사이트로 이동">https://festival.seoul.go.kr/garden/introduce/introduce2020</a>', "숲과 정원의 도시 서울을 세계에 알리는 정원박람회<br>서울국제정원박람회는 세계인과 함께 정원도시 서울의 위상을 알리고, 주민·작가 등과 함께 존치정원을 만드는 정원박람회를 세계에 소개하여 서울시만의 차별화된 정원박람회를 브랜드화하고자 한다.<br><br>시민들에게 정원문화를 일상화시키는 정원박람회<br>식물관리, 정원가꾸기 등 생활형 정원콘텐츠로 집에서 누구나 쉽게 따라할 수 있는 실용적 프로그램을 기획하고, 해외 유명 작가 등 다양한 정원으로 집 근처에서 즐기는 정원문화의 일상화를 꾀하고자 한다.<br><br>지역경제 활성화를 꾀하는 정원박람회<br>지역주민과 함께 동네정원을 조성하고, 지속적으로 주민들이 유지·관리할 수 있도록 동네정원사를 양성하는 등 주민들의 일상 속 정원문화가 자리잡을 수 있도록 추진한다.", 
'북서울 꿈의 숲', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2786391 , '광안리 M(Marvelous) 드론 라이트쇼' , 20220402 , 20231231 , '부산광역시 수영구 광안해변로 219', '(광안동)', 'A02081300', 'http://tong.visitkorea.or.kr/cms/resource/20/2822720_image2_1.jpg', 129.1185505648, 35.1538269450, NULL, 6, 12, '051-610-4884', 
'<a href="http://gwangallimdrone.co.kr/" target="_blank" title="새창 : 드론 라이트쇼">http://gwangallimdrone.co.kr</a>', "매주 토요일 저녁, 새롭고 다양한 콘텐츠로 광안리 밤하늘을 아름답게 장식하는<광안리 M 드론 라이트쇼><br>\"M\"은 '놀라운, 경이로운'이라는 뜻의 'Marvelous'를 의미하는 것으로 드론이 뿜어내는 불빛이 광안대교의 야경과 어우러져 광안리를 찾는 방문객들에게 경이로움과 신비로움을 선사할 것이다.<br><br>* 코로나19 상황 및 기상상황(우천,강풍 등)에 따라 공연 일정 변경 가능", 
'광안리해변 일원', NULL, NULL, '무료',NULL, '10분 내외');

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2784074 , '미구엘 슈발리에 제주 특별전' , 20211108 , 20221106 , '제주특별자치도 서귀포시 성산읍 섭지코지로 95', NULL, 'A02081300', 'http://tong.visitkorea.or.kr/cms/resource/69/2784069_image2_1.jpg', 126.9279812488, 33.4326748187, 6, 39, 3, '1833-7001', 
'<a href="https://www.aquaplanet.co.kr/jeju/kor/miguel_jeju/index.html" target="_blank" title="새창 : 미구엘 슈발리에 제주 특별전">www.aquaplanet.co.kr</a>', "미구엘 슈발리에 특별전 : 디지털 심연은 해저 동식물군이라는 주제로 자연에 대한 탐구를 컴퓨터 작업을 통해 재구성한 미디어 아트 전시이다. 작가는 조명 설치작, 뉴미디어 작품, 그리고 조각물을 통해 여전히 95%가 미탐험 상태인 심해와 같은 미지 세계로의 탐사를 제안한다. 본 전시는 시적이고 은유적인 방식으로 다양한 질문을 던진다. 생물 다양성 보전에 대한 필요성을 표명하며 인간과 자연의 공생 관계를 위한 조건을 재현하는 전시이다.", 
'아쿠아플라넷 제주', NULL, NULL, '[유료]성인 17,00원 / 경로,청소년,어린이 13,000원',NULL, '1시간');

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2778356 , '2022영주세계풍기인삼엑스포' , 20220930 , 20221023 , '경상북도 영주시 신재로 964', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/79/2828079_image2_1.jpg', 128.5193160013, 36.8677160182, 6, 35, 14, '054-639-4801', 
'o홈페이지 : <a href="http://www.ginsengexpo.org/yjexpo/main.do" target="_blank" title="새창 : 영주세계풍기인삼엑스포">http://www.ginsengexpo.org</a><br>o 네이버블로그 : <a href="https://blog.naver.com/in3expo" target="_blank" title="새창 : 영주세계풍기인삼엑스포">blog.naver.com/</a><br>o 페이스북 : <a href="https://www.facebook.com/in3expo" target="_blank" title="새창 : 영주세계풍기인삼엑스포">www.facebook.com</a><br>o 유튜브 : <a href="https://www.youtube.com/channel/UC-eTfd3F1KPy_OZHBj0ZcXg/featured" target="_blank" title="새창 : 영주세계풍기인삼엑스포">www.youtube.com</a><br>o 인스타그램 : <a href="https://www.instagram.com/in3expo/" target="_blank" title="새창 : 영주세계풍기인삼엑스포">www.instagram.com</a>', "2022영주세계풍기인삼엑스포가 \"인삼, 세계를 품고, 미래를 열다!\"라는 주제로 2022. 9. 30.일부터 10. 23.일까지 24일간 경상북도 영주시 풍기인삼문화팝업공원 일원에게 개최된다.<br>경상북도 영주시 풍기읍은 고려인삼의 최초 재배지로 알려져 있으며, 태백산 및 소백산맥으로 둘러 쌓인 고원지역에 위치하고 있어 일교차가 크고 유기물이 풍부한 토양과 대륙성 한랭기후, 배수가 잘되는 사질양토에서 인심이 재배되어 육질이 단단하며 유효 사포닌 함량이 높아 면역력 증진 효과가 우수하다.<br>이번 엑스포는 전시, 교역, 컨퍼런스, 이벤트, 체험, 관광 등 다양한 볼거리와 즐길거리로 다채롭게 꾸며질 계획이다.<br>전시관은 주제관, 생활과학관, 인삼미래관 등 6개관을 운영하고 포럼, 학술회의, 토크콘서트와 각종 컨퍼런스를 개최할 계획이다.", 
'풍기인삼문화팝업공원 일원', NULL, NULL, 'o 보통권 : 일반 8,000원, 청소년 5,000원, 어린이 3,000원<br>o 단체권 : 일반 7,000원, 청소년 4,000원, 어린이 3,000원<br>o 우대권 : 5,000원<br>o 전기간권 : 일반 30,000원, 청소년(중,고등학생) 20,000원<br>* 입장권 종류에 따라 일정금액의 쿠폰 지급<br>* 보통권 사전 예매시 일정금액을 할인(어린이 제외)<br>* 무료입장 : 국가유공자, 6세이하 영유아, 장애인 및 동반보호자 1인, 80세 이상, 상이군경, 명예홍보대사 등',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2774275 , '목포해상W쇼' , 20220603 , 20221126 , '전라남도 목포시 평화로 82', '(상동)', 'A02081300', 'http://tong.visitkorea.or.kr/cms/resource/66/2817066_image2_1.jpg', 126.4338006577, 34.7967007465, 6, 38, 8, '061-270-8441', 
'<a href="http://mokpowshow.co.kr/" target="_blank" title="새창 :  목포해상W쇼">http://mokpowshow.co.kr/</a>', "목포해상W쇼는 가족의 시선에서 바라본 아름다운 목포의 이야기를 '목포의 눈물'을 비롯한 지역상징 노래와 창작곡, 기성곡으로 스토리텔링한 창작뮤지컬 공연에 맞춰 바다분수쇼와 불꽃전문팀이 연출하는 화려하고 웅장한 불꽃으로 구성된 공연이다.<br>W가 분수모양을 연상시키는 점에 착안해 명명된 W쇼는 물(Water)에서 펼쳐지는 세계적인(World)쇼, 놀랍고 멋진(Wonderful)쇼라는 의미를 담고있다.", 
'목포 평화광장 일대', NULL, NULL, '무료','전체', '50분');

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2769942 , '제6회 강원도 평생학습박람회 & 제13회 횡성 평생학습축제' , 20220923 , 20220925 , '강원도 횡성군 문예로 75 횡성 문화체육공원', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/90/2852090_image2_1.jpg', 127.9782824672, 37.4907202341, 6, 32, 18, '1644-4845', 
'<a href="https://www.gwlle.co.kr/" target="_blank" title="새창 : 평생학습박람회">www.gwlle.co.kr</a>', "\"강원도 평생학습박람회\"는 강원도의 다양한 평생학습정보를 소개하고 평생학습성과를 공유하는 강원도 최대의 평생학습 축제이며, 전시, 공연, 체험, 관람 등 다채로운 행사를 경험할 수 있는 축제이다.", 
'횡성문화체육공원 일원', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2767541 , '제16회 전북과학축전' , 20220826 , 20220901 , '전라북도 전주시 덕진구 보훈누리로 63 창의체험관', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/49/2836449_image2_1.jpg', 127.1282680169, 35.8555842510, 6, 37, 12, '063-260-9333~6', 
'<a href="http://jbsf.co.kr/" target="_blank" title="새창 : 전라북도과학축전">http://jbsf.co.kr/</a>', "제16회 전북과학축전은 온·오프라인 동시 진행 및 찾아가는 과학축전을 통해 폭넓은 체험 기회를 제공하고 보다 가까이 여러분께 다가가고자 한다. 또한 메타버스(젭)을 통해 온라인으로도 부대행사를 즐길 수 있도록 기획했다.<br>오프라인 전북과학축전에서는 총 56개, 온라인으로는 47개의 체험 및 전시 프로그램을 즐길 수 있다.<br>온라인 전북과학축전에서는 홈페이지의 3D 전시관을 통해 전북핵심산업에 관한 초고화질 전시를 감상할 수 있으며, 전북과학기술관에서는 전주기상지청, 한국과학기술연구원, 한국원자력연구원, 한국전자기술연구원, 전북LINC3.0사업단의 연구 성과와 과학기술을 살펴볼 수 있다.", 
'전북 어린이창의체험관', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2764526 , '2022 인천 독서대전' , 20220924 , 20221002 , '인천광역시 연수구 해돋이로 51', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/42/2850642_image2_1.jpeg', 126.6552221330, 37.3884664061, 6, 2, 8, '032-440-7873', 
'<a href="https://blog.naver.com/libpolicy" target="_blank" title="새창 : 인천독서대전 블로그로 이동">https://blog.naver.com/libpolicy</a>', "인천광역시 공공도서관 개관 100주년을 맞아 도서관, 출판, 서점,작가 와 시민 모두가 함께하는 다채로운 독서의 향연.<br>9월 24일 11시 송도 해돋이공원에서의 개막식을 시작으로 1주일간 인천 전역에서 풍성한 독서 주제 행사가 진행된다.", 
'송도 해돋이공원 및 인천광역시 전역', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2758373 , '2022 대청호대덕뮤직페스티벌' , 20220916 , 20220918 , '대전광역시 대덕구 대청로570번길 57-13', '(미호동)', 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/99/2841099_image2_1.jpg', 127.4748428601, 36.4693536128, 6, 3, 1, '042-608-6732', 
'<a href="http://www.xn--vk1ba9wl70af7ao1ug2m4ufmmq7rbc3n.com/" target="_blank" title="새창 : 2022 대청호대덕뮤직페스티벌">www.대청호대덕뮤직페스티벌.com</a>', "매년 대전 대덕구의 대표 관광지인 대청공원에서 펼쳐지는 라이브 음악축제로 자연과 사람, 음악이 함께하는 소풍같은 축제이다. 아름다운 자연속에서 감미로운 음악을 들으며 사랑하는 사람과 소중한 추억을 만들어보길 바란다.", 
'대청공원', NULL, NULL, '무료공연',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2757584 , '2023 강릉 세계합창대회' , 20230703 , 20230713 , '강원도 강릉시 죽헌길 7', '(지변동)', 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/78/2811478_image2_1.jpg', 128.8701379764, 37.7707215201, 6, 32, 1, '033-640-2719', 
'<a href="https://www.wcg2023.kr/" target="_blank" title="새창 : 강릉 세계합창대회 공식홈페이지로 이동">https://www.wcg2023.kr/</a>', "2023 강릉 세계합창대회는 남북이 하나된 2018 평창 동계올림픽의 ‘평화와 번영’이라는 레거시를 비전으로 하고 있으며 다시 한번 전세계인이 강릉에서 하나되어 평화를 노래하는 장이 될 것이다.", 
'강릉시 일원, 강원도 DMZ 박물관', NULL, NULL, '유료-등록비(Registration Fee): 각 합창단(단체 단위)은 선택한 첫 활동*에 500유로, 추가 활동 시 250유로 납부',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2756476 , '2022 조선왕릉문화제' , 20220924 , 20221023 , '서울특별시 노원구 화랑로 727 대한체육회선수촌', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/68/2852368_image2_1.jpg', 127.1015912499, 37.6328737518, 6, 1, 9, '02-6354-7223', 
'<a href="https://www.jrtf.or.kr/" target="_blank" title="새창 : 2022 조선왕릉문화제">https://www.jrtf.or.kr/</a>', "유네스코 세계문화유산인 조선왕릉의 가치와 품격을 널리 알리기 위해 2020년부터 시작된 제3회 조선왕릉문화제는 '새로 보다, 조선 왕릉'이라는 슬로건과 함께 개최된다. 능에서 펼쳐지는 융복합 콘텐츠와 힐링 테마, 야행 프로그램을 통해 조선왕릉만의 색다른 모습을 경험할 수 있다.", 
'태강릉, 홍유릉, 동구릉, 선정릉, 헌인릉, 의릉, 서오릉, 융건릉, 세종대왕릉', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2756253 , '2022 부여 세계유산 미디어아트 페스티벌' , 20220916 , 20221015 , '충청남도 부여군 부소로 31 부소산성', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/95/2847195_image2_1.jpg', 126.9148563346, 36.2848009909, 6, 34, 6, '070-4348-7715', 
'<a href="https://www.buyeonight.kr/home/" target="_blank" title="새창 : 2022 부여 세계유산 미디어아트 페스티벌">www.buyeonight.kr</a>', "사비백제의 중심이었던 관북리 유적과 부소산성을 배경으로 시공간을 넘나들며 백제의 찬란한 역사와 어라하의 유산을 만날 수 있는 미디어아트 페스티벌이다.", 
'부여 관북리 유적과 부소산성', NULL, NULL, '무료','전체 이용가', NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2755544 , '2022서울릴랙스위크' , 20221001 , 20221002 , '서울특별시 강남구 남부순환로 3104 SETEC', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/77/2831477_image2_1.jpg', 127.0707673919, 37.4960890861, 6, 1, 1, '02-2231-2011', 
'홈페이지 <a href="https://www.relaxweek.kr/" target="_blank" title="새창 : 릴랙스위크">https://www.relaxweek.kr/</a><br>유튜브 <a href="https://youtu.be/0gAXpMGzkJs" target="_blank" title="새창 : 릴랙스위크">https://youtu.be</a><br>인스타그램 <a href="https://www.instagram.com/seoul_relax_week/" target="_blank" title="새창 : 릴랙스위크">https://www.instagram.com</a><br>페이스북 <a href="https://www.facebook.com/seoulrelaxweek" target="_blank" title="새창 : 릴랙스위크">https://www.facebook.com</a>', "서울릴랙스위크 명상컨펀스<br>마음치유자를 위한 상담클리닉 “상담심리와 마음챙김”<br>몸과 마음에 대한 과학적 연구 결과와 마음챙김 체험을 통해 펜데믹 이후 전지구적인 화두가 된 마음 건강과 심리 방역의 대안과 가능성 모색한다.", 
'서울무역전시컨벤션센터(SETEC) 컨벤션홀', NULL, NULL, '후원 방식',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2755521 , '밀양문화재야행' , 20220819 , 20220821 , '경상남도 밀양시 중앙로 324', '(내일동)', 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/15/2755515_image2_1.jpg', 128.7552701989, 35.4921711431, 6, 36, 7, '055-355-0306', 
'<a href="https://www.miryangnight.com/" target="_blank" title="새창 :밀양문화재야행">https://www.miryangnight.com/</a>', "밤에 깨어나는 신비로운 밀양사(史)<br>밀양이 간직한 보물들이 밤이되면 깨어난다!<br>밀양이 간직한 역사 속 다양한 이야기들이 밤이 되면 조금 더 특별하게 다가온다.<br>2022 밀양문화재야행은 밀양이 가진 유·무형의 문화재와 밀양의 역사 속 신비로운 이야기들이 깨어나 다채로운 방식으로 관람객에게 다가가는 역사·예술·전통이 공존하는 축제이다.", 
'영남루 일원', NULL, NULL, '홈페이지 참조',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2755115 , '2022 푸드앤비어 페스티벌' , 20220902 , 20220904 , '경기도 고양시 일산동구 중앙로 1305-56 라페스타D', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/25/2844325_image2_1.jpg', 126.7683208644, 37.6610811570, 6, 31, 2, '031)927-9973~4', 
'인스타그램 <a href="https://www.instagram.com/p/ChTPVI-JxPG/?utm_source=ig_web_copy_link" target="_blank" title="새창 : 푸드앤비어 페스티벌">www.instagram.com</a><br>블로그 <a href="https://blog.naver.com/goyang_tca/222851747982" target="_blank" title="새창 : 푸드앤비어 페스티벌">https://blog.naver.com</a>', "2022 푸드앤비어 페스티벌은 시민, 지역상권과 함께 즐기는 고양시 종합 축제로 고양시민들에게 위로와 힐링의 시간을 마련하는 주민중심형, 지역상권연계형 행사이다.<br>위드 코로나, 고양시가 제시하는 새로운 축제문화의 패러다임, 안전한 축제를 기반으로 지역 상생, 주민 참여, 관광형 축제플랫폼으로 브랜드 구축.", 
'라페스타 문화의거리', NULL, NULL, '입장 무료<br>맥주 한잔 2,000원',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2755016 , '제10회 강주해바라기 축제' , 20220826 , 20220904 , '경상남도 함안군 강주4길 16', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/91/2844291_image2_1.jpg', 128.3322313624, 35.3208688405, 6, 36, 19, '055-580-4403~4406', 
'<a href="https://m.blog.naver.com/arahaman/222846724535" target="_blank" title="새창 : 제10회 강주해바라기 축제">https://m.blog.naver.com</a>', "함안군 법수면 강주마을 주민들이 힘을 합쳐 자체적으로 조성한 해바라기 꽃이 장관을 이루는 강주해바라기 축제가 올해로 10회째를 맞는다. 전체 해바라기 식재면적은 법수면 강주리 주변 20,000㎡에 이르며 전통과 문화를 부흥시켜 보자는 취지로 마을마다 지닌 끼를 모아 축제 한마당도 함께 펼쳐진다.", 
'법수면 강주마을 일원', NULL, NULL, '2,000원<br>무료입장 : 장애인, 미취학 어린이, 만70세 이상, 법수면민','전 연령', '약 1시간');

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2753041 , '제2회 피나클랜드 국화축제' , 20220923 , 20221127 , '충청남도 아산시 월선길 20-42', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/42/2827642_image2_1.jpg', 126.9263422708, 36.8725197718, 6, 34, 9, '041-541-2582', 
'<a href="https://blog.naver.com/pinnacle_land/222500749142" target="_blank" title="새창 : 제2회 피나클랜드 국화축제">blog.naver.com</a>', "피나클랜드에서 두번째로 선보이는 가을 '국화축제'. 수십가지 조형물들로 표현한 국화작품과 탁트인 풍경 속에 어우러진 가을 정취. 피나클랜드에서 직접 마을주민들과 함께 손수 키운 이백만송이 국화향기와 함께 가을의 정취를 느껴보자. 잔디광장에서는 그림그리기대회, 손글씨대회, 사진전, 할로윈, 음악회, 버블쇼, 마술쇼 등 매주 다양한 이벤트를 진행한다. 그리고 카페 드 피나클에서 준비한 가을 특선 메뉴와 축제장 특설 매장에서 진행하는 가을 대하축제를 함께 만나보자.<br>문의) 041-541-2582<br>※ 일부 행사는 현장상황에 따라 변경 및 취소될 수 있다.", 
'피나클랜드 수목원 일대', NULL, NULL, '성인 12,000원 / 청소년 10,000원 / 어린이 8,000원',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2751090 , '수원화성 미디어아트쇼' , 20220923 , 20221023 , '수원시 장안구 영화동 320-2', '수원시 장안구 영화동 320-2', 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/34/2836234_image2_1.jpg', 127.0120008348, 37.2872039225, 6, 31, 13, '031-290-3625', 
'<a href="https://www.swcf.or.kr/?p=317" target="_blank" title="새창 : 수원화성 미디어아트쇼">https://www.swcf.or.kr/</a>', "정조가 꿈꾸었던 ‘개혁 신도시 수원화성’을 현대의 다채로운 빛으로 연출한 미디어아트쇼이다.<br>지극한 효심과 백성에 대한 깊은 사랑으로 새로운 이상세계를 꿈꾸고 계획한 정조의 개혁 신도시 수원화성의 창조적 스토리를 ‘개혁의 꿈 - 개혁의 길 - 신도시 축성 - 호호부실, 인인화락’이라는 연결된 시간의 흐름으로 연출하였다.<br>작년 화서문에서 시작된 미디어아트쇼의 감동을 올해 화홍문에서 남수문 및 수원천 일원까지 그 이상의 감동으로 선사하도록 하겠다.", 
'수원화성 화홍문, 남수문 및 수원천 일원', NULL, NULL, '무료 *(일부 프로그램에서 요금 부과)',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2748395 , '2022 남구 청년예술제' , 20220916 , 20220918 , '대구광역시 남구 앞산순환로 478', '(대명동)', 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/69/2837969_image2_1.jpg', 128.5768987154, 35.8313434631, 6, 4, 1, '053-664-3264', 
'<a href="https://nam.daegu.kr/" target="_blank" title="새창 : 관광지">https://nam.daegu.kr</a>', "다양한 쟝르 청년 예술인들의 공연 축제", 
'대덕문화전당', NULL, NULL, '무료',NULL, '120분 정도');

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2740921 , '제21회 부산과학축전' , 20220827 , 20220828 , '부산광역시 해운대구 수영강변대로 120 영화의전당', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/45/2838345_image2_1.jpg', 129.1270687971, 35.1710029572, 6, 6, 16, '051-501-3124', 
'<a href="http://www.busansf.or.kr" target="_blank" title="새창 : 부산과학축전 홈페이지로 이동">http://www.busansf.or.kr</a>', "'영화의 도시', '과학문화도시' 부산에서 개최되는 「제21회 부산과학축전」<br>과학기술문화에 대한 시민의 관심과 참여를 확대하고자 한다.<br>'영화 도시' 부산의 고유 브랜드에 과학을 접목하여  씨네 사이언스 페스티벌을 개최한다.<br>영화의 원리부터 영화 속 다양한 과학기술 전시․체험할 수 있다.<br>영화와 과학의 융합 프로그램을 통해 생활 속 과학을 즐기고 소통하는 기회를 제공하는 부산의 과학 축제이다.", 
'영화의전당', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2740109 , '고창 청농원 핑크뮬리가든' , 20220916 , 20221106 , '전라북도 고창군 공음면 청천길 41-27', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/48/2848748_image2_1.jpg', 126.5350719884, 35.3736427850, 6, 37, 1, '063-561-6907', 
'<a href="http://gobluefarm.com/" target="_blank" title="새창 : 고창 청농원 핑크뮬리가든">http://gobluefarm.com/</a>', "고창 공음면에 위치한 스테이팜 관광지로, 여름에는 라벤더 정원, 수국정원, 가을에는 핑크뮬리 정원 관람 서비스를 제공하고 있으며 이 외에도 카페, 한옥스테이 시설을 이용할 수 있다. 약 4,000여평의 핑크뮬리 정원에는 다양한 포토존이 준비되어있고 경사진 정원을 따라 독특한 뷰가 매력적인 곳이다. 또한 반려견 동반입장도 가능해 반려견과 함께 좋은 추억을 남기기에 좋은 장소이다. 카페는 높은 천장의 탁트인 전경으로 넓은 잔디밭에서 자녀와 반려견이 뛰어노는동안 편안한 휴식이 가능하며 카페 뒤 대나무숲길과 라벤더 가든 옆 맥문동 산책길에서는 고요한 사색을 즐길 수 있다.", 
'고창 청농원 핑크뮬리가든', NULL, NULL, '입장료 5,000원',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2740046 , '한복문화주간' , 20221017 , 20221023 , '서울특별시 종로구 율곡로 33', '(안국동)', 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/00/2846400_image2_1.jpg', 126.9834786336, 37.5759615737, 6, 1, 23, '02-398-1621', 
'<a href="http://www.hanbokweek2022.com/" target="_blank" title="새창 : 한복문화주간">www.hanbokweek2022.com</a>', "* 사전행사<br>- 2022.09.01. (목) ~ 2022.09.12. (월)<br>- 스타필드 고양 센트럴 아트리움<br><br>* 본행사<br>- 2022.10.17. (월) ~ 2022.10.23. (일)<br>- 헤드쿼터 및 국내외 17개 국가 27개 도시<br><br>한복문화주간은 우리의 멋과 전통이 담긴 한복을 널리 알리고 일상 속에 한복 입는 문화를 확산하기 위해 열리는 전국 단위의 행사이다. 2022 한복문화주간은 총 2회에 걸쳐 만날 수 있다. 햇곡식이 익어가는 추석을 앞둔 9월 스타필드 고양에서, 낙엽으로 가로가 물들어가는 10월 본 행사인 하이커그라운드를 중심으로 국내외 곳곳에서 문을 연다. 다양한 쓰임의 한복을 한 자리에서 확인할 수 있는 기획 전시를 비롯해 전통문화 체험, 한복상점, 이벤트 등이 여러분을 맞이할 예정이다.", 
'스타필드 고양 1층 센트럴아트리움', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2739974 , '대전청년주간' , 20220916 , 20220918 , '대전광역시 유성구 대덕대로 480 대전 C.T센터, 스튜디오큐브', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/79/2835579_image2_1.jpg', 127.3802705364, 36.3759931713, 6, 3, 4, '042-383-6855', 
'<a href="https://www.daejeonyouthportal.kr/youth/youthWeekDetail.do?commonMenuNo=145_156&weekSeq=7" target="_blank" title="새창 : 대전청년주간">www.daejeonyouthportal.kr/</a>', "코로나19로 2년 동안 온라인으로 개최 되었던 대전청년주간이 드디어 오프라인으로 돌아왔다.<br>2022 대전청년주간은 지난 2년간 단절된 관계와 잃어버린 문화를 회복하고 다시 연결하자는 의미에서 <다시 만난 우리>를 슬로건으로 개최된다.<br>공연·강연·체험·참여형콘텐츠 등 다양한 프로그램이 풍성하게 마련되어 있으니 많이 놀러오길 바란다!", 
'엑스포 과학공원한빛탑', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2738394 , '2022 충주 달달 문화재 야행' , 20220922 , 20220924 , '충청북도 충주시 탑정안길 6', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/79/2836079_image2_1.jpg', 127.8662090641, 37.0178921702, 6, 33, 11, '043-723-1350/1358', 
'<a href="http://www.cjcf.or.kr/" target="_blank" title="새창 : 관광지">www.cjcf.or.kr</a>', "'2022년 충주 달달 문화재 야행'은 9월 22(목)~24(토) 사흘간 개최되며, 충주 중앙탑 사적공원 일원에서 펼쳐진다. 또한 2021년 문화재청에서 주최하는 문화재 야행(夜行) 공모사업에 선정된 「2022 충주 달달 문화재 야행」은 ‘중원의 역사를 밝히다’ 라는 부제를 가지고 탑평리7층석탑(중앙탑)을 중심 거점으로 하여 충주지역을 대표하는 유․무형 문화재를 활용한 다양한 프로그램을 선보일 예정이다. 주최 주관은 (재)충주중원문화재단, 충주시, 문화재청이다.", 
'충주 중앙탑 사적공원 일원', NULL, NULL, '유/무료','전연령가능', NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2737577 , '2022 익산 미륵사지 세계유산 미디어아트 페스타' , 20220903 , 20221003 , '전라북도 익산시 미륵사지로 362 국립익산박물관', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/01/2846401_image2_1.jpg', 127.0279090206, 36.0101982257, 6, 37, 9, '063-859-5708 (익산시 역사문화재과)', 
'<a href="https://iksanlightfesta.kr/" target="_blank" title="새창 : 익산 미륵사지 세계유산 미디어아트 페스타">https://iksanlightfesta.kr</a>', "‘2022 익산 미륵사지 세계유산 미디어아트 페스타’는 문화재와 예술, 디지털로 익산 미륵사지를 새롭게 경험하는 헤리티지 페스티벌이다.<br>백제 최대의 사찰이었던 익산 미륵사지는 유네스코(UNESCO) 등재 백제역사유적지구 중 하나이며, 우리나라 석탑에서 규모가 가장 크고, 창건 시기가 명확하게 밝혀진 석탑이다. 9월 3일(토)부터 10월 3일(월)까지 지난해에 이어 한층 풍성해진 프로그램으로 두 번째 페스티벌을 개최한다.<br>미륵사지 동탑과 서탑을 연결한 대형스크린에서 매일 저녁 메인쇼 <시그니처 미디어파사드>를 비롯하여 <XR(확장현실) 미디어퍼포먼스>가 펼쳐진다. 초고화질의 프로젝션맵핑과 라이트쇼로 만나보는 예술작품이 익산 미륵사지의 밤하늘을 화려하게 수놓는다.<br>익산 미륵사지 전역이 야경을 신비롭게 느낄 수 있는 황홀한 나이트투어가 됩니다. 진입로부터 아름다운 설치미술과 경관조명, 다채로운 콘텐츠로 방문객을 맞이한다.", 
'익산 미륵사지 석탑일원', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2737223 , '2022 울산에이팜(울산아시아퍼시픽뮤직미팅)' , 20220902 , 20220904 , '울산광역시 남구 번영로 200 울산문화예술회관', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/71/2830971_image2_1.jpg', 129.3261549981, 35.5429399430, 6, 7, 2, '052-259-7931', 
'<a href="https://www.apamm.org/" target="_blank" title="새창 : 2022 울산아시아퍼시픽뮤직미팅(울산에이팜)">https://www.apamm.org/</a><br><a href="https://www.instagram.com/apamm_/" target="_blank" title="새창 : 2022 울산아시아퍼시픽뮤직미팅(울산에이팜)">https://www.instagram.com/apamm_/</a><br><a href="https://www.facebook.com/asiapacificmusicmeeting/" target="_blank" title="새창 : 2022 울산아시아퍼시픽뮤직미팅(울산에이팜)">https://www.facebook.com</a>', "울산에이팜은 아시아-태평양 지역의 다양한 로컬음악의 예술적 가치를 발굴하고 해외에 소개하는 글로벌 뮤직 플랫폼이다. 훌륭한 음악을 울산 시민들, 국내외 음악인들과 함께 나누고, 울산에이팜의 네트워크를 통해 음악과 아티스트의 국제적인 교류를 이끌어낸다. 2012년에 시작되어 오랜 기간 예술가들과 시민들의 사랑을 받으며 성장해온 울산에이팜은 점차 그 입지를 넓혀가며 음악시장의 주요한 거점으로 자리 잡았다. ‘음악으로 세상을 연결하는 뮤직 플랫폼’이라는 슬로건에 따라 울산에이팜은 음악 공연뿐 아니라 위원회의, 학술회의, 교류·협력회의, 관광 등 다양한 프로그램을 함께 운영하고 있다.", 
'울산문화예술회관', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2737163 , '2022 서울안보대화 (SEOUL DEFENSE DIALOGUE 2022)' , 20220906 , 20220908 , '서울특별시 중구 을지로 30 롯데호텔', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/00/2826900_image2_1.jpg', 126.9810458210, 37.5654016461, 6, 1, 24, '070-5101-5428', 
'<a href="https://sdd.mnd.go.kr/mbshome/mbs/sdd/index.jsp" target="_blank" title="새창 : 관광지">sdd.mnd.go.kr</a>', "서울안보대화는 동북아시아 지역을 넘어 전 세계의 평화를 위한 실질적 안보토론과 국방협력의 장으로서, 2012년부터 매년 개최된 국방차관급 다자안보회의이다.", 
'롯데호텔 서울', NULL, NULL, '비공개(무료)',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2736064 , '김제 문화재 야행' , 20220902 , 20220904 , '전라북도 김제시 향교길 89-3', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/34/2844334_image2_1.jpg', 126.8798526905, 35.8005417865, 6, 37, 3, '063-540-3517', 
'<a href="http://www.xn--4k0bz9vj3h89b7pr85dsib.com/" target="_blank" title="새창 : 관광지">www.김제문화재야행.com</a>', "8夜를 테마로 한 다양한 전시, 체험, 공연을 통해 문화유산을 다채롭게 즐길 수 있는 김제의 밤에 여러분을 초대한다.", 
'18:00 ~ 22:00', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2736042 , '춘천 커피도시 페스타 Let\'s COFFEE, 춘천' , 20220916 , 20220918 , '강원도 춘천시 서면 박사로 854', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/72/2839372_image2_1.jpg', 127.6918882316, 37.8930876473, 6, 32, 13, '033-245-6993', 
'<a href="http://www.cccf.co.kr/" target="_blank" title="새창 : 관광지">http://www.cccf.co.kr/</a>', "춘천커피산업 육성과 춘천커피도시 브랜드 확장을 위한 ‘2022 춘천커피도시페스타’가 9월16일(금)~18일(일)까지 춘천애니메이션박물관일대와 메타버스가상공간 등에서 다채롭게 열린다.<br>이번 2022 춘천커피도시페스타는‘SNS (Shot “N” Shot=샷 앤 샷)’이라는 컨셉으로 커피의 농도를 나타내는 샷과 촬영의 단위인 샷을 담아서 행사장 전체를 하나의 멋진 카페로 구성해 개최한다.<br><br>9월 16일(금)에서 9월 18일(일)까지 낮12시부터 오후8시까지 춘천 애니메이션 박물관 일원에서 펼쳐지는 오프라인 행사는 춘천 시내 로스터리 커피숍 40여개 업소가 참여해 나름의 커피 맛을 선보일 예정이다.", 
'애니메이션 박물관 일원', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2736033 , '부산인디커넥트페스티벌 2022' , 20220901 , 20220904 , '부산광역시 동구 충장대로 206 부산항 국제여객터미널', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/27/2831027_image2_1.jpg', 129.0491742511, 35.1177852539, 6, 6, 5, 'BIC2022 운영사무국 010-3371-2999<br>BIC조직위 070-8855-5058', 
'홈페이지 <a href="https://bicfest.org/" target="_blank" title="새창 : 부산인디커넥트페스티벌">https://bicfest.org</a><br>페이스북 <a href="https://www.facebook.com/BICfestival" target="_blank" title="새창 : 부산인디커넥트페스티벌">https://www.instagram.com/cafe_osongwave/</a><br>인스타그램 <a href="https://www.instagram.com/bicfest_official/" target="_blank" title="새창 : 부산인디커넥트페스티벌">https://www.instagram.com</a><br>트위터 <a href="https://twitter.com/BIC_Festival" target="_blank" title="새창 : 부산인디커넥트페스티벌">https://twitter.com</a>', "인디게임 개발자와 게이머를 위한 글로벌 인디게임 페스티벌<br>부산인디커넥트페스티벌(BIC Festival)은 2015년부터 매년 대한민국 부산에서 열리는 글로벌 인디게임 페스티벌로, 인디게임 만을 위한 단일 행사로는 대한민국 최대규모로 성장했다.<br>올해 2022년도에는 9월 1일 부터 4일까지 2년만에 더욱 확대된 규모의 오프라인 행사로 부산항국제전시컨벤션센터에서 진행되며, 온라인 행사도 9월 1일 부터 30일까지 BIC 공식누리집에서 진행된다.<br>- 9월 1일(목) ~2일(금) : 비즈니스 데이 (일반 관람객 관람 불가)<br>- 9월 3일(토)~4일(일) : 페스티벌 데이", 
'부산항국제전시컨벤션터', NULL, NULL, '얼리버드 예매 기간 : 2022. 8.5.(금), 10:00 ~ 9.2.(금), 23:59 (네이버 예약 페이지에서 구매 가능)<br>- 성인 : 12,000원 / 청소년 : 9,600원<br>오프라인 현장 예매기간 : 2022. 9.1.(목), 9:00 ~ 9.4.(일), 9:00  ~ 17:00<br> - 성인 : 15,000원 / 청소년 12,000원',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2735210 , '세계유산축전 수원화성' , 20221001 , 20221022 , '경기 수원시 장안구 영화동 320-2', '경기 수원시 장안구 영화동 320-2', 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/46/2833946_image2_1.jpg', 127.0120008348, 37.2872039225, 6, 31, 13, '031-228-1010', 
'홈페이지<a href="https://www.swcf.or.kr/shcf/" target="_blank" title="새창 : 관광지">https://www.swcf.or.kr/shcf/</a><br>인스타그램<a href="https://www.instagram.com/suwonfestival/" target="_blank" title="새창 : 관광지">https://www.instagram.com/suwonfestival/</a><br>유튜브<a href="https://www.youtube.com/c/%EC%88%98%EC%9B%90%EB%AC%B8%ED%99%94%EC%9E%AC%EB%8B%A8%EC%9C%A0%ED%8A%9C%EB%B8%8C " target="_blank" title="새창 : 관광지">www.youtube.com</a>', "유네스코 세계유산 수원화성의 생생한 가치를 느낄 수 있는 <세계유산축전 수원화성>이다.<br>이번 행사에서는 세계유산 수원화성에 깃든 효의 가치, 축성 과정에 담긴 실용적 가치, 정조대왕 애민사상의 가치, 수원화성의 미적 가치를 확산하고 향유하고자 한다.<br>이를 위해 수원화성 축성과 관련된 원행을묘정리의궤, 화성성역의궤, 정리의궤 등 역사적 기록을 기반으로 공연, 전시, 체험, 교육, 투어 등 다양한 콘텐츠를 선보인다.<br>온·오프라인을 통해 이루어지는 <세계유산축전 수원화성>을 통해, 수원화성의 의미를 보다 깊이 이해하게 될 것이다.", 
'수원화성 일원', NULL, NULL, '일부 프로그램 유료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2734974 , '제29회 우리꽃 전시회' , 20220920 , 20220925 , '경기도 포천시 소흘읍 광릉수목원로 415', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/95/2830895_image2_1.jpg', 127.1625072572, 37.7527359115, 6, 31, 29, '031-540-2000', 
'<a href="http://knplants.kr/" target="_blank" title="새창 : 관광지">www.우리꽃전시회.kr</a>', "우리 터에서 피고 자란 우리 고유의 꽃이 건네는 아름다운 응원과 따뜻한 위로를 많은 분들과 나눌 수 있는 시간과 공간으로 구성되어있다.<br>제29회 우리꽃 공모전을 통해 입상한 작품전시회 뿐 아니라 야생화/ 세밀화 특별전시회 부대행사로 함께 진행한다.", 
'국립수목원 산림박물관 앞', NULL, NULL, '국립수목원 입장료 후 무료 관람 어른 1000 청소년 - 700원  어린이(12세 이하) 500원  유아(미취학) 무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2733405 , '2022 서대문 문화재야행' , 20220924 , 20220925 , '서울특별시 서대문구 통일로 247 독립문역', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/28/2833028_image2_1.jpg', 126.9577643533, 37.5744612869, 6, 1, 14, '070-7575-2351', 
'홈페이지 <a href="http://www.sdmnightroad.com/" target="_blank" title="새창 : 서대문 문화재야행">http://www.sdmnightroad.com/</a><br>인스타그램 <a href="https://www.instagram.com/sdm.nightroad/" target="_blank" title="새창 : 서대문 문화재야행">www.instagram.com/sdm.nightroad</a>', "2022 서대문 문화재야행이 오는 9월 24일부터 25일까지 서대문 독립공원과 서대문형무소역사관 일대에서 개최된다.<br>올해 서대문 문화재야행은 서대문구에 위치한 문화재들이 지닌 역사적 의미를 배경으로 혼란했던 근현대사를 살았던 청년들 중 <윤동주>에 집중한다.", 
'서대문구 일대 / 독립공원', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2732131 , '제2회 같음페스티벌 ‘Fresh Start’' , 20220816 , 20220819 , '경기도 성남시 분당구 성남대로 808 성남아트센터', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/10/2828010_image2_1.jpg', 127.1286175581, 37.4025232047, 6, 31, 12, '031-781-7797', 
'<a href="https://www.kateum.com" target="_blank" title="새창 : 제2회같음페스티벌">www.kateum.com</a>', "올해로 두 번째를 맞은 같음페스티벌은 'Fresh Start' 란 주제로 3일간 광림아트센터 장천홀과 성남아트센터 콘서트홀에서 진행될 예정이다.<br>개막공연인 NEW START를 시작으로 RESTART 공연을 이어 폐막공연 FRESH START로 마무리 되며, 신진 예술가들과 여러 초청 예술가들이 멋진 무대를 선보일 것이다.<br>공연 중 콘서트가이드와 연주자의 인터뷰 진행으로 관객과 함께 소통하고 즐기는 페스티벌이 될 것이며, 코로나로 지친 우리 일상이 새롭게 시작된다는 의미로 과거의 그저 평범하고 소중했던 시간들이 다시 돌아오길 바란다.", 
'성남아트센터 콘서트홀', NULL, NULL, 'VIP10만원 R5만원 A3만원<br>8월16일, 17일 예매처 <a href="https://ticket.yes24.com/Perf/42913" target="_blank" title="새창 : 예매처">https://ticket.yes24.com</a><br>8월19일 <a href="https://tickets.interpark.com/goods/22008986" target="_blank" title="새창 : 예매처">https://tickets.interpark.com</a>',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2730685 , '대한민국 목재산업 박람회(WOOD FAIR 2022)' , 20220929 , 20221002 , '대전광역시 유성구 엑스포로 107 대전컨벤션센터', NULL, 'A02080600', 'http://tong.visitkorea.or.kr/cms/resource/60/2844260_image2_1.png', 127.3916945410, 36.3750212633, 6, 3, 4, '02-848-0199', 
'<a href="http://woodfair.or.kr/" target="_blank" title="새창 : 대한민국 목재산업 박람회 홈페이지로 이동">http://woodfair.or.kr/</a>', "2022 대한민국 목재산업박람회가 9월 29일부터 10월 2일 4일간 '산림 르네상스의 시작, 목재는 생활 속의 숲!' 이라는 주제로 대전컨벤션센터 제2전시장에서 개최된다. 
산림청의 지원으로 매년 열리는 목재산업박람회는 국내 목재산업의 현재를 보여주고 미래를 예측하게 하는 행사로 목재의 가치와 효용 증진 및 산림정책 홍보, 대국민 인식 전환 계기를 마련하며 지속 가능한 탄소중립의 산림 흡수원 기능 증진 및 사회적 가치 확산을 목적으로 하고 있다.
또한 목재산업 육성을 통한 새로운 일자리 창출로 경제 활성화에도 기여할 것을 기대하고 있다.", 
'대전컨벤션센터 제2전시장', NULL, NULL, NULL,NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2728867 , '대한민국문화의달(밀양)' , 20221014 , 20221016 , '경상남도 밀양시 중앙로 324 영남루', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/30/2850630_image2_1.jpg', 128.7547091490, 35.4917461810, 6, 36, 7, '055-359-4597', 
'<a href="http://culturemoon.co.kr" target="_blank" title="새창 : 관광지">http://culturemoon.co.kr</a>', "2022 대한민국 문화의 달 행사는 경상남도(밀양시)에서 개최된다. 2022년은 아리랑「유네스코 세계인류무형유산」등재 10주년으로 대한민국 3대 아리랑 공동 협의체 밀양, 정선, 진도 3개 시군이 공동 참여하여 아리랑, 지역문화, 청년예술가, 미래세대를 주제로 공연, 전시, 인형극, 체험 프로그램으로 구성된다.", 
'영남루 밀양강변 일원', NULL, NULL, '무료','전연령', NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2728613 , '[제주] 제주민속촌 귀몽아일랜드' , 20220701 , 20221017 , '제주특별자치도 서귀포시 표선면 민속해안로 631-34', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/60/2825160_image2_1.jpg', 126.8430383774, 33.3213690665, 6, 39, 3, '064-787-4501', 
NULL, "가장 제주다운 곳, 제주민속촌의 납량특집 '지박령의 원한'<br>- point 1  GHOST ZONE ( 고스트존 ) : 제주 지박령들과 만나는 오싹한 공포체험!<br>- point 2  SAVE ZONE ( 세이브존 ) : 미디어아트가 펼쳐지는 제주민속촌의 밤!<br>- point 3  먹거리 야시장 : 공포컨셉의 유니크한 야시장에서 즐기는 먹거리와 플리마켓!", 
'제주민속촌', NULL, NULL, '성인/청소년 : 정가 25,000원 - 할인가 : 22,500원 ( 10%할인 )<br>소인 : 정가 15,000원 - 할인가 : 13,500원 ( 10%할인 )',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2728601 , '부산국제광고제' , 20220825 , 20220827 , '부산광역시 해운대구 APEC로 55 벡스코', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/84/2830684_image2_1.jpg', 129.1355209016, 35.1687450332, 6, 6, 16, '051-623-5539', 
'홈페이지 <a href="https://www.adstars.org/adstar/main/AdstarMainView.do" target="_blank" title="새창 : 부산국제광고제">https://www.adstars.org</a><br>인스타그램 <a href="https://www.instagram.com/madstars/" target="_blank" title="새창 : 부산국제광고제">www.instagram.com</a><br>블로그 <a href="https://blog.adstars.org/" target="_blank" title="새창 : 부산국제광고제">https://blog.adstars.org/</a><br>링크드인 <a href="https://www.linkedin.com/company/ad-stars-advertising-awards-/" target="_blank" title="새창 : 부산국제광고제">www.linkedin.com</a><br>텀블러 <a href="https://www.tumblr.com/blog/view/madstars-festival" target="_blank" title="새창 : 부산국제광고제">www.tumblr.com</a><br>트위터 <a href="https://twitter.com/_MADSTARS" target="_blank" title="새창 : 부산국제광고제">https://twitter.com</a><br>페이스북 <a href="https://www.facebook.com/ADSTARS.Kor" target="_blank" title="새창 : 부산국제광고제">www.facebook.com</a><br>영문 페이스북 <a href="https://www.facebook.com/ADSTARS.Eng/" target="_blank" title="새창 : 부산국제광고제">www.facebook.com</a>', "부산국제광고제'는 아시아 최대 규모이자 국내 유일의 국제광고제이다.<br>‘세상을 바꾸는 창조적인 솔루션을 공유’ 하는 마케팅 ∙ 광고 ∙ 디지털 콘텐츠 관련 국제 행사로써, 광고인 만이 즐기는 행사를 넘어 창의력과 아이디어를 가진 일반인도 함께하는 전 세계인의 축제로 자리 매김했다.<br><br>'2022 부산국제광고제'는 'MAD(세상을 바꿀 기상천외한 아이디어를 찾아라)'를 주제로 오는 8월 25일(목)부터 8월 27일(토)까지 부산 벡스코 및 해운대 일원과 온라인 페스티벌 홈페이지에서 개최된다.", 
'부산 벡스코 및 해운대 일원<br>온라인 페스티벌 홈페이지', NULL, NULL, '∙ 일반인 - Complete 패키지(900,000원)<br>            - Conference 패키지(500,000원)<br>∙ 학생 - Student 패키지(100,000원)<br>∙ 온라인 전용 - ON Line 패키지(100,000원)','전 연령', NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2726864 , '세계유산축전:경상북도 안동·영주' , 20220903 , 20220925 , '경상북도 안동시 전서로 186', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/29/2830929_image2_1.jpg', 128.5289326597, 36.5503608400, 6, 35, 11, '054-851-7182', 
'홈페이지 <a href="http://whf2022.kr/" target="_blank" title="새창 : 세계유산축전:경상북도 안동·영주">http://whf2022.kr/</a><br>인스타그램  <a href="https://www.instagram.com/2022_whf_and_you/" target="_blank" title="새창 : 세계유산축전:경상북도 안동·영주">https://www.instagram.com</a>', "이동하는 유산<br>2022 세계유산축전-경북에서는 안동과 영주가 지닌 세계유산의 역사적 가치와 고전적 미를 동시대 예술가, 건축가, 작가들의 이야기로 경유하여, 유산의 문화 예술적 가치를 가시화하고 과거, 현재, 미래를 잇는 통합적 감각을 제공하고자 한다.<br>세계유산으로서의 ‘탁월한 보편적 가치(Outstanding Universal Value)’를 보다 혁신적으로 흥미롭게 제시하여 유산을 새롭게 발견하고, 쉽게 만나고, 미래로 지속하고 확장하는 기회가 될 것이다.", 
'안동: 하회마을, 도산서원, 병산서원, 봉정사<br>영주: 소수서원, 부석사', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2726029 , '2022 KOREA 월드푸드챔피언십' , 20221028 , 20221030 , '서울특별시 서초구 강남대로 27 AT센터', NULL, 'A02081300', 'http://tong.visitkorea.or.kr/cms/resource/58/2831458_image2_1.jpg', 127.0407514903, 37.4673918780, 6, 1, 15, '02)802-7666/7669', 
'<a href="http://www.kcf90.com"_blank" title="새창: 홈페이지로 이동">http://www.kcf90.com</a>', "2022 KOREA 월드푸드 챔피언십은 하반기 대한민국 단일요리대회 중 전국 최대 규모의 행사로 세계적 수준의 식품조리 및 가공 전문인력을 앙성하고, 나아가 한식의 세계화를 위한 다양한 정보를 공유하고 관련 이슈를 협의하는 자리이다.<br>지난 2021년 KOREA 월드푸드 챔피언십은 조리 종사자와 조리에 관심이 많은 학생 및 일반인들을 대상으로 총 2,400여명의 참가자로 국내 유일무이한 최고의 요리대회라 할 수 있다.<br>2022 KOREA 월드푸드 챔피언십을 통해 조리인의 긍지와 자부심을 심어주고 외식산업 발전 및 국민의 식생활 증진에 이바지한다.", 
'서울특별시 서초구 강남대로 27 AT Center 제 1전시장', NULL, NULL, '미정(추후 홈페이지 공지)',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2725188 , '도봉옛길 문화제' , 20221026 , 20221029 , '서울특별시 도봉구 도봉로 552', '(창동)', 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/60/2835660_image2_1.jpg', 127.0384686195, 37.6541590259, 6, 1, 10, '02-905-4026', 
'도봉문화원: <a href="http://www.dobong.or.kr"_blank" title="새창: 홈페이지로 이동">http://www.dobong.or.kr</a><br>도봉옛길문화제 <a href="https://dobongfesta.modoo.at"_blank" title="새창: 홈페이지로 이동">https://dobongfesta.modoo.at</a>', "도봉옛길 문화제는 서울 도봉구의 대표적 문화유산인 도봉옛길의 역사·문화적 가치를 알리기 위해 마련된 행사이다. 도봉옛길은 조선시대 수도 한양과 한반도 각지를 잇는 주 간선도로 중 제2로인 경흥대로의 도봉구 구간을 지칭한다. 도봉구의 네 권역(창동, 쌍문동, 방학동, 도봉동)을 남북으로 관통하는 도봉옛길은 지금의 도봉로가 만들어지기 전까지 주로 사용되던 교통로였으며, 과거부터 현재까지 주민들의 일상이 묻어있는 공간이다.<br>시간을 거슬러 올라, 도봉옛길은 조선 초기 태종 대 함흥차사가 걸었던 길이고, 세종 대 4군6진으로 군대가 출정하는 길이었다. 이 밖에도 도봉산과 도봉서원을 찾는 선비, 북어를 어깨에 가득 멘 보부상 등 다양한 사람이 이 길에 올랐다. 한국전쟁 당시에는 서울로 쳐들어오는 북한의 침입로이기도 했다. 그리고 오늘 도봉구의 주민뿐 아니라 다양한 사람이 도봉옛길을 삶의 터전으로 삼아 살아가고 있다.<br>도봉옛길 문화제는 도봉옛길의 역사문화적 가치를 소개하고 지역주민의 일상 속에서 문화예술을 향유할 수 있도록 마련한 지역문화축제다. 지역문화예술인으로 구성된 도봉옛길 예술상단은 도봉옛길 곳곳에서 주민들을 찾아가는 거리공연을 연다. 더불어 도봉옛길 거리행렬, 기획전시 및 체험프로그램, 도봉문화굿즈 등 다양한 형태의 콘텐츠를 통해 도봉옛길을 함께 누릴 수 있도록 했다. 지역 주민과 문화유산, 문화예술인이 서로 연계하는 문화제를 통해 현대사회에서 점차 소실되고 있는 지역 정체성을 찾아가는 행사다.<br><br>※행사의 형태와 일정은 코로나바이러스감염증-19 대응지침에 따라 변경될 수 있다.", 
'장소 확인 중', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2724153 , '군산문화재야행' , 20220825 , 20220827 , '전라북도 군산시 구영2길 9', '(신창동)', 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/37/2829437_image2_1.jpg', 126.7079326463, 35.9877258361, NULL, 37, 2, '063)454-3922', 
'<a href="https://culture-nightgunsan.kr/" target="_blank" title="새창 : 군산문화재야행">https://culture-nightgunsan.kr/</a>', "군산 문화재 밀집구간에서 야간에 문화재를 향유하는 야간형 행사이다.  군산 근대역사지구에 방문하는 모든 방문&관광객들이 45개 이상 프로그램으로 다양한 볼거리와 체험거리로 한 여름밤 군산 문화재를 가족,연인,친구와 함께 알아가는 야간형 행사이다.", 
'군산 내항 및 원도심 일원', NULL, NULL, '무료(일부 체험행사 유료)',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2724134 , '비엔날레 바캉스 문화콘서트' , 20220813 , 20220827 , '광주광역시 북구 비엔날레로 111', '(용봉동)', 'A02081000', 'http://tong.visitkorea.or.kr/cms/resource/91/2837191_image2_1.jpg', 126.8902591590, 35.1826203741, 6, 5, 4, '062-410-8227', 
'<a href="https://www.instagram.com/biennale_mediafacade/" target="_blank" title="새창: DMF:W 인스타그램으로 이동">
    www.instagram.com/biennale
</a>', "바캉스 시즌 기다리던 비엔날레 문화콘서트가 돌아왔다!<br>풍선아트체험, 깡통열차탑승 등 문화체험프로그램과 매직버블쇼 등 버스킹 공연과 미디어파사드 전시가 있다.", 
'비엔날레전시관 광장(야외)', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2723394 , '호남제일성, 전라감영 역사의 울림' , 20220702 , 20220924 , '전라북도 전주시 완산구 전라감영로 55 전라감영', NULL, 'A02081300', 'http://tong.visitkorea.or.kr/cms/resource/69/2825169_image2_1.jpg', 127.1455841839, 35.8157779693, 6, 37, 12, '063-232-9938', 
'<a href="https://blog.naver.com/artf9938" target="_blank" title="새창 : 호남제일성, 전라감영 역사의 울림">https://blog.naver.com</a>', "'호남제일성, 전라감영 역사의 울림'은 조선왕조 500년 동안 전라도와 제주도의 정치, 경제, 문화를 아우른 최고의 통치기관 '전라감영'에서 조선의 역사, 관찰사의 일상을 스토리텔링하고, 역사적 사실을 기반으로 한 야외 방탈출 이벤트를 진행하는 전주의 역사+체험+공연이 결합된 전라감영 특별 프로그램이다.", 
'전라감영', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2722473 , '춘천공연예술제' , 20220809 , 20220820 , '강원도 춘천시 후석로420번길 7', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/86/2823086_image2_1.jpg', 127.7451779767, 37.8879559047, 6, 32, 13, '033-251-0545', 
'<a href="http://ccaf.or.kr"_blank" title="새창: 홈페이지로 이동">http://ccaf.or.kr</a>', "무대 위 펼쳐지는 공연예술의 율동성, 몸과 마음을 휘감는 살핌(Care)의 에너지<br>춘천공연예술제(구 춘천아트페스티벌)는 각자의 것을 모두에게 나누자는 십시일반의 정신으로 출발한 축제이다.<br>2022년은 상호 존중과 협력을 중요시하는 ‘살핌’의 의미를 되새겨보고, 몸과 마음의 살핌에 대한 메시지를 전달한다.", 
'축제극장몸짓, 춘천인형극장, 담작은도서관', NULL, NULL, '정가 30,000원<br>[ASAP 티켓] 빨리 예매할수록 높은 할인 가격! 예매율에 따라 단계별로 적용된다. (1단계 : 예매율 40%까지 5,000원 - 약 83% 할인가)<br>- 1단계 (예매율 0~40%) : 5,000원<br>- 2단계 (예매율 40~60%) : 10,000원<br>- 3단계 (예매율 60~80%) : 15,000원<br>- 4단계 (예매율 80~90%) : 20,000원<br>- 5단계 (예매율 90~100%) : 30,000원 / 정가','[무용] 만 12세 이상<br>[음악, 어린이] 전체관람가', NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2720203 , '2022 서울거리공연 [구석구석 라이브]' , 20220501 , 20221231 , '서울특별시 마포구 연남로1길 55', '(연남동)', 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/62/2820962_image2_1.jpg', 126.9204598433, 37.5595179109, 6, 1, 13, '02-542-2695', 
'<a href="https://seoulbusking.com/" target="_blank" title="새창 : 2022 서울거리공연 [구석석 라이브]">https://seoulbusking.com/</a>', "서울 곳곳의 야외 거리공연으로 시민들에게는 문화공연 향유 기회를 확대하고, 공연가에게는 문화예술활동의 공간을 제공하여 ‘문화시민도시, 시민행복도시 서울’ 을 구현", 
'서울도심 관광명소', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2717506 , '전주 경기전 “수복청 상설공연”' , 20220604 , 20221016 , '전라북도 전주시 완산구 태조로 44', '(풍남동3가)', 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/54/2820154_image2_1.jpg', 127.1493699447, 35.8162807559, NULL, 37, 12, '063-232-9938', 
'<a href="https://www.instagram.com/culture__art/"_blank" title="새창: 홈페이지로 이동">www.instagram.com</a>', "전주 한옥마을 경기전에 내에 있는 수복청에서 펼쳐지는 “돌아온 이야기꾼들의 단막창극” 공연이다.<br><br>전주의 대표 문화유산인 경기전 속의 수복청이라는 공간을 다양하게 활용하고, 기존의 판소리를 현대적인 감각으로 재해석해 편안한 분위기에 이뤄지는 공연이다.<br>이 공간은 문화와 함께 문화유산에서 잠시 쉬어갈 수 있는 휴식처로써 제공되며, 경기전을 찾은 관객들에게는 국악기로 듣는 흥겨운 우리 음악과 유쾌한 이야기를 만날 수 있는 뜻밖의 선물같은 공연이 될 것이다.", 
'전주 한옥마을 경기전', NULL, NULL, '경기전 입장 시 무료','전연령', NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2713812 , '세계유산 활용프로그램 <수원화성 낭만소풍>' , 20220506 , 20220826 , '경기도 수원시 장안구 영화동 320-2', NULL, 'A02081300', NULL, 127.0120008348, 37.2872039225, 6, 31, 13, '031-290-3573', 
'<a href="https://www.swcf.or.kr/?p=29_view&idx=2318" target="_blank" title="새창: 수원문화재단 홈페이지로 이동">https://www.swcf.or.kr/?p=29_view&idx=2318</a>', "'수원화성 낭만소풍'은 문화관광해설사와 함께 세계유산을 활용하여 세계유산의 보편적 가치(Outstanding Universal Value 유네스코 세계유산 등재 기준) 전달 및 수원화성 역사 이야기 기반 투어 및 체험 프로그램이다. 세계유산에 내재된 고유한 가치 및 역사적 의미를 지역공동체 자원, 문화 및 예술활동과 결합하여 공연, 문화활동, 관광자원 등으로 창출하는 문화재 향유를 위한 사업으로 문화재청과 수원시가 함께한다.", 
'수원화성 일원(창룡문, 동장대, 화홍문, 용연, 동암문)', NULL, NULL, '2~4인 40,000원 / 5일 45,000원 / 6인 50,000원',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2713558 , '강원세계산림엑스포' , 20230504 , 20230606 , '강원도 고성군 토성면 잼버리로 244', NULL, 'A02080600', 'http://tong.visitkorea.or.kr/cms/resource/24/2804924_image2_1.jpg', 128.5001657397, 38.2236839691, 6, 32, 2, '033-818-2158', 
'홈페이지 <a href="http://www.gwfe.or.kr" target="_blank" title="새창: 홈페이지로 이동">http://www.gwfe.or.kr</a><br>사전예약 <a href="http://ticket.yes24.com/New/Perf/Detail/Detail.aspx?IdPerf=40444" target="_blank" title="새창 : 강원세계산림엑스포">http://ticket.yes24.com</a>', "2023 강원세계산림엑스포는 오는 2023년 5월 4일부터 6월 6일까지 34일 동안 \"세계, 인류의 미래, 산림에서 찾는다\"라는 주제로 고성군 토성면에 위치한 세계잼버리수련장과 설악~금강권을 연결하는 고성, 속초, 인제, 양양 일원에서 개최된다.", 
'강원도세계잼버리수련장', NULL, NULL, '보통권 :<br>일반(만 19세 ~ 64세) 10,000원(예매 8,000원)<br>청소년(만 13세 ~ 18세) 7,000원(예매 6,000원)<br>어린이(만 7세 ~ 12세) 5,000원(예매 4,000원)<br><br>단체권 :<br>일반(만 19세 ~ 64세) 8,000원<br>청소년(만 13세 ~ 18세) 6,000원<br>어린이(만 7세 ~ 12세) 5,000원<br>※ 내국인 :<br>20명 이상 / 외국인 : 10명 이상, 예매요금 동일, 동시입장<br><br>우대권 :<br>일반(만 19세 ~ 64세) 5,000원(예매 5,000원)<br>청소년(만 13세 ~ 18세) 3,500원(예매 3,500원)<br>어린이(만 7세 ~ 12세) 2,500원(예매 2,500원)<br>※ 만 65세 ~74세, 경증(4~6급)장애인, 현역군경(의무복무자), 강원도민<br><br>가족권 : 24,000원(예매 20,000원)<br><br>※ 무료입장 : 국가(독립)유공자, 국민기초생활수급자, 중증(1~3)급 장애인 및 보호자 1명, 만 75세 이상, 만 7세 미만, 공무수행자, 국빈외교사절단 및 수행자, 단체인솔자(20명당 1인), 학교단체 인솔 교사',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2704311 , '파주 초리골 초록 페스티벌' , 20220603 , 20220831 , '경기도 파주시 법원읍 초리골길 138-9', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/21/2821621_image2_1.jpg', 126.8906847990, 37.8522416263, 6, 31, 27, '031-958-8883', 
NULL, "시원한 그늘막 아래 넓은 평상에 앉아 직접 가져오신 음식을 먹으며 편안히 쉴 수 있고, 아이들에게 신나는 기억을 선사 할 사륜오토바이+깡통열차를 신나게 즐길 수도 있다. 밤이 되면 낭만적인 조명 아래 분수를 보며 한여름밤의 정취를 만끽할 수 있다. 초리골 초록페스티벌로 많은 방문 바란다.", 
'초리골 초록축제', NULL, NULL, '1인 입장권 5,000원<br>RC보트 5,000원<br>깡통열차 5,000원<br>참숯/장작 20,000원<br>무료입장 -24개월 미만',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2699287 , '음성명작페스티벌' , 20221005 , 20221009 , '충북 음성군 금왕읍 무극리 519-4', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/78/2699278_image2_1.jpeg', 127.5882432031, 36.9898653154, 6, 33, 6, '043-873-8940', 
'<a href="http://www.esmjf.com" target="_blank" title="새창: 홈페이지로 이동">http://www.esmjf.com</a>', "음성명작페스티벌은 충북 음성군에서 생산하는 모든 명품작물을 선보이는 축제이다. 음성의 이야기, 농부의 이야기를 만날 수 있는 축제이다. 맛을 주제로 축제 공간을 구성하고, 신선한 재료로 만든 맛있는 음식이 풍성하며, 다양한 요리 교실을 운영한다. 맛있는 농산물을 구입하고, 매일매일 펼쳐지는 놀이에 참여하자. 사통팔달 음성에서 열리는 대한민국 대표 명품 농산물 축제, 볼거리 먹거리 즐길거리가 풍성한 축제에 초대한다.", 
'음성군 금왕읍 금빛공원', NULL, NULL, NULL,NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2681701 , '한국문화축제' , 20220930 , 20221008 , '서울특별시 송파구 올림픽로 25 서울종합운동장', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/59/2849859_image2_1.jpg', 127.0735805889, 37.5114817947, 6, 1, 18, '070-4257-7734', 
'<a href="http://kculturefestival.kr/html/ko/main.php" target="_blank" title="새창: 한국문화축제 홈페이지로 이동">http://kculturefestival.kr</a>', "‘한국문화축제’는 한국 문화와 전 세계를 잇는 글로벌 대표 한류 축제이다. 케이팝(K-POP)을 비롯한 음식·뷰티·패션 등 다양한 한국 문화를 소개하는 다채로운 행사에 전 세계 팬들이 직접 참여하여 아티스트와 하나 될 수 있는 장을 마련한다.", 
'광화문광장 & 잠실종합운동장 일대', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2679797 , '2022 한국해사주간' , 20220921 , 20220923 , '부산광역시 기장군 기장해안로 268-32 힐튼부산', NULL, 'A02081300', 'http://tong.visitkorea.or.kr/cms/resource/62/2847462_image2_1.jpg', 129.2286119955, 35.1982323479, 6, 6, 3, '070-7688-3160', 
'<a href="https://koreamaritimeweek.org/html/" target="_blank" title="새창 : 한국해사주간 홈페이지로 이동">https://koreamaritimeweek.org/html/</a>', "해사안전·선원인권 등 국제 해사분야 주요 현안에 대한 비전 제시 및 국내외 해사산업 동향을 공유하는 해양수산부 대표 콘퍼런스이다.", 
'아난티 힐튼 호텔 부산', NULL, NULL, NULL,NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2674675 , '수원화성의 비밀' , 20220101 , 20221231 , '경기도 수원시 팔달구 행궁로 11', '(남창동)', 'A02081300', 'http://tong.visitkorea.or.kr/cms/resource/74/2674674_image2_1.jpg', 127.0152812635, 37.2810769133, 6, 31, 13, '031-290-3563', 
'<a href="https://www.swcf.or.kr/?p=74&viewMode=view&idx=192" target="_blank" title="새창: 홈페이지로 이동">https://www.swcf.or.kr/</a>', "스마트폰으로 수원화성 일원에서 진행하는 방탈출 게임 형식의 콘텐츠로 증강현실 등 다양한 정보통신기술과 역사를 직접 체험할 수 있는 관광 콘텐츠", 
'수원화성 일원', NULL, NULL, '7,500원',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2673150 , 'Let\'s DMZ' , 20220916 , 20221002 , '경기도 파주시 임진각로 148-40 평화누리', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/09/2852409_image2_1.jpg', 126.7447609198, 37.8920676942, 6, 31, 27, '031-853-6496', 
'홈페이지 <a href="https://letsdmz.ggcf.kr/" target="_blank" title="새창 : Let\'s DMZ">https://letsdmz.ggcf.kr</a><br>인스타그램 <a href="https://www.instagram.com/letsdmz" target="_blank" title="새창 : Let\'s DMZ">www.instagram.com/letsdmz</a>', "Let's DMZ \"더 큰 평화를 위한 시작\"<br>Let's DMZ는 DMZ가 지닌 평화의 의미와 생태적 가치를 국내외 대중과 교감하는 종합 학술·문화예술 축제이다. 경기도가 주최하고 경기문화재단·킨텍스·경기관광공사가 주관하며, 《DMZ 평화예술제》, 《DMZ 포럼》, 《DMZ RUN(스포츠)》의 행사로 운영된다.", 
'파주 임진각 평화누리', NULL, NULL, '유료<br>행사별 상이',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2671838 , '2022 웰컴 대학로' , 20220924 , 20221030 , '서울특별시 종로구 대학로 120', '(동숭동)', 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/87/2832887_image2_1.jpg', 127.0023295240, 37.5819417723, 6, 1, 23, 'welcomedaehakro.official@gmail.com', 
'<a href="http://welcomedaehakro.com/" target="_blank" title="새창: 홈페이지로 이동">http://welcomedaehakro.com/</a>', "웰컴 대학로는 넌버벌 퍼포먼스, 전통공연, 뮤지컬, 연극 등 다양한 장르의 한국 공연을 대학로에서 만나볼 수 있는 페스티벌로, 2017년도를 시작으로 매년 가을 국내 및 외국인 관광객들을 대상으로 대학로에서 개최되고 있다.<br>2022 웰컴 대학로는 웰컴 대학로 기간 중 펼쳐지는 다양한 작품을 중심으로 대학로 지역 상권과 함께 한다. 2022년에는 Re:Boot! 대학로(사전 붐업 야외행사)를 시작으로 웰컴 씨어터(한 공연장에서 릴레이로 진행되는 공연 프로그램), 웰컴 K-스테이지(온라인 공연), 웰컴 로드쇼(개막식), 웰컴 플러스(페스티벌 기간 내 진행 공연), 웰컴 프린지(거리공연), 웰컴 폐막파티 등 다채로운 프로그램들이 준비되어 있다.<br>웰컴 대학로는 ‘한국 공연관광’ 페스티벌 브랜드로, 다양한 유관기관 및 단체와 협업하여 ‘대학로’의 장소마케팅과 공연 콘텐츠의 해외 마케팅을 통해 아시아를 대표하는 공연관광 페스티벌로 발전해 나가고자 한다.", 
'대학로 일원', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2671149 , '제8회 고양국제무용제' , 20220928 , 20221002 , '경기도 고양시 일산동구 중앙로 1286', '(마두동)', 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/57/2852357_image2_1.jpg', 126.7740064529, 37.6612006889, 6, 31, 2, '010-7794-5101', 
'<a href="http://www.gidf.kr/" target="_blank" title="새창: 홈페이지로 이동">www.gidf.kr</a>', "고양국제무용제는 고양안무가협회(회장 임미경)의 주최로 지난 2015년 첫 회를 시작으로 올해 8년째를 맞이하는 고양시 유일의 국제 무용축제이다. 고양시 지역문화예술 발전과 무용예술 보급, 지역 무용예술가 창작활동 지원, 국제적 문화교류를 위해 지속적인 노력을 거듭한 결과 올해는 특히 고양시와 고양문화재단 주최로 축제가 치러진다. 지난 2년간 코로나19의 영향으로 국내무용단에 입단한 해외 무용수팀과 국제적 위상을 지닌 국내 안무가의 작품들로 프로그램을 구성하였다. 온라인상영, 거리두기 관객 입장 등 제한적인 상황에서 공연을 했음에도 수준 높은 프로그램과 완성도 높은 실연으로 큰 관심을 받으며 성공리에 행사를 치렀다. 코로나19라는 국제적 위기에도 불구하고 실시간 공연실황 중계를 통해 세계적으로 인정받고 있는 무용가들을 고양시민에게 널리 소개할 수 있는 기회가 되었으며 또한 국제무용축제로써의 위상을 더욱 강화하였다.<br>이번 축제는 9월26일부터 10월2일까지 일주일간 고양아람누리 새라새극장에서 개최된다. 매년 탄탄한 라인업을 자랑하는 본 축제는 올해 국내외 유명 안무가들의 총 13작품이 무대에 오르며, 고양시민 참여 워크숍 및 전문무용가를 위한 마스터클래스 등 부대행사가 진행된다. 전화 및 홈페이지 예약을 통해 누구나 무료로 관람할 수 있다.", 
'고양아람누리 새라새극장', NULL, NULL, '무료(사전예약필수)',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2670718 , '청주전통공예페스티벌' , 20220921 , 20220925 , '충청북도 청주시 청원구 상당로 314 문화제조창 청주시청제2임시청사', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/13/2670713_image2_1.jpg', 127.4889281085, 36.6566740551, 6, 33, 10, '070-7777-7636', 
'<a href="http://www.okcj.org/bbs/content.php?co_id=menu02040101" target="_blank" title="새창: 청주공예비엔날레조직위원회 홈페이지로 이동">http://www.okcj.org</a>', "'천년의 숨결, 미래의 유산'을 주제로 열리는 '2022 청주전통공예페스티벌'은 천년을 이어온 선인들의 고귀한 장인 정신과 공예의 혼을 계승하고, 이를 창의적인 감각으로 발전시켜 동시대에 현대적 가치를 발현하며 미래 세대에게는 아름다운 유산으로 전하고자 한다.", 
'문화제조창 본관 3층 (청주시한국공예관 갤러리 6) 및 온라인', NULL, NULL, NULL,NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2667307 , '고창 핑크뮬리 축제' , 20220915 , 20221031 , '전라북도 고창군 부안면 복분자로 307', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/19/2735319_image2_1.jpg', 126.6264384089, 35.5027352266, 6, 37, 1, '0507-1375-3250', 
'<a href="https://blog.naver.com/feelkkot" target="_blank" title="새창: 꽃객프로젝트 네이버 블로그로 이동">https://blog.naver.com/feelkkot</a>', "고창 핑크뮬리 축제는 식물 및 정원관광 콘텐츠를 발굴하여 정원관광을 활성화하고 방문객들의 관광소비가 지역에 골고루 흡수되며 소멸해가는 지역을 살리는 방향으로 재투자되기를 희망하며 조용한 정원축제를 진행한다. 특히 올가을 코로나19로 위축된 지역 관광업계도 살리고 안전한 로컬여행을 계획해보자.", 
'꽃객프로젝트 팜정원 내', NULL, NULL, '5,000원/인 (36개월 미만 무료)',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2666388 , '아이가 행복입니다' , 20220922 , 20220923 , '서울특별시 송파구 올림픽로 300', '(신천동)', 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/23/2839423_image2_1.jpeg', 127.1025668077, 37.5126099637, 6, 1, 18, '1855-3164', 
'<a href="https://www.behappykorea.kr/" target="_blank" title="새창: 홈페이지로 이동">http://www.behappykorea.kr</a>', "\"아이가 행복입니다\"는 한국의 저출생 문제를 정부와 기업, 사회단체, 국민이 다 함께 힘을 합쳐 극복해야 한다는 공감대를 형성하기 위해 2018년 처음 개최되었다. 일과 생활의 균형, 저출생과 관련된 대책 각 분야 전문가들이 일반 대중들과 소통하는 자리이자,  출생/육아 정책과 건강정보 등 양육의 부담을 덜 수 있는 정보도 제공한다. 동시에 잔디광장에서는 아이와 함께 즐길수 있는 뮤직페스티벌, 가족영화제, 가족 레크레이션 프로그램 등 각종 부대행사로 아이와 함께 즐길 수 있는 다양한 볼거리를 제공한다.", 
'롯데월드타워 SKY31 및 잔디광장', NULL, NULL, NULL,NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2661632 , '세계유산축전' , 20220903 , 20221022 , '서울특별시 종로구 사직로 161', '(세종로)', 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/71/2843571_image2_1.jpg', 126.9770319156, 37.5788944508, 6, 1, 23, '02-2270-1272', 
'홈페이지 <a href="https://worldheritage.modoo.at"_blank" title="새창: 세계유산축전홈페이지로 이동">https://worldheritage.modoo.at</a><br>블로그 <a href="https://blog.naver.com/wherit/222844168410" target="_blank" title="새창 : 세계유산축전">https://blog.naver.com</a>', "세계유산축전은 공모를 통해 선정된 국내 유네스코 등재 세계유산을 주제로 진행되는 축제이다. 뛰어난 보편적 가치를 지닌 인류의 자산인 세계유산의 가치를 전 국민과 더불어 향유하고자 기획되었으며, 세계유산을 주제로 전통공연, 재현행사, 체험, 전시 등 고품질 세계유산 복합 향유 프로그램으로 세계유산의 가치를 전달한다. 2022년 제3회 세계유산축전은 경상북도(안동,영주), 수원화성, 제주 화산섬과 용암동굴에서 펼쳐질 예정이다.", 
'경상북도(안동,영주), 수원화성, 제주', NULL, NULL, '프로그램별 상이',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2659776 , '전주 한옥마을 \'경기전 사람들\'' , 20220605 , 20221023 , '전라북도 전주시 완산구 태조로 44', '(풍남동3가)', 'A02081300', 'http://tong.visitkorea.or.kr/cms/resource/83/2820183_image2_1.jpg', 127.1493699447, 35.8162807559, 6, 37, 12, '063-232-9938', 
'<a href="https://www.instagram.com/culture__art/" target="_blank" title="새창: 홈페이지로 이동">https://www.instagram.com/culture__art/</a>', "옛부터 경기전에서 살아온듯한 조선시대 캐릭터가 나타났다!<br>“어디서 오셨소? 혼자 오셨소? 재미난 역사 이야기 듣고 가시오!”, “관상을 미신이라 생각하시오?”, “커플이시오? 부럽소!”<br>한옥마을 경기전에 조선시대 사람들이?! 오늘 하루 웃음을 책임질 캐릭터들이 경기전 안에 모였다! 매주 일요일, 유쾌한 경기전을 만들어줄 9명의 캐릭터가 모였다!<br><br>※ 캐릭터 소개(9명) : △뻥쟁이(관상가) △어진화사(화공) △까막눈(유생) △김꼰대(참봉) △땅부자(지관) △말뚝이(수문장) △핵인싸(이단아) △한입만(기미상궁) △금화(금화군)", 
'전주 한옥마을 경기전', NULL, NULL, '경기전 입장 시 무료','전연령', NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2659594 , '세텍메가쇼 2022 시즌2' , 20220825 , 20220828 , '서울특별시 강남구 남부순환로 3104', '(대치동)', 'A02080600', 'http://tong.visitkorea.or.kr/cms/resource/54/2661054_image2_1.jpg', 127.0719811806, 37.4957363721, 6, 1, 1, '02-6677-3477', 
'<a href="http://www.megashow.co.kr" target="_blank" title="새창: 홈페이지로 이동">http://www.megashow.co.kr</a>', "일상의 다양한 라이프스타일에 맞는 질 좋고 경쟁력 강한 제품을 만나볼 수 있는 곳.<br>국내 최대 규모의 소비재 박람회 '메가쇼'", 
'SETEC 전시장', NULL, NULL, '유료<br>홈페이지 참조',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2657619 , '화성행궁 야간개장' , 20220501 , 20221031 , '경기도 수원시 팔달구 정조로 825', NULL, 'A02081300', 'http://tong.visitkorea.or.kr/cms/resource/16/2657616_image2_1.jpg', 127.0144035414, 37.2819295766, 6, 31, 13, '031-290-3600', 
'<a href="https://www.swcf.or.kr/?p=260" target="_blank" title="새창: 홈페이지로 이동">https://www.swcf.or.kr</a>', "화성행궁 야간개장 달빛정담 情談
낮보다 더 아름다운 수원화성의 밤, 달빛 아래 다정하게 얘기를 나눌 수 있는 특별한 시간.
도심 속 아름다운 궁궐의 야경과 고즈넉한 분위기, 달빛과 초롱빛을 따라 거닐다보면 행궁 곳곳의 이야기를 만날 수 있다.", 
'화성행궁,  화령전', NULL, NULL, '어른 1,500원 청소년 1,000원 어린이 700원','모든 연령 관람 가능', '1시간 이내');

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2656070 , 'RAPBEAT 2022' , 20220903 , 20220904 , '경기도 과천시 광명로 181', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/19/2818419_image2_1.png', 127.0190599639, 37.4338981534, 6, 31, 3, '02-6012-7135', 
'<a href="https://www.instagram.com/rapbeatfestival/" target="_blank" title="새창 : RAPBEAT 2022">www.instagram.com</a>', "힙합, 알앤비, 인디 등 다양한 장르를 아우르는 대규모 뮤직 페스티벌 ‘RAPBEAT 2022(이하 랩비트)’가 오는 9월 3일부터 4일까지 서울랜드에서 개최된다.<br>매번 핫한 라인업으로 이슈가 되고 있는 ‘랩비트’는 공식 SNS 계정을 통해 올해 1차 라인업을 공개했다.<br><br>키치한 스타일과 독특한 플로우로 전 세계 팬들의 사랑을 받고 있는 힙합 아티스트 아미네(Amine)와 2022 그래미 어워드’에서 최우수 프로그레시브 알앤비 앨범 상을 수상한 R&B 보컬리스트 럭키 다예(Lucky Daye)의 국내 첫 내한 무대가 ‘랩비트’에서 펼쳐진다.<br><br>또 국내 모던 록 음악을 대표하는 밴드 넬(NELL)과 성공적으로 북미 투어를 마친 밴드 새소년이 다채로운 악기 사운드로 무대를 꾸밀 예정이며, 특유의 자유분방하고 트렌디한 음악으로 사랑받는 로꼬(Loco), 유니크한 감성과 목소리를 지닌 아티스트 자이언티(Zion.T)도 무대에 오른다.<br><br>‘랩비트’ 의 1차 티켓은 오는 10일 오후 12시부터 무신사, 멜론티켓, 티켓링크, 네이버 예약을 통해 구매 가능하며, 자세한 정보는 공식 계정(인스타그램, 페이스북 등)을 통해 확인할 수 있다.", 
'서울랜드', NULL, NULL, '1차 티켓 1일권 : 89,000원 (정가 139,000원)<br>1차 티켓 2일권 : 129,000원 (정가 199,000원)',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2651042 , '세계유산축전 - \'제주 화산섬과 용암동굴\'' , 20221001 , 20221016 , '제주특별자치도 제주시 조천읍 선교로 569-36', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/34/2845934_image2_1.jpg', 126.7142575546, 33.4569020299, 6, 39, 4, '064-755-2210', 
'<a href="http://worldheritage.kr" target="_blank" title="새창: 홈페이지로 이동">http://worldheritage.kr</a>', "본 행사는 지난 2020년 처음 시범 시행 후, 올해로 3번째 추진 하는 정부사업으로 유네스코에 등재된 세계유산을 주제로 공연, 전시 등의 가치 확산&향유 프로그램과  참여자가 직접 체험하는 순례단, 워킹투어 등 세계유산에 대한 이해를 돕고 그 가치를 전달하고, 해석하는 프로그램을 결합한 복합 문화 홍보 사업이다.", 
'제주)프로그램별 상이', NULL, NULL, '프로그램 별 상이','전체연령', '프로그램 별 상이');

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2648460 , '경복궁 별빛야행' , 20220915 , 20220925 , '서울특별시 종로구 사직로 161', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/80/2847580_image2_1.jpg', 126.9770319156, 37.5788944508, 6, 1, 23, '02-3210-4633', 
'<a href="http://www.chf.or.kr/" target="_blank" title="새창: 행사 홈페이지로 이동">http://www.chf.or.kr</a>', "<경복궁 별빛야행>에 여러분을 초대한다.<br>경복궁 소주방에서 맛보는 도슭수라상과 전문해설사와 함께 떠나는 별빛산책.<br>장고, 집옥재와 팔우정, 건청궁을 거치며 궁궐의 옛 이야기를 마주하고, 쏟아지는 별빛 아래에서 고종이 거닐었던 향원정의 정취를 느껴보자.", 
'경복궁', NULL, NULL, '일반석 60,000원 / 시야제한석 55,000원','취학아동 이상', '110분');

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2648430 , '2022 경기곤충페스티벌' , 20220924 , 20220925 , '경기도 화성시 병점중앙로 283-33', '(기산동)', 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/91/2830591_image2_1.jpg', 127.0429415014, 37.2225202975, 6, 31, 31, '031-8008-9445', 
'<a href="https://blog.naver.com/ggbug20" target="_blank" title="새창: 행사 홈페이지로 이동">https://blog.naver.com/ggbug20</a>', "코로나19로 인해 비대면으로 진행되었던 경기곤충페스티벌이 다시 대면으로 돌아왔다. 지루하고 갑갑하게 눈으로만 관찰하던 곤충을 직접 만지며 관찰할 수 있는 다양한 체험들이 준비되어 있다. 살아있는 곤충 전시부터, 커다란 참나무위에서 놀고 있는 장수풍뎅이와 사슴벌레, 귀뚤귀뚤 울고 있는 쌍별귀뚜라미, 전시관 안에서 뛰어다니는 메뚜기, 여러 종류의 애벌레까지.. 야외에서 만나볼 수 있는 다양한 곤충들과 곤충콘덴츠 공모전의 수상작들로 꾸며진 전시, 경기도 곤충농가들이 직접 사육하고 판매하는 곤충 제품들도 볼 수 있다. 코로나19의 확산 방지를 위하여 오전/오후 각 4시간씩만 관람이 가능하고 예약하지 않은 관람객은 입장이 불가능하다.", 
'경기도농업기술원 곤충자원센터', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2640874 , '서울라이트 DDP' , 20220930 , 20221009 , '서울특별시 중구 을지로 281', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/19/2852319_image2_1.jpg', 127.0099486810, 37.5675991318, 6, 1, 24, '02-6953-9010', 
'<a href="http://ddp.or.kr" target="_blank" title="새창 :서울라이트쇼">https://www.ddp.or.kr</a>', "2022 서울라이트는 다가오는 9월 30일부터 12월까지 풍성한 프로그램으로 서울 시민들을 맞이한다.<br>가을의 서울라이트는 <버추얼 패션 미디어아트>를 메인으로 하여, 우주적 삶을 향해 걸어가는 거대한 캐릭터의 유쾌하고 신나는 그래피컬한 패션 워킹웨이가 어울림 광장 외벽에 펼쳐진다.  <br>12월에는 <DDP 포럼 ‘Your Dream Space’>이 서울라이트 겨울의 막을 연다. 예술&과학 분야의 전문가들을 초빙해 ‘우주’를 어떻게 해석하고 표현하는지에 대한 포럼이 진행된다. 누구나 온라인으로 참여 가능하다. 서울라이트의 주요 행사인 <DDP 우주와의 만남, Rendez-Vous(랑데-부)>개막식에는 유난샘, Nsyme(엔자임), 범민 등 유명 작가들의 작품이 한데 어우러진 환상적 미디어아트 쇼가 진행된다. 스티키몬스터랩, HELLOMAN이 참여하는 크리스마스 및 새해 카운트다운 행사 등도 함께 진행될 예정이다.", 
'DDP', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2630385 , '코리아그랜드세일' , 20220810 , 20220831 , '온라인개최', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/24/2827924_image2_1.jpg', 126.9848758397, 37.5720426096, 6, 1, 100, '070-7603-3807', 
'<a href="https://en.koreagrandsale.co.kr/" target="_blank" title="새창 : 코리아그랜드세일">https://en.koreagrandsale.co.kr</a>', "미리 만나보는 코리아그랜드세일, 'Korea Grand Sale, Summer Special'<br>
코리아그랜드세일은 관광과 한류가 융복합된 외국인 대상의 한국 대표 쇼핑문화관광축제로, 한국의 쇼핑 즐거움과 함께 항공, 숙박, 뷰티, 엔터테인먼트, 식·음료, 체험 등 다양한 분야에서 풍성한 혜택을 제공한다.<br>
매년 1~2월 개최하는 본 행사에서는 보다 다양하고 매력적인 한국쇼핑관광 콘텐츠와 프로모션을 통해 한국의 다채로운 매력을 보여준다.<br>
연중 운영하는 코리아그랜드세일 온라인 플랫폼을 통해서도 대한민국 전역의 다양한 쇼핑관광 콘텐츠와 혜택을 만날 수 있다.<br>
행사에 대한 자세한 내용은 코리아그랜드세일 온라인 플랫폼(<a href=\"https://en.koreagrandsale.co.kr/\" target=\"_blank\" title=\"새창 : 코리아그랜드세일\">https://en.koreagrandsale.co.kr</a>)에서 확인할 수 있다.", 
'전국(온오프라인)', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2622679 , '예천국제스마트폰영화제' , 20221015 , 20221016 , '경상북도 예천군 풍양면 삼강리길 41', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/05/2822605_image2_1.jpg', 128.3003470759, 36.5633189943, 6, 35, 16, '054.655.8082', 
'<a href="https://blog.naver.com/yisff/222545099118" target="_blank" title="새창: 홈페이지로 이동">blog.naver.com/yisff</a>', "국내 최초 스마트폰을 활용한 영화제로서, 10분 이하의 영화,영상을 제작하고 즐기는 국제 스마트폰영화제", 
'예천군 신도시 일원, 메가박스 경북도청점', NULL, NULL, '무료','4', '영화 1편 10분 미만');

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2620577 , '2022서울국제불교박람회' , 20220929 , 20221002 , '서울특별시 강남구 남부순환로 3104', '(대치동)', 'A02080600', 'http://tong.visitkorea.or.kr/cms/resource/79/2823779_image2_1.jpg', 127.0719811806, 37.4957363721, NULL, 1, 1, '02-2231-2013', 
'<a href="http://www.bexpo.kr" target="_blank" title="새창: 행사 홈페이지로 이동">http://www.bexpo.kr</a>', "2022 서울국제불교박람회는 한국 전통문화 산업의 중추인 불교문화와 산업을 새롭게 조명하고 산업과 문화, 철학을 담은 박람회로, 한국 불교 산업을 위한 비즈니스의 장이자 한국 전통 문화를 체험할 수 있는 축제의 장이다.<br>전통불교 산업과 예술을 한자리에 서울국제불교박람회가 2022년 9월 29일 목요일부터 10월 2일 일요일까지 온·오프라인 동시개최한다.<br>과거부터 이어져온, 조화로운 지혜로 피어나는 우리의 전통 문화와 불교 문화의 가치를 온·오프라인 전시,체험 프로그램으로 만나보자.", 
'서울무역전시컨벤션센터(SETEC)1, 2, 3관/서울국제불교박람회 공식홈페이지(bexpo.kr)', NULL, NULL, '5,000원(입장료의 일부는 비영리 단체 후원 및 문화발전 기금으로 사용)',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2620019 , '\'나미콩쿠르\' 수상작 展' , 20210501 , 20230331 , '강원도 춘천시 남산면 남이섬길 1', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/82/2726982_image2_1.jpg', 127.5262424616, 37.7901326639, 6, 32, 13, '031-580-8193', 
'<a href="http://namiconcours.com/main.php" target="_blank" title="새창 : 관광지">http://namiconcours.com/main.php</a>', "나미콩쿠르는 세계의 그림책 일러스트레이터들에게 창작과 발표의 기회를 제공하고 그림책 일러스트레이션 수준 향상에 기여하기 위해 제정되었으며, 한국의 남이섬이 후원하고 있다.<br>올해 다섯 번째로 열린 나미콩쿠르에는 95개국에서 2,069개 작품이 응모되어 남아프리카공화국, 러시아, 벨기에, 일본, 한국의 국제 심사위원들이 엄정한 심사를 통해 본상 18개 작품을 선정했다.", 
'남이섬 나미콩쿠르갤러리', NULL, NULL, '남이섬 입장 시 무료 관람 (공예원 체험 프로그램 유료)','전 연령 가능', '기간 내 자유');

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2618730 , '대전ART마임페스티벌' , 20220923 , 20220924 , '대전광역시 중구 중앙로 101', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/20/2847620_image2_1.jpg', 127.4209793431, 36.3267634148, 6, 3, 5, '042-257-1231', 
'홈페이지 <a href="http://www.daejeonartmime.com/" target="_blank" title="새창 : 대전ART마임페스티벌">www.daejeonartmime.com</a><br>페이스북 <a href="https://www.facebook.com/daejeonartmimefestival" target="_blank" title="새창 : 대전ART마임페스티벌">www.facebook.com</a><br>유튜브 <a href="https://www.youtube.com/channel/UCgzyVJCpiVH3aqSWMGE6ftQ" target="_blank" title="새창 : 대전ART마임페스티벌">www.youtube.com</a><br>카카오톡 채널 <a href="http://pf.kakao.com/_XIaWs" target="_blank" title="새창 : 대전ART마임페스티벌">http://pf.kakao.com</a>', "대전ART마임페스티벌은 2009년 제1회 축제 슬로건 '지역문화예술운동확산'을 시작으로 민간예술단체 주도의 독립적 예술축제로 이어져 오고 있다.<br>마임을 중심으로 ‘몸’이 가지는 무한의 가치를 예술과 문화의 언어로 풀어내고자 다양한 시도의 축제 진화를 거듭해오고 있다. <br>2022년 제14회 대전ART마임페스티벌은 각각의 개성과 색채를 가진 3개의 주 프로그램으로 진행 된다. <br><개막기획 ‘Space Of Peace>는 대전의 근대건축문화유산에서 '평화의 공간'을 주제로 실험적인 창작 마임, 몸 기반 공연, 국제교류 공연,<br><메인프로그램 '대전에 美친!마임'>은 '원도심곳곳을 누벼라', '곳곳이축제' 등으로 거리 일대를 각양각색의 마임으로 수놓을 예정이다. <br><특별프로그램 'AHA!몸 예술치유>는 '몸의 인문학/ 토크콘서트', 'AHA! 몸 예술치유 프로그램' 으로 몸-마임예술-치유와의 접점을 만들어 일상과 연결되는 축제로 다가간다. <br>마임에서 ‘몸’은 단지 언어적 기능 대신 표현되는 것 이상으로 몸 그 자체의 생명력을 길러내는 행위이다!!생명력이 역동하는 몸&짓의 축제! 몸을 통한 자각의 향연! 대전ART마임페스티벌에 오셔서 '몸소' 즐기고 누리자!!", 
'옛 충남도청사, 대흥동문화예술의거리, 스카이로드, 대전프랑스문화원, 계룡문고', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2618014 , '제4회 인제가을꽃축제' , 20220930 , 20221016 , '강원도 인제군 북면 십이선녀탕길 16', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/81/2848481_image2_1.jpg', 128.3062095629, 38.1856540989, 6, 32, 10, '033-460-8954~7', 
'<a href="http://www.injefestival.kr/" target="_blank" title="새창: 행사 홈페이지로 이동">http://www.injefestival.kr</a>', "아름다운 대한민국에서 단풍이 시작되는 곳! 인제에서 꽃길만 걷자 !", 
'강원도 인제군 용대 관광지 일원', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2617134 , '경주 FCI 국제 도그쇼' , 20220902 , 20220904 , '경상북도 경주시 보문로 507', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/21/2841121_image2_1.jpg', 129.2879693962, 35.8384670465, 6, 35, 2, '02-2278-0661~2', 
'<a href="https://www.thekkf.or.kr" target="_blank" title="새창: 행사 홈페이지로 이동">https://www.thekkf.or.kr</a>', "도그쇼는 세계애견연맹(FCI)에서 규정한 견종 표준에 근거하여 FCI 회원국 및 미국 AKC의 해외 유명 심사위원을 비롯, 국내 심사위원을 초청하여 심사한다. 본 연맹은 선진화된 도그쇼 개최를 통해 우수 애견 혈통 보존을 장려하고 도그쇼와 함께 애견 문화 행사를 개최하여 본 행사가 애견인과 비애견인 모두가 함께 어우러져 즐기는 스포츠이자 축제의 장이 되도록 기여하고 있다.", 
'경주 화백 컨벤션센터', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2616316 , '2022 수원재즈페스티벌' , 20220902 , 20220903 , '경기도 수원시 영통구 광교호수로 165', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/70/2835970_image2_1.jpg', 127.0700734505, 37.2833192997, 6, 31, 13, '031-250-5300', 
'홈페이지 <a href="https://www.swcf.or.kr/?p=236" target="_blank" title="새창: 행사 홈페이지로 이동">https://www.swcf.or.kr</a><br>페이스북 <a href="https://www.facebook.com/2019suwonjazzfestival" target="_blank" title="새창: 페이스북으로 이동">https://www.facebook.com/2019suwonjazzfestival</a><br>인스타그램 <a href="https://www.instagram.com/suwonskartrium/" target="_blank" title="새창: 인스타그램으로 이동">https://www.instagram.com/suwonskartrium/</a>', "온가족이 함께 즐기는 음악축제 <2022 수원재즈페스티벌><br>대한민국 최고경관으로 꼽힌 '광교호수공원'을 배경으로 국내외 재즈아티스트들이 모여 편안하고 감미로운 재즈음악으로 꾸미는 수원재즈페스티벌이다. 정통재즈부터 남녀노소 누구나 편안하게 즐길 수 있는 재즈까지, 무르익는 단풍만큼이나 감성도 깊어진 가을에 수원재즈페스티벌과 함께해 보자.", 
'광교호수공원 재미난 밭(스포츠클라이밍장 앞)', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2615461 , '2022년 경복궁 생과방' , 20220907 , 20221020 , '서울특별시 종로구 사직로 161 경복궁', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/06/2844306_image2_1.jpg', 126.9770319156, 37.5788944508, 6, 1, 23, '02-3210-3507', 
'<a href="https://saenggwabang.modoo.at/?link=77hh1gql" target="_blank" title="새창: 행사 홈페이지로 이동">https://saenggwabang.modoo.at/</a>', "경복궁 소주방 전각에 위치한 '생과방'은 궁중의 육처소(六處所) 가운데 하나이며, '국왕과 왕비'의 후식과 별식을 준비하던 곳으로 '생물방'이라고도 불렸다. 경복궁 생과방 프로그램은 조선왕조실록의 내용을 토대로 실제 임금이 먹었던 궁중병과와 궁중약차를 오늘날에도 즐길 수 있도록 구성된 유료 체험 프로그램이다.", 
'경복궁 생과방', NULL, NULL, '유료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2614763 , '공주 문화재야행' , 20220902 , 20220904 , '충청남도 공주시 제민천길 일원', '(반죽동)', 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/23/2666523_image2_1.JPG', 127.1219804447, 36.4544351759, 6, 34, 1, '041-840-8204', 
'<a href="http://gongju-culturenight.com" target="_blank" title="새창: 행사 홈페이지로 이동">http://gongju-culturenight.com</a>', "근대문화유산이 펼쳐져 있는 공주의 원도심에서 자세히 바라 보면 더 예쁜 공주의 밤거리<br/>제민천을 따라 8야를 보여준다! 그런데 여기서 오늘 뭐행? 공주문화재야행~", 
'공주 원도심 제민천 일원', NULL, NULL, '무료(일부 유료)','전연령 가능', '기간 내 자유');

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2614760 , '2022 경주문화재야행' , 20220930 , 20221002 , '경북 경주시 교동 71', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/13/2838113_image2_1.jpg', 129.2157786981, 35.8314720272, NULL, 35, 2, '054-779-6108', 
'<a href="http://www.gjnighttrip.or.kr/ko/" target="_blank" title="새창: 홈페이지로 이동">http://www.gjnighttrip.or.kr</a>', "\"천년 역사를 품은 월성 달빛에 노닐다\"<br>천년의 향기 그윽한 경주로 여러분을 초대한다.<br>992년간 신라의 수도였던 경주, 경주의 역사는 신라의 역사이다.<br>절터, 고분, 궁궐터를 비롯한 수많은 문화재와 설화 등 이야기 거리가 풍성한 경주.<br>경주문화재야행의 주 무대인 경주 교촌은 첨성대와 계림, 월성, 월정교를 지척에 두고 향교와 최씨고택을 중심으로 현성된 조선시대 전통 한옥마을이다.<br>8夜로 펼쳐지는 역사와 전설 그리고 신라 속의 조선 문화를 오감으로 만나는 아름다운 추억 여행이 될 것이다.", 
'경주 교촌한옥마을', NULL, NULL, NULL,NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2614198 , '광주 ACE Fair' , 20220922 , 20220925 , '광주광역시 서구 상무누리로 30', '(치평동)', 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/02/2614202_image2_1.jpg', 126.8405366718, 35.1469291222, 6, 5, 5, 'ACE Fair 사무국 062-611-2246', 
'<a href="https://www.acefair.or.kr" target="_blank" title="새창: 행사 홈페이지로 이동">www.acefair.or.kr</a>', "국내 최대 규모의 종합문화콘텐츠 전문 전시회인 ‘광주 ACE Fair’는 아시아문화중심도시 광주의 대표 브랜드 전시회로 2006년부터 매년 개최하고 있는 콘텐츠 종합전시회이다. 캐릭터, 방송, 게임, 애니메이션, 지식 정보 등 문화콘텐츠 전 장르를 아우르는 제품 전시와 라이선싱 상담회, 문화콘텐츠 잡페어, 학술행사, 비즈니스 행사, 특별․부대행사 등 다채로운 프로그램으로 꾸며진다.", 
'김대중컨벤션센터', NULL, NULL, '홈페이지 참고','전연령 가능', '기간 내 자유');

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2613900 , '2022 건강서울페스티벌' , 20220904 , 20220904 , '서울특별시 중구 을지로 12 시청광장지하쇼핑센터', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/01/2844301_image2_1.jpg', 126.9787960237, 37.5655015943, 6, 1, 24, '02-549-6111', 
'<a href="http://www.spa-festa.com/2022/event.php" target="_blank" title="새창: 건강서울페스티벌 홈페이지로 이동">www.spa-festa.com</a>', "* 건강서울페스티벌은 서울시민들의 질병예방과 건강증진을 위한 건강상담 관리 캠페인이다.<br>* 건강서울페스티벌에 참여하여 다양한 건강 상담과 정보를 받아보자!<br>* 건강서울페스티벌 참가 사진을 #2022건강서울페스티벌 해시태그와 함께 인스타에 인증 시 하시면 300분을 선정하여 커피 기프티콘을 드린다.", 
'서울시청광장', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2612919 , '한국민속촌 \'달빛을 더하다\'' , 20220409 , 20221106 , '경기도 용인시 기흥구 민속촌로 90', '(보라동)', 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/71/2815371_image2_1.png', 127.1205723175, 37.2594535228, 6, 31, 23, '031-288-0000', 
'<a href="https://www.koreanfolk.co.kr/event/event_now.asp" target="_blank" title="새창: 홈페이지로 이동">https://www.koreanfolk.co.kr</a>', "야간개장 기간에는 공연장에서 조선 시대 남녀의 사랑 이야기를 LED 퍼포먼스 등으로 표현한 '연분' 특별공연이 펼쳐진다.<br>또 민속촌 곳곳에는 그림자를 이용해 재미난 사진을 찍을 수 있는 포토존이 마련되고, 조선 시대 분위기가 물씬 풍기는 야시장도 열린다.", 
'한국민속촌', NULL, NULL, 'After4 할인 17,000원 (16시 이후 입장 고객 대상)',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2612274 , '관악강감찬축제' , 20221014 , 20221016 , '서울특별시 관악구', '(봉천동)', 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/16/2667216_image2_1.jpg', 126.9514981970, 37.4782084678, 6, 1, 5, '02) 828-5763', 
'행사홈페이지 - <a href="https://www.ggcfest.com" target="_blank" title="새창: 관악 강감찬축제 홈페이지로 이동">www.ggcfest.com</a><br>
인스타그램 - <a href="https://www.instagram.com/ggcfest/?hl=ko" target="_blank" title="새창: 관악 강감찬축제 인스타그램으로 이동">https://www.instagram.com/ggcfest/?hl=ko</a><br>
블로그 - <a href="https://blog.naver.com/gwanakcf" target="_blank" title="새창: 관악 강감찬축제 블로그로 이동">https://blog.naver.com/gwanakcf</a>', "관악강감찬축제는 귀주대첩 영웅 강감찬 장군의 호국정신과 위업을 기리고자 개최되는 서울의 대표적인 역사문화 축제이다. 1001년 전 고려시대 때, 거란으로부터 나라를 지켰던 강감찬 장군이 영웅이었다면, 지금 우리에게는 코로나19로부터 자신과 이웃의 안전을 지키기 위해 애쓰는 여러분이 있다. 올해 관악강감찬축제는 이런 강감찬 장군의 뜻을 이어받아 철저한 방역과 거리두기를 지키며 비대면·온라인 중심으로 개최된다. 언택트 축제로 거듭난 관악강감찬축제가 오는 10월 여러분을 찾아간다.", 
'비대면 온라인 중심', NULL, NULL, NULL,NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2611054 , '2022 경주국악여행 ‘사랑이로구나’' , 20220618 , 20221022 , '경상북도 경주시 알천북로 1', NULL, 'A02080100', 'http://tong.visitkorea.or.kr/cms/resource/22/2826222_image2_1.jpg', 129.2058037111, 35.8617128689, 6, 35, 2, '054-777-6302', 
'<a href="https://www.garts.kr/index.do" target="_blank" title="새창 : 경주국악여행">www.garts.kr</a>', "경주국악여행은 1991년부터 경주를 방문한 관광객들에게 아름다운 경주의 명소와 국악을 알리기 위해 마련한 상설 국악공연이다.<br>2022년에는 경주를 대표하는 전문국악공연단체 10팀의 격조있는 국악공연이 경주교촌마을, 양동마을, 국립경주박물관 등에서 펼쳐진다.<br>국가무형문화재 제5호 판소리(흥보가) 보유자 정순임, 경상북도 무형문화재 제19호 가야금병창 전승교육사 주영희, 국가무형문화재 제45호 대금산조 이수자 이성애 등 경주 뿌리인 명인들과 그의 제자들, 탄탄한 실력의 국악전공자들, 전통을 잇는 무형문화재 이수자들로 구성되어 판소리, 창극, 정가, 가야금병창, 전통연희, 한국무용, 국악관혁악, 국악기 연주, 퓨전국악, 창작국악 등 다양한 국악 장르의 공연이 열린다.", 
'경주시 일대', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2610469 , '태화강공연축제「나드리」' , 20221008 , 20221012 , '울산광역시 중구 태화강국가정원길 107', '(태화동)', 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/29/2845429_image2_1.png', 129.2871025957, 35.5519493066, 6, 7, 1, '052-259-7933', 
'홈페이지: <a href="https://www.upfestival.org/" target="_blank" title="새창 : 태화강공연축제 「나드리」">https://www.upfestival.org/</a><br>인스타그램: <a href="https://www.instagram.com/nadeuri.official/" target="_blank" title="새창 : 태화강공연축제 「나드리」">https://www.instagram.com</a><br>페이스북: <a href="https://www.facebook.com/ulsanpromenadefestival" target="_blank" title="새창 : 태화강공연축제 「나드리」">https://www.facebook.com</a>', "가을 정원 속으로 예술 소풍을 떠난다.<br>예술이 깃든 정원 속에서 이웃과 함께 울산의 오늘과 내일을 그려본다.<br>음악, 무용, 서커스, 마술, 거리극 등 울산으로 모인 예술가의 다양하고 감동적인 공연 작품들과 우리의 이야기를 담은 무대가 펼쳐진다.<br>올해 태화강공연축제 「나드리」는 전국(장애인) 체전, 그리고 제56회 처용문화제와 연계 개최될 예정이다.", 
'태화강국가정원 일원', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2609968 , '한국민속촌 \'그해 시골 여름\'' , 20220709 , 20220821 , '경기도 용인시 기흥구 민속촌로 90', '(보라동)', 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/67/2826167_image2_1.jpg', 127.1205723175, 37.2594535228, 6, 31, 23, '031-288-2933', 
'<a href="http://www.koreanfolk.co.kr/" target="_blank" title="새창: 한국민속촌 홈페이지로 이동">www.koreanfolk.co.kr/</a>', "한국민속촌이 여름 축제 '그해, 시골 여름'을 개최한다.<br>여름축제 대표 콘텐츠로는 수박밭 주인과의 짜릿한 한판 승부 ‘수박서리’와 무더위를 날릴 이색 물총싸움 ‘살포대첩’을 준비했다.<br>또 시골의 정취를 듬뿍 느낄 수 있는 밀짚모자, 고무신 꾸미기 등 힙하게 촌캉스를 즐길 수 있는 다양한 체험도 마련된다.<br>이 밖에도 촌캉스의 로망을 담은 이색 포토존과 신나게 함께 즐길 수 있는 마을회관 노래교실은 관람객들의 발길을 향하게 만들 것으로 보인다.", 
'한국민속촌', NULL, NULL, '[유료]<br>매일 선착순 10명에게 수박과 입장권 무료 교환<br>물총을 소지하거나 몸빼바지를 착용한 후 방문하면 최대 50% 할인<br>자세한 사항은 한국민속촌 홈페이지 참조','전연령가능', '기간내자유');

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2601899 , '서울랜드 불빛축제 루나파크' , 20210101 , 20221231 , '경기도 과천시 광명로 181', '(막계동)', 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/68/2769668_image2_1.jpg', 127.0169239697, 37.4366477965, 6, 31, 3, '02-509-6000', 
'<a href="http://www.seoulland.co.kr" target="_blank" title="새창: 서울랜드 루나파크 홈페이지로 이동">http://www.seoulland.co.kr</a>', "서울랜드 빛축제 '루나파크'는 서울에서 가장 가까운 빛 축제로, 매일 밤 서울랜드의 28만 2250㎡의 넓은 공간 전체가 거대한 빛의 공연장으로 새롭게 변신해 환상적인 분위기의 라이트닝 공연이 펼쳐진다. 서울랜드의 상징 '지구별'에서는 3D맵핑과 음악이 어우러진 공연이 펼쳐진다. 특히 6m 크기의 국내 최대규모 미러볼이 등장해 빛축제의 하이라이트를 선보인다. 루나레이크에서는 LED일루미네이션이 화려한 빛으로 관람객들의 시선을 사로잡는다. 또한 로맨틱가든에서는 웨딩을 테마로 한 가제보와 대형 LED 장미꽃이 형형색색 빛으로 낭만적인 분위기를 더한다. 여기에 공원 곳곳 위치한 보름달 실루엣, 초승달 등 다양한 포토존은 관람객들이 인생샷을 남기기에 충분하다.", 
'서울랜드', NULL, NULL, '서울랜드 파크이용권(주간권 혹은 야간권) 구매 시 무료','전연령가능', '1시간');

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2601242 , '도봉한글잔치' , 20221009 , 20221009 , '서울특별시 도봉구 해등로32가길 16', '(방학동)', 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/81/2725681_image2_1.jpg', 127.0222976961, 37.6603469037, 6, 1, 10, '02-905-4026', 
'<a href="http://www.dobong.or.kr" target="_blank" title="새창: 도봉한글잔치 홈페이지로 이동">http://www.dobong.or.kr/</a>', "훈민정음 반포 제 575돌 한글날을 기념하고, 한글의 우수성과 한글을 주제로 만든 설치미술 및 한글을 표현한 다양한 프로그램을 통해 제11회 도봉한글잔치를 개최하고자 한다.", 
'원당샘 공원(서울 도봉구 해등로32가길 16 )', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2600837 , '제8회 흥페스티벌 - [RE:BOOT] 흥의 부활 ll' , 20221003 , 20220904 , '서울특별시 중구 퇴계로34길 28 남산골한옥마을', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/32/2847232_image2_1.jpg', 126.9932865315, 37.5597775194, 6, 1, 24, '02-6925-1255', 
'<a href="https://www.nowpanfest.com" target="_blank" title="새창 : 흥페스티벌">/www.nowpanfest.com</a>', "흥 페스티벌은 일반 시민들에게 국악 콘텐츠의 재미와 아름다움을 전하고자 극장에서 벗어나 거리로 나와 관객과의 만남을 시도하고 있으며, 국악 장르에 대한 통합적 이해를 도와 잠재적 관객으로 개발함에 일조하고 있는 국악전문 축제이다.", 
'남산골 한옥마을', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2600763 , '마노르블랑 수국축제' , 20220418 , 20220831 , '제주특별자치도 서귀포시 안덕면 일주서로2100번길 46', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/23/2816623_image2_1.jpg', 126.2930374799, 33.2580867635, 6, 39, 3, '064-794-0999', 
'<a href="https://manorblanc.modoo.at/" target="_blank" title="새창: 마노르블랑 홈페이지로 이동">https://manorblanc.modoo.at/</a>', "마노르블랑은 서귀포시에 위치한 정원이 아름다운 수목원/식물원이다.<br>이곳은 작년에 이어 올해도 유럽수국축제를 맞이하고 있다. 축제기간은 4월부터 8월까지이다.<br>우리나라 최남단에 위치하고 있어 노지 수국들이 우리나라에서 가장 빨리 개화중이다.<br>제주 수국을 비롯하여 전세계 30여종 7천여본 수국은 오직 마노르블랑에서만 만날수있다.<br>작년에 비해 더 많고 다양한 수국들로 준비되었고 사랑과 정성으로 가꾸어진 다양한 수국들을 마노르블랑 곳곳에서 만날 수 있다.<br>또한 산방산과 송악산 사이로 형제섬과 사계앞바다가 보이는 환상적인 조망은 마노르블랑에서만 만날 수 있다.<br>환상적인 조망과 함께 수국 인생샷을 남길 수 있는 다양한 산책로와 포토존이 준비되어 있고 야외 잔디정원에서는 피아노 연주 버스킹을 즐길 수 있다.<br>이곳 마노르블랑은 지금 유럽수국축제의 향연이 펼쳐지고 있다.", 
'마노르블랑', NULL, NULL, '입장료 [미취학(36개월 이상) 2000원 / 초등학생이상 4000원]',NULL, '30분~2시간');

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2598791 , '2022 Beer Fest Gwangju' , 20220831 , 20220903 , '광주광역시 서구 상무누리로 30', '(치평동)', 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/69/2819169_image2_1.jpg', 126.8384367851, 35.1498370921, 6, 5, 5, '062-611-2165', 
'<a href="http://www.beerfestgwangju.com/" target="_blank" title="새창: 비어페스트 광주 홈페이지로 이동">www.beerfestgwangju.com</a>', "김대중컨벤션센터는 호남권 최대 전시컨벤션센터이다.<br>2019년 마셔브러&일맥상통을 이어 2022년 8월, 김대중컨벤션센터 야외광장에서 2022 Beer Fest Gwangju가 열린다.<br>여름 더위를 물리쳐줄 맥주는 기본, 다양한 먹거리와 광주 대표 음식까지 준비된다.<br>DJ와 버스킹 등 흥을 돋게 할 공연들도 구성되어있다.<br>도심 속에서 캠핑을 즐길 수 있는 글램핑 Zone도 구성되어있다.", 
'김대중컨벤션센터 야외광장', NULL, NULL, '입장료: 무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2598331 , '문화가 흐르는 예술마당' , 20220528 , 20221231 , '서울특별시 용산구 양녕로 445', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/64/2821264_image2_1.jpg', 126.9580520415, 37.5177178854, 6, 1, 21, '02-786-0610', 
'<a href="https://cultureseoul.co.kr/" target="_blank" title="새창 : 문화가 흐르는 예술마당">https://cultureseoul.co.kr</a>', "서울 시민들의 일상속 문화 향유 기회를 제공하는 <문화가 흐르는 예술마당>이 5월부터 12월까지 약 8개월 간 노들섬 잔디마당에서 진행된다.<br>노들섬의 아름다운 자연속에서 문화로 쉼과 힐링을 누릴 수 있는 다채로운 공연들이 매월 진행될 예정이니, <문화가 흐르는 예술마당> 홈페이지에서 자세한 공연 일정을 확인바란다.", 
'노들섬 잔디마당', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2592414 , '근현대사 추리여행, \'사라진 열쇠를 찾아라\'' , 20220423 , 20221231 , '서울특별시 강북구 삼양로 561', '(우이동)', 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/20/2752920_image2_1.png', 127.0122877055, 37.6530781245, 6, 1, 3, '02-901-6213', 
'강북구 홈페이지-<a href="https://www.gangbuk.go.kr/tour/contents.do?key=907" target="_blank" title="새창 : 관광지">www.gangbuk.go.kr/tour</a><br>행사 홈페이지-<a href="https://www.funfarm.kr/shopExperience/117042" target="_blank" title="새창 : 관광지">www.funfarm.kr/</a>', "○ 역사적 사실에 바탕을 둔 이야기 과제를 푸는 체험프로그램이다.<br>○ 스마트폰만 있으면 별도 사전절차나 비용없이 누구나 상시참여 가능하다.<br>○ 북한산 둘레길 1, 2구간을 걸으며 강북구의 역사문화 유산을 체험할 수 있다.<br>○ 게임 진행 도중 막히는 부분이 있다면 스마트폰 화면 왼쪽 상단의 전구아이콘을 눌러 힌트를 확인이 가능하다.<br>○ 2개의 코스로 이루어져 있으며 A코스는 16시, B코스는 18시에 운영종료한다.<br>○ 최초 1회 완료시 모바일상 설문조사 후 5천원 상당의 문화상품권이 지급된다.(선착순이며, 설문조사 다음 달에 지급된다.)<br>*공원 남쪽 놀이터 인근에 솔밭숲속문구함이 있습니다. 참고바랍니다.*", 
'솔밭근린공원', NULL, NULL, '무료','누구나(초등학교 고학년 이상 참여권장)', '구간별 2~3시간');

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2588321 , '오크밸리 3D 라이팅쇼 \'소나타오브라이트\'' , 20220101 , 20231231 , '강원도 원주시 지정면 오크밸리1길 66', NULL, 'A02070200', NULL, 127.8177986180, 37.4346459591, 6, 32, 9, '033-730-3146', 
'<a href="http://www.oakvalley.co.kr/oak_new/star6.asp
" target="_blank" title="새창: 행사 홈페이지로 이동">www.oakvalley.co.kr/oak_new</a>', "내 발걸음만이 소리가 되어 메아리처럼 되돌아오는 자연 그대로의 숨길에 밤이 내리면 아름다운 조명과 신비한 이야기가 있는 환상적인 세계가 펼쳐진다.<br>아름다운 빛의 연주가 겨울의 낭만으로 이끄는 오크밸리의 Sonata Of Light(빛의 소나타)를 걸어보자.<br>빛나는 발자국으로 밤의 숨길을 걷다.<br>문화와 예술이 살아 숨쉬는 오크밸리 조각 공원을 따라가면 산책과 산림욕을 동시에 즐길 수 있는 숨길이 조성되어 있다.<br>계절별로 색다른 아름다움을 자랑하는 갖가지 야생화와 맑은 계곡, 연못 등이 반기는 1km 남짓한 산책로를 걷다보면 어느새 자연과 하나되어 건강과 느림의 미학을 일깨우게 된다.<br>자연 그대로의 쉼터, 오크밸리의 대표 힐링 명소인 숨길이 이번 겨울 더욱 아름답고 신비롭게 변신한다.<br>산책로를 따라 형형색색의 조명을 설치하고 화려한 볼거리를 제공하는 연출을 통해 산책의 낭만을 더하게 된다.<br>‘Sonata Of Light(빛의 소나타)’로 명명되는 숨길 야간 테마는 총거리 1.4km, 5가지 테마로 꾸며진 구간을 약 50분에 걸쳐 감상한 후 오크3번코스로 내려오는 유료 프로그램이다.<br>입장권은 티몬, 유인매표소에서 구매할 수 있다.<br>회원은 50%, 제휴카드 & 단체 40%, 콘도 투숙객 30%, 지역주민 30%등의 할인혜택이 본인 포함 최대 4인까지 제공된다.<br><br>아빠와 함께 가는 밤에 빛나는 골프장 페어웨이, 오크밸리 '소나타오브라이트'의 두번째 변신!<br>아빠들의 전유물로 여겨졌던 골프장 페어웨이가 온 가족을 감동시킬 3D 라이팅쇼의 현장으로 또 한번 변신한다.<br>국내 최초 숲 속 3D 라이팅쇼로 움직이는 숲을 연출한 오크밸리 ‘소나타 오브 라이트’가 이번에는 골프장 페어웨이 위 3D 라이팅쇼를 추가적으로 선보인다.<br>음악 따라 춤추는 달빛, 조명으로 빛나는 꽃 길, 하상욱 시인의 네온사인 로드 등 다양한 콘텐츠 중 숲의 나무와 돌을 배경으로 3D 맵핑을 한 메인쇼가 가장 뜨거운 반응을 받아왔으며, 이에 더욱 풍성하고 감동적인 볼거리를 제공하고자 페어웨이를 3D 맵핑하여 골프장 잔디에 생명을 불어넣었다.<br>이번 골프장 페어웨이 3D 맵핑으로 어디에서도 볼 수 없었던 광활한 대지의 율동감으로 전율을 느낄 수 있게 되었으며 콘텐츠를 관람할 수 있는 전용 데크를 설치하여 전용 관람 포인트에서 압도적인 몰입감을 선사한다.", 
'오크밸리 리조트 골프빌리지 산책로', '티몬', NULL, '정상가 대인 20,000원 / 소인 15,000원 / 36개월 미만 무료입장','전연령 관람가능', '약 50분');
INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2569685 , '퍼스트가든 빛축제 - 별빛이 흐르는 정원 2021' , 20220101 , 20221231 , '경기도 파주시 탑삭골길 260', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/53/2639353_image2_1.jpg', 126.7949386312, 37.7326399636, 6, 31, 27, '031-957-6861', 
'<a href="http://www.firstgarden.co.kr" target="_blank" title="새창: 퍼스트가든 홈페이지로 이동">http://www.firstgarden.co.kr</a>', "퍼스트가든은 아름다운 조명으로 정원을 장식한 별빛축제를 365일 연중무휴 운영한다. 자수화단의 환상적인 별빛, 토스카나 광장의 이국적인 별빛, 로즈가든의 정열적인 별빛은 추위로 얼어붙은 겨울밤을 녹이고 로맨틱한 겨울밤 분위기를 자아낸다. 
[별빛이 흐르는 정원]을 슬로건으로 은하수를 담은 별자리 여행처럼 더 화려하고 볼거리가 많은 별빛축제로 새롭게 모습을 선보이며, 약 2만평 규모의 테마정원마다 다른 주제로 사계절의 대표 별자리를 비롯한 다양한 별자리가 지상에 내려앉은 모습을 볼 수 있다.
퍼스트가든 별빛축제는 4계절을 담아낸 다양한 별자리정원 뿐만 아니라 생명과 희망을 담은 ‘바오밥’나무 별빛, 나비정원 별빛 등 각 테마정원마다 스토리를 담아낸 별빛테마정원과 곳곳마다 별빛황금마차, 별빛아이캐릭터 등 볼거리와 포토존으로 구성하여 연인과 가족들의 눈을 즐겁게 해줄 예정이다. 
2020년 퍼스트가든 빛축제에는 작년에 비해 조명이 더 추가되어 더욱 화려한 정원을 뽐내고 있다.
그 외에 퍼스트가든은 자동차극장, 레스토랑, 웨딩홀, 놀이시설, 체험학습, 기프트샵, 사계절 썰매장, 챌린지 코스 등 다양한 편의 시설을 갖추고 있어 이번 겨울, 소중한 이들과 함께 즐거운 추억을 만끽할 수 있습니다. 큰 감동을 주는 아름다운 퍼스트가든 별빛축제로 지금 초대한다.", 
'퍼스트가든 내 전역', NULL, NULL, '주말 및 공휴일-대인 12,000원/ 소인 11,000원<br>평일- 대인 9,000원/ 소인 8,000원','전연령가능', '2~3시간');
INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2563502 , '미술주간' , 20220901 , 20220911 , '서울특별시 종로구 삼청로 30', NULL, 'A02081300', 'http://tong.visitkorea.or.kr/cms/resource/20/2835120_image2_1.jpg', 126.9800038741, 37.5786500878, 6, 1, 23, '02-708-2271, 2281', 
'<a href="http://artweek.kr" target="_blank" title="새창: 미술주간 홈페이지로 이동">http://artweek.kr</a>', "문화체육관광부가 주최하고 예술경영지원센터가 주관하는 미술주간은 올해 8회째를 맞아 ‘미술에 빠진 대한민국’이라는 슬로건 아래, 남녀노소, 장애·비장애 구분없이 전 국민 누구나 미술 문화를 즐길 수 있도록 다채로운 프로그램을 마련하였다.<br>미술주간 동안 전국의 미술관, 아트페어 및 비엔날레, 비영리 전시공간 등 230여 곳에 무료 혹은 입장료 할인을 받아 전시를 관람할 수 있다. 미술을 친근하게 느끼고 배움의 즐거움이 있는 체험 및 워크숍 프로그램에 무료로 참여할 수 있다.<br>청명한 가을을 맞아 미술관 여행을 추천한다. 도슨트와 함께 지역의 미술관과 화랑을 방문해 작가와 작품에 대한 설명을 들을 수 있는 미술여행 20개 코스를 운영한다.<br>미술에 대한 이해와 식견을 넓히는 것은 물론, 아름다운 그림을 보면서 마음의 여유를 갖는 시간이 될 것이다.<br>미술품 구매에 관심이 있다면 전도유망한 신진작가의 작품을 합리적인 가격에 만날 수 있는 작가 미술장터를 추천한다.<br>전국 14개 소도시에서 젊은 작가의 감성이 깃든 다양한 원화, 판화, 아트 상품을 만나고, 직접 구매하는 즐거움을 느껴볼 수 있다.<br>더불어 올해도 한국을 찾는 해외 미술관계자들에게 차세대 작가와 작품을 소개하고, 홍보할 수 있도록 국제 컨퍼런스를 진행한다.<br>전국 대표 미술 기관들이 마련한 다양한 프로그램들로 여러분의 마음을 가득 채우는 힐링의 시간이 되길 바란다.<br>본 행사를 통하여 미술 소비문화가 활성화되고 대중에게 더욱 가까이 다가갈 수 있기를 기대한다.<br>미술주간에 많은 관심과 참여를 부탁드린다.", 
'국립현대미술관 외 전국', NULL, NULL, NULL,NULL, NULL);
INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2563119 , '벽초지수목원 가을꽃 국화축제' , 20220923 , 20221120 , '경기도 파주시 광탄면 부흥로 242', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/81/2850581_image2_1.jpg', 126.8754182294, 37.8004973858, 6, 31, 27, '031-957-2004', 
'<a href="http://www.bcj.co.kr" target="_blank" title="새창: 벽초지수목원 홈페이지로 이동">http://www.bcj.co.kr</a>', "365일 꽃이 지지 않는 벽초지수목원의 2022년 가을꽃 국화축제가 시작된다. 아름다운 가을꽃들을 감상하며 힐링의 순간을 만끽해보자. 가을꽃 국화축제 기간동안 벽초지수목원에서는 국화를 비롯해 다양한 꽃들을 즐길 수 있다. 또한, 설렘의 공간에 설치된 국화 조형물은 훌륭한 포토스팟이 되어줄 것이다. 자유의 공간에는 가을을 만끽할 수 있는 그라스 등 수십종의 가을식물들이 기다리고 있고, 플라워힐에서는 각종 희귀 국화들이 전시, 판매한다.", 
'벽초지수목원', NULL, NULL, '성인 일반 9,000<br>중고생 7,000<br>경로/장애인/유공자 6,000<br>어린이 6,000<br>36개월 미만 무료','전연령 가능', '약90분');
INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2561750 , '광주비엔날레' , 20230407 , 20230709 , '광주광역시 북구 비엔날레로 111', NULL, 'A02081300', 'http://tong.visitkorea.or.kr/cms/resource/48/2561748_image2_1.JPG', 126.8902647155, 35.1825648257, 6, 5, 4, '062-608-4114', 
'<a href="https://www.gwangjubiennale.org/gb/index.do" target="_blank" title="새창: 광주비엔날레 홈페이지로 이동">https://www.gwangjubiennale.org/gb/index.do</a>', "2년마다 열리는 국제현대미술제’인 광주비엔날레는 지난 1995년, 광복 50주년과‘미술의 해’를 기념하고 한국 미술문화를 새롭게 도약시키는 한편 광주의 문화예술 전통과 5ㆍ18광주민중항쟁 이후 국제사회 속에 널리 알려지기 시작한 광주 민주정신을 새로운 문화적 가치로 승화시키기 위하여 창설되었다. 창설 취지문에서 밝히고 있듯이 “광주비엔날레는 광주의 민주적 시민정신과 예술적 전통을 바탕으로 건강한 민족정신을 존중하며 지구촌시대 세계화의 일원으로 문화생산의 중심축” 으로서 역할을 모색해 왔다. 아울러 “동/서양의 평등한 역사 창조와 21세기 아시아 문화의 능동적 발아를 위하여, 그리고 태평양시대 문화공동체를 위하여...” 미술이라는 표현형식을 빌어 여러 민족,국가,문화권 간의 문화적 소통의 폭을 넓혀 가고 있다. 따라서 광주비엔날레는 문화도시, 민주도시 광주가 문화발신지가 되어 한국-아시아-세계와 교류를 넓혀 나가는 국제 현대미술의 장이다.", 
'광주비엔날레 전시관, 국립광주박물관, 광주극장, 호랑가시나무 아트폴리곤', '현장판매 : 광주비엔날레전시관, 국립아시아문화전당전시관', NULL, '홈페이지 참고','전연령 가능', '기간내 자유');
INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2560741 , '금호강바람소리길축제' , 20220924 , 20220925 , '대구광역시 북구 산격동 14-45', NULL, 'A02070200', NULL, 128.6048329084, 35.9116404433, 6, 4, 5, '053-665-2172', 
'<a href="https://www.buk.daegu.kr/tour/index.do?menu_id=00000329" target="_blank" title="새창: 금호강바람소리길축제 홈페이지로 이동">http://www.hbcf.or.kr</a>', "매년 9~10월경 금호강 일원에서 개최되는 북구의 대표적인 축제 한마당이다.<br>각 동 단 위에서 개최되던 중․소 규모의 축체를 통합하여 지난 2015년 금호강 산격대교 일원 에서 처음으로 개최되었으며, 3일 동안 열린 축제에는 연인원 10만여 명이 참가하여 대성황을 이루었다.<br>금호강의 아름다운 자연경관과 바람소리를 배경으로 다양한 장르의 문화․공연과 체험행사가 펼쳐지며, 앞으로 지역 정체성과 다양한 콘텐츠를 개발하여 차별화된 축제로 육성, 발전시켜 나갈 계획이다.<br>출처: 대광역시 북구청", 
'금호강 산격대교 둔치(산격야영장)', NULL, NULL, '무료 또는 일부유료','전 연령 가능', '기간 내 자유');
INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2559560 , '휴애리 핑크뮬리 축제' , 20220915 , 20221115 , '제주특별자치도 서귀포시 남원읍 신례동로 256', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/91/2742091_image2_1.jpg', 126.6344317363, 33.3085171454, 6, 39, 3, '064-732-2114', 
'<a href="http://hueree.com" target="_blank" title="새창: 휴애리 홈페이지로 이동">http://hueree.com</a>', "2022 휴애리 핑크뮬리 축제는 서귀포시 남원읍 신례리에 위치한 휴애리의 대표 가을 축제 이다. 올해로 5번째인 이번 축제는 9월 15일 부터 시작 예정이며, 예년과 달리 공원 곳곳에 더욱 풍성하게 준비된 핑크뮬리가 방문하시는 모든 분들을 반길것으로 예상된다. 특히, 파란 가을 하늘이 인상적인 제주에서 핑크빛 핑크뮬리와 함께 멋진 인생사진을 남겨볼 수 있어 벌써부터 많은 분들의 관심을 얻고 있다. 또한 작년과 또 다른 특별한 풍경으로 핑크뮬리를 준비하여 답답한 일상에서 위로 를 받고 싶은 분들에게 더욱 매력적인 시간이 될 것 이다. 휴애리 핑크뮬리 축제에는 핑크뮬리 뿐만 아니라 감귤체험도 함께 해 볼 수 있어, 아이를 동반한 가족에게는 교육과 학습의 시간을, 제주감귤을 좋아하시는 분들에겐 행복한 시간이 될 것 이다. 휴애리는 여러 해 전부터 지역사회 환원 차원에서 제주도내 장애인단체, 보육원, 양로원 등은 축제 때마다 무료입장(사전예약 필수)을 진행하고 있으며 도민과 관광객 가운데 3자녀이상(소인, 청소년) 입장료 50%할인행사를 별도로 진행하고 있다.", 
'휴애리 자연생활공원', NULL, NULL, '성인:13,000원/단체:11,000원/도민,장애우,유공자,경로우대:6,500원<br>청소년:11,000원/단체:9,000원/도민, 장애우 :5,500원<br>어린이:10,000원/단체:8,0000원/도민, 장애우 :5,000원<br>단체는 30인 이상[학생단체(수학여행)등 방문 시 별도 문의 요망]<br>경로할인은 만 65세 이상(신분증 제출)<br>만 24개월까지는 무료입장<br>세자녀 50%할인(자녀만 할인혜택, 고등학생까지)<br>제주특별자치도민, 장애인, 군경은 반드시 신분증 및 증명서를 제시','전 연령', '약 1시간 소요');
INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2559471 , '2022 부산수제맥주페스티벌' , 20220817 , 20220821 , '부산광역시 해운대구 APEC로 55 벡스코', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/78/2827478_image2_1.jpg', 129.1355209016, 35.1687450332, 6, 6, 16, '051-740-7549', 
'행사 홈페이지  <a href="http://busanbeerfestival.com" target="_blank" title="새창: 부산수제맥주축제 홈페이지로 이동">www.busanbeerfestival.com</a><br>행사 인스타 계정 <a href="https://www.instagram.com/busan_beerfestival/" target="_blank" title="새창: 부산수제맥주축제 홈페이지로 이동">www.instagram.com</a><br>행사 페이스북 계정 <a href="www.facebook.com/busanbeerfestival/?modal=admin_todo_tour" target="_blank" title="새창 : 2022 부산수제맥주페스티벌">www.facebook.com/busanbeerfestival</a><br>행사 블로그 계정 <a href="https://blog.naver.com/busanbeerfestival" target="_blank" title="새창 : 2022 부산수제맥주페스티벌">https://blog.naver.com</a>', "수제맥주의 성지, 부산에서 다양한 수제맥주를 한 번에 만나볼 수 있는 수제맥주페스티벌이 열린다. 이 행사는 수제맥주 성지 부산을 대내외에 알리고, 지역 청년 소상공인들의 매출 증대와 영업활성화를 위해 개최된다. 부산을 중심으로 전국의 다양한 수제맥주와 어울리는 먹거리들이 준비되어 있다. 감성축제답게 다양한 공연들과 프리마켓 또한 관람객들의 감성을 자극시킬 것으로 보인다. 다양한 이벤트와 특별 부스도 준비되어 있어 누구나 여름의 아쉬움을 시원하게 보낼 수 있는 축제이다.", 
'BEXCO 야외광장', NULL, NULL, '무료입장(*개별 시음권 및 음식권은 구입해야 함)','제한 없음(단, 주류 아용은 만 19세 이상)', NULL);
INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2559006 , '2022목포문화재야행' , 20220923 , 20220925 , '전라남도 목포시 영산로29번길 6', '(대의동2가)', 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/38/2751238_image2_1.jpg', 126.3817999111, 34.7877370151, 6, 38, 8, '061-270-8321', 
'<a href="https://mokponightroad.modoo.at/" target="_blank" title="새창: 홈페이지로 이동">https://mokponightroad.modoo.at</a>', "근대역사문화 일번지, 목포로 떠나는 밤거리 문화여행<br>'시간을 걷는 도시' 목포의 가을 근대거리에 밤이 찾아오면, 문화재들에 불이 밝혀지고 100년전 근대로 시간여행이 시작된다.", 
'목포근대역사문화공간 일원', NULL, NULL, '무료',NULL, NULL);
INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2558866 , '제6회 예산장터 삼국축제' , 20221014 , 20221020 , '충청남도 예산군 천변로 160 예산시네마', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/32/2757532_image2_1.jpg', 126.8479407825, 36.6761660126, 6, 34, 11, '070-4227-5417', 
'<a href="https://yesansamguk.kr/" target="_blank" title="새창: 홈페이지로 이동">https://yesansamguk.kr/</a>', "「국화 피워 놓고 기다리는 가을, 흥에 겨워 어화둥둥, 정겨움이 넘치는 예산장터 삼국축제」 예산의 역사와 문화가 가득한 예산장터 삼국축제는 국화 감상과 더불어 국밥을 뜨끈하게 먹고, 집으로 돌아가는 길에 국수 한 다발을 사 가는 맛과 멋이 있는 ‘가을 나들이’ 축제이다. 향기로운 국화, 얼큰한 국밥, 햇빛과 바람으로 만져 만든 국수는 정겨운 인심이 가득하다. 우리 민족의 미덕으로 불리던 ‘훈훈한 인심’을 느낄 수 있는 축제이다. 이번 2022년 예산장터 삼국축제는 모두가 지쳐있는 코로나시대에 몸과 마음이 지쳐있는 군민들에게 희망의 메세지는 물론, 멈춰있는 지역경제의 경제적 지원, 지역 예술인팀 공연단체의 동기부여 등 예전의 활기차고 정이 넘쳤던 그 시간과 현재가 함께 어우러진 온&오프라인 축제로 개최한다.", 
'백종원 국밥거리 일원', NULL, NULL, '무료',NULL, NULL);
INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2558735 , '2022 부산국제공연예술제(Busan Performing Arts Festival 2022)' , 20220923 , 20220925 , '부산광역시 금정구 장전온천천로 48 부산대지하철역', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/05/2842405_image2_1.jpg', 129.0893371356, 35.2296540211, 6, 6, 2, '051-715-6982', 
'홈페이지 <a href="http://www.gjfac.org" target="_blank" title="새창: 부산거리예술축제 홈페이지로 이동">http://www.gjfac.org</a><br><a href="https://www.facebook.com/GJFACsince2016" target="_blank" title="새창: 부산거리예술축제 홈페이지로 이동">www.facebook.com/GJFACsince2016</a>', "지난 2017년부터 시작된 부산금정거리예술축제가 최근 공연예술의 범위 확장과 공연예술이 갖는 다원적이고 복합적인 경향성을 반영하여 보다 포괄적이고 포용적인 축제로 도약하고자 <부산국제공연예술제>로 새롭게 출발한다.<br>금정구민의 산책길로 익숙한 금정구 온천천변 일원을 배경으로 올해는 \"흐르는 도시, 잠시 멈춤\"이라는 주제로 프랑스, 일본을 비롯한 30여개의 국내외 우수 공연 작품과 함께해, 일상에 지친 여러분께 웃음과 감동을 전해드리고자 한다.<br>공연을 비롯한 업사이클링 플리마켓, 전국 예술축제 담당자 라운드테이블, 굴다리를 활용한 체험 프로그램, 금정팔경을 배경으로 하는 특별 공연등 다채로운 프로그램이 준비되어있다.", 
'부산광역시 금정구 온천천 일원', NULL, NULL, '무료',NULL, NULL);
INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2558683 , '대한민국무용대상' , 20221209 , 20221209 , '서울특별시 종로구 대학로8길 7 한국문예회관', NULL, 'A02070200', NULL, 127.0029878163, 37.5812640855, 6, 1, 23, '02-744-8066', 
'<a href="http://kdaward.koreadanceassociation.org" target="_blank" title="새창: 대한민국무용대상 홈페이지로 이동">http://kdaward.koreadanceassociation.org</a>', "대한민국 최고의 기량과 예술성을 겸비한 무용가들의 경합무대<br>大韓民國舞踊大賞 대한민국무용대상은 대한민국 최고의 기량과 예술성을 겸허한 무용가들의 경합무대로 무용의 저변확대를 통하여 무용의 대중화, 산업화와 국제적으로 경쟁력 있는 작품을 발굴하여 한국무용의 국제화를 선도하기 위한 사업이다.<br>특히 열린 기회와 엄정한 절차, 공정한 심사로 경연에 대한 공신력을 높여 수상자들에게는 영예와 긍지를 부여하고, 일반 시민들에게는 춤의 정신과 가치를 널리 전파한다.동시에 무용의 문화상품으로서의 가치를 높이고 국가경쟁력을 강화시키는 것을 목적으로 한다.", 
'아르코예술극장 대극장', NULL, NULL, '홈페이지 참조',NULL, NULL);
INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2557798 , '이월드 가을축제 <인생꽃 사진관>' , 20220917 , 20221130 , '대구광역시 달서구 두류공원로 200', '(두류동)', 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/82/2847482_image2_1.jpg', 128.5648463453, 35.8548989086, 6, 4, 2, '053-620-0001', 
'<a href="http://www.eworld.kr" target="_blank" title="새창: 이월드 홈페이지로 이동">http://www.eworld.kr</a>', "인생꽃 사진관은 황화 코스모스와 핑크뮬리를 만날 수 있는 이월드 가을축제이다.<br>이번 이월드 가을축제 인생꽃 사진관에서는 전년보다 2배 확장된 규모의 <코스모스 가든>을 선보인다. 축제 기간동안 1000만송이 황화코스모스로 가득 채워진 주황빛 물결의 이월드를 만날 수 있다. 또한 22년에 새롭게 선보이는 신규 핑크뮬리 스팟인<핑크뮬리힐>을 선보인다. 드넓게 펼쳐진 꽃들 사이에 파묻혀 인생사진을 건져보자.<br>놀이기구와 꽃을 함께 즐길 수 있는 이월드 인생꽃 사진관은 2022년 9월 17일을 시작으로 11월 30일까지 진행된다.<br>이 기간동안 1탄 황화 코스모스, 2탄 핑크뮬리를 한주도 빠짐없이 이월드에서 즐길 수 있다.<br>또한 이월드 가을축제에서는 <인생꽃 사진관>외에도 <비비의 해피할로윈>, <어썸불꽃쇼>등 가을 내내 다채로운 볼거리를 제공한다. 귀여운 비비프렌드들과 몬스터 친구들의 할로윈파티인 <비비의 해피할로윈>과, 9월 17일(토) 20시 가을 밤하늘을 수놓는 화려한 불꽃쇼 <어썸불꽃쇼>는 이월드 가을 축제를 놓치면 안되는 이유이다.<br><br>※ 자세한 행사내용은 이월드 인스타그램 @eworld.official 또는 공식 홈페이지를 참조.<br>※ 일부 행사는 현장상황에 따라 변경 및 취소될 수 있다.", 
'이월드', NULL, NULL, '이월드 홈페이지 참고','이월드 홈페이지 참고', '이월드 홈페이지 참고');
INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2557742 , '2022 국제종자박람회' , 20221013 , 20221026 , '전라북도 김제시 씨앗길 232', NULL, 'A02080600', 'http://tong.visitkorea.or.kr/cms/resource/30/2830830_image2_1.jpg', 126.9078043209, 35.8558942966, 6, 37, 3, '063-219-8835, 02-574-0465', 
'홈페이지 <a href="http://www.koreaseedexpo.com/" target="_blank" title="새창: 국제종자박람회 홈페이지로 이동">http://www.koreaseedexpo.com/</a><br>인스타그램 <a href="https://www.instagram.com/koreaseedexpo2022/" target="_blank" title="새창 : 관광지">https://www.instagram.com</a>', "종자의 중요성을 널리 알리고, 국내 종자산업을 미래 성장산업으로 육성하고 대국민 인지도 확산하기 위한 2022 국제종자박람회가 개최된다. 2022 국제종자박람회로 여러분을 초대한다!", 
'민간육종연구단지·종자산업진흥센터', NULL, NULL, '무료',NULL, NULL);
INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2555958 , '2022 전국생활문화축제' , 20221028 , 20221030 , '강원도 강릉시 경강로2021번길 9-1 명주예술마당', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/63/2847563_image2_1.jpg', 128.8903006749, 37.7504520359, 6, 32, 1, '033-647-6808', 
'홈페이지 <a href="http://www.everydaylifeculture.net" target="_blank" title="새창 : 2022 전국생활문화축제">http://www.everydaylifeculture.net</a><br>인스타그램 <a href="https://www.instagram.com/2022lifeculturefesta/" target="_blank" title="새창 : 2022 전국생활문화축제">https://www.instagram.com</a><br>페이스북 <a href="https://www.facebook.com/2022lifeculturefesta" target="_blank" title="새창 : 2022 전국생활문화축제">https://www.facebook.com</a>', "문화체육관광부가 주최, 지역문화진흥원, 강릉문화재단이 공동주관하고, 강릉시가 후원하는 전국생활문화축제가 2022년 10월 28일부터 10월 30일까지 강릉 명주예술마당 및 명주동 일원에서 진행된다. \"일상이:지\"라는 슬로건으로 진행되며, 생활문화란 우리에게 일상이고 쉽게 접할 수 있다라는 의미이다. 전국의 생활문화인과 모든 시민이 축제를 통해 함께 교류하며 화합의 장으로 만들고자 한다.", 
'강릉 명주예술마당 및 강릉 명주동 일원', NULL, NULL, '무료','전 연령', '행사진행기간 상시관람가능');
INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2554814 , '2022 정조대왕 능행차 공동재현' , 20221008 , 20221009 , '서울특별시 종로구 율곡로 99', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/52/2849052_image2_1.jpg', 126.9902446339, 37.5777031595, 6, 1, 23, '02-786-0610(서울)<br>031-290-3617(수원)', 
'<a href="https://www.kingjeongjo-parade.co.kr/" target="_blank" title="새창 : 2022 정조대왕 능행차 공동재현">www.kingjeongjo-parade.co.kr</a>', "조선 후기를 문화적인 황금기 시대로 이끌어 큰 부흥을 이루었던 22대 왕 정조. 가장 성대했던 왕의 행복한 행차를 재현하는 정조대왕 능행차 공동재현이 을묘년원행(1795년 윤 2월) 당시 실제 행차일에 한층 더 가까워진 2022년 10월에 찾아온다. 기록유산 「원행을묘정리의궤」를 기반으로 재현하는 '을묘년 화성원행' 이라고도 불리는 정조대왕 능행차는 정조대왕이 어머니 혜경궁 홍씨의 회갑을 기념하기 위해 을묘년(1795년)에 윤 2월 9일부터 16일까지 총 8일간 진행 한 대규모 왕의 행행(行幸)을 말한다. 정조대왕 능행차 공동재현은 서울시, 경기도, 수원시, 화성시가 협력하여 웅장했던 ‘을묘년 화성원행’의 원형을 현대에 화려하게 재현하는 축제이다.", 
'○ 서울 : 창덕궁 → 광화문광장 → 노들섬 → 시흥행궁터<br>○ 수원행행 : 금천구청 → 안양시(만안교, 안양역) → 의왕시(기아자동차) → 수원시(노송지대, 종합운동장, 장안문, 화성행궁)<br>대황교동 → 화성 현충공원 → 만년제 → 융· 건릉', NULL, NULL, '무료 (일부프로그램 유료)','전 연령 가능', NULL);
INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2553977 , '제 5회 정서진 피크닉 클래식 2022' , 20220827 , 20220906 , '인천광역시 서구 서달로 190 서구문화회관', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/44/2830844_image2_1.jpg', 126.6792886287, 37.5156103911, 6, 2, 7, '032-510-6046', 
'<a href="https://www.iscf.kr/_new/html/index/" target="_blank" title="새창 : 정서진 피크닉 클래식">https://www.iscf.kr</a>', "인천광역시 서구가 주최하고 인천서구문화재단(이사장 강범석)이 주관하는 ‘제5회 정서진 피크닉 클래식 2022’페스티벌 가을 시즌 프로그램이 오는 8월 27일부터 9월 6일까지, 10일간 인천 서구 곳곳에서 개최된다. 지난 5월, 봄 시즌 프로그램인‘정서진 스프링 클래식’을 인천 서구의 상징인 일몰 명소 ‘정서진’의 야외무대에서 성황리에 개최하면서 엔데믹(Endemic) 시대 야외 축제의 서막을 알린 바 있다. 오는 가을 시즌 프로그램은 구성을 대폭 확대하여 인천을 대표하는 클래식 축제의 대명사에 걸맞은 풍성하고 화려한 연주와 부대프로그램으로 클래식 애호가 및 시민들의 마음을 설레게 하고 있다.", 
'인천서구문화회관, 청라블루노바홀, 청라호수공원 야외음악당 등', NULL, NULL, '전석 무료 ~ 전석 2만원 (서로이음카드 소지자 30% 할인 외)',NULL, NULL);
INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2551329 , '대구단편영화제' , 20220824 , 20220829 , '대구광역시 중구 국채보상로 537', NULL, 'A02070200', NULL, 128.5894631814, 35.8707170159, 6, 4, 8, '053-629-4424', 
'<a href="http://www.diff.kr" target="_blank" title="새창: 대구단편영화제 홈페이지로 이동">http://www.diff.kr</a>', "<제23회 대구단편영화제를 열며><br>대구단편영화제는 2000년 국내 단편영화 제작활성화와 지역 영상 발전이라는 목표를 가지고 출발하였다.<br>대구단편영화제는 대구경북 유일의 전국경쟁영화제로 국내에서 제작되는 다양한 단편영화를 초청하여 지역의 시민들에게 소개하고, 제작자와 관객이 직접 만나 소통하는 플랫폼으로서의 역할을 해오고 있다.<br>뿐만 아니라, 대구경북지역에서 제작되는 작품들을 소개하는 ‘애플시네마’ 섹션을 운영하여 지역에서 제작된 작품이 관객과 만날 수 있는 더 많은 기회를 만들고, 나아가 대구경북지역의 영화 제작이 더욱 활성화될 수 있도록 든든한 토대가 되고자 한다.", 
'독립영화전용관 오오극장, CGV 대구 아카데미', NULL, NULL, '홈페이지 참조',NULL, NULL);
INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2550908 , '수원발레축제' , 20220813 , 20220821 , '경기도 수원시 팔달구 동수원로 335', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/06/2550906_image2_1.jpeg', 127.0366660388, 37.2594547990, 6, 31, 13, '02-2263-4680', 
'<a href="http://www.balletstp.kr/" target="_blank" title="새창: 수원발레축제 홈페이지로 이동">http://www.balletstp.kr/</a>', "올해로 8회를 맞이한 수원의 대표 축제, <2022 수원발레축제>가 오는 8월 13일부터 21일까지 수원제1야외음악당에서 열린다. 국내 최정상의 여섯 개 민간발레단의 무대와 올해는 특별히 지역에서 활발한 활동을 보이고 있는 6개의 민간발레단과 한국발레계의 미래, 한국예술종합학교와  서울예술고등학교 학생들을 초청해 함께한다.<br>횡단보도 위에서 발레를 만나는 발레IN횡단보도, 발레를 배워보는 발레체험교실, 우리나라 발레마스터의 가르침을 받을 수 있는 마스터클래스, 올해 새롭게 선보이는 One point on Stage(무대적응훈련)등 발레를 즐길 수 있는 시간을 준비하였다.", 
'수원제1야외음악당', NULL, NULL, '홈페이지 참조',NULL, NULL);
INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2550194 , '대한민국 독서대전' , 20220101 , 20221231 , '강원도 원주시  시청로 (1, 원주시청)', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/88/2823488_image2_1.jpg', 127.9199892978, 37.3423696340, 6, 32, 9, '033-737-3814~3817', 
'<a href="https://korearf.kpipa.or.kr/" target="_blank" title="새창: 홈페이지로 이동">https://korearf.kpipa.or.kr/</a>', "전국 최대 독서문화축제, 대한민국 독서대전이 2022년 원주시에서 개최된다.<br>강연, 체험, 전시, 공연 등 다양한 프로그램에 참여해보자.<br><br>연중 프로그램:2022년 1월~12월<br>본행사:2022년 9월 23일(금)~25일(일)<br>장소:원주댄싱공연장 및 원주시 전역", 
'원주 댄싱공연장 및 원주시 전역', NULL, NULL, '무료',NULL, NULL);
INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2549907 , '양주예술제' , 20220827 , 20220828 , '경기도 양주시 평화로1435번길 56', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/91/2839891_image2_1.jpg', 127.0453132041, 37.8214563387, 6, 31, 18, '031-836-5141', 
'<a href="http://www.faco.or.kr" target="_blank" title="새창: 양주예술제 홈페이지로 이동">http://www.faco.or.kr</a>', "양주시 예술문화단체와 예술인들의 활동을 촉진하여 새로운 문화 콘텐츠 창출과 시민들과의 소통, 어울림, 융합을 도모하는 종합예술축제이다.", 
'양주 덕계공원 일대', NULL, NULL, '없음',NULL, NULL);
INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2544994 , '삼다공원 야간콘서트' , 20220708 , 20220909 , '제주특별자치도 제주시 연동 302-1', NULL, 'A02081300', NULL, 126.4983283548, 33.4889783639, 6, 39, 4, '064-740-6000', 
'<a href="http://www.visitjeju.net/ko/tourView.jto?menuCd=DOM_000001718007000000&areaId=CNTS_000000000022193" target="_blank" title="새창: 삼다공원야간콘서트 홈페이지로 이동">http://www.visitjeju.net</a>', "“Healing us, Healing Earth!”, 매주 금요일 여름 밤을 더욱 뜨겁게 달궈줄 ’2022 삼다공원 야간콘서트‘가 7월 8일(금)부터 9월 9일(금)까지 매주 금요일 밤, 총10회에 걸쳐 진행된다.<br><br>2019년을 마지막으로 코로나19로 잠시 멈쳤던 삼다공원 야간콘서트 오프라인 공연은 코로나19로 지쳐있는 제주도민과 관광객에게 대중문화공연을 통한 힐링의 시간을 제공하기 위해 다시 마련되었다. 삼다공원 야간콘서트는 10CM, 양지은, 김필, 딕펑스, 먼데이키즈, 옥상달빛, 릴러말즈 등 유명 뮤지션이 함께하며, 트롯전국체전 제주 출신 정주형을 비롯해 홍어밴드, 섬보이, FLOCK, 하비오, 주낸드 등 제주 뮤지션까지 함께 참여하여, 풍성한 볼거리를 제공한다.", 
'제주시 삼다공원 일대', NULL, NULL, '무료',NULL, NULL);
INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2544610 , '전주 한옥마을 경기전 “왕과의 산책”' , 20220604 , 20221022 , '전라북도 전주시 완산구 태조로 44', '(풍남동3가)', 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/12/2819612_image2_1.jpg', 127.1493588361, 35.8162252063, 6, 37, 12, '063-232-9938', 
'<a href="https://www.instagram.com/culture__art/?form=MY01SV&OCID=MY01SV"_blank" title="새창: 홈페이지로 이동">www.instagram.com</a>', "\"전주 경기전\”<br>매주 토요일 저녁 비밀의 문이 열린다.<br>고즈넉한 밤의 경기전을 볼수있는 특별한 시간!. 밤의 경기전을 탐하라.<br><br>달빛아래 펼쳐진 조선역사의 숨결을 느낄수 있는 순간<br>2022 경기전 “왕과의 산책”에 여러분을 초대한다.<br>특별히 열린 전주 경기전에서 역사 해설과 음악의 여유를 통해 가장 아름다운 한국, 전주를 만나 보시길 바란다.<br><br>*티켓 관련 내용은 사이트(옥션/11번가/예스24)에서 확인<br>*문의전화 : 063-232-9938, 전화예매 : 1544-6399", 
'전주 한옥마을 경기전', NULL, NULL, '1인 1매 10,000원 (별도 할인 없음)<br>예매처 : 예스24티켓 <a href="http://ticket.yes24.com/New/Main.aspx?Gcode=009_201" target="_blank" title="새창 : 2022 전주 경기전 "왕과의 산책"">http://ticket.yes24.com</a><br>예매문의 : 1544-6399','취학아동 부터 관람가능', '100분');

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2543724 , '제9회 강릉명주인형극제' , 20221013 , 20221016 , '강원도 강릉시 경강로2021번길 9-1', '(명주동)', 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/20/2543720_image2_1.JPG', 128.8897923899, 37.7503881446, 6, 32, 1, '033-823-3228', 
'<a href="https://www.gncc.or.kr/web2017/sub_06/6sub_2_1.php" target="_blank" title="새창 : 제9회 강릉명주인형극제">https://www.gncc.or.kr</a>', "영동지역 대표 가족축제로 매김하고 있는 강릉 명주인형극제가 3년만에 오프라인 행사로 돌아온다.<br>강릉 명주예술마당 일원에서 10월 13일~16일에 치러지며 손인형극, 종이컵인형극, 인형뮤지컬 등 다양한 장르의 인형극이 준비될 예정이다.<br>또한 전시, 체험 행사 등 재미난 부대행사로 아이들을 찾아간다.", 
'강릉 명주예술마당, 강릉 대도호부 관아', NULL, NULL, '유/무료','3세이상 가능', '1편당 40분');

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2540959 , '2022 부여문화재야행 「정림아! 사비로와!」' , 20220916 , 20220925 , '충청남도 부여군 정림로 83 정림사지', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/81/2846881_image2_1.jpg', 126.9128955516, 36.2790710570, 6, 34, 6, '041-830-2646', 
'<a href="https://www.buyeo.go.kr/yahaeng/" target="_blank" title="새창 : 부여문화재야행 홈페이지로 이동">https://www.buyeo.go.kr/yahaeng/</a>', "문화재의 이야기에 취하는 부여 문화재 야행이 관광객을 기다린다. 문화재 야행 사업은 문화유산을 중심으로 주변의 다양한 문화예술 콘텐츠를 연계 활용해 야간에 특화된 문화체험 프로그램으로 지역경제와 관광산업 활성화를 도모하고자 문화재청에서 진행하는 공모사업으로 이번 2022부여문화재야행『정림아! 사비로와!』는 백제의 아름다운 문화유산 정림사지를 중심으로 주변의 문화시설 콘텐츠를 활용한 야간 문화향유 프로그램이다.", 
'정림사지, 의열로, 석탑로, 이색창조거리 일원', NULL, NULL, '무료<br>야식, 야시, 야숙, 야주 유료로 진행','전연령 가능', '5시간');

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2511228 , '제 10회 자문밖문화축제 <자문밖ㆍ예술로ㆍ로그인>' , 20220923 , 20220925 , '서울특별시 종로구 평창문화로 63', '(평창동)', 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/20/2847520_image2_1.jpg', 126.9680902872, 37.6063188791, 6, 1, 23, '02-6365-1388', 
'홈페이지 <a href="http://jmbforum.org/" target="_blank" title="새창: 자문밖문화축제 홈페이지로 이동">http://jmbforum.org</a><br>인스타그램 <a href="https://www.instagram.com/pccforum/" target="_blank" title="새창: 자문밖문화축제 홈페이지로 이동">www.instagram.com</a>', "자문밖문화축제는 2013년부터 매년 가을, 평창동, 부암동, 홍지동, 신영동, 구기동의 문화적 자원을 바탕으로 에술을 사랑하는 모든 사람들과 함께하는 자문밖의 대표적인 문화축제이다. 10회를 맞는 올해는 <누구나 예술을 누릴 수 있고, 예술가가 될  수 있다.> 는 비전으로 자문밖에서 경험할 수 있는 마을과 예술의 다채로운 이야기를 나눈다. '예술 그리고 창작(創作), 락(樂), 영감(靈感), 의식주(衣食住), 취향(趣向), 휴식(休息)’ 의 테마를 가지고 원로-중견-신진 등 여러 세대의 문화예술인과 함께하는 행사, 전시, 공연, 탐색, 참여, 판매 등 다채로운 프로그램을 준비했다. 즉, 지역내 갤러리와 함께하는 전시, 다양한 참여자에 의한 콘서트와 버스킹, 과거-현재-미래의 여정과 영감을 나누는 포럼, 아티스트와 지역 내 공방이 준비하는 아트마켓, 자문밖만의 힐링 리트릿, 초등학생 및 청소년을 위한 예술 체험 프로그램, 30인의 독립공연예술가 네트워크 공연 등을 통해 오늘, 자문밖의 예술과 삶으로 접속한다.", 
'서울특별시 종로구 평창동 일대', NULL, NULL, '무료<br>유로 프로그램 (유로 프로그램 참가비 : 10,000 ~ 30,000)','프로그램 별 상이', '프로그램 별 상이');

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2510116 , '천안춤영화제' , 20220502 , 20220828 , '충청남도 천안시 동남구 중앙로 111', '(문화동)', 'A02070200', NULL, 127.1520097845, 36.8081228503, 6, 34, 12, '천안문화재단 영상미디어팀<br>041-415-0094', 
'<a href="https://blog.naver.com/fastcheonan/222725847266" target="_blank" title="새창: 천안춤영화제 홈페이지로 이동">https://blog.naver.comF</a>', "올해로 6회째를 맞는 이번 공모전은 전문, 지역 총 2개 부문을 접수한다. 전문부문은 영화 내 춤 장면을 삽입한 작품을 제출해야 하며, 지역 부문은 천안을 주·소재로 한 장면이 나오는 영상을 출품해야한다. 총상금은 지난해 인기에 힘입어 1,000만원으로 증액되었다. 전문부문에서는 대상 1편(300만원), 최우수상 2편(각 150만원), 우수상 2편(각 100만원)을 선정하고, 지역부문에서는 최우수상 1편(100만원), 우수상 2편(각 50만원)을 시상한다. 수상작은 '2022 천안 흥타령 춤 축제' 기간에 상영될 예정이다.", 
'천안문화재단', NULL, NULL, '홈페이지 참조',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2508126 , '양주 회암사지 왕실축제' , 20221001 , 20221002 , '경기도 양주시 회암사길 11 회암사지 박물관', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/45/2848445_image2_1.jpg', 127.1029879178, 37.8412745188, 6, 31, 18, '02-782-2721', 
'<a href="https://yangju-hoeamsaji.kr/2022/html/" target="_blank" title="새창: 양주 회암사지 왕실축제 홈페이지로 이동">https://yangju-hoeamsaji.kr/</a>', "\"치유의 궁, 세계를 품다\"<br>조선 왕실사찰의 고고유적 회암사지를 배경으로 펼쳐지는 역사 힐링 축제!<br>유네스코 세계유산 잠정목록 등재를 기념하는 2022 양주 회암사지 왕실축제는 3년만의 대면 축제로 더욱 풍성해진 볼거리와 다채로운 프로그램으로 돌아온다. 코로나19로 일상의 지친 여러분들을 힐링의 장소 회암사지 왕실축제로 초대한다.", 
'양주 회암사지 일원', NULL, NULL, '무료','연령무관', NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2503230 , '2022 청주문화재야행' , 20220827 , 20220828 , '충청북도 청주시 상당구 성안로', '(남문로2가)', 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/86/2823486_image2_1.jpg', 127.4887982220, 36.6329017813, 6, 33, 10, '043-219-1131 / 043-219-1129', 
'<a href="http://www.cjculturenight.org" target="_blank" title="새창: 청주야행 행사 홈페이지로 이동">www.cjculturenight.org</a>', "청주만의 유‧무형 문화재와 청주 원도심 역사 이야기를 품은 2022 청주문화재야행이 개최된다. \"용두사지철당간과 주성\"에 관한 전설을 기반으로 구성된 올해 청주문화재야행은 가족, 친구, 연인 간에 추억을 만들 수 있도록 다양한 프로그램으로 한 가득 채워져 있다. 2016년부터 2022년까지 7회 연속 개최되고 있는 청주문화재야행! 올해도 많은 관심과 참여 부탁 드린다. 한 여름 밤 달빛 아래에서 청주의 역사를 돌아보며 희망찬 미래를 꿈꿔보자.", 
'용두사지철당간, 중앙공원, 청주시청 임시청사, 청주읍성전시관 , 성안길, 서문시장, 남주남문로 한복문화의 거리', NULL, NULL, '무료','전 연령', NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2503125 , '2022 브릿지워크서울' , 20221015 , 20221015 , '서울특별시 영등포구 노들로 113 양화개나리점', NULL, 'A02081200', 'http://tong.visitkorea.or.kr/cms/resource/58/2852358_image2_1.jpg', 126.8933655127, 37.5445580545, 6, 1, 20, '070-4705-2008', 
'<a href="https://www.instagram.com/urbansports.kr/" target="_blank" title="새창: 브릿지워크서울 행사 홈페이지로 이동">www.instagram.com/urbansports.kr</a>', "서울에서 가장 아름다운 걷기대회인 2022 브릿지워크서울이 3년 만에 돌아왔습니다. 가을, 노을 사이를 걷다라는 캐치프레이즈로 진행되는 이번 행사는 양화 한강공원(성수하늘다리 옆 공터)에서 시작해 한강대교~원효대교~마포대교를 경유하여 다시 양화대교로 돌아오는 20K 코스는 물론, 많은 참가자들의 성원으로 새롭게 생긴 10K 코스 등 다채로움으로 가득 채웠다.", 
'양화 한강공원', NULL, NULL, '유료(정가: 42,000원 / 얼리버드: 39,000원(8월 31일부터 일정 수량) / 수퍼얼리버드: 36,000원(수량 조기마감))','성별 연령 제한 없음', '20K 코스 제한시간 5시간 30분 / 10K 코스 제한시간 3시간');

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2502973 , '플라잉(FLYing)' , 20220415 , 20221230 , '경상북도 경주시 경감로 614', '(천군동)', 'A02081300', 'http://tong.visitkorea.or.kr/cms/resource/68/2502968_image2_1.jpg', 129.2892916998, 35.8315650725, 6, 35, 2, '054-775-0815', 
'<a href="https://www.cultureexpo.or.kr/open.content/ko/program/performance/flying/" target="_blank" title="새창: 플라잉 행사 홈페이지로 이동">http://www.cultureexpo.or.kr</a>', "익스트림 퍼포먼스 <플라잉>은 경상북도, 경주시와 한국 넌버벌 창작의 대표주자 최철기(‘난타’ 연출, ‘점프’, ‘비밥’ 총감독)가 만든 작품이다. 전 국가대표 출신 선수(리듬체조, 기계체조, 마샬아츠, 비보잉)들이 펼치는 화려한 기술의 향연과 친근한 도깨비의 유쾌함이 접목되어 남녀노소 누구나 쉽게 즐기실 수 있다.<br /><br />기존 '플라잉' 상설공연의 업그레이드를 통하여 공연의 다이내믹한 연출과 무대효과 극대화 추진
3D 영상 및 홀로그램과 로봇 등의 최첨단 공연기술을 접목하여 배우의 실연 공연과 영상이 만나는 판타지 효과를 연출한다.", 
'문화센터 문무홀', '<a href="https://m.booking.naver.com/booking/12/bizes/153378/items/4178858?area=bni" target="_blank" title="새창: 플라잉 행사 홈페이지로 이동">https://m.booking.naver.com</a>', NULL, '18,000원~27,000원',NULL, '80분');

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2498459 , '이월드 호러 어드벤처 :  좀비 스테이션' , 20220702 , 20220831 , '대구광역시 달서구 두류공원로 200', '(두류동)', 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/12/2824812_image2_1.jpg', 128.5648324581, 35.8548822436, 6, 4, 2, '053-620-0001', 
'<a href="http://www.eworld.kr" target="_blank" title="새창: 이월드 홈페이지로 이동">http://www.eworld.kr</a>', "올 여름 무더위를 날리고 오싹한 찐 공포를 즐길 수 있는 곳은 바로 어디?! 이월드 호러어드벤처!<br>이월드 여름축제 <호러 어드벤처>가 돌아왔다!<br><br>22년 이월드 호러 어드벤처 : 좀비 스테이션에서는 좀비로 분장할 수 있는 <좀비 살롱>이 운영되어 직접 좀비가 되어보는 이색 체험을 즐길 수 있으며, 전국 최장 체험 길이를 자랑하는 고스트하우스를 업그레이드한 <고스트하우스 스테이션>에서 간담이 서늘한 공포를 경험 할 수 있다. 또한 좀비 바이러스에 함락되어 극강의 공포를 극복 해야하는 <죽음의 숲 스테이션>, 마지막 희망의 종착지에서 펼쳐지는 좀비들의 퍼포먼스 <좀비 스테이션>으로 오감을 자극하는 오싹한 하루를 보낼 수 있다.<br><br>공포스러운 컨텐츠 외에도 <아쿠아 빌리지>에서 시원한 물을 맞으며 누구나 즐길 수 있는 컨텐츠도 준비가 되어 있다.남녀노소 친구,커플,가족 누구나 무더위를 날리고 찐 공포를 즐길 수 있는 이색 이벤트들과 함께하는 대구 최고의 여름 시즌을 기대 하셔도 좋다!<br><br>※ 자세한 행사내용은 이월드 인스타그램 @eworld.official 또는 이월드 페이스북 페이지를 참조.<br>※ 일부 행사는 현장상황에 따라 변경 및 취소될 수 있다.", 
'이월드', NULL, NULL, '이월드 홈페이지 참고','이월드 홈페이지 참고', NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2496162 , '강원그린박람회' , 20220826 , 20220828 , '강원도 춘천시 평화로 25 봄내체육관', NULL, 'A02080600', 'http://tong.visitkorea.or.kr/cms/resource/58/2496158_image2_1.jpg', 127.7185528170, 37.8814145022, 6, 32, 13, '033-260-9320', 
'<a href="https://www.instagram.com/gwgreenkr/" target="_blank" title="새창 : 강원 그린박람회">www.instagram.com</a>', "강원그린박람회는 강원도의 미래를 이끌어 갈 환경, 에너지, 녹색, 바이오, 의료 등 대한민국 국민들에게 최신 산업 제품들을 선보이고 판매하며 청소년들에게는 체험의 장을 마련하는 등 강원도 대표 산업 축제로 자리매김하며 나아가 대한민국을 대표하는 박람회로 성장하고 있다.", 
'봄내체육관', NULL, NULL, '무료','전연령가능', '기간내자유');

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2495916 , '휴애리 유럽 수국축제' , 20220715 , 20220915 , '제주특별자치도 서귀포시 남원읍 신례동로 256', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/24/2825224_image2_1.jpg', 126.6344317363, 33.3085171454, 6, 39, 3, '064-732-2114', 
'<a href="http://hueree.com" target="_blank" title="새창: 휴애리자연생활공원 홈페이지로 이동">http://hueree.com</a>', "서귀포시 남원읍 신례리에 위치한 휴애리 자연생활공원은 제주도민과 제주를 찾는 관광객에게 보다 나은 볼거리를 
제공하고 또 힐링의 공간이 되고자 오는 7월 15일부터 “휴애리 유럽 수국축제”를 개최한다고 밝혔다.<br>이번 2022 휴애리 유럽 수국축제는 정성스럽게 키운 유럽수국을 공원 곳곳에서 감상할 수 있어 제주도민과 관광객에게 
인기가 좋은 여름철 제주 대표 축제가 될 것으로 예상된다. <br>전년도 보다 더 풍성하게 준비될 이번 휴애리 유럽 수국축제는 신혼여행, 웨딩스냅, 우정스냅 등 인생사진 찍기 좋은 장소로 
인정받은 제주여행의 필수 코스 로 인정받고있다.  가족, 연인, 친구와 함께 다양한 수국포토존 에서 아름다운 추억을 만들 수
 있을 것으로 예상한다.", 
'휴애리자연생활공원 내', NULL, NULL, '성인:13,000원/단체:11,000원(단체30명이상)/도민,장애우,유공자,경로우대:6,500원<br>청소년:11,000원/단체:9,000원(단체30명이상)/도민, 장애우 :5,500원<br>어린이:10,000원/단체:8,0000원(단체30명이상)/도민, 장애우 :5,000원<br>경로할인은 65세 이상(신분증 제출)<br>만 24개월까지는 무료입장<br>세자녀 50%할인(자녀만 할인혜택, 고등학생까지)<br>제주도민, 장애인, 군경은 반드시 신분증 및 증명서를 제시해야 한다.',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2494459 , '주문진 불꽃크루즈' , 20220701 , 20221231 , '강원도 강릉시 해안로 1730 강릉시수협', NULL, 'A02081300', 'http://tong.visitkorea.or.kr/cms/resource/29/2826929_image2_1.jpg', 128.8284797182, 37.8895847227, 6, 32, 1, '1522-8905', 
'<a href="http://cruisestory.co.kr" target="_blank" title="새창: 강릉하트불꽃크루즈 홈페이지로 이동">http://cruisestory.co.kr</a>', "크루즈 위에서 즐기는 가장 가까운 불꽃축제!<br>사랑하는 사람과 가슴뛰는 데이트, 로맨틱한 선상에서 펼쳐지는 음악불꽃축제<br>매달 불꽃놀이 테마와 음악이 변경되는 주문진의 대표적인 선상음악불꽃축제이다.", 
'강원도 강릉시 주문진읍 해안로 1730', NULL, NULL, '대인 35,000원<br>소인 27,000원',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2492136 , '새만금 K-pop 페스티벌' , 20220826 , 20210828 , '전라북도 군산시 옥도면 신시도리', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/59/2839259_image2_1.jpg', 126.4809101954, 35.8134418681, 6, 37, 2, '063-220-8045', 
'<a href="http://www.kpopfestival.co.kr/" target="_blank" title="새창: 새만금 K-pop 페스티벌로 이동">www.kpopfestival.co.kr</a><br>-유튜브-<br>새만금개발청 <a href="https://www.youtube.com/c/kasdi0912" target="_blank" title="새창 : 새만금 K-pop 페스티벌">www.youtube.com/c/kasdi0912</a><br>전주MBC Original <a href="https://www.youtube.com/channel/UCcMrSGpNrKbM-2Oyf80p6rw" target="_blank" title="새창 : 새만금 K-pop 페스티벌">www.youtube.com/channel/UCcM</a>', "캠핑형 음악축제로서 국내 최고의 케이팝 공연과 최대 규모의 캠핑을 즐길 수 있다. 케이팝 콘서트는 남녀노소 누구나 즐길 수 있도록 트롯, 발라드, 댄스 가수 등이 출연하고, 개막 축하공연인 한류드라마&영화 OST공연은 원곡 가수와 오케스트라가 함께할 예정이다. 캠핑은 캠핑카&카라반, 차박, 일반캠핑 3개 구역으로 구분하여 캠핑카&카라반은 50여대를 준비할 예정이다. 축제 현장을 찾지 못하는 참가자들을 위해서는 유튜브 실시간 방송과 메타버스 플랫폼 활용한 프로그램도 제공된다.", 
'새만금 신시야미 부지', NULL, NULL, '무료케이팝 콘서트 2만원, 캠핑 사이트 임대료 상품별 상이(캠핑키&카라반 10만원, 차박 5만원, 일반텐트 3만원)',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2489499 , '국제무형유산영상축제(IIFF)' , 20220916 , 20220925 , '전라북도 전주시 완산구 서학로 95 국립무형유산원', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/37/2835637_image2_1.jpg', 127.1596636399, 35.8099038819, 6, 37, 12, NULL, 
'공식 홈페이지 <a href="https://iiff.iha.go.kr/service/main.nihc" target="_blank" title="새창 : 제 9회 국제무형유산영상축제">https://iiff.iha.go.kr</a><br>네이버 TV <a href="https://tv.naver.com/iiff2020/clips" target="_blank" title="새창 : 제 9회 국제무형유산영상축제">https://tv.naver.com</a><br>페이스북 <a href="https://url.kr/aigbhc" target="_blank" title="새창 : 제 9회 국제무형유산영상축제">https://url.kr/aigbhc</a><br>유튜브 <a href="https://url.kr/y19su2" target="_blank" title="새창 : 제 9회 국제무형유산영상축제">https://url.kr/y19su2</a><br>인스타그램 <a href="https://www.instagram.com/iiff.iiff2022/" target="_blank" title="새창 : 제 9회 국제무형유산영상축제">www.instagram.com/iiff.iiff2022</a>', "시간 속에서 형태가 없는 상태로만 전해져 내려오는 것들.<br>그런 것들은 실행하는 순간에만 재현된다. 찰나요, 일회적인 것들이다.<br>그런 것들은 누군가의 손에 달려있다.그리고 그 누군가는 다른 누군가에게 전달해주어야만 한다.<br>명맥을 유지하기 위해서는 그렇게 무형유산의 연결은 사람과 사람 사이에서 이루어진다.<br>국제무형유산영상축제는 무형의 유산들을 나름의 방식으로 기록하고 남기려한다.", 
'네이버TV,온피프엔, 국제무형유산원', NULL, NULL, NULL,NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2487990 , '2022 광주프린지페스티벌' , 20220604 , 20221022 , '광주광역시 남구 천변좌로338번길 7', '(구동)', 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/75/2822675_image2_1.jpg', 126.9086639556, 35.1479801537, 6, 5, 2, '062-670-7983', 
'홈페이지 <a href="http://fringefestival.kr/" target="_blank" title="새창 : 2022 광주프린지페스티벌">http://fringefestival.kr</a><br>인스타그램 <a href="https://instagram.com/gwangju_fringefestival" target="_blank" title="새창 : 2022 광주프린지페스티벌">https://instagram.com</a><br>페이스북 <a href="https://m.facebook.com/2022GJFF/" target="_blank" title="새창 : 2022 광주프린지페스티벌">https://m.facebook.com</a><br>유튜브 <a href="https://www.youtube.com/c/광주프린지페스티벌" target="_blank" title="새창 : 2022 광주프린지페스티벌">https://www.youtube.com</a>', "2022년, 올해 광주프린지페스티벌은 ‘시민, 예술애(愛) 물들go’를 슬로건으로 내세워, ‘우리동네 프린지’와 ‘민주광장 프린지’ 두 가지 방식으로 5·18민주광장과 마을을 아우르는 시민 참여형 축제로 총 15회 진행된다.<br>지역 예술 단체와 국내 초청 공연 등 다양한 공연을 어디서든 함께 할 수 있도록 진행 중이며 다양한 시민참여를 위한 예술·놀이 체험프로그램 및 아트마켓도 진행할 예정이다.<br>특히, 기후(환경) 위기를 주제로 하는 프로그램을 다수 진행할 예정이며 대표적으로 기후 위기 비상 행동을 촉구하며 실천하는, 쓰레기를 재활용하여 아트 작품으로 되살리는 <되살림 시민예술학교>, 생활 속 에너지 전환을 체험하는 <에너지 전환 예술놀이터>, ‘기후 위기 액션 플랜’ 중 하나인 사용하지 않는 에코백, 종이봉투 등을 모두와 함께 공유하는 <모두의 가방 : 자율포장대 운영> 등 다양한 프로그램이 있다.<br>시민참여 이벤트도 다수 준비되어 있는데 그 중 광주프린지페스티벌의 주제곡과 안무를 활용한 댄스 챌린지 이벤트, 기후(환경) 보전 이벤트 줍깅 퍼포먼스. 이 외에도 다양한 참여 이벤트를 준비 중이다.", 
'5·18민주광장 및 관내 5개 구 10곳', NULL, NULL, '무료','전체연령', NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2486085 , '피란수도 부산 문화재 야행' , 20220819 , 20220820 , '부산광역시 서구 임시수도기념로', '(부민동2가)', 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/03/2828003_image2_1.jpg', 129.0196549929, 35.1032530039, 6, 6, 11, '070-4365-8370', 
'<a href="http://busan-heritage-night.com" target="_blank" title="새창: 행사 홈페이지로 이동">http://busan-heritage-night.com</a>', "- 금순이와 금동이의 올랑올랑,달빛축제<br>- 피란수도 부산 문화재를 거닐며 즐기는 부산만의 특별한 야간 축제!<br>- 유네스코 세계유산 등재를 위한 부산의 노력!<br>- 역사 문화시설 야간 개방 및 전시·체험·공연 프로그램 운영", 
'임시수도기념거리 일원 및 부산시민공원', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2485123 , '순천 푸드앤아트 페스티벌' , 20221007 , 20221009 , '전라남도 순천시 중앙로 125-1 종합문구사', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/90/2852390_image2_1.jpg', 127.4840014124, 34.9569309401, 6, 38, 11, '061-749-5796', 
'<a href="http://sc-fafestival.com/" target="_blank" title="새창: 행사 홈페이지로 이동">http://sc-fafestival.com/</a>', "2022년 순천푸드앤아트페스티벌은  « 순천, 맛의 정원에 멋을 피우다 »라는 주제로, 순천 원도심에서 10월7일(금)~9일(일) 3일간 진행된다. 10월 7일 바이브, 포맨, 바다, 이하늘과 함께하는 EDM파티로 축제의 개막을 알린다. 순천의 고즈넉한 문화를 느낄 수 있는 중앙동 일대인 의료원 로터리~남교오거리, 문화의 거리~연자로, 남문터광장, 옥천변에서 진행되는 이번 축제는 순천 시민들이 직접 참여하는 푸드포차, 아트마켓 등으로 풍성한 볼거리, 먹을거리, 즐길 거리를 제공한다. 10월 가을에 순천 시민들에게 풍성하고 마음이 따뜻해지는 소중한 추억을 선물로 제공하는 2022 순천 푸드앤아트페스티벌로 놀러가자.", 
'중앙로일원<br>(의료원로타리~남교오거리/문화의거리~연자로,남문터광장,옥천변)', NULL, NULL, '무료<br>부스별 요금 상이','전연령 관람 및 체험 가능', '120분');

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2446530 , '웅진성 수문병 근무교대식' , 20220423 , 20221127 , '충청남도 공주시 웅진로 280', NULL, 'A02081300', NULL, 127.1236550047, 36.4651867499, 6, 34, 1, '공산성 관광안내소 041-856-7700', 
NULL, "2015년 유네스코 세계문화유산에 등재된 백제역사유적지구 중 공산성을 배경으로 펼쳐지는 '웅진성 수문병 근무교대식'은 철저한 역사적 고증 아래 제작된 의상과 소품을 활용하여 당시 왕성을 호위하던 수문병의 근무를 재현한다. 혹서기인 6월 둘째 주부터 8월 말까지 제외하고 4월부터 11월까지 매주 토,일요일에 진행된다. 특히, 올해부터는 기존 1일 6회 진행하던 교대식을 프로그램의 완성도를 높이기 위해 1일 2회(11시, 16시) 실시한다. 교대식에 참여하는 인원을 전원 전문 배우로 선정해 보다 역동적이고 현실감 있는 퍼포먼스를 선보일 예정이다. 이와 함께 매주 주말 오후 2시 진행되는 공산성 앞 무령왕 동상 회전의식에도 수문병들이 직접 참여해 관람객들에게 보다 풍성한 볼거리를 제공할 계획이다.", 
'공산성 금서루 및 연문광장 내 무령왕동상 주변', NULL, NULL, NULL,'전 연령 가능', NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2446020 , '정선아리랑극 아리아라리' , 20220402 , 20221127 , '강원도 정선군 정선읍 애산로 51', NULL, 'A02081300', 'http://tong.visitkorea.or.kr/cms/resource/05/2733805_image2_1.jpg', 128.6715234213, 37.3763882199, 6, 32, 11, '033-560-3017', 
'<a href="http://www.jacf.or.kr"title="새창: 정선아리랑극 아리아라리 이동 "target="_blank">http://www.jacf.or.kr</a>', "정선5일장이 열리는 날에는 아주 특별한 무대가 열린다. 정선아리랑센터에서 오후 2시에 막을 올리는 뮤지컬 퍼포먼스 <아리아라리>다. <아리아라리>는 정선아리랑의 전승과 보존을 위해 정선군과 정선아리랑문화재단이 제작한 창작 뮤지컬이다. 지난 2018년 초연 이후 큰 호응을 얻고 있다. 줄거리는 조선시대 정선에 사는 나무꾼 기목과 그의 아내 정선, 딸 아리가 등장하는 정선아리랑 설화가 바탕이다. 기목이 경복궁 중수를 위해 한양으로 떠난 후 15년 동안 소식이 끊기자, 딸 아리가 아버지를 찾아 한양으로 떠나 펼쳐지는 이야기다. 혼례, 나무 베기, 경북궁 중수, 애월에 흘린 밤, 보고 싶다 정선아 등 총 10개의 막으로 이뤄져 있다. 각 막마다 정선아리랑, 창작 아리랑 등의 노래와 나무꾼의 목도소리, 지체 춤 등이 최신 홀로그램 무대 영상과 어우러져 관객의 눈과 귀를 즐겁게 한다. 내용이 어렵지 않아 가족이 함께 보기에도 부족함이 없다. 커튼 콜 후에는 배우들과 기념사진을 촬영하는 시간이 주어진다. 또한 공연비 5,000원은 아리랑상품권으로 환급한다. 아리랑상품권은 정선의 지역화폐로 정선아리랑시장 등 지역가맹점에서 사용할 수 있다. 정선5일장에서만 누릴 수 있는 특별한 경험인 셈이다.", 
'아리랑센터 아리랑홀', NULL, NULL, '5,000원',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2436040 , '2022 청정임산물 대축제' , 20220824 , 20221016 , '대전광역시 서구 둔산대로 169 한밭수목원', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/33/2844333_image2_1.jpg', 127.3879840082, 36.3659250159, 6, 3, 3, '02-2058-1070', 
'<a href="http://www.xn--392bt3h2xgtqax7p.com/" target="_blank" title="새창 : 관광지">www.청정임산물.com</a>', "청정임산물을 국민들에게 다양한 형태로 알리기 위해, 제철 임산물을 간편하게 만날 수 있는 온&오프라인이 결합된 하이브리드형 축제로 개최되는 행사이다.<br>온라인 축제에서는 판매 기획전 및 라이브커머스 등이 진행되고 오프라인 축제에서는 개막식, 쿠킹클래스, K-FOREST FOOD 토크쇼, 버스킹 등 임산물을 활용한 다양한 프로그램이 구성되어 있다.", 
'대전엑스포 시민광장<br>[온라인 : 네이버 쇼핑, 우체국 쇼핑]', NULL, NULL, '무료','전연령대', NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2435280 , '제7회 강진만 춤추는 갈대축제' , 20221028 , 20221106 , '전라남도 강진군 생태공원길 47 남포축구장', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/73/2843773_image2_1.jpg', 126.7734749863, 34.6205428186, 6, 38, 1, '061-434-7795', 
'<a href="http://www.gangjin.go.kr/culture/festival/gangjinman_reed" target="_blank" title="새창: 강진만 춤추는 갈대축제 홈페이지로 이동">http://www.gangjingo.kr</a>', "이번이 벌써 7회째 맞이하는 강진만 춤추는 갈대축제는 1,131종의 생물이 서식하는 생명의 보고 강진만 생태공원에서 아름다운 석양과 함께 다양한 음악을 만나는 축제가 열린다.<br>다양한 공연과 먹거리, 신나는 음악을 들으며 가을의 정취와 낭만을 느낄 수 있는 이번 축제에서는 삶에 지친 도시민들에게 잠시나마 몸과 마을을 치유해 줄 소중한 시간이 될 것이다.", 
'강진만 생태공원(남포축구장)', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
1718137 , '2022 제49회 신라문화제' , 20221014 , 20221016 , '경상북도 경주시 중앙로 18', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/59/2831959_image2_1.jpg', 129.2118426468, 35.8414847113, 6, 35, 2, '054-777-5952~4', 
'<a href="https://www.gyeongju.go.kr/sillafestival/index.do" target="_blank" title="행사홈페이지로 이동">www.gyeongju.go.kr</a>', "신라문화제는 1962년 제1회를 시작으로 올해까지 제49회를 맞이하였다.<br>2022 제49회 신라문화제는 신라의 태동을 알리는 화려한 퍼포먼스가 펼쳐질 화백제전부터, 도시의 거리, 골목, 가게에서 펼쳐지는 수많은 아티스트들의 화려한 거리예술축제인 실크로드 페스타까지!<br>시민들과 관광객의 오감을 사로잡는 프로그램이 축제 기간 경주에서 펼쳐진다.", 
'경주 시내(봉황대 광장, 중심상가) 일원<br>경주 월정교 일원', NULL, NULL, '무료','전 연령', NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2416752 , '2022년 제13회 오산독산성문화제' , 20221001 , 20221002 , '경기도 오산시 현충로 100', '(은계동)', 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/68/2765168_image2_1.jpg', 127.0770956975, 37.1602725527, 6, 31, 22, '031-379-9924', 
'<a href="http://www.doksanseong.kr" target="_blank" title="새창: 독산성문화제 홈페이지로 이동">http://www.doksanseong.kr</a>', "오산시 대표 문화재인 독산성과 세마대지, 권율장군의 지혜를 기조로 한 다양한 볼거리와 즐길 거리 제공", 
'오산고인돌공원', NULL, NULL, NULL,'전연령가능', '기간내자유');

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2412052 , '2022 제6회 청년의 날' , 20220917 , 20220917 , '서울특별시 송파구 올림픽로 424', '(방이동)', 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/51/2847451_image2_1.jpg', 127.1229758237, 37.5209871362, 6, 1, 18, '02-780-3939', 
'<a href="http://www.ynf.or.kr" target="_blank" title="새창: 청년의날 행사 홈페이지로 이동">http://www.ynf.or.kr</a>', "대한민국 최초! 청년을 위한 자발적 참여형 종합축제, 2022 제6회 대한민국 청년의 날! 국회사무처 소관 사단법인 청년과미래에서 2016년 부터 법정기념일 지정을 위해 준비해온 청년의 날이, 법정기념일로 지정되었다. 매년 9월 셋째 주 토요일, 더욱 화려해진 라인업과 흥미진진한 프로그램들로 청년들의 심장을 뛰게해줄 [2022 청년의 날]을 기대해보자! 2022년 9월 17일 토요일, 올림픽공원 평화의광장에서 청년의 날이 개최된다.", 
'올림픽공원 평화의광장', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2405329 , '종로한복축제' , 20221008 , 20221009 , '서울특별시 종로구 세종대로 172 5호선 광화문역', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/55/2852355_image2_1.jpg', 126.9767821434, 37.5716786179, 6, 1, 23, '02-6263-1185', 
'<a href="https://jongnohanbok.kr/site/main/home" target="_blank" title="새창 : 종로한복축제">https://jongnohanbok.kr</a>', "종로한복축제는 한복의 아름다움과 우수성을 널리 알리고 한복의 대중화와 한복입기 생활화를 위해 2016년부터 개최온 축제로, 한복과 다양한 전통문화콘텐츠를 활용한 행사 및 다채로운 볼거리를 제공해왔다.", 
'광화문광장', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2408959 , '2022 인천개항장 문화재 야행' , 20220924 , 20220925 , '인천광역시 중구 신포로27번길 80 중구청', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/15/2848915_image2_1.jpg', 126.6213645301, 37.4735225945, 6, 2, 10, '02-6961-5435', 
'<a href="http://www.culturenight.co.kr" target="_blank" title="새창: 인천개항장 문화재야행 홈페이지로 이동">http://www.culturenight.co.kr</a>', "1883 꺼지지 않는 개항의 밤 이야기! 2022 인천개항장 문화재 야행 인천개항장의 역사와 문화유산을 느낄 수 있는 문화재 야간 개방과 아름다운 빛의 거리 등 인천개항장 문화재 야행과 함께 잊지 못할 특별한 프로그램으로 낭만 가득한 가을밤의 시간여행을 떠나보자!<br>○ 문화재 야행<br>1차 야행 2022.09.24.(토) ~ 09.25.(일) / 18:00 ~ 22:00<br>2차 야행 2022.10.15.(토) ~ 10.16.(일) / 18:00 ~ 22:00", 
'인천개항장 문화지구 일원', NULL, NULL, '무료','전연령', '1시간');

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2406168 , '제 6회 원주문화의거리 치맥축제' , 20220831 , 20220903 , '강원도 원주시 중앙로 76', NULL, 'A02070200', NULL, 127.9520334545, 37.3483223197, 6, 32, 9, '033 734-8881', 
'<a href="https://blog.naver.com/wonju_city/222861090952" target="_blank" title="새창: 제 6회 원주문화의거리 치맥축제 홈페이지로 이동">https://blog.naver.com</a>', "지구를 지키는 작은 실천! 텀블러와 함께하는 치맥 축제<br>3년 만에 다시 개최되는 치맥 축제를 통하여 지구를 지키는 작은 실천의 일환으로 텀블러 사용을 독려하고, 원주 대표 먹거리 축제로 자리매김하고 나아가 글로벌 축제로 만들어 가고자 한다.", 
'원주 문화의거리', NULL, NULL, '텀블러 지참하여 생맥주 구매 시 500원 할인',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2403896 , '2022 태안 가을꽃박람회' , 20220901 , 20221031 , '충청남도 태안군 안면읍 꽃지해안로 400', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/29/2836329_image2_1.JPG', 126.3367943161, 36.5011689948, 6, 34, 14, '041-675-5533', 
'<a href="http://www.koreaflowerpark.com" target="_blank" title="새창: 가을꽃 축제 홈페이지로 이동">http://www.koreaflowerpark.com</a>', "태안 세계튤립꽃박람회가 펼쳐졌던 코리아플라워파크!<br>오픈 런 형식으로 연중 운영(겨울시즌 제외)되며 지금도 활짝 핀 꽃들이 여러분들을 맞이하고 있다.<br>오는 9월 1일부터 10월 31일까지는 수국, 임파첸스, 버베나 등 풍요로운 가을을 적셔줄 2022 태안 가을꽃박람회가 펼쳐진다.", 
'코리아플라워파크', NULL, NULL, '성인 : 10,000원 / 경로 및 단체: 9,000원 / 유아 및 청소년 : 8,000원','전 연령', NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2396011 , '허브아일랜드 향기샤워축제' , 20220716 , 20221031 , '경기도 포천시 청신로947번길 51', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/18/2827718_image2_1.jpg', 127.1334898415, 37.9662355012, 6, 31, 29, '031-535-6494', 
'<a href="http://www.herbisland.co.kr" target="_blank" title="새창: 허브아일랜드 홈페이지로 이동">http://www.herbisland.co.kr</a>', "더위를 잊게 해줄 안개 미스트에는 천연 허브 에센셜 오일이 들어가 있어 몸과 마음을 시원하게 정화해 준다.<br>허브아일랜드 대표 여름 축제, 향기샤워축제에서 무더위를 싹 날려보자.", 
'허브아일랜드', NULL, NULL, '일반: 9,000원<br>어린이(37개월~중학생): 7,000원<br>우대(장애인, 노인, 국가유공자, 단체(20인)): 7,000원',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2394665 , '제8회 계촌 클래식 축제' , 20220827 , 20220828 , '강원도 평창군 방림면 계촌리', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/83/2826283_image2_1.jpg', 128.3034237089, 37.4521530269, 6, 32, 15, '010-2814-1055', 
'<a href="http://artvillage.or.kr/" target="_blank" title="새창: 계촌마을클래식거리축제 홈페이지로 이동">www.artvillage.or.kr</a>', "강원도 평창군에 위치한 계촌마을은 2015년 계촌 클래식 마을로 선정됐다. 계촌마을은 비경은 물론이고 전교생이 오케스트라 단원으로 활동하고 있다. 우수한 자연경관과 클래식 음악이 상생하며 아이들과 마을 공동체가 함께 문화예술을 조우하는 제8회 계촌 클래식 축제가 오는 8월 27일 28일 양일 열린다.", 
'강원도 평창군 방림면 계촌마을 계촌 클래식 공원, 계촌마을별빛무대 등', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2393544 , '2022전주문화재야행 ‘치유의 경기전을 거닐다’' , 20220923 , 20220924 , '전라북도 전주시 완산구 태조로 44', '(풍남동3가)', 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/84/2846384_image2_1.jpg', 127.1493699447, 35.8162807559, 6, 37, 12, '063-232-9937', 
'홈페이지- <a href="http://www.jeonjunight.com/" target="_blank" title="새창 : 전주문화재야행">http://www.jeonjunight.com</a><br>네이버블로그- <a href="https://blog.naver.com/jeonjunight9937" target="_blank" title="새창 : 전주문화재야행">https://blog.naver.com</a><br>페이스북- <a href="https://www.facebook.com/2020전주문화재야행-400162894106188" target="_blank" title="새창 : 전주문화재야행">https://www.facebook.com</a><br>인스타그램- <a href="https://www.instagram.com/jeonjunight/" target="_blank" title="새창 : 전주문화재야행">https://www.instagram.com</a>', "전주문화재야행이 오는 9월 23일부터 24일까지 전주 한옥마을, 경기전 일대에서 열린다.<br>올해 전주문화재야행의 슬로건은 ‘치유의 경기전을 거닐다'이다. <br>경기전을 다양한 힐링 콘텐츠로 가득 채움으로써, 남녀노소 누구나 편안하게 휴식할 수 있도록 구성했다. <br>또한, 경기전 좀비실록과 같은 다양한 참여형 콘텐츠를 적극적으로 활용해 축제의 즐거움을 더했다.", 
'전주 한옥마을, 경기전', NULL, NULL, '무료<br>* 체험 프로그램(유료)<br>- 한지등 만들기 1,000원 / 경기전 좀비실록 5,000원 / 풍선 3,000원 / 거리의 화공 5,000원 / 컬러링북 1,000원 / 종이접기왕 1,000원 / 종이갓 2,000원',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2392418 , '2022 평창백일홍축제' , 20220906 , 20220912 , '강원도 평창군 평창읍 제방길 81', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/56/2838656_image2_1.jpg', 128.3828276076, 37.3608400696, 6, 32, 15, '033-333-6033', 
'<a href="http://101hongfestival.co.kr/" target="_blank" title="새창: 백일홍축제 홈페이지로 이동">http://101hongfestival.co.kr</a>', "강원도 평창군의 군청소재지인 평창읍에서 개최되는 백일홍축제는 평창읍을 대표하는 관광형축제다. 3년만에 돌아온 백일홍축제는 자연과 하나되듯 어우러지는 평창강변에서 개최되며 약 1만여평의 백일홍 꽃밭이 장관을 이룬다. 이 밖에도 붉은 메밀, 황화 코스모스 등의 볼거리를 더한 종합 꽃축제로 나아가고 있다.", 
'평창백일홍축제장', NULL, NULL, '홈페이지 참조',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2392105 , '2022 달성 대구현대미술제' , 20220902 , 20221003 , '대구광역시 달성군 강정본길 57 강정보통합관리센터', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/05/2843905_image2_1.jpg', 128.4649721907, 35.8412902808, 6, 4, 3, '053)659-4282', 
'<a href="http://www.dalseongart.com/" target="_blank" title="새창: 행사 홈페이지로 이동">http://www.dalseongart.com</a>', "1970년대 젊은작가들이 기성미술계의 경직성에 도전하며 다양한 미술실험을 펼쳤던 ‘대구현대미술제’의 정신을 계승하여 강정보 일원에서 열리는 현대미술축제이다. 달성 대구현대미술제가 개최되는 장소 강정은 1977년 ‘제3회 대구현대미술제’ 당시, 역대 최대규모인 200여명의 작가가 참여한 한국최초의 집단적 이벤트가 펼쳐진 장소로 그 의의를 가진다.<br>오늘날의 강정은 금호강과 낙동강이 만나는 지정학적 위치와 ‘동양 최대 수문’ 이라 불리는 강정보, 세계적인 건축가 하니 라시드가 디자인한 기하학적 디자인의 디아크 등 다양한 지역적 사회적 요소들이 갖추어져 있다.", 
'강정보 디아크 광장, 달천예술창작공간', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2385656 , '이월드 아쿠아 빌리지' , 20220702 , 20220828 , '대구광역시 달서구 두류공원로 200', '(두류동)', 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/78/2847478_image2_1.jpg', 128.5648324581, 35.8548822436, 6, 4, 2, '053-620-0001', 
'<a href="http://www.eworld.kr" target="_blank" title="새창: 이월드 홈페이지로 이동">http://www.eworld.kr</a>', "이월드가 대구의 무더위를 쿨하게 책임지는 <이월드 아쿠아 빌리지>를 개최한다.<br>이월드 아쿠아 빌리지에서 물과 함께 즐기는 컨텐츠로 더위를 날려 보자.<br><br>이번 아쿠아 빌리지를 위해 피크닉 가든은 하와이 풍의 휴양지 느낌으로 새롭게 변신했다. 22년 아쿠아빌리지에서는 대구 최초로 인공서핑 머신을 만나볼 수 있다. 도심속에서 시원하게 파도를 가르는 인공 서핑 <서핑라이더>를 즐겨보자. 또한 더위를 날리는 짜릿한 워터슬라이드 <익스트림 워터 슬라이더>, 수심 1.2M의 성인용 풀부터 수심 60cm의 어린이용 풀까지 어린이부터 어른까지 모두 다 즐길 수 있는 초대형 스위밍 풀을 오픈한다. 대구 도심 속 휴양지 이월드 아쿠아 빌리지에서 시원하게, 신나게 놀아보자.<br><br>이월드 아쿠아빌리지는 7월 2일 오픈하여 8월 31일까지 진행된다.<br><br>※ 자세한 행사내용은 이월드 인스타그램 @eworld.official 또는 이월드 페이스북 페이지를 참조.<br>※ 일부 행사는 현장상황에 따라 변경 및 취소될 수 있다.", 
'이월드', NULL, NULL, '이월드 홈페이지 참고','전연령가능', NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2384776 , '서울 명산트레킹' , 20220423 , 20220912 , '서울특별시 중구 퇴계로34길 28', '(필동2가)', 'A02081300', NULL, 126.9935365470, 37.5584387906, 6, 1, 100, '02-490-2778', 
'<a href="https://www.seoulsports.or.kr/user/citizenAction/userCitizenProgramView.do?idx=466&citizenParam=traking" target="_blank" title="새창: 서울특별시체육회 홈페이지로 이동">http://www.seoulsports.or.kr</a>', "서울 명산 트레킹은 서울특별시에서 주최하고 서울특별시체육회에서 주관하는 생활체육 참여 프로그램이다. 서울에 있는 명산을 선별하여 서울 시민(가족, 친구, 연인 등)이 운동을 직접 참여하고 즐거운 시간을 만들 수 있는 분위기를 조성해주기 위함이다. 도심과 자연이 함께 어우러져 있는 서울의 모습을 보며 운동의 중요성도 느낄 수 있으며  여가 문화 확산을 통한 명랑한 사회 분위기를 조성할 수 있다.", 
'1차: 서울시 걷기 좋은 길(자유선택)<br>2~4차: 홈페이지 참조', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2381938 , 'K-핸드메이드페어 2022' , 20221201 , 20221204 , '서울특별시 강남구 영동대로 513', '(삼성동)', 'A02081300', 'http://tong.visitkorea.or.kr/cms/resource/98/2815098_image2_1.jpg', 127.0591318945, 37.5118092746, 6, 1, 1, '02-761-2512', 
'<a href="http://www.k-handmade.com" target="_blank" title="새창: 행사 홈페이지로 이동">http://www.k-handmade.com</a>', "'K-핸드메이드페어'는 국내 최대 핸드메이드 페어로서, 올해로 18회차를 맞이하고 있다.<br>아티스트와 소비자 간의 교류의 장으로서의 역할을 하며 핸드메이드 산업의 동향을 파악할 수 있다.<br> 출품 업체 및 작가들은 주요 타겟 및 바이어와의 소통을 통한 효과적인 프로모션이 가능하다.<br>각종 트렌디한 핸드메이드 완제품뿐 만 아니라, DIY KIT, 각종 부자재/재료를 한 자리에서 만나볼 수 있고, 공예 체험을 해볼 수 있는 공간도 마련될 예정이다.", 
'코엑스 B홀, COEX HALL B', NULL, NULL, '현장구매 시 10,000원<br>1차 사전등록(~10/17) 시 6,000원<br>2차 사전등록(10/18~11/30) 시 7,000원<br>*사전등록 :  <a href="https://front.maketicket.co.kr/ticket/GD2200945" target="_blank" title="새창 : K-핸드메이드페어 2022">https://front.maketicket.co.kr</a>',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2039869 , '2022 구로G페스티벌 × 안양천 빛축제' , 20220923 , 20220925 , '서울특별시 구로구 구일로 133 구일역', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/62/2832762_image2_1.jpeg', 126.8699356688, 37.4964437822, 6, 1, 7, '02-860-2282', 
'<a href="http://www.gfestival.co.kr" target="_blank" title="새창 : 구로 아시아 문화축제 홈페이지로 이동">http://www.gfestival.co.kr</a><br>유튜브 <a href="https://www.youtube.com/channel/UChJ4AEHO04glsT6g7qnYpGA/featured" target="_blank" title="새창: 홈페이지로 이동">https://www.youtube.com</a><br>인스타그램 <a href="https://www.instagram.com/GURO_GFESTIVAL/" target="_blank" title="새창: 홈페이지로 이동">https://www.instagram.com</a>', "개막행사 및 주민자치프로그램 발표회(축하공연: 정동원, 코요테),  타임투락(출연 : 데이브레이크, 육중완밴드),  TOP10 가요쇼 특집 방송(출연: 김호중, 장민호), 안양천 빛축제 등", 
'안양천(구일역 ) ~ 생태초화원(도림천역)', NULL, NULL, NULL,NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2035335 , '2022 대한민국 마한문화제' , 20221008 , 20221009 , '전라남도 나주시 고분로 747 국립나주박물관', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/29/2835929_image2_1.jpeg', 126.6589140170, 34.9148911497, 6, 38, 6, '061-339-8722', 
'<a href="http://www.naju.go.kr/tour/" target="_blank" title="새창: 행사 홈페이지로 이동">http://www.naju.go.kr/tour/</a>', "2천년전 영산강을 중심으로 화려한 문화를 자랑했던 지역민의 역사적 자긍심을 끌어올리고 고대 마한의 중심이었던 나주를 널리 알리기 위해 국립나주박물관 일원에서 개최한다.", 
'국립나주박물관', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2031318 , '임실N치즈축제 2022' , 20221007 , 20221010 , '전라북도 임실군 성수면 도인2길 50', '(성수면)', 'A02070100', 'http://tong.visitkorea.or.kr/cms/resource/85/2839285_image2_1.jpg', 127.3012056927, 35.6328486749, 6, 37, 10, '063-643-3900', 
'<a href="http://www.imsilfestival.com" target="_blank" title="새창 : 임실N치즈축제 홈페이지로 이동">http://www.imsilfestival.com</a>', "[축제소개] 
치즈의 고장 임실에서 펼쳐지는 임실N치즈축제는 하루 종일 고소한 치즈향과 함께하는 행복한 축제이다. 동화 속 세상 같은 아름다운 풍경을 자랑하는 임실치즈테마파크와 임실치즈마을에서 개최되며, 9개 테마 84개의 다채로운 프로그램으로 채워져 있다. 직접 치즈를 만들어보는 체험부터 치즈를 소재로한 쿠킹쇼나 어린이 공연, 화려한 EDM파티와 야간퍼레이드 등이 펼쳐진다. 축제기간 동안 임실군에서 생산된 신선하고 맛있는 음식과 특산물들도 판매한다.
[축제TIP] 임실치즈란?
1958년 벨기에에서 임실로 선교를 하러 온 지정환 신부님께서 임실의 지역 특산물로 만들기 위해 개발한 치즈이다. 임실의 청정한 자연환경에서 자란 건강한 소에서 얻은 우유와 무색소, 무향료, 무방부제로 만들어 HACCP인증을 받은 친환경 치즈로 사랑받고 있다.", 
'임실치즈테마파크, 임실치즈마을 일원', NULL, NULL, '무료(프로그램 유료)',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2029539 , '2022 실버문화페스티벌' , 20221020 , 20221022 , '온라인개최', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/81/2835181_image2_1.png', 126.9579759370, 37.5570966421, 6, 1, 13, '02)704-2311', 
'<a href="https://www.실버문화페스티벌.kr/" target="_blank" title="새창 : 실버문화 페스티벌 홈페이지로 이동">www.실버문화페스티벌.kr</a>', "전 세대가 함께 즐기는 어르신 중심 문화예술축제 실버문화페스티벌<br>언제, 어디서나 끊임없이 도전하는 청춘들의 꿈과 열정이 가득한 축제를 함께 즐기자!", 
'문화로청춘 유튜브', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2029491 , '2022 과천축제 “나와”' , 20220916 , 20220918 , '경기도 과천시 통영로 5 과천시민회관', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/28/2830528_image2_1.jpg', 126.9906765998, 37.4280177724, 6, 31, 3, '02-2009-9734(9739)', 
'<a href="http://www.gcfest.or.kr" target="_blank" title="새창 :과천축제 행사 안내 홈페이지로 이동">http://www.gcfest.or.kr</a>', "과천시가 주최하고, 과천문화재단이 주관하는 과천축제는 지난 1997년 '세계마당극 큰잔치'라는 이름으로 처음 선보인 아래, 수준 높은 거리극과 다채로운 야외 퍼포먼스로 국내에서 손꼽히는 도심형 축제로 평가받고 있다.", 
'과천시민광장(과천시민회관 옆 잔디마당) 및 과천시민회관 일대', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2028440 , '한강달빛야시장' , 20220917 , 20221030 , '서울특별시 서초구 신반포로11길 40 한강공원 반포 안내센터', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/49/2848549_image2_1.jpg', 126.9927658294, 37.5077391108, 6, 1, 15, '02-120', 
'홈페이지 <a href="http://www.bamdokkaebi.org" target="_blank" title="새창 : 서울 밤도깨비 야시장 홈페이지로 이동">http://www.bamdokkaebi.org</a><br>인스타그램 <a href="https://www.instagram.com/hangangmoonlightmarket/" target="_blank" title="새창 : 한강달빛야시장 홈페이지로 이동">www.instagram.com</a>', "※ 9/10 - 9/11 태풍 11호 힌남노의 영향으로 인한 공원 침수 복구로 휴장<br>※ 행사지의 주차장이 협소하오니 대중교통을 이용해 주시기 바랍니다. <br>● 9월 17일 (토) - 9월 25일 (일) 중 매주 토·일 반포한강공원 개장 예정<br>● 10월 22일 (토) - 10월 30일 (일) 중 매주 토·일 여의도한강공원 개장 예정<br>※운영 기간 중 우천 시 휴장<br><br>한강 위, 달빛이 떠오르면 맛있는 먹거리는 물론 다양한 행사와 예술가가 참여하는 장터, 오랫동안 간직하고 싶은 수공예 상품까지 낭만적인 야경을 배경으로 모두 한자리에 모인다. 한강 달빛 야시장은 달빛 아래 예술과 낭만이 있는 서울형 야시장이다.", 
'반포한강공원 달빛광장 일대, 여의도한강공원 일대', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2025174 , '대학로문화축제' , 20220826 , 20220828 , '서울특별시 종로구 대학로 104', NULL, 'A02070200', NULL, 127.0023878907, 37.5805669329, 6, 1, 23, NULL, 
NULL, "대학생이 말하는 대학로 : 대학로의 아티스트, 대학로의 건축물, 대학로의 역사 등등 대학생이 축제로 풀어낸 대학로의 모든 것.<br>대학로 4차선 위에서 다양한 공연, 전시가 펼쳐지는 국내최대 규모의 대학생 축제이다.", 
'마로니에공원, 좋은공연안내센터 다목적홀', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2021717 , '청주읍성큰잔치' , 20220902 , 20220904 , '충청북도 청주시 상당구 상당로55번길 33 청주중앙공원', '(남문로2가)', 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/48/2839848_image2_1.jpg', 127.4887982220, 36.6329017813, 6, 33, 10, '043-265-3624', 
'<a href="http://www.xn--oj4bt5iegj5c8wilzcf9e.kr/#visual" target="_blank" title="새창 : 청주읍성큰잔치 홈페이지로 이동">www.청주읍성큰잔치.kr</a>', "1,592년 임진왜란 당시 의병과 승병들이 주도한 연합군이 처음으로 성을 지켜낸 역사적 사건을 기념하는 시민참여형 역사·문화 축제이다. 청주성 탈환 전투의 정신적, 역사적 의미를 이어가며 청주의 정체성 확립과 청주 시민의 자긍심을 높이고자 하는데 목적을 두고 있다. 시민참여와 체험 지향형 축제로써 정체성과 독창성을 살린 다양한 프로그램들을 만나볼 수 있다.", 
'청주중앙공원 일원', NULL, NULL, NULL,NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
2005233 , '2022 정동야행' , 20220923 , 20220924 , '서울특별시 중구 세종대로 99 덕수궁', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/56/2851856_image2_1.jpg', 126.9765906796, 37.5651071556, 6, 1, 24, '010-9232-8571', 
'<a href="http://jeongdong-culturenight.kr" target="_blank" title="새창: 2022 정동야행 홈페이지 이동">jeongdong-culturenight.kr</a>', "정동의 르네상스라는 주제로 정동이 과거와 미래를 잇는 대한민국 문화 중심으로의 재도약을 위한 2022 정동야행을 개최한다.", 
'서울 중구 정동 일대', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
1998564 , '궁중문화축전' , 20221001 , 20221009 , '서울특별시 종로구 사직로 161', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/07/2718907_image2_1.png', 126.9769930325, 37.5788222356, 6, 1, 23, '02-3210-4683', 
'궁중문화축전 누리집: <a href="https://www.chf.or.kr/fest" target="_blank" title="새창:궁중문화축전 홈페이지로 이동">https://www.chf.or.kr</a><br>인스타그램: <a href="https://www.instagram.com/royalculturefestival_official/" target="_blank" title="새창:궁중문화축전 홈페이지로 이동">https://www.instagram.com</a><br>블로그: <a href="https://blog.naver.com/royalculture" target="_blank" title="새창:궁중문화축전 홈페이지로 이동">https://blog.naver.com</a><br>유튜브: <a href="https://www.youtube.com/results?search_query=%EA%B6%81%EC%A4%91%EB%AC%B8%ED%99%94%EC%B6%95%EC%A0%84" target="_blank" title="새창:궁중문화축전 홈페이지로 이동">https://www.youtube.com</a>', "‘궁중문화축전’은 대한민국의 대표 문화유산인 경복궁, 창덕궁, 덕수궁, 창경궁, 경희궁 5대궁과 종묘, 사직단을 배경으로 펼쳐지는 국내 최대 문화유산 축제이다. 2014년 시범사업을 거쳐 2015년부터 정식 개최된 궁중문화축전은 '오늘, 궁을 만나다'라는 슬로건 아래 매년 각 고궁의 장소성과 역사성을 활용한 공연, 전시, 체험, 의례 등의 문화예술프로그램을 선보이고 있다. 2020년부터 축제 공간을 고궁 밖으로 확장하여 비대면, 온라인 특화 콘텐츠를 함께 공개하고 있으며, 2021년부터 오프라인 행사 기간을 확대하여 매년 5월 ‘봄 궁중문화축전’과 10월 ‘가을 궁중문화축전’으로 연 2회 관람객에게 특별한 시간을 선사한다.", 
'경복궁, 창덕궁, 덕수궁, 창경궁, 경희궁, 종묘, 사직단', NULL, NULL, '프로그램별 상이',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
1993110 , '안산별빛마을' , 20220101 , 20221231 , '경기도 안산시 상록구 수인로 1723', '(부곡동)', 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/53/2702853_image2_1.jpg', 126.8634434286, 37.3394480000, 6, 31, 15, '031-484-5050', 
'<a href="http://www.ansanstar.net" target="_blank" title="새창: 안산별빛마을 홈페이지로 이동">http://www.ansanstar.net</a>', "<2022 안산별빛마을 애니멀 & 하트빌리지 빛축제>
고속도로 변에 한적하게 위치한 도심 속 숲에는 별빛이 내린 빛의 정원과 200여 마리의 실사이즈 동물 조형물들, 그리고 사랑하는 사람들과 추억을 남길 수 있는 포토존들로 가득하다.", 
'안산별빛마을포토랜드', NULL, NULL, '대인(중학생 이상) 7,000원<br>
소인(24개월 ~ 초등학생) 5,000원<br>
장애인·경로 5,000원',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
1957556 , '창경궁 야간 상시관람' , 20210101 , 20231231 , '서울특별시 종로구 창경궁로 185', '(와룡동)', 'A02081300', 'http://tong.visitkorea.or.kr/cms/resource/48/2597548_image2_1.jpg', 126.9945052690, 37.5807973206, 6, 1, 23, '02-762-4868', 
'<a href="http://cgg.cha.go.kr" target="_blank" title="새창: 칭경궁 홈페이지로 이동">http://cgg.cha.go.kr</a>', "특정 기간동안에만 진행되던 창경궁 야간 특별관람이 2019년부터 상시로 진행된다. (궁궐은 오후 9시까지 개방되며, 마지막 입장은 오후 8시에 마감된다.)<br>홍화문, 명정전, 통명전, 춘당지, 대온진 권역을 개방하여 깊어가는 밤 소중한 우리의 문화유산인 창경궁을 거닐어보자. 예매는 인터넷을 통해 가능하며 65세 이상 어르신은 전화 예매 또한 가능하다. 자세한 안내는 창경궁관리소 (02-762-9515, 4868~9) 문의 또는 홈페이지를 참고바란다.<br><br>* 창경궁<br>창경궁은 세종대왕이 상왕인 태종을 모시고자 1418년에 지은 수강궁이 그 전신이다. 이후 성종 임금 대로 와서 세조의 비 정희왕후, 덕종의 비소혜왕후, 예종의 비 안순왕후를 모시기 위해 명정전, 문정전, 통명전을 짓고 창경궁이라 명명했다. 창경궁에는 아픈 사연이 많다. 임진왜란 때 전소된 적이 있고 이괄의 난이나 병자호란 때에도 화를 입었다. 숙종 때의 인현왕후와 장희빈, 영조 때 뒤주에 갇혀 죽임을 당한 사도세자의 이야기 등이 창경궁 뜰에 묻혀있다.<br><br>창경궁은 일제강점기에 일제에 의하여 창경원이라 격하되고 동물원으로 탈바꿈 했었으나, 일제의 잔재를 없애기 위한 온 겨레의 노력으로 1987년부터 그 옛날 본래 궁의 모습을 되찾게 되었다. 홍화문, 명정전(조선 왕조의 정전 중에서 가장 오래된 건물임), 통명전, 양화당, 춘당지 등이 있으며 구름다리를 통하여 종묘와 드나들 수 있게 되어 있다.", 
'창경궁', '옥션과 인터파크 티켓 구매(일반인 및 한복착용자 현장 판매는 없음) / 만 65세 이상은 현장구매와 전화(1544-1555) 구입 가능', NULL, '유료<br>홈페이지 참조','연령제한없음', '개방시간 내 자유');

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
1945450 , '2022 전주독서대전' , 20220930 , 20221002 , '전라북도 전주시 완산구 전주천동로 20 전주한벽문화관', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/48/2816848_image2_1.jpg', 127.1587442277, 35.8118258696, 6, 37, 12, '063-230-1859', 
'<a href="http://jjbook.kr" target="_blank" title="대한민국독서대전 홈페이지로 이동">http://jjbook.kr</a>', "전주독서대전은 대한민국 최대 규모 책 축제로 올해는 \"책 여행, 발견하는 기쁨\"이라는 주제로 2022년 9월 30일(금)부터 10월 2일(일)까지 전주한벽문화관, 완판본문화관 일원에서 진행 된다.", 
'전주한벽문화관, 완판본문화관 일원', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
229892 , '영천보현산별빛축제' , 20221001 , 20221003 , '경상북도 영천시 별빛로 681-32', NULL, 'A02070200', NULL, 128.9963113930, 36.1400301975, 6, 35, 15, '054-330-6702<br>053-767-0220', 
'<a href="http://xn--bm3bldu0cg6dn6jsldj4kb4bc17a.com/" target="_blank" title="새창:별빛축제 홈페이지로 이동">http:/영천보현산별빛축제.com</a><br>
<a href="https://www.instagram.com/ycstar2004/" target="_blank" title="새창: 별빛축제 인스타그램으로 이동">https://www.instagram.com/ycstar2004/</a>', "'밤하늘 별을 따라 신비의 우주속으로' 최고의 밤하늘과 아름다운 경관 등 풍부한 생태 문화 관광자원을 보유한 영천 보현산 자락에서 보현산천문과학관 및 국립 보현산 천문대 등 천문∙우주관련 인프라를 바탕으로한 순수 천문 ∙ 우주 ∙ 과학 체험 축제이다.", 
'영천보현산천문과학관 일원', NULL, NULL, '무료','전연령 가능함', NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
1926835 , '태안 빛축제' , 20210101 , 20231231 , '충청남도 태안군 남면 마검포길 200', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/15/2445115_image2_1.jpg', 126.2998807800, 36.6151330244, 6, 34, 14, '041-675-9200', 
'<a href="http://www.ffestival.co.kr" target="_blank" title="새창: 태안빛축제 홈페이지로 이동">http://www.ffestival.co.kr</a>', "일년 365일 연중무휴로 진행되는 태안빛축제가 대한민국의 밤하늘을 책임진다.", 
'네이쳐월드', NULL, NULL, '성인:9,000원, 청소년:7,000원, 청소년현장단체:7,000원, 단체:8,000원','연령제한없음', '기간내자유');

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
1849007 , '2022 세종축제' , 20221007 , 20221010 , '세종특별자치시  호수공원길 155', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/11/2848811_image2_1.jpg', 127.2750155705, 36.4967663593, 6, 8, 1, '044-850-0556', 
'<a href=" https://www.2022festivalsj.com" target="_blank" title="새창:세종축제 홈페이지로 이동"> https://www.2022festivalsj.com</a>', "세종축제는 시민 한 사람 한 사람이 500년전 어린 세종 '이도'가 되어 즐기는 축제로 매년 10월 호수공원을 중심으로 개최된다. 축제로 들썩이는 4일간의 낮과 밤의 주인공으로 여러분을 초대한다.", 
'세종호수•중앙공원 일원', NULL, NULL, '무료(일부 유료)',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
1847162 , '의정부 국제가야금축제' , 20220923 , 20220924 , '경기도 의정부시 의정로 1', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/54/2840054_image2_1.jpg', 127.0340500917, 37.7334330545, 6, 31, 25, '02-582-4470', 
NULL, "의정부국제가야금축제는 가야금 음악의 전승 발전과 국제화 및 전통예술 활성화를 통해 문화도시로서 의정부의 위상을 높이고자 마련되었다. 이를 통해 명실상부한 전통예술축제의 대표 브랜드로 발전시켜나감과 동시에 경기북부 문화예술 축제의 모범으로 성장하고자 한다. 이에 따라 의정부국제가야금축제는 가야금 경연을 중심으로 하되, 세미나 및 공연이 결합된 양식으로 기획되었고, 가야금 음악 전통의 역사화 및 창작화, 의정부 문화의 특색화 및 전통의 지역화를 모색하여 일회성 축제에서 벗어나 전통예술 축전의 전형 창출을 기도하고 있다.", 
'의정부예술의전당 국제회의장', NULL, NULL, NULL,NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
1846818 , '수성못 페스티벌(SUSEONG LAKE FESTIVAL)' , 20220923 , 20220925 , '대구광역시 수성구 무학로 112', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/15/2379215_image2_1.JPG', 128.6205949230, 35.8293778245, 6, 4, 7, '053-666-2000', 
'<a href="http://www.ssfestival.net" target="_blank" title="새창:수성페스티벌 홈페이지로 이동">http://www.ssfestival.net</a>', "낮에는 호반과 어우러진 다채로운 거리예술극과 수준높은 버스킹공연 등이 펼쳐지고, 예술가와 함께하는 어린이 창의놀이터가 자리잡는다.<br><br>밤에는 시민참여 주제공연과 수성못 Daily 불꽃쇼가 가을밤을 수놓을 예정이다.<br>수상무대, 수변무대(3개소), 상화동산, 수성랜드 등 수성못 전체를 축제의 무대으로 구성하고 관람객 한 명 한 명의 에너지가 모여 모두가 주인공이 되는 특별한 축제!&nbsp; 특별한 문화예술의 장으로 모두 함께 떠나보자. <br>", 
'수성못 일원, 울루루 문화광장 등', NULL, NULL, NULL,NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
1846797 , '제10회 군산시간여행축제' , 20221007 , 20221010 , '전북 군산시 중앙로1가 11-1', '전북 군산시 중앙로1가 11-1', 'A02070100', 'http://tong.visitkorea.or.kr/cms/resource/95/2843895_image2_1.jpg', 126.7116906420, 35.9878092242, NULL, 37, 2, '063-454-3302', 
'<a href="http://festival.gunsan.go.kr/" target="_blank" title="새창:군산시간여행축제 홈페이지로 이동">http://festival.gunsan.go.kr</a>', "일제 강점기 수탈의 만행속에 군산 공동체의 고통과 항거, 치열한 삶의 역사를 공유하고 새기는 근대 군산으로의 시간여행을 시작으로, 시간을 되돌려 근대 이전 과거로 그리고 근현대를 지나 미래로의 시간여행을 통해 군산의 정체성을 대내외적으로 드러내고 지역 공동체의 새 희망을 만들어가는 대동놀이로 승화해 나가고자 함", 
'군산시간여행마을일원', NULL, NULL, '무료(일부 유료)',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
1844150 , '제9회 낙동강 세계평화 문화 대축전' , 20221028 , 20221030 , '경북 칠곡군 석적읍 중지리 552', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/43/2829343_image2_1.jpg', 128.4011395826, 36.0182857122, 6, 35, 22, '054-979-6100~5', 
'홈페이지 <a href="http://nakdongriver-peacefestival.or.kr/" target="_blank" title="새창:낙동강세계평화 문화대축전 홈페이지로 이동">http://nakdongriver-peacefestival.or.kr/</a><br>인스타그램 <a href="https://www.instagram.com/nakdongriver_peacefestival/" target="_blank" title="새창:낙동강세계평화 문화대축전 홈페이지로 이동">www.instagram.com</a><br>페이스북 <a href="https://www.facebook.com/ndriverfestival" target="_blank" title="새창:낙동강세계평화 문화대축전 홈페이지로 이동">www.facebook.com</a><br>유튜브 <a href="https://www.youtube.com/channel/UCm0SyN0aNWd0gAQLxw900Tw" target="_blank" title="새창:낙동강세계평화 문화대축전 홈페이지로 이동">www.youtube.com</a><br>블로그 <a href="https://blog.naver.com/nnddrr" target="_blank" title="새창:낙동강세계평화 문화대축전 홈페이지로 이동">https://blog.naver.com</a>', "제9회 낙동강 세계평화 문화 대축전은 6.25전쟁의 격전지였던 칠곡군에서 펼쳐지는 지상 최대 규모의 호국평화 축제로서, 10월 28일(금) 개막을 시작으로 10월 30일(일)까지 칠곡보 생태공원 및 왜관 1번도로에서 개최된다. 군 멀티 체험, XR체험, 평화 유원지 등 다양한 체험 프로그램부터 공동 개최되는 제13회 낙동강 지구 전투 전승행사의 430m 부교, 문교탑승체험, 군무기 탑승&전시 체험 등을 통해 나라를 지킨 영웅들에 대한 감사와 평화를 만끽할 수 있는 프로그램으로 구성된다. 특히 올해는 기존 칠곡보 생태공원에서 왜관 1번도로까지 축전공간을 확장하여 호국평화의 도시와 인문학의 도시로 브랜딩 된 칠곡의 다채로운 모습을 만날 수 있다.", 
'칠곡보 생태공원 및 왜관 1번도로 일원', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
1842421 , '제 13회 2022 ACC 월드뮤직페스티벌(AMF)' , 20220826 , 20220827 , '광주광역시 동구 예술길 31-13', NULL, 'A02070200', NULL, 126.9198157026, 35.1497523646, 6, 5, 3, '1899-5566', 
'<a href="https://www.acc.go.kr/main/contents.do?PID=03010701" target="_blank" title="새창: ACC월드뮤직페스티벌 행사 홈페이지로 이동">https://www.acc.go.kr</a>', "\"세계 음악과 함께하는 도심 속 피크닉\" - ACC 월드뮤직 페스티벌<br>August Festival 2022 8월의 끝자락에 즐기는 세계음악축제!<br>Cool Festival 한여름 밤 무더위를 날리는 종합예술축제! <br>Collaboration Festival 세계음악과 한국 뮤지션의 협연을 통한 글로컬축제!<br>‘월드뮤직’은 전 세계에 존재하는 다양한 문화가 담겨 있는 오늘의 음악이다.<br>아시아와 세계를 담는「ACC 월드뮤직 페스티벌」에서는 친구, 연인, 가족과 함께 다양한 음악과 문화를 경험하는 피크닉을 즐길 수 있다.<br>매 년 여름의 끝자락, 8월. ‘빛의 숲’ 에서 열리는 축제의 밤! 「ACC 월드뮤직 페스티벌」로 여러분을 초대한다.", 
'국립아시아문화전당 예술극장, 야외무대, 5·18광장', NULL, NULL, '무료: 야외공연<br>유료: 실내공연(ACC판), 사전예약 및 현장예매',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
981658 , '대전효문화뿌리축제' , 20221007 , 20221009 , '대전광역시 중구 뿌리공원로 47 효문화마을관리원', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/39/2849539_image2_1.jpg', 127.3845115010, 36.2853841653, 6, 3, 5, '042-606-6290', 
'<a href="https://www.djjunggu.go.kr/hyo-ppuri/index.do" target="_blank" title="새창:대전효문화뿌리축제 홈페이지로 이동">www.djjunggu.go.kr</a>', "대전효문화뿌리축제는 천혜 자연환경 속에 위치한 뿌리공원, 한국족보박물관, 효문화마을, 효문화진흥원을 아우르는 효문화 인프라를 기반으로 효의 가치와 의미를 경험하며 자신의 뿌리를 찾아보고 가족의 정을 느낄 수 있는 축제이다. 전국에 어르신과 청소년, 그리고 3대가 모두 함께 어우러질 수 있는 축제의 장이 되어 전국에 효 실천 문화 확산 계기를 마련하고자 한다.", 
'뿌리공원 및 원도심 일원(으능정이거리 등)', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
1840914 , '제8회 화성송산포도축제' , 20220903 , 20220904 , '경기도 화성시 궁평항로 1069-11 궁평리어촌체험안내소', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/06/2846406_image2_1.jpg', 126.6833853938, 37.1162095733, 6, 31, 31, '031-5189-6441/3888', 
'<a href="http://hspodo.com/" target="_blank" title="새창 : 화성송산포도축제">http://hspodo.com</a>', "맛있는 화성송산포도를 즐길수 있는 곳! <br>화성송산포도와 지역특화상품을 즐기는 다채로운 체험프로그램이 있는 화성시 대표축제", 
'경기도 화성시 서신면 궁평항 광장', NULL, NULL, '유/무료(체험별 상이)',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
1829696 , '아시아프' , 20220726 , 20220821 , '서울특별시 마포구 와우산로 94', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/17/2824917_image2_1.jpg', 126.9255540555, 37.5512772937, 6, 1, 13, '02-724-6324', 
'<a href="http://asyaaf.chosun.com" target="_blank" title="새창:아시아프 홈페이지로 이동">http://asyaaf.chosun.com</a>', "국내 최대의 청년 미술축제 '2022 아시아프'가 7월 26일부터 8월 21일까지 홍익대학교 현대미술관에서 개최된다.<br>올해로 15회를 맞이한 아시아프는 참여작가 500명을 선정해 약 1000여점의 작품을 전시하게 된다. 만 20세~35세 청년작가들을 선발하는 '아시아프' 부문과 만 36세 이상 작가들에게 문호를 여는 '히든 아티스트' 부문으로 나뉘어 진행한다.<br>미술시장을 이끌어 갈 청년작가들의 다채로운 작품들을 관람하시는 것은 물론, 마음에 드는 작품을 직접 구매하는 것도 가능하다.<br>오프라인 전시가 종료된 후에는 아시아프 홈페이지에서 참여작가들의 작품을 온라인 구매할 수 있다.", 
'홍익대학교 현대미술관(홍문관)', NULL, NULL, '홈페이지 참고',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
1828270 , '제 22회 목포세계마당페스티벌' , 20220902 , 20220904 , '전라남도 목포시 수문로 60-1 남교공영주차장', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/46/2835846_image2_1.jpg', 126.3805720895, 34.7940640602, 6, 38, 8, '061-243-9786', 
'<a href="http://www.mimaf.net" target="_blank" title="새창:목포세계마당페스티벌 홈페이지로 이동">http://www.mimaf.net</a><br>유튜브 목포마당TV <a href="https://www.youtube.com/c/getdol21" target="_blank" title="새창: 홈페이지로 이동">https://www.youtube.com</a>', "목포세계마당페스티벌은 2001년 시작해 현재까지 22년간 순수민간극단이 이끌어 온 국내 최고의 공연예술축제이다.<br>목포세계마당페스티벌은 지역민이 직접 문화의 주체로 성장할 수 있는 축제로 전통의 '마당'을 현대화 하는 공연예술축제이다. 축제 현장 속에서 문화적 삶이 오고가고 마당이라는 소통 공간을 만들어 나눔을 통해 지역민의 삶의 질을 높이고 상생하는 공동체 축제이다.<br>목포세계마당페스티벌은 전국 공연팀들이 참여하는 국내 초청 공연과 색다른 공연을 보여주는 해외 공연팀, 지역의 다양한 공연단체가 참여하는 예향남도 초청 공연이 있으며 마당극, 탈춤, 마임, 서커스, 인형극, 공중퍼포먼스, 마술 등 다양한 장르의 공연팀이 참여하고 있다.", 
'목포시 수문로 일대', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
1824778 , '제14회 통영연극예술축제' , 20220826 , 20220904 , '경상남도 통영시 남망공원길 29', '경남 통영시 중앙동 68-7', 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/79/2827979_image2_1.jpeg', 128.4240026354, 34.8451571899, 6, 36, 17, '055-645-6379', 
'<a href="http://ttaf.kr"_blank" title="새창: 홈페이지로 이동">http://ttaf.kr</a>', "연극 메시지<br>바다의 땅 통영은 역사, 서사, 인물이 영글어져 있는 이야기의 문화원천지이다. <br>통영문화자원을 활용한 창작희곡과 사회문제와 가치가 담긴 작품을 제작·발표하는 과정을 통해 공동체로서 역할을 대변하고 코로나 19로 3년째 힘든 상황에 몰린 사람들은 사람끼리의 연대가 유일한 힘이며 희망이다. 연극을 통해 역사와 시대를 재조명하고 현재를 바라보는 기회를 관객과 함께 울림이 있는 메시지로 남기고 싶다.", 
'통영시민문화회관, 벅수골소극장, 생활 속의 공간', NULL, NULL, '유료<br>홈페이지 참조(<a href="http://ttaf.kr"_blank" title="새창: 홈페이지로 이동">http://ttaf.kr</a>)',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
1818794 , '부산국제차공예박람회' , 20221124 , 20221127 , '부산광역시 해운대구 APEC로 55', '(우동)', 'A02080600', NULL, 129.1359569660, 35.1690700054, 6, 6, 16, '051-740-7705~7', 
'<a href="http://teafair.co.kr" target="_blank" title="새창:부산국제차공예박람회 홈페이지로 이동">http://teafair.co.kr</a>', "2022 제28회 부산 국제 차·공예 박람회가 2022.11.24~2022.11.27 부산 벡스코에서 개최된다. 차와 공예에 관한 다양한 상품들이 출품 전시된다.<br>차와 공예 문화산업의 활성화와 저변확대를 위한 박람회로 참가업체는 차의 중심지 부산, 경남권에서 홍보마케팅할수 있으며 관람객에게는 차와 공예 정보를 얻을 수 있는 자리이다.", 
'해운대 BEXCO', NULL, NULL, '홈페이지 참조',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
1814499 , '김천나이트투어 \'직지골야행\'' , 20220409 , 20221015 , '경상북도 김천시 직지사길 130 사명대사공원', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/88/2718888_image2_1.JPG', 128.0095382081, 36.1169034720, 6, 35, 6, '054-434-4336', 
'<a href="http://www.nighttour.or.kr/" target="_blank" title="새창:김천직지나이트투어 홈페이지로 이동">http://www.nighttour.or.kr/</a>', "김천의 역사와 문화가 어우러진 사명대사공원을 중심으로 진행되는 야간관광프로그램이다.<br>계절별 수확시기에 맞춰 다양한 김천의 농산물을 수확해보는 체험을 시작으로, 120여개 식당이 밀집되어있는 골목식당에서 김천지역의 이색적인 음식을 맛본다.<br>밤이 되면 야경이 아름다운 사명대사공원에서 김천의 특산물로 만든 간식거리를 맛보며 전통 민속놀이 및 다양한 프로그램을 체험한다.", 
'김청 사명대사공원, 과일농원, 황금시장', NULL, NULL, '1인 15,000원(생후 12개월 이하 무료)',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
1813223 , '제19회 안양사이버과학축제' , 20220917 , 20220918 , '경기도 안양시 동안구 평촌대로 389', '(비산동)', 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/18/2851718_image2_1.jpg', 126.9491782381, 37.4051891236, 6, 31, 17, '031-8045-5135', 
'<a href="https://www.anyang.go.kr/" target="_blank" title="새창:안양사이버과학축제 홈페이지로 이동">https://www.anyang.go.kr/</a>', "안양시는 글로벌 ICT 및 과학 인재 양성과 건전한 정보문화 확산을 위해 2002년부터 안양사이버과학축제를 개최하고 있다. 올해는 지난 2년간 코로나19의 여파로 축제를 개최하지 못한 아쉬움이 있었으나, 멈춰있던 시계를 다시 돌려 「제19회 안양사이버과학축제」로 여러분들을 찾아온다. 오랫동안 축제를 기다려오신 만큼 최신 IT 트렌드를 반영한 양질의 프로그램과 온 가족이 함께 참여하는 다양한 볼거리‧즐길 거리를 마련하였다. 「제19회 안양사이버과학축제」에 온 가족이 함께 오셔서 멋진 추억 만드시고 행복한 시간 보내기를 바란다.", 
'안양실내체육관 일원', NULL, NULL, '무료','전연령가능', '기간내자유');

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
1811380 , '화성 뱃놀이 축제' , 20220916 , 20220918 , '경기도 화성시 서신면 전곡항로 5', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/14/2835314_image2_1.jpg', 126.6510336560, 37.1855870833, 6, 31, 31, '031-290-4618', 
'<a href="http://www.화성뱃놀이축제.com" target="_blank" title="새창 : 화성 뱃놀이축제 홈페이지로 이동">http://www.화성뱃놀이축제.com</a>', "이색적인 요트ㆍ보트 승선체험을 즐길 수 있는 곳!<br>‘문화를 담은 바닷길, 섬을 여는 하늘길’을 즐기는 승선 프로그램과 해양 문화를 느낄 수 있는 다채로운 체험 프로그램이 있는 화성시 대표축제", 
'화성시 서신면 전곡항', NULL, NULL, '유/무료 (체험별 상이)',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
1809861 , '2022 춘천연극제' , 20220615 , 20221029 , '강원도 춘천시 서부대성로 71', '(옥천동)', 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/05/2824905_image2_1.jpg', 127.7312071874, 37.8825368301, 6, 32, 13, '033-241-4345', 
'<a href="http://citf.or.kr/" target="_blank" title="새창:춘천국제연극제 홈페이지로 이동">http://citf.or.kr/</a>', "1, 대한민국 유일무이 코미디 연극 축제<br>2. 초청작 4편<br>3. 가족극 4편<br>4. 거리연극 8회<br>5. 살롱공연 등", 
'봄내극장, 석사천 특설무대 등', NULL, NULL, '20,000<br>할인 : 춘천연극제 채널 친구로 예매 시, 만 65세 이상, 장애인 50%할인<br>단, 항목별 중복 불가',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
1805914 , '무예24기 시범공연' , 20211222 , 20221231 , '경기도 수원시 팔달구 정조로 825', '(남창동)', 'A02081300', 'http://tong.visitkorea.or.kr/cms/resource/62/1998262_image2_1.jpg', 127.0134508573, 37.2816684780, 6, 31, 13, '수원시립공연단(031-267-1644)', 
'<a href="https://www.swcf.or.kr/?p=73&viewMode=view&idx=67" target="_blank" title="새창:수원문화재단 홈페이지로 이동">http://www.swcf.or.kr</a>', "무예24기란, 정조의 명을 받은 실학자 이덕무, 박제가와 무예의 달인 백동수가 1790년에 편찬한 「무예도보통지」의 24가지 무예를 말한다. 「무예도보통지」는 조선 전래의 무예는 물론, 중국과 일본의 우수한 무예를 적극 수용하여 '24기(技)'로 정리한 무예교범서로서 부국강병의 실학정신이 담겨 있다. 무예24기는 화성에 주둔했던 당대 조선의 최정예부대 장용영 외영 군사들이 익혔던 무예로서 역사적 가치는 물론 예술적, 체육적 가치가 아주 높은 무형의 문화유산이다. 이곳 화성행궁의 북군영과 남군영에 주둔한 군사들 또한 무예24기를 수련하여 행궁호위에 최선을 다했다. 화성 행궁의 복원과 때를 같이하여 우리 민족의 건강한 몸짓과 활달한 기상이 담긴 무예 24기 시연을 펼친다.", 
'화성행궁 낙남헌', NULL, NULL, '무료','전연령 가능', '30분');

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
1805176 , '2022 서울안전한마당' , 20220922 , 20220924 , '서울특별시 영등포구 여의공원로 68 여의도공원관리사무소', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/03/2807503_image2_1.jpg', 126.9222939310, 37.5268578503, 6, 1, 20, '02-3706-1561', 
NULL, "서울시 주요재난 대비 안전체험 프로그램으로 시민안전 강화와 시민들이 자발적으로 참여하고 즐길 수 있는 안전문화 행사로써 2022년 9월 22일부터 3일간 열리는 행사이다.", 
'여의도공원 문화의 마당', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
553263 , '울산 고래축제' , 20221013 , 20221016 , '울산광역시 남구 장생포고래로288번길 20', '(매암동)', 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/59/2593159_image2_1.jpg', 129.3866285730, 35.5049453522, 6, 7, 2, '052-226-1999', 
'<a href="http://www.ulsanwhale.com" target="_blank" title="새창:울산고래축제 홈페이지로 이동">http://www.ulsanwhale.com</a>', "울산은 수천 년 전 선사인들이 바위에 고래를 새겨 놓은 국보 제285호 반구대 암각화와 근대 포경산업의 중심지였던 장생포의 역사가 어우러진 우리나라 대표 고래도시입니다. 이러한 고래문화를 계승하고 보존하기 위해 고래의 본고장인 장생포에서 '울산고래축제'가 시작되었고 올해 26회째를 맞이한다.<br>3년 만에 다시 돌아오는 2022년 울산고래축제는 국내 고래테마공원 1호인 장생포고래문화마을과 고래문화특구인 장생포 일원에서 고래를 테마로 하는 퍼레이드, 퍼포먼스, 홀로그램 등 다양한 즐길거리를 선사한다.<br>또, 고래를 직접 찾아 나서는 고래바다여행선, 고래의 역사를 고스란히 담은 고래박물관, 돌고래를 볼 수 있는 고래생태체험관 등 전국 유일무이한 고래인프라가 여러분을 맞이한다.<br>주민이 주체로서 참여하는 축제, 아이들에게는 울산 고래의 푸른 꿈을, 어른들에게는 낭만과 향수를 선사하는 2022년 울산고래축제에 여러분을 초대한다!", 
'장생포 고래문화특구 일원', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
1754946 , '허브아일랜드 불빛동화축제' , 20220101 , 20221231 , '경기도 포천시 신북면 청신로947번길 35', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/32/2827732_image2_1.jpg', 127.1316789055, 37.9659160606, 6, 31, 29, '031-535-6494', 
'<a href="http://www.herbisland.co.kr/33/?q=YToxOntzOjEyOiJrZXl3b3JkX3R5cGUiO3M6MzoiYWxsIjt9&bmode=view&idx=8836235&t=board" target="_blank" title="새창:허브아일랜드 홈페이지로 이동">http://www.herbisland.co.kr</a>', "잃어버린 동심을 만날 수 있는 시간!<br><br>매일 밤, 작은 불빛들이 만들어내는 동화 같은 세상은 누구에게나 잊지 못할 추억을 선사하며, 누구나 불빛세상의 주인공으로 만들어줄 아름다운 불빛야경이 준비되어 있다. 허브아일랜드 불빛동화축제는 우리를 동화 속 세상으로 초대한다. 결코 꺼지지 않는 불빛들의 네버엔딩스토리를 만나보자!", 
'포천시 허브아일랜드', NULL, '산타마을 라이팅쇼, 프랑스 상통인형전(상시), 힐링센터 이벤트 체험(족욕, 체어마사지, 발마사지)', '일반 : 9,000원  어린이(37개월~중학생):7,000원   우대(장애인, 노인, 국가유공자, 단체(20인)): 7,000원','전연령 가능', '3시간');

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
1748721 , '포항스틸아트페스티벌' , 20221015 , 20221029 , '경상북도 포항시 남구 오천읍 구정리', '247-1', 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/05/2753405_image2_1.png', 129.4108299082, 35.9681436278, 6, 35, 23, '054-289-7853~4', 
'<a href="https://www.instagram.com/pohang_festa_official/" target="_blank" title="새창:포항스틸아트페스티벌 홈페이지로 이동">www.instagram.com</a>', "2022 포항스틸아트페스티벌이 11회를 맞이하여 \"동행 - 공존하는 다양성\"이라는 주제로 포항 오천 냉천 포은교 인근에서 개최된다. 이번 축제는 다양한 주체들이 동행하며 함께 만들어 왔다는 점에 주목하여 21여 점의 작가 작품, 포항기업 근로자, 포항 시민이 참여한 작품이 함께 15일간 야외에 전시될 예정이다. 배리어프리 투어, 나이트 투어 등의 콘텐츠를 통해 장애인과 비장애인, 남녀노소 누구나 다양한 방식으로 예술을 향유할 수 있는 경험을 제공하고자 하며, 작품은 스틸아트투어 앱을 통해서 언제 어디서나 만나볼 수 있다. 스틸아트페스티벌은 현장을 방문하는 관광객들이 다양한 콘텐츠를 통해 이색적이고 능동적으로 작품을 감상함으로써 예술에 가까워지는 것을 넘어 하나가 되는 경험을 제공한다.", 
'포항시 남구 오천 냉천 포은교 광장 일원', NULL, NULL, '무료 (체험 프로그램은 유료)',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
1726052 , '남해 독일마을 맥주축제' , 20220930 , 20221002 , '경상남도 남해군 독일로 89-7', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/37/2841137_image2_1.jpg', 128.0383624398, 34.8000859569, 6, 36, 5, '055-864-4515', 
'<a href="https://www.instagram.com/travelnamhae/" target="_blank" title="새창 : 남해 독일마을 맥주축제">https://www.instagram.com/travelnamhae/</a>', "개최 10주년을 맞이하는 2022 남해 독일마을 맥주축제가 3년 만에 돌아온다! 초록 바다를 배경으로 펼쳐진 주황색 지붕의 이색적인 독일식 주택, 유럽풍의 전통 의상과 먹음직스러운 소시지, 깊고 진한 맛의 독일 전통 맥주를 한 번에 즐길 수 있는 축제의 현장으로 초대한다!<br>3년 만에 개최되는 남해 독일마을 맥주축제는 화려한 꽃 장식과 오크통 마차, 흥겨운 음악과 활기찬 행진, 주민과 관광객이 하나 되는 개막식 퍼포먼스를 시작으로 옥토버 나이트, 유럽 문화 공연, 독일 전통 의상 대여, 비어핑퐁 게임 등 다양한 체험 프로그램까지 알차게 눌러 담았다. <br>이국적인 풍경과 다채로운 프로그램, 다양한 먹거리가 가득한 남해 독일마을 맥주축제에서 장기화된 코로나19로 지친 몸과 마음을 달래고 낭만과 흥겨움이 가득한 추억을 안고 돌아가기를 바란다. 남해 독일마을 맥주축제 개최를 기념하며 모두 맥주잔을 들고 외쳐보자, “프로스트(Prost, 건배)!”", 
'남해 독일마을 일원', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
1725993 , '고양가을꽃축제' , 20221001 , 20221010 , '경기도 고양시 일산동구 호수로 595', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/39/2848839_image2_1.jpg', 126.7686654803, 37.6538792239, 6, 31, 2, '031-908-7750~2', 
'<a href="http://www.flower.or.kr" target="_blank" title="새창 : 고양 가을꽃축제 홈페이지로 이동">http://www.flower.or.kr</a>', "\"일산호수공원에서 가을여행 할까요?\"<br>깊어 가는 가을, 꽃의 아름다움과 자연, 문화, 예술의 풍요로움을 만끽할 수 있는 고양가을꽃축제는 우리에게 익숙했던 호수공원의 아름다움을 새롭게 발견하고, 또 다른 ‘나’를 만나게 되는 가을꽃여정을 담았다.", 
'일산호수공원', NULL, NULL, '무료','전연령 가능함', '기간내 자유');

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
1718060 , '2022 진안홍삼축제' , 20221007 , 20221010 , '전라북도 진안군 마이산로 160', NULL, 'A02070100', 'http://tong.visitkorea.or.kr/cms/resource/91/2827091_image2_1.jpg', 127.4162612489, 35.7730819880, 6, 37, 14, '063-430-2391~3', 
'홈페이지:<a href="https://www.jinan.go.kr/festival/" target="_blank" title="새창:진안홍삼축제 홈페이지로 이동">www.jinan.go.kr</a><br>유튜브: 빠망TV(<a href="https://www.youtube.com/jinangun" target="_blank" title="새창 : 관광지">www.youtube.com</a>)', "건강과 힐링, 즐거움이 함께하는 진안홍삼축제<br>대한민국 유일의 홍삼특구인 진안 마이산 북부 일원에서는 매년 10월 홍삼축제가 열린다. 믿고 먹을 수 있는 질 좋은 홍삼과 홍삼으로 만든 다양한 음식들을 맛볼 수 있는 축제로 인기가 많다. 홍삼이 낯선 아이들을 위해 홍삼제품 만들기, 홍삼랜드 스탬프투어 등 재미있는 체험프로그램들이 준비되어 있다. 이밖에도 궁중무예와 전통공연, 트로트 페스티벌 등 볼거리도 풍성하며 진안군수가 품질을 인증한 믿을 수 있는 고품질의 홍삼제품을 시중가보다 저렴하게 구매할 수 있다.", 
'마이산 북부 / 진안고원시장', NULL, NULL, '이용료 없음 (체험 프로그램별 발생 가능)',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
1700426 , '파주 북소리' , 20221021 , 20221023 , '경기도 파주시 회동길 145', '(문발동)', 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/45/2844345_image2_1.JPG', 126.6873602144, 37.7102962060, 6, 31, 27, '031-955-0055', 
'<a href="http://www.pajubooksori.kr" target="_blank" title="새창:파주 북소리 공식홈페이지로 이동">http://www.pajubooksori.kr</a>', "대한민국 출판문화를 선도하는 파주출판도시는 사람과 책, 문화가 한데 어우러진 곳이다. 전 세계적으로 유례를 찾아보기 힘든 출판문화 클러스터이자, 수천 명의 출판인이 매일 새로운 지식을 창조하는 대한민국 출판의 중심지이기도 하다. 2011년부터 파주출판도시는 책을 생산하는 공간에서 책 문화를 향유하는 공간으로 변화하고자 ‘책방거리’ 조성을 시작했다. 그 결과 1년 사이에 42개의 서점이 문을 열었다. 한편 출판도시는 책의 가치를 높이는 국제적인 연대활동에 참여하기 위해 2012년 6월에 전 세계 13개국 16개의 책마을이 가입해 있는 세계책마을협회 (International Organization of Booktowns: IOB)의 회원이 되었다.<br><파주북소리> 는 이처럼 국제적인 출판의 메카로 발전하고 있는 파주출판도시에서 열리는 아시아 최대 규모의 북 페스티벌이다. 2011년 가을에 첫 발걸음을 내디딘 파주북소리는 출판도시 내 100여 곳의 출판사와 국내 유수의 출판, 독서, 교육, 문화 기관이 힘을 합쳐 격조 있는 지식축제로 프로그램을 꾸미고 있다. 아시아 및 유럽 지역의 출판계 인사들이 참여하는 국제적인 행사로 진행된다.", 
'아시아출판문화정보센터 등 출판도시 곳곳', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
1697329 , '2022 대전국제와인페스티벌' , 20220826 , 20220828 , '대전광역시 유성구 엑스포로 107 대전컨벤션센터', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/47/2827947_image2_1.jpg', 127.3916945410, 36.3750212633, 6, 3, 4, '042)250-1358~9', 
'<a href="https://www.djwinefair.com/" target="_blank" title="새창:대전국제와인페스티벌 홈페이지로 이동">http://www.djwinefair.com</a>', "대전국제와인페스티벌은 와인과 문화가 함께하는 대한민국 대표 와인 축제이다.<br>국제와인기구(OIV)의 승인을 받은 세계 3대 와인 품평회 중 하나인 '아시아와인트로피'와 연계하여 이탈리아, 프랑스, 독일 등 30여 개국에서 생산한 다양한 와인을 한자리에서 만나볼 수 있는 국내 최대의 와인 전문 박람회로, 와인 산업 종사자에게는 비즈니스 교류의 장을, 일반 참관객에게는 각국의 문화와 와인을 접할 수 있는 기회를 제공한다.<br>와인 전문가는 물론 와인 애호가도 참가하여 와인에 대한 폭넓은 지식을 마련할 수 있는 '아시아와인컨퍼런스', '한국 국가대표 소믈리에 대회' 등의 연계행사와 각종 문화 공연과 같은 다채로운 부대행사도 마련된다.<br>아시아 최대 규모의 와인 시음존에서 취향에 딱 맞는 나만의 와인을 찾아보자!", 
'대전컨벤션센터(DCC) 제1·2전시장, 물빛광장 등', NULL, NULL, '10,000원 (와인잔 별매)','만19세 이상', NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
1692948 , '제45회 심훈상록문화제' , 20221028 , 20221030 , '충청남도 당진시 시청1로 1 당진시청', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/28/2831028_image2_1.jpg', 126.6459838241, 36.8897906458, 6, 34, 4, '041-352-4802', 
'<a href="http://www.djsangnok.org/" target="_blank" title="새창:심훈상록문화제 홈페이지로 이동">http://www.djsangnok.org</a>', "제45회 심훈상록문화제에 여러분을 초대한다.<br> 심훈상록문화제는 소설 상록수와 시 그날이 오면을 지필한 심훈 작가의 정신을 계승하고자 1977년 제1회 행사를 시작으로 매년 9월~10월 당진시 일원에서 상록문화제가 열리고 있다.", 
'당진시청 일원', NULL, NULL, '무료','전연령가능', '기간내자유');

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
1684988 , '2022 제9회 라틴아메리카축제' , 20220917 , 20220917 , '서울특별시 성북구 삼선동 1가 14', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/98/2843898_image2_1.jpg', 127.0073566840, 37.5875523218, 6, 1, 17, '02-2241-6381,3,4', 
'<a href="https://global.seoul.go.kr/web/cent/gvct/gsbu/centInfoPage.do?cent_cd=05" target="_blank" title="새창:라틴아메리카축제 행사 안내페이지로 이동">http://www.seongbuk.go.kr</a>', "라틴아메리카의 문화와 정서, 긍정적인 삶의  열정을 전파하고 글로벌공동체 가치 공유를 통해 내·외국인이 함께 즐길 수 있는 소통과 공감의 한마당 「제9회 라틴아메리카축제」를 개최한다.", 
'지하철 4호선 한성대입구역 2번출구 성북천분수마루', NULL, NULL, '부스별 음식 및 상품 가격 상의',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
1676021 , '태안 국제모래조각 페스티벌' , 20220903 , 20220904 , '충청남도 태안군 원북면 신두해변길 201-54', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/94/2392294_image2_1.JPG', 126.1945065651, 36.8425855403, 6, 34, 14, NULL, 
'<a href="https://www.taean.go.kr/prog/tursmCn/tour/sub04_01_04/view.do?cntno=66" target="_blank" title="새창 : 태안 국제모래조각 페스티벌">www.taean.go.kr</a>', "태안군이 자랑하는 국내 최대 해안사구에서 신나는 모래조각 페스티벌과 걷기여행 프로그램이 함께 펼쳐진다.<br>9월 3일부터 4일까지 이틀간 원북면 신두리 해수욕장 일원에서 제18회 태안 국제 모래조각 페스티벌이 4일에는 신두리 해수욕장 주차장에서 '태안 서해랑길 걷기 여행' 프로그램이 각각 개최된다.<br>모래조각 페스티벌은 태안군이 주최하며 '꽃과 바다 태안에서 즐기는 모래조각체험'을 주제로 진행된다.<br><br>3일에는 '예술과 함께하는 모래조각 체험교실'이 열려 다양한 모래조각 체험을 즐길 수 있으며 우리나라·일본·대만 3개국 전문작가가 참여한 가운데 국내 최초로 열리는 모래조각 국제 경연 및 작품 전시를 비롯해 예술공연 등이 함께 진행된다.<br>4일에는 개막식에 이어 아마추어 모래조각 경연대회와 맨손 물고기 잡기 체험이 펼쳐지며 샌드아트와 페이스페이팅 등 다양한 체험부스가 운영돼 가족단위 관광객들의 관심을 끌 것으로 기대된다.", 
'충청남도 태안군 원북면 신두리 해수욕장 일원', NULL, NULL, NULL,'전연령 가능함', '기간내자유');

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
1620726 , '지용제' , 20220922 , 20220925 , '충청북도 옥천군 향수길 56', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/73/2830673_image2_1.jpg', 127.5814542173, 36.3150037301, 6, 33, 5, '043-730-3402', 
'<a href="http://gy-festival.okcc.or.kr/html/kr/" target="_blank" title="새창: 지용제 홈페이지로 이동">http://gy-festival.okcc.or.kr/html/kr/</a>', "지용제는 한국 현대시의 선구자이며 우리의 언어를 시적 형상화한 시인이자 우리민족의 정서를 가장 잘 표현한 시인 정지용을 추모하고, 그의 시문학 정신을 이어가며 더욱 발전시키자는 뜻으로 '시인 정지용의 고향 옥천의 문화축제'이다<br /><br />향수'를 통해 우리민족의 이상적 공간을 그렸던 정지용. 우리역사의 질곡은 그에게 또 다른 '고향'을 노래하게 한다. <br>일제 강점기는 그에게 '친일시인이라는 누명'을 씌우기도 했으며 해방 후 좌우익 대립의 혼돈은 그를 방황케 했다. '동족상잔의 비극 6.25'는 아예 그를 '월북시인'으로 낙인찍어 그와 그의 문학을 묻어버렸다. <br>1988년 제24회 하계 올림픽이 서울에서 열리던 해, 그해는 세계인이 한국을 주목하던 시절이었으며, 시인 정지용이 다시 우리에게 돌아왔던 해였다.<br><br>'판금'의 서슬 앞에 그를 기억하는 모두가 30여년을 숨죽이며 기다렸던 그날 1988년 4월 1일, 시인 정지용을 흠모해 마지않았던 이 나라의 시인과 문학인, 그의 제자들이 모여 '지용회'를 발족하기에 이르고 그의 고향 옥천에서는 그해 5월부터 '제1회지용제'를 시작으로 정지용의 삶의 향기를 더욱 가까이 느끼며 그의 문학을 접하고 이야기 할 수 있는 옥천의 문학축제인 지용제가 열린다.<br>", 
'정지용 생가', NULL, NULL, NULL,NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
1569301 , '진도토요민속여행 상설공연' , 20220301 , 20221231 , '전라남도 진도군 진도읍 진도대로 7197', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/26/2726726_image2_1.JPG', 126.2698698980, 34.4795198452, 6, 38, 21, '061-540-3073', 
'<a href="https://www.jindo.go.kr/tour/tour/info/concert.cs?act=view&infoId=188&searchCondition=&searchKeyword=&pageIndex=1&m=24" target="_blank" title="새창:진도토요민속여행 홈페이지로 이동">http://www.jindo.go.kr/tour</a>', "대한민국 최초 민속문화예술특구로 지정된 보배섬 진도에서 펼쳐지는 진도토요민속여행 상설공연은 매주 토요일 오후 2시부터 진도향토문화회관 대공연장에서 진도군의 전통민속 문화예술 자원을 활용한 공연의 관광상품화로 관광객 500만명 유치 및 진도군의 우수한 무형문화유산을 무대극화 하여 관광진도를 찾는 국내외 관광객들에게 문화예술 체험의 기회와 즐길거리, 볼거리를 제공하기 위함이다. 진도 토요민속여행 상설공연은 독특한 진도의 전통 민속, 민요를 대외적으로 알리는 최고의 관광상품으로서의 가치를 인정받아 2018년 12월 한국관광의 별로 선정되었다.", 
'향토문화회관 대공연장', NULL, NULL, '무료입장','5세 이상', '약 80분');

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
1402009 , '원주 다이내믹댄싱카니발' , 20221001 , 20221003 , '강원도 원주시 단구로 170', '(명륜동)', 'A02070100', 'http://tong.visitkorea.or.kr/cms/resource/38/2835638_image2_1.jpg', 127.9464176429, 37.3363874827, 6, 32, 9, '033-760-9881~4', 
'<a href="http://www.ddcwj.com" target="_blank" title="새창:원주다이내믹페스티벌 홈페이지로 이동">http://www.ddcwj.com</a>', "시민주도형 축제인 원주 다이내믹댄싱카니발은 시민이 직접 기획부터 무대에 오르기까지 단계별 참여할 수 있는 구조를 마련한 축제이다.<br>길이 100m 폭 15m의 대형런웨이 무대에서 펼쳐지는 역동적인 퍼레이드형 퍼포먼스를 감상하실 수 있으며 무대에 오르는 참여자와 관객 모두 벅차오르는 감동과 뜨거운 열정을 느낄 수 있다.", 
'원주 댄싱공연장 및 원주시 일대', NULL, NULL, NULL,NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
1399407 , '2022청도반시축제' , 20221014 , 20221016 , '경상북도 청도군 청려로 1846', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/43/2852343_image2_1.jpg', 128.7202383285, 35.6512053494, 6, 35, 20, '054-370-6376', 
'<a href="http://www.청도반시축제.kr" target="_blank" title="새창:청도반시축제 홈페이지로 이동">http://www.청도반시축제.kr</a>', "청도야외공연장", 
'청도야외공연장', NULL, NULL, '무료','전연령', '11:00 ~ 21:00');

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
1394326 , '뮤직드라마 당신만이' , 20211029 , 20221231 , '서울특별시 종로구 이화장길 26', '(이화동)', 'A02080300', 'http://tong.visitkorea.or.kr/cms/resource/72/2489672_image2_1.jpg', 127.0039128630, 37.5766424167, 6, 1, 23, '070-8245-2602', 
'<a href="https://booking.naver.com/booking/12/bizes/22830" target="_blank" title="새창 : 뮤직드라마 당신만이">https://booking.naver.com</a>', "옴니버스 형식으로 펼쳐지는 결혼 5년차 부터 37년차까지 부부 이야기, '부부여, 무엇으로 사는가?' 뮤직드라마 &lt;당신만이&gt;는 경상도 부부의 결혼 5년차부터 결혼 37년차까지의 부부의 이야기를 담은 내용이다. 긴 세월을 ‘연인’에서 ‘웬수’ 그리고 ‘동반자’로 살아온 그들만의 이야기를 꺼내어, 보통 부부들의 사는 이야기를 풀어보고자 한다. 또한, 부부이야기에서 빠질 수 없는 것이 자식 문제. 어느새 훌쩍 자라, 이제는 내 맘처럼 되지 않는 자식들이지만, 여전히 놓을 수 없는 부모와 자식의 이야기를 덧대어, 이 부부의 삶을 좀 더 자세히 보고자 한다.<br>
보통사람들이 살아가는 이야기에, 추억과 향수로 남은 명곡을 더해, 좀 더 찐한 사람 냄새나는 이야기를 그려보고자 한다. 빛 바랜 추억 속 가요를 통해 지난날을 추억하고, 공연 속 부부의 삶과 어우러진 가요를 들으며 새로운 추억을 만들어, 10대부터 80대까지 전 세대가 공감할 수 있는 추억꺼리를 만들어 보고자 한다. 부부의 일상부터죽음까지의 모습을 보여줌으로, 이 땅에서 힘들게 혹은 알콩달콩하게 살고 있는 모든 부부들에게 위성신 연출이 들려주고자 하는 감동스럽고, 끈끈한, 진실된 부부의 이야기’를 담아냈다.<br>", 
'JTN아트홀 3관', '인터파크 1544-1555', NULL, '홈페이지 확인','만 7세이상', '120분');

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
1390147 , '2022 우선멈‘춤’ 안양시민축제' , 20220923 , 20220925 , '경기도 안양시 동안구 관평로 149 중앙공원관리부속', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/36/2844336_image2_1.jpg', 126.9613442188, 37.3901883031, 6, 31, 17, '031-687-0500', 
'<a href="https://www.aydf.kr/default/" target="_blank" title="새창 : 관광지">http://www.aydf.kr</a>', "<2022 우선멈'춤' 안양시민축제> 코로나19를 극복하고 다시 나아가기 위한 프로젝트로  대규모 시민의 군집 이미지를 나타내는 '축제'를 대신하여, 치유와 극복 그리고 희망의 메시지를 담은 사회적 거리두기와 춤의 기원을 담은 \"춤의 도시 안양\"만의 댄스 페스티벌이다.<br>2000년 첫 문을 연 안양시민축제는 20년간 시민들과 함께 하며 매년 30만여명의 관람객이 찾는 안양시 대표 축제로 자리매김 했으며, 시민이 만들고, 참여하고, 관람하는 대표적인 시민 참여형 축제로 시민과 사람, 그리고 시민의 생활예술(Living Arts)콘텐츠를 주제로 지역 예술인 공동체 형성과 시민 문화커뮤니티 육성에 기여하고 있다.<br>특히 ‘안양을 춤추게 하라!’는 슬로건은 안양시민이 안양시민축제의 더 큰 비전을 위해 안양에 잠재되어 있는 Dance에 대한 열정을 발굴해 시민예술가 분들의 에너지와 역동성을 마음껏 펼치도록 독려하고, 더 나아가 안양이 국내외 모두가 다 함께 즐길 수 있는 K-Dance의 성지로 자리매김할 수 있도록 다채롭고 역동적인 공연과 시민 참여 프로그램을 선보이고 있다.<br>이를 통해 안양시민축제는 안양 시민과 안양을 찾는 관람객들이 안양이라는 공간 안에서 ‘춤’과 ‘문화예술’을 매개로 화합할 수 있는 국내 유일의 지역 기반 K-Dance문화예술축제로 거듭나고자 한다.", 
'평촌중앙공원, 삼덕공원, 온라인', NULL, NULL, '무료','전연령 가능함', '기간내 자유');

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
1373544 , '고성군민의날 및 수성문화제' , 20220922 , 20220924 , '강원도 고성군 간성읍 수성로 87', '(간성읍)', 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/29/2739329_image2_1.jpg', 128.4652585958, 38.3761682935, 6, 32, 2, '033-680-3368', 
NULL, "고성은 조선초기까지 수성군으로 불렸다. 고성군의 향토문화의 전통은 수성군 시대부터 그 맥을 이어온 것으로 수성문화제는 고성군 고유의 전통민속문화를 발굴 계승함으로써 향토문화예술의 창달을 통한 구체적 정신문화의 지주가 되는 고성군 문화 예술 행사이다. 문예행사, 민속행사, 체육행사 등 다양한 프로그램을 마련해 한마당 잔치로 펼쳐져 군민화합과 번영을 다짐한다.", 
'강원 고성군 종합운동장 일원', NULL, NULL, '무료','전연령 가능함', '기간내자유');

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
1365676 , '송도맥주축제' , 20220826 , 20220903 , '인천광역시 연수구 센트럴로 350 달빛축제공원', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/77/2607177_image2_1.jpg', 126.6305766927, 37.4052529114, 6, 2, 8, '032-830-1000', 
'홈페이지 <a href="http://www.songdobeer.com" target="_blank" title="새창:송도세계문화축제 홈페이지로 이동">http://www.songdobeer.com</a><br>인스타그램 <a href="https://www.instagram.com/songdo_beer_festival/" target="_blank" title="새창:송도세계문화축제 홈페이지로 이동">www.instagram.com</a>', "80만명이 찾은 압도적 퍼포먼스 송도맥주축제가 다시 돌아왔다!<br>국내외 유명 맥주, 차별화된 레시피! 매일 밤마다 펼쳐지는 불꽃축제.<br>그리고 수많은 유명 아티스트들이 펼치는 9일간의 환호와 열정의 무대.<br>2022년 더 다채롭게 돌아온 송도맥주축제에서 일상을 벗어난 새로운 경험을 느껴보자.", 
'송도달빛축제공원', NULL, NULL, '무료 입장',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
1364529 , '2022 서울카페쇼' , 20221123 , 20221126 , '서울특별시 강남구 영동대로 513', NULL, 'A02080700', 'http://tong.visitkorea.or.kr/cms/resource/49/2801549_image2_1.jpg', 127.0591874466, 37.5117592813, 6, 1, 1, '02-6000-6709', 
'<a href="http://www.cafeshow.com" target="_blank" title="새창:서울카페쇼 홈페이지로 이동">http://www.cafeshow.com</a>', "서울카페쇼는 글로벌 커피 산업과 식음료 문화 활성화를 위해 매년 11월에 개최되는 세계 최대 규모의 비즈니스 플랫폼이다. 커피 업계의 태동기부터 대한민국 커피 산업과 함께 성장해온 서울카페쇼는 산업과 지식, 문화가 융복합 된 창의적인 MICE 모델을 선보이며 서울카페쇼만의 특별한 가치와 경험을 선사 해오고 있다. 전 세계 업계 관계자들이 추천하는 B2B 전시회 서울카페쇼는 글로벌 커피 및 F&B 시장의 트렌드를 한눈에 보고, 새로운 솔루션을 제시하는 전문 전시회로 업계를 대표하는 Global Top 전시로 선정되며 그 경쟁력을 인정받았다. <br>산업통상자원부 선정 Global Top 전시회<br>서울시 글로벌 융복합 대표 MICE 전시회<br>아시아 전시컨벤션협회 AFECA Award 최우수상<br>세계 최초 UN 산하 국제커피기구 ICO 공식 후원", 
'코엑스 전관', NULL, NULL, '1일권 : 20,000원<br>다일권 : 40,000원<br>*기간별 얼리버드 할인 티켓 有, 다일권의 경우 행사 기간 4일 입장 가능','8세 이상 입장 가능<br>*비즈니스데이의 경우, 미성년자 출입 제한<br>*행사 전일 유모차 진입 금지', NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
1363965 , '치악산 복숭아축제' , 20220820 , 20220821 , '강원도 원주시 단구로 170', NULL, 'A02070200', NULL, 127.9464176429, 37.3363874827, 6, 32, 9, '(033)737-4131', 
NULL, "1900년대부터 재배하기 시작하여 현재 368호 농가가 278ha를 재배하고 있으며 복숭아로는 전국 최초로 2010년도에 원주치악산 복숭아 지리적 표시제등록(제63호)을 하였다.<br>치악산 복숭아는 수려한 자연경관을 자랑하는 치악산자락의 물빠짐이 좋은 경사지에서 많이 재배하며 성숙기인 6~8월에 일교차가 크고, 일조량이 많아 전국 최고의 품질을 자랑하는 원주의 대표적인 농특산물이다.", 
'젊음의 광장', NULL, NULL, '무료 (복숭아구입 유료)','전연령 가능함', '기간내자유');

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
1363317 , '제26회 제천박달가요제' , 20220917 , 20220917 , '제천시 고암동 643번지', '제천시 고암동 643번지', 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/62/2846962_image2_1.jpg', 128.2242893718, 37.1624821694, 6, 33, 7, '043-641-4870', 
NULL, "전통있는 트로트 가요제로서 확고한 명성을 확립하고 품격 높은 전국 단위 가요 경연을 통한 지역사회 문화역량 향상시키는 가요제이다. 20년도는 코로나19 대응 방안으로 역대 박달가요제 사상 처음으로 무관중 온라인 가요제로 진행되었다. 21년도는 코로나19에 대응하기 위하여 드라이브 인 콘서트 형식으로 진행되었고 올해 제26회 제천박달가요제는 3년만에 대면 방식으로 추진한다.", 
'제천 모산 비행장', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
1362833 , '2022 계룡세계軍문화엑스포' , 20221007 , 20221023 , '충청남도 계룡시 신도안면 정장리 16', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/07/2549807_image2_1.jpg', 127.2371213251, 36.3068152207, 6, 34, 16, '042-840-3907', 
'<a href="https://expo22.kr/" target="_blank" title="새창 : 계룡세계군문화엑스포 홈페이지로 이동">https://expo21.kr/</a>', "대한민국 국방 도시 계룡시에서 2022계룡세계軍문화엑스포가 개최된다. 충청남도 계룡시는 천혜의 자연경관을 바탕으로 국방의 핵심인 육군본부, 해군본부, 공군본부 뿐만 아니라 군 주요기관 및 시설이 위치해 전국 최대의 국방 분야 특성화 지역이다. 지리적·문화적 여건을 기반으로 2007년부터 시작된 대표적인 군 행사인 계룡軍문화축제가 대표적인 축제로 정착하여 계룡시를 중심으로 군 문화의 우수성과 대중적 가치를 공유하여 軍문화의 정체성을 확립해왔다. 2022계룡세계軍문화엑스포는 세계 최초로 軍문화를 소재로 개최하는 엑스포로서, 평화를 수호하는 우리나라와 세계 각국의 軍문화, 첨단과학과 기술을 접목한 미래세대의 군문화, 세계각국 군악대의 퍼포먼스 등 다양한 체험과 볼거리를 남녀노소 누구나 즐길 수 있는 엑스포로 준비하고 있다.", 
'충남 계룡시(계룡대 활주로 일원)', NULL, NULL, '일반인 9,000원(상품권 2,000원), 중고생 3,000원, 초등학생 2,000원, 우대권 8,000원(상품권 2,000원)<br>* 일반인 관람료의 최대 25%를 상품권으로 드리며, 엑스포행사장 및 계룡시內 계룡사랑상품권 가맹점에서 사용가능합니다.<br>* 우대권 적용대상 : 만 65세 ~ 74세, 국민기초생활 수급대상자, 장애의 정도가 심하지 않은 장애인(구 4급 이하)','전연령가능', '4시간');

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
1358036 , '제26회 고창해풍고추축제' , 20220827 , 20220828 , '전라북도 고창군 청해1길 15 해리면 복지회관', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/32/2841132_image2_1.jpg', 126.5378140086, 35.4609551477, 6, 37, 1, '063-563-6014', 
'<a href="http://www.gochang.go.kr/tour/index.gochang?menuCd=DOM_000000403006001000" target="_blank" title="새창:고창해풍고추축제 홈페이지로 이동">http://www.gochang.go.kr/tour</a>', "고창의 대표 특산물 축제중 하나로 황토질의 좋은 땅에서 태양으로 키워내 고창의 바닷바람에 말린 우수한 품질의 고추를 좋은가격에 구매할 수 있는 기회이다.  콘서트와 가요제등 여러 부대행사를 만날 수 있는 축제이다.
바다海 바람風 이란 이름을 갖고 있는 고창군 해풍고추는 천혜의 생태적 조건과 칠산바다에서 불어오는 해풍을 맞아 병충해에 강하다
그리고, 전국 최고의 미네랄과 게르마늄을 함유한 황토에서 재배하고, 해풍과 태양열을 이용하여 건조시켜 색상이 선명하고 껍질이 두꺼우며, 고추 특유의 매콤 달콤한 맛과 향이 천하제일이다
우리 밥상에 빼놓을 수 없는 고추!!
해풍고추로 조리하여 더없이 ‘행복한 밥상’ 이 되시길 바라는 마음에서 8월의 마지막을 청정 해풍고추, 그 참맛과 참빛 체험으로 함께하시기를 바라며, 올해 김장김치는 천하제일 해풍고추로 준비하기를 바란다.", 
'고창군 해리면 복지회관 및 해리면 체육관', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
1358009 , '칠포재즈페스티벌' , 20220916 , 20220918 , '경상북도 포항시 북구 흥해읍 칠포리 197번지 칠포해수욕장', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/73/2496273_image2_1.jpg', 129.3972041029, 36.1330025003, 6, 35, 23, '070-8675-9177', 
'<a href="http://www.chilpojazz.com" target="_blank" title="새창:칠포 국제재즈페스티벌 홈페이지로 이동">http://www.chilpojazz.com</a>', "올해로 16회를 맞이하는 2022년 칠포재즈페스티벌이 9월 16일부터 18일까지 3일간 포항시 칠포해수욕장 상설무대에서 개최된다. 칠포재즈페스티벌은 국내외 재즈 아티스트, 그리고 관객들의 성원과 격려로 포항의 상징적인 문화축제이자 아울러 대한민국의 대표적인 음악축제로 자리잡아 가고 있다.
칠포재즈페스티벌에서는
규칙적으로 반복되는 멜로디와 리듬으로 몸과 마음을 들썩이게 하는 '스윙'
빠른 템포와 격렬한 즉흥연주를 느낄 수 있는 '비밥'
지적이면서 잔잔하게 감성을 적시는 '쿨'
매우 자유로우면서 연주자들의 개성이 잘 드러나는 '프리재즈'
재즈와 록음악이 만나 누구나 편안하게 즐길 수 있는 '록 재즈' 등
다양한 재즈의 선율을 즐길 수 있다.", 
'칠포해수욕장 상설무대', NULL, NULL, '유료','전연령', '9/16(금) 18:00 ~ 21:00<br>9/17(토), 9/18(일) 17:00 ~ 22:00');

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
1344850 , '세종대왕과 초정약수축제' , 20221007 , 20221009 , '충청북도 청주시 청원구 초정약수로 851 초정행궁', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/93/2852393_image2_1.jpg', 127.6006940627, 36.7213297572, 6, 33, 10, '043-223-4030', 
'<a href="http://www.cjart21.org/index.php?mid=cjart2_1_1&act=dispBusinessInfo&its_business_srl=17" target="_blank" title="새창: 초정약수축제 홈페이지로 이동">http://www.cjmh.or.kr/</a>', "세종대왕이 1444년 두 차례 걸쳐 초정에 머물며 질병을 치료하고 훈민정음 창제 등 애민정책을 펼친 초정행궁 121일 이야기의 재발견과 세계 3대 광천수의 가치를 재조명하고 지역 문화브랜딩 및 문화 자원을 재창조하겠다는 마음을 담은 세종대왕과 초정약수의 역사성, 문화적 가치에 초점을 두는 행사이다.<br>이번 세종대왕과 초정약수축제는 콘텐츠 중심의 축제, 참여와 공감의 축제, 지속가능한 축제로 특화해 내실 있는 행사를 만들고자하는 마음을 담았다.", 
'초정문화공원 및 초정행궁 일원', NULL, NULL, '무료(체험부스 이용 시 요금발생)','전연령', NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
1336591 , '완주 와일드&로컬푸드축제' , 20220908 , 20221002 , '전라북도 완주군 고산휴양림로 246 고산휴양림', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/33/2827633_image2_1.jpg', 127.2331642183, 35.9615878959, 6, 37, 8, '063-290-2623, 2622', 
'<a href="http://www.wildfoodfestival.kr" target="_blank" title="새창:완주와일드푸드축제 홈페이지로 이동">http://www.wildfoodfestival.kr</a>', "자연 친화적 안전한 친환경 축제, 체류형 힐링축제로 와일드한 자연친화&아웃도어 체험과 건강한 먹거리 로컬푸드를 즐길 수 있는 축제이다.", 
'완주 고산자연휴양림 일원', NULL, NULL, '무료(일부체험 유료)',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
1328605 , '제22회 동두천 락 페스티벌' , 20220924 , 20220925 , '경기도 동두천시 평화로2910번길 30 소요산 축산물 브랜드육타운', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/08/2846908_image2_1.jpg', 127.0644411969, 37.9458921750, 6, 31, 10, '02-401-6237', 
'<a href="https://ko-kr.facebook.com/ddrockband2018/" target="_blank" title="새창: 락밴드챔피언십 페이스북으로 이동">http://www.facebook.com/ddrockband2018</a><br />
<a href="http://cafe.naver.com/ddrockband16" target="_blank" title="새창: 동두천락 카페 홈페이지로 이동">http://cafe.naver.com/ddrockband16</a>', "동두천 락 페스티벌은 문화체육관광부 , 동두천시 , 동두천시의회 , 동두천락페스티벌 조직위원회 주최로 이루어지는 축제로 1999년 제1회 페스티벌 개최 후 매년 이어지고 있는 경기도 대표축제이자 전국 최장수 락 음악 축제이다.<br>한국 최초의 록 밴드인 신중현 선생의 'ADD4'가 결성되어 국내에 처음 락(Rock)을 알린 한국 락의 발상지라는 지역의 역사적 자산을 기반으로 탄생한 페스티벌이다.", 
'소요산 입구 광장 특설무대', NULL, NULL, '무료','전연령 가능', '기간내 자유');

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
1328004 , '삼강주막 나루터 축제' , 20220910 , 20220912 , '경상북도 예천군 삼강리길 27-1 삼강문화단지', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/62/2840962_image2_1.jpg', 128.2984833678, 36.5627995750, 6, 35, 16, '054-653-2434', 
NULL, "낙동강 1,300리 마지막 남은 주막, 예천 삼강주막 일원에서 펼쳐지는 삼강주막 나루터 축제는 낙동강, 내성천, 금천 세 강이 합쳐지는 독특하고 아름다운 지형에서 이름을 딴 삼강, 물과 사람이 모이는 나루터, 그리고 나그네 술 한 사발의 낭만이 흐르는 주막이라는 스토리가 어우러진 축제 한마당이다. 매년 많은 관광객이 찾는 예천의 대표적인 축제로 옛 주막의 정취를 느끼며 힐링하기 딱 좋은 축제이다.", 
'삼강주막 및 삼강문화단지 일원', NULL, NULL, NULL,NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
1316398 , '에버랜드 썸머워터 펀' , 20220617 , 20220828 , '경기도 용인시 처인구 포곡읍 에버랜드로 199', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/53/2496353_image2_1.jpg', 127.2131685506, 37.2924319247, 6, 31, 23, '031-320-5000', 
'<a href="http://www.everland.com" target="_blank" title="새창:에버랜드 썸머스플래쉬 홈페이지로 이동">http://www.everland.com</a>', "에버랜드가 여름 축제 '썸머 워터 펀(Summer Water Fun)'을 개최한다.<br><br>지난 2005년부터 '물 맞는 재미'라는 역발상을 통해 시원한 여름 축제를 선보여 온 에버랜드는 이색 피서지를 찾는 사람들에게는 이미 여름철 나들이 명소로 유명하다.", 
'에버랜드', NULL, NULL, '유료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
1291408 , '2022년 창덕궁 달빛기행' , 20220901 , 20221028 , '서울특별시 종로구 율곡로 53 (학)덕성학원 해영회관', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/81/2815681_image2_1.jpg', 126.9851423515, 37.5766531897, 6, 1, 23, '02-3210-4804', 
'<a href="https://www.chf.or.kr/cont/view/fest/month/menu/210?thisPage=1&idx=108793&searchCategory1=600&searchCategory2=&searchField=all&searchDate=202209&weekSel=undefined&searchText=" target="_blank" title="새창: 홈페이지로 이동">https://www.chf.or.kr/chf</a>', "올해 13년째를 맞는 ｢창덕궁 달빛기행｣은 유네스코 세계문화유산 창덕궁에서 펼쳐지는 대표적인 고품격 문화행사이다. 은은한 달빛 아래 청사초롱으로 길을 밝히며 창덕궁 곳곳의 숨은 옛이야기를 들을 수 있고, 후원을 거닐며 밤이 주는 고궁의 운치를 마음껏 만끽할 수 있다.", 
'창덕궁 일원', NULL, NULL, '1인 30,000원',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
1267272 , '레인보우 아일랜드' , 20220908 , 20220915 , '경기도 가평군 가평읍 자라섬로 60', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/56/2493556_image2_1.jpg', 127.5210475885, 37.8208928790, 6, 31, 1, '070-5165-3071', 
'<a href="http://www.rainbowfestival.co.kr" target="_blank" title="새창:레인보우 아일랜드 사이트로 이동">http://www.rainbowfestival.co.kr</a>', "국내 최고의 캠핑 성지, 자라섬에서 진행되는 뮤직 페스티벌
지금 떠나는 나만의 하루, 누구나 즐길 수 있는 낭만 캠핑", 
'가평 자라섬', NULL, NULL, '110,000원(얼리버드 66,000원)','연령제한없음', NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
1266642 , '2022 제26회 부평풍물대축제' , 20220930 , 20221002 , '인천광역시 부평구 부평대로 166 원평빌딩', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/09/2833209_image2_1.png', 126.7216155851, 37.5061983460, 6, 2, 6, '032-509-7516', 
'<a href="https://portal.icbp.go.kr/bpf/" target="_blank" title="새창 : 관광지">portal.icbp.go.kr/bpf</a>', "부평풍물대축제는 1997년에 축제를 시작한 이래 부평의 정체성 확립과 자긍심 고취에 노력하고, 전통문화의 계승 및 발전을 통하여 풍요로운 문화도시 조성에 기여하고 있다. 올해로 26회째를 맞이하는 <2022 부평풍물대축제> 는 21세기 문화도시 부평에 전통과 새로움이 가득한 문화가 소통하고 흐르는 축제로 코로나로 지친 시민들의 마음의 담을 열기를 바라는 축제이다.", 
'부평대로, 부평아트센터', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
1230074 , '2022 춘천막국수닭갈비축제' , 20220830 , 20220904 , '강원도 춘천시 스포츠타운길 245', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/40/2835140_image2_1.jpg', 127.6913807924, 37.8644965197, 6, 32, 13, '033-254-4347', 
'<a href="http://mdfestival.com" title="새창: 춘천막국수닭갈비축제로 이동" target="_blank">http://mdfestival.com</a>', "춘천의 대표적인 축제인 춘천막국수닭갈비축제가 올해는 춘천 삼악산 호수케이블카 일원에서 8월30일부터~9월4일까지 6일간 진행이 된다. 3년만에 오프라인으로 찾아오는 이번 축제는  30일 KBS전국노래자랑을 시작으로 멀티미디어 드론쇼,인기가수 축하공연등 풍성한 볼거리와 춘천에서 즐기는 막국수, 닭갈비를 다양하게 선보이려고 한다.", 
'춘천 삼악산 호수케이블카 일원', NULL, NULL, '무료(축제장에서 할인권을 구매하면 시내 제휴된 막국수,닭갈비음식점에서 할인 혜택을 받을 수 있음.)',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
1147035 , '여주오곡나루축제' , 20221021 , 20221023 , '경기도 여주시 신륵사길 7 여주세계생활도자관', NULL, 'A02070100', 'http://tong.visitkorea.or.kr/cms/resource/84/2838384_image2_1.jpg', 127.6545006058, 37.3001807187, 6, 31, 20, '031-881-9668', 
'<a href="http://www.yjogoknaru.or.kr" target="_blank" title="새창:여주오곡나루축제 홈페이지로 이동">http://www.yjogoknaru.or.kr</a>', "여주오곡나루축제는 여주가 자랑하는 농특산물을 홍보하고, 여주 전통문화를 함께 즐기는 축제이다. 비옥한 토지를 가진 여주는 쌀과 오곡, 고구마 등 다양한 농‧특산물로 유명한 고장으로 조선 시대에는 나루터를 이용해 여주의 농‧특산물을 왕에게 진상했다고 기록되어 있다. 2022 여주오곡나루축제는 단계적 일상회복에 따라 다시 돌아온 관광객과 풍년을 맞이하는 축제로 진행된다. 옛 나루터 주변 저잣거리 정취를 재현한 나루마당, 다양한 농‧특산물 판매 및 민속 체험 프로그램이 운영되는 오곡마당,  먹거리 장터와 공예 판매장 등 잔치마당으로 구성된다.", 
'여주시 신륵사 관광지', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
1118680 , '대한민국와인축제' , 20221006 , 20221009 , '충청북도 영동군 영동힐링로 117', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/20/2824920_image2_1.JPG', 127.7865319410, 36.1563977278, 6, 33, 4, '043-745-8916~8', 
'<a href="https://yd21.go.kr/ydft/html/sub01/010201.html" target="_blank" title="새창 : 대한민국와인축제">https://yd21.go.kr</a>', "와인의 고장, 영동에서 열리는 대한민국와인축제<br>대한민국 최고의 와인을 소개하는 대한민국 와인축제는 영동에서 재배되는 포도로 40여개의 와이너리 농가에서 만든 와인을 소개하고 함께 즐기는 축제이다.", 
'레인보우힐링관광지 일원', NULL, NULL, '무료<br>일부체험 유료-와인잔 구입 등','전연령가능(와인구입 제한)', '기간내자유');

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
1105591 , '제15회 의정부 부대찌개 축제' , 20221015 , 20221023 , '경기도 의정부시 태평로73번길 20', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/85/2823585_image2_1.png', 127.0496150377, 37.7438960063, 6, 31, 25, '031-928-6688', 
'<a href="https://budaejjigaefesta.modoo.at/" target="_blank" title="새창:의정부부대찌개홈페이지로 이동">https://budaejjigaefesta.modoo.at</a><br>', "의정부 대표 음식인 부대찌개축제를 온·오프라인 방문객에게 소개하고 많은 먹거리와 볼거리를 제공하는 축제이다. 소상공인이 참여한 축제를 관광자원화하여 코로나19로 침체한 소상공인의 비대면 영업력 증진에 이바지하고, 의정부시에 있는 부대찌개 전문업소를 소개할 예정이다.", 
'온라인, 축제 참여업소', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
1104496 , '2022도봉산페스티벌' , 20220924 , 20220925 , '서울특별시 도봉구 마들로 932 평화문화진지', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/26/2830026_image2_1.jpg', 127.0464307380, 37.6907576895, 6, 1, 10, '02-908-2914', 
'홈페이지 <a href="https://www.dobongsanf.com/" target="_blank" title="새창 : 2022도봉산페스티벌">www.dobongsanf.com</a><br>인스타그램 <a href="https://www.instagram.com/dbsfestival/" target="_blank" title="새창 : 2022도봉산페스티벌">www.instagram.com</a><br>페이스북 <a href="https://m.facebook.com/dbsfestival" target="_blank" title="새창 : 2022도봉산페스티벌">https://m.facebook.com</a>', "도봉산페스티벌은 도심 속 자연인 도봉산과 함께 일상의 평화를 즐길 수 있는 축제로 올해는 &lt;도봉산을 함께하다&gt;를 주제로 개최한다.<br>다채로운 공연과 자연을 바라보며 즐기는 릴렉스파크, 문화예술 체험프로그램, 친환경 기반의 샐러마켓 등 지속가능발전과 친환경을 고려한 다양한 프로그램을 만날 수 있다. 이번 축제를 통해 일상 속에 스며있는 도봉산과 공존하는 가치를 공유하고, 몸소 실천하는 가치를 되새기며 도봉산 곁에서 즐기는 문화예술축제로 여러분을 초대한다.", 
'다락원체육공원 및 평화문화진지 일대', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
1100492 , '2022 고양호수예술축제 GSAF2022' , 20220930 , 20221003 , '경기도 고양시 일산동구 호수로 595', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/65/2722465_image2_1.jpg', 126.7686654803, 37.6538792239, 6, 31, 2, '031-960-9684', 
'홈페이지 <a href="http://www.gylaf.kr" target="_blank" title="새창 : 고양호수예술축제">http://www.gylaf.kr</a><br>블로그 <a href="https://blog.naver.com/lakefest" target="_blank" title="새창 : 고양호수예술축제">https://blog.naver.com</a><br>인스타그램 <a href="https://www.instagram.com/gylakefest/" target="_blank" title="새창 : 고양호수예술축제">www.instagram.com</a><br>페이스북 <a href="https://www.facebook.com/GYLAF/" target="_blank" title="새창 : 고양호수예술축제">www.facebook.com</a>', "호수 거리 자연 사람이 어우러진 도심의 축제! 대한민국을 대표하는 거리예술 축제인 고양호수예술축제가 2022년 고양특례시 원년을 맞아 더욱 풍성한 프로그램으로 관객여러분을 기다린다.<br>엄선된 국내외 초청작들과 자유참가작은 물론 고양버스커즈를 비롯한지역예술인들과 함께 상생하는 특별 기획 프로그램까지!<br>일산호수공원과 일산문화공원 등 고양시의 주요 거리에서 다채로운 예술로 채워지는 희망의 여정을 함께하자.", 
'일산호수공원 및 고양시 주요거리(일산문화공원, 라페스타, 웨스턴돔 등)', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
1086249 , '청양고추구기자축제' , 20220826 , 20220828 , '충청남도 청양군 청양읍 은천동길 16-6', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/32/2833832_image2_1.jpg', 126.7975542558, 36.4460221385, 6, 34, 13, '041-940-2303~5', 
'<a href="https://xn--539an7vgta625d.com/festival/" target="_blank" title="새창: 고추구기자축제 홈페이지로 이동">www.칠갑마루.com</a>', "지금 이 글을 읽고 계신 당신, 당신은 이미 올여름 잊지 못할 추억을 위한 여행을 시작했다.<br>코로나19로 지친 마음을 달래고 지역 주민과 방문객 모두가 힐링이 될 수 있도록 청양군이 알차게 준비했다!<br>전 연령대가 즐기는 다양한 프로그램과, 이전보다 업그레이드 된 콘텐츠 구성으로 새로운 경험을 선사한다.<br>먹고, 보고, 듣고, 즐겨라! 매콤달콤 청양으로!", 
'청양군 백세건강공원', NULL, NULL, '입장 무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
1083748 , '명지시장 전어축제' , 20220830 , 20220901 , '부산광역시 강서구 신포길 13-10', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/22/1409322_image2_1.jpg', 128.9317096042, 35.1129197501, 6, 6, 1, '051-271-3398', 
'<a href="https://www.bsgangseo.go.kr/visit/contents.do?mId=0301000000" target="_blank" title="새창 : 명지시장 전어축제">https://www.bsgangseo.go.kr</a>', "가을을 대표하는 생선인 전어를 마음껏 맛보려면 매년 8월말 부산 강서구 명지시장에서 열리는 ‘명지시장 전어축제’로 가면 된다. ‘가을전어엔 깨가 서 말’ 이라는 말처럼 전어는 살점이 두껍고 단단해 다른 활어보다 맛이 뛰어난 것으로 미식가들 사이에서 소문이 자자하다.<br>명지시장 전어축제에서는 싱싱한 전어회를 싼 가격에 마음껏 먹어 볼 수 있는 것은 물론 명지시장 상인들의 회썰기 시범, 무료 시식회 등을 체험할 수 있다.<br>명지시장은 약 70년의 전통을 지닌 부산 강서지역의 대표적 전통시장으로 5일장과 새벽시장을 거쳐 30년전부터 부산의 명물 활어시장으로 면모를 갖추어 가고 있다.", 
'강서구 명지동 명지시장 일원', NULL, NULL, NULL,NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
1080734 , '제30회 영도다리축제' , 20221014 , 20221016 , '부산광역시 영도구 해양로301번길 55', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/14/2738814_image2_1.jpg', 129.0820363898, 35.0772292873, 6, 6, 14, '051-403-1861/ 051-419-4064', 
'홈페이지 : <a href="https://www.yeongdo.go.kr/ydfestival.web" target="_blank" title="새창 : 관광지">https://www.yeongdo.go.kr/ydfestival.web</a><br>유튜브 : <a href="https://www.youtube.com/channel/UCjvY4kpjz4YhMApVUux0S6Q" target="_blank" title="새창 : 관광지">www.youtube.com/channel</a>', "1934년 11월 23일 영도다리가 개통되는 날, 부산경남 6만명의 인파가 운집했다. 국내 첫 연육교로 개통돼 한국전쟁 피란민들의 망향의 슬픔을 달래고 헤어진 가족이 다시 만나는 다리였다. 영도는 일제강점기와 한국전쟁, 산업화를 거치면서 많은 근현대사의 유적들이 그때의 애환과 향수를 대변하고 있으며 새로 건설된 남북향대교의 중심지로서 서부산권, 원도심권, 동부산권을 잇는 중요한 거점으로 그 브랜드 가치를 높여가고 있다. <영도다리축제>는 역사적 전통과 현대적 가치를 녹여낸 한국의 근대문화역사를 체험하는 참여형 축제이다. 올해에는 10월 15일부터 17일까지 3일간 진행된다.", 
'아미르공원, 영도 일원, 영도다리축제 유튜브 채널', NULL, NULL, NULL,NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
1078905 , '제22회 영광불갑산상사화축제' , 20220916 , 20220925 , '전라남도 영광군 불갑면 불갑사로 450', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/92/2831192_image2_1.jpg', 126.5506415778, 35.2001904683, 6, 38, 16, '061-350-5269', 
'<a href="http://상사화축제.com/" target="_blank" title="새창: 상사화축제 홈페이지로 이동">http://상사화축제.com/</a>', "매년 9월 상사화 개화시기에 맞춰, 국내 최대 상사화 군락지를 이루는 영광군 불갑사관광지에서 개최되는 축제이다. 상사화는 잎과 꽃이 만날 수 없어 그리움, 애틋함, 참사랑을 상징한다. 제22회 영광불갑산상사화축제는 ‘상사화 붉은물결 청춘의 사랑을 꽃피우다’를 주제로 9월16일부터 25일까지 개최된다. 온 산을 붉게 수놓는 상사화와 함께 꽃길걷기, 꽃맵시 선발대회 등의 대표 프로그램과 다양한 공연, 체험, 전시행사가 펼쳐진다. 올해는 대학가요제 등 청춘들이 참여할 수 있는 프로그램 도입과 미디어파사드, 상사화 별빛야행 등 야간프로그램 강화로 더욱 다채롭게 관광객을 맞이할 계획이다.", 
'영광군 불갑사관광지 일원', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
1074568 , '2022 제주올레걷기축제' , 20221103 , 20221105 , '제주특별자치도 서귀포시 중정로 22', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/95/2830595_image2_1.jpg', 126.5586702334, 33.2474365704, 6, 39, 3, '064-762-2190', 
'<a href="http://www.jejuolle.org/office/kor/board/board_view.asp?page=1&search_idx=8134" target="_blank" title="새창: 제주올레걷기축제 홈페이지로 이동">http://intro.jejuolle.org</a>', "'2022 제주올레걷기축제'는 '걷기예찬'을 슬로건으로 2022년 11월 3일(목) ~ 11월 5일(토) 3일간 제주올레 11, 12 ,13코스에서 개최된다. 제주특별자치도에서 주최하고, 사단법인 제주올레가 주관한다. 제주올레 길을 하루 한 코스씩 걸으며 문화 예술 공연과 지역 먹거리를 즐기는 이동형 축제이다. 국내뿐 아니라 대만, 미국, 영국, 일본, 캐나다 등 전 세계 1만여 명의 도보 여행자들이 참여한다. 운영을 돕는 자원봉사자, 체험과 먹거리를 책임지는 지역주민들, 감동적인 공연을 펼치는 출연진이 함께하는 제주 최대 규모의 페스티벌이다.", 
'제주올레 11, 12, 13코스', NULL, NULL, '사전 접수: 개인 30,000원/인<br>(20인 이상 단체, 청소년 이하(만 19세), 장애인, 국가유공자 할인 25,000원/인)<br><br>현장 접수: 개인 35,000/인<br>(20인 이상 단체, 청소년 이하(만 19세), 장애인, 국가유공자 할인 30,000원/인)',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
1073801 , '영양고추 H.O.T 페스티벌' , 20220828 , 20220830 , '서울특별시 중구 태평로1가', NULL, 'A02070200', NULL, 126.9780155345, 37.5656543401, 6, 1, 24, '054-683-7300', 
'<a href="http://www.yftf.kr/" target="_blank" title="새창:영양 고추축제 홈페이지로 이동">http://www.yftf.kr</a>', "2007년부터 개최된 HOT페스티벌은 영양고추의 우수성을 널리 홍보하고 도농상생을 모색하기 위해 전국자치단체 최초로 영양이 시작한 뜻 깊은 행사이다.
우수 농특산물 직거래 장터 및 영양의 관광지와 먹거리 소개, 영양고추아가씨선발대회 등의 다채로운 행사가 열리며, 영양군민의 푸짐한 인정을 전국에 전하는 계기가 되고 있다.", 
'서울광장 (서울시청 앞)', NULL, NULL, NULL,NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
1066064 , '한일축제한마당 in Seoul' , 20220925 , 20220925 , '서울특별시 강남구 영동대로 513 코엑스', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/26/2822726_image2_1.jpg', 127.0592179950, 37.5119175967, 6, 1, 1, '02-702-7775', 
'<a href="http://omatsuri.kr" target="_blank" title="새창:한일축제한마당 홈페이지로 이동">http://omatsuri.kr</a>', "한일축제한마당은 지난 2005년 한일 국교정상화 40주년을 기념한 '한일 우정의 해'에서 시작된 한국과 일본, 양국에서 매년 열리는 최대의 한일문화 교류행사 이다. 수만 명의 한국인과 일본인이 하나가 되어 만들어가는 최대 규모의 한일 교류 행사로, 한일 문화 교류, 시민 교류, 청소년 교류, 지방 자치 단체 교류 등 많은 의미를 가지고 있다. 이 ‘축제’를 통해 한일 문화의 차이를 더 이해하고 서로를 더 존중하는 계기가 되어, 한일 우호의 상징으로 성장하기를 기대하고 있다.", 
'코엑스 3층 C홀 (1, 2, 3)', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
1032770 , '제17회 부산국제매직페스티벌' , 20220601 , 20221113 , '부산광역시 남구 못골번영로71번길 74 부산예술대학', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/19/2823019_image2_1.jpg', 129.0849510244, 35.1423165015, 6, 6, 4, '051-626-7002', 
'공식홈페이지(<a href="https://www.hibimf.org/" target="_blank" title="새창 : 관광지">www.hibimf.org</a>)<br>인스타그램(<a href="https://www.instagram.com/busanmagicfestival/" target="_blank" title="새창 : 관광지">www.instagram.com</a>)<br>페이스북(<a href="https://www.facebook.com/busanmagicfestival" target="_blank" title="새창 : 관광지">www.facebook.com</a>)<br>네이버블로그(<a href="https://blog.naver.com/bimf7002" target="_blank" title="새창 : 관광지">blog.naver.com</a>)', "부산국제매직페스티벌은 2006년부터 시작되어 문화콘텐츠 산업의 떠오르는 블루오션인 ‘매직’을 테마로 한 국내 100만 매직 매니아의 꿈의 축제인 국내 유일 세계 최대 규모의 마술 페스티벌이다. 올해 11월까지 진행되는 제17회 부산국제매직페스티벌에는 1년 내내 마술로, 매직컨벤션, 제4회 국제매직버스킹챔피언십, 매직위크 등 다양한 행사들이 준비되어있다.", 
'행사별 상이', NULL, NULL, '프로그램별 상이(유/무료)',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
1019773 , '제주레저힐링축제' , 20220916 , 20221015 , '제주특별자치도 제주시 조함해안로 525', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/94/2848794_image2_1.jpg', 126.6690845131, 33.5427390309, 6, 39, 4, '(제주시관광과) 064-728-2751~6', 
'<a href="https://jejulhfestival.kr/" target="_blank" title="새창 : 제주레저힐링축제">https://jejulhfestival.kr</a>', "레저스포츠와 문화예술이 어우러진 「융합형 관광 문화 축제」, 레저스포츠가 가진 역동성을 함께하는 「체험형 액티비티 축제」,제주형 문화․예술로 힐링을 나누는 「감성 문화 축제」,지역민과 직접 참여하고 만들어가는 「지역 밀착형 축제」이다. 환경을 생각하는 행사 운영으로 축제의 지속가능성을 확보한다. 제주의 대표적인 콘텐츠, 레저와 힐링이 어우러진 융합형 관광축제이다. 체험형 액티비티를 통해 레저 스포츠의 역동성을 즐기고 제주만의 감성적인 문화 예술로 힐링을 느낀다. 지역 문화 예술인과 소상송인 등 지역민과 함께 만들어가는 지역 밀착형 축제로서 다양한 환경친화적 캠페인과 프로그램 도입으로 축제의 지속가능성 또한 확보한다.", 
'함덕해수욕장, 새별오름', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
1019654 , '제15회 제주해비치아트페스티벌' , 20220919 , 20220922 , '제주특별자치도 서귀포시 표선면 민속해안로 537', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/89/2846289_image2_1.jpg', 126.8447465590, 33.3215135225, 6, 39, 3, '02-3019-5853~6', 
'홈페이지:<a href="http://www.jhaf.or.kr" target="_blank" title="새창:제주 해비치 아트 페스티벌 홈페이지로 이동">http://www.jhaf.or.kr</a><br>페이스북:<a href="https://ko-kr.facebook.com/jejuhaevichiartsfestival" target="_blank" title="새창:제주 해비치 아트 페스티벌 홈페이지로 이동">jejuhaevichiartsfestival</a>', "전국 문예회관 관계자, 국내외 예술단체 및 공연기획사, 문화예술관련 기관, 공연장 관련 장비업체 등 문화예술 산업 종사자 간 정보제공•교류•홍보를 위한 유통의 핵심 플랫폼 구축을 통해 기획역량 및 유통황성화에 기여하고, 다양한 형태의 공연예술프로그램 실연을 통해 문화 향유 기회를 제공하는 대한민국을 대표하는 아트마켓형 페스티벌", 
'해비치호텔앤드리조트 제주 및 제주도 내 공연장 일원 등', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
1018971 , '국토정중앙 양구 배꼽축제' , 20220902 , 20220904 , '강원도 양구군 양구읍 박수근로 366-33', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/49/2842149_image2_1.jpg', 127.9814637917, 38.1062154905, 6, 32, 6, '033-482-9172', 
'<a href="https://www.ygtour.kr/Home/H30000/H30100/placeDetail?place_no=78&viewType=gallery&viewClass=tour&page=1&pageSize=12&order_column=1&place_class=P012" target="_blank" title="새창: 청춘양구배꼽축제 홈페이지로 이동">www.ygtour.kr</a>', "국토의 정중앙에 위치한 양구에서는 9월 2일부터 4일까지 '2022 국토정중앙 양구 배꼽축제 <100X LAND FESTIVAL>'가 열린다.<br>놀이공원부터 음악마을, 동화마을, 양구군만의 특별한 농특산물과 먹거리를 한데 만나보실 수 있다.", 
'양구 서천 레포츠 공원 일대', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
1018469 , '서울국제작가축제(Seoul International Writers\' Festival)' , 20220923 , 20220930 , '서울특별시 마포구 양화로 72', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/28/2822428_image2_1.png', 126.9167298722, 37.5508549625, 6, 1, 13, 'siwf@klti.or.kr', 
'공식 홈페이지 : <a href="https://www.siwf.or.kr" target="_blank" title="새창 : 관광지">https://www.siwf.or.kr</a><br>인스타그램 : <a href="https://www.instagram.com/siwf_insta/" target="_blank" title="새창 : 관광지">https://www.instagram.com/siwf_insta/</a><br>페이스북 : <a href="https://m.facebook.com/siwfest/" target="_blank" title="새창 : 관광지">https://m.facebook.com/siwfest/</a><br>트위터 : <a href="https://twitter.com/siwfest" target="_blank" title="새창 : 관광지">https://twitter.com/siwfest</a>', "서울국제작가축제는 국내 독자들의 문학향유 기회를 확대하고, 한국문학과 세계문학이 서울을 무대로 교류하는 토대를 만들고자 지난 2006년부터 개최해 온 글로벌 문학 축제이다. 올해 제 11회를 맞이한 서울국제작가축제는 '월담: 이야기 너머-Beyond Narrative'를 주제로 전 세계 35인의 작가들이 참여하는 다양한 프로그램과 문학 낭독 행사를 개최한다.", 
'서교스퀘어, 커뮤니티하우스 마실, 인천국제공항', NULL, NULL, '무료','전 연령', NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
952988 , '백제문화제 「제68회 백제문화제」' , 20221001 , 20221010 , '충청남도 부여군 백강로 135', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/00/2817800_image2_1.jpg', 126.9048904989, 36.2871644357, 6, 34, 6, '041-635-6980', 
'<a href="http://www.baekje.org" target="_blank" title="새창: 백제문화제 홈페이지로 이동">http://www.baekje.org </a>', "<백제의 왕도(王都),충청남도 공주시와 부여군에서 개최되는 역사문화축제><br>68년을 이어온 백제문화제는 고대 동아시아의 문화강국이었던 백제의 전통성에 근거하여 백제의 수도였던 충청남도 공주시와 부여군에서 1955년부터 매년 개최하는 역사재현형 축제이다.<br>또한 2015년7월 백제역사유적지구의 유네스코 세계유산 등재를 계기로 백제의 후예들과 관광객들이 만들어가는 세계적인 역사문화축제로 나아가고 있다. 제68회 백제문화제는 찬란한 문화를 꽃 피워 이웃나라에 전파함으로써 고대 동아시아의 문화발전에 크게 기여했던 '한류원조로서의 백제문화'를 국내외에 확산시키고, 세계적인 축제로 거듭나기 위하여 2022년 10월 1일부터 10월 10일까지 10일간 충청남도 공주시와 부여군 일원에서 \"백제의 빛과 향\"이라는 주제로 화려하게 펼쳐진다.<br>세계유산인 백제역사유적지구를 배경으로 펼쳐지는 제68회 백제문화제에서 다양한 축제 프로그램과 더불어 백제로의 흥겨운 시간여행에 흠뻑 빠져보시기 바란다.", 
'부여군 구드래 일원(충청남도 부여군 부여읍 백강로 135)<br>공주시 금강신관공원 일원(충청남도 공주시 금벽로 368)', NULL, NULL, '무료 (별도의 유료 체험프로그램 및 공연료는 홈페이지 참고)',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
921212 , '청송사과축제' , 20221102 , 20221106 , '경상북도 청송군 청송읍 월막리', NULL, 'A02070100', 'http://tong.visitkorea.or.kr/cms/resource/90/2687790_image2_1.png', 129.0557282477, 36.4326453049, 6, 35, 21, '054-873-3686', 
'<a href="http://www.cs.go.kr/tour/00004559/00004588.web?amode=view&idx=111&" target="_blank" title="새창: 청송사과축제 홈페이지로 이동">http://tour.cs.go.kr</a>', "[축제소개] 대한민국 대표브랜드 '청송사과' 
경상북도 청송은 적은 강수량과 풍부한 일조량, 깨끗한 자연환경 등 사과를 재배하기 최적의 조건을 갖춘 곳이다. ‘자연이 빚어낸 명품’이라 불리는 청송사과가 무르익는 가을, 풍성한 수확의 기쁨과 청송사과의 맛과 영양을 함께 나누는 청송사과축제가 열린다. 축제에서는 8년 연속 대한민국 대표브랜드 대상을 수상한 청송사과를 테마로 하는 유익하고 즐거운 체험프로그램을 즐길 수 있다. 하늘에서 풍선을 떨어뜨려 황금사과를 찾는 ‘만유인력-황금사과를 찾아라’, 만보기가 달린 방망이로 지퍼백 속의 사과를 두드려 잼을 만드는 ‘꿀잼-사과 난타’ 등 재치 있는 체험도 준비되어 있다. 이밖에도 청송사과 퍼레이드, 사과 올림픽, 사과 가면 무도회 등 다양한 행사가 열린다. 
[축제TIP] 청송사과란?
해발고도 250m, 연평균 기온 12.6℃, 일교차 13.4℃로 육질이 치밀하고 색깔이 고우며, 당도와 산미가 뛰어난 사과이다.", 
'청송읍 용전천 일원(현비암 앞)', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
914138 , '제 59회 수원화성문화제' , 20221007 , 20221009 , '경기도 수원시 팔달구 정조로 825', '(남창동)', 'A02070100', 'http://tong.visitkorea.or.kr/cms/resource/96/2735596_image2_1.jpg', 127.0120008348, 37.2872039225, 6, 31, 13, '031-228-1010', 
'홈페이지: <a href="https://www.swcf.or.kr/shcf/" target="_blank" title="새창 : 수원 화성문화제 홈페이지로 이동">www.swcf.or.kr/shcf</a><br>인스타그램: <a href="https://www.instagram.com/suwonfestival/" target="_blank" title="새창 : 수원 화성문화제 홈페이지로 이동">www.instagram.com</a><br>유튜브: <a href="https://www.youtube.com/c/%EC%88%98%EC%9B%90%EB%AC%B8%ED%99%94%EC%9E%AC%EB%8B%A8%EC%9C%A0%ED%8A%9C%EB%B8%8C" target="_blank" title="새창 : 관광지">https://www.youtube.com</a>', "2020·2021 문화관광축제 선정, 정조대왕의 효심과 부국강병의 꿈을 바탕으로 축성된 수원화성에서 매년 펼쳐지는 역사 깊은 문화관광축제 ‘수원화성문화제’이다. 2022년 <제59회 수원화성문화제>는 <세계유산축전 수원화성>과 함께하여 더욱 뜻깊고 다채로운 프로그램으로 시민 곁에 다가간다. 수원화성의 이야기들을 보고, 듣고, 체험할 수 있으며, 역사적 정취가 깃든 장소에서 다양한 문화예술 콘텐츠를 함께 즐길 수 있다.", 
'화성행궁 및 행궁광장 등', NULL, NULL, '일부 프로그램 유료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
900168 , '2022 보은대추 온라인축제' , 20221014 , 20221023 , '충청북도 보은군 보은읍 이평리', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/90/2851890_image2_1.jpg', 127.7234201582, 36.4863477992, 6, 33, 3, '043-540-3393', 
'<a href="http://www.boeunjujube.com/" target="_blank" title="새창:보은 문화관광 홈페이지로 이동">http://www.boeunjujube.com/</a>', "2017년도에 이어 3회연속 충북 농특산물 판매활성화 최우수축제로 선정된 보은대추축제는, 임금님께 진상하였던 명품 보은 대추와 보은의 청정한 자연에서 자란 우수한 품질의 농특산물을 온라인 주문을 통해 쉽게 받아볼 수 있으며,  온라인스튜디오에서 진행되는 인기가수 공연을 온라인(유튜브)으로 송출하여 실시간 관람이 가능하다, 또한 각종 온라인 참여프로그램을 진행하여 누구나 참여 가능하며, 특히 「축제홈페이지 특별이벤트」를 통한 경품 당첨의 행운에 도전할 수 있다. 축제기간중 주요관광지를 방문하면 버스킹공연 등 볼거리가 준비되어있다.", 
'온라인축제', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
825295 , '제14회 강릉커피축제' , 20221007 , 20221010 , '강원도 강릉시 경강로2021번길 9-1 명주예술마당', NULL, 'A02070100', 'http://tong.visitkorea.or.kr/cms/resource/75/2769775_image2_1.JPG', 128.8903006749, 37.7504520359, 6, 32, 1, '033-647-6802', 
'홈페이지-<a href="http://www.coffeefestival.net" target="_blank" title="새창:강릉 커피축제 홈페이지로 이동">www.coffeefestival.net</a><br>유튜브-<a href="https://www.youtube.com/channel/UC7NLJw1WR46vHu7sQZ3VUKQ" target="_blank" title="새창 : 강릉커피축제">www.youtube.com</a>', "강릉에서 매년 10월, 향긋한 커피향과 함께하는 강릉커피축제를 개죄하고 있다.<br>강릉을 비롯한 전국 유명 커피 업체들이 참석해 커피 무료 시음행사를 열고, 커피 명인들에게 직접 커피에 관한 전문적인 노하우를 얻는 세미나도 열린다. 올해는 가족단위형 프로그램 및 커피 관련 체험 등 다양한 문화행사도 동시에 열린다. 아름다운 강릉에서 바다를 바라보며 커피 한잔의 여유를 즐길 수 있다.", 
'강릉 아레나 및 강릉일원', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
790211 , '2022 장애인문화예술축제 A+ Festival' , 20220901 , 20220903 , '서울특별시 종로구 대학로 104', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/32/2825932_image2_1.jpg', 127.0023878907, 37.5805669329, 6, 1, 23, '02-304-6211', 
'<a href="http://aplusfestival.co.kr/" target="_blank" title="새창 : 장애인문화예술축제 A+ Festival">http://aplusfestival.co.kr</a>', "장애인문화예술축제 A+ Festival은 장애인들의 잠재적 가능성(Ability), 열린 접근성(Accessibility), 활기찬 역동성(Activity)을 모토로 장애인과 비장애인이 예술(Arts)로 함께(All Together)한다는 취지로 2009년부터 시작하여 올해 14회를 맞이한다. 2022 장애인문화예술축제는 펜데믹시대를 겪은 모든 사람들에게 장애인 문화예술이 희망의 날개를 달고 날아오른다는 의미의  “날아올라”란 슬로건으로 9월 1일부터 3일까지 대학로 마로니에 공원 일대에서 개최된다.", 
'대학로 마로니에 공원 일대', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
789869 , '제56회 처용문화제' , 20221008 , 20221010 , '울산광역시 중구 태화동', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/30/2845430_image2_1.jpg', 129.3043288142, 35.5539410733, 6, 7, 1, '052-259-7934', 
'홈페이지: <a href="https://www.cheoyongf.or.kr/" target="_blank" title="새창 : 제56회 처용문화제">https://www.cheoyongf.or.kr</a><br>인스타그램: <a href="https://www.instagram.com/cheoyongf/" target="_blank" title="새창 : 제56회 처용문화제">https://www.instagram.com</a><br>페이스북: <a href="https://www.facebook.com/cheoyong" target="_blank" title="새창 : 제56회 처용문화제">https://www.facebook.com</a>', "처용문화제는 1967년 울산공업축제로 시작하여 올해로 56회에 이르는 울산 시민들의 대표적인 축제이다. 지역문화와 전통연희를 콘셉트로 다양한 볼거리와 즐길거리를 제공할 예정이다. 또한 올해는 전국(장애인) 체전, 그리고 태화강공연축제 「나드리」와 연계 개최될 예정이다. 올해의 제56회 처용문화제는 전국(장애인) 체전을 기념하기 위해, 처용 뿐만 아니라 울산의 민담이나 설화 등과 관련된 폭넓은 융합장르 무대 콘텐츠로 이루어질 예정이다. 처용문화제는 지역 문화콘텐츠 활성화를 통해 지역 문화를 발굴 및 전승하고 더 나아가 범아시아 규모의 전통연희 축제로 도약하고자 한다.", 
'태화강국가정원 야외공연장', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
769092 , '제22회 서울국제대안영상예술페스티벌(네마프2022)' , 20220818 , 20220826 , '서울특별시 중구 정동길 3 경향신문사', NULL, 'A02070200', NULL, 126.9696495605, 37.5681316804, 6, 1, 13, '02-337-2870', 
'<a href="http://www.nemaf.net" target="_blank" title="새창:서울국제뉴미디어페스티벌 홈페이지로 이동">http://www.nemaf.net</a>', "축제의 생각과 실천 NeMaf's Beliefs and Practices<br>하나, 뉴미디어의 주인은 '우리'라고 생각하는 사람들과 함께 한다.<br>First, we look to be with people who can actively enjoy and appreciate new media.<br><br>두울, 모든 사람이 뉴미디어로 놀이하는 예술가라고 생각한다.<br>Second, we believe that everyone has the potential to become an artist who can play through new media.<br><br>세엣, 각 개인의 개성과 취향을 존중하는 세계를 꿈꾼다.<br>Third, we dream of a world that can respect every individual characteristic and taste.<br><br>네엣, 확일적인 예술보다 다양성의 예술을 지향한다.<br>Fourth, we aim for diversity in art rather than standardization of it.<br><br>다섯, 편견으로 차별받는 세상을, 모두가 존중받는 세상으로 바꾸어나가고자 한다.<br>Fifth, we desire to change the world, which is full of prejudice and discrimination into a world full of respect.", 
'홈페이지 참조', NULL, NULL, '홈페이지 참조',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
766923 , '2022년 제20회 울릉도 오징어축제' , 20220827 , 20220829 , '경상북도 울릉군 울릉읍 저동리', NULL, 'A02070200', NULL, 130.9099397874, 37.4953527283, 6, 35, 17, '(054)790-6392, 6425, 6426', 
'<a href="http://www.ulleung.go.kr/tour/page.htm?mnu_uid=1986&" target="_blank" title="새창 : 울릉도 오징어축제">http://www.ulleung.go.kr</a>', "밤바다를 밝히는 오징어잡이 배의 집어등 불빛은 한편의 낭만이다.밤바다를 밝히는 오징어잡이 배의 집어등 불빛은 한편의 낭만이다.<br>울릉도는 오징어와 더불어 살아간다.<br>울릉도 오징어축제는 울릉도의 비경을 배경으로 푸른 동해 바다에서 오징어를 잡아보고, 오징어 건조과정을 체험하면서 각종 오징어요리를 즐길 수 있는 행사다.<br>2001년 8월에 처음 개최, 관광객과 주민이 함께 즐길 수 있는 관광축제로 울릉도 오징어축제추진위원회에서 매년 8월중 개최한다.", 
'울릉읍 저동항', NULL, NULL, NULL,NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
763974 , '제16회 장수 한우랑 사과랑 축제' , 20221027 , 20221030 , '전라북도 장수군 장수읍 한누리로 393', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/14/2835514_image2_1.JPG', 127.5180751461, 35.6411181919, 6, 37, 11, '063-350-2355~2357', 
'<a href="http://www.jangsufestival.com/" target="_blank" title="새창: 한우랑사과랑축제 홈페이지로 이동">http://www.jangsufestival.com/</a>', "2022년 전라북도 최우수 축제<br>장수군의 대표 농특산물인 한우, 사과, 토마토, 오미자 등 red컬러를  테마로 한 대한민국의 대표 농특산물 축제인 '장수한우랑사과랑축제'", 
'장수군 의암공원 및 누리파크 일원', NULL, NULL, '입장료 무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
749822 , '부천 소사복숭아축제' , 20220826 , 20220827 , '경기도 부천시 성주로23번길 22', '(송내동)', 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/35/2837135_image2_1.jpg', 126.7604377386, 37.4813297020, 6, 31, 11, '032-625-6033', 
'<a href="http://www.bucheon.go.kr/site/program/board/basicboard/view?menuid=126005001&pagesize=10&boardtypeid=8975&boardid=937991" target="_blank" title="새창:부천시청 홈페이지로 이동">http://www.bucheon.go.kr</a>', "소사복숭아 축제는 복숭아 명산지로 유명했던 소사복숭아의 명성을 살리기 위한 민간주도 시민 참여형 화합의 축제로 1999년부터 개회되고 있는 부천시의 대표적인 지역 축제이다.", 
'부천여자중학교', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
715421 , '밀양 아리랑대축제' , 20220922 , 20220925 , '경상남도 밀양시 중앙로 324', '(내일동)', 'A02070100', 'http://tong.visitkorea.or.kr/cms/resource/00/2689700_image2_1.png', 128.7552590901, 35.4921350361, 6, 36, 7, '055-359-4500', 
'<a href="http://arirang.or.kr" target="_blank" title="새창:밀양아리랑축제 홈페이지로 이동">http://arirang.or.kr</a>', "[축제소개] 아리랑의 선율, 희망의 울림
밀양아리랑대축제는 2012년 유네스코 인류무형문화유산에 등재된 밀양아리랑을 계승, 발전시키기 위해 열리는 축제이다. 1957년 밀양문화제로 시작해 경상남도를 대표하는 향토 축제로 자리매김했으며, 밀양아리랑 경연대회와 아리랑 체험, 각종 전통문화체험 등이 진행된다. 밀양아리랑대축제의 하이라이트, 밀양강 오딧세이는 수천 년을 이어온 밀양의 역사와 밀양아리랑을 결합해 창작한 판타지 뮤지컬로, 눈을 뗄 수 없는 화려한 퍼포먼스와 아름다운 음악, 매력적인 스토리텔링으로 관람객들의 마음을 사로잡는다. 
[축제TIP] 인류무형문화유산이란?
문화다양성의 원천인 무형유산의 중요성에 대한 인식을 고취하고, 무형유산 보호를 위한 국가적, 국제적 협력과 지원을 도모하기 위해서 유네스코에서 지정된 유산을 말한다.", 
'영남루 및 밀양강변 일원, 남천강변로 일원', NULL, NULL, '홈페이지 참고',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
706180 , '서울거리예술축제 2022' , 20220930 , 20221002 , '서울특별시 용산구 양녕로 445', '(이촌동)', 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/35/2850635_image2_1.jpg', 126.9580659298, 37.5177234407, 6, 1, 21, '02-3437-0082', 
'공식 홈페이지-<a href="http://www.ssaf.or.kr/index" target="_blank" title="새창 : 서울거리예술축제">www.ssaf.or.kr</a><br>페이스북-<a href="https://www.facebook.com/%EC%84%9C%EC%9A%B8%EA%B1%B0%EB%A6%AC%EC%98%88%EC%88%A0%EC%B6%95%EC%A0%9C-100255529500711/
" target="_blank" title="새창 : 서울거리예술축제">www.facebook.com/ssaf.official</a>', "서울거리예술축제는 다양한 장르의 예술작품을 서울광장 그리고 노들섬에서 만나볼 수 있는 서울문화재단의 대표 축제이다.<br>많은 시민들이 관람할 수 있는 대형작품, 대중성 있는 작품들과 거리예술, 서커스, 미디어아트, 사운드 등 경계없이 예술적 상상력으로 결합된 다양한 장르의 예술작품 공연을 선보인다.", 
'(서울시청)서울 중구 을지로 12<br>(노들섬)서울 용산구 양녕로 445', NULL, NULL, '무료','전 연령', '한시간 이내');

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
704189 , '하회별신굿탈놀이 상설공연' , 20220101 , 20221231 , '경상북도 안동시 풍천면 하회종가길 3-15', NULL, 'A02080100', NULL, 128.5243722237, 36.5409451627, 6, 35, 11, '054-854-3664', 
'<a href="http://hahoemask.co.kr" target="_blank" title="새창:하회별신굿탈놀이 홈페이지로 이동">http://hahoemask.co.kr</a>', "800여 년 이상의 역사를 지닌 <하회별신굿탈놀이>는 양반, 선비 등의 기득권층과 고려 당시 불교계로 대변되는 특권층, 그외 일반 민중의 생활과 갈등을 꾸밈 없이 드러낸다. 이는 곧, 예로부터 양반이 많았던 안동에서 꾸준히 그 명맥을 이어올 수 있는 이유이자 우리나라 대표 가면극인 '탈놀이'의 특성에서 비롯됨을 알 수 있다. 총 6개 마당으로 이루어진 공연에서는 고려 중기부터 현대를 아우르는 우리 사회의 모순과 지배층의 권위를 날카롭게 풍자한다. 여기에 민중들의 억눌려 있던 답답함과 억울함을 해소해 주는 매개로 기능하여 마을의 평안과 안녕, 나아가 공동체의 결속을 도모한다. 이를 통해 800년의 시대를 뛰어 넘어 현재와 이어지고, 국내를 넘어 세계와 소통하는 축제의 장을 마련한다.", 
'하회마을탈춤공연장', NULL, '[뒷풀이 마당과 포토 타임]<br />
- 공연 후 관객들이 함께 참여할 수 있는 뒷풀이 마당과 사진 촬영 진행<br /><br />
[단체 체험 프로그램(15인 이상 참여 시 유료 진행)]<br />
-  생생 탈춤 따라 배우기, 아카데미, 하회별신굿탈놀이 스토리텔링, 탈 만들기 체험 등', '무료','전 연령 가능', '약 60분');

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
698886 , '토요명품' , 20220108 , 20221224 , '서울특별시 서초구 남부순환로 2364', '(서초동)', 'A02080100', NULL, 127.0097651306, 37.4776567975, 6, 1, 15, '02-580-3300', 
'<a href="https://www.gugak.go.kr/site/program/performance/detail?menuid=001001001&performance_id_main=22117" target="_blank" title="새창: 국립국악원 홈페이지로 이동">http://www.gugak.go.kr </a>', "전통춤과 음악, 노래를 골고루 감상할 수 있는  다채로운 토요상설 무대가 펼쳐진다. 
애호가를 위한 악·가·무 종합프로그램, 청소년, 초보자를 위한 해설이 있는 프로그램, 전문가의 해설이 있는 유네스코 지정 인류무형문화유산 프로그램 등 맞춤형 프로그램들로 마련되어 있다.<br>", 
'국립국악원 우면당', NULL, NULL, 'A석 20,000원 B석 10,000원','8세이상(2015.12.31 이전 출생자)', NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
692682 , '제19회 추억의 광주충장 월드페스티벌' , 20221013 , 20221017 , '광주광역시 동구 서남로 1', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/17/2817317_image2_1.jpg', 126.9231294053, 35.1454973445, 6, 5, 3, '062-608-4681~3', 
'충장축제 홈페이지: <a href="http://www.donggu.kr/cjf" target="_blank" title="새창 :  제19회 광주 추억의 충장축제 2022">http://www.donggu.kr/cjf</a><br> 버스커즈 월드컵 홈페이지: <a href="https://www.buskersworldcup.com/kor/" target="_blank" title="새창 :  제19회 광주 추억의 충장축제 2022">https://www.buskersworldcup.com/kor/</a>', "광주를 대표하는 번화가인 충장로는 오랜 역사와 빠른 변화가 공존하는 독특한 거리이다. 매년 10월, 충장로의 특징을 살린 추억의 충장축제가 열린다. 축제의 가장 큰 볼거리인 ‘충장 월드퍼레이드’에는 광주 13개 동에서 서로 다른 테마로 퍼레이드에 참석하며 경연 퍼레이드, 영화 콘셉트 퍼레이드, 아시아 국가 퍼레이드 등 다양한 퍼레이드가 쉴 새 없이 진행된다. 또한, 70~80년대 충장로의 모습을 그대로 재현한 추억의 테마거리도 조성된다. 옛날 다방에서 차를 마시거나 흑백사진관에서 멋진 흑백사진을 찍는 등 즐거운 레트로 체험이 가능하다.", 
'5․18민주광장, 충장로, 금남로 일원', NULL, NULL, '무료',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
679773 , '난타 (제주)' , 20210101 , 20221231 , '제주특별자치도 제주시 선돌목동길 56-26', '제주특별자치도 제주시 선돌목동길 56-26', 'A02080300', NULL, 126.5479222453, 33.4458561473, 6, 39, 4, '064-723-8878', 
'<a href="https://www.nanta.co.kr:452/kr/show/detail.php?id=3" target="_blank" title="새창 : 난타 (제주)">www.nanta.co.kr</a>', "난타는 한국 전통 가락인 사물놀이 리듬을 소재로, 주방에서 일어나는 일들을 코믹하게 그린 한국 최초의 비언어극이다. 대사를 중심으로 이야기를 전개하는 전통연극에 비해 대사없이 소리와 동작으로 
이루어진 공연형태로 언어장벽을 뛰어넘을 수 있다는 장점을 가지고 있다. &nbsp;따라서, 난타는 국가간, 민족간의 문화적 이질감을 탈피할 수 
있어서, 세계시장으로 진출할 수 있게 되었다. 주방이라는 보편적인 
공간에서 요리라는 친근한 소재에 코믹적 요소를 가미하여, 세대를 뛰어 넘어 누구라도 신명 나고 즐겁게 관람할 수 있는 매력을 가진 작품이다. 
난타는 넓은 세계 시장을 목표로 대사 대신 리듬과 비트 상황만으로 구성한 작품이기 때문에 언어의 장벽으로부터 자유로울 수 있다. &nbsp;그러므로 
난타는 국가와 민족이라는 경계를 뛰어넘어 세계인이 함께 공감할 수 있는 가장 한국적이면서 세계적인 작품이 될 수 있었다. 
<br /><br />가장 한국적인 것이 가장 
세계적인것이다. 우리가 가진 사물놀이라는 전통적인 리듬은 세계적으로 그 독창성을 인정받고 있다. 한국전통리듬을 소재로 하고 있다는 점에서 
세계시장으로 다가갈 수 있는 더없이 좋은 밑거름을 다지게 되었다. 기존의 비언어극들은 
리듬과 비트만으로 구성되어 있어서 단조로움을 주는 경향이 있다. 난타는 이러한 비언어국의 단점을 보완, 가장 보편적인 공간인 '주방'을 무대로 
설정하고, 줄거리에 극적 요소를 가미하여 누구라도 신명나고 즐겁게 관람할 수 있로고 한 작품이다. <br>", 
'제주영상미디어센터 난타공연장', NULL, NULL, '일반 - VIP석  60,000원, S석  50,000원 , A석-40,000원','전체관람가', NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
638241 , '순창장류축제' , 20221014 , 20221016 , '전라북도 순창군 순창읍 민속마을길 6-3', NULL, 'A02070100', 'http://tong.visitkorea.or.kr/cms/resource/97/2689897_image2_1.png', 127.1133178783, 35.3753190513, 6, 37, 7, '063-650-1624', 
'<a href="http://www.jangfestival.co.kr" target="_blank" title="새창:순창장류축제 홈페이지로 이동">http://www.jangfestival.co.kr</a>', "천 년의 장맛을 즐기다<br>전라북도 순창은 한국의 전통소스인 ‘장’으로 유명한 고장이다. 순창에서 매년 가을 한국의 전통장류를 소재로 한 순창장류축제가 열린다. 전통장류를 소재로 한 체험 프로그램과 문화공연, 전시 및 판매 등 약 60여개의 다양한 프로그램들이 진행되며, 순창고추장으로 만든 매콤하고 감칠맛 넘치는 음식들을 맛볼 수 있다. ‘순창고추장 임금님 진상행렬’ 퍼포먼스와 모두 모여 순창고추장을 만드는 체험, 순창 고추장으로 만든 떡볶이를 나눠 먹는 행사 등 순창장류축제만의 특별하고 재미있는 프로그램들도 선보인다. 어른들을 위한 건강힐링체험, 아이들을 위한 다양한 만들기 체험 프로그램이 준비되어 있어 온 가족이 모두 즐거운 시간을 보낼 수 있다.<br><br>[축제TIP] 순창이란?<br>
순창은 천혜의 자연환경과 장류문화의 역사가 살아 숨쉬는 고장으로 대한민국의 대표 먹거리 고추장의 본 고장이기도 하다.", 
'순창전통고추장민속마을', NULL, NULL, '무료(일부체험료)',NULL, NULL);
INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
637693 , '마산국화축제' , 20221028 , 20221109 , '경상남도 창원시 마산합포구 해안대로 180', '(월포동)', 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/27/2757927_image2_1.jpg', 128.5677281079, 35.1916820603, 6, 36, 16, '055-225-2341', 
'<a href="https://www.changwon.go.kr/depart/flower/main.do?mId=1103010000" target="_blank" title="새창 : 마산국화축제">www.changwon.go.kr</a>', "창원(옛 마산지역)은 우리나라 국화재배의 역사가 담긴 곳으로 1961년 회원동 일대에서 여섯농가가 전국 최초로 국화 상업재배를 시작한 이후 비약적인 발전을 거듭하다가 1972년 국내 처음으로 일본에 수출을 하였다. 현재 전국 재배면적의 13%를 차지하고 있으며 연간 40만불의 외화를 획득하는 등 자타가 인정하는 우리나라 국화산업의 메카이다.<br>국화재배에 알맞은 토질과 온화한 기후, 첨단 양액재배 기술보급 등으로 뛰어난 품질을 자랑하는 마산국화의 우수성을 국내외에 홍보하고 국화소비 촉진을 위해 2000년부터 마산국화축제를 개최하게 되었다.", 
'마산해양신도시', NULL, NULL, '무료','전연령 가능', '기간내자유');
INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
637546 , '익산 서동축제' , 20221001 , 20221003 , '전라북도 익산시 금마면 고도9길 41-14', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/27/2825127_image2_1.jpg', 127.0604063368, 36.0019413977, 6, 37, 9, '063-843-8817', 
'<a href="http://seodong.iksan.go.kr" target="_blank" title="새창:익산 서동축제 홈페이지로 이동">http://seodong.iksan.go.kr</a>', "익산은 서동설화와 서동요가 살아있는 천년고도 백제왕도(王都)로 서동요를 통해 선화공주의 사랑을 얻고 마침내 백제 30대무왕으로 등극해서 삼국통일의 웅지를 펼치려 했던 서동의 탄생지이다. 익산서동축제는 1400년 전 익산에서 태어난 백제의 서동(무왕)과 적국이었던 신라 선화공주와의 국경을 초월한 사랑을 이야기한 역사문화축제로서 1969년 마한민속제전에서 출발하였으며 2004년 익산서동축제로 축제명이 변경되어 매년 개최되고 있다.", 
'금마서동공원', NULL, NULL, '무료','전연령 가능함', '기간내 자유');
INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
631257 , '전주비빔밥축제' , 20221006 , 20221010 , '전라북도 전주시 완산구 향교길 139', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/69/2852069_image2_1.jpg', 127.1565360613, 35.8129451491, 6, 37, 12, '063-283-1141', 
'<a href="https://www.instagram.com/bibimbap_festival/" target="_blank" title="새창 : 전주비빔밥축제">www.instagram.com/</a>', "전주비빔밥축제가 올해는 진정한 맛의 축제로 거듭난다. 전주음식의 다채로움, 맛의 즐거움, 맛의 철학, 맛의 여운을 모두 즐길 수 있는 음식축제다. 맛의 축제에 직접 참여해보자!", 
'전주한옥마을 향교길 일대', NULL, NULL, '무료(일부 유료)','전연령가능', '기간내자유');
INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
630793 , 'KYMF 대한민국청소년미디어대전' , 20221027 , 20221029 , '서울특별시 용산구 한강대로 255', '(갈월동)', 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/75/2719675_image2_1.png', 126.9726361655, 37.5410515470, 6, 1, 24, '02-795-8000(내선2번)', 
'<a href="https://kymf.ssro.net" target="_blank" title="새창: 행사 홈페이지로 이동">https://kymf.ssro.net</a>', "대한민국청소년미디어대전(이하 KYMF)은 2001년부터 시작하여 22년 역사를 자랑하는 국내 최대 규모의 청소년 미디어 축제이다. 2022년에는 '미 OR 추'라는 특별주제로 10월 27일~10월 29일 3일 간 온·오프라인으로 진행된다.", 
'서울시청', NULL, NULL, '무료',NULL, NULL);
INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
630131 , '렛츠락페스티벌' , 20220924 , 20220925 , '서울특별시 마포구 한강난지로 162', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/09/2839909_image2_1.jpg', 126.8820576461, 37.5645888576, 6, 1, 13, NULL, 
'<a href="http://letsrock.co.kr" target="_blank" title="새창:렛츠락페스티벌 홈페이지로 이동">http://letsrock.co.kr</a>', "렛츠락 페스티벌은 2007년 고려대학교 녹지운동장에서 처음 시작되어 2008년 올림픽공원 잔디마당, 2009년 용산 전쟁기념관에서 진행되었으며 2010년 4회째부터는 난지한강공원에서 렛츠락을 이어오고 있다. 도심 속에서 즐길 수 있는 도심형 최대의 페스티벌인 렛츠락페스티벌은 여름의 끝자락에서 가을의 시작을 알리며 다양한 아티스트의 무대, 볼거리, 먹거리, 즐길거리를 관객과 함께 하고 있다.", 
'난지한강공원 일대', NULL, NULL, '홈페이지 참고','전체관람가', NULL);
INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
629718 , '광주 왕실도자기축제' , 20220826 , 20220828 , '경기도 광주시 곤지암읍 경충대로 727', NULL, 'A02070200', NULL, 127.3266121626, 37.3510216352, 6, 31, 5, '031-760-1714', 
'<a href="https://royalfestival.kr/" target="_blank" title="새창:광주왕실도자기축제 홈페이지로 이동">https://royalfestival.kr/</a>', "조선시대 왕실도자기 생산지인 경기도 광주에서는 매년 <광주왕실도자기 축제>가 개최된다. 광주왕실도자기 축제는 1998년부터 시작되었다. 제 25회 광주왕실도자기축제가 2022년8월26일부터 28일까지 곤지암도자공원 일원에서 개최될 예정이다.", 
'곤지암도자공원 일대', NULL, NULL, '무료',NULL, NULL);
INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
622888 , '한국국제아트페어' , 20220903 , 20220906 , '서울특별시 강남구 영동대로 513', '(삼성동)', 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/99/565999_image2_1.jpg', 127.0591318945, 37.5118092746, 6, 1, 1, '02-733-3706', 
'<a href="http://www.kiaf.org" target="_blank" title="새창:한국국제아트페어 홈페이지로 이동">http://www.kiaf.org</a>', "Kiaf SEOUL은 2002년 처음 문을 연 한국 최초의 국제아트페어이다. 전세계 갤러리들이 참가하는 Kiaf SEOUL은 글로벌 아트 시티인 서울을 중심으로 빠르게 성장하고 있다. Kiaf SEOUL은 2022년부터 규모를 확대하고 있으며 새롭게 런칭하는 Kiaf PLUS를 통해 현대미술은 물론이고 NFT 아트, 뉴미디어아트 등 다양한 장르의 작품을 소개합니다. Kiaf SEOUL과 Kiaf PLUS는 아시아를 넘어 글로벌 아트 마켓을 주도하며 세계 미술인의 축제가 될 것이다.", 
'서울 강남구 코엑스(COEX)', NULL, NULL, '홈페이지확인',NULL, NULL);
INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
621109 , '제18회 2022 문경오미자축제' , 20220916 , 20220918 , '경상북도 문경시 문경읍 문경대로 2426', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/32/2852732_image2_1.jpg', 128.0826336405, 36.7420889505, 6, 35, 7, '054-571-7677', 
'<a href="http://mg5mija.or.kr/" target="_blank" title="새창:문경오미자축제 홈페이지로 이동">http://mg5mija.or.kr</a>', "100세 청춘! 전국 최고 명품 오미자, 문경오미자!<br>문경오미자는 백두대간의 중심이면서 우리나라 최대 오미자 생산지인 황장산과 대미산의 오미자를 옮겨와 해발고 300m~700m의 준고랭지 청정환경에서 친환경농법으로 생산하고 있으며 전국 유일의 [오미자 산업 특구]로 지정되어 연간 1,500톤 생산으로 전국 오미자의 45%를 차지하는 제1주산지로서 세계적인 오미자 산업의 메카로 자리매김하고 있다.", 
'경상북도 문경시 동로면 금천둔치 일원', NULL, NULL, '무료',NULL, NULL);
INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
615807 , '안성맞춤 포도축제' , 20220923 , 20220925 , '경기도 안성시 서운면 서운중앙길 23', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/48/1691048_image2_1.jpg', 127.2592519417, 36.9430869936, 6, 31, 16, '031-678-3732', 
'<a href="https://www.anseong.go.kr/tour/contents.do?mId=0200000000" target="_blank" title="새창: 안성맞춤포도축제 홈페이지로 이동">https://www.anseong.go.kr/tour</a>', "안성맞춤 포도축제가 열리는 포도박물관은 뒤로 서운산이 병풍처럼 서있고 시간과 세월이 산기슭을 타고 바람이 되어 내려와 머무는 곳마다 포도향기가 가득한곳이다. 포도가지마다 탐스럽게 열릴 기억의 선물을 생각하자면 벌써부터 잠을 설칠것이다. 마을 전체가 포도밭이라 해도 과언이 아닌 포도의 고장 서운면, 각종 체험과 공연 등으로 구성 될 이번 축제는 110년 역사가 자랑하듯 명실공히 안성맞춤이 될 것이다.", 
'서운면사무소', NULL, NULL, NULL,'전연령 가능함', '기간내자유');
INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
613316 , '청원생명축제' , 20220930 , 20221010 , '충청북도 청주시 청원구 오창읍 미래지로 99', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/63/2821263_image2_1.jpg', 127.4073833117, 36.7332499090, 6, 33, 10, '043-201-0253', 
'<a href="http://cw-life-festival.co.kr/" target="_blank" title="새창: 홈페이지로 이동">http://cw-life-festival.co.kr/a>', "청원생명축제는 2008년부터 친환경을 테마로 구성된 대표적인 축제이다.<br>순수자연으로 더욱 빛나는 명품농산물인 청원생명브랜드를 홍보하고, 테마가 있는 전시와 다양한 체험행사 및 문화공연을 통해 관람객의 다양한 볼거리를 제공하며, 자라나는 학생들에게는 농업의 현재와 미래, 다양한 문화를 느낄 수 있는 교육의 장을 마련하고자 노력하고 있다.", 
'미래지농촌테마공원', NULL, NULL, '입장권- 성인 5,000원, 어린이 1,000원<br>(입장권은 축제장 내에서 현금처럼 전액 활용)',NULL, NULL);
INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
607417 , '2022 명량대첩축제' , 20220930 , 20221002 , '전라남도 해남군 문내면 관광레저로 12-36', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/67/2851167_image2_1.jpg', 126.3116750901, 34.5740849043, 6, 38, 23, '061-286-5265', 
'<a href="http://www.mldc.kr" target="_blank" title="새창:명량대첩축제 홈페이지로 이동">http://www.mldc.kr</a>', "- 주    제 : 2022 울돌목 페스타(부제 : 명량, 빛을 품다)<br>- 기간/장소 : ’22. 9. 30.(금) ~ 10. 2.(일) / 해남․진도군 울돌목 일원<br>- 주요내용 : 야간 개막식, 미디어 해전재현, 주민참여 프로그램 등 <br>(해전재현) 울돌목 현장배경을 담은 대형스크린(20m*6m) 활용 미디어 해전 구현<br>(드론쇼) 밤바다 위에서 불꽃을 장착한 300여대 드론으로 당시 병법 일자진 재현<br>(미디어아트) 밤의 꽃길․이순신동상․판옥선 등 야간 라이팅, 아트놈 작가 작품 설치 등<br>(특별이벤트) 이날치밴드 공연, 영화 “명랑”, “한산”  김한민 감독 토크콘서트 등", 
'울돌목 일원(진도 녹진관광지, 해남 우수영관광지)', NULL, NULL, '무료',NULL, NULL);
INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
606549 , '동강국제사진제' , 20220722 , 20221009 , '강원도 영월군 영월읍 영월로 1909-10', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/60/2826360_image2_1.jpg', 128.4615147283, 37.1819788343, 6, 32, 8, '033-375-4554', 
'<a href="http://www.dgphotofestival.com" target="_blank" title="새창:동강국제사진제 홈페이지로 이동">http://www.dgphotofestival.com</a>', "올해로 20회를 맞이하는 동강국제사진제는 국내외 사진작가와 강원도 영월군 지역민, 사진 애호가들이 함께 만들어 가는 대한민국 대표 사진 축제로2022.07.22(금)-2022.10.09(일)까지 개최된다. 특히 <동강사진상 수상자전>에서는 올해의 동강사진상 수상자 김녕만 작가의 작품들, <국제 주제전>에서는 그룹 f.64의 오리지널 프린트 130여점, 74개국이 출품한 <국제공모전>에 선정된 올해의 작가 팀 스미스외 18명의 작품도 만나 볼 수 있다. 이외에도 <강원도사진가전>, <보도사진가전>, <거리설치전>, <영월군민사진전>, <전국 초등학교 사진일기 공모전>, <평생교육원사진전>, <영월스토리텔링전><아카이브 전시> 등 전 세계 사진인들이 기다리는 연례행사인 만큼 다채로운 전시가 아름다운 강원도 영월군 일대에서 진행된다. *자세한 사항과 지난 축제가 궁금하다면 공식 홈페이지(<a href=\"http://www.dgphotofestival.com\" target=\"_blank\" title=\"새창 : 동강국제사진제\">www.dgphotofestival.com</a>)를 방문하길 바란다.", 
'동강사진박물관, 동강사진박물관 주변 야외 전시장, 영월문화센터, 영월문화예술회관, 영월군청소년수련관, 영월 일원', NULL, NULL, '어른 3,000원, 청소년/군인 1,500원, 어린이 1,000원<br>단체(20인 이상) 어른 2,000원 청소년/군인 1,000원, 어린이 800원<br>* 미취학 아동, 65세 이상은 무료<br>* 영월군민은 50% 할인',NULL, NULL);
INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
604454 , '제49회고창모양성제' , 20220930 , 20221004 , '전라북도 고창군 고창읍 모양성로 1', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/94/2848494_image2_1.jpg', 126.7042193959, 35.4315946094, 6, 37, 1, '063-562-2999', 
'<a href="http://www.gochang.go.kr/tour/index.gochang?menuCd=DOM_000000403004001000" target="_blank" title="새창:고창모양성제 홈페이지로 이동">http://www.gochang.go.kr</a>', "고창모양성제는 유비무환 정신으로 축성한 뜻깊은 조상의 애국심을 고취시키고 향토문화를 계승 발전시키며, 고창군민의 긍지와 애향심을 높이기 위해 1973년부터 열리고 있다.주요행사로 축제행사와 기념식이 열리고, 문예행사로는 판소리공연, 농악놀이 등이, 민속놀이로는 답성놀이.활쏘기 등이 열리며 다채로운 체육대회도 열리고 있다. 성을 밟으면 무병장수하고 극락승천한다는 전설 때문에 매년 답성놀이가 계속되고 있으며, 성밟기는 저승문이 열리는 윤달에 밟아야 효험이 있다고 하며 같은 윤달이라도 3월 윤달이 제일 좋다고 한다. 성을 한바퀴 돌면 다리병이 낫고, 두바퀴 돌면 무병장수하며, 세바퀴 돌면 극락승천한다고 한다. 성을 돌 때는 반드시 손바닥만한 돌을 머리에 이고 세 번 돌아야 하며 성입구에 그돌을 쌓아 두도록 하였다. 이는 돌을 머리에 임으로써 체중을 가중시켜 성을 더욱 다지게 하려는 의도에서 비롯된 것으로 잘 알려져 있다.모양성은 조선 단종 원년(1453년) 왜침을 막기 위해 전라도민들이 유비무환의 슬기로 축성한 자연식 성곽으로 고창읍성이라 불리는데 호남 내륙을 방어하는 전초기지로서의 역할을 하고 있으며, 고창군민의 날 행사를 ‘모양성제’ 라 부른다.", 
'고창읍성(모양성)및 읍 시가지 일원', NULL, NULL, '무료',NULL, NULL);
INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
604144 , '제19회 자라섬재즈페스티벌' , 20221001 , 20221003 , '경기도 가평군 가평읍 달전리 1-1', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/76/2844176_image2_1.jpg', 127.5354271394, 37.8104943540, 6, 31, 1, '031-581-2813~4', 
'홈페이지 <a href="http://www.jarasumjazz.com/" target="_blank" title="새창 :  자라섬재즈페스티벌">www.jarasumjazz.com</a><br>인스타그램 <a href="https://www.instagram.com/jarasumjazzfestival/" target="_blank" title="새창 : 자라섬재즈페스티벌">www.instagram.com</a>', "올해로 19회를 맞이한 자라섬재즈페스티벌은 57개국 약 1200개 팀의 아티스트가 다녀간 아시아 대표 재즈페스티벌이다. 매년 10월이면 축제의 섬으로 변모하는 경기도 가평 자라섬에서 자연, 가족, 휴식 그리고 음악을 모토로 '온 세대가 함께 즐길 수 있는 소풍 같은 축제'를 선보이고 있다.<br><br>스윙, 퓨전, 보사노바, 비밥, 월드뮤직 등 수많은 하위 카테고리로 나뉘어지는 재즈는 모든 장르를 수용할 수 있는 특이한 음악이다. 19년 동안 재즈의 이름으로 묶일 수 있는 무수한 음악들을 국내에 소개하며 한국 음악 생태계의 다양화를 꾀했던 자라섬재즈페스티벌이 올해는 주빈국 스페인을 비롯해 남아메리카, 북아메리카, 아시아 등의 아티스트들을 선보인다. 최종 라인업에 이름을 올린 재즈미어 혼, 은두두조 마카티니 등과 더불어 1차 라인업으로 공개되어 많은 호응을 얻었던 조이 알렉산더, 아비샤이 코헨, 김현철, 하드피아노 등 실력있는 아티스트들로 ' 믿고 듣는 자라섬재즈' 라인업을 완성했다. 최정상급 재즈 공연뿐만 아니라 다양한 볼거리, 즐길거리, 먹거리가 가득한 자라섬재즈페스티벌은 10월 1일부터 경기도 가평 자라섬, 가평 읍내 일대에서 개최된다. 일반티켓, 반려견 동반좌석, 캠핑패키지는 투어비스에서 구매할 수 있다.", 
'경기도 가평군 자라섬, 가평읍 일대', NULL, NULL, '일반<br>3일권 120,000원<br>2일권 100,000원<br>1일권 60,000원<br><br>청소년 <br>1일권 40,000원<br><br>장애인, 65세 이상<br>1일권 30,000원<br><br>반려견 동반좌석<br>1일권 60,000원',NULL, NULL);
INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
590116 , '햇사레장호원복숭아축제' , 20220916 , 20220918 , '경기도 이천시 장호원읍 서동대로8759번길 117', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/53/2025253_image2_1.JPG', 127.6122679664, 37.1178509997, 6, 31, 26, '031-643-0040', 
'<a href="http://www.peachfestival.co.kr" target="_blank" title="새창:햇사레 장호원 복숭아축제 홈페이지로 이동">http://www.peachfestival.co.kr</a>', "햇사레 복숭아와 함께 발전하여온 장호원의 역사를 조명하고 앞으로 발전할 장호원 황도의 위상과 그 아름다운 맛을 전국의 소비자에게 알리고 다양한 문화 체험과 축제 프로그램을 통한 복숭아의 홍보를 통하여 지역민의 자긍심은 물론 농업인의 소득 창출을 목표로 하여 함께 어우러지는 축제로 구성하고자 한다.", 
'장호원농산물유통센터 복숭아축제장', NULL, NULL, NULL,'전연령 가능함', '기간내 자유');
INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
589386 , '부천국제만화축제' , 20220930 , 20221003 , '경기도 부천시 길주로 1', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/89/2852389_image2_1.jpg', 126.7422053159, 37.5082512500, 6, 31, 11, '032-310-3073', 
'홈페이지: <a href="https://www.bicof.com/" target="_blank" title="새창 : 부천국제만화축제">https://www.bicof.com</a><br>인스타그램: <a href="https://www.instagram.com/bicof_official" target="_blank" title="새창 : 부천국제만화축제">https://www.instagram.com</a><br>유튜브: <a href="https://www.youtube.com/channel/UCcMqhLUStnwZUab4_e4REbg" target="_blank" title="새창 : 부천국제만화축제">https://www.youtube.com</a>', "아시아 최고의 글로벌 만화축제, 부천국제만화축제(BICOF)! 관람객 12만 명, 만화가 및 관계자 1천여 명, 국내외 코스튬플레이어 5천여 명이 참여한다.<br>대한민국 최고 만화상 '부천만화대상'을 중심으로 한 만화전시를 비롯해 만화콘서트, 국제 코스프레 챔피언십, 만화마켓, 참여이벤트 등 화려한 볼거리, 다채로운 즐길거리를 자랑한다. 가족, 연인, 친구와 함께 남녀노소 즐길 수 있는 이색적인 만화축제.", 
'한국만화박물관 일대', NULL, NULL, '유료(5,000원)',NULL, NULL);
INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
574969 , '2022 전주세계소리축제' , 20220916 , 20220925 , '전라북도 전주시 덕진구 소리로 31 소리문화전당', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/70/2825770_image2_1.jpg', 127.1390309872, 35.8540707211, 6, 37, 12, '063-232-8394', 
'<a href="http://www.sorifestival.com/" target="_blank" title="새창: 전주세계소리축제 홈페이지로 이동">http://www.sorifestival.com/</a>', "전주세계소리축제는 판소리와 전통음악, 월드뮤직을 중심으로 다양한 장르의 음악을 아우르는 공연예술축제로 해마다 가을에 열린다. 2022년은 스물 첫해로 새로운 음악적 실험을 통한 더욱 깊어진 공연들을 만날 수 있겠다.", 
'한국소리문화의전당', NULL, NULL, '유/무료 (공연마다 상이함)',NULL, NULL);
INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
574285 , '제24회 김제지평선축제' , 20220929 , 20221003 , '전라북도 김제시 벽골제로 442', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/15/2689815_image2_1.png', 126.8522869016, 35.7540632714, 6, 37, 3, '063)540-3035~3038', 
'<a href="http://www.gimje.go.kr/festival/index.gimje" target="_blank" title="새창: 김제지평선축제 홈페이지로 이동">http://www.gimje.go.kr/festival/index.gimje</a>', "전라북도 김제는 한국 최대의 곡창지대인 호남평야의 중심에 위치한 고장이다. 물, 공기, 토양이 좋아 쌀이 맛있기로 유명한 축복받은 고장이며, 특히 한국에서 유일하게 지평선을 감상할 수 있는 곳으로 알려져 있다. 김제에서는 매년 가을, 호남평야의 들판이 황금빛으로 물들 때 하늘과 땅이 만나는 황금물결 지평선의 배경을 테마로 김제 지평선축제를 열고 있다.
축제가 열리는 드넓은 들판 한가운데에는 볏짚으로 만들어진 거대한 쌍룡 조형물이 방문객들을 반겨준다. 넓은 축제장 이곳 저곳을 돌아다니며 벼베기, 탈곡하기, 수확하기, 아궁이에 밥짓기 등 농사와 관련된 다양한 체험을 즐길 수 있다. 또한, 메뚜기 잡기, 소 달구지 타기, 연날리기 등 도시생활에 익숙한 방문자들이 신선한 재미를 느낄 수 있는 체험프로그램도 마련되어 있다. 김제의 농산물로 만든 맛있는 먹거리들을 맛볼 수 있는 먹거리장터도 열린다.", 
'전북 김제시 벽골제', NULL, NULL, '무료','전연령 가능함', '기간내자유');
INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
573459 , '제34회 춘천인형극제' , 20220401 , 20221231 , '강원도 춘천시 영서로 3017', '(사농동)', 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/68/2818868_image2_1.jpg', 127.7202320249, 37.9216376309, 6, 32, 13, '033-242-8452', 
'<a href="http://www.cocobau.com/" title="새창: 춘천인형극제로 이동" target="_blank">www.cocobau.com</a>', "올해로 34회째를 맞이하는 '춘천인형극제'는 다양한 인형극 문화예술프로그램을 제공하며, 인형극 장르의 확산과 발전을 위해 다양하고 구체적인 분산개최형 문화예술축제를 개최한다.<br>올해는 국내뿐만 아니라 세계 각국의 인형극단들이 참가하는 아시아 최대 인형극 축제로 진행되며 1년 내내 춘천인형극장과 춘천시 일대 곳곳에서 개성 넘치는 4계절 축제로 찾아갈 예정이다.", 
'춘천인형극장 및 춘천시 일대', NULL, NULL, '축제별 상이',NULL, NULL);
INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
563458 , '함양 산삼축제' , 20220902 , 20220911 , '경상남도 함양군 함양읍 필봉산길 49', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/48/2590448_image2_1.JPG', 127.7218713327, 35.5237239599, 6, 36, 20, '055-964-3353', 
'<a href="http://sansamfestival.hygn.go.kr/" target="_blank" title="새창:함양 산삼축제 홈페이지로 이동">http://sansamfestival.hygn.go.kr/</a>', "22년 9월 2일부터 11일까지 약 10일간 천년의 신비가 살아 숨 쉬는 함양 상림공원에서 산삼축제가 개최된다.
잊혀가는 산삼과 심마니의 역사·문화 등을 계승할 수 있는 콘텐츠를 활용한 축제 프로그램 운영으로 산삼의 의미와 역사적 가치를 재조명하고, 군의 대표 브랜드인 청정 임산물 산삼의 이미지를 활용하여 지역 농특산물의 판로를 확대할 예정이다.", 
'함양 상림공원 일원', NULL, NULL, NULL,NULL, NULL);
INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
553315 , '여수 거북선축제' , 20220930 , 20221002 , '전라남도 여수시 이순신광장로 146', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/46/2827646_image2_1.png', 127.7397262519, 34.7373266625, 6, 38, 13, '061-664-5400', 
'<a href="http://www.jinnamje.com" target="_blank" title="새창: 여수거북선축제 페이지로 이동">http://www.jinnamje.com</a>', "매년 5월. 진남제라는 호국문화제전을 통해 임진왜란을 승리로 이끌었던 이순신 장군의 구국정신 선양과 호국 충절을 기리던 것이 여수거북선축제의 시작으로, 여수거북선대축제는 한때 전국 10대 향토축제 중의 하나로 꼽히던 진남제를 현대적으로 변모시킨 행사다. 축제는 매년 5월 4일을 전후하여 개최되고 있는데, 그 이유는 이순신 장군이 구국의 영남을 구하기 위해 첫 출정을 했던 1592년 5월 4일을 기념하기 위함이다. 제56회를 맞은 이번 축제는 코로나19 상황으로 인해 오는 해는 7월에 개최된다. 여수세계박람회장에서 개최될 예정이며, 통제영길놀이와 용줄다리기, 임진왜란유적지 순례 등 다양한 온·오프라인 프로그램이 준비된다.", 
'여수 종포해양공원', NULL, NULL, '무료','전연령 가능함', '기간내자유');
INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
534220 , '연천 구석기축제' , 20221007 , 20221010 , '경기도 연천군 전곡읍 양연로 1510', NULL, 'A02070100', 'http://tong.visitkorea.or.kr/cms/resource/98/2689798_image2_1.png', 127.0611506837, 38.0122815870, 6, 31, 21, '031-839-2378', 
'<a href="https://www.yeoncheon.go.kr/festival/contents.do?key=4049" target="_blank" title="새창 :  연천 구석기 축제">www.yeoncheon.go.kr</a>', "한반도 최초의 인류가 살았던 연천 전곡리 유적에서 펼쳐지는 구석기체험 축제이다.<br>연천 전곡리 유적은 30만년전에 우리나라에 매우 똑똑한 구석기 사람들이 살았다는 증거인 주먹도끼가 발견된 세계적인 유적이다.<br>매년 한차례 전세계의 선사문화체험이 연천 전곡리로 모여 원시체험의 장을 열고 현대인을 초대한다.<br>연천 전곡리 유적의 역사적 가치를 바탕으로 문화와 대중의 조화, 지역의 브랜드 개발, 적극적인 보존을 위한 유적의 활용에 축제의 의의가 있다.", 
'연천 전곡리 유적 일원', NULL, NULL, '홈페이지 참조',NULL, NULL);
INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
527710 , '2022년 제36회 이천도자기축제' , 20220902 , 20221003 , '경기도 이천시 신둔면 도자예술로5번길 109', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/38/2536038_image2_1.jpg', 127.3857028989, 37.2931488494, 6, 31, 26, '070-4914-4312', 
'<a href="http://www.ceramic.or.kr" target="_blank" title="새창:이천 도자기축제 홈페이지로 이동">http://www.ceramic.or.kr</a><br><a href="https://www.artic.or.kr/base/main/view" target="_blank" title="새창 : 이천도자기축제">www.artic.or.kr</a>', "이천의 대표 축제, 이천도자기축제가 3년 만에 다시 열린다!<br>2022년 9월 2일부터 10월 3일까지 주말과 공휴일 14일간 '일상을 예술하는 이천'을 슬로건으로 다양한 프로그램이 펼쳐질 예정이다.<br>코로나19 이후 3년 만에 여러분 곁을 찾아 온 이천도자기축제에서 온 가족이 함께 도자체험을 즐겨보자.<br>자세한 사항은 이천도자기축제 또는 이천문화재단 홈페이지를 확인바란다.", 
'이천도자예술마을 예스파크', NULL, NULL, '무료',NULL, NULL);
INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
513291 , '광화문국제아트페스티벌' , 20221102 , 20221115 , '서울특별시 종로구 세종대로 175', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/90/2037790_image2_1.jpg', 126.9768376800, 37.5721757834, 6, 1, 23, '02-723-9484~7', 
'<a href="http://www.giaf.or.kr/" target="_blank" title="새창:광화문국제아트페스티벌 사이트로 이동">http://www.giaf.or.kr</a>', "광화문 광장은 대한민국의 역사적 현장 속에서 민주화의 상징과도 같은 존재이다. 시민들의 적극적인 권리행사나 소통의 광장으로 자리매김 해오며, 월드컵이 열리고 시민들의 자발적 거리응원이 축제의 장으로 발전하면서 더욱 광장으로서의 역할에 충실할 수 있었다.  역사 속의 유산이 아닌 국민이 함께 참여하는 문화공간으로써, 나아가 세계 속의 광장으로 그 존재를 알리고 있다.<br><br><광화문국제아트페스티벌>은 시민 문화축제로서 전시 활성화의 취지에 걸맞은 다양할 부대행사를 개최하여왔다. 매 회 행사마다 미술인 및 시민의 참여도를 위해 다양한 퍼포먼스를 시도해 왔으며 전시관람에만 국한하지 않고 다양한 볼거리를 제공하는데 만전을 기하였다. 체험부스에는 색칠심리, 도자체험, 은공예, 가죽공예 등 다양한 체험 및 아트 상품으로 전시의 질을 더욱 풍성하게 한다.", 
'세종문화회관 미술관, 광화문 광장', NULL, NULL, '무료',NULL, NULL);
INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
507531 , '제 22회 한성백제문화제' , 20220930 , 20221002 , '서울특별시 송파구 올림픽로 326 송파구청', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/72/2819172_image2_1.JPG', 127.1066830358, 37.5148625533, 6, 1, 18, '02-2147-2800', 
'<a href="https://www.songpa.go.kr/hanseong/" target="_blank" title="새창: 홈페이지로 이동">http://www.songpa.go.kr</a>', "백제한성시대부터 88서울올림픽 개최, 그리고 현재에 이르기까지 송파구의 위대한 문화유산을 토대로 축제를 구현함으로써 구민에게 희망의 메시지를 전달하고 세계적인 축제로 도약", 
'올림픽공원(평화의 문 광장)', NULL, NULL, '무료',NULL, NULL);
INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
506935 , '천안흥타령춤축제 2022 Cheonan World Dance Festival 2022' , 20220921 , 20220925 , '충청남도 천안시 서북구 번영로 208 종합운동장', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/60/2810360_image2_1.jpg', 127.1114686823, 36.8194930438, 6, 34, 12, '041-900-7397', 
'<a href="http://cheonanfestival.com" target="_blank" title="새창:천안 흥타령춤축제 홈페이지로 이동">http://cheonanfestival.com</a><br><a href="https://www.facebook.com/cheonanfestival" target="_blank" title="새창:천안 흥타령춤축제 홈페이지로 이동">https://www.facebook.com/cheonanfestival</a><br><a href="https://www.instagram.com/cheonanfestival/" target="_blank" title="새창:천안 흥타령춤축제 홈페이지로 이동">https://www.instagram.com/cheonanfestival/</a><br><a href="https://www.youtube.com/cheonanfestival" target="_blank" title="새창:천안 흥타령춤축제 홈페이지로 이동">https://www.youtube.com/cheonanfestival</a>', "2003년 처음으로 개최되어 올해로 18회를 맞이하는 천안흥타령춤축제는 문화체육관광부로부터 6년 연속 지역대표공연예술제로 선정되었으며, 2020년부터 문화체육관광부 지정 <명예 문화관광축제>로 선정되었다.<br>대한민국을 대표하는 국제적인 대표 춤축제로서, 매년 120만 명이 넘는 국내·외 관광객이 방문하고 있다. 오는 9월 21일부터 9월 25일까지 온·오프라인으로 펼쳐지는 '천안흥타령춤축제 2022' 에서는 코로나19 방역지침을 준수하며 국내 최고의 춤꾼들이 모여 다채로운 경합을 벌일 예정이다.", 
'천안종합운동장 및 천안시 일원', NULL, NULL, '무료',NULL, NULL);
INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
506926 , '진주 남강유등축제' , 20221010 , 20221031 , '경상남도 진주시 남강로 626', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/12/2828012_image2_1.jpg', 128.0802763856, 35.1897457534, 6, 36, 13, '055-749-8588', 
'<a href="http://www.yudeung.com" target="_blank" title="새창:진주 남강유등축제 홈페이지로 이동">http://www.yudeung.com</a>', "가을밤을 아름답게 수놓는, 진주대첩의 역사와 함께 이어져온 유등축제<br>진주남강유등축제는 특별한 역사와 함께 이어져 내려오는 빛축제이다. 임진왜란 당시 벌어진 진주성 전투에서 적군이 강을 건너려고 하자 강물 위에 유등(기름으로 켜는 등불)을 띄워서 이를 저지했다고 한다. 진주남강유등축제에서는 유등띄우기의 전통을 이어받아 등을 활용한 다채로운 전시와 체험을 진행하고 있다.<br>낮에도 다양한 체험프로그램을 운영하지만, 해가 지기 시작할 무렵 등불이 켜지면서 본격적으로 축제가 진행된다. 남강의 잔잔한 물결 위해 용, 봉황, 거북이, 연꽃 등 다양한 모양의 수상등이 전시되며 수상 불꽃놀이와 워터라이팅쇼 등이 펼쳐져 화려한 볼거리리가 제공된다. 그 중 각자의 소망을 적은 등을 남강에 직접 띄워 보내는 유등띄우기 체험은 축제의 하이라이트라 할 수 있다. 저마다의 소망이 담긴 유등이 하나 둘 모여 별처럼 반짝이는 풍경은 가슴을 뭉클하게 한다. <br><br> [축제TIP] 진주대첩이란?<br>진주대첩은 임진왜란이 한창인 1592년 10월, 충무공 김시민장군이 이끄는 3,800여 명의 병사들과 진주성의 백성들이 2만이 넘는 적군을 크게 무찔렀던 전투이다.", 
'진주성 및 남강 일원(하천, 사적지)', NULL, NULL, '입장료 무료(개별 프로그램 이용료 부과)','전연령가능', '3~4시간');
INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
506895 , '정선아리랑제' , 20220915 , 20220918 , '강원도 정선군 정선읍 봉양리', NULL, 'A02070100', NULL, 128.6659266756, 37.3772519016, 6, 32, 11, '033-560-3000', 
'<a href="http://www.arirangfestival.kr/" target="_blank" title="새창:정선아리랑제 홈페이지로 이동">http://www.arirangfestival.kr</a>', "제47회 정선아리랑제가 ‘보고싶다 정선아! 정선아리랑’을 주제로 2년 만에 새롭게 단장하여 강원도 정선에서 4일간 성대하게 개최된다. 정선아리랑제의 시작을 알리는 칠현제례부터 ‘아리랑을 담다’개막식 주제공연과 다양한 장르의 화려한 퍼포먼스로 구성된 아리랑 퍼레이드, 전국 아리랑경창대회 및 전국최초로 열리는 아리랑과 K-POP이 만난 A-POP경연대회 등 전통문화의 대향연에 여러분을 초대한다.", 
'정선공설운동장 일대', NULL, NULL, NULL,NULL, NULL);
INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
506809 , '제22회 소래포구 축제' , 20221001 , 20221003 , '인천광역시 남동구 장도로 86-17', '(논현동)', 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/56/2852356_image2_1.jpeg', 126.7393253184, 37.3979806750, 6, 2, 4, '032-453-2142', 
'홈페이지 <a href="https://www.namdong.go.kr/soraefestival" target="_blank" title="새창 : 제22회 소래포구축제">https://www.namdong.go.kr</a><br>공식블로그 <a href="http://blog.naver.com/soraefestival" target="_blank" title="새창 : 제22회 소래포구축제">http://blog.naver.com</a>', "수도권 대표의 해양생태축제인 소래포구축제가 10월 1일부터 3일까지 3일간 개최된다. 제22회 소래포구축제는 소래포구 수산물 체험행사 및 다양한 문화공연, 참여이벤트 등 풍부한 볼거리와 먹거리를 관광객에게 선사할 예정이며, 올해 성공적인 개최를 통해 문화관광축제로의 도약을 목표로 하고 있다. 소래포구축제의 대표행사인 꽃게 잡기체험, 수산물을 소재로한 요리교실, 새롭게 조성된 소래포구 관광벨트를 활용한 행사 등 남녀노소 직접 참여할 수 있는 다양한 프로그램이 진행될 예정이다.", 
'소래포구 해오름광장 전통어시장 및 소래습지생태공원', NULL, NULL, '무료','전연령', NULL);
INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
506797 , '이천쌀문화축제' , 20221019 , 20221023 , '경기도 이천시 공원로 48', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/06/2847106_image2_1.jpg', 127.4448702054, 37.1798991253, 6, 31, 26, '031-644-4135~7', 
'<a href="http://www.ricefestival.or.kr" target="_blank" title="새창:이천쌀문화축제 홈페이지로 이동">http://www.ricefestival.or.kr</a>', "이천의 대표적인 특산물이며 상징인 이천쌀의 우수성을 널리 알리기 위해 개최되는 제21회 이천쌀문화축제가 2022년 이천농업테마공원에서 새롭게 단장하고 방문객들을 맞이한다.<br>어린 세대에겐 전통 농경문화를 체험하고, 어른들에겐 옛 향수를 자아내며 함께 어울릴 수 있는 축제의 한 마당에서, 하루 임금님이 되어 맛있는 이천쌀을 진상받아 보는 것은 어떨까?", 
'이천농업테마공원', NULL, NULL, '무료',NULL, NULL);
INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
506774 , '울산옹기축제' , 20220930 , 20221003 , '울산광역시 울주군 온양읍 외고산길 23', NULL, 'A02070100', 'http://tong.visitkorea.or.kr/cms/resource/68/1993568_image2_1.jpg', 129.2801648931, 35.4322848446, 6, 7, 5, '052-980-2232~4', 
'<a href="https://www.onggi.or.kr/" target="_blank" title="새창:울주외고산옹기축제 홈페이지로 이동">https://www.onggi.or.kr/</a>', "2022 울산옹기축제를 9월 30일부터 10월 3일까지 외고산 옹기마을 일대에서 개최한다. 울주문화재단이 주최하는 이번 축제는‘Welcome to 옹기마을’을 슬로건으로 ▲옹기테마파크 ▲옹기의 친환경성 ▲옹기의 전통성과 디지털의 결합이라는 3가지 컨셉으로 지속가능한 축제를 위한 새로운 변화를 시도한다.", 
'울산광역시 울주군 온양읍 외고산 옹기마을 일대', NULL, NULL, '체험별 가격다름',NULL, NULL);
INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
506708 , '양양송이축제' , 20220930 , 20221002 , '강원도 양양군 양양읍 남문10길 9', NULL, 'A02070200', NULL, 128.6242869334, 38.0731566683, 6, 32, 7, '033-671-3803', 
'<a href="http://yymsfestival.com/" title="새창: 양양송이축제로 이동" target="_blank">http://yymsfestival.com/</a>', "양양송이축제는 양양송이의 향과 맛을 즐길 수 있는 축제로 매년 9월 말에서 10월 초에 열린다. 양양군 양양송이축제위원회의 주최로 열리는 축제는 양양 남대천 둔치와 송이 산지 등이 주 무대다. 양양송이는 송이 중에서도 씹는 맛과 향기가 뛰어난 것으로 유명하다. 인공 재배가 불가능한 100% 자연산 버섯으로 수분 함량이 적어 육질이 단단하고, 20~60년 된 소나무 뿌리에서만 영양분을 섭취해 송진 향 비슷한 특유의 향기가 짙기 때문이다. 양양송이축제에서는 양양송이를 주제로 한 다양한 체험 프로그램과 문화예술 행사를 즐길 수 있다. 산이나 휴양림을 뒤져 송이를 직접 찾아보는 송이보물찾기 체험은 언제나 인기다. 이 외에 표고버섯 재배단지를 방문, 자신이 채취한 표고버섯 1kg을 가져갈 수 있는 표고버섯 따기 체험, 송이가 자라는 과정을 살펴보는 송이생태 견학은 양양송이의 생육 환경을 배우는 뜻깊은 기회다. 양양송이 직거래 장터에서 양질의 제품을 구입하고, 푸드트럭존과 VIP 송이요리 전문점에서 양양송이로 만든 신선한 음식도 맛볼 수 있다.", 
'양양 남대천 둔치', NULL, NULL, '홈페이지 참조',NULL, NULL);
INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
506690 , '안성맞춤 남사당 바우덕이 축제' , 20220930 , 20221003 , '경기도 안성시 보개면 남사당로 198-2', NULL, 'A02070100', 'http://tong.visitkorea.or.kr/cms/resource/61/2844261_image2_1.jpg', 127.3101782044, 37.0318776686, 6, 31, 16, '031-678-2511~5', 
'<a href="http://www.baudeogi.com" target="_blank" title="새창: 안성맞춤남사당바우덕이축제 홈페이지로 이동">http://www.baudeogi.com</a>', "안성맞춤 남사당 바우덕이 축제는 2001년부터 개최되어 올해로 22회를 맞이 하는 축제이다.<br>코로나에 지친 사람들을 위로하고 응원하기 위해 4년만에 대면축제로 돌아온 바우덕이 축제는 개․폐막식을 비롯한 다채로운 공연으로 관람객에게 낭만적인 가을을 선사할 예정이다.<br>또한 현장판매와 네이버쇼핑라이브를 병행한 안성 농특산물 홍보판매, 각종 체험프로그램 등 다양한 즐길거리와 야간 경관조명을 설치한 힐링공간이 준비되어 있고 저탄소 축제를 위해 음료구매시 개인컵을 이용하면 1천원 할인행사를 진행한다.", 
'안성맞춤랜드, 안성천 일대(작은미술관 부근)', NULL, NULL, '무료','연령제한없음', NULL);
INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
506670 , '안동국제탈춤페스티벌' , 20220929 , 20221003 , '경상북도 안동시 축제장길 200 탈춤공연장', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/01/2689901_image2_1.png', 128.7306588876, 36.5605523512, 6, 35, 11, '054-841-6379~8', 
'<a href="http://www.maskdance.com" target="_blank" title="새창:안동 국제탈춤페스티벌 홈페이지로 이동">http://www.maskdance.com</a>', "[축제소개] 다채로운 가면과 함께 펼쳐지는 신명나는 탈춤 한바탕!
2010년 유네스코 세계문화유산에 등재된 안동하회마을은 한국에서 한국전통문화를 가장 잘 보존, 계승하고 있는 고장이다. 안동하회마을의 전통 중 하나인 ‘하회별신굿탈놀이’는 우스꽝스러운 표정의 탈을 쓰고 펼쳐지는 공연으로, 풍자와 해학의 정신이 담겨 있다. 안동에서는 하회별신굿탈놀이의 정신을 계승하고, 탈과 춤이라는 테마를 바탕으로 안동국제탈춤페스티벌을 개최하고 있다. 축제에서는 하회별신굿탈놀이를 비롯해 중요무형문화재 탈춤 공연과 세계 각국의 탈춤 공연이 펼쳐지며, 마당극, 차전놀이, 놋다리밟기 등 민속극과 민속놀이가 진행된다. 메인 이벤트인 탈놀이대동난장 퍼레이드는 시민과 관광객, 외국 공연팀이 모두 모여 다양한 탈을 쓰고 신나게 춤을 추는 행사로, 춤으로 모두가 하나되는 특별한 체험을 선사한다. ‘잘 노는 사람이 건강한 사람’이라는 축제의 모토 그대로, 공연자와 관객이 격이 없이 서로 어울리는 즐거운 축제한마당이 펼쳐진다. 

[축제TIP] 탈춤이란?
안동 하회마을에서 전승되어 오는 가면극으로, 마을의 안녕과 풍년을 기원하기 위한 마을 굿의 일환이다. 지배계층인 양반과 선비를 비판하고 상민들의 삶의 애환을 풍자적으로 표현해 계급 간의 모순과 갈등을 완충하는 역할도 했다고 한다.", 
'안동시 원도심 일원', NULL, NULL, '홈페이지 참조',NULL, NULL);
INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
506600 , '산청한방약초축제' , 20220930 , 20221010 , '경상남도 산청군 금서면 매촌리', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/25/2689925_image2_1.png', 127.8293195944, 35.4410407594, 6, 36, 9, '055-970-6601~5', 
'홈페이지 <a href="http://scherb.or.kr" target="_blank" title="새창:산청 한방약초축제 홈페이지로 이동">http://scherb.or.kr</a><br>인스타그램 <a href="https://www.instagram.com/scherbfest/" target="_blank" title="새창:산청 한방약초축제 홈페이지로 이동">www.instagram.com</a><br>블로그 <a href="https://blog.naver.com/scherbfest" target="_blank" title="새창:산청 한방약초축제 홈페이지로 이동">https://blog.naver.com</a>', "사계절 달라지는 아름다운 풍경과 맑은 정기를 자랑하는 지리산은 1,000여 종이 넘는 약초가 자생하는 약초의 보물창고이기도 하다. 지리산을 품은 산청은 질 좋은 약초를 구하기 쉬워 동의보감의 저자인 구암 허준 선생을 비롯한 수많은 명의들이 의학공부와 의술을 펼쳤던 곳이다. 동의보감과 약초의 고장 산청에서 매년 9월 산청한방약초축제가 열린다. 한방진료와 한방침 등을 무료로 체험할 수 있는 산청혜민서를 비롯해 보약체험, 약초족욕체험, 웰니스체험 등 다양한 힐링 체험이 가능하다. 조선시대 어의와 의녀 의상 입어보기 체험, 전통다례 체험, 민속놀이 체험 등 재미있는 체험도 할 수 있다.<br><br>[축제TIP]동의보감이란?<br>
조선시대의 명의 구암 허준이 중국과 조선의 의학서적을 집대성하여 1610년에 저술한 의학서이다. 동양 최고의 의학 백과사전 중 하나로 평가받고 있으며, 2009년 유네스코 세계기록문화유산에 등재되었다.", 
'산청IC축제광장, 동의보감촌', NULL, NULL, '홈페이지 참고',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
506545 , '광안리어방축제' , 20221014 , 20221016 , '부산광역시 수영구 광안동', NULL, 'A02070100', 'http://tong.visitkorea.or.kr/cms/resource/34/2689834_image2_1.png', 129.1187283431, 35.1532381253, 6, 6, 12, '051-610-4062', 
'<a href="http://www.suyeong.go.kr/festival/index.suyeong" target="_blank" title="새창:광안리어방축제 홈페이지로 이동">http://www.suyeong.go.kr</a>', "[축제소개] 역사와 전통, 즐거움과 웃음이 가득한 축제!
광안리어방축제는 한국에서 유일하게 전통어촌의 민속문화를 소재로 한 축제로, 조선시대 수군과 어민의 어업 공동작업체인 '어방(漁坊)'을 소재로 하고 있다. 축제 기간에는 옛 수군병영과 어촌마을을 재현한 민속마을에서 20여 가지의 전시 및 체험프로그램을 즐길 수 있고 수군, 주모, 어민, 기생 등 다양한 인물들이 마을을 돌아다니며 방문객들을 즐겁게 해준다. 조선시대 부산지역의 수군대장인 경상좌수사의 행렬을 재현하고, 어방을 소재로 한 창작뮤지컬을 선보이는 등 볼거리도 알차다. 이밖에도 맨손으로 활어잡기, 한복체험, 아이들을 위한 유물발굴 및 복원체험 등 다양한 체험프로그램이 준비되어 있으며 화려한 계-폐막식과 문화공연이 펼쳐진다. 
[축제TIP] 어방이란?
현종 11년에는 성(城)에 어방(漁坊)을 두고 어업의 권장과 진흥을 위하여 어업기술을 지도하였다. 이것이 좌수영어방이며, 이 어방은 어촌 지방의 어업협동기구로 현대의 수산업 협동조합(어촌계)과 비슷한 의미이다. 공동어로 작업 때에 피로를 잊고, 또 일손을 맞추어 능률을 올리며 어민들의 정서를 위해서 노래를 권장하였다.", 
'광안리해변 및 수영사적공원 일원', NULL, NULL, '무료','전연령 가능', '기간내 자유');

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
506523 , '무주반딧불축제' , 20220827 , 20220904 , '전라북도 무주군 한풍루로 326-14 등나무운동장', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/55/2731555_image2_1.jpg', 127.6615222281, 36.0026685539, 6, 37, 5, '063-324-2440', 
'<a href="http://www.firefly.or.kr" target="_blank" title="새창:무주반딧불축제 홈페이지로 이동">http://www.firefly.or.kr</a>', "무주반딧불축제는 추억과 설렘을 간직한 반딧불이를 직접 관찰할 수 있는 축제로, 반딧불이와 그 먹이 서식지가 천연기념물 지정되어있는 무주에서 매년 8월말에 개최된다.", 
'무주등나무운동장 일원', NULL, NULL, '무료(일부 유료)',NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
506516 , '대구약령시한방문화축제' , 20221006 , 20221010 , '대구광역시 중구 남성로 51-1', '(동성로3가)', 'A02070100', 'http://tong.visitkorea.or.kr/cms/resource/70/2689770_image2_1.png', 128.5923963501, 35.8673230099, 6, 4, 8, '053-253-4729', 
'<a href="http://www.herbfestival.org/kor/" target="_blank" title="새창:대구약령시 한방문화축제 홈페이지로 이동">http://www.herbfestival.org</a>', "[축제소개] 한방과 함께 건강하고 즐겁게!<br>대구약령시는 조선 중기부터 한약재를 판매하던 유서 깊은 약재시장이다. 한국은 물론 해외까지 한약재를 공급해온 세계적인 한약재 유통의 거점이었던 약령시에서 대구약령시한방문화축제가 펼쳐진다. 사상체질 체험관에서 전문가의 상담을 통해 자신의 체질을 분석하고 한방힐링센터에서 한방진료를 받을 수 있으며 전통 방식으로 한약을 달여 마셔보거나 십전대보환, 총명환 등 전통 한방 환을 만들어볼 수도 있다. 저녁 시간에 골목해설사와 함께 대구근대골목을 걸으며 대구 근대역사에 대한 재미있는 이야기를 들을 수 있는 달빛야경투어 또한 인기가 많다. <br><br>[축제TIP] 고유제란?<br>고유제는 초근목피(草根木皮)를 한약재로 처음 쓰기 시작한 염제(炎帝) 신농씨(神農氏)를 모시는 고사로 시민의 건강과 안녕을 비는 祭(제)를 시작으로 약령시 개장행사의 서막을 장식한다. 전통 제례악 공연에 맞춰서 祭(제)를 지낸다.", 
'대구광역시 중구 약령시 일원', NULL, NULL, '홈페이지 참고','전연령 가능함', '기간내자유');

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
506470 , '김해분청도자기축제' , 20221024 , 20221030 , '경상남도 김해시 진례면 진례로 275-35', NULL, 'A02070200', NULL, 128.7458664871, 35.2515063634, 6, 36, 4, '055-330-3244', 
'<a href="https://www.gimhae.go.kr/06804/06849.web" target="_blank" title="새창:김해분청도자기축제 홈페이지로 이동">https://www.gimhae.go.kr</a>', "축제는 개막식과 분청사기 전통을 계승 발전시키기 위한 전통가마 불지피기로 시작되며, 요리와 만난 분청도자기, 나만의 도자기 만들기, 분청도자기의 7가지 기법 체험, 대형 도자기 만들기(기마인물상(3m)), 소원풍선 날리기, 일본도자기춤공연 등 오감 만족 프로그램으로 관람객의 눈과 귀와 입을 사로잡을 예정이다.", 
'김해분청도자박물관 일원', NULL, NULL, '무료','전연령 가능함', '2~3시간');

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
506465 , '제40회 금산인삼축제' , 20220930 , 20221010 , '충청남도 금산군 금산읍 인삼광장로 30', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/35/2815735_image2_1.jpg', 127.5012171957, 36.1002101508, 6, 34, 2, '041-750-4147', 
'<a href="http://www.insamfestival.co.kr/" target="_blank" title="새창:금산인삼축제 홈페이지로 이동">http://www.insamfestival.co.kr</a>', "금산에 인삼산업이 발달하게 되자 1981년 삼장제를 시작으로 지역 주민 화합형 축제로 금산인삼제가 시작되었다. 이후로 발전을 거듭해오던 금산인삼축제가 1996년 문화관광축제로 선정되면서, 전국적인 축제로 발전하게 되었다.<br>금산인삼축제의 발전과 더불어 금산인삼의 효능과 약리 작용이 과학적으로 검증되면서 건강을 찾아, 청정 자연을 찾아, 금산을 찾는 방문객이 해마다 늘어가고 있다.<br> 1981년부터 매년 개최되어 온 금산인삼축제는 문화체육관광부가 선정하는 전국 최우수축제 10회 선정 및 2020~2021년 명예 문화관광축제 지정, 2010년 세계축제협회 축제도시 선정에 이어 피나클 어워드 10년 연속 수상 등 명실 공히 한국을 대표하는 산업형 축제로 숱한 명성을 쌓아오고 있다.", 
'금산인삼관 광장 및 인삼약초시장 일원', NULL, NULL, '프로그램마다 상이(무료/유료)','전연령 가능함', '기간내자유');

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
506376 , '논산 강경젓갈축제' , 20221012 , 20221016 , '충청남도 논산시 강경읍 대흥리', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/84/2821984_image2_1.jpg', 127.0148146484, 36.1572450973, 6, 34, 3, '041-746-5902,5903', 
'<a href="https://www.nonsan.go.kr/ggfestival/" target="_blank" title="새창:강경젓갈페스티벌 홈페이지로 이동">www.nonsan.go.kr</a>', "강경젓갈의 특징은 모든 재료를 원산지에서 직접 가져와 선조로부터 이어받은 전통비법에 현대화된 시설로 정갈하게 제조되어 전국의 어느 젓갈과도 비교될 수 없는 옛 고유의 참맛을 그대로 간직하고 있다는 것이다. 우리나라 대표적인 산업형 축제로 발전한 강경젓갈축제는 당초 IMF가 한창이던 1997년 경제 극복의 일환으로 지역경제 활성화 및 상인들의 소득증대 취지에서 강경 젓갈상인들의 뜻을 모아 시작한 축제가 해를 거듭할수록 규모가 커져 오늘에 이르고 있다. 특히 2007년부터 강경젓갈발효축제에서 강경젓갈축제로 명칭을 변경하고 단순히 젓갈이 염장식품이라는 개념에서 탈피하여 세계속의 젓갈, 발효음식이라는 인식을 확고히 다진 결과, 관광객들의 호응도가 훨씬 높아졌다.", 
'강경젓갈시장 일원', NULL, NULL, NULL,NULL, NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
406696 , '성남아트센터 마티네콘서트' , 20220317 , 20221215 , '경기도 성남시 분당구 성남대로 808', '(야탑동)', 'A02080900', 'http://tong.visitkorea.or.kr/cms/resource/02/1786002_image2_1.jpg', 127.1292175196, 37.4019566143, 6, 31, 12, '031-783-8000', 
'<a href="http://www.snart.or.kr" target="_blank" title="새창: 성남 아트센터 홈페이지로 이동">http://www.snart.or.kr</a>', "성남아트센터 2022마티네 콘서트는 영국으로 향한다. 오늘날 영국은 독일이나 이탈리아, 프랑스에 비해 '음악의 나라'라는 느낌이 덜하다. 하지만 사실 영국은 중세와 르네상스를 거쳐 바로크 시대까지 그 어느 나라 못지 않게 아름다운 음악이 꽃피었던 음악 강국이었다.<br>빈 고전파와 낭만주의 시대에는 잠시 음악이 주춤했지만, 대신 유럽 최고의 경제 대국이자 일찍부터 예술을 사랑하는 시민 사회가 발전한 나라답게 여러 나라 음악가들이 모여들고 있다.<br>그리고 19세기 후반, 엘가를 시작으로 다시 힘차게 부활한 영국 ㅠ음악은 본 윌리엄스와 브리튼을 거쳐 태버너와 맥밀란까지 다시 한번 세계음악을 이끌고 있다.<br>올해 마티네 콘서트는 이렇게 독특한 영국 음악의 역사를 한눈에 살펴볼수 있는 프로그램으로 준비되었다. 헨리 퍼셀과 헨델 같은 바로크 대가들을 필두로 엘가, 본 윌리엄스, 월튼 등 우리 귀에 익숙한 20세기 대가들의 작품도 있으며, 또 합창음악의 나라다운 멋진합창음악도 있다.<br>그런가 하면 요한 크리스티안 바후, 하이든, 멘델스존처럼 영국인이 사랑했던 자곡가들이 영국 청중을 위해서 쓴 작품도 들을 수 있으며, 캐롤의 고향이 영국임을 일깨워주는 매력적인 작품도 여러분을 기다린다.<br>조금 색다른, 그래서 더욱 매력적인 영국으로 떠나는 마티네 음악 여행에 함께 떠나보는 건 어떨까?", 
'성남아트센터 콘서트홀', NULL, NULL, '전석 25,000원','미취학아동입장불가', NULL);

INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
235076 , '부산불꽃축제' , 20221105 , 20221105 , '부산광역시 수영구 광안해변로 219', '(광안동)', 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/96/2830696_image2_1.jpg', 129.1184922375, 35.1537908369, 6, 6, 12, '051-888-4135', 
'<a href="http://www.bfo.or.kr" target="_blank" title="새창:부산 세계불꽃축제 홈페이지로 이동">http://www.bfo.or.kr</a>', "매년 광안리해수욕장을 화려하게 수놓는 부산불꽃축제가 어느덧 17회를 맞이하였다. 2005년 APEC정상회의 기념행사 일환으로 시작돼, 해를 거듭할수록 세계적인 관심을 받으며 부산 대표 축제로 자리매김하였다. 부산에서만 볼 수 있는 초대형 불꽃과 광안대교 경관조명을 활용한 미디어파사드 연출, 화려한 불꽃과 조명, 음악이 어우러져 스토리텔링이 가미된 부산멀티불꽃쇼와 해외 초청 불꽃쇼를 만나볼 수 있다. 또한 광안리 해수욕장뿐만 아니라 동백섬, 이기대 앞까지 \“3 point\" 연출로 다양한 장소에서 불꽃쇼를 관람할 수 있다.<br>가을밤, 불꽃이 내리는 부산! 세계인과 함께하는 부산불꽃축제로 여러분을 초대한다.", 
'광안리해수욕장 일원', NULL, NULL, '무료(일부 유료)',NULL, NULL);
INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
234232 , '사천에어쇼' , 20221020 , 20221023 , '경상남도 사천시 사천읍 사천대로 1971', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/61/2835661_image2_1.jpg', 128.0851867810, 35.0949648277, 6, 36, 8, '055-831-2061', 
'홈페이지 <a href="http://airshow.sacheon.go.kr" target="_blank" title="새창:사천에어쇼 홈페이지로 이동">http://airshow.sacheon.go.kr</a><br>인스타그램 <a href=\"https://www.instagram.com/sacheon_airshow/\" target=\"_blank\" title=\"새창:사천에어쇼 홈페이지로 이동\">www.instagram.com/sacheon_airshow</a><br>페이스북 <a href=\"https://www.facebook.com/4000aerospace\" target=\"_blank\" title=\"새창:사천에어쇼 홈페이지로 이동\">www.facebook.com/4000aerospace</a>', "사천은 대한민국 최초의 항공기 부활호를 제작·운용한 발원지이며, 국내에서 유일하게 항공기를 자체 생산, 수출하는 한국항공우주산업㈜과 다수의 항공우주산업체들이 활동하는 항공우주산업의 중심도시이다.<br>무료체험비행, 실제 조종사들이 훈련할 때 사용하는 KT-1 시뮬레이터 탑승, 블랙이글스 에어쇼, 호주 폴베넷 곡예비행 에어쇼, 블랙이글스 전투기 가상현실(VR)체험, 항공기 지상전시 등 다양한 무료체험이 준비되어 있다.<br>특히 2022 사천에어쇼에서는 공동주최기관 한국항공우주산업(주)에서 개발한 한국형 전투기 KF-21 지상전시와 LAH 시범비행도 펼쳐질 예정이다.", 
'사천비행장', NULL, NULL, '무료',NULL, NULL);
INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
232325 , '횡성한우축제' , 20220930 , 20221004 , '강원도 횡성군 문화체육로 47 종합운동장', NULL, 'A02070100', 'http://tong.visitkorea.or.kr/cms/resource/07/2826707_image2_1.jpg', 127.9877120195, 37.4958559276, 6, 32, 18, '1522-1099', 
'<a href="http://www.happyhanwoofestival.com" target="_blank" title="새창: 횡성한우축제 홈페이지로 이동">www.happyhanwoofestival.com</a>', "3년만에 오프라인으로 열리는 횡성한우축제.<br>
화려한 문화예술공연과 다양한 프로그램.<br>
대한민국 1등 명품 횡성한우와, 물좋고 공기좋은 횡성에서 나고자란 싱싱한 농특산물을 저렴하게 구매할 수 있는 기회까지!<br>
횡성에서 맛보소! 한우축제 즐기소!<br>", 
'횡성종합운동장 일원', NULL, NULL, '무료','전연령가능', '기간내자유');
INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
229057 , '제18회 서울와우북페스티벌' , 20221001 , 20221009 , '서울특별시 마포구 양화로 72 서교동 효성 해링턴 타워', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/94/2847494_image2_1.jpg', 126.9167298722, 37.5508549625, 6, 1, 13, '02-313-1587', 
'<a href="http://wowbookfest.com/" target="_blank" title="새창:서울 와우북페스티벌 홈페이지로 이동">http://wowbookfest.com/</a>', "서울와우북페스티벌은 동시대를 살아가는 사람들을 연결하는 공간으로 독자들의 관심사와 시대적 담론을 담은 참여의 장을 만들어 왔다. 2022년 서울와우북페스티벌에서는 “다정함으로 길을 묻다”라는 슬로건 아래 다정한 이들이 모이는 환대의 공간이 되었으면 한다. 자기 분야에서 묵묵히 일하면서 따뜻한 시선으로 세상을 바라보는 사람들과 함께 힘들게 살아가는 사람들에게 위로와 공감이 되는 이야기를 나눌 수 있는 공간 말이다. ≪이상한 날씨≫에서 올림피아 랭이 “혐오에 대해서는 한 글자도 더 할애하고 싶지 않다. 대신 환대가 이뤄지는 공간에 대해 써보려고 한다.”고 한 것처럼 올해 서울와우북페스티벌은 작가, 예술가, 출판사, 독자 등 모두에게 환대 가 이뤄지는 공간이 되어 사랑과 연대의 힘을 보여주고 싶다.", 
'서울생활문화센터 서교, 서교예술실험센터', NULL, NULL, '무료','전체관람가능', '프로그램별 상이');
INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
229048 , '동래읍성 역사축제' , 20221014 , 20221016 , '부산광역시 동래구 문화로 80', '(명륜동)', 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/60/2612860_image2_1.JPG', 129.0901347694, 35.2121421097, 6, 6, 6, '051-550-4092', 
'<a href="https://www.dongnae.go.kr/festival/index.dongnae?contentsSid=169" target="_blank" title="새창:동래읍성문화축제 홈페이지로 이동">https://www.dongnae.go.kr</a>', "단풍이 아름다운 10월의 가을 하늘아래 '1592년, 조선 동래를 만나다'라는 슬로건으로 역사와 전통의 향연 속에 개최되는 동래읍성역사축제는 역사교육형 체험 축제이다.<br>축제의 대표 프로그램인 동래성 전투재현 뮤지컬 '외로운 성'은 1592년 임진왜란 당신 '전사이가도난'을 외치며 목숨으로 동래성을 지키고자 했던 송상현 동래부사와 동래읍성민들의 처절한 항쟁을 재조명하며, 실내가 아닌, 동래읍성 북문 언덕에서 연출하여 숲속 관람객이 극중의 일원이 되어 불꽃같은 감동과<br>전율로 카타르시스를 경험하게 될 것이다.<br>지금의 부산시장과 같은 위치인 '동래부사'의 신임 행차와 야류 길놀이를 한번에 즐길 수 있는 '동래부사행차 길놀이'와 1592년 조선, 동래로 입장하는 여러가지 관문체험, 임진왜란의 동래성 전투를 기억하는 기억의 공간, 427년전 동래읍성민들의 일상을 체험해보는 동래사람되어 보기 체험, 나도 모르게 어깨가 들썩 동래학춤 한마당 등 여러가지 공연과 체험들은 1592년으로 시간을 돌려놓을 것이다.<br>동래읍성역사축제는 동래의 전통과 문화, 숭고한 선열들의 구국정신을 중심으로 역사의 산 교육장으로 교육(education)과 오락(entertainment)이 결합된 에듀테인먼트(Edutainment)의 역사교육형 축제로써 여러분의 문화적 욕구를 만족시킬 것이다.<br>", 
'동래읍성(북문),  동래문화회관 등', NULL, NULL, NULL,'전연령 가능함', '기간내자유');
INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
142191 , '2022 영동포도축제' , 20220825 , 20220828 , '충청북도 영동군 영동힐링로 117', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/11/2824911_image2_1.jpg', 127.7865319410, 36.1563977278, 6, 33, 4, '043-744-8916~8', 
'<a href="https://www.ydgrape.co.kr/" target="_blank" title="새창 : 2022 영동포도축제">www.ydgrape.co.kr</a>', "매년 8월 말이 되면 포도의 고장인 영동에서 열리는 대표적인 축제이다. 전국 최대의 재배면적(2,209ha)과 품질 좋은 포도를 전국에 알리기 위해 축제이며, 단순히 포도를 먹기만 하는 축제 아니라 포도를 직접 따는 체험부터 포도를 이용해서 와인, 빙수, 초콜릿 등 여러 가지 제품을 만들고, 포도밟기 등 수십 가지의 다양한 체험들이 함께하는 오감만을 만족할 수 있는 즐거운 축제의 장이다. 수도권에서 멀지 않아 당일치기로도 즐길 수 있으며, 어린아이에게 눈높이를 맞춘 다양한 행사까지 준비되어 있으니 무더운 여름 시원하게 영동포도축제와 함께 해보자. <br><br>연계행사 : 영동포도전국마라톤대회, 추풍령가요제", 
'영동 레인보우힐링관광지 일원', NULL, NULL, '무료<br>(일부체험 유료)',NULL, NULL);
INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
142193 , '서울프린지페스티벌' , 20220811 , 20220828 , '서울특별시 마포구 증산로 87', '(성산동)', 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/94/2818894_image2_1.JPG', 126.8929203036, 37.5731297249, 6, 1, 13, '02-325-8250', 
'<a href="http://www.seoulfringefestival.net" target="_blank" title="새창:서울 프린지페스티벌 홈페이지로 이동">http://www.seoulfringefestival.net</a>', "예술가의 자유로운 시도와 그들의 주체성을 지지하는 예술축제, 서울프린지페스티벌<br>서울프린지페스티벌은 1998년 대학로에서 열린 ‘독립예술제’로 시작되어 매년 여름, 연극, 무용, 음악, 퍼포먼스, 미술, 영상 등 다양한 분야의 예술가들이 참여하는 축제이다. 예술가나 작품에 대한 심사나 선정이 없는 자유참가에 원칙을 두고 있으며, 모두에게 참여의 기회를 개방하고 있다. 정형화된 틀에서 벗어나 공간을 실험하고, 장르와 형식을 넘나드는 시도와 도전이 가능하다.", 
'서울시 마포구 및 서대문구 일대', NULL, NULL, '홈페이지 참조','공연 별 상이', NULL);
INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
142197 , '제17회 시흥갯골축제' , 20220923 , 20220925 , '경기도 시흥시 동서로 287 갯골생태공원', NULL, 'A02070100', 'http://tong.visitkorea.or.kr/cms/resource/35/2822835_image2_1.jpg', 126.7812550601, 37.3898240311, 6, 31, 14, '031-380-5681', 
'<a href="http://www.sgfestival.com" target="_blank" title="새창:시흥 갯골축제 홈페이지로 이동">
    http://www.sgfestival.com
</a>', "시흥갯골축제는 경기도 유일의 내만갯골에 위치한 시흥갯골생태공원에서 펼쳐지는 생태축제로 옛 염전 터와 습지가 어우러진 천혜의 자연환경을 기반으로 자연에서 쉬고 배우며 즐기는 다양한 프로그램을 통해 자연과 동화되는 색다른 즐거움이 있는 축제로 생태공원의 자연환경을 보호하기 위해 차 없는 축제로 진행하고 있다.", 
'시흥갯골생태공원', NULL, NULL, NULL,NULL, NULL);
INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
142105 , '진주 개천예술제' , 20221027 , 20221103 , '경상남도 진주시 남강로 626', '(본성동)', 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/85/2600285_image2_1.JPG', 128.0780681464, 35.1935119571, 6, 36, 13, '055-752-0111', 
'<a href="http://www.gaecheonart.com" target="_blank" title="새창:개천예술제 홈페이지로 이동">http://www.gaecheonart.com</a>', "개천예술제는 1949년(단기 4282년)에 정부수립의 실질적인 자주독립 1주년을 기리고 예술문화의 발전을 위해서 제1회 영남예술제로 개최 되었다. 그 이후 1950년 한국전쟁과 1979년 10.26을 제외 하고는 매년 어떤 어려움에도 그 맥을 이어온 국내 최대, 최고의예술제이다. 1959년에는 영남예술제에서 개천예술제로 그 명칭을 바꿔 개최되었으며, 1964년부터 1968년까지는국가원수가 개제식에 참석하는 최초의 예술제였다. 개천예술제는 그 동안에 전통 예술 경연을 통해 우리의 예술문화 발전에 많은 기여를 해왔으며, 지역 문화예술 발전에이바지 한 바가 크다고 할 수 있다.", 
'경상남도 진주시 일원', NULL, NULL, NULL,'전연령가능', NULL);
INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
141731 , '음성 품바축제' , 20220921 , 20220925 , '충청북도 음성군 음성읍 설성공원길 28', NULL, 'A02070100', 'http://tong.visitkorea.or.kr/cms/resource/66/2689066_image2_1.png', 127.6910022374, 36.9327654263, 6, 33, 6, '043-873-2241', 
'<a href="http://pumba21.com" target="_blank" title="새창:음성품바축제 홈페이지로 이동">http://pumba21.com</a>', "풍자와 해학이 있는 퓨전 마당놀이<br>음성 품바축제는 웃음과 눈물, 풍자와 해학, 그리고 따뜻한 사랑을 느낄 수 있는 축제이다. 장애를 가진 몸으로 구걸을 하며 음성 꽃동네(장애인, 걸인 들을 위한 사회복지시설) 설립의 계기를 마련한 ‘거지성자’ 최귀동 할아버지의 숭고한 인류애와 박애정신을 기리기 위한 축제로, 거지를 상징하는 품바를 활용한 다양한 체험프로그램들을 운영한다. 축제장 이곳 저곳을 돌아다니며 신명나는 가락과 함께 구수한 각설이타령을 부르는 각설이들을 만날 수 있으며, 품바 의상을 빌려 입고 각설이타령을 따라 불러볼 수도 있다. 또한, 각설이들이 살았던 다리 밑에서 60-70년대 풍으로 꾸며진 다양한 공간을 둘러보며 레트로 문화에 빠져볼 수 있다. 이외에도 품바경연대회, 천인의 비빔밥 나누기 등의 행사가 열린다. <br><br>[축제TIP] 품바란?<br>조선시대 타령의 후렴구에 장단을 맞추기 위해 사용되는 의성어로, 장터나 길거리를 돌아다니면서 동냥하는 각설이나 걸인들이 즐겨 불렀다고 한다.", 
'음성군, 음성 설성공원', NULL, NULL, '무료','전연령 가능', '기간 내 자유');
INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
141661 , '수문장 교대의식' , 20220101 , 20221231 , '서울특별시 종로구 사직로 161', '(세종로)', 'A02080100', 'http://tong.visitkorea.or.kr/cms/resource/96/868696_image2_1.jpg', 126.9767235747, 37.5801859611, 6, 1, 23, '02-3210-1645', 
'<a href="http://www.chf.or.kr/c1/sub2.jsp" target="_blank" title="새창:수문장 교대의식 홈페이지로 이동">http://www.chf.or.kr</a>', "조선시대 수문장은 흥인지문, 숭례문 등 도성문과 경복궁 등 국왕이 임어(생활)하는 궁궐의 문을 지키는 책임자였다. 수문장은 정해진 절차에 따라 광화문을 여닫고 근무교대를 통하여 국가의 중심인 국왕과 왕실을 호위함으로써 나라의 안정에 기여 하였다. 우리나라에서 처음 수문장 제도가 확립된 시기는 조선 예종 1년 (1469년)으로 그 이전까지는 중앙군인 오위(五衛)의 호군(護軍)이 궁궐을 지키는 일을 담당하였다.<br><br>따라서 조선의 법궁인 경복궁에서 재현하는 본 행사의 시대배경은 수문장 제도가 정비되는 15세기 조선전기로 당시 궁궐을 지키던 군인들의 복식과 무기, 각종 의장물을 그대로 재현하도록 노력하였다. 역사시대 최고수준의 왕실문화를 복원, 재현하는 일은 그 자체가 지닌 역사와 전통문화의 교육적인 요인을 활용함과 동시에 전통문화를 관광자원화하여 수준 높은 문화발전에 기여하기 위해 지속적으로 유지, 발전되어야 할 주요 문화사업이다.<br>", 
'서울 종로구 경복궁, 광화문 일원', NULL, NULL, '무료',NULL, NULL);
INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
141234 , '괴산고추축제' , 20220901 , 20220904 , '충청북도 괴산군 임꺽정로 113', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/42/2832542_image2_1.jpg', 127.7834944865, 36.8147417924, 6, 33, 1, '043-830-3463', 
'<a href="http://www.goesanfestival.com" target="_blank" title="새창:괴산고추축제 홈페이지로 이동">http://www.goesanfestival.com</a>', "괴산청결고추는 전국 최초로 고추산업특구지정, 지리적표시제등록, ISO품질인증, 클러스터사업선정, HACCP인증, 괴산고추 지리적표시등록, 괴산고춧가루 지리적표시등록, 대한민국우수특산품대상선정 등으로 전국 최고의 명품 브랜드로 소비자들에게 각광받고 있다. 이러한 배경으로 2001년부터 개최되어온 <괴산고추축제>는 본격적인 고추출하시기인 매년 8월 하순에서 9월 초순경 3간의 일정으로 치루어지며 수십만명의 관광객이 찾아와 축제를 만끽하고 있다.", 
'괴산유기농엑스포광장 일원', NULL, NULL, '무료<br>체험비 부분유료','전연령 관람가능', '기간내자유');
INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
141220 , '제8회 대한민국국제포토페스티벌  < 메타 리얼리티 : 현실 그 너머 >' , 20220909 , 20220915 , '서울특별시 서초구 남부순환로 2406', '(서초동)', 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/07/2838807_image2_1.jpg', 127.0107150202, 37.4785261578, 6, 1, 15, '02 313-9539', 
'<a href="http://www.kipf.kr/" target="_blank" title="새창 : 대한민국국제포토페스티벌">http://www.kipf.kr</a>', "대한민국국제포토페스티벌은 예술의전당에서 해마다 펼쳐지는 사진 및 시각예술축제이다. 2013년 제1회를 시작으로 2022년 올해로 8회를 맞이한다. 올해는 200여명의 작가의 작품 1000여점이 출품된다. 4차 산업혁명으로 대변되는 인공지능의 시대를 맞아 사진의 방향성과 변화상을 조명해본다.", 
'예술의전당 한가람미술관 제3,4전시실', NULL, NULL, '성인(만19~64세 미만) 12,000원 / 청소년(만13~18세) 10,000원 / 어린이(36개월~12세) 8,000원, 경로(만 65세 이상), 국가유공자, 장애우  10,000원<br><br>단체(20인 이상)<br>성인(만19~64세 미만) 9,000원 / 청소년(만13~18세) 8,000원 / 어린이(36개월~12세) 6,000원, 경로(만 65세 이상), 국가유공자, 장애우  10,000원',NULL, '1-2시간');
INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
141105 , '경남고성공룡세계엑스포' , 20221001 , 20221030 , '경상남도 고성군 당항만로 1116', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/38/2828038_image2_1.jpg', 128.3915388600, 35.0533471834, 6, 36, 3, '055)670-3814', 
'<a href="http://www.dino-expo.com" target="_blank" title="새창:경남고성공룡세계엑스포 홈페이지로 이동">http://www.dino-expo.com</a>', "공룡나라 고성에서 <2022경남고성공룡세계엑스포>가 2022년 10월 1일부터 10월 30일까지 코로나 이후 개최되는 최대 행사로 당항포관광지에서 개최된다. '끝나지 않은 모험'이라는 주제로 열리는 이번 공룡엑스포에서는 공룡을 주제로 한 대한민국 최대 규모의 공룡퍼레이드와 첨단영상과 디지털 기술을 바탕으로 복원된 공룡을 만나볼 수 있는 공룡 5D영상관, 오색 빛깔 미디어아트 존, 다양한 공룡이 살아 숨쉬는 공룡 캐릭터관, 다채로운 공룡 체험 등을 구성하여 다양한 공룡콘텐츠를 선보인다.", 
'고성군 당항포관광지', NULL, NULL, '대인(만 19세 ~ 만 64세) 18,000원 (사전예매 12,000원)<br>소인(만 3세 ~ 만 18세) 12,000원 (사전예매 6,000원)<br>※ 무료: 만 3세미만 어린이, 국가(독립)유공자 및 유족, 중증(구 1~3급) 장애인, 교육기관 인솔교사(사전등록필요), 단체관람객 유치자',NULL, NULL);
INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
293084 , '영동난계국악축제' , 20221006 , 20221009 , '충청북도 영동군 영동읍 중앙로 11', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/01/2689801_image2_1.png', 127.7729881364, 36.1770756832, 6, 33, 4, '043-740-3213', 
'<a href="http://ydft.kr" target="_blank" title="새창:영동난계국악축제 홈페이지로 이동">http://ydft.kr</a>', "영동난계국악축제는 한국에서 3대 악성 중 하나로 꼽히는 난계(蘭溪) 박연(朴堧) 선생이 태어나고 자란 영동에서 열리는 국악축체이다. 한국 유일의 국악축제로, 정통 국악공연부터 퓨전국악까지 다양한 국악공연이 펼쳐진다. 국악기를 직접 연주해보고 만드는 과정을 체험해볼 수 있으며, 어가행렬 및 종묘제례 시연 등의 볼거리도 풍성하다. 영동난계국악축제는 한국 최고의 와인을 소개하는 축제인 대한민국 와인축제와 함께 열린다. 한국 전통음악의 아름다운 선율과 향이 깊은 와인을 함께 즐기는 특별한 시간을 가져볼 수 있다.

[축제TIP] 난계 박연 선생이란?
고려우왕 4년인 1378년 영동군 심천면 고당리에서 출생하였으며 궁중음악을 전반적으로 개혁함과 동시에 전통음악의 기반까지 구축하여 고구려 왕산악, 신라의 우륵과 함께 우리나라 3대 악성으로 추앙받고 있다.
*난계(蘭溪): 바위틈에서 날렵히 피어난 고고한 난초의 자태에 매료되어 자신의 호를 난계로 정함", 
'영동레인보우힐링관광지', NULL, NULL, '무료(일부체험 유료)','전연령가능', '기간내자유');
INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
293030 , '안성 남사당놀이 상설공연' , 20220326 , 20221126 , '경기도 안성시 보개면 남사당로 198-2', NULL, 'A02080100', 'http://tong.visitkorea.or.kr/cms/resource/52/2607852_image2_1.jpg', 127.3101448759, 37.0318221187, 6, 31, 16, '031-678-2518', 
'<a href="https://www.anseong.go.kr/tourPortal/namsadang/main.do" target="_blank" title="새창: 안성 남사당놀이 홈페이지로 이동">https://www.anseong.go.kr</a>', "남사당은 조선후기 전문 공연 예술가들로 결성된 우리나라 최초의 대중 연예집단이다. 안성시립 남사당바우덕이풍물단은 옛 남사당의 근거지였던 안성에서 이를 계승 발전하고자 창단되었으며 우리의 전통문화인 남사당놀이를 재현하고 현대화하여 매해3월부터 11월까지 상설공연을 하고있다.", 
'안성남사당공연장', NULL, NULL, '일반 성인 10,000원 중고등학생 5,000원 어린이 2,000','6세이상', '2시간(기간내자유)');
INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
292961 , '왕궁 수문장 교대의식' , 20220101 , 20221231 , '서울특별시 중구 세종대로 99', '(정동)', 'A02080100', 'http://tong.visitkorea.or.kr/cms/resource/32/2804532_image2_1.jpg', 126.9761046145, 37.5650460435, 6, 1, 24, '02-737-6444', 
'덕수궁 <a href="http://www.deoksugung.go.kr/c/event/1" target="_blank" title="새창: 행사 홈페이지로 이동">http://www.deoksugung.go.kr</a><br>왕궁수문장교대의식 <a href="http://www.royalguard.kr" target="_blank" title="새창 : 왕궁수문장교대의식">http://www.royalguard.kr</a>', "지난 1996년부터 역사전문가들의 철저한 고증을 바탕으로 왕궁수문장교대의식이 일반인들에게 보여지고 있다. 덕수궁 대한문 앞에서 선보이는 왕궁수문장교대의식은 영국 왕실의 근위병교대의식과 같은 한국 전통의 궁중문화 재현 행사로서, 왕실문화를 직접 체험하기 어려운 요즈음 진귀한 구경거리를 제공하고 있다. 정해진 시간에 궁궐의 문을 열고 닫는 것에서부터, 경비, 순찰의 임무를 맡고 있는 수문장들은 고유의 의상을 입은 채 하루 3회 교대의식을 갖는다.<br>일년 365일 덕수궁 대한문 앞에서 재현되는 왕궁수문장교대의식은 꼭 관람 해볼만한 볼거리다. 오전 11시 00분부터 11시 40분까지 오후 2시부터 2시 40분까지, 마지막으로 오후 3시 30분부터 4시 30분까지 하루 3차례 같은 순서대로 진행되고 있으므로 원하는 시간에 방문해 관람하면 된다. 왕궁수문장교대의식의 관람은 무료이며, 매주 월요일과 혹독한 추위와 더위가 있는 날에는 행사를 진행하지 않는다. 왕궁수문장교대의식은 다양한 전통 악기를 앞세운 채 교대조가 등장하면서 시작한다. 그 후 정해진 암호를 상호간에 알려 아군인지를 확인하는 절차를 마친다. 그 후에는 약 8분간 수위의식, 7분간의 교대의식, 그리고 마지막으로 예를 마치고 순찰을 도는 것으로 의식은 끝이 난다. 6개 관직의 군사 18명이 북을 치며 큰소리로 의식을 진행하는 모습에서는 박진감이 느껴진다.<br>한국 전통의 궁중 문화 행사인 왕궁수문장 교대의식은 한국에서 보기 어려운 전통적인 모습을 볼 수 있는 절호의 기회다. 또한 군사들의 화려하고 원색적인 색상의 전통 의상 또한 충분히 볼거리를 제공한다. 때문에 군사들을 배경으로 한 사진촬영은 필수다. 2012년 4월 부터 '수문장속으로'라는 행사가 신설이되어 교대의식 사이에 군사들과 기념촬영을 할 수 있는 포토타임을 가질 수 있다. 또한  '나도수문장이다'라는 프로그램에서는 일반인들도 간단한 참여방식을 통해 직접 수문장이 되어 왕궁수문장교대의식을 체험할 수 있다. 교대의식을 관람한 후에는 직접 궁 안으로 들어가 또 한번 한국적인 아름다움을 만끽해보자.", 
'서울 덕수궁 대한문', NULL, NULL, '무료','전연령 가능', '30분');
INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
140930 , '제61회 탐라문화제' , 20221006 , 20221010 , '제주특별자치도 제주시 중앙로 2', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/58/2844258_image2_1.jpg', 126.5246670689, 33.5181838831, 6, 39, 4, '064-753-3287', 
'<a href="http://www.tamnafestival.kr/" target="_blank" title="새창:탐라문화제 홈페이지로 이동">http://www.tamnafestival.kr/</a>', "탐라문화제는 지난 1962년 문화예술인들이 참여한 순수예술단체인 제주예총이 주최하여 '제주예술제'라는 이름으로 탄생되었다.<br>제주예술제는 1965년 4회 때부터 한라문화제로 이름을 바뀌면서 전통문화와 현대예술이 조화를 이룬 종합적인 향토문화축제로 전환되면서 더욱 다채로워져서 제주를 대표하는 문화축전으로 그 위상을 한껏 드높였다. 이처럼 성장해 온 한라문화제는 2002년 제41회부터 '탐라문화제'로 개칭하고 '제주의 유구한 역사와 고유한 문화전통'을 되살리는 문화축제로 그 성격과 내용을 재정립했다.<br>탐라문화제는 개천예술제와 백제문화제와 더불어 전국의 3대문화축제로 성장하였고, 2004년부터는 문화관광부에서 우수 지역 민속축제로 지정되기도 했다.<br>탐라문화제에서 발굴된 방앗돌굴리는노래와 귀리겉보리농사일소리, 멸치후리는소리와 해녀노래, 불미공예를 비롯한 여러 민요 종목들이 제주도무형문화재로 지정되어 보배로운 문화유산으로 보존 전승되고 있다. 탐라문화제는 제주의 축제 발전에도 크게 공헌했다. 조랑말경주는 제주마 축제로 성장했고 남제주군의 특성행사로 열렸던 성읍민속마을의 정의골한마당축제와 덕수리전통민속재현행사는 지역문화축제로 발전하면서 그 우수성을 널리 떨치고 있으며 도내 수협들이 주관했던 바다축제는 제주해녀문화축제로 승화되어 세계화를 도모하고 있다.<br>전국의 다양한 축제 중에서도 유일하게 열려 오고 있는 언어축제인 '제주어 축제'는 사라져 가는 구수한 제주사투리를 생활 속에 되살리는 중심 축제로 성장하여, '제주어보존전승조례'를 제정하는 문화정책으로 승화되었고 다양한 측면에서 제주어교육과 연구를 확산시키는데 기여하고 있다.", 
'탑동해변공연장, 탑동광장, 탐라광장 등 제주도일원', NULL, NULL, '무료','전연령가능', '1시간~10시간');
INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
140911 , '홍성남당항대하축제' , 20220827 , 20221030 , '충청남도 홍성군 서부면 남당항로 213-1', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/59/2736259_image2_1.JPG', 126.4721144284, 36.5395946637, 6, 34, 15, '010-3288-9551', 
'<a href="https://smartstore.naver.com/namdanghang" target="_blank" title="새창: 홍성문화관광 홈페이지로 이동"> 
https://smartstore.naver.com/namdanghang</a>', "서해안 가을 대표 먹거리 “대하”는 전국 어느곳에 누구에게 물어봐도 ‘대하’하면 홍성 남당리를 떠올린다. 그 이유는 한번이라도 홍성 남당리를 찾아 대하의 맛을 본 사람이라면 그 담백한 맛과 구수한 향을 잊지 못해서 일 것이다.<br>꽃게, 새조개, 쭈꾸미 등의 어종이 풍부한 남당항은 천수만에 위치한 청정 어항으로, 9월 초순에서 10월 중순에는 대하를 찾아 전국에서 모여든 미식가들의 발길이 끊이지 않는 우리나라 최대의 대하축제가 열리는 곳이다. 남당리 대하축제는 매년 9~10월경에 열리고, 축제기간 남당항을 방문하면 맨손대하잡이체험과 아름다운 낙조를 만나볼 수 있다.", 
'남당항일원', NULL, NULL, '홈페이지 참조',NULL, NULL);
INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
140799 , '2022 부산국제록페스티벌' , 20221001 , 20221002 , '부산광역시 사상구 삼락동', NULL, 'A02070200', 'http://tong.visitkorea.or.kr/cms/resource/56/2841856_image2_1.jpg', 128.9735266634, 35.1688392540, 6, 6, 9, '고객 문의용 051-713-5000<br>티켓 관련 문의 051-713-5051<br>협찬 및 참가 관련 문의 051-713-5053', 
'<a href="https://www.busanrockfestival.com/" target="_blank" title="새창:부산 국제록페스티벌 홈페이지로 이동">www.busanrockfestival.com</a>', "2022 부산국제록페스티벌은 2000년 첫 개최된 이래 2022년 제23회를 맞는 국내 최장수 록페스티벌로 부산에서 펼쳐지는 역동적인 아시아 대표 록페스티벌로 자리매김 하고 있다. 부산을 비롯한 전국의 인디밴드들과 국내외 최정상 밴드 공연으로 사상구 삼락생태공원에서 개최되고 있으며, 국내 최고 수준의 라인업을 자랑하고 있다. 2022 부산국제록페스티벌은 국제교류 활성화를 통한 아티스트 교류사업을 진행해오고 있다.", 
'사상구 삼락생태공원 일원', NULL, NULL, '[1일권] 88,000원<br>[2일권] 132,000원','제한 없음', '약 12시간');
INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
140752 , '서산해미읍성축제' , 20221007 , 20221009 , '충청남도 서산시 남문2로 143 해미읍성', NULL, 'A02070100', 'http://tong.visitkorea.or.kr/cms/resource/49/2816649_image2_1.jpg', 126.5503944175, 36.7136037541, 6, 34, 7, '041-660-2697', 
'<a href="http://www.haemifest.com/" target="_blank" title="새창:서산해미읍성역사축제 홈페이지로 이동">http://www.haemifest.com/</a>', "서산 해미읍성축제는 타임머신을 타고 조선시대로 돌아 간 듯한 느낌을 받을 만큼 축제장 전체를 옛 모습 그대로 완벽하게 재현했다. 
성내 숙영 프로그램, 역사마당극, 야간미디어파사드 등 다채로운 프로그램으로 인기가 높으며, 교육적 효과도 높아 전국적인 축제로 자리매김하고 있다.", 
'해미읍성 일원', NULL, NULL, '무료(일부프로그램 유료)',NULL, NULL);
INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
140660 , '국립민속박물관 우리민속한마당' , 20210101 , 20221224 , '서울특별시 종로구 삼청로 37', '(세종로)', 'A02080100', NULL, 126.9788705506, 37.5819663482, 6, 1, 23, '02-3704-3114', 
'<a href="https://www.nfm.go.kr/user/bbs/home/4/94/bbsDataList.do" target="_blank" title="새창: 홈페이지로 이동">https://www.nfm.go.kr</a>', "국립민속박물관은 국내에서 가장 많은 관람객(연간 3,000,000명 이상)이 방문하는 우리나라의 민속문화 관련 대표박물관이다. 국립민속박물관은 박물관을 찾은 국내외 관람객들을 위해 매주 주말에 우리민속한마당공연을 개최하고 있다. 우리민속한마당은 관람객들에게 살아있는 우리 무형문화유산을 소개하고 전통문화를 쉽게 이해할 수 있는 계기를 제공하고, 무형문화유산을 계승해 오고 있는 신진, 기성 연희자들에게 무대 공연의 기회를 제공하여 전통문화의 전승과 발전을 도모하고자 기획되었다.", 
'온라인개최', NULL, NULL, NULL,'연령제한없음', NULL);
INSERT INTO eventTBL (eventID, eventName, startDate, endDate, addr1, addr2, kind, pic, mapx, mapy, mlevel, areacode, sigungucode, tel, homepage, overview, eventplace,bookingplace, subevent, price, agelimit, eventtime) VALUES ( 
140665 , '한국의집 전통예술공연 KOREA 심청' , 20220101 , 20221231 , '서울특별시 중구 퇴계로36길 10', '(필동2가)', 'A02080100', NULL, 126.9945752914, 37.5601774962, 6, 1, 24, '02-2266-9101~3', 
'<a href="https://www.chf.or.kr/combine/content/list/550" target="_blank" title="새창: 종묘대제 홈페이지로 이동">https://www.chf.or.kr</a>', "한국의 집은 지난 20여 년간 한국의 전통예술공연을 해온 공연장으로서, 풍물놀이, 탈춤, 판소리, 시나위 합주 등 한국의 다양한 궁중무용과 민속무용을 관람할 수 있는 곳이다. 

고품격의 궁중무용에서부터 서민들의 흥이 살아 있는 민속무용, 풍물, 탈춤과 대금, 아쟁, 가야금의 전통음악 연주까지 한국음악과 공연의 다양함과 풍부함을 관람할 수 있다. 
지금까지  국가지정 무형문화재 예능보유자인 안숙선, 박병천, 이춘희 등이 한국의 집 전통예술공연에 출연하였으며, 현재는 예능보유자 정재만 선생이 예술감독으로 무대를 이끌고 있다", 
'한국의 집 민속극장', NULL, NULL, '50,000원',NULL, NULL);
INSERT INTO `MainEventTBL` VALUES (1,'어디가?는 처음이신가요?', 'https://asset.cloudinary.com/drgsu4lyo/8d2274a6637ba6401ddea4e6f081c9ac', NULL);
INSERT INTO `MainEventTBL` VALUES (2,'산림에서 힐링하자', 'http://tong.visitkorea.or.kr/cms/resource/24/2804924_image2_1.jpg',2713558);
INSERT INTO `MainEventTBL` VALUES (3,'낭만적인 드론 라이트 쇼!', 'http://tong.visitkorea.or.kr/cms/resource/20/2822720_image2_1.jpg',2786391);
INSERT INTO `MainEventTBL` VALUES (4,'나랑 공룡보러 갈래?', 'http://tong.visitkorea.or.kr/cms/resource/38/2828038_image2_1.jpg',141105);
INSERT INTO `MainEventTBL` VALUES (5,'취업난 이겨내자 강원청년 모두모여~~!', 'http://tong.visitkorea.or.kr/cms/resource/74/2829874_image2_1.png',2829875);
INSERT INTO `MainEventTBL` VALUES (6,'영화제를 한다구요...? 농촌에서요...?', 'http://tong.visitkorea.or.kr/cms/resource/80/2809280_image2_1.jpg',2809281);
INSERT INTO `KeywordTBL` VALUES (1, '밤');
INSERT INTO `KeywordTBL` VALUES (1,'야시장');
INSERT INTO `KeywordTBL` VALUES (1,'먹거리');
INSERT INTO `KeywordTBL` VALUES (1,'진흙');
INSERT INTO `KeywordTBL` VALUES (1,'축제');
INSERT INTO `UserVisitedTBL` VALUES (1, 141105, 'g');
INSERT INTO `UserVisitedTBL` VALUES (1, 506545, 'b');
INSERT INTO `UserVisitedTBL` VALUES (1, 629718, 's');
INSERT INTO `UserVisitedTBL` VALUES (1, 2561750, 'g');
INSERT INTO `UserVisitedTBL` VALUES (1, 2612274, 'b');
INSERT INTO `UserVisitedTBL` VALUES (11, 141105, 'g');
INSERT INTO `UserVisitedTBL` VALUES (11, 506545, 'b');
INSERT INTO `UserVisitedTBL` VALUES (34, 141105, 's');
INSERT INTO `UserVisitedTBL` VALUES (25, 506545, 'g');
INSERT INTO `UserVisitedTBL` VALUES (41, 141105, 'b');
INSERT INTO `UserVisitedTBL` VALUES (17, 141105, 'g');
INSERT INTO `UserVisitedTBL` VALUES (41, 2561750, 'b');
INSERT INTO `UserVisitedTBL` VALUES (35, 2612274, 's');
INSERT INTO `UserVisitedTBL` VALUES (45, 2612274, 'g');
INSERT INTO `UserVisitedTBL` VALUES (19, 2612274, 'b');
INSERT INTO `UserSavedTBL` VALUES (1, 2713558);
INSERT INTO `UserSavedTBL` VALUES (1, 2786391);
INSERT INTO `UserSavedTBL` VALUES (1, 2809281);
INSERT INTO `UserSavedTBL` VALUES (1, 2819403);
INSERT INTO `UserSavedTBL` VALUES (1, 2829875);
INSERT INTO `UserSavedTBL` VALUES (7, 140665);
INSERT INTO `UserSavedTBL` VALUES (12, 2713558);
INSERT INTO `UserSavedTBL` VALUES (14, 2713558);
INSERT INTO `UserSavedTBL` VALUES (17, 140660);
INSERT INTO `UserSavedTBL` VALUES (31, 293030);
INSERT INTO `UserSavedTBL` VALUES (32, 293030);
INSERT INTO `UserSavedTBL` VALUES (33, 293030);
INSERT INTO `UserSavedTBL` VALUES (34, 293030);
INSERT INTO `UserSavedTBL` VALUES (35, 293030);
INSERT INTO `UserSavedTBL` VALUES (32, 2713558);
INSERT INTO `UserSavedTBL` VALUES (33, 2713558);
INSERT INTO `UserSavedTBL` VALUES (34, 2713558);
INSERT INTO `UserSavedTBL` VALUES (35, 2713558);
INSERT INTO `UserSavedTBL` VALUES (34, 140660);
INSERT INTO `UserSavedTBL` VALUES (35, 140660);
INSERT INTO `UserSavedTBL` VALUES (21, 140799);
INSERT INTO `UserSavedTBL` VALUES (27, 292961);
INSERT INTO `UserSavedTBL` VALUES (25, 2713558);
INSERT INTO `UserSavedTBL` VALUES (41, 2713558);
INSERT INTO `UserSavedTBL` VALUES (17, 2713558);
INSERT INTO `UserSavedTBL` VALUES (41, 2786391);
INSERT INTO `UserSavedTBL` VALUES (38, 2713558);
INSERT INTO `UserSavedTBL` VALUES (45, 2713558);
INSERT INTO `UserSavedTBL` VALUES (48, 141220);
INSERT INTO `UserSavedTBL` VALUES (19, 2713558);
INSERT INTO `SearchTBL` (word) VALUES ('워터밤');
INSERT INTO `SearchTBL` (word) VALUES ('워터밤');
INSERT INTO `SearchTBL` (word) VALUES ('워터밤');
INSERT INTO `SearchTBL` (word) VALUES ('워터밤');
INSERT INTO `SearchTBL` (word) VALUES ('워터밤');
INSERT INTO `SearchTBL` (word) VALUES ('워터밤');
INSERT INTO `SearchTBL` (word) VALUES ('물총');
INSERT INTO `SearchTBL` (word) VALUES ('물총');
INSERT INTO `SearchTBL` (word) VALUES ('물총');
INSERT INTO `SearchTBL` (word) VALUES ('물총');
INSERT INTO `SearchTBL` (word) VALUES ('물총');
INSERT INTO `SearchTBL` (word) VALUES ('음악');
INSERT INTO `SearchTBL` (word) VALUES ('음악');
INSERT INTO `SearchTBL` (word) VALUES ('음악');
INSERT INTO `SearchTBL` (word) VALUES ('음악');
INSERT INTO `SearchTBL` (word) VALUES ('백예린');
INSERT INTO `SearchTBL` (word) VALUES ('아이유');
INSERT INTO `SearchTBL` (word) VALUES ('재즈');
INSERT INTO `SearchTBL` (word) VALUES ('수영');
INSERT INTO `SearchTBL` (word) VALUES ('불꽃놀이');
INSERT INTO `SearchTBL` (word) VALUES ('수박');
INSERT INTO `SearchTBL` (word) VALUES ('야시장');