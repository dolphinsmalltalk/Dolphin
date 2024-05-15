"Filed out from Dolphin Smalltalk"!

UI.Tests.AbstractTextEditTest
	subclass: #'UI.Tests.TextEditTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.Tests.TextEditTest guid: (Core.GUID fromString: '{5237b507-a634-4555-81af-e15822492437}')!

UI.Tests.TextEditTest comment: ''!

!UI.Tests.TextEditTest methodsFor!

classToTest
	^TextEdit!

margins
	^1 @ 0!

testCalculateExtent
	"Test preferred extent calculation correctly accounts for tabs and does not process mnemonic prefixes."

	| actualText shell expected actual textToMeasure |
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
	textToMeasure := actualText copyReplaceAll: (String with: Character tab)
				with: (String new: 8 withAll: Character space).
	expected := presenter calcExtentFromClientExtent: (self getTextExtent: textToMeasure).
	actual := presenter calculateExtent: (LayoutContext forContainer: shell).
	self assert: actual y equals: expected y.
	"The width calculated by the GDI GetTextExtentPoint32 function is slightly different than the DrawTextEx calculation used by the control (and now#calculateExtent:) so we don't expect a precise result"
	self assert: (actual x - expected x) abs < 3!

testClearing
	"Single-line edit control will truncate text that exceeds the display area unless ES_AUTOHSCROLL is set."

	presenter canHScroll: true.
	super testClearing!

text
	^'The quick brown fox jumped over the lazy dog'!

verifyUpgradedView: anInteger identifier: aResourceIdentifier
	| view |
	super verifyUpgradedView: anInteger identifier: aResourceIdentifier.
	view := self view.
	aResourceIdentifier owningClass == NumberPresenter
		ifTrue: 
			[aResourceIdentifier selector == #resource_Integer_text
				ifTrue: [self assert: view format identicalTo: #numeric]
				ifFalse: [self assert: view format identicalTo: #mixed].
			self assert: view typeconverter isKindOf: NumberToText]
		ifFalse: [self assert: view typeconverter isNullConverter].
	self assertIsNil: view contextMenu.
	self assert: (view instVarNamed: 'teFlags') equals: 0.
	self assert: view updateMode
		equals: ((aResourceIdentifier notNil
				and: [aResourceIdentifier selector == #resource_Default_view_D8_13])
					ifTrue: [#perChar]
					ifFalse: [#focusLost])! !

!UI.Tests.TextEditTest categoriesForMethods!
classToTest!constants!private! !
margins!constants!private! !
testCalculateExtent!public!unit tests! !
testClearing!public!unit tests! !
text!constants!private! !
verifyUpgradedView:identifier:!helpers!private! !
!

!UI.Tests.TextEditTest class methodsFor!

resource_Default_view_D6
	"Version 13 TextPresenter TextEdit resource from Dolphin 6.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view_D6)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.TextEdit)  98 16 0 0 98 2 8 1140916352 1025 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 7 0 0 0 416 0 8 4294904635 852486 ##(Smalltalk.NullConverter)  0 0 1 983302 ##(Smalltalk.MessageSequence)  202 208 98 3 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point)  2799 21 722 241 39 416 658 8 #selectionRange: 98 1 525062 ##(Smalltalk.Interval)  3 1 3 416 658 8 #isTextModified: 98 1 32 416 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 239 5 0 0 29 0 0 0] 98 0 722 193 193 0 27 )!

resource_Default_view_D7
	"Version 13 resource from Dolphin 7.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view_D7)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.TextEdit) 34 16 nil nil 34 2 8 1140916352 1025 416 nil 327686 ##(Smalltalk.Color) #default nil 7 nil nil nil 416 nil 8 1903872368 852486 ##(Smalltalk.NullConverter) nil nil 1 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 3839 21 674 241 39 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 247 7 0 0 29 0 0 0] 8 #() 674 193 193 nil 27 )!

resource_Default_view_D8_13
	"Version 13 TextPresenter TextEdit resource from D8. Same stbVersion as D7, but STL 5 with binding refs to classes, and classes in namespaces other than Smalltalk AND edited to set updatePerChar to test correct conversion to updateMode.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view_D8_13)
	"

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.TextEdit} 34 16 nil nil 34 2 8 1140916352 1025 416 nil 917510 #{Graphics.Color} #default nil 7 nil nil nil 416 nil 8 1817911536 1049094 #{UI.NullConverter} nil nil 5 1310982 #{Core.MessageSequence} 34 2 1049350 #{Core.MessageSend} #createAt:extent: 34 2 918022 #{Graphics.Point} 6143 21 658 241 39 416 610 #text: 34 1 8 'perChar' 416 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 119 12 0 0 29 0 0 0] 8 #() 658 193 193 nil 27)! !

!UI.Tests.TextEditTest class categoriesForMethods!
resource_Default_view_D6!constants!public! !
resource_Default_view_D7!constants!public! !
resource_Default_view_D8_13!constants!public! !
!

