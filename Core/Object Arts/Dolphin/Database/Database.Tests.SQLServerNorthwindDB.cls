"Filed out from Dolphin Smalltalk 7"!

Database.Tests.DBConnectionTestResource subclass: #'Database.Tests.SQLServerNorthwindDB'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Database.Tests.SQLServerNorthwindDB guid: (Core.GUID fromString: '{2575aff5-9fad-4133-bf64-34ff8442f774}')!
Database.Tests.SQLServerNorthwindDB comment: ''!
!Database.Tests.SQLServerNorthwindDB categoriesForClass!Unclassified! !
!Database.Tests.SQLServerNorthwindDB methodsFor!

connectString
	"Private - APPVEYOR config is 'DRIVER=SQL Server;Server=(local)\SQL2017;Database=master;User ID=sa;Password=Password12!!'"

	^'DRIVER=SQL Server;Server=<1d>;Database=master;uid=<2d>;pwd=<3d>;Language=us_english'
		expandMacrosWith: self serverName
		with: self uid
		with: self pwd!

createDatabase
	| sql cmd process |
	sql := self class owningPackage fileLocator localFileSpecFor: 'Northwind.sql'.
	cmd := 'sqlcmd -S <1d> -U <2d> -P <3d> -i "<4d>"'
				expandMacrosWith: self serverName
				with: self uid
				with: self pwd
				with: sql.
	process := Smalltalk.ExternalProcess new.
	process commandLine: cmd.
	^
	[process executeSync.
	true] on: Smalltalk.ExternalProcessExecuteError do: [:ex | false]!

dropDatabase
	self connection
		ifNotNil: 
			[:cnxn |
			cnxn
				exec: 'USE [master]';
				exec: 'DROP DATABASE [Northwind]'].
	super dropDatabase!

newConnection
	^super newConnection
		ifNotNil: 
			[:cnxn |
			cnxn
				exec: 'USE [Northwind]';
				yourself]!

pwd
	^'Password12!!'!

serverName
	^'(local)\SQL2019'!

uid
	^'sa'! !
!Database.Tests.SQLServerNorthwindDB categoriesFor: #connectString!private! !
!Database.Tests.SQLServerNorthwindDB categoriesFor: #createDatabase!private! !
!Database.Tests.SQLServerNorthwindDB categoriesFor: #dropDatabase!private! !
!Database.Tests.SQLServerNorthwindDB categoriesFor: #newConnection!public! !
!Database.Tests.SQLServerNorthwindDB categoriesFor: #pwd!private! !
!Database.Tests.SQLServerNorthwindDB categoriesFor: #serverName!private! !
!Database.Tests.SQLServerNorthwindDB categoriesFor: #uid!private! !

