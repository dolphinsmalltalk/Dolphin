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

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.ContainerView} 34 15 nil nil 34 2 8 1409286144 131073 416 nil nil nil 517 nil 852998 #{Graphics.Font} nil true 721158 #{OS.LOGFONTW} 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 918022 #{Graphics.Point} 193 193 nil 416 852806 1 #{UI.FlowLayout} 11 11 17 170 192 8 #() 1180166 #{Graphics.Rectangle} 562 1 21 562 1 21 1310982 #{Core.MessageSequence} 34 1 1049350 #{Core.MessageSend} #createAt:extent: 34 2 562 12287 21 562 471 711 416 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 234 24 0 0 109 1 0 0] 34 4 410 #{UI.ContainerView} 34 15 nil 416 34 2 8 1140850688 131073 912 nil nil nil 5 nil nil nil 912 594 11 1 9 170 192 34 4 410 #{UI.TextEdit} 34 16 nil 912 34 2 8 1140916352 1025 1024 nil 917510 #{Graphics.Color} #default nil 5 nil nil nil 1024 nil 8 1815092992 1049094 #{UI.NullConverter} nil nil 35 722 34 2 770 #createAt:extent: 34 2 562 93 1 562 259 39 1024 770 #text: 34 1 8 'Name of style' 1024 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 46 0 0 0 0 0 0 0 175 0 0 0 19 0 0 0] 8 #() 562 193 193 nil 27 8 'name' 410 #{UI.TextEdit} 34 16 nil 912 34 2 8 1140916352 1025 1392 nil 1104 nil 5 nil nil nil 1392 nil 8 1815092992 1138 nil nil 35 722 34 1 770 #createAt:extent: 34 2 562 395 1 562 61 39 1392 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 197 0 0 0 0 0 0 0 227 0 0 0 19 0 0 0] 8 #() 1360 nil 27 8 'id' 658 562 21 1 562 1 1 722 34 1 770 #createAt:extent: 34 2 562 1 21 562 471 39 912 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 10 0 0 0 235 0 0 0 29 0 0 0] 34 4 410 #{UI.StaticText} 34 16 nil 912 34 2 8 1140850956 1 1840 nil nil nil 5 nil nil nil 1840 nil 8 1815137184 1138 nil nil nil 722 34 2 770 #createAt:extent: 34 2 562 21 7 562 63 27 1840 770 #text: 34 1 8 'Name:' 1840 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 3 0 0 0 41 0 0 0 16 0 0 0] 8 #() 1360 nil 27 1024 410 #{UI.StaticText} 34 16 nil 912 34 2 8 1140850955 1 2128 nil nil nil 5 nil nil nil 2128 nil 8 1815137184 1138 nil nil nil 722 34 2 770 #createAt:extent: 34 2 562 361 7 562 25 27 2128 770 #text: 34 1 8 'Id:' 2128 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 180 0 0 0 3 0 0 0 192 0 0 0 16 0 0 0] 8 #() 1360 nil 27 1392 1360 nil 27 410 #{UI.ContainerView} 34 15 nil 416 34 2 8 1140850688 131073 2416 nil nil nil 5 nil nil nil 2416 1048838 #{UI.FramingLayout} 170 176 34 24 410 #{UI.TextEdit} 34 16 nil 2416 34 2 8 1140924544 1025 2544 nil 1090 #window nil 5 nil nil nil 2544 nil 8 1815092992 1049670 1 #{UI.IntegerToText} nil 8 '' 721222 1 #{Core.Locale} #userDefault nil 1 722 34 2 770 #createAt:extent: 34 2 562 329 71 562 1 43 2544 770 #text: 34 1 8 '0' 2544 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 164 0 0 0 35 0 0 0 164 0 0 0 56 0 0 0] 8 #() 1360 nil 27 1378374 2 #{UI.FramingConstraints} 1377286 #{UI.FramingCalculation} #fixedPreviousLeft 1 2946 #fixedViewLeft 65 2946 #fixedPreviousBottom 5 2946 #fixedViewTop 43 410 #{UI.ComboBox} 34 17 nil 2416 34 2 8 1152583170 1 3024 787270 2 #{UI.ListModel} 138 144 640 nil 1769478 #{Kernel.IdentitySearchPolicy} 1104 nil 5 nil nil nil 3024 nil 8 1814646992 786950 #{Core.Message} #displayString 8 #() 8 #() 401 722 34 1 770 #createAt:extent: 34 2 562 21 71 562 285 43 3024 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 35 0 0 0 152 0 0 0 56 0 0 0] 8 #() 1360 nil 27 2914 2960 1 2976 285 2992 5 3008 43 410 #{UI.ColorView} 34 16 nil 2416 34 2 8 1140850944 262145 3408 918598 2 #{UI.ValueHolder} nil false 1572870 #{Kernel.NeverSearchPolicy} nil nil nil 5 nil nil nil 3408 nil 8 1815137184 1138 nil nil nil 722 34 1 770 #createAt:extent: 34 2 562 21 159 562 91 43 3408 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 79 0 0 0 55 0 0 0 100 0 0 0] 8 #() 1360 nil 27 2914 2960 1 2976 91 2992 5 3008 43 410 #{UI.PushButton} 34 20 nil 2416 34 2 8 1140924416 1 3728 nil 1104 nil 5 nil nil nil 3728 nil 8 1815097472 1377606 4 #{UI.CommandDescription} #chooseForecolor 8 '…' 1 1 nil nil false nil nil nil 722 34 2 770 #createAt:extent: 34 2 562 121 159 562 41 43 3728 770 #text: 34 1 8 '…' 3728 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 60 0 0 0 79 0 0 0 80 0 0 0 100 0 0 0] 8 #() 1360 nil 29 2914 2946 #fixedPreviousRight 11 2976 41 2946 #fixedPreviousTop 1 2992 1 410 #{UI.ContainerView} 34 15 nil 2416 34 2 8 1140850688 131073 4096 nil nil nil 5 nil nil nil 4096 594 1 1 1 170 192 34 6 410 #{UI.CheckBox} 34 16 nil 4096 34 2 8 1140924422 1 4208 3474 nil nil 3520 false nil nil 5 nil 482 nil true 655622 #{OS.LOGFONT} 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 1 2 1 34 77 83 32 83 97 110 115 32 83 101 114 105 102 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 562 193 193 nil 4208 nil 8 1815097472 1138 nil nil nil 722 34 2 770 #createAt:extent: 34 2 562 1 1 562 135 29 4208 770 #text: 34 1 8 '&Bold' 4208 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 67 0 0 0 14 0 0 0] 8 #() 1360 nil 27 8 'isBold' 410 #{UI.CheckBox} 34 16 nil 4096 34 2 8 1140924422 1 4608 3474 nil nil 3520 false nil nil 5 nil 482 nil true 4306 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 1 0 0 0 1 2 1 34 77 83 32 83 97 110 115 32 83 101 114 105 102 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 562 193 193 nil 4608 nil 8 1815097472 1138 nil nil nil 722 34 2 770 #createAt:extent: 34 2 562 135 1 562 121 29 4608 770 #text: 34 1 8 '&Italic' 4608 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 67 0 0 0 0 0 0 0 127 0 0 0 14 0 0 0] 8 #() 1360 nil 27 8 'isItalic' 410 #{UI.CheckBox} 34 16 nil 4096 34 2 8 1140924422 1 4992 3474 nil nil 3520 false nil nil 5 nil 482 nil true 4306 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 1 0 0 1 2 1 34 77 83 32 83 97 110 115 32 83 101 114 105 102 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 562 193 193 nil 4992 nil 8 1815097472 1138 nil nil nil 722 34 2 770 #createAt:extent: 34 2 562 255 1 562 147 29 4992 770 #text: 34 1 8 '&Underlined' 4992 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 0 0 0 0 0 0 0 200 0 0 0 14 0 0 0] 8 #() 1360 nil 27 8 'isUnderlined' 658 562 1 1 562 11 1 722 34 1 770 #createAt:extent: 34 2 562 21 225 562 431 29 4096 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 112 0 0 0 225 0 0 0 126 0 0 0] 34 3 4208 4608 4992 1360 nil 27 2914 2946 #fixedParentLeft 1 2946 #fixedParentRight 1 2992 25 2946 #fixedParentBottom -25 410 #{UI.StaticText} 34 16 nil 2416 34 2 8 1140850956 1 5632 nil nil nil 5 nil nil nil 5632 nil 8 1815137184 1138 nil nil nil 722 34 2 770 #createAt:extent: 34 2 562 21 41 562 61 27 5632 770 #text: 34 1 8 '&Font:' 5632 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 20 0 0 0 40 0 0 0 33 0 0 0] 8 #() 1360 nil 27 2914 5584 1 2976 61 2946 #fixedParentTop 41 3008 27 410 #{UI.StaticText} 34 16 nil 2416 34 2 8 1140916492 1 5952 3474 nil false 1769478 #{Kernel.EqualitySearchPolicy} nil nil nil 5 nil nil nil 5952 nil 8 1815137184 1138 nil nil nil 722 34 2 770 #createAt:extent: 34 2 562 329 41 562 61 27 5952 770 #text: 34 1 8 '&Size:' 5952 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 164 0 0 0 20 0 0 0 194 0 0 0 33 0 0 0] 8 #() 1360 nil 27 2914 4064 25 2976 61 4080 -29 3008 27 410 #{UI.ComboBox} 34 17 nil 2416 34 2 8 1144063491 1025 6304 3090 138 144 640 nil 3152 1104 nil 5 nil nil nil 6304 nil 8 1814646992 3186 #displayString 8 #() 3232 401 722 34 1 770 #createAt:extent: 34 2 562 183 159 562 185 43 6304 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 91 0 0 0 79 0 0 0 183 0 0 0 100 0 0 0] 8 #() 1360 nil 27 2914 2960 1 2976 185 2992 5 3008 43 410 #{UI.StaticText} 34 16 nil 2416 34 2 8 1140916492 1 6608 3474 nil false 6048 nil nil nil 5 nil nil nil 6608 nil 8 1815137184 1138 nil nil nil 722 34 2 770 #createAt:extent: 34 2 562 21 129 562 61 27 6608 770 #text: 34 1 8 '&Color:' 6608 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 64 0 0 0 40 0 0 0 77 0 0 0] 8 #() 1360 nil 27 2914 5584 1 2976 61 2992 17 3008 27 410 #{UI.StaticText} 34 16 nil 2416 34 2 8 1140916492 1 6928 3474 nil false 6048 nil nil nil 5 nil nil nil 6928 nil 8 1815137184 1138 nil nil nil 722 34 2 770 #createAt:extent: 34 2 562 183 129 562 61 27 6928 770 #text: 34 1 8 'C&ase:' 6928 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 91 0 0 0 64 0 0 0 121 0 0 0 77 0 0 0] 8 #() 1360 nil 27 2914 4064 23 2976 61 4080 -29 3008 27 410 #{UI.GroupBox} 34 14 nil 2416 34 2 8 1140850695 65 7248 nil nil nil 5 nil nil nil 7248 nil 8 1815097472 722 34 2 770 #createAt:extent: 34 2 562 1 1 562 471 279 7248 770 #text: 34 1 8 'Text' 7248 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 235 0 0 0 139 0 0 0] 8 #() 1360 nil 27 2914 5584 -19 5600 21 5936 1 5616 1 410 #{UI.SpinButton} 34 15 nil 2416 34 2 8 1140916276 1 7536 3474 nil nil 1835526 #{Kernel.PluggableSearchPolicy} 3186 #= 8 #() 3186 #hash 8 #() 1 1104 nil 5 nil nil nil 7536 nil 8 1814748160 1138 nil nil 722 34 3 770 #createAt:extent: 34 2 562 393 71 562 31 43 7536 770 #setRange: 34 1 852742 #{Core.Interval} 3 201 3 7536 770 #udmSetAccel: 34 1 1508678 1 #{External.StructureArray} 8 #[0 0 0 0 1 0 0 0 2 0 0 0 5 0 0 0 5 0 0 0 20 0 0 0] 7 #{OS.UDACCEL} nil 17 7536 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 196 0 0 0 35 0 0 0 211 0 0 0 56 0 0 0] 8 #() 1360 nil 27 2914 4064 1 2976 31 4080 1 2992 1 170 192 34 10 7536 8 'pointSizeSpinner' 6304 8 'case' 3024 8 'faceName' 2544 8 'pointSize' 3408 8 'forecolor' 658 562 21 1 562 21 1 722 34 1 770 #createAt:extent: 34 2 562 1 69 562 471 279 2416 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 34 0 0 0 235 0 0 0 173 0 0 0] 34 12 7248 5632 3024 5952 2544 7536 6608 3408 3728 6928 6304 4096 1360 nil 27 410 #{UI.ContainerView} 34 15 nil 416 34 2 8 1140850688 131073 8352 nil nil nil 5 nil nil nil 8352 2482 170 176 34 10 410 #{UI.PushButton} 34 20 nil 8352 34 2 8 1141055488 1 8464 nil 1104 nil 5 nil nil nil 8464 nil 8 1815097472 3810 #chooseBackcolor 8 '…' 1 1 nil nil false nil nil nil 722 34 2 770 #createAt:extent: 34 2 562 121 69 562 41 43 8464 770 #text: 34 1 8 '…' 8464 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 60 0 0 0 34 0 0 0 80 0 0 0 55 0 0 0] 8 #() 1360 nil 29 2914 4064 11 2976 41 4080 1 2992 1 410 #{UI.ColorView} 34 16 nil 8352 34 2 8 1140850944 262145 8784 3474 nil false 3520 nil nil nil 5 nil nil nil 8784 nil 8 1815137184 1138 nil nil nil 722 34 1 770 #createAt:extent: 34 2 562 21 69 562 91 43 8784 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 34 0 0 0 55 0 0 0 55 0 0 0] 8 #() 1360 nil 27 2914 2960 1 2976 91 2992 5 3008 43 410 #{UI.CheckBox} 34 16 nil 8352 34 2 8 1140924422 1 9056 3474 nil nil 3520 false nil nil 5 nil nil nil 9056 nil 8 1815097472 1138 nil nil nil 722 34 2 770 #createAt:extent: 34 2 562 191 71 562 211 31 9056 770 #text: 34 1 8 'Fill to &end of line' 9056 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 95 0 0 0 35 0 0 0 200 0 0 0 50 0 0 0] 8 #() 1360 nil 27 2914 4064 31 2976 211 4080 3 3008 31 410 #{UI.StaticText} 34 16 nil 8352 34 2 8 1140850956 1 9376 nil nil nil 5 nil nil nil 9376 nil 8 1815137184 1138 nil nil nil 722 34 2 770 #createAt:extent: 34 2 562 21 39 562 61 27 9376 770 #text: 34 1 8 'C&olor:
' 9376 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 19 0 0 0 40 0 0 0 32 0 0 0] 8 #() 1360 nil 27 2914 5584 1 2976 61 5936 39 3008 27 410 #{UI.GroupBox} 34 14 nil 8352 34 2 8 1140850695 65 9680 nil nil nil 5 nil nil nil 9680 nil 8 1815097472 722 34 2 770 #createAt:extent: 34 2 562 1 1 562 471 137 9680 770 #text: 34 1 8 'Background' 9680 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 235 0 0 0 68 0 0 0] 8 #() 1360 nil 27 2914 5584 -19 5600 21 5936 1 5616 1 170 192 34 4 8784 8 'backcolor' 9056 8 'isBackcolorExtendedToEndOfLine' 658 562 21 1 562 21 1 722 34 1 770 #createAt:extent: 34 2 562 1 357 562 471 137 8352 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 178 0 0 0 235 0 0 0 246 0 0 0] 34 5 9680 9376 8784 8464 9056 1360 nil 27 410 #{UI.ContainerView} 34 15 nil 416 34 2 8 1140850688 131073 10224 nil nil nil 5 nil nil nil 10224 984838 #{UI.BorderLayout} 1 11 410 #{UI.StaticText} 34 16 nil 10224 34 2 8 1140850956 1 10320 3474 nil false 6048 nil nil nil 5 nil nil nil 10320 nil 8 1815137184 1138 nil nil nil 722 34 2 770 #createAt:extent: 34 2 562 21 5 562 435 27 10320 770 #text: 34 1 8 'Preview:' 10320 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 2 0 0 0 227 0 0 0 15 0 0 0] 8 #() 1360 nil 27 nil nil nil 410 #{UI.Scintilla.ScintillaView} 34 52 nil 10224 34 2 8 1174409476 262145 10624 3474 nil false 6048 nil 1104 nil 5 nil nil nil 10624 nil 8 1395533126 1138 nil 8 '' 43 nil 170 192 34 6 #normal 1444934 1 #{UI.Scintilla.TextStyle} 1 nil nil 1 nil nil nil nil #normal nil nil nil #indentGuide 10786 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil #callTip 10786 77 1090 #gray 1090 #white 1 nil nil nil nil #callTip nil nil nil nil 1507654 1 #{UI.Scintilla.NullStyler} #preview 170 192 640 138 #{Core.IdentitySet} 640 nil 170 176 640 9215 nil nil 170 176 34 2 81 1090 #windowText nil nil 2162950 #{UI.Scintilla.NullScintillaLibrary} nil 65 nil nil nil 8 '' 3 170 192 34 2 #container 10752 nil nil nil nil 16 nil 170 192 640 nil nil 170 192 640 nil nil nil 722 34 8 770 #createAt:extent: 34 2 562 21 41 562 435 151 10624 770 #text: 34 1 8 '-- Abcdefghijklm … 
	…  nopqrstuvwxyz --' 10624 770 #setMarginWidths: 34 1 8 #(5 5) 10624 770 #wordWrap: 8 #(true) 10624 770 #margins: 34 1 34 3 1247302 3 #{UI.Scintilla.Margin} 1 10624 1 3 nil nil nil nil 11394 3 10624 1 nil nil 67108863 nil nil 11394 5 10624 1 nil nil nil nil nil 10624 770 #sciSetIndentationGuides: 8 #(1) 10624 770 #targetRange: 34 1 7874 3 87 3 10624 770 #maxCompletionListHeight: 8 #(9) 10624 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 20 0 0 0 227 0 0 0 95 0 0 0] 8 #() 1360 nil 35 170 192 34 2 10624 8 'preview' 658 562 21 5 562 17 1 722 34 1 770 #createAt:extent: 34 2 562 1 503 562 471 191 10224 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 251 0 0 0 235 0 0 0 90 1 0 0] 34 2 10320 10624 1360 nil 27 1360 nil 27)!

