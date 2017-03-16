"Filed out from Dolphin Smalltalk 7"!

Shell subclass: #TestRunner
	instanceVariableNames: 'result lastPass'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
TestRunner guid: (GUID fromString: '{5e967948-0810-11d4-a876-0050da643bf9}')!
TestRunner comment: 'A TestRunner is a simple graphical user interface to run test cases. A window can be opened via "TestRunner show". '!
!TestRunner categoriesForClass!SUnit! !
!TestRunner methodsFor!

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
	| list button |
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
 	(self view viewNamed: 'colorField') backcolor: (Color perform: aSymbol).
 	(self view viewNamed: 'mode') backcolor: (Color perform: aSymbol).
 	(self view viewNamed: 'details') backcolor: (Color perform: aSymbol)!

displayDefects: aCollection
	| list button |
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
	self displayDetails: result runCount printString , ' run' , self timeSinceLastPassAsString.
	lastPass := Time now!

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

formatTime: aTime 
	aTime hours > 0 ifTrue: [^aTime hours printString , 'h'].
	aTime minutes > 0 ifTrue: [^aTime minutes printString , 'min'].
	^aTime seconds printString , ' sec'!

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
	lastPass isNil ifTrue: [^''].
	^', ' , (self formatTime: (Time now subtractTime: lastPass)) , ' since last Pass'!

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
!TestRunner categoriesFor: #allTestSuite!helpers!public! !
!TestRunner categoriesFor: #createSchematicWiring!helpers!private! !
!TestRunner categoriesFor: #debugFailedTest!Actions!public! !
!TestRunner categoriesFor: #debugTest!Actions!public! !
!TestRunner categoriesFor: #debugTest:!Actions!public! !
!TestRunner categoriesFor: #displayClear!public!Updating! !
!TestRunner categoriesFor: #displayColor:!public!Updating! !
!TestRunner categoriesFor: #displayDefects:!public!Updating! !
!TestRunner categoriesFor: #displayDetails:!public!Updating! !
!TestRunner categoriesFor: #displayFail!public!Updating! !
!TestRunner categoriesFor: #displayGreen!public!Updating! !
!TestRunner categoriesFor: #displayMode:!public!Updating! !
!TestRunner categoriesFor: #displayPass!public!Updating! !
!TestRunner categoriesFor: #displayRed!public!Updating! !
!TestRunner categoriesFor: #displayReset!public!Updating! !
!TestRunner categoriesFor: #displayRunning!public!Updating! !
!TestRunner categoriesFor: #displayYellow!public!Updating! !
!TestRunner categoriesFor: #formatTime:!helpers!public! !
!TestRunner categoriesFor: #onViewOpened!Actions!public! !
!TestRunner categoriesFor: #refreshTests!Actions!public! !
!TestRunner categoriesFor: #result!Accessing!public! !
!TestRunner categoriesFor: #runAllTests!Actions!public! !
!TestRunner categoriesFor: #runSuite:!Actions!public! !
!TestRunner categoriesFor: #runTests!Actions!public! !
!TestRunner categoriesFor: #script!Accessing!public! !
!TestRunner categoriesFor: #timeSinceLastPassAsString!helpers!public! !
!TestRunner categoriesFor: #update:!helpers!public! !
!TestRunner categoriesFor: #updateDefects!public!Updating! !
!TestRunner categoriesFor: #updateWindow!public!Updating! !

!TestRunner class methodsFor!

defaultView
	^'SUnit Runner 3.0'!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

