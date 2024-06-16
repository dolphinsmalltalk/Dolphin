"Filed out from Dolphin Smalltalk"!

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
	cmd == #reformatXml
		ifTrue: 
			[query isEnabled: self scintilla textLength > 0.
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

!XmlPad categoriesForMethods!
about!commands!public! !
basicValidateXml!helpers!private! !
booleanOptions!helpers!private! !
booleanViewOptions!helpers!private! !
canSave!public!testing! !
hasFormattingMarks!public!testing! !
hasFormattingMarks:!accessing!public! !
hasIndentationGuides!public!testing! !
hasIndentationGuides:!accessing!public! !
hasLineNumbers!public!testing! !
hasLineNumbers:!accessing!public! !
hasWordWrap!public!testing! !
hasWordWrap:!accessing!public! !
initialize!initializing!public! !
isAutoCompleteEnabled!public! !
isAutoCompleteEnabled:!public! !
isAutoCompletionSingleMatchChosen!public!testing! !
isAutoCompletionSingleMatchChosen:!public! !
isAutoCompletionTruncating!public!testing! !
isAutoCompletionTruncating:!public! !
isFoldingEnabled!public!testing! !
isFoldingEnabled:!accessing!public! !
isRememberingPlacement!commands!public! !
isRememberingPlacement:!public!testing! !
parseXml!helpers!private! !
parseXml:validate:!helpers!private! !
queryCommand:!commands!private! !
reformatXml!commands!public! !
restoreBooleanOptions:!operations!private! !
restoreTabWidth!operations!private! !
restoreTextStyles!helpers!private! !
restoreUserSettings!helpers!private! !
restoreViewOptions!operations!private! !
saveBooleanOptions:!helpers!private! !
saveFontSetting!helpers!private! !
saveOptions!helpers!private! !
saveTabWidth!helpers!private! !
saveTextStyles!helpers!private! !
saveUserSettings!helpers!private! !
saveViewOptions!helpers!private! !
saveWindowPlacement!helpers!private! !
scintilla!accessing!private! !
statusBar!accessing!private! !
tabWidth!accessing!private! !
tabWidth:!accessing!private! !
toolbar!accessing!private! !
userSettingsKey!accessing!private! !
validateXml!commands!public! !
viewStatusBar!commands!private! !
viewToolbar!commands!private! !
!

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

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65568) 416 nil 327686 ##(Smalltalk.Color) #default nil 517 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.Toolbar) 34 28 nil 416 34 2 8 1409289036 131073 528 nil 480 nil 517 nil nil nil 528 nil 8 1759112192 nil nil nil nil 170 192 8 #() 8 #() nil nil 9 763 #smallIcons nil nil 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[0 0 0 0 0 0 0 0 160 4 0 0 25 0 0 0] 193 560 8 '' 528 3 34 4 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 912 nil nil nil 5 nil nil nil 912 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Toolbar) #resource_Fluent_File_tools nil 690 138 144 34 1 754 #createWindow: 34 1 802 834 8 #[0 0 0 0 0 0 0 0 89 0 0 0 25 0 0 0] 193 944 8 '' 912 3 624 328198 ##(Smalltalk.Point) 193 193 nil 27 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1184 nil nil nil 5 nil nil nil 1184 978 ##(Smalltalk.Toolbar) #resource_Fluent_Edit_tools nil 690 138 144 34 1 754 #createWindow: 34 1 802 834 8 #[89 0 0 0 0 0 0 0 228 0 0 0 25 0 0 0] 193 1216 8 '' 1184 3 624 1154 193 193 nil 27 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1424 nil nil nil 5 nil nil nil 1424 978 ##(Smalltalk.Toolbar) #resource_Fluent_Find_tools nil 690 138 144 34 1 754 #createWindow: 34 1 802 834 8 #[228 0 0 0 0 0 0 0 36 1 0 0 25 0 0 0] 193 1456 8 '' 1424 3 624 1154 193 193 nil 27 410 ##(Smalltalk.Toolbar) 34 28 nil 528 34 2 8 1409293132 131137 1664 nil nil nil 517 nil nil nil 1664 480 8 1759112192 170 192 624 nil nil nil 170 192 34 6 16613 1115462 1 ##(Smalltalk.ToolbarTextButton) 1664 161 1180998 4 ##(Smalltalk.CommandDescription) #reformatXml 8 '&Reformat XML' 1 1 nil 16613 $\xE736 16611 1794 1664 161 1826 #unfoldAll 8 '&Unfold All' 1 1 nil 16611 $\xECCD 16609 1794 1664 161 1826 #foldAll 8 '&Fold All' 1 1 nil 16609 $\xF165 34 4 1920 1872 1808 1049158 1 ##(Smalltalk.ToolbarSeparator) 1664 1 nil nil 13 5 nil nil nil nil 690 138 144 34 1 754 #createWindow: 34 1 802 834 8 #[36 1 0 0 0 0 0 0 125 1 0 0 25 0 0 0] 193 34 2 8 1409293132 131137 8 '' 1664 3 8 #() 1154 193 193 nil 31 1154 193 193 nil 31 410 ##(Smalltalk.StatusBar) 34 21 nil 416 34 2 8 1140850948 1 2240 nil 480 nil 5 nil nil nil 2240 nil 8 1758805184 170 192 34 2 853830 1 ##(Smalltalk.StatusBarItem) 8193 -1 2240 nil 459270 ##(Smalltalk.Message) #displayString 8 #() 787814 3 ##(Smalltalk.BlockClosure) 0 nil 918822 ##(Smalltalk.CompiledMethod) 3 3 2352 #defaultGetImageBlock 462740483 8 #[31 105 226 0 159 106] #icon #imageIndex 2448 7 257 nil nil 8 'status' nil nil nil 34 1 2368 1115206 1 ##(Smalltalk.StatusBarNullItem) 8705 1 2240 nil nil 690 138 144 34 1 754 #createWindow: 34 1 802 834 8 #[0 0 0 0 233 2 0 0 160 4 0 0 255 2 0 0] 193 2272 8 '' 2240 3 8 #() 1154 193 193 nil 29 nil nil 410 ##(Smalltalk.ScintillaView) 34 65 nil 416 34 2 8 1174475012 262145 2752 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil 480 nil 21 nil nil nil 2752 nil 8 1504001512 852486 ##(Smalltalk.NullConverter) nil nil 9 68819953 170 192 34 60 #sgmlEntity 1182790 1 ##(Smalltalk.ScintillaTextStyle) 57 196934 1 ##(Smalltalk.RGB) 6710887 2994 33546207 1 nil nil nil nil #sgmlEntity nil nil nil #doubleString 2962 13 2994 16646399 nil 1 nil nil nil nil #doubleString nil nil nil #unknownAttribute 2962 9 466 #teal nil 1 nil nil nil nil #unknownAttribute nil nil nil #sgmlError 2962 53 466 #maroon 2994 13422079 1 nil nil nil nil #sgmlError nil nil nil #number 2962 11 2994 16711169 nil 1 nil nil nil nil #number nil nil nil #unquotedValue 2962 39 2994 12648641 nil 1 nil nil nil nil #unquotedValue nil nil nil #sgmlDoubleString 2962 49 3120 2994 33546207 1 nil nil nil nil #sgmlDoubleString nil nil nil #normal 2962 1 nil nil 1 nil nil nil nil #normal nil nil nil #comment 2962 19 466 #olive nil 1 nil nil nil nil #comment nil nil nil #sgmlSpecial 2962 55 2994 33475687 2994 33546207 1 nil nil nil nil #sgmlSpecial nil nil nil #identifierStart 2962 27 466 #purple nil 3 nil nil nil nil #identifierStart nil 1401 nil #otherInsideTag 2962 17 3360 nil 1 nil nil nil nil #otherInsideTag nil nil nil #sgmlSingleString 2962 51 2994 26419 2994 33546207 1 nil nil nil nil #sgmlSingleString nil nil nil #callTip 2962 77 466 #gray 466 #white 1 nil nil nil nil #callTip nil nil nil #identifierEnd 2962 25 3360 nil 3 nil nil nil nil #identifierEnd nil 1401 nil #attribute 2962 7 3088 nil 1 nil nil nil nil #attribute nil nil nil #unknownTag 2962 5 466 #navy nil 1 nil nil nil nil #unknownTag nil nil nil #tag 2962 3 3536 nil 1 nil nil nil nil #tag nil nil nil #sgmlTag 2962 43 3536 2994 33546207 1 nil nil nil nil #sgmlTag nil nil nil #sgmlComment 2962 59 3280 2994 33546207 1 nil nil nil nil #sgmlComment nil nil nil #entity 2962 21 3360 nil 1 nil nil nil nil #entity nil nil nil #lineNumber 2962 67 nil nil 1 nil nil nil nil #lineNumber nil nil nil #indentGuide 2962 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil #sgmlCommand 2962 45 3536 2994 33546207 3 nil nil nil nil #sgmlCommand nil 1401 nil #singleString 2962 15 2994 16646399 nil 1 nil nil nil nil #singleString nil nil nil #question 2962 37 3120 nil 1 nil nil nil nil #question nil nil nil #sgmlFirstParam 2962 47 2994 52225 2994 33546207 1 nil nil nil nil #sgmlFirstParam nil nil nil #styleTagEnd 2962 23 3536 nil 1 nil nil nil nil #styleTagEnd nil nil nil #sgmlBlock 2962 63 2994 13369345 2994 29464985 1 nil nil nil nil #sgmlBlock nil nil nil #CDATA 2962 35 3120 2994 31580671 129 nil nil nil nil #CDATA nil nil nil nil 1245510 1 ##(Smalltalk.NullScintillaStyler) #normal 170 192 34 14 #folderOpen 1641542 2 ##(Smalltalk.ScintillaMarkerDefinition) 63 15 3472 466 #black 2752 #folderOpen nil nil nil nil nil nil #folderSub 3970 59 11 3472 4000 2752 #folderSub nil nil nil nil nil nil #folderOpenMid 3970 53 11 3472 4000 2752 #folderOpenMid nil nil nil nil nil nil #folderMidTail 3970 55 11 3472 4000 2752 #folderMidTail nil nil nil nil nil nil #folder 3970 61 17 3472 4000 2752 #folder nil nil nil nil nil nil #folderTail 3970 57 11 3472 4000 2752 #folderTail nil nil nil nil nil nil #folderEnd 3970 51 11 3472 4000 2752 #folderEnd nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 624 nil 170 176 624 123903 nil nil nil nil 466 #silver nil nil 65 nil nil nil 8 '' 5 170 192 34 4 #xml 2928 #container 170 192 34 60 #sgmlEntity 2976 #doubleString 3040 #unknownAttribute 3072 #sgmlError 3104 #number 3152 #unquotedValue 3184 #sgmlDoubleString 3216 #normal 3248 #comment 3264 #sgmlSpecial 3296 #identifierStart 3344 #otherInsideTag 3376 #sgmlSingleString 3392 #callTip 3440 #identifierEnd 3488 #attribute 3504 #unknownTag 3520 #tag 3552 #sgmlTag 3568 #sgmlComment 3600 #entity 3632 #lineNumber 3648 #indentGuide 3664 #sgmlCommand 3680 #singleString 3712 #question 3744 #sgmlFirstParam 3760 #styleTagEnd 3808 #sgmlBlock 3824 #CDATA 3872 nil nil #plusMinus 33 208 nil 170 192 34 6 8 'indicator0' 1510470 3 ##(Smalltalk.ScintillaIndicatorStyle) 1 2752 466 #commonGreen 3 false nil nil nil nil nil nil nil 8 'indicator2' 4290 5 2752 466 #red 1 false nil nil nil nil nil nil nil 8 'indicator1' 4290 3 2752 466 #blue 5 false nil nil nil nil nil nil nil nil nil 170 192 34 6 #Warning 2962 1027 466 #darkGoldenrod 466 #ivory 1 nil nil nil nil #Warning nil nil nil #Error 2962 1031 466 #firebrick 466 #floralWhite 1 nil nil nil nil #Error nil nil nil #Notification 2962 1029 nil 466 #gainsboro 1 nil nil nil nil #Notification nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 690 138 144 34 9 754 #createWindow: 34 1 802 834 8 #[0 0 0 0 25 0 0 0 160 4 0 0 233 2 0 0] 193 2784 nil 2752 754 #caretPeriod: 8 #(530) 2752 754 #wordWrap: 8 #(true) 2752 754 #margins: 34 1 34 3 985158 3 ##(Smalltalk.ScintillaMargin) 1 2752 1 3 nil nil nil nil 4834 3 2752 33 nil nil 67108863 nil nil 4834 5 2752 33 nil 3 -67108863 nil nil 2752 754 #canHScroll: 8 #(false) 2752 754 #targetRange: 34 1 525062 ##(Smalltalk.Interval) 1 -1 3 2752 754 #maxCompletionListHeight: 8 #(9) 2752 754 #edgeColumn: 8 #(1) 2752 754 #setLexerLanguage: 8 #(#xml) 2752 3 8 #() 1154 193 193 nil 33 170 192 34 6 2752 8 'document' 2240 8 'statusbar' 528 8 'toolbar' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 4 265030 4 ##(Smalltalk.Menu) nil true 34 6 984134 2 ##(Smalltalk.CommandMenuItem) 1 1826 #fileNew 8 '&New' 9373 1 nil nil nil 5298 1 1826 #fileOpen 8 '&Open...' 9375 1 nil nil nil 5298 1 1826 #fileSave 8 '&Save' 9383 1 nil nil nil 5298 1 1826 #fileSaveAs 8 'Save &As...' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 5298 1 1826 #exit 8 'E&xit' 1025 1 nil nil nil 8 '&File' nil 1 nil nil 16625 nil nil 5250 nil true 34 15 5298 1 1826 #undo 8 '&Undo' 9397 1 nil nil nil 5298 1 1826 #redo 8 '&Redo' 9395 1 nil nil nil 5506 4097 5298 1 1826 #cutSelection 8 'Cu&t' 9393 1 nil nil nil 5298 1 1826 #copySelection 8 '&Copy' 9351 1 nil nil nil 5298 1 1826 #pasteClipboard 8 '&Paste' 9389 1 nil nil nil 5298 1 1826 #clearSelection 8 'Cle&ar' 1025 1 nil nil nil 5298 1 1826 #selectAll 8 'Select All' 9347 1 nil nil nil 5506 4097 5298 1 1826 #reformatXml 8 'Refor&mat' 1 1 nil nil nil 5298 1 1826 #validateXml 8 '&Validate' 1 1 nil nil nil 5506 4097 5298 1 1826 #find 8 '&Find...' 9357 1 nil nil nil 5298 1 1826 #findNext 8 'Find &Next' 1253 1 nil nil nil 5298 1 1826 #findReplace 8 'R&eplace...' 9361 1 nil nil nil 8 '&Edit' nil 1 nil nil 16651 nil nil 5250 nil true 34 7 5298 1 1826 #viewToolbar 8 '&Toolbar' 1025 1 nil nil nil 5298 1 1826 #viewStatusBar 8 '&Status Bar' 1025 1 nil nil nil 5506 4097 5298 1 1826 #foldAll 8 '&Fold All' 1 1 nil nil nil 5298 1 1826 #unfoldAll 8 '&Unfold All' 1 1 nil nil nil 5506 4097 5250 nil true 34 1 5298 1 1826 #editStyles 8 'Text &Styles' 1 1 nil nil nil 8 '&Options' nil 134217729 nil nil 16663 nil nil 8 '&View' nil 1 nil nil 16665 nil nil 5250 nil true 34 3 5298 1 1826 #help 8 '&Help Topics' 1025 1 nil nil nil 5506 4097 5298 1 1826 #about 8 '&About' 1 1 nil nil nil 8 '&Help' nil 1 nil nil 16671 nil nil 8 '' nil 1 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil 193 690 138 144 34 1 754 #createWindow: 34 1 802 590342 ##(Smalltalk.Rectangle) 1154 1 1 1154 2401 1653 193 448 8 '' 416 1 34 3 528 2752 2240 1154 193 193 nil 27 )!

toolName
	^self name!

userSettingsKey
	"Private - Answer the <RegKey> under which user specific settings should be stored."

	^self userSettingsRootKey createKey: self toolName!

userSettingsRootKey
	^RegKey userRoot createKey: self installKeyName! !

!XmlPad class categoriesForMethods!
about!enquiries!private! !
aboutTemplate!enquiries!private! !
defaultFileExtension!constants!public! !
explicitDependencies!must not strip!private! !
fileTypes!constants!public! !
icon!constants!public! !
initialize!development!initializing!public! !
installKeyName!accessing!public! !
resource_Default_view!public!resources-views! !
toolName!accessing!public! !
userSettingsKey!accessing!public! !
userSettingsRootKey!accessing!public! !
!

