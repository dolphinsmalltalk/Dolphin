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

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 34 nil nil 8 #(13369344 65536) 32 nil 518 #{Graphics.ThemeColor} #dialog nil 133 nil 1350 1 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 1 2 1 0 77 0 83 0 32 0 83 0 97 0 110 0 115 0 32 0 83 0 101 0 114 0 105 0 102 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 32 1798 #{UI.BorderLayout} 1 1 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 240 nil nil nil 5 nil nil nil 240 262 #{UI.FramingLayout} 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.LookupTable} 50 4 18 #{UI.GroupBox} 50 14 nil 240 50 2 8 1140850695 65 384 nil nil nil 5 nil nil nil 384 nil nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[5 0 0 0 5 0 0 0 196 1 0 0 55 0 0 0] 193 416 8 'Description' 384 3 8 #() 518 #{Graphics.Point} 193 193 nil 27 2118 2 #{UI.FramingConstraints} 1030 #{UI.FramingCalculation} #fixedParentLeft 1 722 #fixedParentRight -3 722 #fixedParentTop 1 722 #fixedParentBottom 1 18 #{UI.TextEdit} 50 20 nil 240 50 2 8 1140916352 1025 800 nil 6 #{Graphics.Color} #default nil 5 nil nil nil 800 nil nil 518 #{UI.NullConverter} nil nil 9 #focusLost nil nil nil 450 50 1 498 #createWindow: 50 1 546 578 8 #[15 0 0 0 24 0 0 0 186 1 0 0 43 0 0 0] 193 832 nil 800 3 8 #() 658 193 193 nil 45 690 736 21 752 -23 768 39 784 -23 338 #{Core.IdentityDictionary} 50 2 800 8 'description' 518 #{Graphics.Rectangle} 658 11 11 658 11 11 450 50 1 498 #createWindow: 50 1 546 578 8 #[0 0 0 0 0 0 0 0 203 1 0 0 60 0 0 0] 193 272 8 '' 240 3 50 2 800 384 658 193 193 nil 27 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 1360 nil nil nil 5 nil nil nil 1360 306 338 #{Core.LookupTable} 50 8 18 #{UI.ReferenceView} 50 14 nil 1360 50 2 8 1140850688 131073 1472 nil nil nil 5 nil nil nil 1472 582 1 #{UI.ResourceIdentifier} #{UI.Presenter} #resource_OK_Cancel_button_block nil 450 50 1 498 #createWindow: 50 1 546 578 8 #[29 1 0 0 254 255 255 255 196 1 0 0 33 0 0 0] 193 1504 8 '' 1472 3 8 #() 658 193 193 nil 27 690 722 #fixedViewRight -333 752 -13 722 #fixedViewBottom -69 784 -13 18 #{UI.PushButton} 50 20 nil 1360 50 2 8 1140924416 1 1776 nil 880 nil 5 nil nil nil 1776 nil nil 1350 4 #{UI.CommandDescription} #scriptParse 8 '&Parse' 1 1 nil nil false nil nil nil 450 50 2 498 #createWindow: 50 1 546 578 8 #[175 0 0 0 5 0 0 0 245 0 0 0 28 0 0 0] 193 1808 8 '&Parse' 1776 498 #isEnabled: 8 #(false) 1776 3 8 #() 658 193 193 nil 29 690 722 #fixedPreviousRight 31 722 #fixedViewLeft 141 722 #fixedPreviousTop -1 722 #fixedViewTop 47 18 #{UI.ComboBox} 50 17 nil 1360 50 2 8 1144063490 1025 2160 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} 880 nil 5 nil nil nil 2160 nil nil 518 #{Core.Message} #displayString 8 #() 8 #() 201 450 50 1 498 #createWindow: 50 1 546 578 8 #[70 0 0 0 6 0 0 0 160 0 0 0 124 0 0 0] 193 2192 8 '' 2160 3 8 #() 658 193 193 nil 27 690 2096 11 2112 181 2128 -3 2144 43 18 #{UI.StaticText} 50 16 nil 1360 50 2 8 1140850946 1 2560 nil nil nil 5 nil nil nil 2560 nil nil 898 nil nil nil 450 50 2 498 #createWindow: 50 1 546 578 8 #[10 0 0 0 8 0 0 0 65 0 0 0 30 0 0 0] 193 2592 nil 2560 498 #text: 50 1 8 'Language:' 2560 3 8 #() 658 193 193 nil 27 690 736 21 2112 111 1760 -43 784 -19 338 #{Core.IdentityDictionary} 50 2 2160 8 'Language' nil 450 50 1 498 #createWindow: 50 1 546 578 8 #[0 0 0 0 145 1 0 0 203 1 0 0 185 1 0 0] 193 1392 8 '' 1360 3 50 4 2560 2160 1776 1472 658 193 193 nil 27 nil nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 3056 nil nil nil 5 nil nil nil 3056 518 #{UI.ProportionalLayout} 518 #{Kernel.STBCollectionProxy} #{Core.LookupTable} 50 2 518 #{Core.Association} 18 #{UI.ContainerView} 50 15 nil 3056 50 2 8 1140850688 131073 3232 nil nil nil 5 nil nil nil 3232 306 338 #{Core.LookupTable} 50 10 18 #{UI.GroupBox} 50 14 nil 3232 50 2 8 1140850695 65 3344 nil nil nil 5 nil nil nil 3344 nil nil 450 50 1 498 #createWindow: 50 1 546 578 8 #[5 0 0 0 5 0 0 0 196 1 0 0 104 0 0 0] 193 3376 8 'Expression' 3344 3 8 #() 658 193 193 nil 27 690 736 1 752 -3 768 1 784 11 18 #{UI.MultilineTextEdit} 50 20 nil 3232 50 2 8 1143017540 1025 3584 nil 880 nil 5 nil nil nil 3584 nil nil 898 nil nil 9 #focusLost nil nil nil 450 50 1 498 #createWindow: 50 1 546 578 8 #[85 0 0 0 20 0 0 0 186 1 0 0 59 0 0 0] 193 3616 nil 3584 3 8 #() 658 193 193 nil 45 690 736 161 752 -23 768 31 784 -79 18 #{UI.PushButton} 50 20 nil 3232 50 2 8 1140924416 1 3824 nil 880 nil 5 nil nil nil 3824 nil nil 1842 #scriptRun 8 '&Test' 1 1 nil nil false nil nil nil 450 50 2 498 #createWindow: 50 1 546 578 8 #[15 0 0 0 25 0 0 0 80 0 0 0 50 0 0 0] 193 3856 8 '&Test' 3824 498 #isEnabled: 8 #(false) 3824 3 8 #() 658 193 193 nil 29 690 736 21 2112 131 768 41 2144 51 18 #{UI.TextEdit} 50 20 nil 3232 50 2 8 1140916352 1025 4128 nil 866 #white nil 5 nil nil nil 4128 nil nil 898 nil nil 1 #focusLost nil nil nil 450 50 2 498 #createWindow: 50 1 546 578 8 #[85 0 0 0 71 0 0 0 186 1 0 0 92 0 0 0] 193 4160 nil 4128 498 #isEnabled: 8 #(false) 4128 3 8 #() 658 193 193 nil 45 690 736 161 752 -23 1760 -41 784 -13 18 #{UI.StaticText} 50 16 nil 3232 50 2 8 1140850946 1 4416 nil nil nil 5 nil nil nil 4416 nil nil 898 nil nil nil 450 50 2 498 #createWindow: 50 1 546 578 8 #[25 0 0 0 75 0 0 0 75 0 0 0 95 0 0 0] 193 4448 nil 4416 498 #text: 50 1 8 'Result:' 4416 3 8 #() 658 193 193 nil 27 690 736 41 2112 101 1760 -39 784 -7 338 #{Core.IdentityDictionary} 50 4 3584 8 'Expression' 4128 8 'Result' 1138 658 11 11 658 11 11 450 50 1 498 #createWindow: 50 1 546 578 8 #[0 0 0 0 0 0 0 0 203 1 0 0 104 0 0 0] 193 3264 8 '' 3232 3 50 5 3584 3824 4416 4128 3344 658 193 193 nil 27 8 1.1 3202 18 #{UI.ContainerView} 50 15 nil 3056 50 2 8 1140850688 131073 5008 nil nil nil 5 nil nil nil 5008 306 338 #{Core.LookupTable} 50 4 18 #{UI.GroupBox} 50 14 nil 5008 50 2 8 1140850695 65 5120 nil nil nil 5 nil nil nil 5120 nil nil 450 50 1 498 #createWindow: 50 1 546 578 8 #[5 0 0 0 5 0 0 0 196 1 0 0 234 0 0 0] 193 5152 8 'Procedures' 5120 3 8 #() 658 193 193 nil 27 690 736 1 752 -3 768 1 784 -5 18 #{UI.ContainerView} 50 15 nil 5008 50 2 8 1140850688 131073 5360 nil nil nil 5 nil nil nil 5360 210 11 11 nil nil nil nil 18 #{UI.Scintilla.ScintillaView} 50 56 nil 5360 50 2 8 1174475012 1025 5440 1094 2 #{UI.ValueHolder} nil false 6 #{Kernel.EqualitySearchPolicy} nil 880 nil 5 nil nil nil 5440 nil nil 898 nil nil 9 #focusLost nil nil nil nil 550 #{Core.IdentityDictionary} 5 #callTip 3142 1 #{UI.Scintilla.TextStyle} 77 866 #gray 4192 1 nil nil nil nil #callTip nil nil nil #indentGuide 5618 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil #lineNumber 5618 67 nil nil 1 nil nil nil nil #lineNumber nil nil nil #normal 5618 1 nil nil 1 nil nil nil nil #normal nil nil nil #whitespace 5618 3 nil nil 1 nil nil nil nil #whitespace nil nil nil nil 326 1 #{UI.Scintilla.NullStyler} #normal 5586 1 #default 3142 2 #{UI.Scintilla.MarkerDefinition} 1 nil nil nil 5440 #circle nil nil nil nil nil nil 294 #{Core.IdentitySet} 0 nil 550 #{Core.LookupTable} 0 9215 nil nil 5842 1 81 866 #windowText nil nil 262 #{UI.Scintilla.NullScintillaLibrary} nil 65 nil nil nil nil 3 5586 1 #container 5600 nil nil nil nil #{Core.AnsiString} nil 5586 3 8 'indicator0' 3142 5 #{UI.Scintilla.IndicatorDefinition} 1 5440 866 #commonGreen 3 3 nil nil nil nil nil nil nil 8 'indicator1' 5986 3 5440 866 #blue 5 3 nil nil nil nil nil nil nil 8 'indicator2' 5986 5 5440 866 #red 1 3 nil nil nil nil nil nil nil nil nil 5586 3 #Error 5618 1031 866 #firebrick 866 #floralWhite 1 nil nil nil nil #Error nil nil nil #Notification 5618 1029 nil 866 #gainsboro 1 nil nil nil nil #Notification nil nil nil #Warning 5618 1027 866 #darkGoldenrod 866 #ivory 1 nil nil nil nil #Warning nil nil nil nil nil nil 450 50 7 498 #createWindow: 50 1 546 578 8 #[5 0 0 0 5 0 0 0 176 1 0 0 204 0 0 0] 193 5472 nil 5440 498 #text: 50 1 8 'function Do(x)
	Do = "Do " + x
