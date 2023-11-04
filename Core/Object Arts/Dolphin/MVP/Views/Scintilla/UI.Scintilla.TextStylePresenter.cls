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

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.ContainerView} 38 #{Core.Array} 15 nil nil 50 2 8 1409286144 131073 32 nil nil nil 517 nil 1030 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 518 #{Graphics.Point} 193 193 nil 32 838 1 #{UI.FlowLayout} 11 11 17 550 #{Core.IdentityDictionary} 0 518 #{Graphics.Rectangle} 194 1 21 194 1 21 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createAt:extent: 50 2 194 6143 21 194 471 711 32 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 234 12 0 0 109 1 0 0] 50 4 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 544 nil nil nil 5 nil nil nil 544 226 11 1 9 518 #{Kernel.STBIdentityDictionaryProxy} 256 50 4 18 #{UI.TextEdit} 50 20 nil 544 50 2 8 1140916352 1025 672 nil 6 #{Graphics.Color} #default nil 5 nil nil nil 672 nil nil 518 #{UI.NullConverter} nil nil 35 #focusLost nil nil nil 354 50 1 402 #createAt:extent: 50 2 194 395 1 194 61 39 672 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 197 0 0 0 0 0 0 0 227 0 0 0 19 0 0 0] 8 #() 194 193 193 nil 45 8 'id' 18 #{UI.TextEdit} 50 20 nil 544 50 2 8 1140916352 1025 976 nil 752 nil 5 nil nil nil 976 nil nil 770 nil nil 35 #focusLost nil nil nil 354 50 2 402 #createAt:extent: 50 2 194 93 1 194 259 39 976 402 #text: 50 1 8 'Name of style' 976 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 46 0 0 0 0 0 0 0 175 0 0 0 19 0 0 0] 8 #() 944 nil 45 8 'name' 290 194 21 1 194 1 1 354 50 1 402 #createAt:extent: 50 2 194 1 21 194 471 39 544 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 10 0 0 0 235 0 0 0 29 0 0 0] 50 4 18 #{UI.StaticText} 50 16 nil 544 50 2 8 1140850956 1 1456 nil nil nil 5 nil nil nil 1456 nil nil 770 nil nil nil 354 50 2 402 #createAt:extent: 50 2 194 21 7 194 63 27 1456 402 #text: 50 1 8 'Name:' 1456 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 3 0 0 0 41 0 0 0 16 0 0 0] 8 #() 944 nil 27 976 18 #{UI.StaticText} 50 16 nil 544 50 2 8 1140850955 1 1728 nil nil nil 5 nil nil nil 1728 nil nil 770 nil nil nil 354 50 2 402 #createAt:extent: 50 2 194 361 7 194 25 27 1728 402 #text: 50 1 8 'Id:' 1728 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 180 0 0 0 3 0 0 0 192 0 0 0 16 0 0 0] 8 #() 944 nil 27 672 944 nil 27 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 2000 nil nil nil 5 nil nil nil 2000 262 #{UI.FramingLayout} 626 #{Core.LookupTable} 50 24 18 #{UI.GroupBox} 50 14 nil 2000 50 2 8 1140850695 65 2128 nil nil nil 5 nil nil nil 2128 nil nil 354 50 2 402 #createAt:extent: 50 2 194 1 1 194 471 279 2128 402 #text: 50 1 8 'Text' 2128 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 235 0 0 0 139 0 0 0] 8 #() 944 nil 27 2118 2 #{UI.FramingConstraints} 1030 #{UI.FramingCalculation} #fixedParentLeft -19 2418 #fixedParentRight 21 2418 #fixedParentTop 1 2418 #fixedParentBottom 1 18 #{UI.StaticText} 50 16 nil 2000 50 2 8 1140850956 1 2496 nil nil nil 5 nil nil nil 2496 nil nil 770 nil nil nil 354 50 2 402 #createAt:extent: 50 2 194 21 41 194 61 27 2496 402 #text: 50 1 8 '&Font:' 2496 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 20 0 0 0 40 0 0 0 33 0 0 0] 8 #() 944 nil 27 2386 2432 1 2418 #fixedViewLeft 61 2464 41 2418 #fixedViewTop 27 18 #{UI.StaticText} 50 16 nil 2000 50 2 8 1140916492 1 2816 1094 2 #{UI.ValueHolder} nil false 6 #{Kernel.EqualitySearchPolicy} nil nil nil 5 nil nil nil 2816 nil nil 770 nil nil nil 354 50 2 402 #createAt:extent: 50 2 194 329 41 194 61 27 2816 402 #text: 50 1 8 '&Size:' 2816 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 164 0 0 0 20 0 0 0 194 0 0 0 33 0 0 0] 8 #() 944 nil 27 2386 2418 #fixedPreviousRight 25 2784 61 2418 #fixedPreviousTop -29 2800 27 18 #{UI.ComboBox} 50 17 nil 2000 50 2 8 1152583170 1 3200 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} 752 nil 5 nil nil nil 3200 nil nil 518 #{Core.Message} #displayString 8 #() 8 #() 401 354 50 1 402 #createAt:extent: 50 2 194 21 71 194 285 43 3200 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 35 0 0 0 152 0 0 0 56 0 0 0] 8 #() 944 nil 27 2386 2418 #fixedPreviousLeft 1 2784 285 2418 #fixedPreviousBottom 5 2800 43 18 #{UI.TextEdit} 50 20 nil 2000 50 2 8 1140924544 1025 3616 nil 738 #window nil 5 nil nil nil 3616 nil nil 1094 1 #{UI.IntegerToText} nil 8 '' 326 1 #{Core.Locale} #userDefault nil 1 #focusLost nil nil nil 354 50 2 402 #createAt:extent: 50 2 194 329 71 194 1 43 3616 402 #text: 50 1 8 '0' 3616 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 164 0 0 0 35 0 0 0 164 0 0 0 56 0 0 0] 8 #() 944 nil 45 2386 3584 1 2784 65 3600 5 2800 43 18 #{UI.SpinButton} 50 15 nil 2000 50 2 8 1140916276 1 3984 2882 nil nil 518 #{Kernel.PluggableSearchPolicy} 3362 #= 8 #() 3362 #hash 8 #() 1 752 nil 5 nil nil nil 3984 nil nil 770 nil nil 354 50 3 402 #createAt:extent: 50 2 194 393 71 194 31 43 3984 402 #setRange: 50 1 774 #{Core.Interval} 3 201 3 3984 402 #udmSetAccel: 50 1 1350 1 #{External.StructureArray} 8 #[0 0 0 0 1 0 0 0 2 0 0 0 5 0 0 0 5 0 0 0 20 0 0 0] 7 #{OS.UDACCEL} nil 17 3984 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 196 0 0 0 35 0 0 0 211 0 0 0 56 0 0 0] 8 #() 944 nil 27 2386 3168 1 2784 31 3184 1 3600 1 18 #{UI.StaticText} 50 16 nil 2000 50 2 8 1140916492 1 4480 2882 nil false 2928 nil nil nil 5 nil nil nil 4480 nil nil 770 nil nil nil 354 50 2 402 #createAt:extent: 50 2 194 21 129 194 61 27 4480 402 #text: 50 1 8 '&Color:' 4480 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 64 0 0 0 40 0 0 0 77 0 0 0] 8 #() 944 nil 27 2386 2432 1 2784 61 3600 17 2800 27 18 #{UI.StaticText} 50 16 nil 2000 50 2 8 1140916492 1 4784 2882 nil false 2928 nil nil nil 5 nil nil nil 4784 nil nil 770 nil nil nil 354 50 2 402 #createAt:extent: 50 2 194 183 129 194 61 27 4784 402 #text: 50 1 8 'C&ase:' 4784 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 91 0 0 0 64 0 0 0 121 0 0 0 77 0 0 0] 8 #() 944 nil 27 2386 3168 23 2784 61 3184 -29 2800 27 18 #{UI.ColorView} 50 16 nil 2000 50 2 8 1140850944 262145 5088 2882 nil false 6 #{Kernel.NeverSearchPolicy} nil nil nil 5 nil nil nil 5088 nil nil 770 nil nil nil 354 50 1 402 #createAt:extent: 50 2 194 21 159 194 91 43 5088 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 79 0 0 0 55 0 0 0 100 0 0 0] 8 #() 944 nil 27 2386 3584 1 2784 91 3600 5 2800 43 18 #{UI.PushButton} 50 20 nil 2000 50 2 8 1140924416 1 5376 nil 752 nil 5 nil nil nil 5376 nil nil 1350 4 #{UI.CommandDescription} #chooseForecolor 8 '…' 1 1 nil nil false nil nil nil 354 50 2 402 #createAt:extent: 50 2 194 121 159 194 41 43 5376 402 #text: 50 1 8 '…' 5376 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 60 0 0 0 79 0 0 0 80 0 0 0 100 0 0 0] 8 #() 944 nil 29 2386 3168 11 2784 41 3184 1 3600 1 18 #{UI.ComboBox} 50 17 nil 2000 50 2 8 1144063491 1025 5696 3266 3298 0 nil 3344 752 nil 5 nil nil nil 5696 nil nil 3362 #displayString 8 #() 3408 401 354 50 1 402 #createAt:extent: 50 2 194 183 159 194 185 43 5696 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 91 0 0 0 79 0 0 0 183 0 0 0 100 0 0 0] 8 #() 944 nil 27 2386 3584 1 2784 185 3600 5 2800 43 18 #{UI.ContainerView} 50 15 nil 2000 50 2 8 1140850688 131073 5984 nil nil nil 5 nil nil nil 5984 226 1 1 1 626 256 50 6 18 #{UI.CheckBox} 50 16 nil 5984 50 2 8 1140924422 1 6096 2882 nil nil 5184 false nil nil 5 nil 114 nil true 146 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 0 0 0 0 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 194 193 193 nil 6096 nil nil 770 nil nil nil 354 50 2 402 #createAt:extent: 50 2 194 1 1 194 135 29 6096 402 #text: 50 1 8 '&Bold' 6096 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 67 0 0 0 14 0 0 0] 8 #() 944 nil 27 8 'isBold' 18 #{UI.CheckBox} 50 16 nil 5984 50 2 8 1140924422 1 6464 2882 nil nil 5184 false nil nil 5 nil 114 nil true 146 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 1 0 0 0 0 0 0 0 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 6224 nil 6464 nil nil 770 nil nil nil 354 50 2 402 #createAt:extent: 50 2 194 135 1 194 121 29 6464 402 #text: 50 1 8 '&Italic' 6464 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 67 0 0 0 0 0 0 0 127 0 0 0 14 0 0 0] 8 #() 944 nil 27 8 'isItalic' 18 #{UI.CheckBox} 50 16 nil 5984 50 2 8 1140924422 1 6816 2882 nil nil 5184 false nil nil 5 nil 114 nil true 146 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 1 0 0 0 0 0 0 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 6224 nil 6816 nil nil 770 nil nil nil 354 50 2 402 #createAt:extent: 50 2 194 255 1 194 153 29 6816 402 #text: 50 1 8 '&Underlined' 6816 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 0 0 0 0 0 0 0 203 0 0 0 14 0 0 0] 8 #() 944 nil 27 8 'isUnderlined' 290 194 1 1 194 11 1 354 50 1 402 #createAt:extent: 50 2 194 21 225 194 431 29 5984 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 112 0 0 0 225 0 0 0 126 0 0 0] 50 3 6096 6464 6816 944 nil 27 2386 2432 1 2448 1 3600 25 2480 -25 626 256 50 10 5696 8 'case' 3200 8 'faceName' 5088 8 'forecolor' 3616 8 'pointSize' 3984 8 'pointSizeSpinner' 290 194 21 1 194 21 1 354 50 1 402 #createAt:extent: 50 2 194 1 69 194 471 279 2000 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 34 0 0 0 235 0 0 0 173 0 0 0] 50 12 2128 2496 3200 2816 3616 3984 4480 5088 5376 4784 5696 5984 944 nil 27 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 7680 nil nil nil 5 nil nil nil 7680 2066 626 #{Core.LookupTable} 50 10 18 #{UI.GroupBox} 50 14 nil 7680 50 2 8 1140850695 65 7792 nil nil nil 5 nil nil nil 7792 nil nil 354 50 2 402 #createAt:extent: 50 2 194 1 1 194 471 137 7792 402 #text: 50 1 8 'Background' 7792 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 235 0 0 0 68 0 0 0] 8 #() 944 nil 27 2386 2432 -19 2448 21 2464 1 2480 1 18 #{UI.StaticText} 50 16 nil 7680 50 2 8 1140850956 1 8064 nil nil nil 5 nil nil nil 8064 nil nil 770 nil nil nil 354 50 2 402 #createAt:extent: 50 2 194 21 39 194 61 27 8064 402 #text: 50 1 8 'C&olor:
' 8064 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 19 0 0 0 40 0 0 0 32 0 0 0] 8 #() 944 nil 27 2386 2432 1 2784 61 2464 39 2800 27 18 #{UI.ColorView} 50 16 nil 7680 50 2 8 1140850944 262145 8352 2882 nil false 5184 nil nil nil 5 nil nil nil 8352 nil nil 770 nil nil nil 354 50 1 402 #createAt:extent: 50 2 194 21 69 194 91 43 8352 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 34 0 0 0 55 0 0 0 55 0 0 0] 8 #() 944 nil 27 2386 3584 1 2784 91 3600 5 2800 43 18 #{UI.PushButton} 50 20 nil 7680 50 2 8 1141055488 1 8608 nil 752 nil 5 nil nil nil 8608 nil nil 5442 #chooseBackcolor 8 '…' 1 1 nil nil false nil nil nil 354 50 2 402 #createAt:extent: 50 2 194 121 69 194 41 43 8608 402 #text: 50 1 8 '…' 8608 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 60 0 0 0 34 0 0 0 80 0 0 0 55 0 0 0] 8 #() 944 nil 29 2386 3168 11 2784 41 3184 1 3600 1 18 #{UI.CheckBox} 50 16 nil 7680 50 2 8 1140924422 1 8912 2882 nil nil 5184 false nil nil 5 nil nil nil 8912 nil nil 770 nil nil nil 354 50 2 402 #createAt:extent: 50 2 194 191 71 194 211 31 8912 402 #text: 50 1 8 'Fill to &end of line' 8912 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 95 0 0 0 35 0 0 0 200 0 0 0 50 0 0 0] 8 #() 944 nil 27 2386 3168 31 2784 211 3184 3 2800 31 626 256 50 4 8352 8 'backcolor' 8912 8 'isBackcolorExtendedToEndOfLine' 290 194 21 1 194 21 1 354 50 1 402 #createAt:extent: 50 2 194 1 357 194 471 137 7680 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 178 0 0 0 235 0 0 0 246 0 0 0] 50 5 7792 8064 8352 8608 8912 944 nil 27 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 9472 nil nil nil 5 nil nil nil 9472 1798 #{UI.BorderLayout} 1 11 18 #{UI.StaticText} 50 16 nil 9472 50 2 8 1140850956 1 9568 2882 nil false 2928 nil nil nil 5 nil nil nil 9568 nil nil 770 nil nil nil 354 50 2 402 #createAt:extent: 50 2 194 21 5 194 435 27 9568 402 #text: 50 1 8 'Preview:' 9568 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 2 0 0 0 227 0 0 0 15 0 0 0] 8 #() 944 nil 27 nil nil nil 18 #{UI.Scintilla.ScintillaView} 50 56 nil 9472 50 2 8 1174409476 262145 9856 2882 nil false 2928 nil 752 nil 5 nil nil nil 9856 nil nil 770 nil 8 '' 43 #focusLost nil nil nil nil 258 3 #callTip 3142 1 #{UI.Scintilla.TextStyle} 77 738 #gray 738 #white 1 nil nil nil nil #callTip nil nil nil #indentGuide 9986 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil #normal 9986 1 nil nil 1 nil nil nil nil #normal nil nil nil nil 326 1 #{UI.Scintilla.NullStyler} #preview 258 0 294 #{Core.IdentitySet} 0 nil 550 #{Core.LookupTable} 0 9215 nil nil 10162 1 81 738 #windowText nil nil 262 #{UI.Scintilla.NullScintillaLibrary} nil 65 nil nil nil nil 3 258 1 #container 9968 nil nil nil nil #{Core.Utf8String} nil 258 0 nil nil 258 0 nil nil nil 354 50 8 402 #createAt:extent: 50 2 194 21 41 194 435 151 9856 402 #text: 50 1 8 '-- Abcdefghijklm … 
	…  nopqrstuvwxyz --' 9856 402 #setMarginWidths: 50 1 8 #(5 5) 9856 402 #wordWrap: 8 #(true) 9856 402 #margins: 50 1 50 3 2118 3 #{UI.Scintilla.Margin} 1 9856 nil 3 nil nil nil nil 10578 3 9856 nil nil nil 67108863 nil nil 10578 5 9856 nil nil nil nil nil nil 9856 402 #sciSetIndentationGuides: 8 #(1) 9856 402 #targetRange: 50 1 4306 3 91 3 9856 402 #maxCompletionListHeight: 8 #(9) 9856 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 20 0 0 0 227 0 0 0 95 0 0 0] 8 #() 944 nil 45 626 256 50 2 9856 8 'preview' 290 194 21 5 194 17 1 354 50 1 402 #createAt:extent: 50 2 194 1 503 194 471 191 9472 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 251 0 0 0 235 0 0 0 90 1 0 0] 50 2 9568 9856 944 nil 27 944 nil 27)!

