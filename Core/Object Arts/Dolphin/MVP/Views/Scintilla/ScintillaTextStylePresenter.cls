"Filed out from Dolphin Smalltalk X6.1"!

ValuePresenter subclass: #ScintillaTextStylePresenter
	instanceVariableNames: 'facePresenter pointSizePresenter forecolorPresenter backcolorPresenter isItalicPresenter isBoldPresenter isUnderlinedPresenter casePresenter characterSetPresenter previewPresenter fillToEndOfLinePresenter normalStyle defaultStyle isInvisiblePresenter isHotspotPresenter isReadOnlyPresenter namePresenter idPresenter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ScintillaTextStylePresenter guid: (GUID fromString: '{E352DFCB-7063-4B89-9958-074E8500392F}')!
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

	super createComponents.
	namePresenter := self add: TextPresenter new name: 'name'.
	idPresenter := self add: TextPresenter new name: 'id'.
	facePresenter := self add: ((ChoicePresenter new)
						choices: ((Canvas forDesktop fontNames asSortedCollection asOrderedCollection)
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
	preview textStyles: (Array with: self normalStyle with: style).
	super onValueChanged!

onViewOpened
	super onViewOpened.
	self onValueChanged! !
!ScintillaTextStylePresenter categoriesFor: #applyDefaultStyle!private!updating! !
!ScintillaTextStylePresenter categoriesFor: #buildDefaultStyle!helpers!private! !
!ScintillaTextStylePresenter categoriesFor: #chooseBackcolor!commands!private! !
!ScintillaTextStylePresenter categoriesFor: #chooseForecolor!commands!private! !
!ScintillaTextStylePresenter categoriesFor: #createComponents!initializing!public! !
!ScintillaTextStylePresenter categoriesFor: #defaultStyle!accessing!public! !
!ScintillaTextStylePresenter categoriesFor: #defaultStyle:!accessing!public! !
!ScintillaTextStylePresenter categoriesFor: #isEnabled:!accessing!public! !
!ScintillaTextStylePresenter categoriesFor: #model:!accessing!private! !
!ScintillaTextStylePresenter categoriesFor: #normalStyle!accessing!public! !
!ScintillaTextStylePresenter categoriesFor: #normalStyle:!accessing!public! !
!ScintillaTextStylePresenter categoriesFor: #onValueChanged!event handling!public! !
!ScintillaTextStylePresenter categoriesFor: #onViewOpened!event handling!public! !

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

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.ContainerView)  98 15 0 0 98 2 8 1409286144 131073 416 0 0 0 517 0 263174 ##(Smalltalk.Font)  0 16 459014 ##(Smalltalk.LOGFONT)  8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 1 2 1 34 77 83 32 83 97 110 115 32 83 101 114 105 102 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point)  193 193 0 416 656198 1 ##(Smalltalk.FlowLayout)  11 11 17 234 256 98 0 590342 ##(Smalltalk.Rectangle)  578 1 21 578 1 21 983302 ##(Smalltalk.MessageSequence)  202 208 98 1 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 578 3359 21 578 471 711 416 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 143 6 0 0 10 0 0 0 122 7 0 0 109 1 0 0] 98 4 410 432 98 15 0 416 98 2 8 1140850688 131073 960 0 0 0 5 0 0 0 960 610 11 1 9 234 256 98 4 410 8 ##(Smalltalk.TextEdit)  98 16 0 960 98 2 8 1140916352 1025 1072 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 5 0 0 0 1072 0 8 4294903901 852486 ##(Smalltalk.NullConverter)  0 0 35 738 202 208 98 4 802 832 98 2 578 93 1 578 259 39 1072 802 8 #text: 98 1 8 'Name of style' 1072 802 8 #selectionRange: 98 1 525062 ##(Smalltalk.Interval)  3 1 3 1072 802 8 #isTextModified: 98 1 32 1072 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 46 0 0 0 0 0 0 0 175 0 0 0 19 0 0 0] 98 0 578 193 193 0 27 8 'name' 410 1088 98 16 0 960 98 2 8 1140916352 1025 1632 0 1154 1184 0 5 0 0 0 1632 0 8 4294903901 1218 0 0 35 738 202 208 98 3 802 832 98 2 578 395 1 578 61 39 1632 802 1440 98 1 1474 3 1 3 1632 802 1520 98 1 32 1632 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 197 0 0 0 0 0 0 0 227 0 0 0 19 0 0 0] 98 0 1600 0 27 8 'id' 674 578 21 1 578 1 1 738 202 208 98 1 802 832 98 2 578 1 21 578 471 39 960 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 10 0 0 0 235 0 0 0 29 0 0 0] 98 4 410 8 ##(Smalltalk.StaticText)  98 16 0 960 98 2 8 1140850956 1 2208 0 0 0 5 0 0 0 2208 0 8 4294903875 1218 0 0 0 738 202 208 98 2 802 832 98 2 578 21 7 578 63 27 2208 802 1376 98 1 8 'Name:' 2208 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 3 0 0 0 41 0 0 0 16 0 0 0] 98 0 1600 0 27 1072 410 2224 98 16 0 960 98 2 8 1140850955 1 2528 0 0 0 5 0 0 0 2528 0 8 4294903875 1218 0 0 0 738 202 208 98 2 802 832 98 2 578 361 7 578 25 27 2528 802 1376 98 1 8 'Id:' 2528 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 180 0 0 0 3 0 0 0 192 0 0 0 16 0 0 0] 98 0 1600 0 27 1632 1600 0 27 410 432 98 15 0 416 98 2 8 1140850688 131073 2832 0 0 0 5 0 0 0 2832 852230 ##(Smalltalk.FramingLayout)  234 240 98 24 410 2224 98 16 0 2832 98 2 8 1140916492 1 2960 721990 2 ##(Smalltalk.ValueHolder)  0 32 1310726 ##(Smalltalk.EqualitySearchPolicy)  0 0 0 5 0 0 0 2960 0 8 4294903875 656134 ##(Smalltalk.TimeToText)  0 0 0 0 738 202 208 98 2 802 832 98 2 578 329 41 578 61 27 2960 802 1376 98 1 8 '&Size:' 2960 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 164 0 0 0 20 0 0 0 194 0 0 0 33 0 0 0] 98 0 1600 0 27 1181766 2 ##(Smalltalk.FramingConstraints)  1180678 ##(Smalltalk.FramingCalculation)  8 #fixedPreviousRight 25 3378 8 #fixedViewLeft 61 3378 8 #fixedPreviousTop -29 3378 8 #fixedViewTop 27 410 8 ##(Smalltalk.PushButton)  98 17 0 2832 98 2 8 1140924416 1 3520 0 1154 1184 0 5 0 0 0 3520 0 8 4294903711 1180998 4 ##(Smalltalk.CommandDescription)  8 #chooseForecolor 8 '...' 1 1 0 0 32 738 202 208 98 2 802 832 98 2 578 121 159 578 41 43 3520 802 1376 98 1 8 '...' 3520 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 60 0 0 0 79 0 0 0 80 0 0 0 100 0 0 0] 98 0 1600 0 27 3346 3392 11 3424 41 3456 1 3378 8 #fixedPreviousBottom 1 410 1088 98 16 0 2832 98 2 8 1140924544 1025 3952 0 721158 ##(Smalltalk.SystemColor)  11 0 5 0 0 0 3952 0 8 4294903901 852742 ##(Smalltalk.IntegerToText)  0 8 '' 0 1 738 202 208 98 4 802 832 98 2 578 329 71 578 1 43 3952 802 1376 98 1 8 '0' 3952 802 1440 98 1 1474 3 1 3 3952 802 1520 98 1 32 3952 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 164 0 0 0 35 0 0 0 164 0 0 0 56 0 0 0] 98 0 1600 0 27 3346 3378 8 #fixedPreviousLeft 1 3424 65 3920 5 3488 43 410 2224 98 16 0 2832 98 2 8 1140850956 1 4448 0 0 0 5 0 0 0 4448 0 8 4294903875 1218 0 0 0 738 202 208 98 2 802 832 98 2 578 21 41 578 61 27 4448 802 1376 98 1 8 '&Font:' 4448 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 20 0 0 0 40 0 0 0 33 0 0 0] 98 0 1600 0 27 3346 3378 8 #fixedParentLeft 1 3424 61 3378 8 #fixedParentTop 41 3488 27 410 8 ##(Smalltalk.ComboBox)  98 17 0 2832 98 2 8 1152583170 1 4832 590662 2 ##(Smalltalk.ListModel)  202 208 656 0 1310726 ##(Smalltalk.IdentitySearchPolicy)  1154 1184 0 5 0 0 0 4832 0 8 4294903891 459270 ##(Smalltalk.Message)  8 #displayString 98 0 656 401 738 202 208 98 1 802 832 98 2 578 21 71 578 285 43 4832 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 35 0 0 0 152 0 0 0 56 0 0 0] 98 0 1600 0 27 3346 4416 1 3424 285 3920 5 3488 43 410 8 ##(Smalltalk.ColorView)  98 16 0 2832 98 2 8 1140850944 262145 5264 3026 0 32 1114118 ##(Smalltalk.NeverSearchPolicy)  0 0 0 5 0 0 0 5264 0 8 4294903875 1218 0 0 0 738 202 208 98 1 802 832 98 2 578 21 159 578 91 43 5264 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 79 0 0 0 55 0 0 0 100 0 0 0] 98 0 1600 0 27 3346 4416 1 3424 91 3920 5 3488 43 410 4848 98 17 0 2832 98 2 8 1144063491 1025 5600 4914 202 208 656 0 4976 1154 1184 0 5 0 0 0 5600 0 8 4294903891 5026 5056 98 0 656 401 738 202 208 98 1 802 832 98 2 578 183 159 578 185 43 5600 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 91 0 0 0 79 0 0 0 183 0 0 0 100 0 0 0] 98 0 1600 0 27 3346 4416 1 3424 185 3920 5 3488 43 410 432 98 15 0 2832 98 2 8 1140850688 131073 5936 0 0 0 5 0 0 0 5936 610 1 1 1 234 256 98 6 410 8 ##(Smalltalk.CheckBox)  98 16 0 5936 98 2 8 1140924422 1 6048 3026 0 0 5376 32 0 0 5 0 498 0 16 530 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 1 2 1 34 77 83 32 83 97 110 115 32 83 101 114 105 102 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 578 193 193 0 6048 0 8 4294903711 1218 0 0 0 738 202 208 98 2 802 832 98 2 578 1 1 578 135 29 6048 802 1376 98 1 8 '&Bold' 6048 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 67 0 0 0 14 0 0 0] 98 0 1600 0 27 8 'isBold' 410 6064 98 16 0 5936 98 2 8 1140924422 1 6464 3026 0 0 5376 32 0 0 5 0 498 0 16 530 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 1 0 0 1 2 1 34 77 83 32 83 97 110 115 32 83 101 114 105 102 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 578 193 193 0 6464 0 8 4294903711 1218 0 0 0 738 202 208 98 2 802 832 98 2 578 255 1 578 147 29 6464 802 1376 98 1 8 '&Underlined' 6464 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 0 0 0 0 0 0 0 200 0 0 0 14 0 0 0] 98 0 1600 0 27 8 'isUnderlined' 410 6064 98 16 0 5936 98 2 8 1140924422 1 6864 3026 0 0 5376 32 0 0 5 0 498 0 16 530 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 1 0 0 0 1 2 1 34 77 83 32 83 97 110 115 32 83 101 114 105 102 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 578 193 193 0 6864 0 8 4294903711 1218 0 0 0 738 202 208 98 2 802 832 98 2 578 135 1 578 121 29 6864 802 1376 98 1 8 '&Italic' 6864 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 67 0 0 0 0 0 0 0 127 0 0 0 14 0 0 0] 98 0 1600 0 27 8 'isItalic' 674 578 1 1 578 11 1 738 202 208 98 1 802 832 98 2 578 21 225 578 431 29 5936 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 112 0 0 0 225 0 0 0 126 0 0 0] 98 3 6048 6864 6464 1600 0 27 3346 4768 1 3378 8 #fixedParentRight 1 3920 25 3378 8 #fixedParentBottom -25 410 2224 98 16 0 2832 98 2 8 1140916492 1 7552 3026 0 32 3072 0 0 0 5 0 0 0 7552 0 8 4294903875 3106 0 0 0 0 738 202 208 98 2 802 832 98 2 578 21 129 578 61 27 7552 802 1376 98 1 8 '&Color:' 7552 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 64 0 0 0 40 0 0 0 77 0 0 0] 98 0 1600 0 27 3346 4768 1 3424 61 3920 17 3488 27 410 8 ##(Smalltalk.GroupBox)  98 14 0 2832 98 2 8 1140850695 65 7888 0 0 0 5 0 0 0 7888 0 8 4294903711 738 202 208 98 2 802 832 98 2 578 1 1 578 471 279 7888 802 1376 98 1 8 'Text' 7888 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 235 0 0 0 139 0 0 0] 98 0 1600 0 27 3346 4768 -19 7488 21 4800 1 7520 1 410 8 ##(Smalltalk.SpinButton)  98 15 0 2832 98 2 8 1140916276 1 8208 3026 0 0 1376774 ##(Smalltalk.PluggableSearchPolicy)  5026 8 #= 98 0 5026 8 #hash 98 0 1 1154 1184 0 5 0 0 0 8208 0 8 4294903591 1218 0 0 738 202 208 98 3 802 832 98 2 578 393 71 578 31 43 8208 802 8 #setRange: 98 1 1474 3 201 3 8208 802 8 #udmSetAccel: 98 1 918854 1 ##(Smalltalk.StructureArray)  8 #[0 0 0 0 1 0 0 0 2 0 0 0 5 0 0 0 5 0 0 0 20 0 0 0] 7 8 ##(Smalltalk.UDACCEL)  0 17 8208 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 196 0 0 0 35 0 0 0 211 0 0 0 56 0 0 0] 98 0 1600 0 27 3346 3392 1 3424 31 3456 1 3920 1 410 2224 98 16 0 2832 98 2 8 1140916492 1 8832 3026 0 32 3072 0 0 0 5 0 0 0 8832 0 8 4294903875 3106 0 0 0 0 738 202 208 98 2 802 832 98 2 578 183 129 578 61 27 8832 802 1376 98 1 8 'C&ase:' 8832 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 91 0 0 0 64 0 0 0 121 0 0 0 77 0 0 0] 98 0 1600 0 27 3346 3392 23 3424 61 3456 -29 3488 27 234 256 98 10 5600 8 'case' 8208 8 'pointSizeSpinner' 5264 8 'forecolor' 4832 8 'faceName' 3952 8 'pointSize' 674 578 21 1 578 21 1 738 202 208 98 1 802 832 98 2 578 1 69 578 471 279 2832 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 34 0 0 0 235 0 0 0 173 0 0 0] 98 12 7888 4448 4832 2960 3952 8208 7552 5264 3520 8832 5600 5936 1600 0 27 410 432 98 15 0 416 98 2 8 1140850688 131073 9488 0 0 0 5 0 0 0 9488 2898 234 240 98 10 410 5280 98 16 0 9488 98 2 8 1140850944 262145 9600 3026 0 32 5376 0 0 0 5 0 0 0 9600 0 8 4294903875 1218 0 0 0 738 202 208 98 1 802 832 98 2 578 21 69 578 91 43 9600 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 34 0 0 0 55 0 0 0 55 0 0 0] 98 0 1600 0 27 3346 4416 1 3424 91 3920 5 3488 43 410 3536 98 17 0 9488 98 2 8 1141055488 1 9888 0 1154 1184 0 5 0 0 0 9888 0 8 4294903711 3634 8 #chooseBackcolor 8 '...' 1 1 0 0 32 738 202 208 98 2 802 832 98 2 578 121 69 578 41 43 9888 802 1376 98 1 8 '...' 9888 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 60 0 0 0 34 0 0 0 80 0 0 0 55 0 0 0] 98 0 1600 0 27 3346 3392 11 3424 41 3456 1 3920 1 410 7904 98 14 0 9488 98 2 8 1140850695 65 10256 0 0 0 5 0 0 0 10256 0 8 4294903711 738 202 208 98 2 802 832 98 2 578 1 1 578 471 137 10256 802 1376 98 1 8 'Background' 10256 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 235 0 0 0 68 0 0 0] 98 0 1600 0 27 3346 4768 -19 7488 21 4800 1 7520 1 410 6064 98 16 0 9488 98 2 8 1140924422 1 10560 3026 0 0 5376 32 0 0 5 0 0 0 10560 0 8 4294903711 1218 0 0 0 738 202 208 98 2 802 832 98 2 578 191 71 578 211 31 10560 802 1376 98 1 8 'Fill to &end of line' 10560 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 95 0 0 0 35 0 0 0 200 0 0 0 50 0 0 0] 98 0 1600 0 27 3346 3392 31 3424 211 3456 3 3488 31 410 2224 98 16 0 9488 98 2 8 1140850956 1 10896 0 0 0 5 0 0 0 10896 0 8 4294903875 1218 0 0 0 738 202 208 98 2 802 832 98 2 578 21 39 578 61 27 10896 802 1376 98 1 8 'C&olor:
' 10896 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 19 0 0 0 40 0 0 0 32 0 0 0] 98 0 1600 0 27 3346 4768 1 3424 61 4800 39 3488 27 234 256 98 4 10560 8 'isBackcolorExtendedToEndOfLine' 9600 8 'backcolor' 674 578 21 1 578 21 1 738 202 208 98 1 802 832 98 2 578 1 357 578 471 137 9488 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 178 0 0 0 235 0 0 0 246 0 0 0] 98 5 10256 10896 9600 9888 10560 1600 0 27 410 432 98 15 0 416 98 2 8 1140850688 131073 11488 0 0 0 5 0 0 0 11488 788230 ##(Smalltalk.BorderLayout)  1 11 410 2224 98 16 0 11488 98 2 8 1140850956 1 11584 3026 0 32 3072 0 0 0 5 0 0 0 11584 0 8 4294903875 1218 0 0 0 738 202 208 98 2 802 832 98 2 578 21 5 578 435 27 11584 802 1376 98 1 8 'Preview:' 11584 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 2 0 0 0 227 0 0 0 15 0 0 0] 98 0 1600 0 27 0 0 0 410 8 ##(Smalltalk.ScintillaView)  98 46 0 11488 98 2 8 1174409476 262145 11904 3026 0 32 3072 0 1154 1184 0 5 0 0 0 11904 0 8 4294903673 1218 0 8 '' 43 0 234 256 98 4 8 #normal 1182726 ##(Smalltalk.ScintillaTextStyle)  1 0 0 1 0 0 0 0 12096 0 0 0 8 #indentGuide 12114 75 0 0 1 0 0 0 0 12144 0 0 0 234 256 98 4 1 12128 75 12160 1245510 1 ##(Smalltalk.NullScintillaStyler)  8 #preview 234 256 656 202 208 656 0 63 9215 0 0 0 0 786694 ##(Smalltalk.IndexedColor)  33554447 0 0 0 0 0 0 8 '' 3 234 256 98 2 8 #container 12064 0 0 0 0 1 0 234 256 656 738 202 208 98 10 802 832 98 2 578 21 41 578 435 151 11904 802 1376 98 1 8 '-- Abcdefghijklm ...
	... nopqrstuvwxyz --' 11904 802 1440 98 1 1474 3 1 3 11904 802 1520 98 1 32 11904 802 8 #setMarginWidths: 98 1 98 2 11 11 11904 802 8 #modificationEventMask: 98 1 9215 11904 802 8 #wordWrap: 98 1 16 11904 802 8 #margins: 98 1 98 3 984582 ##(Smalltalk.ScintillaMargin)  1 11904 1 3 32 1 12866 3 11904 1 1 32 67108863 12866 5 11904 1 1 32 1 11904 802 8 #indentationGuides: 98 1 8 #real 11904 802 8 #tabIndents: 98 1 16 11904 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 20 0 0 0 227 0 0 0 95 0 0 0] 98 0 1600 0 27 234 256 98 2 11904 8 'preview' 674 578 21 5 578 17 1 738 202 208 98 1 802 832 98 2 578 1 503 578 471 191 11488 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 251 0 0 0 235 0 0 0 90 1 0 0] 98 2 11584 11904 1600 0 27 1600 0 27 )!

resource_Developer_view
	"Answer the literal data from which the 'Developer view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Developer_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.ContainerView)  98 15 0 0 98 2 8 1409286144 131073 416 0 0 0 517 0 263174 ##(Smalltalk.Font)  0 16 459014 ##(Smalltalk.LOGFONT)  8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 1 2 1 34 77 83 32 83 97 110 115 32 83 101 114 105 102 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point)  193 193 0 416 656198 1 ##(Smalltalk.FlowLayout)  11 21 17 234 256 98 0 590342 ##(Smalltalk.Rectangle)  578 1 21 578 1 21 983302 ##(Smalltalk.MessageSequence)  202 208 98 1 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 578 3359 21 578 485 791 416 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 143 6 0 0 10 0 0 0 129 7 0 0 149 1 0 0] 98 4 410 432 98 15 0 416 98 2 8 1140850688 131073 960 0 0 0 5 0 0 0 960 610 11 1 9 234 256 98 4 410 8 ##(Smalltalk.TextEdit)  98 16 0 960 98 2 8 1140916352 1025 1072 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 5 0 0 0 1072 0 8 4294903901 852486 ##(Smalltalk.NullConverter)  0 0 35 738 202 208 98 3 802 832 98 2 578 391 1 578 69 39 1072 802 8 #selectionRange: 98 1 525062 ##(Smalltalk.Interval)  3 1 3 1072 802 8 #isTextModified: 98 1 32 1072 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 195 0 0 0 0 0 0 0 229 0 0 0 19 0 0 0] 98 0 578 193 193 0 27 8 'id' 410 1088 98 16 0 960 98 2 8 1140916352 1025 1568 0 1154 1184 0 5 0 0 0 1568 0 8 4294903901 1218 0 0 1 738 202 208 98 4 802 832 98 2 578 93 1 578 255 39 1568 802 8 #text: 98 1 8 'Name of style' 1568 802 1376 98 1 1410 3 1 3 1568 802 1456 98 1 32 1568 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 46 0 0 0 0 0 0 0 173 0 0 0 19 0 0 0] 98 0 1536 0 27 8 'name' 674 578 21 1 578 1 1 738 202 208 98 1 802 832 98 2 578 1 21 578 481 39 960 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 10 0 0 0 240 0 0 0 29 0 0 0] 98 4 410 8 ##(Smalltalk.StaticText)  98 16 0 960 98 2 8 1140850956 1 2208 0 0 0 5 0 0 0 2208 0 8 4294903875 1218 0 0 0 738 202 208 98 2 802 832 98 2 578 21 7 578 63 27 2208 802 1808 98 1 8 '&Name:' 2208 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 3 0 0 0 41 0 0 0 16 0 0 0] 98 0 1536 0 27 1568 410 2224 98 16 0 960 98 2 8 1140850955 1 2528 0 0 0 5 0 0 0 2528 0 8 4294903875 1218 0 0 0 738 202 208 98 2 802 832 98 2 578 357 7 578 25 27 2528 802 1808 98 1 8 'Id:' 2528 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 178 0 0 0 3 0 0 0 190 0 0 0 16 0 0 0] 98 0 1536 0 27 1072 1536 0 27 410 432 98 15 0 416 98 2 8 1140850688 131073 2832 0 0 0 5 0 0 0 2832 852230 ##(Smalltalk.FramingLayout)  234 240 98 24 410 8 ##(Smalltalk.ComboBox)  98 17 0 2832 98 2 8 1144063491 1025 2960 590662 2 ##(Smalltalk.ListModel)  202 208 656 0 1310726 ##(Smalltalk.IdentitySearchPolicy)  1154 1184 0 5 0 0 0 2960 0 8 4294903891 459270 ##(Smalltalk.Message)  8 #displayString 98 0 656 401 738 202 208 98 1 802 832 98 2 578 191 151 578 171 43 2960 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 95 0 0 0 75 0 0 0 180 0 0 0 96 0 0 0] 98 0 1536 0 27 1181766 2 ##(Smalltalk.FramingConstraints)  1180678 ##(Smalltalk.FramingCalculation)  8 #fixedPreviousLeft 1 3410 8 #fixedViewLeft 171 3410 8 #fixedPreviousBottom 1 3410 8 #fixedViewTop 43 410 8 ##(Smalltalk.PushButton)  98 17 0 2832 98 2 8 1140924416 1 3552 0 1154 1184 0 5 0 0 0 3552 0 8 4294903711 1180998 4 ##(Smalltalk.CommandDescription)  8 #chooseForecolor 8 '...' 1 1 0 0 32 738 202 208 98 2 802 832 98 2 578 123 153 578 41 43 3552 802 1808 98 1 8 '...' 3552 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 61 0 0 0 76 0 0 0 81 0 0 0 97 0 0 0] 98 0 1536 0 27 3378 3410 8 #fixedPreviousRight 11 3456 41 3410 8 #fixedPreviousTop 1 3488 1 410 8 ##(Smalltalk.GroupBox)  98 14 0 2832 98 2 8 1140850695 65 4016 0 0 0 5 0 0 0 4016 0 8 4294903711 738 202 208 98 2 802 832 98 2 578 1 1 578 485 317 4016 802 1808 98 1 8 'Text' 4016 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 242 0 0 0 158 0 0 0] 98 0 1536 0 27 3378 3410 8 #fixedParentLeft -19 3410 8 #fixedParentRight 21 3410 8 #fixedParentTop 1 3410 8 #fixedParentBottom 1 410 8 ##(Smalltalk.ColorView)  98 16 0 2832 98 2 8 1140850944 262145 4464 721990 2 ##(Smalltalk.ValueHolder)  0 32 1114118 ##(Smalltalk.NeverSearchPolicy)  0 0 0 5 0 0 0 4464 0 8 4294903875 1218 0 0 0 738 202 208 98 1 802 832 98 2 578 23 153 578 91 43 4464 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 0 76 0 0 0 56 0 0 0 97 0 0 0] 98 0 1536 0 27 3378 3424 3 3456 91 3488 3 3520 43 410 2224 98 16 0 2832 98 2 8 1140850956 1 4816 0 0 0 5 0 0 0 4816 0 8 4294903875 1218 0 0 0 738 202 208 98 2 802 832 98 2 578 21 37 578 61 31 4816 802 1808 98 1 8 '&Font:' 4816 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 18 0 0 0 40 0 0 0 33 0 0 0] 98 0 1536 0 27 3378 4336 1 3456 61 4400 37 3520 31 410 1088 98 16 0 2832 98 2 8 1140924544 1025 5136 0 721158 ##(Smalltalk.SystemColor)  11 0 5 0 0 0 5136 0 8 4294903901 852742 ##(Smalltalk.IntegerToText)  0 8 '' 0 1 738 202 208 98 4 802 832 98 2 578 327 67 578 1 43 5136 802 1808 98 1 8 '0' 5136 802 1376 98 1 1410 3 1 3 5136 802 1456 98 1 32 5136 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 163 0 0 0 33 0 0 0 163 0 0 0 54 0 0 0] 98 0 1536 0 27 3378 3424 1 3456 61 3488 1 3520 43 410 2224 98 16 0 2832 98 2 8 1140916492 1 5600 4546 0 32 1310726 ##(Smalltalk.EqualitySearchPolicy)  0 0 0 5 0 0 0 5600 0 8 4294903875 656134 ##(Smalltalk.TimeToText)  0 0 0 0 738 202 208 98 2 802 832 98 2 578 327 37 578 61 31 5600 802 1808 98 1 8 '&Size:' 5600 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 163 0 0 0 18 0 0 0 193 0 0 0 33 0 0 0] 98 0 1536 0 27 3378 3952 27 3456 61 3984 -29 3520 31 410 8 ##(Smalltalk.SpinButton)  98 15 0 2832 98 2 8 1140916276 1 5984 4546 0 0 1376774 ##(Smalltalk.PluggableSearchPolicy)  3154 8 #= 98 0 3154 8 #hash 98 0 1 1154 1184 0 5 0 0 0 5984 0 8 4294903591 1218 0 0 738 202 208 98 3 802 832 98 2 578 387 67 578 31 43 5984 802 8 #setRange: 98 1 1410 3 201 3 5984 802 8 #udmSetAccel: 98 1 918854 1 ##(Smalltalk.StructureArray)  8 #[0 0 0 0 1 0 0 0 2 0 0 0 5 0 0 0 5 0 0 0 20 0 0 0] 7 8 ##(Smalltalk.UDACCEL)  0 17 5984 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 193 0 0 0 33 0 0 0 208 0 0 0 54 0 0 0] 98 0 1536 0 27 3378 3952 1 3456 31 3984 1 3488 1 410 432 98 15 0 2832 98 2 8 1140850688 131073 6608 0 0 0 5 0 0 0 6608 656390 ##(Smalltalk.GridLayout)  1 7 11 7 234 256 98 12 410 8 ##(Smalltalk.CheckBox)  98 16 0 6608 98 2 8 1140924422 1 6736 4546 0 0 4592 32 0 0 5 0 498 0 16 530 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 1 0 0 0 1 2 1 34 77 83 32 83 97 110 115 32 83 101 114 105 102 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 578 193 193 0 6736 0 8 4294903711 1218 0 0 0 738 202 208 98 2 802 832 98 2 578 155 1 578 141 43 6736 802 1808 98 1 8 '&Italic' 6736 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 77 0 0 0 0 0 0 0 147 0 0 0 21 0 0 0] 98 0 1536 0 27 8 'isItalic' 410 6752 98 16 0 6608 98 2 8 1140927750 1 7152 4546 0 0 4592 32 0 0 5 0 498 0 16 530 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 1 2 1 34 77 83 32 83 97 110 115 32 83 101 114 105 102 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 578 193 193 0 7152 0 8 4294903711 1218 0 0 0 738 202 208 98 2 802 832 98 2 578 3 1 578 143 43 7152 802 1808 98 1 8 '&Bold' 7152 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 1 0 0 0 0 0 0 0 72 0 0 0 21 0 0 0] 98 0 1536 0 27 8 'isBold' 410 6752 98 16 0 6608 98 2 8 1140924422 1 7552 4546 0 0 4592 32 0 0 5 0 0 0 7552 0 8 4294903711 1218 0 0 0 738 202 208 98 2 802 832 98 2 578 155 49 578 141 41 7552 802 1808 98 1 8 '&Hotspot' 7552 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 77 0 0 0 24 0 0 0 147 0 0 0 44 0 0 0] 98 0 1536 0 27 8 'isHotspot' 410 6752 98 16 0 6608 98 2 8 1140924422 1 7888 4546 0 0 4592 32 0 0 5 0 0 0 7888 0 8 4294903711 1218 0 0 0 738 202 208 98 2 802 832 98 2 578 305 49 578 143 41 7888 802 1808 98 1 8 'In&visible' 7888 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 152 0 0 0 24 0 0 0 223 0 0 0 44 0 0 0] 98 0 1536 0 27 8 'isInvisible' 410 6752 98 16 0 6608 98 2 8 1140924422 1 8224 4546 0 0 4592 32 0 0 5 0 0 0 8224 0 8 4294903711 1218 0 0 0 738 202 208 98 2 802 832 98 2 578 3 49 578 143 41 8224 802 1808 98 1 8 '&Read Only' 8224 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 1 0 0 0 24 0 0 0 72 0 0 0 44 0 0 0] 98 0 1536 0 27 8 'isReadOnly' 410 6752 98 16 0 6608 98 2 8 1140924422 1 8560 4546 0 0 4592 32 0 0 5 0 498 0 16 530 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 1 0 0 1 2 1 34 77 83 32 83 97 110 115 32 83 101 114 105 102 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 578 193 193 0 8560 0 8 4294903711 1218 0 0 0 738 202 208 98 2 802 832 98 2 578 305 1 578 143 43 8560 802 1808 98 1 8 '&Underlined' 8560 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 152 0 0 0 0 0 0 0 223 0 0 0 21 0 0 0] 98 0 1536 0 27 8 'isUnderlined' 674 578 3 1 578 11 1 738 202 208 98 1 802 832 98 2 578 21 207 578 457 89 6608 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 103 0 0 0 238 0 0 0 147 0 0 0] 98 6 7152 6736 8560 8224 7552 7888 1536 0 27 3378 4336 1 4368 13 3488 15 4432 -21 410 2224 98 16 0 2832 98 2 8 1140916492 1 9184 4546 0 32 5696 0 0 0 5 0 0 0 9184 0 8 4294903875 5730 0 0 0 0 738 202 208 98 2 802 832 98 2 578 21 121 578 61 31 9184 802 1808 98 1 8 '&Color:' 9184 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 60 0 0 0 40 0 0 0 75 0 0 0] 98 0 1536 0 27 3378 4336 1 3456 61 3488 13 3520 31 410 2976 98 17 0 2832 98 2 8 1152583170 1 9520 3042 202 208 656 0 3104 1154 1184 0 5 0 0 0 9520 0 8 4294903891 3154 3184 98 0 656 401 738 202 208 98 1 802 832 98 2 578 21 67 578 281 43 9520 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 33 0 0 0 150 0 0 0 54 0 0 0] 98 0 1536 0 27 3378 3424 1 3456 281 3488 1 3520 43 410 2224 98 16 0 2832 98 2 8 1140916492 1 9856 4546 0 32 5696 0 0 0 5 0 0 0 9856 0 8 4294903875 5730 0 0 0 0 738 202 208 98 2 802 832 98 2 578 191 121 578 61 31 9856 802 1808 98 1 8 'C&ase:' 9856 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 95 0 0 0 60 0 0 0 125 0 0 0 75 0 0 0] 98 0 1536 0 27 3378 3952 29 3456 61 3984 -31 3520 31 234 256 98 10 4464 8 'forecolor' 5136 8 'pointSize' 5984 8 'pointSizeSpinner' 2960 8 'case' 9520 8 'faceName' 674 578 21 1 578 21 1 738 202 208 98 1 802 832 98 2 578 1 79 578 485 317 2832 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 39 0 0 0 242 0 0 0 197 0 0 0] 98 12 4016 4816 9520 5600 5136 5984 9184 4464 3552 9856 2960 6608 1536 0 27 410 432 98 15 0 416 98 2 8 1140850688 131073 10512 0 0 0 5 0 0 0 10512 2898 234 240 98 10 410 4032 98 14 0 10512 98 2 8 1140850695 65 10624 0 0 0 5 0 0 0 10624 0 8 4294903711 738 202 208 98 2 802 832 98 2 578 1 1 578 485 145 10624 802 1808 98 1 8 'Background' 10624 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 242 0 0 0 72 0 0 0] 98 0 1536 0 27 3378 4336 -19 4368 21 4400 1 4432 11 410 2224 98 16 0 10512 98 2 8 1140850956 1 10928 0 0 0 5 0 0 0 10928 0 8 4294903875 1218 0 0 0 738 202 208 98 2 802 832 98 2 578 21 41 578 61 31 10928 802 1808 98 1 8 'C&olor:
' 10928 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 20 0 0 0 40 0 0 0 35 0 0 0] 98 0 1536 0 27 3378 4336 1 3456 61 4400 41 3520 31 410 4480 98 16 0 10512 98 2 8 1140850944 262145 11248 4546 0 32 4592 0 0 0 5 0 0 0 11248 0 8 4294903875 1218 0 0 0 738 202 208 98 1 802 832 98 2 578 23 73 578 91 43 11248 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 0 36 0 0 0 56 0 0 0 57 0 0 0] 98 0 1536 0 27 3378 3424 3 3456 91 3488 3 3520 43 410 6752 98 16 0 10512 98 2 8 1140924422 1 11536 4546 0 0 4592 32 0 0 5 0 0 0 11536 0 8 4294903711 1218 0 0 0 738 202 208 98 2 802 832 98 2 578 197 79 578 205 31 11536 802 1808 98 1 8 'Fill to &end of line' 11536 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 98 0 0 0 39 0 0 0 200 0 0 0 54 0 0 0] 98 0 1536 0 27 3378 3952 35 3456 205 3984 7 3520 31 410 3568 98 17 0 10512 98 2 8 1141055488 1 11872 0 1154 1184 0 5 0 0 0 11872 0 8 4294903711 3666 8 #chooseBackcolor 8 '...' 1 1 0 0 32 738 202 208 98 2 802 832 98 2 578 123 73 578 41 43 11872 802 1808 98 1 8 '...' 11872 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 61 0 0 0 36 0 0 0 81 0 0 0 57 0 0 0] 98 0 1536 0 27 3378 3952 11 3456 41 3984 1 3488 1 234 256 98 4 11248 8 'backcolor' 11536 8 'isBackcolorExtendedToEndOfLine' 674 578 21 1 578 21 11 738 202 208 98 1 802 832 98 2 578 1 415 578 485 145 10512 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 207 0 0 0 242 0 0 0 23 1 0 0] 98 5 10624 10928 11248 11872 11536 1536 0 27 410 432 98 15 0 416 98 2 8 1140850688 131073 12512 0 0 0 5 0 0 0 12512 788230 ##(Smalltalk.BorderLayout)  1 11 410 2224 98 16 0 12512 98 2 8 1140850956 1 12608 4546 0 32 5696 0 0 0 517 0 0 0 12608 0 8 4294903875 1218 0 0 0 738 202 208 98 2 802 832 98 2 578 21 1 578 449 27 12608 802 1808 98 1 8 '&Description:' 12608 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 0 0 0 0 234 0 0 0 13 0 0 0] 98 0 1536 0 27 0 0 0 410 8 ##(Smalltalk.ScintillaView)  98 46 0 12512 98 2 8 1174409476 1025 12928 4546 0 32 5696 0 1154 1184 0 5 0 0 0 12928 0 8 4294903673 1218 0 8 '' 9 0 234 256 98 4 8 #normal 1182726 ##(Smalltalk.ScintillaTextStyle)  1 0 0 1 0 0 0 0 13120 0 0 0 8 #indentGuide 13138 75 0 0 1 0 0 0 0 13168 0 0 0 98 40 13152 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 13184 0 0 1245510 1 ##(Smalltalk.NullScintillaStyler)  8 #preview 234 256 656 202 208 656 0 63 9215 0 0 0 0 786694 ##(Smalltalk.IndexedColor)  33554447 0 0 0 0 0 0 8 '' 3 234 256 98 2 8 #container 13088 0 0 0 0 1 0 234 256 656 738 202 208 98 10 802 832 98 2 578 21 37 578 449 163 12928 802 1808 98 1 8 '-- Abcdefghijklm ...
	... nopqrstuvwxyz --' 12928 802 1376 98 1 1410 3 1 3 12928 802 1456 98 1 32 12928 802 8 #setMarginWidths: 98 1 98 2 11 11 12928 802 8 #modificationEventMask: 98 1 9215 12928 802 8 #wordWrap: 98 1 16 12928 802 8 #margins: 98 1 98 3 984582 ##(Smalltalk.ScintillaMargin)  1 12928 1 3 32 1 13874 3 12928 1 1 32 67108863 13874 5 12928 1 1 32 1 12928 802 8 #indentationGuides: 98 1 8 #real 12928 802 8 #tabIndents: 98 1 16 12928 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 18 0 0 0 234 0 0 0 99 0 0 0] 98 0 1536 0 27 234 256 98 2 12928 8 'preview' 674 578 21 1 578 17 1 738 202 208 98 1 802 832 98 2 578 1 579 578 485 199 12512 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 33 1 0 0 242 0 0 0 132 1 0 0] 98 2 12608 12928 1536 0 27 1536 0 27 )! !
!ScintillaTextStylePresenter class categoriesFor: #defaultModel!models!public! !
!ScintillaTextStylePresenter class categoriesFor: #resource_Default_view!public!resources-views! !
!ScintillaTextStylePresenter class categoriesFor: #resource_Developer_view!public!resources-views! !

