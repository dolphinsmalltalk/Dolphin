"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'UI.Scintilla.Tests.IndicatorDefinitionTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Scintilla.Tests.IndicatorDefinitionTest guid: (Core.GUID fromString: '{f9336218-5504-41d4-bf04-d9bbe66ecfbe}')!
UI.Scintilla.Tests.IndicatorDefinitionTest comment: ''!
!UI.Scintilla.Tests.IndicatorDefinitionTest methodsFor!

testDefaults
	| view subject |
	view := MockScintillaView new.
	view resetMessages.
	subject := IndicatorDefinition new.
	self assert: subject style identicalTo: #hidden.
	self assert: subject isUnderText.
	self assert: subject alpha equals: 30.
	self assert: subject foreAlpha equals: 50.
	self assert: subject strokeWidth equals: 1.
	self assert: subject hoverStyle identicalTo: #hidden.
	self assert: subject hoverForecolor identicalTo: Color black.
	subject initializeView: view.
	"The default of the control is to draw indicators over, but a better default is under  (see IndicatorDefinition>>#isUnderText), so this has to be set"
	self assert: view messages asArray equals: { { SCI_INDICSETUNDER. nil. 1 } }.

	"Now really all defaults - should send nothing"
	subject isUnderText: false.
	view resetMessages.
	subject initializeView: view.
	self assert: view messages asArray equals: #().

	"All values should be passed for an update of the whole definition, even though defaults, aside from the hover settings as these track the base settings when nil"
	view resetMessages.
	subject applyToView: view.
	self assert: view messages asArray
		equals: {
				{ SCI_INDICSETFORE. nil. 0 }.
				{ SCI_INDICSETSTYLE. nil. INDIC_HIDDEN }.
				{ SCI_INDICSETUNDER. nil. 0 }.
				{ SCI_INDICSETALPHA. nil. 30 }.
				{ SCI_INDICSETFLAGS. nil. 0 }.
				{ SCI_INDICSETOUTLINEALPHA. nil. 50 }.
				{ SCI_INDICSETSTROKEWIDTH. nil. 100 }
			}
	"Hover settings do not need to be set"!

