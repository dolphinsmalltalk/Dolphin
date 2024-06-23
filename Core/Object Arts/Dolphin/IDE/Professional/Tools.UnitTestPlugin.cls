"Filed out from Dolphin Smalltalk"!

Tools.ClassBrowserPlugin
	subclass: #'Tools.UnitTestPlugin'
	instanceVariableNames: 'result icon autoSwitchProcess defectsPresenter modePresenter detailsPresenter'
	classVariableNames: 'AutoSwitchDelay ErrorColor FailColor NoTestsColor PassColor RunningColor'
	imports: #(#{XProgramming.SUnit private})
	classInstanceVariableNames: ''
	classConstants: {}!

Tools.UnitTestPlugin guid: (Core.GUID fromString: '{e8b10dcb-9855-41f7-95d2-a91639377d01}')!

Tools.UnitTestPlugin comment: '`UnitTestPlugin` is a `<classBrowserPlugin>` that provides SUnit test running facilities within a browser. The aim is to allow tests directly relevant to the current class being worked on in the browser to be run quickly and easily using a single hotkey or menu command. Failing tests can be isolated and run within the debugger. The `UnitTestPlugin` does not provide facilities to run large suites of tests comprising of more than one `TestCase`; this functionaility is left to the `SUnitBrowser` and `TestRunner` tools.

When a class is selected in the browser, the `UnitTestPlugin` determines if there is a `TestCase` subclass that can be associated with it. By default, `ClassDescription>>correspondingTestCase` is used to do this by simply appending ''Test'' to the name of the class. If the mapping between a class under test and its `TestCase` is not so straightforward it is alway possible to implement `#correspondingTestCase` as a class method that directly answers the correct `TestCase` subclass. Typically, if used, this class method would be installed as a loose method in the package containing the tests. 

If such a test case class exists then a `TestSuite` is built and held by the plugin to be run at the user''s request. A `UnitTestPlugin` dynamically installs new menu commands into the Class and Method menus of the associated browser. The `#runTests` command will run the available tests. A traffic light scheme is used to display the result of the tests in the plugin pane''s tab. If the tests take a long time to run, or if a test fails, the `UnitTestPlugin` will automatically make itself the foreground pane in the browser.

Another menu command that is made available is `#toggleToTests`. This allows the developer to quickly move the browser between the class under test and its corresponding `TestCase` class (and vice versa). When the browser displays a `TestCase` class the `#runTests` command will run all the tests in that test case. If, however, one or more individual test methods (`#testXXX` methods) are selected then only these will be executed when a `#runTests` is performed.

When tests fail, a list of the defects is retained by the plugin. Using the drop down list at the bottom of the plugin''s display you can choose each of the failing tests to re-run under the control of the debugger.

##Instance Variables:
  `result`				`TestResult` indicating the results of the last executed tests
  `icon`				`Icon` used to provide a traffic light representation of the current state of the plugin 
  `autoSwitchProcess`	Background `Process` started when tests are running to automatically switch to the plugin pane to show progress if the tests take a long time to complete.
  `defectsPresenter`		`ListPresenter` showing a list of defects when some tests have failed
  `modePresenter`		`TextPresenter` describing the current running state
  `detailsPresenter`		`TextPresenter` providing further details about the current running state

##Class Variables:
  `AutoSwitchDelay`		`Duration` after which the `autoSwitchProcess` will bring the plugin pane to the foreground
  `ErrorColor`			`<color>` to be used as the background colour when one or more tests throw errors
  `FailColor`			`<color>` to be used as the background colour when one or more tests fail, but there are no errors
  `PassColor`			`<color>` to be used as the background colour when all tests pass
  `RunningColor`		`<color>` to be used as the background colour when tests are running
  `NoTestsColor`		`<color>` to be used as the background colour when no tests are available for the browser selection
'!

!Tools.UnitTestPlugin categoriesForClass!Browser-Plugins! !

!Tools.UnitTestPlugin methodsFor!

