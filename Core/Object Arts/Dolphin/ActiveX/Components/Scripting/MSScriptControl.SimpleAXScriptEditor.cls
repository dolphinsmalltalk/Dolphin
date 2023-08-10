"Filed out from Dolphin Smalltalk"!

UI.Dialog
	subclass: #'MSScriptControl.SimpleAXScriptEditor'
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

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 30 nil nil 8 #(13369344 65536) 32 nil 518 #{Graphics.ThemeColor} #dialog nil 135 nil 1030 #{Graphics.Font} nil true 262 #{OS.LOGFONT} 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 1 2 1 34 77 83 32 83 97 110 115 32 83 101 114 105 102 0 110 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 518 #{Graphics.Point} 193 193 nil 32 1798 #{UI.BorderLayout} 1 1 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 272 nil nil nil 7 nil nil nil 272 262 #{UI.FramingLayout} 550 #{Core.LookupTable} 2 18 #{UI.GroupBox} 50 14 nil 272 50 2 8 1140850695 65 400 nil nil nil 7 nil nil nil 400 nil 8 1853182784 262 #{Core.MessageSequence} 50 2 774 #{Core.MessageSend} #createAt:extent: 50 2 210 11 11 210 895 101 400 530 #text: 50 1 8 'Description' 400 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 196 1 0 0 55 0 0 0] 8 #() 210 193 193 nil 27 2118 2 #{UI.FramingConstraints} 1030 #{UI.FramingCalculation} #fixedParentLeft 1 770 #fixedParentRight -3 770 #fixedParentTop 1 770 #fixedParentBottom 1 18 #{UI.TextEdit} 50 20 nil 272 50 2 8 1140916352 1025 848 nil 6 #{Graphics.Color} #default nil 7 nil nil nil 848 nil 8 1853175488 518 #{UI.NullConverter} nil nil 9 #focusLost nil nil nil 482 50 1 530 #createAt:extent: 50 2 210 31 49 210 855 39 848 658 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 24 0 0 0 186 1 0 0 43 0 0 0] 8 #() 720 nil 45 738 784 21 800 -23 816 39 832 -23 550 #{Core.IdentityDictionary} 1 848 8 'description' 518 #{Graphics.Rectangle} 210 11 11 210 11 11 482 50 1 530 #createAt:extent: 50 2 210 1 1 210 919 121 272 658 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 203 1 0 0 60 0 0 0] 50 2 848 400 720 nil 27 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 1408 nil nil nil 7 nil nil nil 1408 338 370 4 18 #{UI.ComboBox} 50 17 nil 1408 50 2 8 1144063490 1025 1504 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} 928 nil 7 nil nil nil 1504 nil 8 1852792128 518 #{Core.Message} #displayString 8 #() 8 #() 201 482 50 1 530 #createAt:extent: 50 2 210 141 13 210 181 43 1504 658 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 70 0 0 0 6 0 0 0 160 0 0 0 27 0 0 0] 8 #() 720 nil 27 738 770 #fixedPreviousRight 11 770 #fixedViewLeft 181 770 #fixedPreviousTop -3 770 #fixedViewTop 43 18 #{UI.PushButton} 50 20 nil 1408 50 2 8 1140924416 1 1968 nil 928 nil 7 nil nil nil 1968 nil 8 1853182784 1350 4 #{UI.CommandDescription} #scriptParse 8 '&Parse' 1 1 nil nil false nil nil nil 482 50 3 530 #createAt:extent: 50 2 210 351 11 210 141 47 1968 530 #isEnabled: 8 #(false) 1968 530 #text: 50 1 8 '&Parse' 1968 658 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 175 0 0 0 5 0 0 0 245 0 0 0 28 0 0 0] 8 #() 720 nil 29 738 1904 31 1920 141 1936 -1 1952 47 18 #{UI.ReferenceView} 50 14 nil 1408 50 2 8 1140850688 131073 2336 nil nil nil 7 nil nil nil 2336 582 1 #{UI.ResourceIdentifier} #{UI.Presenter} #resource_OK_Cancel_button_block nil 482 50 1 530 #createAt:extent: 50 2 210 571 -3 210 335 71 2336 658 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 29 1 0 0 254 255 255 255 196 1 0 0 33 0 0 0] 8 #() 720 nil 27 738 770 #fixedViewRight -333 800 -13 770 #fixedViewBottom -69 832 -13 18 #{UI.StaticText} 50 16 nil 1408 50 2 8 1140850946 1 2624 nil nil nil 7 nil nil nil 2624 nil 8 1853387904 962 nil nil nil 482 50 2 530 #createAt:extent: 50 2 210 21 17 210 111 45 2624 530 #text: 50 1 8 'Language:' 2624 658 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 8 0 0 0 65 0 0 0 30 0 0 0] 8 #() 720 nil 27 738 784 21 1920 111 2608 -43 832 -19 1154 1 1504 8 'Language' nil 482 50 1 530 #createAt:extent: 50 2 210 1 803 210 919 81 1408 658 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 145 1 0 0 203 1 0 0 185 1 0 0] 50 4 2624 1504 1968 2336 720 nil 27 nil nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 3104 nil nil nil 7 nil nil nil 3104 518 #{UI.ProportionalLayout} 370 2 18 #{UI.ContainerView} 50 15 nil 3104 50 2 8 1140850688 131073 3216 nil nil nil 7 nil nil nil 3216 338 370 2 18 #{UI.ContainerView} 50 15 nil 3216 50 2 8 1140850688 131073 3312 nil nil nil 7 nil nil nil 3312 242 11 11 nil nil nil nil 18 #{UI.Scintilla.ScintillaView} 50 56 nil 3312 50 2 8 1174475012 1025 3392 1094 2 #{UI.ValueHolder} nil false 6 #{Kernel.EqualitySearchPolicy} nil 928 nil 7 nil nil nil 3392 nil 8 1367644576 962 nil nil 9 #focusLost nil nil nil nil 1154 5 #callTip 3142 1 #{UI.Scintilla.TextStyle} 77 914 #gray 914 #white 1 nil nil nil nil #callTip nil nil nil #indentGuide 3570 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil #lineNumber 3570 67 nil nil 1 nil nil nil nil #lineNumber nil nil nil #normal 3570 1 nil nil 1 nil nil nil nil #normal nil nil nil #whitespace 3570 3 nil nil 1 nil nil nil nil #whitespace nil nil nil nil 326 1 #{UI.Scintilla.NullStyler} #normal 1154 1 #default 3142 2 #{UI.Scintilla.MarkerDefinition} 1 nil nil nil 3392 #circle nil nil nil nil nil nil 294 #{Core.IdentitySet} 0 nil 370 0 9215 nil nil 370 1 81 914 #windowText nil nil 262 #{UI.Scintilla.NullScintillaLibrary} nil 65 nil nil nil nil 3 1154 1 #container 3552 nil nil nil nil #{Core.AnsiString} nil 1154 3 8 'indicator0' 3142 5 #{UI.Scintilla.IndicatorDefinition} 1 3392 914 #commonGreen 3 3 nil nil nil nil nil nil nil 8 'indicator1' 3938 3 3392 914 #blue 5 3 nil nil nil nil nil nil nil 8 'indicator2' 3938 5 3392 914 #red 1 3 nil nil nil nil nil nil nil nil nil 1154 3 #Error 3570 1031 914 #firebrick 914 #floralWhite 1 nil nil nil nil #Error nil nil nil #Notification 3570 1029 nil 914 #gainsboro 1 nil nil nil nil #Notification nil nil nil #Warning 3570 1027 914 #darkGoldenrod 914 #ivory 1 nil nil nil nil #Warning nil nil nil nil nil nil 482 50 7 530 #createAt:extent: 50 2 210 11 11 210 855 399 3392 530 #text: 50 1 8 'function Do(x)
	Do = "Do " + x
