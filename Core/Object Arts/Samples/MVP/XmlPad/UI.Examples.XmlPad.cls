"Filed out from Dolphin Smalltalk 7"!

UI.TextDocument subclass: #XmlPad
	instanceVariableNames: 'viewOptions'
	classVariableNames: ''
	imports: #(#{MSXML private})
	classInstanceVariableNames: ''
	classConstants: {
		'RememberPlacementMask' -> 16r1
	}!
XmlPad guid: (Core.GUID fromString: '{0b798c7b-c80f-46ab-9dd4-d8832b78d33c}')!
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
	dom := MSXML newDocument.
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
	self scintilla
		targetAll;
		replaceTarget: reformatted!

restoreBooleanOptions: anArrayOfPairs fromRegKey: aRegKey
	| values |
	values := aRegKey subValues.
	anArrayOfPairs
		do: [:each | values at: each first ifPresent: [:bool | self perform: each third with: bool asBoolean]]!

restoreTabWidth: aRegKey
	aRegKey subValues at: 'TabWidth' ifPresent: [:width | self tabWidth: width]!

restoreTextStyles: aRegKey
	aRegKey at: 'TextStyles'
		ifPresent: 
			[:key |
			| styles |
			styles := Object fromRegKey: key.
			self scintilla textStyles: styles]!

restoreUserSettings
	| settingsKey rootKey |
	rootKey := self class userSettingsRootKey.
	settingsKey := rootKey at: self class settingsKeyName
				ifAbsent: 
					[rootKey at: self class legacySettingsKeyName
						ifAbsent: [rootKey createKey: self class settingsKeyName]].
	self restoreViewOptions: settingsKey.
	self restoreBooleanOptions: self booleanOptions fromRegKey: settingsKey!

restoreViewOptions: aRegKey
	self restoreBooleanOptions: self booleanViewOptions fromRegKey: aRegKey.
	self restoreTextStyles: aRegKey.
	self restoreTabWidth: aRegKey!

saveBooleanOptions: anArrayOfPairs underRegKey: aRegKey
	| values |
	values := aRegKey subValues.
	anArrayOfPairs do: [:each | values at: each first put: (self perform: each second) asParameter]!

saveFontSetting: aRegKey
	aRegKey valueAt: 'Font' put: self view actualFont logFont!

saveOptions: aRegKey
	self saveViewOptions: aRegKey.
	self saveBooleanOptions: self booleanOptions underRegKey: aRegKey!

saveTabWidth: aRegKey
	aRegKey valueAt: 'TabWidth' put: self tabWidth!

saveTextStyles: aRegKey
	self scintilla textStyles asArray storeUnderRegKey: aRegKey as: 'TextStyles'!

saveUserSettings
	"Private - Save the users configuration to the registry."

	| settingsKey |
	settingsKey := self class userSettingsKey.
	self
		saveOptions: settingsKey;
		saveWindowPlacement: settingsKey!

saveViewOptions: aRegKey
	aRegKey valueAt: 'SavePlacement' put: self isRememberingPlacement asParameter.
	self saveTabWidth: aRegKey.
	self saveBooleanOptions: self booleanViewOptions underRegKey: aRegKey.
	self saveTextStyles: aRegKey!

saveWindowPlacement: aRegKey
	self isRememberingPlacement
		ifTrue: 
			[| placement |
			placement := self view placement.
			placement showCmd: (self view isMaximized ifTrue: [SW_SHOWMAXIMIZED] ifFalse: [SW_SHOW]).
			aRegKey valueAt: 'placement' put: placement]
		ifFalse: [aRegKey removeSubValue: 'placement' ifAbsent: []]!

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

