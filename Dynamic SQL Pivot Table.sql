-- Dynamic SQL Pivot Table with Sample Data
-- Christopher Lee - 2021
--
-- This program is free software : you can redistribute itand /or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.If not, see < https://www.gnu.org/licenses/>.


-- Stored procedure to manage generating dynamic SQL logic.

-- Drop the above proc
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

-- Create table for sample data and populate with values.

IF OBJECT_ID('tempdb..#SampleData') IS NOT NULL
    Truncate TABLE #SampleData
else
CREATE TABLE #SampleData
([Student] [varchar](40) NULL, 
[Subject] [varchar](40) NULL, 
[Year] [int] NULL, 
[Score] [int] NULL) ON [PRIMARY] 

insert into #SampleData values
('Paul', 'Calculus', '2020', '90'), 
('Paul', 'Set Theory', '2020', '100'), 
('Paul', 'Mechanics', '2020', '100'),
('Luke', 'Calculus', '2020', '95'),
('Luke', 'Set Theory', '2020', '96'), 
('Luke', 'Mechanics', '2020', '100'), 
('John ', 'Calculus', '2020', '95'), 
('John', 'Set Theory', '2020', '96'), 
('John', 'Mechanics', '2020', '100'), 
('Thomas', 'Calculus', '2020', '90'), 
('Thomas', 'Set Theory', '2020', '100'), 
('Thomas', 'Mechanics', '2020', '100')

-- Execute stored procedure with parameters populated by sample data

EXEC #usp_DynamicPivotGeneric
   @HorizontalValueField  = 'Subject', -- get list of unique values
   @TableToPivot  = '#SampleData', -- table that holds data
   @AggregationFunction  = 'SUM', -- type of operation to perform
   @AggregationValueField   = 'Score', -- column value for pivot operation
   @VerticalValueField    = 'Student' -- order results by column
