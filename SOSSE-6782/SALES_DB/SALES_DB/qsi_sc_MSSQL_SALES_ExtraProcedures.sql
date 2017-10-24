CREATE PROCEDURE GET_SUM_AMOUNT;2
AS
BEGIN
    DECLARE @CUSTNME    VARCHAR(32);
    DECLARE @ORDERNBR   INTEGER;
    DECLARE @PRODDESC   VARCHAR(100);
    DECLARE @AMOUNT     INTEGER;

    CREATE TABLE #GETSUMAMOUNT(
        CUSTOMER_NAME       VARCHAR(32)     NOT NULL,
        ORDER_NUMBER        INTEGER         NOT NULL,
        PRODUCT_DESCRIPTION VARCHAR(100)    NOT NULL,
        AMOUNT              INTEGER         NOT NULL);

    DECLARE getsumamount CURSOR FOR
        SELECT      ISNULL(LTRIM(RTRIM(LAST_NAME)) + ', ' + LTRIM(RTRIM(FIRST_NAME)),'none specified'),
        			O.ORDER_ID,
        			ISNULL(LTRIM(RTRIM(PRODUCT_DESCRIPTION)),'none specified'),
                    ISNULL(SUM(AMOUNT),0)
        FROM        ORDERS      O
        LEFT JOIN	ORDER_LINE  L
        		ON	O.ORDER_ID = L.ORDER_ID
        LEFT JOIN   CUSTOMER    C
        		ON	O.CUSTOMER_ID = C.CUSTOMER_ID
        LEFT JOIN	PRODUCT		P
        		ON	L.PRODUCT_ID = P.PRODUCT_ID
        GROUP BY    ISNULL(LTRIM(RTRIM(LAST_NAME)) + ', ' + LTRIM(RTRIM(FIRST_NAME)),'none specified'),
        			ISNULL(LTRIM(RTRIM(PRODUCT_DESCRIPTION)),'none specified'),
        			O.ORDER_ID
        ORDER BY	ISNULL(LTRIM(RTRIM(LAST_NAME)) + ', ' + LTRIM(RTRIM(FIRST_NAME)),'none specified'),
        			ISNULL(LTRIM(RTRIM(PRODUCT_DESCRIPTION)),'none specified'),
        			O.ORDER_ID;
    OPEN getsumamount;
    FETCH getsumamount INTO @CUSTNME,
                            @ORDERNBR,
                            @PRODDESC,
                            @AMOUNT;
    WHILE @@FETCH_STATUS = 0
        BEGIN
            INSERT INTO #GETSUMAMOUNT(
                CUSTOMER_NAME,
                ORDER_NUMBER,
                PRODUCT_DESCRIPTION,
                AMOUNT)
            VALUES( @CUSTNME,
                    @ORDERNBR,
                    @PRODDESC,
                    @AMOUNT);

            FETCH getsumamount INTO @CUSTNME,
                                    @ORDERNBR,
                                    @PRODDESC,
                                    @AMOUNT;
        END;
    CLOSE       getsumamount;
    DEALLOCATE  getsumamount;

    SELECT * FROM #GETSUMAMOUNT;
END;
GO
IF EXISTS(SELECT * FROM sysobjects WHERE type = 'P' AND name = 'GET_SUM_AMOUNT_ENCRYPTED')
    DROP PROCEDURE GET_SUM_AMOUNT_ENCRYPTED;
GO
CREATE PROCEDURE GET_SUM_AMOUNT_ENCRYPTED
WITH ENCRYPTION AS
BEGIN
    DECLARE @CUSTNME    VARCHAR(32);
    DECLARE @ORDERNBR   INTEGER;
    DECLARE @PRODDESC   VARCHAR(100);
    DECLARE @AMOUNT     INTEGER;

    CREATE TABLE #GETSUMAMOUNT(
        CUSTOMER_NAME       VARCHAR(32)     NOT NULL,
        ORDER_NUMBER        INTEGER         NOT NULL,
        PRODUCT_DESCRIPTION VARCHAR(100)    NOT NULL,
        AMOUNT              INTEGER         NOT NULL);

    DECLARE getsumamount CURSOR FOR
        SELECT      ISNULL(LTRIM(RTRIM(LAST_NAME)) + ', ' + LTRIM(RTRIM(FIRST_NAME)),'none specified'),
        			O.ORDER_ID,
        			ISNULL(LTRIM(RTRIM(PRODUCT_DESCRIPTION)),'none specified'),
                    ISNULL(SUM(AMOUNT),0)
        FROM        ORDERS      O
        LEFT JOIN	ORDER_LINE  L
        		ON	O.ORDER_ID = L.ORDER_ID
        LEFT JOIN   CUSTOMER    C
        		ON	O.CUSTOMER_ID = C.CUSTOMER_ID
        LEFT JOIN	PRODUCT		P
        		ON	L.PRODUCT_ID = P.PRODUCT_ID
        GROUP BY    ISNULL(LTRIM(RTRIM(LAST_NAME)) + ', ' + LTRIM(RTRIM(FIRST_NAME)),'none specified'),
        			ISNULL(LTRIM(RTRIM(PRODUCT_DESCRIPTION)),'none specified'),
        			O.ORDER_ID
        ORDER BY	ISNULL(LTRIM(RTRIM(LAST_NAME)) + ', ' + LTRIM(RTRIM(FIRST_NAME)),'none specified'),
        			ISNULL(LTRIM(RTRIM(PRODUCT_DESCRIPTION)),'none specified'),
        			O.ORDER_ID;
    OPEN getsumamount;
    FETCH getsumamount INTO @CUSTNME,
                            @ORDERNBR,
                            @PRODDESC,
                            @AMOUNT;
    WHILE @@FETCH_STATUS = 0
        BEGIN
            INSERT INTO #GETSUMAMOUNT(
                CUSTOMER_NAME,
                ORDER_NUMBER,
                PRODUCT_DESCRIPTION,
                AMOUNT)
            VALUES( @CUSTNME,
                    @ORDERNBR,
                    @PRODDESC,
                    @AMOUNT);

            FETCH getsumamount INTO @CUSTNME,
                                    @ORDERNBR,
                                    @PRODDESC,
                                    @AMOUNT;
        END;
    CLOSE       getsumamount;
    DEALLOCATE  getsumamount;

    SELECT * FROM #GETSUMAMOUNT;
