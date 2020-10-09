"Filed out from Dolphin Smalltalk 7"!

PresenterTest subclass: #SmalltalkWorkspaceTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SmalltalkWorkspaceTest guid: (GUID fromString: '{6bb24dc3-1c9a-49ac-a5e2-143892b9350c}')!
SmalltalkWorkspaceTest comment: ''!
!SmalltalkWorkspaceTest categoriesForClass!Unclassified! !
!SmalltalkWorkspaceTest methodsFor!

classToTest
	^SmalltalkWorkspace!

testReformatSource
	| query |
	presenter text: '[:foo :bar | foo foo. bar bar] value: #foo value: #bar'.
	query := presenter commandPolicy query: (CommandDescription command: #reformatSource).
	self assert: query isEnabled.
	presenter reformatSource.
	self assert: presenter text equals: '
[:foo :bar |
foo foo.
bar bar] value: #foo value: #bar'!

testReformatSourcePartial
	| query |
	presenter text: '[:foo :bar | foo foo. bar bar] value: #foo value: #bar'.
	"Just the body of the block"
	presenter selectionRange: (14 to: 29).
	query := presenter commandPolicy query: (CommandDescription command: #reformatSource).
	self assert: query isEnabled.
	presenter reformatSource.
	self assert: presenter text equals: '[:foo :bar | foo foo.
bar bar] value: #foo value: #bar'! !
!SmalltalkWorkspaceTest categoriesFor: #classToTest!helpers!private! !
!SmalltalkWorkspaceTest categoriesFor: #testReformatSource!public! !
!SmalltalkWorkspaceTest categoriesFor: #testReformatSourcePartial!public! !

