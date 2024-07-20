--------------------------------------------------------
--  File created - Cumartesi-Temmuz-20-2024   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package WS_TCMB
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "WS_TCMB" AS
    PROCEDURE tcmb_devisenkurs_aufrufen (
        p_anfang_datum IN DATE,
        p_ende_datum   IN DATE
    );

    PROCEDURE tcmb_devisenkurs_speichern (
        p_anfang_datum IN DATE,
        p_ende_datum   IN DATE
    );
    
    FUNCTION finden_devisenkurs (
        p_datum IN DATE
    ) RETURN NUMBER;

END ws_tcmb;

/

--------------------------------------------------------
--  File created - Cumartesi-Temmuz-20-2024   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package Body WS_TCMB
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "WS_TCMB" AS

    /*Declarations*/
    p_ordner_erweiterung    VARCHAR2(50) := 'Bitte schreiben deine erweitering';
    p_passwort              VARCHAR2(50) := 'Bitte schreiben deine passwort';
    p_url                   VARCHAR2(4000);
    p_url_vorsilbe          VARCHAR2(4000) := 'https://www.tcmb.gov.tr/kurlar/';
    p_datum                 DATE;
    tcmb_url                httpurıtype;
    tcmb_xml                XMLTYPE;
    v_error_code            ausnahme.fehlercode%TYPE := NULL;
    v_error_description     ausnahme.fehlerbeschreibung%TYPE NULL;
    v_refseq                NUMBER;
    v_tcmb_devisenkurs_wert tcmb_devisenkurs%rowtype;

    PROCEDURE tcmb_devisenkurs_aufrufen (
        p_anfang_datum IN DATE,
        p_ende_datum   IN DATE
    ) IS
    BEGIN
        /*1. Oracle Wallet Anrufen*/
        standard_package.oracle_wallet_anrufen(p_ordner_erweiterung, p_passwort);
        /*2. TCMB Web Service Anrufen und Daten Speichern*/
        ws_tcmb.tcmb_devısenkurs_speıchern(p_anfang_datum, p_ende_datum);
    END tcmb_devisenkurs_aufrufen;
    
    FUNCTION finden_devisenkurs(p_datum IN DATE) RETURN NUMBER IS
    /*Declarations*/
    v_count number;
    v_bestehend number;
    BEGIN
        select count(1) INTO v_count from tcmb_devisenkurs t where t.tarih = p_datum;
        
        IF v_count = 0 THEN
            v_bestehend := 0;
        ELSE
            v_bestehend := 1;
        END IF;

        RETURN v_bestehend;
        
    END finden_devisenkurs;

    PROCEDURE tcmb_devisenkurs_speichern (
        p_anfang_datum IN DATE,
        p_ende_datum   IN DATE
    ) IS
    BEGIN
        p_datum := p_anfang_datum;
        LOOP
            /*Ob Der Tag ein Werktag ist oder nicht*/
            IF standard_package.fınden_werktag(p_datum) = 1 AND finden_devisenkurs(p_datum) = 0 THEN
                p_url := p_url_vorsilbe
                         || to_char(p_datum, 'YYYYMM')
                         || '/'
                         || to_char(p_datum, 'DDMMYYYY')
                         || '.xml';

                BEGIN
                    tcmb_url := httpurıtype.createurı(p_url);
                    tcmb_xml := tcmb_url.getxml();
                    INSERT INTO ws_tcmb_xml (
                        data_date,
                        xml_data
                    ) VALUES (
                        p_datum,
                        tcmb_xml
                    ) RETURNING seq INTO v_refseq;

                    FOR i IN 0..21 LOOP
                        BEGIN
                            INSERT INTO tcmb_devisenkurs (
                                refseq,
                                tarih,
                                data_date,
                                bulten_no,
                                crossorder,
                                code,
                                currencycode,
                                unit,
                                isim,
                                currencyname,
                                forexbuying,
                                forexselling,
                                banknotebuying,
                                banknoteselling,
                                crossrateusd,
                                crossrateother
                            )
                                SELECT
                                    v_refseq,
                                    extractvalue(xml_data, '/Tarih_Date/@Tarih'),
                                    TO_DATE(extractvalue(xml_data, '/Tarih_Date/@Date'),
                                            'dd/mm/yyyy'),
                                    extractvalue(xml_data, '/Tarih_Date/@Bulten_No'),
                                    extractvalue(xml_data, '/Tarih_Date/Currency['
                                                           || i
                                                           || ']/@CrossOrder'),
                                    extractvalue(xml_data, '/Tarih_Date/Currency['
                                                           || i
                                                           || ']/@Code'),
                                    extractvalue(xml_data, '/Tarih_Date/Currency['
                                                           || i
                                                           || ']/@CurrencyCode'),
                                    extractvalue(xml_data, '/Tarih_Date/Currency['
                                                           || i
                                                           || ']/Unit'),
                                    replace(replace(replace(extractvalue(xml_data, '/Tarih_Date/Currency['
                                                                                   || i
                                                                                   || ']/Isim'),
                                                            'Ä°',
                                                            'İ'),
                                                    'Ã',
                                                    'Ç'),
                                            'Ã',
                                            'Ü'),
                                    extractvalue(xml_data, '/Tarih_Date/Currency['
                                                           || i
                                                           || ']/CurrencyName'),
                                    replace(extractvalue(xml_data, '/Tarih_Date/Currency['
                                                                   || i
                                                                   || ']/ForexBuying'),
                                            '.',
                                            ','),
                                    replace(extractvalue(xml_data, '/Tarih_Date/Currency['
                                                                   || i
                                                                   || ']/ForexSelling'),
                                            '.',
                                            ','),
                                    replace(extractvalue(xml_data, '/Tarih_Date/Currency['
                                                                   || i
                                                                   || ']/BanknoteBuying'),
                                            '.',
                                            ','),
                                    replace(extractvalue(xml_data, '/Tarih_Date/Currency['
                                                                   || i
                                                                   || ']/BanknoteSelling'),
                                            '.',
                                            ','),
                                    replace(extractvalue(xml_data, '/Tarih_Date/Currency['
                                                                   || i
                                                                   || ']/CrossRateUSD'),
                                            '.',
                                            ','),
                                    replace(extractvalue(xml_data, '/Tarih_Date/Currency['
                                                                   || i
                                                                   || ']/CrossRateOther'),
                                            '.',
                                            ',')
                                FROM
                                    ws_tcmb_xml w
                                WHERE
                                    w.seq = v_refseq;

                        EXCEPTION
                            WHEN OTHERS THEN
                                v_error_description := sqlerrm;
                                INSERT INTO ausnahme (
                                    DATA_DATUM,
                                    AUSNAHME_METHOD,
                                    FEHLERCODE,
                                    FEHLERBESCHREIBUNG
                                ) VALUES (
                                    p_datum,
                                    'WS_TCMB.TCMB_DEVISENKURS_SPEICHERN',
                                    3,
                                    v_error_description
                                );
                        END;
                    END LOOP;

                    EXIT WHEN p_datum = p_ende_datum;
                    p_datum := p_datum + 1;
                EXCEPTION
                    WHEN OTHERS THEN
                        v_error_description := sqlerrm;
                        INSERT INTO ausnahme (
                            DATA_DATUM,
                            AUSNAHME_METHOD,
                            FEHLERCODE,
                            FEHLERBESCHREIBUNG
                        ) VALUES (
                            p_datum,
                            'WS_TCMB.TCMB_DEVISENKURS_SPEICHERN',
                            1,
                            v_error_description
                        );

                        EXIT WHEN p_datum = p_ende_datum;
                        p_datum := p_datum + 1;
                END;

            ELSE
                INSERT INTO ausnahme (
                    DATA_DATUM,
                    AUSNAHME_METHOD,
                    FEHLERCODE,
                    FEHLERBESCHREIBUNG
                ) VALUES (
                    p_datum,
                    'WS_TCMB.TCMB_DEVISENKURS_SPEICHERN',
                    2,
                    'Das ist kein Arbetistag oder Es gibt Daten für gleiche Tag'
                );
                EXIT WHEN p_datum = p_ende_datum;
                p_datum := p_datum + 1;
            END IF;
        END LOOP;

    END tcmb_devisenkurs_speichern;

END ws_tcmb;

/