resource_Developer_view
	"Answer the literal data from which the 'Developer view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Developer_view)
	"

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.ContainerView} 38 #{Core.Array} 15 nil nil 50 2 8 1409286144 131073 32 nil nil nil 517 nil 1030 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 518 #{Graphics.Point} 193 193 nil 32 838 1 #{UI.FlowLayout} 11 21 17 550 #{Core.IdentityDictionary} 0 518 #{Graphics.Rectangle} 194 1 21 194 1 21 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createAt:extent: 50 2 194 6143 21 194 485 791 32 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 241 12 0 0 149 1 0 0] 50 4 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 544 nil nil nil 5 nil nil nil 544 226 11 1 9 518 #{Kernel.STBIdentityDictionaryProxy} 256 50 4 18 #{UI.TextEdit} 50 20 nil 544 50 2 8 1140916352 1025 672 nil 6 #{Graphics.Color} #default nil 5 nil nil nil 672 nil nil 518 #{UI.NullConverter} nil nil 35 #focusLost nil nil nil 354 50 1 402 #createAt:extent: 50 2 194 391 1 194 69 39 672 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 195 0 0 0 0 0 0 0 229 0 0 0 19 0 0 0] 8 #() 194 193 193 nil 45 8 'id' 18 #{UI.TextEdit} 50 20 nil 544 50 2 8 1140916352 1025 976 nil 752 nil 5 nil nil nil 976 nil nil 770 nil nil 1 #focusLost nil nil nil 354 50 2 402 #createAt:extent: 50 2 194 93 1 194 255 39 976 402 #text: 50 1 8 'Name of style' 976 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 46 0 0 0 0 0 0 0 173 0 0 0 19 0 0 0] 8 #() 944 nil 45 8 'name' 290 194 21 1 194 1 1 354 50 1 402 #createAt:extent: 50 2 194 1 21 194 481 39 544 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 10 0 0 0 240 0 0 0 29 0 0 0] 50 4 18 #{UI.StaticText} 50 16 nil 544 50 2 8 1140850956 1 1456 nil nil nil 5 nil nil nil 1456 nil nil 770 nil nil nil 354 50 2 402 #createAt:extent: 50 2 194 21 7 194 63 27 1456 402 #text: 50 1 8 '&Name:' 1456 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 3 0 0 0 41 0 0 0 16 0 0 0] 8 #() 944 nil 27 976 18 #{UI.StaticText} 50 16 nil 544 50 2 8 1140850955 1 1728 nil nil nil 5 nil nil nil 1728 nil nil 770 nil nil nil 354 50 2 402 #createAt:extent: 50 2 194 357 7 194 25 27 1728 402 #text: 50 1 8 'Id:' 1728 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 178 0 0 0 3 0 0 0 190 0 0 0 16 0 0 0] 8 #() 944 nil 27 672 944 nil 27 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 2000 nil nil nil 5 nil nil nil 2000 262 #{UI.FramingLayout} 626 #{Core.LookupTable} 50 24 18 #{UI.GroupBox} 50 14 nil 2000 50 2 8 1140850695 65 2128 nil nil nil 5 nil nil nil 2128 nil nil 354 50 2 402 #createAt:extent: 50 2 194 1 1 194 485 317 2128 402 #text: 50 1 8 'Text' 2128 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 242 0 0 0 158 0 0 0] 8 #() 944 nil 27 2118 2 #{UI.FramingConstraints} 1030 #{UI.FramingCalculation} #fixedParentLeft -19 2418 #fixedParentRight 21 2418 #fixedParentTop 1 2418 #fixedParentBottom 1 18 #{UI.StaticText} 50 16 nil 2000 50 2 8 1140850956 1 2496 nil nil nil 5 nil nil nil 2496 nil nil 770 nil nil nil 354 50 2 402 #createAt:extent: 50 2 194 21 37 194 61 31 2496 402 #text: 50 1 8 '&Font:' 2496 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 18 0 0 0 40 0 0 0 33 0 0 0] 8 #() 944 nil 27 2386 2432 1 2418 #fixedViewLeft 61 2464 37 2418 #fixedViewTop 31 18 #{UI.StaticText} 50 16 nil 2000 50 2 8 1140916492 1 2816 1094 2 #{UI.ValueHolder} nil false 6 #{Kernel.EqualitySearchPolicy} nil nil nil 5 nil nil nil 2816 nil nil 770 nil nil nil 354 50 2 402 #createAt:extent: 50 2 194 327 37 194 61 31 2816 402 #text: 50 1 8 '&Size:' 2816 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 163 0 0 0 18 0 0 0 193 0 0 0 33 0 0 0] 8 #() 944 nil 27 2386 2418 #fixedPreviousRight 27 2784 61 2418 #fixedPreviousTop -29 2800 31 18 #{UI.ComboBox} 50 17 nil 2000 50 2 8 1152583170 1 3200 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} 752 nil 5 nil nil nil 3200 nil nil 518 #{Core.Message} #displayString 8 #() 8 #() 401 354 50 1 402 #createAt:extent: 50 2 194 21 67 194 281 43 3200 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 33 0 0 0 150 0 0 0 54 0 0 0] 8 #() 944 nil 27 2386 2418 #fixedPreviousLeft 1 2784 281 2418 #fixedPreviousBottom 1 2800 43 18 #{UI.TextEdit} 50 20 nil 2000 50 2 8 1140924544 1025 3616 nil 738 #window nil 5 nil nil nil 3616 nil nil 1094 1 #{UI.IntegerToText} nil 8 '' 326 1 #{Core.Locale} #userDefault nil 1 #focusLost nil nil nil 354 50 2 402 #createAt:extent: 50 2 194 327 67 194 1 43 3616 402 #text: 50 1 8 '0' 3616 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 163 0 0 0 33 0 0 0 163 0 0 0 54 0 0 0] 8 #() 944 nil 45 2386 3584 1 2784 61 3600 1 2800 43 18 #{UI.SpinButton} 50 15 nil 2000 50 2 8 1140916276 1 3984 2882 nil nil 518 #{Kernel.PluggableSearchPolicy} 3362 #= 8 #() 3362 #hash 8 #() 1 752 nil 5 nil nil nil 3984 nil nil 770 nil nil 354 50 3 402 #createAt:extent: 50 2 194 387 67 194 31 43 3984 402 #setRange: 50 1 774 #{Core.Interval} 3 201 3 3984 402 #udmSetAccel: 50 1 1350 1 #{External.StructureArray} 8 #[0 0 0 0 1 0 0 0 2 0 0 0 5 0 0 0 5 0 0 0 20 0 0 0] 7 #{OS.UDACCEL} nil 17 3984 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 193 0 0 0 33 0 0 0 208 0 0 0 54 0 0 0] 8 #() 944 nil 27 2386 3168 1 2784 31 3184 1 3600 1 18 #{UI.StaticText} 50 16 nil 2000 50 2 8 1140916492 1 4480 2882 nil false 2928 nil nil nil 5 nil nil nil 4480 nil nil 770 nil nil nil 354 50 2 402 #createAt:extent: 50 2 194 21 121 194 61 31 4480 402 #text: 50 1 8 '&Color:' 4480 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 60 0 0 0 40 0 0 0 75 0 0 0] 8 #() 944 nil 27 2386 2432 1 2784 61 3600 13 2800 31 18 #{UI.StaticText} 50 16 nil 2000 50 2 8 1140916492 1 4784 2882 nil false 2928 nil nil nil 5 nil nil nil 4784 nil nil 770 nil nil nil 354 50 2 402 #createAt:extent: 50 2 194 191 121 194 61 31 4784 402 #text: 50 1 8 'C&ase:' 4784 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 95 0 0 0 60 0 0 0 125 0 0 0 75 0 0 0] 8 #() 944 nil 27 2386 3168 29 2784 61 3184 -31 2800 31 18 #{UI.ComboBox} 50 17 nil 2000 50 2 8 1144063491 1025 5088 3266 3298 0 nil 3344 752 nil 5 nil nil nil 5088 nil nil 3362 #displayString 8 #() 3408 401 354 50 1 402 #createAt:extent: 50 2 194 191 151 194 171 43 5088 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 95 0 0 0 75 0 0 0 180 0 0 0 96 0 0 0] 8 #() 944 nil 27 2386 3584 1 2784 171 3600 1 2800 43 18 #{UI.ColorView} 50 16 nil 2000 50 2 8 1140850944 262145 5376 2882 nil false 6 #{Kernel.NeverSearchPolicy} nil nil nil 5 nil nil nil 5376 nil nil 770 nil nil nil 354 50 1 402 #createAt:extent: 50 2 194 23 153 194 91 43 5376 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 0 76 0 0 0 56 0 0 0 97 0 0 0] 8 #() 944 nil 27 2386 3584 3 2784 91 3600 3 2800 43 18 #{UI.PushButton} 50 20 nil 2000 50 2 8 1140924416 1 5664 nil 752 nil 5 nil nil nil 5664 nil nil 1350 4 #{UI.CommandDescription} #chooseForecolor 8 '…' 1 1 nil nil false nil nil nil 354 50 2 402 #createAt:extent: 50 2 194 123 153 194 41 43 5664 402 #text: 50 1 8 '…' 5664 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 61 0 0 0 76 0 0 0 81 0 0 0 97 0 0 0] 8 #() 944 nil 29 2386 3168 11 2784 41 3184 1 3600 1 18 #{UI.ContainerView} 50 15 nil 2000 50 2 8 1140850688 131073 5984 nil nil nil 5 nil nil nil 5984 1030 #{UI.GridLayout} 1 7 5 7 626 256 50 12 18 #{UI.CheckBox} 50 16 nil 5984 50 2 8 1140927750 1 6112 2882 nil nil 5472 false nil nil 5 nil 114 nil true 146 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 194 193 193 nil 6112 nil nil 770 nil nil nil 354 50 2 402 #createAt:extent: 50 2 194 3 1 194 149 43 6112 402 #text: 50 1 8 '&Bold' 6112 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 1 0 0 0 0 0 0 0 75 0 0 0 21 0 0 0] 8 #() 944 nil 27 8 'isBold' 18 #{UI.CheckBox} 50 16 nil 5984 50 2 8 1140924422 1 6480 2882 nil nil 5472 false nil nil 5 nil nil nil 6480 nil nil 770 nil nil nil 354 50 2 402 #createAt:extent: 50 2 194 155 49 194 147 41 6480 402 #text: 50 1 8 '&Hotspot' 6480 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 77 0 0 0 24 0 0 0 150 0 0 0 44 0 0 0] 8 #() 944 nil 27 8 'isHotspot' 18 #{UI.CheckBox} 50 16 nil 5984 50 2 8 1140924422 1 6784 2882 nil nil 5472 false nil nil 5 nil nil nil 6784 nil nil 770 nil nil nil 354 50 2 402 #createAt:extent: 50 2 194 305 49 194 149 41 6784 402 #text: 50 1 8 'In&visible' 6784 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 152 0 0 0 24 0 0 0 226 0 0 0 44 0 0 0] 8 #() 944 nil 27 8 'isInvisible' 18 #{UI.CheckBox} 50 16 nil 5984 50 2 8 1140924422 1 7088 2882 nil nil 5472 false nil nil 5 nil 114 nil true 146 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 255 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 6240 nil 7088 nil nil 770 nil nil nil 354 50 2 402 #createAt:extent: 50 2 194 155 1 194 147 43 7088 402 #text: 50 1 8 '&Italic' 7088 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 77 0 0 0 0 0 0 0 150 0 0 0 21 0 0 0] 8 #() 944 nil 27 8 'isItalic' 18 #{UI.CheckBox} 50 16 nil 5984 50 2 8 1140924422 1 7440 2882 nil nil 5472 false nil nil 5 nil nil nil 7440 nil nil 770 nil nil nil 354 50 2 402 #createAt:extent: 50 2 194 3 49 194 149 41 7440 402 #text: 50 1 8 '&Read Only' 7440 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 1 0 0 0 24 0 0 0 75 0 0 0 44 0 0 0] 8 #() 944 nil 27 8 'isReadOnly' 18 #{UI.CheckBox} 50 16 nil 5984 50 2 8 1140924422 1 7744 2882 nil nil 5472 false nil nil 5 nil 114 nil true 146 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 1 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 6240 nil 7744 nil nil 770 nil nil nil 354 50 2 402 #createAt:extent: 50 2 194 305 1 194 149 43 7744 402 #text: 50 1 8 '&Underlined' 7744 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 152 0 0 0 0 0 0 0 226 0 0 0 21 0 0 0] 8 #() 944 nil 27 8 'isUnderlined' 290 194 3 1 194 5 1 354 50 1 402 #createAt:extent: 50 2 194 21 207 194 457 89 5984 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 103 0 0 0 238 0 0 0 147 0 0 0] 50 6 6112 7088 7744 7440 6480 6784 944 nil 27 2386 2432 1 2448 13 3600 15 2480 -21 626 256 50 10 5088 8 'case' 3200 8 'faceName' 5376 8 'forecolor' 3616 8 'pointSize' 3984 8 'pointSizeSpinner' 290 194 21 1 194 21 1 354 50 1 402 #createAt:extent: 50 2 194 1 79 194 485 317 2000 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 39 0 0 0 242 0 0 0 197 0 0 0] 50 12 2128 2496 3200 2816 3616 3984 4480 5376 5664 4784 5088 5984 944 nil 27 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 8608 nil nil nil 5 nil nil nil 8608 2066 626 #{Core.LookupTable} 50 10 18 #{UI.GroupBox} 50 14 nil 8608 50 2 8 1140850695 65 8720 nil nil nil 5 nil nil nil 8720 nil nil 354 50 2 402 #createAt:extent: 50 2 194 1 1 194 485 145 8720 402 #text: 50 1 8 'Background' 8720 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 242 0 0 0 72 0 0 0] 8 #() 944 nil 27 2386 2432 -19 2448 21 2464 1 2480 11 18 #{UI.StaticText} 50 16 nil 8608 50 2 8 1140850956 1 8992 nil nil nil 5 nil nil nil 8992 nil nil 770 nil nil nil 354 50 2 402 #createAt:extent: 50 2 194 21 41 194 61 31 8992 402 #text: 50 1 8 'C&olor:
' 8992 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 20 0 0 0 40 0 0 0 35 0 0 0] 8 #() 944 nil 27 2386 2432 1 2784 61 2464 41 2800 31 18 #{UI.ColorView} 50 16 nil 8608 50 2 8 1140850944 262145 9280 2882 nil false 5472 nil nil nil 5 nil nil nil 9280 nil nil 770 nil nil nil 354 50 1 402 #createAt:extent: 50 2 194 23 73 194 91 43 9280 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 0 36 0 0 0 56 0 0 0 57 0 0 0] 8 #() 944 nil 27 2386 3584 3 2784 91 3600 3 2800 43 18 #{UI.PushButton} 50 20 nil 8608 50 2 8 1141055488 1 9536 nil 752 nil 5 nil nil nil 9536 nil nil 5730 #chooseBackcolor 8 '…' 1 1 nil nil false nil nil nil 354 50 2 402 #createAt:extent: 50 2 194 123 73 194 41 43 9536 402 #text: 50 1 8 '…' 9536 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 61 0 0 0 36 0 0 0 81 0 0 0 57 0 0 0] 8 #() 944 nil 29 2386 3168 11 2784 41 3184 1 3600 1 18 #{UI.CheckBox} 50 16 nil 8608 50 2 8 1140924422 1 9840 2882 nil nil 5472 false nil nil 5 nil nil nil 9840 nil nil 770 nil nil nil 354 50 2 402 #createAt:extent: 50 2 194 201 77 194 221 31 9840 402 #text: 50 1 8 'Fill to &end of line' 9840 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 100 0 0 0 38 0 0 0 210 0 0 0 53 0 0 0] 8 #() 944 nil 27 2386 3168 39 2784 221 3184 5 2800 31 626 256 50 4 9280 8 'backcolor' 9840 8 'isBackcolorExtendedToEndOfLine' 290 194 21 1 194 21 11 354 50 1 402 #createAt:extent: 50 2 194 1 415 194 485 145 8608 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 207 0 0 0 242 0 0 0 23 1 0 0] 50 5 8720 8992 9280 9536 9840 944 nil 27 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 10400 nil nil nil 5 nil nil nil 10400 1798 #{UI.BorderLayout} 1 11 18 #{UI.StaticText} 50 16 nil 10400 50 2 8 1140850956 1 10496 2882 nil false 2928 nil nil nil 517 nil nil nil 10496 nil nil 770 nil nil nil 354 50 2 402 #createAt:extent: 50 2 194 21 1 194 449 27 10496 402 #text: 50 1 8 '&Description:' 10496 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 0 0 0 0 234 0 0 0 13 0 0 0] 8 #() 944 nil 27 nil nil nil 18 #{UI.Scintilla.ScintillaView} 50 56 nil 10400 50 2 8 1174409476 1025 10784 2882 nil false 2928 nil 752 nil 5 nil nil nil 10784 nil nil 770 nil 8 '' 9 #focusLost nil nil nil nil 258 3 #callTip 3142 1 #{UI.Scintilla.TextStyle} 77 738 #gray 738 #white 1 nil nil nil nil #callTip nil nil nil #indentGuide 10914 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil #normal 10914 1 nil nil 1 nil nil nil nil #normal nil nil nil nil 326 1 #{UI.Scintilla.NullStyler} #preview 258 0 294 #{Core.IdentitySet} 0 nil 550 #{Core.LookupTable} 0 9215 nil nil 11090 1 81 738 #windowText nil nil 262 #{UI.Scintilla.NullScintillaLibrary} nil 65 nil nil nil nil 3 258 1 #container 10896 nil nil nil nil #{Core.Utf8String} nil 258 0 nil nil 258 0 nil nil nil 354 50 8 402 #createAt:extent: 50 2 194 21 37 194 449 163 10784 402 #text: 50 1 8 '-- Abcdefghijklm … 
	…  nopqrstuvwxyz --' 10784 402 #setMarginWidths: 50 1 8 #(5 5) 10784 402 #wordWrap: 8 #(true) 10784 402 #margins: 50 1 50 3 2118 3 #{UI.Scintilla.Margin} 1 10784 nil 3 nil nil nil nil 11506 3 10784 nil nil nil 67108863 nil nil 11506 5 10784 nil nil nil nil nil nil 10784 402 #sciSetIndentationGuides: 8 #(1) 10784 402 #targetRange: 50 1 4306 3 91 3 10784 402 #maxCompletionListHeight: 8 #(9) 10784 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 18 0 0 0 234 0 0 0 99 0 0 0] 8 #() 944 nil 45 626 256 50 2 10784 8 'preview' 290 194 21 1 194 17 1 354 50 1 402 #createAt:extent: 50 2 194 1 579 194 485 199 10400 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 33 1 0 0 242 0 0 0 132 1 0 0] 50 2 10496 10784 944 nil 27 944 nil 27)! !
!UI.Scintilla.TextStylePresenter class categoriesForMethods!
defaultModel!models!public! !
resource_Default_view!public!resources-views! !
resource_Developer_view!public!resources-views! !
!

