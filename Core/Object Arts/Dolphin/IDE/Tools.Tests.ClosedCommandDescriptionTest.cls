"Filed out from Dolphin Smalltalk"!

XProgramming.SUnit.TestCase
	subclass: #'Tools.Tests.ClosedCommandDescriptionTest'
	instanceVariableNames: 'dialog'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.Tests.ClosedCommandDescriptionTest guid: (Core.GUID fromString: '{c860325b-fae5-47a0-a5d0-711d8ac4c509}')!
Tools.Tests.ClosedCommandDescriptionTest comment: ''!
!Tools.Tests.ClosedCommandDescriptionTest methodsFor!

setUp
	super setUp.
	dialog := ClosedCommandDescriptionIssueDialog showOn: 'blah'!

tearDown
	dialog destroy.
	super tearDown!

testArgument
	"self halt."

	self assert: dialog view combinedAcceleratorTable commands anyOne command arguments first
		identicalTo: dialog!

testReceiver
	"self halt."

	self assert: dialog view combinedAcceleratorTable commands anyOne receiver
		identicalTo: dialog model subject! !
!Tools.Tests.ClosedCommandDescriptionTest categoriesForMethods!
setUp!public!unit tests! !
tearDown!public!unit tests! !
testArgument!public!unit tests! !
testReceiver!public!unit tests! !
!

