"Filed out from Dolphin Smalltalk"!

UI.Shell
	subclass: #'XProgramming.SUnit.TestRunner'
	instanceVariableNames: 'result lastPass'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

XProgramming.SUnit.TestRunner guid: (Core.GUID fromString: '{5e967948-0810-11d4-a876-0050da643bf9}')!

XProgramming.SUnit.TestRunner comment: 'A TestRunner is a simple graphical user interface to run test cases. A window can be opened via "TestRunner show". '!

!XProgramming.SUnit.TestRunner categoriesForClass!SUnit! !

!XProgramming.SUnit.TestRunner methodsFor!

allTestSuite
	^TestCase buildSuite!

createSchematicWiring
	| list |
	list := self view viewNamed: 'defects' ifNone: [^self].
	list when: #selectionChanged send: #debugTest to: self.	
!

debugFailedTest
	self debugTest!

debugTest
	| list  |
	list := self view viewNamed: 'defects' ifNone: [^self].
	list selectionOrNil isNil ifTrue: [^self].
	self debugTest: list selection.
!

debugTest: aTestCase 
	aTestCase isNil ifTrue: [^self].
	self displayMode: 'Debugging'.
	aTestCase debug!

displayClear
	self displayColor: #default!

displayColor: aSymbol
 	(self view viewNamed: 'colorField') backcolor: (Graphics.Color perform: aSymbol).
 	(self view viewNamed: 'mode') backcolor: (Graphics.Color perform: aSymbol).
 	(self view viewNamed: 'details') backcolor: (Graphics.Color perform: aSymbol)!

displayDefects: aCollection
	| list |
	list := self view viewNamed: 'defects' ifNone: [^self].
	list selectionOrNil: nil.
	list list: aCollection.
	list isEnabled: aCollection isEmpty not.
!

displayDetails: aString
	| details |
	details := self view viewNamed: 'details' ifNone: [^self].
	details value: aString.
	SessionManager inputState pumpMessages!

displayFail
	self displayRed.
	self displayMode: 'Fail'.
	self displayDetails: result printString.!

displayGreen
 	self displayColor: #green!

displayMode: aString
 	| mode |
	mode := self view viewNamed: 'mode' ifNone: [^self].
	mode value: aString.
	!

displayPass
	self displayGreen.
	self displayMode: 'Pass'.
	self displayDetails: result printString , self timeSinceLastPassAsString.
	lastPass := DateAndTime now!

displayRed
 	self displayColor: #red!

displayReset
	self displayClear.
	self displayMode: 'N/A'.
	self displayDetails: '...'.
	self displayDefects: OrderedCollection new.!

displayRunning
	self displayYellow.
	self displayMode: 'running'. 
	self displayDetails: '...'.!

displayYellow
 	self displayColor: #yellow!

onViewOpened

	super onViewOpened.
	self caption: 'SUnit Camp Smalltalk ', TestCase version, ' TestRunner'.
	(self view viewNamed: 'scriptModel') 
		list: TestCase allSubclasses.
	!

refreshTests
	(self view viewNamed: 'scriptModel') 
		list: TestCase allSubclasses; 
		selectionByIndex: 0; 
		updateAll.
	self displayReset.

!

result
	^result!

runAllTests
	self runSuite: self allTestSuite!

runSuite: aTestSuite 
	self displayRunning.
	aTestSuite addDependentToHierachy: self.
	[result := aTestSuite run]
		ensure: [aTestSuite removeDependentFromHierachy: self].
	self updateWindow!

runTests
	self script isNil ifFalse: 
		[self runSuite: self script suite]!

script
	| scriptModel |
	scriptModel := self view viewNamed: 'scriptModel' ifNone: [^nil].
	scriptModel selectionOrNil isNil ifTrue: [^nil].
	^scriptModel selection!

timeSinceLastPassAsString
	| stream |
	lastPass isNil ifTrue: [^''].
	stream := String smalltalkWriteStream.
	stream nextPutAll: ', '.
	DateAndTime now - lastPass displayOn: stream.
	stream nextPutAll: ' since last Pass'.
	^stream contents!

update: anObject 
	(anObject isKindOf: TestCase)
		ifTrue: [self displayDetails: anObject printString]
		ifFalse: [super update: anObject]!

updateDefects
	self displayDefects: result defects!

updateWindow
	result hasPassed
		ifTrue: [self displayPass]
		ifFalse: [self displayFail].
	self updateDefects! !

