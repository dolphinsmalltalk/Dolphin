"Filed out from Dolphin Smalltalk"!

ClassBrowserPlugin subclass: #UnitTestPlugin
	instanceVariableNames: 'result icon autoSwitchProcess defectsPresenter modePresenter detailsPresenter'
	classVariableNames: 'AutoSwitchDelayMs ErrorColor FailColor NoTestsColor PassColor RunningColor'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

UnitTestPlugin guid: (GUID fromString: '{e8b10dcb-9855-41f7-95d2-a91639377d01}')!

UnitTestPlugin comment: 'UnitTestPlugin is a <classBrowserPlugin> that provides SUnit test running facilities within a browser. The aim is to allow tests directly relevant to the current class being worked on in the browser to be run quickly and easily using a single hotkey or menu command. Failing tests can be isolated and run within the debugger. The UnitTestPlugin does not provide facilities to run large suites of tests comprising of more than one <TestCase>; this functionaility is left to the SUnitBrowser and TestRunner tools.

When a class is selected in the browser, the UnitTestPlugin deterines if there is a <TestCase> subclass that can be associated with it. By default, ClassDescription>>correspondingTestCase is used to do this by simply appending ''Test'' to the name of the class. If the mapping between a class under test and its <TestCase> is not so straightforward it is alway possible to implement #correspondingTestCase as a class method that directly answers the correct <TestCase> subclass. Typically, if used, this class method would be installed as a loose method in the package containing the tests. 

If such a test case class exists then a TestSuite is built and held by the plugin to be run at the user''s request. A UnitTestPlugin dynamically installs new menu commands into the Class and Method menus of the associated browser. The #runTests command will run the available tests. A traffic light scheme is used to display the result of the tests in the plugin pane''s tab. If the tests take a long time to run, or if a test fails, the UnitTestPlugin will automatically make itself the foreground pane in the browser.

Another menu command that is made available is #toggleToTests. This allows the developer to quickly move the browser between the class under test and its corresponding <TestCase> class (and vice versa). When the browser displays a <TestCase> class the #runTests command will run all the tests in that test case. If, however, one or more individual test methods (#testXXX methods) are selected then only these will be executed when a #runTests is performed.

When tests fail, a list of the defects is retained by the plugin. Using the drop down list at the bottom of the plugin''s display you can choose each of the failing tests to re-run under the control of the debugger.

Instance Variables:
	result			<TestResult> indicating the results of the last run tests
	testSuite			<TestSuite> indicating which tests (if any) should be run according to the browser selection
	icon				<Icon> used to provide a traffic light representation of the current state of the plugin 
	autoSwitchProcess	<Process> started when tests are running to automatically switch to the plugin pane to show progress if the tests take a long time to complete.
	defectsPresenter	<ListPresenter> showing a list of defects when some tests have failed
	modePresenter		<TextPresenter> describing the current running state
	detailsPresenter	<TextPresenter> providing further details about t ... etc ...'!

!UnitTestPlugin categoriesForClass!Browser-Plugins! !

!UnitTestPlugin methodsFor!

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
				ifNone: [].
	^classUnderTest!

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

currentTestMethodSelectors
	self isBrowserLookingAtTestClass ifFalse: [^Set new].
	^(self browser selectedMethods collect: [:each | each selector]) 
		intersection: self testClass testSelectors!

debugTest
	"Debug the currently selected defect. If no defects are selected then select and ebug the first one"

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
	defectsPresenter list: (aCollection asSortedCollection: [:a :b | a case <= b case]).
	defectsPresenter view isEnabled: aCollection notEmpty!

displayDetails: aString 
	"Display aString to indicate additional details about the current mode of operation"

	detailsPresenter value: aString!

displayErrors
	"Indicate that some tests have failed and we have defects"

	self icon: (Icon fromId: 'UnitTestPluginFail.ico').
	self displayColor: self class errorColor.
	self displayMode: 'Error'.
	self displayDetails: result displayString.
	self ensureVisible!

displayFail
	"Indicate that some tests have failed and we have defects"

	self icon: (Icon fromId: 'UnitTestPluginFail.ico').
	self displayColor: self class failColor.
	self displayMode: 'Fail'.
	self displayDetails: result displayString.
	self ensureVisible!

