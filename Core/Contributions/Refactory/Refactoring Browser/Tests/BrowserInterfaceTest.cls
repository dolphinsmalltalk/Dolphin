"Filed out from Dolphin Smalltalk 2000 release 5.00"!

RefactoringBrowserTest subclass: #BrowserInterfaceTest
	instanceVariableNames: 'browser'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
BrowserInterfaceTest guid: (GUID fromString: '{31A3532C-EDFB-4988-AC25-ACBCC9144534}')!
BrowserInterfaceTest comment: ''!
!BrowserInterfaceTest categoriesForClass!Refactory-Testing! !
!BrowserInterfaceTest methodsFor!

navigator
	^browser navigator!

oldTestBufferChange
"	| tool |
	self wrapConfirmWith: #(true false true).
	self openBrowser.
	(self navigator)
		selectClass: Object;
		changedClass;
		setSelector: #printString;
		changedSelector.
	(tool := browser currentTool) tool textNoChange: 'This is a test'.
	browser newBuffer.
	(self navigator)
		selectClass: Class;
		changedClass;
		setSelector: #name;
		changedSelector.
	self assert: browser requestForWindowClose.
	browser currentBuffer value: tool.
	browser changedBuffer.
	self assert: self navigator selector = #printString.
	browser removeBuffer.
	self assert: self navigator selector = #printString.
	self assert: self navigator selectedClass = Object"!

openBrowser
	^RefactoringBrowserShell show!

openBrowserOn: anEnvironment
	| prompt |
	prompt := ScheduledWindow promptForOpen.
	ScheduledWindow promptForOpen: false.
	[browser := RefactoringBrowser openOnEnvironment: anEnvironment] 
		ensure: [ScheduledWindow promptForOpen: prompt]!

setClassTests
	(self navigator)
		selectClass: Object;
		changedClass.
	self assert: self navigator selectedClass = Object.
	self assert: self navigator selectedClasses asArray = (Array with: Object).
	self assert: self navigator className = #Object.
	self assert: self navigator classNames asArray = #(#Object).
	self assert: self navigator nonMetaClass = Object.
	self assert: self navigator nonMetaClasses asArray = (Array with: Object).
	self deny: self navigator isMeta.
	self navigator updateCategoryList.
	self assert: self navigator selectedClass = Object.
	self assert: self navigator selectedClasses asArray = (Array with: Object).
	self assert: self navigator className = #Object.
	self assert: self navigator classNames asArray = #(#Object).
	self assert: self navigator nonMetaClass = Object.
	self assert: self navigator nonMetaClasses asArray = (Array with: Object).
	(self navigator)
		selectClass: Class class;
		changedClass.
	self assert: self navigator selectedClass = Class class.
	self 
		assert: self navigator selectedClasses asArray = (Array with: Class class).
	self assert: self navigator className = #Class.
	self assert: self navigator classNames asArray = #(#Class).
	self assert: self navigator nonMetaClass = Class.
	self assert: self navigator nonMetaClasses asArray = (Array with: Class).
	self assert: self navigator isMeta.
	self navigator updateCategoryList.
	self assert: self navigator selectedClass = Class class.
	self 
		assert: self navigator selectedClasses asArray = (Array with: Class class).
	self assert: self navigator className = #Class.
	self assert: self navigator classNames asArray = #(#Class).
	self assert: self navigator nonMetaClass = Class.
	self assert: self navigator nonMetaClasses asArray = (Array with: Class).
	(self navigator)
		selectClass: nil;
		changedClass.
	self assert: self navigator selectedClass = nil.
	self assert: self navigator selectedClasses asArray = #().
	self assert: self navigator className = nil.
	self assert: self navigator classNames asArray = #().
	self assert: self navigator nonMetaClass = nil.
	self assert: self navigator nonMetaClasses asArray = #().
	self navigator updateCategoryList.
	self assert: self navigator selectedClass = nil.
	self assert: self navigator selectedClasses asArray = #().
	self assert: self navigator className = nil.
	self assert: self navigator classNames asArray = #().
	self assert: self navigator nonMetaClass = nil.
	self assert: self navigator nonMetaClasses asArray = #()!

