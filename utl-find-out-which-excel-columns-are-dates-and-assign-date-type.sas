Find out which excel columns are dates and assign date type                                                                              
                                                                                                                                         
Firstobs=2 suggests you are skipping over the first data record                                                                          
which it sounds like it has  dates (but other issues?)?                                                                                  
You want to know which columns are excel dates and set datatypes.                                                                        
                                                                                                                                         
   Process                                                                                                                               
       1. create workbook sheet with problematic forst record                                                                            
       2. Determine which columns are dates.                                                                                             
       3. Use firstobs=2 to ignore problematic record.                                                                                   
                                                                                                                                         
I will query the first record and find out which columns are dates.                                                                      
                                                                                                                                         
There are many ways to solve this SAs sicne you can eximine a single reoord                                                              
or even up cells and records inplace in excel.                                                                                           
There are many examples on my github site.                                                                                               
                                                                                                                                         
                                                                                                                                         
SAS 9.4M6 workstation Win 10 64bit                                                                                                       
                                                                                                                                         
github                                                                                                                                   
https://tinyurl.com/y4awmk5j                                                                                                             
https://github.com/rogerjdeangelis/utl-find-out-which-excel-columns-are-dates-and-assign-date-type                                       
                                                                                                                                         
SAS-L                                                                                                                                    
https://listserv.uga.edu/cgi-bin/wa?A2=SAS-L;e08ac2e0.2008e                                                                              
                                                                                                                                         
/*                   _                                                                                                                   
(_)_ __  _ __  _   _| |_                                                                                                                 
| | `_ \| `_ \| | | | __|                                                                                                                
| | | | | |_) | |_| | |_                                                                                                                 
|_|_| |_| .__/ \__,_|\__|                                                                                                                
        |_|                                                                                                                              
*/                                                                                                                                       
                                                                                                                                         
%utlfkil(d:/xls/have.xlsx);                                                                                                              
                                                                                                                                         
libname xel "d:/xls/have.xlsx";                                                                                                          
                                                                                                                                         
data xel.have;                                                                                                                           
  retain name sex;                                                                                                                       
  format                                                                                                                                 
     yesterday                                                                                                                           
     today                                                                                                                               
     tomorrow  mmddyy10.;                                                                                                                
  set sashelp.class(obs=1 keep=name sex);                                                                                                
  do i=1 to 3;                                                                                                                           
      if i=1 then do; name='BUTTONS';SEX="B"; end;                                                                                       
      else do; name="Joyce";sex="F";end;                                                                                                 
      yesterday   =today()-i;                                                                                                            
      today       =today();                                                                                                              
      tomorrow    =today()+i;                                                                                                            
      output;                                                                                                                            
  end;                                                                                                                                   
  drop i;                                                                                                                                
                                                                                                                                         
run;quit;                                                                                                                                
                                                                                                                                         
libname xel clear;                                                                                                                       
                                                                                                                                         
proc report data=have(obs=3) nowd missing box;                                                                                           
run;quit;                                                                                                                                
                                                                                                                                         
                                                                                                                                         
d:/xls/have.xlsx                                                                                                                         
                                                                                                                                         
   --------------------------------------------------                                                                                    
   |   A    | B |     C     |     D     |    E      |                                                                                    
   --------------------------------------------------                                                                                    
1  |NAME    |SEX| YESTERDAY |     TODAY |  TOMORROW |                                                                                    
   |------------------------------------------------|                                                                                    
2  |BUTTONS |  B| 08/28/2020| 08/29/2020| 08/30/2020| ** PROBLEMATIC ROW?                                                                
   |--------+---+-----------+-----------+-----------|                                                                                    
3  |Joyce   |  F| 08/27/2020| 08/29/2020| 08/31/2020|                                                                                    
   |--------+---+-----------+-----------+-----------|                                                                                    
4  |Joyce   |  F| 08/26/2020| 08/29/2020| 09/01/2020|                                                                                    
   --------------------------------------------------                                                                                    
                                                                                                                                         
[HAVE]                                                                                                                                   
                                                                                                                                         
/*           _               _                                                                                                           
  ___  _   _| |_ _ __  _   _| |_                                                                                                         
 / _ \| | | | __| `_ \| | | | __|                                                                                                        
| (_) | |_| | |_| |_) | |_| | |_                                                                                                         
 \___/ \__,_|\__| .__/ \__,_|\__|                                                                                                        
                |_|                                                                                                                      
*/                                                                                                                                       
                                                                                                                                         
