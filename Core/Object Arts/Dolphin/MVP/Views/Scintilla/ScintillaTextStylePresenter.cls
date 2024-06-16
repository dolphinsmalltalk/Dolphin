"Filed out from Dolphin Smalltalk"!

ValuePresenter subclass: #ScintillaTextStylePresenter
	instanceVariableNames: 'facePresenter pointSizePresenter forecolorPresenter backcolorPresenter isItalicPresenter isBoldPresenter isUnderlinedPresenter casePresenter characterSetPresenter previewPresenter fillToEndOfLinePresenter normalStyle defaultStyle isInvisiblePresenter isHotspotPresenter isReadOnlyPresenter namePresenter idPresenter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ScintillaTextStylePresenter guid: (GUID fromString: '{e352dfcb-7063-4b89-9958-074e8500392f}')!

ScintillaTextStylePresenter comment: 'ScintillaTextStylePresenter provides a detail presentation of a <ScintillaTextStyle>, and can be used to view and modify the settings of that style such as the font, foreground and background colours, etc.

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

!ScintillaTextStylePresenter categoriesForClass!MVP-Presenters!MVP-Resources-IDE Tools! !

!ScintillaTextStylePresenter methodsFor!

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
	style := ScintillaTextStyle new.
	desktop := View desktop.
	style
		font: desktop actualFont;
		forecolor: desktop forecolor;
		backcolor: Color window.
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
	casePresenter choices: #(nil) , ScintillaTextStyle caseNames.
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
	normalStyle isNil ifTrue: [normalStyle := ScintillaTextStyle normal].
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

!ScintillaTextStylePresenter categoriesForMethods!
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

