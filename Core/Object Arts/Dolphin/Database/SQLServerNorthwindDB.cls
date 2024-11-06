"Filed out from Dolphin Smalltalk"!

DBConnectionTestResource subclass: #SQLServerNorthwindDB
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SQLServerNorthwindDB guid: (GUID fromString: '{2575aff5-9fad-4133-bf64-34ff8442f774}')!

SQLServerNorthwindDB comment: ''!

!SQLServerNorthwindDB categoriesForClass!Unclassified! !

!SQLServerNorthwindDB methodsFor!

connectionStringFormat
	^'DRIVER={<1s>}' << self latestSqlServerOdbcDriver , (self isCiBuild
				ifTrue: 
					["APPVEYOR config is 'DRIVER=SQL Server;Server=(local)\SQL2019;Database=master;User ID=sa;Password=Password12!!"
					';SERVER=<1d>;DATABASE=master;UID=<2d>;PWD=<3d>']
				ifFalse: 
					["If running locally use localdb. There will need to be an instance named MSSQLlocalDB"
					';SERVER=(localdb)\MSSQLLocalDB;Trusted_Connection=Yes'])!

connectString
	^self connectionStringFormat << { self serverName. self uid. self pwd }!

createDatabase
	| sql |
	sql := (PackageRelativeFileLocator package: self class owningPackage)
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

latestSqlServerOdbcDriver
	| drivers odbc |
	drivers := (self installedOdbcDrivers select: [:each | each endsWith: 'SQL Server'])
				asSortedCollection.
	odbc := drivers select: [:each | each beginsWith: 'ODBC'].
	^(odbc isEmpty ifTrue: [drivers] ifFalse: [odbc]) last!

newConnection
	^super newConnection
		ifNotNil: 
			[:cnxn |
			cnxn
				exec: 'USE [Northwind]';
				yourself]!

requiredOdbcVersion
	^ODBCConstants.SQL_OV_ODBC3_80!

serverName
	^self isCiBuild ifTrue: ['(local)\SQL2019'] ifFalse: ['(localdb)\MSSQLLocalDB']!

uid
	^'sa'! !

!SQLServerNorthwindDB categoriesForMethods!
connectionStringFormat!constants!private! !
connectString!accessing!private! !
createDatabase!operations!private! !
dropDatabase!operations!private! !
latestSqlServerOdbcDriver!constants!private! !
newConnection!operations!public! !
requiredOdbcVersion!constants!private! !
serverName!constants!private! !
uid!constants!public! !
!

