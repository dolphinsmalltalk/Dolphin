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
	"Private - APPVEYOR config is 'DRIVER=SQL Server;Server=(local)\SQL2017;Database=master;User ID=sa;Password=Password12!!'"

	^'DRIVER=SQL Server;Server=<1d>;Database=master;uid=<2d>;pwd=<3d>;Language=us_english'
		expandMacrosWith: self serverName
		with: self uid
		with: self pwd!

createDatabase
	| sql cmd process stderr |
	sql := self class owningPackage fileLocator localFileSpecFor: 'Northwind.sql'.
	cmd := 'sqlcmd -b -S <1d> -U <2d> -P <3d> -i "<4d>"'
				expandMacrosWith: self serverName
				with: self uid
				with: self pwd
				with: sql.
	process := Smalltalk.ExternalProcess new.
	process commandLine: cmd.
	stderr := process stderrStream.
	^
	[process executeSync.
	process processExitCode == 0 or: 
			[Notification signal: '<1p> failed to create database<n><2s>' << { self class. stderr upToEnd }.
			false]]
			on: Smalltalk.ExternalProcessExecuteError
			do: 
				[:ex |
				Notification signal: ex description.
				false]!

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
!Database.Tests.SQLServerNorthwindDB categoriesForMethods!
connectString!private! !
createDatabase!private! !
dropDatabase!private! !
newConnection!public! !
pwd!private! !
serverName!private! !
uid!private! !
!

