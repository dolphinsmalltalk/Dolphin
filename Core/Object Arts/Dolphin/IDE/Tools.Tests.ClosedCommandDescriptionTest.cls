"Filed out from Dolphin Smalltalk 7"!

XProgramming.SUnit.TestCase subclass: #'Tools.Tests.ClosedCommandDescriptionTest'
	instanceVariableNames: 'dialog'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.Tests.ClosedCommandDescriptionTest guid: (Core.GUID fromString: '{c860325b-fae5-47a0-a5d0-711d8ac4c509}')!
Tools.Tests.ClosedCommandDescriptionTest comment: ''!
!Tools.Tests.ClosedCommandDescriptionTest categoriesForClass!Unclassified! !
!Tools.Tests.ClosedCommandDescriptionTest methodsFor!

setUp
	dialog := Tools.Tests.ClosedCommandDescriptionIssueDialog showOn: 'blah'!

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
!Tools.Tests.ClosedCommandDescriptionTest categoriesFor: #setUp!public!unit tests! !
!Tools.Tests.ClosedCommandDescriptionTest categoriesFor: #tearDown!public!unit tests! !
!Tools.Tests.ClosedCommandDescriptionTest categoriesFor: #testArgument!public!unit tests! !
!Tools.Tests.ClosedCommandDescriptionTest categoriesFor: #testReceiver!public!unit tests! !