setSelectorTests
	(self navigator)
		beHierarchy;
		selectClass: Object;
		changedClass;
		setSelector: #printString;
		changedSelector.
	self assert: self navigator selector = #printString.
	self assert: self navigator selectors asArray = #(#printString).
	self assert: self navigator protocol = #printing.
	self assert: self navigator protocols asArray = #(#printing).
	self assert: self navigator category = #'Kernel-Objects'.
	self assert: self navigator categories asArray = #(#'Kernel-Objects').
	self navigator clearToClass.
	self assert: self navigator selector = nil.
	self assert: self navigator selectors asArray = #().
	self assert: self navigator protocol = nil.
	self assert: self navigator protocols asArray = #().
	self assert: self navigator selectedClass = Object!

tearDown
	browser notNil 
		ifTrue: 
			[browser closeAndUnschedule.
			(Delay forMilliseconds: 100) wait].
	super tearDown!

testAndClassBrowserClassTest
	self 
		openBrowserOn: (BrowserEnvironment new 
				forClasses: (Array with: Object with: Class class)) 
					& BrowserEnvironment new.
	self setClassTests!

testBuffers
	self openBrowser.
	(self navigator)
		selectClass: Object;
		changedClass;
		setSelector: #printString;
		changedSelector.
	browser newBuffer.
	(self navigator)
		selectClass: Class;
		changedClass;
		setSelector: #name;
		changedSelector.
	self assert: browser requestForWindowClose.
	self assert: self navigator selector = #name.
	browser removeBuffer.
	self assert: self navigator selector = #printString.
	self assert: self navigator selectedClass = Object!

