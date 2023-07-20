"Filed out from Dolphin Smalltalk"!

UI.Tests.PresenterTest
	subclass: #'UI.Tests.InplaceTextEditorTest'
	instanceVariableNames: 'clipboard savedText'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Tests.InplaceTextEditorTest guid: (Core.GUID fromString: '{f5c0a24d-9521-4497-9801-efc620bbaf9a}')!
UI.Tests.InplaceTextEditorTest comment: ''!
!UI.Tests.InplaceTextEditorTest methodsFor!

classToTest
	^InplaceTextEditor!

initializePresenter
	presenter := self classToTest createOn: 'a 🐬' asValue!

setUp
	clipboard := Clipboard current.
	savedText := clipboard getTextOrEmpty.
	super setUp!

tearDown
	super tearDown.
	clipboard setText: savedText!

testPaste
	| result expected toPaste |
	toPaste := 'Pasted 🍺 should not be truncated'.
	clipboard setText: toPaste.
	self assert: clipboard getText equals: toPaste.
	presenter show.
	presenter view selectionRange: (3 to: presenter view textLength).
	presenter pasteClipboard.
	result := presenter view plainText.
	expected := 'a ' , toPaste.
	self assert: result equals: expected.
	presenter ok.
	self assert: presenter value equals: expected! !
!UI.Tests.InplaceTextEditorTest categoriesForMethods!
classToTest!helpers!private! !
initializePresenter!private!Running! !
setUp!private!Running! !
tearDown!public!Running! !
testPaste!public!unit tests! !
!