validateXml
	statusModel
		value: (
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
!XmlPad categoriesFor: #restoreBooleanOptions:fromRegKey:!operations!private! !
!XmlPad categoriesFor: #restoreTabWidth:!operations!private! !
!XmlPad categoriesFor: #restoreTextStyles:!helpers!private! !
!XmlPad categoriesFor: #restoreUserSettings!helpers!private! !
!XmlPad categoriesFor: #restoreViewOptions:!operations!private! !
!XmlPad categoriesFor: #saveBooleanOptions:underRegKey:!helpers!private! !
!XmlPad categoriesFor: #saveFontSetting:!helpers!private! !
!XmlPad categoriesFor: #saveOptions:!helpers!private! !
!XmlPad categoriesFor: #saveTabWidth:!helpers!private! !
!XmlPad categoriesFor: #saveTextStyles:!helpers!private! !
!XmlPad categoriesFor: #saveUserSettings!helpers!private! !
!XmlPad categoriesFor: #saveViewOptions:!helpers!private! !
!XmlPad categoriesFor: #saveWindowPlacement:!helpers!private! !
!XmlPad categoriesFor: #scintilla!accessing!private! !
!XmlPad categoriesFor: #statusBar!accessing!private! !
!XmlPad categoriesFor: #tabWidth!accessing!private! !
!XmlPad categoriesFor: #tabWidth:!accessing!private! !
!XmlPad categoriesFor: #toolbar!accessing!private! !
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

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream nextPutAll: 'XmlPad'!

explicitDependencies
	AdvancedFindDialog
!

fileTypes
	"Answer an Array of file types that can be associated with this class of document."

	^#(#('XML Files (*.xml)' '*.xml') #('All Files (*.*)' '*.*'))!

icon
	"Answers an Icon that can be used to represent this class and which is displayed in the
	caption of the dialog box."

	^MSXML icon!

initialize
	"
	self initialize
	"

	self addClassConstant: 'RememberPlacementMask' value: 1!

installKeyName
	"Private - Answer the name of the base installation registry key."

	^'Software\Object Arts'!

legacySettingsKeyName
	^self toolName!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 327686 ##(Smalltalk.Color) #face3d nil 549 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.Toolbar) 34 25 nil 416 34 2 8 1140853508 131137 528 nil 466 #default nil 519 nil 263174 ##(Smalltalk.Font) nil true 459014 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 nil 528 592 8 1867527152 170 192 8 #() 170 192 34 18 36585 1246790 1 ##(Smalltalk.ToolbarSystemButton) 528 1 1180998 4 ##(Smalltalk.CommandDescription) #copySelection 8 'Copy' 1 1 nil 36585 1 3 36581 802 528 1 834 #find 8 'Find' 1 1 nil 36581 1 25 36577 802 528 1 834 #fileOpen 8 'Open' 1 1 nil 36577 1 15 36591 802 528 1 834 #undo 8 'Undo' 1 1 nil 36591 1 7 36587 802 528 1 834 #pasteClipboard 8 'Paste' 1 1 nil 36587 1 5 36583 802 528 1 834 #cutSelection 8 'Cut' 1 1 nil 36583 1 1 36579 802 528 1 834 #fileSave 8 'Save' 1 1 nil 36579 1 17 36575 802 528 1 834 #fileNew 8 'New' 1 1 nil 36575 1 13 36589 802 528 1 834 #clearSelection 8 'Delete' 1 1 nil 36589 1 11 34 11 1168 928 1120 1049158 1 ##(Smalltalk.ToolbarSeparator) 528 1 880 1282 528 1 1072 816 1024 1216 976 nil nil 1 nil 690 33 33 690 45 45 nil 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 690 1 1 690 2369 51 528 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 160 4 0 0 25 0 0 0] 8 #() 690 193 193 nil 27 410 ##(Smalltalk.StatusBar) 34 18 nil 416 34 2 8 1140850948 1 1616 nil 592 nil 7 nil 610 nil true 642 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 690 193 193 nil 1616 nil 8 1867315760 170 192 34 2 853766 ##(Smalltalk.StatusBarItem) 1 -1 1616 nil 459270 ##(Smalltalk.Message) #displayString 8 #() 787814 3 ##(Smalltalk.BlockClosure) 0 nil 918822 ##(Smalltalk.CompiledMethod) 3 3 1792 #defaultGetImageBlock 462740483 8 #[31 105 226 0 159 106] #icon #imageIndex 1888 7 257 nil nil 8 'status' 34 1 1808 1115142 ##(Smalltalk.StatusBarNullItem) 513 1 1616 nil nil 1394 138 144 34 1 1458 #createAt:extent: 34 2 690 1 1491 690 2369 45 1616 1538 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 233 2 0 0 160 4 0 0 255 2 0 0] 8 #() 1600 nil 27 nil nil 410 ##(Smalltalk.ScintillaView) 34 50 nil 416 34 2 8 1174475012 262145 2176 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil 592 nil 23 nil nil nil 2176 nil 8 1533228637 852486 ##(Smalltalk.NullConverter) nil nil 9 nil 170 192 34 60 #identifierStart 1182790 1 ##(Smalltalk.ScintillaTextStyle) 27 466 #purple nil 3 nil nil nil nil #identifierStart nil 1401 nil #sgmlDoubleString 2386 49 466 #maroon 196934 1 ##(Smalltalk.RGB) 33546207 1 nil nil nil nil #sgmlDoubleString nil nil nil #entity 2386 21 2416 nil 1 nil nil nil nil #entity nil nil nil #comment 2386 19 466 #olive nil 1 nil nil nil nil #comment nil nil nil #singleString 2386 15 2466 16646399 nil 1 nil nil nil nil #singleString nil nil nil #sgmlTag 2386 43 466 #navy 2466 33546207 1 nil nil nil nil #sgmlTag nil nil nil #sgmlError 2386 53 2448 2466 13422079 1 nil nil nil nil #sgmlError nil nil nil #sgmlSpecial 2386 55 2466 33475687 2466 33546207 1 nil nil nil nil #sgmlSpecial nil nil nil #indentGuide 2386 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil #callTip 2386 77 466 #gray 466 #white 1 nil nil nil nil #callTip nil nil nil #otherInsideTag 2386 17 2416 nil 1 nil nil nil nil #otherInsideTag nil nil nil #lineNumber 2386 67 nil nil 1 nil nil nil nil #lineNumber nil nil nil #unknownAttribute 2386 9 466 #teal nil 1 nil nil nil nil #unknownAttribute nil nil nil #sgmlBlock 2386 63 2466 13369345 2466 29464985 1 nil nil nil nil #sgmlBlock nil nil nil #styleTagEnd 2386 23 2592 nil 1 nil nil nil nil #styleTagEnd nil nil nil #unquotedValue 2386 39 2466 12648641 nil 1 nil nil nil nil #unquotedValue nil nil nil #CDATA 2386 35 2448 2466 31580671 129 nil nil nil nil #CDATA nil nil nil #sgmlFirstParam 2386 47 2466 52225 2466 33546207 1 nil nil nil nil #sgmlFirstParam nil nil nil #sgmlComment 2386 59 2528 2466 33546207 1 nil nil nil nil #sgmlComment nil nil nil #identifierEnd 2386 25 2416 nil 3 nil nil nil nil #identifierEnd nil 1401 nil #sgmlSingleString 2386 51 2466 26419 2466 33546207 1 nil nil nil nil #sgmlSingleString nil nil nil #question 2386 37 2448 nil 1 nil nil nil nil #question nil nil nil #number 2386 11 2466 16711169 nil 1 nil nil nil nil #number nil nil nil #normal 2386 1 nil nil 1 nil nil nil nil #normal nil nil nil #unknownTag 2386 5 2592 nil 1 nil nil nil nil #unknownTag nil nil nil #sgmlCommand 2386 45 2592 2466 33546207 3 nil nil nil nil #sgmlCommand nil 1401 nil #doubleString 2386 13 2466 16646399 nil 1 nil nil nil nil #doubleString nil nil nil #attribute 2386 7 2816 nil 1 nil nil nil nil #attribute nil nil nil #tag 2386 3 2592 nil 1 nil nil nil nil #tag nil nil nil #sgmlEntity 2386 57 2466 6710887 2466 33546207 1 nil nil nil nil #sgmlEntity nil nil nil nil 1245510 1 ##(Smalltalk.NullScintillaStyler) #normal 170 192 34 14 #folderSub 1641542 2 ##(Smalltalk.ScintillaMarkerDefinition) 59 11 2752 466 #black 2176 #folderSub nil nil nil nil nil nil #folderOpenMid 3394 53 11 2752 3424 2176 #folderOpenMid nil nil nil nil nil nil #folderOpen 3394 63 15 2752 3424 2176 #folderOpen nil nil nil nil nil nil #folderEnd 3394 51 11 2752 3424 2176 #folderEnd nil nil nil nil nil nil #folderMidTail 3394 55 11 2752 3424 2176 #folderMidTail nil nil nil nil nil nil #folder 3394 61 17 2752 3424 2176 #folder nil nil nil nil nil nil #folderTail 3394 57 11 2752 3424 2176 #folderTail nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 752 nil 170 176 752 123903 nil nil nil nil 466 #silver nil nil 65 nil nil nil 8 '' 5 170 192 34 4 #container 170 192 34 60 #identifierStart 2400 #sgmlDoubleString 2432 #entity 2496 #comment 2512 #singleString 2544 #sgmlTag 2576 #sgmlError 2624 #sgmlSpecial 2656 #indentGuide 2704 #callTip 2720 #otherInsideTag 2768 #lineNumber 2784 #unknownAttribute 2800 #number 3120 #styleTagEnd 2880 #CDATA 2928 #sgmlFirstParam 2960 #sgmlComment 3008 #identifierEnd 3040 #sgmlBlock 2832 #sgmlSingleString 3056 #question 3104 #unquotedValue 2896 #normal 3152 #unknownTag 3168 #sgmlCommand 3184 #doubleString 3216 #attribute 3248 #tag 3264 #sgmlEntity 3280 #xml 2352 nil nil #plusMinus 33 130003 nil 170 192 34 6 8 'indicator0' 1510470 3 ##(Smalltalk.ScintillaIndicatorStyle) 1 2176 466 #commonGreen 3 false nil nil nil nil nil nil nil 8 'indicator1' 3714 3 2176 466 #blue 5 false nil nil nil nil nil nil nil 8 'indicator2' 3714 5 2176 466 #red 1 false nil nil nil nil nil nil nil nil nil 170 192 34 6 #Warning 2386 1027 466 #darkGoldenrod 466 #ivory 1 nil nil nil nil #Warning nil nil nil #Notification 2386 1029 nil 466 #gainsboro 1 nil nil nil nil #Notification nil nil nil #Error 2386 1031 466 #firebrick 466 #floralWhite 1 nil nil nil nil #Error nil nil nil nil 1394 138 144 34 10 1458 #createAt:extent: 34 2 690 1 51 690 2369 1441 2176 1458 #textLimit: 8 #(1073741823) 2176 1458 #caretPeriod: 8 #(530) 2176 1458 #wordWrap: 8 #(true) 2176 1458 #margins: 34 1 34 3 985158 3 ##(Smalltalk.ScintillaMargin) 1 2176 1 3 nil nil nil nil 4274 3 2176 33 nil nil 67108863 nil nil 4274 5 2176 33 nil 3 -67108863 nil nil 2176 1458 #canHScroll: 8 #(false) 2176 1458 #targetRange: 34 1 525062 ##(Smalltalk.Interval) 1 -1 3 2176 1458 #maxCompletionListHeight: 8 #(9) 2176 1458 #edgeColumn: 8 #(1) 2176 1458 #setLexerLanguage: 8 #(#xml) 2176 1538 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 160 4 0 0 233 2 0 0] 8 #() 1600 nil 29 170 192 34 6 528 8 'toolbar' 2176 8 'document' 1616 8 'statusbar' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 4 265030 4 ##(Smalltalk.Menu) nil true 34 6 984134 2 ##(Smalltalk.CommandMenuItem) 1 834 #fileNew 8 '&New' 9373 1 nil nil nil 4754 1 834 #fileOpen 8 '&Open...' 9375 1 nil nil nil 4754 1 834 #fileSave 8 '&Save' 9383 1 nil nil nil 4754 1 834 #fileSaveAs 8 'Save &As...' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 4754 1 834 #exit 8 'E&xit' 1025 1 nil nil nil 8 '&File' nil 1 nil nil 36603 nil nil 4706 nil true 34 15 4754 1 834 #undo 8 '&Undo' 9397 1 nil nil nil 4754 1 834 #redo 8 '&Redo' 9395 1 nil nil nil 4962 4097 4754 1 834 #cutSelection 8 'Cu&t' 9393 1 nil nil nil 4754 1 834 #copySelection 8 '&Copy' 9351 1 nil nil nil 4754 1 834 #pasteClipboard 8 '&Paste' 9389 1 nil nil nil 4754 1 834 #clearSelection 8 'Cle&ar' 1025 1 nil nil nil 4754 1 834 #selectAll 8 'Select All' 9347 1 nil nil nil 4962 4097 4754 1 834 #reformatXml 8 'Refor&mat' 1 1 nil nil nil 4754 1 834 #validateXml 8 '&Validate' 1 1 nil nil nil 4962 4097 4754 1 834 #find 8 '&Find...' 9357 1 nil nil nil 4754 1 834 #findNext 8 'Find &Next' 1253 1 nil nil nil 4754 1 834 #findReplace 8 'R&eplace...' 9361 1 nil nil nil 8 '&Edit' nil 1 nil nil 36629 nil nil 4706 nil true 34 7 4754 1 834 #viewToolbar 8 '&Toolbar' 1025 1 nil nil nil 4754 1 834 #viewStatusBar 8 '&Status Bar' 1025 1 nil nil nil 4962 4097 4754 1 834 #foldAll 8 '&Fold All' 1 1 nil nil nil 4754 1 834 #unfoldAll 8 '&Unfold All' 1 1 nil nil nil 4962 4097 4706 nil true 34 1 4754 1 834 #editStyles 8 'Text &Styles' 1 1 nil nil nil 8 '&Options' nil 134217729 nil nil 36641 nil nil 8 '&View' nil 1 nil nil 36643 nil nil 4706 nil true 34 3 4754 1 834 #help 8 '&Help Topics' 1025 1 nil nil nil 4962 4097 4754 1 834 #about 8 '&About' 1 1 nil nil nil 8 '&Help' nil 1 nil nil 36649 nil nil 8 '' nil 1 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 1394 138 144 34 1 1458 #createAt:extent: 34 2 690 7039 21 690 2401 1653 416 1538 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 191 13 0 0 10 0 0 0 111 18 0 0 68 3 0 0] 34 3 528 2176 1616 1600 nil 27 )!

settingsKeyName
	^self toolName, ' 7.2'!

toolName
	^self name!

userSettingsKey
	"Private - Answer the <RegKey> under which user specific settings should be stored."

	^self userSettingsRootKey createKey: self settingsKeyName!

userSettingsRootKey
	^RegKey userRoot createKey: self installKeyName! !
!XmlPad class categoriesFor: #about!enquiries!private! !
!XmlPad class categoriesFor: #aboutTemplate!enquiries!private! !
!XmlPad class categoriesFor: #defaultFileExtension!constants!public! !
!XmlPad class categoriesFor: #displayOn:!displaying!public! !
!XmlPad class categoriesFor: #explicitDependencies!must not strip!private! !
!XmlPad class categoriesFor: #fileTypes!constants!public! !
!XmlPad class categoriesFor: #icon!constants!public! !
!XmlPad class categoriesFor: #initialize!development!initializing!public! !
!XmlPad class categoriesFor: #installKeyName!accessing!public! !
!XmlPad class categoriesFor: #legacySettingsKeyName!private! !
!XmlPad class categoriesFor: #resource_Default_view!public!resources-views! !
!XmlPad class categoriesFor: #settingsKeyName!accessing!public! !
!XmlPad class categoriesFor: #toolName!accessing!public! !
!XmlPad class categoriesFor: #userSettingsKey!accessing!public! !
!XmlPad class categoriesFor: #userSettingsRootKey!accessing!public! !

