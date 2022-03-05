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

connect
	connection := self newConnection!

connection
	^connection!

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
!DBConnectionTestResource categoriesForMethods!
connect!private! !
connection!private! !
connectString!private! !
createDatabase!private! !
dropDatabase!private! !
newConnection!public! !
setUp!public! !
tearDown!public! !
!

