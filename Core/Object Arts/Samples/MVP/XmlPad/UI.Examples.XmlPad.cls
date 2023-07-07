"Filed out from Dolphin Smalltalk"!

UI.TextDocument
	subclass: #'UI.Examples.XmlPad'
	instanceVariableNames: 'viewOptions'
	classVariableNames: ''
	imports: #(#{MSXML private})
	classInstanceVariableNames: ''
	classConstants: { 'RememberPlacementMask' -> 16r1 }!
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
	^#(#('AutoCompleteSingle' #isAutoCompletionSingleMatchChosen #isAutoCompletionSingleMatchChosen:) #('AutoCompleteTruncate' #isAutoCompletionTruncating #isAutoCompletionTruncating:) #('ChangeHistory' #hasChangeHistoryMarkers #hasChangeHistoryMarkers:) #('Folding' #isFoldingEnabled #isFoldingEnabled:) #('FormattingMarks' #hasFormattingMarks #hasFormattingMarks:) #('IdentationGuides' #hasIndentationGuides #hasIndentationGuides:) #('LineEndings' #hasVisibleLineEndings #hasVisibleLineEndings:) #('LineNumbers' #hasLineNumbers #hasLineNumbers:) #('SavePlacement' #isRememberingPlacement #isRememberingPlacement:) #('Styling' #isStylingEnabled #isStylingEnabled:) #('WordWrap' #hasWordWrap #hasWordWrap:))!

fileSave
	<commandQuery: #canSave>
	^(
	[self basicValidateXml.
	true] on: DOMParseError
			do: 
				[:ex |
				MessageBox new
					headline: 'Save invalid XML?';
					detailsText: ex tag displayString;
					confirm: 'The XML contains one or more errors and is invalid. Are you sure that you would like to save it?'])
			ifTrue: [^super fileSave]!

hasChangeHistoryMarkers
	^self scintilla margins second width ~~ 0!

hasChangeHistoryMarkers: aBoolean
	| editor |
	aBoolean = self hasChangeHistoryMarkers ifTrue: [^self].
	editor := self scintilla.
	"We don't actually turn the change history on and off, just hide/show the margin. This is because change history can only be enabled after a save point with undo enabled. It provides a better user experience to just enable it when the document is loaded, and leave it turned on, otherwise it would be necessary to surface the modality to the user in some way."
	aBoolean ifTrue: [editor margins second width: 16] ifFalse: [editor margins second width: 0]!

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

hasValidXml
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

hasVisibleLineEndings
	^self scintilla hasVisibleLineEndings!

hasVisibleLineEndings: aBoolean 
	^self scintilla hasVisibleLineEndings: aBoolean!

hasWordWrap
	^self scintilla wordWrap!

hasWordWrap: aBoolean 
	^self scintilla wordWrap: aBoolean!

initialize
	super initialize.
	viewOptions := RememberPlacementMask.!

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

isStylingEnabled
	^self scintilla isStylingEnabled!

