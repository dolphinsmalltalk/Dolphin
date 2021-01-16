"Filed out from Dolphin Smalltalk 7"!

XProgramming.SUnit.TestResource subclass: #DBConnectionTestResource
	instanceVariableNames: 'connection isAvailable'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
DBConnectionTestResource guid: (Core.GUID fromString: '{2661c6fe-6796-4f00-a5c4-6ac7f74bb107}')!
DBConnectionTestResource comment: ''!
!DBConnectionTestResource categoriesForClass!Unclassified! !
!DBConnectionTestResource methodsFor!

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
!DBConnectionTestResource categoriesFor: #canConnect!private! !
!DBConnectionTestResource categoriesFor: #connect!private! !
!DBConnectionTestResource categoriesFor: #connection!private! !
!DBConnectionTestResource categoriesFor: #connectString!private! !
!DBConnectionTestResource categoriesFor: #createConnection!public! !
!DBConnectionTestResource categoriesFor: #createDatabase!private! !
!DBConnectionTestResource categoriesFor: #dropDatabase!private! !
!DBConnectionTestResource categoriesFor: #newConnection!public! !
!DBConnectionTestResource categoriesFor: #setUp!public! !
!DBConnectionTestResource categoriesFor: #tearDown!public! !

