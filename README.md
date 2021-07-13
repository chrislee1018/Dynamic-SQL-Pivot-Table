# Dynamic-SQL-Pivot-Table


```TSQL
IF OBJECT_ID('tempdb..#usp_DynamicPivotGeneric') IS NOT NULL DROP PROCEDURE #usp_DynamicPivotGeneric
GO

CREATE PROCEDURE #usp_DynamicPivotGeneric (
   @TableToPivot NVARCHAR (100),
   @HorizontalValueField NVARCHAR (100),
   @AggregationValueField NVARCHAR (100),
   @VerticalValueField NVARCHAR (100),
   @AggregationFunction NVARCHAR (3))
AS
BEGIN
   DECLARE @columns NVARCHAR (2000),
      @tsql NVARCHAR (2000)
   DECLARE @distinctVals TABLE (val NVARCHAR (50))

   SET NOCOUNT ON
   SET @columns = N'';
   SET @tsql = CONCAT ('SELECT DISTINCT ', @HorizontalValueField,' FROM ',@TableToPivot)
   INSERT @distinctVals EXEC (@tsql)

   SELECT @columns += CONCAT ('[', Val,']',',')
   FROM @distinctVals

   SET @columns = LEFT (@columns, LEN (@columns) - 1)
   SET @tsql = CONCAT ( 'SELECT ', @VerticalValueField,   ',', @columns,' FROM ',' ( SELECT ',@VerticalValueField,',',
         @AggregationValueField,',',   @HorizontalValueField,   ' FROM ',   @TableToPivot,   ') as t ',
         ' PIVOT (', @AggregationFunction,   '(', @AggregationValueField,   ')',' FOR ',   @HorizontalValueField,
         '   IN (', @columns,')) as pvt ',' ORDER BY ',   @VerticalValueField)
   EXEC (@tsql)
   SET NOCOUNT ON
END
GO

```
