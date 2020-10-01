"Filed out from Dolphin Smalltalk 7"!

UI.Tests.AbstractMultilineTextEditTest subclass: #'UI.Scintilla.Tests.ScintillaViewTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{UI.Scintilla.ScintillaConstants})
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Scintilla.Tests.ScintillaViewTest guid: (Core.GUID fromString: '{3c6fbe95-74e0-4325-97e1-82f12133d503}')!
UI.Scintilla.Tests.ScintillaViewTest comment: ''!
!UI.Scintilla.Tests.ScintillaViewTest categoriesForClass!Unclassified! !
!UI.Scintilla.Tests.ScintillaViewTest methodsFor!

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
		add: (KeyBinding newAcceleratorKey: code message: ScintillaConstants.SCI_NULL).
	"Add a binding"
	code := AcceleratorTable keyCodeFromInvariantString: 'CTRL+J'.
	self deny: (bindings includesKey: code).
	binding := KeyBinding newAcceleratorKey: code
				message: ScintillaConstants.SCI_SELECTIONDUPLICATE.
	bindings at: code put: binding.
	expectedDiffs add: binding.
	"Update a binding"
	code := AcceleratorTable keyCodeFromInvariantString: 'CTRL+D'.
	self assert: (bindings includesKey: code).
	binding := KeyBinding newAcceleratorKey: code message: ScintillaConstants.SCI_PAGEDOWN.
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
		add: (Annotation
					line: 1
					text: 'Wobble'
					style: #Error);
		add: (Annotation
					line: 2
					text: 'Wibble'
					style: #Warning);
		add: (Annotation
					line: 1
					text: 'Blah'
					style: #Notification).
	presenter annotations: annotations.
	self assert: (presenter annotations noDifference: annotations)!

testStateRestoral
	| indicStyle1 indicStyle2 |
	"At the moment, just checking that the non-container indicators are reset on state restoral as regression test for #1085"
	indicStyle1:= IndicatorStyle view: presenter index: INDICATOR_CONTAINER - 1.
	self assert: indicStyle1 style equals: #hidden.
	presenter recreate.
	indicStyle2 := IndicatorStyle view: presenter index: INDICATOR_CONTAINER - 1.
	self assert: indicStyle2 style equals: #hidden.
! !
!UI.Scintilla.Tests.ScintillaViewTest categoriesFor: #classToTest!helpers!private! !
!UI.Scintilla.Tests.ScintillaViewTest categoriesFor: #initializePresenter!public!Running! !
!UI.Scintilla.Tests.ScintillaViewTest categoriesFor: #margins!private!unit tests! !
!UI.Scintilla.Tests.ScintillaViewTest categoriesFor: #testCallTipColors!public!unit tests! !
!UI.Scintilla.Tests.ScintillaViewTest categoriesFor: #testFindStringStartingAt!public!unit tests! !
!UI.Scintilla.Tests.ScintillaViewTest categoriesFor: #testImmersiveColorSetChange!public!unit tests! !
!UI.Scintilla.Tests.ScintillaViewTest categoriesFor: #testLanguages!public!unit tests! !
!UI.Scintilla.Tests.ScintillaViewTest categoriesFor: #testOverrideDefaultKeyBindings!public!unit tests! !
!UI.Scintilla.Tests.ScintillaViewTest categoriesFor: #testSetGetAnnotations!public!unit tests! !
!UI.Scintilla.Tests.ScintillaViewTest categoriesFor: #testStateRestoral!public!unit tests! !

