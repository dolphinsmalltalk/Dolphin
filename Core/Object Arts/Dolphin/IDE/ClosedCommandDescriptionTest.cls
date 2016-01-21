"Filed out from Dolphin Smalltalk 7"!

TestCase subclass: #ClosedCommandDescriptionTest
	instanceVariableNames: 'dialog'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ClosedCommandDescriptionTest guid: (GUID fromString: '{C860325B-FAE5-47A0-A5D0-711D8AC4C509}')!
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
	self assert: dialog view combinedAcceleratorTable commands anyOne command arguments first == dialog !

testReceiver
	"self halt."

	self assert: dialog view combinedAcceleratorTable commands anyOne receiver == dialog model subject! !
!ClosedCommandDescriptionTest categoriesFor: #setUp!public!unit tests! !
!ClosedCommandDescriptionTest categoriesFor: #tearDown!public!unit tests! !
!ClosedCommandDescriptionTest categoriesFor: #testArgument!public!unit tests! !
!ClosedCommandDescriptionTest categoriesFor: #testReceiver!public!unit tests! !

