--To create the trigger
CREATE TRIGGER TRG_ORL_CHG 
	ON [dbo].[ORDER_LINE] 
	AFTER INSERT,UPDATE
AS
UPDATE [dbo].[ORDER_LINE] 
SET [COMMENTS]='Updated by: '+SUSER_SNAME()+' on '+CONVERT(VARCHAR(50),getdate(),120) 
FROM [dbo].[ORDER_LINE] AS tbl
	,inserted AS newby
WHERE tbl.[ORDER_ID]=newby.[ORDER_ID];
--To fire the trigger
UPDATE ORDER_LINE SET AMOUNT=AMOUNT+1 WHERE ORDER_ID=1
--To see what the trigger did
select COMMENTS from ORDER_LINE WHERE ORDER_ID=1