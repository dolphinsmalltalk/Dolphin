"Filed out from Dolphin Smalltalk 7"!

ClassBrowserPlugin subclass: #UnitTestPlugin
	instanceVariableNames: 'result icon autoSwitchProcess defectsPresenter modePresenter detailsPresenter'
	classVariableNames: 'AutoSwitchDelayMs FailColor NoTestsColor PassColor RunningColor'
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
	detailsPresenter	<TextPresenter> providing further details about the current running state

Class Variables:
	AutoSwitchDelayMs	<Integer> count of milliseconds after which the <autoSwitchProcess> will bring the plugin pane to the foreground
	FailColor			<color> which will be used as a background colour when some tests fail
	PassColor			<color> which will be used as a background colour when all tests pass
	RunningColor		<color> which will be used as a background colour when tests are running
	NoTestsColor		<color> which will be used as a background colour when no tests are available for the browser selection


'!
!UnitTestPlugin categoriesForClass!Browser-Plugins! !
!UnitTestPlugin methodsFor!

allContextMenus
	| allMenus |
	allMenus := OrderedCollection new.
	self browser view withAllSubViews 
		do: [:each | each contextMenu ifNotNil: [:menu | allMenus addAll: menu allMenus]].
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

debugTest: aTestCase 
	self displayMode: 'Debugging'.
	aTestCase debug!

defaultHelpId
	^10994!

displayColor: aColor 
	modePresenter view backcolor: aColor.
	detailsPresenter view backcolor: aColor!

displayDefects: aCollection
	defectsPresenter list: aCollection asSortedCollection.
	defectsPresenter view isEnabled: aCollection notEmpty!

displayDetails: aString 
	"Display aString to indicate additional details about the current mode of operation"

	detailsPresenter value: aString.
	SessionManager inputState pumpMessages!

displayFail
	"Indicate that some tests have failed and we have defects"

	self icon: (Icon fromFile: 'UnitTestPluginFail.ico').
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

	self icon: (Icon fromFile: 'UnitTestPluginPass.ico').
	self displayColor: self class passColor.
	self displayMode: 'Pass'.
	self displayDetails: result displayString!

displayReset
	self displayColor: self class noTestsColor.
	self hasTestClass 
		ifTrue: 
			[self icon: (Icon fromFile: 'UnitTestPluginNotRun.ico').
			self displayMode: 'Not Yet Run']
		ifFalse: 
			[self icon: (Icon fromFile: 'UnitTestPluginNoTest.ico').
			self displayMode: 'No Tests'].
	self displayDetails: ''.
	self displayDefects: OrderedCollection new.
	result := nil!

displayRunning
	"Indicate that tests are being run"

	self icon: (Icon fromFile: 'UnitTestPluginDefect.ico').
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

	icon := anIconOrNil.
	self refreshIcon!

