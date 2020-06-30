"Filed out from Dolphin Smalltalk 7"!

TestCase subclass: #ClosedCommandDescriptionTest
	instanceVariableNames: 'dialog'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ClosedCommandDescriptionTest guid: (GUID fromString: '{c860325b-fae5-47a0-a5d0-711d8ac4c509}')!
ClosedCommandDescriptionTest comment: ''!
!ClosedCommandDescriptionTest categoriesForClass!Unclassified! !
!ClosedCommandDescriptionTest methodsFor!

setUp

	dialog := ClosedCommandDescriptionIssueDialog showOn: 'blah'.
	!

tearDown

	dialog  destroy.!

testArgument
	"self halt."

	self assert: dialog view combinedAcceleratorTable commands anyOne command arguments first
		identicalTo: dialog!

testReceiver
	"self halt."

	self assert: dialog view combinedAcceleratorTable commands anyOne receiver
		identicalTo: dialog model subject! !
!ClosedCommandDescriptionTest categoriesFor: #setUp!public!unit tests! !
!ClosedCommandDescriptionTest categoriesFor: #tearDown!public!unit tests! !
!ClosedCommandDescriptionTest categoriesFor: #testArgument!public!unit tests! !
!ClosedCommandDescriptionTest categoriesFor: #testReceiver!public!unit tests! !

