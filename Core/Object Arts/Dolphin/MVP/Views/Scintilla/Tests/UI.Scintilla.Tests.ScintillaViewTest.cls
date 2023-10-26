"Filed out from Dolphin Smalltalk"!

UI.Tests.AbstractMultilineTextEditTest
	subclass: #'UI.Scintilla.Tests.ScintillaViewTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Scintilla.Tests.ScintillaViewTest guid: (Core.GUID fromString: '{3c6fbe95-74e0-4325-97e1-82f12133d503}')!
UI.Scintilla.Tests.ScintillaViewTest comment: ''!
!UI.Scintilla.Tests.ScintillaViewTest methodsFor!

assertClassifiesAscii: subject
	self assert: (($\0 to: $\x7F)
				difference: (subject wordChars , subject punctuation , subject whitespaces) asSet)
		equals: #($\n $\r)!

assertDefaultClassifications: aCharacterClassifications
	self assert: aCharacterClassifications isDefault.
	self assert: aCharacterClassifications wordChars equals: CharacterClassifications.DefaultWordChars.
	self assert: aCharacterClassifications punctuation equals: CharacterClassifications.DefaultPunctuation.
	self assert: aCharacterClassifications whitespaces equals: CharacterClassifications.DefaultWhitespaces.
	self assertClassifiesAscii: aCharacterClassifications!

classToTest
	^(self selector beginsWith: 'testStbUpgrade') ifFalse: [ScintillaView]!

initializePresenter
	super initializePresenter.
	presenter
		ifNotNil: 
			[| margins |
			presenter drawingTechnology: #default.
			margins := presenter margins.
			margins do: [:each | each width: 0].
			presenter margins: margins]!

margins
	^0 @ 0!

testCallTipColors
	| fore back style |
	style := presenter callTipStyle.
	self assert: style forecolor equals: Color tooltipText.
	self assert: style backcolor equals: Color tooltip.
	fore := Color fromRgbCode: (presenter sendMessage: SCI_STYLEGETFORE wParam: STYLE_CALLTIP).
	self assert: fore equals: Color tooltipText.
	back := Color fromRgbCode: (presenter sendMessage: SCI_STYLEGETBACK wParam: STYLE_CALLTIP).
	self assert: back equals: Color tooltip.
	presenter
		callTipForecolor: Color purple;
		callTipBackcolor: Color green.
	self assert: style forecolor equals: Color purple.
	self assert: style backcolor equals: Color green.
	fore := Color fromRgbCode: (presenter sendMessage: SCI_STYLEGETFORE wParam: STYLE_CALLTIP).
	self assert: fore equals: Color purple.
	back := Color fromRgbCode: (presenter sendMessage: SCI_STYLEGETBACK wParam: STYLE_CALLTIP).
	self assert: back equals: Color green!

testChangePunctuation
	| subject punctuation |
	subject := self view characterClassifications.
	self assertDefaultClassifications: subject.
	punctuation := subject punctuation, #($_ $\b).
	subject punctuation: punctuation.
	self assert: subject punctuation asSet equals: punctuation asSet.
	self assert: subject wordChars equals: (CharacterClassifications.DefaultWordChars copyWithout: $_).
	self assert: subject whitespaces equals: (CharacterClassifications.DefaultWhitespaces copyWithout: $\b).
	self assertClassifiesAscii: subject.
	self view characterClassifications: subject.
	self assert: self view characterClassifications identicalTo: subject.
	self assert: self view getCharacterClassifications equals: subject.
	self view punctuation: nil.
	self assertDefaultClassifications: subject.
	self assertDefaultClassifications: self view getCharacterClassifications
!

testChangeWhitespace
	| subject whitespaces |
	subject := self view characterClassifications.
	self assertDefaultClassifications: subject.
	whitespaces := #($\x20 $\t $\f $\v).
	subject whitespaces: whitespaces.
	self assert: subject whitespaces asSet equals: (whitespaces copyWith: $\0) asSet.
	self assert: subject wordChars equals: CharacterClassifications.DefaultWordChars.
	self assert: subject punctuation asSet
		equals: ((CharacterClassifications.DefaultPunctuation , CharacterClassifications.DefaultWhitespaces)
				asSet difference: (whitespaces copyWith: $\0)).
	self assertClassifiesAscii: subject.
	self view characterClassifications: subject.
	self assert: self view characterClassifications identicalTo: subject.
	self assert: self view getCharacterClassifications equals: subject.
	self view whitespaces: nil.
	self assertDefaultClassifications: subject.
	self assertDefaultClassifications: self view getCharacterClassifications!

