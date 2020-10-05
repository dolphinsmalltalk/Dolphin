"Filed out from Dolphin Smalltalk 7"!

Tools.ClassBrowserPlugin subclass: #'Tools.UnitTestPlugin'
	instanceVariableNames: 'result icon autoSwitchProcess defectsPresenter modePresenter detailsPresenter'
	classVariableNames: 'AutoSwitchDelayMs ErrorColor FailColor NoTestsColor PassColor RunningColor'
	imports: #(#{XProgramming.SUnit private})
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.UnitTestPlugin guid: (Core.GUID fromString: '{e8b10dcb-9855-41f7-95d2-a91639377d01}')!
Tools.UnitTestPlugin comment: 'UnitTestPlugin is a <classBrowserPlugin> that provides SUnit test running facilities within a browser. The aim is to allow tests directly relevant to the current class being worked on in the browser to be run quickly and easily using a single hotkey or menu command. Failing tests can be isolated and run within the debugger. The UnitTestPlugin does not provide facilities to run large suites of tests comprising of more than one <TestCase>; this functionaility is left to the SUnitBrowser and TestRunner tools.

When a class is selected in the browser, the UnitTestPlugin deterines if there is a <TestCase> subclass that can be associated with it. By default, ClassDescription>>correspondingTestCase is used to do this by simply appending ''Test'' to the name of the class. If the mapping between a class under test and its <TestCase> is not so straightforward it is alway possible to implement #correspondingTestCase as a class method that directly answers the correct <TestCase> subclass. Typically, if used, this class method would be installed as a loose method in the package containing the tests. 

If such a test case class exists then a TestSuite is built and held by the plugin to be run at the user''s request. A UnitTestPlugin dynamically installs new menu commands into the Class and Method menus of the associated browser. The #runTests command will run the available tests. A traffic light scheme is used to display the result of the tests in the plugin pane''s tab. If the tests take a long time to run, or if a test fails, the UnitTestPlugin will automatically make itself the foreground pane in the browser.

Another menu command that is made available is #toggleToTests. This allows the developer to quickly move the browser between the class under test and its corresponding <TestCase> class (and vice versa). When the browser displays a <TestCase> class the #runTests command will run all the tests in that test case. If, however, one or more individual test methods (#testXXX methods) are selected then only these will be executed when a #runTests is performed.

When tests fail, a list of the defects is retained by the plugin. Using the drop down list at the bottom of the plugin''s display you can choose each of the failing tests to re-run under the control of the debugger.

Instance Variables:
	result			<TestResult> indicating the results of the last run tests
	icon				<Icon> used to provide a traffic light representation of the current state of the plugin 
	autoSwitchProcess	<Process> started when tests are running to automatically switch to the plugin pane to show progress if the tests take a long time to complete.
	defectsPresenter	<ListPresenter> showing a list of defects when some tests have failed
	modePresenter		<TextPresenter> describing the current running state
	detailsPresenter	<TextPresenter> providing further details about the current running state

Class Variables:
	AutoSwitchDelayMs	<Integer> count of milliseconds after which the <autoSwitchProcess> will bring the plugin pane to the foreground
	ErrorColor			<color> which will be used as a background colour when some tests throw errors
	FailColor			<color> which will be used as a background colour when some tests fail
	PassColor			<color> which will be used as a background colour when all tests pass
	RunningColor		<color> which will be used as a background colour when tests are running
	NoTestsColor		<color> which will be used as a background colour when no tests are available for the browser selection