!XProgramming.SUnit.TestRunner categoriesForMethods!
allTestSuite!helpers!public! !
createSchematicWiring!helpers!private! !
debugFailedTest!Actions!public! !
debugTest!Actions!public! !
debugTest:!Actions!public! !
displayClear!public!Updating! !
displayColor:!public!Updating! !
displayDefects:!public!Updating! !
displayDetails:!public!Updating! !
displayFail!public!Updating! !
displayGreen!public!Updating! !
displayMode:!public!Updating! !
displayPass!public!Updating! !
displayRed!public!Updating! !
displayReset!public!Updating! !
displayRunning!public!Updating! !
displayYellow!public!Updating! !
onViewOpened!Actions!public! !
refreshTests!Actions!public! !
result!Accessing!public! !
runAllTests!Actions!public! !
runSuite:!Actions!public! !
runTests!Actions!public! !
script!Accessing!public! !
timeSinceLastPassAsString!helpers!public! !
update:!helpers!public! !
updateDefects!public!Updating! !
updateWindow!public!Updating! !
!

!XProgramming.SUnit.TestRunner class methodsFor!

defaultView
	^'SUnit Runner 3.0'!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

initialize
	"Private - Initialize the receiver. Register the tools folder icon with SmalltalkSystem.

		self initialize.
	"

	Smalltalk developmentSystem
		addAdditionalToolsFolderIcon: (Tools.SmalltalkSystemIcon
					show: self
					description: self toolDescription
					helpId: self toolsFolderHelpId);
		registerTool: self!

open
	^self show!

