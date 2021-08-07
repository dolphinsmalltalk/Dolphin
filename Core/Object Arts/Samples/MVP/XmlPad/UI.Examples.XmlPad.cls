"Filed out from Dolphin Smalltalk"!

UI.TextDocument subclass: #'UI.Examples.XmlPad'
	instanceVariableNames: 'viewOptions'
	classVariableNames: ''
	imports: #(#{MSXML private})
	classInstanceVariableNames: ''
	classConstants: {
		'RememberPlacementMask' -> 16r1
	}!
UI.Examples.XmlPad guid: (Core.GUID fromString: '{0b798c7b-c80f-46ab-9dd4-d8832b78d33c}')!
UI.Examples.XmlPad comment: '`XmlPad` is a simple XML text editor. It is intended to demonstrate the `DocumentShell` hierarchy of Dolphin''s application framework, the `ScintillaView` editor component, and the use of the MSXML. XmlPad also demonstrates how to use the registry to save and restore user preferences. 

```
XmlPad show
```'!
!UI.Examples.XmlPad categoriesForClass!MVP-Presenters! !
!UI.Examples.XmlPad methodsFor!

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
				MessageBox new
					headline: 'Save invalid XML?';
					detailsText: ex tag displayString;
					confirm: 'The XML contains one or more errors and is invalid. Are you sure that you would like to save it?']!

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
!UI.Examples.XmlPad categoriesForMethods!
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
restoreBooleanOptions:fromRegKey:!operations!private! !
restoreTabWidth:!operations!private! !
restoreTextStyles:!helpers!private! !
restoreUserSettings!helpers!private! !
restoreViewOptions:!operations!private! !
saveBooleanOptions:underRegKey:!helpers!private! !
saveFontSetting:!helpers!private! !
saveOptions:!helpers!private! !
saveTabWidth:!helpers!private! !
saveTextStyles:!helpers!private! !
saveUserSettings!helpers!private! !
saveViewOptions:!helpers!private! !
saveWindowPlacement:!helpers!private! !
scintilla!accessing!private! !
statusBar!accessing!private! !
tabWidth!accessing!private! !
tabWidth:!accessing!private! !
toolbar!accessing!private! !
validateXml!commands!public! !
viewStatusBar!commands!private! !
viewToolbar!commands!private! !
!

!UI.Examples.XmlPad class methodsFor!

about
	"Private - Pop up a little helpful info. about this sample program."

	MessageBox new
		caption: 'About Dolphin <1d>' << self;
		icon: self icon;
		headline: 'XmlPad Sample';
		text: VM fullVersion;
		detailsText: 'XmlPad is a simple text-based XML editor. It is intended to demonstrate the DocumentShell hierarchy of Dolphin''s application framework, the Scintilla view component, and the use of the MSXML.

It is also useful for editing Xml!!

