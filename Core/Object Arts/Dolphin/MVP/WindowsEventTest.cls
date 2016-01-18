"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #WindowsEventTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WindowsEventTest guid: (GUID fromString: '{08EC4909-75D4-4BEF-BBB8-0F443B78F834}')!
WindowsEventTest comment: ''!
!WindowsEventTest categoriesForClass!Unclassified! !
!WindowsEventTest methodsFor!

newEvent: anInteger 
	^self isD6OrLater 
		ifTrue: 
			[WindowsEvent 
				handle: 1
				message: anInteger
				wParam: 3
				lParam: 4]
		ifFalse: 
			[WindowsEvent 
				message: anInteger
				handle: 1
				wParam: 3
				lParam: 4]!

testInstanceCreation
	"Test that instance creation and initialization using primiitive 157 works correctly"

	| instance |
	instance := self newEvent: 2.
	self assert: instance hwnd = 1.
	self assert: instance message = 2.
	self assert: instance wParam = 3.
	self assert: instance lParam = 4!

testPrintString
	"#1492"

	| instance |
	instance := self newEvent: 2.
	self assert: instance printString = 'a WindowsEvent(1 wmDestroy:wParam:lParam: 3 4)'.
	instance := self newEvent: 999.
	self assert: instance printString = 'a WindowsEvent(1 16r3E7 3 4)'! !
!WindowsEventTest categoriesFor: #newEvent:!private!unit tests! !
!WindowsEventTest categoriesFor: #testInstanceCreation!public!unit tests! !
!WindowsEventTest categoriesFor: #testPrintString!public!unit tests! !

