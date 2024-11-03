"Filed out from Dolphin Smalltalk"!

TestResource subclass: #DBConnectionTestResource
	instanceVariableNames: 'connection isAvailable'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

DBConnectionTestResource guid: (GUID fromString: '{2661c6fe-6796-4f00-a5c4-6ac7f74bb107}')!

DBConnectionTestResource comment: ''!

!DBConnectionTestResource categoriesForClass!Unclassified! !

!DBConnectionTestResource methodsFor!

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
	process := ExternalProcess new.
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
			on: ExternalProcessExecuteError
			do: 
				[:ex |
				ex toTrace.
				false]!

installedOdbcDrivers
	^((RegKey localMachineRoot: #read) at: 'SOFTWARE\ODBC\ODBCINST.INI') keys!

isAvailable
	^isAvailable!

newConnection
	^isAvailable ifTrue: [
		"DBConnection requiredOdbcVersion: self requiredOdbcVersion."
		self basicConnection]!

pwd
	^'Password12!!'!

requiredOdbcVersion
	^ODBCConstants.SQL_OV_ODBC3!

setUp
	isAvailable := self createDatabase!

tearDown
	self dropDatabase! !

!DBConnectionTestResource categoriesForMethods!
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
installedOdbcDrivers!enquiries!private! !
isAvailable!public!Testing! !
newConnection!helpers!public! !
pwd!constants!private! !
requiredOdbcVersion!constants!private! !
setUp!public!running! !
tearDown!public!running! !
!

!DBConnectionTestResource class methodsFor!

isAvailable
	^true! !

!DBConnectionTestResource class categoriesForMethods!
isAvailable!public!Testing! !
!

