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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 721158 ##(Smalltalk.SystemColor) 31 nil 517 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.Toolbar) 34 25 nil 416 34 2 8 1140853508 131137 528 nil 786694 ##(Smalltalk.ColorDefault) 8 4278190080 nil 517 nil 263174 ##(Smalltalk.Font) nil true 459014 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 nil 528 608 8 1915204752 170 192 8 #() 170 192 34 22 48681 1246790 1 ##(Smalltalk.ToolbarSystemButton) 528 1 1180998 4 ##(Smalltalk.CommandDescription) #fileNew 8 'New' 1 1 nil 48681 1 13 48683 834 528 1 866 #fileOpen 8 'Open' 1 1 nil 48683 1 15 48685 834 528 1 866 #fileSave 8 'Save' 1 1 nil 48685 1 17 48687 834 528 1 866 #printDocument 8 'Print' 1 1 nil 48687 1 29 48689 834 528 1 866 #printPreview 8 'Print Preview' 1 1 nil 48689 1 19 48691 834 528 1 866 #find 8 'Find' 1 1 nil 48691 1 25 48693 834 528 1 866 #cutSelection 8 'Cut' 1 1 nil 48693 1 1 48695 834 528 1 866 #copySelection 8 'Copy' 1 1 nil 48695 1 3 48697 834 528 1 866 #pasteSelection 8 'Paste' 1 1 nil 48697 1 5 48699 834 528 1 866 #clearSelection 8 'Delete' 1 1 nil 48699 1 11 48701 834 528 1 866 #undo 8 'Undo' 1 1 nil 48701 1 7 34 14 848 912 960 1049158 1 ##(Smalltalk.ToolbarSeparator) 528 1 1008 1056 1410 528 11 1104 1410 528 1 1152 1200 1248 1296 1344 nil nil 1 nil 722 33 33 722 45 45 nil 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 722 1 1 722 2369 51 528 1602 #updateSizePosted 784 528 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 160 4 0 0 25 0 0 0] 8 #() 722 193 193 nil 27 410 ##(Smalltalk.StatusBar) 34 18 nil 416 34 2 8 1140850948 1 1776 nil 608 nil 5 nil 642 nil true 674 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 722 193 193 nil 1776 nil 8 1914952576 170 192 34 2 853766 ##(Smalltalk.StatusBarItem) 1 -1 1776 nil 459270 ##(Smalltalk.Message) #displayString 8 #() 787814 3 ##(Smalltalk.BlockClosure) 0 nil 918822 ##(Smalltalk.CompiledMethod) 3 3 1952 #defaultGetImageBlock 462740483 8 #[31 105 226 0 159 106] #icon #imageIndex 2048 7 257 nil 1049926 1 ##(Smalltalk.IconImageManager) 8 'status' 34 1 1968 1115142 ##(Smalltalk.StatusBarNullItem) 513 1 1776 nil nil 1538 138 144 34 1 1602 #createAt:extent: 34 2 722 1 1491 722 2369 45 1776 1698 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 233 2 0 0 160 4 0 0 255 2 0 0] 8 #() 1760 nil 27 nil nil 410 ##(Smalltalk.ScintillaView) 34 50 nil 416 34 2 8 1174475012 262145 2368 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil 608 nil 21 nil nil nil 2368 nil 8 1825558121 852486 ##(Smalltalk.NullConverter) nil nil 9 nil 170 192 34 60 #normal 1182790 1 ##(Smalltalk.ScintillaTextStyle) 1 nil nil 1 nil nil nil nil #normal nil nil nil #unknownAttribute 2578 9 786694 ##(Smalltalk.IndexedColor) 33554445 nil 1 nil nil nil nil #unknownAttribute nil nil nil #attribute 2578 7 2640 nil 1 nil nil nil nil #attribute nil nil nil #sgmlSpecial 2578 55 196934 1 ##(Smalltalk.RGB) 33475687 2690 33546207 1 nil nil nil nil #sgmlSpecial nil nil nil #sgmlDoubleString 2578 49 2626 33554435 2690 33546207 1 nil nil nil nil #sgmlDoubleString nil nil nil #sgmlTag 2578 43 2626 33554441 2690 33546207 1 nil nil nil nil #sgmlTag nil nil nil #question 2578 37 2752 nil 1 nil nil nil nil #question nil nil nil #sgmlComment 2578 59 2690 65793 2690 33546207 1 nil nil nil nil #sgmlComment nil nil nil #sgmlSingleString 2578 51 2690 26419 2690 33546207 1 nil nil nil nil #sgmlSingleString nil nil nil #sgmlBlock 2578 63 2690 13369345 2690 29464985 1 nil nil nil nil #sgmlBlock nil nil nil #callTip 2578 77 2626 33554457 2626 33554471 1 nil nil nil nil #callTip nil nil nil #sgmlEntity 2578 57 2690 6710887 2690 33546207 1 nil nil nil nil #sgmlEntity nil nil nil #tag 2578 3 2800 nil 1 nil nil nil nil #tag nil nil nil #unknownTag 2578 5 2800 nil 1 nil nil nil nil #unknownTag nil nil nil #sgmlFirstParam 2578 47 2690 52225 2690 33546207 1 nil nil nil nil #sgmlFirstParam nil nil nil #identifierStart 2578 27 2626 33554443 nil 3 nil nil nil nil #identifierStart nil 1401 nil #doubleString 2578 13 2690 16646399 nil 1 nil nil nil nil #doubleString nil nil nil #indentGuide 2578 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil #otherInsideTag 2578 17 3184 nil 1 nil nil nil nil #otherInsideTag nil nil nil #sgmlError 2578 53 2752 2690 13422079 1 nil nil nil nil #sgmlError nil nil nil #sgmlCommand 2578 45 2800 2690 33546207 3 nil nil nil nil #sgmlCommand nil 1401 nil #styleTagEnd 2578 23 2800 nil 1 nil nil nil nil #styleTagEnd nil nil nil #unquotedValue 2578 39 2690 12648641 nil 1 nil nil nil nil #unquotedValue nil nil nil #CDATA 2578 35 2752 2690 31580671 129 nil nil nil nil #CDATA nil nil nil #lineNumber 2578 67 nil nil 1 nil nil nil nil #lineNumber nil nil nil #singleString 2578 15 2690 16646399 nil 1 nil nil nil nil #singleString nil nil nil #entity 2578 21 3184 nil 1 nil nil nil nil #entity nil nil nil #identifierEnd 2578 25 3184 nil 3 nil nil nil nil #identifierEnd nil 1401 nil #number 2578 11 2690 16711169 nil 1 nil nil nil nil #number nil nil nil #comment 2578 19 2690 65793 nil 1 nil nil nil nil #comment nil nil nil 34 40 2592 3088 3104 2656 2608 3488 3200 3424 3248 3520 3456 3328 3472 3168 nil nil nil 3376 2832 3344 nil 2784 3296 3120 2736 2896 3264 2672 3040 2848 nil 2944 nil 3408 nil nil nil 3232 nil nil 1245510 1 ##(Smalltalk.NullScintillaStyler) #normal 170 192 34 14 #folderMidTail 1641542 1 ##(Smalltalk.ScintillaMarkerDefinition) 55 11 33554471 33554433 2368 #folderMidTail nil nil nil nil nil nil #folderTail 3634 57 11 33554471 33554433 2368 #folderTail nil nil nil nil nil nil #folderSub 3634 59 11 33554471 33554433 2368 #folderSub nil nil nil nil nil nil #folderOpenMid 3634 53 11 33554471 33554433 2368 #folderOpenMid nil nil nil nil nil nil #folderEnd 3634 51 11 33554471 33554433 2368 #folderEnd nil nil nil nil nil nil #folderOpen 3634 63 15 33554471 33554433 2368 #folderOpen nil nil nil nil nil nil #folder 3634 61 17 33554471 33554433 2368 #folder nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 784 nil 170 176 784 123903 nil nil nil nil 2626 33554447 nil nil 65 nil nil nil 8 '' 5 170 192 34 2 #container 2544 nil nil #plusMinus 33 130003 nil 170 192 34 6 8 'indicator2' 1510470 2 ##(Smalltalk.ScintillaIndicatorStyle) 5 2368 511 1 false nil nil nil nil nil nil nil 8 'indicator0' 3906 1 2368 65025 3 false nil nil nil nil nil nil nil 8 'indicator1' 3906 3 2368 33423361 5 false nil nil nil nil nil nil nil nil nil 170 192 34 6 #Notification 2578 1027 nil 2690 31185883 1 nil nil nil nil #Notification nil nil nil #Warning 2578 1029 2690 60239 2690 31326207 1 nil nil nil nil #Warning nil nil nil #Error 2578 1031 2690 335 2690 31317503 1 nil nil nil nil #Error nil nil nil nil 1538 138 144 34 9 1602 #createAt:extent: 34 2 722 1 51 722 2369 1441 2368 1602 #textLimit: 8 #(1073741823) 2368 1602 #modificationEventMask: 8 #(61951) 2368 1602 #caretPeriod: 8 #(530) 2368 1602 #wordWrap: 8 #(true) 2368 1602 #margins: 34 1 34 3 985158 2 ##(Smalltalk.ScintillaMargin) 1 2368 1 3 nil nil nil nil 4450 3 2368 33 nil nil 67108863 nil nil 4450 5 2368 33 nil 3 -67108863 nil nil 2368 1602 #canHScroll: 8 #(false) 2368 1602 #maxCompletionListHeight: 8 #(9) 2368 1602 #setLexerLanguage: 8 #(#xml) 2368 1698 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 160 4 0 0 233 2 0 0] 8 #() 1760 nil 29 170 192 34 6 2368 8 'document' 1776 8 'statusbar' 528 8 'toolbar' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 4 265030 4 ##(Smalltalk.Menu) nil true 34 10 984134 2 ##(Smalltalk.CommandMenuItem) 1 866 #fileNew 8 '&New' 9373 1 nil nil nil 4834 1 866 #fileOpen 8 '&Open...' 9375 1 nil nil nil 4834 1 866 #fileSave 8 '&Save' 8359 1 nil nil nil 4834 1 866 #fileSaveAs 8 'Save &As...' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 4834 1 866 #printDocument 8 '&Print...' 9377 1 nil nil nil 4834 1 866 #printPreview 8 'Print Pre&view' 1 1 nil nil nil 4834 1 866 #pageSetup 8 'Page Set&up...' 1 1 nil nil nil 5042 4097 4834 1 866 #exit 8 'E&xit' 1025 1 nil nil nil 8 '&File' nil 1 nil nil 48635 nil nil 4786 nil true 34 16 4834 1 866 #undo 8 '&Undo' 9397 1 nil nil nil 4834 1 866 #redo 8 '&Redo' 9395 1 nil nil nil 5042 4097 4834 1 866 #cutSelection 8 'Cu&t' 9393 1 nil nil nil 4834 1 866 #copySelection 8 '&Copy' 9351 1 nil nil nil 4834 1 866 #pasteClipboard 8 '&Paste' 9389 1 nil nil nil 4834 1 866 #pasteSpecial 8 'Paste &Special...' 1 1 nil nil nil 4834 1 866 #clearSelection 8 'Cle&ar' 1025 1 nil nil nil 4834 1 866 #selectAll 8 'Select All' 9347 1 nil nil nil 5042 4097 4834 1 866 #reformatXml 8 'Refor&mat' 1 1 nil nil nil 4834 1 866 #validateXml 8 '&Validate' 1 1 nil nil nil 5042 4097 4834 1 866 #find 8 '&Find...' 9357 1 nil nil nil 4834 1 866 #findNext 8 'Find &Next' 1253 1 nil nil nil 4834 1 866 #findReplace 8 'R&eplace...' 9361 1 nil nil nil 8 '&Edit' nil 1 nil nil 48663 nil nil 4786 nil true 34 4 4834 1025 866 #viewToolbar 8 '&Toolbar' 1025 1 nil nil nil 4834 1025 866 #viewStatusBar 8 '&Status Bar' 1025 1 nil nil nil 5042 4097 4786 nil true 34 1 4834 1 866 #editStyles 8 'Text &Styles' 1 1 nil nil nil 8 '&Options' nil 134217729 nil nil 48671 nil nil 8 '&View' nil 1 nil nil 48673 nil nil 4786 nil true 34 3 4834 1 866 #help 8 '&Help Topics' 1025 1 nil nil nil 5042 4097 4834 1 866 #about 8 '&About' 1 1 nil nil nil 8 '&Help' nil 1 nil nil 48679 nil nil 8 '' nil 1 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 1538 138 144 34 2 1602 #createAt:extent: 34 2 722 53 53 722 2401 1653 416 1602 #updateMenuBar 784 416 1698 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 26 0 0 0 26 0 0 0 202 4 0 0 84 3 0 0] 34 3 528 2368 1776 1760 nil 27 )!

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