isStylingEnabled: aBoolean
	"ScintillaView can only toggle container lexer on (it doesn't remember the lexer other than as a setting of the actual Scintilla control)"

	aBoolean ifTrue: [self scintilla lexer: #xml] ifFalse: [self scintilla isStylingEnabled: false]!

loadLegacySettings
	"For legacy format settings, saved prior to Dolphin 8, we do not use the RegistryDeserializer."

	^(self class userSettingsRootKey lookup: self class legacySettingsKeyName)
		ifNotNil: 
			[:settingsKey |
			| settings bools |
			settings := LookupTable new.
			bools := Set new.
			bools addAll: (self booleanOptions collect: [:each | each first]).
			bools addAll: (self booleanViewOptions collect: [:each | each first]).
			settingsKey subValueNamesAndValuesDo: 
					[:eachName :each |
					settings at: eachName put: ((bools includes: eachName) ifTrue: [each asBoolean] ifFalse: [each])].
			(settingsKey objectAt: 'TextStyles' ifAbsent: nil)
				ifNotNil: [:styles | settings at: 'TextStyles' put: styles].
			settingsKey free.
			settings]!

loadSettings
	^(self class userSettingsRootKey lookup: self class settingsKeyName)
		ifNil: [self loadLegacySettings]
		ifNotNil: 
			[:settingsKey |
			| settings deserializer |
			deserializer := OS.RegistryDeserializer regKey: settingsKey.
			deserializer
				addSafeClass: WINDOWPLACEMENT;
				addSafeClass: LOGFONTW;
				addSafeClass: UI.Scintilla.TextStyle.
			settings := deserializer readObject.
			settingsKey free.
			settings]!

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

queryToggleChangeHistory: aCommandQuery
	aCommandQuery
		isEnabled: true;
		isChecked: self hasChangeHistoryMarkers!

queryToggleRememberPlacement: aCommandQuery
	aCommandQuery
		isEnabled: true;
		isChecked: self isRememberingPlacement!

queryToggleStatusBar: aCommandQuery
	aCommandQuery
		isEnabled: true;
		isChecked: self statusBar isWindowVisible!

queryToggleToolbar: aCommandQuery
	aCommandQuery
		isEnabled: true;
		isChecked: self toolbar isWindowVisible!

queryToggleXmlStyling: aCommandQuery
	aCommandQuery
		isEnabled: true;
		isChecked: self isStylingEnabled!

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

restoreBooleanOptions: anArrayOfPairs from: values
	"Note that we must be careful to #perform: only a fixed set of mutators configured in the application code itself. This avoids the potential for code injection that would arise if we sent messages with names loaded from the registry. We also clamp the values to true/false."

	anArrayOfPairs do: 
			[:each |
			values at: each first
				ifPresent: 
					[:value |
					##(LookupTable withAll: {true -> true. false -> false. 1 -> true. 0 -> false}) at: value
						ifPresent: [:bool | self perform: each third with: bool]]]!

restoreUserSettings
	| settings |
	settings := self loadSettings.
	settings ifNil: [^self].
	self restoreBooleanOptions: self booleanViewOptions from: settings.
	self isRememberingPlacement
		ifTrue: [(settings at: 'Placement' ifAbsent: nil) ifNotNil: [:placement | view placement: placement]].
	(settings at: 'TextStyles' ifAbsent: nil) ifNotNil: [:styles | self scintilla textStyles: styles].
	(settings at: 'TabWidth' ifAbsent: nil)
		ifNotNil: [:width | (width isInteger and: [width between: 1 and: 16]) ifTrue: [self tabWidth: width]].
	self restoreBooleanOptions: self booleanOptions from: settings!

saveUserSettings
	"Private - Save the users configuration to the registry."

	| settings |
	settings := LookupTable new.
	settings at: 'TabWidth' put: self tabWidth.
	self booleanViewOptions do: [:each | settings at: each first put: (self perform: each second)].
	settings at: 'TextStyles' put: self scintilla textStyles asArray.
	self booleanOptions do: [:each | settings at: each first put: (self perform: each second)].
	self isRememberingPlacement
		ifTrue: 
			[| placement |
			placement := self view placement.
			placement showCmd: (self view isMaximized ifTrue: [SW_SHOWMAXIMIZED] ifFalse: [SW_SHOW]).
			settings at: 'Placement' put: placement].
	settings at: 'Font' put: self view actualFont logFont.
	OS.RegistrySerializer
		write: settings
		to: self class userSettingsRootKey
		name: self class settingsKeyName!

scintilla
	^documentPresenter view!

setDocumentData: aString 
	"Private - Set the data for the receiver's document to be anObject.
	Can be overidden by subclasses"

	super setDocumentData: aString.
	self scintilla changeHistoryMode: #markers.!

statusBar
	^self view viewNamed: 'statusbar'!

tabWidth
	^self scintilla tabWidth!

tabWidth: anInteger 
	self scintilla tabWidth: anInteger!

toggleChangeHistory
	<commandQuery: #queryToggleChangeHistory:>
	self hasChangeHistoryMarkers: self hasChangeHistoryMarkers not!

toggleRememberPlacement
	<commandQuery: #queryToggleRememberPlacement:>
	self isRememberingPlacement: self isRememberingPlacement not!

toggleStatusBar
	<commandQuery: #queryToggleStatusBar:>
	| statusBar |
	statusBar := self statusBar.
	statusBar isWindowVisible ifTrue: [statusBar hide] ifFalse: [statusBar show]!

toggleToolbar
	<commandQuery: #queryToggleToolbar:>
	| toolbar |
	toolbar := self toolbar.
	toolbar isWindowVisible ifTrue: [toolbar hide] ifFalse: [toolbar show]!

toggleXmlStyling
	"Enable/disable dynamic styling of text in the receiver."

	<commandQuery: #queryToggleXmlStyling:>
	self isStylingEnabled: self isStylingEnabled not!

toolbar
	^self view viewNamed: 'toolbar'!

validateXml
	statusModel
		value: (
			[self basicValidateXml.
			nil] on: DOMParseError do: [:ex | ex tag])! !
!UI.Examples.XmlPad categoriesForMethods!
about!commands-actions!public! !
basicValidateXml!helpers!private! !
booleanOptions!helpers!private! !
booleanViewOptions!helpers!private! !
fileSave!commands-actions!public! !
hasChangeHistoryMarkers!public!testing! !
hasChangeHistoryMarkers:!options!public! !
hasFormattingMarks!public!testing! !
hasFormattingMarks:!accessing!public! !
hasIndentationGuides!public!testing! !
hasIndentationGuides:!accessing!public! !
hasLineNumbers!public!testing! !
hasLineNumbers:!accessing!public! !
hasValidXml!public!testing! !
hasVisibleLineEndings!public!testing! !
hasVisibleLineEndings:!options!public! !
hasWordWrap!public!testing! !
hasWordWrap:!accessing!public! !
initialize!initializing!public! !
isAutoCompleteEnabled!options!public! !
isAutoCompleteEnabled:!options!public! !
isAutoCompletionSingleMatchChosen!public!testing! !
isAutoCompletionSingleMatchChosen:!options!public! !
isAutoCompletionTruncating!public!testing! !
isAutoCompletionTruncating:!options!public! !
isFoldingEnabled!public!testing! !
isFoldingEnabled:!accessing!public! !
isRememberingPlacement!public!testing! !
isRememberingPlacement:!options!public! !
isStylingEnabled!public!styling! !
isStylingEnabled:!public!styling! !
loadLegacySettings!options!public! !
loadSettings!options!public! !
parseXml!helpers!private! !
parseXml:validate:!helpers!private! !
queryToggleChangeHistory:!commands-queries!private! !
queryToggleRememberPlacement:!commands-queries!private! !
queryToggleStatusBar:!commands-queries!private! !
queryToggleToolbar:!commands-queries!private! !
queryToggleXmlStyling:!commands-queries!private! !
reformatXml!commands-actions!public! !
restoreBooleanOptions:from:!operations!private! !
restoreUserSettings!helpers!private! !
saveUserSettings!helpers!private! !
scintilla!accessing!private! !
setDocumentData:!accessing!private! !
statusBar!accessing!private! !
tabWidth!accessing!private! !
tabWidth:!accessing!private! !
toggleChangeHistory!commands-actions!public! !
toggleRememberPlacement!commands-actions!public! !
toggleStatusBar!commands-actions!public! !
toggleToolbar!commands-actions!public! !
toggleXmlStyling!commands-actions!public!styling! !
toolbar!accessing!private! !
validateXml!commands-actions!public! !
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

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.ShellView} 34 27 nil nil 8 #(13565952 65536) 416 nil 917510 #{Graphics.Color} #face3d nil 551 nil nil nil 416 984838 #{UI.BorderLayout} 1 1 410 #{UI.Toolbar} 34 28 nil 416 34 2 8 1140853508 131137 528 nil 466 #default nil 519 nil 852998 #{Graphics.Font} nil true 655622 #{OS.LOGFONT} 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 918022 #{Graphics.Point} 193 193 nil 528 592 8 1818022976 170 192 8 #() nil nil nil 170 192 34 18 24991 1443398 1 #{UI.ToolbarSystemButton} 528 1 1377606 4 #{UI.CommandDescription} #pasteClipboard 8 'Paste' 1 1 nil 24991 1 5 24987 802 528 1 834 #cutSelection 8 'Cut' 1 1 nil 24987 1 1 24983 802 528 1 834 #fileSave 8 'Save' 1 1 nil 24983 1 17 24979 802 528 1 834 #fileNew 8 'New' 1 1 nil 24979 1 13 24993 802 528 1 834 #clearSelection 8 'Delete' 1 1 nil 24993 1 11 24989 802 528 1 834 #copySelection 8 'Copy' 1 1 nil 24989 1 3 24985 802 528 1 834 #find 8 'Find' 1 1 nil 24985 1 25 24981 802 528 1 834 #fileOpen 8 'Open' 1 1 nil 24981 1 15 24995 802 528 1 834 #undo 8 'Undo' 1 1 nil 24995 1 7 34 11 976 1168 928 1245766 1 #{UI.ToolbarSeparator} 528 1 1120 1282 528 1 880 1072 816 1024 1216 nil nil 1 nil 690 33 33 690 45 45 nil 852806 1 #{UI.FlowLayout} 1 1 1 1310982 #{Core.MessageSequence} 34 1 1049350 #{Core.MessageSend} #createAt:extent: 34 2 690 1 1 690 2369 51 528 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 160 4 0 0 25 0 0 0] 8 #() 690 193 193 nil 29 410 #{UI.StatusBar} 34 21 nil 416 34 2 8 1140850948 1 1600 nil 592 nil 7 nil 610 nil true 642 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 690 193 193 nil 1600 nil 8 1817716480 170 192 34 2 1050438 1 #{UI.StatusBarItem} 8193 -1 1600 nil 786950 #{Core.Message} #displayString 8 #() 1246566 3 #{Kernel.BlockClosure} 0 nil 1377574 #{Kernel.CompiledMethod} 3 3 1776 #defaultGetImageBlock 462740483 8 #[31 105 226 0 159 106] #icon #imageIndex 1872 7 257 nil nil 8 'status' nil nil nil 34 1 1792 1311814 1 #{UI.StatusBarNullItem} 8705 1 1600 nil nil 1394 34 1 1442 #createAt:extent: 34 2 690 1 1491 690 2369 45 1600 1522 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 233 2 0 0 160 4 0 0 255 2 0 0] 8 #() 1584 nil 29 nil nil 410 #{UI.Scintilla.ScintillaView} 34 52 nil 416 34 2 8 1174475012 262145 2144 918598 2 #{UI.ValueHolder} nil false 1769478 #{Kernel.EqualitySearchPolicy} nil 592 nil 23 nil nil nil 2144 nil 8 1834785184 1049094 #{UI.NullConverter} nil nil 9 nil 170 192 34 60 #sgmlSpecial 1444934 1 #{UI.Scintilla.TextStyle} 55 786758 1 #{Graphics.RGB} 33475687 2386 33546207 1 nil nil nil nil #sgmlSpecial nil nil nil #lineNumber 2354 67 nil nil 1 nil nil nil nil #lineNumber nil nil nil #attribute 2354 7 466 #teal nil 1 nil nil nil nil #attribute nil nil nil #unknownAttribute 2354 9 2464 nil 1 nil nil nil nil #unknownAttribute nil nil nil #number 2354 11 2386 16711169 nil 1 nil nil nil nil #number nil nil nil #doubleString 2354 13 2386 16646399 nil 1 nil nil nil nil #doubleString nil nil nil #identifierEnd 2354 25 466 #purple nil 3 nil nil nil nil #identifierEnd nil 1401 nil #singleString 2354 15 2386 16646399 nil 1 nil nil nil nil #singleString nil nil nil #question 2354 37 466 #maroon nil 1 nil nil nil nil #question nil nil nil #unquotedValue 2354 39 2386 12648641 nil 1 nil nil nil nil #unquotedValue nil nil nil #sgmlComment 2354 59 466 #olive 2386 33546207 1 nil nil nil nil #sgmlComment nil nil nil #sgmlFirstParam 2354 47 2386 52225 2386 33546207 1 nil nil nil nil #sgmlFirstParam nil nil nil #normal 2354 1 nil nil 1 nil nil nil nil #normal nil nil nil #entity 2354 21 2576 nil 1 nil nil nil nil #entity nil nil nil #otherInsideTag 2354 17 2576 nil 1 nil nil nil nil #otherInsideTag nil nil nil #sgmlTag 2354 43 466 #navy 2386 33546207 1 nil nil nil nil #sgmlTag nil nil nil #tag 2354 3 2848 nil 1 nil nil nil nil #tag nil nil nil #sgmlDoubleString 2354 49 2640 2386 33546207 1 nil nil nil nil #sgmlDoubleString nil nil nil #sgmlBlock 2354 63 2386 13369345 2386 29464985 1 nil nil nil nil #sgmlBlock nil nil nil #indentGuide 2354 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil #styleTagEnd 2354 23 2848 nil 1 nil nil nil nil #styleTagEnd nil nil nil #sgmlEntity 2354 57 2386 6710887 2386 33546207 1 nil nil nil nil #sgmlEntity nil nil nil #callTip 2354 77 466 #gray 466 #white 1 nil nil nil nil #callTip nil nil nil #identifierStart 2354 27 2576 nil 3 nil nil nil nil #identifierStart nil 1401 nil #comment 2354 19 2704 nil 1 nil nil nil nil #comment nil nil nil #sgmlSingleString 2354 51 2386 26419 2386 33546207 1 nil nil nil nil #sgmlSingleString nil nil nil #sgmlError 2354 53 2640 2386 13422079 1 nil nil nil nil #sgmlError nil nil nil #sgmlCommand 2354 45 2848 2386 33546207 3 nil nil nil nil #sgmlCommand nil 1401 nil #unknownTag 2354 5 2848 nil 1 nil nil nil nil #unknownTag nil nil nil #CDATA 2354 35 2640 2386 31580671 129 nil nil nil nil #CDATA nil nil nil nil 1507654 1 #{UI.Scintilla.NullStyler} #normal 170 192 34 22 #folderOpenMid 1903686 2 #{UI.Scintilla.MarkerDefinition} 53 11 3088 466 #black 2144 #folderOpenMid nil nil nil nil nil nil #folderTail 3362 57 11 3088 3392 2144 #folderTail nil nil nil nil nil nil #folderOpen 3362 63 15 3088 3392 2144 #folderOpen nil nil nil nil nil nil #historyRevertedToOrigin 3362 43 67 2386 25116801 3456 2144 #historyRevertedToOrigin nil nil nil nil nil nil #historySaved 3362 45 67 2386 81921 3488 2144 #historySaved nil nil nil nil nil nil #historyModified 3362 47 67 2386 66047 480 2144 #historyModified nil nil nil nil nil nil #folder 3362 61 17 3088 3392 2144 #folder nil nil nil nil nil nil #folderMidTail 3362 55 11 3088 3392 2144 #folderMidTail nil nil nil nil nil nil #historyRevertedToModified 3362 49 67 2386 98625 3584 2144 #historyRevertedToModified nil nil nil nil nil nil #folderEnd 3362 51 11 3088 3392 2144 #folderEnd nil nil nil nil nil nil #folderSub 3362 59 11 3088 3392 2144 #folderSub nil nil nil nil nil nil 138 #{Core.IdentitySet} 752 nil 170 176 752 123903 nil nil 170 176 34 8 81 466 #windowText 121 466 #silver 23 1245702 #{Graphics.ColorAlpha} 466 #highlight 121 161 3730 3696 257 nil 34 1 2360326 #{UI.Scintilla.CharacterRepresentation} $\x2028 nil 33 3730 3696 257 2162950 #{UI.Scintilla.NullScintillaLibrary} nil 65 nil nil nil nil 5 170 192 34 4 #xml 2320 #container 170 192 34 60 #CDATA 3264 #lineNumber 2432 #unknownAttribute 2480 #attribute 2448 #number 2496 #doubleString 2528 #question 2624 #singleString 2592 #sgmlComment 2688 #identifierEnd 2560 #unquotedValue 2656 #sgmlFirstParam 2736 #entity 2800 #sgmlTag 2832 #normal 2784 #sgmlDoubleString 2896 #tag 2880 #otherInsideTag 2816 #sgmlBlock 2928 #indentGuide 2976 #sgmlEntity 3008 #styleTagEnd 2992 #callTip 3056 #identifierStart 3104 #comment 3120 #sgmlError 3184 #sgmlSingleString 3136 #sgmlCommand 3216 #unknownTag 3248 #sgmlSpecial 2368 nil nil #plusMinus 33 208 nil 170 192 34 6 8 'indicator1' 2100294 5 #{UI.Scintilla.IndicatorDefinition} 3 2144 466 #blue 5 1 nil nil nil nil nil nil nil 8 'indicator2' 4002 5 2144 466 #red 1 1 nil nil nil nil nil nil nil 8 'indicator0' 4002 1 2144 466 #commonGreen 3 1 nil nil nil nil nil nil nil nil nil 170 192 34 6 #Notification 2354 1029 nil 466 #gainsboro 1 nil nil nil nil #Notification nil nil nil #Warning 2354 1027 466 #darkGoldenrod 466 #ivory 1 nil nil nil nil #Warning nil nil nil #Error 2354 1031 466 #firebrick 466 #floralWhite 1 nil nil nil nil #Error nil nil nil nil nil nil 1394 34 7 1442 #createAt:extent: 34 2 690 1 51 690 2369 1441 2144 1442 #wordWrap: 8 #(true) 2144 1442 #margins: 34 1 34 3 1247302 3 #{UI.Scintilla.Margin} 1 2144 nil 3 nil nil nil nil 4482 3 2144 nil nil nil 67108863 nil nil 4482 5 2144 33 nil 3 8 4261412864 nil nil 2144 1442 #sciSetHScrollBar: 8 #(false) 2144 1442 #maxCompletionListHeight: 8 #(9) 2144 1442 #setLexerLanguage: 8 #(#xml) 2144 1442 #sciSetSelectionLayer: 8 #(1) 2144 1522 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 160 4 0 0 233 2 0 0] 8 #() 1584 nil 37 170 192 34 6 2144 8 'document' 1600 8 'statusbar' 528 8 'toolbar' nil 658246 4 #{UI.MenuBar} nil true 34 4 461638 4 #{UI.Menu} nil true 34 6 1180742 2 #{UI.CommandMenuItem} 1 834 #fileNew 8 '&New' 9373 1 nil nil nil 4914 1 834 #fileOpen 8 '&Open…' 9375 1 nil nil nil 4914 1 834 #fileSave 8 '&Save' 9383 1 nil nil nil 4914 1 834 #fileSaveAs 8 'Save &As…' 1 1 nil nil nil 1179974 1 #{UI.DividerMenuItem} 4097 4914 1 834 #exit 8 'E&xit' 1025 1 nil nil nil 8 '&File' nil 1 nil nil 39373 nil nil 4866 nil true 34 15 4914 1 834 #undo 8 '&Undo' 9397 1 nil nil nil 4914 1 834 #redo 8 '&Redo' 9395 1 nil nil nil 5122 4097 4914 1 834 #cutSelection 8 'Cu&t' 9393 1 nil nil nil 4914 1 834 #copySelection 8 '&Copy' 9351 1 nil nil nil 4914 1 834 #pasteClipboard 8 '&Paste' 9389 1 nil nil nil 4914 1 834 #clearSelection 8 'Cle&ar' 1025 1 nil nil nil 4914 1 834 #selectAll 8 'Select All' 9347 1 nil nil nil 5122 4097 4914 1 834 #reformatXml 8 'Refor&mat' 1 1 nil nil nil 4914 1 834 #validateXml 8 '&Validate' 1 1 nil nil nil 5122 4097 4914 1 834 #find 8 '&Find…' 9357 1 nil nil nil 4914 1 834 #findNext 8 'Find &Next' 1253 1 nil nil nil 4914 1 834 #findReplace 8 'R&eplace…' 9361 1 nil nil nil 8 '&Edit' nil 1 nil nil 39423 nil nil 4866 nil true 34 7 4914 1 834 #viewToolbar 8 '&Toolbar' 1025 1 nil nil nil 4914 1 834 #viewStatusBar 8 '&Status Bar' 1025 1 nil nil nil 5122 4097 4914 1 834 #foldAll 8 '&Fold All' 1 1 nil nil nil 4914 1 834 #unfoldAll 8 '&Unfold All' 1 1 nil nil nil 5122 4097 4866 nil true 34 11 4914 1 834 #editStyles 8 'Text &Styles' 1 1 nil nil nil 5122 4097 4914 1 834 #toggleChangeHistory 8 '&Change History' 1 1 nil nil nil 4914 1 834 #toggleIndentationGuides 8 '&Indentation Guides' 1 1 nil nil nil 4914 1 834 #toggleLineEndings 8 '&Line Endings' 1 1 nil nil nil 4914 1 834 #toggleLineNumbers 8 'Line &Numbers' 1 1 nil nil nil 4914 1 834 #toggleXmlStyling 8 'St&yling' 1 1 nil nil nil 4914 1 834 #toggleWhitespace 8 'Whites&pace' 1 1 nil nil nil 4914 1 834 #toggleWordWrap 8 '&Word wrap' 1 1 nil nil nil 5122 4097 4914 1 834 #toggleRememberPlacement 8 '&Remember Placement' 1 1 nil nil nil 8 '&Options' nil 134217729 nil nil 39451 nil nil 8 '&View' nil 1 nil nil 39453 nil nil 4866 nil true 34 3 4914 1 834 #help 8 '&Help Topics' 1025 1 nil nil nil 5122 4097 4914 1 834 #about 8 '&About' 1 1 nil nil nil 8 '&Help' nil 1 nil nil 39459 nil nil 8 '' nil 1 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 1394 34 1 1442 #createAt:extent: 34 2 690 6143 21 690 2401 1653 416 1522 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 175 16 0 0 68 3 0 0] 34 3 528 2144 1600 1584 nil 27)!

settingsKeyName
	^self toolName, ' 8.0'!

toolName
	^self name!

userSettingsRootKey
	^RegKey userRoot createKey: self installKeyName! !
!UI.Examples.XmlPad class categoriesForMethods!
about!enquiries!private! !
defaultFileExtension!constants!public! !
displayOn:!displaying!public! !
explicitDependencies!must not strip!private! !
fileTypes!constants!public! !
icon!constants!public! !
installKeyName!accessing!public! !
legacySettingsKeyName!private! !
resource_Default_view!public!resources-views! !
settingsKeyName!accessing!public! !
toolName!accessing!public! !
userSettingsRootKey!accessing!public! !
!