end function' 3392 530 #wordWrap: 8 #(true) 3392 530 #margins: 50 1 50 3 2118 3 #{UI.Scintilla.Margin} 1 3392 nil 3 nil nil nil nil 4450 3 3392 33 nil nil 67108863 nil nil 4450 5 3392 nil nil nil nil nil nil 3392 530 #sciSetHScrollBar: 8 #(false) 3392 530 #targetRange: 50 1 774 #{Core.Interval} 3 91 3 3392 530 #maxCompletionListHeight: 8 #(9) 3392 658 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 176 1 0 0 204 0 0 0] 8 #() 720 nil 45 1154 1 3392 8 'ScriptText' 1202 210 11 11 210 11 11 482 50 1 530 #createAt:extent: 50 2 210 21 41 210 875 419 3312 658 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 20 0 0 0 191 1 0 0 229 0 0 0] 50 1 3392 720 nil 27 738 784 11 800 -13 816 31 832 -15 18 #{UI.GroupBox} 50 14 nil 3216 50 2 8 1140850695 65 4928 nil nil nil 7 nil nil nil 4928 nil 8 1853182784 482 50 2 530 #createAt:extent: 50 2 210 11 11 210 895 459 4928 530 #text: 50 1 8 'Procedures' 4928 658 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 196 1 0 0 234 0 0 0] 8 #() 720 nil 27 738 784 1 800 -3 816 1 832 -5 1154 0 1202 210 11 11 210 11 1 482 50 1 530 #createAt:extent: 50 2 210 1 209 210 919 475 3216 658 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 104 0 0 0 203 1 0 0 85 1 0 0] 50 2 4928 3312 720 nil 27 8 2.5 18 #{UI.ContainerView} 50 15 nil 3104 50 2 8 1140850688 131073 5440 nil nil nil 7 nil nil nil 5440 338 370 5 18 #{UI.GroupBox} 50 14 nil 5440 50 2 8 1140850695 65 5536 nil nil nil 7 nil nil nil 5536 nil 8 1853182784 482 50 2 530 #createAt:extent: 50 2 210 11 11 210 895 199 5536 530 #text: 50 1 8 'Expression' 5536 658 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 196 1 0 0 104 0 0 0] 8 #() 720 nil 27 738 784 1 800 -3 816 1 832 11 18 #{UI.MultilineTextEdit} 50 20 nil 5440 50 2 8 1143017540 1025 5824 nil 928 nil 7 nil nil nil 5824 nil 8 1853175488 962 nil nil 9 #focusLost nil nil nil 482 50 1 530 #createAt:extent: 50 2 210 171 41 210 715 79 5824 658 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 85 0 0 0 20 0 0 0 186 1 0 0 59 0 0 0] 8 #() 720 nil 45 738 784 161 800 -23 816 31 832 -79 18 #{UI.PushButton} 50 20 nil 5440 50 2 8 1140924416 1 6080 nil 928 nil 7 nil nil nil 6080 nil 8 1853182784 2050 #scriptRun 8 '&Test' 1 1 nil nil false nil nil nil 482 50 3 530 #createAt:extent: 50 2 210 31 51 210 131 51 6080 530 #isEnabled: 8 #(false) 6080 530 #text: 50 1 8 '&Test' 6080 658 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 25 0 0 0 80 0 0 0 50 0 0 0] 8 #() 720 nil 29 738 784 21 1920 131 816 41 1952 51 18 #{UI.StaticText} 50 16 nil 5440 50 2 8 1140850946 1 6432 nil nil nil 7 nil nil nil 6432 nil 8 1853387904 962 nil nil nil 482 50 2 530 #createAt:extent: 50 2 210 51 151 210 101 41 6432 530 #text: 50 1 8 'Result:' 6432 658 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 25 0 0 0 75 0 0 0 75 0 0 0 95 0 0 0] 8 #() 720 nil 27 738 784 41 1920 101 2608 -39 832 -7 18 #{UI.TextEdit} 50 20 nil 5440 50 2 8 1140916352 1025 6736 nil 3616 nil 7 nil nil nil 6736 nil 8 1853175488 962 nil nil 1 #focusLost nil nil nil 482 50 2 530 #createAt:extent: 50 2 210 171 143 210 715 43 6736 530 #isEnabled: 8 #(false) 6736 658 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 85 0 0 0 71 0 0 0 186 1 0 0 92 0 0 0] 8 #() 720 nil 45 738 784 161 800 -23 2608 -41 832 -13 1154 2 5824 8 'Expression' 6736 8 'Result' 1202 210 11 11 210 11 11 482 50 1 530 #createAt:extent: 50 2 210 1 1 210 919 209 5440 658 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 203 1 0 0 104 0 0 0] 50 5 5824 6080 6432 6736 5536 720 nil 27 8 1.1 true 1154 0 nil 482 50 1 530 #createAt:extent: 50 2 210 1 121 210 919 683 3104 658 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 60 0 0 0 203 1 0 0 145 1 0 0] 50 2 5440 3216 720 nil 27 1154 0 nil 2886 4 #{UI.MenuBar} nil true 50 4 2886 4 #{UI.Menu} nil true 50 3 1094 2 #{UI.CommandMenuItem} 1 2050 #fileOpen 8 '&Open…' 9375 1 nil nil nil 7554 1 2050 #fileSave 8 '&Save' 9383 1 nil nil nil 7554 1 2050 #fileSaveAs 8 'Save &As…' 1 1 nil nil nil 8 '&File' nil 1 nil nil 47811 nil nil 7506 nil true 50 11 7554 1 2050 #undo 8 '&Undo' 9397 1 nil nil nil 326 1 #{UI.DividerMenuItem} 4097 7554 1 2050 #cutSelection 8 'Cu&t' 9393 1 nil nil nil 7554 1 2050 #copySelection 8 '&Copy' 9351 1 nil nil nil 7554 1 2050 #pasteClipboard 8 '&Paste' 9389 1 nil nil nil 7554 1 2050 #clearSelection 8 '&Delete' 1 1 nil nil nil 7554 1 2050 #selectAll 8 'Select &All' 9347 1 nil nil nil 7824 7554 1 2050 #find 8 '&Find…' 9357 1 838 4 #{Graphics.Icon} nil true 1030 #{Graphics.ImageFromResourceInitializer} 47 262 #{OS.ShellLibrary} 65541 nil nil nil 7554 1 2050 #findNext 8 'Find &Next' 1253 1 nil nil nil 7554 1 2050 #findReplace 8 '&Replace…' 9361 1 nil nil nil 8 '&Edit' nil 1 nil nil 47831 nil nil 7506 nil true 50 2 7554 1 2050 #scriptParse 8 '&Parse' 1 1 nil nil nil 7554 1 2050 #scriptRun 8 '&Test' 1 1 nil nil nil 8 '&Script' nil 1 nil nil 47837 nil nil 7506 nil true 50 1 7554 1 2050 #helpAboutScriptControl 8 '&About Script Control…' 1 1 nil nil nil 8 '&Help' nil 1 nil nil 47841 nil nil 8 '' nil 1 nil nil nil nil nil nil nil nil 13467 nil nil nil 210 851 901 1 nil nil 774 #{Core.Semaphore} nil nil 1 nil 8 2011790800 482 50 2 530 #createAt:extent: 50 2 210 6143 21 210 951 1001 32 530 #text: 50 1 8 'Active-X Script Editor' 32 658 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 218 13 0 0 254 1 0 0] 50 3 272 3104 1408 720 nil 27)! !
!MSScriptControl.SimpleAXScriptEditor class categoriesForMethods!
defaultModel!constants!public! !
resource_Default_view!public!resources-views! !
!

