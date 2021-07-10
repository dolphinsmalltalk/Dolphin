"Filed out from Dolphin Smalltalk"!

UI.Tests.AbstractMultilineTextEditTest subclass: #'UI.Scintilla.Tests.ScintillaViewTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Scintilla.Tests.ScintillaViewTest guid: (Core.GUID fromString: '{3c6fbe95-74e0-4325-97e1-82f12133d503}')!
UI.Scintilla.Tests.ScintillaViewTest comment: ''!
!UI.Scintilla.Tests.ScintillaViewTest categoriesForClass!Unclassified! !
!UI.Scintilla.Tests.ScintillaViewTest methodsFor!

classToTest
	^(self selector beginsWith: 'testStbUpgrade') ifFalse: [ScintillaView]!

initializePresenter
	| margins |
	super initializePresenter.
	presenter
		ifNotNil: 
			[presenter drawingTechnology: #default.
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

testFindStringStartingAt
	| found found2 |
	presenter codePage: #utf8.
	self assert: (presenter findString: 'Object' startingAt: 1) equals: 0.
	"This test relies on 'Object' appearing in the text multiple times"
	presenter text: self text.
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
	self assert: found equals: 0!

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
	presenter text: self text; annotationMode: #boxed.
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
	presenter text: self text.
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

testStateRestoral
	| indicStyle1 indicStyle2 |
	"At the moment, just checking that the non-container indicators are reset on state restoral as regression test for #1085"
	indicStyle1:= IndicatorStyle view: presenter index: INDICATOR_CONTAINER - 1.
	self assert: indicStyle1 style equals: #hidden.
	presenter recreate.
	indicStyle2 := IndicatorStyle view: presenter index: INDICATOR_CONTAINER - 1.
	self assert: indicStyle2 style equals: #hidden.
!

testStbUpgradeFrom15
	| stream filer |
	stream := #(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.Scintilla.ScintillaView) 34 50 nil nil 34 2 8 1411449156 262145 416 918598 2 ##(UI.ValueHolder) nil false 1769478 ##(Kernel.EqualitySearchPolicy) nil nil nil 21 nil nil nil 416 nil 8 2031697384 1049094 ##(UI.NullConverter) nil nil 73 1848902001 170 192 34 4 #normal 1444934 1 ##(UI.Scintilla.TextStyle) 1 nil nil 1 nil nil nil nil #normal nil nil nil #callTip 626 77 917510 ##(Graphics.Color) #gray 674 #white 1 nil nil nil nil #callTip nil nil nil nil 2032902 ##(Tools.SmalltalkExpressionStyler) 1 nil nil false 138 144 8 #() 170 192 768 138 ##(Core.IdentitySet) 768 nil 170 176 768 nil nil nil nil nil 674 #silver nil nil 65 nil nil 170 192 34 6 #specialCharacter 8 '()[]<>' #literalArray 8 '()' #literalBytes 8 '[]' 8 '' 1 170 192 34 2 #container 592 nil nil nil nil 208 138 ##(Core.Set) 34 5 1507846 ##(UI.Scintilla.KeyBinding) 9385 4345 1010 9951 4345 1010 9353 4345 1010 9435 4345 1010 9431 4345 170 192 34 4 #Warning 1772614 3 ##(UI.Scintilla.IndicatorStyle) 17 416 674 #blue 3 false #Warning nil nil nil nil nil nil #Error 1138 19 416 674 #red 3 false #Error nil nil nil nil nil nil nil nil 170 192 34 6 #Notification 626 1029 nil 674 #gainsboro 1 nil nil nil nil #Notification nil nil nil #Warning 626 1027 674 #darkGoldenrod 674 #ivory 1 nil nil nil nil #Warning nil nil nil #Error 626 1031 674 #firebrick 674 #floralWhite 1 nil nil nil nil #Error nil nil nil nil 1310982 ##(Core.MessageSequence) 138 144 34 8 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 918022 ##(Graphics.Point) 6143 21 1490 371 39 416 1442 #hoverTime: 8 #(500) 416 1442 #caretPeriod: 8 #(530) 416 1442 #margins: 34 1 34 3 1247302 3 ##(UI.Scintilla.Margin) 1 416 1 3 nil nil nil nil 1650 3 416 1 nil nil 67108863 nil nil 1650 5 416 1 nil nil nil nil nil 416 1442 #canHScroll: 8 #(false) 416 1442 #targetRange: 34 1 852742 ##(Core.Interval) 1 -1 3 416 1442 #maxCompletionListHeight: 8 #(9) 416 1442 #edgeColumn: 8 #(1) 416 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 184 12 0 0 29 0 0 0] 8 #() 1490 193 193 nil 31)
				readStream.
	filer := STLInFiler on: stream.
	filer context: View desktop.
	presenter := filer next.
	#(29 30 47 48 50 51) do: [:i | self assertIsNil: (presenter instVarAt: i)].
	self assert: (presenter instVarAt: 31) identicalTo: UI.Scintilla.ScintillaLibrary default.
	self assert: presenter elementColors associations asArray
		equals: {SC_ELEMENT_CARET -> Color windowText}!

testStbUpgradeFrom16
	| stream filer |
	"TextPresenter 'Scintilla view', version 16 saved in Dolphin 7.1 with addition of some deprecated settings such as selectionAlpha, secondarySelectionAlpha, currentLineAlpha, and settings for all the colours replaced by element colours."
	stream := #(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ScintillaView) 34 65 nil nil 34 2 8 1445007428 1025 416 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil 327686 ##(Smalltalk.Color) #default nil 5 nil nil nil 416 nil 8 1499413992 852486 ##(Smalltalk.NullConverter) nil nil 9 56813377 170 192 34 4 #callTip 1182790 1 ##(Smalltalk.ScintillaTextStyle) 77 546 #gray 546 #white 1 nil nil nil nil #callTip nil nil nil #normal 658 1 nil nil 1 nil nil nil nil #normal nil nil nil nil 1245510 1 ##(Smalltalk.NullScintillaStyler) #normal 170 192 34 2 #default 1641542 2 ##(Smalltalk.ScintillaMarkerDefinition) 1 nil nil nil 416 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 8 #() nil 170 176 848 nil nil nil 546 #tooltip 546 #lightSkyBlue 546 #highlight 704 nil 65 nil nil nil 8 '' 3 170 192 34 2 #container 624 nil nil nil nil 208 nil 170 192 34 6 1 1510470 3 ##(Smalltalk.ScintillaIndicatorStyle) 1 416 546 #commonGreen 3 false 1 nil nil nil nil nil nil 3 1010 3 416 546 #blue 5 false 3 nil nil nil nil nil nil 5 1010 5 416 546 #red 1 false 5 nil nil nil nil nil nil 546 #yellowGreen 546 #oliveDrab 170 192 34 6 #Warning 658 1027 546 #darkGoldenrod 546 #ivory 1 nil nil nil nil #Warning nil nil nil #Error 658 1031 546 #firebrick 546 #floralWhite 1 nil nil nil nil #Error nil nil nil #Notification 658 1029 nil 546 #gainsboro 1 nil nil nil nil #Notification nil nil nil 546 #navy 546 #purple 546 #grayText 546 #cyan 896 546 #darkSlateBlue nil nil nil nil nil nil nil nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 12 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 6143 21 1506 631 501 416 1458 #text: 34 1 8 'Test content
Line 2' 416 1458 #currentLineAlpha: 8 #(63) 416 1458 #caretPeriod: 8 #(530) 416 1458 #isCurrentLineHighlighted: 8 #(true) 416 1458 #margins: 34 1 34 3 985158 3 ##(Smalltalk.ScintillaMargin) 1 416 1 3 nil nil nil nil 1746 3 416 33 nil 3 67108863 nil nil 1746 5 416 1 nil 3 -67108863 nil nil 416 1458 #tabWidth: 8 #(4) 416 1458 #targetRange: 34 1 525062 ##(Smalltalk.Interval) 3 41 3 416 1458 #maxCompletionListHeight: 8 #(9) 416 1458 #edgeColumn: 8 #(120) 416 1458 #selectionAlpha: 8 #(127) 416 1458 #secondarySelectionAlpha: 8 #(98) 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 58 13 0 0 4 1 0 0] 8 #() 1506 193 193 nil 33)
				readStream.
	filer := STLInFiler on: stream.
	filer context: View desktop.
	presenter := filer next.
	"The element colour instance variables should have been nil'd, and replaced with entries in the elementColors dictionary. Any alpha settings should be transferred to the relevant colour(s)"
	#(29 30 47 48 50 51) do: [:i | self assertIsNil: (presenter instVarAt: i)].
	self assert: (presenter instVarAt: 31) identicalTo: UI.Scintilla.ScintillaLibrary default.
	self assert: presenter caretForecolor equals: Color navy.
	self assert: presenter secondaryCaretForecolor equals: Color purple.
	self assert: presenter currentLineBackcolor equals: (Color cyan alpha: 63).
	self assert: presenter whitespaceBackcolor equals: Color tooltip.
	self assert: presenter whitespaceForecolor equals: Color lightSkyBlue.
	self assert: presenter selectionBackcolor equals: (Color highlight alpha: 127).
	self assert: presenter selectionForecolor equals: Color white.
	self assert: presenter secondarySelectionForecolor equals: Color yellowGreen.
	self assert: presenter secondarySelectionBackcolor equals: (Color oliveDrab alpha: 98).
	self assert: presenter edgeColor equals: Color grayText.
	self assert: presenter activeHotspotBackcolor equals: Color darkSlateBlue.
	self assert: presenter activeHotspotForecolor equals: Color lightSkyBlue.
	self assert: presenter edgeColumn equals: 120.
	self assert: presenter isCurrentLineHighlighted! !
!UI.Scintilla.Tests.ScintillaViewTest categoriesForMethods!
classToTest!helpers!private! !
initializePresenter!public!Running! !
margins!private!unit tests! !
testCallTipColors!public!unit tests! !
testFindStringStartingAt!public!unit tests! !
testImmersiveColorSetChange!public!unit tests! !
testLanguages!public!unit tests! !
testOverrideDefaultKeyBindings!public!unit tests! !
testSetGetAnnotations!public!unit tests! !
testSetGetEndOfLineAnnotations!public!unit tests! !
testStateRestoral!public!unit tests! !
testStbUpgradeFrom15!public!unit tests! !
testStbUpgradeFrom16!public!unit tests! !
!

