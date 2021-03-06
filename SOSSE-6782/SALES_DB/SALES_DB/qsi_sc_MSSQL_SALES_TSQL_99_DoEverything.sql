/**************************************************************************************************
**  This is the first in a series of scripts intended to provide a homogenous testing or
**  demo environment for Quest's Performance Analysis product.
**
** NOTE: This script is the principal prerequisite script. Once this script has been
** executed, move on to the following scripts to complete the demo environment:
**          1) qsi_sc_MSSQL_SALES_TSQL_2_LoadData.sql
**          2) qsi_sc_MSSQL_SALES_TSQL_3_CreateConstraints.sql
**          3) qsi_sc_MSSQL_SALES_TSQL_4_CreateDemoSTPs.sql
**          4) qsi_sc_MSSQL_SALES_TSQL_5_CreateDemoSTPSupplement.sql (OPTIONAL)
**
** NOTICE OF DEFAULT VALUES:
**          + The user data file is named sales_Data by default. This can be changed
**              as desired.
**          + The user data file is allocated 256 MB by default and set to autogrow 10% when it
**              needs to take an extent.  This value can be changed as desired or required by the
**              target system's disk capacity.
**          + The user log file is named sales_Log by default. This can be changed
**              as desired.
**          + The user log file is allocated 128 MB by default, and set to autogrow 10% when it
**              needs to take an extent.  This can be changed as desired or required by the target
**              system's disk capacity.
**
** USAGE NOTICES:
**          + Change <user_data_path> to the path for the database data file
**              % i.e. C:\data\sales_Data.MDF %
**          + Change <user_log_path> to the path for the database log file
**              % i.e. C:\data\sales_Log.LDF %
**
** 30.08.2005   Ariel Weil          CREATED
**************************************************************************************************/
USE master
GO

IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = N'sales')
	DROP DATABASE [sales]
	IF @@ERROR = 3702
		BEGIN
			ALTER DATABASE [sales] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
			WAITFOR DELAY '00:00:05';
			DROP DATABASE [sales];
		END;
GO

CREATE DATABASE [sales]  -- select * from sysfiles
		ON (NAME = N'sales_Data', FILENAME = N'C:\Data1\salesI_Data.mdf' ,
			SIZE = 256, FILEGROWTH = 10%)
		LOG ON (NAME = N'sales_Log', FILENAME = N'C:\Log1\salesI_Log.ldf' ,
			SIZE = 128, FILEGROWTH = 10%)
        COLLATE Latin1_General_CS_AS
GO
exec sp_dboption N'sales', N'autoclose', N'false'
GO
exec sp_dboption N'sales', N'bulkcopy', N'false'
GO
exec sp_dboption N'sales', N'trunc. log', N'false'
GO
exec sp_dboption N'sales', N'torn page detection', N'true'
GO
exec sp_dboption N'sales', N'read only', N'false'
GO
exec sp_dboption N'sales', N'dbo use', N'false'
GO
exec sp_dboption N'sales', N'single', N'false'
GO
exec sp_dboption N'sales', N'autoshrink', N'false'
GO
exec sp_dboption N'sales', N'ANSI null default', N'false'
GO
exec sp_dboption N'sales', N'recursive triggers', N'false'
GO
exec sp_dboption N'sales', N'ANSI nulls', N'false'
GO
exec sp_dboption N'sales', N'concat null yields null', N'false'
GO
exec sp_dboption N'sales', N'cursor close on commit', N'false'
GO
exec sp_dboption N'sales', N'default to local cursor', N'false'
GO
exec sp_dboption N'sales', N'quoted identifier', N'false'
GO
exec sp_dboption N'sales', N'ANSI warnings', N'false'
GO
exec sp_dboption N'sales', N'auto create statistics', N'true'
GO
exec sp_dboption N'sales', N'auto update statistics', N'true'
GO

USE [sales]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[udfn_countlines]') and xtype in (N'FN', N'IF', N'TF'))
drop function [dbo].[udfn_countlines]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[proc_1]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[proc_1]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[BANK]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[BANK]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CITY]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[CITY]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CUSTOMER]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[CUSTOMER]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DEPARTMENT]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[DEPARTMENT]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[EMPLOYEE]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[EMPLOYEE]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[JOB]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[JOB]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ORDERS]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ORDERS]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ORDER_LINE]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ORDER_LINE]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PRODUCT]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[PRODUCT]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PRODUCT_IN_WAREHOUSE]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[PRODUCT_IN_WAREHOUSE]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[STATUS]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[STATUS]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[SUPPLIER]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[SUPPLIER]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[WAREHOUSE]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[WAREHOUSE]
GO

