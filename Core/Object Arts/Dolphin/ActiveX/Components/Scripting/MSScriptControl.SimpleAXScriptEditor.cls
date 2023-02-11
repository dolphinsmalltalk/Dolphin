"Filed out from Dolphin Smalltalk"!

UI.Dialog subclass: #'MSScriptControl.SimpleAXScriptEditor'
	instanceVariableNames: 'scriptControl languagePresenter scriptPresenter expressionPresenter resultPresenter filename descriptionPresenter'
	classVariableNames: ''
	imports: #(#{UI})
	classInstanceVariableNames: ''
	classConstants: {}!
MSScriptControl.SimpleAXScriptEditor guid: (Core.GUID fromString: '{46f9c2fb-d025-11d3-93da-00a024ca708a}')!
MSScriptControl.SimpleAXScriptEditor comment: 'Simple editor for creating ActiveXScriptlets.'!
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

	MessageBox new
		headline: '<1s> Error <2d> on line <3d>'
					<< {self language. anIScriptError number. anIScriptError line};
		errorMsg: anIScriptError description!

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
		caption: 'Load Script…';
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
!MSScriptControl.SimpleAXScriptEditor categoriesForMethods!
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

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.DialogView} 34 30 nil nil 8 #(13369344 65536) 416 nil 1245702 #{Graphics.ThemeColor} #dialog nil 167 nil 852998 #{Graphics.Font} nil true 655622 #{OS.LOGFONT} 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 1 2 1 34 77 83 32 83 97 110 115 32 83 101 114 105 102 0 110 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 918022 #{Graphics.Point} 193 193 nil 416 984838 #{UI.BorderLayout} 1 1 410 #{UI.ContainerView} 34 15 nil 416 34 2 8 1140850688 131073 640 nil nil nil 7 nil nil nil 640 1048838 #{UI.FramingLayout} 170 176 34 4 410 #{UI.GroupBox} 34 14 nil 640 34 2 8 1140850695 65 768 nil nil nil 7 nil nil nil 768 nil 8 1815097472 1310982 #{Core.MessageSequence} 34 2 1049350 #{Core.MessageSend} #createAt:extent: 34 2 578 11 11 578 895 101 768 898 #text: 34 1 8 'Description' 768 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 196 1 0 0 55 0 0 0] 8 #() 578 193 193 nil 27 1378374 2 #{UI.FramingConstraints} 1377286 #{UI.FramingCalculation} #fixedParentLeft 1 1138 #fixedParentRight -3 1138 #fixedParentTop 1 1138 #fixedParentBottom 1 410 #{UI.TextEdit} 34 16 nil 640 34 2 8 1140916352 1025 1216 nil 917510 #{Graphics.Color} #default nil 7 nil nil nil 1216 nil 8 1815092992 1049094 #{UI.NullConverter} nil nil 9 850 34 1 898 #createAt:extent: 34 2 578 31 49 578 855 39 1216 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 24 0 0 0 186 1 0 0 43 0 0 0] 8 #() 1088 nil 27 1106 1152 21 1168 -23 1184 39 1200 -23 170 192 34 2 1216 8 'description' 1180166 #{Graphics.Rectangle} 578 11 11 578 11 11 850 34 1 898 #createAt:extent: 34 2 578 1 1 578 919 121 640 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 203 1 0 0 60 0 0 0] 34 2 1216 768 1088 nil 27 410 #{UI.ContainerView} 34 15 nil 416 34 2 8 1140850688 131073 1776 nil nil nil 7 nil nil nil 1776 706 170 176 34 8 410 #{UI.ReferenceView} 34 14 nil 1776 34 2 8 1140850688 131073 1888 nil nil nil 7 nil nil nil 1888 1376838 1 #{UI.ResourceIdentifier} #{UI.Presenter} #resource_OK_Cancel_button_block nil 850 34 1 898 #createAt:extent: 34 2 578 571 -3 578 335 71 1888 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 29 1 0 0 254 255 255 255 196 1 0 0 33 0 0 0] 8 #() 1088 nil 27 1106 1138 #fixedViewRight -333 1168 -13 1138 #fixedViewBottom -69 1200 -13 410 #{UI.StaticText} 34 16 nil 1776 34 2 8 1140850946 1 2176 nil nil nil 7 nil nil nil 2176 nil 8 1815137184 1330 nil nil nil 850 34 2 898 #createAt:extent: 34 2 578 21 17 578 111 45 2176 898 #text: 34 1 8 'Language:' 2176 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 8 0 0 0 65 0 0 0 30 0 0 0] 8 #() 1088 nil 27 1106 1152 21 1138 #fixedViewLeft 111 2160 -43 1200 -19 410 #{UI.ComboBox} 34 17 nil 1776 34 2 8 1144063490 1025 2496 787270 2 #{UI.ListModel} 138 144 2112 nil 1769478 #{Kernel.IdentitySearchPolicy} 1296 nil 7 nil nil nil 2496 nil 8 1814646992 786950 #{Core.Message} #displayString 2112 8 #() 201 850 34 1 898 #createAt:extent: 34 2 578 141 13 578 181 43 2496 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 70 0 0 0 6 0 0 0 160 0 0 0 27 0 0 0] 8 #() 1088 nil 27 1106 1138 #fixedPreviousRight 11 2480 181 1138 #fixedPreviousTop -3 1138 #fixedViewTop 43 410 #{UI.PushButton} 34 20 nil 1776 34 2 8 1140924416 1 2912 nil 1296 nil 7 nil nil nil 2912 nil 8 1815097472 1377606 4 #{UI.CommandDescription} #scriptParse 8 '&Parse' 1 1 nil nil false nil nil nil 850 34 3 898 #createAt:extent: 34 2 578 351 11 578 141 47 2912 898 #isEnabled: 8 #(false) 2912 898 #text: 34 1 8 '&Parse' 2912 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 175 0 0 0 5 0 0 0 245 0 0 0 28 0 0 0] 8 #() 1088 nil 29 1106 2864 31 2480 141 2880 -1 2896 47 170 192 34 2 2496 8 'Language' nil 850 34 1 898 #createAt:extent: 34 2 578 1 803 578 919 81 1776 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 145 1 0 0 203 1 0 0 185 1 0 0] 34 4 2176 2496 2912 1888 1088 nil 27 nil nil 410 #{UI.ContainerView} 34 15 nil 416 34 2 8 1140850688 131073 3472 nil nil nil 7 nil nil nil 3472 1376774 #{UI.ProportionalLayout} 170 176 34 4 410 #{UI.ContainerView} 34 15 nil 3472 34 2 8 1140850688 131073 3600 nil nil nil 7 nil nil nil 3600 706 170 176 34 4 410 #{UI.ContainerView} 34 15 nil 3600 34 2 8 1140850688 131073 3712 nil nil nil 7 nil nil nil 3712 610 11 11 nil nil nil nil 410 #{UI.Scintilla.ScintillaView} 34 52 nil 3712 34 2 8 1174475012 1025 3792 918598 2 #{UI.ValueHolder} nil false 1769478 #{Kernel.EqualitySearchPolicy} nil 1296 nil 7 nil nil nil 3792 nil 8 1395533126 1330 nil nil 9 nil 170 192 34 10 #indentGuide 1444934 1 #{UI.Scintilla.TextStyle} 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil #callTip 3986 77 1282 #gray 1282 #white 1 nil nil nil nil #callTip nil nil nil #whitespace 3986 3 nil nil 1 nil nil nil nil #whitespace nil nil nil #normal 3986 1 nil nil 1 nil nil nil nil #normal nil nil nil #lineNumber 3986 67 nil nil 1 nil nil nil nil #lineNumber nil nil nil nil 1507654 1 #{UI.Scintilla.NullStyler} #normal 170 192 34 2 #default 1903686 2 #{UI.Scintilla.MarkerDefinition} 1 nil nil nil 3792 #circle nil nil nil nil nil nil 138 #{Core.IdentitySet} 2112 nil 170 176 2112 9215 nil nil 170 176 34 2 81 1282 #windowText nil nil 2162950 #{UI.Scintilla.NullScintillaLibrary} nil 65 nil nil nil 8 '' 3 170 192 34 2 #container 3952 nil nil nil nil 16 nil 170 192 34 6 8 'indicator2' 1772614 4 #{UI.Scintilla.IndicatorStyle} 5 3792 1282 #red 1 3 nil nil nil nil nil nil nil 8 'indicator0' 4418 1 3792 1282 #commonGreen 3 3 nil nil nil nil nil nil nil 8 'indicator1' 4418 3 3792 1282 #blue 5 3 nil nil nil nil nil nil nil nil nil 170 192 34 6 #Error 3986 1031 1282 #firebrick 1282 #floralWhite 1 nil nil nil nil #Error nil nil nil #Notification 3986 1029 nil 1282 #gainsboro 1 nil nil nil nil #Notification nil nil nil #Warning 3986 1027 1282 #darkGoldenrod 1282 #ivory 1 nil nil nil nil #Warning nil nil nil nil nil nil 850 34 7 898 #createAt:extent: 34 2 578 11 11 578 855 399 3792 898 #text: 34 1 8 'function Do(x)
	Do = "Do " + x
