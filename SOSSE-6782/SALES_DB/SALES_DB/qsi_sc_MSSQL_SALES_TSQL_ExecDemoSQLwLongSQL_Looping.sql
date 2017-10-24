/**************************************************************************************************
**  This script contains a number of demo T-SQL statements to help illustrate the various
**  features of Quest Software's Performance Analysis for Microsoft SQL Server Product.
**
** NOTE: Before executing this script, or any elements herein, there are a number of
**  prerequisite scripts that must first be run:
**          1) qsi_sc_MSSQL_SALES_TSQL_1_CreateDBandTables.sql
**          1) qsi_sc_MSSQL_SALES_TSQL_2_LoadData.sql
**          2) qsi_sc_MSSQL_SALES_TSQL_3_CreateConstraints.sql
**          3) qsi_sc_MSSQL_SALES_TSQL_4_CreateDemoSTPs.sql
**          4) qsi_sc_MSSQL_SALES_TSQL_5_CreateDemoSTPSupplement.sql (OPTIONAL)
**
** USAGE NOTE: The entire script will run for a VERY long time (many hardware, load, network issues
**			   influence the total runtime).  For predictible results, execute the script in the
**			   labelled chunks; this also helps in presentations as each chunk is identified by the
**			   average runtime, which wait events are invoked, and to what degree.
**
** 30.08.2005   Ariel Weil          CREATED
**************************************************************************************************/
USE sales
GO
SET NOCOUNT ON
GO

DECLARE @var VARBINARY(128)
SET @var = CAST('Context_Info_Test' AS VARBINARY)
SET CONTEXT_INFO @var
GO

DECLARE @ActiveTime_Overall DATETIME,
        @ActiveTime_Major   DATETIME,
        @ActiveTime_Minor   DATETIME,
        @ActiveTime_HoldOne INTEGER,
        @ActiveTime_HoldTwo INTEGER;

SELECT  @ActiveTime_Overall = GETDATE(),
        @ActiveTime_Major   = GETDATE(),
        @ActiveTime_Minor   = GETDATE(),
        @ActiveTime_HoldOne = 0,
        @ActiveTime_HoldTwo = 0;

DECLARE  @killme int,@started datetime;
SELECT   @killme=60000 --SET THIS VALUE IN SECONDS TO END THE LOOP AFTER @killme SECONDS
        ,@started=getdate();
