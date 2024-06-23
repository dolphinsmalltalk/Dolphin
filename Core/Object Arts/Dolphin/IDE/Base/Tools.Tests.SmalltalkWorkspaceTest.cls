"Filed out from Dolphin Smalltalk"!

UI.Tests.PresenterTest
	subclass: #'Tools.Tests.SmalltalkWorkspaceTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Tools.Tests.SmalltalkWorkspaceTest guid: (Core.GUID fromString: '{6bb24dc3-1c9a-49ac-a5e2-143892b9350c}')!

Tools.Tests.SmalltalkWorkspaceTest comment: ''!

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
	self assert: presenter selectionRange equals: (31 to: 30)!

testSelectedWord
	presenter text: '123 printString, ''abc'''.
	"When there is a selection, that is considered the selected word"
	{ 1 to: 3. 1 to: 1. 2 to: 2. 3 to: 3 } do: 
			[:each |
			presenter selectionRange: each.
			self assert: presenter selectedWord equals: (presenter plainTextRange: each)].
	"When there is no selection, the token under the caret is considered the selected word"
	presenter view restyleAll.
	{ 1 to: 3. 1 to: 0. 2 to: 1. 3 to: 2 } do: 
			[:each |
			presenter selectionRange: each.
			self assert: presenter selectedWord equals: '123'].
	presenter selectionRange: (4 to: 3).
	self assert: presenter selectedWord equals: ' '.
	presenter selectionRange: (5 to: 4).
	self assert: presenter selectedWord equals: 'printString'.
	presenter selectionRange: (16 to: 15).
	self assert: presenter selectedWord equals: ','.
	presenter selectionRange: (18 to: 17).
	self assert: presenter selectedWord equals: '''abc'''.
	presenter selectionRange: (22 to: 21).
	self assert: presenter selectedWord equals: '''abc'''.
	presenter selectionRange: (23 to: 22).
	self assert: presenter selectedWord equals: ''.
	"Now when empty"
	presenter text: ''.
	presenter view restyleAll.
	self assert: presenter selectionRange equals: (1 to: 0).
	self assert: presenter selectedWord equals: ''.
	!

verifyUpgradedView: anInteger identifier: aResourceIdentifier
	| view expectedViewClass |
	view := self view.
	expectedViewClass := ##(IdentityDictionary withAll: {
						#resource_Multiline_text -> MultilineTextEdit.
						#resource_Rich_text -> RichTextEdit.
						#resource_Default_view -> RichTextEdit.
						#resource_Method_source -> RichTextEdit.
					})
				at: aResourceIdentifier selector.
	self assert: view isKindOf: expectedViewClass.
	self assert: view isOpen! !

!Tools.Tests.SmalltalkWorkspaceTest categoriesForMethods!
classToTest!helpers!private! !
doReformatSource!helpers!private! !
testReformatSource!public!unit tests! !
testReformatSourcePartial!public!unit tests! !
testSelectedWord!public!unit tests! !
verifyUpgradedView:identifier:!helpers!private! !
!

