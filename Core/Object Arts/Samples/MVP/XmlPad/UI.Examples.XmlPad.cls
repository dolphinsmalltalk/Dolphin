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

optionsTabWidth
	(IntegerPrompter create
		caption: 'Choose Tab Width';
		prompt: 'Enter number:';
		interval: (1 to: 16);
		value: self tabWidth;
		showModal) ifNotNil: [:count | self tabWidth: count]!

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

queryReformatXml: aCommandQuery
	aCommandQuery
		isEnabled: self scintilla textLength > 0!

queryToggleChangeHistory: aCommandQuery
	aCommandQuery
		beEnabled;
		isChecked: self hasChangeHistoryMarkers!

queryToggleRememberPlacement: aCommandQuery
	aCommandQuery
		beEnabled;
		isChecked: self isRememberingPlacement!

queryToggleStatusBar: aCommandQuery
	aCommandQuery
		beEnabled;
		isChecked: self statusBar isWindowVisible!

queryToggleToolbar: aCommandQuery
	aCommandQuery
		beEnabled;
		isChecked: self toolbar isWindowVisible!

queryToggleXmlStyling: aCommandQuery
	aCommandQuery
		beEnabled;
		isChecked: self isStylingEnabled!

reformatXml
	<commandQuery: #queryReformatXml:>
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
optionsTabWidth!commands-actions!public! !
parseXml!helpers!private! !
parseXml:validate:!helpers!private! !
queryReformatXml:!commands-queries!private! !
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

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.ShellView} 38 #{Core.Array} 27 nil nil 8 #(13565952 65536) 32 nil 6 #{Graphics.Color} #face3d nil 517 nil nil nil 32 1798 #{UI.BorderLayout} 1 1 18 #{UI.Toolbar} 50 28 nil 32 50 2 8 1409289036 131073 160 nil 98 #default nil 517 nil nil nil 160 nil nil nil nil nil nil nil 8 #() nil nil 9 763 #smallIcons nil nil 838 1 #{UI.FlowLayout} 1 1 1 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[0 0 0 0 0 0 0 0 160 4 0 0 25 0 0 0] 193 192 8 '' 160 3 50 4 18 #{UI.ReferenceView} 50 14 nil 160 50 2 8 1140850688 131073 496 nil nil nil 5 nil nil nil 496 582 1 #{UI.ResourceIdentifier} #{UI.Toolbar} #resource_Fluent_File_tools nil 290 50 1 338 #createWindow: 50 1 386 418 8 #[0 0 0 0 0 0 0 0 89 0 0 0 25 0 0 0] 193 528 8 '' 496 3 8 #() 518 #{Graphics.Point} 193 193 nil 27 18 #{UI.ReferenceView} 50 14 nil 160 50 2 8 1140850688 131073 768 nil nil nil 5 nil nil nil 768 562 #{UI.Toolbar} #resource_Fluent_Edit_tools nil 290 50 1 338 #createWindow: 50 1 386 418 8 #[89 0 0 0 0 0 0 0 228 0 0 0 25 0 0 0] 193 800 8 '' 768 3 720 738 193 193 nil 27 18 #{UI.ReferenceView} 50 14 nil 160 50 2 8 1140850688 131073 992 nil nil nil 5 nil nil nil 992 562 #{UI.Toolbar} #resource_Fluent_Find_tools nil 290 50 1 338 #createWindow: 50 1 386 418 8 #[228 0 0 0 0 0 0 0 36 1 0 0 25 0 0 0] 193 1024 8 '' 992 3 720 738 193 193 nil 27 18 #{UI.Toolbar} 50 28 nil 160 50 2 8 1409293132 131137 1216 nil nil nil 517 nil nil nil 1216 224 nil 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 720 nil nil nil nil 50 4 1350 1 #{UI.ToolbarTextButton} 1216 161 1350 4 #{UI.CommandDescription} #foldAll 8 '&Fold All' 1 1 nil nil 8 $\xF165 1330 1216 161 1362 #unfoldAll 8 '&Unfold All' 1 1 nil nil 8 $\xECCD 1330 1216 161 1362 #reformatXml 8 '&Reformat XML' 1 1 nil nil 8 $\xE736 582 1 #{UI.ToolbarSeparator} 1216 1 nil nil 13 5 nil nil nil nil 290 50 1 338 #createWindow: 50 1 386 418 8 #[36 1 0 0 0 0 0 0 125 1 0 0 25 0 0 0] 193 50 2 8 1409293132 131137 8 '' 1216 3 8 #() 738 193 193 nil 31 738 193 193 nil 31 18 #{UI.StatusBar} 50 21 nil 32 50 2 8 1140850948 1 1792 nil 224 nil 5 nil 1350 1 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 0 65 0 114 0 105 0 97 0 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 1792 nil nil 1282 #{Core.IdentityDictionary} 50 2 1862 1 #{UI.StatusBarItem} 8193 -1 1792 nil 518 #{Core.Message} #displayString 8 #() 1382 3 #{Kernel.BlockClosure} 0 nil 1318 #{Kernel.CompiledMethod} 3 3 1968 #defaultGetImageBlock 462740483 8 #[31 105 226 0 159 106] #icon #imageIndex 2064 7 257 nil nil 8 'status' nil nil nil 50 1 1984 1094 1 #{UI.StatusBarNullItem} 8705 1 1792 nil nil 290 50 1 338 #createWindow: 50 1 386 418 8 #[0 0 0 0 233 2 0 0 160 4 0 0 255 2 0 0] 193 1824 8 '' 1792 3 8 #() 738 193 193 nil 29 nil nil 18 #{UI.Scintilla.ScintillaView} 50 56 nil 32 50 2 8 1174475012 262145 2352 1094 2 #{UI.ValueHolder} nil false 6 #{Kernel.EqualitySearchPolicy} nil 224 nil 21 nil nil nil 2352 nil nil 518 #{UI.NullConverter} nil nil 9 #focusLost nil nil nil nil 550 #{Core.IdentityDictionary} 30 #attribute 3142 1 #{UI.Scintilla.TextStyle} 7 98 #teal nil 1 nil nil nil nil #attribute nil nil nil #callTip 2546 77 98 #gray 98 #white 1 nil nil nil nil #callTip nil nil nil #CDATA 2546 35 98 #maroon 326 1 #{Graphics.RGB} 31580671 129 nil nil nil nil #CDATA nil nil nil #comment 2546 19 98 #olive nil 1 nil nil nil nil #comment nil nil nil #doubleString 2546 13 2674 16646399 nil 1 nil nil nil nil #doubleString nil nil nil #entity 2546 21 98 #purple nil 1 nil nil nil nil #entity nil nil nil #identifierEnd 2546 25 2784 nil 3 nil nil nil nil #identifierEnd nil 1401 nil #identifierStart 2546 27 2784 nil 3 nil nil nil nil #identifierStart nil 1401 nil #indentGuide 2546 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil #lineNumber 2546 67 nil nil 1 nil nil nil nil #lineNumber nil nil nil #normal 2546 1 nil nil 1 nil nil nil nil #normal nil nil nil #number 2546 11 2674 16711169 nil 1 nil nil nil nil #number nil nil nil #otherInsideTag 2546 17 2784 nil 1 nil nil nil nil #otherInsideTag nil nil nil #question 2546 37 2656 nil 1 nil nil nil nil #question nil nil nil #sgmlBlock 2546 63 2674 13369345 2674 29464985 1 nil nil nil nil #sgmlBlock nil nil nil #sgmlCommand 2546 45 98 #navy 2674 33546207 3 nil nil nil nil #sgmlCommand nil 1401 nil #sgmlComment 2546 59 2720 2674 33546207 1 nil nil nil nil #sgmlComment nil nil nil #sgmlDoubleString 2546 49 2656 2674 33546207 1 nil nil nil nil #sgmlDoubleString nil nil nil #sgmlEntity 2546 57 2674 6710887 2674 33546207 1 nil nil nil nil #sgmlEntity nil nil nil #sgmlError 2546 53 2656 2674 13422079 1 nil nil nil nil #sgmlError nil nil nil #sgmlFirstParam 2546 47 2674 52225 2674 33546207 1 nil nil nil nil #sgmlFirstParam nil nil nil #sgmlSingleString 2546 51 2674 26419 2674 33546207 1 nil nil nil nil #sgmlSingleString nil nil nil #sgmlSpecial 2546 55 2674 33475687 2674 33546207 1 nil nil nil nil #sgmlSpecial nil nil nil #sgmlTag 2546 43 3008 2674 33546207 1 nil nil nil nil #sgmlTag nil nil nil #singleString 2546 15 2674 16646399 nil 1 nil nil nil nil #singleString nil nil nil #styleTagEnd 2546 23 3008 nil 1 nil nil nil nil #styleTagEnd nil nil nil #tag 2546 3 3008 nil 1 nil nil nil nil #tag nil nil nil #unknownAttribute 2546 9 2576 nil 1 nil nil nil nil #unknownAttribute nil nil nil #unknownTag 2546 5 3008 nil 1 nil nil nil nil #unknownTag nil nil nil #unquotedValue 2546 39 2674 12648641 nil 1 nil nil nil nil #unquotedValue nil nil nil nil 326 1 #{UI.Scintilla.NullStyler} #normal 2514 11 #folder 3142 2 #{UI.Scintilla.MarkerDefinition} 61 17 2624 98 #black 2352 #folder nil nil nil nil nil nil #folderEnd 3538 51 11 2624 3568 2352 #folderEnd nil nil nil nil nil nil #folderMidTail 3538 55 11 2624 3568 2352 #folderMidTail nil nil nil nil nil nil #folderOpen 3538 63 15 2624 3568 2352 #folderOpen nil nil nil nil nil nil #folderOpenMid 3538 53 11 2624 3568 2352 #folderOpenMid nil nil nil nil nil nil #folderSub 3538 59 11 2624 3568 2352 #folderSub nil nil nil nil nil nil #folderTail 3538 57 11 2624 3568 2352 #folderTail nil nil nil nil nil nil #historyModified 3538 47 67 2674 66047 112 2352 #historyModified nil nil nil nil nil nil #historyRevertedToModified 3538 49 67 2674 98625 3728 2352 #historyRevertedToModified nil nil nil nil nil nil #historyRevertedToOrigin 3538 43 67 2674 25116801 3760 2352 #historyRevertedToOrigin nil nil nil nil nil nil #historySaved 3538 45 67 2674 81921 3792 2352 #historySaved nil nil nil nil nil nil 294 #{Core.IdentitySet} 0 nil 550 #{Core.LookupTable} 0 123903 nil nil 3842 4 23 518 #{Graphics.ColorAlpha} 98 #highlight 121 81 98 #windowText 121 98 #silver 161 3890 3936 257 nil 50 1 1030 #{UI.Scintilla.CharacterRepresentation} 8 $\x2028 nil 33 3890 3936 257 262 #{UI.Scintilla.NullScintillaLibrary} nil 65 nil nil nil nil 5 2514 2 #container 2514 30 #attribute 2560 #callTip 2592 #CDATA 2640 #comment 2704 #doubleString 2736 #entity 2768 #identifierEnd 2800 #identifierStart 2816 #indentGuide 2832 #lineNumber 2848 #normal 2864 #number 2880 #otherInsideTag 2912 #question 2928 #sgmlBlock 2944 #sgmlCommand 2992 #sgmlComment 3040 #sgmlDoubleString 3072 #sgmlEntity 3104 #sgmlError 3152 #sgmlFirstParam 3184 #sgmlSingleString 3232 #sgmlSpecial 3280 #sgmlTag 3328 #singleString 3360 #styleTagEnd 3392 #tag 3408 #unknownAttribute 3424 #unknownTag 3440 #unquotedValue 3456 #xml 2528 nil nil #plusMinus 33 #{Core.Utf8String} nil 2514 3 8 'indicator0' 3142 5 #{UI.Scintilla.IndicatorDefinition} 1 2352 98 #commonGreen 3 1 nil nil nil nil nil nil nil 8 'indicator1' 4162 3 2352 98 #blue 5 1 nil nil nil nil nil nil nil 8 'indicator2' 4162 5 2352 98 #red 1 1 nil nil nil nil nil nil nil nil nil 2514 3 #Error 2546 1031 98 #firebrick 98 #floralWhite 1 nil nil nil nil #Error nil nil nil #Notification 2546 1029 nil 98 #gainsboro 1 nil nil nil nil #Notification nil nil nil #Warning 2546 1027 98 #darkGoldenrod 98 #ivory 1 nil nil nil nil #Warning nil nil nil nil nil nil 290 50 8 338 #createWindow: 50 1 386 418 8 #[0 0 0 0 25 0 0 0 160 4 0 0 233 2 0 0] 193 2384 nil 2352 338 #wordWrap: 8 #(true) 2352 338 #margins: 50 1 50 3 2118 3 #{UI.Scintilla.Margin} 1 2352 nil 3 nil nil nil nil 4642 3 2352 nil nil nil 67108863 nil nil 4642 5 2352 33 nil 3 8 4261412864 nil nil 2352 338 #sciSetHScrollBar: 8 #(false) 2352 338 #tabWidth: 8 #(4) 2352 338 #maxCompletionListHeight: 8 #(9) 2352 338 #setLexerLanguage: 8 #(#xml) 2352 338 #sciSetSelectionLayer: 8 #(1) 2352 3 8 #() 738 193 193 nil 45 1282 2512 50 6 2352 8 'document' 1792 8 'statusbar' 160 8 'toolbar' nil 2886 4 #{UI.MenuBar} nil true 50 4 2886 4 #{UI.Menu} nil true 50 6 1094 2 #{UI.CommandMenuItem} 1 1362 #fileNew 8 '&New' 9373 1 nil nil nil 5090 1 1362 #fileOpen 8 '&Open…' 9375 1 nil nil nil 5090 1 1362 #fileSave 8 '&Save' 9383 1 nil nil nil 5090 1 1362 #fileSaveAs 8 'Save &As…' 1 1 nil nil nil 326 1 #{UI.DividerMenuItem} 4097 5090 1 1362 #exit 8 'E&xit' 1025 1 nil nil nil 8 '&File' nil 1 nil nil nil nil nil 5042 nil true 50 15 5090 1 1362 #undo 8 '&Undo' 9397 1 nil nil nil 5090 1 1362 #redo 8 '&Redo' 9395 1 nil nil nil 5298 4097 5090 1 1362 #cutSelection 8 'Cu&t' 9393 1 nil nil nil 5090 1 1362 #copySelection 8 '&Copy' 9351 1 nil nil nil 5090 1 1362 #pasteClipboard 8 '&Paste' 9389 1 nil nil nil 5090 1 1362 #clearSelection 8 'Cle&ar' 1025 1 nil nil nil 5090 1 1362 #selectAll 8 'Select All' 9347 1 nil nil nil 5298 4097 5090 1 1362 #reformatXml 8 'Refor&mat' 1 1 nil nil nil 5090 1 1362 #validateXml 8 '&Validate' 1 1 nil nil nil 5298 4097 5090 1 1362 #find 8 '&Find…' 9357 1 nil nil nil 5090 1 1362 #findNext 8 'Find &Next' 1253 1 nil nil nil 5090 1 1362 #findReplace 8 'R&eplace…' 9361 1 nil nil nil 8 '&Edit' nil 1 nil nil nil nil nil 5042 nil true 50 7 5090 1 1362 #viewToolbar 8 '&Toolbar' 1025 1 nil nil nil 5090 1 1362 #viewStatusBar 8 '&Status Bar' 1025 1 nil nil nil 5298 4097 5090 1 1362 #foldAll 8 '&Fold All' 1 1 nil nil nil 5090 1 1362 #unfoldAll 8 '&Unfold All' 1 1 nil nil nil 5298 4097 5042 nil true 50 12 5090 1 1362 #editStyles 8 'Text &Styles' 1 1 nil nil nil 5298 4097 5090 1 1362 #toggleChangeHistory 8 '&Change History' 1 1 nil nil nil 5090 1 1362 #toggleIndentationGuides 8 '&Indentation Guides' 1 1 nil nil nil 5090 1 1362 #toggleLineEndings 8 '&Line Endings' 1 1 nil nil nil 5090 1 1362 #toggleLineNumbers 8 'Line &Numbers' 1 1 nil nil nil 5090 1 1362 #toggleXmlStyling 8 'St&yling' 1 1 nil nil nil 5090 1 1362 #optionsTabWidth 8 '&Tab Width...' 1 1 nil nil nil 5090 1 1362 #toggleWhitespace 8 'Whites&pace' 1 1 nil nil nil 5090 1 1362 #toggleWordWrap 8 '&Word wrap' 1 1 nil nil nil 5298 4097 5090 1 1362 #toggleRememberPlacement 8 '&Remember Placement' 1 1 nil nil nil 8 '&Options' nil 134217729 nil nil nil nil nil 8 '&View' nil 1 nil nil nil nil nil 5042 nil true 50 3 5090 1 1362 #help 8 '&Help Topics' 1025 1 nil nil nil 5298 4097 5090 1 1362 #about 8 '&About' 1 1 nil nil nil 8 '&Help' nil 1 nil nil nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil 193 290 50 1 338 #createWindow: 50 1 386 418 8 #[255 11 0 0 10 0 0 0 175 16 0 0 68 3 0 0] 193 80 8 '' 32 1 50 3 160 2352 1792 738 193 193 nil 27)!

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

