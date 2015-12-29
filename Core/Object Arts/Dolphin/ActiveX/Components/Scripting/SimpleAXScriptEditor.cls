"Filed out from Dolphin Smalltalk X6"!

Dialog subclass: #SimpleAXScriptEditor
	instanceVariableNames: 'scriptControl languagePresenter scriptPresenter expressionPresenter resultPresenter filename descriptionPresenter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SimpleAXScriptEditor guid: (GUID fromString: '{46F9C2FB-D025-11D3-93DA-00A024CA708A}')!
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

	^Array
		with: #('VB Script (*.vbs)' '*.vbs')
		with: #('JScript (*.js)' '*.js')
		with: FileDialog allFilesType!

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

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.DialogView)  98 30 0 0 98 2 26738689 131073 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 167 0 263174 ##(Smalltalk.Font)  0 16 459014 ##(Smalltalk.LOGFONT)  8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 1 2 1 34 77 83 32 83 97 110 115 32 83 101 114 105 102 0 110 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point)  193 193 0 416 788230 ##(Smalltalk.BorderLayout)  1 1 410 8 ##(Smalltalk.ContainerView)  98 15 0 416 98 2 8 1140850688 131073 672 0 721158 ##(Smalltalk.SystemColor)  31 0 7 0 0 0 672 852230 ##(Smalltalk.FramingLayout)  234 240 98 4 410 8 ##(Smalltalk.GroupBox)  98 14 0 672 98 2 8 1140850695 65 848 0 482 512 0 7 0 0 0 848 0 8 4294903631 983302 ##(Smalltalk.MessageSequence)  202 208 98 2 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 610 11 11 610 911 101 848 1026 8 #text: 98 1 8 'Description' 848 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 204 1 0 0 55 0 0 0] 98 0 610 193 193 0 27 1181766 2 ##(Smalltalk.FramingConstraints)  1180678 ##(Smalltalk.FramingCalculation)  8 #fixedParentLeft 1 1298 8 #fixedParentRight -3 1298 8 #fixedParentTop 1 1298 8 #fixedParentBottom 1 410 8 ##(Smalltalk.TextEdit)  98 16 0 672 98 2 8 1140916352 1025 1440 0 482 512 0 7 0 0 0 1440 0 8 4294903807 852486 ##(Smalltalk.NullConverter)  0 0 9 962 202 208 98 3 1026 1056 98 2 610 31 49 610 871 39 1440 1026 8 #selectionRange: 98 1 525062 ##(Smalltalk.Interval)  3 1 3 1440 1026 8 #isTextModified: 98 1 32 1440 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 24 0 0 0 194 1 0 0 43 0 0 0] 98 0 1248 0 27 1266 1312 21 1344 -23 1376 39 1408 -23 234 256 98 2 1440 8 'description' 590342 ##(Smalltalk.Rectangle)  610 11 11 610 11 11 962 202 208 98 1 1026 1056 98 2 610 1 1 610 935 121 672 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 211 1 0 0 60 0 0 0] 98 2 1440 848 1248 0 27 410 688 98 15 0 416 98 2 8 1140850688 131073 2160 0 754 31 0 7 0 0 0 2160 786 234 240 98 8 410 8 ##(Smalltalk.ReferenceView)  98 14 0 2160 98 2 8 1140850688 131073 2288 0 0 0 7 0 0 0 2288 1180166 ##(Smalltalk.ResourceIdentifier)  8 ##(Smalltalk.Presenter)  8 #resource_OK_Cancel_button_block 0 962 202 208 98 1 1026 1056 98 2 610 595 -9 610 321 71 2288 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 41 1 0 0 251 255 255 255 201 1 0 0 30 0 0 0] 98 0 1248 0 27 1266 1298 8 #fixedViewRight -319 1344 -19 1298 8 #fixedViewBottom -69 1408 -19 410 8 ##(Smalltalk.ComboBox)  98 17 0 2160 98 2 8 1144063490 1025 2672 590662 2 ##(Smalltalk.ListModel)  202 208 2576 0 1310726 ##(Smalltalk.IdentitySearchPolicy)  482 512 0 7 0 0 0 2672 0 8 4294903803 8 ##(Smalltalk.BasicListAbstract)  2576 201 962 202 208 98 1 1026 1056 98 2 610 141 13 610 181 43 2672 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 70 0 0 0 6 0 0 0 160 0 0 0 27 0 0 0] 98 0 1248 0 27 1266 1298 8 #fixedPreviousRight 11 1298 8 #fixedViewLeft 181 1298 8 #fixedPreviousTop -3 1298 8 #fixedViewTop 43 410 8 ##(Smalltalk.StaticText)  98 16 0 2160 98 2 8 1140850946 1 3184 0 0 0 7 0 0 0 3184 0 8 4294903625 1554 0 0 0 962 202 208 98 2 1026 1056 98 2 610 21 17 610 111 45 3184 1026 1136 98 1 8 'Language:' 3184 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 8 0 0 0 65 0 0 0 30 0 0 0] 98 0 1248 0 27 1266 1312 21 3088 111 2640 -43 1408 -19 410 8 ##(Smalltalk.PushButton)  98 17 0 2160 98 2 8 1140924416 1 3520 0 482 512 0 7 0 0 0 3520 0 8 4294903631 1180998 4 ##(Smalltalk.CommandDescription)  8 #scriptParse 8 '&Parse' 1 1 0 0 32 962 202 208 98 3 1026 1056 98 2 610 351 9 610 141 51 3520 1026 8 #isEnabled: 98 1 32 3520 1026 1136 98 1 8 '&Parse' 3520 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 175 0 0 0 4 0 0 0 245 0 0 0 29 0 0 0] 98 0 1248 0 27 1266 3056 31 3088 141 3120 -3 3152 51 234 256 98 2 2672 8 'Language' 0 962 202 208 98 1 1026 1056 98 2 610 1 813 610 935 81 2160 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 150 1 0 0 211 1 0 0 190 1 0 0] 98 4 3184 2672 3520 2288 1248 0 27 0 0 410 688 98 15 0 416 98 2 8 1140850688 131073 4176 0 482 512 0 7 0 0 0 4176 1180166 ##(Smalltalk.ProportionalLayout)  234 240 98 4 410 688 98 15 0 4176 98 2 8 1140850688 131073 4320 0 754 31 0 7 0 0 0 4320 786 234 240 98 4 410 864 98 14 0 4320 98 2 8 1140850695 65 4448 0 482 512 0 7 0 0 0 4448 0 8 4294903631 962 202 208 98 2 1026 1056 98 2 610 11 11 610 911 467 4448 1026 1136 98 1 8 'Procedures' 4448 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 204 1 0 0 238 0 0 0] 98 0 1248 0 27 1266 1312 1 1344 -3 1376 1 1408 -5 410 688 98 15 0 4320 98 2 8 1140850688 131073 4768 0 754 31 0 7 0 0 0 4768 642 11 11 0 0 0 0 410 8 ##(Smalltalk.ScintillaView)  98 46 0 4768 98 2 8 1174475012 1025 4864 721990 2 ##(Smalltalk.ValueHolder)  0 32 1310726 ##(Smalltalk.EqualitySearchPolicy)  0 482 512 0 7 0 0 0 4864 0 70871329 1554 0 0 9 0 234 256 98 8 8 #whitespace 1182726 ##(Smalltalk.ScintillaTextStyle)  3 0 0 1 0 0 0 0 5072 0 0 0 8 #indentGuide 5090 75 0 0 1 0 0 0 0 5120 0 0 0 8 #lineNumber 5090 67 0 0 1 0 0 0 0 5152 0 0 0 8 #normal 5090 1 0 0 1 0 0 0 0 5184 0 0 0 98 40 5200 5104 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 5168 0 0 0 5136 0 0 1245510 1 ##(Smalltalk.NullScintillaStyler)  5184 234 256 98 2 8 #default 1639942 ##(Smalltalk.ScintillaMarkerDefinition)  1 1 786694 ##(Smalltalk.IndexedColor)  33554433 5346 33554471 4864 8 #circle 202 8 ##(Smalltalk.IdentitySet)  2576 0 63 0 0 0 0 0 5346 33554447 0 0 0 0 0 0 8 '' 3 234 256 98 2 8 #container 5040 0 0 0 0 1 0 0 962 202 208 98 11 1026 1056 98 2 610 11 11 610 871 407 4864 1026 1136 98 1 8 'function Do(x)
	Do = "Do " + x