-- basically just throwing a bunch of column functions at SQL Server
-- to force it to think, ie. use CPU
WHILE DATEDIFF(ss,@started,getdate())<@killme
    BEGIN
        SELECT '
        This is Californication:
        Psychic spies from China Try to steal your minds elation Little girls from Sweden Dream of silver screen quotations And if you want these kind of dreams Its Californication
        Its the edge of the world And all of western civilization The sun may rise in the East At least it settles in the final location Its understood that Hollywood sells Californication
        Pay your surgeon very well To break the spell of aging Celebrity skin is this your chin Or is that war your waging
        [Chorus: First born unicorn Hard core soft porn Dream of Californication Dream of Californication]
        Marry me girl be my fairy to the world Be my very own constellation A teenage bride with a baby inside Getting high on information And buy me a star on the boulevard Its Californication
        Space may be the final frontier But its made in a Hollywood basement Cobain can you hear the spheres Singing songs off station to station And Alderons not far away Its Californication
        Born and raised by those who praise Control of population everybodys been there and I dont mean on vacation
        [Chorus: First born unicorn Hard core soft porn Dream of Californication Dream of Californication]
        Destruction leads to a very rough road But it also breeds creation And earthquakes are to a girls guitar Theyre just another good vibration And tidal waves couldnt save the world From Californication
        Pay your surgeon very well To break the spell of aging Sicker than the rest There is no test But this is what youre craving
        [Chorus: First born unicorn Hard core soft porn Dream of Californication Dream of Californication]

        And this is Fortune Faded:
        They say in chess, you gotta kill the queen  And then you mate it Oh I, do you? A funny thing, the king who gets himself assassinated Hey now, every time i lose Altitude
        You took a town by storm The mess you made was nominated Oh I, do you? Now put away your welcome, soon youll find youve overstayed it Hey now, every time I lose Altitude
        [CHORUS: So divine, hell of an elevator All the while my fortune faded Nevermind the consequences of the crime this time My fortune faded]
        The medicated state of mind you find is overrated Oh I, do you? You saw it all come down and now its time to imitate it Hey now, every time I lose altitude
        [CHORUS: So divine, hell of an elevator All the while my fortune faded Nevermind the consequences of the crime this time My fortune faded]
        (Instrumental Bridge)
        Come on God, do I seem bulletproof? Ooooooooooh
        [CHORUS: So divine, hell of an elevator All the while my fortune faded Nevermind the consequences of the crime this time My fortune faded]
        [CHORUS: So divine, hell of an elevator All the while my fortune faded Nevermind the consequences of the crime this time My fortune faded]

        And that makes a long T-SQL Statement!!' FROM master.dbo.sysprocesses CROSS JOIN dbo.sysobjects CROSS JOIN dbo.syscolumns;

        /* Section 1
        ** Heavy I/O, Moderate CPU, Network if executed from remote client
        ** Average Run Time: 30 - 45 minutes */
        DECLARE @order_id	INTEGER;
        DECLARE @oldprodid  INTEGER;
        DECLARE @product_id	INTEGER;
        SELECT	@order_id	= 0;
        SELECT  @oldprodid  = 0;
        SELECT	@product_id	= 0;

        BEGIN TRAN
        	INSERT INTO ORDER_LINE(
        		ORDER_ID,
        		PRODUCT_ID,
        		AMOUNT,
        		COMMENTS,
        		DATE_OF_ORDER)
        	SELECT DISTINCT ORDER_ID,
        				1,
        				0,
        				'Order Entered: ' + LTRIM(RTRIM(CAST(getdate() AS CHAR(100)))),
        				getdate()
        	FROM		ORDERS
        	WHERE		ORDER_ID NOT IN(SELECT ORDER_ID FROM ORDER_LINE);

            SELECT 'Time elapsed for INSERT INTO ORDER_LINE (ms)',DATEDIFF(ms,@ActiveTime_Minor,GETDATE());
            SELECT  @ActiveTime_Minor = GETDATE();

        	DECLARE updateproduct CURSOR FOR
        		SELECT  ORDER_ID,PRODUCT_ID
        		FROM	ORDER_LINE;
        	OPEN updateproduct;

            SELECT 'Time elapsed for DECLARE and OPEN CURSOR (ms)',DATEDIFF(ms,@ActiveTime_Minor,GETDATE());

        	FETCH updateproduct INTO @order_id,@oldprodid;
        	WHILE @@FETCH_STATUS = 0
        		BEGIN
        			SELECT  @product_id = 0;
                    SELECT  @ActiveTime_Minor = GETDATE();
        			SELECT  @product_id = (SELECT CAST(100*(RAND(DATEPART(ms,getdate()))) AS INTEGER));
        			IF NOT EXISTS(SELECT * FROM PRODUCT WHERE PRODUCT_ID = @product_id)
        				SELECT @product_id = (SELECT MIN(PRODUCT_ID) FROM PRODUCT WHERE PRODUCT_ID > @product_id);

                    SELECT @ActiveTime_HoldOne = @ActiveTime_HoldOne + DATEDIFF(ms,@ActiveTime_Minor,GETDATE());
                    SELECT @ActiveTime_Minor = GETDATE();

                    IF NOT EXISTS(SELECT * FROM ORDER_LINE WHERE ORDER_ID = @order_id AND PRODUCT_ID = @product_id)
            			UPDATE	ORDER_LINE
            			SET		PRODUCT_ID = @product_id,
            					AMOUNT = (SELECT CAST(1000*RAND(DATEPART(ms,getdate())) AS INTEGER))
            			WHERE	ORDER_ID = @order_id
                        AND     PRODUCT_ID = @oldprodid;

                    SELECT @ActiveTime_HoldTwo = @ActiveTime_HoldTwo + DATEDIFF(ms,@ActiveTime_Minor,GETDATE());
                    SELECT @ActiveTime_Minor = GETDATE();

        			FETCH updateproduct INTO @order_id,@oldprodid;
        		END;
        	CLOSE updateproduct;
        	DEALLOCATE updateproduct;
        ROLLBACK TRAN;

        SELECT 'Total time elapsed for IF NOT EXISTS(SELECT * FROM PRODUCT... (ms)',@ActiveTime_HoldOne;
        SELECT 'Total time elapsed for IF NOT EXISTS(SELECT * FROM ORDER_LINE... (ms)',@ActiveTime_HoldTwo;
        SELECT 'Time elapsed for Section 1 - INSERT ORDER_LINE, UPDATE PRODUCT (ms)',DATEDIFF(ms,@ActiveTime_Major,GETDATE());
        SELECT  @ActiveTime_Major = GETDATE(),
                @ActiveTime_Minor = GETDATE();

        /* Section 1a
        ** Heavy I/O, Moderate CPU, Network if executed from remote client
        ** Average Run Time: 1 minutes
        ** NOTE: this does the same as above, but with dramatically better performance */

        BEGIN TRAN
        	INSERT INTO ORDER_LINE(
        		ORDER_ID,
        		PRODUCT_ID,
        		AMOUNT,
        		COMMENTS,
        		DATE_OF_ORDER)
        	SELECT      ORDER_ID,
        				ISNULL((SELECT MAX(PRODUCT_ID) FROM PRODUCT WHERE PRODUCT_ID <= CAST(((CAST(10000*(RAND(DATEPART(ms,getdate()))) AS INTEGER)/ORDER_ID*27586)/75.14) AS INTEGER)),100) AS "PRODUCT_ID",
        				CAST((100000*RAND(DATEPART(ms,getdate())))/(ORDER_ID/21.4) AS INTEGER),
        				'Order Entered: ' + LTRIM(RTRIM(CAST(getdate() AS CHAR(100)))),
        				getdate()
        	FROM		ORDERS
        	WHERE		ORDER_ID NOT IN(SELECT ORDER_ID FROM ORDER_LINE);
        COMMIT TRAN;

        SELECT 'Time elapsed for Section 1a - INSERT ORDER_LINE CPU-intensive (ms)',DATEDIFF(ms,@ActiveTime_Major,GETDATE());
        SELECT  @ActiveTime_Major = GETDATE(),
                @ActiveTime_Minor = GETDATE();

        /* Retrieve Order Details for Customers */
        /* This is an example of a dynamic SELECT and a procedure executing the same SELECT */
        /* First issue a standard T-SQL statement */
        /* Section 2
        ** Moderate CPU, Network if executed from remote client
        ** Average Run Time: 1 - 2 minutes */

            SELECT		ISNULL(LTRIM(RTRIM(LAST_NAME)) + ', ' + LTRIM(RTRIM(FIRST_NAME)),'none specified'),
        				O.ORDER_ID,
        				ISNULL(PRODUCT_DESCRIPTION,'none specified'),
        				ISNULL(AMOUNT,0)
            FROM		ORDERS      O
        	LEFT JOIN	ORDER_LINE  L
        			ON	O.ORDER_ID = L.ORDER_ID
        	LEFT JOIN	CUSTOMER    C
        			ON	O.CUSTOMER_ID = C.CUSTOMER_ID
        	LEFT JOIN	PRODUCT     P
        			ON	P.PRODUCT_ID = L.PRODUCT_ID
        	ORDER BY	LTRIM(RTRIM(LAST_NAME)) + ', ' + LTRIM(RTRIM(FIRST_NAME)),
        				PRODUCT_DESCRIPTION,
        				AMOUNT;

        SELECT 'Time elapsed for Section 2 - TSQL Retrieve Order Details (ms)',DATEDIFF(ms,@ActiveTime_Major,GETDATE());
        SELECT  @ActiveTime_Major = GETDATE(),
                @ActiveTime_Minor = GETDATE();

        /* Then call a stored procedure that executes the same select */
        /* Section 3
        ** Moderate CPU, Network if executed from remote client
        ** Average Run Time: 1 minute */
            EXEC GET_ORDER_DETAILS;

        SELECT 'Time elapsed for Section 3 - Stored Procedure GET_ORDER_DETAILS (ms)',DATEDIFF(ms,@ActiveTime_Major,GETDATE());
        SELECT  @ActiveTime_Major = GETDATE(),
                @ActiveTime_Minor = GETDATE();

        /* Retrieve Order Sums for Customers */
        /* This is an example of a dynamic SELECT and a procedure executing the same SELECT */
        /* though with a cursor and temporary table */
        /* First issue a standard T-SQL statement */
        /* Section 4
        ** Light CPU, Network if executed from remote client
        ** Average Run Time: 10 - 30 seconds */
            SELECT      ISNULL(LTRIM(RTRIM(LAST_NAME)) + ', ' + LTRIM(RTRIM(FIRST_NAME)),'none specified'),
                        ISNULL(SUM(AMOUNT),0)
            FROM        ORDERS      O
        	LEFT JOIN	ORDER_LINE  L
        			ON	O.ORDER_ID = L.ORDER_ID
        	LEFT JOIN	CUSTOMER    C
        			ON	O.CUSTOMER_ID = C.CUSTOMER_ID
            GROUP BY    ISNULL(LTRIM(RTRIM(LAST_NAME)) + ', ' + LTRIM(RTRIM(FIRST_NAME)),'none specified');

        SELECT 'Time elapsed for Section 4 - TSQL Retrieve Order Sums (ms)',DATEDIFF(ms,@ActiveTime_Major,GETDATE());
        SELECT  @ActiveTime_Major = GETDATE(),
                @ActiveTime_Minor = GETDATE();

        /* Then call a stored procedure that executes the same select with ISNULLs so there is actually a resultset */
        /* Section 5
        ** Moderate CPU, Network if executed from remote client
        ** Average Run Time: 3 - 4 minutes */
            EXEC GET_SUM_AMOUNT;

        SELECT 'Time elapsed for Section 5 - Stored Procedure GET_SUM_AMOUNT (ms)',DATEDIFF(ms,@ActiveTime_Major,GETDATE());
        SELECT  @ActiveTime_Major = GETDATE(),
                @ActiveTime_Minor = GETDATE();

        /* Update Older Order Priority */
        /* This is an example of a dynamic UPDATE and a procedure executing the same UPDATE */
        /* Both methods rollback the change after it is made */
        /* First issue a standard T-SQL statement */
        /* Section 6
        ** Light CPU, Network if executed from remote client
        ** Average Run Time: 5 - 10 seconds */
        BEGIN TRAN
            UPDATE  ORDERS
            SET     PRIORITY = PRIORITY +1
            WHERE   DATE_OF_ORDER < getdate();
        ROLLBACK TRAN;

        SELECT 'Time elapsed for Section 6 - TSQL UPDATE ORDERS (ms)',DATEDIFF(ms,@ActiveTime_Major,GETDATE());
        SELECT  @ActiveTime_Major = GETDATE(),
                @ActiveTime_Minor = GETDATE();

        /* Then call a stored procedure that executes the same update */
        /* Section 7
        ** Light CPU, Network if executed from remote client
        ** Average Run Time: Virtually instantaneous */
        EXEC UPDATE_PRIORITY;

        SELECT 'Time elapsed for Section 7 - StoredProcedure UPDATE_PRIORITY (ms)',DATEDIFF(ms,@ActiveTime_Major,GETDATE());
        SELECT  @ActiveTime_Major = GETDATE(),
                @ActiveTime_Minor = GETDATE();

        /* Section CreateData */
        /* Insert more test data into Orders */
        BEGIN TRAN
        DECLARE @temptable TABLE(
            ORDER_ID            INT NOT NULL IDENTITY,
            CUSTOMER_ID         INT,
            DATE_OF_ORDER       DATETIME,
            PRIORITY            TINYINT,
            EMPLOYEE_RECIEVING  INT,
            STATUS              CHAR(3));

            SELECT 'Time elapsed for DECLARE @temptable (ms)',DATEDIFF(ms,@ActiveTime_Minor,GETDATE());
            SELECT  @ActiveTime_Minor = GETDATE();

            INSERT INTO @temptable(
                CUSTOMER_ID,
                DATE_OF_ORDER,
                PRIORITY,
                EMPLOYEE_RECIEVING,
                STATUS)
        	SELECT      TOP 10000 ISNULL((SELECT MAX(CUSTOMER_ID) FROM CUSTOMER WHERE CUSTOMER_ID <= CAST(((CAST(10000*(RAND(DATEPART(ms,getdate()))) AS INTEGER)/ORDER_ID*27586)/75.14) AS INTEGER)),(SELECT MAX(CUSTOMER_ID) FROM CUSTOMER WHERE CUSTOMER_ID <= RAND(ORDER_ID))),
        				getdate(),
        				1,
        				ISNULL((SELECT MAX(EMPLOYEE_ID) FROM EMPLOYEE WHERE EMPLOYEE_ID <= CAST(((CAST(10000*(RAND(DATEPART(ms,getdate()))) AS INTEGER)/267.14)) AS INTEGER)),(SELECT MAX(EMPLOYEE_ID) FROM EMPLOYEE WHERE EMPLOYEE_ID <= RAND(ORDER_ID))),
        				'bef'
        	FROM		ORDERS;

            SELECT 'Time elapsed for INSERT INTO @temptable (ms)',DATEDIFF(ms,@ActiveTime_Minor,GETDATE());
            SELECT  @ActiveTime_Minor = GETDATE();

            INSERT INTO ORDERS(
                ORDER_ID,
                CUSTOMER_ID,
                DATE_OF_ORDER,
                PRIORITY,
                EMPLOYEE_RECIEVING,
                STATUS)
            SELECT (SELECT MAX(ORDER_ID) FROM ORDERS) + ORDER_ID,
                    CUSTOMER_ID,
                    DATE_OF_ORDER,
                    PRIORITY,
                    EMPLOYEE_RECIEVING,
                    STATUS
            FROM    @temptable;

            SELECT 'Time elapsed for INSERT INTO ORDERS (ms)',DATEDIFF(ms,@ActiveTime_Minor,GETDATE());

        COMMIT TRAN;

        SELECT 'Time elapsed for Section CreateData - TSQL INSERT INTO ORDERS (ms)',DATEDIFF(ms,@ActiveTime_Major,GETDATE());
        SELECT  @ActiveTime_Major = GETDATE(),
                @ActiveTime_Minor = GETDATE();

        /* Insert test data into Order Line */
        /* This is an example of a dynamic INSERT and a procedure executing the same INSERT */
        /* Both methods rollback the change after it is made */
        /* First issue a standard T-SQL statement */
        /* Section 8
        ** Moderate-Heavy CPU, Moderate-Heavy I/O, Network if executed from remote client
        ** Average Run Time: Depends wholly on difference between records in ORDERS and ORDER_LINE */
        BEGIN TRAN
            INSERT INTO ORDER_LINE
            SELECT DISTINCT ORDER_ID,
                    0,
                    0,
                    'NEW ORDER',
                    DATE_OF_ORDER
            FROM    ORDERS
            WHERE   ORDER_ID NOT IN(SELECT  ORDER_ID
                                    FROM    ORDER_LINE);
        ROLLBACK TRAN;

        SELECT 'Time elapsed for Section 8 - TSQL INSERT INTO ORDER_LINE (ms)',DATEDIFF(ms,@ActiveTime_Major,GETDATE());
        SELECT  @ActiveTime_Major = GETDATE(),
                @ActiveTime_Minor = GETDATE();

        /* Then call a stored procedure that executes the same insert */
        /* Section 9
        ** Moderate-Heavy CPU, Moderate-Heavy I/O, Network if executed from remote client
        ** Average Run Time: Depends wholly on difference between records in ORDERS and ORDER_LINE */
        EXEC LOAD_ORDER_LINE;

        SELECT 'Time elapsed for Section 9 - Stored Procedure LOAD_ORDER_LINE (ms)',DATEDIFF(ms,@ActiveTime_Major,GETDATE());
        SELECT  @ActiveTime_Major = GETDATE(),
                @ActiveTime_Minor = GETDATE();

        /* Update Older Order Priority */
        /* This is an example of a dynamic DELETE and a procedure executing the same DELETE */
        /* Both methods rollback the change after it is made */
        /* First issue a standard T-SQL statement */
        /* Section 10
        ** Moderate CPU, Moderate I/O, Network if executed from remote client
        ** Average Run Time: Depends wholly on number of 0 amount records in ORDER_LINE */
        BEGIN TRAN
            DELETE FROM ORDER_LINE
            WHERE       AMOUNT =0;

            DELETE FROM ORDERS
            WHERE       ORDER_ID NOT IN(SELECT  DISTINCT ORDER_ID
                                        FROM    ORDER_LINE);
        ROLLBACK TRAN;

        SELECT 'Time elapsed for Section 10 - TSQL DELETE FROM ORDER_LINE and ORDERS (ms)',DATEDIFF(ms,@ActiveTime_Major,GETDATE());
        SELECT  @ActiveTime_Major = GETDATE(),
                @ActiveTime_Minor = GETDATE();

        /* Then call a stored procedure that executes the same delete */
        /* Section 11
        ** Moderate CPU, Moderate I/O, Network if executed from remote client
        ** Average Run Time: Depends wholly on number of 0 amount records in ORDER_LINE */
        EXEC DELETE_ORDER;

        SELECT 'Time elapsed for Section 11 - Stored Procedure DELETE_ORDER (ms)',DATEDIFF(ms,@ActiveTime_Major,GETDATE());
        SELECT  @ActiveTime_Major = GETDATE(),
                @ActiveTime_Minor = GETDATE();

        SELECT 'Time elapsed for entire session (ms)',DATEDIFF(ms,@ActiveTime_Overall,GETDATE());
    END
GO

SET NOCOUNT OFF
GO