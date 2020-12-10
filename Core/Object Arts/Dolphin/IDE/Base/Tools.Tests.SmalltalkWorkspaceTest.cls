"Filed out from Dolphin Smalltalk 7"!

UI.Tests.PresenterTest subclass: #'Tools.Tests.SmalltalkWorkspaceTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.Tests.SmalltalkWorkspaceTest guid: (Core.GUID fromString: '{6bb24dc3-1c9a-49ac-a5e2-143892b9350c}')!
Tools.Tests.SmalltalkWorkspaceTest comment: ''!
!Tools.Tests.SmalltalkWorkspaceTest categoriesForClass!Unclassified! !
!Tools.Tests.SmalltalkWorkspaceTest methodsFor!

classToTest
	^SmalltalkWorkspace!

doReformatSource
	| query |
	query := presenter commandPolicy query: (CommandDescription command: #reformatSource).
	self assert: query isEnabled.
	presenter reformatSource!

testReformatSource
	presenter text: '[:foo :bar | foo foo. bar bar] value: #foo value: #bar'.
	self doReformatSource.
	self assert: presenter text equals: '
[:foo :bar |
foo foo.
bar bar] value: #foo value: #bar'.
	"No selection, cursor positioned at end"
	self assert: presenter selectionRange equals: (59 to: 58)!

testReformatSourcePartial
	presenter text: '[:foo :bar | foo foo. bar bar] value: #foo value: #bar'.
	"Just the body of the block"
	presenter selectionRange: (14 to: 29).
	self doReformatSource.
	self assert: presenter text equals: '[:foo :bar | foo foo.
bar bar] value: #foo value: #bar'.
	"No selection, cursor positioned after reformatted text"
	self assert: presenter selectionRange equals: (31 to: 30)! !
!Tools.Tests.SmalltalkWorkspaceTest categoriesFor: #classToTest!helpers!private! !
!Tools.Tests.SmalltalkWorkspaceTest categoriesFor: #doReformatSource!helpers!private! !
!Tools.Tests.SmalltalkWorkspaceTest categoriesFor: #testReformatSource!public!unit tests! !
!Tools.Tests.SmalltalkWorkspaceTest categoriesFor: #testReformatSourcePartial!public!unit tests! !

