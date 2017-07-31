"Filed out from Dolphin Smalltalk 7"!

TextDocument subclass: #XmlPad
	instanceVariableNames: 'viewOptions'
	classVariableNames: 'RememberPlacementMask'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
XmlPad guid: (GUID fromString: '{0b798c7b-c80f-46ab-9dd4-d8832b78d33c}')!
XmlPad comment: 'XmlPad is a simple XML text editor. It is intended to demonstrate the DocumentShell hierarchy of Dolphin''s application framework, the Scintilla view component, and the use of the MSXML. XmlPad also demonstrates how to use the registry to save and restore user preferences. 

XmlPad show'!
!XmlPad categoriesForClass!MVP-Presenters! !
!XmlPad methodsFor!

about
	"Pop up a little helpful info. about this sample program."

	self class about!

basicValidateXml
	(self parseXml: self getDocumentData validate: true) free!

booleanOptions
	^#(#('AutoCompleteEnabled' #isAutoCompleteEnabled #isAutoCompleteEnabled:))!

booleanViewOptions
	^#(#('IdentationGuides' #hasIndentationGuides #hasIndentationGuides:) #('FormattingMarks' #hasFormattingMarks #hasFormattingMarks:) #('WordWrap' #hasWordWrap #hasWordWrap:) #('LineNumbers' #hasLineNumbers #hasLineNumbers:) #('AutoCompleteSingle' #isAutoCompletionSingleMatchChosen #isAutoCompletionSingleMatchChosen:) #('AutoCompleteTruncate' #isAutoCompletionTruncating #isAutoCompletionTruncating:) #('Folding' #isFoldingEnabled #isFoldingEnabled:))!

canSave
	"Answer whether the document is in a valid state and can be saved. Here we check that the document consists of valid Xml."

	^
	[self basicValidateXml.
	true] on: DOMParseError
			do: 
				[:ex | 
				MessageBox 
					confirm: 'The XML contains one or more errors and is invalid. Are you sure that you would like to save it?'
					caption: ex tag displayString]!

hasFormattingMarks
	^self scintilla whitespaceVisibility ~~ #invisible!