* BAD TECORD GONE AND DATES ARE CORRECT                                                                                                  
                                                                                                                                         
 WORK.WANT total obs=2                                                                                                                   
                                                                                                                                         
   NAME     SEX    YESTERDAY     TODAY     TOMORROW                                                                                      
                                                                                                                                         
   Joyce     F      27AUG20     29AUG20    31AUG20                                                                                       
   Joyce     F      26AUG20     29AUG20    01SEP20                                                                                       
                                                                                                                                         
/*                                                                                                                                       
 _ __  _ __ ___   ___ ___  ___ ___                                                                                                       
| `_ \| `__/ _ \ / __/ _ \/ __/ __|                                                                                                      
| |_) | | | (_) | (_|  __/\__ \__ \                                                                                                      
| .__/|_|  \___/ \___\___||___/___/                                                                                                      
|_|                                                                                                                                      
*/                                                                                                                                       
                                                                                                                                         
                                                                                                                                         
* use just the probematic record to get datatypes;                                                                                       
                                                                                                                                         
Proc sql dquote=ansi;                                                                                                                    
  connect to excel (Path="d:\xls\have.xlsx");                                                                                            
create                                                                                                                                   
    table dates as                                                                                                                       
select                                                                                                                                   
   *                                                                                                                                     
from                                                                                                                                     
   connection to Excel                                                                                                                   
    (                                                                                                                                    
     Select                                                                                                                              
          top 1                                                                                                                          
           isDate(name)      as namet                                                                                                    
          ,isDate(sex)       as sext                                                                                                     
          ,isDate(yesterday) as yesterday                                                                                                
          ,isDate(today    ) as todayt                                                                                                   
          ,isDate(tomorrow ) as tomorrowt                                                                                                
     from                                                                                                                                
          have                                                                                                                           
    );                                                                                                                                   
    disconnect from Excel                                                                                                                
;quit;                                                                                                                                   
                                                                                                                                         
                                                                                                                                         
* YESTERDAY    TODAYT    TOMORROWT are dates;                                                                                            
                                                                                                                                         
                                                                                                                                         
Up to 40 obs WORK.DATES total obs=1                                                                                                      
                                                                                                                                         
                             Minus 1 = dates                                                                                             
                        ================================                                                                                 
Obs    NAMET    SEXT    YESTERDAY    TODAYT    TOMORROWT                                                                                 
                                                                                                                                         
 1       0        0         -1         -1          -1                                                                                    
                                                                                                                                         
* input accordingly. Note scan_text=no;                                                                                                  
                                                                                                                                         
libname xel  'd:\xls\have.xlsx' scan_text=no ;                                                                                           
    data work.want;                                                                                                                      
    set xel.have(firstobs=2                                                                                                              
            dbsastype=(                                                                                                                  
                name='char(8)'                                                                                                           
                sex='char(1)'                                                                                                            
                yesterday='date'                                                                                                         
                today='date'                                                                                                             
                tomorrow='date'                                                                                                          
            ));                                                                                                                          
    run;                                                                                                                                 
