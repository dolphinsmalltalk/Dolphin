"Filed out from Dolphin Smalltalk"!

XProgramming.SUnit.TestResource
	subclass: #'Database.Tests.DBConnectionTestResource'
	instanceVariableNames: 'connection isAvailable'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Database.Tests.DBConnectionTestResource guid: (Core.GUID fromString: '{2661c6fe-6796-4f00-a5c4-6ac7f74bb107}')!
Database.Tests.DBConnectionTestResource comment: ''!
!Database.Tests.DBConnectionTestResource methodsFor!

canConnect
	| cnxn |
	cnxn := self createConnection.
	^[cnxn notNil] ensure: [cnxn close]!

connect
	connection := self newConnection!

connection
	^connection!

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

newConnection
	^isAvailable
		ifTrue: 
			[(DBConnection new connectString: self connectString)
				open;
				yourself]!

setUp
	(isAvailable := self createDatabase) ifTrue: [self connect]!

tearDown
	self dropDatabase! !
!Database.Tests.DBConnectionTestResource categoriesForMethods!
canConnect!private! !
connect!private! !
connection!private! !
connectString!private! !
createConnection!public! !
createDatabase!private! !
dropDatabase!private! !
newConnection!public! !
setUp!public! !
tearDown!public! !
!

