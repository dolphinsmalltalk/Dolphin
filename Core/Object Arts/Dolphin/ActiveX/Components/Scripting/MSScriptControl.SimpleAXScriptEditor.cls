"Filed out from Dolphin Smalltalk 7"!

UI.Dialog subclass: #'MSScriptControl.SimpleAXScriptEditor'
	instanceVariableNames: 'scriptControl languagePresenter scriptPresenter expressionPresenter resultPresenter filename descriptionPresenter'
	classVariableNames: ''
	imports: #(#{UI})
	classInstanceVariableNames: ''
	classConstants: {}!
MSScriptControl.SimpleAXScriptEditor guid: (Core.GUID fromString: '{46f9c2fb-d025-11d3-93da-00a024ca708a}')!
MSScriptControl.SimpleAXScriptEditor comment: 'Simple editor for creating ActiveXScriptlets.'!
!MSScriptControl.SimpleAXScriptEditor categoriesForClass!Unclassified! !
!MSScriptControl.SimpleAXScriptEditor methodsFor!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.

	languagePresenter := self add: ChoicePresenter new name: 'Language'.
	languagePresenter choices: (ListModel on: self languages searchPolicy: SearchPolicy caseInsensitive).
	scriptPresenter := self add: TextPresenter new name: 'ScriptText'.
	expressionPresenter := self add: TextPresenter new name: 'Expression'.
	resultPresenter := self add: TextPresenter new name: 'Result'.
	descriptionPresenter := self add: TextPresenter new name: 'description'
!

createSchematicWiring
	"Create the trigger wiring for the receiver"
	
	super createSchematicWiring.
	languagePresenter when: #selectionChanged send: #onLanguageChanged to: self!

defaultFileExtension
	"Answer a default extension that will be used for files saved from
	instances the receiver"

	^(File splitExtensionFrom: self scriptFileTypes first last)!

defaultLanguage
	"Answer the <readableString> name of the default scripting language used in the receiver."

	^self languages first
!

displayScriptError: anIScriptError 
	"Private - Report a script code parsing or runtime error to the user."

	MessageBox errorMsg: anIScriptError description
		caption: ('<1s> Error <2d> on line <3d>' 
				expandMacrosWith: self language
				with: anIScriptError number
				with: anIScriptError line)!

expressionText
	"Answer the expression text from the receiver's editing window."

	^expressionPresenter model value!

fileNew
	"Create a new script"

	self newScript!

fileOpen
	"Open an existing script from a file and load it into the procedures pane."

	| path dialog |
	dialog:= FileOpenDialog new
		caption: 'Load Script...';
		fileTypes: self scriptFileTypes;
		defaultExtension: self defaultFileExtension.
	filename notNil ifTrue: [dialog value: filename].
	path := dialog showModal.
	path notNil ifTrue: [
		self scriptText: (FileStream read: path) contents.
		filename := path]!

fileSave
	"Save the current script to a file."

	filename notNil
		ifTrue: [self saveScriptToFile]
		ifFalse: [self fileSaveAs]!

fileSaveAs
	"Associated the receiver with a file and saves it.
	Answers whether the file was actually saved."

	| newFilename dialog |
	dialog := (FileSaveDialog on: filename asValue)
		fileTypes: self scriptFileTypes;
		caption: 'Save Script As'.
	filename notNil ifTrue: [dialog value: filename].
	newFilename := dialog showModal.
	newFilename notNil ifTrue: [ "Install the new filename"
		filename := newFilename.
		self saveScriptToFile].
	!

helpAboutScriptControl
	"Pop the script controls About Box (useful for checking version, etc)."

	scriptControl _aboutBox!

initialize
	"Private - Initialize the receiver"

	super initialize.
	scriptControl := MSScriptControl.IScriptControl new!

language
	"Answer the language specified for the script text in the receiver's editing window."

	^languagePresenter value!

language: aString
	"Set the language used to interpret the script text in the receiver's editing window."

	languagePresenter value: aString!

languages
	"Answer the list of scripting language names supported by the receiver."

	^#('VBScript' 'JScript')
!

