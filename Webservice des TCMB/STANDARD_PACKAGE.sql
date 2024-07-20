--------------------------------------------------------
--  File created - Cumartesi-Temmuz-20-2024   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package STANDARD_PACKAGE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "STANDARD_PACKAGE" AS
    FUNCTION finden_werktag (
        p_datum IN DATE
    ) RETURN NUMBER;

    PROCEDURE oracle_wallet_anrufen (
        p_ordner_erweiterung IN VARCHAR2,
        p_passwort           IN VARCHAR2
    );

END standard_package;

/

--------------------------------------------------------
--  File created - Cumartesi-Temmuz-20-2024   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package Body STANDARD_PACKAGE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "STANDARD_PACKAGE" AS

    FUNCTION finden_werktag (
        p_datum IN DATE
    ) RETURN NUMBER IS
    
    /*Declarations*/
        v_count   NUMBER;
        v_werktag NUMBER;
    BEGIN
        SELECT
            COUNT(1)
        INTO v_count
        FROM
            werktag w
        WHERE
                w.datum = p_datum
            AND w.wochenendefeıertag = 0
            AND w.natıonalefeıertag = 0
            AND w.relıgıosefeıertag = 0
            AND w.anderefeıertag = 0;

        IF v_count = 0 THEN
            v_werktag := 0;
        ELSE
            v_werktag := 1;
        END IF;

        RETURN v_werktag;
    END;

    PROCEDURE oracle_wallet_anrufen (
        p_ordner_erweiterung IN VARCHAR2,
        p_passwort           IN VARCHAR2
    ) IS
    BEGIN
        utl_http.set_wallet(p_ordner_erweiterung, p_passwort);
    END oracle_wallet_anrufen;

END standard_package;

/