testChangeWordChars
	| subject wordChars |
	subject := self view characterClassifications.
	self assertDefaultClassifications: subject.
	wordChars := subject wordChars , #($: $\v $#).
	subject wordChars: wordChars.
	self assert: subject wordChars asSet equals: wordChars asSet.
	self assert: subject punctuation
		equals: (CharacterClassifications.DefaultPunctuation difference: #($: $#)).
	self assert: subject whitespaces
		equals: (CharacterClassifications.DefaultWhitespaces difference: #($\v)).
	self assertClassifiesAscii: subject.
	self view characterClassifications: subject.
	self assert: self view characterClassifications identicalTo: subject.
	self assert: self view getCharacterClassifications equals: subject.
	self view wordChars: nil.
	self assertDefaultClassifications: subject.
	self assertDefaultClassifications: self view getCharacterClassifications!

testFindStringStartingAt
	| found found2 |
	self assert: presenter codePage identicalTo: #utf8.
	"This test relies on 'Object' appearing in the text multiple times"
	found := presenter findString: 'Object' startingAt: 1.
	self assert: found equals: (self text indexOfSubCollection: 'Object').
	self assert: (presenter findString: 'Object' startingAt: found) equals: found.
	self assert: found equals: (self text indexOfSubCollection: 'Object').
	found2 := presenter findString: 'Object' startingAt: found + 1.
	self assert: found2 > found.
	self assert: found2 equals: (self text indexOfSubCollection: 'Object' startingAt: found+1).
	self assert: (presenter findString: 'Wibble' startingAt: 1) equals: 0.
	self assert: (presenter findString: '' startingAt: 1) equals: 0.
	presenter text: 'Hello 🐬 World'.
	found := presenter findString: '🐬' startingAt: 1.
	self assert: found equals: 7.
	found := presenter findString: '🐬' startingAt: 7.
	self assert: found equals: 7.
	found := presenter findString: '🐬' startingAt: 8.
	self assert: found equals: 0.
	found := presenter findString: '🐬' startingAt: 50.
	self assert: found equals: 0.
	presenter clearAll.
	self assert: (presenter findString: 'Object' startingAt: 1) equals: 0.
!

testImmersiveColorSetChange
	| textColor settingName requested settableNotGettable rnd |
	textColor := Color red.
	presenter caretForecolor: (PluggableColor with: [textColor]).
	"Selection/whitespace forecolor and background colour are not retrievable from the view; we expect them to change, but can only test by examining calls"
	requested := OrderedCollection new.
	rnd := Random new.
	settableNotGettable := #(#whitespaceForecolor: #whitespaceBackcolor: #selectionForecolor: #selectionBackcolor: #secondarySelectionForecolor: #secondarySelectionBackcolor: #callTipHighlightColor: #foldMarginColor: #foldMarginHiColor: #secondaryCaretForecolor: #edgeColor: #currentLineBackcolor: #activeHotspotForecolor: #activeHotspotBackcolor:)
				asSet.
	settableNotGettable do: 
			[:each |
			presenter perform: each
				with: (PluggableColor with: 
							[requested addLast: each.
							Color fromRgbCode: (rnd next * 16rFFFFFF) rounded])].
	self assert: (presenter sendMessage: SCI_GETCARETFORE) equals: Color red rgbCode.
	self assert: requested asSet equals: settableNotGettable asSet.
	requested := OrderedCollection new.
	textColor := Color green.
	"Simulate the color set changing, e.g. entering/leaving high contrast mode."
	settingName := 'ImmersiveColorSet' asUtf16String.
	presenter topShell
		wmSettingChange: WM_SETTINGCHANGE
		wParam: 0
		lParam: settingName yourAddress.
	self assert: (presenter sendMessage: SCI_GETCARETFORE) equals: Color green rgbCode.
	self assert: requested asSet equals: settableNotGettable asSet!

testLanguages
	| lingos |
	lingos := ScintillaView lexerLanguages.
	lingos do: [:each | each notNil ifTrue: [presenter view lexer: each]]!

testLexerIndicatorStateRestoral
	| indicDefn1 indicDefn2 |
	"At the moment, just checking that the non-container indicators are reset on state restoral as regression test for #1085"
	indicDefn1 := IndicatorDefinition view: presenter index: INDICATOR_CONTAINER - 1.
	self assert: indicDefn1 style equals: #hidden.
	"All the other properties should be defaults"
	self assertIsNil: indicDefn1 basicAlpha.
	self assertIsNil: indicDefn1 basicForeAlpha.
	self assertIsNil: indicDefn1 basicForecolor.
	self assertIsNil: indicDefn1 basicHoverForecolor.
	self assertIsNil: indicDefn1 basicHoverStyle.
	self assert: indicDefn1 layer equals: 0.
	self assertIsNil: indicDefn1 basicStrokeWidth.
	indicDefn1 alpha: 123.
	presenter recreate.
	indicDefn2 := IndicatorDefinition view: presenter index: INDICATOR_CONTAINER - 1.
	self assert: indicDefn2 style equals: #hidden.
	"Note that the properties are not saved and restored - it's just that all indicators are hidden when the container indicator definitions are set"
	self assertIsNil: indicDefn2 basicAlpha!

testOverrideDefaultKeyBindings
	| bindings code expectedDiffs binding actualBindings |
	bindings := ScintillaView.DefaultKeyBindings copy.
	expectedDiffs := Set new.
	"Remove a key binding"
	code := AcceleratorTable keyCodeFromInvariantString: 'PGDOWN'.
	self assert: (bindings includesKey: code).
	bindings removeKey: code.
	expectedDiffs
		add: (KeyBinding newAcceleratorKey: code message: SCI_NULL).
	"Add a binding"
	code := AcceleratorTable keyCodeFromInvariantString: 'CTRL+J'.
	self deny: (bindings includesKey: code).
	binding := KeyBinding newAcceleratorKey: code
				message: SCI_SELECTIONDUPLICATE.
	bindings at: code put: binding.
	expectedDiffs add: binding.
	"Update a binding"
	code := AcceleratorTable keyCodeFromInvariantString: 'CTRL+D'.
	self assert: (bindings includesKey: code).
	binding := KeyBinding newAcceleratorKey: code message: SCI_PAGEDOWN.
	bindings at: code put: binding.
	expectedDiffs add: binding.

	"When the bindings are set, we should be able to get back matching bindings"
	presenter keyBindings: bindings.
	actualBindings := presenter keyBindings asSet.
	bindings := bindings asSet.
	self assert: (bindings symmetricDifference: actualBindings) asArray equals: #().
	"But only the diffs should be stored"
	self assert: presenter basicKeyBindings asSet equals: expectedDiffs!

testSetGetAnnotations
	| annotations |
	presenter annotationMode: #boxed.
	annotations := {Annotation
					line: 1
					text: 'Wobble'
					style: #Error.
				Annotation
					line: 2
					text: 'Wibble'
					style: #Warning.
				Annotation
					line: 1
					text: 'Blah'
					style: #Notification}.
	presenter annotations: annotations.
	self assert: (presenter annotations noDifference: annotations)!

testSetGetEndOfLineAnnotations
	| expected actual |
	presenter endOfLineAnnotationMode: #angleFlat.
	expected := {Annotation
					line: 1
					text: 'Wobble'
					style: #Error.
				Annotation
					line: 2
					text: 'Wibble'
					style: #Warning.
				Annotation
					line: 3
					text: 'Blah'
					style: #Notification}.
	presenter endOfLineAnnotations: expected.
	actual := presenter endOfLineAnnotations.
	self assert: actual equals: expected!

testStrCmp
	| upper |
	upper := 'A🐬£'.
	self assert: (Ucrt strcmp: upper string2: upper asLowercase) equals: -1.
	"Shouldn't be converting Utf8Strings to AnsiStrings as this is lossy"
	self deny: (Ucrt strcmp: upper string2: upper asAnsiString) equals: 0!

testStyleRunTextAt
	| subject cr line1 |
	subject := presenter view.
	subject lexer: #markdown.
	subject restyleAll.
	cr := self text indexOf: $\r.
	line1 := self text copyFrom: 1 to: cr - 1.
	self assert: (subject styleRunTextAt: 1) equals: line1.
	self assert: (subject styleRunTextAt: cr - 1) equals: line1.
	self assert: (subject styleRunTextAt: cr) equals: String lineDelimiter , String lineDelimiter.
	self assert: (subject styleRunTextAt: self text size) equals: String lineDelimiter.
	self should: [subject styleRunTextAt: 0] raise: BoundsError.
	self should: [subject styleRunTextAt: self text size + 1] raise: BoundsError!

testWcsICmp
	| upper |
	upper := 'A🐬£'.
	self assert: (Ucrt _wcsicmp: upper string2: upper) equals: 0.
	self assert: (Ucrt _wcsicmp: upper string2: upper asLowercase) equals: 0.
	self deny: (Ucrt _wcsicmp: upper string2: upper asAnsiString) equals: 0!

undoOnlyModification
	super undoOnlyModification.
	self deny: presenter isTextModified.
	self deny: presenter canUndo!

verifyUpgradedView: anInteger identifier: aResourceIdentifier
	| view offset |
	super verifyUpgradedView: anInteger identifier: aResourceIdentifier.
	view := self view.
	offset := MultilineTextEdit instSize - 16.
	#(29 30 34 48 50 51) do: [:i | self assertIsNil: (view instVarAt: i + offset)].	"The element colour instance variables should have been nil'd, and replaced with entries in the elementColors dictionary. Any alpha settings should be transferred to the relevant colour(s)"
	self assert: (view instVarNamed: 'library') identicalTo: UI.Scintilla.ScintillaLibrary default.
	self assert: view callTipTabWidth equals: ScintillaView.DefaultCallTipTabWidth.
	self assert: ({ AnsiString. Utf8String } includes: view stringClass).
	anInteger < 16
		ifTrue: 
			[self assert: view elementColors associations asArray
				equals: { SC_ELEMENT_CARET -> Color windowText }.
			anInteger < 15 ifTrue: [self assert: view selectionBackcolor equals: Color silver].
			self assertIsNil: (view instVarAt: 47 + offset).
			self assert: view characterClassifications isDefault.
			^self].
	anInteger = 16
		ifTrue: [self verifyUpgradedViewFrom16: view]
		ifFalse: [self verifyUpgradedViewFrom17: view]!

verifyUpgradedViewFrom16: aScintillaView
	"Former separately stored colours transitioned to element colours.
	The test view resource has been deliberately modified and resaved in Dolphin 7.1 to set various properties."

	| margin markerDef |
	self assert: aScintillaView caretForecolor equals: Color navy.
	self assert: aScintillaView secondaryCaretForecolor equals: Color purple.
	self assert: aScintillaView currentLineBackcolor equals: (Color cyan alpha: 63).
	self assert: aScintillaView whitespaceBackcolor equals: Color tooltip.
	self assert: aScintillaView whitespaceForecolor equals: Color lightSkyBlue.
	self assert: aScintillaView selectionBackcolor equals: (Color highlight alpha: 127).
	self assert: aScintillaView selectionForecolor equals: Color white.
	self assert: aScintillaView secondarySelectionForecolor equals: Color yellowGreen.
	self assert: aScintillaView secondarySelectionBackcolor equals: (Color oliveDrab alpha: 98).
	self assert: aScintillaView edgeColor equals: Color grayText.
	self assert: aScintillaView activeHotspotBackcolor equals: Color darkSlateBlue.
	self assert: aScintillaView activeHotspotForecolor equals: Color lightSkyBlue.
	self assert: aScintillaView edgeColumn equals: 120.
	self assert: aScintillaView isCurrentLineHighlighted.
	"The first margin has mostly defaults"
	margin := aScintillaView margins first.
	self assert: margin backcolor identicalTo: Margin.DefaultBackcolor.
	self assert: margin cursorType identicalTo: #reverseArrow.
	self deny: margin isSensitive.
	self assert: margin type identicalTo: #lineNumber.
	self assert: margin cursorType equals: #reverseArrow.
	self assertIsNil: margin mask.
	self assert: margin width equals: 16.
	"The last margin has mainly non-default properties"
	margin := aScintillaView margins last.
	self assert: margin backcolor equals: Color oldLace.
	self assert: margin cursorType equals: #normal.
	self assert: margin isSensitive.
	self assert: margin type identicalTo: #symbol.
	self assert: margin mask equals: SC_MASK_FOLDERS.
	self assert: margin width equals: 0.
	"And markers"
	markerDef := aScintillaView markerDefinitions first.
	self assert: markerDef name identicalTo: #circle.
	self assert: markerDef glyphName identicalTo: #circle.
	self assert: markerDef backcolor identicalTo: Color white.
	self assert: markerDef forecolor identicalTo: Color black.
	self assert: markerDef alpha identicalTo: SC_ALPHA_NOALPHA.
	self assert: markerDef selectionBackcolor identicalTo: Color red.
	"Properties not present in the v16 that should be defaults."
	self assert: markerDef strokeWidth equals: 1.
	self assert: markerDef layer identicalTo: #base.
	markerDef := aScintillaView markerDefinitions second.
	self assert: markerDef name identicalTo: #foo.
	self assert: markerDef glyphName identicalTo: #shortArrow.
	self assert: markerDef backcolor identicalTo: Color yellow.
	self assert: markerDef forecolor identicalTo: Color red.
	self assert: markerDef alpha identicalTo: 123.
	self assert: markerDef selectionBackcolor identicalTo: Color highlight.
	self assert: markerDef strokeWidth equals: 1.
	self assert: markerDef layer identicalTo: #base!

verifyUpgradedViewFrom17: aScintillaView
	"Version 18 introduced the CharacterClassifications abstraction replacing wordChars, whitespaces, and punctuation"

	| offset |
	offset := MultilineTextEdit instSize - 16.
	#(23 34 37) do: [:i | self assertIsNil: (aScintillaView instVarAt: i + offset)].
	"The resource was deliberately edited to remove $: from the punctuation chars, making it implicitly a word char. This should have been converted to a CharacterClassifications object."
	self deny: aScintillaView characterClassifications isDefault.
	self assert:aScintillaView punctuation equals: '~}|{`^]\[@?>=<;/.-,+*)(''&%$#"!!'.
	self assert: aScintillaView wordChars equals: 'zyxwvutsrqponmlkjihgfedcba_ZYXWVUTSRQPONMLKJIHGFEDCBA:9876543210'! !
!UI.Scintilla.Tests.ScintillaViewTest categoriesForMethods!
assertClassifiesAscii:!helpers!private! !
assertDefaultClassifications:!helpers!private! !
classToTest!helpers!private! !
initializePresenter!public!Running! !
margins!private!unit tests! !
testCallTipColors!public!unit tests! !
testChangePunctuation!character classes!public!unit tests! !
testChangeWhitespace!character classes!public!unit tests! !
testChangeWordChars!character classes!public!unit tests! !
testFindStringStartingAt!public!unit tests! !
testImmersiveColorSetChange!public!unit tests! !
testLanguages!public!unit tests! !
testLexerIndicatorStateRestoral!public!unit tests! !
testOverrideDefaultKeyBindings!public!unit tests! !
testSetGetAnnotations!public!unit tests! !
testSetGetEndOfLineAnnotations!public!unit tests! !
testStrCmp!public! !
testStyleRunTextAt!public!unit tests! !
testWcsICmp!public! !
undoOnlyModification!helpers!private! !
verifyUpgradedView:identifier:!helpers!private! !
verifyUpgradedViewFrom16:!helpers!private! !
verifyUpgradedViewFrom17:!helpers!private! !
!

!UI.Scintilla.Tests.ScintillaViewTest class methodsFor!

resource_Scintilla_view_13
	"Answer the literal data from which the 'Scintilla view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Scintilla_view_13)

	Contains:
		- v0 TextStyles
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy) 8 ##(Smalltalk.ScintillaView) 98 46 0 0 98 2 8 1445007428 1025 416 721990 2 ##(Smalltalk.ValueHolder) 0 32 1310726 ##(Smalltalk.EqualitySearchPolicy) 0 524550 ##(Smalltalk.ColorRef) 8 4278190080 0 5 0 0 0 416 0 8 4294903673 852486 ##(Smalltalk.NullConverter) 0 0 9 0 234 256 98 2 8 #normal 1182726 ##(Smalltalk.ScintillaTextStyle) 1 0 0 1 0 0 0 0 688 0 0 0 98 40 720 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1245510 1 ##(Smalltalk.NullScintillaStyler) 688 234 256 98 2 8 #default 1639942 ##(Smalltalk.ScintillaMarkerDefinition) 1 1 786694 ##(Smalltalk.IndexedColor) 33554433 866 33554471 416 8 #circle 202 208 98 0 0 63 9215 0 0 0 0 866 33554447 0 0 0 0 0 0 8 '' 3 234 256 98 2 8 #container 656 0 0 0 0 1 0 234 256 98 6 1 1509190 1 ##(Smalltalk.ScintillaIndicatorStyle) 1 416 65025 3 32 1 0 3 1074 3 416 33423361 5 32 3 0 5 1074 5 416 511 1 32 5 0 983302 ##(Smalltalk.MessageSequence) 202 208 98 8 721670 ##(Smalltalk.MessageSend) 8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point) 3359 21 1266 631 501 416 1202 8 #selectionRange: 98 1 525062 ##(Smalltalk.Interval) 3 1 3 416 1202 8 #isTextModified: 98 1 32 416 1202 8 #modificationEventMask: 98 1 9215 416 1202 8 #margins: 98 1 98 3 984582 ##(Smalltalk.ScintillaMargin) 1 416 1 3 32 1 1554 3 416 33 1 16 67108863 1554 5 416 1 1 16 -67108863 416 1202 8 #indentationGuides: 98 1 0 416 1202 8 #tabIndents: 98 1 16 416 1202 8 #tabWidth: 98 1 9 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 143 6 0 0 10 0 0 0 202 7 0 0 4 1 0 0] 98 0 1266 193 193 0 27)!

resource_Scintilla_view_14
	"Answer the literal data from which the 'Scintilla view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Scintilla_view_14)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy) 8 ##(Smalltalk.ScintillaView) 98 50 0 0 98 2 8 1445007428 1025 416 721990 2 ##(Smalltalk.ValueHolder) 0 32 1310726 ##(Smalltalk.EqualitySearchPolicy) 0 524550 ##(Smalltalk.ColorRef) 8 4278190080 0 5 0 0 0 416 0 8 4294906441 852486 ##(Smalltalk.NullConverter) 0 0 9 0 234 256 98 4 8 #callTip 1182790 1 ##(Smalltalk.ScintillaTextStyle) 77 786694 ##(Smalltalk.IndexedColor) 33554457 738 33554471 1 0 0 0 0 688 0 0 0 8 #normal 706 1 0 0 1 0 0 0 0 784 0 0 0 98 40 800 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1245510 1 ##(Smalltalk.NullScintillaStyler) 784 234 256 98 2 8 #default 1641542 1 ##(Smalltalk.ScintillaMarkerDefinition) 1 0 0 0 416 8 #circle 0 0 0 0 0 0 202 208 98 0 0 63 9215 0 0 0 0 738 33554447 0 0 65 0 0 0 8 '' 3 234 256 98 2 8 #container 656 0 0 0 0 1 0 234 256 98 6 1 1510470 2 ##(Smalltalk.ScintillaIndicatorStyle) 1 416 65025 3 32 1 0 0 0 0 0 0 3 1106 3 416 33423361 5 32 3 0 0 0 0 0 0 5 1106 5 416 511 1 32 5 0 0 0 0 0 0 0 0 234 256 98 6 8 #Notification 706 1029 0 196934 1 ##(Smalltalk.RGB) 31185883 1 0 0 0 0 1200 0 0 0 8 #Error 706 1031 1234 335 1234 31317503 1 0 0 0 0 1264 0 0 0 8 #Warning 706 1027 1234 60239 1234 31326207 1 0 0 0 0 1328 0 0 0 0 983302 ##(Smalltalk.MessageSequence) 202 208 98 10 721670 ##(Smalltalk.MessageSend) 8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point) 3839 21 1522 631 501 416 1458 8 #selectionRange: 98 1 525062 ##(Smalltalk.Interval) 3 1 3 416 1458 8 #isTextModified: 98 1 32 416 1458 8 #modificationEventMask: 98 1 9215 416 1458 8 #secondaryCaretForecolor: 98 1 1234 16711423 416 1458 8 #caretPeriod: 98 1 1061 416 1458 8 #margins: 98 1 98 3 984902 1 ##(Smalltalk.ScintillaMargin) 1 416 1 3 32 1 15 1922 3 416 33 1 16 67108863 15 1922 5 416 1 1 16 -67108863 15 416 1458 8 #tabIndents: 98 1 16 416 1458 8 #tabWidth: 98 1 9 416 1458 8 #areAdditionalCaretsVisible: 98 1 16 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 186 8 0 0 4 1 0 0] 98 0 1522 193 193 0 29)!

resource_Scintilla_view_14b
	"Answer the literal data from which the 'Scintilla view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Scintilla_view_14b)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ScintillaView) 34 50 0 0 34 2 8 1445007428 1025 416 721990 2 ##(Smalltalk.ValueHolder) 0 false 1310726 ##(Smalltalk.EqualitySearchPolicy) 0 524550 ##(Smalltalk.ColorRef) 8 4278190080 0 5 0 0 0 416 0 8 4294906539 852486 ##(Smalltalk.NullConverter) 0 0 9 0 170 192 34 4 #normal 1182790 1 ##(Smalltalk.ScintillaTextStyle) 1 0 0 1 0 0 0 0 #normal 0 0 0 #callTip 674 77 786694 ##(Smalltalk.IndexedColor) 33554457 722 33554471 1 0 0 0 0 #callTip 0 0 0 34 40 688 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1245510 1 ##(Smalltalk.NullScintillaStyler) #normal 170 192 34 2 #default 1641542 1 ##(Smalltalk.ScintillaMarkerDefinition) 1 0 0 0 416 #circle 0 0 0 0 0 0 138 ##(Smalltalk.IdentitySet) 8 #() 0 170 176 896 9215 0 0 0 0 722 33554447 0 0 65 0 0 0 8 '' 3 170 192 34 2 #container 640 0 0 0 0 1 0 170 192 34 6 1 1510470 2 ##(Smalltalk.ScintillaIndicatorStyle) 1 416 65025 3 false 1 0 0 0 0 0 0 3 1026 3 416 33423361 5 false 3 0 0 0 0 0 0 5 1026 5 416 511 1 false 5 0 0 0 0 0 0 0 0 170 192 34 6 #Notification 674 1029 0 196934 1 ##(Smalltalk.RGB) 31185883 1 0 0 0 0 #Notification 0 0 0 #Warning 674 1027 1138 60239 1138 31326207 1 0 0 0 0 #Warning 0 0 0 #Error 674 1031 1138 335 1138 31317503 1 0 0 0 0 #Error 0 0 0 0 983302 ##(Smalltalk.MessageSequence) 138 144 34 5 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 3839 21 1378 631 501 416 1330 #modificationEventMask: 8 #(4607) 416 1330 #caretPeriod: 8 #(530) 416 1330 #margins: 34 1 34 3 985158 2 ##(Smalltalk.ScintillaMargin) 1 416 1 3 0 0 0 0 1538 3 416 33 0 3 67108863 0 0 1538 5 416 1 0 3 -67108863 0 0 416 1330 #tabWidth: 8 #(4) 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 186 8 0 0 4 1 0 0] 8 #() 1378 193 193 0 29)!

resource_Scintilla_view_15
	"Answer the literal data from which the 'Scintilla view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Scintilla_view_15)
	"

	^#(#'!!STL' 4 985166 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ScintillaView) 34 50 nil nil 34 2 8 1411449156 262145 416 918598 2 ##(Smalltalk.ValueHolder) nil false 1769478 ##(Smalltalk.EqualitySearchPolicy) nil nil nil 21 nil nil nil 416 nil 8 2031697384 1049094 ##(Smalltalk.NullConverter) nil nil 73 1848902001 170 192 34 4 #normal 1444934 1 ##(Smalltalk.ScintillaTextStyle) 1 nil nil 1 nil nil nil nil #normal nil nil nil #callTip 626 77 917510 ##(Smalltalk.Color) #gray 674 #white 1 nil nil nil nil #callTip nil nil nil nil 2032902 ##(Tools.SmalltalkExpressionStyler) 1 nil nil false 138 144 8 #() 170 192 768 138 ##(Smalltalk.IdentitySet) 768 nil 170 176 768 nil nil nil nil nil 674 #silver nil nil 65 nil nil 170 192 34 6 #specialCharacter 8 '()[]<>' #literalArray 8 '()' #literalBytes 8 '[]' 8 '' 1 170 192 34 2 #container 592 nil nil nil nil 208 138 ##(Smalltalk.Set) 34 5 1507846 ##(Smalltalk.ScintillaKeyBinding) 9385 4345 1010 9951 4345 1010 9353 4345 1010 9435 4345 1010 9431 4345 170 192 34 4 #Warning 1772614 3 ##(Smalltalk.ScintillaIndicatorStyle) 17 416 674 #blue 3 false #Warning nil nil nil nil nil nil #Error 1138 19 416 674 #red 3 false #Error nil nil nil nil nil nil nil nil 170 192 34 6 #Notification 626 1029 nil 674 #gainsboro 1 nil nil nil nil #Notification nil nil nil #Warning 626 1027 674 #darkGoldenrod 674 #ivory 1 nil nil nil nil #Warning nil nil nil #Error 626 1031 674 #firebrick 674 #floralWhite 1 nil nil nil nil #Error nil nil nil nil 1310982 ##(Smalltalk.MessageSequence) 138 144 34 8 1049350 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 918022 ##(Smalltalk.Point) 6143 21 1490 371 39 416 1442 #hoverTime: 8 #(500) 416 1442 #caretPeriod: 8 #(530) 416 1442 #margins: 34 1 34 3 1247302 3 ##(Smalltalk.ScintillaMargin) 1 416 1 3 nil nil nil nil 1650 3 416 1 nil nil 67108863 nil nil 1650 5 416 1 nil nil nil nil nil 416 1442 #canHScroll: 8 #(false) 416 1442 #targetRange: 34 1 852742 ##(Smalltalk.Interval) 1 -1 3 416 1442 #maxCompletionListHeight: 8 #(9) 416 1442 #edgeColumn: 8 #(1) 416 1179910 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 184 12 0 0 29 0 0 0] 8 #() 1490 193 193 nil 31)!

resource_Scintilla_view_16
	"A TextPresenter `Scintilla view` resource amended in Dolphin 7.
	N.B. Includes additional non-default properties - this is not the original resource.

	If you wish to view this resource evaluate:
	Tools.ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Scintilla_view_16)
	
	DO NOT MODIFY/SAVE, as to do so will invalidate the test. Also be careful that the content is not modified by refactorings, e.g. class renames.
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ScintillaView) 34 65 nil nil 34 2 8 1445007428 1025 416 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil 327686 ##(Smalltalk.Color) #default nil 5 nil nil nil 416 nil 8 2079342056 852486 ##(Smalltalk.NullConverter) nil nil 9 1874459713 170 192 34 4 #callTip 1182790 1 ##(Smalltalk.ScintillaTextStyle) 77 546 #gray 546 #white 1 nil nil nil nil #callTip nil nil nil #normal 658 1 nil nil 1 nil nil nil nil #normal nil nil nil nil 1245510 1 ##(Smalltalk.NullScintillaStyler) #normal 170 192 34 4 #foo 1641542 2 ##(Smalltalk.ScintillaMarkerDefinition) 3 9 546 #red 546 #yellow 416 #foo 247 546 #highlight nil nil nil nil #circle 802 1 nil nil nil 416 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 8 #() nil 170 176 912 nil nil nil 546 #tooltip 546 #lightSkyBlue 864 704 nil 65 nil nil nil 8 '' 3 170 192 34 2 #container 624 nil nil nil nil 208 nil 170 192 34 6 1 1510470 3 ##(Smalltalk.ScintillaIndicatorStyle) 1 416 546 #commonGreen 3 false 1 nil nil nil nil nil nil 3 1058 3 416 546 #blue 5 false 3 nil nil nil nil nil nil 5 1058 5 416 546 #red 1 false 5 nil nil nil nil nil nil 546 #yellowGreen 546 #oliveDrab 170 192 34 6 #Warning 658 1027 546 #darkGoldenrod 546 #ivory 1 nil nil nil nil #Warning nil nil nil #Error 658 1031 546 #firebrick 546 #floralWhite 1 nil nil nil nil #Error nil nil nil #Notification 658 1029 nil 546 #gainsboro 1 nil nil nil nil #Notification nil nil nil 546 #navy 546 #purple 546 #grayText 546 #cyan 546 #lightSkyBlue 546 #darkSlateBlue nil nil nil nil nil nil nil nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 11 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 5515 21 1570 631 501 416 1522 #currentLineAlpha: 8 #(63) 416 1522 #caretPeriod: 8 #(530) 416 1522 #isCurrentLineHighlighted: 8 #(true) 416 1522 #margins: 34 1 34 3 985158 3 ##(Smalltalk.ScintillaMargin) 1 416 33 3 nil nil nil nil 1762 3 416 33 nil 3 67108863 nil nil 1762 5 416 1 nil 3 -67108863 -1 546 #oldLace 416 1522 #tabWidth: 8 #(4) 416 1522 #targetRange: 34 1 525062 ##(Smalltalk.Interval) 1 -1 3 416 1522 #maxCompletionListHeight: 8 #(9) 416 1522 #edgeColumn: 8 #(120) 416 1522 #selectionAlpha: 8 #(127) 416 1522 #secondarySelectionAlpha: 8 #(98) 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 197 10 0 0 10 0 0 0 0 12 0 0 4 1 0 0] 8 #() 1570 193 193 nil 33 )!

resource_Scintilla_view_17
	"The TextPresenter `Scintilla view` resource from some earlier Dolphin 8 versions, BUT edited to test CharacterClassifications by removing $: from the default punctuation chars.

	If you wish to view this resource evaluate:
	Tools.ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Scintilla_view_17)
	
	DO NOT MODIFY/SAVE, as to do so will invalidate the test.
	"

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.Scintilla.ScintillaView} 34 52 nil nil 34 2 8 1445007428 1025 416 918598 2 #{UI.ValueHolder} nil false 1769478 #{Kernel.EqualitySearchPolicy} nil 917510 #{Graphics.Color} #default nil 5 nil nil nil 416 nil 8 1379768784 1049094 #{UI.NullConverter} nil nil 9 nil 170 192 34 4 #normal 1444934 1 #{UI.Scintilla.TextStyle} 1 nil nil 1 nil nil nil nil #normal nil nil nil #callTip 658 77 546 #gray 546 #white 1 nil nil nil nil #callTip nil nil nil nil 1507654 1 #{UI.Scintilla.NullStyler} #normal 170 192 34 2 #default 1903686 2 #{UI.Scintilla.MarkerDefinition} 1 nil nil nil 416 #circle nil nil nil nil nil nil 138 #{Core.IdentitySet} 8 #() nil 170 176 848 nil nil nil 170 176 34 2 81 546 #windowText nil nil 2162950 #{UI.Scintilla.NullScintillaLibrary} nil 65 8 '~}|{`^]\[@?>=<;/.-,+*)(''&%$#"!!' nil nil 8 '' 3 170 192 34 2 #container 624 nil nil nil nil 208 nil 170 192 34 6 1 1772614 4 #{UI.Scintilla.IndicatorStyle} 1 416 546 #commonGreen 3 3 1 nil nil nil nil nil nil 3 1058 3 416 546 #blue 5 3 3 nil nil nil nil nil nil 5 1058 5 416 546 #red 1 3 5 nil nil nil nil nil nil nil nil 170 192 34 6 #Error 658 1031 546 #firebrick 546 #floralWhite 1 nil nil nil nil #Error nil nil nil #Warning 658 1027 546 #darkGoldenrod 546 #ivory 1 nil nil nil nil #Warning nil nil nil #Notification 658 1029 nil 546 #gainsboro 1 nil nil nil nil #Notification nil nil nil nil nil nil 1310982 #{Core.MessageSequence} 34 7 1049350 #{Core.MessageSend} #createAt:extent: 34 2 918022 #{Graphics.Point} 6143 21 1426 631 501 416 1378 #margins: 34 1 34 3 1247302 3 #{UI.Scintilla.Margin} 1 416 1 3 nil nil nil nil 1522 3 416 33 nil 3 67108863 nil nil 1522 5 416 1 nil 3 -67108863 nil nil 416 1378 #tabWidth: 8 #(4) 416 1378 #maxCompletionListHeight: 8 #(9) 416 1378 #sciSetTechnology: 8 #(1) 416 1378 #sciSetFontQuality: 8 #(3) 416 1378 #sciSetSelectionLayer: 8 #(1) 416 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 58 13 0 0 4 1 0 0] 8 #() 1426 193 193 nil 35)!

