------------------------------------------------------------
---------will create Recompiles IO and CPU activity---------
------------------------------------------------------------


 

GO

/****** Object:  Job [CPU_Noise]    Script Date: 12/17/2012 4:24:49 PM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]]    Script Date: 12/17/2012 4:24:49 PM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'CPU_Noise50', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [CPU_Noise]    Script Date: 12/17/2012 4:24:49 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'CPU_Noise', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'------cursor script that effects:Physical Read & Writes/s, Lazy Writes, Log Flushes, Logical Reads, Compiles/s, Packets/s IN, Packets/s Out, Batches/s, Page Life Expectancy, CPU Usage, 


USE sales
GO
IF OBJECT_ID(''#customer_order_report'') IS NOT NULL
    DROP TABLE #customer_order_report;
GO

DECLARE @ord_id     INT
DECLARE @dte_ord    DATETIME
DECLARE @stat_desc  VARCHAR(20)
DECLARE @amt        INT
DECLARE @cust_nme   VARCHAR(31)
DECLARE @cust_st    VARCHAR(30)
DECLARE @cust_city  VARCHAR(20)
DECLARE @cust_zip   CHAR(5)
DECLARE @cust_phone VARCHAR(15)
DECLARE @tot_sales  DECIMAL(15,2)
DECLARE @emp_nme    VARCHAR(31)
DECLARE @emp_branch CHAR(7)
DECLARE @emp_hired  DATETIME
DECLARE @comments   VARCHAR(255)
DECLARE @ActiveTime DATETIME;
SELECT  @ActiveTime = GETDATE();

IF OBJECT_ID(''#customer_order_report'') IS NULL
CREATE TABLE [dbo].[#customer_order_report](
    [ord_id]     INT,
    [dte_ord]    DATETIME,
    [stat_desc]  VARCHAR(20),
    [amt]        INT,
    [cust_nme]   VARCHAR(31),
    [cust_st]    VARCHAR(30),
    [cust_city]  VARCHAR(20),
    [cust_zip]   CHAR(5),
    [cust_phone] VARCHAR(15),
    [tot_sales]  DECIMAL(15,2),
    [emp_nme]    VARCHAR(31),
    [emp_branch] CHAR(7),
    [emp_hired]  DATETIME,
    [comments]   VARCHAR(255))

DECLARE a_cursor   CURSOR LOCAL FORWARD_ONLY STATIC READ_ONLY FOR
    SELECT      ord.[ORDER_ID]                                                          order_nbr,
                ord.[DATE_OF_ORDER]                                                     order_dte,
                LTRIM(RTRIM(ord.[STATUS]))                                 		order_status,
                orl.[AMOUNT]                                                            order_amt,
                LTRIM(RTRIM(cust.[FIRST_NAME])) + '' '' + LTRIM(RTRIM(cust.[LAST_NAME]))  cust_nme,
                LTRIM(RTRIM(cust.[STREET]))                                             cust_street,
                LTRIM(RTRIM(city.[CITY_DESCRIPTION]))                                   cust_city,
                cust.[ZIP_CODE]                                                         cust_zip,
                LTRIM(RTRIM(cust.[PHONE]))                                              cust_phone,
                cust.[TOTAL_SALES]                                                      cust_tot_sales,
                LTRIM(RTRIM(emp.[FIRST_NAME])) + '' '' + LTRIM(RTRIM(emp.[LAST_NAME]))    emp_assigned,
                LTRIM(RTRIM(emp.[BRANCH_CODE]))                                         emp_branch,
                emp.[DATE_OF_HIRE]                                                      emp_hire_dte,
                LTRIM(RTRIM(orl.[COMMENTS]))                                            comments
    FROM        [dbo].[ORDERS]      ord
    INNER JOIN  [dbo].[ORDER_LINE]  orl
            ON  ord.[ORDER_ID] = orl.[ORDER_ID]
    INNER JOIN  [dbo].[CUSTOMER]    cust
            ON  ord.[CUSTOMER_ID] = cust.[CUSTOMER_ID]
    INNER JOIN  [dbo].[CITY]        city
            ON  cust.[CITY] = city.[CITY_CODE]
    INNER JOIN  [dbo].[EMPLOYEE]    emp
            ON  ord.[EMPLOYEE_RECIEVING] = emp.[EMPLOYEE_ID]
OPEN a_cursor
DECLARE b_cursor   CURSOR LOCAL FORWARD_ONLY STATIC READ_ONLY TYPE_WARNING FOR
    SELECT      ord.[ORDER_ID]                                                          order_nbr,
                ord.[DATE_OF_ORDER]                                                     order_dte,
                LTRIM(RTRIM(ord.[STATUS]))                                 		order_status,
                orl.[AMOUNT]                                                            order_amt,
                LTRIM(RTRIM(cust.[FIRST_NAME])) + '' '' + LTRIM(RTRIM(cust.[LAST_NAME]))  cust_nme,
                LTRIM(RTRIM(cust.[STREET]))                                             cust_street,
                LTRIM(RTRIM(city.[CITY_DESCRIPTION]))                                   cust_city,
                cust.[ZIP_CODE]                                                         cust_zip,
                LTRIM(RTRIM(cust.[PHONE]))                                              cust_phone,
                cust.[TOTAL_SALES]                                                      cust_tot_sales,
                LTRIM(RTRIM(emp.[FIRST_NAME])) + '' '' + LTRIM(RTRIM(emp.[LAST_NAME]))    emp_assigned,
                LTRIM(RTRIM(emp.[BRANCH_CODE]))                                         emp_branch,
                emp.[DATE_OF_HIRE]                                                      emp_hire_dte,
                LTRIM(RTRIM(orl.[COMMENTS]))                                            comments
    FROM        [dbo].[ORDERS]      ord
    INNER JOIN  [dbo].[ORDER_LINE]  orl
            ON  ord.[ORDER_ID] = orl.[ORDER_ID]
    INNER JOIN  [dbo].[CUSTOMER]    cust
            ON  ord.[CUSTOMER_ID] = cust.[CUSTOMER_ID]
    INNER JOIN  [dbo].[CITY]        city
            ON  cust.[CITY] = city.[CITY_CODE]
    INNER JOIN  [dbo].[EMPLOYEE]    emp
            ON  ord.[EMPLOYEE_RECIEVING] = emp.[EMPLOYEE_ID]
OPEN b_cursor
DECLARE c_cursor   CURSOR LOCAL FORWARD_ONLY STATIC FOR
    SELECT      ord.[ORDER_ID]                                                          order_nbr,
                ord.[DATE_OF_ORDER]                                                     order_dte,
                LTRIM(RTRIM(ord.[STATUS]))                                 		order_status,
                orl.[AMOUNT]                                                            order_amt,
                LTRIM(RTRIM(cust.[FIRST_NAME])) + '' '' + LTRIM(RTRIM(cust.[LAST_NAME]))  cust_nme,
                LTRIM(RTRIM(cust.[STREET]))                                             cust_street,
                LTRIM(RTRIM(city.[CITY_DESCRIPTION]))                                   cust_city,
                cust.[ZIP_CODE]                                                         cust_zip,
                LTRIM(RTRIM(cust.[PHONE]))                                              cust_phone,
                cust.[TOTAL_SALES]                                                      cust_tot_sales,
                LTRIM(RTRIM(emp.[FIRST_NAME])) + '' '' + LTRIM(RTRIM(emp.[LAST_NAME]))    emp_assigned,
                LTRIM(RTRIM(emp.[BRANCH_CODE]))                                         emp_branch,
                emp.[DATE_OF_HIRE]                                                      emp_hire_dte,
                LTRIM(RTRIM(orl.[COMMENTS]))                                            comments
    FROM        [dbo].[ORDERS]      ord
    INNER JOIN  [dbo].[ORDER_LINE]  orl
            ON  ord.[ORDER_ID] = orl.[ORDER_ID]
    INNER JOIN  [dbo].[CUSTOMER]    cust
            ON  ord.[CUSTOMER_ID] = cust.[CUSTOMER_ID]
    INNER JOIN  [dbo].[CITY]        city
            ON  cust.[CITY] = city.[CITY_CODE]
    INNER JOIN  [dbo].[EMPLOYEE]    emp
            ON  ord.[EMPLOYEE_RECIEVING] = emp.[EMPLOYEE_ID]
OPEN c_cursor
DECLARE d_cursor   CURSOR LOCAL FORWARD_ONLY SCROLL_LOCKS TYPE_WARNING FOR
    SELECT      ord.[ORDER_ID]                                                          order_nbr,
                ord.[DATE_OF_ORDER]                                                     order_dte,
                LTRIM(RTRIM(ord.[STATUS]))                                 		order_status,
                orl.[AMOUNT]                                                            order_amt,
                LTRIM(RTRIM(cust.[FIRST_NAME])) + '' '' + LTRIM(RTRIM(cust.[LAST_NAME]))  cust_nme,
                LTRIM(RTRIM(cust.[STREET]))                                             cust_street,
                LTRIM(RTRIM(city.[CITY_DESCRIPTION]))                                   cust_city,
                cust.[ZIP_CODE]                                                         cust_zip,
                LTRIM(RTRIM(cust.[PHONE]))                                              cust_phone,
                cust.[TOTAL_SALES]                                                      cust_tot_sales,
                LTRIM(RTRIM(emp.[FIRST_NAME])) + '' '' + LTRIM(RTRIM(emp.[LAST_NAME]))    emp_assigned,
                LTRIM(RTRIM(emp.[BRANCH_CODE]))                                         emp_branch,
                emp.[DATE_OF_HIRE]                                                      emp_hire_dte,
                LTRIM(RTRIM(orl.[COMMENTS]))                                            comments
    FROM        [dbo].[ORDERS]      ord
    INNER JOIN  [dbo].[ORDER_LINE]  orl
            ON  ord.[ORDER_ID] = orl.[ORDER_ID]
    INNER JOIN  [dbo].[CUSTOMER]    cust
            ON  ord.[CUSTOMER_ID] = cust.[CUSTOMER_ID]
    INNER JOIN  [dbo].[CITY]        city
            ON  cust.[CITY] = city.[CITY_CODE]
    INNER JOIN  [dbo].[EMPLOYEE]    emp
            ON  ord.[EMPLOYEE_RECIEVING] = emp.[EMPLOYEE_ID]
OPEN d_cursor
DECLARE e_cursor   CURSOR LOCAL FORWARD_ONLY STATIC OPTIMISTIC FOR
    SELECT      ord.[ORDER_ID]                                                          order_nbr,
                ord.[DATE_OF_ORDER]                                                     order_dte,
                LTRIM(RTRIM(ord.[STATUS]))                                 		order_status,
                orl.[AMOUNT]                                                            order_amt,
                LTRIM(RTRIM(cust.[FIRST_NAME])) + '' '' + LTRIM(RTRIM(cust.[LAST_NAME]))  cust_nme,
                LTRIM(RTRIM(cust.[STREET]))                                             cust_street,
                LTRIM(RTRIM(city.[CITY_DESCRIPTION]))                                   cust_city,
                cust.[ZIP_CODE]                                                         cust_zip,
                LTRIM(RTRIM(cust.[PHONE]))                                              cust_phone,
                cust.[TOTAL_SALES]                                                      cust_tot_sales,
                LTRIM(RTRIM(emp.[FIRST_NAME])) + '' '' + LTRIM(RTRIM(emp.[LAST_NAME]))    emp_assigned,
                LTRIM(RTRIM(emp.[BRANCH_CODE]))                                         emp_branch,
                emp.[DATE_OF_HIRE]                                                      emp_hire_dte,
                LTRIM(RTRIM(orl.[COMMENTS]))                                            comments
    FROM        [dbo].[ORDERS]      ord
    INNER JOIN  [dbo].[ORDER_LINE]  orl
            ON  ord.[ORDER_ID] = orl.[ORDER_ID]
    INNER JOIN  [dbo].[CUSTOMER]    cust
            ON  ord.[CUSTOMER_ID] = cust.[CUSTOMER_ID]
    INNER JOIN  [dbo].[CITY]        city
            ON  cust.[CITY] = city.[CITY_CODE]
    INNER JOIN  [dbo].[EMPLOYEE]    emp
            ON  ord.[EMPLOYEE_RECIEVING] = emp.[EMPLOYEE_ID]
OPEN e_cursor
DECLARE f_cursor   CURSOR LOCAL FORWARD_ONLY STATIC OPTIMISTIC TYPE_WARNING FOR
    SELECT      ord.[ORDER_ID]                                                          order_nbr,
                ord.[DATE_OF_ORDER]                                                     order_dte,
                LTRIM(RTRIM(ord.[STATUS]))                                 		order_status,
                orl.[AMOUNT]                                                            order_amt,
                LTRIM(RTRIM(cust.[FIRST_NAME])) + '' '' + LTRIM(RTRIM(cust.[LAST_NAME]))  cust_nme,
                LTRIM(RTRIM(cust.[STREET]))                                             cust_street,
                LTRIM(RTRIM(city.[CITY_DESCRIPTION]))                                   cust_city,
                cust.[ZIP_CODE]                                                         cust_zip,
                LTRIM(RTRIM(cust.[PHONE]))                                              cust_phone,
                cust.[TOTAL_SALES]                                                      cust_tot_sales,
                LTRIM(RTRIM(emp.[FIRST_NAME])) + '' '' + LTRIM(RTRIM(emp.[LAST_NAME]))    emp_assigned,
                LTRIM(RTRIM(emp.[BRANCH_CODE]))                                         emp_branch,
                emp.[DATE_OF_HIRE]                                                      emp_hire_dte,
                LTRIM(RTRIM(orl.[COMMENTS]))                                            comments
    FROM        [dbo].[ORDERS]      ord
    INNER JOIN  [dbo].[ORDER_LINE]  orl
            ON  ord.[ORDER_ID] = orl.[ORDER_ID]
    INNER JOIN  [dbo].[CUSTOMER]    cust
            ON  ord.[CUSTOMER_ID] = cust.[CUSTOMER_ID]
    INNER JOIN  [dbo].[CITY]        city
            ON  cust.[CITY] = city.[CITY_CODE]
    INNER JOIN  [dbo].[EMPLOYEE]    emp
            ON  ord.[EMPLOYEE_RECIEVING] = emp.[EMPLOYEE_ID]
OPEN f_cursor

FETCH NEXT FROM a_cursor INTO @ord_id,@dte_ord,@stat_desc,@amt,@cust_nme,@cust_st,@cust_city,@cust_zip,@cust_phone,@tot_sales,@emp_nme,@emp_branch,@emp_hired,@comments
WHILE @@FETCH_STATUS = 0
    BEGIN
        PRINT ''INSIDE THE 1ST ONE''
        INSERT INTO [dbo].[#customer_order_report] VALUES(@ord_id,@dte_ord,@stat_desc,@amt,@cust_nme,@cust_st,@cust_city,@cust_zip,@cust_phone,@tot_sales,@emp_nme,@emp_branch,@emp_hired,@comments)
        FETCH NEXT FROM b_cursor INTO @ord_id,@dte_ord,@stat_desc,@amt,@cust_nme,@cust_st,@cust_city,@cust_zip,@cust_phone,@tot_sales,@emp_nme,@emp_branch,@emp_hired,@comments
        WHILE @@FETCH_STATUS = 0
            BEGIN
                PRINT ''INSIDE THE 2ND ONE''
                INSERT INTO [dbo].[#customer_order_report] VALUES(@ord_id,@dte_ord,@stat_desc,@amt,@cust_nme,@cust_st,@cust_city,@cust_zip,@cust_phone,@tot_sales,@emp_nme,@emp_branch,@emp_hired,@comments)
                FETCH NEXT FROM c_cursor INTO @ord_id,@dte_ord,@stat_desc,@amt,@cust_nme,@cust_st,@cust_city,@cust_zip,@cust_phone,@tot_sales,@emp_nme,@emp_branch,@emp_hired,@comments
                WHILE @@FETCH_STATUS = 0
                    BEGIN
                        PRINT ''INSIDE THE 3RD ONE''
                        INSERT INTO [dbo].[#customer_order_report] VALUES(@ord_id,@dte_ord,@stat_desc,@amt,@cust_nme,@cust_st,@cust_city,@cust_zip,@cust_phone,@tot_sales,@emp_nme,@emp_branch,@emp_hired,@comments)
                        FETCH NEXT FROM d_cursor INTO @ord_id,@dte_ord,@stat_desc,@amt,@cust_nme,@cust_st,@cust_city,@cust_zip,@cust_phone,@tot_sales,@emp_nme,@emp_branch,@emp_hired,@comments
                        WHILE @@FETCH_STATUS = 0
                            BEGIN
                                PRINT ''INSIDE THE 4TH ONE''
                                INSERT INTO [dbo].[#customer_order_report] VALUES(@ord_id,@dte_ord,@stat_desc,@amt,@cust_nme,@cust_st,@cust_city,@cust_zip,@cust_phone,@tot_sales,@emp_nme,@emp_branch,@emp_hired,@comments)
                                FETCH NEXT FROM e_cursor INTO @ord_id,@dte_ord,@stat_desc,@amt,@cust_nme,@cust_st,@cust_city,@cust_zip,@cust_phone,@tot_sales,@emp_nme,@emp_branch,@emp_hired,@comments
                                WHILE @@FETCH_STATUS = 0
                                    BEGIN
                                        PRINT ''INSIDE THE 5TH ONE''
                                        INSERT INTO [dbo].[#customer_order_report] VALUES(@ord_id,@dte_ord,@stat_desc,@amt,@cust_nme,@cust_st,@cust_city,@cust_zip,@cust_phone,@tot_sales,@emp_nme,@emp_branch,@emp_hired,@comments)
                                        FETCH NEXT FROM f_cursor INTO @ord_id,@dte_ord,@stat_desc,@amt,@cust_nme,@cust_st,@cust_city,@cust_zip,@cust_phone,@tot_sales,@emp_nme,@emp_branch,@emp_hired,@comments
                                        WHILE @@FETCH_STATUS = 0
                                            BEGIN
                                                PRINT ''INSIDE THE 6TH ONE''
                                                INSERT INTO [dbo].[#customer_order_report] VALUES(@ord_id,@dte_ord,@stat_desc,@amt,@cust_nme,@cust_st,@cust_city,@cust_zip,@cust_phone,@tot_sales,@emp_nme,@emp_branch,@emp_hired,@comments)

                                                FETCH NEXT FROM f_cursor INTO @ord_id,@dte_ord,@stat_desc,@amt,@cust_nme,@cust_st,@cust_city,@cust_zip,@cust_phone,@tot_sales,@emp_nme,@emp_branch,@emp_hired,@comments
                                            END
                                        FETCH NEXT FROM e_cursor INTO @ord_id,@dte_ord,@stat_desc,@amt,@cust_nme,@cust_st,@cust_city,@cust_zip,@cust_phone,@tot_sales,@emp_nme,@emp_branch,@emp_hired,@comments
                                    END
                                FETCH NEXT FROM d_cursor INTO @ord_id,@dte_ord,@stat_desc,@amt,@cust_nme,@cust_st,@cust_city,@cust_zip,@cust_phone,@tot_sales,@emp_nme,@emp_branch,@emp_hired,@comments
                            END
                        FETCH NEXT FROM c_cursor INTO @ord_id,@dte_ord,@stat_desc,@amt,@cust_nme,@cust_st,@cust_city,@cust_zip,@cust_phone,@tot_sales,@emp_nme,@emp_branch,@emp_hired,@comments
                    END
                FETCH NEXT FROM b_cursor INTO @ord_id,@dte_ord,@stat_desc,@amt,@cust_nme,@cust_st,@cust_city,@cust_zip,@cust_phone,@tot_sales,@emp_nme,@emp_branch,@emp_hired,@comments
            END
        FETCH NEXT FROM a_cursor INTO @ord_id,@dte_ord,@stat_desc,@amt,@cust_nme,@cust_st,@cust_city,@cust_zip,@cust_phone,@tot_sales,@emp_nme,@emp_branch,@emp_hired,@comments
    END

CLOSE a_cursor
CLOSE b_cursor
CLOSE c_cursor
CLOSE d_cursor
CLOSE e_cursor
CLOSE f_cursor
DEALLOCATE a_cursor
DEALLOCATE b_cursor
DEALLOCATE c_cursor
DEALLOCATE d_cursor
DEALLOCATE e_cursor
DEALLOCATE f_cursor
SELECT * FROM [dbo].[#customer_order_report]

DROP TABLE #customer_order_report

SELECT ''Time elapsed for INSERT INTO ORDER_LINE (ms)'',DATEDIFF(ms,@ActiveTime,GETDATE());
GO', 
		@database_name=N'master', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'CPU_Noise_Schd', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=2, 
		@freq_subday_interval=10, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20121213, 
		@active_end_date=99991231, 
		@active_start_time=0, 
		@active_end_time=235959
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:

GO


