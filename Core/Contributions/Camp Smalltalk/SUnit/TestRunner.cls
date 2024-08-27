"Filed out from Dolphin Smalltalk"!

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
	lastPass isNil ifTrue: [^''].
	^String streamContents: 
			[:s |
			s nextPutAll: ', '.
			DateAndTime now - lastPass printHumanReadableOn: s.
			s nextPutAll: ' since last Pass']!

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

!TestRunner categoriesForMethods!
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

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 327686 ##(Smalltalk.Color) #silver nil 5 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 528 nil 480 nil 7 nil 263494 1 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 0 65 0 114 0 105 0 97 0 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 528 498 1 1 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 528 34 2 8 1140850688 131073 688 nil 480 nil 7 nil nil nil 688 nil 170 192 34 2 410 ##(Smalltalk.PushButton) 34 20 nil 688 34 2 8 1140924416 1 784 nil 480 328198 ##(Smalltalk.Point) 177 57 7 nil 594 nil true 626 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 0 65 0 114 0 105 0 97 0 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 784 nil 8 1795707744 1180998 4 ##(Smalltalk.CommandDescription) #runTests 8 'Run' 1 1 nil nil false nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[0 0 0 0 0 0 0 0 60 0 0 0 24 0 0 0] 193 816 8 'Run' 784 1058 #isEnabled: 8 #(false) 784 3 8 #() 850 193 193 nil 29 8 'runOne' nil 994 138 144 34 1 1058 #createWindow: 34 1 1106 1138 8 #[92 1 0 0 0 0 0 0 212 1 0 0 24 0 0 0] 193 720 8 '' 688 3 34 2 410 ##(Smalltalk.PushButton) 34 20 nil 688 34 2 8 1140924416 1 1440 nil 466 #default nil 7 nil 594 nil true 626 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 0 65 0 114 0 105 0 97 0 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 1440 nil 8 1795707744 946 #runAllTests 8 'RunAll' 1 1 nil nil false nil nil nil 994 138 144 34 2 1058 #createWindow: 34 1 1106 1138 8 #[60 0 0 0 0 0 0 0 120 0 0 0 24 0 0 0] 193 1472 8 'RunAll' 1440 1058 #isEnabled: 8 #(false) 1440 3 8 #() 850 193 193 nil 29 784 850 193 193 nil 27 410 ##(Smalltalk.PushButton) 34 20 nil 528 34 2 8 1140924416 1 1840 nil 1504 nil 7 nil 594 nil true 626 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 0 65 0 114 0 105 0 97 0 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 1840 nil 8 1795707744 946 #refreshTests 8 'Refresh' 1 1 nil nil false nil nil nil 994 138 144 34 2 1058 #createWindow: 34 1 1106 1138 8 #[0 0 0 0 0 0 0 0 74 0 0 0 24 0 0 0] 193 1872 8 'Refresh' 1840 1058 #isEnabled: 8 #(false) 1840 3 8 #() 850 193 193 nil 29 410 ##(Smalltalk.ComboBox) 34 17 nil 528 34 2 8 1144063491 1025 2208 590662 2 ##(Smalltalk.ListModel) 138 144 8 #() nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 1504 nil 7 nil 594 nil true 626 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 0 65 0 114 0 105 0 97 0 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 2208 nil 8 1795317024 ##(Smalltalk.BasicListAbstract) 8 #() 401 994 138 144 34 1 1058 #createWindow: 34 1 1106 1138 8 #[74 0 0 0 0 0 0 0 92 1 0 0 224 0 0 0] 193 2240 8 '' 2208 3 8 #() 850 193 193 nil 27 170 192 34 4 2208 8 'scriptModel' 1840 8 'refreshButton' nil 994 138 144 34 1 1058 #createWindow: 34 1 1106 1138 8 #[0 0 0 0 0 0 0 0 212 1 0 0 24 0 0 0] 193 560 8 '' 528 3 34 3 1840 2208 688 850 193 193 nil 27 nil nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 2864 nil 1504 nil 7 nil nil nil 2864 498 1 1 nil 410 ##(Smalltalk.ContainerView) 34 15 nil 2864 34 2 8 1140850688 131073 2944 nil 1504 nil 7 nil nil nil 2944 498 1 1 nil nil 410 ##(Smalltalk.PushButton) 34 20 nil 2944 34 2 8 1140924416 1 3024 nil 1504 nil 7 nil 594 nil true 626 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 0 65 0 114 0 105 0 97 0 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 3024 nil 8 1795707744 946 #debugFailedTest 8 'Debug' 1 1 nil nil false nil nil nil 994 138 144 34 2 1058 #createWindow: 34 1 1106 1138 8 #[135 1 0 0 0 0 0 0 212 1 0 0 24 0 0 0] 193 3056 8 'Debug' 3024 1058 #isEnabled: 8 #(false) 3024 3 8 #() 850 193 193 nil 29 nil 410 ##(Smalltalk.ComboBox) 34 17 nil 2944 34 2 8 1144063491 1 3392 2274 138 144 2320 nil 2352 1504 nil 7 nil 594 nil true 626 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 0 65 0 114 0 105 0 97 0 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 3392 nil 8 1795317024 ##(Smalltalk.BasicListAbstract) 2432 401 994 138 144 34 2 1058 #createWindow: 34 1 1106 1138 8 #[0 0 0 0 0 0 0 0 135 1 0 0 224 0 0 0] 193 3424 8 '' 3392 1058 #isEnabled: 8 #(false) 3392 3 8 #() 850 193 193 nil 27 170 192 34 4 3024 8 'debugButton' 3392 8 'defects' nil 994 138 144 34 1 1058 #createWindow: 34 1 1106 1138 8 #[0 0 0 0 103 0 0 0 212 1 0 0 127 0 0 0] 193 2976 8 '' 2944 3 34 2 3024 3392 850 193 193 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 2864 34 2 8 1149239296 131073 4000 nil 1504 nil 7 nil nil nil 4000 498 1 1 410 ##(Smalltalk.StaticText) 34 16 nil 4000 34 2 8 1140850945 1 4080 nil nil 850 177 81 7 nil 594 nil true 626 8 #[224 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 0 65 0 114 0 105 0 97 0 108 0 32 0 66 0 108 0 97 0 99 0 107 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 4080 nil 8 1795912768 852486 ##(Smalltalk.NullConverter) nil nil true 994 138 144 34 2 1058 #createWindow: 34 1 1106 1138 8 #[0 0 0 0 0 0 0 0 210 1 0 0 60 0 0 0] 193 4112 nil 4080 1058 #text: 34 1 8 'N/A' 4080 3 8 #() 850 193 193 nil 27 nil nil nil 410 ##(Smalltalk.StaticText) 34 16 nil 4000 34 2 8 1140850945 65 4464 nil nil nil 7 nil 594 nil true 626 8 #[240 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 0 65 0 114 0 105 0 97 0 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 4464 nil 8 1795912768 4226 nil nil nil 994 138 144 34 2 1058 #createWindow: 34 1 1106 1138 8 #[0 0 0 0 60 0 0 0 210 1 0 0 101 0 0 0] 193 4496 nil 4464 1058 #text: 34 1 8 '...' 4464 3 8 #() 850 193 193 nil 27 170 192 34 4 4464 8 'details' 4080 8 'mode' nil 994 138 144 34 1 1058 #createWindow: 34 1 1106 1138 8 #[0 0 0 0 0 0 0 0 212 1 0 0 103 0 0 0] 193 4032 8 '' 4000 3 34 2 4464 4080 850 193 193 nil 27 170 192 2320 nil 994 138 144 34 1 1058 #createWindow: 34 1 1106 1138 8 #[0 0 0 0 24 0 0 0 212 1 0 0 151 0 0 0] 193 2896 8 '' 2864 3 34 2 4000 2944 850 193 193 nil 27 170 192 34 2 2864 8 'colorField' nil nil nil nil nil 1 nil nil nil 850 969 381 1 nil 193 994 138 144 34 1 1058 #createWindow: 34 1 1106 590342 ##(Smalltalk.Rectangle) 850 6143 21 850 7111 401 193 448 8 'SUnit Camp Smalltalk 3.0 TestRunner' 416 1 34 2 528 2864 850 193 193 nil 27 )!

toolDescription
	"Answer the description of this tool that should be displayed in, for example,
	the system shell window."

	^self displayString!

toolsFolderHelpId
	^10632! !

!TestRunner class categoriesForMethods!
defaultView!public!views! !
icon!constants!public! !
initialize!initializing!must strip!private! !
open!Init / Release!public! !
resource_SUnit_Runner_30!public!resources-views! !
toolDescription!constants!public! !
toolsFolderHelpId!public! !
!

