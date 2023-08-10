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

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.ShellView} 38 #{Core.Array} 27 nil nil 8 #(13565952 65536) 32 nil 6 #{Graphics.Color} #silver nil 7 nil nil nil 32 1798 #{UI.BorderLayout} 1 1 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 160 nil 112 nil 7 nil 1030 #{Graphics.Font} nil true 262 #{OS.LOGFONT} 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 518 #{Graphics.Point} 193 193 nil 160 130 1 1 nil nil 18 #{UI.ContainerView} 50 15 nil 160 50 2 8 1140850688 131073 352 nil 112 nil 7 nil nil nil 352 nil 550 #{Core.IdentityDictionary} 1 18 #{UI.PushButton} 50 20 nil 352 50 2 8 1140924416 1 448 nil 112 306 177 57 7 nil 226 nil true 258 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 68 132 66 49 15 1 0 0 196 53 15 1 2 0 144 39 0 0 0 0 191 0 253 85 63 1] 306 193 193 nil 448 nil 8 1853182784 1350 4 #{UI.CommandDescription} #runTests 8 'Run' 1 1 nil nil false nil nil nil 262 #{Core.MessageSequence} 50 3 774 #{Core.MessageSend} #createAt:extent: 50 2 306 1 1 306 121 49 448 706 #isEnabled: 8 #(false) 448 706 #text: 50 1 8 'Run' 448 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 60 0 0 0 24 0 0 0] 8 #() 306 193 193 nil 29 8 'runOne' nil 658 50 1 706 #createAt:extent: 50 2 306 697 1 306 241 49 352 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 92 1 0 0 0 0 0 0 212 1 0 0 24 0 0 0] 50 2 18 #{UI.PushButton} 50 20 nil 352 50 2 8 1140924416 1 1104 nil 98 #default nil 7 nil 226 nil true 258 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 68 132 66 49 15 1 0 0 196 53 15 1 2 0 144 39 0 0 0 0 191 0 253 85 63 1] 576 nil 1104 nil 8 1853182784 610 #runAllTests 8 'RunAll' 1 1 nil nil false nil nil nil 658 50 3 706 #createAt:extent: 50 2 306 121 1 306 121 49 1104 706 #isEnabled: 8 #(false) 1104 706 #text: 50 1 8 'RunAll' 1104 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 60 0 0 0 0 0 0 0 120 0 0 0 24 0 0 0] 8 #() 928 nil 29 448 928 nil 27 18 #{UI.PushButton} 50 20 nil 160 50 2 8 1140924416 1 1504 nil 1168 nil 7 nil 226 nil true 258 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 576 nil 1504 nil 8 1853182784 610 #refreshTests 8 'Refresh' 1 1 nil nil false nil nil nil 658 50 3 706 #createAt:extent: 50 2 306 1 1 306 149 49 1504 706 #isEnabled: 8 #(false) 1504 706 #text: 50 1 8 'Refresh' 1504 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 74 0 0 0 24 0 0 0] 8 #() 928 nil 29 18 #{UI.ComboBox} 50 17 nil 160 50 2 8 1144063491 1025 1888 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} 1168 nil 7 nil 226 nil true 258 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 576 nil 1888 nil 8 1852792128 518 #{Core.Message} #displayString 8 #() 8 #() 401 658 50 1 706 #createAt:extent: 50 2 306 149 1 306 549 49 1888 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 74 0 0 0 0 0 0 0 92 1 0 0 24 0 0 0] 8 #() 928 nil 27 418 2 1888 8 'scriptModel' 1504 8 'refreshButton' nil 658 50 1 706 #createAt:extent: 50 2 306 1 1 306 937 49 160 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 212 1 0 0 24 0 0 0] 50 3 1504 1888 352 928 nil 27 nil nil nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 2512 nil 1168 nil 7 nil nil nil 2512 130 1 1 nil 18 #{UI.ContainerView} 50 15 nil 2512 50 2 8 1140850688 131073 2592 nil 1168 nil 7 nil nil nil 2592 130 1 1 nil nil 18 #{UI.PushButton} 50 20 nil 2592 50 2 8 1140924416 1 2672 nil 1168 nil 7 nil 226 nil true 258 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 306 193 193 nil 2672 nil 8 1853182784 610 #debugFailedTest 8 'Debug' 1 1 nil nil false nil nil nil 658 50 3 706 #createAt:extent: 50 2 306 783 1 306 155 49 2672 706 #isEnabled: 8 #(false) 2672 706 #text: 50 1 8 'Debug' 2672 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 135 1 0 0 0 0 0 0 212 1 0 0 24 0 0 0] 8 #() 928 nil 29 nil 18 #{UI.ComboBox} 50 17 nil 2592 50 2 8 1144063491 1 3072 1954 1986 0 nil 2032 1168 nil 7 nil 226 nil true 258 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 306 193 193 nil 3072 nil 8 1852792128 2128 2160 401 658 50 2 706 #createAt:extent: 50 2 306 1 1 306 783 49 3072 706 #isEnabled: 8 #(false) 3072 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 135 1 0 0 24 0 0 0] 8 #() 928 nil 27 418 2 3072 8 'defects' 2672 8 'debugButton' nil 658 50 1 706 #createAt:extent: 50 2 306 1 207 306 937 49 2592 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 103 0 0 0 212 1 0 0 127 0 0 0] 50 2 2672 3072 928 nil 27 nil nil 18 #{UI.ContainerView} 50 15 nil 2512 50 2 8 1149239296 131073 3616 nil 1168 nil 7 nil nil nil 3616 130 1 1 18 #{UI.StaticText} 50 16 nil 3616 50 2 8 1140850945 1 3696 nil nil 306 177 81 7 nil 226 nil true 258 8 #[224 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 32 66 108 97 99 107 0 0 0 196 53 15 1 2 0 144 39 0 0 0 0 191 0 253 85 63 1] 576 nil 3696 nil 8 1853387904 518 #{UI.NullConverter} nil nil true 658 50 2 706 #createAt:extent: 50 2 306 1 1 306 933 121 3696 706 #text: 50 1 8 'N/A' 3696 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 210 1 0 0 60 0 0 0] 8 #() 928 nil 27 nil nil nil 18 #{UI.StaticText} 50 16 nil 3616 50 2 8 1140850945 65 4064 nil nil nil 7 nil 226 nil true 258 8 #[240 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 68 132 66 49 15 1 0 0 196 53 15 1 2 0 144 39 0 0 0 0 191 0 253 85 63 1] 576 nil 4064 nil 8 1853387904 3842 nil nil nil 658 50 2 706 #createAt:extent: 50 2 306 1 121 306 933 83 4064 706 #text: 50 1 8 '...' 4064 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 60 0 0 0 210 1 0 0 101 0 0 0] 8 #() 928 nil 27 418 2 3696 8 'mode' 4064 8 'details' nil 658 50 1 706 #createAt:extent: 50 2 306 1 1 306 937 207 3616 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 212 1 0 0 103 0 0 0] 50 2 4064 3696 928 nil 27 418 0 518 #{Graphics.Rectangle} 306 1 1 306 1 1 658 50 1 706 #createAt:extent: 50 2 306 1 49 306 937 255 2512 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 24 0 0 0 212 1 0 0 151 0 0 0] 50 2 3616 2592 928 nil 27 418 1 2512 8 'colorField' nil nil nil nil nil 1 nil nil nil 306 969 381 1 nil nil 658 50 2 706 #createAt:extent: 50 2 306 6143 21 306 969 381 32 706 #text: 50 1 8 'SUnit Camp Smalltalk 3.0 TestRunner' 32 866 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 227 13 0 0 200 0 0 0] 50 2 160 2512 928 nil 27)!

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