resource_Scintilla_view_18
	"The TextPresenter `Scintilla view` resource from some earlier Dolphin 8 versions, but edited to include character classifications (that were added in v18)

	If you wish to view this resource evaluate:
	Tools.ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Scintilla_view_18)
	
	DO NOT MODIFY/SAVE, as to do so will invalidate the test. Also watch out for modification by rename refactorings. These should be reverted.
	"

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.Scintilla.ScintillaView} 34 52 nil nil 34 2 8 1445007428 1025 416 918598 2 #{UI.ValueHolder} nil false 1769478 #{Kernel.EqualitySearchPolicy} nil 917510 #{Graphics.Color} #default nil 5 nil nil nil 416 nil 8 1392286112 1049094 #{UI.NullConverter} nil nil 9 nil 170 192 34 4 #callTip 1444934 1 #{UI.Scintilla.TextStyle} 77 546 #gray 546 #white 1 nil nil nil nil #callTip nil nil nil #normal 658 1 nil nil 1 nil nil nil nil #normal nil nil nil nil 1507654 1 #{UI.Scintilla.NullStyler} #normal 170 192 34 2 #default 1903686 2 #{UI.Scintilla.MarkerDefinition} 1 nil nil nil 416 #circle nil nil nil nil nil nil 138 #{Core.IdentitySet} 8 #() nil 170 176 848 nil nil nil 170 176 34 2 81 546 #windowText nil nil 2162950 #{UI.Scintilla.NullScintillaLibrary} nil 65 nil nil nil nil 3 170 192 34 2 #container 624 nil nil nil nil 208 nil 170 192 34 6 1 1772614 4 #{UI.Scintilla.IndicatorStyle} 1 416 546 #commonGreen 3 3 1 nil nil nil nil nil nil 3 1026 3 416 546 #blue 5 3 3 nil nil nil nil nil nil 5 1026 5 416 546 #red 1 3 5 nil nil nil nil nil nil 2425094 #{UI.Scintilla.CharacterClassifications} 8 #[0 0 0 0 0 0 0 0 0 0 1 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 2 2 2 2 2 2 2 2 2 2 2 3 3 3 3 3 3 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 3 3 3 3 2 3 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 3 3 3 3 0 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2] nil 170 192 34 6 #Notification 658 1029 nil 546 #gainsboro 1 nil nil nil nil #Notification nil nil nil #Warning 658 1027 546 #darkGoldenrod 546 #ivory 1 nil nil nil nil #Warning nil nil nil #Error 658 1031 546 #firebrick 546 #floralWhite 1 nil nil nil nil #Error nil nil nil nil nil nil 1310982 #{Core.MessageSequence} 34 7 1049350 #{Core.MessageSend} #createAt:extent: 34 2 918022 #{Graphics.Point} 6143 21 1442 631 501 416 1394 #margins: 34 1 34 3 1247302 3 #{UI.Scintilla.Margin} 1 416 1 3 nil nil nil nil 1538 3 416 33 nil 3 67108863 nil nil 1538 5 416 1 nil 3 -67108863 nil nil 416 1394 #tabWidth: 8 #(4) 416 1394 #maxCompletionListHeight: 8 #(9) 416 1394 #sciSetTechnology: 8 #(1) 416 1394 #sciSetFontQuality: 8 #(3) 416 1394 #sciSetSelectionLayer: 8 #(1) 416 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 58 13 0 0 4 1 0 0] 8 #() 1442 193 193 nil 37)!