end function' 3792 898 #wordWrap: 8 #(true) 3792 898 #margins: 34 1 34 3 1247302 3 #{UI.Scintilla.Margin} 1 3792 1 3 nil nil nil nil 4946 3 3792 33 nil nil 67108863 nil nil 4946 5 3792 1 nil nil nil nil nil 3792 898 #canHScroll: 8 #(false) 3792 898 #targetRange: 34 1 852742 #{Core.Interval} 3 91 3 3792 898 #maxCompletionListHeight: 8 #(9) 3792 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 176 1 0 0 204 0 0 0] 8 #() 1088 nil 35 170 192 34 2 3792 8 'ScriptText' 1570 578 11 11 578 11 11 850 34 1 898 #createAt:extent: 34 2 578 21 41 578 875 419 3712 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 20 0 0 0 191 1 0 0 229 0 0 0] 34 1 3792 1088 nil 27 1106 1152 11 1168 -13 1184 31 1200 -15 410 #{UI.GroupBox} 34 14 nil 3600 34 2 8 1140850695 65 5440 nil nil nil 7 nil nil nil 5440 nil 8 1815097472 850 34 2 898 #createAt:extent: 34 2 578 11 11 578 895 459 5440 898 #text: 34 1 8 'Procedures' 5440 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 196 1 0 0 234 0 0 0] 8 #() 1088 nil 27 1106 1152 1 1168 -3 1184 1 1200 -5 170 192 2112 1570 578 11 11 578 11 1 850 34 1 898 #createAt:extent: 34 2 578 1 209 578 919 475 3600 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 104 0 0 0 203 1 0 0 85 1 0 0] 34 2 5440 3712 1088 nil 27 8 2.5 410 #{UI.ContainerView} 34 15 nil 3472 34 2 8 1140850688 131073 5952 nil nil nil 7 nil nil nil 5952 706 170 176 34 10 410 #{UI.TextEdit} 34 16 nil 5952 34 2 8 1140916352 1025 6064 nil 4048 nil 7 nil nil nil 6064 nil 8 1815092992 1330 nil nil 1 850 34 2 898 #createAt:extent: 34 2 578 171 143 578 715 43 6064 898 #isEnabled: 8 #(false) 6064 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 85 0 0 0 71 0 0 0 186 1 0 0 92 0 0 0] 8 #() 1088 nil 27 1106 1152 161 1168 -23 2160 -41 1200 -13 410 #{UI.GroupBox} 34 14 nil 5952 34 2 8 1140850695 65 6352 nil nil nil 7 nil nil nil 6352 nil 8 1815097472 850 34 2 898 #createAt:extent: 34 2 578 11 11 578 895 199 6352 898 #text: 34 1 8 'Expression' 6352 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 196 1 0 0 104 0 0 0] 8 #() 1088 nil 27 1106 1152 1 1168 -3 1184 1 1200 11 410 #{UI.StaticText} 34 16 nil 5952 34 2 8 1140850946 1 6640 nil nil nil 7 nil nil nil 6640 nil 8 1815137184 1330 nil nil nil 850 34 2 898 #createAt:extent: 34 2 578 51 151 578 101 41 6640 898 #text: 34 1 8 'Result:' 6640 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 25 0 0 0 75 0 0 0 75 0 0 0 95 0 0 0] 8 #() 1088 nil 27 1106 1152 41 2480 101 2160 -39 1200 -7 410 #{UI.PushButton} 34 20 nil 5952 34 2 8 1140924416 1 6944 nil 1296 nil 7 nil nil nil 6944 nil 8 1815097472 2994 #scriptRun 8 '&Test' 1 1 nil nil false nil nil nil 850 34 3 898 #createAt:extent: 34 2 578 31 51 578 131 51 6944 898 #isEnabled: 8 #(false) 6944 898 #text: 34 1 8 '&Test' 6944 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 25 0 0 0 80 0 0 0 50 0 0 0] 8 #() 1088 nil 29 1106 1152 21 2480 131 1184 41 2896 51 410 #{UI.MultilineTextEdit} 34 16 nil 5952 34 2 8 1143017540 1025 7296 nil 1296 nil 7 nil nil nil 7296 nil 8 1815092992 1330 nil nil 9 850 34 1 898 #createAt:extent: 34 2 578 171 41 578 715 79 7296 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 85 0 0 0 20 0 0 0 186 1 0 0 59 0 0 0] 8 #() 1088 nil 27 1106 1152 161 1168 -23 1184 31 1200 -79 170 192 34 4 6064 8 'Result' 7296 8 'Expression' 1570 578 11 11 578 11 11 850 34 1 898 #createAt:extent: 34 2 578 1 1 578 919 209 5952 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 203 1 0 0 104 0 0 0] 34 5 7296 6944 6640 6064 6352 1088 nil 27 8 1.1 true 170 192 2112 nil 850 34 1 898 #createAt:extent: 34 2 578 1 121 578 919 683 3472 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 60 0 0 0 203 1 0 0 145 1 0 0] 34 2 5952 3600 1088 nil 27 170 192 2112 nil 658246 4 #{UI.MenuBar} nil true 34 4 461638 4 #{UI.Menu} nil true 34 3 1180742 2 #{UI.CommandMenuItem} 1 2994 #fileOpen 8 '&Open…' 9375 1 nil nil nil 8098 1 2994 #fileSave 8 '&Save' 9383 1 nil nil nil 8098 1 2994 #fileSaveAs 8 'Save &As…' 1 1 nil nil nil 8 '&File' nil 1 nil nil 13645 nil nil 8050 nil true 34 11 8098 1 2994 #undo 8 '&Undo' 9397 1 nil nil nil 1179974 1 #{UI.DividerMenuItem} 4097 8098 1 2994 #cutSelection 8 'Cu&t' 9393 1 nil nil nil 8098 1 2994 #copySelection 8 '&Copy' 9351 1 nil nil nil 8098 1 2994 #pasteClipboard 8 '&Paste' 9389 1 nil nil nil 8098 1 2994 #clearSelection 8 '&Delete' 1 1 nil nil nil 8098 1 2994 #selectAll 8 'Select &All' 9347 1 nil nil nil 8368 8098 1 2994 #find 8 '&Find…' 9357 1 852806 4 #{Graphics.Icon} nil true 2425862 #{Graphics.ImageFromResourceInitializer} 47 983302 #{OS.ShellLibrary} 65541 nil nil nil 8098 1 2994 #findNext 8 'Find &Next' 1253 1 nil nil nil 8098 1 2994 #findReplace 8 '&Replace…' 9361 1 nil nil nil 8 '&Edit' nil 1 nil nil 13807 nil nil 8050 nil true 34 2 8098 1 2994 #scriptParse 8 '&Parse' 1 1 nil nil nil 8098 1 2994 #scriptRun 8 '&Test' 1 1 nil nil nil 8 '&Script' nil 1 nil nil 13837 nil nil 8050 nil true 34 1 8098 1 2994 #helpAboutScriptControl 8 '&About Script Control…' 1 1 nil nil nil 8 '&Help' nil 1 nil nil 13841 nil nil 8 '' nil 1 nil nil nil nil nil nil nil nil 43563 nil nil nil 578 851 901 1 nil nil 918278 #{Core.Semaphore} nil nil 1 nil 8 2004646672 850 34 2 898 #createAt:extent: 34 2 578 12287 21 578 951 1001 416 898 #text: 34 1 8 'Active-X Script Editor' 416 1026 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 218 25 0 0 254 1 0 0] 34 3 640 3472 1776 1088 nil 27)! !
!MSScriptControl.SimpleAXScriptEditor class categoriesForMethods!
defaultModel!constants!public! !
resource_Default_view!public!resources-views! !
!