END;
GO
IF EXISTS(SELECT * FROM sysobjects WHERE [name]=N'ORL_UPDATE_TRIG' AND type='TR')
    DROP TRIGGER ORL_UPDATE_TRIG;
GO
CREATE TRIGGER ORL_UPDATE_TRIG ON [dbo].[ORDER_LINE]
FOR UPDATE AS
   UPDATE [dbo].[ORDER_LINE]
    SET [COMMENTS]=LTRIM(RTRIM(ord.[COMMENTS]))+' updated by: '+SESSION_USER+' on: '+CONVERT(varchar(35),GETDATE())
    FROM ORDER_LINE ord INNER JOIN deleted del
    ON ord.[ORDER_ID]=del.[ORDER_ID]
    AND ord.[PRODUCT_ID]=del.[PRODUCT_ID];
GO
IF EXISTS(SELECT * FROM sysobjects WHERE [name]=N'ORL_GET_UPD_REPORT' AND type='IF')
    DROP FUNCTION ORL_GET_UPD_REPORT;
GO
CREATE FUNCTION ORL_GET_UPD_REPORT (@ORDER_ID int)
RETURNS TABLE
AS
RETURN (
SELECT   orl.ORDER_ID
        ,prod.PRODUCT_ID,ITEM_TYPE,PRODUCT_DESCRIPTION
        ,cus.CUSTOMER_ID,cus.FIRST_NAME "CUS_FIRST",cus.LAST_NAME "CUS_LAST",cus.CITY "CUS_CITY",cus.STREET "CUS_STREET",cus.ZIP_CODE "CUS_ZIP",cus.PHONE "CUS_PHONE",cus.TOTAL_SALES
        ,emp.EMPLOYEE_ID,emp.FIRST_NAME,emp.LAST_NAME,emp.CITY,emp.STREET,emp.ZIP_CODE,emp.PHONE,emp.DATE_OF_HIRE,emp.JOB,emp.DEPARTMENT
        ,AMOUNT
        ,orl.COMMENTS
        ,orl.DATE_OF_ORDER
FROM     [dbo].[ORDER_LINE]    orl
        ,[dbo].[ORDERS]        ord
        ,[dbo].[CUSTOMER]      cus
        ,[dbo].[EMPLOYEE]      emp
        ,[dbo].[PRODUCT]       prod
WHERE    orl.[ORDER_ID]<=@ORDER_ID
    AND  orl.[ORDER_ID]=ord.[ORDER_ID]
    AND  ord.[CUSTOMER_ID]=cus.[CUSTOMER_ID]
    AND  ord.[EMPLOYEE_RECIEVING]=emp.[EMPLOYEE_ID]
    AND  orl.[PRODUCT_ID]=prod.[PRODUCT_ID])
GO
/*  HOW TO EXECUTE ... VERY HEAVY
SET NOCOUNT ON
DECLARE @ORL int,@ctr int;
SELECT @ORL=0,@ctr=0;
DECLARE orl CURSOR FOR
SELECT ORDER_ID FROM ORDER_LINE;
OPEN orl;
FETCH orl INTO @ORL;
WHILE @@FETCH_STATUS=0
BEGIN
UPDATE ORDER_LINE SET AMOUNT=AMOUNT WHERE ORDER_ID=@ORL;
SELECT @ctr=@ctr+1;
IF @ctr=500
BEGIN
select @ctr=0;
SELECT * FROM ORL_GET_UPD_REPORT (@ORL);
END
FETCH orl INTO @ORL;
END
CLOSE orl;
DEALLOCATE orl;
*/