resource_Scintilla_view_22
	"Answer the literal data from which the 'Scintilla view 22' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Scintilla_view_22)
	"

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.Scintilla.ScintillaView} 38 #{Core.Array} 56 nil nil 50 2 8 1445007428 1025 32 1094 2 #{UI.ValueHolder} nil false 6 #{Kernel.EqualitySearchPolicy} nil 6 #{Graphics.Color} #default nil 5 nil nil nil 32 nil nil 518 #{UI.NullConverter} nil nil 9 #focusLost nil nil nil nil 550 #{Core.IdentityDictionary} 2 #callTip 3142 1 #{UI.Scintilla.TextStyle} 77 178 #gray 178 #white 1 nil nil nil nil #callTip nil nil nil #normal 274 1 nil nil 1 nil nil nil nil #normal nil nil nil nil 326 1 #{UI.Scintilla.NullStyler} #normal 242 1 #default 3142 2 #{UI.Scintilla.MarkerDefinition} 1 nil nil nil 32 #circle nil nil nil nil nil nil 294 #{Core.IdentitySet} 0 nil 550 #{Core.LookupTable} 0 nil nil nil 466 1 81 178 #windowText nil nil 262 #{UI.Scintilla.NullScintillaLibrary} nil 65 nil nil nil nil 3 242 1 #container 256 nil nil nil nil #{Core.Utf8String} nil 242 3 1 3142 5 #{UI.Scintilla.IndicatorDefinition} 1 32 178 #commonGreen 3 3 1 nil nil nil nil nil nil 3 594 3 32 178 #blue 5 3 3 nil nil nil nil nil nil 5 594 5 32 178 #red 1 3 5 nil nil nil nil nil nil 262 #{UI.Scintilla.CharacterClassifications} 8 #[0 0 0 0 0 0 0 0 0 0 1 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 2 2 2 2 2 2 2 2 2 2 2 3 3 3 3 3 3 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 3 3 3 3 2 3 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 3 3 3 3 0 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2] nil 242 3 #Error 274 1031 178 #firebrick 178 #floralWhite 1 nil nil nil nil #Error nil nil nil #Notification 274 1029 nil 178 #gainsboro 1 nil nil nil nil #Notification nil nil nil #Warning 274 1027 178 #darkGoldenrod 178 #ivory 1 nil nil nil nil #Warning nil nil nil nil nil nil 262 #{Core.MessageSequence} 50 7 774 #{Core.MessageSend} #createAt:extent: 50 2 518 #{Graphics.Point} 6143 21 994 631 501 32 946 #margins: 50 1 50 3 2118 3 #{UI.Scintilla.Margin} 1 32 nil 3 nil nil nil nil 1090 3 32 33 nil 3 67108863 nil nil 1090 5 32 nil nil 3 8 4261412864 nil nil 32 946 #tabWidth: 8 #(4) 32 946 #maxCompletionListHeight: 8 #(9) 32 946 #sciSetTechnology: 8 #(1) 32 946 #sciSetFontQuality: 8 #(3) 32 946 #sciSetSelectionLayer: 8 #(1) 32 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 58 13 0 0 4 1 0 0] 8 #() 994 193 193 nil 45)! !
!UI.Scintilla.Tests.ScintillaViewTest class categoriesForMethods!
resource_Scintilla_view_13!public!resources-views! !
resource_Scintilla_view_14!public!resources-views! !
resource_Scintilla_view_14b!public!resources-views! !
resource_Scintilla_view_15!public!resources-views! !
resource_Scintilla_view_16!public!resources-views! !
resource_Scintilla_view_17!public!resources-views! !
resource_Scintilla_view_18!public!resources-views! !
resource_Scintilla_view_22!public!resources-views! !
!

