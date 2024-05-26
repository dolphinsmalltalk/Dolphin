﻿"Filed out from Dolphin Smalltalk"!

AbstractMultilineTextEditTest subclass: #ScintillaViewTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'ScintillaConstants'
	classInstanceVariableNames: ''!

ScintillaViewTest guid: (GUID fromString: '{3c6fbe95-74e0-4325-97e1-82f12133d503}')!

ScintillaViewTest comment: ''!

!ScintillaViewTest categoriesForClass!Unclassified! !

!ScintillaViewTest methodsFor!

classToTest
	^ScintillaView!

initializePresenter
	| margins |
	super initializePresenter.
	margins := presenter view margins.
	margins do: [:each | each width: 0].
	presenter view margins: margins
!

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
		add: (ScintillaKeyBinding newAcceleratorKey: code message: ScintillaConstants.SCI_NULL).
	"Add a binding"
	code := AcceleratorTable keyCodeFromInvariantString: 'CTRL+J'.
	self deny: (bindings includesKey: code).
	binding := ScintillaKeyBinding newAcceleratorKey: code
				message: ScintillaConstants.SCI_SELECTIONDUPLICATE.
	bindings at: code put: binding.
	expectedDiffs add: binding.
	"Update a binding"
	code := AcceleratorTable keyCodeFromInvariantString: 'CTRL+D'.
	self assert: (bindings includesKey: code).
	binding := ScintillaKeyBinding newAcceleratorKey: code message: ScintillaConstants.SCI_PAGEDOWN.
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
	presenter text: self text.
	annotations := OrderedCollection new.
	annotations
		add: (ScintillaAnnotation
					line: 1
					text: 'Wobble'
					style: #Error);
		add: (ScintillaAnnotation
					line: 2
					text: 'Wibble'
					style: #Warning);
		add: (ScintillaAnnotation
					line: 1
					text: 'Blah'
					style: #Notification).
	presenter annotations: annotations.
	self assert: (presenter annotations noDifference: annotations)!

testStateRestoral
	| indicStyle1 indicStyle2 |
	"At the moment, just checking that the non-container indicators are reset on state restoral as regression test for #1085"
	indicStyle1:= ScintillaIndicatorStyle view: presenter index: INDICATOR_CONTAINER - 1.
	self assert: indicStyle1 style equals: #hidden.
	presenter recreate.
	indicStyle2 := ScintillaIndicatorStyle view: presenter index: INDICATOR_CONTAINER - 1.
	self assert: indicStyle2 style equals: #hidden.
!

testStbUpgradeFrom15
	| stream filer |
	#nocreate.
	stream := #(#'!!STL' 4 985166 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ScintillaView) 34 50 nil nil 34 2 8 1411449156 262145 416 918598 2 ##(Smalltalk.ValueHolder) nil false 1769478 ##(Smalltalk.EqualitySearchPolicy) nil nil nil 21 nil nil nil 416 nil 8 2031697384 1049094 ##(Smalltalk.NullConverter) nil nil 73 1848902001 170 192 34 4 #normal 1444934 1 ##(Smalltalk.ScintillaTextStyle) 1 nil nil 1 nil nil nil nil #normal nil nil nil #callTip 626 77 917510 ##(Smalltalk.Color) #gray 674 #white 1 nil nil nil nil #callTip nil nil nil nil 2032902 ##(Smalltalk.SmalltalkExpressionStyler) 1 nil nil false 138 144 8 #() 170 192 768 138 ##(Smalltalk.IdentitySet) 768 nil 170 176 768 nil nil nil nil nil 674 #silver nil nil 65 nil nil 170 192 34 6 #specialCharacter 8 '()[]<>' #literalArray 8 '()' #literalBytes 8 '[]' 8 '' 1 170 192 34 2 #container 592 nil nil nil nil 208 138 ##(Smalltalk.Set) 34 5 1507846 ##(Smalltalk.ScintillaKeyBinding) 9385 4345 1010 9951 4345 1010 9353 4345 1010 9435 4345 1010 9431 4345 170 192 34 4 #Warning 1772614 3 ##(Smalltalk.ScintillaIndicatorStyle) 17 416 674 #blue 3 false #Warning nil nil nil nil nil nil #Error 1138 19 416 674 #red 3 false #Error nil nil nil nil nil nil nil nil 170 192 34 6 #Notification 626 1029 nil 674 #gainsboro 1 nil nil nil nil #Notification nil nil nil #Warning 626 1027 674 #darkGoldenrod 674 #ivory 1 nil nil nil nil #Warning nil nil nil #Error 626 1031 674 #firebrick 674 #floralWhite 1 nil nil nil nil #Error nil nil nil nil 1310982 ##(Smalltalk.MessageSequence) 138 144 34 8 1049350 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 918022 ##(Smalltalk.Point) 6143 21 1490 371 39 416 1442 #hoverTime: 8 #(500) 416 1442 #caretPeriod: 8 #(530) 416 1442 #margins: 34 1 34 3 1247302 3 ##(Smalltalk.ScintillaMargin) 1 416 1 3 nil nil nil nil 1650 3 416 1 nil nil 67108863 nil nil 1650 5 416 1 nil nil nil nil nil 416 1442 #canHScroll: 8 #(false) 416 1442 #targetRange: 34 1 852742 ##(Smalltalk.Interval) 1 -1 3 416 1442 #maxCompletionListHeight: 8 #(9) 416 1442 #edgeColumn: 8 #(1) 416 1179910 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 184 12 0 0 29 0 0 0] 8 #() 1490 193 193 nil 31)
				readStream.
	filer := STLInFiler on: stream.
	filer context: View desktop.
	presenter := filer next.
	#(29 31 47 48 50 51) do: [:i | self assertIsNil: (presenter instVarAt: i)].
	self assert: presenter selectionBackcolor equals: Color silver.
	self assert: presenter caretForecolor equals: Color windowText!

verifyUpgradedView: anInteger
	| view |
	super verifyUpgradedView: anInteger.
	view := self view.
	#(29 34 47 48 50 51) do: [:i | self assertIsNil: (view instVarAt: i)].	"The element colour instance variables should have been nil'd, and replaced with entries in the elementColors dictionary. Any alpha settings should be transferred to the relevant colour(s)"
	self assert: view callTipTabWidth equals: ScintillaView.DefaultCallTipTabWidth.
	self assert: ({AnsiString. Utf8String} includes: view stringClass).
	anInteger >= 16
		ifTrue: 
			[self assert: view caretForecolor equals: Color navy.
			self assert: view secondaryCaretForecolor equals: Color purple.
			self assert: view currentLineBackcolor equals: (Color cyan alpha: 63).
			self assert: view whitespaceBackcolor equals: Color tooltip.
			self assert: view whitespaceForecolor equals: Color lightSkyBlue.
			self assert: view selectionBackcolor equals: (Color highlight alpha: 127).
			self assert: view selectionForecolor equals: Color white.
			self assert: view secondarySelectionForecolor equals: Color yellowGreen.
			self assert: view secondarySelectionBackcolor equals: (Color oliveDrab alpha: 98).
			self assert: view edgeColor equals: Color grayText.
			self assert: view activeHotspotBackcolor equals: Color darkSlateBlue.
			self assert: view activeHotspotForecolor equals: Color lightSkyBlue.
			self assert: view edgeColumn equals: 120.
			self assert: view isCurrentLineHighlighted]
		ifFalse: 
			[self assertIsNil: view selectionForecolor.
			anInteger < 15 ifTrue: [self assert: view selectionBackcolor equals: Color silver]]! !

!ScintillaViewTest categoriesForMethods!
classToTest!helpers!private! !
initializePresenter!public!Running! !
margins!private!unit tests! !
testCallTipColors!public!unit tests! !
testFindStringStartingAt!public!unit tests! !
testImmersiveColorSetChange!public!unit tests! !
testLanguages!public!unit tests! !
testOverrideDefaultKeyBindings!public!unit tests! !
testSetGetAnnotations!public!unit tests! !
testStateRestoral!public!unit tests! !
testStbUpgradeFrom15!public!unit tests! !
verifyUpgradedView:!helpers!private! !
!

!ScintillaViewTest class methodsFor!

resource_Scintilla_view_13
	"Answer the literal data from which the 'Scintilla view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Scintilla_view_13)
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
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Scintilla_view_14b)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ScintillaView) 34 50 0 0 34 2 8 1445007428 1025 416 721990 2 ##(Smalltalk.ValueHolder) 0 false 1310726 ##(Smalltalk.EqualitySearchPolicy) 0 524550 ##(Smalltalk.ColorRef) 8 4278190080 0 5 0 0 0 416 0 8 4294906539 852486 ##(Smalltalk.NullConverter) 0 0 9 0 170 192 34 4 #normal 1182790 1 ##(Smalltalk.ScintillaTextStyle) 1 0 0 1 0 0 0 0 #normal 0 0 0 #callTip 674 77 786694 ##(Smalltalk.IndexedColor) 33554457 722 33554471 1 0 0 0 0 #callTip 0 0 0 34 40 688 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1245510 1 ##(Smalltalk.NullScintillaStyler) #normal 170 192 34 2 #default 1641542 1 ##(Smalltalk.ScintillaMarkerDefinition) 1 0 0 0 416 #circle 0 0 0 0 0 0 138 ##(Smalltalk.IdentitySet) 8 #() 0 170 176 896 9215 0 0 0 0 722 33554447 0 0 65 0 0 0 8 '' 3 170 192 34 2 #container 640 0 0 0 0 1 0 170 192 34 6 1 1510470 2 ##(Smalltalk.ScintillaIndicatorStyle) 1 416 65025 3 false 1 0 0 0 0 0 0 3 1026 3 416 33423361 5 false 3 0 0 0 0 0 0 5 1026 5 416 511 1 false 5 0 0 0 0 0 0 0 0 170 192 34 6 #Notification 674 1029 0 196934 1 ##(Smalltalk.RGB) 31185883 1 0 0 0 0 #Notification 0 0 0 #Warning 674 1027 1138 60239 1138 31326207 1 0 0 0 0 #Warning 0 0 0 #Error 674 1031 1138 335 1138 31317503 1 0 0 0 0 #Error 0 0 0 0 983302 ##(Smalltalk.MessageSequence) 138 144 34 5 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 3839 21 1378 631 501 416 1330 #modificationEventMask: 8 #(4607) 416 1330 #caretPeriod: 8 #(530) 416 1330 #margins: 34 1 34 3 985158 2 ##(Smalltalk.ScintillaMargin) 1 416 1 3 0 0 0 0 1538 3 416 33 0 3 67108863 0 0 1538 5 416 1 0 3 -67108863 0 0 416 1330 #tabWidth: 8 #(4) 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 186 8 0 0 4 1 0 0] 8 #() 1378 193 193 0 29)!

resource_Scintilla_view_15
	"Answer the literal data from which the 'Scintilla view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Scintilla_view_15)
	"

	^#(#'!!STL' 4 985166 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ScintillaView) 34 50 nil nil 34 2 8 1411449156 262145 416 918598 2 ##(Smalltalk.ValueHolder) nil false 1769478 ##(Smalltalk.EqualitySearchPolicy) nil nil nil 21 nil nil nil 416 nil 8 2031697384 1049094 ##(Smalltalk.NullConverter) nil nil 73 1848902001 170 192 34 4 #normal 1444934 1 ##(Smalltalk.ScintillaTextStyle) 1 nil nil 1 nil nil nil nil #normal nil nil nil #callTip 626 77 917510 ##(Smalltalk.Color) #gray 674 #white 1 nil nil nil nil #callTip nil nil nil nil 2032902 ##(Smalltalk.SmalltalkExpressionStyler) 1 nil nil false 138 144 8 #() 170 192 768 138 ##(Smalltalk.IdentitySet) 768 nil 170 176 768 nil nil nil nil nil 674 #silver nil nil 65 nil nil 170 192 34 6 #specialCharacter 8 '()[]<>' #literalArray 8 '()' #literalBytes 8 '[]' 8 '' 1 170 192 34 2 #container 592 nil nil nil nil 208 138 ##(Smalltalk.Set) 34 5 1507846 ##(Smalltalk.ScintillaKeyBinding) 9385 4345 1010 9951 4345 1010 9353 4345 1010 9435 4345 1010 9431 4345 170 192 34 4 #Warning 1772614 3 ##(Smalltalk.ScintillaIndicatorStyle) 17 416 674 #blue 3 false #Warning nil nil nil nil nil nil #Error 1138 19 416 674 #red 3 false #Error nil nil nil nil nil nil nil nil 170 192 34 6 #Notification 626 1029 nil 674 #gainsboro 1 nil nil nil nil #Notification nil nil nil #Warning 626 1027 674 #darkGoldenrod 674 #ivory 1 nil nil nil nil #Warning nil nil nil #Error 626 1031 674 #firebrick 674 #floralWhite 1 nil nil nil nil #Error nil nil nil nil 1310982 ##(Smalltalk.MessageSequence) 138 144 34 8 1049350 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 918022 ##(Smalltalk.Point) 6143 21 1490 371 39 416 1442 #hoverTime: 8 #(500) 416 1442 #caretPeriod: 8 #(530) 416 1442 #margins: 34 1 34 3 1247302 3 ##(Smalltalk.ScintillaMargin) 1 416 1 3 nil nil nil nil 1650 3 416 1 nil nil 67108863 nil nil 1650 5 416 1 nil nil nil nil nil 416 1442 #canHScroll: 8 #(false) 416 1442 #targetRange: 34 1 852742 ##(Smalltalk.Interval) 1 -1 3 416 1442 #maxCompletionListHeight: 8 #(9) 416 1442 #edgeColumn: 8 #(1) 416 1179910 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 184 12 0 0 29 0 0 0] 8 #() 1490 193 193 nil 31)!

resource_Scintilla_view_16
	"Answer the literal data from which the 'Scintilla view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Scintilla_view_16)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ScintillaView) 34 50 nil nil 34 2 8 1445007428 1025 416 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil 327686 ##(Smalltalk.Color) #default nil 5 nil nil nil 416 nil 8 1533163101 852486 ##(Smalltalk.NullConverter) nil nil 9 nil 170 192 34 4 #normal 1182790 1 ##(Smalltalk.ScintillaTextStyle) 1 nil nil 1 nil nil nil nil #normal nil nil nil #callTip 658 77 546 #gray 546 #white 1 nil nil nil nil #callTip nil nil nil nil 1245510 1 ##(Smalltalk.NullScintillaStyler) #normal 170 192 34 2 #default 1641542 2 ##(Smalltalk.ScintillaMarkerDefinition) 1 nil nil nil 416 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 8 #() nil 170 176 848 nil nil nil nil nil 546 #silver nil nil 65 nil nil nil 8 '' 3 170 192 34 2 #container 624 nil nil nil nil 130003 nil 170 192 34 6 1 1510470 3 ##(Smalltalk.ScintillaIndicatorStyle) 1 416 546 #commonGreen 3 false 1 nil nil nil nil nil nil 3 978 3 416 546 #blue 5 false 3 nil nil nil nil nil nil 5 978 5 416 546 #red 1 false 5 nil nil nil nil nil nil nil nil 170 192 34 6 #Warning 658 1027 546 #darkGoldenrod 546 #ivory 1 nil nil nil nil #Warning nil nil nil #Notification 658 1029 nil 546 #gainsboro 1 nil nil nil nil #Notification nil nil nil #Error 658 1031 546 #firebrick 546 #floralWhite 1 nil nil nil nil #Error nil nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 8 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 7039 21 1362 631 501 416 1314 #textLimit: 8 #(1073741823) 416 1314 #caretPeriod: 8 #(530) 416 1314 #margins: 34 1 34 3 985158 3 ##(Smalltalk.ScintillaMargin) 1 416 1 3 nil nil nil nil 1522 3 416 33 nil 3 67108863 nil nil 1522 5 416 1 nil 3 -67108863 nil nil 416 1314 #tabWidth: 8 #(4) 416 1314 #targetRange: 34 1 525062 ##(Smalltalk.Interval) 1 -1 3 416 1314 #maxCompletionListHeight: 8 #(9) 416 1314 #edgeColumn: 8 #(1) 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 191 13 0 0 10 0 0 0 250 14 0 0 4 1 0 0] 8 #() 1362 193 193 nil 29 )! !

!ScintillaViewTest class categoriesForMethods!
resource_Scintilla_view_13!public!resources-views! !
resource_Scintilla_view_14!public!resources-views! !
resource_Scintilla_view_14b!public!resources-views! !
resource_Scintilla_view_15!public!resources-views! !
resource_Scintilla_view_16!public!resources-views! !
!
