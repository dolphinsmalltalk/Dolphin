"Filed out from Dolphin Smalltalk"!

XProgramming.SUnit.TestResource
	subclass: #'Database.Tests.DBConnectionTestResource'
	instanceVariableNames: 'connection isAvailable odbcDriver'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Database.Tests.DBConnectionTestResource guid: (Core.GUID fromString: '{2661c6fe-6796-4f00-a5c4-6ac7f74bb107}')!

Database.Tests.DBConnectionTestResource isNonInstantiable: true!

Database.Tests.DBConnectionTestResource comment: ''!

!Database.Tests.DBConnectionTestResource methodsFor!

basicConnection
	^(DBConnection new connectString: self connectString)
		useDriverCompletion: false;
		open;
		yourself!

canConnect
	| cnxn |
	cnxn := self createConnection.
	^[cnxn notNil] ensure: [cnxn close]!

connect
	connection := self newConnection!

connection
	^connection ifNil: [connection := self newConnection]!

connectionStringAttributes
	| keyValuePairs |
	keyValuePairs := Dictionary
				withAll: (($; split: self connectString) collect: 
							[:each |
							| keyValuePair |
							keyValuePair := $= split: each.
							keyValuePair first asUppercase -> keyValuePair second]).
	^keyValuePairs!

connectString
	self subclassResponsibility!

createConnection
	^(DBConnection new connectString: self connectString)
		open;
		yourself!

createDatabase
	"Private - Override in subclasses"

	^self subclassResponsibility!

dropDatabase
	connection
		ifNotNil: 
			[connection close.
			connection := nil]!

execSqlCmd: cmdString stdin: stdinStream
	| process |
	process := Smalltalk.ExternalProcess new.
	^
	[process
		executeCommand: cmdString
		inDirectory: nil
		waitForSeconds: 30
		stdin: stdinStream
		stdout: 
			[:out |
			(FileStream write: self name , '.stdout.log' text: true)
				nextPutAll: out;
				close]
		stderr: 
			[:err |
			(FileStream write: self name , '.stderr.log' text: true)
				nextPutAll: err;
				close].
	process processExitCode = 0]
			on: Smalltalk.ExternalProcessExecuteError
			do: 
				[:ex |
				ex toTrace.
				false]!

getOdbcDriver
	^self subclassResponsibility!

installedOdbcDrivers
	^((OS.RegKey localMachineRoot: #read) at: 'SOFTWARE\ODBC\ODBCINST.INI') keys!

isAvailable
	^isAvailable!

newConnection
	^isAvailable ifTrue: [
		"DBConnection requiredOdbcVersion: self requiredOdbcVersion."
		self basicConnection]!

odbcDriver
	^odbcDriver ifNil: [odbcDriver := self getOdbcDriver]!

prereqsAvailable
	^self installedOdbcDrivers includes: self odbcDriver!

pwd
	^'Password12!!'!

requiredOdbcVersion
	^OS.ODBCConstants.SQL_OV_ODBC3!

setUp
	isAvailable := self prereqsAvailable and: [self createDatabase]!

tearDown
	[self dropDatabase] on: DBWarning do: [:ex | 
		"Suppress any log noise"
		ex resume].
	super tearDown! !

!Database.Tests.DBConnectionTestResource categoriesForMethods!
basicConnection!helpers!private! !
canConnect!public!testing! !
connect!helpers!private! !
connection!accessing!private! !
connectionStringAttributes!constants!private! !
connectString!accessing!private! !
createConnection!operations!public! !
createDatabase!operations!private! !
dropDatabase!helpers!private! !
execSqlCmd:stdin:!helpers!private! !
getOdbcDriver!constants!private! !
installedOdbcDrivers!enquiries!private! !
isAvailable!public!Testing! !
newConnection!helpers!public! !
odbcDriver!constants!private! !
prereqsAvailable!operations!private! !
pwd!constants!private! !
requiredOdbcVersion!constants!private! !
setUp!public!running! !
tearDown!public!running! !
!

!Database.Tests.DBConnectionTestResource class methodsFor!

isAvailable
	"We want the DB to be initialized up front when the test suite is being initialized so that the cost is measured there, rather than during the execution of the first test case, but we don't want unavailability of the DB to fail the run, rather we just skip those tests later."

	^super isAvailable or: [true]! !

!Database.Tests.DBConnectionTestResource class categoriesForMethods!
isAvailable!public!Testing! !
!

