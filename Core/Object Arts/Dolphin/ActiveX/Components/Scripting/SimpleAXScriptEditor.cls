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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 30 0 0 8 #(13369344 65536) 416 0 524550 ##(Smalltalk.ColorRef) 8 4278190080 0 135 0 263174 ##(Smalltalk.Font) 0 true 459014 ##(Smalltalk.LOGFONT) 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 1 2 1 34 77 83 32 83 97 110 115 32 83 101 114 105 102 0 110 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 0 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.ContainerView) 34 15 0 416 34 2 8 1140850688 131073 656 0 721158 ##(Smalltalk.SystemColor) 31 0 7 0 0 0 656 852230 ##(Smalltalk.FramingLayout) 170 176 34 4 410 ##(Smalltalk.GroupBox) 34 14 0 656 34 2 8 1140850695 65 816 0 466 496 0 7 0 0 0 816 0 8 4294903891 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 594 11 11 594 895 101 816 978 #text: 34 1 8 'Description' 816 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 196 1 0 0 55 0 0 0] 8 #() 594 193 193 0 27 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedParentLeft 1 1218 #fixedParentRight -3 1218 #fixedParentTop 1 1218 #fixedParentBottom 1 410 ##(Smalltalk.TextEdit) 34 16 0 656 34 2 8 1140916352 1025 1296 0 466 496 0 7 0 0 0 1296 0 8 4294903825 852486 ##(Smalltalk.NullConverter) 0 0 9 914 138 144 34 1 978 #createAt:extent: 34 2 594 31 49 594 855 39 1296 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 24 0 0 0 186 1 0 0 43 0 0 0] 8 #() 1168 0 27 1186 1232 21 1248 -23 1264 39 1280 -23 170 192 34 2 1296 8 'description' 590342 ##(Smalltalk.Rectangle) 594 11 11 594 11 11 914 138 144 34 1 978 #createAt:extent: 34 2 594 1 1 594 919 121 656 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 203 1 0 0 60 0 0 0] 34 2 1296 816 1168 0 27 410 ##(Smalltalk.ContainerView) 34 15 0 416 34 2 8 1140850688 131073 1872 0 722 31 0 7 0 0 0 1872 754 170 176 34 8 410 ##(Smalltalk.PushButton) 34 20 0 1872 34 2 8 1140924416 1 2000 0 466 496 0 7 0 0 0 2000 0 8 4294903891 1180998 4 ##(Smalltalk.CommandDescription) #scriptParse 8 '&Parse' 1 1 0 0 false 0 0 0 914 138 144 34 3 978 #createAt:extent: 34 2 594 351 9 594 141 51 2000 978 #isEnabled: 8 #(false) 2000 978 #text: 34 1 8 '&Parse' 2000 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 175 0 0 0 4 0 0 0 245 0 0 0 29 0 0 0] 8 #() 1168 0 29 1186 1218 #fixedPreviousRight 31 1218 #fixedViewLeft 141 1218 #fixedPreviousTop -3 1218 #fixedViewTop 51 410 ##(Smalltalk.ComboBox) 34 17 0 1872 34 2 8 1144063490 1025 2464 590662 2 ##(Smalltalk.ListModel) 138 144 8 #() 0 1310726 ##(Smalltalk.IdentitySearchPolicy) 466 496 0 7 0 0 0 2464 0 8 4294903831 ##(Smalltalk.BasicListAbstract) 2576 201 914 138 144 34 1 978 #createAt:extent: 34 2 594 141 13 594 181 43 2464 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 70 0 0 0 6 0 0 0 160 0 0 0 27 0 0 0] 8 #() 1168 0 27 1186 2400 11 2416 181 2432 -3 2448 43 410 ##(Smalltalk.ReferenceView) 34 14 0 1872 34 2 8 1140850688 131073 2832 0 0 0 7 0 0 0 2832 1180166 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Presenter) #resource_OK_Cancel_button_block 0 914 138 144 34 1 978 #createAt:extent: 34 2 594 579 -9 594 321 71 2832 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 33 1 0 0 251 255 255 255 193 1 0 0 30 0 0 0] 2576 1168 0 27 1186 1218 #fixedViewRight -319 1248 -19 1218 #fixedViewBottom -69 1280 -19 410 ##(Smalltalk.StaticText) 34 16 0 1872 34 2 8 1140850946 1 3120 0 0 0 7 0 0 0 3120 0 8 4294903859 1394 0 0 0 914 138 144 34 2 978 #createAt:extent: 34 2 594 21 17 594 111 45 3120 978 #text: 34 1 8 'Language:' 3120 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 8 0 0 0 65 0 0 0 30 0 0 0] 8 #() 1168 0 27 1186 1232 21 2416 111 3104 -43 1280 -19 170 192 34 2 2464 8 'Language' 0 914 138 144 34 1 978 #createAt:extent: 34 2 594 1 803 594 919 81 1872 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 145 1 0 0 203 1 0 0 185 1 0 0] 34 4 3120 2464 2000 2832 1168 0 27 0 0 410 ##(Smalltalk.ContainerView) 34 15 0 416 34 2 8 1140850688 131073 3648 0 466 496 0 7 0 0 0 3648 1180166 ##(Smalltalk.ProportionalLayout) 170 176 34 4 410 ##(Smalltalk.ContainerView) 34 15 0 3648 34 2 8 1140850688 131073 3792 0 722 31 0 7 0 0 0 3792 754 170 176 34 4 410 ##(Smalltalk.GroupBox) 34 14 0 3792 34 2 8 1140850695 65 3920 0 466 496 0 7 0 0 0 3920 0 8 4294903891 914 138 144 34 2 978 #createAt:extent: 34 2 594 11 11 594 895 459 3920 978 #text: 34 1 8 'Procedures' 3920 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 196 1 0 0 234 0 0 0] 8 #() 1168 0 27 1186 1232 1 1248 -3 1264 1 1280 -5 410 ##(Smalltalk.ContainerView) 34 15 0 3792 34 2 8 1140850688 131073 4240 0 722 31 0 7 0 0 0 4240 626 11 11 0 0 0 0 410 ##(Smalltalk.ScintillaView) 34 50 0 4240 34 2 8 1174475012 1025 4336 721990 2 ##(Smalltalk.ValueHolder) 0 false 1310726 ##(Smalltalk.EqualitySearchPolicy) 0 466 496 0 7 0 0 0 4336 0 8 4294906539 1394 0 0 9 0 170 192 34 10 #callTip 1182790 1 ##(Smalltalk.ScintillaTextStyle) 77 786694 ##(Smalltalk.IndexedColor) 33554457 4578 33554471 1 0 0 0 0 #callTip 0 0 0 #normal 4546 1 0 0 1 0 0 0 0 #normal 0 0 0 #lineNumber 4546 67 0 0 1 0 0 0 0 #lineNumber 0 0 0 #whitespace 4546 3 0 0 1 0 0 0 0 #whitespace 0 0 0 #indentGuide 4546 75 0 0 1 0 0 0 0 #indentGuide 0 0 0 34 40 4624 4656 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4640 0 0 0 4672 0 0 1245510 1 ##(Smalltalk.NullScintillaStyler) #normal 170 192 34 2 #default 1641542 1 ##(Smalltalk.ScintillaMarkerDefinition) 1 0 0 0 4336 #circle 0 0 0 0 0 0 138 ##(Smalltalk.IdentitySet) 2576 0 170 176 2576 9215 0 0 0 0 4578 33554447 0 0 65 0 0 0 8 '' 3 170 192 34 2 #container 4512 0 0 0 0 1 0 170 192 34 6 8 'indicator0' 1510470 2 ##(Smalltalk.ScintillaIndicatorStyle) 1 4336 65025 3 0 0 0 0 0 0 0 0 8 'indicator1' 4946 3 4336 33423361 5 0 0 0 0 0 0 0 0 8 'indicator2' 4946 5 4336 511 1 0 0 0 0 0 0 0 0 0 0 170 192 34 6 #Notification 4546 1027 0 196934 1 ##(Smalltalk.RGB) 31185883 1 0 0 0 0 #Notification 0 0 0 #Warning 4546 1029 5090 60239 5090 31326207 1 0 0 0 0 #Warning 0 0 0 #Error 4546 1031 5090 335 5090 31317503 1 0 0 0 0 #Error 0 0 0 0 914 138 144 34 7 978 #createAt:extent: 34 2 594 11 11 594 855 399 4336 978 #text: 34 1 8 'function Do(x)
	Do = "Do " + x