addToCommandRouteInactive: aCommandPolicy
	"Update the command routing path of the <CommandPolicy> argument with the receiver's contribution to the command path when it is not the active plugin. This is generally only required for plugins that contribute global commands associated with keyboard accelerators and/or on the menubar menus."

	self addToCommandRoute: aCommandPolicy!

allContextMenus
	| allMenus |
	allMenus := OrderedCollection new.
	self browser view
		withAllSubViewsDo: [:each | each contextMenu ifNotNil: [:menu | allMenus addAll: menu allMenus]].
	^allMenus!

allMenuBarMenus
	^self browser view menuBar allMenus
!

classUnderTest
	"Private - Answer the class being tested. If the currently selected class in the browser is a TestCase then try and locate the class
	that this tests. If none is found, answer nil. If the current class is not a TestCase then answer that class regardless."

	| currentClass classUnderTest |
	currentClass := self browser selectedClass.
	currentClass isNil ifTrue: [^nil].
	classUnderTest := Class allClasses
				detect: [:each | each ~~ currentClass and: [each correspondingTestCase = currentClass]]
				ifNone: nil.
	^classUnderTest!

completeRun: aTestSuite
	aTestSuite removeDependentFromHierachy: self.
	self stopAutoSwitchProcess!

createComponents
	"Private - Create the presenters contained by the receiver"

	super createComponents.
	modePresenter := self add: TextPresenter new name: 'mode'.
	detailsPresenter := self add: TextPresenter new name: 'details'.
	defectsPresenter := self add: ListPresenter new name: 'defects'!

createSchematicWiring
	| list |
	super createSchematicWiring.
	(self model)
		when: #classSelected
			send: #onBrowserClassSelected
			to: self;
		when: #methodSelected
			send: #onBrowserMethodSelected
			to: self.
	list := self view viewNamed: 'defects' ifNone: [^self].
	list 
		when: #selectionChanged
		send: #debugTest
		to: self!

debugTest
	"Debug the currently selected defect. If no defects are selected then select and ebug the first one"

	<commandQuery: #hasDefects>
	defectsPresenter hasSelection ifFalse: [defectsPresenter selectionByIndex: 1].
	self debugTest: defectsPresenter selection!

debugTest: aTestCaseResult
	self displayMode: 'Debugging'.
	aTestCaseResult case debug!

defaultHelpId
	^10994!

displayColor: aColor 
	modePresenter view backcolor: aColor.
	detailsPresenter view backcolor: aColor!

displayDefects: aCollection
	defectsPresenter list: aCollection.
	defectsPresenter view isEnabled: aCollection notEmpty!

displayDetails: aString 
	"Display aString to indicate additional details about the current mode of operation"

	detailsPresenter value: aString!

displayErrors
	"Indicate that some tests have failed and we have defects"

	self icon: (Icon fromId: 'UnitTestPluginFail.ico').
	self displayColor: self class errorColor.
	self displayMode: 'Error'.
	self displayDetails: (result displayString: Locale smalltalk).
	self ensureVisible!

displayFail
	"Indicate that some tests have failed and we have defects"

	self icon: (Icon fromId: 'UnitTestPluginFail.ico').
	self displayColor: self class failColor.
	self displayMode: 'Fail'.
	self displayDetails: (result displayString: Locale smalltalk).
	self ensureVisible!

displayMode: aString 
	"Display aString to indicate the current mode"

	modePresenter value: aString!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream nextPutAll: 'Unit Tests'!

displayPass
	"Indicate that all tests passed"

	self icon: (Icon fromId: 'UnitTestPluginPass.ico').
	self displayColor: self class passColor.
	self displayMode: 'Pass'.
	self displayDetails: (result displayString: Locale smalltalk)!

displayReset
	self displayColor: self class noTestsColor.
	self hasTests
		ifTrue: 
			[self icon: (Icon fromId: 'UnitTestPluginNotRun.ico').
			self displayMode: 'Not Yet Run']
		ifFalse: 
			[self icon: (Icon fromId: 'UnitTestPluginNoTest.ico').
			self displayMode: 'No Tests'].
	self displayDetails: ''.
	self displayDefects: #().
	result := nil!