installMenuCommands
	"Private - Installs the menu commands required by the receiver into the associated browser menus"

	| classContextMenus classMenuBarMenus methodContextMenus methodMenuBarMenus |
	classContextMenus := self allContextMenus 
				select: [:each1 | each1 items anySatisfy: [:item | item command = #newClass]].
	classContextMenus do: [:each | self installTestCommandsInClassMenu: each withAccelerator: false].
	classMenuBarMenus := self allMenuBarMenus 
				select: [:each1 | each1 items anySatisfy: [:item | item command = #newClass]].
	classMenuBarMenus do: [:each | self installTestCommandsInClassMenu: each withAccelerator: true].
	methodContextMenus := self allContextMenus 
				select: [:each1 | each1 items anySatisfy: [:item | item command = #newMethod]].
	methodContextMenus do: [:each | self installTestCommandsInMethodMenu: each].
	methodMenuBarMenus := self allMenuBarMenus 
				select: [:each1 | each1 items anySatisfy: [:item | item command = #newMethod]].
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
	self view arrangement: self.
	SessionManager inputState pumpMessages!

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
		ifTrue: [self displayDetails: anObject printString]
		ifFalse: [super update: anObject]!

updateDefects
	self displayDefects: result defects!

updateWindow
	result hasPassed
		ifTrue: [self displayPass]
		ifFalse: [self displayFail].
	self updateDefects! !
!UnitTestPlugin categoriesFor: #allContextMenus!helpers!private! !
!UnitTestPlugin categoriesFor: #allMenuBarMenus!helpers!private! !
!UnitTestPlugin categoriesFor: #classUnderTest!Accessing!private! !
!UnitTestPlugin categoriesFor: #createComponents!initializing!private! !
!UnitTestPlugin categoriesFor: #createSchematicWiring!helpers!private! !
!UnitTestPlugin categoriesFor: #currentTestMethodSelectors!commands!private! !
!UnitTestPlugin categoriesFor: #debugTest!commands!public! !
!UnitTestPlugin categoriesFor: #debugTest:!operations!private! !
!UnitTestPlugin categoriesFor: #defaultHelpId!constants!public! !
!UnitTestPlugin categoriesFor: #displayColor:!private!Updating! !
!UnitTestPlugin categoriesFor: #displayDefects:!private!Updating! !
!UnitTestPlugin categoriesFor: #displayDetails:!private!Updating! !
!UnitTestPlugin categoriesFor: #displayFail!private!Updating! !
!UnitTestPlugin categoriesFor: #displayMode:!private!Updating! !
!UnitTestPlugin categoriesFor: #displayOn:!displaying!private! !
!UnitTestPlugin categoriesFor: #displayPass!private!Updating! !
!UnitTestPlugin categoriesFor: #displayReset!private!Updating! !
!UnitTestPlugin categoriesFor: #displayRunning!private!Updating! !
!UnitTestPlugin categoriesFor: #hasDefects!public! !
!UnitTestPlugin categoriesFor: #hasIndividualTests!public!Updating! !
!UnitTestPlugin categoriesFor: #hasTestClass!public!Updating! !
!UnitTestPlugin categoriesFor: #icon!public! !
!UnitTestPlugin categoriesFor: #icon:!private! !
!UnitTestPlugin categoriesFor: #installMenuCommands!private! !
!UnitTestPlugin categoriesFor: #installTestCommandsInClassMenu:withAccelerator:!helpers!private! !
!UnitTestPlugin categoriesFor: #installTestCommandsInMethodMenu:!private! !
!UnitTestPlugin categoriesFor: #isBrowserLookingAtTestClass!private!testing! !
!UnitTestPlugin categoriesFor: #onBrowserClassSelected!event handling!private! !
!UnitTestPlugin categoriesFor: #onBrowserMethodSelected!event handling!private! !
!UnitTestPlugin categoriesFor: #onViewOpened!private! !
!UnitTestPlugin categoriesFor: #queryCommand:!commands!private! !
!UnitTestPlugin categoriesFor: #refreshIcon!operations!private! !
!UnitTestPlugin categoriesFor: #runIndividualTests!commands!public! !
!UnitTestPlugin categoriesFor: #runSuite:!private! !
!UnitTestPlugin categoriesFor: #runTests!commands!public! !
!UnitTestPlugin categoriesFor: #startAutoSwitchProcess!private! !
!UnitTestPlugin categoriesFor: #stopAutoSwitchProcess!private! !
!UnitTestPlugin categoriesFor: #testClass!Accessing!private! !
!UnitTestPlugin categoriesFor: #testSuite!public! !
!UnitTestPlugin categoriesFor: #testSuiteName!event handling!private! !
!UnitTestPlugin categoriesFor: #toggleToTests!commands!public! !
!UnitTestPlugin categoriesFor: #toggleToTestsClass!private! !
!UnitTestPlugin categoriesFor: #toggleToTestsClassDescription!private! !
!UnitTestPlugin categoriesFor: #update:!helpers!private! !
!UnitTestPlugin categoriesFor: #updateDefects!private!Updating! !
!UnitTestPlugin categoriesFor: #updateWindow!private!Updating! !

!UnitTestPlugin class methodsFor!

autoSwitchDelayMs
	"Answer the number of milliseconds after which instances of the receiver will automatically switch
	to their tab when tests are running"

	^AutoSwitchDelayMs!

autoSwitchDelayMs: anInteger 
	"Set the number of milliseconds after which instances of the receiver will automatically switch
	to their tab when tests are running"

	AutoSwitchDelayMs := anInteger!

defaultAutoSwitchDelay
	"Private - Answer the default number of milliseconds before the plugin will automatically show itself when tests are running"

	^1000!

defaultFailColor
	^RGB 
		red: 243
		green: 27
		blue: 65!

defaultNoTestsColor
	^RGB 
		red: 111
		green: 158
		blue: 238!

defaultPassColor
	^RGB 
		red: 100
		green: 210
		blue: 103!

defaultRunningColor
	^RGB 
		red: 235
		green: 201
		blue: 65!

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

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.ContainerView)  98 15 0 0 98 2 8 1409482752 131073 416 0 196934 1 ##(Smalltalk.RGB)  25264513 0 5 0 0 0 416 788230 ##(Smalltalk.BorderLayout)  1 1 410 8 ##(Smalltalk.PushButton)  98 17 0 416 98 2 8 1140924416 1 560 0 498 25264513 328198 ##(Smalltalk.Point)  177 57 5 0 263174 ##(Smalltalk.Font)  0 16 459014 ##(Smalltalk.LOGFONT)  8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 68 132 66 49 15 1 0 0 196 53 15 1 2 0 144 39 0 0 0 0 191 0 253 85 63 1] 658 193 193 0 560 0 8 4294902317 1180998 4 ##(Smalltalk.CommandDescription)  8 #runTests 8 'Run Tests' 9381 1 0 0 32 983302 ##(Smalltalk.MessageSequence)  202 208 98 3 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 658 1 1 658 969 49 560 930 8 #isEnabled: 98 1 32 560 930 8 #text: 98 1 8 'Run Tests' 560 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 228 1 0 0 24 0 0 0] 98 0 658 193 193 0 27 0 0 0 410 432 98 15 0 416 98 2 8 1140850688 131073 1216 0 498 66047 0 5 0 0 0 1216 530 1 1 0 410 432 98 15 0 1216 98 2 8 1140850688 131073 1312 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 5 0 0 0 1312 530 1 1 0 0 410 576 98 17 0 1312 98 2 8 1140924416 1 1440 0 1378 1408 0 5 0 690 0 16 722 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 658 193 193 0 1440 0 8 4294902317 802 8 #debugTest 8 'Debug' 1 1 0 0 32 866 202 208 98 3 930 960 98 2 658 815 1 658 155 49 1440 930 1040 98 1 32 1440 930 1088 98 1 8 'Debug' 1440 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 151 1 0 0 0 0 0 0 228 1 0 0 24 0 0 0] 98 0 1200 0 27 0 410 8 ##(Smalltalk.ComboBox)  98 17 0 1312 98 2 8 1144063491 1 1888 590662 2 ##(Smalltalk.ListModel)  202 208 98 0 0 1310726 ##(Smalltalk.IdentitySearchPolicy)  1378 1408 0 5 0 690 0 16 722 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 658 193 193 0 1888 0 8 4294902425 8 ##(Smalltalk.BasicListAbstract)  2016 401 866 202 208 98 2 930 960 98 2 658 1 1 658 815 49 1888 930 1040 98 1 32 1888 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 151 1 0 0 24 0 0 0] 98 0 1200 0 27 234 256 98 4 1440 8 'debugButton' 1888 8 'defects' 0 866 202 208 98 1 930 960 98 2 658 1 285 658 969 49 1312 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 142 0 0 0 228 1 0 0 166 0 0 0] 98 2 1440 1888 1200 0 27 0 0 410 432 98 15 0 1216 98 2 8 1140850688 131073 2592 0 1378 1408 0 5 0 0 0 2592 530 1 1 410 8 ##(Smalltalk.StaticText)  98 16 0 2592 98 2 8 1140850945 1 2688 0 0 658 177 81 5 0 690 0 16 722 8 #[208 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 49 67 111 117 114 105 101 114 32 78 101 119 0 83 0 118 97 0 114 105 102 0 39 0 0 0 0 191 0 253 85 63 1] 658 193 193 0 2688 0 8 4294902439 852486 ##(Smalltalk.NullConverter)  0 0 16 866 202 208 98 2 930 960 98 2 658 1 1 658 969 121 2688 930 1088 98 1 8 'No Tests' 2688 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 228 1 0 0 60 0 0 0] 98 0 1200 0 27 0 0 0 410 2704 98 16 0 2592 98 2 8 1140850945 65 3104 0 0 0 5 0 690 0 16 722 8 #[240 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 68 132 66 49 15 1 0 0 196 53 15 1 2 0 144 39 0 0 0 0 191 0 253 85 63 1] 658 193 193 0 3104 0 8 4294902439 2866 0 0 0 866 202 208 98 2 930 960 98 2 658 1 121 658 969 165 3104 930 1088 98 1 8 '...' 3104 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 60 0 0 0 228 1 0 0 142 0 0 0] 98 0 1200 0 27 234 256 98 4 2688 8 'mode' 3104 8 'details' 0 866 202 208 98 1 930 960 98 2 658 1 1 658 969 285 2592 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 228 1 0 0 142 0 0 0] 98 2 3104 2688 1200 0 27 234 256 2016 590342 ##(Smalltalk.Rectangle)  658 1 1 658 1 1 866 202 208 98 1 930 960 98 2 658 1 49 658 969 333 1216 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 24 0 0 0 228 1 0 0 190 0 0 0] 98 2 2592 1312 1200 0 27 234 256 98 4 560 8 'runOne' 1216 8 'colorField' 0 866 202 208 98 1 930 960 98 2 658 3839 21 658 969 381 416 1138 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 99 9 0 0 200 0 0 0] 98 2 560 1216 1200 0 27 )!

runningColor
	^RunningColor!

runningColor: aColor 
	RunningColor := aColor = Color default ifTrue: [self defaultRunningColor] ifFalse: [aColor]! !
!UnitTestPlugin class categoriesFor: #autoSwitchDelayMs!public! !
!UnitTestPlugin class categoriesFor: #autoSwitchDelayMs:!public! !
!UnitTestPlugin class categoriesFor: #defaultAutoSwitchDelay!constants!private! !
!UnitTestPlugin class categoriesFor: #defaultFailColor!private! !
!UnitTestPlugin class categoriesFor: #defaultNoTestsColor!private!Updating! !
!UnitTestPlugin class categoriesFor: #defaultPassColor!private! !
!UnitTestPlugin class categoriesFor: #defaultRunningColor!private! !
!UnitTestPlugin class categoriesFor: #failColor!accessing!public! !
!UnitTestPlugin class categoriesFor: #failColor:!accessing!public! !
!UnitTestPlugin class categoriesFor: #icon!constants!public! !
!UnitTestPlugin class categoriesFor: #initialize!private! !
!UnitTestPlugin class categoriesFor: #noTestsColor!accessing!public! !
!UnitTestPlugin class categoriesFor: #noTestsColor:!accessing!public! !
!UnitTestPlugin class categoriesFor: #passColor!accessing!public! !
!UnitTestPlugin class categoriesFor: #passColor:!accessing!public! !
!UnitTestPlugin class categoriesFor: #publishedAspects!development!private! !
!UnitTestPlugin class categoriesFor: #resource_Default_view!public!resources-views! !
!UnitTestPlugin class categoriesFor: #runningColor!public! !
!UnitTestPlugin class categoriesFor: #runningColor:!accessing!public! !

