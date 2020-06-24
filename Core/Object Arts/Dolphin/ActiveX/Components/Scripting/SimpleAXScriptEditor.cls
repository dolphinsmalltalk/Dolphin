"Filed out from Dolphin Smalltalk 7"!

Dialog subclass: #SimpleAXScriptEditor
	instanceVariableNames: 'scriptControl languagePresenter scriptPresenter expressionPresenter resultPresenter filename descriptionPresenter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SimpleAXScriptEditor guid: (GUID fromString: '{46f9c2fb-d025-11d3-93da-00a024ca708a}')!
SimpleAXScriptEditor comment: 'Simple editor for creating ActiveXScriptlets.'!
!SimpleAXScriptEditor categoriesForClass!Unclassified! !
!SimpleAXScriptEditor methodsFor!

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
	scriptControl := IScriptControl new
!

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
!SimpleAXScriptEditor categoriesFor: #createComponents!initializing!public! !
!SimpleAXScriptEditor categoriesFor: #createSchematicWiring!initializing!public! !
!SimpleAXScriptEditor categoriesFor: #defaultFileExtension!constants!public! !
!SimpleAXScriptEditor categoriesFor: #defaultLanguage!initializing!public! !
!SimpleAXScriptEditor categoriesFor: #displayScriptError:!commands!private! !
!SimpleAXScriptEditor categoriesFor: #expressionText!accessing!public! !
!SimpleAXScriptEditor categoriesFor: #fileNew!commands!public! !
!SimpleAXScriptEditor categoriesFor: #fileOpen!commands!public! !
!SimpleAXScriptEditor categoriesFor: #fileSave!commands!public! !
!SimpleAXScriptEditor categoriesFor: #fileSaveAs!commands!public! !
!SimpleAXScriptEditor categoriesFor: #helpAboutScriptControl!commands!public! !
!SimpleAXScriptEditor categoriesFor: #initialize!initializing!private! !
!SimpleAXScriptEditor categoriesFor: #language!accessing!public! !
!SimpleAXScriptEditor categoriesFor: #language:!accessing!public! !
!SimpleAXScriptEditor categoriesFor: #languages!initializing!public! !
!SimpleAXScriptEditor categoriesFor: #model:!accessing!public! !
!SimpleAXScriptEditor categoriesFor: #newScript!commands!private! !
!SimpleAXScriptEditor categoriesFor: #onLanguageChanged!event handling!private! !
!SimpleAXScriptEditor categoriesFor: #onViewOpened!event handling!public! !
!SimpleAXScriptEditor categoriesFor: #saveScriptToFile!commands!private! !
!SimpleAXScriptEditor categoriesFor: #scriptFileTypes!constants!public! !
!SimpleAXScriptEditor categoriesFor: #scriptParse!commands!public! !
!SimpleAXScriptEditor categoriesFor: #scriptRun!commands!public! !
!SimpleAXScriptEditor categoriesFor: #scriptText!accessing!public! !
!SimpleAXScriptEditor categoriesFor: #scriptText:!accessing!public! !

