"Filed out from Dolphin Smalltalk"!

PresenterTest subclass: #StaticTextTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

StaticTextTest guid: (GUID fromString: '{92e427a0-a55c-4346-a3a1-68b30ee8a1a9}')!

StaticTextTest comment: ''!

!StaticTextTest categoriesForClass!Unclassified! !

!StaticTextTest methodsFor!

classToTest
	^StaticText!

testCalculateExtentMultiline
	"Test preferred extent calculation in multi-line 'alignment' modes:
		- In #leftNoWrap mode we expect that the calculated width is that required for the longest line, and that the height is the number of actual cr/lf separated lines.
		- In word-wrapping modes we expect that the calculated width respects the starting width, and that the height is sufficient to display all the text with wrapping."

	| expectedText firstLine canvas shell width firstLineExtent tabWidth actual lineHeight expected |
	presenter alignment: #leftNoWrap.
	self assert: (presenter getWindowStyle bitAnd: SS_TYPEMASK) equals: SS_LEFTNOWORDWRAP.
	expectedText := (String with: Character tab)
				, 'The quick &brown 狐狸 jumped over the lazy Лиса && fell over
multiple 
lines'.
	"The first line includes a tab, but the GDI GetTextExtentPoint32 function behind Canvas>>textExtent: isn't capable of calculating the width of text with tabs (perhaps not surprising, as there is a GetTabbedTextExtent function), so we do that separately"
	firstLine := 'The quick brown 狐狸 jumped over the lazy Лиса & fell over'.
	presenter text: expectedText.
	canvas := presenter canvas.
	canvas font: presenter actualFont.
	firstLineExtent := canvas textExtent: firstLine.
	tabWidth := canvas textMetrics tmAveCharWidth * 8.
	canvas free.
	lineHeight := firstLineExtent y.
	width := firstLineExtent x + tabWidth.
	expected := presenter calcExtentFromClientExtent: width @ (lineHeight * 3).
	shell := presenter parentView.
	actual := presenter calculateExtent: (LayoutContext forContainer: shell).
	self assert: actual equals: expected.
	"Now test with wrapping"
	presenter alignment: #left.
	self assert: (presenter getWindowStyle bitAnd: SS_TYPEMASK) equals: SS_LEFT.
	self assert: presenter text equals: expectedText.
	width := firstLineExtent x - 20.
	shell extent: width @ 100.
	expected := presenter calcExtentFromClientExtent: width @ (lineHeight * 4).
	actual := presenter calculateExtent: (LayoutContext forContainer: shell).
	"In this case we expect the initial width to be used as the line wrapping width, so the calculated width should be no larger. It may be smaller, however, depending on where the word breaks are."
	self assert: actual x <= expected x.
	self assert: actual y equals: expected y!

testCalculateExtentSimple
	"Test preferred extent calculation in the #simple (SS_SIMPLE) mode. This is a single-line mode that does not process tabs, nor the mnemonic prefixes. Furthermore any embedded cr/lfs are stripped out."

	| actualText firstLine canvas shell expected actual |
	shell := presenter parentView.
	shell extent: 500 @ 100.
	shell layoutManager: FlowLayout new.
	presenter alignment: #simple.
	actualText := (String with: Character tab)
				, 'The quick &brown 狐狸 jumped over the lazy Лиса && fell over
multiple 
lines'.
	"In simple mode the &'s are left untouched"
	firstLine := 'The quick &brown 狐狸 jumped over the lazy Лиса && fell overmultiple lines'.
	presenter text: actualText.
	"If debugging through it can be useful to see the size the control actually wants to be"
	presenter usePreferredExtent: true.
	presenter extent: 20 @ 10.
	canvas := presenter canvas.
	canvas font: presenter actualFont.
	expected := presenter calcExtentFromClientExtent: (canvas textExtent: firstLine).
	canvas free.
	actual := presenter calculateExtent: (LayoutContext forContainer: shell).
	self assert: actual y equals: expected y.
	"The width calculated by the GDI GetTextExtentPoint32 function is slightly different than the DrawTextEx calculation used by the control (and now#calculateExtent:) so we don't expect a precise result"
	self assert: (actual x - expected x) abs < 3! !

!StaticTextTest categoriesForMethods!
classToTest!helpers!private! !
testCalculateExtentMultiline!public! !
testCalculateExtentSimple!public! !
!