!ScintillaTextStylePresenter class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it is initialized."

	^ScintillaTextStyle normal asValue!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ContainerView) 34 15 nil nil 34 2 8 1409286144 131073 416 nil nil nil 517 nil 263494 1 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 1 2 1 0 77 0 83 0 32 0 83 0 97 0 110 0 115 0 32 0 83 0 101 0 114 0 105 0 102 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 416 656198 1 ##(Smalltalk.FlowLayout) 11 11 17 170 192 8 #() 590342 ##(Smalltalk.Rectangle) 328198 ##(Smalltalk.Point) 1 21 658 1 21 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[191 13 0 0 10 0 0 0 170 14 0 0 109 1 0 0] 193 448 8 '' 416 1 34 4 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 928 nil nil nil 5 nil nil nil 928 562 11 1 9 170 192 34 4 410 ##(Smalltalk.TextEdit) 34 16 nil 928 34 2 8 1140916352 1025 1040 nil 327686 ##(Smalltalk.Color) #default nil 5 nil nil nil 1040 nil 8 1759000288 852486 ##(Smalltalk.NullConverter) nil nil 35 706 138 144 34 2 770 #createWindow: 34 1 818 850 8 #[46 0 0 0 0 0 0 0 175 0 0 0 19 0 0 0] 193 1072 nil 1040 770 #text: 34 1 8 'Name of style' 1040 3 8 #() 658 193 193 nil 27 8 'name' 410 ##(Smalltalk.TextEdit) 34 16 nil 928 34 2 8 1140916352 1025 1408 nil 1120 nil 5 nil nil nil 1408 nil 8 1759000288 1154 nil nil 35 706 138 144 34 1 770 #createWindow: 34 1 818 850 8 #[197 0 0 0 0 0 0 0 227 0 0 0 19 0 0 0] 193 1440 nil 1408 3 8 #() 658 193 193 nil 27 8 'id' 626 658 21 1 658 1 1 706 138 144 34 1 770 #createWindow: 34 1 818 850 8 #[0 0 0 0 10 0 0 0 235 0 0 0 29 0 0 0] 193 960 8 '' 928 3 34 4 410 ##(Smalltalk.StaticText) 34 16 nil 928 34 2 8 1140850956 1 1888 nil nil nil 5 nil nil nil 1888 nil 8 1759212608 1154 nil nil nil 706 138 144 34 2 770 #createWindow: 34 1 818 850 8 #[10 0 0 0 3 0 0 0 41 0 0 0 16 0 0 0] 193 1920 nil 1888 770 #text: 34 1 8 'Name:' 1888 3 8 #() 658 193 193 nil 27 1040 410 ##(Smalltalk.StaticText) 34 16 nil 928 34 2 8 1140850955 1 2192 nil nil nil 5 nil nil nil 2192 nil 8 1759212608 1154 nil nil nil 706 138 144 34 2 770 #createWindow: 34 1 818 850 8 #[180 0 0 0 3 0 0 0 192 0 0 0 16 0 0 0] 193 2224 nil 2192 770 #text: 34 1 8 'Id:' 2192 3 8 #() 658 193 193 nil 27 1408 658 193 193 nil 27 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 2512 nil nil nil 5 nil nil nil 2512 852230 ##(Smalltalk.FramingLayout) 170 176 34 24 410 ##(Smalltalk.TextEdit) 34 16 nil 2512 34 2 8 1140924544 1025 2640 nil 1106 #window nil 5 nil nil nil 2640 nil 8 1759000288 852742 ##(Smalltalk.IntegerToText) nil 8 '' nil 1 706 138 144 34 2 770 #createWindow: 34 1 818 850 8 #[164 0 0 0 35 0 0 0 164 0 0 0 56 0 0 0] 193 2672 nil 2640 770 #text: 34 1 8 '0' 2640 3 8 #() 658 193 193 nil 27 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedPreviousLeft 1 3026 #fixedViewLeft 65 3026 #fixedPreviousBottom 5 3026 #fixedViewTop 43 410 ##(Smalltalk.PushButton) 34 20 nil 2512 34 2 8 1140924416 1 3104 nil 1120 nil 5 nil nil nil 3104 nil 8 1759007584 1180998 4 ##(Smalltalk.CommandDescription) #chooseForecolor 8 '...' 1 1 nil nil false nil nil nil 706 138 144 34 1 770 #createWindow: 34 1 818 850 8 #[60 0 0 0 79 0 0 0 80 0 0 0 100 0 0 0] 193 3136 8 '...' 3104 3 8 #() 658 193 193 nil 29 2994 3026 #fixedPreviousRight 11 3056 41 3026 #fixedPreviousTop 1 3072 1 410 ##(Smalltalk.ComboBox) 34 17 nil 2512 34 2 8 1144063491 1025 3456 590662 2 ##(Smalltalk.ListModel) 138 144 608 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 1120 nil 5 nil nil nil 3456 nil 8 1758616864 459270 ##(Smalltalk.Message) #displayString 8 #() 8 #() 401 706 138 144 34 1 770 #createWindow: 34 1 818 850 8 #[91 0 0 0 79 0 0 0 183 0 0 0 41 1 0 0] 193 3488 8 '' 3456 3 8 #() 658 193 193 nil 27 2994 3040 1 3056 185 3072 5 3088 43 410 ##(Smalltalk.StaticText) 34 16 nil 2512 34 2 8 1140916492 1 3872 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil nil nil 5 nil nil nil 3872 nil 8 1759212608 1154 nil nil nil 706 138 144 34 2 770 #createWindow: 34 1 818 850 8 #[164 0 0 0 20 0 0 0 194 0 0 0 33 0 0 0] 193 3904 nil 3872 770 #text: 34 1 8 '&Size:' 3872 3 8 #() 658 193 193 nil 27 2994 3424 25 3056 61 3440 -29 3088 27 410 ##(Smalltalk.StaticText) 34 16 nil 2512 34 2 8 1140916492 1 4256 3938 nil false 3984 nil nil nil 5 nil nil nil 4256 nil 8 1759212608 1154 nil nil nil 706 138 144 34 2 770 #createWindow: 34 1 818 850 8 #[91 0 0 0 64 0 0 0 121 0 0 0 77 0 0 0] 193 4288 nil 4256 770 #text: 34 1 8 'C&ase:' 4256 3 8 #() 658 193 193 nil 27 2994 3424 23 3056 61 3440 -29 3088 27 410 ##(Smalltalk.ColorView) 34 16 nil 2512 34 2 8 1140850944 262145 4592 3938 nil false 1114118 ##(Smalltalk.NeverSearchPolicy) nil nil nil 5 nil nil nil 4592 nil 8 1759212608 1154 nil nil nil 706 138 144 34 2 770 #createWindow: 34 1 818 850 8 #[10 0 0 0 79 0 0 0 55 0 0 0 100 0 0 0] 193 4624 nil 4592 770 #text: 34 1 8 '' 4592 3 8 #() 658 193 193 nil 27 2994 3040 1 3056 91 3072 5 3088 43 410 ##(Smalltalk.GroupBox) 34 14 nil 2512 34 2 8 1140850695 65 4960 nil nil nil 5 nil nil nil 4960 nil 8 1759007584 706 138 144 34 1 770 #createWindow: 34 1 818 850 8 #[0 0 0 0 0 0 0 0 235 0 0 0 139 0 0 0] 193 4992 8 'Text' 4960 3 8 #() 658 193 193 nil 27 2994 3026 #fixedParentLeft -19 3026 #fixedParentRight 21 3026 #fixedParentTop 1 3026 #fixedParentBottom 1 410 ##(Smalltalk.ComboBox) 34 17 nil 2512 34 2 8 1152583170 1 5296 3522 138 144 608 nil 3584 1120 nil 5 nil nil nil 5296 nil 8 1758616864 3618 #displayString 8 #() 3664 401 706 138 144 34 1 770 #createWindow: 34 1 818 850 8 #[10 0 0 0 35 0 0 0 152 0 0 0 253 0 0 0] 193 5328 8 '' 5296 3 8 #() 658 193 193 nil 27 2994 3040 1 3056 285 3072 5 3088 43 410 ##(Smalltalk.StaticText) 34 16 nil 2512 34 2 8 1140916492 1 5632 3938 nil false 3984 nil nil nil 5 nil nil nil 5632 nil 8 1759212608 1154 nil nil nil 706 138 144 34 2 770 #createWindow: 34 1 818 850 8 #[10 0 0 0 64 0 0 0 40 0 0 0 77 0 0 0] 193 5664 nil 5632 770 #text: 34 1 8 '&Color:' 5632 3 8 #() 658 193 193 nil 27 2994 5232 1 3056 61 3072 17 3088 27 410 ##(Smalltalk.StaticText) 34 16 nil 2512 34 2 8 1140850956 1 5968 nil nil nil 5 nil nil nil 5968 nil 8 1759212608 1154 nil nil nil 706 138 144 34 2 770 #createWindow: 34 1 818 850 8 #[10 0 0 0 20 0 0 0 40 0 0 0 33 0 0 0] 193 6000 nil 5968 770 #text: 34 1 8 '&Font:' 5968 3 8 #() 658 193 193 nil 27 2994 5232 1 3056 61 5264 41 3088 27 410 ##(Smalltalk.SpinButton) 34 15 nil 2512 34 2 8 1140916276 1 6288 3938 nil nil 1376774 ##(Smalltalk.PluggableSearchPolicy) 3618 #= 8 #() 3618 #hash 8 #() 1 1120 nil 5 nil nil nil 6288 nil 8 1758920736 1154 nil nil 706 138 144 34 3 770 #createWindow: 34 1 818 850 8 #[146 0 0 0 35 0 0 0 164 0 0 0 56 0 0 0] 193 6320 8 '' 6288 770 #setRange: 34 1 525062 ##(Smalltalk.Interval) 3 201 3 6288 770 #udmSetAccel: 34 1 918854 1 ##(Smalltalk.StructureArray) 8 #[0 0 0 0 1 0 0 0 2 0 0 0 5 0 0 0 5 0 0 0 20 0 0 0] 7 ##(Smalltalk.UDACCEL) nil 17 6288 3 8 #() 658 193 193 nil 27 2994 3424 1 3056 31 3440 1 3072 1 410 ##(Smalltalk.ContainerView) 34 15 nil 2512 34 2 8 1140850688 131073 6832 nil nil nil 5 nil nil nil 6832 562 1 1 1 170 192 34 6 410 ##(Smalltalk.CheckBox) 34 16 nil 6832 34 2 8 1140924422 1 6944 3938 nil nil 4688 false nil nil 5 nil 482 nil true 514 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 1 0 0 0 1 2 1 0 77 0 83 0 32 0 83 0 97 0 110 0 115 0 32 0 83 0 101 0 114 0 105 0 102 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 6944 nil 8 1759007584 1154 nil nil nil 706 138 144 34 1 770 #createWindow: 34 1 818 850 8 #[67 0 0 0 0 0 0 0 127 0 0 0 14 0 0 0] 193 6976 8 '&Italic' 6944 3 8 #() 658 193 193 nil 27 8 'isItalic' 410 ##(Smalltalk.CheckBox) 34 16 nil 6832 34 2 8 1140924422 1 7296 3938 nil nil 4688 false nil nil 5 nil 482 nil true 514 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 1 0 0 1 2 1 0 77 0 83 0 32 0 83 0 97 0 110 0 115 0 32 0 83 0 101 0 114 0 105 0 102 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 7296 nil 8 1759007584 1154 nil nil nil 706 138 144 34 1 770 #createWindow: 34 1 818 850 8 #[127 0 0 0 0 0 0 0 200 0 0 0 14 0 0 0] 193 7328 8 '&Underlined' 7296 3 8 #() 658 193 193 nil 27 8 'isUnderlined' 410 ##(Smalltalk.CheckBox) 34 16 nil 6832 34 2 8 1140924422 1 7648 3938 nil nil 4688 false nil nil 5 nil 482 nil true 514 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 1 2 1 0 77 0 83 0 32 0 83 0 97 0 110 0 115 0 32 0 83 0 101 0 114 0 105 0 102 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 7648 nil 8 1759007584 1154 nil nil nil 706 138 144 34 1 770 #createWindow: 34 1 818 850 8 #[0 0 0 0 0 0 0 0 67 0 0 0 14 0 0 0] 193 7680 8 '&Bold' 7648 3 8 #() 658 193 193 nil 27 8 'isBold' 626 658 1 1 658 11 1 706 138 144 34 1 770 #createWindow: 34 1 818 850 8 #[10 0 0 0 112 0 0 0 225 0 0 0 126 0 0 0] 193 6864 8 '' 6832 3 34 3 7648 6944 7296 658 193 193 nil 27 2994 5232 1 5248 1 3072 25 5280 -25 170 192 34 10 6288 8 'pointSizeSpinner' 3456 8 'case' 5296 8 'faceName' 2640 8 'pointSize' 4592 8 'forecolor' 626 658 21 1 658 21 1 706 138 144 34 1 770 #createWindow: 34 1 818 850 8 #[0 0 0 0 34 0 0 0 235 0 0 0 173 0 0 0] 193 2544 8 '' 2512 3 34 12 4960 5968 5296 3872 2640 6288 5632 4592 3104 4256 3456 6832 658 193 193 nil 27 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 8576 nil nil nil 5 nil nil nil 8576 2578 170 176 34 10 410 ##(Smalltalk.PushButton) 34 20 nil 8576 34 2 8 1141055488 1 8688 nil 1120 nil 5 nil nil nil 8688 nil 8 1759007584 3186 #chooseBackcolor 8 '...' 1 1 nil nil false nil nil nil 706 138 144 34 1 770 #createWindow: 34 1 818 850 8 #[60 0 0 0 34 0 0 0 80 0 0 0 55 0 0 0] 193 8720 8 '...' 8688 3 8 #() 658 193 193 nil 29 2994 3424 11 3056 41 3440 1 3072 1 410 ##(Smalltalk.CheckBox) 34 16 nil 8576 34 2 8 1140924422 1 8992 3938 nil nil 4688 false nil nil 5 nil nil nil 8992 nil 8 1759007584 1154 nil nil nil 706 138 144 34 1 770 #createWindow: 34 1 818 850 8 #[95 0 0 0 35 0 0 0 200 0 0 0 50 0 0 0] 193 9024 8 'Fill to &end of line' 8992 3 8 #() 658 193 193 nil 27 2994 3424 31 3056 211 3440 3 3088 31 410 ##(Smalltalk.ColorView) 34 16 nil 8576 34 2 8 1140850944 262145 9296 3938 nil false 4688 nil nil nil 5 nil nil nil 9296 nil 8 1759212608 1154 nil nil nil 706 138 144 34 2 770 #createWindow: 34 1 818 850 8 #[10 0 0 0 34 0 0 0 55 0 0 0 55 0 0 0] 193 9328 nil 9296 770 #text: 34 1 8 '' 9296 3 8 #() 658 193 193 nil 27 2994 3040 1 3056 91 3072 5 3088 43 410 ##(Smalltalk.StaticText) 34 16 nil 8576 34 2 8 1140850956 1 9632 nil nil nil 5 nil nil nil 9632 nil 8 1759212608 1154 nil nil nil 706 138 144 34 2 770 #createWindow: 34 1 818 850 8 #[10 0 0 0 19 0 0 0 40 0 0 0 32 0 0 0] 193 9664 nil 9632 770 #text: 34 1 8 'C&olor:
' 9632 3 8 #() 658 193 193 nil 27 2994 5232 1 3056 61 5264 39 3088 27 410 ##(Smalltalk.GroupBox) 34 14 nil 8576 34 2 8 1140850695 65 9952 nil nil nil 5 nil nil nil 9952 nil 8 1759007584 706 138 144 34 1 770 #createWindow: 34 1 818 850 8 #[0 0 0 0 0 0 0 0 235 0 0 0 68 0 0 0] 193 9984 8 'Background' 9952 3 8 #() 658 193 193 nil 27 2994 5232 -19 5248 21 5264 1 5280 1 170 192 34 4 9296 8 'backcolor' 8992 8 'isBackcolorExtendedToEndOfLine' 626 658 21 1 658 21 1 706 138 144 34 1 770 #createWindow: 34 1 818 850 8 #[0 0 0 0 178 0 0 0 235 0 0 0 246 0 0 0] 193 8608 8 '' 8576 3 34 5 9952 9632 9296 8688 8992 658 193 193 nil 27 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 10512 nil nil nil 5 nil nil nil 10512 788230 ##(Smalltalk.BorderLayout) 1 11 410 ##(Smalltalk.StaticText) 34 16 nil 10512 34 2 8 1140850956 1 10608 3938 nil false 3984 nil nil nil 5 nil nil nil 10608 nil 8 1759212608 1154 nil nil nil 706 138 144 34 2 770 #createWindow: 34 1 818 850 8 #[10 0 0 0 2 0 0 0 227 0 0 0 15 0 0 0] 193 10640 nil 10608 770 #text: 34 1 8 'Preview:' 10608 3 8 #() 658 193 193 nil 27 nil nil nil 410 ##(Smalltalk.ScintillaView) 34 65 nil 10512 34 2 8 1174409476 262145 10928 3938 nil false 3984 nil 1120 nil 5 nil nil nil 10928 nil 8 1504001512 1154 nil 8 '' 43 68776273 170 192 34 6 #callTip 1182790 1 ##(Smalltalk.ScintillaTextStyle) 77 1106 #gray 1106 #white 1 nil nil nil nil #callTip nil nil nil #normal 11090 1 nil nil 1 nil nil nil nil #normal nil nil nil #indentGuide 11090 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil nil 1245510 1 ##(Smalltalk.NullScintillaStyler) #preview 170 192 608 138 ##(Smalltalk.IdentitySet) 608 nil 170 176 608 9215 nil nil nil nil 1106 #silver nil nil 65 nil nil nil 8 '' 3 170 192 34 2 #container 11056 nil nil nil nil 16 nil 170 192 608 nil nil 170 192 608 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 706 138 144 34 10 770 #createWindow: 34 1 818 850 8 #[10 0 0 0 20 0 0 0 227 0 0 0 95 0 0 0] 193 10960 nil 10928 770 #text: 34 1 8 '-- Abcdefghijklm ...
	... nopqrstuvwxyz --' 10928 770 #setMarginWidths: 34 1 8 #(5 5) 10928 770 #caretPeriod: 8 #(530) 10928 770 #wordWrap: 8 #(true) 10928 770 #margins: 34 1 34 3 985158 3 ##(Smalltalk.ScintillaMargin) 1 10928 1 3 nil nil nil nil 11698 3 10928 1 nil nil 67108863 nil nil 11698 5 10928 1 nil nil nil nil nil 10928 770 #sciSetIndentationGuides: 8 #(1) 10928 770 #targetRange: 34 1 6674 3 87 3 10928 770 #maxCompletionListHeight: 8 #(9) 10928 770 #edgeColumn: 8 #(1) 10928 3 8 #() 658 193 193 nil 33 170 192 34 2 10928 8 'preview' 626 658 21 5 658 17 1 706 138 144 34 1 770 #createWindow: 34 1 818 850 8 #[0 0 0 0 251 0 0 0 235 0 0 0 90 1 0 0] 193 10544 8 '' 10512 3 34 2 10608 10928 658 193 193 nil 27 658 193 193 nil 27 )!

