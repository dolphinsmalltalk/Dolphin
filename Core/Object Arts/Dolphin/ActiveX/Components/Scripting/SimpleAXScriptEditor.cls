"Filed out from Dolphin Smalltalk"!

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

!SimpleAXScriptEditor categoriesForMethods!
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
defaultFileExtension!constants!public! !
defaultLanguage!initializing!public! !
displayScriptError:!commands!private! !
expressionText!accessing!public! !
fileNew!commands!public! !
fileOpen!commands!public! !
fileSave!commands!public! !
fileSaveAs!commands!public! !
helpAboutScriptControl!commands!public! !
initialize!initializing!private! !
language!accessing!public! !
language:!accessing!public! !
languages!initializing!public! !
model:!accessing!public! !
newScript!commands!private! !
onLanguageChanged!event handling!private! !
onViewOpened!event handling!public! !
saveScriptToFile!commands!private! !
scriptFileTypes!constants!public! !
scriptParse!commands!public! !
scriptRun!commands!public! !
scriptText!accessing!public! !
scriptText:!accessing!public! !
!

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

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 34 nil nil 8 #(13369344 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #dialog nil 133 nil 263494 1 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 1 2 1 0 77 0 83 0 32 0 83 0 97 0 110 0 115 0 32 0 83 0 101 0 114 0 105 0 102 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 608 nil nil nil 5 nil nil nil 608 852230 ##(Smalltalk.FramingLayout) 170 176 34 4 410 ##(Smalltalk.GroupBox) 34 14 nil 608 34 2 8 1140850695 65 736 nil nil nil 5 nil nil nil 736 nil 8 1759007584 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[5 0 0 0 5 0 0 0 196 1 0 0 55 0 0 0] 193 768 8 'Description' 736 3 8 #() 328198 ##(Smalltalk.Point) 193 193 nil 27 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedParentLeft 1 1106 #fixedParentRight -3 1106 #fixedParentTop 1 1106 #fixedParentBottom 1 410 ##(Smalltalk.TextEdit) 34 16 nil 608 34 2 8 1140916352 1025 1184 nil 327686 ##(Smalltalk.Color) #default nil 5 nil nil nil 1184 nil 8 1759000288 852486 ##(Smalltalk.NullConverter) nil nil 9 818 138 144 34 1 882 #createWindow: 34 1 930 962 8 #[15 0 0 0 24 0 0 0 186 1 0 0 43 0 0 0] 193 1216 nil 1184 3 8 #() 1042 193 193 nil 27 1074 1120 21 1136 -23 1152 39 1168 -23 170 192 34 2 1184 8 'description' 590342 ##(Smalltalk.Rectangle) 1042 11 11 1042 11 11 818 138 144 34 1 882 #createWindow: 34 1 930 962 8 #[0 0 0 0 0 0 0 0 203 1 0 0 60 0 0 0] 193 640 8 '' 608 3 34 2 1184 736 1042 193 193 nil 27 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 1792 nil nil nil 5 nil nil nil 1792 674 170 176 34 8 410 ##(Smalltalk.PushButton) 34 20 nil 1792 34 2 8 1140924416 1 1904 nil 1264 nil 5 nil nil nil 1904 nil 8 1759007584 1180998 4 ##(Smalltalk.CommandDescription) #scriptParse 8 '&Parse' 1 1 nil nil false nil nil nil 818 138 144 34 2 882 #createWindow: 34 1 930 962 8 #[175 0 0 0 5 0 0 0 245 0 0 0 28 0 0 0] 193 1936 8 '&Parse' 1904 882 #isEnabled: 8 #(false) 1904 3 8 #() 1042 193 193 nil 29 1074 1106 #fixedPreviousRight 31 1106 #fixedViewLeft 141 1106 #fixedPreviousTop -1 1106 #fixedViewTop 47 410 ##(Smalltalk.StaticText) 34 16 nil 1792 34 2 8 1140850946 1 2320 nil nil nil 5 nil nil nil 2320 nil 8 1759212608 1298 nil nil nil 818 138 144 34 2 882 #createWindow: 34 1 930 962 8 #[10 0 0 0 8 0 0 0 65 0 0 0 30 0 0 0] 193 2352 nil 2320 882 #text: 34 1 8 'Language:' 2320 3 8 #() 1042 193 193 nil 27 1074 1120 21 2272 111 1106 #fixedViewBottom -43 1168 -19 410 ##(Smalltalk.ReferenceView) 34 14 nil 1792 34 2 8 1140850688 131073 2656 nil nil nil 5 nil nil nil 2656 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Presenter) #resource_OK_Cancel_button_block nil 818 138 144 34 1 882 #createWindow: 34 1 930 962 8 #[29 1 0 0 254 255 255 255 196 1 0 0 33 0 0 0] 193 2688 8 '' 2656 3 8 #() 1042 193 193 nil 27 1074 1106 #fixedViewRight -333 1136 -13 2640 -69 1168 -13 410 ##(Smalltalk.ComboBox) 34 17 nil 1792 34 2 8 1144063490 1025 2960 590662 2 ##(Smalltalk.ListModel) 138 144 2896 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 1264 nil 5 nil nil nil 2960 nil 8 1758616864 ##(Smalltalk.BasicListAbstract) 8 #() 201 818 138 144 34 1 882 #createWindow: 34 1 930 962 8 #[70 0 0 0 6 0 0 0 160 0 0 0 124 0 0 0] 193 2992 8 '' 2960 3 8 #() 1042 193 193 nil 27 1074 2256 11 2272 181 2288 -3 2304 43 170 192 34 2 2960 8 'Language' nil 818 138 144 34 1 882 #createWindow: 34 1 930 962 8 #[0 0 0 0 145 1 0 0 203 1 0 0 185 1 0 0] 193 1824 8 '' 1792 3 34 4 2320 2960 1904 2656 1042 193 193 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 3552 nil nil nil 5 nil nil nil 3552 1180166 ##(Smalltalk.ProportionalLayout) 170 176 34 4 410 ##(Smalltalk.ContainerView) 34 15 nil 3552 34 2 8 1140850688 131073 3680 nil nil nil 5 nil nil nil 3680 674 170 176 34 10 410 ##(Smalltalk.StaticText) 34 16 nil 3680 34 2 8 1140850946 1 3792 nil nil nil 5 nil nil nil 3792 nil 8 1759212608 1298 nil nil nil 818 138 144 34 2 882 #createWindow: 34 1 930 962 8 #[25 0 0 0 75 0 0 0 75 0 0 0 95 0 0 0] 193 3824 nil 3792 882 #text: 34 1 8 'Result:' 3792 3 8 #() 1042 193 193 nil 27 1074 1120 41 2272 101 2640 -39 1168 -7 410 ##(Smalltalk.PushButton) 34 20 nil 3680 34 2 8 1140924416 1 4112 nil 1264 nil 5 nil nil nil 4112 nil 8 1759007584 1986 #scriptRun 8 '&Test' 1 1 nil nil false nil nil nil 818 138 144 34 2 882 #createWindow: 34 1 930 962 8 #[15 0 0 0 25 0 0 0 80 0 0 0 50 0 0 0] 193 4144 8 '&Test' 4112 882 #isEnabled: 8 #(false) 4112 3 8 #() 1042 193 193 nil 29 1074 1120 21 2272 131 1152 41 2304 51 410 ##(Smalltalk.GroupBox) 34 14 nil 3680 34 2 8 1140850695 65 4448 nil nil nil 5 nil nil nil 4448 nil 8 1759007584 818 138 144 34 1 882 #createWindow: 34 1 930 962 8 #[5 0 0 0 5 0 0 0 196 1 0 0 104 0 0 0] 193 4480 8 'Expression' 4448 3 8 #() 1042 193 193 nil 27 1074 1120 1 1136 -3 1152 1 1168 11 410 ##(Smalltalk.TextEdit) 34 16 nil 3680 34 2 8 1140916352 1025 4720 nil 1250 #white nil 5 nil nil nil 4720 nil 8 1759000288 1298 nil nil 1 818 138 144 34 2 882 #createWindow: 34 1 930 962 8 #[85 0 0 0 71 0 0 0 186 1 0 0 92 0 0 0] 193 4752 nil 4720 882 #isEnabled: 8 #(false) 4720 3 8 #() 1042 193 193 nil 27 1074 1120 161 1136 -23 2640 -41 1168 -13 410 ##(Smalltalk.MultilineTextEdit) 34 16 nil 3680 34 2 8 1143017540 1025 5040 nil 1264 nil 5 nil nil nil 5040 nil 8 1759000288 1298 nil nil 9 818 138 144 34 1 882 #createWindow: 34 1 930 962 8 #[85 0 0 0 20 0 0 0 186 1 0 0 59 0 0 0] 193 5072 nil 5040 3 8 #() 1042 193 193 nil 27 1074 1120 161 1136 -23 1152 31 1168 -79 170 192 34 4 5040 8 'Expression' 4720 8 'Result' 1554 1042 11 11 1042 11 11 818 138 144 34 1 882 #createWindow: 34 1 930 962 8 #[0 0 0 0 0 0 0 0 203 1 0 0 104 0 0 0] 193 3712 8 '' 3680 3 34 5 5040 4112 3792 4720 4448 1042 193 193 nil 27 327734 ##(Smalltalk.Float) 8 154 153 153 153 153 153 241 63 410 ##(Smalltalk.ContainerView) 34 15 nil 3552 34 2 8 1140850688 131073 5632 nil nil nil 5 nil nil nil 5632 674 170 176 34 4 410 ##(Smalltalk.GroupBox) 34 14 nil 5632 34 2 8 1140850695 65 5744 nil nil nil 5 nil nil nil 5744 nil 8 1759007584 818 138 144 34 1 882 #createWindow: 34 1 930 962 8 #[5 0 0 0 5 0 0 0 196 1 0 0 234 0 0 0] 193 5776 8 'Procedures' 5744 3 8 #() 1042 193 193 nil 27 1074 1120 1 1136 -3 1152 1 1168 -5 410 ##(Smalltalk.ContainerView) 34 15 nil 5632 34 2 8 1140850688 131073 6016 nil nil nil 5 nil nil nil 6016 578 11 11 nil nil nil nil 410 ##(Smalltalk.ScintillaView) 34 65 nil 6016 34 2 8 1174475012 1025 6096 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil 1264 nil 5 nil nil nil 6096 nil 8 1504001512 1298 nil nil 9 68776273 170 192 34 10 #indentGuide 1182790 1 ##(Smalltalk.ScintillaTextStyle) 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil #lineNumber 6290 67 nil nil 1 nil nil nil nil #lineNumber nil nil nil #normal 6290 1 nil nil 1 nil nil nil nil #normal nil nil nil #callTip 6290 77 1250 #gray 4784 1 nil nil nil nil #callTip nil nil nil #whitespace 6290 3 nil nil 1 nil nil nil nil #whitespace nil nil nil nil 1245510 1 ##(Smalltalk.NullScintillaStyler) #normal 170 192 34 2 #default 1641542 2 ##(Smalltalk.ScintillaMarkerDefinition) 1 nil nil nil 6096 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 2896 nil 170 176 2896 9215 nil nil nil nil 1250 #silver nil nil 65 nil nil nil 8 '' 3 170 192 34 2 #container 6256 nil nil nil nil 16 nil 170 192 34 6 8 'indicator0' 1510470 3 ##(Smalltalk.ScintillaIndicatorStyle) 1 6096 1250 #commonGreen 3 nil nil nil nil nil nil nil nil 8 'indicator2' 6642 5 6096 1250 #red 1 nil nil nil nil nil nil nil nil 8 'indicator1' 6642 3 6096 1250 #blue 5 nil nil nil nil nil nil nil nil nil nil 170 192 34 6 #Warning 6290 1027 1250 #darkGoldenrod 1250 #ivory 1 nil nil nil nil #Warning nil nil nil #Error 6290 1031 1250 #firebrick 1250 #floralWhite 1 nil nil nil nil #Error nil nil nil #Notification 6290 1029 nil 1250 #gainsboro 1 nil nil nil nil #Notification nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 818 138 144 34 9 882 #createWindow: 34 1 930 962 8 #[5 0 0 0 5 0 0 0 176 1 0 0 204 0 0 0] 193 6128 nil 6096 882 #text: 34 1 8 'function Do(x)
	Do = "Do " + x