testCategoryBrowserClassTest
	self openBrowserOn: (BrowserEnvironment new 
				forCategories: #(#'Kernel-Objects' #'Kernel-Classes')).
	self setClassTests!

testCategoryBrowserSelectorTest
	self 
		openBrowserOn: (BrowserEnvironment new forCategories: #(#'Kernel-Objects')).
	self setSelectorTests!

testClassBrowserClassTest
	self openBrowserOn: (BrowserEnvironment new 
				forClasses: (Array with: Object with: Class class)).
	self setClassTests!

testClassBrowserSelectorTest
	self 
		openBrowserOn: (BrowserEnvironment new forClasses: (Array with: Object)).
	self setSelectorTests!

testClassSelectorBrowserClassTest
	| env |
	env := SelectorEnvironment new.
	env addClass: Object selector: #printString.
	env addClass: Class class.
	self openBrowserOn: env.
	self setClassTests!

testClassSelectorBrowserSelectorTest
	| env |
	env := SelectorEnvironment new.
	env addClass: Object selector: #printString.
	env addClass: Class class.
	self openBrowserOn: env.
	self setSelectorTests!

testClassTools
	| tool |
	self openBrowser.
	self navigator selectClass: BrowserTextTool.
	self navigator changedClass.
	tool := browser currentTool tool.
	self assert: tool subcanvas class = BrowserClassTool.
	tool currentSubcanvas value: #comment.
	tool updateContents.
	self assert: tool subcanvas class = ClassCommentTool.
	tool subcanvas generateDefaultComment.
	tool currentSubcanvas value: #organization.
	tool updateContents.
	self assert: tool subcanvas class = OrganizationEditor.
	tool currentSubcanvas value: #hierarchy.
	tool updateContents.
	self assert: tool subcanvas class = OMTClassTool!

testNotBrowserSelectorTest
	| env |
	env := SelectorEnvironment new.
	env addClass: Collection.
	self openBrowserOn: env not.
	self setSelectorTests!

testProtocolBrowserSelectorTest
	self openBrowserOn: (BrowserEnvironment new forClass: Object
				protocols: #(#printing)).
	self setSelectorTests!

testResourceViewers
	| index |
	index := RefactoringBrowser allInstVarNames indexOf: 'tools'.
	RefactoringBrowser
		beMultiWindow;
		beVertical.
	self openBrowser.
	RefactoringBrowser
		beSingleWindow;
		beHorizontal.
	self navigator selectClass: VisualLauncher class.
	self navigator setSelector: #CGLint24.
	self navigator changedSelector.
	self 
		assert: (browser instVarAt: index) last tool subcanvas class == IconViewer.
	(browser instVarAt: index) last tool visual value: false.
	self assert: (browser instVarAt: index) last tool subcanvas class 
				== BrowserCodeTool.
	self navigator setSelector: #menuBar.
	self navigator changedSelector.
	self assert: (browser instVarAt: index) last tool class = ResourceTool.
	(browser instVarAt: index) last tool visual value: true.
	self 
		assert: (browser instVarAt: index) last tool subcanvas class == MenuViewer.
	self navigator setSelector: #windowSpec.
	self navigator changedSelector.
	self assert: (browser instVarAt: index) last tool class = ResourceTool.
	self assert: (browser instVarAt: index) last tool subcanvas class 
				== CanvasViewer!

testSelectorBrowserSelectorTest
	self openBrowserOn: (BrowserEnvironment new forClass: Object
				selectors: #(#printString)).
	self setSelectorTests!

testSystemBrowserClassTest
	self openBrowser.
	self setClassTests!

testSystemBrowserSelectorTest
	self openBrowser.
	self setSelectorTests! !
!BrowserInterfaceTest categoriesFor: #navigator!public!set up! !
!BrowserInterfaceTest categoriesFor: #oldTestBufferChange!public!tests! !
!BrowserInterfaceTest categoriesFor: #openBrowser!public!set up! !
!BrowserInterfaceTest categoriesFor: #openBrowserOn:!*-compilation failures!public!set up! !
!BrowserInterfaceTest categoriesFor: #setClassTests!public!set up! !
!BrowserInterfaceTest categoriesFor: #setSelectorTests!public!set up! !
!BrowserInterfaceTest categoriesFor: #tearDown!public!set up! !
!BrowserInterfaceTest categoriesFor: #testAndClassBrowserClassTest!public!tests! !
!BrowserInterfaceTest categoriesFor: #testBuffers!public!tests! !
!BrowserInterfaceTest categoriesFor: #testCategoryBrowserClassTest!public!tests! !
!BrowserInterfaceTest categoriesFor: #testCategoryBrowserSelectorTest!public!tests! !
!BrowserInterfaceTest categoriesFor: #testClassBrowserClassTest!public!tests! !
!BrowserInterfaceTest categoriesFor: #testClassBrowserSelectorTest!public!tests! !
!BrowserInterfaceTest categoriesFor: #testClassSelectorBrowserClassTest!public!tests! !
!BrowserInterfaceTest categoriesFor: #testClassSelectorBrowserSelectorTest!public!tests! !
!BrowserInterfaceTest categoriesFor: #testClassTools!*-compilation failures!public!tests! !
!BrowserInterfaceTest categoriesFor: #testNotBrowserSelectorTest!public!tests! !
!BrowserInterfaceTest categoriesFor: #testProtocolBrowserSelectorTest!public!tests! !
!BrowserInterfaceTest categoriesFor: #testResourceViewers!*-compilation failures!public!tests! !
!BrowserInterfaceTest categoriesFor: #testSelectorBrowserSelectorTest!public!tests! !
!BrowserInterfaceTest categoriesFor: #testSystemBrowserClassTest!public!tests! !
!BrowserInterfaceTest categoriesFor: #testSystemBrowserSelectorTest!public!tests! !

