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
		ifTrue: [(settings at: 'Placement' ifAbsent: nil) ifNotNil: [:placement | 
			"We saved the placement extent scaled to 96 dpi. We then need to scale to the DPI of the current monitor of the view, rather than the DPI of the monitor to which we will actually restore"
			placement extent: placement extent *  view dpi // USER_DEFAULT_SCREEN_DPI. 
			view placement: placement]].
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
			"Store extent at a known logical DPI"
			placement extent: placement extent *  USER_DEFAULT_SCREEN_DPI // view dpi.
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

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.ShellView} 38 #{Core.Array} 27 nil nil 8 #(13565952 65536) 32 nil 6 #{Graphics.Color} #face3d nil 517 nil nil nil 32 1798 #{UI.BorderLayout} 1 1 18 #{UI.Toolbar} 50 28 nil 32 50 2 8 1409289036 131073 160 nil 98 #default nil 517 nil nil nil 160 nil nil nil nil nil nil nil 8 #() nil nil 9 763 #smallIcons nil nil 838 1 #{UI.FlowLayout} 1 1 1 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 582 1 #{OS.RECTL} 8 #[0 0 0 0 0 0 0 0 160 4 0 0 25 0 0 0] nil 193 192 8 '' 160 3 50 4 18 #{UI.ReferenceView} 50 14 nil 160 50 2 8 1140850688 131073 496 nil nil nil 5 nil nil nil 496 582 1 #{UI.ResourceIdentifier} #{UI.Toolbar} #resource_Fluent_File_tools nil 290 50 1 338 #createWindow: 50 1 386 418 8 #[0 0 0 0 0 0 0 0 89 0 0 0 25 0 0 0] nil 193 528 8 '' 496 3 8 #() 518 #{Graphics.Point} 193 193 nil 27 18 #{UI.ReferenceView} 50 14 nil 160 50 2 8 1140850688 131073 768 nil nil nil 5 nil nil nil 768 562 #{UI.Toolbar} #resource_Fluent_Edit_tools nil 290 50 1 338 #createWindow: 50 1 386 418 8 #[89 0 0 0 0 0 0 0 228 0 0 0 25 0 0 0] nil 193 800 8 '' 768 3 720 738 193 193 nil 27 18 #{UI.ReferenceView} 50 14 nil 160 50 2 8 1140850688 131073 992 nil nil nil 5 nil nil nil 992 562 #{UI.Toolbar} #resource_Fluent_Find_tools nil 290 50 1 338 #createWindow: 50 1 386 418 8 #[228 0 0 0 0 0 0 0 36 1 0 0 25 0 0 0] nil 193 1024 8 '' 992 3 720 738 193 193 nil 27 18 #{UI.Toolbar} 50 28 nil 160 50 2 8 1409293132 131137 1216 nil nil nil 517 nil nil nil 1216 224 nil 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 720 nil nil nil nil 50 4 1862 2 #{UI.ToolbarTextButton} 1216 161 1350 4 #{UI.CommandDescription} #foldAll 8 '&Fold All' 1 1 nil nil nil nil 8 $\xF165 1330 1216 161 1362 #unfoldAll 8 '&Unfold All' 1 1 nil nil nil nil 8 $\xECCD 1330 1216 161 1362 #reformatXml 8 '&Reformat XML' 1 1 nil nil nil nil 8 $\xE736 582 1 #{UI.ToolbarSeparator} 1216 1 nil nil 13 5 nil nil nil nil 290 50 1 338 #createWindow: 50 1 386 418 8 #[36 1 0 0 0 0 0 0 125 1 0 0 25 0 0 0] nil 193 50 2 8 1409293132 131137 8 '' 1216 3 8 #() 738 193 193 nil 31 738 193 193 nil 31 18 #{UI.StatusBar} 50 21 nil 32 50 2 8 1140850948 1 1792 nil 224 nil 5 nil 1350 1 #{Graphics.Font} nil true 582 1 #{OS.LOGFONTW} 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 0 65 0 114 0 105 0 97 0 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] nil 193 nil nil 1792 nil nil 1282 #{Core.IdentityDictionary} 50 2 1862 1 #{UI.StatusBarItem} 8193 -1 1792 nil 518 #{Core.Message} #displayString 8 #() 2002 #iconImageIndex 8 #() nil 8 'status' nil nil nil 50 1 1984 1094 1 #{UI.StatusBarNullItem} 8705 1 1792 nil nil 290 50 1 338 #createWindow: 50 1 386 418 8 #[0 0 0 0 233 2 0 0 160 4 0 0 255 2 0 0] nil 193 1824 8 '' 1792 3 8 #() 738 193 193 nil 29 nil nil 18 #{UI.Scintilla.ScintillaView} 50 56 nil 32 50 2 8 1174475012 262145 2304 1094 2 #{UI.ValueHolder} nil false 6 #{Kernel.EqualitySearchPolicy} nil 224 nil 21 nil nil nil 2304 nil nil 518 #{UI.NullConverter} nil nil 9 #focusLost nil nil nil nil 550 #{Core.IdentityDictionary} 30 #attribute 3142 1 #{UI.Scintilla.TextStyle} 7 98 #teal nil 1 nil nil nil nil #attribute nil nil nil #callTip 2498 77 98 #gray 98 #white 1 nil nil nil nil #callTip nil nil nil #CDATA 2498 35 98 #maroon 326 1 #{Graphics.RGB} 31580671 129 nil nil nil nil #CDATA nil nil nil #comment 2498 19 98 #olive nil 1 nil nil nil nil #comment nil nil nil #doubleString 2498 13 2626 16646399 nil 1 nil nil nil nil #doubleString nil nil nil #entity 2498 21 98 #purple nil 1 nil nil nil nil #entity nil nil nil #identifierEnd 2498 25 2736 nil 3 nil nil nil nil #identifierEnd nil 1401 nil #identifierStart 2498 27 2736 nil 3 nil nil nil nil #identifierStart nil 1401 nil #indentGuide 2498 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil #lineNumber 2498 67 nil nil 1 nil nil nil nil #lineNumber nil nil nil #normal 2498 1 nil nil 1 nil nil nil nil #normal nil nil nil #number 2498 11 2626 16711169 nil 1 nil nil nil nil #number nil nil nil #otherInsideTag 2498 17 2736 nil 1 nil nil nil nil #otherInsideTag nil nil nil #question 2498 37 2608 nil 1 nil nil nil nil #question nil nil nil #sgmlBlock 2498 63 2626 13369345 2626 29464985 1 nil nil nil nil #sgmlBlock nil nil nil #sgmlCommand 2498 45 98 #navy 2626 33546207 3 nil nil nil nil #sgmlCommand nil 1401 nil #sgmlComment 2498 59 2672 2626 33546207 1 nil nil nil nil #sgmlComment nil nil nil #sgmlDoubleString 2498 49 2608 2626 33546207 1 nil nil nil nil #sgmlDoubleString nil nil nil #sgmlEntity 2498 57 2626 6710887 2626 33546207 1 nil nil nil nil #sgmlEntity nil nil nil #sgmlError 2498 53 2608 2626 13422079 1 nil nil nil nil #sgmlError nil nil nil #sgmlFirstParam 2498 47 2626 52225 2626 33546207 1 nil nil nil nil #sgmlFirstParam nil nil nil #sgmlSingleString 2498 51 2626 26419 2626 33546207 1 nil nil nil nil #sgmlSingleString nil nil nil #sgmlSpecial 2498 55 2626 33475687 2626 33546207 1 nil nil nil nil #sgmlSpecial nil nil nil #sgmlTag 2498 43 2960 2626 33546207 1 nil nil nil nil #sgmlTag nil nil nil #singleString 2498 15 2626 16646399 nil 1 nil nil nil nil #singleString nil nil nil #styleTagEnd 2498 23 2960 nil 1 nil nil nil nil #styleTagEnd nil nil nil #tag 2498 3 2960 nil 1 nil nil nil nil #tag nil nil nil #unknownAttribute 2498 9 2528 nil 1 nil nil nil nil #unknownAttribute nil nil nil #unknownTag 2498 5 2960 nil 1 nil nil nil nil #unknownTag nil nil nil #unquotedValue 2498 39 2626 12648641 nil 1 nil nil nil nil #unquotedValue nil nil nil nil 326 1 #{UI.Scintilla.NullStyler} #normal 2466 11 #folder 3142 2 #{UI.Scintilla.MarkerDefinition} 61 17 2576 98 #black 2304 #folder nil nil nil nil nil nil #folderEnd 3490 51 11 2576 3520 2304 #folderEnd nil nil nil nil nil nil #folderMidTail 3490 55 11 2576 3520 2304 #folderMidTail nil nil nil nil nil nil #folderOpen 3490 63 15 2576 3520 2304 #folderOpen nil nil nil nil nil nil #folderOpenMid 3490 53 11 2576 3520 2304 #folderOpenMid nil nil nil nil nil nil #folderSub 3490 59 11 2576 3520 2304 #folderSub nil nil nil nil nil nil #folderTail 3490 57 11 2576 3520 2304 #folderTail nil nil nil nil nil nil #historyModified 3490 47 67 2626 66047 112 2304 #historyModified nil nil nil nil nil nil #historyRevertedToModified 3490 49 67 2626 98625 3680 2304 #historyRevertedToModified nil nil nil nil nil nil #historyRevertedToOrigin 3490 43 67 2626 25116801 3712 2304 #historyRevertedToOrigin nil nil nil nil nil nil #historySaved 3490 45 67 2626 81921 3744 2304 #historySaved nil nil nil nil nil nil 294 #{Core.IdentitySet} 0 nil 550 #{Core.LookupTable} 0 123903 nil nil 3794 4 23 518 #{Graphics.ColorAlpha} 98 #highlight 121 81 98 #windowText 121 98 #silver 161 3842 3888 257 nil 50 1 1030 #{UI.Scintilla.CharacterRepresentation} 8 $\x2028 nil 33 3842 3888 257 262 #{UI.Scintilla.NullScintillaLibrary} nil 65 nil nil nil nil 5 2466 2 #container 2466 30 #attribute 2512 #callTip 2544 #CDATA 2592 #comment 2656 #doubleString 2688 #entity 2720 #identifierEnd 2752 #identifierStart 2768 #indentGuide 2784 #lineNumber 2800 #normal 2816 #number 2832 #otherInsideTag 2864 #question 2880 #sgmlBlock 2896 #sgmlCommand 2944 #sgmlComment 2992 #sgmlDoubleString 3024 #sgmlEntity 3056 #sgmlError 3104 #sgmlFirstParam 3136 #sgmlSingleString 3184 #sgmlSpecial 3232 #sgmlTag 3280 #singleString 3312 #styleTagEnd 3344 #tag 3360 #unknownAttribute 3376 #unknownTag 3392 #unquotedValue 3408 #xml 2480 nil nil #plusMinus 33 #{Core.Utf8String} nil 2466 3 8 'indicator0' 3142 5 #{UI.Scintilla.IndicatorDefinition} 1 2304 98 #commonGreen 3 1 nil nil nil nil nil nil nil 8 'indicator1' 4114 3 2304 98 #blue 5 1 nil nil nil nil nil nil nil 8 'indicator2' 4114 5 2304 98 #red 1 1 nil nil nil nil nil nil nil nil nil 2466 3 #Error 2498 1031 98 #firebrick 98 #floralWhite 1 nil nil nil nil #Error nil nil nil #Notification 2498 1029 nil 98 #gainsboro 1 nil nil nil nil #Notification nil nil nil #Warning 2498 1027 98 #darkGoldenrod 98 #ivory 1 nil nil nil nil #Warning nil nil nil nil nil nil 290 50 8 338 #createWindow: 50 1 386 418 8 #[0 0 0 0 25 0 0 0 160 4 0 0 233 2 0 0] nil 193 2336 nil 2304 338 #wordWrap: 8 #(true) 2304 338 #margins: 50 1 50 3 2118 3 #{UI.Scintilla.Margin} 1 2304 nil 3 nil nil nil nil 4594 3 2304 nil nil nil 67108863 nil nil 4594 5 2304 33 nil 3 8 4261412864 nil nil 2304 338 #sciSetHScrollBar: 8 #(false) 2304 338 #tabWidth: 8 #(4) 2304 338 #maxCompletionListHeight: 8 #(9) 2304 338 #setLexerLanguage: 8 #(#xml) 2304 338 #sciSetSelectionLayer: 8 #(1) 2304 3 8 #() 738 193 193 nil 45 1282 2464 50 6 2304 8 'document' 1792 8 'statusbar' 160 8 'toolbar' nil 2886 4 #{UI.MenuBar} nil true 50 4 2886 4 #{UI.Menu} nil true 50 6 1094 2 #{UI.CommandMenuItem} 1 1362 #fileNew 8 '&New' 9373 1 nil nil nil 5042 1 1362 #fileOpen 8 '&Open…' 9375 1 nil nil nil 5042 1 1362 #fileSave 8 '&Save' 9383 1 nil nil nil 5042 1 1362 #fileSaveAs 8 'Save &As…' 1 1 nil nil nil 326 1 #{UI.DividerMenuItem} 4097 5042 1 1362 #exit 8 'E&xit' 1025 1 nil nil nil 8 '&File' nil 1 nil nil nil nil nil 4994 nil true 50 15 5042 1 1362 #undo 8 '&Undo' 9397 1 nil nil nil 5042 1 1362 #redo 8 '&Redo' 9395 1 nil nil nil 5250 4097 5042 1 1362 #cutSelection 8 'Cu&t' 9393 1 nil nil nil 5042 1 1362 #copySelection 8 '&Copy' 9351 1 nil nil nil 5042 1 1362 #pasteClipboard 8 '&Paste' 9389 1 nil nil nil 5042 1 1362 #clearSelection 8 'Cle&ar' 1025 1 nil nil nil 5042 1 1362 #selectAll 8 'Select All' 9347 1 nil nil nil 5250 4097 5042 1 1362 #reformatXml 8 'Refor&mat' 1 1 nil nil nil 5042 1 1362 #validateXml 8 '&Validate' 1 1 nil nil nil 5250 4097 5042 1 1362 #find 8 '&Find…' 9357 1 nil nil nil 5042 1 1362 #findNext 8 'Find &Next' 1253 1 nil nil nil 5042 1 1362 #findReplace 8 'R&eplace…' 9361 1 nil nil nil 8 '&Edit' nil 1 nil nil nil nil nil 4994 nil true 50 7 5042 1 1362 #viewToolbar 8 '&Toolbar' 1025 1 nil nil nil 5042 1 1362 #viewStatusBar 8 '&Status Bar' 1025 1 nil nil nil 5250 4097 5042 1 1362 #foldAll 8 '&Fold All' 1 1 nil nil nil 5042 1 1362 #unfoldAll 8 '&Unfold All' 1 1 nil nil nil 5250 4097 4994 nil true 50 12 5042 1 1362 #editStyles 8 'Text &Styles' 1 1 nil nil nil 5250 4097 5042 1 1362 #toggleChangeHistory 8 '&Change History' 1 1 nil nil nil 5042 1 1362 #toggleIndentationGuides 8 '&Indentation Guides' 1 1 nil nil nil 5042 1 1362 #toggleLineEndings 8 '&Line Endings' 1 1 nil nil nil 5042 1 1362 #toggleLineNumbers 8 'Line &Numbers' 1 1 nil nil nil 5042 1 1362 #toggleXmlStyling 8 'St&yling' 1 1 nil nil nil 5042 1 1362 #optionsTabWidth 8 '&Tab Width...' 1 1 nil nil nil 5042 1 1362 #toggleWhitespace 8 'Whites&pace' 1 1 nil nil nil 5042 1 1362 #toggleWordWrap 8 '&Word wrap' 1 1 nil nil nil 5250 4097 5042 1 1362 #toggleRememberPlacement 8 '&Remember Placement' 1 1 nil nil nil 8 '&Options' nil 134217729 nil nil nil nil nil 8 '&View' nil 1 nil nil nil nil nil 4994 nil true 50 3 5042 1 1362 #help 8 '&Help Topics' 1025 1 nil nil nil 5250 4097 5042 1 1362 #about 8 '&About' 1 1 nil nil nil 8 '&Help' nil 1 nil nil nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil nil nil 193 290 50 1 338 #createWindow: 50 1 386 518 #{Graphics.Rectangle} 738 1 1 738 2401 1653 193 80 8 '' 32 1 50 3 160 2304 1792 738 193 193 nil 27)!

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

