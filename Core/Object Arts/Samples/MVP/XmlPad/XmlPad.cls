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
	^#(#('IdentationGuides' #hasIndentationGuides #hasIndentationGuides:) #('FormattingMarks' #hasFormattingMarks #hasFormattingMarks:) #('WordWrap' #hasWordWrap #hasWordWrap:) #('LineNumbers' #hasLineNumbers #hasLineNumbers:) #('AutoCompleteSingle' #isAutoCompletionSingleMatchChosen #isAutoCompletionSingleMatchChosen:) #('AutoCompleteTruncate' #isAutoCompletionTruncating #isAutoCompletionTruncating:))!

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

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.ShellView)  98 27 0 0 98 2 27131905 131073 416 0 721158 ##(Smalltalk.SystemColor)  31 0 551 0 0 0 416 788230 ##(Smalltalk.BorderLayout)  1 1 410 8 ##(Smalltalk.Toolbar)  98 25 0 416 98 2 8 1140851460 131137 544 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 519 0 263174 ##(Smalltalk.Font)  0 16 459014 ##(Smalltalk.LOGFONT)  8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point)  193 193 0 544 626 656 8 4294903749 234 256 98 0 234 256 98 22 35749 1246982 ##(Smalltalk.ToolbarSystemButton)  35749 0 544 1 1180998 4 ##(Smalltalk.CommandDescription)  8 #fileNew 8 'New' 1 1 0 1 13 35751 882 35751 0 544 1 914 8 #fileOpen 8 'Open' 1 1 0 1 15 35753 882 35753 0 544 1 914 8 #fileSave 8 'Save' 1 1 0 1 17 35755 882 35755 0 544 1 914 8 #printDocument 8 'Print' 1 1 0 1 29 35757 882 35757 0 544 1 914 8 #printPreview 8 'Print Preview' 1 1 0 1 19 35759 882 35759 0 544 1 914 8 #find 8 'Find' 1 1 0 1 25 35761 882 35761 0 544 1 914 8 #cutSelection 8 'Cut' 1 1 0 1 1 35763 882 35763 0 544 1 914 8 #copySelection 8 'Copy' 1 1 0 1 3 35765 882 35765 0 544 1 914 8 #pasteSelection 8 'Paste' 1 1 0 1 5 35767 882 35767 0 544 1 914 8 #clearSelection 8 'Delete' 1 1 0 1 11 35769 882 35769 0 544 1 914 8 #undo 8 'Undo' 1 1 0 1 7 98 14 896 976 1040 1050118 ##(Smalltalk.ToolbarSeparator)  0 0 544 3 0 1 1104 1168 1634 0 0 544 3 0 11 1232 1634 0 0 544 3 0 1 1296 1360 1424 1488 1552 234 240 98 2 1 1 0 1 0 754 33 33 754 45 45 0 656198 1 ##(Smalltalk.FlowLayout)  1 1 1 983302 ##(Smalltalk.MessageSequence)  202 208 98 2 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 754 1 1 754 2369 51 544 1858 8 #updateSize 832 544 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 160 4 0 0 25 0 0 0] 98 0 754 193 193 0 27 410 8 ##(Smalltalk.StatusBar)  98 18 0 416 98 2 8 1140850948 1 2064 0 626 656 0 7 0 674 0 16 706 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 754 193 193 0 2064 0 8 4294903825 234 256 98 2 853766 ##(Smalltalk.StatusBarItem)  1 -1 2064 0 459270 ##(Smalltalk.Message)  8 #displayString 98 0 787814 3 ##(Smalltalk.BlockClosure)  0 0 918822 ##(Smalltalk.CompiledMethod)  3 3 2272 8 #defaultGetImageBlock 462740483 8 #[31 105 226 0 159 106] 8 #icon 8 #imageIndex 2384 7 257 0 1049670 1 ##(Smalltalk.IconImageManager)  8 'status' 98 1 2288 1115142 ##(Smalltalk.StatusBarNullItem)  513 1 2064 0 0 1794 202 208 98 1 1858 1888 98 2 754 1 1497 754 2369 45 2064 1986 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 236 2 0 0 160 4 0 0 2 3 0 0] 98 0 2048 0 27 0 0 410 8 ##(Smalltalk.ScintillaView)  98 46 0 416 98 2 8 1174475012 262145 2752 721990 2 ##(Smalltalk.ValueHolder)  0 32 1310726 ##(Smalltalk.EqualitySearchPolicy)  0 626 656 0 23 0 0 0 2752 0 8 4294903673 852486 ##(Smalltalk.NullConverter)  0 0 9 0 234 256 98 58 8 #number 1182726 ##(Smalltalk.ScintillaTextStyle)  11 196934 1 ##(Smalltalk.RGB)  16711169 0 1 0 0 0 0 2992 0 0 0 8 #singleString 3010 15 3042 16646399 0 1 0 0 0 0 3072 0 0 0 8 #sgmlEntity 3010 57 3042 6710887 3042 33546207 1 0 0 0 0 3120 0 0 0 8 #lineNumber 3010 67 0 0 1 0 0 0 0 3184 0 0 0 8 #unknownTag 3010 5 786694 ##(Smalltalk.IndexedColor)  33554441 0 1 0 0 0 0 3216 0 0 0 8 #otherInsideTag 3010 17 3250 33554443 0 1 0 0 0 0 3280 0 0 0 8 #sgmlDoubleString 3010 49 3250 33554435 3042 33546207 1 0 0 0 0 3328 0 0 0 8 #attribute 3010 7 3250 33554445 0 1 0 0 0 0 3392 0 0 0 8 #identifierStart 3010 27 3312 0 3 0 0 0 0 3440 0 0 0 8 #sgmlError 3010 53 3360 3042 13422079 1 0 0 0 0 3472 0 0 0 8 #identifierEnd 3010 25 3312 0 3 0 0 0 0 3520 0 0 0 8 #entity 3010 21 3312 0 1 0 0 0 0 3552 0 0 0 8 #styleTagEnd 3010 23 3264 0 1 0 0 0 0 3584 0 0 0 8 #sgmlSingleString 3010 51 3042 26419 3042 33546207 1 0 0 0 0 3616 0 0 0 8 #tag 3010 3 3264 0 1 0 0 0 0 3680 0 0 0 8 #normal 3010 1 0 0 1 0 0 0 0 3712 0 0 0 8 #sgmlTag 3010 43 3264 3042 33546207 1 0 0 0 0 3744 0 0 0 8 #comment 3010 19 3042 65793 0 1 0 0 0 0 3792 0 0 0 8 #sgmlComment 3010 59 3042 65793 3042 33546207 1 0 0 0 0 3840 0 0 0 8 #sgmlCommand 3010 45 3264 3042 33546207 3 0 0 0 0 3904 0 0 0 8 #sgmlBlock 3010 63 3042 13369345 3042 29464985 1 0 0 0 0 3952 0 0 0 8 #indentGuide 3010 75 0 0 1 0 0 0 0 4016 0 0 0 8 #sgmlFirstParam 3010 47 3042 52225 3042 33546207 1 0 0 0 0 4048 0 0 0 8 #sgmlSpecial 3010 55 3042 33475687 3042 33546207 1 0 0 0 0 4112 0 0 0 8 #doubleString 3010 13 3042 16646399 0 1 0 0 0 0 4176 0 0 0 8 #CDATA 3010 35 3360 3042 31580671 129 0 0 0 0 4224 0 0 0 8 #unknownAttribute 3010 9 3424 0 1 0 0 0 0 4272 0 0 0 8 #unquotedValue 3010 39 3042 12648641 0 1 0 0 0 0 4304 0 0 0 8 #question 3010 37 3360 0 1 0 0 0 0 4352 0 0 0 98 40 3728 3696 3232 3408 4288 3024 4192 3088 3296 3808 3568 3600 3536 3456 0 0 0 4240 4368 4320 0 3760 3920 4064 3344 3632 3488 4128 3136 3856 0 3968 0 3200 0 0 0 4032 0 0 1245510 1 ##(Smalltalk.NullScintillaStyler)  3712 234 256 98 14 8 #folderTail 1639942 ##(Smalltalk.ScintillaMarkerDefinition)  57 21 3250 33554471 3042 16843009 2752 4464 8 #folderEnd 4482 51 27 4512 4528 2752 4544 8 #folder 4482 61 25 4512 4528 2752 4576 8 #folderMidTail 4482 55 23 4512 4528 2752 4608 8 #folderOpen 4482 63 29 4512 4528 2752 4640 8 #folderSub 4482 59 19 4512 4528 2752 4672 8 #folderOpenMid 4482 53 31 4512 4528 2752 4704 202 208 832 0 63 0 0 0 0 0 3250 33554447 0 0 0 0 0 0 8 '' 5 234 256 98 2 8 #container 2960 0 0 8 #boxTree 33 1 0 234 256 98 6 8 'indicator0' 1509190 1 ##(Smalltalk.ScintillaIndicatorStyle)  1 2752 65025 3 32 0 0 8 'indicator2' 4898 5 2752 511 1 32 0 0 8 'indicator1' 4898 3 2752 33423361 5 32 0 0 1794 202 208 98 10 1858 1888 98 2 754 1 51 754 2369 1447 2752 1858 8 #selectionRange: 98 1 525062 ##(Smalltalk.Interval)  3 1 3 2752 1858 8 #isTextModified: 98 1 32 2752 1858 8 #modificationEventMask: 98 1 123903 2752 1858 8 #wordWrap: 98 1 16 2752 1858 8 #margins: 98 1 98 3 984582 ##(Smalltalk.ScintillaMargin)  1 2752 1 3 32 1 5394 3 2752 1 1 32 67108863 5394 5 2752 33 1 16 -67108863 2752 1858 8 #canHScroll: 98 1 32 2752 1858 8 #indentationGuides: 98 1 0 2752 1858 8 #tabIndents: 98 1 16 2752 1858 8 #setLexerLanguage: 98 1 8 #xml 2752 1986 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 160 4 0 0 236 2 0 0] 98 0 2048 0 27 234 256 98 6 2752 8 'document' 2064 8 'statusbar' 544 8 'toolbar' 0 461638 4 ##(Smalltalk.MenuBar)  0 16 98 4 265030 4 ##(Smalltalk.Menu)  0 16 98 10 984134 2 ##(Smalltalk.CommandMenuItem)  1 914 944 8 '&New' 9373 1 0 0 0 5890 1 914 1008 8 '&Open...' 9375 1 0 0 0 5890 1 914 1072 8 '&Save' 8359 1 0 0 0 5890 1 914 8 #fileSaveAs 8 'Save &As...' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem)  4097 5890 1 914 1136 8 '&Print...' 9377 1 0 0 0 5890 1 914 1200 8 'Print Pre&view' 1 1 0 0 0 5890 1 914 8 #pageSetup 8 'Page Set&up...' 1 1 0 0 0 6114 4097 5890 1 914 8 #exit 8 'E&xit' 1025 1 0 0 0 8 '&File' 0 1 0 0 35703 0 0 5842 0 16 98 16 5890 1 914 1584 8 '&Undo' 9397 1 0 0 0 5890 1 914 8 #redo 8 '&Redo' 9395 1 0 0 0 6114 4097 5890 1 914 1328 8 'Cu&t' 9393 1 0 0 0 5890 1 914 1392 8 '&Copy' 9351 1 0 0 0 5890 1 914 8 #pasteClipboard 8 '&Paste' 9389 1 0 0 0 5890 1 914 8 #pasteSpecial 8 'Paste &Special...' 1 1 0 0 0 5890 1 914 1520 8 'Cle&ar' 1025 1 0 0 0 5890 1 914 8 #selectAll 8 'Select All' 9347 1 0 0 0 6114 4097 5890 1 914 8 #reformatXml 8 'Refor&mat' 1 1 0 0 0 5890 1 914 8 #validateXml 8 '&Validate' 1 1 0 0 0 6114 4097 5890 1 914 1264 8 '&Find...' 9357 1 0 0 0 5890 1 914 8 #findNext 8 'Find &Next' 1253 1 0 0 0 5890 1 914 8 #findReplace 8 'R&eplace...' 9361 1 0 0 0 8 '&Edit' 0 1 0 0 35731 0 0 5842 0 16 98 4 5890 1025 914 8 #viewToolbar 8 '&Toolbar' 1025 1 0 0 0 5890 1025 914 8 #viewStatusBar 8 '&Status Bar' 1025 1 0 0 0 6114 4097 5842 0 16 98 1 5890 1 914 8 #editStyles 8 'Text &Styles' 1 1 0 0 0 8 '&Options' 0 134217729 0 0 35739 0 0 8 '&View' 0 1 0 0 35741 0 0 5842 0 16 98 3 5890 1 914 8 #help 8 '&Help Topics' 1025 1 0 0 0 6114 4097 5890 1 914 8 #about 8 '&About' 1 1 0 0 0 8 '&Help' 0 1 0 0 35747 0 0 8 '' 0 1 0 0 0 0 0 0 0 0 1 0 0 0 0 1 0 0 1794 202 208 98 2 1858 1888 98 2 754 3359 21 754 2401 1653 416 1858 8 #updateMenuBar 832 416 1986 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 143 6 0 0 10 0 0 0 63 11 0 0 68 3 0 0] 98 3 544 2752 2064 2048 0 27 )!

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

