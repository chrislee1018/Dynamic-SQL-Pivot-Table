# Dynamic-SQL-Pivot-Table

An implementation of the Pearson Correlation Coefficient in T-SQL with sample data to demonstrate functionality.

## Background

In statistics, the Pearson correlation coefficient, also referred to as Pearson's r is a measure of linear correlation between two sets of data.

It is the covariance of two variables, divided by the product of their standard deviations. This creates a normalised measurement of covariance with a result between −1 and 1. 

## Stored Procedure

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

## Authors

* **Christopher Lee** (https://github.com/chrislee1018/)


## License

This project is licensed under the GNU General Public License License 3.0 - see the [LICENSE](LICENSE) file for details