resource_Developer_view
	"Answer the literal data from which the 'Developer view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Developer_view)
	"

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ContainerView) 34 15 nil nil 34 2 8 1409286144 131073 416 nil nil nil 517 nil 263494 1 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 1 2 1 0 77 0 83 0 32 0 83 0 97 0 110 0 115 0 32 0 83 0 101 0 114 0 105 0 102 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 416 656198 1 ##(Smalltalk.FlowLayout) 11 21 17 170 192 8 #() 590342 ##(Smalltalk.Rectangle) 328198 ##(Smalltalk.Point) 1 21 658 1 21 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[191 13 0 0 10 0 0 0 177 14 0 0 149 1 0 0] 193 448 8 '' 416 1 34 4 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 928 nil nil nil 5 nil nil nil 928 562 11 1 9 170 192 34 4 410 ##(Smalltalk.TextEdit) 34 16 nil 928 34 2 8 1140916352 1025 1040 nil 327686 ##(Smalltalk.Color) #default nil 5 nil nil nil 1040 nil 8 1759000288 852486 ##(Smalltalk.NullConverter) nil nil 35 706 138 144 34 1 770 #createWindow: 34 1 818 850 8 #[195 0 0 0 0 0 0 0 229 0 0 0 19 0 0 0] 193 1072 nil 1040 3 8 #() 658 193 193 nil 27 8 'id' 410 ##(Smalltalk.TextEdit) 34 16 nil 928 34 2 8 1140916352 1025 1360 nil 1120 nil 5 nil nil nil 1360 nil 8 1759000288 1154 nil nil 1 706 138 144 34 2 770 #createWindow: 34 1 818 850 8 #[46 0 0 0 0 0 0 0 173 0 0 0 19 0 0 0] 193 1392 nil 1360 770 #text: 34 1 8 'Name of style' 1360 3 8 #() 658 193 193 nil 27 8 'name' 626 658 21 1 658 1 1 706 138 144 34 1 770 #createWindow: 34 1 818 850 8 #[0 0 0 0 10 0 0 0 240 0 0 0 29 0 0 0] 193 960 8 '' 928 3 34 4 410 ##(Smalltalk.StaticText) 34 16 nil 928 34 2 8 1140850956 1 1888 nil nil nil 5 nil nil nil 1888 nil 8 1759212608 1154 nil nil nil 706 138 144 34 2 770 #createWindow: 34 1 818 850 8 #[10 0 0 0 3 0 0 0 41 0 0 0 16 0 0 0] 193 1920 nil 1888 770 #text: 34 1 8 '&Name:' 1888 3 8 #() 658 193 193 nil 27 1360 410 ##(Smalltalk.StaticText) 34 16 nil 928 34 2 8 1140850955 1 2192 nil nil nil 5 nil nil nil 2192 nil 8 1759212608 1154 nil nil nil 706 138 144 34 2 770 #createWindow: 34 1 818 850 8 #[178 0 0 0 3 0 0 0 190 0 0 0 16 0 0 0] 193 2224 nil 2192 770 #text: 34 1 8 'Id:' 2192 3 8 #() 658 193 193 nil 27 1040 658 193 193 nil 27 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 2512 nil nil nil 5 nil nil nil 2512 852230 ##(Smalltalk.FramingLayout) 170 176 34 24 410 ##(Smalltalk.TextEdit) 34 16 nil 2512 34 2 8 1140924544 1025 2640 nil 1106 #window nil 5 nil nil nil 2640 nil 8 1759000288 852742 ##(Smalltalk.IntegerToText) nil 8 '' nil 1 706 138 144 34 2 770 #createWindow: 34 1 818 850 8 #[163 0 0 0 33 0 0 0 163 0 0 0 54 0 0 0] 193 2672 nil 2640 770 #text: 34 1 8 '0' 2640 3 8 #() 658 193 193 nil 27 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedPreviousLeft 1 3026 #fixedViewLeft 61 3026 #fixedPreviousBottom 1 3026 #fixedViewTop 43 410 ##(Smalltalk.ComboBox) 34 17 nil 2512 34 2 8 1152583170 1 3104 590662 2 ##(Smalltalk.ListModel) 138 144 608 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 1120 nil 5 nil nil nil 3104 nil 8 1758616864 459270 ##(Smalltalk.Message) #displayString 8 #() 8 #() 401 706 138 144 34 1 770 #createWindow: 34 1 818 850 8 #[10 0 0 0 33 0 0 0 150 0 0 0 251 0 0 0] 193 3136 8 '' 3104 3 8 #() 658 193 193 nil 27 2994 3040 1 3056 281 3072 1 3088 43 410 ##(Smalltalk.ContainerView) 34 15 nil 2512 34 2 8 1140850688 131073 3520 nil nil nil 5 nil nil nil 3520 656390 ##(Smalltalk.GridLayout) 1 7 11 7 170 192 34 12 410 ##(Smalltalk.CheckBox) 34 16 nil 3520 34 2 8 1140924422 1 3648 721990 2 ##(Smalltalk.ValueHolder) nil nil 1114118 ##(Smalltalk.NeverSearchPolicy) false nil nil 5 nil 482 nil true 514 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 1 0 0 1 2 1 0 77 0 83 0 32 0 83 0 97 0 110 0 115 0 32 0 83 0 101 0 114 0 105 0 102 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 3648 nil 8 1759007584 1154 nil nil nil 706 138 144 34 1 770 #createWindow: 34 1 818 850 8 #[152 0 0 0 0 0 0 0 223 0 0 0 21 0 0 0] 193 3680 8 '&Underlined' 3648 3 8 #() 658 193 193 nil 27 8 'isUnderlined' 410 ##(Smalltalk.CheckBox) 34 16 nil 3520 34 2 8 1140927750 1 4048 3714 nil nil 3760 false nil nil 5 nil 482 nil true 514 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 1 2 1 0 77 0 83 0 32 0 83 0 97 0 110 0 115 0 32 0 83 0 101 0 114 0 105 0 102 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 4048 nil 8 1759007584 1154 nil nil nil 706 138 144 34 1 770 #createWindow: 34 1 818 850 8 #[1 0 0 0 0 0 0 0 72 0 0 0 21 0 0 0] 193 4080 8 '&Bold' 4048 3 8 #() 658 193 193 nil 27 8 'isBold' 410 ##(Smalltalk.CheckBox) 34 16 nil 3520 34 2 8 1140924422 1 4400 3714 nil nil 3760 false nil nil 5 nil 482 nil true 514 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 1 0 0 0 1 2 1 0 77 0 83 0 32 0 83 0 97 0 110 0 115 0 32 0 83 0 101 0 114 0 105 0 102 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 4400 nil 8 1759007584 1154 nil nil nil 706 138 144 34 1 770 #createWindow: 34 1 818 850 8 #[77 0 0 0 0 0 0 0 147 0 0 0 21 0 0 0] 193 4432 8 '&Italic' 4400 3 8 #() 658 193 193 nil 27 8 'isItalic' 410 ##(Smalltalk.CheckBox) 34 16 nil 3520 34 2 8 1140924422 1 4752 3714 nil nil 3760 false nil nil 5 nil nil nil 4752 nil 8 1759007584 1154 nil nil nil 706 138 144 34 1 770 #createWindow: 34 1 818 850 8 #[152 0 0 0 24 0 0 0 223 0 0 0 44 0 0 0] 193 4784 8 'In&visible' 4752 3 8 #() 658 193 193 nil 27 8 'isInvisible' 410 ##(Smalltalk.CheckBox) 34 16 nil 3520 34 2 8 1140924422 1 5056 3714 nil nil 3760 false nil nil 5 nil nil nil 5056 nil 8 1759007584 1154 nil nil nil 706 138 144 34 1 770 #createWindow: 34 1 818 850 8 #[77 0 0 0 24 0 0 0 147 0 0 0 44 0 0 0] 193 5088 8 '&Hotspot' 5056 3 8 #() 658 193 193 nil 27 8 'isHotspot' 410 ##(Smalltalk.CheckBox) 34 16 nil 3520 34 2 8 1140924422 1 5360 3714 nil nil 3760 false nil nil 5 nil nil nil 5360 nil 8 1759007584 1154 nil nil nil 706 138 144 34 1 770 #createWindow: 34 1 818 850 8 #[1 0 0 0 24 0 0 0 72 0 0 0 44 0 0 0] 193 5392 8 '&Read Only' 5360 3 8 #() 658 193 193 nil 27 8 'isReadOnly' 626 658 3 1 658 11 1 706 138 144 34 1 770 #createWindow: 34 1 818 850 8 #[10 0 0 0 103 0 0 0 238 0 0 0 147 0 0 0] 193 3552 8 '' 3520 3 34 6 4048 4400 3648 5360 5056 4752 658 193 193 nil 27 2994 3026 #fixedParentLeft 1 3026 #fixedParentRight 13 3072 15 3026 #fixedParentBottom -21 410 ##(Smalltalk.StaticText) 34 16 nil 2512 34 2 8 1140916492 1 5952 3714 nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil nil nil 5 nil nil nil 5952 nil 8 1759212608 1154 nil nil nil 706 138 144 34 2 770 #createWindow: 34 1 818 850 8 #[95 0 0 0 60 0 0 0 125 0 0 0 75 0 0 0] 193 5984 nil 5952 770 #text: 34 1 8 'C&ase:' 5952 3 8 #() 658 193 193 nil 27 2994 3026 #fixedPreviousRight 29 3056 61 3026 #fixedPreviousTop -31 3088 31 410 ##(Smalltalk.ComboBox) 34 17 nil 2512 34 2 8 1144063491 1025 6352 3170 138 144 608 nil 3232 1120 nil 5 nil nil nil 6352 nil 8 1758616864 3266 #displayString 8 #() 3312 401 706 138 144 34 1 770 #createWindow: 34 1 818 850 8 #[95 0 0 0 75 0 0 0 180 0 0 0 37 1 0 0] 193 6384 8 '' 6352 3 8 #() 658 193 193 nil 27 2994 3040 1 3056 171 3072 1 3088 43 410 ##(Smalltalk.GroupBox) 34 14 nil 2512 34 2 8 1140850695 65 6688 nil nil nil 5 nil nil nil 6688 nil 8 1759007584 706 138 144 34 1 770 #createWindow: 34 1 818 850 8 #[0 0 0 0 0 0 0 0 242 0 0 0 158 0 0 0] 193 6720 8 'Text' 6688 3 8 #() 658 193 193 nil 27 2994 5904 -19 5920 21 3026 #fixedParentTop 1 5936 1 410 ##(Smalltalk.PushButton) 34 20 nil 2512 34 2 8 1140924416 1 6976 nil 1120 nil 5 nil nil nil 6976 nil 8 1759007584 1180998 4 ##(Smalltalk.CommandDescription) #chooseForecolor 8 '...' 1 1 nil nil false nil nil nil 706 138 144 34 1 770 #createWindow: 34 1 818 850 8 #[61 0 0 0 76 0 0 0 81 0 0 0 97 0 0 0] 193 7008 8 '...' 6976 3 8 #() 658 193 193 nil 29 2994 6320 11 3056 41 6336 1 3072 1 410 ##(Smalltalk.StaticText) 34 16 nil 2512 34 2 8 1140850956 1 7296 nil nil nil 5 nil nil nil 7296 nil 8 1759212608 1154 nil nil nil 706 138 144 34 2 770 #createWindow: 34 1 818 850 8 #[10 0 0 0 18 0 0 0 40 0 0 0 33 0 0 0] 193 7328 nil 7296 770 #text: 34 1 8 '&Font:' 7296 3 8 #() 658 193 193 nil 27 2994 5904 1 3056 61 6960 37 3088 31 410 ##(Smalltalk.SpinButton) 34 15 nil 2512 34 2 8 1140916276 1 7616 3714 nil nil 1376774 ##(Smalltalk.PluggableSearchPolicy) 3266 #= 8 #() 3266 #hash 8 #() 1 1120 nil 5 nil nil nil 7616 nil 8 1758920736 1154 nil nil 706 138 144 34 3 770 #createWindow: 34 1 818 850 8 #[145 0 0 0 33 0 0 0 163 0 0 0 54 0 0 0] 193 7648 8 '' 7616 770 #setRange: 34 1 525062 ##(Smalltalk.Interval) 3 201 3 7616 770 #udmSetAccel: 34 1 918854 1 ##(Smalltalk.StructureArray) 8 #[0 0 0 0 1 0 0 0 2 0 0 0 5 0 0 0 5 0 0 0 20 0 0 0] 7 ##(Smalltalk.UDACCEL) nil 17 7616 3 8 #() 658 193 193 nil 27 2994 6320 1 3056 31 6336 1 3072 1 410 ##(Smalltalk.StaticText) 34 16 nil 2512 34 2 8 1140916492 1 8160 3714 nil false 6048 nil nil nil 5 nil nil nil 8160 nil 8 1759212608 1154 nil nil nil 706 138 144 34 2 770 #createWindow: 34 1 818 850 8 #[10 0 0 0 60 0 0 0 40 0 0 0 75 0 0 0] 193 8192 nil 8160 770 #text: 34 1 8 '&Color:' 8160 3 8 #() 658 193 193 nil 27 2994 5904 1 3056 61 3072 13 3088 31 410 ##(Smalltalk.StaticText) 34 16 nil 2512 34 2 8 1140916492 1 8496 3714 nil false 6048 nil nil nil 5 nil nil nil 8496 nil 8 1759212608 1154 nil nil nil 706 138 144 34 2 770 #createWindow: 34 1 818 850 8 #[163 0 0 0 18 0 0 0 193 0 0 0 33 0 0 0] 193 8528 nil 8496 770 #text: 34 1 8 '&Size:' 8496 3 8 #() 658 193 193 nil 27 2994 6320 27 3056 61 6336 -29 3088 31 410 ##(Smalltalk.ColorView) 34 16 nil 2512 34 2 8 1140850944 262145 8832 3714 nil false 3760 nil nil nil 5 nil nil nil 8832 nil 8 1759212608 1154 nil nil nil 706 138 144 34 2 770 #createWindow: 34 1 818 850 8 #[11 0 0 0 76 0 0 0 56 0 0 0 97 0 0 0] 193 8864 nil 8832 770 #text: 34 1 8 '' 8832 3 8 #() 658 193 193 nil 27 2994 3040 3 3056 91 3072 3 3088 43 170 192 34 10 8832 8 'forecolor' 6352 8 'case' 2640 8 'pointSize' 7616 8 'pointSizeSpinner' 3104 8 'faceName' 626 658 21 1 658 21 1 706 138 144 34 1 770 #createWindow: 34 1 818 850 8 #[0 0 0 0 39 0 0 0 242 0 0 0 197 0 0 0] 193 2544 8 '' 2512 3 34 12 6688 7296 3104 8496 2640 7616 8160 8832 6976 5952 6352 3520 658 193 193 nil 27 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 9504 nil nil nil 5 nil nil nil 9504 2578 170 176 34 10 410 ##(Smalltalk.ColorView) 34 16 nil 9504 34 2 8 1140850944 262145 9616 3714 nil false 3760 nil nil nil 5 nil nil nil 9616 nil 8 1759212608 1154 nil nil nil 706 138 144 34 2 770 #createWindow: 34 1 818 850 8 #[11 0 0 0 36 0 0 0 56 0 0 0 57 0 0 0] 193 9648 nil 9616 770 #text: 34 1 8 '' 9616 3 8 #() 658 193 193 nil 27 2994 3040 3 3056 91 3072 3 3088 43 410 ##(Smalltalk.PushButton) 34 20 nil 9504 34 2 8 1141055488 1 9952 nil 1120 nil 5 nil nil nil 9952 nil 8 1759007584 7058 #chooseBackcolor 8 '...' 1 1 nil nil false nil nil nil 706 138 144 34 1 770 #createWindow: 34 1 818 850 8 #[61 0 0 0 36 0 0 0 81 0 0 0 57 0 0 0] 193 9984 8 '...' 9952 3 8 #() 658 193 193 nil 29 2994 6320 11 3056 41 6336 1 3072 1 410 ##(Smalltalk.GroupBox) 34 14 nil 9504 34 2 8 1140850695 65 10256 nil nil nil 5 nil nil nil 10256 nil 8 1759007584 706 138 144 34 1 770 #createWindow: 34 1 818 850 8 #[0 0 0 0 0 0 0 0 242 0 0 0 72 0 0 0] 193 10288 8 'Background' 10256 3 8 #() 658 193 193 nil 27 2994 5904 -19 5920 21 6960 1 5936 11 410 ##(Smalltalk.StaticText) 34 16 nil 9504 34 2 8 1140850956 1 10528 nil nil nil 5 nil nil nil 10528 nil 8 1759212608 1154 nil nil nil 706 138 144 34 2 770 #createWindow: 34 1 818 850 8 #[10 0 0 0 20 0 0 0 40 0 0 0 35 0 0 0] 193 10560 nil 10528 770 #text: 34 1 8 'C&olor:
' 10528 3 8 #() 658 193 193 nil 27 2994 5904 1 3056 61 6960 41 3088 31 410 ##(Smalltalk.CheckBox) 34 16 nil 9504 34 2 8 1140924422 1 10848 3714 nil nil 3760 false nil nil 5 nil nil nil 10848 nil 8 1759007584 1154 nil nil nil 706 138 144 34 1 770 #createWindow: 34 1 818 850 8 #[98 0 0 0 39 0 0 0 200 0 0 0 54 0 0 0] 193 10880 8 'Fill to &end of line' 10848 3 8 #() 658 193 193 nil 27 2994 6320 35 3056 205 6336 7 3088 31 170 192 34 4 10848 8 'isBackcolorExtendedToEndOfLine' 9616 8 'backcolor' 626 658 21 1 658 21 11 706 138 144 34 1 770 #createWindow: 34 1 818 850 8 #[0 0 0 0 207 0 0 0 242 0 0 0 23 1 0 0] 193 9536 8 '' 9504 3 34 5 10256 10528 9616 9952 10848 658 193 193 nil 27 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 11440 nil nil nil 5 nil nil nil 11440 788230 ##(Smalltalk.BorderLayout) 1 11 410 ##(Smalltalk.StaticText) 34 16 nil 11440 34 2 8 1140850956 1 11536 3714 nil false 6048 nil nil nil 517 nil nil nil 11536 nil 8 1759212608 1154 nil nil nil 706 138 144 34 2 770 #createWindow: 34 1 818 850 8 #[10 0 0 0 0 0 0 0 234 0 0 0 13 0 0 0] 193 11568 nil 11536 770 #text: 34 1 8 '&Description:' 11536 3 8 #() 658 193 193 nil 27 nil nil nil 410 ##(Smalltalk.ScintillaView) 34 65 nil 11440 34 2 8 1174409476 1025 11856 3714 nil false 6048 nil 1120 nil 5 nil nil nil 11856 nil 8 1504001512 1154 nil 8 '' 9 68806849 170 192 34 6 #callTip 1182790 1 ##(Smalltalk.ScintillaTextStyle) 77 1106 #gray 1106 #white 1 nil nil nil nil #callTip nil nil nil #normal 12018 1 nil nil 1 nil nil nil nil #normal nil nil nil #indentGuide 12018 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil nil 1245510 1 ##(Smalltalk.NullScintillaStyler) #preview 170 192 608 138 ##(Smalltalk.IdentitySet) 608 nil 170 176 608 9215 nil nil nil nil 1106 #silver nil nil 65 nil nil nil 8 '' 3 170 192 34 2 #container 11984 nil nil nil nil 16 nil 170 192 608 nil nil 170 192 608 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 706 138 144 34 10 770 #createWindow: 34 1 818 850 8 #[10 0 0 0 18 0 0 0 234 0 0 0 99 0 0 0] 193 11888 nil 11856 770 #text: 34 1 8 '-- Abcdefghijklm ...
	... nopqrstuvwxyz --' 11856 770 #setMarginWidths: 34 1 8 #(5 5) 11856 770 #caretPeriod: 8 #(530) 11856 770 #wordWrap: 8 #(true) 11856 770 #margins: 34 1 34 3 985158 3 ##(Smalltalk.ScintillaMargin) 1 11856 1 3 nil nil nil nil 12626 3 11856 1 nil nil 67108863 nil nil 12626 5 11856 1 nil nil nil nil nil 11856 770 #sciSetIndentationGuides: 8 #(1) 11856 770 #targetRange: 34 1 8002 3 87 3 11856 770 #maxCompletionListHeight: 8 #(9) 11856 770 #edgeColumn: 8 #(1) 11856 3 8 #() 658 193 193 nil 33 170 192 34 2 11856 8 'preview' 626 658 21 1 658 17 1 706 138 144 34 1 770 #createWindow: 34 1 818 850 8 #[0 0 0 0 33 1 0 0 242 0 0 0 132 1 0 0] 193 11472 8 '' 11440 3 34 2 11536 11856 658 193 193 nil 27 658 193 193 nil 27 )! !

!ScintillaTextStylePresenter class categoriesForMethods!
defaultModel!models!public! !
resource_Default_view!public!resources-views! !
resource_Developer_view!public!resources-views! !
!

