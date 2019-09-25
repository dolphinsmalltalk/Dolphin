"Filed out from Dolphin Smalltalk 7"!

TextDocument subclass: #XmlPad
	instanceVariableNames: 'viewOptions'
	classVariableNames: 'RememberPlacementMask'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
XmlPad guid: (GUID fromString: '{0b798c7b-c80f-46ab-9dd4-d8832b78d33c}')!
XmlPad addClassConstant: 'RememberPlacementMask' value: 16r1!
XmlPad comment: '`XmlPad` is a simple XML text editor. It is intended to demonstrate the `DocumentShell` hierarchy of Dolphin''s application framework, the `ScintillaView` editor component, and the use of the MSXML. XmlPad also demonstrates how to use the registry to save and restore user preferences. 

```
XmlPad show
```'!
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

queryCommand: query
	"Private - Enters details about a potential command for the receiver into 
	the <CommandQuery>, query"

	| cmd |
	cmd := query commandSymbol.
	cmd == #viewToolbar
		ifTrue: 
			[query
				isEnabled: true;
				isChecked: self toolbar isWindowVisible.
			^true].
	cmd == #viewStatusBar
		ifTrue: 
			[query
				isEnabled: true;
				isChecked: self statusBar isWindowVisible.
			^true].
	^super queryCommand: query!

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

statusBar
	^self view viewNamed: 'statusbar'!

tabWidth
	^self scintilla tabWidth!

tabWidth: anInteger 
	self scintilla tabWidth: anInteger!

toolbar
	^self view viewNamed: 'toolbar'!

userSettingsKey
	"Private - Answer the <RegKey> under which user settings are stored for the RulesSetBrowser
	itself."

	^self class userSettingsKey!

validateXml
	statusModel value: (
			[self basicValidateXml.
			nil] on: DOMParseError do: [:ex | ex tag])!

viewStatusBar
	| statusBar |
	statusBar := self statusBar.
	statusBar isWindowVisible ifTrue: [statusBar hide] ifFalse: [statusBar show]!

viewToolbar
	| toolbar |
	toolbar := self toolbar.
	toolbar isWindowVisible ifTrue: [toolbar hide] ifFalse: [toolbar show]! !
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
!XmlPad categoriesFor: #queryCommand:!commands!private! !
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
!XmlPad categoriesFor: #statusBar!accessing!private! !
!XmlPad categoriesFor: #tabWidth!accessing!private! !
!XmlPad categoriesFor: #tabWidth:!accessing!private! !
!XmlPad categoriesFor: #toolbar!accessing!private! !
!XmlPad categoriesFor: #userSettingsKey!accessing!private! !
!XmlPad categoriesFor: #validateXml!commands!public! !
!XmlPad categoriesFor: #viewStatusBar!commands!private! !
!XmlPad categoriesFor: #viewToolbar!commands!private! !

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

defaultFileExtension
	"Answer a default extension that will be used for files saved from
	the receiver"

	^'xml'!

explicitDependencies
	AdvancedFindDialog
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

	self addClassConstant: 'RememberPlacementMask' value: 1!

