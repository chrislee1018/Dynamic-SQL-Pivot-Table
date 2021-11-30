<h3 align="center">Dynamic SQL Pivot Table</h3>

  <p align="center">
    A stored procedure in T-SQL to dynamically generate a pivot table based on user specified parameters.
    <br />
  </p>
</div>

## About

The main purpose of using a dynamic pivot table is that it will adapt if underlying table values change without the need to alter the code for the pivot.  This would not be possible with a regular pivot in T-SQL as if a new value was inserted into the table, the pivot table would not display the new value because it is not defined within the IN operator.
<p align="right">(<a href="#top">back to top</a>)</p>

<!-- GETTING STARTED -->
## Prerequisites

* Microsoft SQL Server 2016 (or later).
* Microsoft SQL Server Management Studio
<p align="right">(<a href="#top">back to top</a>)</p>

## Usage

A standard example with sample data to show how the stored procedure can be used.

```TSQL
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

EXEC #usp_DynamicPivotGeneric
   @HorizontalValueField  = 'Subject', -- get list of unique values
   @TableToPivot  = '#SampleData', -- table that holds data
   @AggregationFunction  = 'SUM', -- type of operation to perform
   @AggregationValueField   = 'Score', -- column value for pivot operation
   @VerticalValueField    = 'Student' -- order results by column

```
<p align="right">(<a href="#top">back to top</a>)</p>

<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. 

* Fork the Project
* Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
* Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
* Push to the Branch (`git push origin feature/AmazingFeature`)
* Open a Pull Request
<p align="right">(<a href="#top">back to top</a>)</p>

## Authors

* **Christopher Lee** (https://github.com/chrislee1018/)
<p align="right">(<a href="#top">back to top</a>)</p>

## License

This project is licensed under the GNU General Public License License 3.0 - see the [LICENSE](LICENSE) file for details.
<p align="right">(<a href="#top">back to top</a>)</p>

