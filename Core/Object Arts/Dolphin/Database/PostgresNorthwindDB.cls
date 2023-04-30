﻿"Filed out from Dolphin Smalltalk"!

DBConnectionTestResource subclass: #PostgresNorthwindDB
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

PostgresNorthwindDB guid: (GUID fromString: '{892e25a6-1bd6-41b4-82df-fdb1bfc704be}')!

PostgresNorthwindDB comment: ''!

!PostgresNorthwindDB categoriesForClass!Unclassified! !

!PostgresNorthwindDB methodsFor!

connectString
	"DSN=PostgreSQL35W;DATABASE=;SERVER=;PORT=;UID=postgres;PWD=;SSLmode=disable;ReadOnly=0;Protocol=7.4;FakeOidIndex=0;ShowOidColumn=0;RowVersioning=0;ShowSystemTables=0;Fetch=100;UnknownSizes=0;MaxVarcharSize=255;MaxLongVarcharSize=8190;Debug=0;CommLog=0;UseDeclareFetch=0;TextAsLongVarchar=1;UnknownsAsLongVarchar=0;BoolsAsChar=0;Parse=0;ExtraSysTablePrefixes=;LFConversion=1;UpdatableCursors=1;TrueIsMinus1=0;BI=0;ByteaAsLongVarBinary=1;UseServerSidePrepare=1;LowerCaseIdentifier=0;D6=-101;OptionalErrors=0;FetchRefcursors=0;XaOpt=1"

	^'DRIVER={<1d>};Database=Northwind;Uid=<2d>;Pwd=<3d>;BoolsAsChar=0;UnknownSizes=0' << { self odbcDriver. self uid. self pwd }

!

createDatabase
	SessionManager current setenv: 'PGPASSWORD' value: self pwd.
	^
	[self
		execSqlCmd: '"<1s>\bin\psql" -U <2s> -f "<4s>"' << {
						self installationFolder.
						self uid.
						self pwd.
						(PackageRelativeFileLocator package: self class owningPackage)
							localFileSpecFor: 'NorthwindPostgres.sql'
					}
		stdin: nil]
			ensure: [SessionManager current setenv: 'PGPASSWORD' value: nil]!

dropDatabase
	| cmdString process dropdb |
	super dropDatabase.
	dropdb := File composePath: self installationFolder subPath: 'bin\dropdb.exe'.
	(File exists: dropdb)
		ifFalse: 
			[Notification signal: dropdb , ' not found'.
			^self].
	cmdString := '"<1s>" -U <2s> -f "Northwind"' << { dropdb. self uid }.
	process := ExternalProcess new.
	SessionManager current setenv: 'PGPASSWORD' value: self pwd.
	
	[
	[process
		executeCommand: cmdString
		inDirectory: nil
		waitForSeconds: 3
		stdin: nil
		stdout: [:out | ]
		stderr: 
			[:err |
			err isEmpty
				ifFalse: 
					[SessionManager current traceStream
						nextPutAll: err;
						cr]]]
			on: ExternalProcessExecuteError
			do: 
				[:ex |
				ex toTrace.
				false].
	process processExitCode = 0 ifFalse: [Notification signal: 'Failed to drop Postgres Northwind DB']]
			ensure: [SessionManager current setenv: 'PGPASSWORD' value: nil]!

getOdbcDriver
	| drivers installed |
	installed := DBConnection installedOdbcDrivers.
	drivers := (installed select: [:each | 'PostgreSQL*Unicode*' match: each]) asSortedCollection .
	^drivers isEmpty ifFalse: [drivers last]!

installationFolder
	^(RegKey localMachineRoot64 lookup: 'SOFTWARE\PostgreSQL Global Development Group\PostgreSQL')
		ifNotNil: [:regkey | regkey valueAt: 'Location' ifAbsent: nil]!

prereqsAvailable
	^self getOdbcDriver notNil and: [self installationFolder notNil]!

uid
	^'postgres'! !

!PostgresNorthwindDB categoriesForMethods!
connectString!constants!private! !
createDatabase!operations!private! !
dropDatabase!operations!private! !
getOdbcDriver!constants!private! !
installationFolder!constants!private! !
prereqsAvailable!operations!private! !
uid!constants!private! !
!