!SimpleAXScriptEditor class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized."

	^ActiveXScriptlet new!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 30 nil nil 8 #(13369344 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #dialog nil 133 nil 263174 ##(Smalltalk.Font) nil true 459014 ##(Smalltalk.LOGFONT) 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 1 2 1 34 77 83 32 83 97 110 115 32 83 101 114 105 102 0 110 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 640 nil nil nil 7 nil nil nil 640 852230 ##(Smalltalk.FramingLayout) 170 176 34 4 410 ##(Smalltalk.GroupBox) 34 14 nil 640 34 2 8 1140850695 65 768 nil nil nil 7 nil nil nil 768 nil 8 1867514112 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 578 11 11 578 895 101 768 914 #text: 34 1 8 'Description' 768 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 196 1 0 0 55 0 0 0] 8 #() 578 193 193 nil 27 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedParentLeft 1 1154 #fixedParentRight -3 1154 #fixedParentTop 1 1154 #fixedParentBottom 1 410 ##(Smalltalk.TextEdit) 34 16 nil 640 34 2 8 1140916352 1025 1232 nil 327686 ##(Smalltalk.Color) #default nil 7 nil nil nil 1232 nil 8 1867501424 852486 ##(Smalltalk.NullConverter) nil nil 9 850 138 144 34 1 914 #createAt:extent: 34 2 578 31 49 578 855 39 1232 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 24 0 0 0 186 1 0 0 43 0 0 0] 8 #() 1104 nil 27 1122 1168 21 1184 -23 1200 39 1216 -23 170 192 34 2 1232 8 'description' 590342 ##(Smalltalk.Rectangle) 578 11 11 578 11 11 850 138 144 34 1 914 #createAt:extent: 34 2 578 1 1 578 919 121 640 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 203 1 0 0 60 0 0 0] 34 2 1232 768 1104 nil 27 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 1824 nil nil nil 7 nil nil nil 1824 706 170 176 34 8 410 ##(Smalltalk.PushButton) 34 20 nil 1824 34 2 8 1140924416 1 1936 nil 1312 nil 7 nil nil nil 1936 nil 8 1867514112 1180998 4 ##(Smalltalk.CommandDescription) #scriptParse 8 '&Parse' 1 1 nil nil false nil nil nil 850 138 144 34 3 914 #createAt:extent: 34 2 578 351 11 578 141 47 1936 914 #isEnabled: 8 #(false) 1936 914 #text: 34 1 8 '&Parse' 1936 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 175 0 0 0 5 0 0 0 245 0 0 0 28 0 0 0] 8 #() 1104 nil 29 1122 1154 #fixedPreviousRight 31 1154 #fixedViewLeft 141 1154 #fixedPreviousTop -1 1154 #fixedViewTop 47 410 ##(Smalltalk.ComboBox) 34 17 nil 1824 34 2 8 1144063490 1025 2384 590662 2 ##(Smalltalk.ListModel) 138 144 8 #() nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 1312 nil 7 nil nil nil 2384 nil 8 1867367040 ##(Smalltalk.BasicListAbstract) 2496 201 850 138 144 34 1 914 #createAt:extent: 34 2 578 141 13 578 181 43 2384 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 70 0 0 0 6 0 0 0 160 0 0 0 27 0 0 0] 8 #() 1104 nil 27 1122 2320 11 2336 181 2352 -3 2368 43 410 ##(Smalltalk.StaticText) 34 16 nil 1824 34 2 8 1140850946 1 2736 nil nil nil 7 nil nil nil 2736 nil 8 1867478992 1346 nil nil nil 850 138 144 34 2 914 #createAt:extent: 34 2 578 21 17 578 111 45 2736 914 #text: 34 1 8 'Language:' 2736 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 8 0 0 0 65 0 0 0 30 0 0 0] 8 #() 1104 nil 27 1122 1168 21 2336 111 1154 #fixedViewBottom -43 1216 -19 410 ##(Smalltalk.ReferenceView) 34 14 nil 1824 34 2 8 1140850688 131073 3072 nil nil nil 7 nil nil nil 3072 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Presenter) #resource_OK_Cancel_button_block nil 850 138 144 34 1 914 #createAt:extent: 34 2 578 571 -3 578 335 71 3072 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 29 1 0 0 254 255 255 255 196 1 0 0 33 0 0 0] 2496 1104 nil 27 1122 1154 #fixedViewRight -333 1184 -13 3056 -69 1216 -13 170 192 34 2 2384 8 'Language' nil 850 138 144 34 1 914 #createAt:extent: 34 2 578 1 803 578 919 81 1824 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 145 1 0 0 203 1 0 0 185 1 0 0] 34 4 2736 2384 1936 3072 1104 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 3552 nil nil nil 7 nil nil nil 3552 1180166 ##(Smalltalk.ProportionalLayout) 170 176 34 4 410 ##(Smalltalk.ContainerView) 34 15 nil 3552 34 2 8 1140850688 131073 3680 nil nil nil 7 nil nil nil 3680 706 170 176 34 4 410 ##(Smalltalk.GroupBox) 34 14 nil 3680 34 2 8 1140850695 65 3792 nil nil nil 7 nil nil nil 3792 nil 8 1867514112 850 138 144 34 2 914 #createAt:extent: 34 2 578 11 11 578 895 459 3792 914 #text: 34 1 8 'Procedures' 3792 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 196 1 0 0 234 0 0 0] 8 #() 1104 nil 27 1122 1168 1 1184 -3 1200 1 1216 -5 410 ##(Smalltalk.ContainerView) 34 15 nil 3680 34 2 8 1140850688 131073 4096 nil nil nil 7 nil nil nil 4096 610 11 11 nil nil nil nil 410 ##(Smalltalk.ScintillaView) 34 50 nil 4096 34 2 8 1174475012 1025 4176 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil 1312 nil 7 nil nil nil 4176 nil 8 1533163101 1346 nil nil 9 nil 170 192 34 10 #lineNumber 1182790 1 ##(Smalltalk.ScintillaTextStyle) 67 nil nil 1 nil nil nil nil #lineNumber nil nil nil #indentGuide 4370 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil #normal 4370 1 nil nil 1 nil nil nil nil #normal nil nil nil #callTip 4370 77 1298 #gray 1298 #white 1 nil nil nil nil #callTip nil nil nil #whitespace 4370 3 nil nil 1 nil nil nil nil #whitespace nil nil nil nil 1245510 1 ##(Smalltalk.NullScintillaStyler) #normal 170 192 34 2 #default 1641542 2 ##(Smalltalk.ScintillaMarkerDefinition) 1 nil nil nil 4176 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 2496 nil 170 176 2496 9215 nil nil nil nil 1298 #silver nil nil 65 nil nil nil 8 '' 3 170 192 34 2 #container 4336 nil nil nil nil 1 nil 170 192 34 6 8 'indicator2' 1510470 3 ##(Smalltalk.ScintillaIndicatorStyle) 5 4176 1298 #red 1 nil nil nil nil nil nil nil nil 8 'indicator0' 4738 1 4176 1298 #commonGreen 3 nil nil nil nil nil nil nil nil 8 'indicator1' 4738 3 4176 1298 #blue 5 nil nil nil nil nil nil nil nil nil nil 170 192 34 6 #Warning 4370 1027 1298 #darkGoldenrod 1298 #ivory 1 nil nil nil nil #Warning nil nil nil #Notification 4370 1029 nil 1298 #gainsboro 1 nil nil nil nil #Notification nil nil nil #Error 4370 1031 1298 #firebrick 1298 #floralWhite 1 nil nil nil nil #Error nil nil nil nil 850 138 144 34 10 914 #createAt:extent: 34 2 578 11 11 578 855 399 4176 914 #text: 34 1 8 'function Do(x)
	Do = "Do " + x