end function' 4336 978 #modificationEventMask: 8 #(4607) 4336 978 #caretPeriod: 8 #(530) 4336 978 #wordWrap: 8 #(true) 4336 978 #margins: 34 1 34 3 985158 2 ##(Smalltalk.ScintillaMargin) 1 4336 1 3 0 0 0 0 5522 3 4336 33 0 0 67108863 0 0 5522 5 4336 1 0 0 0 0 0 4336 978 #canHScroll: 8 #(false) 4336 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 176 1 0 0 204 0 0 0] 8 #() 1168 0 29 170 192 34 2 4336 8 'ScriptText' 1650 594 11 11 594 11 11 914 138 144 34 1 978 #createAt:extent: 34 2 594 21 41 594 875 419 4240 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 20 0 0 0 191 1 0 0 229 0 0 0] 34 1 4336 1168 0 27 1186 1232 11 1248 -13 1264 31 1280 -15 170 192 2576 1650 594 11 11 594 11 1 914 138 144 34 1 978 #createAt:extent: 34 2 594 1 209 594 919 475 3792 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 104 0 0 0 203 1 0 0 85 1 0 0] 34 2 3920 4240 1168 0 27 327734 ##(Smalltalk.Float) 8 0 0 0 0 0 0 4 64 410 ##(Smalltalk.ContainerView) 34 15 0 3648 34 2 8 1140850688 131073 6192 0 722 31 0 7 0 0 0 6192 754 170 176 34 10 410 ##(Smalltalk.StaticText) 34 16 0 6192 34 2 8 1140850946 1 6320 0 0 0 7 0 0 0 6320 0 8 4294903859 1394 0 0 0 914 138 144 34 2 978 #createAt:extent: 34 2 594 51 151 594 101 41 6320 978 #text: 34 1 8 'Result:' 6320 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 25 0 0 0 75 0 0 0 75 0 0 0 95 0 0 0] 8 #() 1168 0 27 1186 1232 41 2416 101 3104 -39 1280 -7 410 ##(Smalltalk.GroupBox) 34 14 0 6192 34 2 8 1140850695 65 6640 0 466 496 0 7 0 0 0 6640 0 8 4294903891 914 138 144 34 2 978 #createAt:extent: 34 2 594 11 11 594 895 199 6640 978 #text: 34 1 8 'Expression' 6640 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 196 1 0 0 104 0 0 0] 8 #() 1168 0 27 1186 1232 1 1248 -3 1264 1 1280 11 410 ##(Smalltalk.TextEdit) 34 16 0 6192 34 2 8 1140916352 1025 6960 0 5090 33554431 0 7 0 0 0 6960 0 8 4294903825 1394 0 0 1 914 138 144 34 2 978 #createAt:extent: 34 2 594 171 143 594 715 43 6960 978 #isEnabled: 8 #(false) 6960 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 85 0 0 0 71 0 0 0 186 1 0 0 92 0 0 0] 8 #() 1168 0 27 1186 1232 161 1248 -23 3104 -41 1280 -13 410 ##(Smalltalk.MultilineTextEdit) 34 16 0 6192 34 2 8 1143017540 1025 7280 0 466 496 0 7 0 0 0 7280 0 8 4294903825 1394 0 0 9 914 138 144 34 1 978 #createAt:extent: 34 2 594 171 41 594 715 79 7280 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 85 0 0 0 20 0 0 0 186 1 0 0 59 0 0 0] 8 #() 1168 0 27 1186 1232 161 1248 -23 1264 31 1280 -79 410 ##(Smalltalk.PushButton) 34 20 0 6192 34 2 8 1140924416 1 7568 0 466 496 0 7 0 0 0 7568 0 8 4294903891 2098 #scriptRun 8 '&Test' 1 1 0 0 false 0 0 0 914 138 144 34 3 978 #createAt:extent: 34 2 594 31 51 594 131 51 7568 978 #isEnabled: 8 #(false) 7568 978 #text: 34 1 8 '&Test' 7568 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 25 0 0 0 80 0 0 0 50 0 0 0] 8 #() 1168 0 29 1186 1232 21 2416 131 1264 41 2448 51 170 192 34 4 6960 8 'Result' 7280 8 'Expression' 1650 594 11 11 594 11 11 914 138 144 34 1 978 #createAt:extent: 34 2 594 1 1 594 919 209 6192 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 203 1 0 0 104 0 0 0] 34 5 7280 7568 6320 6960 6640 1168 0 27 6162 8 154 153 153 153 153 153 241 63 true 170 192 2576 0 914 138 144 34 1 978 #createAt:extent: 34 2 594 1 121 594 919 683 3648 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 60 0 0 0 203 1 0 0 145 1 0 0] 34 2 6192 3792 1168 0 27 170 192 2576 0 461638 4 ##(Smalltalk.MenuBar) 0 true 34 4 265030 4 ##(Smalltalk.Menu) 0 true 34 3 984134 2 ##(Smalltalk.CommandMenuItem) 1 2098 #fileOpen 8 '&Open...' 9375 1 0 0 0 8530 1 2098 #fileSave 8 '&Save' 9383 1 0 0 0 8530 1 2098 #fileSaveAs 8 'Save &As...' 1 1 0 0 0 8 '&File' 0 1 0 0 39423 0 0 8482 0 true 34 11 8530 1 2098 #undo 8 '&Undo' 9397 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem) 4097 8530 1 2098 #cutSelection 8 'Cu&t' 9393 1 0 0 0 8530 1 2098 #copySelection 8 '&Copy' 9351 1 0 0 0 8530 1 2098 #pasteClipboard 8 '&Paste' 9389 1 0 0 0 8530 1 2098 #clearSelection 8 '&Delete' 1 1 0 0 0 8530 1 2098 #selectAll 8 'Select &All' 9347 1 0 0 0 8800 8530 1 2098 #find 8 '&Find...' 9357 1 263494 3 ##(Smalltalk.Icon) 0 true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 47 786694 ##(Smalltalk.ShellLibrary) 0 0 8530 1 2098 #findNext 8 'Find &Next' 1253 1 0 0 0 8530 1 2098 #findReplace 8 '&Replace...' 9361 1 0 0 0 8 '&Edit' 0 1 0 0 39443 0 0 8482 0 true 34 2 8530 1 2098 #scriptParse 8 '&Parse' 1 1 0 0 0 8530 1 2098 #scriptRun 8 '&Test' 1 1 0 0 0 8 '&Script' 0 1 0 0 39449 0 0 8482 0 true 34 1 8530 1 2098 #helpAboutScriptControl 8 '&About Script Control...' 1 1 0 0 0 8 '&Help' 0 1 0 0 39453 0 0 8 '' 0 1 0 0 0 0 0 0 0 0 19843 0 0 0 594 851 901 1 0 0 590598 ##(Smalltalk.Semaphore) 0 0 1 0 8 1997218624 914 138 144 34 3 978 #createAt:extent: 34 2 594 3839 21 594 951 1001 416 978 #text: 34 1 8 'Active-X Script Editor' 416 978 #updateMenuBar 2576 416 1106 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 90 9 0 0 254 1 0 0] 34 3 656 3648 1872 1168 0 27 )! !
!SimpleAXScriptEditor class categoriesFor: #defaultModel!constants!public! !
!SimpleAXScriptEditor class categoriesFor: #resource_Default_view!public!resources-views! !

