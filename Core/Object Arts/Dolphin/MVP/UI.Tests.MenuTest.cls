"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest subclass: #'UI.Tests.MenuTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Tests.MenuTest guid: (Core.GUID fromString: '{7e39f8d9-1ee0-471d-8e3f-76c307707b10}')!
UI.Tests.MenuTest comment: ''!
!UI.Tests.MenuTest methodsFor!

testFindCommand
	| subject item |
	subject := Menu fromStrings: #('&File' 'Open//fileOpen' '-' '&Save/Ctrl+S/fileSave').
	item := subject findCommand: #fileOpen.
	self assertNotNil: item.
	self assert: item command identicalTo: #fileOpen.
	item := subject findCommand: #fileExit.
	self assertIsNil: item.
	subject addCommand: (Message selector: #quit argument: SessionManager current) description: '&Exit'.
	item := subject findCommand: (Message selector: #quit argument: SessionManager current).
	self assertNotNil: item.
	self assert: item command isKindOf: Message.
	self assert: item command selector equals: #quit! !
!UI.Tests.MenuTest categoriesForMethods!
testFindCommand!public!unit tests! !
!