end function' 4176 914 #textLimit: 8 #(1073741823) 4176 914 #caretPeriod: 8 #(530) 4176 914 #wordWrap: 8 #(true) 4176 914 #margins: 34 1 34 3 985158 3 ##(Smalltalk.ScintillaMargin) 1 4176 1 3 nil nil nil nil 5346 3 4176 33 nil nil 67108863 nil nil 5346 5 4176 1 nil nil nil nil nil 4176 914 #canHScroll: 8 #(false) 4176 914 #targetRange: 34 1 525062 ##(Smalltalk.Interval) 3 91 3 4176 914 #maxCompletionListHeight: 8 #(9) 4176 914 #edgeColumn: 8 #(1) 4176 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 176 1 0 0 204 0 0 0] 8 #() 1104 nil 29 170 192 34 2 4176 8 'ScriptText' 1602 578 11 11 578 11 11 850 138 144 34 1 914 #createAt:extent: 34 2 578 21 41 578 875 419 4096 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 20 0 0 0 191 1 0 0 229 0 0 0] 34 1 4176 1104 nil 27 1122 1168 11 1184 -13 1200 31 1216 -15 170 192 2496 1602 578 11 11 578 11 1 850 138 144 34 1 914 #createAt:extent: 34 2 578 1 209 578 919 475 3680 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 104 0 0 0 203 1 0 0 85 1 0 0] 34 2 3792 4096 1104 nil 27 327734 ##(Smalltalk.Float) 8 0 0 0 0 0 0 4 64 410 ##(Smalltalk.ContainerView) 34 15 nil 3552 34 2 8 1140850688 131073 6144 nil nil nil 7 nil nil nil 6144 706 170 176 34 10 410 ##(Smalltalk.GroupBox) 34 14 nil 6144 34 2 8 1140850695 65 6256 nil nil nil 7 nil nil nil 6256 nil 8 1867514112 850 138 144 34 2 914 #createAt:extent: 34 2 578 11 11 578 895 199 6256 914 #text: 34 1 8 'Expression' 6256 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 196 1 0 0 104 0 0 0] 8 #() 1104 nil 27 1122 1168 1 1184 -3 1200 1 1216 11 410 ##(Smalltalk.StaticText) 34 16 nil 6144 34 2 8 1140850946 1 6560 nil nil nil 7 nil nil nil 6560 nil 8 1867478992 1346 nil nil nil 850 138 144 34 2 914 #createAt:extent: 34 2 578 51 151 578 101 41 6560 914 #text: 34 1 8 'Result:' 6560 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 25 0 0 0 75 0 0 0 75 0 0 0 95 0 0 0] 8 #() 1104 nil 27 1122 1168 41 2336 101 3056 -39 1216 -7 410 ##(Smalltalk.PushButton) 34 20 nil 6144 34 2 8 1140924416 1 6880 nil 1312 nil 7 nil nil nil 6880 nil 8 1867514112 2018 #scriptRun 8 '&Test' 1 1 nil nil false nil nil nil 850 138 144 34 3 914 #createAt:extent: 34 2 578 31 51 578 131 51 6880 914 #isEnabled: 8 #(false) 6880 914 #text: 34 1 8 '&Test' 6880 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 25 0 0 0 80 0 0 0 50 0 0 0] 8 #() 1104 nil 29 1122 1168 21 2336 131 1200 41 2368 51 410 ##(Smalltalk.MultilineTextEdit) 34 16 nil 6144 34 2 8 1143017540 1025 7248 nil 1312 nil 7 nil nil nil 7248 nil 8 1867501424 1346 nil nil 9 850 138 144 34 1 914 #createAt:extent: 34 2 578 171 41 578 715 79 7248 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 85 0 0 0 20 0 0 0 186 1 0 0 59 0 0 0] 8 #() 1104 nil 27 1122 1168 161 1184 -23 1200 31 1216 -79 410 ##(Smalltalk.TextEdit) 34 16 nil 6144 34 2 8 1140916352 1025 7520 nil 4464 nil 7 nil nil nil 7520 nil 8 1867501424 1346 nil nil 1 850 138 144 34 2 914 #createAt:extent: 34 2 578 171 143 578 715 43 7520 914 #isEnabled: 8 #(false) 7520 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 85 0 0 0 71 0 0 0 186 1 0 0 92 0 0 0] 8 #() 1104 nil 27 1122 1168 161 1184 -23 3056 -41 1216 -13 170 192 34 4 7520 8 'Result' 7248 8 'Expression' 1602 578 11 11 578 11 11 850 138 144 34 1 914 #createAt:extent: 34 2 578 1 1 578 919 209 6144 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 203 1 0 0 104 0 0 0] 34 5 7248 6880 6560 7520 6256 1104 nil 27 6114 8 154 153 153 153 153 153 241 63 true 170 192 2496 nil 850 138 144 34 1 914 #createAt:extent: 34 2 578 1 121 578 919 683 3552 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 60 0 0 0 203 1 0 0 145 1 0 0] 34 2 6144 3680 1104 nil 27 170 192 2496 nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 4 265030 4 ##(Smalltalk.Menu) nil true 34 3 984134 2 ##(Smalltalk.CommandMenuItem) 1 2018 #fileOpen 8 '&Open...' 9375 1 nil nil nil 8402 1 2018 #fileSave 8 '&Save' 9383 1 nil nil nil 8402 1 2018 #fileSaveAs 8 'Save &As...' 1 1 nil nil nil 8 '&File' nil 1 nil nil 16121 nil nil 8354 nil true 34 11 8402 1 2018 #undo 8 '&Undo' 9397 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 8402 1 2018 #cutSelection 8 'Cu&t' 9393 1 nil nil nil 8402 1 2018 #copySelection 8 '&Copy' 9351 1 nil nil nil 8402 1 2018 #pasteClipboard 8 '&Paste' 9389 1 nil nil nil 8402 1 2018 #clearSelection 8 '&Delete' 1 1 nil nil nil 8402 1 2018 #selectAll 8 'Select &All' 9347 1 nil nil nil 8672 8402 1 2018 #find 8 '&Find...' 9357 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 47 786694 ##(Smalltalk.ShellLibrary) nil nil 8402 1 2018 #findNext 8 'Find &Next' 1253 1 nil nil nil 8402 1 2018 #findReplace 8 '&Replace...' 9361 1 nil nil nil 8 '&Edit' nil 1 nil nil 16141 nil nil 8354 nil true 34 2 8402 1 2018 #scriptParse 8 '&Parse' 1 1 nil nil nil 8402 1 2018 #scriptRun 8 '&Test' 1 1 nil nil nil 8 '&Script' nil 1 nil nil 16147 nil nil 8354 nil true 34 1 8402 1 2018 #helpAboutScriptControl 8 '&About Script Control...' 1 1 nil nil nil 8 '&Help' nil 1 nil nil 16151 nil nil 8 '' nil 1 nil nil nil nil nil nil nil nil 39063 nil nil nil 578 851 901 1 nil nil 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 2007860128 850 138 144 34 3 914 #createAt:extent: 34 2 578 7039 21 578 951 1001 416 914 #text: 34 1 8 'Active-X Script Editor' 416 914 #updateMenuBar 2496 416 1042 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 191 13 0 0 10 0 0 0 154 15 0 0 254 1 0 0] 34 3 640 3552 1824 1104 nil 27 )! !
!SimpleAXScriptEditor class categoriesFor: #defaultModel!constants!public! !
!SimpleAXScriptEditor class categoriesFor: #resource_Default_view!public!resources-views! !

