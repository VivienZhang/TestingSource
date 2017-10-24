USE [msdb]
GO

/****** Object:  Job [IO_Latch_Noise1]    Script Date: 12/17/2012 5:56:38 PM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]]    Script Date: 12/17/2012 5:56:38 PM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'IO_Latch_Noise1', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [IO_Latch_Noise1]    Script Date: 12/17/2012 5:56:38 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'IO_Latch_Noise1', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'---Run this scrirpt from the instance server
USE sales
GO
IF NOT EXISTS(SELECT * FROM sysobjects WHERE type=''U'' and name=''ORDL1'')
	CREATE TABLE [dbo].[ORDL1](
		[ORDER_ID] [decimal](8, 0) NOT NULL,
		[PRODUCT_ID] [decimal](8, 0) NOT NULL,
		[AMOUNT] [decimal](11, 0) NULL,
		[COMMENTS] [varchar](255) COLLATE Latin1_General_CS_AS NULL,
		[DATE_OF_ORDER] [datetime] NULL,
		CONSTRAINT [PK_ORDL1] PRIMARY KEY NONCLUSTERED
			([ORDER_ID] ASC,
			 [PRODUCT_ID] ASC) ON [PRIMARY]) ON [PRIMARY]
ELSE
	TRUNCATE TABLE [dbo].[ORDL1];
GO
DECLARE  @killme int,@started datetime;
SELECT   @killme=30--SET THIS VALUE IN SECONDS TO END THE LOOP AFTER @killme SECONDS
        ,@started=getdate();
WHILE DATEDIFF(ss,@started,getdate())<@killme
    BEGIN
        INSERT INTO [dbo].[ORDL1]
        	SELECT * FROM [dbo].[ORDER_LINE];
        DELETE FROM [dbo].[ORDL1];
    END
GO', 
		@database_name=N'sales', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'IO_Latch_Sched', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=2, 
		@freq_subday_interval=30, 
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


USE [msdb]
GO

/****** Object:  Job [IO_Latch_Noise2]    Script Date: 12/17/2012 5:56:44 PM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]]    Script Date: 12/17/2012 5:56:44 PM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'IO_Latch_Noise2', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [IO_Latch_Noise2]    Script Date: 12/17/2012 5:56:45 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'IO_Latch_Noise2', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'USE sales
GO
IF NOT EXISTS(SELECT * FROM sysobjects WHERE type=''U'' and name=''ORDL2'')
	CREATE TABLE [dbo].[ORDL2](
		[ORDER_ID] [decimal](8, 0) NOT NULL,
		[PRODUCT_ID] [decimal](8, 0) NOT NULL,
		[AMOUNT] [decimal](11, 0) NULL,
		[COMMENTS] [varchar](255) COLLATE Latin1_General_CS_AS NULL,
		[DATE_OF_ORDER] [datetime] NULL,
		CONSTRAINT [PK_ORDL2] PRIMARY KEY NONCLUSTERED
			([ORDER_ID] ASC,
			 [PRODUCT_ID] ASC) ON [PRIMARY]) ON [PRIMARY]
ELSE
	TRUNCATE TABLE [dbo].[ORDL1];
GO
DECLARE  @killme int,@started datetime;
SELECT   @killme=30--SET THIS VALUE IN SECONDS TO END THE LOOP AFTER @killme SECONDS
        ,@started=getdate();
WHILE DATEDIFF(ss,@started,getdate())<@killme
    BEGIN
        INSERT INTO [dbo].[ORDL2]
        	SELECT * FROM [dbo].[ORDER_LINE];
        DELETE FROM [dbo].[ORDL2];
    END
GO', 
		@database_name=N'master', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'IO_Latch_Sched2', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=2, 
		@freq_subday_interval=30, 
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


USE [msdb]
GO

/****** Object:  Job [IO_Latch_Noise3]    Script Date: 12/17/2012 5:56:52 PM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]]    Script Date: 12/17/2012 5:56:52 PM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'IO_Latch_Noise3', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [IO_Latch_Noise3]    Script Date: 12/17/2012 5:56:52 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'IO_Latch_Noise3', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'USE sales
GO
IF NOT EXISTS(SELECT * FROM sysobjects WHERE type=''U'' and name=''ORDL3'')
	CREATE TABLE [dbo].[ORDL3](
		[ORDER_ID] [decimal](8, 0) NOT NULL,
		[PRODUCT_ID] [decimal](8, 0) NOT NULL,
		[AMOUNT] [decimal](11, 0) NULL,
		[COMMENTS] [varchar](255) COLLATE Latin1_General_CS_AS NULL,
		[DATE_OF_ORDER] [datetime] NULL,
		CONSTRAINT [PK_ORDL3] PRIMARY KEY NONCLUSTERED
			([ORDER_ID] ASC,
			 [PRODUCT_ID] ASC) ON [PRIMARY]) ON [PRIMARY]
ELSE
	TRUNCATE TABLE [dbo].[ORDL1];
GO
DECLARE  @killme int,@started datetime;
SELECT   @killme=30--SET THIS VALUE IN SECONDS TO END THE LOOP AFTER @killme SECONDS
        ,@started=getdate();
WHILE DATEDIFF(ss,@started,getdate())<@killme
    BEGIN
        INSERT INTO [dbo].[ORDL3]
        	SELECT * FROM [dbo].[ORDER_LINE];
        DELETE FROM [dbo].[ORDL3];
    END
GO', 
		@database_name=N'master', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'IO_Latch_Sched3', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=2, 
		@freq_subday_interval=30, 
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