resource_SUnit_Runner_30
	"Answer the literal data from which the 'SUnit Runner 30' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_SUnit_Runner_30)
	"

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.ShellView} 38 #{Core.Array} 27 nil nil 8 #(13565952 65536) 32 nil 6 #{Graphics.Color} #silver nil 5 nil nil nil 32 1798 #{UI.BorderLayout} 1 1 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 160 nil 112 nil 5 nil 1350 1 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 0 65 0 114 0 105 0 97 0 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 160 130 1 1 nil nil 18 #{UI.ContainerView} 50 15 nil 160 50 2 8 1140850688 131073 320 nil 112 nil 5 nil nil nil 320 nil 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 50 2 18 #{UI.PushButton} 50 20 nil 320 50 2 8 1140924416 1 432 nil 112 518 #{Graphics.Point} 177 57 5 nil 226 nil true 258 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 0 65 0 114 0 105 0 97 0 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 432 nil nil 1350 4 #{UI.CommandDescription} #runTests 8 'Run' 1 1 nil nil false nil nil nil 262 #{Core.MessageSequence} 50 2 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[0 0 0 0 0 0 0 0 60 0 0 0 24 0 0 0] 193 464 8 'Run' 432 674 #isEnabled: 8 #(false) 432 3 8 #() 498 193 193 nil 29 8 'runOne' nil 626 50 1 674 #createWindow: 50 1 722 754 8 #[92 1 0 0 0 0 0 0 212 1 0 0 24 0 0 0] 193 352 8 '' 320 3 50 2 18 #{UI.PushButton} 50 20 nil 320 50 2 8 1140924416 1 1040 nil 98 #default nil 5 nil 226 nil true 258 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 0 65 0 114 0 105 0 97 0 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 1040 nil nil 578 #runAllTests 8 'RunAll' 1 1 nil nil false nil nil nil 626 50 2 674 #createWindow: 50 1 722 754 8 #[60 0 0 0 0 0 0 0 120 0 0 0 24 0 0 0] 193 1072 8 'RunAll' 1040 674 #isEnabled: 8 #(false) 1040 3 8 #() 498 193 193 nil 29 432 498 193 193 nil 27 18 #{UI.PushButton} 50 20 nil 160 50 2 8 1140924416 1 1408 nil 1104 nil 5 nil 226 nil true 258 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 0 65 0 114 0 105 0 97 0 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 1408 nil nil 578 #refreshTests 8 'Refresh' 1 1 nil nil false nil nil nil 626 50 2 674 #createWindow: 50 1 722 754 8 #[0 0 0 0 0 0 0 0 74 0 0 0 24 0 0 0] 193 1440 8 'Refresh' 1408 674 #isEnabled: 8 #(false) 1408 3 8 #() 498 193 193 nil 29 18 #{UI.ComboBox} 50 17 nil 160 50 2 8 1144063491 1025 1744 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} 1104 nil 5 nil 226 nil true 258 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 0 65 0 114 0 105 0 97 0 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 1744 nil nil 518 #{Core.Message} #displayString 8 #() 8 #() 401 626 50 1 674 #createWindow: 50 1 722 754 8 #[74 0 0 0 0 0 0 0 92 1 0 0 224 0 0 0] 193 1776 8 '' 1744 3 8 #() 498 193 193 nil 27 386 #{Core.IdentityDictionary} 50 4 1408 8 'refreshButton' 1744 8 'scriptModel' nil 626 50 1 674 #createWindow: 50 1 722 754 8 #[0 0 0 0 0 0 0 0 212 1 0 0 24 0 0 0] 193 192 8 '' 160 3 50 3 1408 1744 320 498 193 193 nil 27 nil nil nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 2400 nil 1104 nil 5 nil nil nil 2400 130 1 1 nil 18 #{UI.ContainerView} 50 15 nil 2400 50 2 8 1140850688 131073 2480 nil 1104 nil 5 nil nil nil 2480 130 1 1 nil nil 18 #{UI.PushButton} 50 20 nil 2480 50 2 8 1140924416 1 2560 nil 1104 nil 5 nil 226 nil true 258 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 0 65 0 114 0 105 0 97 0 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 2560 nil nil 578 #debugFailedTest 8 'Debug' 1 1 nil nil false nil nil nil 626 50 2 674 #createWindow: 50 1 722 754 8 #[135 1 0 0 0 0 0 0 212 1 0 0 24 0 0 0] 193 2592 8 'Debug' 2560 674 #isEnabled: 8 #(false) 2560 3 8 #() 498 193 193 nil 29 nil 18 #{UI.ComboBox} 50 17 nil 2480 50 2 8 1144063491 1 2896 1810 1842 0 nil 1888 1104 nil 5 nil 226 nil true 258 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 0 65 0 114 0 105 0 97 0 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 2896 nil nil 1968 2000 401 626 50 2 674 #createWindow: 50 1 722 754 8 #[0 0 0 0 0 0 0 0 135 1 0 0 224 0 0 0] 193 2928 8 '' 2896 674 #isEnabled: 8 #(false) 2896 3 8 #() 498 193 193 nil 27 386 #{Core.IdentityDictionary} 50 4 2560 8 'debugButton' 2896 8 'defects' nil 626 50 1 674 #createWindow: 50 1 722 754 8 #[0 0 0 0 103 0 0 0 212 1 0 0 127 0 0 0] 193 2512 8 '' 2480 3 50 2 2560 2896 498 193 193 nil 27 nil nil 18 #{UI.ContainerView} 50 15 nil 2400 50 2 8 1149239296 131073 3456 nil 1104 nil 5 nil nil nil 3456 130 1 1 18 #{UI.StaticText} 50 16 nil 3456 50 2 8 1140850945 1 3536 nil nil 498 177 81 5 nil 226 nil true 258 8 #[224 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 0 65 0 114 0 105 0 97 0 108 0 32 0 66 0 108 0 97 0 99 0 107 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 3536 nil nil 518 #{UI.NullConverter} nil nil true 626 50 2 674 #createWindow: 50 1 722 754 8 #[0 0 0 0 0 0 0 0 210 1 0 0 60 0 0 0] 193 3568 nil 3536 674 #text: 50 1 8 'N/A' 3536 3 8 #() 498 193 193 nil 27 nil nil nil 18 #{UI.StaticText} 50 16 nil 3456 50 2 8 1140850945 65 3888 nil nil nil 5 nil 226 nil true 258 8 #[240 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 0 65 0 114 0 105 0 97 0 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 3888 nil nil 3666 nil nil nil 626 50 2 674 #createWindow: 50 1 722 754 8 #[0 0 0 0 60 0 0 0 210 1 0 0 101 0 0 0] 193 3920 nil 3888 674 #text: 50 1 8 '...' 3888 3 8 #() 498 193 193 nil 27 386 #{Core.IdentityDictionary} 50 4 3888 8 'details' 3536 8 'mode' nil 626 50 1 674 #createWindow: 50 1 722 754 8 #[0 0 0 0 0 0 0 0 212 1 0 0 103 0 0 0] 193 3488 8 '' 3456 3 50 2 3888 3536 498 193 193 nil 27 550 #{Core.IdentityDictionary} 0 518 #{Graphics.Rectangle} 498 1 1 498 1 1 626 50 1 674 #createWindow: 50 1 722 754 8 #[0 0 0 0 24 0 0 0 212 1 0 0 151 0 0 0] 193 2432 8 '' 2400 3 50 2 3456 2480 498 193 193 nil 27 386 4432 50 2 2400 8 'colorField' nil nil nil nil nil 1 nil nil nil 498 969 381 1 nil 193 626 50 1 674 #createWindow: 50 1 722 4466 498 7679 21 498 8647 401 193 80 8 'SUnit Camp Smalltalk 3.0 TestRunner' 32 1 50 2 160 2400 498 193 193 nil 27)!

toolDescription
	"Answer the description of this tool that should be displayed in, for example,
	the system shell window."

	^self displayString!

toolsFolderHelpId
	^10632! !

!XProgramming.SUnit.TestRunner class categoriesForMethods!
defaultView!public!views! !
icon!constants!public! !
initialize!initializing!must strip!private! !
open!Init / Release!public! !
resource_SUnit_Runner_30!public!resources-views! !
toolDescription!constants!public! !
toolsFolderHelpId!public! !
!