'!
!Tools.UnitTestPlugin categoriesForClass!Browser-Plugins! !
!Tools.UnitTestPlugin methodsFor!

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
						text: (query commandDescription menuText
									expandMacrosWithArguments: {self toggleToTestsClassDescription}
									locale: Locale smalltalk)]
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
	^self toggleToTestsClass ?? XProgramming.SUnit.TestCase!

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
!Tools.UnitTestPlugin categoriesFor: #allContextMenus!helpers!private! !
!Tools.UnitTestPlugin categoriesFor: #allMenuBarMenus!helpers!private! !
!Tools.UnitTestPlugin categoriesFor: #classUnderTest!Accessing!private! !
!Tools.UnitTestPlugin categoriesFor: #createComponents!initializing!private! !
!Tools.UnitTestPlugin categoriesFor: #createSchematicWiring!helpers!private! !
!Tools.UnitTestPlugin categoriesFor: #currentTestMethodSelectors!commands!private! !
!Tools.UnitTestPlugin categoriesFor: #debugTest!commands!public! !
!Tools.UnitTestPlugin categoriesFor: #debugTest:!operations!private! !
!Tools.UnitTestPlugin categoriesFor: #defaultHelpId!constants!public! !
!Tools.UnitTestPlugin categoriesFor: #displayColor:!private!Updating! !
!Tools.UnitTestPlugin categoriesFor: #displayDefects:!private!Updating! !
!Tools.UnitTestPlugin categoriesFor: #displayDetails:!private!Updating! !
!Tools.UnitTestPlugin categoriesFor: #displayErrors!private!Updating! !
!Tools.UnitTestPlugin categoriesFor: #displayFail!private!Updating! !
!Tools.UnitTestPlugin categoriesFor: #displayMode:!private!Updating! !
!Tools.UnitTestPlugin categoriesFor: #displayOn:!displaying!private! !
!Tools.UnitTestPlugin categoriesFor: #displayPass!private!Updating! !
!Tools.UnitTestPlugin categoriesFor: #displayReset!private!Updating! !
!Tools.UnitTestPlugin categoriesFor: #displayRunning!private!Updating! !
!Tools.UnitTestPlugin categoriesFor: #hasDefects!public!testing! !
!Tools.UnitTestPlugin categoriesFor: #hasIndividualTests!public!Updating! !
!Tools.UnitTestPlugin categoriesFor: #hasTestClass!public!Updating! !
!Tools.UnitTestPlugin categoriesFor: #icon!accessing!public! !
!Tools.UnitTestPlugin categoriesFor: #icon:!accessing!private! !
!Tools.UnitTestPlugin categoriesFor: #installMenuCommands!helpers!private! !
!Tools.UnitTestPlugin categoriesFor: #installTestCommandsInClassMenu:withAccelerator:!helpers!private! !
!Tools.UnitTestPlugin categoriesFor: #installTestCommandsInMethodMenu:!helpers!private! !
!Tools.UnitTestPlugin categoriesFor: #isBrowserLookingAtTestClass!private!testing! !
!Tools.UnitTestPlugin categoriesFor: #onBrowserClassSelected!event handling!private! !
!Tools.UnitTestPlugin categoriesFor: #onBrowserMethodSelected!event handling!private! !
!Tools.UnitTestPlugin categoriesFor: #onViewOpened!event handling!private! !
!Tools.UnitTestPlugin categoriesFor: #queryCommand:!commands!private! !
!Tools.UnitTestPlugin categoriesFor: #refreshIcon!operations!private! !
!Tools.UnitTestPlugin categoriesFor: #runIndividualTests!commands!public! !
!Tools.UnitTestPlugin categoriesFor: #runSuite:!operations!private! !
!Tools.UnitTestPlugin categoriesFor: #runTests!commands!public! !
!Tools.UnitTestPlugin categoriesFor: #startAutoSwitchProcess!helpers!private! !
!Tools.UnitTestPlugin categoriesFor: #stopAutoSwitchProcess!helpers!private! !
!Tools.UnitTestPlugin categoriesFor: #testClass!Accessing!private! !
!Tools.UnitTestPlugin categoriesFor: #testSuite!accessing!public! !
!Tools.UnitTestPlugin categoriesFor: #testSuiteName!event handling!private! !
!Tools.UnitTestPlugin categoriesFor: #toggleToTests!commands!public! !
!Tools.UnitTestPlugin categoriesFor: #toggleToTestsClass!helpers!private! !
!Tools.UnitTestPlugin categoriesFor: #toggleToTestsClassDescription!helpers!private! !
!Tools.UnitTestPlugin categoriesFor: #update:!helpers!private! !
!Tools.UnitTestPlugin categoriesFor: #updateDefects!private!Updating! !
!Tools.UnitTestPlugin categoriesFor: #updateWindow!private!Updating! !