installKeyName
	"Private - Answer the name of the base installation registry key."

	^'Software\Object Arts'!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 327686 ##(Smalltalk.Color) #face3d nil 549 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.Toolbar) 34 25 nil 416 34 2 8 1140853508 131137 528 nil 466 #default nil 519 nil 263174 ##(Smalltalk.Font) nil true 459014 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 nil 528 592 8 1903898080 170 192 8 #() 170 192 34 18 28425 1246790 1 ##(Smalltalk.ToolbarSystemButton) 528 1 1180998 4 ##(Smalltalk.CommandDescription) #undo 8 'Undo' 1 1 nil 28425 1 7 28421 802 528 1 834 #pasteClipboard 8 'Paste' 1 1 nil 28421 1 5 28417 802 528 1 834 #cutSelection 8 'Cut' 1 1 nil 28417 1 1 28413 802 528 1 834 #fileSave 8 'Save' 1 1 nil 28413 1 17 28409 802 528 1 834 #fileNew 8 'New' 1 1 nil 28409 1 13 28423 802 528 1 834 #clearSelection 8 'Delete' 1 1 nil 28423 1 11 28419 802 528 1 834 #copySelection 8 'Copy' 1 1 nil 28419 1 3 28415 802 528 1 834 #find 8 'Find' 1 1 nil 28415 1 25 28411 802 528 1 834 #fileOpen 8 'Open' 1 1 nil 28411 1 15 34 11 1024 1216 976 1049158 1 ##(Smalltalk.ToolbarSeparator) 528 1 1168 1282 528 1 928 1120 880 1072 816 nil nil 1 nil 690 33 33 690 45 45 nil 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 690 1 1 690 2369 51 528 1458 #updateSizePosted 752 528 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 160 4 0 0 25 0 0 0] 8 #() 690 193 193 nil 27 410 ##(Smalltalk.StatusBar) 34 18 nil 416 34 2 8 1140850948 1 1632 nil 592 nil 7 nil 610 nil true 642 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 690 193 193 nil 1632 nil 8 1903688272 170 192 34 2 853766 ##(Smalltalk.StatusBarItem) 1 -1 1632 nil 459270 ##(Smalltalk.Message) #displayString 8 #() 787814 3 ##(Smalltalk.BlockClosure) 0 nil 918822 ##(Smalltalk.CompiledMethod) 3 3 1808 #defaultGetImageBlock 462740483 8 #[31 105 226 0 159 106] #icon #imageIndex 1904 7 257 nil nil 8 'status' 34 1 1824 1115142 ##(Smalltalk.StatusBarNullItem) 513 1 1632 nil nil 1394 138 144 34 1 1458 #createAt:extent: 34 2 690 1 1491 690 2369 45 1632 1554 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 233 2 0 0 160 4 0 0 255 2 0 0] 8 #() 1616 nil 27 nil nil 410 ##(Smalltalk.ScintillaView) 34 50 nil 416 34 2 8 1174475012 262145 2192 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil 592 nil 23 nil nil nil 2192 nil 8 1349308863 852486 ##(Smalltalk.NullConverter) nil nil 9 nil 170 192 34 60 #unquotedValue 1182790 1 ##(Smalltalk.ScintillaTextStyle) 39 196934 1 ##(Smalltalk.RGB) 12648641 nil 1 nil nil nil nil #unquotedValue nil nil nil #attribute 2402 7 466 #teal nil 1 nil nil nil nil #attribute nil nil nil #singleString 2402 15 2434 16646399 nil 1 nil nil nil nil #singleString nil nil nil #indentGuide 2402 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil #identifierStart 2402 27 466 #purple nil 3 nil nil nil nil #identifierStart nil 1401 nil #CDATA 2402 35 466 #maroon 2434 31580671 129 nil nil nil nil #CDATA nil nil nil #sgmlDoubleString 2402 49 2592 2434 33546207 1 nil nil nil nil #sgmlDoubleString nil nil nil #sgmlFirstParam 2402 47 2434 52225 2434 33546207 1 nil nil nil nil #sgmlFirstParam nil nil nil #callTip 2402 77 466 #gray 466 #white 1 nil nil nil nil #callTip nil nil nil #tag 2402 3 466 #navy nil 1 nil nil nil nil #tag nil nil nil #sgmlEntity 2402 57 2434 6710887 2434 33546207 1 nil nil nil nil #sgmlEntity nil nil nil #sgmlError 2402 53 2592 2434 13422079 1 nil nil nil nil #sgmlError nil nil nil #question 2402 37 2592 nil 1 nil nil nil nil #question nil nil nil #sgmlComment 2402 59 466 #olive 2434 33546207 1 nil nil nil nil #sgmlComment nil nil nil #sgmlCommand 2402 45 2768 2434 33546207 3 nil nil nil nil #sgmlCommand nil 1401 nil #identifierEnd 2402 25 2560 nil 3 nil nil nil nil #identifierEnd nil 1401 nil #unknownAttribute 2402 9 2480 nil 1 nil nil nil nil #unknownAttribute nil nil nil #doubleString 2402 13 2434 16646399 nil 1 nil nil nil nil #doubleString nil nil nil #unknownTag 2402 5 2768 nil 1 nil nil nil nil #unknownTag nil nil nil #entity 2402 21 2560 nil 1 nil nil nil nil #entity nil nil nil #styleTagEnd 2402 23 2768 nil 1 nil nil nil nil #styleTagEnd nil nil nil #sgmlTag 2402 43 2768 2434 33546207 1 nil nil nil nil #sgmlTag nil nil nil #sgmlSpecial 2402 55 2434 33475687 2434 33546207 1 nil nil nil nil #sgmlSpecial nil nil nil #comment 2402 19 2896 nil 1 nil nil nil nil #comment nil nil nil #otherInsideTag 2402 17 2560 nil 1 nil nil nil nil #otherInsideTag nil nil nil #sgmlBlock 2402 63 2434 13369345 2434 29464985 1 nil nil nil nil #sgmlBlock nil nil nil #lineNumber 2402 67 nil nil 1 nil nil nil nil #lineNumber nil nil nil #normal 2402 1 nil nil 1 nil nil nil nil #normal nil nil nil #sgmlSingleString 2402 51 2434 26419 2434 33546207 1 nil nil nil nil #sgmlSingleString nil nil nil #number 2402 11 2434 16711169 nil 1 nil nil nil nil #number nil nil nil 34 256 3248 2752 3024 2464 2976 3312 2992 2496 3168 3152 3040 3056 2960 2544 nil nil nil 2576 2864 2416 nil 3072 2928 2656 2624 3264 2832 3104 2784 2880 nil 3184 nil 3232 nil nil nil 2528 2704 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 1245510 1 ##(Smalltalk.NullScintillaStyler) #normal 170 192 34 14 #folderOpenMid 1641542 2 ##(Smalltalk.ScintillaMarkerDefinition) 53 11 2736 466 #black 2192 #folderOpenMid nil nil nil nil nil nil #folderMidTail 3426 55 11 2736 3456 2192 #folderMidTail nil nil nil nil nil nil #folder 3426 61 17 2736 3456 2192 #folder nil nil nil nil nil nil #folderTail 3426 57 11 2736 3456 2192 #folderTail nil nil nil nil nil nil #folderOpen 3426 63 15 2736 3456 2192 #folderOpen nil nil nil nil nil nil #folderEnd 3426 51 11 2736 3456 2192 #folderEnd nil nil nil nil nil nil #folderSub 3426 59 11 2736 3456 2192 #folderSub nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 752 nil 170 176 752 123903 nil nil nil nil 466 #silver nil nil 65 nil nil nil 8 '' 5 170 192 34 4 #xml 2368 #container 170 192 34 60 #number 3312 #attribute 2464 #singleString 2496 #indentGuide 2528 #CDATA 2576 #identifierStart 2544 #sgmlDoubleString 2624 #sgmlFirstParam 2656 #callTip 2704 #tag 2752 #sgmlComment 2880 #sgmlError 2832 #question 2864 #sgmlEntity 2784 #sgmlCommand 2928 #identifierEnd 2960 #unknownAttribute 2976 #doubleString 2992 #sgmlTag 3072 #entity 3040 #styleTagEnd 3056 #unknownTag 3024 #sgmlSpecial 3104 #comment 3152 #otherInsideTag 3168 #sgmlBlock 3184 #lineNumber 3232 #normal 3248 #sgmlSingleString 3264 #unquotedValue 2416 nil nil #plusMinus 33 130003 nil 170 192 34 6 8 'indicator0' 1510470 3 ##(Smalltalk.ScintillaIndicatorStyle) 1 2192 466 #commonGreen 3 false nil nil nil nil nil nil nil 8 'indicator2' 3746 5 2192 466 #red 1 false nil nil nil nil nil nil nil 8 'indicator1' 3746 3 2192 466 #blue 5 false nil nil nil nil nil nil nil nil nil 170 192 34 6 #Warning 2402 1027 466 #darkGoldenrod 466 #ivory 1 nil nil nil nil #Warning nil nil nil #Error 2402 1031 466 #firebrick 466 #floralWhite 1 nil nil nil nil #Error nil nil nil #Notification 2402 1029 nil 466 #gainsboro 1 nil nil nil nil #Notification nil nil nil nil 1394 138 144 34 9 1458 #createAt:extent: 34 2 690 1 51 690 2369 1441 2192 1458 #textLimit: 8 #(1073741823) 2192 1458 #caretPeriod: 8 #(530) 2192 1458 #wordWrap: 8 #(true) 2192 1458 #margins: 34 1 34 3 985158 3 ##(Smalltalk.ScintillaMargin) 1 2192 1 3 nil nil nil nil 4306 3 2192 33 nil nil 67108863 nil nil 4306 5 2192 33 nil 3 -67108863 nil nil 2192 1458 #canHScroll: 8 #(false) 2192 1458 #maxCompletionListHeight: 8 #(9) 2192 1458 #edgeColumn: 8 #(1) 2192 1458 #setLexerLanguage: 8 #(#xml) 2192 1554 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 160 4 0 0 233 2 0 0] 8 #() 1616 nil 29 170 192 34 6 2192 8 'document' 528 8 'toolbar' 1632 8 'statusbar' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 4 265030 4 ##(Smalltalk.Menu) nil true 34 6 984134 2 ##(Smalltalk.CommandMenuItem) 1 834 #fileNew 8 '&New' 9373 1 nil nil nil 4722 1 834 #fileOpen 8 '&Open...' 9375 1 nil nil nil 4722 1 834 #fileSave 8 '&Save' 8359 1 nil nil nil 4722 1 834 #fileSaveAs 8 'Save &As...' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 4722 1 834 #exit 8 'E&xit' 1025 1 nil nil nil 8 '&File' nil 1 nil nil 28361 nil nil 4674 nil true 34 15 4722 1 834 #undo 8 '&Undo' 9397 1 nil nil nil 4722 1 834 #redo 8 '&Redo' 9395 1 nil nil nil 4930 4097 4722 1 834 #cutSelection 8 'Cu&t' 9393 1 nil nil nil 4722 1 834 #copySelection 8 '&Copy' 9351 1 nil nil nil 4722 1 834 #pasteClipboard 8 '&Paste' 9389 1 nil nil nil 4722 1 834 #clearSelection 8 'Cle&ar' 1025 1 nil nil nil 4722 1 834 #selectAll 8 'Select All' 9347 1 nil nil nil 4930 4097 4722 1 834 #reformatXml 8 'Refor&mat' 1 1 nil nil nil 4722 1 834 #validateXml 8 '&Validate' 1 1 nil nil nil 4930 4097 4722 1 834 #find 8 '&Find...' 9357 1 nil nil nil 4722 1 834 #findNext 8 'Find &Next' 1253 1 nil nil nil 4722 1 834 #findReplace 8 'R&eplace...' 9361 1 nil nil nil 8 '&Edit' nil 1 nil nil 28387 nil nil 4674 nil true 34 7 4722 1 834 #viewToolbar 8 '&Toolbar' 1025 1 nil nil nil 4722 1 834 #viewStatusBar 8 '&Status Bar' 1025 1 nil nil nil 4930 4097 4722 1 834 #foldAll 8 '&Fold All' 1 1 nil nil nil 4722 1 834 #unfoldAll 8 '&Unfold All' 1 1 nil nil nil 4930 4097 4674 nil true 34 1 4722 1 834 #editStyles 8 'Text &Styles' 1 1 nil nil nil 8 '&Options' nil 134217729 nil nil 28399 nil nil 8 '&View' nil 1 nil nil 28401 nil nil 4674 nil true 34 3 4722 1 834 #help 8 '&Help Topics' 1025 1 nil nil nil 4930 4097 4722 1 834 #about 8 '&About' 1 1 nil nil nil 8 '&Help' nil 1 nil nil 28407 nil nil 8 '' nil 1 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 1394 138 144 34 2 1458 #createAt:extent: 34 2 690 3839 21 690 2401 1653 416 1458 #updateMenuBar 752 416 1554 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 47 12 0 0 68 3 0 0] 34 3 528 2192 1632 1616 nil 27 )!

toolName
	^self name!

userSettingsKey
	"Private - Answer the <RegKey> under which user specific settings should be stored."

	^self userSettingsRootKey createKey: self toolName!

userSettingsRootKey
	^RegKey userRoot createKey: self installKeyName! !
!XmlPad class categoriesFor: #about!enquiries!private! !
!XmlPad class categoriesFor: #aboutTemplate!enquiries!private! !
!XmlPad class categoriesFor: #defaultFileExtension!constants!public! !
!XmlPad class categoriesFor: #explicitDependencies!must not strip!private! !
!XmlPad class categoriesFor: #fileTypes!constants!public! !
!XmlPad class categoriesFor: #icon!constants!public! !
!XmlPad class categoriesFor: #initialize!development!initializing!public! !
!XmlPad class categoriesFor: #installKeyName!accessing!public! !
!XmlPad class categoriesFor: #resource_Default_view!public!resources-views! !
!XmlPad class categoriesFor: #toolName!accessing!public! !
!XmlPad class categoriesFor: #userSettingsKey!accessing!public! !
!XmlPad class categoriesFor: #userSettingsRootKey!accessing!public! !

