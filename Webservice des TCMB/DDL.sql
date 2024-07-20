/*DDL - Datendefinitionssprache*/

/*AUSNAHME*/
--------------------------------------------------------
--  File created - Cumartesi-Temmuz-20-2024   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Table AUSNAHME
--------------------------------------------------------
CREATE TABLE "AUSNAHME" (
    "SEQ"               NUMBER
        GENERATED ALWAYS AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER NOCYCLE
        NOKEEP NOSCALE,
    "DATA_DATUM"         DATE,
    "AUSNAHME_METHOD"  VARCHAR2(100),
    "FEHLERCODE"        NUMBER,
    "FEHLERBESCHREIBUNG" VARCHAR2(4000),
    "SQLERRM"           VARCHAR2(4000)
)
--------------------------------------------------------
--  Constraints for Table AUSNAHME
--------------------------------------------------------

ALTER TABLE "AUSNAHME" MODIFY (
    "SEQ"
        NOT NULL ENABLE
)

/*FEIERTAGART*/
--------------------------------------------------------
--  File created - Cumartesi-Temmuz-20-2024   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Table FEIERTAGART
--------------------------------------------------------

CREATE TABLE "FEIERTAGART" (
    "SEQ"             NUMBER
        GENERATED ALWAYS AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER NOCYCLE
        NOKEEP NOSCALE,
    "FEIERTAGNUMMBER" NUMBER,
    "FEIERTAGNAME"    VARCHAR2(4000)
)
--------------------------------------------------------
--  Constraints for Table FEIERTAGART
--------------------------------------------------------

ALTER TABLE "FEIERTAGART" MODIFY (
    "SEQ"
        NOT NULL ENABLE
)

/*FEIERTAGGRUND*/
--------------------------------------------------------
--  File created - Cumartesi-Temmuz-20-2024   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Table FEIERTAGGRUND
--------------------------------------------------------

CREATE TABLE "FEIERTAGGRUND" (
    "SEQ"             NUMBER
        GENERATED ALWAYS AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER NOCYCLE
        NOKEEP NOSCALE,
    "FEIERTAGNUMMBER" NUMBER,
    "FEIERTAGGRUND"   NUMBER,
    "ZEIT"            NUMBER(2, 1),
    "BESCHREIBUNG"    VARCHAR2(100)
)
--------------------------------------------------------
--  Constraints for Table FEIERTAGGRUND
--------------------------------------------------------

ALTER TABLE "FEIERTAGGRUND" MODIFY (
    "SEQ"
        NOT NULL ENABLE
)

/*TCMB_DEVISENKURS*/
--------------------------------------------------------
--  File created - Cumartesi-Temmuz-20-2024   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Table TCMB_DEVISENKURS
--------------------------------------------------------

CREATE TABLE "TCMB_DEVISENKURS" (
    "SEQ"             NUMBER
        GENERATED ALWAYS AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER NOCYCLE
        NOKEEP NOSCALE,
    "REFSEQ"          NUMBER,
    "TARIH"           DATE,
    "DATA_DATE"       DATE,
    "BULTEN_NO"       VARCHAR2(8),
    "CROSSORDER"      VARCHAR2(2),
    "CODE"            VARCHAR2(3),
    "CURRENCYCODE"    VARCHAR2(3),
    "UNIT"            NUMBER,
    "ISIM"            VARCHAR2(100),
    "CURRENCYNAME"    VARCHAR2(100),
    "FOREXBUYING"     NUMBER(18, 4),
    "FOREXSELLING"    NUMBER(18, 4),
    "BANKNOTEBUYING"  NUMBER(18, 4),
    "BANKNOTESELLING" NUMBER(18, 4),
    "CROSSRATEUSD"    NUMBER(18, 4),
    "CROSSRATEOTHER"  NUMBER(18, 4)
)
--------------------------------------------------------
--  Constraints for Table TCMB_DEVISENKURS
--------------------------------------------------------

ALTER TABLE "TCMB_DEVISENKURS" MODIFY (
    "SEQ"
        NOT NULL ENABLE
)

/*WERKTAG*/
--------------------------------------------------------
--  File created - Cumartesi-Temmuz-20-2024   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Table WERKTAG
--------------------------------------------------------

CREATE TABLE "WERKTAG" (
    "SEQ"                NUMBER
        GENERATED ALWAYS AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER NOCYCLE
        NOKEEP NOSCALE,
    "DATUM"              DATE,
    "WOCHENENDEFEIERTAG" NUMBER,
    "NATIONALEFEIERTAG"  NUMBER,
    "RELIGIOSEFEIERTAG"  NUMBER,
    "ANDEREFEIERTAG"     NUMBER
)
--------------------------------------------------------
--  Constraints for Table WERKTAG
--------------------------------------------------------

ALTER TABLE "WERKTAG" MODIFY (
    "SEQ"
        NOT NULL ENABLE
)

/*WS_TCMB_XML*/
--------------------------------------------------------
--  File created - Cumartesi-Temmuz-20-2024   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Table WS_TCMB_XML
--------------------------------------------------------

CREATE TABLE "WS_TCMB_XML" (
    "SEQ"         NUMBER
        GENERATED ALWAYS AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER NOCYCLE
        NOKEEP NOSCALE,
    "CREATE_USER" VARCHAR2(100) DEFAULT user,
    "CREATE_DATE" TIMESTAMP(6) DEFAULT systımestamp,
    "UPDATE_USER" VARCHAR2(50),
    "UPDATE_DATE" TIMESTAMP(6),
    "DATA_DATE"   DATE,
    "XML_DATA"    "XMLTYPE"
)
--------------------------------------------------------
--  Constraints for Table WS_TCMB_XML
--------------------------------------------------------

ALTER TABLE "WS_TCMB_XML" MODIFY (
    "SEQ"
        NOT NULL ENABLE
)