!Tools.UnitTestPlugin class methodsFor!

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

	^super publishedAspects
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
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.ContainerView) 34 15 nil nil 34 2 8 1409482752 131073 416 nil nil nil 5 nil nil nil 416 984838 ##(UI.BorderLayout) 1 1 410 ##(UI.PushButton) 34 20 nil 416 34 2 8 1140924416 1 512 nil 917510 ##(Graphics.Color) #silver 918022 ##(Graphics.Point) 177 57 5 nil 852998 ##(Graphics.Font) nil true 655622 ##(OS.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 68 132 66 49 15 1 0 0 196 53 15 1 2 0 144 39 0 0 0 0 191 0 253 85 63 1] 610 193 193 nil 512 nil 8 1801347024 1377606 4 ##(UI.CommandDescription) #runTests 8 'Run Tests' 9381 1 nil nil false nil nil nil 1310982 ##(Core.MessageSequence) 138 144 34 3 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 610 1 1 610 969 49 512 866 #isEnabled: 8 #(false) 512 866 #text: 34 1 8 'Run Tests' 512 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 228 1 0 0 24 0 0 0] 8 #() 610 193 193 nil 29 nil nil nil 410 ##(UI.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 1104 nil 578 #darkOrange nil 5 nil nil nil 1104 482 1 1 nil 410 ##(UI.ContainerView) 34 15 nil 1104 34 2 8 1140850688 131073 1200 nil 578 #default nil 5 nil nil nil 1200 482 1 1 nil nil 410 ##(UI.PushButton) 34 20 nil 1200 34 2 8 1140924416 1 1296 nil nil nil 5 nil 642 nil true 674 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 610 193 193 nil 1296 nil 8 1801347024 754 #debugTest 8 'Debug' 1 1 nil nil false nil nil nil 802 138 144 34 3 866 #createAt:extent: 34 2 610 815 1 610 155 49 1296 866 #isEnabled: 8 #(false) 1296 866 #text: 34 1 8 'Debug' 1296 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 151 1 0 0 0 0 0 0 228 1 0 0 24 0 0 0] 8 #() 1088 nil 29 nil 410 ##(UI.ComboBox) 34 17 nil 1200 34 2 8 1144063491 1 1712 787270 2 ##(UI.ListModel) 138 144 8 #() nil 1769478 ##(Kernel.IdentitySearchPolicy) nil nil 5 nil 642 nil true 674 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 610 193 193 nil 1712 nil 8 1801138208 ##(UI.BasicListAbstract) 8 #() 401 802 138 144 34 2 866 #createAt:extent: 34 2 610 1 1 610 815 49 1712 866 #isEnabled: 8 #(false) 1712 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 151 1 0 0 24 0 0 0] 8 #() 1088 nil 27 170 192 34 4 1296 8 'debugButton' 1712 8 'defects' nil 802 138 144 34 1 866 #createAt:extent: 34 2 610 1 285 610 969 49 1200 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 142 0 0 0 228 1 0 0 166 0 0 0] 34 2 1296 1712 1088 nil 27 nil nil 410 ##(UI.ContainerView) 34 15 nil 1104 34 2 8 1140850688 131073 2384 nil 1264 nil 5 nil nil nil 2384 482 1 1 410 ##(UI.StaticText) 34 16 nil 2384 34 2 8 1140850945 1 2464 nil nil 610 177 81 5 nil 642 nil true 674 8 #[208 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 49 67 111 117 114 105 101 114 32 78 101 119 0 83 0 118 97 0 114 105 102 0 39 0 0 0 0 191 0 253 85 63 1] 610 193 193 nil 2464 nil 8 1801195232 1049094 ##(UI.NullConverter) nil nil true 802 138 144 34 2 866 #createAt:extent: 34 2 610 1 1 610 969 121 2464 866 #text: 34 1 8 'No Tests' 2464 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 228 1 0 0 60 0 0 0] 8 #() 1088 nil 27 nil nil nil 410 ##(UI.StaticText) 34 16 nil 2384 34 2 8 1140850945 65 2864 nil nil nil 5 nil 642 nil true 674 8 #[240 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 68 132 66 49 15 1 0 0 196 53 15 1 2 0 144 39 0 0 0 0 191 0 253 85 63 1] 610 193 193 nil 2864 nil 8 1801195232 2626 nil nil nil 802 138 144 34 2 866 #createAt:extent: 34 2 610 1 121 610 969 165 2864 866 #text: 34 1 8 '...' 2864 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 60 0 0 0 228 1 0 0 142 0 0 0] 8 #() 1088 nil 27 170 192 34 4 2464 8 'mode' 2864 8 'details' nil 802 138 144 34 1 866 #createAt:extent: 34 2 610 1 1 610 969 285 2384 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 228 1 0 0 142 0 0 0] 34 2 2864 2464 1088 nil 27 170 192 34 2 2384 8 'colorField' 1180166 ##(Graphics.Rectangle) 610 1 1 610 1 1 802 138 144 34 1 866 #createAt:extent: 34 2 610 1 49 610 969 333 1104 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 24 0 0 0 228 1 0 0 190 0 0 0] 34 2 2384 1200 1088 nil 27 170 192 34 2 512 8 'runOne' nil 802 138 144 34 1 866 #createAt:extent: 34 2 610 6143 21 610 969 381 416 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 227 13 0 0 200 0 0 0] 34 2 512 1104 1088 nil 27 )!

