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

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.ShellView} 34 27 nil nil 8 #(13565952 65536) 416 nil 917510 #{Graphics.Color} #silver nil 39 nil nil nil 416 984838 #{UI.BorderLayout} 1 1 410 #{UI.ContainerView} 34 15 nil 416 34 2 8 1140850688 131073 528 nil 480 nil 7 nil 852998 #{Graphics.Font} nil true 655622 #{OS.LOGFONT} 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 918022 #{Graphics.Point} 193 193 nil 528 498 1 1 nil nil 410 #{UI.ContainerView} 34 15 nil 528 34 2 8 1140850688 131073 720 nil 480 nil 7 nil nil nil 720 nil 170 192 34 2 410 #{UI.PushButton} 34 20 nil 720 34 2 8 1140924416 1 816 nil 480 674 177 57 7 nil 594 nil true 626 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 68 132 66 49 15 1 0 0 196 53 15 1 2 0 144 39 0 0 0 0 191 0 253 85 63 1] 674 193 193 nil 816 nil 8 1815097472 1377606 4 #{UI.CommandDescription} #runTests 8 'Run' 1 1 nil nil false nil nil nil 1310982 #{Core.MessageSequence} 34 3 1049350 #{Core.MessageSend} #createAt:extent: 34 2 674 1 1 674 121 49 816 1074 #isEnabled: 8 #(false) 816 1074 #text: 34 1 8 'Run' 816 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 60 0 0 0 24 0 0 0] 8 #() 674 193 193 nil 29 8 'runOne' nil 1026 34 1 1074 #createAt:extent: 34 2 674 697 1 674 241 49 720 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 92 1 0 0 0 0 0 0 212 1 0 0 24 0 0 0] 34 2 410 #{UI.PushButton} 34 20 nil 720 34 2 8 1140924416 1 1472 nil 466 #default nil 7 nil 594 nil true 626 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 68 132 66 49 15 1 0 0 196 53 15 1 2 0 144 39 0 0 0 0 191 0 253 85 63 1] 944 nil 1472 nil 8 1815097472 978 #runAllTests 8 'RunAll' 1 1 nil nil false nil nil nil 1026 34 3 1074 #createAt:extent: 34 2 674 121 1 674 121 49 1472 1074 #isEnabled: 8 #(false) 1472 1074 #text: 34 1 8 'RunAll' 1472 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 60 0 0 0 0 0 0 0 120 0 0 0 24 0 0 0] 8 #() 1296 nil 29 816 1296 nil 27 410 #{UI.PushButton} 34 20 nil 528 34 2 8 1140924416 1 1872 nil 1536 nil 7 nil 594 nil true 626 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 944 nil 1872 nil 8 1815097472 978 #refreshTests 8 'Refresh' 1 1 nil nil false nil nil nil 1026 34 3 1074 #createAt:extent: 34 2 674 1 1 674 149 49 1872 1074 #isEnabled: 8 #(false) 1872 1074 #text: 34 1 8 'Refresh' 1872 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 74 0 0 0 24 0 0 0] 8 #() 1296 nil 29 410 #{UI.ComboBox} 34 17 nil 528 34 2 8 1144063491 1025 2256 787270 2 #{UI.ListModel} 138 144 8 #() nil 1769478 #{Kernel.IdentitySearchPolicy} 1536 nil 7 nil 594 nil true 626 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 944 nil 2256 nil 8 1814646992 786950 #{Core.Message} #displayString 2368 8 #() 401 1026 34 1 1074 #createAt:extent: 34 2 674 149 1 674 549 49 2256 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 74 0 0 0 0 0 0 0 92 1 0 0 24 0 0 0] 8 #() 1296 nil 27 170 192 34 4 1872 8 'refreshButton' 2256 8 'scriptModel' nil 1026 34 1 1074 #createAt:extent: 34 2 674 1 1 674 937 49 528 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 212 1 0 0 24 0 0 0] 34 3 1872 2256 720 1296 nil 27 nil nil nil 410 #{UI.ContainerView} 34 15 nil 416 34 2 8 1140850688 131073 2880 nil 1536 nil 7 nil nil nil 2880 498 1 1 nil 410 #{UI.ContainerView} 34 15 nil 2880 34 2 8 1140850688 131073 2960 nil 1536 nil 7 nil nil nil 2960 498 1 1 nil nil 410 #{UI.PushButton} 34 20 nil 2960 34 2 8 1140924416 1 3040 nil 1536 nil 7 nil 594 nil true 626 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 674 193 193 nil 3040 nil 8 1815097472 978 #debugFailedTest 8 'Debug' 1 1 nil nil false nil nil nil 1026 34 3 1074 #createAt:extent: 34 2 674 783 1 674 155 49 3040 1074 #isEnabled: 8 #(false) 3040 1074 #text: 34 1 8 'Debug' 3040 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 135 1 0 0 0 0 0 0 212 1 0 0 24 0 0 0] 8 #() 1296 nil 29 nil 410 #{UI.ComboBox} 34 17 nil 2960 34 2 8 1144063491 1 3440 2322 138 144 2368 nil 2400 1536 nil 7 nil 594 nil true 626 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 674 193 193 nil 3440 nil 8 1814646992 2496 2512 401 1026 34 2 1074 #createAt:extent: 34 2 674 1 1 674 783 49 3440 1074 #isEnabled: 8 #(false) 3440 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 135 1 0 0 24 0 0 0] 8 #() 1296 nil 27 170 192 34 4 3040 8 'debugButton' 3440 8 'defects' nil 1026 34 1 1074 #createAt:extent: 34 2 674 1 207 674 937 49 2960 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 103 0 0 0 212 1 0 0 127 0 0 0] 34 2 3040 3440 1296 nil 27 nil nil 410 #{UI.ContainerView} 34 15 nil 2880 34 2 8 1149239296 131073 4000 nil 1536 nil 7 nil nil nil 4000 498 1 1 410 #{UI.StaticText} 34 16 nil 4000 34 2 8 1140850945 1 4080 nil nil 674 177 81 7 nil 594 nil true 626 8 #[224 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 32 66 108 97 99 107 0 0 0 196 53 15 1 2 0 144 39 0 0 0 0 191 0 253 85 63 1] 944 nil 4080 nil 8 1815137184 1049094 #{UI.NullConverter} nil nil true 1026 34 2 1074 #createAt:extent: 34 2 674 1 1 674 933 121 4080 1074 #text: 34 1 8 'N/A' 4080 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 210 1 0 0 60 0 0 0] 8 #() 1296 nil 27 nil nil nil 410 #{UI.StaticText} 34 16 nil 4000 34 2 8 1140850945 65 4448 nil nil nil 7 nil 594 nil true 626 8 #[240 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 68 132 66 49 15 1 0 0 196 53 15 1 2 0 144 39 0 0 0 0 191 0 253 85 63 1] 944 nil 4448 nil 8 1815137184 4226 nil nil nil 1026 34 2 1074 #createAt:extent: 34 2 674 1 121 674 933 83 4448 1074 #text: 34 1 8 '...' 4448 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 60 0 0 0 210 1 0 0 101 0 0 0] 8 #() 1296 nil 27 170 192 34 4 4448 8 'details' 4080 8 'mode' nil 1026 34 1 1074 #createAt:extent: 34 2 674 1 1 674 937 207 4000 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 212 1 0 0 103 0 0 0] 34 2 4448 4080 1296 nil 27 170 192 2368 1180166 #{Graphics.Rectangle} 674 1 1 674 1 1 1026 34 1 1074 #createAt:extent: 34 2 674 1 49 674 937 255 2880 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 24 0 0 0 212 1 0 0 151 0 0 0] 34 2 4000 2960 1296 nil 27 170 192 34 2 2880 8 'colorField' nil nil nil nil nil 1 nil nil nil 674 969 381 1 nil nil 1026 34 2 1074 #createAt:extent: 34 2 674 12287 21 674 969 381 416 1074 #text: 34 1 8 'SUnit Camp Smalltalk 3.0 TestRunner' 416 1234 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 227 25 0 0 200 0 0 0] 34 2 528 2880 1296 nil 27)!

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

