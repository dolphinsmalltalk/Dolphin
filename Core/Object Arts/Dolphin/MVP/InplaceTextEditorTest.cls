"Filed out from Dolphin Smalltalk"!

PresenterTest subclass: #InplaceTextEditorTest
	instanceVariableNames: 'clipboard savedText'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

InplaceTextEditorTest guid: (GUID fromString: '{f5c0a24d-9521-4497-9801-efc620bbaf9a}')!

InplaceTextEditorTest comment: ''!

!InplaceTextEditorTest categoriesForClass!Unclassified! !

!InplaceTextEditorTest methodsFor!

classToTest
	^InplaceTextEditor!

setUp
	clipboard := Clipboard current.
	savedText := clipboard getTextOrEmpty.
	presenter := self classToTest createOn: 'a 🐬' asValue!

tearDown
	presenter isNil
		ifFalse: 
			[presenter destroy.
			presenter := nil].
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

!InplaceTextEditorTest categoriesForMethods!
classToTest!helpers!private! !
setUp!private!Running! !
tearDown!public!Running! !
testPaste!public!unit tests! !
!