displayRunning: aString
	"Indicate that tests are being run"

	self icon: (Icon fromId: 'UnitTestPluginDefect.ico').
	self displayColor: self class runningColor.
	self displayMode: aString.
	self displayDetails: '…'!

hasDefects
	"Answer true if some tests failed and we have defects in our defectsPresenter"

	^defectsPresenter list notEmpty!

hasIndividualTests
	"Answer true if we are looking at a TestCase subclass with one or more  #testXXX methods selected."

	| methods |
	methods := self browser selectedMethods.
	^methods notEmpty and: [(methods select: [:each | TestCase isTestMethod: each]) notEmpty]!

hasTestClass
	"Answer true if we have a corresponding test class so that tests can be run."

	^self testClasses size == 1!

hasTests
	"Answer true if we have a some tests to run."

	^self testClasses notEmpty!

icon
	^icon ifNil: [super icon]!

icon: anIconOrNil
	"Private - Set the icon displayed in the receiver's tab. This is used to indicate whether tests have passed or failed etc."

	icon = anIconOrNil
		ifFalse: 
			[icon := anIconOrNil.
			self refreshIcon]!

installMenuCommands
	"Private - Installs the menu commands required by the receiver into the associated browser menus"

	| classContextMenus classMenuBarMenus methodContextMenus methodMenuBarMenus contextMenus menuBarMenus |
	contextMenus := self allContextMenus.
	classContextMenus := contextMenus
				select: [:each | each items anySatisfy: [:item | item command == #newClass]].
	classContextMenus do: [:each | self installTestCommandsInClassMenu: each withAccelerator: false].
	menuBarMenus := self allMenuBarMenus.
	classMenuBarMenus := menuBarMenus
				select: [:each | each items anySatisfy: [:item | item command == #newClass]].
	classMenuBarMenus do: [:each | self installTestCommandsInClassMenu: each withAccelerator: true].
	methodContextMenus := contextMenus
				select: [:each | each items anySatisfy: [:item | item command == #newMethod]].
	methodContextMenus do: [:each | self installTestCommandsInMethodMenu: each].
	methodMenuBarMenus := menuBarMenus
				select: [:each | each items anySatisfy: [:item | item command == #newMethod]].
	methodMenuBarMenus do: [:each | self installTestCommandsInMethodMenu: each]!

installTestCommandsInClassMenu: aMenu withAccelerator: needsAccel
	"Private - Installs the test commands required by the receiver into aMenu. If an accelerator is required (i.e. in the case of
	non-context menus) then needsAccel should be true"

	| runTestsCommandDescription toggleToTestClassCommandDescription |
	runTestsCommandDescription := CommandDescription command: #runTests description: 'R&un Tests'.
	needsAccel ifTrue: [runTestsCommandDescription acceleratorKeyString: 'Ctrl+Alt+R'].
	runTestsCommandDescription image: self class icon.
	toggleToTestClassCommandDescription := CommandDescription command: #toggleToTests
				description: '&Go to <1d>'.
	toggleToTestClassCommandDescription image: [self toggleToTestsClass ifNotNil: [:class | class icon]].
	needsAccel ifTrue: [toggleToTestClassCommandDescription acceleratorKeyString: 'Ctrl+Alt+T'].
	aMenu
		addSeparator;
		addCommandDescription: runTestsCommandDescription;
		addCommandDescription: toggleToTestClassCommandDescription.
	#{Smalltalk.Profiler} valueOrNil
		ifNotNil: 
			[:profiler |
			aMenu
				addCommandDescription: ((CommandDescription command: #profileTests description: 'Profi&le Tests')
						image: profiler icon;
						yourself)]!

installTestCommandsInMethodMenu: aMenu
	"Private - Installs the method test commands required by the receiver into aMenu."

	| runTestsCommandDescription |
	runTestsCommandDescription := ClosedCommandDescription command: #runTests description: 'R&un Tests'.
	runTestsCommandDescription image: self class icon.
	aMenu
		addSeparator;
		addCommandDescription: runTestsCommandDescription.
	#{Smalltalk.Profiler} valueOrNil
		ifNotNil: 
			[:profiler |
			aMenu
				addCommandDescription: ((CommandDescription command: #profileTests description: 'Profi&le Tests')
						image: profiler icon;
						yourself)]!

onBrowserClassSelected
	"Private - Event handler for a class being selected within the receiver's associated browser. "

	self displayReset!

onBrowserMethodSelected
	"Event handler for a method being selected within the receiver's associated browser. "

	(self isCurrentCard and: [self browser hasMethodSelected]) 
		ifTrue: [self browser ensureSourceVisible]!

onViewOpened
	super onViewOpened.
	self installMenuCommands.
	self displayReset!

prepareToRun: aTestSuite
	self
		displayRunning: 'Running';
		startAutoSwitchProcess.
	aTestSuite addDependentToHierachy: self!

profileSuite: aTestSuite
	self displayRunning: 'Profiling'.
	result := #{Smalltalk.Profiler} value profile: [aTestSuite run]
				inSetNamed: '<1d> - <2d>' << { aTestSuite. DateAndTime now }.
	self updateWindow!

profileTests
	<commandQuery: #hasTests>
	| suite |
	suite := self testSuite.
	(#{Smalltalk.Profiler} isDefined and: [suite notNil])
		ifTrue: [self profileSuite: suite]
		ifFalse: [self displayReset]!

queryToggleToTests: query
	^query
		isEnabled: self hasTestClass;
		expandMenuTextWith: self toggleToTestsClassDescription!

refreshIcon
	self view arrangement: self!

runSuite: aTestSuite
	self prepareToRun: aTestSuite.
	result := [aTestSuite run] ensure: [self completeRun: aTestSuite].
	self updateWindow!

runTests
	<commandQuery: #hasTests>
	self testSuite ifNil: [self displayReset] ifNotNil: [:suite | self runSuite: suite]!

startAutoSwitchProcess
	autoSwitchProcess := 
			[Processor sleep: self class autoSwitchDelay.
			self ensureVisible.
			SessionManager inputState prod]
					forkAt: Processor highIOPriority!

stopAutoSwitchProcess
	autoSwitchProcess ifNotNil: [:process | process terminate].
	autoSwitchProcess := nil!

suiteForTestClasses
	| allTests testClasses count |
	testClasses := self testClasses.
	count := testClasses size.
	count = 0 ifTrue: [^nil].
	#todo.	"Improve SUnit TestSuite building so we don't have logic spread around for building suites"
	allTests := Set new.
	testClasses do: [:each | allTests addAll: each suite tests].
	^TestSuite new
		addTests: allTests;
		name: (count = 1
					ifTrue: [testClasses anyOne fullName]
					ifFalse: ['<1p> & <2d> other<3?s:>' << { testClasses asSortedArray first. count - 1. count > 2 }])
						yourself!

suiteForTestMethods: aCollectionOfCompiledMethods
	"Private - Answer a `TestSuite` build from the specified methods, assumed to be methods of, or inherited by, a single selected test class."

	^self testClasses single
		buildSuiteFromConcreteMethods: (aCollectionOfCompiledMethods collect: [:each | each selector])!

testClass
	self browser selectedClass isNil ifTrue: [^nil].
	^self browser selectedClass correspondingTestCase!

testClasses
	| testClasses |
	testClasses := Set new.
	self browser selectedClasses do: [:each | testClasses add: each correspondingTestCase].
	^testClasses!

testSuite
	| testMethods methods |
	methods := self browser selectedMethods.
	testMethods := methods select: [:each | TestCase isTestMethod: each].
	^testMethods isEmpty
		ifTrue: 
			["If there are no test methods selected at all, then run the tests for the whole class"
			self suiteForTestClasses]
		ifFalse: [self suiteForTestMethods: testMethods]!

toggleToTests
	"Switch the associated browser between the class under test and the corresponding test class"

	<commandQuery: #queryToggleToTests:>
	| toggleToClass |
	toggleToClass := self toggleToTestsClass.
	toggleToClass ifNil: [^Error beep].
	^self browser actualClass: toggleToClass!

toggleToTestsClass
	| testClasses testClass |
	testClasses := self testClasses.
	testClasses size == 1 ifFalse: [^nil].
	testClass := testClasses single.
	^testClass = self browser selectedClass ifTrue: [self classUnderTest] ifFalse: [testClass]!

toggleToTestsClassDescription
	^(self toggleToTestsClass ?? TestCase) shortName!

update: anObject
	(anObject isKindOf: TestCase)
		ifTrue: 
			[self displayDetails: anObject printString.
			SessionManager inputState pumpMessages]
		ifFalse: [super update: anObject]!

updateDefects
	self displayDefects: (result defects asSortedArray , result skipped asSortedArray
				collect: [:each | result resultFor: each])!

updateWindow
	result hasErrors
		ifTrue: [self displayErrors]
		ifFalse: [result hasFailures ifTrue: [self displayFail] ifFalse: [self displayPass]].
	self updateDefects! !

!Tools.UnitTestPlugin categoriesForMethods!
addToCommandRouteInactive:!commands-routing!public! !
allContextMenus!helpers!private! !
allMenuBarMenus!helpers!private! !
classUnderTest!Accessing!private! !
completeRun:!operations!private! !
createComponents!initializing!private! !
createSchematicWiring!helpers!private! !
debugTest!commands-actions!public! !
debugTest:!operations!private! !
defaultHelpId!constants!public! !
displayColor:!private!updating! !
displayDefects:!private!updating! !
displayDetails:!private!updating! !
displayErrors!private!updating! !
displayFail!private!updating! !
displayMode:!private!updating! !
displayOn:!displaying!private! !
displayPass!private!updating! !
displayReset!private!updating! !
displayRunning:!private!updating! !
hasDefects!public!testing! !
hasIndividualTests!public!updating! !
hasTestClass!public!testing! !
hasTests!public!testing! !
icon!accessing!public! !
icon:!accessing!private! !
installMenuCommands!helpers!private! !
installTestCommandsInClassMenu:withAccelerator:!helpers!private! !
installTestCommandsInMethodMenu:!helpers!private! !
onBrowserClassSelected!event handling!private! !
onBrowserMethodSelected!event handling!private! !
onViewOpened!event handling!private! !
prepareToRun:!operations!private! !
profileSuite:!operations!private! !
profileTests!commands-actions!public! !
queryToggleToTests:!helpers!private! !
refreshIcon!operations!private! !
runSuite:!operations!private! !
runTests!commands-actions!public! !
startAutoSwitchProcess!helpers!private! !
stopAutoSwitchProcess!helpers!private! !
suiteForTestClasses!accessing!private! !
suiteForTestMethods:!accessing!private! !
testClass!Accessing!private! !
testClasses!accessing!private! !
testSuite!accessing!public! !
toggleToTests!commands-actions!public! !
toggleToTestsClass!helpers!private! !
toggleToTestsClassDescription!helpers!private! !
update:!helpers!private! !
updateDefects!private!updating! !
updateWindow!private!updating! !
!

!Tools.UnitTestPlugin class methodsFor!

autoSwitchDelay
	"Answer the number of milliseconds after which instances of the receiver will automatically switch
	to their tab when tests are running"

	^AutoSwitchDelay!

autoSwitchDelay: aDuration
	"Set the <Duration> after which instances of the receiver will automatically switch to their tab when tests are running"

	AutoSwitchDelay := aDuration!

defaultAutoSwitchDelay
	"Private - Answer the default <Duration> before the plugin will automatically show itself when tests are running"

	^1 seconds!

defaultErrorColor
	^Color
		r: 243
		g: 27
		b: 65!

defaultFailColor
	^Color darkOrange!

defaultNoTestsColor
	^Color 
		r: 111
		g: 158
		b: 238!

defaultPassColor
	^Color 
		r: 100
		g: 210
		b: 103!

defaultRunningColor
	^Color 
		r: 235
		g: 201
		b: 65!

errorColor
	^ErrorColor!

errorColor: aColor
	ErrorColor := aColor = Color default ifTrue: [self defaultErrorColor] ifFalse: [aColor]!

failColor
	^FailColor!

failColor: aColor 
	FailColor := aColor = Color default ifTrue: [self defaultFailColor] ifFalse: [aColor]!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

initialize
	"Private - 
	self initialize
	"

	AutoSwitchDelay := self defaultAutoSwitchDelay.
	PassColor := self defaultPassColor.
	FailColor := self defaultFailColor.
	ErrorColor := self defaultErrorColor.
	RunningColor := self defaultRunningColor.
	NoTestsColor := self defaultNoTestsColor!

noTestsColor
	^NoTestsColor!

noTestsColor: aColor 
	NoTestsColor := aColor = Color default ifTrue: [self defaultNoTestsColor] ifFalse: [aColor]!

passColor
	^PassColor!

passColor: aColor 
	PassColor := aColor = Color default ifTrue: [self defaultPassColor] ifFalse: [aColor]!

publishedAspects
	"Private - Answer a <LookupTable> of the <Aspect>s published by the receiver."

	^super publishedAspects
		add: (Aspect duration: #autoSwitchDelay);
		add: (Aspect color: #noTestsColor);
		add: (Aspect color: #passColor);
		add: (Aspect color: #runningColor);
		add: (Aspect color: #failColor);
		add: (Aspect color: #errorColor);
		yourself!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.ContainerView} 38 #{Core.Array} 15 nil nil 50 2 8 1409482752 131073 32 nil nil nil 5 nil nil nil 32 1798 #{UI.BorderLayout} 1 1 18 #{UI.PushButton} 50 20 nil 32 50 2 8 1140924416 1 144 nil 6 #{Graphics.Color} #silver 518 #{Graphics.Point} 177 57 5 nil 1030 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 0 65 0 114 0 105 0 97 0 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 242 193 193 nil 144 nil nil 1350 4 #{UI.CommandDescription} #runTests 8 'Run Tests' 9381 1 nil nil false nil nil nil 262 #{Core.MessageSequence} 50 3 774 #{Core.MessageSend} #createAt:extent: 50 2 242 1 1 242 969 49 144 466 #isEnabled: 8 #(false) 144 466 #text: 50 1 8 'Run Tests' 144 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 228 1 0 0 24 0 0 0] 8 #() 242 193 193 nil 29 nil nil nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 704 nil 210 #darkOrange nil 5 nil nil nil 704 114 1 1 nil 18 #{UI.ContainerView} 50 15 nil 704 50 2 8 1140850688 131073 800 nil 210 #default nil 5 nil nil nil 800 114 1 1 nil nil 18 #{UI.PushButton} 50 20 nil 800 50 2 8 1140924416 1 896 nil nil nil 5 nil 274 nil true 306 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 0 65 0 114 0 105 0 97 0 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 242 193 193 nil 896 nil nil 370 #debugTest 8 'Debug' 1 7 nil nil false nil nil nil 418 50 3 466 #createAt:extent: 50 2 242 815 1 242 155 49 896 466 #isEnabled: 8 #(false) 896 466 #text: 50 1 8 'Debug' 896 626 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 151 1 0 0 0 0 0 0 228 1 0 0 24 0 0 0] 8 #() 688 nil 29 nil 18 #{UI.ComboBox} 50 17 nil 800 50 2 8 1144063491 1 1280 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} nil nil 5 nil 274 nil true 306 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 0 65 0 114 0 105 0 97 0 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 242 193 193 nil 1280 nil nil 518 #{Core.Message} #displayString 8 #() 8 #() 401 418 50 2 466 #createAt:extent: 50 2 242 1 1 242 815 49 1280 466 #isEnabled: 8 #(false) 1280 626 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 151 1 0 0 24 0 0 0] 8 #() 688 nil 27 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 50 4 896 8 'debugButton' 1280 8 'defects' nil 418 50 1 466 #createAt:extent: 50 2 242 1 285 242 969 49 800 626 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 142 0 0 0 228 1 0 0 166 0 0 0] 50 2 896 1280 688 nil 27 nil nil 18 #{UI.ContainerView} 50 15 nil 704 50 2 8 1140850688 131073 1968 nil 864 nil 5 nil nil nil 1968 114 1 1 18 #{UI.StaticText} 50 16 nil 1968 50 2 8 1140850945 1 2048 nil nil 242 177 81 5 nil 274 nil true 306 8 #[208 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 0 67 0 111 0 117 0 114 0 105 0 101 0 114 0 32 0 78 0 101 0 119 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 242 193 193 nil 2048 nil nil 518 #{UI.NullConverter} nil nil true 418 50 2 466 #createAt:extent: 50 2 242 1 1 242 969 121 2048 466 #text: 50 1 8 'No Tests' 2048 626 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 228 1 0 0 60 0 0 0] 8 #() 688 nil 27 nil nil nil 18 #{UI.StaticText} 50 16 nil 1968 50 2 8 1140850945 65 2416 nil nil nil 5 nil 274 nil true 306 8 #[240 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 0 65 0 114 0 105 0 97 0 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 242 193 193 nil 2416 nil nil 2194 nil nil nil 418 50 2 466 #createAt:extent: 50 2 242 1 121 242 969 165 2416 466 #text: 50 1 8 '⋯' 2416 626 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 60 0 0 0 228 1 0 0 142 0 0 0] 8 #() 688 nil 27 1746 #{Core.IdentityDictionary} 50 4 2416 8 'details' 2048 8 'mode' nil 418 50 1 466 #createAt:extent: 50 2 242 1 1 242 969 285 1968 626 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 228 1 0 0 142 0 0 0] 50 2 2416 2048 688 nil 27 1746 #{Core.IdentityDictionary} 50 2 1968 8 'colorField' 518 #{Graphics.Rectangle} 242 1 1 242 1 1 418 50 1 466 #createAt:extent: 50 2 242 1 49 242 969 333 704 626 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 24 0 0 0 228 1 0 0 190 0 0 0] 50 2 1968 800 688 nil 27 1746 #{Core.IdentityDictionary} 50 2 144 8 'runOne' nil 418 50 1 466 #createAt:extent: 50 2 242 6143 21 242 969 381 32 626 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 227 13 0 0 200 0 0 0] 50 2 144 704 688 nil 27)!

runningColor
	^RunningColor!

runningColor: aColor 
	RunningColor := aColor = Color default ifTrue: [self defaultRunningColor] ifFalse: [aColor]! !

!Tools.UnitTestPlugin class categoriesForMethods!
autoSwitchDelay!accessing!public! !
autoSwitchDelay:!accessing!public! !
defaultAutoSwitchDelay!constants!private! !
defaultErrorColor!constants!private! !
defaultFailColor!constants!private! !
defaultNoTestsColor!private!Updating! !
defaultPassColor!constants!private! !
defaultRunningColor!constants!private! !
errorColor!accessing!public! !
errorColor:!accessing!public! !
failColor!accessing!public! !
failColor:!accessing!public! !
icon!constants!public! !
initialize!class initialization!private! !
noTestsColor!accessing!public! !
noTestsColor:!accessing!public! !
passColor!accessing!public! !
passColor:!accessing!public! !
publishedAspects!private! !
resource_Default_view!public!resources-views! !
runningColor!accessing!public! !
runningColor:!accessing!public! !
!

