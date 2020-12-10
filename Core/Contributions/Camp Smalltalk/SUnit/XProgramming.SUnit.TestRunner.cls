"Filed out from Dolphin Smalltalk 7"!

UI.Shell subclass: #'XProgramming.SUnit.TestRunner'
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
!XProgramming.SUnit.TestRunner categoriesFor: #allTestSuite!helpers!public! !
!XProgramming.SUnit.TestRunner categoriesFor: #createSchematicWiring!helpers!private! !
!XProgramming.SUnit.TestRunner categoriesFor: #debugFailedTest!Actions!public! !
!XProgramming.SUnit.TestRunner categoriesFor: #debugTest!Actions!public! !
!XProgramming.SUnit.TestRunner categoriesFor: #debugTest:!Actions!public! !
!XProgramming.SUnit.TestRunner categoriesFor: #displayClear!public!Updating! !
!XProgramming.SUnit.TestRunner categoriesFor: #displayColor:!public!Updating! !
!XProgramming.SUnit.TestRunner categoriesFor: #displayDefects:!public!Updating! !
!XProgramming.SUnit.TestRunner categoriesFor: #displayDetails:!public!Updating! !
!XProgramming.SUnit.TestRunner categoriesFor: #displayFail!public!Updating! !
!XProgramming.SUnit.TestRunner categoriesFor: #displayGreen!public!Updating! !
!XProgramming.SUnit.TestRunner categoriesFor: #displayMode:!public!Updating! !
!XProgramming.SUnit.TestRunner categoriesFor: #displayPass!public!Updating! !
!XProgramming.SUnit.TestRunner categoriesFor: #displayRed!public!Updating! !
!XProgramming.SUnit.TestRunner categoriesFor: #displayReset!public!Updating! !
!XProgramming.SUnit.TestRunner categoriesFor: #displayRunning!public!Updating! !
!XProgramming.SUnit.TestRunner categoriesFor: #displayYellow!public!Updating! !
!XProgramming.SUnit.TestRunner categoriesFor: #onViewOpened!Actions!public! !
!XProgramming.SUnit.TestRunner categoriesFor: #refreshTests!Actions!public! !
!XProgramming.SUnit.TestRunner categoriesFor: #result!Accessing!public! !
!XProgramming.SUnit.TestRunner categoriesFor: #runAllTests!Actions!public! !
!XProgramming.SUnit.TestRunner categoriesFor: #runSuite:!Actions!public! !
!XProgramming.SUnit.TestRunner categoriesFor: #runTests!Actions!public! !
!XProgramming.SUnit.TestRunner categoriesFor: #script!Accessing!public! !
!XProgramming.SUnit.TestRunner categoriesFor: #timeSinceLastPassAsString!helpers!public! !
!XProgramming.SUnit.TestRunner categoriesFor: #update:!helpers!public! !
!XProgramming.SUnit.TestRunner categoriesFor: #updateDefects!public!Updating! !
!XProgramming.SUnit.TestRunner categoriesFor: #updateWindow!public!Updating! !

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

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 917510 ##(Graphics.Color) #silver nil 37 nil nil nil 416 984838 ##(UI.BorderLayout) 1 1 410 ##(UI.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 528 nil 480 nil 7 nil 852998 ##(Graphics.Font) nil true 655622 ##(OS.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 655878 ##(Graphics.Point) 193 193 nil 528 498 1 1 nil nil 410 ##(UI.ContainerView) 34 15 nil 528 34 2 8 1140850688 131073 720 nil 480 nil 7 nil nil nil 720 nil 170 192 34 2 410 ##(UI.PushButton) 34 20 nil 720 34 2 8 1140924416 1 816 nil 480 674 177 57 7 nil 594 nil true 626 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 68 132 66 49 15 1 0 0 196 53 15 1 2 0 144 39 0 0 0 0 191 0 253 85 63 1] 674 193 193 nil 816 nil 8 1920683440 1377606 4 ##(UI.CommandDescription) #runTests 8 'Run' 1 1 nil nil false nil nil nil 1310982 ##(Core.MessageSequence) 138 144 34 3 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 674 1 1 674 121 49 816 1090 #isEnabled: 8 #(false) 816 1090 #text: 34 1 8 'Run' 816 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 60 0 0 0 24 0 0 0] 8 #() 674 193 193 nil 29 8 'runOne' nil 1026 138 144 34 1 1090 #createAt:extent: 34 2 674 697 1 674 241 49 720 1250 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 92 1 0 0 0 0 0 0 212 1 0 0 24 0 0 0] 34 2 410 ##(UI.PushButton) 34 20 nil 720 34 2 8 1140924416 1 1504 nil 466 #default nil 7 nil 594 nil true 626 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 68 132 66 49 15 1 0 0 196 53 15 1 2 0 144 39 0 0 0 0 191 0 253 85 63 1] 944 nil 1504 nil 8 1920683440 978 #runAllTests 8 'RunAll' 1 1 nil nil false nil nil nil 1026 138 144 34 3 1090 #createAt:extent: 34 2 674 121 1 674 121 49 1504 1090 #isEnabled: 8 #(false) 1504 1090 #text: 34 1 8 'RunAll' 1504 1250 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 60 0 0 0 0 0 0 0 120 0 0 0 24 0 0 0] 8 #() 1312 nil 29 816 1312 nil 27 410 ##(UI.PushButton) 34 20 nil 528 34 2 8 1140924416 1 1920 nil 1568 nil 7 nil 594 nil true 626 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 944 nil 1920 nil 8 1920683440 978 #refreshTests 8 'Refresh' 1 1 nil nil false nil nil nil 1026 138 144 34 3 1090 #createAt:extent: 34 2 674 1 1 674 149 49 1920 1090 #isEnabled: 8 #(false) 1920 1090 #text: 34 1 8 'Refresh' 1920 1250 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 74 0 0 0 24 0 0 0] 8 #() 1312 nil 29 410 ##(UI.ComboBox) 34 17 nil 528 34 2 8 1144063491 1025 2320 787270 2 ##(UI.ListModel) 138 144 8 #() nil 1638406 ##(Kernel.IdentitySearchPolicy) 1568 nil 7 nil 594 nil true 626 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 944 nil 2320 nil 8 1920475232 ##(UI.BasicListAbstract) 8 #() 401 1026 138 144 34 1 1090 #createAt:extent: 34 2 674 149 1 674 549 49 2320 1250 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 74 0 0 0 0 0 0 0 92 1 0 0 24 0 0 0] 8 #() 1312 nil 27 170 192 34 4 2320 8 'scriptModel' 1920 8 'refreshButton' nil 1026 138 144 34 1 1090 #createAt:extent: 34 2 674 1 1 674 937 49 528 1250 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 212 1 0 0 24 0 0 0] 34 3 1920 2320 720 1312 nil 27 nil nil nil 410 ##(UI.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 2944 nil 1568 nil 7 nil nil nil 2944 498 1 1 nil 410 ##(UI.ContainerView) 34 15 nil 2944 34 2 8 1140850688 131073 3024 nil 1568 nil 7 nil nil nil 3024 498 1 1 nil nil 410 ##(UI.PushButton) 34 20 nil 3024 34 2 8 1140924416 1 3104 nil 1568 nil 7 nil 594 nil true 626 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 674 193 193 nil 3104 nil 8 1920683440 978 #debugFailedTest 8 'Debug' 1 1 nil nil false nil nil nil 1026 138 144 34 3 1090 #createAt:extent: 34 2 674 783 1 674 155 49 3104 1090 #isEnabled: 8 #(false) 3104 1090 #text: 34 1 8 'Debug' 3104 1250 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 135 1 0 0 0 0 0 0 212 1 0 0 24 0 0 0] 8 #() 1312 nil 29 nil 410 ##(UI.ComboBox) 34 17 nil 3024 34 2 8 1144063491 1 3520 2386 138 144 2432 nil 2464 1568 nil 7 nil 594 nil true 626 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 674 193 193 nil 3520 nil 8 1920475232 ##(UI.BasicListAbstract) 2544 401 1026 138 144 34 2 1090 #createAt:extent: 34 2 674 1 1 674 783 49 3520 1090 #isEnabled: 8 #(false) 3520 1250 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 135 1 0 0 24 0 0 0] 8 #() 1312 nil 27 170 192 34 4 3104 8 'debugButton' 3520 8 'defects' nil 1026 138 144 34 1 1090 #createAt:extent: 34 2 674 1 207 674 937 49 3024 1250 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 103 0 0 0 212 1 0 0 127 0 0 0] 34 2 3104 3520 1312 nil 27 nil nil 410 ##(UI.ContainerView) 34 15 nil 2944 34 2 8 1149239296 131073 4112 nil 1568 nil 7 nil nil nil 4112 498 1 1 410 ##(UI.StaticText) 34 16 nil 4112 34 2 8 1140850945 1 4192 nil nil 674 177 81 7 nil 594 nil true 626 8 #[224 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 32 66 108 97 99 107 0 0 0 196 53 15 1 2 0 144 39 0 0 0 0 191 0 253 85 63 1] 944 nil 4192 nil 8 1920531648 1049094 ##(UI.NullConverter) nil nil true 1026 138 144 34 2 1090 #createAt:extent: 34 2 674 1 1 674 933 121 4192 1090 #text: 34 1 8 'N/A' 4192 1250 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 210 1 0 0 60 0 0 0] 8 #() 1312 nil 27 nil nil nil 410 ##(UI.StaticText) 34 16 nil 4112 34 2 8 1140850945 65 4576 nil nil nil 7 nil 594 nil true 626 8 #[240 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 68 132 66 49 15 1 0 0 196 53 15 1 2 0 144 39 0 0 0 0 191 0 253 85 63 1] 944 nil 4576 nil 8 1920531648 4338 nil nil nil 1026 138 144 34 2 1090 #createAt:extent: 34 2 674 1 121 674 933 83 4576 1090 #text: 34 1 8 '...' 4576 1250 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 60 0 0 0 210 1 0 0 101 0 0 0] 8 #() 1312 nil 27 170 192 34 4 4192 8 'mode' 4576 8 'details' nil 1026 138 144 34 1 1090 #createAt:extent: 34 2 674 1 1 674 937 207 4112 1250 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 212 1 0 0 103 0 0 0] 34 2 4576 4192 1312 nil 27 170 192 2432 1180166 ##(Graphics.Rectangle) 674 1 1 674 1 1 1026 138 144 34 1 1090 #createAt:extent: 34 2 674 1 49 674 937 255 2944 1250 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 24 0 0 0 212 1 0 0 151 0 0 0] 34 2 4112 3024 1312 nil 27 170 192 34 2 2944 8 'colorField' nil nil nil nil nil 1 nil nil nil 674 969 381 1 nil nil 1026 138 144 34 2 1090 #createAt:extent: 34 2 674 6143 21 674 969 381 416 1090 #text: 34 1 8 'SUnit Camp Smalltalk 3.0 TestRunner' 416 1250 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 227 13 0 0 200 0 0 0] 34 2 528 2944 1312 nil 27)!

toolDescription
	"Answer the description of this tool that should be displayed in, for example,
	the system shell window."

	^self displayString!

toolsFolderHelpId
	^10632! !
!XProgramming.SUnit.TestRunner class categoriesFor: #defaultView!public!views! !
!XProgramming.SUnit.TestRunner class categoriesFor: #icon!constants!public! !
!XProgramming.SUnit.TestRunner class categoriesFor: #initialize!initializing!must strip!private! !
!XProgramming.SUnit.TestRunner class categoriesFor: #open!Init / Release!public! !
!XProgramming.SUnit.TestRunner class categoriesFor: #resource_SUnit_Runner_30!public!resources-views! !
!XProgramming.SUnit.TestRunner class categoriesFor: #toolDescription!constants!public! !
!XProgramming.SUnit.TestRunner class categoriesFor: #toolsFolderHelpId!public! !

