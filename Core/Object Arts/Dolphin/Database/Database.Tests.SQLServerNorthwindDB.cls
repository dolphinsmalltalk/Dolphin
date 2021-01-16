"Filed out from Dolphin Smalltalk 7"!

DBConnectionTestResource subclass: #SQLServerNorthwindDB
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
SQLServerNorthwindDB guid: (Core.GUID fromString: '{2575aff5-9fad-4133-bf64-34ff8442f774}')!
SQLServerNorthwindDB comment: ''!
!SQLServerNorthwindDB categoriesForClass!Unclassified! !
!SQLServerNorthwindDB methodsFor!

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
	process := ExternalProcess new.
	process commandLine: cmd.
	^
	[process executeSync.
	true] on: ExternalProcessExecuteError do: [:ex | false]!

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
!SQLServerNorthwindDB categoriesFor: #connectString!private! !
!SQLServerNorthwindDB categoriesFor: #createDatabase!private! !
!SQLServerNorthwindDB categoriesFor: #dropDatabase!private! !
!SQLServerNorthwindDB categoriesFor: #newConnection!public! !
!SQLServerNorthwindDB categoriesFor: #pwd!private! !
!SQLServerNorthwindDB categoriesFor: #serverName!private! !
!SQLServerNorthwindDB categoriesFor: #uid!private! !