displayMode: aString 
	"Display aString to indicate the current mode"

	modePresenter value: aString!

displayOn: aStream
	"Private - Append, to aStream, a String whose characters are a representation of the receiver as a user
	would want to see it. This will be used as the label for the tab when the receiver is being displayed
	as a plugin within the Class Browser"

	aStream nextPutAll: 'Unit Tests'!

displayPass
	"Indicate that all tests passed"

	self icon: (Icon fromId: 'UnitTestPluginPass.ico').
	self displayColor: self class passColor.
	self displayMode: 'Pass'.
	self displayDetails: result displayString!

displayReset
	self displayColor: self class noTestsColor.
	self hasTestClass
		ifTrue: 
			[self icon: (Icon fromId: 'UnitTestPluginNotRun.ico').
			self displayMode: 'Not Yet Run']
		ifFalse: 
			[self icon: (Icon fromId: 'UnitTestPluginNoTest.ico').
			self displayMode: 'No Tests'].
	self displayDetails: ''.
	self displayDefects: OrderedCollection new.
	result := nil!

displayRunning
	"Indicate that tests are being run"

	self icon: (Icon fromId: 'UnitTestPluginDefect.ico').
	self displayColor: self class runningColor.
	self displayMode: 'Running'.
	self displayDetails: '...'!

hasDefects
	"Answer true if some tests failed and we have defects in our defectsPresenter"

	^defectsPresenter list notEmpty!

hasIndividualTests
	"Answer true if we are looking at a TestCase subclass with one or more  #testXXX methods selected."

	^self currentTestMethodSelectors notEmpty!

hasTestClass
	"Answer true if we have a corresponding test class so that tests can be run."

	^self testClass notNil!

icon
	icon ifNil: [^super icon].
	^icon!

icon: anIconOrNil
	"Private - Set the icon displayed in the receivers tab. This is used to indicate whether tests have passed or failed etc."

	icon = anIconOrNil
		ifFalse: 
			[icon := anIconOrNil.
			self refreshIcon]!