CREATE TABLE [dbo].[BANK] (
	[BANK_CODE] [char](3)                                              NOT NULL ,
	[BANK_NAME] [varchar](100)  COLLATE Latin1_General_CS_AS   NOT NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[CITY] (
	[CITY_CODE]        [char](3)       COLLATE Latin1_General_CS_AS NOT NULL ,
	[CITY_DESCRIPTION] [varchar](20)   COLLATE Latin1_General_CS_AS NOT NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[CUSTOMER] (
	[CUSTOMER_ID]  [decimal](8,0)                                          NOT NULL ,
	[FIRST_NAME]   [varchar](10)   COLLATE Latin1_General_CS_AS    NULL ,
	[LAST_NAME]    [varchar](20)   COLLATE Latin1_General_CS_AS    NULL ,
	[CITY]         [char](3)       COLLATE Latin1_General_CS_AS    NULL ,
	[STREET]       [varchar](30)   COLLATE Latin1_General_CS_AS    NULL ,
	[ZIP_CODE]     [decimal](5,0)                                          NULL ,
	[PHONE]        [varchar](15)   COLLATE Latin1_General_CS_AS    NULL ,
	[CREDIT_CARD]  [decimal](16,0)                                         NULL ,
	[TOTAL_SALES]  [decimal](15,2)                                         NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[DEPARTMENT] (
	[DEPARTMENT_CODE]          [char](3)       COLLATE Latin1_General_CS_AS NOT NULL ,
	[DEPARTMENT_DESCRIPTION]   [varchar](20)   COLLATE Latin1_General_CS_AS NOT NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[EMPLOYEE] (
	[EMPLOYEE_ID]  [decimal](8,0)                                       NOT NULL ,
	[FIRST_NAME]   [varchar](10)   COLLATE Latin1_General_CS_AS NOT NULL ,
	[LAST_NAME]    [varchar](20)   COLLATE Latin1_General_CS_AS NOT NULL ,
	[CITY]         [char](3)       COLLATE Latin1_General_CS_AS NULL ,
	[STREET]       [varchar](30)   COLLATE Latin1_General_CS_AS NOT NULL ,
	[ZIP_CODE]     [decimal](5,0)                                       NULL ,
	[PHONE]        [varchar](15)   COLLATE Latin1_General_CS_AS NULL ,
	[BANK_CODE]    [char](3)                                            NULL ,
	[BRANCH_CODE]  [char](7)                                            NULL ,
	[ACCOUNT#]     [char](20)                                           NULL ,
	[DATE_OF_HIRE] [datetime]                                           NULL ,
	[JOB]          [char](3)       COLLATE Latin1_General_CS_AS NULL ,
	[DEPARTMENT]   [char](3)       COLLATE Latin1_General_CS_AS NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[JOB] (
	[JOB_CODE]         [char](3)       COLLATE Latin1_General_CS_AS NOT NULL ,
	[JOB_DESCRIPTION]  [varchar](20)   COLLATE Latin1_General_CS_AS NOT NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[ORDERS] (
	[ORDER_ID]             [decimal](8,0)                                       NOT NULL ,
	[CUSTOMER_ID]          [decimal](8,0)                                       NOT NULL ,
	[DATE_OF_ORDER]        [datetime]                                           NOT NULL ,
	[PRIORITY]             [decimal](2,0)                                       NULL ,
	[EMPLOYEE_RECIEVING]   [decimal](8,0)                                       NOT NULL ,
	[STATUS]               [char](3)       COLLATE Latin1_General_CS_AS NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[ORDER_LINE] (
	[ORDER_ID]         [decimal](8,0)                                       NOT NULL ,
	[PRODUCT_ID]       [decimal](8,0)                                       NOT NULL ,
	[AMOUNT]           [decimal](11,0)                                      NULL ,
	[COMMENTS]         [varchar](255) COLLATE Latin1_General_CS_AS  NULL ,
	[DATE_OF_ORDER]    [datetime]                                           NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[PRODUCT] (
	[PRODUCT_ID]           [decimal](8,0)                                          NOT NULL ,
	[SUPPLIER_ID]          [decimal](8,0)                                          NULL ,
	[PRODUCT_DESCRIPTION]  [varchar](100)  COLLATE Latin1_General_CS_AS    NOT NULL ,
	[ITEM_TYPE]            [varchar](10)   COLLATE Latin1_General_CS_AS    NOT NULL ,
	[PRICE]                [decimal](8,2)                                          NOT NULL ,
	[COMMENTS]             [varchar](50)   COLLATE Latin1_General_CS_AS    NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[PRODUCT_IN_WAREHOUSE] (
	[PRODUCT_ID]   [decimal](8,0)       NOT NULL ,
	[WAREHOUSE_ID] [int]				NOT NULL ,
	[REMAINING]    [decimal](11, 0)     NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[STATUS] (
	[STATUS_CODE]          [char](3)       COLLATE Latin1_General_CS_AS NOT NULL ,
	[STATUS_DESCRIPTION]   [varchar](20)   COLLATE Latin1_General_CS_AS NOT NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[SUPPLIER] (
	[SUPPLIER_ID]  [decimal](8,0)                                       NOT NULL ,
	[NAME]         [varchar](35)   COLLATE Latin1_General_CS_AS NOT NULL ,
	[CITY]         [char](3)       COLLATE Latin1_General_CS_AS NULL ,
	[STREET]       [varchar](30)   COLLATE Latin1_General_CS_AS NOT NULL ,
	[ZIP_CODE]     [decimal](5,0)                                       NULL ,
	[PHONE]        [varchar](15)   COLLATE Latin1_General_CS_AS NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[WAREHOUSE](
	[WAREHOUSE_ID] [int]                                        NOT NULL,
	[LOCATION]     [varchar](100)  COLLATE Latin1_General_CS_AS NOT NULL,
	[COMMENTS]     [varchar](7000) COLLATE Latin1_General_CS_AS NULL,
 CONSTRAINT [PK_WAREHOUSE] PRIMARY KEY NONCLUSTERED
(
	[WAREHOUSE_ID] ASC
) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
/**************************************************************************************************
**  This is the second in a series of scripts intended to provide a homogenous testing
**  or demo environment for Quest's Performance Analysis product.
**
** NOTE: This script should only be run after the prerequisite script:
**          1) qsi_sc_MSSQL_SALES_TSQL_1_CreateDBandTables.sql
**
** USAGE NOTE:
**          + Change C:\SalesDB to the path where the csv files were unzipped
**              % i.e. C:\Temp %
**
** Once this script has been executed, move on to the following scripts to complete
** the demo environment:
**          1) qsi_sc_MSSQL_SALES_TSQL_3_CreateConstraints.sql
**          2) qsi_sc_MSSQL_SALES_TSQL_4_CreateDemoSTPs.sql
**          3) qsi_sc_MSSQL_SALES_TSQL_5_CreateDemoSTPSupplement.sql (OPTIONAL)
**
** 30.08.2005   Ariel Weil          CREATED
**************************************************************************************************/
USE sales
GO

BULK INSERT [sales].[dbo].[BANK]                    FROM 'C:\SalesDB\BANK.csv' WITH (BATCHSIZE=1000,CODEPAGE='RAW',DATAFILETYPE='char',FIELDTERMINATOR=',',ROWTERMINATOR='\n');
BULK INSERT [sales].[dbo].[CITY]                    FROM 'C:\SalesDB\CITY.csv' WITH (BATCHSIZE=1000,CODEPAGE='RAW',DATAFILETYPE='char',FIELDTERMINATOR=',',ROWTERMINATOR='\n');
BULK INSERT [sales].[dbo].[CUSTOMER]                FROM 'C:\SalesDB\CUSTOMER.csv' WITH (BATCHSIZE=1000,CODEPAGE='RAW',DATAFILETYPE='char',FIELDTERMINATOR='|',ROWTERMINATOR='\n');
BULK INSERT [sales].[dbo].[DEPARTMENT]              FROM 'C:\SalesDB\DEPARTMENT.csv' WITH (BATCHSIZE=1000,CODEPAGE='RAW',DATAFILETYPE='char',FIELDTERMINATOR=',',ROWTERMINATOR='\n');
BULK INSERT [sales].[dbo].[EMPLOYEE]                FROM 'C:\SalesDB\EMPLOYEE.csv' WITH (BATCHSIZE=1000,CODEPAGE='RAW',DATAFILETYPE='char',FIELDTERMINATOR='|',ROWTERMINATOR='|\n');
BULK INSERT [sales].[dbo].[JOB]                     FROM 'C:\SalesDB\JOB.csv' WITH (BATCHSIZE=1000,CODEPAGE='RAW',DATAFILETYPE='char',FIELDTERMINATOR=',',ROWTERMINATOR='\n');
BULK INSERT [sales].[dbo].[ORDER_LINE]              FROM 'C:\SalesDB\ORDER_LINE.csv' WITH (BATCHSIZE=1000,CODEPAGE='RAW',DATAFILETYPE='char',FIELDTERMINATOR=',',ROWTERMINATOR='\n');
BULK INSERT [sales].[dbo].[ORDERS]                  FROM 'C:\SalesDB\ORDERS.csv' WITH (BATCHSIZE=1000,CODEPAGE='RAW',DATAFILETYPE='char',FIELDTERMINATOR=',',ROWTERMINATOR='\n');
BULK INSERT [sales].[dbo].[PRODUCT]                 FROM 'C:\SalesDB\PRODUCT.csv' WITH (BATCHSIZE=1000,CODEPAGE='RAW',DATAFILETYPE='char',FIELDTERMINATOR='|',ROWTERMINATOR='\n');
BULK INSERT [sales].[dbo].[PRODUCT_IN_WAREHOUSE]    FROM 'C:\SalesDB\PRODUCT_IN_WAREHOUSE.csv' WITH (BATCHSIZE=1000,CODEPAGE='RAW',DATAFILETYPE='char',FIELDTERMINATOR=',',ROWTERMINATOR='\n');
BULK INSERT [sales].[dbo].[STATUS]                  FROM 'C:\SalesDB\STATUS.csv' WITH (BATCHSIZE=1000,CODEPAGE='RAW',DATAFILETYPE='char',FIELDTERMINATOR=',',ROWTERMINATOR='\n');
BULK INSERT [sales].[dbo].[SUPPLIER]                FROM 'C:\SalesDB\SUPPLIER.csv' WITH (BATCHSIZE=1000,CODEPAGE='RAW',DATAFILETYPE='char',FIELDTERMINATOR=',',ROWTERMINATOR='\n');
BULK INSERT [sales].[dbo].[WAREHOUSE]               FROM 'C:\SalesDB\WAREHOUSE.csv' WITH (BATCHSIZE=1000,CODEPAGE='RAW',DATAFILETYPE='char',FIELDTERMINATOR=',',ROWTERMINATOR='\n');
GO
/**************************************************************************************************
**  This is the third in a series of scripts intended to provide a homogenous testing or
**  demo environment for Quest's Performance Analysis product.
**
** NOTE: This script should only be run after the following prerequisite scripts:
**          1) qsi_sc_MSSQL_SALES_TSQL_1_CreateDBandTables.sql
**          2) qsi_sc_MSSQL_SALES_TSQL_2_LoadData.sql
**
** Once this script has been executed, move on to the following scripts to complete
** the demo environment:
**          1) qsi_sc_MSSQL_SALES_TSQL_4_CreateDemoSTPs.sql
**          2) qsi_sc_MSSQL_SALES_TSQL_5_CreateDemoSTPSupplement.sql (OPTIONAL)
**
** 30.08.2005   Ariel Weil          CREATED
**************************************************************************************************/
USE sales
GO

ALTER TABLE [dbo].[BANK] ADD CONSTRAINT [PK_BANK] PRIMARY KEY  NONCLUSTERED
	(
		[BANK_CODE]
	)  ON [PRIMARY]
GO

ALTER TABLE [dbo].[CITY] ADD CONSTRAINT [PK_CITY] PRIMARY KEY  NONCLUSTERED
	(
		[CITY_CODE]
	)  ON [PRIMARY]
GO

ALTER TABLE [dbo].[CUSTOMER] ADD CONSTRAINT [PK_CUSTOMER] PRIMARY KEY  NONCLUSTERED
	(
		[CUSTOMER_ID]
	)  ON [PRIMARY]
GO

ALTER TABLE [dbo].[DEPARTMENT] ADD CONSTRAINT [PK_DEPARTMENT] PRIMARY KEY  NONCLUSTERED
	(
		[DEPARTMENT_CODE]
	)  ON [PRIMARY]
GO

ALTER TABLE [dbo].[EMPLOYEE] ADD CONSTRAINT [PK_EMPLOYEE] PRIMARY KEY  NONCLUSTERED
	(
		[EMPLOYEE_ID]
	)  ON [PRIMARY]
GO

ALTER TABLE [dbo].[JOB] ADD CONSTRAINT [PK_JOB] PRIMARY KEY  NONCLUSTERED
	(
		[JOB_CODE]
	)  ON [PRIMARY]
GO

ALTER TABLE [dbo].[ORDER_LINE] ADD CONSTRAINT [PK_ORDER_LINE] PRIMARY KEY  NONCLUSTERED
	(
		[ORDER_ID],
		[PRODUCT_ID]
	)  ON [PRIMARY]
GO

ALTER TABLE [dbo].[ORDERS] ADD CONSTRAINT [PK_ORDERS] PRIMARY KEY  NONCLUSTERED
	(
		[ORDER_ID]
	)  ON [PRIMARY]
GO

ALTER TABLE [dbo].[PRODUCT] ADD CONSTRAINT [PK_PRODUCT] PRIMARY KEY  NONCLUSTERED
	(
		[PRODUCT_ID]
	)  ON [PRIMARY]
GO

ALTER TABLE [dbo].[PRODUCT_IN_WAREHOUSE] ADD CONSTRAINT [PK_PRODUCT_IN_WAREHOUSE] PRIMARY KEY  NONCLUSTERED
	(
		[PRODUCT_ID],
		[WAREHOUSE_ID]
	)  ON [PRIMARY]
GO

ALTER TABLE [dbo].[STATUS] ADD CONSTRAINT [PK_STATUS] PRIMARY KEY  NONCLUSTERED
	(
		[STATUS_CODE]
	)  ON [PRIMARY]
GO

ALTER TABLE [dbo].[SUPPLIER] ADD CONSTRAINT [PK_SUPPLIER] PRIMARY KEY  NONCLUSTERED
	(
		[SUPPLIER_ID]
	)  ON [PRIMARY]
GO

ALTER TABLE [dbo].[EMPLOYEE] ADD CONSTRAINT [FK_EMPLOYEE_BANK] FOREIGN KEY
	(
		[BANK_CODE]
	) REFERENCES [BANK] (
		[BANK_CODE]
	)
GO

ALTER TABLE [dbo].[EMPLOYEE] ADD CONSTRAINT [FK_EMPLOYEE_CITY] FOREIGN KEY
	(
		[CITY]
	) REFERENCES [CITY] (
		[CITY_CODE]
	)
GO

ALTER TABLE [dbo].[EMPLOYEE] ADD CONSTRAINT [FK_EMPLOYEE_DEPARTMENT] FOREIGN KEY
	(
		[DEPARTMENT]
	) REFERENCES [DEPARTMENT] (
		[DEPARTMENT_CODE]
	)
GO

ALTER TABLE [dbo].[EMPLOYEE] ADD CONSTRAINT [FK_EMPLOYEE_JOB] FOREIGN KEY
	(
		[JOB]
	) REFERENCES [JOB] (
		[JOB_CODE]
	)
GO

ALTER TABLE [dbo].[ORDER_LINE] ADD CONSTRAINT [FK_ORDER_LINE_ORDERS] FOREIGN KEY
	(
		[ORDER_ID]
	) REFERENCES [ORDERS] (
		[ORDER_ID]
	)
GO

ALTER TABLE [dbo].[ORDER_LINE] ADD CONSTRAINT [FK_ORDER_LINE_PRODUCT] FOREIGN KEY
	(
		[PRODUCT_ID]
	) REFERENCES [PRODUCT] (
		[PRODUCT_ID]
	)
GO

ALTER TABLE [dbo].[ORDERS] ADD CONSTRAINT [FK_ORDERS_CUSTOMER] FOREIGN KEY
	(
		[CUSTOMER_ID]
	) REFERENCES [CUSTOMER] (
		[CUSTOMER_ID]
	)
GO

ALTER TABLE [dbo].[ORDERS] ADD CONSTRAINT [FK_ORDERS_STATUS] FOREIGN KEY
	(
		[STATUS]
	) REFERENCES [STATUS] (
		[STATUS_CODE]
	)
GO

ALTER TABLE [dbo].[PRODUCT] ADD CONSTRAINT [FK_PRODUCT_SUPPLIER] FOREIGN KEY
	(
		[SUPPLIER_ID]
	) REFERENCES [SUPPLIER] (
		[SUPPLIER_ID]
	)
GO

ALTER TABLE [dbo].[PRODUCT_IN_WAREHOUSE] ADD CONSTRAINT [FK_PRODUCT_IN_WAREHOUSE_PRODUCT] FOREIGN KEY
	(
		[PRODUCT_ID]
	) REFERENCES [PRODUCT] (
		[PRODUCT_ID]
	)
GO

ALTER TABLE [dbo].[PRODUCT_IN_WAREHOUSE] ADD CONSTRAINT [FK_PRODUCT_IN_WAREHOUSE_WAREHOUSE] FOREIGN KEY
	(
		[WAREHOUSE_ID]
	) REFERENCES [WAREHOUSE] (
		[WAREHOUSE_ID]
	)
GO
/**************************************************************************************************
**  This is the fourth in a series of scripts intended to provide a homogenous testing or
**  demo environment for Quest's Performance Analysis product.
**
** NOTE: This script should only be run after the prerequisite scripts:
**          1) qsi_sc_MSSQL_SALES_TSQL_1_CreateDBandTables.sql
**          2) qsi_sc_MSSQL_SALES_TSQL_2_LoadData.sql
**          3) qsi_sc_MSSQL_SALES_TSQL_3_CreateConstraints.sql
**
** Once this script has been executed, you may choose to move on to the following script to complete
** the demo environment:
**          1) qsi_sc_MSSQL_SALES_TSQL_5_CreateDemoSTPSupplement.sql (OPTIONAL)
**
** 30.08.2005   Ariel Weil          CREATED
**************************************************************************************************/
USE sales
GO
IF EXISTS(SELECT * FROM sysobjects WHERE type = 'P' AND name = 'GET_ORDER_DETAILS')
    DROP PROCEDURE GET_ORDER_DETAILS;
GO
CREATE PROCEDURE GET_ORDER_DETAILS
AS
BEGIN
        SELECT  LTRIM(RTRIM(LAST_NAME)) + ', ' + LTRIM(RTRIM(FIRST_NAME)),
                O.ORDER_ID,
                PRODUCT_DESCRIPTION,
                AMOUNT
        FROM    ORDERS      O,
                ORDER_LINE  L,
                CUSTOMER    C,
                PRODUCT     P
        WHERE   O.ORDER_ID = L.ORDER_ID
            AND O.CUSTOMER_ID = C.CUSTOMER_ID
            AND P.PRODUCT_ID = L.PRODUCT_ID;
END;
GO
IF EXISTS(SELECT * FROM sysobjects WHERE type = 'P' AND name = 'GET_SUM_AMOUNT')
    DROP PROCEDURE GET_SUM_AMOUNT;
GO
CREATE PROCEDURE GET_SUM_AMOUNT
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
IF EXISTS(SELECT * FROM sysobjects WHERE type = 'P' AND name = 'UPDATE_PRIORITY')
    DROP PROCEDURE UPDATE_PRIORITY;
GO
CREATE PROCEDURE UPDATE_PRIORITY
AS
BEGIN
    UPDATE  ORDERS
    SET     PRIORITY = PRIORITY +1
    WHERE   DATE_OF_ORDER < getdate();
END;
GO
IF EXISTS(SELECT * FROM sysobjects WHERE type = 'P' AND name = 'LOAD_ORDER_LINE')
    DROP PROCEDURE LOAD_ORDER_LINE;
GO
CREATE PROCEDURE LOAD_ORDER_LINE
AS
BEGIN
    BEGIN TRAN
        INSERT INTO ORDER_LINE
        SELECT  ORDER_ID,
                0,
                0,
                'NEW ORDER',
                DATE_OF_ORDER
        FROM    ORDERS
        WHERE   ORDER_ID NOT IN(SELECT  DISTINCT ORDER_ID
                                FROM    ORDER_LINE);
    ROLLBACK TRAN;
END;
GO
IF EXISTS(SELECT * FROM sysobjects WHERE type = 'P' AND name = 'DELETE_ORDER')
    DROP PROCEDURE DELETE_ORDER;
GO
CREATE PROCEDURE DELETE_ORDER
AS
BEGIN
    BEGIN TRAN
        DELETE FROM ORDER_LINE
        WHERE       AMOUNT =0;

        DELETE FROM ORDERS
        WHERE       ORDER_ID NOT IN(SELECT  DISTINCT ORDER_ID
                                    FROM    ORDER_LINE);
    ROLLBACK TRAN;
END;
GO
/**************************************************************************************************
**  This is the final, optional installment in a series of scripts intended to provide a
**  homogenous testing or demo environment for Quest's Performance Analysis product.
**
** NOTE: This script should only be run after the following prerequisite scripts:
**          1) qsi_sc_MSSQL_SALES_TSQL_1_CreateDBandTables.sql
**          2) qsi_sc_MSSQL_SALES_TSQL_2_LoadData.sql
**          3) qsi_sc_MSSQL_SALES_TSQL_3_CreateConstraints.sql
**          4) qsi_sc_MSSQL_SALES_TSQL_4_CreateDemoSTPs.sql
**
** 30.08.2005   Ariel Weil          CREATED
**************************************************************************************************/
USE sales
GO

IF (SELECT OBJECT_ID('qp_IndexTable')) IS NOT NULL
	DROP PROCEDURE qp_IndexTable;
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure qp_IndexTable @TAB varchar(100)='PRODUCT_IN_WAREHOUSE'
as
BEGIN
 declare @i int
 declare @N int
 declare @S varchar(8000)
 create table #IX (indid int identity, indstr varchar(7000))
 create table #T (t varchar(8000))
 create table ##F (colid int, colname varchar(256))

  insert into ##F select 0,null
  insert into ##F select colid, name from syscolumns where id = object_id(@TAB)

  select @S='SELECT DISTINCT '''''
  select @S=@S+'+ISNULL('',''+f'+convert(varchar,colid)+'.colname,'''')' from ##F
  select @S=@S+' FROM '
  select @S=@S+', ##F f'+convert(varchar,colid)+' ' from ##F
  select @S=replace(@S,'FROM ,','FROM')
  select @S=@S+char(13)+' WHERE 1=1 '
  select @S=@S+char(13)+' AND ((f'+convert(varchar,t1.colid)+'.colname iS NULL) OR (f'+convert(varchar,t2.colid)+'.colname iS NULL) OR (f'+convert(varchar,t1.colid)+'.colname!=f'+convert(varchar,t2.colid)+'.colname ))'
		from ##F t1 cross join ##F t2 where t1.colid!=t2.colid order by t1.colid,t2.colid

  insert into #T exec (@S)
  update #T set t=substring(t,2,8000) where substring(t,1,1)=','
  insert into #IX (indstr)
  select t  from #T where datalength(t)>0
  update #IX set indstr='create index xie'+convert(varchar,indid)+'_'+@TAB+' on '+@TAB+' ('+indstr+')'
  raiserror('build list of indexes',0,1) with nowait
  select @i=0
  select @N=max(indid) from #IX
  while (@i<@N)
  begin
   select @i=@i+1
   select @S=indstr from #IX where indid=@i
   exec (@S)
  end
  select @S='create clustered index xie000_'+@TAB+' on '+@TAB+' ('+name+')' from syscolumns where colid=1 and id=object_id(@TAB)
  exec (@S)
  select @i=0
  select @N=max(indid) from #IX
  while (@i<@N)
  begin
   select @i=@i+1
   select @S='drop index '+@TAB+'.xie'+convert(varchar,@i)+'_'+@TAB from #IX where indid=@i
   exec (@S)
  end
  select @S='drop index '+@TAB+'.xie000_'+@TAB
  exec (@S)
 drop table #T
 drop table ##F
 drop table #IX

END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
IF (SELECT OBJECT_ID('qsp_randstr')) IS NOT NULL
	DROP PROCEDURE qsp_randstr;
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure qsp_randstr @t char(1),@S varchar(100) output
 as
 begin
 declare @i int
 declare @j int
 select @i=0
 select @S=''
 if (ISNUMERIC(@t)=1)
 while (@i<100)
 begin
  select @i=@i+1
  select @S =@S+char(convert(int,rand()*10)+ascii('0'))
 end
 else
 begin
	 while (@i<90)
	 begin
	  select @i=@i+1
	  select @S =@S+char(convert(int,rand()*26)+ascii('A'))
	 end
	 select @i=0
	 select @j=0
	 while (@i<10)
	 begin
	  select @i=@i+1
	  select @j = charindex(' ',@S,@j)+5+convert(int,rand()*7)
	  select @S=substring(@S,1,@j)+' '+substring(@S,@j+1,100)
	 end
	 select @S=lower(@S)
	 select @i=charindex(' ',@S)
	 while (@i>0)
	 begin
	  select @S=substring(@S,1,@i)+upper(substring(@S,@i+1,1))+substring(@S,@i+2,100)
	  select @i=charindex(' ',@S,@i+2)
	 end
	select @S=upper(substring(@S,1,1))+substring(@S,2,100)
end
end
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
IF (SELECT OBJECT_ID('qsp_Fill_DEPARTMENT')) IS NOT NULL
	DROP PROCEDURE qsp_Fill_DEPARTMENT;
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure qsp_Fill_DEPARTMENT @N int = 100
as
begin
 declare @D table (did tinyint, dname varchar(120))
 declare @DD table (did int, dname varchar(20))
 declare @i int
 insert into @D
			select  1, 'Research and Development'
	union	select  2, 'Marketing'
	union	select  3, 'Sales'
	union	select  4, 'Support'
	union	select  5, 'QA'
	union	select  6, 'Accounting'
	union	select  7, 'HR'
	union	select  8, 'Administration'
	union	select  9, 'BizDev'
	union	select  10, 'Storage'
 select @i = 0
 while (@i<((@N-1)/10)+1)
 begin
  insert into @DD select did+10*@i,substring('('+convert(varchar,@i+1)+') '+dname,1,20) from @D
  select @i = @i+1
 end
 insert into DEPARTMENT select dbo.f_ito36(did),dname from @DD
end
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
IF (SELECT OBJECT_ID('qsp_CreateSupplier')) IS NOT NULL
	DROP PROCEDURE qsp_CreateSupplier;
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure qsp_CreateSupplier @N int
as
BEGIN
 declare @eid int
 declare @i int
 declare @S1 varchar(100)
 create table #C (cid int identity, CCODE char(3))
 insert into #C (CCODE) select CITY_CODE from CITY

 select top 1 * into #E from SUPPLIER

 select @i = 0
 select @eid = max(SUPPLIER_ID) from SUPPLIER
 select @eid=isnull(@eid+1,1)
 select @N=@N+@eid
 while (@eid<@N)
 begin
  update #E set SUPPLIER_ID = @eid

  select @i = convert(int,(rand()*2406))
  update #E set NAME = upper(ln) from ppl where rid = @i

  select @i = convert(int,(rand()*1156))
  update #E set CITY = CCODE from #C where cid = @i


  exec qsp_randstr '0',@S1 output
  update #E set STREET = substring(@S1,1,2)+', '
  exec qsp_randstr 'A',@S1 output
  update #E set STREET = STREET+substring(@S1,1,26)

  exec qsp_randstr '0',@S1 output
  update #E set ZIP_CODE = substring(@S1,1,5)

  exec qsp_randstr '0',@S1 output
  update #E set PHONE = substring(@S1,1,3)
  exec qsp_randstr '0',@S1 output
  update #E set PHONE = PHONE+' '+substring(@S1,1,3)
  exec qsp_randstr '0',@S1 output
  update #E set PHONE = PHONE+' '+substring(@S1,1,4)


  insert into SUPPLIER select * from #E

  select @eid=@eid+1
 end
END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
IF (SELECT OBJECT_ID('qsp_CreateOrders')) IS NOT NULL
	DROP PROCEDURE qsp_CreateOrders;
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure qsp_CreateOrders @NumOrders int, @NumLines tinyint=3, @StartDate smalldatetime='Jan 1 2000'
as
BEGIN
declare @oid int
declare @maxoid int
declare @cid int
declare @days int
declare @eid int
declare @pri tinyint
declare @lines tinyint
declare @lid tinyint
declare @pid int
declare @amt int
select @oid=max(ORDER_ID) from ORDERS
select @maxoid = @oid+@NumOrders
while (@oid<@maxoid)
begin
 select @oid=@oid+1
 select @eid=convert(int,rand()*max(EMPLOYEE_ID)) from EMPLOYEE
 select @cid=convert(int,rand()*max(CUSTOMER_ID)) from CUSTOMER
 select @days=convert(int,rand()*datediff(day,@StartDate,getdate()))
 select @pri = convert(tinyint,rand()*5)
 select @lines = convert(tinyint, @NumLines/2+rand()*@NumLines)
 select @lid = 0
 insert into ORDERS select @oid,@cid,dateadd(day,@days,@StartDate),@pri,@eid,null
 while (@lid<@lines)
 begin
  select @lid=@lid+1
  select @pid=convert(int,rand()*max(PRODUCT_ID)) from PRODUCT
  select @amt=convert(int,rand()*100000)
  if not exists (select * from ORDER_LINE where ORDER_ID = @oid and PRODUCT_ID = @pid)
    insert into ORDER_LINE select @oid,@pid,@amt,null,dateadd(day,@days,@StartDate)
 end
end
END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
IF (SELECT OBJECT_ID('qsp_CreateEmployees')) IS NOT NULL
	DROP PROCEDURE qsp_CreateEmployees;
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure qsp_CreateEmployees @N int
as
BEGIN
 declare @eid int
 declare @i int
 declare @S1 varchar(100)
 create table #B (bid int identity, BCODE char(3))
 create table #C (cid int identity, CCODE char(3))
 create table #D (did int identity, DCODE char(3))
 create table #J (jid int identity, JCODE char(3))
 insert into #B (BCODE) select BANK_CODE from BANK
 insert into #C (CCODE) select CITY_CODE from CITY
 insert into #D (DCODE) select DEPARTMENT_CODE from DEPARTMENT
 insert into #J (JCODE) select JOB_CODE from JOB

 select top 1 * into #E from EMPLOYEE

 select @i = 0
 select @eid = max(EMPLOYEE_ID) from EMPLOYEE
 select @eid=isnull(@eid+1,1)
 select @N=@N+@eid
-- select @N,@eid
 while (@eid<@N)
 begin
  update #E set EMPLOYEE_ID = @eid

  select @i = convert(int,(rand()*2406))
  update #E set FIRST_NAME = substring(LTRIM(RTRIM(fn)),1,10), LAST_NAME = substring(LTRIM(RTRIM(ln)),1,20) from ppl where rid = @i

  select @i = convert(int,(rand()*1156))
  update #E set CITY = CCODE from #C where cid = @i

  select @i = convert(int,(rand()*760))
  update #E set BANK_CODE = BCODE from #B where bid = @i

  select @i = convert(int,(rand()*52))
  update #E set JOB = JCODE from #J where jid = @i

  select @i = convert(int,(rand()*46650))
  update #E set DEPARTMENT = DCODE from #D where did = @i

  exec qsp_randstr '0',@S1 output
  update #E set STREET = substring(@S1,1,2)+', '

  exec qsp_randstr 'A',@S1 output
  update #E set STREET = STREET+substring(@S1,1,26)

  exec qsp_randstr '0',@S1 output
  update #E set ZIP_CODE = substring(@S1,1,5)

  exec qsp_randstr '0',@S1 output
  update #E set BRANCH_CODE = substring(@S1,1,3)

  exec qsp_randstr '0',@S1 output
  update #E set BRANCH_CODE = left(BRANCH_CODE,3)+'/'+substring(@S1,1,3)

  exec qsp_randstr '0',@S1 output
  update #E set ACCOUNT# = substring(@S1,1,6)

  exec qsp_randstr '0',@S1 output
  update #E set ACCOUNT# = ACCOUNT#+'/'+substring(@S1,1,6)

  exec qsp_randstr '0',@S1 output
  update #E set ACCOUNT# = ACCOUNT#+'-'+substring(@S1,1,6)

  exec qsp_randstr '0',@S1 output
  update #E set PHONE = substring(@S1,1,3)
  exec qsp_randstr '0',@S1 output
  update #E set PHONE = PHONE+' '+substring(@S1,1,3)
  exec qsp_randstr '0',@S1 output
  update #E set PHONE = PHONE+' '+substring(@S1,1,4)



  select @i = convert(int,(rand()*datediff(day,'Jan 1 1990',getdate())))
  update #E set DATE_OF_HIRE = dateadd(day,@i,'Jan 1 1990')

  insert into EMPLOYEE select * from #E

  select @eid=@eid+1
 end
END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
IF (SELECT OBJECT_ID('qsp_CreateCustomer')) IS NOT NULL
	DROP PROCEDURE qsp_CreateCustomer;
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure qsp_CreateCustomer @N int
as
BEGIN
 declare @eid int
 declare @i int
 declare @S1 varchar(100)
 create table #C (cid int identity, CCODE char(3))
 insert into #C (CCODE) select CITY_CODE from CITY

 select top 1 * into #E from CUSTOMER

 select @i = 0
 select @eid = max(CUSTOMER_ID) from CUSTOMER
 select @eid=isnull(@eid+1,1)
 select @N=@N+@eid
-- select @N,@eid
 while (@eid<@N)
 begin
  update #E set CUSTOMER_ID = @eid

  select @i = convert(int,(rand()*2406))
  update #E set FIRST_NAME = substring(LTRIM(RTRIM(fn)),1,10), LAST_NAME = substring(LTRIM(RTRIM(ln)),1,20) from ppl where rid = @i

  select @i = convert(int,(rand()*1156))
  update #E set CITY = CCODE from #C where cid = @i


  exec qsp_randstr '0',@S1 output
  update #E set STREET = substring(@S1,1,2)+', '
  exec qsp_randstr 'A',@S1 output
  update #E set STREET = STREET+substring(@S1,1,26)

  exec qsp_randstr '0',@S1 output
  update #E set ZIP_CODE = substring(@S1,1,5)

  exec qsp_randstr '0',@S1 output
  update #E set PHONE = substring(@S1,1,3)
  exec qsp_randstr '0',@S1 output
  update #E set PHONE = PHONE+' '+substring(@S1,1,3)
  exec qsp_randstr '0',@S1 output
  update #E set PHONE = PHONE+' '+substring(@S1,1,4)

  exec qsp_randstr '0',@S1 output
  update #E set CREDIT_CARD = convert(decimal,substring(@S1,1,16))

  exec qsp_randstr '0',@S1 output
  update #E set TOTAL_SALES = convert(decimal,substring(@S1,1,5))



  insert into CUSTOMER select * from #E

  select @eid=@eid+1
 end
END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
IF (SELECT OBJECT_ID('qqp_IndexTable')) IS NOT NULL
	DROP PROCEDURE qqp_IndexTable;
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure qqp_IndexTable @TAB varchar(100)='PRODUCT_IN_WAREHOUSE'
as
BEGIN
 set ANSI_NULLS on
 declare @i int
 declare @N int
 declare @S varchar(8000)
 create table #IX (indid int identity, indstr varchar(7000))
 create table #T (t varchar(8000))
 create table ##FF  (colid int, colname varchar(256))

  insert into ##FF select 0,null
  insert into ##FF select colid, name from syscolumns where id = object_id(@TAB)

  select @S='SELECT DISTINCT '''''
  select @S=@S+char(13)+'+ISNULL('',''+f'+convert(varchar,colid)+'.colname,'''')' from ##FF
  select @S=@S+char(13)+' FROM '
  select @S=@S+', ##FF f'+convert(varchar,colid)+' ' from ##FF
  select @S=replace(@S,'FROM ,','FROM')
  select @S=@S+char(13)+' WHERE 1=1 '
  select @S=@S+char(13)+' AND ((f'+convert(varchar,t1.colid)+'.colname iS NULL) OR (f'+convert(varchar,t2.colid)+'.colname iS NULL) OR (f'+convert(varchar,t1.colid)+'.colname!=f'+convert(varchar,t2.colid)+'.colname ))'
		from ##FF t1 cross join ##FF t2 where t1.colid!=t2.colid order by t1.colid,t2.colid  select @S

  insert into #T exec (@S)
  select * from #T

 drop table #T
 drop table ##FF
 drop table #IX

END
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
IF (SELECT OBJECT_ID('qp_WarehouseReport_Loop')) IS NOT NULL
	DROP PROCEDURE qp_WarehouseReport_Loop;
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure qp_WarehouseReport_Loop @N int = 10
as
begin
  declare @i int
  exec master..xp_cmdshell 'del c:\Warehouses.txt'
  select @i=0
  while (@i<@N)
  begin
   select @i=@i+1
   exec master..xp_cmdshell 'osql -Usa -Pdba4ever -dsales -Q"exec qp_WarehouseReport" -oC:\Warehouses.txt'
   waitfor delay '00:00:10'
  end
end
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
IF (SELECT OBJECT_ID('qp_WarehouseReport')) IS NOT NULL
	DROP PROCEDURE qp_WarehouseReport;
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure qp_WarehouseReport
as
select
	w.WAREHOUSE_ID,
	'== '+upper(LOCATION)+' ==',
	0 as REMAINING,
	'WAREHOUSE'+isnull(' [ '+COMMENTS+' ]','')
from WAREHOUSE w
union
select
	pw.WAREHOUSE_ID,
	'   '+p.PRODUCT_DESCRIPTION,
	pw.REMAINING,
	'( @'+convert(varchar,p.PRICE)+'/'+p.ITEM_TYPE+') '+isnull('[ '+p.COMMENTS+' ]','')
 from PRODUCT_IN_WAREHOUSE pw join PRODUCT p on p.PRODUCT_ID=pw.PRODUCT_ID
order by 1,3
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