DISCLAIMER: This software is freely provided purely as an educational sample and as such it is provided "as is", WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.';
		open!

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
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 917510 ##(Graphics.Color) #face3d nil 551 nil nil nil 416 984838 ##(UI.BorderLayout) 1 1 410 ##(UI.Toolbar) 34 28 nil 416 34 2 8 1140853508 131137 528 nil 466 #default nil 519 nil 852998 ##(Graphics.Font) nil true 655622 ##(OS.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 918022 ##(Graphics.Point) 193 193 nil 528 592 8 1731461760 170 192 8 #() nil nil nil 170 192 34 18 27643 1443398 1 ##(UI.ToolbarSystemButton) 528 1 1377606 4 ##(UI.CommandDescription) #copySelection 8 'Copy' 1 1 nil 27643 1 3 27639 802 528 1 834 #find 8 'Find' 1 1 nil 27639 1 25 27635 802 528 1 834 #fileOpen 8 'Open' 1 1 nil 27635 1 15 27649 802 528 1 834 #undo 8 'Undo' 1 1 nil 27649 1 7 27645 802 528 1 834 #pasteClipboard 8 'Paste' 1 1 nil 27645 1 5 27641 802 528 1 834 #cutSelection 8 'Cut' 1 1 nil 27641 1 1 27637 802 528 1 834 #fileSave 8 'Save' 1 1 nil 27637 1 17 27633 802 528 1 834 #fileNew 8 'New' 1 1 nil 27633 1 13 27647 802 528 1 834 #clearSelection 8 'Delete' 1 1 nil 27647 1 11 34 11 1168 928 1120 1245766 1 ##(UI.ToolbarSeparator) 528 1 880 1282 528 1 1072 816 1024 1216 976 nil nil 1 nil 690 33 33 690 45 45 nil 852806 1 ##(UI.FlowLayout) 1 1 1 1310982 ##(Core.MessageSequence) 138 144 34 1 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 690 1 1 690 2369 51 528 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 160 4 0 0 25 0 0 0] 8 #() 690 193 193 nil 29 410 ##(UI.StatusBar) 34 21 nil 416 34 2 8 1140850948 1 1616 nil 592 nil 7 nil 610 nil true 642 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 690 193 193 nil 1616 nil 8 1731009616 170 192 34 2 1050438 1 ##(UI.StatusBarItem) 8193 -1 1616 nil 786950 ##(Core.Message) #displayString 8 #() 1246566 3 ##(Kernel.BlockClosure) 0 nil 1377574 ##(Kernel.CompiledMethod) 3 3 1792 #defaultGetImageBlock 462740483 8 #[31 105 226 0 159 106] #icon #imageIndex 1888 7 257 nil nil 8 'status' nil nil nil 34 1 1808 1311814 1 ##(UI.StatusBarNullItem) 8705 1 1616 nil nil 1394 138 144 34 1 1458 #createAt:extent: 34 2 690 1 1491 690 2369 45 1616 1538 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 233 2 0 0 160 4 0 0 255 2 0 0] 8 #() 1600 nil 29 nil nil 410 ##(UI.Scintilla.ScintillaView) 34 52 nil 416 34 2 8 1174475012 262145 2176 918598 2 ##(UI.ValueHolder) nil false 1769478 ##(Kernel.EqualitySearchPolicy) nil 592 nil 23 nil nil nil 2176 nil 8 2031624084 1049094 ##(UI.NullConverter) nil nil 9 382953025 170 192 34 60 #comment 1444934 1 ##(UI.Scintilla.TextStyle) 19 466 #olive nil 1 nil nil nil nil #comment nil nil nil #sgmlFirstParam 2386 47 786758 1 ##(Graphics.RGB) 52225 2450 33546207 1 nil nil nil nil #sgmlFirstParam nil nil nil #sgmlSingleString 2386 51 2450 26419 2450 33546207 1 nil nil nil nil #sgmlSingleString nil nil nil #singleString 2386 15 2450 16646399 nil 1 nil nil nil nil #singleString nil nil nil #normal 2386 1 nil nil 1 nil nil nil nil #normal nil nil nil #attribute 2386 7 466 #teal nil 1 nil nil nil nil #attribute nil nil nil #tag 2386 3 466 #navy nil 1 nil nil nil nil #tag nil nil nil #otherInsideTag 2386 17 466 #purple nil 1 nil nil nil nil #otherInsideTag nil nil nil #indentGuide 2386 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil #unknownAttribute 2386 9 2608 nil 1 nil nil nil nil #unknownAttribute nil nil nil #sgmlDoubleString 2386 49 466 #maroon 2450 33546207 1 nil nil nil nil #sgmlDoubleString nil nil nil #identifierStart 2386 27 2672 nil 3 nil nil nil nil #identifierStart nil 1401 nil #doubleString 2386 13 2450 16646399 nil 1 nil nil nil nil #doubleString nil nil nil #entity 2386 21 2672 nil 1 nil nil nil nil #entity nil nil nil #sgmlError 2386 53 2736 2450 13422079 1 nil nil nil nil #sgmlError nil nil nil #sgmlSpecial 2386 55 2450 33475687 2450 33546207 1 nil nil nil nil #sgmlSpecial nil nil nil #callTip 2386 77 466 #gray 466 #white 1 nil nil nil nil #callTip nil nil nil #sgmlTag 2386 43 2640 2450 33546207 1 nil nil nil nil #sgmlTag nil nil nil #identifierEnd 2386 25 2672 nil 3 nil nil nil nil #identifierEnd nil 1401 nil #unknownTag 2386 5 2640 nil 1 nil nil nil nil #unknownTag nil nil nil #question 2386 37 2736 nil 1 nil nil nil nil #question nil nil nil #CDATA 2386 35 2736 2450 31580671 129 nil nil nil nil #CDATA nil nil nil #sgmlBlock 2386 63 2450 13369345 2450 29464985 1 nil nil nil nil #sgmlBlock nil nil nil #sgmlCommand 2386 45 2640 2450 33546207 3 nil nil nil nil #sgmlCommand nil 1401 nil #lineNumber 2386 67 nil nil 1 nil nil nil nil #lineNumber nil nil nil #unquotedValue 2386 39 2450 12648641 nil 1 nil nil nil nil #unquotedValue nil nil nil #styleTagEnd 2386 23 2640 nil 1 nil nil nil nil #styleTagEnd nil nil nil #number 2386 11 2450 16711169 nil 1 nil nil nil nil #number nil nil nil #sgmlComment 2386 59 2416 2450 33546207 1 nil nil nil nil #sgmlComment nil nil nil #sgmlEntity 2386 57 2450 6710887 2450 33546207 1 nil nil nil nil #sgmlEntity nil nil nil nil 1507654 1 ##(UI.Scintilla.NullStyler) #normal 170 192 34 14 #folder 1903686 2 ##(UI.Scintilla.MarkerDefinition) 61 17 2944 466 #black 2176 #folder nil nil nil nil nil nil #folderMidTail 3394 55 11 2944 3424 2176 #folderMidTail nil nil nil nil nil nil #folderSub 3394 59 11 2944 3424 2176 #folderSub nil nil nil nil nil nil #folderEnd 3394 51 11 2944 3424 2176 #folderEnd nil nil nil nil nil nil #folderOpen 3394 63 15 2944 3424 2176 #folderOpen nil nil nil nil nil nil #folderOpenMid 3394 53 11 2944 3424 2176 #folderOpenMid nil nil nil nil nil nil #folderTail 3394 57 11 2944 3424 2176 #folderTail nil nil nil nil nil nil 138 ##(Core.IdentitySet) 752 nil 170 176 752 123903 nil nil 170 176 34 2 81 466 #windowText nil nil nil nil 65 nil nil nil 8 '' 5 170 192 34 4 #xml 2352 #container 170 192 34 60 #comment 2400 #sgmlFirstParam 2432 #sgmlSingleString 2496 #singleString 2544 #normal 2576 #attribute 2592 #tag 2624 #otherInsideTag 2656 #indentGuide 2688 #unknownAttribute 2704 #sgmlDoubleString 2720 #identifierStart 2768 #doubleString 2784 #entity 2816 #sgmlError 2832 #sgmlSpecial 2864 #callTip 2912 #sgmlTag 2960 #identifierEnd 2992 #unknownTag 3008 #question 3024 #CDATA 3040 #sgmlBlock 3072 #sgmlCommand 3120 #lineNumber 3152 #unquotedValue 3168 #styleTagEnd 3200 #number 3216 #sgmlComment 3248 #sgmlEntity 3280 nil nil #plusMinus 33 208 nil 170 192 34 6 8 'indicator1' 1772614 4 ##(UI.Scintilla.IndicatorStyle) 3 2176 466 #blue 5 1 nil nil nil nil nil nil nil 8 'indicator2' 3746 5 2176 466 #red 1 1 nil nil nil nil nil nil nil 8 'indicator0' 3746 1 2176 466 #commonGreen 3 1 nil nil nil nil nil nil nil nil nil 170 192 34 6 #Notification 2386 1029 nil 466 #gainsboro 1 nil nil nil nil #Notification nil nil nil #Warning 2386 1027 466 #darkGoldenrod 466 #ivory 1 nil nil nil nil #Warning nil nil nil #Error 2386 1031 466 #firebrick 466 #floralWhite 1 nil nil nil nil #Error nil nil nil nil nil nil 1394 138 144 34 6 1458 #createAt:extent: 34 2 690 1 51 690 2369 1441 2176 1458 #wordWrap: 8 #(true) 2176 1458 #margins: 34 1 34 3 1247302 3 ##(UI.Scintilla.Margin) 1 2176 1 3 nil nil nil nil 4242 3 2176 33 nil nil 67108863 nil nil 4242 5 2176 33 nil 3 -67108863 nil nil 2176 1458 #canHScroll: 8 #(false) 2176 1458 #maxCompletionListHeight: 8 #(9) 2176 1458 #setLexerLanguage: 8 #(#xml) 2176 1538 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 160 4 0 0 233 2 0 0] 8 #() 1600 nil 35 170 192 34 6 1616 8 'statusbar' 528 8 'toolbar' 2176 8 'document' nil 658246 4 ##(UI.MenuBar) nil true 34 4 461638 4 ##(UI.Menu) nil true 34 6 1180742 2 ##(UI.CommandMenuItem) 1 834 #fileNew 8 '&New' 9373 1 nil nil nil 4626 1 834 #fileOpen 8 '&Open…' 9375 1 nil nil nil 4626 1 834 #fileSave 8 '&Save' 9383 1 nil nil nil 4626 1 834 #fileSaveAs 8 'Save &As…' 1 1 nil nil nil 1179974 1 ##(UI.DividerMenuItem) 4097 4626 1 834 #exit 8 'E&xit' 1025 1 nil nil nil 8 '&File' nil 1 nil nil 27661 nil nil 4578 nil true 34 15 4626 1 834 #undo 8 '&Undo' 9397 1 nil nil nil 4626 1 834 #redo 8 '&Redo' 9395 1 nil nil nil 4834 4097 4626 1 834 #cutSelection 8 'Cu&t' 9393 1 nil nil nil 4626 1 834 #copySelection 8 '&Copy' 9351 1 nil nil nil 4626 1 834 #pasteClipboard 8 '&Paste' 9389 1 nil nil nil 4626 1 834 #clearSelection 8 'Cle&ar' 1025 1 nil nil nil 4626 1 834 #selectAll 8 'Select All' 9347 1 nil nil nil 4834 4097 4626 1 834 #reformatXml 8 'Refor&mat' 1 1 nil nil nil 4626 1 834 #validateXml 8 '&Validate' 1 1 nil nil nil 4834 4097 4626 1 834 #find 8 '&Find…' 9357 1 nil nil nil 4626 1 834 #findNext 8 'Find &Next' 1253 1 nil nil nil 4626 1 834 #findReplace 8 'R&eplace…' 9361 1 nil nil nil 8 '&Edit' nil 1 nil nil 27687 nil nil 4578 nil true 34 7 4626 1 834 #viewToolbar 8 '&Toolbar' 1025 1 nil nil nil 4626 1 834 #viewStatusBar 8 '&Status Bar' 1025 1 nil nil nil 4834 4097 4626 1 834 #foldAll 8 '&Fold All' 1 1 nil nil nil 4626 1 834 #unfoldAll 8 '&Unfold All' 1 1 nil nil nil 4834 4097 4578 nil true 34 1 4626 1 834 #editStyles 8 'Text &Styles' 1 1 nil nil nil 8 '&Options' nil 134217729 nil nil 27699 nil nil 8 '&View' nil 1 nil nil 27701 nil nil 4578 nil true 34 3 4626 1 834 #help 8 '&Help Topics' 1025 1 nil nil nil 4834 4097 4626 1 834 #about 8 '&About' 1 1 nil nil nil 8 '&Help' nil 1 nil nil 27707 nil nil 8 '' nil 1 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 1394 138 144 34 1 1458 #createAt:extent: 34 2 690 12287 21 690 2401 1653 416 1538 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 175 28 0 0 68 3 0 0] 34 3 528 2176 1616 1600 nil 27 )!

settingsKeyName
	^self toolName, ' 7.2'!

toolName
	^self name!

userSettingsKey
	"Private - Answer the <RegKey> under which user specific settings should be stored."

	^self userSettingsRootKey createKey: self settingsKeyName!

userSettingsRootKey
	^RegKey userRoot createKey: self installKeyName! !
!UI.Examples.XmlPad class categoriesForMethods!
about!enquiries!private! !
defaultFileExtension!constants!public! !
displayOn:!displaying!public! !
explicitDependencies!must not strip!private! !
fileTypes!constants!public! !
icon!constants!public! !
initialize!development!initializing!public! !
installKeyName!accessing!public! !
legacySettingsKeyName!private! !
resource_Default_view!public!resources-views! !
settingsKeyName!accessing!public! !
toolName!accessing!public! !
userSettingsKey!accessing!public! !
userSettingsRootKey!accessing!public! !
!

