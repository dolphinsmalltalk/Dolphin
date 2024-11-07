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

binPath
	^(($; split: (SessionManager current getenv: 'PATH'))
		detect: [:each | (each indexOfSubCollection: 'MySQL') ~~ 0]
		ifNone: [])
			ifNotNil: 
				[:mySqlPath |
				"e.g. 'C:\Program Files\MySQL\MySQL Shell 8.0\bin\'"
				mySqlPath copyReplaceAll: 'MySQL Shell' with: 'MySQL Server']!

connectString
	^'DRIVER={<1d>};UID=<2d>;PWD=<3d>' << { self odbcDriver. self uid. self pwd }!

createDatabase
	| binPath |
	"N.B. Obviously storing a password in a method and passing it on a command line is insecure, but this is a test database"
	binPath := self binPath.
	binPath ifNil: [^false].
	^self execSqlCmd: '"<1s>" -u <2s> -p<3s>'
				<< { File composePath: binPath subPath: 'mysql.exe'. self uid. self pwd }
		stdin: (FileStream read: ((PackageRelativeFileLocator package: self class owningPackage)
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

	^super prereqsAvailable and: [AdvApiLibrary default isServiceRunning: 'MySQL80']!

uid
	^'root'! !

!MySqlNorthwindDB categoriesForMethods!
binPath!accessing!private! !
connectString!constants!private! !
createDatabase!operations!private! !
dropDatabase!operations!private! !
newConnection!operations!public! !
odbcDriver!constants!private! !
prereqsAvailable!operations!private! !
uid!constants!private! !
!