end function' 5440 498 #wordWrap: 8 #(true) 5440 498 #margins: 50 1 50 3 2118 3 #{UI.Scintilla.Margin} 1 5440 nil 3 nil nil nil nil 6514 3 5440 33 nil nil 67108863 nil nil 6514 5 5440 nil nil nil nil nil nil 5440 498 #sciSetHScrollBar: 8 #(false) 5440 498 #targetRange: 50 1 774 #{Core.Interval} 3 91 3 5440 498 #maxCompletionListHeight: 8 #(9) 5440 3 8 #() 658 193 193 nil 45 338 5584 50 2 5440 8 'ScriptText' 1138 658 11 11 658 11 11 450 50 1 498 #createWindow: 50 1 546 578 8 #[10 0 0 0 20 0 0 0 191 1 0 0 229 0 0 0] 193 5392 8 '' 5360 3 50 1 5440 658 193 193 nil 27 690 736 11 752 -13 768 31 784 -15 5586 0 1138 658 11 11 658 11 1 450 50 1 498 #createWindow: 50 1 546 578 8 #[0 0 0 0 104 0 0 0 203 1 0 0 85 1 0 0] 193 5040 8 '' 5008 3 50 2 5120 5360 658 193 193 nil 27 8 2.5 true 5586 0 nil 450 50 1 498 #createWindow: 50 1 546 578 8 #[0 0 0 0 60 0 0 0 203 1 0 0 145 1 0 0] 193 3088 8 '' 3056 3 50 2 3232 5008 658 193 193 nil 27 5586 0 nil 2886 4 #{UI.MenuBar} nil true 50 4 2886 4 #{UI.Menu} nil true 50 3 1094 2 #{UI.CommandMenuItem} 1 1842 #fileOpen 8 '&Open…' 9375 1 nil nil nil 7538 1 1842 #fileSave 8 '&Save' 9383 1 nil nil nil 7538 1 1842 #fileSaveAs 8 'Save &As…' 1 1 nil nil nil 8 '&File' nil 1 nil nil nil nil nil 7490 nil true 50 11 7538 1 1842 #undo 8 '&Undo' 9397 1 nil nil nil 326 1 #{UI.DividerMenuItem} 4097 7538 1 1842 #cutSelection 8 'Cu&t' 9393 1 nil nil nil 7538 1 1842 #copySelection 8 '&Copy' 9351 1 nil nil nil 7538 1 1842 #pasteClipboard 8 '&Paste' 9389 1 nil nil nil 7538 1 1842 #clearSelection 8 '&Delete' 1 1 nil nil nil 7538 1 1842 #selectAll 8 'Select &All' 9347 1 nil nil nil 7808 7538 1 1842 #find 8 '&Find…' 9357 1 838 4 #{Graphics.Icon} nil true 1030 #{Graphics.ImageFromResourceInitializer} 47 262 #{OS.ShellLibrary} 65541 nil nil nil 7538 1 1842 #findNext 8 'Find &Next' 1253 1 nil nil nil 7538 1 1842 #findReplace 8 '&Replace…' 9361 1 nil nil nil 8 '&Edit' nil 1 nil nil nil nil nil 7490 nil true 50 2 7538 1 1842 #scriptParse 8 '&Parse' 1 1 nil nil nil 7538 1 1842 #scriptRun 8 '&Test' 1 1 nil nil nil 8 '&Script' nil 1 nil nil nil nil nil 7490 nil true 50 1 7538 1 1842 #helpAboutScriptControl 8 '&About Script Control…' 1 1 nil nil nil 8 '&Help' nil 1 nil nil nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil nil 1 nil nil nil 658 851 901 1 nil 193 774 #{Core.Semaphore} nil nil 1 nil nil nil nil nil nil 450 50 2 498 #createWindow: 50 1 518 #{UI.CreateDialog} 1138 658 7679 21 658 8629 1021 193 32 498 #setWindowText: 50 1 8 'Active-X Script Editor' 32 1 50 3 240 3056 1360 658 193 193 nil 29)! !

!MSScriptControl.SimpleAXScriptEditor class categoriesForMethods!
defaultModel!constants!public! !
resource_Default_view!public!resources-views! !
!