hasFormattingMarks: aBoolean 
	^self scintilla whitespaceVisibility: (aBoolean ifTrue: [#visibleAlways] ifFalse: [#invisible])!

hasIndentationGuides
	^self scintilla hasIndentationGuides!

hasIndentationGuides: aBoolean 
	^self scintilla hasIndentationGuides: aBoolean!

hasLineNumbers
	^self scintilla hasLineNumbers!

hasLineNumbers: aBoolean 
	^self scintilla hasLineNumbers: aBoolean!

hasWordWrap
	^self scintilla wordWrap!

hasWordWrap: aBoolean 
	^self scintilla wordWrap: aBoolean!

initialize
	super initialize.
	viewOptions := 0.!

isAutoCompleteEnabled
	^false!

isAutoCompleteEnabled: aBoolean 
	"Currently ignored as auto-completion is not implemented yet"

	!

isAutoCompletionSingleMatchChosen
	^self scintilla isAutoCompletionSingleMatchChosen!

isAutoCompletionSingleMatchChosen: aBoolean 
	^self scintilla isAutoCompletionSingleMatchChosen: aBoolean!

isAutoCompletionTruncating
	^self scintilla isAutoCompletionTruncating!

isAutoCompletionTruncating: aBoolean 
	^self scintilla isAutoCompletionTruncating: aBoolean!

isFoldingEnabled
	^self scintilla isFoldingEnabled!

isFoldingEnabled: aBoolean 
	self scintilla isFoldingEnabled: aBoolean!

isRememberingPlacement
	^viewOptions allMask: RememberPlacementMask!

isRememberingPlacement: aBoolean 
	viewOptions := viewOptions mask: RememberPlacementMask set: aBoolean!

parseXml
	^self parseXml: self getDocumentData validate: false!

parseXml: aString validate: aBoolean 
	| dom |
	dom := IXMLDOMDocument new.
	"Preserve whitespace in case there are any mixed text/element nodes. This allows the
	formatter to preserve the text of these nodes exactly."
	dom
		preserveWhiteSpace: false;
		validateOnParse: aBoolean;
		resolveExternals: aBoolean.
	(dom loadXML: aString asString) 
		ifFalse: [dom parseErrorClass signal: 'Error in XML' with: dom parseError].
	^dom!

reformatXml
	| dom formatter reformatted |
	dom := [self parseXml] on: DOMParseError
				do: 
					[:ex | 
					statusModel value: ex tag.
					nil].
	dom ifNil: [^self].
	formatter := XmlFormatter new.
	reformatted := formatter format: dom.
	"
	DiffBrowser compare: originalText with: reformatted.
"
	"Replace the text using the Scintilla target feature (this is like an invisible selection).
	If we just set the text, then it would not be undoable."
	(self scintilla)
		targetAll;
		replaceTarget: reformatted!

restoreBooleanOptions: anArrayOfPairs 
	| values |
	values := self userSettingsKey subValues.
	anArrayOfPairs 
		do: [:each | values at: each first ifPresent: [:bool | self perform: each third with: bool asBoolean]]!

restoreTabWidth
	self userSettingsKey subValues at: 'TabWidth' ifPresent: [:width | self tabWidth: width]!

restoreTextStyles
	self userSettingsKey at: 'TextStyles'
		ifPresent: 
			[:key | 
			| styles |
			styles := Object fromRegKey: key.
			self scintilla textStyles: styles]!

restoreUserSettings
	self restoreViewOptions.
	self restoreBooleanOptions: self booleanOptions!

restoreViewOptions
	self restoreBooleanOptions: self booleanViewOptions.
	self restoreTextStyles.
	self restoreTabWidth!

saveBooleanOptions: anArrayOfPairs 
	| values |
	values := self userSettingsKey subValues.
	anArrayOfPairs do: [:each | values at: each first put: (self perform: each second) asParameter]!

saveFontSetting
	self userSettingsKey valueAt: 'Font' put: self view actualFont logFont!

saveOptions
	self saveViewOptions.
	self saveBooleanOptions: self booleanOptions!

saveTabWidth
	self userSettingsKey valueAt: 'TabWidth' put: self tabWidth!

saveTextStyles
	self scintilla textStyles asArray storeUnderRegKey: self userSettingsKey as: 'TextStyles'!

saveUserSettings
	"Private - Save the users configuration to the registry."

	self
		saveOptions;
		saveWindowPlacement!

saveViewOptions
	self userSettingsKey valueAt: 'SavePlacement' put: self isRememberingPlacement asParameter.
	self saveTabWidth.
	self saveBooleanOptions: self booleanViewOptions.
	self saveTextStyles!

saveWindowPlacement
	self isRememberingPlacement 
		ifTrue: 
			[| placement |
			placement := self view placement.
			placement showCmd: (self view isMaximized ifTrue: [SW_SHOWMAXIMIZED] ifFalse: [SW_SHOW]).
			self userSettingsKey valueAt: 'placement' put: placement]
		ifFalse: [self userSettingsKey removeSubValue: 'placement' ifAbsent: []]!

scintilla
	^documentPresenter view!

tabWidth
	^self scintilla tabWidth!

tabWidth: anInteger 
	self scintilla tabWidth: anInteger!

userSettingsKey
	"Private - Answer the <RegKey> under which user settings are stored for the RulesSetBrowser
	itself."

	^self class userSettingsKey!

validateXml
	statusModel value: (
			[self basicValidateXml.
			nil] on: DOMParseError do: [:ex | ex tag])! !
!XmlPad categoriesFor: #about!commands!public! !
!XmlPad categoriesFor: #basicValidateXml!helpers!private! !
!XmlPad categoriesFor: #booleanOptions!helpers!private! !
!XmlPad categoriesFor: #booleanViewOptions!helpers!private! !
!XmlPad categoriesFor: #canSave!public!testing! !
!XmlPad categoriesFor: #hasFormattingMarks!public!testing! !
!XmlPad categoriesFor: #hasFormattingMarks:!accessing!public! !
!XmlPad categoriesFor: #hasIndentationGuides!public!testing! !
!XmlPad categoriesFor: #hasIndentationGuides:!accessing!public! !
!XmlPad categoriesFor: #hasLineNumbers!public!testing! !
!XmlPad categoriesFor: #hasLineNumbers:!accessing!public! !
!XmlPad categoriesFor: #hasWordWrap!public!testing! !
!XmlPad categoriesFor: #hasWordWrap:!accessing!public! !
!XmlPad categoriesFor: #initialize!initializing!public! !
!XmlPad categoriesFor: #isAutoCompleteEnabled!public! !
!XmlPad categoriesFor: #isAutoCompleteEnabled:!public! !
!XmlPad categoriesFor: #isAutoCompletionSingleMatchChosen!public!testing! !
!XmlPad categoriesFor: #isAutoCompletionSingleMatchChosen:!public! !
!XmlPad categoriesFor: #isAutoCompletionTruncating!public!testing! !
!XmlPad categoriesFor: #isAutoCompletionTruncating:!public! !
!XmlPad categoriesFor: #isFoldingEnabled!public!testing! !
!XmlPad categoriesFor: #isFoldingEnabled:!accessing!public! !
!XmlPad categoriesFor: #isRememberingPlacement!commands!public! !
!XmlPad categoriesFor: #isRememberingPlacement:!public!testing! !
!XmlPad categoriesFor: #parseXml!helpers!private! !
!XmlPad categoriesFor: #parseXml:validate:!helpers!private! !
!XmlPad categoriesFor: #reformatXml!commands!public! !
!XmlPad categoriesFor: #restoreBooleanOptions:!operations!private! !
!XmlPad categoriesFor: #restoreTabWidth!operations!private! !
!XmlPad categoriesFor: #restoreTextStyles!helpers!private! !
!XmlPad categoriesFor: #restoreUserSettings!helpers!private! !
!XmlPad categoriesFor: #restoreViewOptions!operations!private! !
!XmlPad categoriesFor: #saveBooleanOptions:!helpers!private! !
!XmlPad categoriesFor: #saveFontSetting!helpers!private! !
!XmlPad categoriesFor: #saveOptions!helpers!private! !
!XmlPad categoriesFor: #saveTabWidth!helpers!private! !
!XmlPad categoriesFor: #saveTextStyles!helpers!private! !
!XmlPad categoriesFor: #saveUserSettings!helpers!private! !
!XmlPad categoriesFor: #saveViewOptions!helpers!private! !
!XmlPad categoriesFor: #saveWindowPlacement!helpers!private! !
!XmlPad categoriesFor: #scintilla!accessing!private! !
!XmlPad categoriesFor: #tabWidth!accessing!private! !
!XmlPad categoriesFor: #tabWidth:!accessing!private! !
!XmlPad categoriesFor: #userSettingsKey!accessing!private! !
!XmlPad categoriesFor: #validateXml!commands!public! !

!XmlPad class methodsFor!

about
	"Private - Pop up a little helpful info. about this sample program."

	(MessageBox new)
		caption: ('About Dolphin <1d>' expandMacrosWith: self);
		icon: self icon;
		text: (self aboutTemplate expandMacrosWith: VMLibrary default fullVersion);
		open!

aboutTemplate
	"Private - Answer the text to be used in the receiver's about box"

	^'XmlPad Sample<n><1s><n>
XmlPad is a simple text-based XML editor. It is intended to demonstrate the DocumentShell hierarchy 
of Dolphin''s application framework, the Scintilla view component, and the use of the MSXML. 
It is also useful for editing Xml!!<n>
DISCLAIMER: This software is freely provided purely as an educational sample and as such it
is provided "as is", WITHOUT ANY WARRANTY; without even the implied warranty of 
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.'!

addSamplesFolderIcon
	Smalltalk developmentSystem 
		addSamplesFolderIconFor: self
		description: self displayString
		helpId: 10625!

defaultFileExtension
	"Answer a default extension that will be used for files saved from
	the receiver"

	^'xml'!

explicitDependencies
	AdvancedFindDialog.
	IRegExp2.
!

fileTypes
	"Answer an Array of file types that can be associated with this class of document."

	^#(#('XML Files (*.xml)' '*.xml') #('All Files (*.*)' '*.*'))!

icon
	"Answers an Icon that can be used to represent this class and which is displayed in the
	caption of the dialog box."

	^Icon fromId: 'XML.ICO'!

initialize
	"
	self initialize
	"
	RememberPlacementMask := 16r1.
	self addSamplesFolderIcon!

installKeyName
	"Private - Answer the name of the base installation registry key."

	^'Software\Object Arts'!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 0 0 8 #(13565952 65536) 416 0 721158 ##(Smalltalk.SystemColor) 31 0 551 0 0 0 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.Toolbar) 34 25 0 416 34 2 8 1140851460 131137 528 0 524550 ##(Smalltalk.ColorRef) 8 4278190080 0 519 0 263174 ##(Smalltalk.Font) 0 true 459014 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 0 528 594 624 8 4294909695 170 192 8 #() 170 192 34 22 19161 1246982 ##(Smalltalk.ToolbarSystemButton) 19161 0 528 1 1180998 4 ##(Smalltalk.CommandDescription) #fileNew 8 'New' 1 1 0 1 13 19163 850 19163 0 528 1 882 #fileOpen 8 'Open' 1 1 0 1 15 19165 850 19165 0 528 1 882 #fileSave 8 'Save' 1 1 0 1 17 19167 850 19167 0 528 1 882 #printDocument 8 'Print' 1 1 0 1 29 19169 850 19169 0 528 1 882 #printPreview 8 'Print Preview' 1 1 0 1 19 19171 850 19171 0 528 1 882 #find 8 'Find' 1 1 0 1 25 19173 850 19173 0 528 1 882 #cutSelection 8 'Cut' 1 1 0 1 1 19175 850 19175 0 528 1 882 #copySelection 8 'Copy' 1 1 0 1 3 19177 850 19177 0 528 1 882 #pasteSelection 8 'Paste' 1 1 0 1 5 19179 850 19179 0 528 1 882 #clearSelection 8 'Delete' 1 1 0 1 11 19181 850 19181 0 528 1 882 #undo 8 'Undo' 1 1 0 1 7 34 14 864 928 976 1050118 ##(Smalltalk.ToolbarSeparator) 0 0 528 3 0 1 1024 1072 1426 0 0 528 3 0 11 1120 1426 0 0 528 3 0 1 1168 1216 1264 1312 1360 170 176 8 #(0 0) 0 1 0 722 33 33 722 45 45 0 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 722 1 1 722 2369 51 528 1650 #updateSizePosted 800 528 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 160 4 0 0 25 0 0 0] 8 #() 722 193 193 0 27 410 ##(Smalltalk.StatusBar) 34 18 0 416 34 2 8 1140850948 1 1824 0 594 624 0 7 0 642 0 true 674 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 722 193 193 0 1824 0 8 4294910823 170 192 34 2 853766 ##(Smalltalk.StatusBarItem) 1 -1 1824 0 459270 ##(Smalltalk.Message) #displayString 8 #() 787814 3 ##(Smalltalk.BlockClosure) 0 0 918822 ##(Smalltalk.CompiledMethod) 3 3 2016 #defaultGetImageBlock 462740483 8 #[31 105 226 0 159 106] #icon #imageIndex 2112 7 257 0 1049926 1 ##(Smalltalk.IconImageManager) 8 'status' 34 1 2032 1115142 ##(Smalltalk.StatusBarNullItem) 513 1 1824 0 0 1586 138 144 34 1 1650 #createAt:extent: 34 2 722 1 1491 722 2369 45 1824 1746 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 233 2 0 0 160 4 0 0 255 2 0 0] 8 #() 1808 0 27 0 0 410 ##(Smalltalk.ScintillaView) 34 50 0 416 34 2 8 1174475012 262145 2432 721990 2 ##(Smalltalk.ValueHolder) 0 false 1310726 ##(Smalltalk.EqualitySearchPolicy) 0 594 624 0 23 0 0 0 2432 0 8 4294909661 852486 ##(Smalltalk.NullConverter) 0 0 9 0 170 192 34 60 #sgmlComment 1182790 1 ##(Smalltalk.ScintillaTextStyle) 59 196934 1 ##(Smalltalk.RGB) 65793 2690 33546207 1 0 0 0 0 #sgmlComment 0 0 0 #otherInsideTag 2658 17 786694 ##(Smalltalk.IndexedColor) 33554443 0 1 0 0 0 0 #otherInsideTag 0 0 0 #singleString 2658 15 2690 16646399 0 1 0 0 0 0 #singleString 0 0 0 #number 2658 11 2690 16711169 0 1 0 0 0 0 #number 0 0 0 #tag 2658 3 2754 33554441 0 1 0 0 0 0 #tag 0 0 0 #comment 2658 19 2690 65793 0 1 0 0 0 0 #comment 0 0 0 #unquotedValue 2658 39 2690 12648641 0 1 0 0 0 0 #unquotedValue 0 0 0 #identifierStart 2658 27 2768 0 3 0 0 0 0 #identifierStart 0 1401 0 #sgmlSingleString 2658 51 2690 26419 2690 33546207 1 0 0 0 0 #sgmlSingleString 0 0 0 #sgmlTag 2658 43 2864 2690 33546207 1 0 0 0 0 #sgmlTag 0 0 0 #normal 2658 1 0 0 1 0 0 0 0 #normal 0 0 0 #question 2658 37 2754 33554435 0 1 0 0 0 0 #question 0 0 0 #CDATA 2658 35 3072 2690 31580671 129 0 0 0 0 #CDATA 0 0 0 #indentGuide 2658 75 0 0 1 0 0 0 0 #indentGuide 0 0 0 #sgmlEntity 2658 57 2690 6710887 2690 33546207 1 0 0 0 0 #sgmlEntity 0 0 0 #unknownAttribute 2658 9 2754 33554445 0 1 0 0 0 0 #unknownAttribute 0 0 0 #callTip 2658 77 2754 33554457 2754 33554471 1 0 0 0 0 #callTip 0 0 0 #unknownTag 2658 5 2864 0 1 0 0 0 0 #unknownTag 0 0 0 #sgmlSpecial 2658 55 2690 33475687 2690 33546207 1 0 0 0 0 #sgmlSpecial 0 0 0 #sgmlCommand 2658 45 2864 2690 33546207 3 0 0 0 0 #sgmlCommand 0 1401 0 #lineNumber 2658 67 0 0 1 0 0 0 0 #lineNumber 0 0 0 #identifierEnd 2658 25 2768 0 3 0 0 0 0 #identifierEnd 0 1401 0 #doubleString 2658 13 2690 16646399 0 1 0 0 0 0 #doubleString 0 0 0 #entity 2658 21 2768 0 1 0 0 0 0 #entity 0 0 0 #attribute 2658 7 3200 0 1 0 0 0 0 #attribute 0 0 0 #sgmlFirstParam 2658 47 2690 52225 2690 33546207 1 0 0 0 0 #sgmlFirstParam 0 0 0 #sgmlError 2658 53 3072 2690 13422079 1 0 0 0 0 #sgmlError 0 0 0 #sgmlBlock 2658 63 2690 13369345 2690 29464985 1 0 0 0 0 #sgmlBlock 0 0 0 #styleTagEnd 2658 23 2864 0 1 0 0 0 0 #styleTagEnd 0 0 0 #sgmlDoubleString 2658 49 3072 2690 33546207 1 0 0 0 0 #sgmlDoubleString 0 0 0 34 40 3040 2848 3264 3440 3184 2816 3392 2784 2736 2880 3424 3584 3376 2944 0 0 0 3088 3056 2912 0 3008 3328 3456 3600 2960 3504 3280 3136 2672 0 3536 0 3360 0 0 0 3120 0 0 1245510 1 ##(Smalltalk.NullScintillaStyler) #normal 170 192 34 14 #folderEnd 1641542 1 ##(Smalltalk.ScintillaMarkerDefinition) 51 11 33554471 33554433 2432 #folderEnd 0 0 0 0 0 0 #folderTail 3714 57 11 33554471 33554433 2432 #folderTail 0 0 0 0 0 0 #folderOpen 3714 63 15 33554471 33554433 2432 #folderOpen 0 0 0 0 0 0 #folderSub 3714 59 11 33554471 33554433 2432 #folderSub 0 0 0 0 0 0 #folderOpenMid 3714 53 11 33554471 33554433 2432 #folderOpenMid 0 0 0 0 0 0 #folder 3714 61 17 33554471 33554433 2432 #folder 0 0 0 0 0 0 #folderMidTail 3714 55 11 33554471 33554433 2432 #folderMidTail 0 0 0 0 0 0 138 ##(Smalltalk.IdentitySet) 800 0 170 176 800 123903 0 0 0 0 2754 33554447 0 0 65 0 0 0 8 '' 5 170 192 34 2 #container 2624 0 0 #plusMinus 33 1 0 170 192 34 6 8 'indicator1' 1510470 2 ##(Smalltalk.ScintillaIndicatorStyle) 3 2432 33423361 5 false 0 0 0 0 0 0 0 8 'indicator0' 3986 1 2432 65025 3 false 0 0 0 0 0 0 0 8 'indicator2' 3986 5 2432 511 1 false 0 0 0 0 0 0 0 0 0 170 192 34 6 #Notification 2658 1027 0 2690 31185883 1 0 0 0 0 #Notification 0 0 0 #Warning 2658 1029 2690 60239 2690 31326207 1 0 0 0 0 #Warning 0 0 0 #Error 2658 1031 2690 335 2690 31317503 1 0 0 0 0 #Error 0 0 0 0 1586 138 144 34 8 1650 #createAt:extent: 34 2 722 1 51 722 2369 1441 2432 1650 #modificationEventMask: 8 #(61951) 2432 1650 #caretPeriod: 8 #(530) 2432 1650 #wordWrap: 8 #(true) 2432 1650 #margins: 34 1 34 3 985158 2 ##(Smalltalk.ScintillaMargin) 1 2432 1 3 0 0 0 0 4498 3 2432 33 0 0 67108863 0 0 4498 5 2432 33 0 3 -67108863 0 0 2432 1650 #canHScroll: 8 #(false) 2432 1650 #maxCompletionListHeight: 8 #(9) 2432 1650 #setLexerLanguage: 8 #(#xml) 2432 1746 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 160 4 0 0 233 2 0 0] 8 #() 1808 0 29 170 192 34 6 2432 8 'document' 1824 8 'statusbar' 528 8 'toolbar' 0 461638 4 ##(Smalltalk.MenuBar) 0 true 34 4 265030 4 ##(Smalltalk.Menu) 0 true 34 10 984134 2 ##(Smalltalk.CommandMenuItem) 1 882 #fileNew 8 '&New' 9373 1 0 0 0 4882 1 882 #fileOpen 8 '&Open...' 9375 1 0 0 0 4882 1 882 #fileSave 8 '&Save' 8359 1 0 0 0 4882 1 882 #fileSaveAs 8 'Save &As...' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem) 4097 4882 1 882 #printDocument 8 '&Print...' 9377 1 0 0 0 4882 1 882 #printPreview 8 'Print Pre&view' 1 1 0 0 0 4882 1 882 #pageSetup 8 'Page Set&up...' 1 1 0 0 0 5090 4097 4882 1 882 #exit 8 'E&xit' 1025 1 0 0 0 8 '&File' 0 1 0 0 19115 0 0 4834 0 true 34 16 4882 1 882 #undo 8 '&Undo' 9397 1 0 0 0 4882 1 882 #redo 8 '&Redo' 9395 1 0 0 0 5090 4097 4882 1 882 #cutSelection 8 'Cu&t' 9393 1 0 0 0 4882 1 882 #copySelection 8 '&Copy' 9351 1 0 0 0 4882 1 882 #pasteClipboard 8 '&Paste' 9389 1 0 0 0 4882 1 882 #pasteSpecial 8 'Paste &Special...' 1 1 0 0 0 4882 1 882 #clearSelection 8 'Cle&ar' 1025 1 0 0 0 4882 1 882 #selectAll 8 'Select All' 9347 1 0 0 0 5090 4097 4882 1 882 #reformatXml 8 'Refor&mat' 1 1 0 0 0 4882 1 882 #validateXml 8 '&Validate' 1 1 0 0 0 5090 4097 4882 1 882 #find 8 '&Find...' 9357 1 0 0 0 4882 1 882 #findNext 8 'Find &Next' 1253 1 0 0 0 4882 1 882 #findReplace 8 'R&eplace...' 9361 1 0 0 0 8 '&Edit' 0 1 0 0 19143 0 0 4834 0 true 34 4 4882 1025 882 #viewToolbar 8 '&Toolbar' 1025 1 0 0 0 4882 1025 882 #viewStatusBar 8 '&Status Bar' 1025 1 0 0 0 5090 4097 4834 0 true 34 1 4882 1 882 #editStyles 8 'Text &Styles' 1 1 0 0 0 8 '&Options' 0 134217729 0 0 19151 0 0 8 '&View' 0 1 0 0 19153 0 0 4834 0 true 34 3 4882 1 882 #help 8 '&Help Topics' 1025 1 0 0 0 5090 4097 4882 1 882 #about 8 '&About' 1 1 0 0 0 8 '&Help' 0 1 0 0 19159 0 0 8 '' 0 1 0 0 0 0 0 0 0 0 1 0 0 0 0 1 0 0 1586 138 144 34 2 1650 #createAt:extent: 34 2 722 3839 21 722 2401 1653 416 1650 #updateMenuBar 800 416 1746 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 47 12 0 0 68 3 0 0] 34 3 528 2432 1824 1808 0 27 )!

toolName
	^self name!

uninitialize
	"Private - Uninitialize the receiver as it is about to be removed from the system.
		self uninitialize
	"

	Smalltalk developmentSystem removeSystemFolderIconNamed: self displayString!

userSettingsKey
	"Private - Answer the <RegKey> under which user specific settings should be stored."

	^self userSettingsRootKey createKey: self toolName!

userSettingsRootKey
	^RegKey userRoot createKey: self installKeyName! !
!XmlPad class categoriesFor: #about!enquiries!private! !
!XmlPad class categoriesFor: #aboutTemplate!enquiries!private! !
!XmlPad class categoriesFor: #addSamplesFolderIcon!development!initializing!private! !
!XmlPad class categoriesFor: #defaultFileExtension!constants!public! !
!XmlPad class categoriesFor: #explicitDependencies!must not strip!private! !
!XmlPad class categoriesFor: #fileTypes!constants!public! !
!XmlPad class categoriesFor: #icon!constants!public! !
!XmlPad class categoriesFor: #initialize!initializing!public! !
!XmlPad class categoriesFor: #installKeyName!accessing!public! !
!XmlPad class categoriesFor: #resource_Default_view!public!resources-views! !
!XmlPad class categoriesFor: #toolName!accessing!public! !
!XmlPad class categoriesFor: #uninitialize!development!initializing!private! !
!XmlPad class categoriesFor: #userSettingsKey!accessing!public! !
!XmlPad class categoriesFor: #userSettingsRootKey!accessing!public! !