resource_Developer_view
	"Answer the literal data from which the 'Developer view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Developer_view)
	"

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.ContainerView} 34 15 nil nil 34 2 8 1409286144 131073 416 nil nil nil 517 nil 852998 #{Graphics.Font} nil true 721158 #{OS.LOGFONTW} 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 918022 #{Graphics.Point} 193 193 nil 416 852806 1 #{UI.FlowLayout} 11 21 17 170 192 8 #() 1180166 #{Graphics.Rectangle} 562 1 21 562 1 21 1310982 #{Core.MessageSequence} 34 1 1049350 #{Core.MessageSend} #createAt:extent: 34 2 562 12287 21 562 485 791 416 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 241 24 0 0 149 1 0 0] 34 4 410 #{UI.ContainerView} 34 15 nil 416 34 2 8 1140850688 131073 912 nil nil nil 5 nil nil nil 912 594 11 1 9 170 192 34 4 410 #{UI.TextEdit} 34 16 nil 912 34 2 8 1140916352 1025 1024 nil 917510 #{Graphics.Color} #default nil 5 nil nil nil 1024 nil 8 1815092992 1049094 #{UI.NullConverter} nil nil 35 722 34 1 770 #createAt:extent: 34 2 562 391 1 562 69 39 1024 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 195 0 0 0 0 0 0 0 229 0 0 0 19 0 0 0] 8 #() 562 193 193 nil 27 8 'id' 410 #{UI.TextEdit} 34 16 nil 912 34 2 8 1140916352 1025 1344 nil 1104 nil 5 nil nil nil 1344 nil 8 1815092992 1138 nil nil 1 722 34 2 770 #createAt:extent: 34 2 562 93 1 562 255 39 1344 770 #text: 34 1 8 'Name of style' 1344 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 46 0 0 0 0 0 0 0 173 0 0 0 19 0 0 0] 8 #() 1312 nil 27 8 'name' 658 562 21 1 562 1 1 722 34 1 770 #createAt:extent: 34 2 562 1 21 562 481 39 912 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 10 0 0 0 240 0 0 0 29 0 0 0] 34 4 410 #{UI.StaticText} 34 16 nil 912 34 2 8 1140850956 1 1840 nil nil nil 5 nil nil nil 1840 nil 8 1815137184 1138 nil nil nil 722 34 2 770 #createAt:extent: 34 2 562 21 7 562 63 27 1840 770 #text: 34 1 8 '&Name:' 1840 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 3 0 0 0 41 0 0 0 16 0 0 0] 8 #() 1312 nil 27 1344 410 #{UI.StaticText} 34 16 nil 912 34 2 8 1140850955 1 2128 nil nil nil 5 nil nil nil 2128 nil 8 1815137184 1138 nil nil nil 722 34 2 770 #createAt:extent: 34 2 562 357 7 562 25 27 2128 770 #text: 34 1 8 'Id:' 2128 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 178 0 0 0 3 0 0 0 190 0 0 0 16 0 0 0] 8 #() 1312 nil 27 1024 1312 nil 27 410 #{UI.ContainerView} 34 15 nil 416 34 2 8 1140850688 131073 2416 nil nil nil 5 nil nil nil 2416 1048838 #{UI.FramingLayout} 170 176 34 24 410 #{UI.TextEdit} 34 16 nil 2416 34 2 8 1140924544 1025 2544 nil 1090 #window nil 5 nil nil nil 2544 nil 8 1815092992 1049670 1 #{UI.IntegerToText} nil 8 '' 721222 1 #{Core.Locale} #userDefault nil 1 722 34 2 770 #createAt:extent: 34 2 562 327 67 562 1 43 2544 770 #text: 34 1 8 '0' 2544 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 163 0 0 0 33 0 0 0 163 0 0 0 54 0 0 0] 8 #() 1312 nil 27 1378374 2 #{UI.FramingConstraints} 1377286 #{UI.FramingCalculation} #fixedPreviousLeft 1 2946 #fixedViewLeft 61 2946 #fixedPreviousBottom 1 2946 #fixedViewTop 43 410 #{UI.SpinButton} 34 15 nil 2416 34 2 8 1140916276 1 3024 918598 2 #{UI.ValueHolder} nil nil 1835526 #{Kernel.PluggableSearchPolicy} 786950 #{Core.Message} #= 8 #() 3154 #hash 8 #() 1 1104 nil 5 nil nil nil 3024 nil 8 1814748160 1138 nil nil 722 34 3 770 #createAt:extent: 34 2 562 387 67 562 31 43 3024 770 #setRange: 34 1 852742 #{Core.Interval} 3 201 3 3024 770 #udmSetAccel: 34 1 1508678 1 #{External.StructureArray} 8 #[0 0 0 0 1 0 0 0 2 0 0 0 5 0 0 0 5 0 0 0 20 0 0 0] 7 #{OS.UDACCEL} nil 17 3024 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 193 0 0 0 33 0 0 0 208 0 0 0 54 0 0 0] 8 #() 1312 nil 27 2914 2946 #fixedPreviousRight 1 2976 31 2946 #fixedPreviousTop 1 2992 1 410 #{UI.ContainerView} 34 15 nil 2416 34 2 8 1140850688 131073 3600 nil nil nil 5 nil nil nil 3600 852998 #{UI.GridLayout} 1 7 11 7 170 192 34 12 410 #{UI.CheckBox} 34 16 nil 3600 34 2 8 1140924422 1 3728 3090 nil nil 1572870 #{Kernel.NeverSearchPolicy} false nil nil 5 nil 482 nil true 655622 #{OS.LOGFONT} 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 1 0 0 0 1 2 1 34 77 83 32 83 97 110 115 32 83 101 114 105 102 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 562 193 193 nil 3728 nil 8 1815097472 1138 nil nil nil 722 34 2 770 #createAt:extent: 34 2 562 155 1 562 141 43 3728 770 #text: 34 1 8 '&Italic' 3728 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 77 0 0 0 0 0 0 0 147 0 0 0 21 0 0 0] 8 #() 1312 nil 27 8 'isItalic' 410 #{UI.CheckBox} 34 16 nil 3600 34 2 8 1140924422 1 4160 3090 nil nil 3824 false nil nil 5 nil nil nil 4160 nil 8 1815097472 1138 nil nil nil 722 34 2 770 #createAt:extent: 34 2 562 3 49 562 143 41 4160 770 #text: 34 1 8 '&Read Only' 4160 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 1 0 0 0 24 0 0 0 72 0 0 0 44 0 0 0] 8 #() 1312 nil 27 8 'isReadOnly' 410 #{UI.CheckBox} 34 16 nil 3600 34 2 8 1140924422 1 4480 3090 nil nil 3824 false nil nil 5 nil 482 nil true 3858 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 1 0 0 1 2 1 34 77 83 32 83 97 110 115 32 83 101 114 105 102 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 562 193 193 nil 4480 nil 8 1815097472 1138 nil nil nil 722 34 2 770 #createAt:extent: 34 2 562 305 1 562 143 43 4480 770 #text: 34 1 8 '&Underlined' 4480 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 152 0 0 0 0 0 0 0 223 0 0 0 21 0 0 0] 8 #() 1312 nil 27 8 'isUnderlined' 410 #{UI.CheckBox} 34 16 nil 3600 34 2 8 1140924422 1 4864 3090 nil nil 3824 false nil nil 5 nil nil nil 4864 nil 8 1815097472 1138 nil nil nil 722 34 2 770 #createAt:extent: 34 2 562 305 49 562 143 41 4864 770 #text: 34 1 8 'In&visible' 4864 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 152 0 0 0 24 0 0 0 223 0 0 0 44 0 0 0] 8 #() 1312 nil 27 8 'isInvisible' 410 #{UI.CheckBox} 34 16 nil 3600 34 2 8 1140927750 1 5184 3090 nil nil 3824 false nil nil 5 nil 482 nil true 3858 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 1 2 1 34 77 83 32 83 97 110 115 32 83 101 114 105 102 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 562 193 193 nil 5184 nil 8 1815097472 1138 nil nil nil 722 34 2 770 #createAt:extent: 34 2 562 3 1 562 143 43 5184 770 #text: 34 1 8 '&Bold' 5184 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 1 0 0 0 0 0 0 0 72 0 0 0 21 0 0 0] 8 #() 1312 nil 27 8 'isBold' 410 #{UI.CheckBox} 34 16 nil 3600 34 2 8 1140924422 1 5568 3090 nil nil 3824 false nil nil 5 nil nil nil 5568 nil 8 1815097472 1138 nil nil nil 722 34 2 770 #createAt:extent: 34 2 562 155 49 562 141 41 5568 770 #text: 34 1 8 '&Hotspot' 5568 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 77 0 0 0 24 0 0 0 147 0 0 0 44 0 0 0] 8 #() 1312 nil 27 8 'isHotspot' 658 562 3 1 562 11 1 722 34 1 770 #createAt:extent: 34 2 562 21 207 562 457 89 3600 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 103 0 0 0 238 0 0 0 147 0 0 0] 34 6 5184 3728 4480 4160 5568 4864 1312 nil 27 2914 2946 #fixedParentLeft 1 2946 #fixedParentRight 13 2992 15 2946 #fixedParentBottom -21 410 #{UI.ColorView} 34 16 nil 2416 34 2 8 1140850944 262145 6144 3090 nil false 3824 nil nil nil 5 nil nil nil 6144 nil 8 1815137184 1138 nil nil nil 722 34 1 770 #createAt:extent: 34 2 562 23 153 562 91 43 6144 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 0 76 0 0 0 56 0 0 0 97 0 0 0] 8 #() 1312 nil 27 2914 2960 3 2976 91 2992 3 3008 43 410 #{UI.PushButton} 34 20 nil 2416 34 2 8 1140924416 1 6416 nil 1104 nil 5 nil nil nil 6416 nil 8 1815097472 1377606 4 #{UI.CommandDescription} #chooseForecolor 8 '…' 1 1 nil nil false nil nil nil 722 34 2 770 #createAt:extent: 34 2 562 123 153 562 41 43 6416 770 #text: 34 1 8 '…' 6416 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 61 0 0 0 76 0 0 0 81 0 0 0 97 0 0 0] 8 #() 1312 nil 29 2914 3568 11 2976 41 3584 1 2992 1 410 #{UI.StaticText} 34 16 nil 2416 34 2 8 1140916492 1 6752 3090 nil false 1769478 #{Kernel.EqualitySearchPolicy} nil nil nil 5 nil nil nil 6752 nil 8 1815137184 1138 nil nil nil 722 34 2 770 #createAt:extent: 34 2 562 21 121 562 61 31 6752 770 #text: 34 1 8 '&Color:' 6752 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 60 0 0 0 40 0 0 0 75 0 0 0] 8 #() 1312 nil 27 2914 6096 1 2976 61 2992 13 3008 31 410 #{UI.GroupBox} 34 14 nil 2416 34 2 8 1140850695 65 7104 nil nil nil 5 nil nil nil 7104 nil 8 1815097472 722 34 2 770 #createAt:extent: 34 2 562 1 1 562 485 317 7104 770 #text: 34 1 8 'Text' 7104 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 242 0 0 0 158 0 0 0] 8 #() 1312 nil 27 2914 6096 -19 6112 21 2946 #fixedParentTop 1 6128 1 410 #{UI.ComboBox} 34 17 nil 2416 34 2 8 1144063491 1025 7408 787270 2 #{UI.ListModel} 138 144 640 nil 1769478 #{Kernel.IdentitySearchPolicy} 1104 nil 5 nil nil nil 7408 nil 8 1814646992 3154 #displayString 8 #() 8 #() 401 722 34 1 770 #createAt:extent: 34 2 562 191 151 562 171 43 7408 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 95 0 0 0 75 0 0 0 180 0 0 0 96 0 0 0] 8 #() 1312 nil 27 2914 2960 1 2976 171 2992 1 3008 43 410 #{UI.StaticText} 34 16 nil 2416 34 2 8 1140916492 1 7776 3090 nil false 6848 nil nil nil 5 nil nil nil 7776 nil 8 1815137184 1138 nil nil nil 722 34 2 770 #createAt:extent: 34 2 562 327 37 562 61 31 7776 770 #text: 34 1 8 '&Size:' 7776 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 163 0 0 0 18 0 0 0 193 0 0 0 33 0 0 0] 8 #() 1312 nil 27 2914 3568 27 2976 61 3584 -29 3008 31 410 #{UI.StaticText} 34 16 nil 2416 34 2 8 1140916492 1 8096 3090 nil false 6848 nil nil nil 5 nil nil nil 8096 nil 8 1815137184 1138 nil nil nil 722 34 2 770 #createAt:extent: 34 2 562 191 121 562 61 31 8096 770 #text: 34 1 8 'C&ase:' 8096 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 95 0 0 0 60 0 0 0 125 0 0 0 75 0 0 0] 8 #() 1312 nil 27 2914 3568 29 2976 61 3584 -31 3008 31 410 #{UI.StaticText} 34 16 nil 2416 34 2 8 1140850956 1 8416 nil nil nil 5 nil nil nil 8416 nil 8 1815137184 1138 nil nil nil 722 34 2 770 #createAt:extent: 34 2 562 21 37 562 61 31 8416 770 #text: 34 1 8 '&Font:' 8416 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 18 0 0 0 40 0 0 0 33 0 0 0] 8 #() 1312 nil 27 2914 6096 1 2976 61 7392 37 3008 31 410 #{UI.ComboBox} 34 17 nil 2416 34 2 8 1152583170 1 8720 7474 138 144 640 nil 7536 1104 nil 5 nil nil nil 8720 nil 8 1814646992 3154 #displayString 8 #() 7600 401 722 34 1 770 #createAt:extent: 34 2 562 21 67 562 281 43 8720 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 33 0 0 0 150 0 0 0 54 0 0 0] 8 #() 1312 nil 27 2914 2960 1 2976 281 2992 1 3008 43 170 192 34 10 7408 8 'case' 8720 8 'faceName' 3024 8 'pointSizeSpinner' 6144 8 'forecolor' 2544 8 'pointSize' 658 562 21 1 562 21 1 722 34 1 770 #createAt:extent: 34 2 562 1 79 562 485 317 2416 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 39 0 0 0 242 0 0 0 197 0 0 0] 34 12 7104 8416 8720 7776 2544 3024 6752 6144 6416 8096 7408 3600 1312 nil 27 410 #{UI.ContainerView} 34 15 nil 416 34 2 8 1140850688 131073 9328 nil nil nil 5 nil nil nil 9328 2482 170 176 34 10 410 #{UI.GroupBox} 34 14 nil 9328 34 2 8 1140850695 65 9440 nil nil nil 5 nil nil nil 9440 nil 8 1815097472 722 34 2 770 #createAt:extent: 34 2 562 1 1 562 485 145 9440 770 #text: 34 1 8 'Background' 9440 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 242 0 0 0 72 0 0 0] 8 #() 1312 nil 27 2914 6096 -19 6112 21 7392 1 6128 11 410 #{UI.PushButton} 34 20 nil 9328 34 2 8 1141055488 1 9728 nil 1104 nil 5 nil nil nil 9728 nil 8 1815097472 6498 #chooseBackcolor 8 '…' 1 1 nil nil false nil nil nil 722 34 2 770 #createAt:extent: 34 2 562 123 73 562 41 43 9728 770 #text: 34 1 8 '…' 9728 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 61 0 0 0 36 0 0 0 81 0 0 0 57 0 0 0] 8 #() 1312 nil 29 2914 3568 11 2976 41 3584 1 2992 1 410 #{UI.StaticText} 34 16 nil 9328 34 2 8 1140850956 1 10048 nil nil nil 5 nil nil nil 10048 nil 8 1815137184 1138 nil nil nil 722 34 2 770 #createAt:extent: 34 2 562 21 41 562 61 31 10048 770 #text: 34 1 8 'C&olor:
' 10048 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 20 0 0 0 40 0 0 0 35 0 0 0] 8 #() 1312 nil 27 2914 6096 1 2976 61 7392 41 3008 31 410 #{UI.CheckBox} 34 16 nil 9328 34 2 8 1140924422 1 10352 3090 nil nil 3824 false nil nil 5 nil nil nil 10352 nil 8 1815097472 1138 nil nil nil 722 34 2 770 #createAt:extent: 34 2 562 201 77 562 221 31 10352 770 #text: 34 1 8 'Fill to &end of line' 10352 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 100 0 0 0 38 0 0 0 210 0 0 0 53 0 0 0] 8 #() 1312 nil 27 2914 3568 39 2976 221 3584 5 3008 31 410 #{UI.ColorView} 34 16 nil 9328 34 2 8 1140850944 262145 10672 3090 nil false 3824 nil nil nil 5 nil nil nil 10672 nil 8 1815137184 1138 nil nil nil 722 34 1 770 #createAt:extent: 34 2 562 23 73 562 91 43 10672 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 0 36 0 0 0 56 0 0 0 57 0 0 0] 8 #() 1312 nil 27 2914 2960 3 2976 91 2992 3 3008 43 170 192 34 4 10672 8 'backcolor' 10352 8 'isBackcolorExtendedToEndOfLine' 658 562 21 1 562 21 11 722 34 1 770 #createAt:extent: 34 2 562 1 415 562 485 145 9328 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 207 0 0 0 242 0 0 0 23 1 0 0] 34 5 9440 10048 10672 9728 10352 1312 nil 27 410 #{UI.ContainerView} 34 15 nil 416 34 2 8 1140850688 131073 11200 nil nil nil 5 nil nil nil 11200 984838 #{UI.BorderLayout} 1 11 410 #{UI.StaticText} 34 16 nil 11200 34 2 8 1140850956 1 11296 3090 nil false 6848 nil nil nil 517 nil nil nil 11296 nil 8 1815137184 1138 nil nil nil 722 34 2 770 #createAt:extent: 34 2 562 21 1 562 449 27 11296 770 #text: 34 1 8 '&Description:' 11296 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 0 0 0 0 234 0 0 0 13 0 0 0] 8 #() 1312 nil 27 nil nil nil 410 #{UI.Scintilla.ScintillaView} 34 52 nil 11200 34 2 8 1174409476 1025 11600 3090 nil false 6848 nil 1104 nil 5 nil nil nil 11600 nil 8 1395533126 1138 nil 8 '' 9 nil 170 192 34 6 #normal 1444934 1 #{UI.Scintilla.TextStyle} 1 nil nil 1 nil nil nil nil #normal nil nil nil #indentGuide 11762 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil #callTip 11762 77 1090 #gray 1090 #white 1 nil nil nil nil #callTip nil nil nil nil 1507654 1 #{UI.Scintilla.NullStyler} #preview 170 192 640 138 #{Core.IdentitySet} 640 nil 170 176 640 9215 nil nil 170 176 34 2 81 1090 #windowText nil nil 2162950 #{UI.Scintilla.NullScintillaLibrary} nil 65 nil nil nil 8 '' 3 170 192 34 2 #container 11728 nil nil nil nil 16 nil 170 192 640 nil nil 170 192 640 nil nil nil 722 34 8 770 #createAt:extent: 34 2 562 21 37 562 449 163 11600 770 #text: 34 1 8 '-- Abcdefghijklm …
	… nopqrstuvwxyz --' 11600 770 #setMarginWidths: 34 1 8 #(5 5) 11600 770 #wordWrap: 8 #(true) 11600 770 #margins: 34 1 34 3 1247302 3 #{UI.Scintilla.Margin} 1 11600 1 3 nil nil nil nil 12370 3 11600 1 nil nil 67108863 nil nil 12370 5 11600 1 nil nil nil nil nil 11600 770 #sciSetIndentationGuides: 8 #(1) 11600 770 #targetRange: 34 1 3394 3 87 3 11600 770 #maxCompletionListHeight: 8 #(9) 11600 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 18 0 0 0 234 0 0 0 99 0 0 0] 8 #() 1312 nil 35 170 192 34 2 11600 8 'preview' 658 562 21 1 562 17 1 722 34 1 770 #createAt:extent: 34 2 562 1 579 562 485 199 11200 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 33 1 0 0 242 0 0 0 132 1 0 0] 34 2 11296 11600 1312 nil 27 1312 nil 27)! !
!UI.Scintilla.TextStylePresenter class categoriesForMethods!
defaultModel!models!public! !
resource_Default_view!public!resources-views! !
resource_Developer_view!public!resources-views! !
!

