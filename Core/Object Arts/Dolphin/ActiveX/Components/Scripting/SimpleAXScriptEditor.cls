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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 30 nil nil 8 #(13369344 65536) 416 nil 786950 ##(Smalltalk.ThemeColor) #dialog nil 167 nil 263174 ##(Smalltalk.Font) nil true 459014 ##(Smalltalk.LOGFONT) 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 1 2 1 34 77 83 32 83 97 110 115 32 83 101 114 105 102 0 110 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 640 nil nil nil 7 nil nil nil 640 852230 ##(Smalltalk.FramingLayout) 170 176 34 4 410 ##(Smalltalk.TextEdit) 34 16 nil 640 34 2 8 1140916352 1025 768 nil 524550 ##(Smalltalk.ColorRef) 8 4278190080 nil 7 nil nil nil 768 nil 8 1912718128 852486 ##(Smalltalk.NullConverter) nil nil 9 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 578 31 49 578 855 39 768 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 24 0 0 0 186 1 0 0 43 0 0 0] 8 #() 578 193 193 nil 27 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedParentLeft 21 1186 #fixedParentRight -23 1186 #fixedParentTop 39 1186 #fixedParentBottom -23 410 ##(Smalltalk.GroupBox) 34 14 nil 640 34 2 8 1140850695 65 1264 nil nil nil 7 nil nil nil 1264 nil 8 1912725136 930 138 144 34 2 994 #createAt:extent: 34 2 578 11 11 578 895 101 1264 994 #text: 34 1 8 'Description' 1264 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 196 1 0 0 55 0 0 0] 8 #() 1136 nil 27 1154 1200 1 1216 -3 1232 1 1248 1 170 192 34 2 768 8 'description' 590342 ##(Smalltalk.Rectangle) 578 11 11 578 11 11 930 138 144 34 1 994 #createAt:extent: 34 2 578 1 1 578 919 121 640 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 203 1 0 0 60 0 0 0] 34 2 768 1264 1136 nil 27 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 1840 nil nil nil 7 nil nil nil 1840 706 170 176 34 8 410 ##(Smalltalk.StaticText) 34 16 nil 1840 34 2 8 1140850946 1 1952 nil nil nil 7 nil nil nil 1952 nil 8 1912674480 898 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 21 17 578 111 45 1952 994 #text: 34 1 8 'Language:' 1952 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 8 0 0 0 65 0 0 0 30 0 0 0] 8 #() 1136 nil 27 1154 1200 21 1186 #fixedViewLeft 111 1186 #fixedViewBottom -43 1248 -19 410 ##(Smalltalk.ComboBox) 34 17 nil 1840 34 2 8 1144063490 1025 2304 590662 2 ##(Smalltalk.ListModel) 138 144 8 #() nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 834 864 nil 7 nil nil nil 2304 nil 8 1912552560 ##(Smalltalk.BasicListAbstract) 2416 201 930 138 144 34 1 994 #createAt:extent: 34 2 578 141 13 578 181 43 2304 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 70 0 0 0 6 0 0 0 160 0 0 0 27 0 0 0] 8 #() 1136 nil 27 1154 1186 #fixedPreviousRight 11 2272 181 1186 #fixedPreviousTop -3 1186 #fixedViewTop 43 410 ##(Smalltalk.ReferenceView) 34 14 nil 1840 34 2 8 1140850688 131073 2720 nil nil nil 7 nil nil nil 2720 1180166 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Presenter) #resource_OK_Cancel_button_block nil 930 138 144 34 1 994 #createAt:extent: 34 2 578 571 -3 578 335 71 2720 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 29 1 0 0 254 255 255 255 196 1 0 0 33 0 0 0] 2416 1136 nil 27 1154 1186 #fixedViewRight -333 1216 -13 2288 -69 1248 -13 410 ##(Smalltalk.PushButton) 34 20 nil 1840 34 2 8 1140924416 1 2992 nil 834 864 nil 7 nil nil nil 2992 nil 8 1912725136 1180998 4 ##(Smalltalk.CommandDescription) #scriptParse 8 '&Parse' 1 1 nil nil false nil nil nil 930 138 144 34 3 994 #createAt:extent: 34 2 578 351 11 578 141 47 2992 994 #isEnabled: 8 #(false) 2992 994 #text: 34 1 8 '&Parse' 2992 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 175 0 0 0 5 0 0 0 245 0 0 0 28 0 0 0] 8 #() 1136 nil 29 1154 2672 31 2272 141 2688 -1 2704 47 170 192 34 2 2304 8 'Language' nil 930 138 144 34 1 994 #createAt:extent: 34 2 578 1 803 578 919 81 1840 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 145 1 0 0 203 1 0 0 185 1 0 0] 34 4 1952 2304 2992 2720 1136 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 3600 nil nil nil 7 nil nil nil 3600 1180166 ##(Smalltalk.ProportionalLayout) 170 176 34 4 410 ##(Smalltalk.ContainerView) 34 15 nil 3600 34 2 8 1140850688 131073 3728 nil nil nil 7 nil nil nil 3728 706 170 176 34 10 410 ##(Smalltalk.TextEdit) 34 16 nil 3728 34 2 8 1140916352 1025 3840 nil 196934 1 ##(Smalltalk.RGB) 33554431 nil 7 nil nil nil 3840 nil 8 1912718128 898 nil nil 1 930 138 144 34 2 994 #createAt:extent: 34 2 578 171 143 578 715 43 3840 994 #isEnabled: 8 #(false) 3840 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 85 0 0 0 71 0 0 0 186 1 0 0 92 0 0 0] 8 #() 1136 nil 27 1154 1200 161 1216 -23 2288 -41 1248 -13 410 ##(Smalltalk.PushButton) 34 20 nil 3728 34 2 8 1140924416 1 4176 nil 834 864 nil 7 nil nil nil 4176 nil 8 1912725136 3090 #scriptRun 8 '&Test' 1 1 nil nil false nil nil nil 930 138 144 34 3 994 #createAt:extent: 34 2 578 31 51 578 131 51 4176 994 #isEnabled: 8 #(false) 4176 994 #text: 34 1 8 '&Test' 4176 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 25 0 0 0 80 0 0 0 50 0 0 0] 8 #() 1136 nil 29 1154 1200 21 2272 131 1232 41 2704 51 410 ##(Smalltalk.MultilineTextEdit) 34 16 nil 3728 34 2 8 1143017540 1025 4560 nil 834 864 nil 7 nil nil nil 4560 nil 8 1912718128 898 nil nil 9 930 138 144 34 1 994 #createAt:extent: 34 2 578 171 41 578 715 79 4560 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 85 0 0 0 20 0 0 0 186 1 0 0 59 0 0 0] 8 #() 1136 nil 27 1154 1200 161 1216 -23 1232 31 1248 -79 410 ##(Smalltalk.GroupBox) 34 14 nil 3728 34 2 8 1140850695 65 4848 nil nil nil 7 nil nil nil 4848 nil 8 1912725136 930 138 144 34 2 994 #createAt:extent: 34 2 578 11 11 578 895 199 4848 994 #text: 34 1 8 'Expression' 4848 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 196 1 0 0 104 0 0 0] 8 #() 1136 nil 27 1154 1200 1 1216 -3 1232 1 1248 11 410 ##(Smalltalk.StaticText) 34 16 nil 3728 34 2 8 1140850946 1 5152 nil nil nil 7 nil nil nil 5152 nil 8 1912674480 898 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 51 151 578 101 41 5152 994 #text: 34 1 8 'Result:' 5152 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 25 0 0 0 75 0 0 0 75 0 0 0 95 0 0 0] 8 #() 1136 nil 27 1154 1200 41 2272 101 2288 -39 1248 -7 170 192 34 4 3840 8 'Result' 4560 8 'Expression' 1618 578 11 11 578 11 11 930 138 144 34 1 994 #createAt:extent: 34 2 578 1 1 578 919 209 3728 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 203 1 0 0 104 0 0 0] 34 5 4560 4176 5152 3840 4848 1136 nil 27 327734 ##(Smalltalk.Float) 8 154 153 153 153 153 153 241 63 410 ##(Smalltalk.ContainerView) 34 15 nil 3600 34 2 8 1140850688 131073 5776 nil nil nil 7 nil nil nil 5776 706 170 176 34 4 410 ##(Smalltalk.GroupBox) 34 14 nil 5776 34 2 8 1140850695 65 5888 nil nil nil 7 nil nil nil 5888 nil 8 1912725136 930 138 144 34 2 994 #createAt:extent: 34 2 578 11 11 578 895 459 5888 994 #text: 34 1 8 'Procedures' 5888 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 196 1 0 0 234 0 0 0] 8 #() 1136 nil 27 1154 1200 1 1216 -3 1232 1 1248 -5 410 ##(Smalltalk.ContainerView) 34 15 nil 5776 34 2 8 1140850688 131073 6192 nil nil nil 7 nil nil nil 6192 610 11 11 nil nil nil nil 410 ##(Smalltalk.ScintillaView) 34 50 nil 6192 34 2 8 1174475012 1025 6272 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil 834 864 nil 7 nil nil nil 6272 nil 8 1893518953 898 nil nil 9 nil 170 192 34 10 #callTip 1182790 1 ##(Smalltalk.ScintillaTextStyle) 77 786694 ##(Smalltalk.IndexedColor) 33554457 6514 33554471 1 nil nil nil nil #callTip nil nil nil #whitespace 6482 3 nil nil 1 nil nil nil nil #whitespace nil nil nil #lineNumber 6482 67 nil nil 1 nil nil nil nil #lineNumber nil nil nil #normal 6482 1 nil nil 1 nil nil nil nil #normal nil nil nil #indentGuide 6482 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil 34 40 6592 6560 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 6576 nil nil nil 6608 nil nil 1245510 1 ##(Smalltalk.NullScintillaStyler) #normal 170 192 34 2 #default 1641542 1 ##(Smalltalk.ScintillaMarkerDefinition) 1 nil nil nil 6272 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 2416 nil 170 176 2416 9215 nil nil nil nil 6514 33554447 nil nil 65 nil nil nil 8 '' 3 170 192 34 2 #container 6448 nil nil nil nil 1 nil 170 192 34 6 8 'indicator1' 1510470 2 ##(Smalltalk.ScintillaIndicatorStyle) 3 6272 33423361 5 nil nil nil nil nil nil nil nil 8 'indicator2' 6882 5 6272 511 1 nil nil nil nil nil nil nil nil 8 'indicator0' 6882 1 6272 65025 3 nil nil nil nil nil nil nil nil nil nil 170 192 34 6 #Warning 6482 1029 3906 60239 3906 31326207 1 nil nil nil nil #Warning nil nil nil #Error 6482 1031 3906 335 3906 31317503 1 nil nil nil nil #Error nil nil nil #Notification 6482 1027 nil 3906 31185883 1 nil nil nil nil #Notification nil nil nil nil 930 138 144 34 9 994 #createAt:extent: 34 2 578 11 11 578 855 399 6272 994 #text: 34 1 8 'function Do(x)
	Do = "Do " + x
