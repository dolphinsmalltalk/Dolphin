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

colorField
	^self view viewNamed: 'colorField'!

createSchematicWiring
	self defectsList
		when: #selectionChanged
		send: #debugTest
		to: self!

debugFailedTest
	<commandQuery: #hasFailureSelected>
	self debugTest!

debugTest
	| list failed |
	list := self defectsList.
	list selectionOrNil isNil ifTrue: [^self].
	failed := list selection.
	self debugTest: failed!

debugTest: aTestCase 
	aTestCase isNil ifTrue: [^self].
	self displayMode: 'Debugging'.
	aTestCase debug!

defectsList
	^self view viewNamed: 'defects'!

detailsField
	^self view viewNamed: 'details'!

displayClear
	self displayColor: UI.Color default!

displayColor: aColor
	self colorField backcolor: aColor!

displayDefects: aCollection
	| list |
	list := self defectsList.
	list selectionOrNil: nil.
	list list: aCollection.
	list isEnabled: aCollection isEmpty not!

displayDetails: aString
	| details |
	details := self detailsField.
	details value: aString.
	SessionManager inputState pumpMessages!

displayFail
	self displayRed.
	self displayMode: 'Fail'.
	self displayDetails: result printString.!

displayGreen
	self displayColor: (Graphics.Color
				r: 100
				g: 210
				b: 103)!

displayMode: aString
 	| mode |
	mode := self view viewNamed: 'mode'.
	mode value: aString.
	!

displayPass
	self displayGreen.
	self displayMode: 'Pass'.
	self displayDetails: result printString , self timeSinceLastPassAsString.
	lastPass := DateAndTime now!

displayRed
	self displayColor: (Graphics.Color
				r: 243
				g: 27
				b: 65)!

displayReset
	self displayClear.
	self displayMode: 'N/A'.
	self displayDetails: '...'.
	self displayDefects: OrderedCollection new.!

displayRunning
	self displayYellow.
	self displayMode: 'Running'. 
	self displayDetails: '…'.!

displayYellow
	self displayColor: (Graphics.Color
				r: 235
				g: 201
				b: 65)!

failure
	^self defectsList selectionOrNil!

fillTestList
	self scriptList list: TestCase allSubclasses asSortedCollection!

hasFailureSelected
	^self failure notNil!

hasTestSelected
	^self script notNil!

onViewOpened
	super onViewOpened.
	self caption: 'SUnit Camp Smalltalk ' , TestCase version , ' TestRunner'.
	self fillTestList!

refreshTests
	self fillTestList.
	self displayReset!

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
	<commandQuery: #hasTestSelected>
	self runSuite: self script suite!

script
	^self scriptList selectionOrNil!

