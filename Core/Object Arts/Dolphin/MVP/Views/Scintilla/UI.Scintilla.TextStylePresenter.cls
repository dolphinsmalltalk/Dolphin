"Filed out from Dolphin Smalltalk"!

UI.ValuePresenter subclass: #'UI.Scintilla.TextStylePresenter'
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

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.ContainerView) 34 15 nil nil 34 2 8 1409286144 131073 416 nil nil nil 517 nil 852998 ##(Graphics.Font) nil true 721158 ##(OS.LOGFONTW) 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 918022 ##(Graphics.Point) 193 193 nil 416 852806 1 ##(UI.FlowLayout) 11 11 17 170 192 8 #() 1180166 ##(Graphics.Rectangle) 562 1 21 562 1 21 1310982 ##(Core.MessageSequence) 34 1 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 562 12287 21 562 471 711 416 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 234 24 0 0 109 1 0 0] 34 4 410 ##(UI.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 912 nil nil nil 5 nil nil nil 912 594 11 1 9 170 192 34 4 410 ##(UI.TextEdit) 34 16 nil 912 34 2 8 1140916352 1025 1024 nil 917510 ##(Graphics.Color) #default nil 5 nil nil nil 1024 nil 8 1868457584 1049094 ##(UI.NullConverter) nil nil 35 722 34 2 770 #createAt:extent: 34 2 562 93 1 562 259 39 1024 770 #text: 34 1 8 'Name of style' 1024 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 46 0 0 0 0 0 0 0 175 0 0 0 19 0 0 0] 8 #() 562 193 193 nil 27 8 'name' 410 ##(UI.TextEdit) 34 16 nil 912 34 2 8 1140916352 1025 1392 nil 1104 nil 5 nil nil nil 1392 nil 8 1868457584 1138 nil nil 35 722 34 1 770 #createAt:extent: 34 2 562 395 1 562 61 39 1392 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 197 0 0 0 0 0 0 0 227 0 0 0 19 0 0 0] 8 #() 1360 nil 27 8 'id' 658 562 21 1 562 1 1 722 34 1 770 #createAt:extent: 34 2 562 1 21 562 471 39 912 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 10 0 0 0 235 0 0 0 29 0 0 0] 34 4 410 ##(UI.StaticText) 34 16 nil 912 34 2 8 1140850956 1 1840 nil nil nil 5 nil nil nil 1840 nil 8 1868316128 1138 nil nil nil 722 34 2 770 #createAt:extent: 34 2 562 21 7 562 63 27 1840 770 #text: 34 1 8 'Name:' 1840 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 3 0 0 0 41 0 0 0 16 0 0 0] 8 #() 1360 nil 27 1024 410 ##(UI.StaticText) 34 16 nil 912 34 2 8 1140850955 1 2128 nil nil nil 5 nil nil nil 2128 nil 8 1868316128 1138 nil nil nil 722 34 2 770 #createAt:extent: 34 2 562 361 7 562 25 27 2128 770 #text: 34 1 8 'Id:' 2128 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 180 0 0 0 3 0 0 0 192 0 0 0 16 0 0 0] 8 #() 1360 nil 27 1392 1360 nil 27 410 ##(UI.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 2416 nil nil nil 5 nil nil nil 2416 1048838 ##(UI.FramingLayout) 170 176 34 24 410 ##(UI.ComboBox) 34 17 nil 2416 34 2 8 1152583170 1 2544 787270 2 ##(UI.ListModel) 138 144 640 nil 1769478 ##(Kernel.IdentitySearchPolicy) 1104 nil 5 nil nil nil 2544 nil 8 1868021280 786950 ##(Core.Message) #displayString 8 #() 8 #() 401 722 34 1 770 #createAt:extent: 34 2 562 21 71 562 285 43 2544 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 35 0 0 0 152 0 0 0 56 0 0 0] 8 #() 1360 nil 27 1378374 2 ##(UI.FramingConstraints) 1377286 ##(UI.FramingCalculation) #fixedPreviousLeft 1 2946 #fixedViewLeft 285 2946 #fixedPreviousBottom 5 2946 #fixedViewTop 43 410 ##(UI.SpinButton) 34 15 nil 2416 34 2 8 1140916276 1 3024 918598 2 ##(UI.ValueHolder) nil nil 1704454 ##(Core.PluggableSearchPolicy) 2706 #= 8 #() 2706 #hash 8 #() 1 1104 nil 5 nil nil nil 3024 nil 8 1868243072 1138 nil nil 722 34 3 770 #createAt:extent: 34 2 562 393 71 562 31 43 3024 770 #setRange: 34 1 852742 ##(Core.Interval) 3 201 3 3024 770 #udmSetAccel: 34 1 1508678 1 ##(External.StructureArray) 8 #[0 0 0 0 1 0 0 0 2 0 0 0 5 0 0 0 5 0 0 0 20 0 0 0] 7 ##(OS.UDACCEL) nil 17 3024 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 196 0 0 0 35 0 0 0 211 0 0 0 56 0 0 0] 8 #() 1360 nil 27 2914 2946 #fixedPreviousRight 1 2976 31 2946 #fixedPreviousTop 1 2992 1 410 ##(UI.StaticText) 34 16 nil 2416 34 2 8 1140850956 1 3584 nil nil nil 5 nil nil nil 3584 nil 8 1868316128 1138 nil nil nil 722 34 2 770 #createAt:extent: 34 2 562 21 41 562 61 27 3584 770 #text: 34 1 8 '&Font:' 3584 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 20 0 0 0 40 0 0 0 33 0 0 0] 8 #() 1360 nil 27 2914 2946 #fixedParentLeft 1 2976 61 2946 #fixedParentTop 41 3008 27 410 ##(UI.ComboBox) 34 17 nil 2416 34 2 8 1144063491 1025 3920 2610 138 144 640 nil 2672 1104 nil 5 nil nil nil 3920 nil 8 1868021280 2706 #displayString 8 #() 2752 401 722 34 1 770 #createAt:extent: 34 2 562 183 159 562 185 43 3920 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 91 0 0 0 79 0 0 0 183 0 0 0 100 0 0 0] 8 #() 1360 nil 27 2914 2960 1 2976 185 2992 5 3008 43 410 ##(UI.StaticText) 34 16 nil 2416 34 2 8 1140916492 1 4224 3090 nil false 1769478 ##(Kernel.EqualitySearchPolicy) nil nil nil 5 nil nil nil 4224 nil 8 1868316128 1138 nil nil nil 722 34 2 770 #createAt:extent: 34 2 562 329 41 562 61 27 4224 770 #text: 34 1 8 '&Size:' 4224 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 164 0 0 0 20 0 0 0 194 0 0 0 33 0 0 0] 8 #() 1360 nil 27 2914 3552 25 2976 61 3568 -29 3008 27 410 ##(UI.PushButton) 34 20 nil 2416 34 2 8 1140924416 1 4576 nil 1104 nil 5 nil nil nil 4576 nil 8 1868462064 1377606 4 ##(UI.CommandDescription) #chooseForecolor 8 '…' 1 1 nil nil false nil nil nil 722 34 2 770 #createAt:extent: 34 2 562 121 159 562 41 43 4576 770 #text: 34 1 8 '…' 4576 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 60 0 0 0 79 0 0 0 80 0 0 0 100 0 0 0] 8 #() 1360 nil 29 2914 3552 11 2976 41 3568 1 2992 1 410 ##(UI.StaticText) 34 16 nil 2416 34 2 8 1140916492 1 4912 3090 nil false 4320 nil nil nil 5 nil nil nil 4912 nil 8 1868316128 1138 nil nil nil 722 34 2 770 #createAt:extent: 34 2 562 183 129 562 61 27 4912 770 #text: 34 1 8 'C&ase:' 4912 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 91 0 0 0 64 0 0 0 121 0 0 0 77 0 0 0] 8 #() 1360 nil 27 2914 3552 23 2976 61 3568 -29 3008 27 410 ##(UI.ContainerView) 34 15 nil 2416 34 2 8 1140850688 131073 5232 nil nil nil 5 nil nil nil 5232 594 1 1 1 170 192 34 6 410 ##(UI.CheckBox) 34 16 nil 5232 34 2 8 1140924422 1 5344 3090 nil nil 1572870 ##(Kernel.NeverSearchPolicy) false nil nil 5 nil 482 nil true 655622 ##(OS.LOGFONT) 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 1 0 0 1 2 1 34 77 83 32 83 97 110 115 32 83 101 114 105 102 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 562 193 193 nil 5344 nil 8 1868462064 1138 nil nil nil 722 34 2 770 #createAt:extent: 34 2 562 255 1 562 147 29 5344 770 #text: 34 1 8 '&Underlined' 5344 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 0 0 0 0 0 0 0 200 0 0 0 14 0 0 0] 8 #() 1360 nil 27 8 'isUnderlined' 410 ##(UI.CheckBox) 34 16 nil 5232 34 2 8 1140924422 1 5776 3090 nil nil 5440 false nil nil 5 nil 482 nil true 5474 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 1 2 1 34 77 83 32 83 97 110 115 32 83 101 114 105 102 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 562 193 193 nil 5776 nil 8 1868462064 1138 nil nil nil 722 34 2 770 #createAt:extent: 34 2 562 1 1 562 135 29 5776 770 #text: 34 1 8 '&Bold' 5776 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 67 0 0 0 14 0 0 0] 8 #() 1360 nil 27 8 'isBold' 410 ##(UI.CheckBox) 34 16 nil 5232 34 2 8 1140924422 1 6160 3090 nil nil 5440 false nil nil 5 nil 482 nil true 5474 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 1 0 0 0 1 2 1 34 77 83 32 83 97 110 115 32 83 101 114 105 102 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 562 193 193 nil 6160 nil 8 1868462064 1138 nil nil nil 722 34 2 770 #createAt:extent: 34 2 562 135 1 562 121 29 6160 770 #text: 34 1 8 '&Italic' 6160 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 67 0 0 0 0 0 0 0 127 0 0 0 14 0 0 0] 8 #() 1360 nil 27 8 'isItalic' 658 562 1 1 562 11 1 722 34 1 770 #createAt:extent: 34 2 562 21 225 562 431 29 5232 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 112 0 0 0 225 0 0 0 126 0 0 0] 34 3 5776 6160 5344 1360 nil 27 2914 3888 1 2946 #fixedParentRight 1 2992 25 2946 #fixedParentBottom -25 410 ##(UI.GroupBox) 34 14 nil 2416 34 2 8 1140850695 65 6784 nil nil nil 5 nil nil nil 6784 nil 8 1868462064 722 34 2 770 #createAt:extent: 34 2 562 1 1 562 471 279 6784 770 #text: 34 1 8 'Text' 6784 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 235 0 0 0 139 0 0 0] 8 #() 1360 nil 27 2914 3888 -19 6752 21 3904 1 6768 1 410 ##(UI.ColorView) 34 16 nil 2416 34 2 8 1140850944 262145 7072 3090 nil false 5440 nil nil nil 5 nil nil nil 7072 nil 8 1868316128 1138 nil nil nil 722 34 1 770 #createAt:extent: 34 2 562 21 159 562 91 43 7072 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 79 0 0 0 55 0 0 0 100 0 0 0] 8 #() 1360 nil 27 2914 2960 1 2976 91 2992 5 3008 43 410 ##(UI.TextEdit) 34 16 nil 2416 34 2 8 1140924544 1025 7344 nil 1090 #window nil 5 nil nil nil 7344 nil 8 1868457584 1049670 1 ##(UI.IntegerToText) nil 8 '' 1049350 ##(OS.WindowsLocale) 852998 ##(OS.NUMBERFMTW) 8 #[2 0 0 0 1 0 0 0 3 0 0 0 120 162 108 5 104 162 108 5 1 0 0 0] 8 '.' nil 8 ',' 4115 170 192 34 12 35 5 31 8 ',' 8225 3 37 3 33 8 '3;0' 29 8 '.' nil 1 722 34 2 770 #createAt:extent: 34 2 562 329 71 562 1 43 7344 770 #text: 34 1 8 '0' 7344 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 164 0 0 0 35 0 0 0 164 0 0 0 56 0 0 0] 8 #() 1360 nil 27 2914 2960 1 2976 65 2992 5 3008 43 410 ##(UI.StaticText) 34 16 nil 2416 34 2 8 1140916492 1 7888 3090 nil false 4320 nil nil nil 5 nil nil nil 7888 nil 8 1868316128 1138 nil nil nil 722 34 2 770 #createAt:extent: 34 2 562 21 129 562 61 27 7888 770 #text: 34 1 8 '&Color:' 7888 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 64 0 0 0 40 0 0 0 77 0 0 0] 8 #() 1360 nil 27 2914 3888 1 2976 61 2992 17 3008 27 170 192 34 10 7072 8 'forecolor' 3024 8 'pointSizeSpinner' 7344 8 'pointSize' 3920 8 'case' 2544 8 'faceName' 658 562 21 1 562 21 1 722 34 1 770 #createAt:extent: 34 2 562 1 69 562 471 279 2416 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 34 0 0 0 235 0 0 0 173 0 0 0] 34 12 6784 3584 2544 4224 7344 3024 7888 7072 4576 4912 3920 5232 1360 nil 27 410 ##(UI.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 8512 nil nil nil 5 nil nil nil 8512 2482 170 176 34 10 410 ##(UI.ColorView) 34 16 nil 8512 34 2 8 1140850944 262145 8624 3090 nil false 5440 nil nil nil 5 nil nil nil 8624 nil 8 1868316128 1138 nil nil nil 722 34 1 770 #createAt:extent: 34 2 562 21 69 562 91 43 8624 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 34 0 0 0 55 0 0 0 55 0 0 0] 8 #() 1360 nil 27 2914 2960 1 2976 91 2992 5 3008 43 410 ##(UI.GroupBox) 34 14 nil 8512 34 2 8 1140850695 65 8896 nil nil nil 5 nil nil nil 8896 nil 8 1868462064 722 34 2 770 #createAt:extent: 34 2 562 1 1 562 471 137 8896 770 #text: 34 1 8 'Background' 8896 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 235 0 0 0 68 0 0 0] 8 #() 1360 nil 27 2914 3888 -19 6752 21 3904 1 6768 1 410 ##(UI.StaticText) 34 16 nil 8512 34 2 8 1140850956 1 9184 nil nil nil 5 nil nil nil 9184 nil 8 1868316128 1138 nil nil nil 722 34 2 770 #createAt:extent: 34 2 562 21 39 562 61 27 9184 770 #text: 34 1 8 'C&olor:
' 9184 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 19 0 0 0 40 0 0 0 32 0 0 0] 8 #() 1360 nil 27 2914 3888 1 2976 61 3904 39 3008 27 410 ##(UI.PushButton) 34 20 nil 8512 34 2 8 1141055488 1 9488 nil 1104 nil 5 nil nil nil 9488 nil 8 1868462064 4658 #chooseBackcolor 8 '…' 1 1 nil nil false nil nil nil 722 34 2 770 #createAt:extent: 34 2 562 121 69 562 41 43 9488 770 #text: 34 1 8 '…' 9488 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 60 0 0 0 34 0 0 0 80 0 0 0 55 0 0 0] 8 #() 1360 nil 29 2914 3552 11 2976 41 3568 1 2992 1 410 ##(UI.CheckBox) 34 16 nil 8512 34 2 8 1140924422 1 9808 3090 nil nil 5440 false nil nil 5 nil nil nil 9808 nil 8 1868462064 1138 nil nil nil 722 34 2 770 #createAt:extent: 34 2 562 191 71 562 211 31 9808 770 #text: 34 1 8 'Fill to &end of line' 9808 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 95 0 0 0 35 0 0 0 200 0 0 0 50 0 0 0] 8 #() 1360 nil 27 2914 3552 31 2976 211 3568 3 3008 31 170 192 34 4 8624 8 'backcolor' 9808 8 'isBackcolorExtendedToEndOfLine' 658 562 21 1 562 21 1 722 34 1 770 #createAt:extent: 34 2 562 1 357 562 471 137 8512 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 178 0 0 0 235 0 0 0 246 0 0 0] 34 5 8896 9184 8624 9488 9808 1360 nil 27 410 ##(UI.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 10384 nil nil nil 5 nil nil nil 10384 984838 ##(UI.BorderLayout) 1 11 410 ##(UI.StaticText) 34 16 nil 10384 34 2 8 1140850956 1 10480 3090 nil false 4320 nil nil nil 5 nil nil nil 10480 nil 8 1868316128 1138 nil nil nil 722 34 2 770 #createAt:extent: 34 2 562 21 5 562 435 27 10480 770 #text: 34 1 8 'Preview:' 10480 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 2 0 0 0 227 0 0 0 15 0 0 0] 8 #() 1360 nil 27 nil nil nil 410 ##(UI.Scintilla.ScintillaView) 34 52 nil 10384 34 2 8 1174409476 262145 10784 3090 nil false 4320 nil 1104 nil 5 nil nil nil 10784 nil 8 1862410721 1138 nil 8 '' 43 nil 170 192 34 6 #normal 1444934 1 ##(UI.Scintilla.TextStyle) 1 nil nil 1 nil nil nil nil #normal nil nil nil #indentGuide 10946 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil #callTip 10946 77 1090 #gray 1090 #white 1 nil nil nil nil #callTip nil nil nil nil 1507654 1 ##(UI.Scintilla.NullStyler) #preview 170 192 640 138 ##(Core.IdentitySet) 640 nil 170 176 640 9215 nil nil 170 176 34 2 81 1090 #windowText nil nil 2162950 ##(UI.Scintilla.NullScintillaLibrary) nil 65 nil nil nil 8 '' 3 170 192 34 2 #container 10912 nil nil nil nil 16 nil 170 192 640 nil nil 170 192 640 nil nil nil 722 34 8 770 #createAt:extent: 34 2 562 21 41 562 435 151 10784 770 #text: 34 1 8 '-- Abcdefghijklm … 
	…  nopqrstuvwxyz --' 10784 770 #setMarginWidths: 34 1 8 #(5 5) 10784 770 #wordWrap: 8 #(true) 10784 770 #margins: 34 1 34 3 1247302 3 ##(UI.Scintilla.Margin) 1 10784 1 3 nil nil nil nil 11554 3 10784 1 nil nil 67108863 nil nil 11554 5 10784 1 nil nil nil nil nil 10784 770 #sciSetIndentationGuides: 8 #(1) 10784 770 #targetRange: 34 1 3378 3 87 3 10784 770 #maxCompletionListHeight: 8 #(9) 10784 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 20 0 0 0 227 0 0 0 95 0 0 0] 8 #() 1360 nil 35 170 192 34 2 10784 8 'preview' 658 562 21 5 562 17 1 722 34 1 770 #createAt:extent: 34 2 562 1 503 562 471 191 10384 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 251 0 0 0 235 0 0 0 90 1 0 0] 34 2 10480 10784 1360 nil 27 1360 nil 27 )!

