"Filed out from Dolphin Smalltalk 7"!

UI.Tests.AbstractTextEditTest subclass: #'UI.Tests.TextEditTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Tests.TextEditTest guid: (Core.GUID fromString: '{5237b507-a634-4555-81af-e15822492437}')!
UI.Tests.TextEditTest comment: ''!
!UI.Tests.TextEditTest categoriesForClass!Unclassified! !
!UI.Tests.TextEditTest methodsFor!

classToTest
	^TextEdit!

margins
	^1 @ 0!

testCalculateExtent
	"Test preferred extent calculation correctly accounts for tabs and does not process mnemonic prefixes."

	| actualText canvas shell expected actual textToMeasure |
	"Use a non-proportional font to make calculating the expected result predictable"
	presenter view font: self nonProportionalFont.
	shell := presenter parentView.
	shell extent: 600 @ 100.
	shell layoutManager: FlowLayout new.
	actualText := '	The quick brown 狐狸 jumped over the lazy Лиса & fell over'.
	presenter text: actualText.
	"If debugging through it can be useful to see the size the control actually wants to be to check that all the text is displayed without extra space or clipping"
	presenter usePreferredExtent: true.
	presenter extent: 20 @ 10.
	canvas := presenter canvas.
	canvas font: presenter actualFont.
	textToMeasure := actualText copyReplaceAll: (String with: Character tab)
				with: (String new: 8 withAll: Character space).
	expected := presenter calcExtentFromClientExtent: (canvas textExtent: textToMeasure).
	canvas free.
	actual := presenter calculateExtent: (LayoutContext forContainer: shell).
	self assert: actual y equals: expected y.
	"The width calculated by the GDI GetTextExtentPoint32 function is slightly different than the DrawTextEx calculation used by the control (and now#calculateExtent:) so we don't expect a precise result"
	self assert: (actual x - expected x) abs < 3!

text
	^'The quick brown fox jumped over the lazy dog'! !
!UI.Tests.TextEditTest categoriesFor: #classToTest!constants!private! !
!UI.Tests.TextEditTest categoriesFor: #margins!constants!private! !
!UI.Tests.TextEditTest categoriesFor: #testCalculateExtent!public!unit tests! !
!UI.Tests.TextEditTest categoriesFor: #text!constants!private! !