model: anActiveXScriptlet
	"Set the model associated with the receiver."

	| aspectBuffer |
	super model: anActiveXScriptlet.

	aspectBuffer := self model.

	languagePresenter model: (aspectBuffer aspectValue: #language).
	expressionPresenter model: (aspectBuffer aspectValue: #expression).
	scriptPresenter model: (aspectBuffer aspectValue: #procedures).
	descriptionPresenter model: (aspectBuffer aspectValue: #description)!

newScript
	"Private - Reset the receiver ready for the entry of a new script."

	self language: self defaultLanguage.
	self scriptText: ''!

onLanguageChanged
	"Private - The language (script engine name) has been changed. Inform the script host accordingly."

	scriptControl language: self language!

onViewOpened
	"Received when the receiver's view has been connected. 
	Set the script controls host site window handle."

	super onViewOpened.
	scriptControl sitehWnd: self view asParameter.
	self onLanguageChanged!

saveScriptToFile
	"Private - Save the script to the current filename."

	(FileStream write: filename)
		nextPutAll: self scriptText; close!

scriptFileTypes
	"Answer an Array of file types that can be associated with
	instances of the receiver"

	^{#('VB Script (*.vbs)' '*.vbs'). #('JScript (*.js)' '*.js'). FileDialog allFilesType}!

scriptParse
	"Parse the script text, reporting any errors.
	Answer whether the script compiled successfully."

	| success |
	scriptControl reset.
	[
		scriptControl addCode: self scriptText.
		success := true.
	] on: HRESULTError do: [:e | | error |
		error := scriptControl error.
		self displayScriptError: error.
		scriptPresenter view selectLine: error line.
		success := false].
	^success!

scriptRun
	"Evaluate the expression against the current script (with arguments from
	the comma separated list). Useful for testing and very basic debugging."

	| result |
	self scriptParse ifFalse: [^self].
	
	[self model value globalBindings 
		keysAndValuesDo: [:eachKey :eachValue | scriptControl addObject: eachKey object: (eachValue queryInterface: IDispatch)].
	result := scriptControl eval: self expressionText] 
			on: HRESULTError
			do: [:e | result := scriptControl error].
	resultPresenter value: result displayString!

scriptText
	"Answer the script text from the receiver's editing window."

	^scriptPresenter model value!

scriptText: aString
	"Set the script text in the receiver's editing window."

	scriptPresenter model value: aString! !
!MSScriptControl.SimpleAXScriptEditor categoriesFor: #createComponents!initializing!public! !
!MSScriptControl.SimpleAXScriptEditor categoriesFor: #createSchematicWiring!initializing!public! !
!MSScriptControl.SimpleAXScriptEditor categoriesFor: #defaultFileExtension!constants!public! !
!MSScriptControl.SimpleAXScriptEditor categoriesFor: #defaultLanguage!initializing!public! !
!MSScriptControl.SimpleAXScriptEditor categoriesFor: #displayScriptError:!commands!private! !
!MSScriptControl.SimpleAXScriptEditor categoriesFor: #expressionText!accessing!public! !
!MSScriptControl.SimpleAXScriptEditor categoriesFor: #fileNew!commands!public! !
!MSScriptControl.SimpleAXScriptEditor categoriesFor: #fileOpen!commands!public! !
!MSScriptControl.SimpleAXScriptEditor categoriesFor: #fileSave!commands!public! !
!MSScriptControl.SimpleAXScriptEditor categoriesFor: #fileSaveAs!commands!public! !
!MSScriptControl.SimpleAXScriptEditor categoriesFor: #helpAboutScriptControl!commands!public! !
!MSScriptControl.SimpleAXScriptEditor categoriesFor: #initialize!initializing!private! !
!MSScriptControl.SimpleAXScriptEditor categoriesFor: #language!accessing!public! !
!MSScriptControl.SimpleAXScriptEditor categoriesFor: #language:!accessing!public! !
!MSScriptControl.SimpleAXScriptEditor categoriesFor: #languages!initializing!public! !
!MSScriptControl.SimpleAXScriptEditor categoriesFor: #model:!accessing!public! !
!MSScriptControl.SimpleAXScriptEditor categoriesFor: #newScript!commands!private! !
!MSScriptControl.SimpleAXScriptEditor categoriesFor: #onLanguageChanged!event handling!private! !
!MSScriptControl.SimpleAXScriptEditor categoriesFor: #onViewOpened!event handling!public! !
!MSScriptControl.SimpleAXScriptEditor categoriesFor: #saveScriptToFile!commands!private! !
!MSScriptControl.SimpleAXScriptEditor categoriesFor: #scriptFileTypes!constants!public! !
!MSScriptControl.SimpleAXScriptEditor categoriesFor: #scriptParse!commands!public! !
!MSScriptControl.SimpleAXScriptEditor categoriesFor: #scriptRun!commands!public! !
!MSScriptControl.SimpleAXScriptEditor categoriesFor: #scriptText!accessing!public! !
!MSScriptControl.SimpleAXScriptEditor categoriesFor: #scriptText:!accessing!public! !

!MSScriptControl.SimpleAXScriptEditor class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized."

	^MSScriptControl.ActiveXScriptlet new!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.DialogView) 34 30 nil nil 8 #(13369344 65536) 416 nil 1245702 ##(Graphics.ThemeColor) #dialog nil 167 nil 852998 ##(Graphics.Font) nil true 655622 ##(OS.LOGFONT) 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 1 2 1 34 77 83 32 83 97 110 115 32 83 101 114 105 102 0 110 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 918022 ##(Graphics.Point) 193 193 nil 416 984838 ##(UI.BorderLayout) 1 1 410 ##(UI.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 640 nil nil nil 7 nil nil nil 640 1048838 ##(UI.FramingLayout) 170 176 34 4 410 ##(UI.GroupBox) 34 14 nil 640 34 2 8 1140850695 65 768 nil nil nil 7 nil nil nil 768 nil 8 1840275408 1310982 ##(Core.MessageSequence) 138 144 34 2 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 578 11 11 578 895 101 768 914 #text: 34 1 8 'Description' 768 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 196 1 0 0 55 0 0 0] 8 #() 578 193 193 nil 27 1378374 2 ##(UI.FramingConstraints) 1377286 ##(UI.FramingCalculation) #fixedParentLeft 1 1154 #fixedParentRight -3 1154 #fixedParentTop 1 1154 #fixedParentBottom 1 410 ##(UI.TextEdit) 34 16 nil 640 34 2 8 1140916352 1025 1232 nil 917510 ##(Graphics.Color) #default nil 7 nil nil nil 1232 nil 8 1840267216 1049094 ##(UI.NullConverter) nil nil 9 850 138 144 34 1 914 #createAt:extent: 34 2 578 31 49 578 855 39 1232 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 24 0 0 0 186 1 0 0 43 0 0 0] 8 #() 1104 nil 27 1122 1168 21 1184 -23 1200 39 1216 -23 170 192 34 2 1232 8 'description' 1180166 ##(Graphics.Rectangle) 578 11 11 578 11 11 850 138 144 34 1 914 #createAt:extent: 34 2 578 1 1 578 919 121 640 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 203 1 0 0 60 0 0 0] 34 2 1232 768 1104 nil 27 410 ##(UI.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 1824 nil nil nil 7 nil nil nil 1824 706 170 176 34 8 410 ##(UI.PushButton) 34 20 nil 1824 34 2 8 1140924416 1 1936 nil 1312 nil 7 nil nil nil 1936 nil 8 1840275408 1377606 4 ##(UI.CommandDescription) #scriptParse 8 '&Parse' 1 1 nil nil false nil nil nil 850 138 144 34 3 914 #createAt:extent: 34 2 578 351 11 578 141 47 1936 914 #isEnabled: 8 #(false) 1936 914 #text: 34 1 8 '&Parse' 1936 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 175 0 0 0 5 0 0 0 245 0 0 0 28 0 0 0] 8 #() 1104 nil 29 1122 1154 #fixedPreviousRight 31 1154 #fixedViewLeft 141 1154 #fixedPreviousTop -1 1154 #fixedViewTop 47 410 ##(UI.ReferenceView) 34 14 nil 1824 34 2 8 1140850688 131073 2384 nil nil nil 7 nil nil nil 2384 1376838 1 ##(UI.ResourceIdentifier) ##(UI.Presenter) #resource_OK_Cancel_button_block nil 850 138 144 34 1 914 #createAt:extent: 34 2 578 571 -3 578 335 71 2384 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 29 1 0 0 254 255 255 255 196 1 0 0 33 0 0 0] 8 #() 1104 nil 27 1122 1154 #fixedViewRight -333 1184 -13 1154 #fixedViewBottom -69 1216 -13 410 ##(UI.ComboBox) 34 17 nil 1824 34 2 8 1144063490 1025 2688 787270 2 ##(UI.ListModel) 138 144 2624 nil 1769478 ##(Kernel.IdentitySearchPolicy) 1312 nil 7 nil nil nil 2688 nil 8 1840066592 ##(UI.BasicListAbstract) 8 #() 201 850 138 144 34 1 914 #createAt:extent: 34 2 578 141 13 578 181 43 2688 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 70 0 0 0 6 0 0 0 160 0 0 0 27 0 0 0] 8 #() 1104 nil 27 1122 2320 11 2336 181 2352 -3 2368 43 410 ##(UI.StaticText) 34 16 nil 1824 34 2 8 1140850946 1 3040 nil nil nil 7 nil nil nil 3040 nil 8 1840123616 1346 nil nil nil 850 138 144 34 2 914 #createAt:extent: 34 2 578 21 17 578 111 45 3040 914 #text: 34 1 8 'Language:' 3040 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 8 0 0 0 65 0 0 0 30 0 0 0] 8 #() 1104 nil 27 1122 1168 21 2336 111 2672 -43 1216 -19 170 192 34 2 2688 8 'Language' nil 850 138 144 34 1 914 #createAt:extent: 34 2 578 1 803 578 919 81 1824 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 145 1 0 0 203 1 0 0 185 1 0 0] 34 4 3040 2688 1936 2384 1104 nil 27 nil nil 410 ##(UI.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 3568 nil nil nil 7 nil nil nil 3568 1376774 ##(UI.ProportionalLayout) 170 176 34 4 410 ##(UI.ContainerView) 34 15 nil 3568 34 2 8 1140850688 131073 3696 nil nil nil 7 nil nil nil 3696 706 170 176 34 10 410 ##(UI.MultilineTextEdit) 34 16 nil 3696 34 2 8 1143017540 1025 3808 nil 1312 nil 7 nil nil nil 3808 nil 8 1840267216 1346 nil nil 9 850 138 144 34 1 914 #createAt:extent: 34 2 578 171 41 578 715 79 3808 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 85 0 0 0 20 0 0 0 186 1 0 0 59 0 0 0] 8 #() 1104 nil 27 1122 1168 161 1184 -23 1200 31 1216 -79 410 ##(UI.GroupBox) 34 14 nil 3696 34 2 8 1140850695 65 4080 nil nil nil 7 nil nil nil 4080 nil 8 1840275408 850 138 144 34 2 914 #createAt:extent: 34 2 578 11 11 578 895 199 4080 914 #text: 34 1 8 'Expression' 4080 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 196 1 0 0 104 0 0 0] 8 #() 1104 nil 27 1122 1168 1 1184 -3 1200 1 1216 11 410 ##(UI.StaticText) 34 16 nil 3696 34 2 8 1140850946 1 4384 nil nil nil 7 nil nil nil 4384 nil 8 1840123616 1346 nil nil nil 850 138 144 34 2 914 #createAt:extent: 34 2 578 51 151 578 101 41 4384 914 #text: 34 1 8 'Result:' 4384 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 25 0 0 0 75 0 0 0 75 0 0 0 95 0 0 0] 8 #() 1104 nil 27 1122 1168 41 2336 101 2672 -39 1216 -7 410 ##(UI.TextEdit) 34 16 nil 3696 34 2 8 1140916352 1025 4704 nil 1298 #white nil 7 nil nil nil 4704 nil 8 1840267216 1346 nil nil 1 850 138 144 34 2 914 #createAt:extent: 34 2 578 171 143 578 715 43 4704 914 #isEnabled: 8 #(false) 4704 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 85 0 0 0 71 0 0 0 186 1 0 0 92 0 0 0] 8 #() 1104 nil 27 1122 1168 161 1184 -23 2672 -41 1216 -13 410 ##(UI.PushButton) 34 20 nil 3696 34 2 8 1140924416 1 5024 nil 1312 nil 7 nil nil nil 5024 nil 8 1840275408 2018 #scriptRun 8 '&Test' 1 1 nil nil false nil nil nil 850 138 144 34 3 914 #createAt:extent: 34 2 578 31 51 578 131 51 5024 914 #isEnabled: 8 #(false) 5024 914 #text: 34 1 8 '&Test' 5024 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 25 0 0 0 80 0 0 0 50 0 0 0] 8 #() 1104 nil 29 1122 1168 21 2336 131 1200 41 2368 51 170 192 34 4 4704 8 'Result' 3808 8 'Expression' 1602 578 11 11 578 11 11 850 138 144 34 1 914 #createAt:extent: 34 2 578 1 1 578 919 209 3696 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 203 1 0 0 104 0 0 0] 34 5 3808 5024 4384 4704 4080 1104 nil 27 655414 ##(Core.Float) 8 154 153 153 153 153 153 241 63 410 ##(UI.ContainerView) 34 15 nil 3568 34 2 8 1140850688 131073 5696 nil nil nil 7 nil nil nil 5696 706 170 176 34 4 410 ##(UI.ContainerView) 34 15 nil 5696 34 2 8 1140850688 131073 5808 nil nil nil 7 nil nil nil 5808 610 11 11 nil nil nil nil 410 ##(UI.Scintilla.ScintillaView) 34 50 nil 5808 34 2 8 1174475012 1025 5888 918598 2 ##(UI.ValueHolder) nil false 1769478 ##(Kernel.EqualitySearchPolicy) nil 1312 nil 7 nil nil nil 5888 nil 8 2058764186 1346 nil nil 9 1524184769 170 192 34 10 #callTip 1444934 1 ##(UI.Scintilla.TextStyle) 77 1298 #gray 4768 1 nil nil nil nil #callTip nil nil nil #lineNumber 6082 67 nil nil 1 nil nil nil nil #lineNumber nil nil nil #indentGuide 6082 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil #normal 6082 1 nil nil 1 nil nil nil nil #normal nil nil nil #whitespace 6082 3 nil nil 1 nil nil nil nil #whitespace nil nil nil nil 1507654 1 ##(UI.Scintilla.NullStyler) #normal 170 192 34 2 #default 1903686 2 ##(UI.Scintilla.MarkerDefinition) 1 nil nil nil 5888 #circle nil nil nil nil nil nil 138 ##(Core.IdentitySet) 2624 nil 170 176 2624 9215 nil nil nil nil 1298 #silver nil nil 65 nil nil nil 8 '' 3 170 192 34 2 #container 6048 nil nil nil nil 16 nil 170 192 34 6 8 'indicator2' 1772614 3 ##(UI.Scintilla.IndicatorStyle) 5 5888 1298 #red 1 nil nil nil nil nil nil nil nil 8 'indicator0' 6434 1 5888 1298 #commonGreen 3 nil nil nil nil nil nil nil nil 8 'indicator1' 6434 3 5888 1298 #blue 5 nil nil nil nil nil nil nil nil nil nil 170 192 34 6 #Warning 6082 1027 1298 #darkGoldenrod 1298 #ivory 1 nil nil nil nil #Warning nil nil nil #Error 6082 1031 1298 #firebrick 1298 #floralWhite 1 nil nil nil nil #Error nil nil nil #Notification 6082 1029 nil 1298 #gainsboro 1 nil nil nil nil #Notification nil nil nil nil 850 138 144 34 9 914 #createAt:extent: 34 2 578 11 11 578 855 399 5888 914 #text: 34 1 8 'function Do(x)
	Do = "Do " + x
end function' 5888 914 #caretPeriod: 8 #(530) 5888 914 #wordWrap: 8 #(true) 5888 914 #margins: 34 1 34 3 1247302 3 ##(UI.Scintilla.Margin) 1 5888 1 3 nil nil nil nil 7010 3 5888 33 nil nil 67108863 nil nil 7010 5 5888 1 nil nil nil nil nil 5888 914 #canHScroll: 8 #(false) 5888 914 #targetRange: 34 1 852742 ##(Core.Interval) 3 91 3 5888 914 #maxCompletionListHeight: 8 #(9) 5888 914 #edgeColumn: 8 #(1) 5888 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 176 1 0 0 204 0 0 0] 8 #() 1104 nil 31 170 192 34 2 5888 8 'ScriptText' 1602 578 11 11 578 11 11 850 138 144 34 1 914 #createAt:extent: 34 2 578 21 41 578 875 419 5808 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 20 0 0 0 191 1 0 0 229 0 0 0] 34 1 5888 1104 nil 27 1122 1168 11 1184 -13 1200 31 1216 -15 410 ##(UI.GroupBox) 34 14 nil 5696 34 2 8 1140850695 65 7552 nil nil nil 7 nil nil nil 7552 nil 8 1840275408 850 138 144 34 2 914 #createAt:extent: 34 2 578 11 11 578 895 459 7552 914 #text: 34 1 8 'Procedures' 7552 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 196 1 0 0 234 0 0 0] 8 #() 1104 nil 27 1122 1168 1 1184 -3 1200 1 1216 -5 170 192 2624 1602 578 11 11 578 11 1 850 138 144 34 1 914 #createAt:extent: 34 2 578 1 209 578 919 475 5696 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 104 0 0 0 203 1 0 0 85 1 0 0] 34 2 7552 5808 1104 nil 27 5666 8 0 0 0 0 0 0 4 64 true 170 192 2624 nil 850 138 144 34 1 914 #createAt:extent: 34 2 578 1 121 578 919 683 3568 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 60 0 0 0 203 1 0 0 145 1 0 0] 34 2 3696 5696 1104 nil 27 170 192 2624 nil 658246 4 ##(UI.MenuBar) nil true 34 4 461638 4 ##(UI.Menu) nil true 34 3 1180742 2 ##(UI.CommandMenuItem) 1 2018 #fileOpen 8 '&Open...' 9375 1 nil nil nil 8386 1 2018 #fileSave 8 '&Save' 9383 1 nil nil nil 8386 1 2018 #fileSaveAs 8 'Save &As...' 1 1 nil nil nil 8 '&File' nil 1 nil nil 43999 nil nil 8338 nil true 34 11 8386 1 2018 #undo 8 '&Undo' 9397 1 nil nil nil 1179974 1 ##(UI.DividerMenuItem) 4097 8386 1 2018 #cutSelection 8 'Cu&t' 9393 1 nil nil nil 8386 1 2018 #copySelection 8 '&Copy' 9351 1 nil nil nil 8386 1 2018 #pasteClipboard 8 '&Paste' 9389 1 nil nil nil 8386 1 2018 #clearSelection 8 '&Delete' 1 1 nil nil nil 8386 1 2018 #selectAll 8 'Select &All' 9347 1 nil nil nil 8656 8386 1 2018 #find 8 '&Find...' 9357 1 853318 3 ##(Graphics.Icon) nil true 2031622 ##(Kernel.ImageRelativeFileLocator) 47 983302 ##(OS.ShellLibrary) nil nil 8386 1 2018 #findNext 8 'Find &Next' 1253 1 nil nil nil 8386 1 2018 #findReplace 8 '&Replace...' 9361 1 nil nil nil 8 '&Edit' nil 1 nil nil 44019 nil nil 8338 nil true 34 2 8386 1 2018 #scriptParse 8 '&Parse' 1 1 nil nil nil 8386 1 2018 #scriptRun 8 '&Test' 1 1 nil nil nil 8 '&Script' nil 1 nil nil 44025 nil nil 8338 nil true 34 1 8386 1 2018 #helpAboutScriptControl 8 '&About Script Control...' 1 1 nil nil nil 8 '&Help' nil 1 nil nil 44029 nil nil 8 '' nil 1 nil nil nil nil nil nil nil nil 21959 nil nil nil 578 851 901 1 nil nil 918278 ##(Core.Semaphore) nil nil 1 nil 8 2002544400 850 138 144 34 2 914 #createAt:extent: 34 2 578 6143 21 578 951 1001 416 914 #text: 34 1 8 'Active-X Script Editor' 416 1042 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 218 13 0 0 254 1 0 0] 34 3 640 3568 1824 1104 nil 27 )! !
!MSScriptControl.SimpleAXScriptEditor class categoriesFor: #defaultModel!constants!public! !
!MSScriptControl.SimpleAXScriptEditor class categoriesFor: #resource_Default_view!public!resources-views! !

