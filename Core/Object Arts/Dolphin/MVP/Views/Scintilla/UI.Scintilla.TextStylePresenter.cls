"Filed out from Dolphin Smalltalk"!

UI.ValuePresenter
	subclass: #'UI.Scintilla.TextStylePresenter'
	instanceVariableNames: 'facePresenter pointSizePresenter forecolorPresenter backcolorPresenter isItalicPresenter isBoldPresenter isUnderlinedPresenter casePresenter characterSetPresenter previewPresenter fillToEndOfLinePresenter normalStyle defaultStyle isInvisiblePresenter isHotspotPresenter isReadOnlyPresenter namePresenter idPresenter'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Scintilla.TextStylePresenter guid: (Core.GUID fromString: '{e352dfcb-7063-4b89-9958-074e8500392f}')!
UI.Scintilla.TextStylePresenter comment: 'ScintillaTextStylePresenter provides a detail presentation of a <ScintillaTextStyle>, and can be used to view and modify the settings of that style such as the font, foreground and background colours, etc.

Instance Variables:
	facePresenter			<ChoicePresenter>. Font face name.
	pointSizePresenter		<NumberPresenter>. Font point size.
	forecolorPresenter		<ColorPresenter>. Text foreground colour.
	backcolorPresenter		<ColorPresenter>. Text background colour.
	isItalicPresenter			<BooleanPresenter>. Whether font is italic, non-italic, or unspecified.
	isBoldPresenter			<BooleanPresenter>. Whether font is bold, normal weight, or unspecified.
	isUnderlinedPresenter	<BooleanPresenter>. Whether font is underlined, normal, or unspecified.
	casePresenter			<ChoicePresenter>. Whether font is mixed, all-upper or all-lower case.
	characterSetPresenter		<ChoicePresenter>. The character set specified for the font.
	previewPresenter			<ScintillaView> used to preview the style.
	fillToEndOfLinePresenter	<BooleanPresenter>. Whether the backcolour is applied to the end of the window line if after the end of text.
	normalStyle				<ScintillaTextStyle>. The #normal style. Significant because its settings are inherited by other styles.
	defaultStyle				<ScintillaTextStyle>. The default style expected to be inherited from the view at runtime.
	isInvisiblePresenter		<BooleanPresenter>. Whether the text is visible, invisible, or unspecified.
	isHotspotPresenter		<BooleanPresenter>. Whether the text acts like a hotspot when the mouse moves over it, or not, or unspecified.
	isReadOnlyPresenter		<BooleanPresenter>. Whether the text is read-only, read-write, or unspecified.
	namePresenter			<TextPresenter>. The symbolic name of the style, as used by the application.
	idPresenter				<TextPresenter>. The numeric id associated with the style, for identifying the style to Scintilla and by lexers.'!
!UI.Scintilla.TextStylePresenter categoriesForClass!MVP-Presenters!MVP-Resources-IDE Tools! !
!UI.Scintilla.TextStylePresenter methodsFor!

applyDefaultStyle
	| style preview |
	(previewPresenter notNil and: [previewPresenter isOpen]) ifFalse: [^self].
	preview := previewPresenter view.
	style := self defaultStyle.
	preview
		font: style font;
		forecolor: style forecolor;
		backcolor: style backcolor!

buildDefaultStyle
	| style desktop |
	style := TextStyle new.
	desktop := View desktop.
	style
		font: desktop actualFont;
		forecolor: desktop forecolor;
		backcolor: Color.Window.
	^style!

chooseBackcolor
	(ColorDialog on: backcolorPresenter model)
		caption: 'Background Color';
		showModal!

chooseForecolor
	(ColorDialog on: forecolorPresenter model)
		caption: 'Foreground Color';
		showModal!

createComponents
	"Create the presenters contained by the receiver"

	| nonVerticalFonts |
	super createComponents.
	namePresenter := self add: TextPresenter new name: 'name'.
	idPresenter := self add: TextPresenter new name: 'id'.
	nonVerticalFonts := Canvas forDesktop fontNames reject: [:each | each first = $@].
	facePresenter := self add: (ChoicePresenter new
						choices: (nonVerticalFonts asSortedCollection asOrderedCollection
									addFirst: nil;
									yourself);
						yourself)
				name: 'faceName'.
	pointSizePresenter := self add: NumberPresenter new name: 'pointSize'.
	casePresenter := self add: ChoicePresenter new name: 'case'.
	casePresenter choices: #(nil) , TextStyle caseNames.
	characterSetPresenter := self add: ChoicePresenter new name: 'charSet'.
	forecolorPresenter := self add: ColorPresenter new name: 'forecolor'.
	backcolorPresenter := self add: ColorPresenter new name: 'backcolor'.
	isItalicPresenter := self add: BooleanPresenter new name: 'isItalic'.
	isBoldPresenter := self add: BooleanPresenter new name: 'isBold'.
	isUnderlinedPresenter := self add: BooleanPresenter new name: 'isUnderlined'.
	fillToEndOfLinePresenter := self add: BooleanPresenter new name: 'isBackcolorExtendedToEndOfLine'.
	previewPresenter := self add: TextPresenter new name: 'preview'.
	isInvisiblePresenter := self add: BooleanPresenter new name: 'isInvisible'.
	isReadOnlyPresenter := self add: BooleanPresenter new name: 'isReadOnly'.
	isHotspotPresenter := self add: BooleanPresenter new name: 'isHotspot'!

defaultStyle
	^defaultStyle ifNil: [self buildDefaultStyle]!

defaultStyle: aScintillaTextStyle 
	defaultStyle := aScintillaTextStyle.
	self applyDefaultStyle!

isEnabled: aBoolean
	self view isEnabledDeeply: aBoolean!

