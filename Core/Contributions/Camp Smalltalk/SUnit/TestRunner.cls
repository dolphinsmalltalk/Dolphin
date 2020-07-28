"Filed out from Dolphin Smalltalk 7"!

Shell subclass: #TestRunner
	instanceVariableNames: 'result lastPass'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 327686 ##(Smalltalk.Color) #silver nil 37 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 528 nil 466 #silver nil 7 nil 263174 ##(Smalltalk.Font) nil true 459014 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 nil 528 498 1 1 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 528 34 2 8 1140850688 131073 736 nil 466 #silver nil 7 nil nil nil 736 nil 170 192 34 2 410 ##(Smalltalk.PushButton) 34 20 nil 736 34 2 8 1140924416 1 848 nil 466 #silver 690 177 57 7 nil 610 nil true 642 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 68 132 66 49 15 1 0 0 196 53 15 1 2 0 144 39 0 0 0 0 191 0 253 85 63 1] 690 193 193 nil 848 nil 8 1903885040 1180998 4 ##(Smalltalk.CommandDescription) #runTests 8 'Run' 1 1 nil nil false nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 3 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 690 1 1 690 121 49 848 1138 #isEnabled: 8 #(false) 848 1138 #text: 34 1 8 'Run' 848 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 60 0 0 0 24 0 0 0] 8 #() 690 193 193 nil 29 8 'runOne' nil 1074 138 144 34 1 1138 #createAt:extent: 34 2 690 697 1 690 241 49 736 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 92 1 0 0 0 0 0 0 212 1 0 0 24 0 0 0] 34 2 410 ##(Smalltalk.PushButton) 34 20 nil 736 34 2 8 1140924416 1 1552 nil 466 #default nil 7 nil 610 nil true 642 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 68 132 66 49 15 1 0 0 196 53 15 1 2 0 144 39 0 0 0 0 191 0 253 85 63 1] 992 nil 1552 nil 8 1903885040 1026 #runAllTests 8 'RunAll' 1 1 nil nil false nil nil nil 1074 138 144 34 3 1138 #createAt:extent: 34 2 690 121 1 690 121 49 1552 1138 #isEnabled: 8 #(false) 1552 1138 #text: 34 1 8 'RunAll' 1552 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 60 0 0 0 0 0 0 0 120 0 0 0 24 0 0 0] 8 #() 1360 nil 29 848 1360 nil 27 410 ##(Smalltalk.PushButton) 34 20 nil 528 34 2 8 1140924416 1 1968 nil 1616 nil 7 nil 610 nil true 642 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 992 nil 1968 nil 8 1903885040 1026 #refreshTests 8 'Refresh' 1 1 nil nil false nil nil nil 1074 138 144 34 3 1138 #createAt:extent: 34 2 690 1 1 690 149 49 1968 1138 #isEnabled: 8 #(false) 1968 1138 #text: 34 1 8 'Refresh' 1968 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 74 0 0 0 24 0 0 0] 8 #() 1360 nil 29 410 ##(Smalltalk.ComboBox) 34 17 nil 528 34 2 8 1144063491 1025 2368 590662 2 ##(Smalltalk.ListModel) 138 144 8 #() nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 1616 nil 7 nil 610 nil true 642 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 992 nil 2368 nil 8 1903738896 ##(Smalltalk.BasicListAbstract) 2480 401 1074 138 144 34 1 1138 #createAt:extent: 34 2 690 149 1 690 549 49 2368 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 74 0 0 0 0 0 0 0 92 1 0 0 24 0 0 0] 8 #() 1360 nil 27 170 192 34 4 1968 8 'refreshButton' 2368 8 'scriptModel' nil 1074 138 144 34 1 1138 #createAt:extent: 34 2 690 1 1 690 937 49 528 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 212 1 0 0 24 0 0 0] 34 3 1968 2368 736 1360 nil 27 nil nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 2976 nil 1616 nil 7 nil nil nil 2976 498 1 1 nil 410 ##(Smalltalk.ContainerView) 34 15 nil 2976 34 2 8 1140850688 131073 3056 nil 1616 nil 7 nil nil nil 3056 498 1 1 nil nil 410 ##(Smalltalk.PushButton) 34 20 nil 3056 34 2 8 1140924416 1 3136 nil 1616 nil 7 nil 610 nil true 642 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 690 193 193 nil 3136 nil 8 1903885040 1026 #debugFailedTest 8 'Debug' 1 1 nil nil false nil nil nil 1074 138 144 34 3 1138 #createAt:extent: 34 2 690 783 1 690 155 49 3136 1138 #isEnabled: 8 #(false) 3136 1138 #text: 34 1 8 'Debug' 3136 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 135 1 0 0 0 0 0 0 212 1 0 0 24 0 0 0] 8 #() 1360 nil 29 nil 410 ##(Smalltalk.ComboBox) 34 17 nil 3056 34 2 8 1144063491 1 3552 2434 138 144 2480 nil 2512 1616 nil 7 nil 610 nil true 642 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 690 193 193 nil 3552 nil 8 1903738896 ##(Smalltalk.BasicListAbstract) 2480 401 1074 138 144 34 2 1138 #createAt:extent: 34 2 690 1 1 690 783 49 3552 1138 #isEnabled: 8 #(false) 3552 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 135 1 0 0 24 0 0 0] 8 #() 1360 nil 27 170 192 34 4 3552 8 'defects' 3136 8 'debugButton' nil 1074 138 144 34 1 1138 #createAt:extent: 34 2 690 1 207 690 937 49 3056 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 103 0 0 0 212 1 0 0 127 0 0 0] 34 2 3136 3552 1360 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 2976 34 2 8 1149239296 131073 4144 nil 1616 nil 7 nil nil nil 4144 498 1 1 410 ##(Smalltalk.StaticText) 34 16 nil 4144 34 2 8 1140850945 1 4224 nil nil 690 177 81 7 nil 610 nil true 642 8 #[224 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 32 66 108 97 99 107 0 0 0 196 53 15 1 2 0 144 39 0 0 0 0 191 0 253 85 63 1] 992 nil 4224 nil 8 1903849936 852486 ##(Smalltalk.NullConverter) nil nil true 1074 138 144 34 2 1138 #createAt:extent: 34 2 690 1 1 690 933 121 4224 1138 #text: 34 1 8 'N/A' 4224 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 210 1 0 0 60 0 0 0] 8 #() 1360 nil 27 nil nil nil 410 ##(Smalltalk.StaticText) 34 16 nil 4144 34 2 8 1140850945 65 4608 nil nil nil 7 nil 610 nil true 642 8 #[240 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 68 132 66 49 15 1 0 0 196 53 15 1 2 0 144 39 0 0 0 0 191 0 253 85 63 1] 992 nil 4608 nil 8 1903849936 4370 nil nil nil 1074 138 144 34 2 1138 #createAt:extent: 34 2 690 1 121 690 933 83 4608 1138 #text: 34 1 8 '...' 4608 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 60 0 0 0 210 1 0 0 101 0 0 0] 8 #() 1360 nil 27 170 192 34 4 4224 8 'mode' 4608 8 'details' nil 1074 138 144 34 1 1138 #createAt:extent: 34 2 690 1 1 690 937 207 4144 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 212 1 0 0 103 0 0 0] 34 2 4608 4224 1360 nil 27 170 192 2480 590342 ##(Smalltalk.Rectangle) 690 1 1 690 1 1 1074 138 144 34 1 1138 #createAt:extent: 34 2 690 1 49 690 937 255 2976 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 24 0 0 0 212 1 0 0 151 0 0 0] 34 2 4144 3056 1360 nil 27 170 192 34 2 2976 8 'colorField' nil nil nil nil nil 1 nil nil nil 690 969 381 1 nil nil 1074 138 144 34 3 1138 #createAt:extent: 34 2 690 3839 21 690 969 381 416 1138 #text: 34 1 8 'SUnit Camp Smalltalk 3.0 TestRunner' 416 1138 #updateMenuBar 2480 416 1298 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 99 9 0 0 200 0 0 0] 34 2 528 2976 1360 nil 27 )!

toolDescription
	"Answer the description of this tool that should be displayed in, for example,
	the system shell window."

	^self displayString!

toolsFolderHelpId
	^10632! !
!TestRunner class categoriesFor: #defaultView!public!views! !
!TestRunner class categoriesFor: #icon!constants!public! !
!TestRunner class categoriesFor: #initialize!initializing!must strip!private! !
!TestRunner class categoriesFor: #open!Init / Release!public! !
!TestRunner class categoriesFor: #resource_SUnit_Runner_30!public!resources-views! !
!TestRunner class categoriesFor: #toolDescription!constants!public! !
!TestRunner class categoriesFor: #toolsFolderHelpId!public! !