resource_Developer_view
	"Answer the literal data from which the 'Developer view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Developer_view)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.ContainerView) 34 15 nil nil 34 2 8 1409286144 131073 416 nil nil nil 517 nil 852998 ##(Graphics.Font) nil true 721158 ##(OS.LOGFONTW) 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 918022 ##(Graphics.Point) 193 193 nil 416 852806 1 ##(UI.FlowLayout) 11 21 17 170 192 8 #() 1180166 ##(Graphics.Rectangle) 562 1 21 562 1 21 1310982 ##(Core.MessageSequence) 34 1 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 562 12287 21 562 485 791 416 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 241 24 0 0 149 1 0 0] 34 4 410 ##(UI.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 912 nil nil nil 5 nil nil nil 912 594 11 1 9 170 192 34 4 410 ##(UI.TextEdit) 34 16 nil 912 34 2 8 1140916352 1025 1024 nil 917510 ##(Graphics.Color) #default nil 5 nil nil nil 1024 nil 8 1868457584 1049094 ##(UI.NullConverter) nil nil 35 722 34 1 770 #createAt:extent: 34 2 562 391 1 562 69 39 1024 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 195 0 0 0 0 0 0 0 229 0 0 0 19 0 0 0] 8 #() 562 193 193 nil 27 8 'id' 410 ##(UI.TextEdit) 34 16 nil 912 34 2 8 1140916352 1025 1344 nil 1104 nil 5 nil nil nil 1344 nil 8 1868457584 1138 nil nil 1 722 34 2 770 #createAt:extent: 34 2 562 93 1 562 255 39 1344 770 #text: 34 1 8 'Name of style' 1344 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 46 0 0 0 0 0 0 0 173 0 0 0 19 0 0 0] 8 #() 1312 nil 27 8 'name' 658 562 21 1 562 1 1 722 34 1 770 #createAt:extent: 34 2 562 1 21 562 481 39 912 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 10 0 0 0 240 0 0 0 29 0 0 0] 34 4 410 ##(UI.StaticText) 34 16 nil 912 34 2 8 1140850956 1 1840 nil nil nil 5 nil nil nil 1840 nil 8 1868316128 1138 nil nil nil 722 34 2 770 #createAt:extent: 34 2 562 21 7 562 63 27 1840 770 #text: 34 1 8 '&Name:' 1840 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 3 0 0 0 41 0 0 0 16 0 0 0] 8 #() 1312 nil 27 1344 410 ##(UI.StaticText) 34 16 nil 912 34 2 8 1140850955 1 2128 nil nil nil 5 nil nil nil 2128 nil 8 1868316128 1138 nil nil nil 722 34 2 770 #createAt:extent: 34 2 562 357 7 562 25 27 2128 770 #text: 34 1 8 'Id:' 2128 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 178 0 0 0 3 0 0 0 190 0 0 0 16 0 0 0] 8 #() 1312 nil 27 1024 1312 nil 27 410 ##(UI.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 2416 nil nil nil 5 nil nil nil 2416 1048838 ##(UI.FramingLayout) 170 176 34 24 410 ##(UI.ComboBox) 34 17 nil 2416 34 2 8 1152583170 1 2544 787270 2 ##(UI.ListModel) 138 144 640 nil 1769478 ##(Kernel.IdentitySearchPolicy) 1104 nil 5 nil nil nil 2544 nil 8 1868021280 786950 ##(Core.Message) #displayString 8 #() 8 #() 401 722 34 1 770 #createAt:extent: 34 2 562 21 67 562 281 43 2544 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 33 0 0 0 150 0 0 0 54 0 0 0] 8 #() 1312 nil 27 1378374 2 ##(UI.FramingConstraints) 1377286 ##(UI.FramingCalculation) #fixedPreviousLeft 1 2946 #fixedViewLeft 281 2946 #fixedPreviousBottom 1 2946 #fixedViewTop 43 410 ##(UI.StaticText) 34 16 nil 2416 34 2 8 1140916492 1 3024 918598 2 ##(UI.ValueHolder) nil false 1769478 ##(Kernel.EqualitySearchPolicy) nil nil nil 5 nil nil nil 3024 nil 8 1868316128 1138 nil nil nil 722 34 2 770 #createAt:extent: 34 2 562 21 121 562 61 31 3024 770 #text: 34 1 8 '&Color:' 3024 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 60 0 0 0 40 0 0 0 75 0 0 0] 8 #() 1312 nil 27 2914 2946 #fixedParentLeft 1 2976 61 2992 13 3008 31 410 ##(UI.StaticText) 34 16 nil 2416 34 2 8 1140850956 1 3408 nil nil nil 5 nil nil nil 3408 nil 8 1868316128 1138 nil nil nil 722 34 2 770 #createAt:extent: 34 2 562 21 37 562 61 31 3408 770 #text: 34 1 8 '&Font:' 3408 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 18 0 0 0 40 0 0 0 33 0 0 0] 8 #() 1312 nil 27 2914 3392 1 2976 61 2946 #fixedParentTop 37 3008 31 410 ##(UI.ComboBox) 34 17 nil 2416 34 2 8 1144063491 1025 3728 2610 138 144 640 nil 2672 1104 nil 5 nil nil nil 3728 nil 8 1868021280 2706 #displayString 8 #() 2752 401 722 34 1 770 #createAt:extent: 34 2 562 191 151 562 171 43 3728 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 95 0 0 0 75 0 0 0 180 0 0 0 96 0 0 0] 8 #() 1312 nil 27 2914 2960 1 2976 171 2992 1 3008 43 410 ##(UI.StaticText) 34 16 nil 2416 34 2 8 1140916492 1 4032 3090 nil false 3136 nil nil nil 5 nil nil nil 4032 nil 8 1868316128 1138 nil nil nil 722 34 2 770 #createAt:extent: 34 2 562 327 37 562 61 31 4032 770 #text: 34 1 8 '&Size:' 4032 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 163 0 0 0 18 0 0 0 193 0 0 0 33 0 0 0] 8 #() 1312 nil 27 2914 2946 #fixedPreviousRight 27 2976 61 2946 #fixedPreviousTop -29 3008 31 410 ##(UI.SpinButton) 34 15 nil 2416 34 2 8 1140916276 1 4384 3090 nil nil 1704454 ##(Core.PluggableSearchPolicy) 2706 #= 8 #() 2706 #hash 8 #() 1 1104 nil 5 nil nil nil 4384 nil 8 1868243072 1138 nil nil 722 34 3 770 #createAt:extent: 34 2 562 387 67 562 31 43 4384 770 #setRange: 34 1 852742 ##(Core.Interval) 3 201 3 4384 770 #udmSetAccel: 34 1 1508678 1 ##(External.StructureArray) 8 #[0 0 0 0 1 0 0 0 2 0 0 0 5 0 0 0 5 0 0 0 20 0 0 0] 7 ##(OS.UDACCEL) nil 17 4384 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 193 0 0 0 33 0 0 0 208 0 0 0 54 0 0 0] 8 #() 1312 nil 27 2914 4352 1 2976 31 4368 1 2992 1 410 ##(UI.TextEdit) 34 16 nil 2416 34 2 8 1140924544 1025 4896 nil 1090 #window nil 5 nil nil nil 4896 nil 8 1868457584 1049670 1 ##(UI.IntegerToText) nil 8 '' 1049350 ##(OS.WindowsLocale) 852998 ##(OS.NUMBERFMTW) 8 #[2 0 0 0 1 0 0 0 3 0 0 0 120 162 108 5 104 162 108 5 1 0 0 0] 8 '.' nil 8 ',' 4115 170 192 34 12 35 5 31 8 ',' 8225 3 37 3 33 8 '3;0' 29 8 '.' nil 1 722 34 2 770 #createAt:extent: 34 2 562 327 67 562 1 43 4896 770 #text: 34 1 8 '0' 4896 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 163 0 0 0 33 0 0 0 163 0 0 0 54 0 0 0] 8 #() 1312 nil 27 2914 2960 1 2976 61 2992 1 3008 43 410 ##(UI.ColorView) 34 16 nil 2416 34 2 8 1140850944 262145 5440 3090 nil false 1572870 ##(Kernel.NeverSearchPolicy) nil nil nil 5 nil nil nil 5440 nil 8 1868316128 1138 nil nil nil 722 34 1 770 #createAt:extent: 34 2 562 23 153 562 91 43 5440 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 0 76 0 0 0 56 0 0 0 97 0 0 0] 8 #() 1312 nil 27 2914 2960 3 2976 91 2992 3 3008 43 410 ##(UI.PushButton) 34 20 nil 2416 34 2 8 1140924416 1 5744 nil 1104 nil 5 nil nil nil 5744 nil 8 1868462064 1377606 4 ##(UI.CommandDescription) #chooseForecolor 8 '…' 1 1 nil nil false nil nil nil 722 34 2 770 #createAt:extent: 34 2 562 123 153 562 41 43 5744 770 #text: 34 1 8 '…' 5744 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 61 0 0 0 76 0 0 0 81 0 0 0 97 0 0 0] 8 #() 1312 nil 29 2914 4352 11 2976 41 4368 1 2992 1 410 ##(UI.StaticText) 34 16 nil 2416 34 2 8 1140916492 1 6080 3090 nil false 3136 nil nil nil 5 nil nil nil 6080 nil 8 1868316128 1138 nil nil nil 722 34 2 770 #createAt:extent: 34 2 562 191 121 562 61 31 6080 770 #text: 34 1 8 'C&ase:' 6080 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 95 0 0 0 60 0 0 0 125 0 0 0 75 0 0 0] 8 #() 1312 nil 27 2914 4352 29 2976 61 4368 -31 3008 31 410 ##(UI.GroupBox) 34 14 nil 2416 34 2 8 1140850695 65 6400 nil nil nil 5 nil nil nil 6400 nil 8 1868462064 722 34 2 770 #createAt:extent: 34 2 562 1 1 562 485 317 6400 770 #text: 34 1 8 'Text' 6400 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 242 0 0 0 158 0 0 0] 8 #() 1312 nil 27 2914 3392 -19 2946 #fixedParentRight 21 3712 1 2946 #fixedParentBottom 1 410 ##(UI.ContainerView) 34 15 nil 2416 34 2 8 1140850688 131073 6720 nil nil nil 5 nil nil nil 6720 852998 ##(UI.GridLayout) 1 7 11 7 170 192 34 12 410 ##(UI.CheckBox) 34 16 nil 6720 34 2 8 1140924422 1 6848 3090 nil nil 5536 false nil nil 5 nil nil nil 6848 nil 8 1868462064 1138 nil nil nil 722 34 2 770 #createAt:extent: 34 2 562 3 49 562 143 41 6848 770 #text: 34 1 8 '&Read Only' 6848 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 1 0 0 0 24 0 0 0 72 0 0 0 44 0 0 0] 8 #() 1312 nil 27 8 'isReadOnly' 410 ##(UI.CheckBox) 34 16 nil 6720 34 2 8 1140924422 1 7168 3090 nil nil 5536 false nil nil 5 nil nil nil 7168 nil 8 1868462064 1138 nil nil nil 722 34 2 770 #createAt:extent: 34 2 562 155 49 562 141 41 7168 770 #text: 34 1 8 '&Hotspot' 7168 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 77 0 0 0 24 0 0 0 147 0 0 0 44 0 0 0] 8 #() 1312 nil 27 8 'isHotspot' 410 ##(UI.CheckBox) 34 16 nil 6720 34 2 8 1140927750 1 7488 3090 nil nil 5536 false nil nil 5 nil 482 nil true 655622 ##(OS.LOGFONT) 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 1 2 1 34 77 83 32 83 97 110 115 32 83 101 114 105 102 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 562 193 193 nil 7488 nil 8 1868462064 1138 nil nil nil 722 34 2 770 #createAt:extent: 34 2 562 3 1 562 143 43 7488 770 #text: 34 1 8 '&Bold' 7488 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 1 0 0 0 0 0 0 0 72 0 0 0 21 0 0 0] 8 #() 1312 nil 27 8 'isBold' 410 ##(UI.CheckBox) 34 16 nil 6720 34 2 8 1140924422 1 7888 3090 nil nil 5536 false nil nil 5 nil nil nil 7888 nil 8 1868462064 1138 nil nil nil 722 34 2 770 #createAt:extent: 34 2 562 305 49 562 143 41 7888 770 #text: 34 1 8 'In&visible' 7888 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 152 0 0 0 24 0 0 0 223 0 0 0 44 0 0 0] 8 #() 1312 nil 27 8 'isInvisible' 410 ##(UI.CheckBox) 34 16 nil 6720 34 2 8 1140924422 1 8208 3090 nil nil 5536 false nil nil 5 nil 482 nil true 7586 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 1 0 0 0 1 2 1 34 77 83 32 83 97 110 115 32 83 101 114 105 102 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 562 193 193 nil 8208 nil 8 1868462064 1138 nil nil nil 722 34 2 770 #createAt:extent: 34 2 562 155 1 562 141 43 8208 770 #text: 34 1 8 '&Italic' 8208 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 77 0 0 0 0 0 0 0 147 0 0 0 21 0 0 0] 8 #() 1312 nil 27 8 'isItalic' 410 ##(UI.CheckBox) 34 16 nil 6720 34 2 8 1140924422 1 8592 3090 nil nil 5536 false nil nil 5 nil 482 nil true 7586 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 1 0 0 1 2 1 34 77 83 32 83 97 110 115 32 83 101 114 105 102 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 562 193 193 nil 8592 nil 8 1868462064 1138 nil nil nil 722 34 2 770 #createAt:extent: 34 2 562 305 1 562 143 43 8592 770 #text: 34 1 8 '&Underlined' 8592 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 152 0 0 0 0 0 0 0 223 0 0 0 21 0 0 0] 8 #() 1312 nil 27 8 'isUnderlined' 658 562 3 1 562 11 1 722 34 1 770 #createAt:extent: 34 2 562 21 207 562 457 89 6720 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 103 0 0 0 238 0 0 0 147 0 0 0] 34 6 7488 8208 8592 6848 7168 7888 1312 nil 27 2914 3392 1 6688 13 2992 15 6704 -21 170 192 34 10 3728 8 'case' 4896 8 'pointSize' 2544 8 'faceName' 5440 8 'forecolor' 4384 8 'pointSizeSpinner' 658 562 21 1 562 21 1 722 34 1 770 #createAt:extent: 34 2 562 1 79 562 485 317 2416 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 39 0 0 0 242 0 0 0 197 0 0 0] 34 12 6400 3408 2544 4032 4896 4384 3024 5440 5744 6080 3728 6720 1312 nil 27 410 ##(UI.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 9488 nil nil nil 5 nil nil nil 9488 2482 170 176 34 10 410 ##(UI.GroupBox) 34 14 nil 9488 34 2 8 1140850695 65 9600 nil nil nil 5 nil nil nil 9600 nil 8 1868462064 722 34 2 770 #createAt:extent: 34 2 562 1 1 562 485 145 9600 770 #text: 34 1 8 'Background' 9600 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 242 0 0 0 72 0 0 0] 8 #() 1312 nil 27 2914 3392 -19 6688 21 3712 1 6704 11 410 ##(UI.PushButton) 34 20 nil 9488 34 2 8 1141055488 1 9888 nil 1104 nil 5 nil nil nil 9888 nil 8 1868462064 5826 #chooseBackcolor 8 '…' 1 1 nil nil false nil nil nil 722 34 2 770 #createAt:extent: 34 2 562 123 73 562 41 43 9888 770 #text: 34 1 8 '…' 9888 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 61 0 0 0 36 0 0 0 81 0 0 0 57 0 0 0] 8 #() 1312 nil 29 2914 4352 11 2976 41 4368 1 2992 1 410 ##(UI.StaticText) 34 16 nil 9488 34 2 8 1140850956 1 10208 nil nil nil 5 nil nil nil 10208 nil 8 1868316128 1138 nil nil nil 722 34 2 770 #createAt:extent: 34 2 562 21 41 562 61 31 10208 770 #text: 34 1 8 'C&olor:
' 10208 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 20 0 0 0 40 0 0 0 35 0 0 0] 8 #() 1312 nil 27 2914 3392 1 2976 61 3712 41 3008 31 410 ##(UI.ColorView) 34 16 nil 9488 34 2 8 1140850944 262145 10512 3090 nil false 5536 nil nil nil 5 nil nil nil 10512 nil 8 1868316128 1138 nil nil nil 722 34 1 770 #createAt:extent: 34 2 562 23 73 562 91 43 10512 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 0 36 0 0 0 56 0 0 0 57 0 0 0] 8 #() 1312 nil 27 2914 2960 3 2976 91 2992 3 3008 43 410 ##(UI.CheckBox) 34 16 nil 9488 34 2 8 1140924422 1 10784 3090 nil nil 5536 false nil nil 5 nil nil nil 10784 nil 8 1868462064 1138 nil nil nil 722 34 2 770 #createAt:extent: 34 2 562 201 77 562 221 31 10784 770 #text: 34 1 8 'Fill to &end of line' 10784 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 100 0 0 0 38 0 0 0 210 0 0 0 53 0 0 0] 8 #() 1312 nil 27 2914 4352 39 2976 221 4368 5 3008 31 170 192 34 4 10784 8 'isBackcolorExtendedToEndOfLine' 10512 8 'backcolor' 658 562 21 1 562 21 11 722 34 1 770 #createAt:extent: 34 2 562 1 415 562 485 145 9488 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 207 0 0 0 242 0 0 0 23 1 0 0] 34 5 9600 10208 10512 9888 10784 1312 nil 27 410 ##(UI.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 11360 nil nil nil 5 nil nil nil 11360 984838 ##(UI.BorderLayout) 1 11 410 ##(UI.StaticText) 34 16 nil 11360 34 2 8 1140850956 1 11456 3090 nil false 3136 nil nil nil 517 nil nil nil 11456 nil 8 1868316128 1138 nil nil nil 722 34 2 770 #createAt:extent: 34 2 562 21 1 562 449 27 11456 770 #text: 34 1 8 '&Description:' 11456 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 0 0 0 0 234 0 0 0 13 0 0 0] 8 #() 1312 nil 27 nil nil nil 410 ##(UI.Scintilla.ScintillaView) 34 52 nil 11360 34 2 8 1174409476 1025 11760 3090 nil false 3136 nil 1104 nil 5 nil nil nil 11760 nil 8 1862410721 1138 nil 8 '' 9 nil 170 192 34 6 #normal 1444934 1 ##(UI.Scintilla.TextStyle) 1 nil nil 1 nil nil nil nil #normal nil nil nil #indentGuide 11922 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil #callTip 11922 77 1090 #gray 1090 #white 1 nil nil nil nil #callTip nil nil nil nil 1507654 1 ##(UI.Scintilla.NullStyler) #preview 170 192 640 138 ##(Core.IdentitySet) 640 nil 170 176 640 9215 nil nil 170 176 34 2 81 1090 #windowText nil nil 2162950 ##(UI.Scintilla.NullScintillaLibrary) nil 65 nil nil nil 8 '' 3 170 192 34 2 #container 11888 nil nil nil nil 16 nil 170 192 640 nil nil 170 192 640 nil nil nil 722 34 8 770 #createAt:extent: 34 2 562 21 37 562 449 163 11760 770 #text: 34 1 8 '-- Abcdefghijklm …
	… nopqrstuvwxyz --' 11760 770 #setMarginWidths: 34 1 8 #(5 5) 11760 770 #wordWrap: 8 #(true) 11760 770 #margins: 34 1 34 3 1247302 3 ##(UI.Scintilla.Margin) 1 11760 1 3 nil nil nil nil 12530 3 11760 1 nil nil 67108863 nil nil 12530 5 11760 1 nil nil nil nil nil 11760 770 #sciSetIndentationGuides: 8 #(1) 11760 770 #targetRange: 34 1 4722 3 87 3 11760 770 #maxCompletionListHeight: 8 #(9) 11760 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 18 0 0 0 234 0 0 0 99 0 0 0] 8 #() 1312 nil 35 170 192 34 2 11760 8 'preview' 658 562 21 1 562 17 1 722 34 1 770 #createAt:extent: 34 2 562 1 579 562 485 199 11360 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 33 1 0 0 242 0 0 0 132 1 0 0] 34 2 11456 11760 1312 nil 27 1312 nil 27 )! !
!UI.Scintilla.TextStylePresenter class categoriesForMethods!
defaultModel!models!public! !
resource_Default_view!public!resources-views! !
resource_Developer_view!public!resources-views! !
!