runningColor
	^RunningColor!

runningColor: aColor 
	RunningColor := aColor = Color default ifTrue: [self defaultRunningColor] ifFalse: [aColor]! !
!Tools.UnitTestPlugin class categoriesFor: #autoSwitchDelayMs!accessing!public! !
!Tools.UnitTestPlugin class categoriesFor: #autoSwitchDelayMs:!accessing!public! !
!Tools.UnitTestPlugin class categoriesFor: #defaultAutoSwitchDelay!constants!private! !
!Tools.UnitTestPlugin class categoriesFor: #defaultErrorColor!constants!private! !
!Tools.UnitTestPlugin class categoriesFor: #defaultFailColor!constants!private! !
!Tools.UnitTestPlugin class categoriesFor: #defaultNoTestsColor!private!Updating! !
!Tools.UnitTestPlugin class categoriesFor: #defaultPassColor!constants!private! !
!Tools.UnitTestPlugin class categoriesFor: #defaultRunningColor!constants!private! !
!Tools.UnitTestPlugin class categoriesFor: #errorColor!accessing!public! !
!Tools.UnitTestPlugin class categoriesFor: #errorColor:!accessing!public! !
!Tools.UnitTestPlugin class categoriesFor: #failColor!accessing!public! !
!Tools.UnitTestPlugin class categoriesFor: #failColor:!accessing!public! !
!Tools.UnitTestPlugin class categoriesFor: #icon!constants!public! !
!Tools.UnitTestPlugin class categoriesFor: #initialize!class initialization!private! !
!Tools.UnitTestPlugin class categoriesFor: #noTestsColor!accessing!public! !
!Tools.UnitTestPlugin class categoriesFor: #noTestsColor:!accessing!public! !
!Tools.UnitTestPlugin class categoriesFor: #passColor!accessing!public! !
!Tools.UnitTestPlugin class categoriesFor: #passColor:!accessing!public! !
!Tools.UnitTestPlugin class categoriesFor: #publishedAspects!private! !
!Tools.UnitTestPlugin class categoriesFor: #resource_Default_view!public!resources-views! !
!Tools.UnitTestPlugin class categoriesFor: #runningColor!accessing!public! !
!Tools.UnitTestPlugin class categoriesFor: #runningColor:!accessing!public! !