scriptList
	^self view viewNamed: 'scriptModel'!

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
colorField!accessing!private! !
createSchematicWiring!helpers!private! !
debugFailedTest!Actions!public! !
debugTest!Actions!public! !
debugTest:!Actions!public! !
defectsList!accessing!private! !
detailsField!accessing!private! !
displayClear!public!Updating! !
displayColor:!private!Updating! !
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
failure!Accessing!public! !
fillTestList!helpers!private! !
hasFailureSelected!public!testing! !
hasTestSelected!public!testing! !
onViewOpened!Actions!public! !
refreshTests!Actions!public! !
result!Accessing!public! !
runAllTests!Actions!public! !
runSuite:!Actions!public! !
runTests!Actions!public! !
script!Accessing!public! !
scriptList!accessing!private! !
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

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.ShellView} 38 #{Core.Array} 27 nil nil 8 #(13565952 65536) 32 nil 6 #{Graphics.Color} #silver 518 #{Graphics.Point} 1121 381 517 nil 1350 1 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 32 1798 #{UI.BorderLayout} 1 1 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 272 nil 112 nil 5 nil nil nil 272 242 1 1 nil nil 18 #{UI.Toolbar} 50 28 nil 272 50 2 8 1409293132 131137 352 nil 98 #face3d nil 517 nil nil nil 352 98 #default nil 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 8 #() nil nil nil nil 50 2 1094 1 #{UI.ToolbarIconButton} 352 1 1350 4 #{UI.CommandDescription} #runTests 8 '&Run' 1 1 838 4 #{Graphics.Icon} nil true 1030 #{Graphics.ImageFromStringResourceInitializer} 8 'Run.ico' 838 1 #{External.ResourceLibrary} 8 'dolphindr8.dll' 65541 nil nil 514 352 1 546 #runAllTests 8 'Run &All' 1 1 594 nil true 626 8 'ProgressBar.ico' 688 65541 nil nil nil nil 11 1 nil nil nil nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[164 1 0 0 0 0 0 0 32 2 0 0 24 0 0 0] 193 384 8 '' 352 3 8 #() 130 193 193 nil 31 18 #{UI.Toolbar} 50 28 nil 272 50 2 8 1409293132 131137 1040 nil 432 nil 517 nil nil nil 1040 432 nil 450 #{Core.IdentityDictionary} 480 nil nil nil nil 50 1 514 1040 1 546 #refreshTests 8 'Re&fresh' 1 1 594 nil true 626 8 'Refresh.ico' 688 65541 nil nil nil nil 11 nil #smallIcons nil nil 838 1 #{UI.FlowLayout} 1 1 1 818 50 1 866 #createWindow: 50 1 914 946 8 #[0 0 0 0 0 0 0 0 70 0 0 0 24 0 0 0] 193 1072 8 '' 1040 3 8 #() 130 193 193 nil 31 18 #{UI.ComboBox} 50 17 nil 272 50 2 8 1144063491 1025 1424 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} 432 nil 5 nil nil nil 1424 nil nil 1382 3 #{Kernel.BlockClosure} 0 nil 1318 #{Kernel.CompiledExpression} 8 1 #{Core.Message} 8 'doIt' 8 '[:each | ''<1s> (<2s>)'' << { each name. each environment fullName }]' 8 #[36 105 29 226 1 226 2 161 49 64 181 182 106] 8 '<1s> (<2s>)' #name #environment #fullName 1094 2 #{Kernel.VariableBinding} #Array 48 #{Core} 1 #newFromStack: #<< 1600 7 257 nil 8 #() 401 818 50 1 866 #createWindow: 50 1 914 946 8 #[70 0 0 0 0 0 0 0 164 1 0 0 225 0 0 0] 193 1456 8 '' 1424 3 8 #() 130 193 193 nil 27 450 #{Core.IdentityDictionary} 50 6 1040 8 'refreshButton' 352 8 'runButtons' 1424 8 'scriptModel' nil 818 50 1 866 #createWindow: 50 1 914 946 8 #[0 0 0 0 0 0 0 0 32 2 0 0 24 0 0 0] 193 304 8 '' 272 3 50 3 1040 1424 352 130 193 193 nil 27 nil nil nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 2160 nil 432 nil 5 nil nil nil 2160 242 1 1 nil 18 #{UI.ContainerView} 50 15 nil 2160 50 2 8 1140850688 131073 2240 nil 416 nil 5 nil nil nil 2240 242 1 1 nil nil 18 #{UI.Toolbar} 50 28 nil 2240 50 2 8 1409293132 131137 2320 nil 432 nil 517 nil nil nil 2320 432 nil 450 #{Core.IdentityDictionary} 480 nil nil nil nil 50 1 514 2320 1 546 #debugFailedTest 8 '&Debug' 1 1 594 nil true 626 8 'Debugger.ico' 688 65541 nil nil nil nil 11 nil nil nil nil 1234 1 1 1 818 50 1 866 #createWindow: 50 1 914 946 8 #[218 1 0 0 0 0 0 0 32 2 0 0 26 0 0 0] 193 2352 8 '' 2320 3 8 #() 130 193 193 nil 31 nil 18 #{UI.ComboBox} 50 17 nil 2240 50 2 8 1144063491 1 2688 1490 1522 0 nil 1568 nil nil 5 nil nil nil 2688 nil nil 518 #{Core.Message} #displayString 8 #() 8 #() 401 818 50 2 866 #createWindow: 50 1 914 946 8 #[0 0 0 0 0 0 0 0 218 1 0 0 225 0 0 0] 193 2720 8 '' 2688 866 #isEnabled: 8 #(false) 2688 3 8 #() 130 193 193 nil 27 450 #{Core.IdentityDictionary} 50 4 2320 8 'debugFailedTest' 2688 8 'defects' nil 818 50 1 866 #createWindow: 50 1 914 946 8 #[0 0 0 0 101 0 0 0 32 2 0 0 127 0 0 0] 193 2272 8 '' 2240 3 50 2 2688 2320 130 193 193 nil 27 nil nil 18 #{UI.ContainerView} 50 15 nil 2160 50 2 8 1149239296 131073 3264 nil nil nil 5 nil nil nil 3264 242 1 1 18 #{UI.StaticText} 50 16 nil 3264 50 2 8 1140850945 1 3344 nil nil 130 177 81 5 nil 162 nil true 194 8 #[224 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 3344 nil nil 518 #{UI.NullConverter} nil nil true 818 50 2 866 #createWindow: 50 1 914 946 8 #[0 0 0 0 10 0 0 0 30 2 0 0 65 0 0 0] 193 3376 nil 3344 866 #text: 50 1 8 'N/A' 3344 3 8 #() 130 193 193 nil 27 nil nil nil 18 #{UI.StaticText} 50 16 nil 3264 50 2 8 1140850945 65 3696 nil nil nil 5 nil 162 nil true 194 8 #[241 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 88 2 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 32 0 83 0 101 0 109 0 105 0 98 0 111 0 108 0 100 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 3696 nil nil 3474 nil nil nil 818 50 2 866 #createWindow: 50 1 914 946 8 #[0 0 0 0 65 0 0 0 30 2 0 0 99 0 0 0] 193 3728 nil 3696 866 #text: 50 1 8 '...' 3696 3 8 #() 130 193 193 nil 27 450 #{Core.IdentityDictionary} 50 4 3696 8 'details' 3344 8 'mode' 518 #{Graphics.Rectangle} 130 1 21 130 1 1 818 50 1 866 #createWindow: 50 1 914 946 8 #[0 0 0 0 0 0 0 0 32 2 0 0 101 0 0 0] 193 3296 8 '' 3264 3 50 2 3696 3344 130 193 193 nil 27 550 #{Core.IdentityDictionary} 0 nil 818 50 1 866 #createWindow: 50 1 914 946 8 #[0 0 0 0 24 0 0 0 32 2 0 0 151 0 0 0] 193 2192 8 '' 2160 3 50 2 3264 2240 130 193 193 nil 27 450 4304 50 2 2160 8 'colorField' nil nil nil nil nil 1 nil nil nil 130 969 381 nil nil 193 818 50 1 866 #createWindow: 50 1 914 4082 130 7679 21 130 8799 401 193 80 8 'SUnit Camp Smalltalk 3.0 TestRunner' 32 1 50 2 272 2160 130 193 193 nil 27)!

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