installMenuCommands
	"Private - Installs the menu commands required by the receiver into the associated browser menus"

	| classContextMenus classMenuBarMenus methodContextMenus methodMenuBarMenus contextMenus menuBarMenus |
	contextMenus := self allContextMenus.
	classContextMenus := contextMenus
				select: [:each | each items anySatisfy: [:item | item command = #newClass]].
	classContextMenus do: [:each | self installTestCommandsInClassMenu: each withAccelerator: false].
	menuBarMenus := self allMenuBarMenus.
	classMenuBarMenus := menuBarMenus
				select: [:each | each items anySatisfy: [:item | item command = #newClass]].
	classMenuBarMenus do: [:each | self installTestCommandsInClassMenu: each withAccelerator: true].
	methodContextMenus := contextMenus
				select: [:each | each items anySatisfy: [:item | item command = #newMethod]].
	methodContextMenus do: [:each | self installTestCommandsInMethodMenu: each].
	methodMenuBarMenus := menuBarMenus
				select: [:each | each items anySatisfy: [:item | item command = #newMethod]].
	methodMenuBarMenus do: [:each | self installTestCommandsInMethodMenu: each]!

installTestCommandsInClassMenu: aMenu withAccelerator: needsAccel 
	"Private - Installs the test commands required by the receiver into aMenu. If an accelerator is required (i.e. in the case of
	non-context menus) then needsAccel should be true"

	| runTestsCommandDescription toggleToTestClassCommandDescription |
	runTestsCommandDescription := ClosedCommandDescription 
				command: #runTests
				description: '&Run Tests'
				queryBlock: [:query | query isEnabled: self hasTestClass]
				receiver: self.
	needsAccel ifTrue: [runTestsCommandDescription acceleratorKeyString: 'Ctrl+Alt+R'].
	runTestsCommandDescription image: self class icon.
	toggleToTestClassCommandDescription := ClosedCommandDescription 
				command: #toggleToTests
				description: '&Go to <1d> '
				queryBlock: 
					[:query | 
					query
						isEnabled: self hasTestClass;
						text: (query commandDescription menuText expandMacrosWith: self toggleToTestsClassDescription)]
				receiver: self.
	needsAccel ifTrue: [toggleToTestClassCommandDescription acceleratorKeyString: 'Ctrl+Alt+T'].
	aMenu
		addSeparator;
		addCommandDescription: runTestsCommandDescription;
		addCommandDescription: toggleToTestClassCommandDescription!

installTestCommandsInMethodMenu: aMenu 
	"Private - Installs the method test commands required by the receiver into aMenu."

	| runTestsCommandDescription |
	runTestsCommandDescription := ClosedCommandDescription 
				command: #runTests
				description: '&Run Tests'
				queryBlock: [:query | query isEnabled: self hasIndividualTests]
				receiver: self.
	runTestsCommandDescription image: self class icon.
	aMenu
		addSeparator;
		addCommandDescription: runTestsCommandDescription!

isBrowserLookingAtTestClass
	"Private - Answer true if the browser associated with the receiver is looking at a TestCase subclass"

	^self testClass ifNotNil: [:testClass | testClass = self browser actualClass] ifNil: [false]!

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

queryCommand: aCommandQuery 
	"Private - Enter details about a potential command for the receiver 
	into the <CommandQuery> argument."

	| selector |
	selector := aCommandQuery commandSymbol.
	#runTests == selector 
		ifTrue: 
			[aCommandQuery isEnabled: self hasTestClass.
			^true].
	#debugTest == selector 
		ifTrue: 
			[aCommandQuery isEnabled: self hasDefects.
			^true].
	^super queryCommand: aCommandQuery!

refreshIcon
	self view arrangement: self!

runIndividualTests
	| suite |
	suite := self testClass buildSuiteFromMethods: self currentTestMethodSelectors.
	self runSuite: suite!

runSuite: aTestSuite 
	self
		displayRunning;
		startAutoSwitchProcess.
	aTestSuite addDependentToHierachy: self.
	result := [aTestSuite run] ensure: 
					[aTestSuite removeDependentFromHierachy: self.
					self stopAutoSwitchProcess].
	self updateWindow!

runTests
	self testSuite ifNil: [self displayReset] ifNotNil: [:suite | self runSuite: suite]!

startAutoSwitchProcess
	autoSwitchProcess := 
			[Processor sleep: self class autoSwitchDelayMs.
			self ensureVisible.
			SessionManager inputState prod]
					forkAt: Processor highIOPriority.!

stopAutoSwitchProcess
	autoSwitchProcess ifNotNil: [:process | process terminate].
	autoSwitchProcess := nil!

testClass
	self browser selectedClass isNil ifTrue: [^nil].
	^self browser selectedClass correspondingTestCase!

testSuite
	| testMethodSelectors testClass |
	testClass := self testClass.
	testClass ifNil: [^nil].
	testMethodSelectors := self currentTestMethodSelectors.
	testMethodSelectors isEmpty ifTrue: [^testClass suite].
	^testClass buildSuiteFromConcreteMethods: testMethodSelectors!

testSuiteName
	"Private - Answer the name of the current test suite (if any). Answer nil if none"

	^self testClass ifNotNil: [:testClass | testClass suite name]!

toggleToTests
	"Switch the associated browser between the class under test and the corresponding test class"

	| toggleToClass |
	toggleToClass := self toggleToTestsClass.
	toggleToClass ifNil: [^Error beep].
	^self browser actualClass: toggleToClass!

toggleToTestsClass
	^self testClass = self browser actualClass ifTrue: [self classUnderTest] ifFalse: [self testClass]!

toggleToTestsClassDescription
	| gotoClass |
	gotoClass := self toggleToTestsClass.
	gotoClass isNil ifTrue: [^TestCase].
	^gotoClass!

update: anObject
	(anObject isKindOf: TestCase)
		ifTrue: 
			[self displayDetails: anObject printString.
			SessionManager inputState pumpMessages]
		ifFalse: [super update: anObject]!

updateDefects
	self displayDefects: (result defects collect: [:each | result resultFor: each])!

updateWindow
	result hasErrors
		ifTrue: [self displayErrors]
		ifFalse: [result hasFailures ifTrue: [self displayFail] ifFalse: [self displayPass]].
	self updateDefects! !

!UnitTestPlugin categoriesForMethods!
allContextMenus!helpers!private! !
allMenuBarMenus!helpers!private! !
classUnderTest!Accessing!private! !
createComponents!initializing!private! !
createSchematicWiring!helpers!private! !
currentTestMethodSelectors!commands!private! !
debugTest!commands!public! !
debugTest:!operations!private! !
defaultHelpId!constants!public! !
displayColor:!private!Updating! !
displayDefects:!private!Updating! !
displayDetails:!private!Updating! !
displayErrors!private!Updating! !
displayFail!private!Updating! !
displayMode:!private!Updating! !
displayOn:!displaying!private! !
displayPass!private!Updating! !
displayReset!private!Updating! !
displayRunning!private!Updating! !
hasDefects!public!testing! !
hasIndividualTests!public!Updating! !
hasTestClass!public!Updating! !
icon!accessing!public! !
icon:!accessing!private! !
installMenuCommands!helpers!private! !
installTestCommandsInClassMenu:withAccelerator:!helpers!private! !
installTestCommandsInMethodMenu:!helpers!private! !
isBrowserLookingAtTestClass!private!testing! !
onBrowserClassSelected!event handling!private! !
onBrowserMethodSelected!event handling!private! !
onViewOpened!event handling!private! !
queryCommand:!commands!private! !
refreshIcon!operations!private! !
runIndividualTests!commands!public! !
runSuite:!operations!private! !
runTests!commands!public! !
startAutoSwitchProcess!helpers!private! !
stopAutoSwitchProcess!helpers!private! !
testClass!Accessing!private! !
testSuite!accessing!public! !
testSuiteName!event handling!private! !
toggleToTests!commands!public! !
toggleToTestsClass!helpers!private! !
toggleToTestsClassDescription!helpers!private! !
update:!helpers!private! !
updateDefects!private!Updating! !
updateWindow!private!Updating! !
!

!UnitTestPlugin class methodsFor!

autoSwitchDelayMs
	"Answer the number of milliseconds after which instances of the receiver will automatically switch
	to their tab when tests are running"

	^AutoSwitchDelayMs!

autoSwitchDelayMs: aDuration 
	"Set the <Duration> after which instances of the receiver will automatically switch to their tab when tests are running"

	AutoSwitchDelayMs := aDuration!

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

	AutoSwitchDelayMs := self defaultAutoSwitchDelay.
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

	^(super publishedAspects)
		add: (Aspect integer: #autoSwitchDelayMs);
		add: (Aspect color: #noTestsColor);
		add: (Aspect color: #passColor);
		add: (Aspect color: #runningColor);
		add: (Aspect color: #failColor);
		yourself!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ContainerView) 34 15 nil nil 34 2 8 1409482752 131073 416 nil nil nil 7 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.PushButton) 34 20 nil 416 34 2 8 1140924416 1 512 nil 327686 ##(Smalltalk.Color) #silver 328198 ##(Smalltalk.Point) 177 57 7 nil 263494 1 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 0 65 0 114 0 105 0 97 0 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 512 nil 8 1795707744 1180998 4 ##(Smalltalk.CommandDescription) #runTests 8 'Run Tests' 9381 1 nil nil false nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[0 0 0 0 0 0 0 0 228 1 0 0 24 0 0 0] 193 544 8 'Run Tests' 512 850 #isEnabled: 8 #(false) 512 3 8 #() 610 193 193 nil 29 nil nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 1056 nil 578 #darkOrange nil 7 nil nil nil 1056 482 1 1 nil 410 ##(Smalltalk.ContainerView) 34 15 nil 1056 34 2 8 1140850688 131073 1152 nil 578 #face3d nil 7 nil 642 nil true 674 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 1152 482 1 1 nil nil 410 ##(Smalltalk.ToolButton) 34 14 nil 1152 34 2 8 1140916224 131073 1296 nil nil nil 7 nil nil nil 1296 nil 410 ##(Smalltalk.Toolbar) 34 28 nil 1296 34 2 8 1140923212 131137 1360 nil nil nil 515 nil nil nil 1360 nil 8 1795812352 nil nil nil nil 170 192 34 2 10729 1115206 1 ##(Smalltalk.ToolbarIconButton) 1360 1 738 #debugTest 8 'Debug' 1 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'Debugger.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil 10729 34 1 1488 nil nil 11 1 #smallIcons 610 131 41 nil nil 786 138 144 34 1 850 #createWindow: 34 1 898 930 8 #[0 0 0 0 0 0 0 0 70 0 0 0 25 0 0 0] 193 1392 8 '' 1360 3 8 #() 610 193 193 nil 31 786 138 144 34 1 850 #createWindow: 34 1 898 930 8 #[158 1 0 0 0 0 0 0 228 1 0 0 25 0 0 0] 193 1328 8 'Debug' 1296 3 34 1 1360 610 193 193 nil 27 nil 410 ##(Smalltalk.ComboBox) 34 17 nil 1152 34 2 8 1144063491 1 2048 590662 2 ##(Smalltalk.ListModel) 138 144 8 #() nil 1310726 ##(Smalltalk.IdentitySearchPolicy) nil nil 7 nil nil nil 2048 nil 8 1795317024 ##(Smalltalk.BasicListAbstract) 8 #() 401 786 138 144 34 2 850 #createWindow: 34 1 898 930 8 #[0 0 0 0 0 0 0 0 158 1 0 0 225 0 0 0] 193 2080 8 '' 2048 850 #isEnabled: 8 #(false) 2048 3 8 #() 610 193 193 nil 27 170 192 34 4 1296 8 'debugButton' 2048 8 'defects' nil 786 138 144 34 1 850 #createWindow: 34 1 898 930 8 #[0 0 0 0 141 0 0 0 228 1 0 0 166 0 0 0] 193 1184 8 '' 1152 3 34 2 1296 2048 610 193 193 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 1056 34 2 8 1140850688 131073 2688 nil 578 #default nil 7 nil nil nil 2688 482 1 1 410 ##(Smalltalk.StaticText) 34 16 nil 2688 34 2 8 1140850945 1 2784 nil nil 610 177 81 7 nil 642 nil true 674 8 #[208 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 0 67 0 111 0 117 0 114 0 105 0 101 0 114 0 32 0 78 0 101 0 119 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 2784 nil 8 1795912768 852486 ##(Smalltalk.NullConverter) nil nil true 786 138 144 34 2 850 #createWindow: 34 1 898 930 8 #[0 0 0 0 0 0 0 0 228 1 0 0 60 0 0 0] 193 2816 nil 2784 850 #text: 34 1 8 'No Tests' 2784 3 8 #() 610 193 193 nil 27 nil nil nil 410 ##(Smalltalk.StaticText) 34 16 nil 2688 34 2 8 1140850945 65 3168 nil nil nil 7 nil 642 nil true 674 8 #[240 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 0 65 0 114 0 105 0 97 0 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 3168 nil 8 1795912768 2930 nil nil nil 786 138 144 34 2 850 #createWindow: 34 1 898 930 8 #[0 0 0 0 60 0 0 0 228 1 0 0 141 0 0 0] 193 3200 nil 3168 850 #text: 34 1 8 '...' 3168 3 8 #() 610 193 193 nil 27 170 192 34 4 2784 8 'mode' 3168 8 'details' nil 786 138 144 34 1 850 #createWindow: 34 1 898 930 8 #[0 0 0 0 0 0 0 0 228 1 0 0 141 0 0 0] 193 2720 8 '' 2688 3 34 2 3168 2784 610 193 193 nil 27 170 192 34 2 2688 8 'colorField' nil 786 138 144 34 1 850 #createWindow: 34 1 898 930 8 #[0 0 0 0 24 0 0 0 228 1 0 0 190 0 0 0] 193 1088 8 '' 1056 3 34 2 2688 1152 610 193 193 nil 27 170 192 34 2 512 8 'runOne' nil 786 138 144 34 1 850 #createWindow: 34 1 898 930 8 #[255 14 0 0 10 0 0 0 227 16 0 0 200 0 0 0] 193 448 8 '' 416 1 34 2 512 1056 610 193 193 nil 27 )!

runningColor
	^RunningColor!

runningColor: aColor 
	RunningColor := aColor = Color default ifTrue: [self defaultRunningColor] ifFalse: [aColor]! !

!UnitTestPlugin class categoriesForMethods!
autoSwitchDelayMs!accessing!public! !
autoSwitchDelayMs:!accessing!public! !
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