initialize
	"Private - Initialize the receiver. Register the tools folder icon with SmalltalkSystem.

		self initialize.
	"

	(Smalltalk developmentSystem)
		addAdditionalToolsFolderIcon: (SmalltalkSystemIcon 
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
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_SUnit_Runner_30)
	"

	^#(#'!!STL' 3 788558 10 ##(STBViewProxy)  8 ##(ShellView)  98 27 0 0 98 2 27131905 131073 416 0 196934 1 ##(RGB)  25264513 0 5 0 0 0 416 788230 ##(BorderLayout)  1 1 410 8 ##(ContainerView)  98 15 0 416 98 2 8 1140850688 131073 544 0 482 25264513 0 5 0 263174 ##(Font)  0 16 459014 ##(LOGFONT)  8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Point)  193 193 0 544 514 1 1 0 0 410 560 98 15 0 544 98 2 8 1140850688 131073 768 0 482 25264513 0 5 0 0 0 768 0 234 256 98 2 410 8 ##(PushButton)  98 17 0 768 98 2 8 1140924416 1 880 0 482 25264513 722 177 57 5 0 642 0 16 674 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 68 132 66 49 15 1 0 0 196 53 15 1 2 0 144 39 0 0 0 0 191 0 253 85 63 1] 722 193 193 0 880 0 8 4294906781 1180998 4 ##(CommandDescription)  8 #runTests 8 'Run' 1 1 0 0 32 983302 ##(MessageSequence)  202 208 98 3 721670 ##(MessageSend)  8 #createAt:extent: 98 2 722 1 1 722 121 49 880 1202 8 #isEnabled: 98 1 32 880 1202 8 #text: 98 1 8 'Run' 880 983302 ##(WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 60 0 0 0 24 0 0 0] 98 0 722 193 193 0 27 8 'runOne' 0 1138 202 208 98 1 1202 1232 98 2 722 713 1 722 241 49 768 1410 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 100 1 0 0 0 0 0 0 220 1 0 0 24 0 0 0] 98 2 410 896 98 17 0 768 98 2 8 1140924416 1 1664 0 524550 ##(ColorRef)  8 4278190080 0 5 0 642 0 16 674 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 68 132 66 49 15 1 0 0 196 53 15 1 2 0 144 39 0 0 0 0 191 0 253 85 63 1] 1040 0 1664 0 8 4294906781 1074 8 #runAllTests 8 'RunAll' 1 1 0 0 32 1138 202 208 98 2 1202 1232 98 2 722 121 1 722 121 49 1664 1202 1360 98 1 8 'RunAll' 1664 1410 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 60 0 0 0 0 0 0 0 120 0 0 0 24 0 0 0] 98 0 1472 0 27 880 1472 0 27 410 896 98 17 0 544 98 2 8 1140924416 1 2096 0 1730 1760 0 5 0 642 0 16 674 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 1040 0 2096 0 8 4294906781 1074 8 #refreshTests 8 'Refresh' 1 1 0 0 32 1138 202 208 98 2 1202 1232 98 2 722 1 1 722 149 49 2096 1202 1360 98 1 8 'Refresh' 2096 1410 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 74 0 0 0 24 0 0 0] 98 0 1472 0 27 410 8 ##(ComboBox)  98 17 0 544 98 2 8 1144063491 1025 2496 590662 2 ##(ListModel)  202 208 98 0 0 1114638 ##(STBSingletonProxy)  8 ##(SearchPolicy)  8 #identity 1730 1760 0 5 0 642 0 16 674 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 1040 0 2496 0 8 4294906641 8 ##(BasicListAbstract)  2624 401 1138 202 208 98 1 1202 1232 98 2 722 149 1 722 565 49 2496 1410 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 74 0 0 0 0 0 0 0 100 1 0 0 24 0 0 0] 98 0 1472 0 27 234 256 98 4 2496 8 'scriptModel' 2096 8 'refreshButton' 0 1138 202 208 98 1 1202 1232 98 2 722 1 1 722 953 49 544 1410 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 220 1 0 0 24 0 0 0] 98 3 2096 2496 768 1472 0 27 0 0 0 410 560 98 15 0 416 98 2 8 1140850688 131073 3184 0 1730 1760 0 5 0 0 0 3184 514 1 1 0 410 560 98 15 0 3184 98 2 8 1140850688 131073 3280 0 1730 1760 0 5 0 0 0 3280 514 1 1 0 0 410 896 98 17 0 3280 98 2 8 1140924416 1 3376 0 1730 1760 0 5 0 642 0 16 674 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 722 193 193 0 3376 0 8 4294906781 1074 8 #debugFailedTest 8 'Debug' 1 1 0 0 32 1138 202 208 98 3 1202 1232 98 2 722 799 1 722 155 49 3376 1202 1312 98 1 32 3376 1202 1360 98 1 8 'Debug' 3376 1410 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 143 1 0 0 0 0 0 0 220 1 0 0 24 0 0 0] 98 0 1472 0 27 0 410 2512 98 17 0 3280 98 2 8 1144063491 1 3824 2578 202 208 2624 0 2656 1730 1760 0 5 0 642 0 16 674 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 722 193 193 0 3824 0 8 4294906641 2784 2624 401 1138 202 208 98 2 1202 1232 98 2 722 1 1 722 799 49 3824 1202 1312 98 1 32 3824 1410 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 143 1 0 0 24 0 0 0] 98 0 1472 0 27 234 256 98 4 3824 8 'defects' 3376 8 'debugButton' 0 1138 202 208 98 1 1202 1232 98 2 722 1 217 722 953 49 3280 1410 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 108 0 0 0 220 1 0 0 132 0 0 0] 98 2 3376 3824 1472 0 27 0 0 410 560 98 15 0 3184 98 2 8 1149239296 131073 4432 0 1730 1760 0 5 0 0 0 4432 514 1 1 410 8 ##(StaticText)  98 16 0 4432 98 2 8 1140850945 1 4528 0 0 722 177 81 5 0 642 0 16 674 8 #[224 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 32 66 108 97 99 107 0 0 0 196 53 15 1 2 0 144 39 0 0 0 0 191 0 253 85 63 1] 1040 0 4528 0 8 4294906439 852486 ##(NullConverter)  0 0 16 1138 202 208 98 2 1202 1232 98 2 722 1 1 722 949 121 4528 1202 1360 98 1 8 'N/A' 4528 1410 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 218 1 0 0 60 0 0 0] 98 0 1472 0 27 0 0 0 410 4544 98 16 0 4432 98 2 8 1140850945 65 4928 0 0 0 5 0 642 0 16 674 8 #[240 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 68 132 66 49 15 1 0 0 196 53 15 1 2 0 144 39 0 0 0 0 191 0 253 85 63 1] 1040 0 4928 0 8 4294906439 4690 0 0 0 1138 202 208 98 2 1202 1232 98 2 722 1 121 722 949 93 4928 1202 1360 98 1 8 '...' 4928 1410 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 60 0 0 0 218 1 0 0 106 0 0 0] 98 0 1472 0 27 234 256 98 4 4528 8 'mode' 4928 8 'details' 0 1138 202 208 98 1 1202 1232 98 2 722 1 1 722 953 217 4432 1410 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 220 1 0 0 108 0 0 0] 98 2 4928 4528 1472 0 27 234 256 2624 590342 ##(Rectangle)  722 1 1 722 1 1 1138 202 208 98 1 1202 1232 98 2 722 1 49 722 953 265 3184 1410 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 24 0 0 0 220 1 0 0 156 0 0 0] 98 2 4432 3280 1472 0 27 234 256 98 2 3184 8 'colorField' 0 0 0 0 0 1 0 0 0 722 969 381 1 0 0 1138 202 208 98 3 1202 1232 98 2 722 309 407 722 969 381 416 1202 1360 98 1 8 'SUnit Camp Smalltalk 3.0 TestRunner' 416 1202 8 #menuBar: 98 1 0 416 1410 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 154 0 0 0 203 0 0 0 126 2 0 0 137 1 0 0] 98 2 544 3184 1472 0 27 )!

toolDescription
	"Answer the description of this tool that should be displayed in, for example,
	the system shell window."

	^self displayString!

toolsFolderHelpId
	^10632!

uninitialize
	"Private - Un-register the system tools folder icon for the receiver to allow clean
	removal of this class from the system.
		self uninitialize
	"

	Smalltalk developmentSystem
		removeSystemFolderIconNamed: self toolDescription;
		unregisterTool: self! !
!TestRunner class categoriesFor: #defaultView!public!views! !
!TestRunner class categoriesFor: #icon!constants!public! !
!TestRunner class categoriesFor: #initialize!initializing!must strip!private! !
!TestRunner class categoriesFor: #open!Init / Release!public! !
!TestRunner class categoriesFor: #resource_SUnit_Runner_30!public!resources-views! !
!TestRunner class categoriesFor: #toolDescription!constants!public! !
!TestRunner class categoriesFor: #toolsFolderHelpId!public! !
!TestRunner class categoriesFor: #uninitialize!class hierarchy-removing!private! !

