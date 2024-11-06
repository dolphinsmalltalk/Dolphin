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
	^'DRIVER={<1d>};UID=<2d>;PWD=<3d>' << { self latestMySqlOdbcDriver. self uid. self pwd }!

createDatabase
	| binPath |
	"The MySQL80 service needs to be installed with ODBC driver, and running. Note that it must also be explicitly configured to utf8mb4 character set, or tests that attempt to insert non-BMP characters will error."
	(self latestMySqlOdbcDriver notNil and: [OS.AdvApiLibrary default isServiceRunning: 'MySQL80'])
		ifFalse: [^false].
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

latestMySqlOdbcDriver
	| drivers |
	drivers := (self installedOdbcDrivers
				select: [:each | (each beginsWith: 'MySQL') and: [each endsWith: 'Unicode Driver']])
					asSortedCollection.
	^drivers isEmpty ifFalse: [drivers last]!

newConnection
	^super newConnection
		ifNotNil: 
			[:cnxn |
			cnxn
				exec: 'USE Northwind';
				yourself]!

uid
	^'root'! !

!Database.Tests.MySqlNorthwindDB categoriesForMethods!
binPath!accessing!private! !
connectString!constants!private! !
createDatabase!operations!private! !
dropDatabase!operations!private! !
latestMySqlOdbcDriver!constants!private! !
newConnection!operations!public! !
uid!constants!private! !
!

