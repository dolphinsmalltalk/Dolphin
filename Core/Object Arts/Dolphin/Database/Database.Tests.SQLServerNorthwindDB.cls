"Filed out from Dolphin Smalltalk"!

Database.Tests.DBConnectionTestResource
	subclass: #'Database.Tests.SQLServerNorthwindDB'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Database.Tests.SQLServerNorthwindDB guid: (Core.GUID fromString: '{2575aff5-9fad-4133-bf64-34ff8442f774}')!

Database.Tests.SQLServerNorthwindDB comment: ''!

!Database.Tests.SQLServerNorthwindDB methodsFor!

connectString
	^('DRIVER={<1s>};SERVER=<2s>;' , (self isCiBuild
				ifTrue: 
					["APPVEYOR config is 'DRIVER=SQL Server;Server=(local)\SQL2022;Database=master;User ID=sa;Password=Password12!!"
					'DATABASE=master;UID=<3s>;PWD=<4s>']
				ifFalse: 
					["If running locally use localdb. There will need to be an instance named MSSQLlocalDB"
					'Trusted_Connection=Yes']))
		<< { self odbcDriver. self serverName. self uid. self pwd }!

createDatabase
	| sql |
	sql := (Kernel.PackageRelativeFileLocator package: self class owningPackage)
				localFileSpecFor: 'Northwind.sql'.
	^self execSqlCmd: 'sqlcmd -S <1d> -i "<4d>"' << {self serverName. self uid. self pwd. sql}
		stdin: nil!

dropDatabase
	self connection
		ifNotNil: 
			[:cnxn |
			
			[cnxn
				exec: 'USE [master]';
				exec: 'DROP DATABASE [Northwind]'] on: DBError
					do: [:ex | ex toTrace]].
	super dropDatabase!

getOdbcDriver
	| drivers odbc |
	drivers := (DBConnection installedOdbcDrivers select: [:each | each endsWith: 'SQL Server'])
				asSortedCollection.
	drivers isEmpty ifTrue: [^nil].
	odbc := drivers select: [:each | each beginsWith: 'ODBC'].
	^(odbc isEmpty ifTrue: [drivers] ifFalse: [odbc]) last!

newConnection
	^super newConnection
		ifNotNil: 
			[:cnxn |
			cnxn
				exec: 'USE [Northwind]';
				yourself]!

prereqsAvailable
	^super prereqsAvailable
		and: [self isCiBuild or: [self sqllocaldbInstances includes: 'MSSQLLocalDB']]!

requiredOdbcVersion
	^OS.ODBCConstants.SQL_OV_ODBC3_80!

serverName
	^self isCiBuild ifTrue: ['(local)\SQL2022'] ifFalse: ['(localdb)\MSSQLLocalDB']!

sqllocaldbInstances
	| process instances |
	process := Smalltalk.ExternalProcess new.
	instances := OrderedCollection new.
	
	[process
		executeCommand: 'sqllocaldb i'
		inDirectory: nil
		waitForSeconds: 1
		stdin: nil
		stdout: [:out | instances := out lines]
		stderr: 
			[:err |
			Transcript
				nextPutAll: err;
				cr].
	process processExitCode = 0]
			on: Smalltalk.ExternalProcessExecuteError
			do: [:ex | ex toTrace].
	^instances!

uid
	^'sa'! !

!Database.Tests.SQLServerNorthwindDB categoriesForMethods!
connectString!accessing!private! !
createDatabase!operations!private! !
dropDatabase!operations!private! !
getOdbcDriver!constants!private! !
newConnection!operations!public! !
prereqsAvailable!operations!private! !
requiredOdbcVersion!constants!private! !
serverName!constants!private! !
sqllocaldbInstances!constants!private! !
uid!constants!public! !
!