model: aValueHolder 
	"Set the model associated with the receiver."

	| value |
	self model removeEventsTriggeredFor: self.
	value := aValueHolder ifNil: [self normalStyle asValue].
	super model: value.
	namePresenter model: (value aspectValue: #name).
	idPresenter model: (value aspectValue: #id).
	facePresenter model: (value aspectValue: #fontName).
	casePresenter model: (value aspectValue: #caseName).
	characterSetPresenter model: (value aspectValue: #characterSet).
	forecolorPresenter model: (value aspectValue: #forecolor).
	backcolorPresenter model: (value aspectValue: #backcolor).
	isBoldPresenter model: (value aspectValue: #isBold).
	isItalicPresenter model: (value aspectValue: #isItalic).
	isUnderlinedPresenter model: (value aspectValue: #isUnderlined).
	pointSizePresenter model: (value aspectValue: #pointSize).
	(self view viewNamed: 'pointSizeSpinner') model: pointSizePresenter model.
	fillToEndOfLinePresenter model: (value aspectValue: #isBackcolorExtendedToEndOfLine).
	previewPresenter model: (value aspectValue: #description).
	isHotspotPresenter model: (value aspectValue: #isHotspot).
	isReadOnlyPresenter model: (value aspectValue: #isReadOnly).
	isInvisiblePresenter model: (value aspectValue: #isInvisible).
!

normalStyle
	normalStyle isNil ifTrue: [normalStyle := TextStyle normal].
	^normalStyle!

normalStyle: aScintillaTextStyle 
	normalStyle := aScintillaTextStyle.
	self onValueChanged!

onValueChanged
	| preview previewStyle style |
	previewPresenter isOpen ifFalse: [^self].
	style := self model value copy.
	namePresenter view isReadOnly: style isPredefined.
	preview := previewPresenter view.
	previewStyle := #preview.
	style name == #lineNumber
		ifTrue: 
			[previewStyle := #normal.
			preview hasLineNumbers: true]
		ifFalse: 
			[preview hasLineNumbers: false.
			style name: previewStyle].
	self applyDefaultStyle.
	preview styler normalStyleName: previewStyle.
	style id: style id.
	preview textStyles: {self normalStyle. style}.
	super onValueChanged!

onViewOpened
	super onViewOpened.
	self onValueChanged! !
!UI.Scintilla.TextStylePresenter categoriesForMethods!
applyDefaultStyle!private!updating! !
buildDefaultStyle!helpers!private! !
chooseBackcolor!commands!private! !
chooseForecolor!commands!private! !
createComponents!initializing!public! !
defaultStyle!accessing!public! !
defaultStyle:!accessing!public! !
isEnabled:!accessing!public! !
model:!accessing!private! !
normalStyle!accessing!public! !
normalStyle:!accessing!public! !
onValueChanged!event handling!public! !
onViewOpened!event handling!public! !
!

!UI.Scintilla.TextStylePresenter class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it is initialized."

	^TextStyle normal asValue!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.ContainerView} 38 #{Core.Array} 15 nil nil 50 2 8 1409286144 131073 32 nil nil nil 517 nil 1030 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 518 #{Graphics.Point} 193 193 nil 32 838 1 #{UI.FlowLayout} 11 11 17 550 #{Core.IdentityDictionary} 0 518 #{Graphics.Rectangle} 194 1 21 194 1 21 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createAt:extent: 50 2 194 6143 21 194 471 711 32 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 234 12 0 0 109 1 0 0] 50 4 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 544 nil nil nil 5 nil nil nil 544 226 11 1 9 258 2 18 #{UI.TextEdit} 50 20 nil 544 50 2 8 1140916352 1025 640 nil 6 #{Graphics.Color} #default nil 5 nil nil nil 640 nil 8 1853175488 518 #{UI.NullConverter} nil nil 35 #focusLost nil nil nil 354 50 1 402 #createAt:extent: 50 2 194 395 1 194 61 39 640 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 197 0 0 0 0 0 0 0 227 0 0 0 19 0 0 0] 8 #() 194 193 193 nil 45 8 'id' 18 #{UI.TextEdit} 50 20 nil 544 50 2 8 1140916352 1025 960 nil 720 nil 5 nil nil nil 960 nil 8 1853175488 754 nil nil 35 #focusLost nil nil nil 354 50 2 402 #createAt:extent: 50 2 194 93 1 194 259 39 960 402 #text: 50 1 8 'Name of style' 960 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 46 0 0 0 0 0 0 0 175 0 0 0 19 0 0 0] 8 #() 928 nil 45 8 'name' 290 194 21 1 194 1 1 354 50 1 402 #createAt:extent: 50 2 194 1 21 194 471 39 544 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 10 0 0 0 235 0 0 0 29 0 0 0] 50 4 18 #{UI.StaticText} 50 16 nil 544 50 2 8 1140850956 1 1456 nil nil nil 5 nil nil nil 1456 nil 8 1853387904 754 nil nil nil 354 50 2 402 #createAt:extent: 50 2 194 21 7 194 63 27 1456 402 #text: 50 1 8 'Name:' 1456 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 3 0 0 0 41 0 0 0 16 0 0 0] 8 #() 928 nil 27 960 18 #{UI.StaticText} 50 16 nil 544 50 2 8 1140850955 1 1744 nil nil nil 5 nil nil nil 1744 nil 8 1853387904 754 nil nil nil 354 50 2 402 #createAt:extent: 50 2 194 361 7 194 25 27 1744 402 #text: 50 1 8 'Id:' 1744 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 180 0 0 0 3 0 0 0 192 0 0 0 16 0 0 0] 8 #() 928 nil 27 640 928 nil 27 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 2032 nil nil nil 5 nil nil nil 2032 262 #{UI.FramingLayout} 550 #{Core.LookupTable} 12 18 #{UI.ColorView} 50 16 nil 2032 50 2 8 1140850944 262145 2160 1094 2 #{UI.ValueHolder} nil false 6 #{Kernel.NeverSearchPolicy} nil nil nil 5 nil nil nil 2160 nil 8 1853387904 754 nil nil nil 354 50 1 402 #createAt:extent: 50 2 194 21 159 194 91 43 2160 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 79 0 0 0 55 0 0 0 100 0 0 0] 8 #() 928 nil 27 2118 2 #{UI.FramingConstraints} 1030 #{UI.FramingCalculation} #fixedPreviousLeft 1 2498 #fixedViewLeft 91 2498 #fixedPreviousBottom 5 2498 #fixedViewTop 43 18 #{UI.ComboBox} 50 17 nil 2032 50 2 8 1144063491 1025 2576 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} 720 nil 5 nil nil nil 2576 nil 8 1852792128 518 #{Core.Message} #displayString 8 #() 8 #() 401 354 50 1 402 #createAt:extent: 50 2 194 183 159 194 185 43 2576 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 91 0 0 0 79 0 0 0 183 0 0 0 100 0 0 0] 8 #() 928 nil 27 2466 2512 1 2528 185 2544 5 2560 43 18 #{UI.ComboBox} 50 17 nil 2032 50 2 8 1152583170 1 2976 2642 2674 0 nil 2720 720 nil 5 nil nil nil 2976 nil 8 1852792128 2754 #displayString 8 #() 2800 401 354 50 1 402 #createAt:extent: 50 2 194 21 71 194 285 43 2976 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 35 0 0 0 152 0 0 0 56 0 0 0] 8 #() 928 nil 27 2466 2512 1 2528 285 2544 5 2560 43 18 #{UI.ContainerView} 50 15 nil 2032 50 2 8 1140850688 131073 3280 nil nil nil 5 nil nil nil 3280 226 1 1 1 258 3 18 #{UI.CheckBox} 50 16 nil 3280 50 2 8 1140924422 1 3376 2226 nil nil 2272 false nil nil 5 nil 114 nil true 262 #{OS.LOGFONT} 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 1 2 1 34 77 83 32 83 97 110 115 32 83 101 114 105 102 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 194 193 193 nil 3376 nil 8 1853182784 754 nil nil nil 354 50 2 402 #createAt:extent: 50 2 194 1 1 194 135 29 3376 402 #text: 50 1 8 '&Bold' 3376 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 67 0 0 0 14 0 0 0] 8 #() 928 nil 27 8 'isBold' 18 #{UI.CheckBox} 50 16 nil 3280 50 2 8 1140924422 1 3776 2226 nil nil 2272 false nil nil 5 nil 114 nil true 3474 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 1 0 0 1 2 1 34 77 83 32 83 97 110 115 32 83 101 114 105 102 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 194 193 193 nil 3776 nil 8 1853182784 754 nil nil nil 354 50 2 402 #createAt:extent: 50 2 194 255 1 194 147 29 3776 402 #text: 50 1 8 '&Underlined' 3776 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 0 0 0 0 0 0 0 200 0 0 0 14 0 0 0] 8 #() 928 nil 27 8 'isUnderlined' 18 #{UI.CheckBox} 50 16 nil 3280 50 2 8 1140924422 1 4160 2226 nil nil 2272 false nil nil 5 nil 114 nil true 3474 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 1 0 0 0 1 2 1 34 77 83 32 83 97 110 115 32 83 101 114 105 102 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 194 193 193 nil 4160 nil 8 1853182784 754 nil nil nil 354 50 2 402 #createAt:extent: 50 2 194 135 1 194 121 29 4160 402 #text: 50 1 8 '&Italic' 4160 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 67 0 0 0 0 0 0 0 127 0 0 0 14 0 0 0] 8 #() 928 nil 27 8 'isItalic' 290 194 1 1 194 11 1 354 50 1 402 #createAt:extent: 50 2 194 21 225 194 431 29 3280 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 112 0 0 0 225 0 0 0 126 0 0 0] 50 3 3376 4160 3776 928 nil 27 2466 2498 #fixedParentLeft 1 2498 #fixedParentRight 1 2544 25 2498 #fixedParentBottom -25 18 #{UI.GroupBox} 50 14 nil 2032 50 2 8 1140850695 65 4800 nil nil nil 5 nil nil nil 4800 nil 8 1853182784 354 50 2 402 #createAt:extent: 50 2 194 1 1 194 471 279 4800 402 #text: 50 1 8 'Text' 4800 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 235 0 0 0 139 0 0 0] 8 #() 928 nil 27 2466 4752 -19 4768 21 2498 #fixedParentTop 1 4784 1 18 #{UI.PushButton} 50 20 nil 2032 50 2 8 1140924416 1 5104 nil 720 nil 5 nil nil nil 5104 nil 8 1853182784 1350 4 #{UI.CommandDescription} #chooseForecolor 8 '…' 1 1 nil nil false nil nil nil 354 50 2 402 #createAt:extent: 50 2 194 121 159 194 41 43 5104 402 #text: 50 1 8 '…' 5104 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 60 0 0 0 79 0 0 0 80 0 0 0 100 0 0 0] 8 #() 928 nil 29 2466 2498 #fixedPreviousRight 11 2528 41 2498 #fixedPreviousTop 1 2544 1 18 #{UI.SpinButton} 50 15 nil 2032 50 2 8 1140916276 1 5472 2226 nil nil 518 #{Kernel.PluggableSearchPolicy} 2754 #= 8 #() 2754 #hash 8 #() 1 720 nil 5 nil nil nil 5472 nil 8 1853096016 754 nil nil 354 50 3 402 #createAt:extent: 50 2 194 393 71 194 31 43 5472 402 #setRange: 50 1 774 #{Core.Interval} 3 201 3 5472 402 #udmSetAccel: 50 1 1350 1 #{External.StructureArray} 8 #[0 0 0 0 1 0 0 0 2 0 0 0 5 0 0 0 5 0 0 0 20 0 0 0] 7 #{OS.UDACCEL} nil 17 5472 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 196 0 0 0 35 0 0 0 211 0 0 0 56 0 0 0] 8 #() 928 nil 27 2466 5440 1 2528 31 5456 1 2544 1 18 #{UI.StaticText} 50 16 nil 2032 50 2 8 1140916492 1 5984 2226 nil false 6 #{Kernel.EqualitySearchPolicy} nil nil nil 5 nil nil nil 5984 nil 8 1853387904 754 nil nil nil 354 50 2 402 #createAt:extent: 50 2 194 183 129 194 61 27 5984 402 #text: 50 1 8 'C&ase:' 5984 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 91 0 0 0 64 0 0 0 121 0 0 0 77 0 0 0] 8 #() 928 nil 27 2466 5440 23 2528 61 5456 -29 2560 27 18 #{UI.StaticText} 50 16 nil 2032 50 2 8 1140850956 1 6336 nil nil nil 5 nil nil nil 6336 nil 8 1853387904 754 nil nil nil 354 50 2 402 #createAt:extent: 50 2 194 21 41 194 61 27 6336 402 #text: 50 1 8 '&Font:' 6336 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 20 0 0 0 40 0 0 0 33 0 0 0] 8 #() 928 nil 27 2466 4752 1 2528 61 5088 41 2560 27 18 #{UI.StaticText} 50 16 nil 2032 50 2 8 1140916492 1 6640 2226 nil false 6080 nil nil nil 5 nil nil nil 6640 nil 8 1853387904 754 nil nil nil 354 50 2 402 #createAt:extent: 50 2 194 21 129 194 61 27 6640 402 #text: 50 1 8 '&Color:' 6640 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 64 0 0 0 40 0 0 0 77 0 0 0] 8 #() 928 nil 27 2466 4752 1 2528 61 2544 17 2560 27 18 #{UI.StaticText} 50 16 nil 2032 50 2 8 1140916492 1 6960 2226 nil false 6080 nil nil nil 5 nil nil nil 6960 nil 8 1853387904 754 nil nil nil 354 50 2 402 #createAt:extent: 50 2 194 329 41 194 61 27 6960 402 #text: 50 1 8 '&Size:' 6960 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 164 0 0 0 20 0 0 0 194 0 0 0 33 0 0 0] 8 #() 928 nil 27 2466 5440 25 2528 61 5456 -29 2560 27 18 #{UI.TextEdit} 50 20 nil 2032 50 2 8 1140924544 1025 7280 nil 706 #window nil 5 nil nil nil 7280 nil 8 1853175488 1094 1 #{UI.IntegerToText} nil 8 '' 326 1 #{Core.Locale} #userDefault nil 1 #focusLost nil nil nil 354 50 2 402 #createAt:extent: 50 2 194 329 71 194 1 43 7280 402 #text: 50 1 8 '0' 7280 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 164 0 0 0 35 0 0 0 164 0 0 0 56 0 0 0] 8 #() 928 nil 45 2466 2512 1 2528 65 2544 5 2560 43 258 5 2160 8 'forecolor' 2576 8 'case' 2976 8 'faceName' 5472 8 'pointSizeSpinner' 7280 8 'pointSize' 290 194 21 1 194 21 1 354 50 1 402 #createAt:extent: 50 2 194 1 69 194 471 279 2032 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 34 0 0 0 235 0 0 0 173 0 0 0] 50 12 4800 6336 2976 6960 7280 5472 6640 2160 5104 5984 2576 3280 928 nil 27 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 7952 nil nil nil 5 nil nil nil 7952 2098 2130 5 18 #{UI.CheckBox} 50 16 nil 7952 50 2 8 1140924422 1 8048 2226 nil nil 2272 false nil nil 5 nil nil nil 8048 nil 8 1853182784 754 nil nil nil 354 50 2 402 #createAt:extent: 50 2 194 191 71 194 211 31 8048 402 #text: 50 1 8 'Fill to &end of line' 8048 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 95 0 0 0 35 0 0 0 200 0 0 0 50 0 0 0] 8 #() 928 nil 27 2466 5440 31 2528 211 5456 3 2560 31 18 #{UI.ColorView} 50 16 nil 7952 50 2 8 1140850944 262145 8368 2226 nil false 2272 nil nil nil 5 nil nil nil 8368 nil 8 1853387904 754 nil nil nil 354 50 1 402 #createAt:extent: 50 2 194 21 69 194 91 43 8368 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 34 0 0 0 55 0 0 0 55 0 0 0] 8 #() 928 nil 27 2466 2512 1 2528 91 2544 5 2560 43 18 #{UI.GroupBox} 50 14 nil 7952 50 2 8 1140850695 65 8640 nil nil nil 5 nil nil nil 8640 nil 8 1853182784 354 50 2 402 #createAt:extent: 50 2 194 1 1 194 471 137 8640 402 #text: 50 1 8 'Background' 8640 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 235 0 0 0 68 0 0 0] 8 #() 928 nil 27 2466 4752 -19 4768 21 5088 1 4784 1 18 #{UI.PushButton} 50 20 nil 7952 50 2 8 1141055488 1 8928 nil 720 nil 5 nil nil nil 8928 nil 8 1853182784 5186 #chooseBackcolor 8 '…' 1 1 nil nil false nil nil nil 354 50 2 402 #createAt:extent: 50 2 194 121 69 194 41 43 8928 402 #text: 50 1 8 '…' 8928 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 60 0 0 0 34 0 0 0 80 0 0 0 55 0 0 0] 8 #() 928 nil 29 2466 5440 11 2528 41 5456 1 2544 1 18 #{UI.StaticText} 50 16 nil 7952 50 2 8 1140850956 1 9248 nil nil nil 5 nil nil nil 9248 nil 8 1853387904 754 nil nil nil 354 50 2 402 #createAt:extent: 50 2 194 21 39 194 61 27 9248 402 #text: 50 1 8 'C&olor:
' 9248 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 19 0 0 0 40 0 0 0 32 0 0 0] 8 #() 928 nil 27 2466 4752 1 2528 61 5088 39 2560 27 258 2 8048 8 'isBackcolorExtendedToEndOfLine' 8368 8 'backcolor' 290 194 21 1 194 21 1 354 50 1 402 #createAt:extent: 50 2 194 1 357 194 471 137 7952 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 178 0 0 0 235 0 0 0 246 0 0 0] 50 5 8640 9248 8368 8928 8048 928 nil 27 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 9792 nil nil nil 5 nil nil nil 9792 1798 #{UI.BorderLayout} 1 11 18 #{UI.StaticText} 50 16 nil 9792 50 2 8 1140850956 1 9888 2226 nil false 6080 nil nil nil 5 nil nil nil 9888 nil 8 1853387904 754 nil nil nil 354 50 2 402 #createAt:extent: 50 2 194 21 5 194 435 27 9888 402 #text: 50 1 8 'Preview:' 9888 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 2 0 0 0 227 0 0 0 15 0 0 0] 8 #() 928 nil 27 nil nil nil 18 #{UI.Scintilla.ScintillaView} 50 56 nil 9792 50 2 8 1174409476 262145 10192 2226 nil false 6080 nil 720 nil 5 nil nil nil 10192 nil 8 1367644576 754 nil 8 '' 43 #focusLost nil nil nil nil 258 3 #callTip 3142 1 #{UI.Scintilla.TextStyle} 77 706 #gray 706 #white 1 nil nil nil nil #callTip nil nil nil #indentGuide 10338 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil #normal 10338 1 nil nil 1 nil nil nil nil #normal nil nil nil nil 326 1 #{UI.Scintilla.NullStyler} #preview 258 0 294 #{Core.IdentitySet} 0 nil 2130 0 9215 nil nil 2130 1 81 706 #windowText nil nil 262 #{UI.Scintilla.NullScintillaLibrary} nil 65 nil nil nil nil 3 258 1 #container 10320 nil nil nil nil #{Core.AnsiString} nil 258 0 nil nil 258 0 nil nil nil 354 50 8 402 #createAt:extent: 50 2 194 21 41 194 435 151 10192 402 #text: 50 1 8 '-- Abcdefghijklm … 
	…  nopqrstuvwxyz --' 10192 402 #setMarginWidths: 50 1 8 #(5 5) 10192 402 #wordWrap: 8 #(true) 10192 402 #margins: 50 1 50 3 2118 3 #{UI.Scintilla.Margin} 1 10192 nil 3 nil nil nil nil 10914 3 10192 nil nil nil 67108863 nil nil 10914 5 10192 nil nil nil nil nil nil 10192 402 #sciSetIndentationGuides: 8 #(1) 10192 402 #targetRange: 50 1 5810 3 87 3 10192 402 #maxCompletionListHeight: 8 #(9) 10192 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 20 0 0 0 227 0 0 0 95 0 0 0] 8 #() 928 nil 45 258 1 10192 8 'preview' 290 194 21 5 194 17 1 354 50 1 402 #createAt:extent: 50 2 194 1 503 194 471 191 9792 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 251 0 0 0 235 0 0 0 90 1 0 0] 50 2 9888 10192 928 nil 27 928 nil 27)!

resource_Developer_view
	"Answer the literal data from which the 'Developer view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Developer_view)
	"

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.ContainerView} 38 #{Core.Array} 15 nil nil 50 2 8 1409286144 131073 32 nil nil nil 517 nil 1030 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 518 #{Graphics.Point} 193 193 nil 32 838 1 #{UI.FlowLayout} 11 21 17 550 #{Core.IdentityDictionary} 0 518 #{Graphics.Rectangle} 194 1 21 194 1 21 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createAt:extent: 50 2 194 6143 21 194 485 791 32 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 241 12 0 0 149 1 0 0] 50 4 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 544 nil nil nil 5 nil nil nil 544 226 11 1 9 258 2 18 #{UI.TextEdit} 50 20 nil 544 50 2 8 1140916352 1025 640 nil 6 #{Graphics.Color} #default nil 5 nil nil nil 640 nil 8 1853175488 518 #{UI.NullConverter} nil nil 1 #focusLost nil nil nil 354 50 2 402 #createAt:extent: 50 2 194 93 1 194 255 39 640 402 #text: 50 1 8 'Name of style' 640 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 46 0 0 0 0 0 0 0 173 0 0 0 19 0 0 0] 8 #() 194 193 193 nil 45 8 'name' 18 #{UI.TextEdit} 50 20 nil 544 50 2 8 1140916352 1025 1008 nil 720 nil 5 nil nil nil 1008 nil 8 1853175488 754 nil nil 35 #focusLost nil nil nil 354 50 1 402 #createAt:extent: 50 2 194 391 1 194 69 39 1008 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 195 0 0 0 0 0 0 0 229 0 0 0 19 0 0 0] 8 #() 976 nil 45 8 'id' 290 194 21 1 194 1 1 354 50 1 402 #createAt:extent: 50 2 194 1 21 194 481 39 544 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 10 0 0 0 240 0 0 0 29 0 0 0] 50 4 18 #{UI.StaticText} 50 16 nil 544 50 2 8 1140850956 1 1456 nil nil nil 5 nil nil nil 1456 nil 8 1853387904 754 nil nil nil 354 50 2 402 #createAt:extent: 50 2 194 21 7 194 63 27 1456 402 #text: 50 1 8 '&Name:' 1456 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 3 0 0 0 41 0 0 0 16 0 0 0] 8 #() 976 nil 27 640 18 #{UI.StaticText} 50 16 nil 544 50 2 8 1140850955 1 1744 nil nil nil 5 nil nil nil 1744 nil 8 1853387904 754 nil nil nil 354 50 2 402 #createAt:extent: 50 2 194 357 7 194 25 27 1744 402 #text: 50 1 8 'Id:' 1744 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 178 0 0 0 3 0 0 0 190 0 0 0 16 0 0 0] 8 #() 976 nil 27 1008 976 nil 27 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 2032 nil nil nil 5 nil nil nil 2032 262 #{UI.FramingLayout} 550 #{Core.LookupTable} 12 18 #{UI.ColorView} 50 16 nil 2032 50 2 8 1140850944 262145 2160 1094 2 #{UI.ValueHolder} nil false 6 #{Kernel.NeverSearchPolicy} nil nil nil 5 nil nil nil 2160 nil 8 1853387904 754 nil nil nil 354 50 1 402 #createAt:extent: 50 2 194 23 153 194 91 43 2160 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 0 76 0 0 0 56 0 0 0 97 0 0 0] 8 #() 976 nil 27 2118 2 #{UI.FramingConstraints} 1030 #{UI.FramingCalculation} #fixedPreviousLeft 3 2498 #fixedViewLeft 91 2498 #fixedPreviousBottom 3 2498 #fixedViewTop 43 18 #{UI.ComboBox} 50 17 nil 2032 50 2 8 1144063491 1025 2576 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} 720 nil 5 nil nil nil 2576 nil 8 1852792128 518 #{Core.Message} #displayString 8 #() 8 #() 401 354 50 1 402 #createAt:extent: 50 2 194 191 151 194 171 43 2576 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 95 0 0 0 75 0 0 0 180 0 0 0 96 0 0 0] 8 #() 976 nil 27 2466 2512 1 2528 171 2544 1 2560 43 18 #{UI.ComboBox} 50 17 nil 2032 50 2 8 1152583170 1 2976 2642 2674 0 nil 2720 720 nil 5 nil nil nil 2976 nil 8 1852792128 2754 #displayString 8 #() 2800 401 354 50 1 402 #createAt:extent: 50 2 194 21 67 194 281 43 2976 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 33 0 0 0 150 0 0 0 54 0 0 0] 8 #() 976 nil 27 2466 2512 1 2528 281 2544 1 2560 43 18 #{UI.ContainerView} 50 15 nil 2032 50 2 8 1140850688 131073 3280 nil nil nil 5 nil nil nil 3280 1030 #{UI.GridLayout} 1 7 11 7 258 6 18 #{UI.CheckBox} 50 16 nil 3280 50 2 8 1140927750 1 3392 2226 nil nil 2272 false nil nil 5 nil 114 nil true 262 #{OS.LOGFONT} 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 1 2 1 34 77 83 32 83 97 110 115 32 83 101 114 105 102 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 194 193 193 nil 3392 nil 8 1853182784 754 nil nil nil 354 50 2 402 #createAt:extent: 50 2 194 3 1 194 143 43 3392 402 #text: 50 1 8 '&Bold' 3392 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 1 0 0 0 0 0 0 0 72 0 0 0 21 0 0 0] 8 #() 976 nil 27 8 'isBold' 18 #{UI.CheckBox} 50 16 nil 3280 50 2 8 1140924422 1 3792 2226 nil nil 2272 false nil nil 5 nil 114 nil true 3490 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 1 0 0 0 1 2 1 34 77 83 32 83 97 110 115 32 83 101 114 105 102 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 194 193 193 nil 3792 nil 8 1853182784 754 nil nil nil 354 50 2 402 #createAt:extent: 50 2 194 155 1 194 141 43 3792 402 #text: 50 1 8 '&Italic' 3792 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 77 0 0 0 0 0 0 0 147 0 0 0 21 0 0 0] 8 #() 976 nil 27 8 'isItalic' 18 #{UI.CheckBox} 50 16 nil 3280 50 2 8 1140924422 1 4176 2226 nil nil 2272 false nil nil 5 nil 114 nil true 3490 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 1 0 0 1 2 1 34 77 83 32 83 97 110 115 32 83 101 114 105 102 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 194 193 193 nil 4176 nil 8 1853182784 754 nil nil nil 354 50 2 402 #createAt:extent: 50 2 194 305 1 194 143 43 4176 402 #text: 50 1 8 '&Underlined' 4176 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 152 0 0 0 0 0 0 0 223 0 0 0 21 0 0 0] 8 #() 976 nil 27 8 'isUnderlined' 18 #{UI.CheckBox} 50 16 nil 3280 50 2 8 1140924422 1 4560 2226 nil nil 2272 false nil nil 5 nil nil nil 4560 nil 8 1853182784 754 nil nil nil 354 50 2 402 #createAt:extent: 50 2 194 155 49 194 141 41 4560 402 #text: 50 1 8 '&Hotspot' 4560 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 77 0 0 0 24 0 0 0 147 0 0 0 44 0 0 0] 8 #() 976 nil 27 8 'isHotspot' 18 #{UI.CheckBox} 50 16 nil 3280 50 2 8 1140924422 1 4880 2226 nil nil 2272 false nil nil 5 nil nil nil 4880 nil 8 1853182784 754 nil nil nil 354 50 2 402 #createAt:extent: 50 2 194 305 49 194 143 41 4880 402 #text: 50 1 8 'In&visible' 4880 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 152 0 0 0 24 0 0 0 223 0 0 0 44 0 0 0] 8 #() 976 nil 27 8 'isInvisible' 18 #{UI.CheckBox} 50 16 nil 3280 50 2 8 1140924422 1 5200 2226 nil nil 2272 false nil nil 5 nil nil nil 5200 nil 8 1853182784 754 nil nil nil 354 50 2 402 #createAt:extent: 50 2 194 3 49 194 143 41 5200 402 #text: 50 1 8 '&Read Only' 5200 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 1 0 0 0 24 0 0 0 72 0 0 0 44 0 0 0] 8 #() 976 nil 27 8 'isReadOnly' 290 194 3 1 194 11 1 354 50 1 402 #createAt:extent: 50 2 194 21 207 194 457 89 3280 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 103 0 0 0 238 0 0 0 147 0 0 0] 50 6 3392 3792 4176 5200 4560 4880 976 nil 27 2466 2498 #fixedParentLeft 1 2498 #fixedParentRight 13 2544 15 2498 #fixedParentBottom -21 18 #{UI.GroupBox} 50 14 nil 2032 50 2 8 1140850695 65 5776 nil nil nil 5 nil nil nil 5776 nil 8 1853182784 354 50 2 402 #createAt:extent: 50 2 194 1 1 194 485 317 5776 402 #text: 50 1 8 'Text' 5776 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 242 0 0 0 158 0 0 0] 8 #() 976 nil 27 2466 5728 -19 5744 21 2498 #fixedParentTop 1 5760 1 18 #{UI.PushButton} 50 20 nil 2032 50 2 8 1140924416 1 6080 nil 720 nil 5 nil nil nil 6080 nil 8 1853182784 1350 4 #{UI.CommandDescription} #chooseForecolor 8 '…' 1 1 nil nil false nil nil nil 354 50 2 402 #createAt:extent: 50 2 194 123 153 194 41 43 6080 402 #text: 50 1 8 '…' 6080 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 61 0 0 0 76 0 0 0 81 0 0 0 97 0 0 0] 8 #() 976 nil 29 2466 2498 #fixedPreviousRight 11 2528 41 2498 #fixedPreviousTop 1 2544 1 18 #{UI.SpinButton} 50 15 nil 2032 50 2 8 1140916276 1 6448 2226 nil nil 518 #{Kernel.PluggableSearchPolicy} 2754 #= 8 #() 2754 #hash 8 #() 1 720 nil 5 nil nil nil 6448 nil 8 1853096016 754 nil nil 354 50 3 402 #createAt:extent: 50 2 194 387 67 194 31 43 6448 402 #setRange: 50 1 774 #{Core.Interval} 3 201 3 6448 402 #udmSetAccel: 50 1 1350 1 #{External.StructureArray} 8 #[0 0 0 0 1 0 0 0 2 0 0 0 5 0 0 0 5 0 0 0 20 0 0 0] 7 #{OS.UDACCEL} nil 17 6448 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 193 0 0 0 33 0 0 0 208 0 0 0 54 0 0 0] 8 #() 976 nil 27 2466 6416 1 2528 31 6432 1 2544 1 18 #{UI.StaticText} 50 16 nil 2032 50 2 8 1140916492 1 6960 2226 nil false 6 #{Kernel.EqualitySearchPolicy} nil nil nil 5 nil nil nil 6960 nil 8 1853387904 754 nil nil nil 354 50 2 402 #createAt:extent: 50 2 194 21 121 194 61 31 6960 402 #text: 50 1 8 '&Color:' 6960 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 60 0 0 0 40 0 0 0 75 0 0 0] 8 #() 976 nil 27 2466 5728 1 2528 61 2544 13 2560 31 18 #{UI.StaticText} 50 16 nil 2032 50 2 8 1140850956 1 7312 nil nil nil 5 nil nil nil 7312 nil 8 1853387904 754 nil nil nil 354 50 2 402 #createAt:extent: 50 2 194 21 37 194 61 31 7312 402 #text: 50 1 8 '&Font:' 7312 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 18 0 0 0 40 0 0 0 33 0 0 0] 8 #() 976 nil 27 2466 5728 1 2528 61 6064 37 2560 31 18 #{UI.StaticText} 50 16 nil 2032 50 2 8 1140916492 1 7616 2226 nil false 7056 nil nil nil 5 nil nil nil 7616 nil 8 1853387904 754 nil nil nil 354 50 2 402 #createAt:extent: 50 2 194 327 37 194 61 31 7616 402 #text: 50 1 8 '&Size:' 7616 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 163 0 0 0 18 0 0 0 193 0 0 0 33 0 0 0] 8 #() 976 nil 27 2466 6416 27 2528 61 6432 -29 2560 31 18 #{UI.StaticText} 50 16 nil 2032 50 2 8 1140916492 1 7936 2226 nil false 7056 nil nil nil 5 nil nil nil 7936 nil 8 1853387904 754 nil nil nil 354 50 2 402 #createAt:extent: 50 2 194 191 121 194 61 31 7936 402 #text: 50 1 8 'C&ase:' 7936 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 95 0 0 0 60 0 0 0 125 0 0 0 75 0 0 0] 8 #() 976 nil 27 2466 6416 29 2528 61 6432 -31 2560 31 18 #{UI.TextEdit} 50 20 nil 2032 50 2 8 1140924544 1025 8256 nil 706 #window nil 5 nil nil nil 8256 nil 8 1853175488 1094 1 #{UI.IntegerToText} nil 8 '' 326 1 #{Core.Locale} #userDefault nil 1 #focusLost nil nil nil 354 50 2 402 #createAt:extent: 50 2 194 327 67 194 1 43 8256 402 #text: 50 1 8 '0' 8256 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 163 0 0 0 33 0 0 0 163 0 0 0 54 0 0 0] 8 #() 976 nil 45 2466 2512 1 2528 61 2544 1 2560 43 258 5 2160 8 'forecolor' 2576 8 'case' 2976 8 'faceName' 6448 8 'pointSizeSpinner' 8256 8 'pointSize' 290 194 21 1 194 21 1 354 50 1 402 #createAt:extent: 50 2 194 1 79 194 485 317 2032 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 39 0 0 0 242 0 0 0 197 0 0 0] 50 12 5776 7312 2976 7616 8256 6448 6960 2160 6080 7936 2576 3280 976 nil 27 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 8928 nil nil nil 5 nil nil nil 8928 2098 2130 5 18 #{UI.CheckBox} 50 16 nil 8928 50 2 8 1140924422 1 9024 2226 nil nil 2272 false nil nil 5 nil nil nil 9024 nil 8 1853182784 754 nil nil nil 354 50 2 402 #createAt:extent: 50 2 194 201 77 194 221 31 9024 402 #text: 50 1 8 'Fill to &end of line' 9024 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 100 0 0 0 38 0 0 0 210 0 0 0 53 0 0 0] 8 #() 976 nil 27 2466 6416 39 2528 221 6432 5 2560 31 18 #{UI.ColorView} 50 16 nil 8928 50 2 8 1140850944 262145 9344 2226 nil false 2272 nil nil nil 5 nil nil nil 9344 nil 8 1853387904 754 nil nil nil 354 50 1 402 #createAt:extent: 50 2 194 23 73 194 91 43 9344 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 0 36 0 0 0 56 0 0 0 57 0 0 0] 8 #() 976 nil 27 2466 2512 3 2528 91 2544 3 2560 43 18 #{UI.GroupBox} 50 14 nil 8928 50 2 8 1140850695 65 9616 nil nil nil 5 nil nil nil 9616 nil 8 1853182784 354 50 2 402 #createAt:extent: 50 2 194 1 1 194 485 145 9616 402 #text: 50 1 8 'Background' 9616 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 242 0 0 0 72 0 0 0] 8 #() 976 nil 27 2466 5728 -19 5744 21 6064 1 5760 11 18 #{UI.PushButton} 50 20 nil 8928 50 2 8 1141055488 1 9904 nil 720 nil 5 nil nil nil 9904 nil 8 1853182784 6162 #chooseBackcolor 8 '…' 1 1 nil nil false nil nil nil 354 50 2 402 #createAt:extent: 50 2 194 123 73 194 41 43 9904 402 #text: 50 1 8 '…' 9904 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 61 0 0 0 36 0 0 0 81 0 0 0 57 0 0 0] 8 #() 976 nil 29 2466 6416 11 2528 41 6432 1 2544 1 18 #{UI.StaticText} 50 16 nil 8928 50 2 8 1140850956 1 10224 nil nil nil 5 nil nil nil 10224 nil 8 1853387904 754 nil nil nil 354 50 2 402 #createAt:extent: 50 2 194 21 41 194 61 31 10224 402 #text: 50 1 8 'C&olor:
' 10224 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 20 0 0 0 40 0 0 0 35 0 0 0] 8 #() 976 nil 27 2466 5728 1 2528 61 6064 41 2560 31 258 2 9024 8 'isBackcolorExtendedToEndOfLine' 9344 8 'backcolor' 290 194 21 1 194 21 11 354 50 1 402 #createAt:extent: 50 2 194 1 415 194 485 145 8928 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 207 0 0 0 242 0 0 0 23 1 0 0] 50 5 9616 10224 9344 9904 9024 976 nil 27 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 10768 nil nil nil 5 nil nil nil 10768 1798 #{UI.BorderLayout} 1 11 18 #{UI.StaticText} 50 16 nil 10768 50 2 8 1140850956 1 10864 2226 nil false 7056 nil nil nil 517 nil nil nil 10864 nil 8 1853387904 754 nil nil nil 354 50 2 402 #createAt:extent: 50 2 194 21 1 194 449 27 10864 402 #text: 50 1 8 '&Description:' 10864 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 0 0 0 0 234 0 0 0 13 0 0 0] 8 #() 976 nil 27 nil nil nil 18 #{UI.Scintilla.ScintillaView} 50 56 nil 10768 50 2 8 1174409476 1025 11168 2226 nil false 7056 nil 720 nil 5 nil nil nil 11168 nil 8 1367644576 754 nil 8 '' 9 #focusLost nil nil nil nil 258 3 #callTip 3142 1 #{UI.Scintilla.TextStyle} 77 706 #gray 706 #white 1 nil nil nil nil #callTip nil nil nil #indentGuide 11314 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil #normal 11314 1 nil nil 1 nil nil nil nil #normal nil nil nil nil 326 1 #{UI.Scintilla.NullStyler} #preview 258 0 294 #{Core.IdentitySet} 0 nil 2130 0 9215 nil nil 2130 1 81 706 #windowText nil nil 262 #{UI.Scintilla.NullScintillaLibrary} nil 65 nil nil nil nil 3 258 1 #container 11296 nil nil nil nil #{Core.AnsiString} nil 258 0 nil nil 258 0 nil nil nil 354 50 8 402 #createAt:extent: 50 2 194 21 37 194 449 163 11168 402 #text: 50 1 8 '-- Abcdefghijklm …
	… nopqrstuvwxyz --' 11168 402 #setMarginWidths: 50 1 8 #(5 5) 11168 402 #wordWrap: 8 #(true) 11168 402 #margins: 50 1 50 3 2118 3 #{UI.Scintilla.Margin} 1 11168 nil 3 nil nil nil nil 11890 3 11168 nil nil nil 67108863 nil nil 11890 5 11168 nil nil nil nil nil nil 11168 402 #sciSetIndentationGuides: 8 #(1) 11168 402 #targetRange: 50 1 6786 3 87 3 11168 402 #maxCompletionListHeight: 8 #(9) 11168 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 18 0 0 0 234 0 0 0 99 0 0 0] 8 #() 976 nil 45 258 1 11168 8 'preview' 290 194 21 1 194 17 1 354 50 1 402 #createAt:extent: 50 2 194 1 579 194 485 199 10768 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 33 1 0 0 242 0 0 0 132 1 0 0] 50 2 10864 11168 976 nil 27 976 nil 27)! !
!UI.Scintilla.TextStylePresenter class categoriesForMethods!
defaultModel!models!public! !
resource_Default_view!public!resources-views! !
resource_Developer_view!public!resources-views! !
!

