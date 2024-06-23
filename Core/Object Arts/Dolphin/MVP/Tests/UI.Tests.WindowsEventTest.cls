"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'UI.Tests.WindowsEventTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.Tests.WindowsEventTest guid: (Core.GUID fromString: '{08ec4909-75d4-4bef-bbb8-0f443b78f834}')!

UI.Tests.WindowsEventTest comment: ''!

!UI.Tests.WindowsEventTest methodsFor!

newEvent: anInteger
	^WindowsEvent
		window: Transcript view
		message: anInteger
		wParam: 3
		lParam: 4!

testInstanceCreation
	"Test that instance creation and initialization using primiitive 157 works correctly"

	| instance |
	instance := self newEvent: 2.
	self assert: instance window identicalTo: Transcript view.
	self assert: instance message equals: 2.
	self assert: instance wParam equals: 3.
	self assert: instance lParam equals: 4!

testPrintString
	"#1492"

	| instance |
	instance := self newEvent: 2.
	self assert: instance printString
		equals: ('a WindowsEvent(<1p> wmDestroy:wParam:lParam: 3 4)' expandMacrosWith: instance window).
	instance := self newEvent: 999.
	self assert: instance printString
		equals: ('a WindowsEvent(<1p> 16r3E7 3 4)' expandMacrosWith: instance window)! !

!UI.Tests.WindowsEventTest categoriesForMethods!
newEvent:!private!unit tests! !
testInstanceCreation!public!unit tests! !
testPrintString!public!unit tests! !
!