end function' 6096 882 #caretPeriod: 8 #(530) 6096 882 #wordWrap: 8 #(true) 6096 882 #margins: 34 1 34 3 985158 3 ##(Smalltalk.ScintillaMargin) 1 6096 1 3 nil nil nil nil 7234 3 6096 33 nil nil 67108863 nil nil 7234 5 6096 1 nil nil nil nil nil 6096 882 #canHScroll: 8 #(false) 6096 882 #targetRange: 34 1 525062 ##(Smalltalk.Interval) 3 91 3 6096 882 #maxCompletionListHeight: 8 #(9) 6096 882 #edgeColumn: 8 #(1) 6096 3 8 #() 1042 193 193 nil 33 170 192 34 2 6096 8 'ScriptText' 1554 1042 11 11 1042 11 11 818 138 144 34 1 882 #createWindow: 34 1 930 962 8 #[10 0 0 0 20 0 0 0 191 1 0 0 229 0 0 0] 193 6048 8 '' 6016 3 34 1 6096 1042 193 193 nil 27 1074 1120 11 1136 -13 1152 31 1168 -15 170 192 2896 1554 1042 11 11 1042 11 1 818 138 144 34 1 882 #createWindow: 34 1 930 962 8 #[0 0 0 0 104 0 0 0 203 1 0 0 85 1 0 0] 193 5664 8 '' 5632 3 34 2 5744 6016 1042 193 193 nil 27 5602 8 0 0 0 0 0 0 4 64 true 170 192 2896 nil 818 138 144 34 1 882 #createWindow: 34 1 930 962 8 #[0 0 0 0 60 0 0 0 203 1 0 0 145 1 0 0] 193 3584 8 '' 3552 3 34 2 3680 5632 1042 193 193 nil 27 170 192 2896 nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 4 265030 4 ##(Smalltalk.Menu) nil true 34 3 984134 2 ##(Smalltalk.CommandMenuItem) 1 1986 #fileOpen 8 '&Open...' 9375 1 nil nil nil 8338 1 1986 #fileSave 8 '&Save' 9383 1 nil nil nil 8338 1 1986 #fileSaveAs 8 'Save &As...' 1 1 nil nil nil 8 '&File' nil 1 nil nil 14841 nil nil 8290 nil true 34 11 8338 1 1986 #undo 8 '&Undo' 9397 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 8338 1 1986 #cutSelection 8 'Cu&t' 9393 1 nil nil nil 8338 1 1986 #copySelection 8 '&Copy' 9351 1 nil nil nil 8338 1 1986 #pasteClipboard 8 '&Paste' 9389 1 nil nil nil 8338 1 1986 #clearSelection 8 '&Delete' 1 1 nil nil nil 8338 1 1986 #selectAll 8 'Select &All' 9347 1 nil nil nil 8608 8338 1 1986 #find 8 '&Find...' 9357 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 47 786694 ##(Smalltalk.ShellLibrary) nil nil 8338 1 1986 #findNext 8 'Find &Next' 1253 1 nil nil nil 8338 1 1986 #findReplace 8 '&Replace...' 9361 1 nil nil nil 8 '&Edit' nil 1 nil nil 14861 nil nil 8290 nil true 34 2 8338 1 1986 #scriptParse 8 '&Parse' 1 1 nil nil nil 8338 1 1986 #scriptRun 8 '&Test' 1 1 nil nil nil 8 '&Script' nil 1 nil nil 14867 nil nil 8290 nil true 34 1 8338 1 1986 #helpAboutScriptControl 8 '&About Script Control...' 1 1 nil nil nil 8 '&Help' nil 1 nil nil 14871 nil nil 8 '' nil 1 nil nil nil nil nil nil nil nil 13237 nil nil nil 1042 851 901 1 nil 193 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 2006356512 nil nil nil nil 818 138 144 34 2 882 #createWindow: 34 1 786950 ##(Smalltalk.CreateDialog) 1554 1042 1 1 1042 951 1001 193 416 882 #setWindowText: 34 1 8 'Active-X Script Editor' 416 1 34 3 608 3552 1792 1042 193 193 nil 29 )! !

!SimpleAXScriptEditor class categoriesForMethods!
defaultModel!constants!public! !
resource_Default_view!public!resources-views! !
!