end function' 6272 994 #textLimit: 8 #(1073741823) 6272 994 #modificationEventMask: 8 #(4607) 6272 994 #caretPeriod: 8 #(530) 6272 994 #wordWrap: 8 #(true) 6272 994 #margins: 34 1 34 3 985158 2 ##(Smalltalk.ScintillaMargin) 1 6272 1 3 nil nil nil nil 7474 3 6272 33 nil nil 67108863 nil nil 7474 5 6272 1 nil nil nil nil nil 6272 994 #canHScroll: 8 #(false) 6272 994 #maxCompletionListHeight: 8 #(9) 6272 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 176 1 0 0 204 0 0 0] 8 #() 1136 nil 29 170 192 34 2 6272 8 'ScriptText' 1618 578 11 11 578 11 11 930 138 144 34 1 994 #createAt:extent: 34 2 578 21 41 578 875 419 6192 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 20 0 0 0 191 1 0 0 229 0 0 0] 34 1 6272 1136 nil 27 1154 1200 11 1216 -13 1232 31 1248 -15 170 192 2416 1618 578 11 11 578 11 1 930 138 144 34 1 994 #createAt:extent: 34 2 578 1 209 578 919 475 5776 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 104 0 0 0 203 1 0 0 85 1 0 0] 34 2 5888 6192 1136 nil 27 5746 8 0 0 0 0 0 0 4 64 true 170 192 2416 nil 930 138 144 34 1 994 #createAt:extent: 34 2 578 1 121 578 919 683 3600 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 60 0 0 0 203 1 0 0 145 1 0 0] 34 2 3728 5776 1136 nil 27 170 192 2416 nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 4 265030 4 ##(Smalltalk.Menu) nil true 34 3 984134 2 ##(Smalltalk.CommandMenuItem) 1 3090 #fileOpen 8 '&Open...' 9375 1 nil nil nil 8450 1 3090 #fileSave 8 '&Save' 9383 1 nil nil nil 8450 1 3090 #fileSaveAs 8 'Save &As...' 1 1 nil nil nil 8 '&File' nil 1 nil nil 26251 nil nil 8402 nil true 34 11 8450 1 3090 #undo 8 '&Undo' 9397 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 8450 1 3090 #cutSelection 8 'Cu&t' 9393 1 nil nil nil 8450 1 3090 #copySelection 8 '&Copy' 9351 1 nil nil nil 8450 1 3090 #pasteClipboard 8 '&Paste' 9389 1 nil nil nil 8450 1 3090 #clearSelection 8 '&Delete' 1 1 nil nil nil 8450 1 3090 #selectAll 8 'Select &All' 9347 1 nil nil nil 8720 8450 1 3090 #find 8 '&Find...' 9357 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 47 786694 ##(Smalltalk.ShellLibrary) nil nil 8450 1 3090 #findNext 8 'Find &Next' 1253 1 nil nil nil 8450 1 3090 #findReplace 8 '&Replace...' 9361 1 nil nil nil 8 '&Edit' nil 1 nil nil 26271 nil nil 8402 nil true 34 2 8450 1 3090 #scriptParse 8 '&Parse' 1 1 nil nil nil 8450 1 3090 #scriptRun 8 '&Test' 1 1 nil nil nil 8 '&Script' nil 1 nil nil 26277 nil nil 8402 nil true 34 1 8450 1 3090 #helpAboutScriptControl 8 '&About Script Control...' 1 1 nil nil nil 8 '&Help' nil 1 nil nil 26281 nil nil 8 '' nil 1 nil nil nil nil nil nil nil nil 33737 nil nil nil 578 851 901 1 nil nil 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 2007257760 930 138 144 34 3 994 #createAt:extent: 34 2 578 3839 21 578 951 1001 416 994 #text: 34 1 8 'Active-X Script Editor' 416 994 #updateMenuBar 2416 416 1074 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 90 9 0 0 254 1 0 0] 34 3 640 3600 1840 1136 nil 27)! !
!SimpleAXScriptEditor class categoriesFor: #defaultModel!constants!public! !
!SimpleAXScriptEditor class categoriesFor: #resource_Default_view!public!resources-views! !

