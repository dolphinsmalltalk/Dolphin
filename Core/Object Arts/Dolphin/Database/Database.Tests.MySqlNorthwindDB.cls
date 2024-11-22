"Filed out from Dolphin Smalltalk"!

Database.Tests.DBConnectionTestResource
	subclass: #'Database.Tests.MySqlNorthwindDB'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Database.Tests.MySqlNorthwindDB guid: (Core.GUID fromString: '{9bfea414-9714-441c-9398-5e8683836e56}')!

Database.Tests.MySqlNorthwindDB comment: ''!

!Database.Tests.MySqlNorthwindDB methodsFor!

binPath
	^(($; split: (SessionManager current getenv: 'PATH'))
		detect: [:each | (each indexOfSubCollection: 'MySQL') ~~ 0]
		ifNone: [])
			ifNotNil: 
				[:mySqlPath |
				"e.g. 'C:\Program Files\MySQL\MySQL Shell 8.0\bin\'"
				mySqlPath copyReplaceAll: 'MySQL Shell' with: 'MySQL Server']!

connectString
	"Notes on options:
		- PAD_SPACE: MySql does not implement CHAR columns correctly. These should be of fixed width, and padded with spaces out to that width. MySql implements them as variable length strings treating the defined length as a maximum (i.e. no differently to varchar). The developers have been claiming since 2006 that this is not a bug because it is documented behaviour, a rather specious argument: https://bugs.mysql.com/bug.php?id=24424. However they have at least included an option that can be passed in the ODBC connection string to request standard SQL behaviour of padding CHAR columns 
		- COLUMN_SIZE_S32: Ensures that long columns return a consisten length. We have to set this explicitly in order to get stable results for the length of long var columns, otherwise we sometimes get a large positive integer value, and sometimes we get -1. I worked out in the end that this depended on whether the ADO tests had been run beforehand, because the driver contains some ~~cretinous~~helpful code that implicitly sets this option if the msado15.dll is found to be loaded in the process when creating a connection. Fortunately the code is open source in github, and I stumbled across this when attempting to understand the padding behaviour."

	^'DRIVER={<1d>};UID=<2d>;PWD=<3d>;PAD_SPACE=1;COLUMN_SIZE_S32=1' << { self odbcDriver. self uid. self pwd }!

createDatabase
	| binPath |
	"N.B. Obviously storing a password in a method and passing it on a command line is insecure, but this is a test database"
	binPath := self binPath.
	binPath ifNil: [^false].
	^self execSqlCmd: '"<1s>" -u <2s> -p<3s>'
				<< { File composePath: binPath subPath: 'mysql.exe'. self uid. self pwd }
		stdin: (FileStream read: ((Kernel.PackageRelativeFileLocator package: self class owningPackage)
						localFileSpecFor: 'NorthwindMySql.sql')
				text: true)!

dropDatabase
	self connection
		ifNotNil: 
			[:cnxn |
			cnxn
				exec: 'USE world';
				exec: 'DROP DATABASE Northwind'].
	super dropDatabase!

newConnection
	^super newConnection
		ifNotNil: 
			[:cnxn |
			cnxn
				exec: 'USE Northwind';
				yourself]!

odbcDriver
	| drivers |
	drivers := (self installedOdbcDrivers
				select: [:each | (each beginsWith: 'MySQL') and: [each endsWith: 'Unicode Driver']])
					asSortedCollection.
	^drivers isEmpty ifFalse: [drivers last]!

prereqsAvailable
	"The MySQL80 service needs to be installed with ODBC driver, and running. Note that it must also be explicitly configured to utf8mb4 character set, or tests that attempt to insert non-BMP characters will error."

	^super prereqsAvailable and: [OS.AdvApiLibrary default isServiceRunning: 'MySQL80']!

uid
	^'root'! !

!Database.Tests.MySqlNorthwindDB categoriesForMethods!
binPath!accessing!private! !
connectString!constants!private! !
createDatabase!operations!private! !
dropDatabase!operations!private! !
newConnection!operations!public! !
odbcDriver!constants!private! !
prereqsAvailable!operations!private! !
uid!constants!private! !
!

