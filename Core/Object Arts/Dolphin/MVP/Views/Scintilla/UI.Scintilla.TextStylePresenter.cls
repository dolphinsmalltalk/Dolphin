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

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.ContainerView} 38 #{Core.Array} 15 nil nil 50 2 8 1409286144 131073 32 nil nil nil 517 nil 1350 1 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 32 838 1 #{UI.FlowLayout} 11 11 17 550 #{Core.IdentityDictionary} 0 518 #{Graphics.Rectangle} 518 #{Graphics.Point} 1 21 290 1 21 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[255 14 0 0 10 0 0 0 234 15 0 0 109 1 0 0] 193 80 8 '' 32 1 50 4 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 544 nil nil nil 5 nil nil nil 544 194 11 1 9 518 #{Kernel.STBIdentityDictionaryProxy} 224 50 4 18 #{UI.TextEdit} 50 20 nil 544 50 2 8 1140916352 1025 672 nil 6 #{Graphics.Color} #default nil 5 nil nil nil 672 nil nil 518 #{UI.NullConverter} nil nil 35 #focusLost nil nil nil 338 50 1 386 #createWindow: 50 1 434 466 8 #[197 0 0 0 0 0 0 0 227 0 0 0 19 0 0 0] 193 704 nil 672 3 8 #() 290 193 193 nil 45 8 'id' 18 #{UI.TextEdit} 50 20 nil 544 50 2 8 1140916352 1025 960 nil 752 nil 5 nil nil nil 960 nil nil 770 nil nil 35 #focusLost nil nil nil 338 50 2 386 #createWindow: 50 1 434 466 8 #[46 0 0 0 0 0 0 0 175 0 0 0 19 0 0 0] 193 992 nil 960 386 #text: 50 1 8 'Name of style' 960 3 8 #() 290 193 193 nil 45 8 'name' 258 290 21 1 290 1 1 338 50 1 386 #createWindow: 50 1 434 466 8 #[0 0 0 0 10 0 0 0 235 0 0 0 29 0 0 0] 193 576 8 '' 544 3 50 4 18 #{UI.StaticText} 50 16 nil 544 50 2 8 1140850956 1 1440 nil nil nil 5 nil nil nil 1440 nil nil 770 nil nil nil 338 50 2 386 #createWindow: 50 1 434 466 8 #[10 0 0 0 3 0 0 0 41 0 0 0 16 0 0 0] 193 1472 nil 1440 386 #text: 50 1 8 'Name:' 1440 3 8 #() 290 193 193 nil 27 960 18 #{UI.StaticText} 50 16 nil 544 50 2 8 1140850955 1 1712 nil nil nil 5 nil nil nil 1712 nil nil 770 nil nil nil 338 50 2 386 #createWindow: 50 1 434 466 8 #[180 0 0 0 3 0 0 0 192 0 0 0 16 0 0 0] 193 1744 nil 1712 386 #text: 50 1 8 'Id:' 1712 3 8 #() 290 193 193 nil 27 672 290 193 193 nil 27 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 2000 nil nil nil 5 nil nil nil 2000 262 #{UI.FramingLayout} 626 #{Core.LookupTable} 50 24 18 #{UI.GroupBox} 50 14 nil 2000 50 2 8 1140850695 65 2128 nil nil nil 5 nil nil nil 2128 nil nil 338 50 1 386 #createWindow: 50 1 434 466 8 #[0 0 0 0 0 0 0 0 235 0 0 0 139 0 0 0] 193 2160 8 'Text' 2128 3 8 #() 290 193 193 nil 27 2118 2 #{UI.FramingConstraints} 1030 #{UI.FramingCalculation} #fixedParentLeft -19 2386 #fixedParentRight 21 2386 #fixedParentTop 1 2386 #fixedParentBottom 1 18 #{UI.StaticText} 50 16 nil 2000 50 2 8 1140850956 1 2464 nil nil nil 5 nil nil nil 2464 nil nil 770 nil nil nil 338 50 2 386 #createWindow: 50 1 434 466 8 #[10 0 0 0 20 0 0 0 40 0 0 0 33 0 0 0] 193 2496 nil 2464 386 #text: 50 1 8 '&Font:' 2464 3 8 #() 290 193 193 nil 27 2354 2400 1 2386 #fixedViewLeft 61 2432 41 2386 #fixedViewTop 27 18 #{UI.StaticText} 50 16 nil 2000 50 2 8 1140916492 1 2784 1094 2 #{UI.ValueHolder} nil false 6 #{Kernel.EqualitySearchPolicy} nil nil nil 5 nil nil nil 2784 nil nil 770 nil nil nil 338 50 2 386 #createWindow: 50 1 434 466 8 #[164 0 0 0 20 0 0 0 194 0 0 0 33 0 0 0] 193 2816 nil 2784 386 #text: 50 1 8 '&Size:' 2784 3 8 #() 290 193 193 nil 27 2354 2386 #fixedPreviousRight 25 2752 61 2386 #fixedPreviousTop -29 2768 27 18 #{UI.ComboBox} 50 17 nil 2000 50 2 8 1152583170 1 3168 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} 752 nil 5 nil nil nil 3168 nil nil 518 #{Core.Message} #displayString 8 #() 8 #() 401 338 50 1 386 #createWindow: 50 1 434 466 8 #[10 0 0 0 35 0 0 0 152 0 0 0 253 0 0 0] 193 3200 8 '' 3168 3 8 #() 290 193 193 nil 27 2354 2386 #fixedPreviousLeft 1 2752 285 2386 #fixedPreviousBottom 5 2768 43 18 #{UI.TextEdit} 50 20 nil 2000 50 2 8 1140924544 1025 3600 nil 738 #window nil 5 nil nil nil 3600 nil nil 1094 1 #{UI.IntegerToText} nil 8 '' 326 1 #{Core.Locale} #userDefault nil 1 #focusLost nil nil nil 338 50 2 386 #createWindow: 50 1 434 466 8 #[164 0 0 0 35 0 0 0 196 0 0 0 56 0 0 0] 193 3632 nil 3600 386 #text: 50 1 8 '0' 3600 3 8 #() 290 193 193 nil 45 2354 3568 1 2752 65 3584 5 2768 43 18 #{UI.SpinButton} 50 15 nil 2000 50 2 8 1140916276 1 3968 2850 nil nil 518 #{Kernel.PluggableSearchPolicy} 3330 #= 8 #() 3330 #hash 8 #() 1 752 nil 5 nil nil nil 3968 nil nil 770 nil nil 338 50 3 386 #createWindow: 50 1 434 466 8 #[196 0 0 0 35 0 0 0 211 0 0 0 56 0 0 0] 193 4000 8 '' 3968 386 #setRange: 50 1 774 #{Core.Interval} 3 201 3 3968 386 #udmSetAccel: 50 1 1350 1 #{External.StructureArray} 8 #[0 0 0 0 1 0 0 0 2 0 0 0 5 0 0 0 5 0 0 0 20 0 0 0] 7 #{OS.UDACCEL} nil 17 3968 3 8 #() 290 193 193 nil 27 2354 3136 1 2752 31 3152 1 3584 1 18 #{UI.StaticText} 50 16 nil 2000 50 2 8 1140916492 1 4480 2850 nil false 2896 nil nil nil 5 nil nil nil 4480 nil nil 770 nil nil nil 338 50 2 386 #createWindow: 50 1 434 466 8 #[10 0 0 0 64 0 0 0 40 0 0 0 77 0 0 0] 193 4512 nil 4480 386 #text: 50 1 8 '&Color:' 4480 3 8 #() 290 193 193 nil 27 2354 2400 1 2752 61 3584 17 2768 27 18 #{UI.StaticText} 50 16 nil 2000 50 2 8 1140916492 1 4784 2850 nil false 2896 nil nil nil 5 nil nil nil 4784 nil nil 770 nil nil nil 338 50 2 386 #createWindow: 50 1 434 466 8 #[91 0 0 0 64 0 0 0 121 0 0 0 77 0 0 0] 193 4816 nil 4784 386 #text: 50 1 8 'C&ase:' 4784 3 8 #() 290 193 193 nil 27 2354 3136 23 2752 61 3152 -29 2768 27 18 #{UI.ColorView} 50 16 nil 2000 50 2 8 1140850944 262145 5088 2850 nil false 6 #{Kernel.NeverSearchPolicy} nil nil nil 5 nil nil nil 5088 nil nil 770 nil nil nil 338 50 1 386 #createWindow: 50 1 434 466 8 #[10 0 0 0 79 0 0 0 55 0 0 0 100 0 0 0] 193 5120 nil 5088 3 8 #() 290 193 193 nil 27 2354 3568 1 2752 91 3584 5 2768 43 18 #{UI.PushButton} 50 20 nil 2000 50 2 8 1140924416 1 5376 nil 752 nil 5 nil nil nil 5376 nil nil 1350 4 #{UI.CommandDescription} #chooseForecolor 8 '…' 1 1 nil nil false nil nil nil 338 50 1 386 #createWindow: 50 1 434 466 8 #[60 0 0 0 79 0 0 0 80 0 0 0 100 0 0 0] 193 5408 8 '…' 5376 3 8 #() 290 193 193 nil 29 2354 3136 11 2752 41 3152 1 3584 1 18 #{UI.ComboBox} 50 17 nil 2000 50 2 8 1144063491 1025 5664 3234 3266 0 nil 3312 752 nil 5 nil nil nil 5664 nil nil 3330 #displayString 8 #() 3376 401 338 50 1 386 #createWindow: 50 1 434 466 8 #[91 0 0 0 79 0 0 0 183 0 0 0 41 1 0 0] 193 5696 8 '' 5664 3 8 #() 290 193 193 nil 27 2354 3568 1 2752 185 3584 5 2768 43 18 #{UI.ContainerView} 50 15 nil 2000 50 2 8 1140850688 131073 5968 nil nil nil 5 nil nil nil 5968 194 1 1 1 626 224 50 6 18 #{UI.CheckBox} 50 16 nil 5968 50 2 8 1140924422 1 6080 2850 nil nil 5184 false nil nil 5 nil 114 nil true 146 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 0 0 0 0 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 6080 nil nil 770 nil nil nil 338 50 1 386 #createWindow: 50 1 434 466 8 #[0 0 0 0 0 0 0 0 67 0 0 0 14 0 0 0] 193 6112 8 '&Bold' 6080 3 8 #() 290 193 193 nil 27 8 'isBold' 18 #{UI.CheckBox} 50 16 nil 5968 50 2 8 1140924422 1 6400 2850 nil nil 5184 false nil nil 5 nil 114 nil true 146 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 1 0 0 0 0 0 0 0 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 6400 nil nil 770 nil nil nil 338 50 1 386 #createWindow: 50 1 434 466 8 #[67 0 0 0 0 0 0 0 127 0 0 0 14 0 0 0] 193 6432 8 '&Italic' 6400 3 8 #() 290 193 193 nil 27 8 'isItalic' 18 #{UI.CheckBox} 50 16 nil 5968 50 2 8 1140924422 1 6720 2850 nil nil 5184 false nil nil 5 nil 114 nil true 146 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 1 0 0 0 0 0 0 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 6720 nil nil 770 nil nil nil 338 50 1 386 #createWindow: 50 1 434 466 8 #[127 0 0 0 0 0 0 0 203 0 0 0 14 0 0 0] 193 6752 8 '&Underlined' 6720 3 8 #() 290 193 193 nil 27 8 'isUnderlined' 258 290 1 1 290 11 1 338 50 1 386 #createWindow: 50 1 434 466 8 #[10 0 0 0 112 0 0 0 225 0 0 0 126 0 0 0] 193 6000 8 '' 5968 3 50 3 6080 6400 6720 290 193 193 nil 27 2354 2400 1 2416 1 3584 25 2448 -25 626 224 50 10 5664 8 'case' 3168 8 'faceName' 5088 8 'forecolor' 3600 8 'pointSize' 3968 8 'pointSizeSpinner' 258 290 21 1 290 21 1 338 50 1 386 #createWindow: 50 1 434 466 8 #[0 0 0 0 34 0 0 0 235 0 0 0 173 0 0 0] 193 2032 8 '' 2000 3 50 12 2128 2464 3168 2784 3600 3968 4480 5088 5376 4784 5664 5968 290 193 193 nil 27 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 7584 nil nil nil 5 nil nil nil 7584 2066 626 #{Core.LookupTable} 50 10 18 #{UI.GroupBox} 50 14 nil 7584 50 2 8 1140850695 65 7696 nil nil nil 5 nil nil nil 7696 nil nil 338 50 1 386 #createWindow: 50 1 434 466 8 #[0 0 0 0 0 0 0 0 235 0 0 0 68 0 0 0] 193 7728 8 'Background' 7696 3 8 #() 290 193 193 nil 27 2354 2400 -19 2416 21 2432 1 2448 1 18 #{UI.StaticText} 50 16 nil 7584 50 2 8 1140850956 1 7936 nil nil nil 5 nil nil nil 7936 nil nil 770 nil nil nil 338 50 2 386 #createWindow: 50 1 434 466 8 #[10 0 0 0 19 0 0 0 40 0 0 0 32 0 0 0] 193 7968 nil 7936 386 #text: 50 1 8 'C&olor:
' 7936 3 8 #() 290 193 193 nil 27 2354 2400 1 2752 61 2432 39 2768 27 18 #{UI.ColorView} 50 16 nil 7584 50 2 8 1140850944 262145 8224 2850 nil false 5184 nil nil nil 5 nil nil nil 8224 nil nil 770 nil nil nil 338 50 1 386 #createWindow: 50 1 434 466 8 #[10 0 0 0 34 0 0 0 55 0 0 0 55 0 0 0] 193 8256 nil 8224 3 8 #() 290 193 193 nil 27 2354 3568 1 2752 91 3584 5 2768 43 18 #{UI.PushButton} 50 20 nil 7584 50 2 8 1141055488 1 8480 nil 752 nil 5 nil nil nil 8480 nil nil 5442 #chooseBackcolor 8 '…' 1 1 nil nil false nil nil nil 338 50 1 386 #createWindow: 50 1 434 466 8 #[60 0 0 0 34 0 0 0 80 0 0 0 55 0 0 0] 193 8512 8 '…' 8480 3 8 #() 290 193 193 nil 29 2354 3136 11 2752 41 3152 1 3584 1 18 #{UI.CheckBox} 50 16 nil 7584 50 2 8 1140924422 1 8752 2850 nil nil 5184 false nil nil 5 nil nil nil 8752 nil nil 770 nil nil nil 338 50 1 386 #createWindow: 50 1 434 466 8 #[95 0 0 0 35 0 0 0 200 0 0 0 50 0 0 0] 193 8784 8 'Fill to &end of line' 8752 3 8 #() 290 193 193 nil 27 2354 3136 31 2752 211 3152 3 2768 31 626 224 50 4 8224 8 'backcolor' 8752 8 'isBackcolorExtendedToEndOfLine' 258 290 21 1 290 21 1 338 50 1 386 #createWindow: 50 1 434 466 8 #[0 0 0 0 178 0 0 0 235 0 0 0 246 0 0 0] 193 7616 8 '' 7584 3 50 5 7696 7936 8224 8480 8752 290 193 193 nil 27 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 9296 nil nil nil 5 nil nil nil 9296 1798 #{UI.BorderLayout} 1 11 18 #{UI.StaticText} 50 16 nil 9296 50 2 8 1140850956 1 9392 2850 nil false 2896 nil nil nil 5 nil nil nil 9392 nil nil 770 nil nil nil 338 50 2 386 #createWindow: 50 1 434 466 8 #[10 0 0 0 2 0 0 0 227 0 0 0 15 0 0 0] 193 9424 nil 9392 386 #text: 50 1 8 'Preview:' 9392 3 8 #() 290 193 193 nil 27 nil nil nil 18 #{UI.Scintilla.ScintillaView} 50 56 nil 9296 50 2 8 1174409476 262145 9680 2850 nil false 2896 nil 752 nil 5 nil nil nil 9680 nil nil 770 nil 8 '' 43 #focusLost nil nil nil nil 226 3 #callTip 3142 1 #{UI.Scintilla.TextStyle} 77 738 #gray 738 #white 1 nil nil nil nil #callTip nil nil nil #indentGuide 9810 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil #normal 9810 1 nil nil 1 nil nil nil nil #normal nil nil nil nil 326 1 #{UI.Scintilla.NullStyler} #preview 226 0 294 #{Core.IdentitySet} 0 nil 550 #{Core.LookupTable} 0 9215 nil nil 9986 1 81 738 #windowText nil nil 262 #{UI.Scintilla.NullScintillaLibrary} nil 65 nil nil nil nil 3 226 1 #container 9792 nil nil nil nil #{Core.Utf8String} nil 226 0 nil nil 226 0 nil nil nil 338 50 8 386 #createWindow: 50 1 434 466 8 #[10 0 0 0 20 0 0 0 227 0 0 0 95 0 0 0] 193 9712 nil 9680 386 #text: 50 1 8 '-- Abcdefghijklm … 
	…  nopqrstuvwxyz --' 9680 386 #setMarginWidths: 50 1 8 #(5 5) 9680 386 #wordWrap: 8 #(true) 9680 386 #margins: 50 1 50 3 2118 3 #{UI.Scintilla.Margin} 1 9680 nil 3 nil nil nil nil 10418 3 9680 nil nil nil 67108863 nil nil 10418 5 9680 nil nil nil nil nil nil 9680 386 #sciSetIndentationGuides: 8 #(1) 9680 386 #targetRange: 50 1 4322 3 91 3 9680 386 #maxCompletionListHeight: 8 #(9) 9680 3 8 #() 290 193 193 nil 45 626 224 50 2 9680 8 'preview' 258 290 21 5 290 17 1 338 50 1 386 #createWindow: 50 1 434 466 8 #[0 0 0 0 251 0 0 0 235 0 0 0 90 1 0 0] 193 9328 8 '' 9296 3 50 2 9392 9680 290 193 193 nil 27 290 193 193 nil 27)! !

!UI.Scintilla.TextStylePresenter class categoriesForMethods!
defaultModel!models!public! !
resource_Default_view!public!resources-views! !
!

