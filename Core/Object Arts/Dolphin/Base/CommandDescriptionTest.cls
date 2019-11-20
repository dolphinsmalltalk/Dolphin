"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #CommandDescriptionTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CommandDescriptionTest guid: (GUID fromString: '{f36e555c-9741-49d2-89aa-fa4db14bc62f}')!
CommandDescriptionTest comment: ''!
!CommandDescriptionTest categoriesForClass!SUnit! !
!CommandDescriptionTest methodsFor!

testRegistry
	self assert: CommandDescription.CommandDescriptionRegistry hasWeakKeys.
	self deny: CommandDescription.CommandDescriptionRegistry hasWeakValues! !
!CommandDescriptionTest categoriesFor: #testRegistry!public! !