testHoverStyleAndColor
	"The control updates the hoverForecolor and hoverStyle when the base forecolor and style are set, so we have to have a rather complex set of transitions.
	If it had the notion of 'not set' or 'inherit' for properties, all this would be simpler."

	| view subject forecolor expected |
	view := MockScintillaView new.
	view resetMessages.
	forecolor := Color oliveDrab.
	subject := IndicatorDefinition
				name: #foo
				style: #roundBox
				forecolor: forecolor.
	self assert: subject printString
		equals: 'a Scintilla.IndicatorDefinition(0:#foo, forecolor=Color oliveDrab, style=#roundBox, isUnderText=true)'.
	subject isUnderText: false.
	self assert: subject printString
		equals: 'a Scintilla.IndicatorDefinition(0:#foo, forecolor=Color oliveDrab, style=#roundBox)'.
	subject initializeView: view.
	"Both values are non-defaults, so passed through"
	self assert: view messages asArray
		equals: { { SCI_INDICSETFORE. nil. forecolor rgbCode }. { SCI_INDICSETSTYLE. nil. INDIC_ROUNDBOX } }.
	"Black is the default, but because we are setting it after initialization we expect it to be sent to the view"
	view resetMessages.
	subject
		forecolor: Color black;
		style: #hidden.
	self assert: subject printString equals: 'a Scintilla.IndicatorDefinition(0:#foo)'.
	self assert: view messages asArray
		equals: { { SCI_INDICSETFORE. nil. 0 }. { SCI_INDICSETSTYLE. nil. INDIC_HIDDEN} }.
	"Change the hoverStyle and forecolor to something different"
	view resetMessages.
	subject
		hoverForecolor: Color red;
		hoverStyle: #tt.
	self assert: subject printString
		equals: 'a Scintilla.IndicatorDefinition(0:#foo, hoverForecolor=Color red, hoverStyle=#tt)'.
	expected := {
				{ SCI_INDICSETHOVERFORE. nil. Color red rgbCode }.
				{ SCI_INDICSETHOVERSTYLE. nil. INDIC_TT }
			}.
	self assert: view messages asArray equals: expected.
	"Now initialize the view with all defaults except the hover"
	view resetMessages.
	subject initializeView: view.
	self assert: view messages asArray equals: expected.
	"Now set the style again - also needs to reapply the hover style"
	view resetMessages.
	subject style: #hatch.
	self assert: subject printString equals: 'a Scintilla.IndicatorDefinition(0:#foo, style=#hatch, hoverForecolor=Color red, hoverStyle=#tt)'.
	self assert: view messages asArray
		equals: { { SCI_INDICSETSTYLE. nil. INDIC_DIAGONAL }. { SCI_INDICSETHOVERSTYLE. nil. INDIC_TT } }.
	"But if we set it to the same value, then the base style should carry through and we don't need to set the hoverStyle again"
	view resetMessages.
	subject style: #tt.
	self assert: subject printString equals: 'a Scintilla.IndicatorDefinition(0:#foo, style=#tt, hoverForecolor=Color red)'.
	self assertIsNil: subject basicHoverStyle.
	self assert: subject hoverStyle identicalTo: #tt.
	self assert: view messages asArray equals: { { SCI_INDICSETSTYLE. nil. INDIC_TT } }.
	"Now the same, so don't need to set both on init"
	view resetMessages.
	subject initializeView: view.
	"Initializing the hoverstyle to the same setting as the base style isn't needed"
	self assert: view messages asArray
		equals: { { SCI_INDICSETSTYLE. nil. INDIC_TT }. { SCI_INDICSETHOVERFORE. nil. Color red rgbCode } }.
	"Similarly forecolor/hoverForecolor"
	view resetMessages.
	subject forecolor: Color green.
	self assert: subject printString
		equals: 'a Scintilla.IndicatorDefinition(0:#foo, forecolor=Color green, style=#tt, hoverForecolor=Color red)'.
	self assert: view messages asArray
		equals: {
				{ SCI_INDICSETFORE. nil. Color green rgbCode }.
				{ SCI_INDICSETHOVERFORE. nil. Color red rgbCode }
			}.
	"but if we set it to the same...now the hoverForecolor inherits again"
	view resetMessages.
	subject forecolor: Color red.
	self assertIsNil: subject basicHoverForecolor.
	self assert: subject hoverForecolor equals: Color red.
	self assert: subject printString
		equals: 'a Scintilla.IndicatorDefinition(0:#foo, forecolor=Color red, style=#tt)'.
	self assert: view messages asArray equals: { { SCI_INDICSETFORE. nil. Color red rgbCode } }.
	view resetMessages.
	subject forecolor: Color green.
	self assertIsNil: subject basicHoverForecolor.
	self assert: subject hoverForecolor equals: Color green.
	self assert: subject printString
		equals: 'a Scintilla.IndicatorDefinition(0:#foo, forecolor=Color green, style=#tt)'.
	self assert: view messages asArray equals: { { SCI_INDICSETFORE. nil. Color green rgbCode } }.
	"Now change the hover style again"
	view resetMessages.
	subject hoverStyle: #roundBox.
	self assert: subject printString
		equals: 'a Scintilla.IndicatorDefinition(0:#foo, forecolor=Color green, style=#tt, hoverStyle=#roundBox)'.
	self assert: view messages asArray equals: { { SCI_INDICSETHOVERSTYLE. nil. INDIC_ROUNDBOX } }.
	"Changing it back to inherit base style still needs to send a message, since we are changing only it"
	view resetMessages.
	subject hoverStyle: subject style.
	self assertIsNil: subject basicHoverStyle.
	self assert: view messages asArray equals: { { SCI_INDICSETHOVERSTYLE. nil. INDIC_TT } }.
	"Now change the hover forecolor again"
	view resetMessages.
	subject hoverForecolor: Color purple.
	self assert: subject printString
		equals: 'a Scintilla.IndicatorDefinition(0:#foo, forecolor=Color green, style=#tt, hoverForecolor=Color purple)'.
	self assert: view messages asArray equals: { { SCI_INDICSETHOVERFORE. nil. Color purple rgbCode } }.
	"Changing it back to inherit base style still needs to send a message, since we are changing only it"
	view resetMessages.
	subject hoverForecolor: subject forecolor.
	self assertIsNil: subject basicHoverForecolor.
	self assert: view messages asArray
		equals: { { SCI_INDICSETHOVERFORE. nil. subject forecolor rgbCode } }!

testStyle
	| view subject |
	view := MockScintillaView new.
	view resetMessages.
	subject := IndicatorDefinition new.
	subject isUnderText: false.
	self assert: subject style identicalTo: #hidden.
	subject initializeView: view.
	self assert: view messages asArray equals: #().
	subject style: #roundBox.
	self assert: subject basicStyle equals: INDIC_ROUNDBOX.
	self assert: view messages asArray equals: { { SCI_INDICSETSTYLE. nil. INDIC_ROUNDBOX } }.
	view resetMessages.
	subject initializeView: view.
	self assert: view messages asArray equals: { { SCI_INDICSETSTYLE. nil. INDIC_ROUNDBOX } }.
	view resetMessages.
	self should: [subject style: #foo] raise: Error matching: [:ex | ex messageText = 'value not found: #foo'].
	self assert: view messages asArray equals: #().
	subject style: nil.
	self assert: subject style identicalTo: #hidden.
	self assert: view messages asArray equals: { { SCI_INDICSETSTYLE. nil. INDIC_HIDDEN } }.
! !
!UI.Scintilla.Tests.IndicatorDefinitionTest categoriesForMethods!
testDefaults!public!unit tests! !
testHoverStyleAndColor!public!unit tests! !
testStyle!public!unit tests! !
!