libname xel  clear;                                                                                                                      
                                                                                                                                         
                                                                                                                                         
/* T1003080 SAS Passthru to Excel. Not sure how many of these are supported by MS ODBC.OLEDB drivers                                     
   I have used a dozen or so.                                                                                                            
                                                                                                                                         
                                                                                                                                         
https://ss64.com/access/                                                                                                                 
                                                                                                                                         
a                                                                                                                                        
  Abs             The absolute value of a number (ignore negative sign).                                                                 
 .AddMenu         Add a custom menu bar/shortcut bar.                                                                                    
 .AddNew          Add a new record to a recordset.                                                                                       
 .ApplyFilter     Apply a filter clause to a table, form, or report.                                                                     
  Array           Create an Array.                                                                                                       
  Asc             The Ascii code of a character.                                                                                         
  AscW            The Unicode of a character.                                                                                            
  Atn             Display the ArcTan of an angle.                                                                                        
  Avg (SQL)       Average.                                                                                                               
b                                                                                                                                        
 .Beep (DoCmd)    Sound a tone.                                                                                                          
 .BrowseTo(DoCmd) Navigate between objects.                                                                                              
c                                                                                                                                        
  Call            Call a procedure.                                                                                                      
 .CancelEvent (DoCmd) Cancel an event.                                                                                                   
 .CancelUpdate    Cancel recordset changes.                                                                                              
  Case            If Then Else.                                                                                                          
  CBool           Convert to boolean.                                                                                                    
  CByte           Convert to byte.                                                                                                       
  CCur            Convert to currency (number)                                                                                           
  CDate           Convert to Date.                                                                                                       
  CVDate          Convert to Date.                                                                                                       
  CDbl            Convert to Double (number)                                                                                             
  CDec            Convert to Decimal (number)                                                                                            
  Choose          Return a value from a list based on position.                                                                          
  ChDir           Change the current directory or folder.                                                                                
  ChDrive         Change the current drive.                                                                                              
  Chr             Return a character based on an ASCII code.                                                                             
 .ClearMacroError (DoCmd) Clear MacroError.                                                                                              
 .Close (DoCmd)           Close a form/report/window.                                                                                    
 .CloseDatabase (DoCmd)   Close the database.                                                                                            
  CInt                    Convert to Integer (number)                                                                                    
  CLng                    Convert to Long (number)                                                                                       
  Command                 Return command line option string.                                                                             
 .CopyDatabaseFile(DoCmd) Copy to an SQL .mdf file.                                                                                      
 .CopyObject (DoCmd)      Copy an Access database object.                                                                                
  Cos                     Display Cosine of an angle.                                                                                    
  Count (SQL)             Count records.                                                                                                 
  CSng             Convert to Single (number.)                                                                                           
  CStr             Convert to String.                                                                                                    
  CurDir           Return the current path.                                                                                              
  CurrentDb        Return an object variable for the current database.                                                                   
  CurrentUser      Return the current user.                                                                                              
  CVar             Convert to a Variant.                                                                                                 
d                                                                                                                                        
  Date             The current date.                                                                                                     
  DateAdd          Add a time interval to a date.                                                                                        
  DateDiff         The time difference between two dates.                                                                                
  DatePart         Return part of a given date.                                                                                          
  DateSerial       Return a date given a year, month, and day.                                                                           
  DateValue        Convert a string to a date.                                                                                           
  DAvg             Average from a set of records.                                                                                        
  Day              Return the day of the month.                                                                                          
  DCount           Count the number of records in a table/query.                                                                         
  Delete (SQL)          Delete records.                                                                                                  
 .DeleteObject (DoCmd)  Delete an object.                                                                                                
  DeleteSetting         Delete a value from the users registry                                                                           
 .DoMenuItem (DoCmd)    Display a menu or toolbar command.                                                                               
  DFirst           The first value from a set of records.                                                                                
  Dir              List the files in a folder.                                                                                           
  DLast            The last value from a set of records.                                                                                 
  DLookup          Get the value of a particular field.                                                                                  
  DMax             Return the maximum value from a set of records.                                                                       
  DMin             Return the minimum value from a set of records.                                                                       
  DoEvents         Allow the operating system to process other events.                                                                   
  DStDev           Estimate Standard deviation for domain (subset of records)                                                            
  DStDevP          Estimate Standard deviation for population (subset of records)                                                        
  DSum             Return the sum of values from a set of records.                                                                       
  DVar             Estimate variance for domain (subset of records)                                                                      
  DVarP            Estimate variance for population (subset of records)                                                                  
e                                                                                                                                        
 .Echo             Turn screen updating on or off.                                                                                       
  Environ          Return the value of an OS environment variable.                                                                       
  EOF              End of file input.                                                                                                    
  Error            Return the error message for an error No.                                                                             
  Eval             Evaluate an expression.                                                                                               
  Execute(SQL/VBA) Execute a procedure or run SQL.                                                                                       
  Exp              Exponential e raised to the nth power.                                                                                
f                                                                                                                                        
  FileDateTime      Filename last modified date/time.                                                                                    
  FileLen           The size of a file in bytes.                                                                                         
 .FindFirst/Last/Next/Previous Record.                                                                                                   
 .FindRecord(DoCmd) Find a specific record.                                                                                              
  First (SQL)       Return the first value from a query.                                                                                 
  Fix               Return the integer portion of a number.                                                                              
  For               Loop.                                                                                                                
  Format            Format a Number/Date/Time.                                                                                           
  FreeFile          The next file No. available to open.                                                                                 
  From              Specify the table(s) to be used in an SQL query.                                                                     
  FV                Future Value of an annuity.                                                                                          
g                                                                                                                                        
  GetAllSettings    List the settings saved in the registry.                                                                             
  GetAttr           Get file/folder attributes.                                                                                          
  GetObject         Return a reference to an ActiveX object                                                                              
  GetSetting        Retrieve a value from the users registry.                                                                            
  form.GoToPage     Move to a page on specific form.                                                                                     
 .GoToRecord (DoCmd)Move to a specific record in a dataset.                                                                              
h                                                                                                                                        
  Hex               Convert a number to Hex.                                                                                             
  Hour              Return the hour of the day.                                                                                          
 .Hourglass (DoCmd) Display the hourglass icon.                                                                                          
  HyperlinkPart     Return information about data stored as a hyperlink.                                                                 
i                                                                                                                                        
  If Then Else      If-Then-Else                                                                                                         
  IIf               If-Then-Else function.                                                                                               
  Input             Return characters from a file.                                                                                       
  InputBox          Prompt for user input.                                                                                               
  Insert (SQL)      Add records to a table (append query).                                                                               
  InStr             Return the position of one string within another.                                                                    
  InstrRev          Return the position of one string within another.                                                                    
  Int               Return the integer portion of a number.                                                                              
  IPmt              Interest payment for an annuity                                                                                      
  IsArray           Test if an expression is an array                                                                                    
  IsDate            Test if an expression is a date.                                                                                     
  IsEmpty           Test if an expression is Empty (unassigned).                                                                         
  IsError           Test if an expression is returning an error.                                                                         
  IsMissing         Test if a missing expression.                                                                                        
  IsNull            Test for a NULL expression or Zero Length string.                                                                    
  IsNumeric         Test for a valid Number.                                                                                             
  IsObject          Test if an expression is an Object.                                                                                  
L                                                                                                                                        
  Last (SQL)        Return the last value from a query.                                                                                  
  LBound            Return the smallest subscript from an array.                                                                         
  LCase             Convert a string to lower-case.                                                                                      
  Left              Extract a substring from a string.                                                                                   
  Len               Return the length of a string.                                                                                       
  LoadPicture       Load a picture into an ActiveX control.                                                                              
  Loc               The current position within an open file.                                                                            
 .LockNavigationPane(DoCmd) Lock the Navigation Pane.                                                                                    
  LOF               The length of a file opened with Open()                                                                              
  Log               Return the natural logarithm of a number.                                                                            
  LTrim             Remove leading spaces from a string.                                                                                 
m                                                                                                                                        
  Max (SQL)         Return the maximum value from a query.                                                                               
 .Maximize (DoCmd)  Enlarge the active window.                                                                                           
  Mid               Extract a substring from a string.                                                                                   
  Min (SQL)         Return the minimum value from a query.                                                                               
 .Minimize (DoCmd)  Minimise a window.                                                                                                   
  Minute            Return the minute of the hour.                                                                                       
  MkDir             Create directory.                                                                                                    
  Month             Return the month for a given date.                                                                                   
  MonthName         Return  a string representing the month.                                                                             
 .Move              Move through a Recordset.                                                                                            
 .MoveFirst/Last/Next/Previous Record                                                                                                    
 .MoveSize (DoCmd)  Move or Resize a Window.                                                                                             
  MsgBox            Display a message in a dialogue box.                                                                                 
n                                                                                                                                        
  Next              Continue a for loop.                                                                                                 
  Now               Return the current date and time.                                                                                    
  Nz                Detect a NULL value or a Zero Length string.                                                                         
o                                                                                                                                        
  Oct               Convert an integer to Octal.                                                                                         
  OnClick, OnOpen   Events.                                                                                                              
 .OpenForm (DoCmd)  Open a form.                                                                                                         
 .OpenQuery (DoCmd) Open a query.                                                                                                        
 .OpenRecordset         Create a new Recordset.                                                                                          
 .OpenReport (DoCmd)    Open a report.                                                                                                   
 .OutputTo (DoCmd)      Export to a Text/CSV/Spreadsheet file.                                                                           
p                                                                                                                                        
  Partition (SQL)       Locate a number within a range.                                                                                  
 .PrintOut (DoCmd)      Print the active object (form/report etc.)                                                                       
q                                                                                                                                        
  Quit                  Quit Microsoft Access                                                                                            
r                                                                                                                                        
 .RefreshRecord (DoCmd) Refresh the data in a form.                                                                                      
 .Rename (DoCmd)        Rename an object.                                                                                                
 .RepaintObject (DoCmd) Complete any pending screen updates.                                                                             
  Replace               Replace a sequence of characters in a string.                                                                    
 .Requery               Requery the data in a form or a control.                                                                         
 .Restore (DoCmd)       Restore a maximized or minimized window.                                                                         
  RGB                   Convert an RGB color to a number.                                                                                
  Right                 Extract a substring from a string.                                                                               
  Rnd                   Generate a random number.                                                                                        
  Round                 Round a number to n decimal places.                                                                              
  RTrim                 Remove trailing spaces from a string.                                                                            
 .RunCommand            Run an Access menu or toolbar command.                                                                           
 .RunDataMacro (DoCmd)  Run a named data macro.                                                                                          
 .RunMacro (DoCmd)      Run a macro.                                                                                                     
 .RunSavedImportExport (DoCmd) Run a saved import or export specification.                                                               
 .RunSQL (DoCmd)        Run an SQL query.                                                                                                
s                                                                                                                                        
 .Save (DoCmd)          Save a database object.                                                                                          
  SaveSetting           Store a value in the users registry                                                                              
 .SearchForRecord(DoCmd) Search for a specific record.                                                                                   
  Second                Return the seconds of the minute.                                                                                
  Seek                  The position within a file opened with Open.                                                                     
  Select (SQL)          Retrieve data from one or more tables or queries.                                                                
  Select Into (SQL)     Make-table query.                                                                                                
  Select-Subquery (SQL) SubQuery.                                                                                                        
 .SelectObject (DoCmd)  Select a specific database object.                                                                               
 .SendObject (DoCmd)    Send an email with a database object attached.                                                                   
  SendKeys              Send keystrokes to the active window.                                                                            
  SetAttr               Set the attributes of a file.                                                                                    
 .SetDisplayedCategories (DoCmd)  Change Navigation Pane display options.                                                                
 .SetFilter (DoCmd)     Apply a filter to the records being displayed.                                                                   
  SetFocus              Move focus to a specified field or control.                                                                      
 .SetMenuItem (DoCmd)   Set the state of menubar items (enabled /checked)                                                                
 .SetOrderBy (DoCmd)    Apply a sort to the active datasheet, form or report.                                                            
 .SetParameter (DoCmd)  Set a parameter before opening a Form or Report.                                                                 
 .SetWarnings (DoCmd)   Turn system messages on or off.                                                                                  
  Sgn                   Return the sign of a number.                                                                                     
 .ShowAllRecords(DoCmd) Remove any applied filter.                                                                                       
 .ShowToolbar (DoCmd)   Display or hide a custom toolbar.                                                                                
  Shell                 Run an executable program.                                                                                       
  Sin                   Display Sine of an angle.                                                                                        
  SLN                   Straight Line Depreciation.                                                                                      
  Space                 Return a number of spaces.                                                                                       
  Sqr                   Return the square root of a number.                                                                              
  StDev (SQL)           Estimate the standard deviation for a population.                                                                
  Str                   Return a string representation of a number.                                                                      
  StrComp               Compare two strings.                                                                                             
  StrConv               Convert a string to Upper/lower case or Unicode.                                                                 
  String                Repeat a character n times.                                                                                      
  Sum (SQL)             Add up the values in a query result set.                                                                         
  Switch                Return one of several values.                                                                                    
  SysCmd                Display a progress meter.                                                                                        
t                                                                                                                                        
  Tan                   Display Tangent of an angle.                                                                                     
  Time                  Return the current system time.                                                                                  
  Timer                 Return a number (single) of seconds since midnight.                                                              
  TimeSerial            Return a time given an hour, minute, and second.                                                                 
  TimeValue             Convert a string to a Time.                                                                                      
 .TransferDatabase (DoCmd)      Import or export data to/from another database.                                                          
 .TransferSharePointList(DoCmd) Import or link data from a SharePoint Foundation site.                                                   
 .TransferSpreadsheet (DoCmd)   Import or export data to/from a spreadsheet file.                                                        
 .TransferSQLDatabase (DoCmd)   Copy an entire SQL Server database.                                                                      
 .TransferText (DoCmd)          Import or export data to/from a text file.                                                               
  Transform (SQL)       Create a crosstab query.                                                                                         
  Trim                  Remove leading and trailing spaces from a string.                                                                
  TypeName              Return the data type of a variable.                                                                              
u                                                                                                                                        
  UBound                Return the largest subscript from an array.                                                                      
  UCase                 Convert a string to upper-case.                                                                                  
  Undo                  Undo the last data edit.                                                                                         
  Union (SQL)           Combine the results of two SQL queries.                                                                          
  Update (SQL)          Update existing field values in a table.                                                                         
 .Update                Save a recordset.                                                                                                
v                                                                                                                                        
  Val                   Extract a numeric value from a string.                                                                           
  Var (SQL)             Estimate variance for sample (all records)                                                                       
  VarP (SQL)            Estimate variance for population (all records)                                                                   
  VarType               Return a number indicating the data type of a variable.                                                          
w                                                                                                                                        
  Weekday               Return the weekday (1-7) from a date.                                                                            
  WeekdayName           Return the day of the week.                                                                                      
y                                                                                                                                        
  Year                  Return the year for a given date.                                                                                
                                                                                                                                         
                                                                                                                                         
                                                                                                                                         