end function' 4864 1026 1712 98 1 1746 3 1 3 4864 1026 1792 98 1 32 4864 1026 8 #modificationEventMask: 98 1 9215 4864 1026 8 #indicatorDefinitions: 98 1 98 3 1836038 ##(Smalltalk.ScintillaIndicatorDefinition)  1 4864 65025 3 5874 3 4864 33423361 5 5874 5 4864 511 1 4864 1026 8 #wordWrap: 98 1 16 4864 1026 8 #margins: 98 1 98 3 984582 ##(Smalltalk.ScintillaMargin)  1 4864 1 3 32 1 6050 3 4864 33 1 32 67108863 6050 5 4864 1 1 32 1 4864 1026 8 #markers: 98 1 5408 4864 1026 8 #canHScroll: 98 1 32 4864 1026 8 #tabIndents: 98 1 16 4864 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 184 1 0 0 208 0 0 0] 98 0 1248 0 27 234 256 98 2 4864 8 'ScriptText' 1938 610 11 11 610 11 11 962 202 208 98 1 1026 1056 98 2 610 21 41 610 891 427 4768 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 20 0 0 0 199 1 0 0 233 0 0 0] 98 1 4864 1248 0 27 1266 1312 11 1344 -13 1376 31 1408 -15 234 256 2576 1938 610 11 11 610 11 1 962 202 208 98 1 1026 1056 98 2 610 1 211 610 935 483 4320 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 105 0 0 0 211 1 0 0 90 1 0 0] 98 2 4448 4768 1248 0 27 327734 ##(Smalltalk.Float)  8 0 0 0 0 0 0 4 64 410 688 98 15 0 4176 98 2 8 1140850688 131073 6832 0 754 31 0 7 0 0 0 6832 786 234 240 98 10 410 1456 98 16 0 6832 98 2 8 1140916352 1025 6960 0 196934 1 ##(Smalltalk.RGB)  33554431 0 7 0 0 0 6960 0 8 4294903807 1554 0 0 1 962 202 208 98 4 1026 1056 98 2 610 171 145 610 731 43 6960 1026 3824 98 1 32 6960 1026 1712 98 1 1746 3 1 3 6960 1026 1792 98 1 32 6960 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 85 0 0 0 72 0 0 0 194 1 0 0 93 0 0 0] 98 0 1248 0 27 1266 1312 161 1344 -23 2640 -41 1408 -13 410 864 98 14 0 6832 98 2 8 1140850695 65 7376 0 482 512 0 7 0 0 0 7376 0 8 4294903631 962 202 208 98 2 1026 1056 98 2 610 11 11 610 911 201 7376 1026 1136 98 1 8 'Expression' 7376 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 204 1 0 0 105 0 0 0] 98 0 1248 0 27 1266 1312 1 1344 -3 1376 1 1408 11 410 8 ##(Smalltalk.MultilineTextEdit)  98 16 0 6832 98 2 8 1143017540 1025 7696 0 482 512 0 7 0 0 0 7696 0 8 4294903807 1554 0 0 9 962 202 208 98 3 1026 1056 98 2 610 171 41 610 731 81 7696 1026 1712 98 1 1746 3 1 3 7696 1026 1792 98 1 32 7696 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 85 0 0 0 20 0 0 0 194 1 0 0 60 0 0 0] 98 0 1248 0 27 1266 1312 161 1344 -23 1376 31 1408 -79 410 3536 98 17 0 6832 98 2 8 1140924416 1 8080 0 482 512 0 7 0 0 0 8080 0 8 4294903631 3634 8 #scriptRun 8 '&Test' 1 1 0 0 32 962 202 208 98 3 1026 1056 98 2 610 31 51 610 131 51 8080 1026 3824 98 1 32 8080 1026 1136 98 1 8 '&Test' 8080 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 25 0 0 0 80 0 0 0 50 0 0 0] 98 0 1248 0 27 1266 1312 21 3088 131 1376 41 3152 51 410 3200 98 16 0 6832 98 2 8 1140850946 1 8480 0 0 0 7 0 0 0 8480 0 8 4294903625 1554 0 0 0 962 202 208 98 2 1026 1056 98 2 610 51 153 610 101 41 8480 1026 1136 98 1 8 'Result:' 8480 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 25 0 0 0 76 0 0 0 75 0 0 0 96 0 0 0] 98 0 1248 0 27 1266 1312 41 3088 101 2640 -39 1408 -7 234 256 98 4 6960 8 'Result' 7696 8 'Expression' 1938 610 11 11 610 11 11 962 202 208 98 1 1026 1056 98 2 610 1 1 610 935 211 6832 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 211 1 0 0 105 0 0 0] 98 5 7696 8080 8480 6960 7376 1248 0 27 6802 8 154 153 153 153 153 153 241 63 16 234 256 2576 0 962 202 208 98 1 1026 1056 98 2 610 1 121 610 935 693 4176 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 60 0 0 0 211 1 0 0 150 1 0 0] 98 2 6832 4320 1248 0 27 234 256 2576 0 461638 4 ##(Smalltalk.MenuBar)  0 16 98 4 265030 4 ##(Smalltalk.Menu)  0 16 98 3 984134 2 ##(Smalltalk.CommandMenuItem)  1 3634 8 #fileOpen 8 '&Open...' 9375 1 0 0 0 9378 1 3634 8 #fileSave 8 '&Save' 9383 1 0 0 0 9378 1 3634 8 #fileSaveAs 8 'Save &As...' 1 1 0 0 0 8 '&File' 0 1 0 0 34141 0 0 9330 0 16 98 11 9378 1 3634 8 #undo 8 '&Undo' 9397 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem)  4097 9378 1 3634 8 #cutSelection 8 'Cu&t' 9393 1 0 0 0 9378 1 3634 8 #copySelection 8 '&Copy' 9351 1 0 0 0 9378 1 3634 8 #pasteClipboard 8 '&Paste' 9389 1 0 0 0 9378 1 3634 8 #clearSelection 8 '&Delete' 1 1 0 0 0 9378 1 3634 8 #selectAll 8 'Select &All' 9347 1 0 0 0 9712 9378 1 3634 8 #find 8 '&Find...' 9357 1 263494 3 ##(Smalltalk.Icon)  0 16 1572870 ##(Smalltalk.ImageRelativeFileLocator)  47 786694 ##(Smalltalk.ShellLibrary)  0 0 9378 1 3634 8 #findNext 8 'Find &Next' 1253 1 0 0 0 9378 1 3634 8 #findReplace 8 '&Replace...' 9361 1 0 0 0 8 '&Edit' 0 1 0 0 34161 0 0 9330 0 16 98 2 9378 1 3634 3664 8 '&Parse' 1 1 0 0 0 9378 1 3634 8192 8 '&Test' 1 1 0 0 0 8 '&Script' 0 1 0 0 34167 0 0 9330 0 16 98 1 9378 1 3634 8 #helpAboutScriptControl 8 '&About Script Control...' 1 1 0 0 0 8 '&Help' 0 1 0 0 34171 0 0 8 '' 0 1 0 0 0 0 0 0 0 0 32923 0 0 0 610 851 901 1 0 0 590598 ##(Smalltalk.Semaphore)  0 0 1 0 8 2010572111 962 202 208 98 3 1026 1056 98 2 610 2799 21 610 951 1001 416 1026 1136 98 1 8 'Active-X Script Editor' 416 1026 8 #updateMenuBar 2576 416 1186 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 82 7 0 0 254 1 0 0] 98 3 672 4176 2160 1248 0 27 )! !
!SimpleAXScriptEditor class categoriesFor: #defaultModel!constants!public! !
!SimpleAXScriptEditor class categoriesFor: #resource_Default_view!public!resources-views! !

