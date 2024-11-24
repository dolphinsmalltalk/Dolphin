"Filed out from Dolphin Smalltalk"!

DBConnectionTestResource subclass: #MySqlNorthwindDB
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MySqlNorthwindDB guid: (GUID fromString: '{9bfea414-9714-441c-9398-5e8683836e56}')!

MySqlNorthwindDB comment: ''!

!MySqlNorthwindDB categoriesForClass!Unclassified! !

!MySqlNorthwindDB methodsFor!

connectString
	"Notes on options:
		- PAD_SPACE: MySql does not implement CHAR columns correctly. These should be of fixed width, and padded with spaces out to that width. MySql implements them as variable length strings treating the defined length as a maximum (i.e. no differently to varchar). The developers have been claiming since 2006 that this is not a bug because it is documented behaviour, a rather specious argument: https://bugs.mysql.com/bug.php?id=24424. However they have at least included an option that can be passed in the ODBC connection string to request standard SQL behaviour of padding CHAR columns 
		- COLUMN_SIZE_S32: Ensures that long columns return a consisten length. We have to set this explicitly in order to get stable results for the length of long var columns, otherwise we sometimes get a large positive integer value, and sometimes we get -1. I worked out in the end that this depended on whether the ADO tests had been run beforehand, because the driver contains some ~~cretinous~~helpful code that implicitly sets this option if the msado15.dll is found to be loaded in the process when creating a connection. Fortunately the code is open source in github, and I stumbled across this when attempting to understand the padding behaviour."

	^'DRIVER={<1d>};<4s>;UID=<2d>;PWD=<3d>' << { self odbcDriver. self uid. self pwd. self options }!

createDatabase
	| installFolder |
	"N.B. Obviously storing a password in a method and passing it on a command line is insecure, but this is a test database"
	installFolder := self installationFolder.
	installFolder ifNil: [^false].
	^self execSqlCmd: '"<1s>" -u <2s> -p<3s>'
				<< { File composePath: installFolder subPath: 'bin\mysql.exe'. self uid. self pwd }
		stdin: (FileStream read: ((PackageRelativeFileLocator package: self class owningPackage)
						localFileSpecFor: 'NorthwindMySql.sql')
				text: true)!

dropDatabase
	self connection ifNotNil: [:cnxn | cnxn exec: 'DROP DATABASE Northwind'].
	super dropDatabase!

getOdbcDriver
	| available |
	available := DBConnection installedOdbcDrivers.
	"Use the MariaDB ODBC driver if installed. It still has a lot of quirks, but at least it doesn't change the global CRT state when loaded, or alter its behaviour depending on whether msado15.dll is loaded. It is also still supporting 32-bit in its most recent versions."
	^available detect: [:each | each beginsWith: 'MariaDB ODBC']
		ifNone: ['MySQL ODBC 8.0 Unicode Driver']!

installationFolder
	^((RegKey localMachineRoot64 lookup: 'SOFTWARE\MySQL AB\MySQL Server 8.0')
		ifNotNil: [:regkey | regkey valueAt: 'Location' ifAbsent: nil])
			ifNil: 
				[File composePath: (SessionManager current getenv: 'ProgramW6432') subPath: 'MySQL\MySQL Server 8.0\']!

newConnection
	^super newConnection
		ifNotNil: 
			[:cnxn |
			cnxn
				exec: 'USE northwind';
				yourself]!

options
	"Notes on options:
		- PAD_SPACE: MySql does not implement CHAR columns correctly. These should be of fixed width, and padded with spaces out to that width. MySql implements them as variable length strings treating the defined length as a maximum (i.e. no differently to varchar). The developers have been claiming since 2006 that this is not a bug because it is documented behaviour, a rather specious argument: https://bugs.mysql.com/bug.php?id=24424. However they have at least included an option that can be passed in the ODBC connection string to request standard SQL behaviour of padding CHAR columns 
		- COLUMN_SIZE_S32: Ensures that long columns return a consisten length. We have to set this explicitly in order to get stable results for the length of long var columns, otherwise we sometimes get a large positive integer value, and sometimes we get -1. I worked out in the end that this depended on whether the ADO tests had been run beforehand, because the driver contains some ~~cretinous~~helpful code that implicitly sets this option if the msado15.dll is found to be loaded in the process when creating a connection. Fortunately the code is open source in github, and I stumbled across this when attempting to understand the padding behaviour."

	^self useMariaDbOdbcDriver
		ifTrue: ['CHARSET=utf8mb4;OPTION=<d>' << (512 | 134217728)	"(MADB_OPT_FLAG_PAD_SPACE | MADB_OPT_FLAG_COLUMN_SIZE_S32)"]
		ifFalse: ['PAD_SPACE=1;COLUMN_SIZE_S32=1']!

prereqsAvailable
	"The MySQL80 service needs to be installed with ODBC driver, and running. Note that it must also be explicitly configured to utf8mb4 character set, or tests that attempt to insert non-BMP characters will error."

	^super prereqsAvailable and: [AdvApiLibrary default isServiceRunning: 'MySQL80']!

uid
	^'root'!

useMariaDbOdbcDriver
	^self odbcDriver beginsWith: 'MariaDB'! !

!MySqlNorthwindDB categoriesForMethods!
connectString!constants!private! !
createDatabase!operations!private! !
dropDatabase!operations!private! !
getOdbcDriver!constants!private! !
installationFolder!constants!private! !
newConnection!operations!public! !
options!constants!private! !
prereqsAvailable!operations!private! !
uid!constants!private! !
useMariaDbOdbcDriver!public!testing! !
!

