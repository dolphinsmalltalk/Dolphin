"Filed out from Dolphin Smalltalk 7"!

SUnitAbsBrowser subclass: #SUnitBrowser
	instanceVariableNames: 'testCaseListModel showAllTextPresenter testCaseListPresenter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
SUnitBrowser guid: (GUID fromString: '{fc3aa1de-e128-4ade-a04c-035ebda3b5c2}')!
SUnitBrowser comment: ''!
!SUnitBrowser categoriesForClass!Unclassified! !
!SUnitBrowser methodsFor!

browseHierarchy
	| currentClass compiledMethod selected |
	selected := self model selectedItem.
	(selected isNil or: [selected canBrowse not]) ifTrue: [^self].
	currentClass := self model selectedItem class.
	compiledMethod := currentClass definitionOf: selected selector.
	compiledMethod isNil ifTrue: [^self].
	compiledMethod browse!

browserName

	^'SUnit Browser'!

callbackResetResults: aCollection

	self 
		refreshList:  aCollection;
		refreshTestCaseListFromTests: aCollection;
		setDetailState!

callbackResetRunningStatus

	self setLabelState!

callbackSetRunningStatus: aString

	self setRunningLabel: aString.
	self setStatusColorsOn: self label!

callbackToggledShowAll

	self setShowAllLabel!

callbackToggledShowBackgroundColors

	self refreshList!

callbackToggledShowIcons

	self refreshList!

callbackToggledShowStatusBackgroundColors

	self setResultDisplay!

callbackToggledShowToolbar

	self setToolbarState!

callbackToggledUseDisplayNames

	super callbackToggledUseDisplayNames.
	self refreshTestCaseList!

callbackUpdateTestCaseStatus: aTestCase withResult: aTestResult

	self setDetailState.

	self model showRunningStatusInList ifTrue: [
		self
			updateListStateFor: aTestCase
			with: aTestResult].

	self view update!

createComponents
	"Create the presenters contained by the receiver. At this stage
	the receiver has not yet been initialized."

	super createComponents.

	self testCaseListPresenter: (
		self 
			add: ListPresenter new 
			name: 'testCaseList').

	self showAllTextPresenter: (
		self 
			add: TextPresenter new 
			name: 'showAll')!

createSchematicWiring
	"Create the trigger wiring for the receiver. At this stage the initialization
	is complete and the view is open"

	super createSchematicWiring.

	self testCaseListPresenter
		when: #selectionChanged 
			send: #setModelWithSelectedTestCases
			to: self;
		when: #actionPerformed
			send: #browseHierarchy
			to: self!

debug

	self model debugSelected!

inspectSelected

	self model inspectSelected!

model: anSUnitBrowserModel
	"Set the model of the receiver to be anObject"

	super model: anSUnitBrowserModel.
	anSUnitBrowserModel browser: self.

	self listModel: (ListModel on: self wrapAllTestsFromModel).
	listPresenter model: self listModel.

	self testCaseListModel: (ListModel on: OrderedCollection new).
	testCaseListPresenter model: self testCaseListModel.

	self 
		setShowAllLabel;
		setResultDisplay!

queryCommand: aCommandQuery
	"Enters details about a potential command for the receiver into aCommandQuery"

	super queryCommand: aCommandQuery.

	(aCommandQuery command = #runSelected)
		 ifTrue: [^aCommandQuery isEnabled: self model canRun].

	(aCommandQuery command = #debug)
		 ifTrue: [^aCommandQuery isEnabled: self model canDebug].

	(aCommandQuery command = #step)
		 ifTrue: [^aCommandQuery isEnabled: self model canAnalyze].

	(aCommandQuery command = #inspect)
		 ifTrue: [^aCommandQuery isEnabled: self model canInspect].

	(aCommandQuery command = #showAll)
		 ifTrue: [^aCommandQuery isChecked: self model showAll].

	(aCommandQuery command = #showStatusPaneBackgroundColors)
		 ifTrue: [^aCommandQuery isChecked: self model showStatusBackgroundColors].

	(aCommandQuery command = #shouldInitializeResources)
		 ifTrue: [^aCommandQuery isChecked: self model shouldInitializeResources].

	(aCommandQuery command = #showRunningStatusInList)
		 ifTrue: [^aCommandQuery isChecked: self model showRunningStatusInList]!

refreshTestCaseItemAtIndex: anIndex 
	self testCaseListModel refreshAtIndex: anIndex.
	self testCaseListPresenter view ensureVisible: anIndex!

refreshTestCaseList

	1 
		to: self testCaseListModel size 
		do: [:index | self refreshTestCaseItemAtIndex: index].

	self view update !

refreshTestCaseList: aTestCase

	| index |

	index := self testCaseIndexOf: aTestCase.
	index = 0 
		ifTrue: [^self].

	self refreshTestCaseItemAtIndex: index!

refreshTestCaseListFromTests: aTestCaseCollection

	aTestCaseCollection do: [:each | each allTests do: [:eachTest | self refreshTestCaseList: eachTest]].
	self view update!

remove

	self model removeSelectedInList!

resetListFromModel

	self listModel 
		removeAll; 
		addAll: self wrapAllTestsFromModel.

	self model selectItems: #().

	self resetTestCaseListFromModel


!

resetTestCaseListFromModel

	| wraps |

	wraps := self wrapAllSelectedTestsFromModel.

	self testCaseListModel
		removeAll;
		addAll: wraps!

runAll

	self model runAll!

runSelected

	self model runSelected!

sbBrowseHierarchy
	| currentClass compiledMethod |

	self model selectedItem canBrowse
		ifFalse: [^self].

	currentClass := self model selectedItem class.

	compiledMethod := currentClass definitionOf: self model selectedItem selector.

	compiledMethod isNil 
		ifTrue: [^self].

	compiledMethod browse
 	!

setLabelState

	self labelTextPresenter value: self model resultStateString.
	self setStatusColorsOn: self label
!

setModelWithSelectedItems
	self model 
		selectItems: (self listPresenter selections collect: [:eachWrapper | eachWrapper testCase]).
	self resetTestCaseListFromModel!

setModelWithSelectedTestCases
	"set the models selected Test Cases from the Test Case Pane.  Check for empty collection
	fixes a subtle bug"

	| oc |

	oc := self testCaseListPresenter selections asOrderedCollection collect: [:each | each testCase].
	oc isEmpty ifTrue: [^self].

	self model selectItems: oc!

setRunningLabel: aString

	self labelTextPresenter value: aString!

setShowAllLabel

	self showAllTextPresenter value: self model showAllLabel.!

setToolbarState!

shouldInitializeResources

	self model toggleShouldInitializeResources!

showAll

	self model toggleShowAll.
	self setModelWithSelectedItems
!

showAllTextPresenter
	"Private - Answer the value of the receiver's ''showAllTextPresenter'' instance variable."

	^showAllTextPresenter!

showAllTextPresenter: anObject
	"Private - Set the value of the receiver's ''showAllTextPresenter'' instance variable to the argument, anObject."

	showAllTextPresenter := anObject!

showBackgroundColors!

showIcons!

showRunningStatusInList

	self model toggleShowRunningStatusInList!

showStatusPaneBackgroundColors

	self model toggleShowStatusBackgroundColors!

showToolBar!

step

	self model stepSelected!

testCaseIndexOf: aTestCase

	| index |

	index := 0.

	self testCaseListModel do: [:each | 
		index := index + 1. 
		each testCase = aTestCase 
			ifTrue: [^index]].

	^0
!

testCaseListModel
	"Private - Answer the value of the receiver's ''testCaseListModel'' instance variable."

	^testCaseListModel!

testCaseListModel: anObject
	"Private - Set the value of the receiver's ''testCaseListModel'' instance variable to the argument, anObject."

	testCaseListModel := anObject!

testCaseListPresenter
	"Private - Answer the value of the receiver's ''testCaseListPresenter'' instance variable."

	^testCaseListPresenter!

testCaseListPresenter: anObject
	"Private - Set the value of the receiver's ''testCaseListPresenter'' instance variable to the argument, anObject."

	testCaseListPresenter := anObject!

updateListStateFor: aTestCase with: aTestResult 
	| index |
	index := self listModel findFirst: [:each | each isFor: aTestCase withResult: aTestResult].
	self model showAll 
		ifTrue: 
			[index > 0 
				ifTrue: 
					[self listModel refreshAtIndex: index.
					self listPresenter view ensureVisible: index]]
		ifFalse: 
			[aTestResult hasPassed 
				ifTrue: [index > 0 ifTrue: [self listModel removeAtIndex: index]]
				ifFalse: 
					[index > 0 
						ifTrue: 
							[self listModel refreshAtIndex: index.
							self listPresenter view ensureVisible: index]
						ifFalse: 
							[self listModel add: (self wrapTest: aTestCase).
							self listPresenter view ensureVisible: self listModel size]]].
	self refreshTestCaseList: aTestCase!

wrapAllSelectedTestsFromModel

	| items |

	self model selectedItems isEmpty
		ifTrue: [^#()].

	items := OrderedCollection new.

	self model selectedItems do: [:each | items addAll: each allTests].

	self model showAll
		ifFalse: [
			items := 
				items select: [:each | 
					(self model numberCorrectFor: each) = 0]].

	^self wrapAllTests: items !

wrapAllTests: testCases

	| allTests |

	allTests := OrderedCollection new.

	testCases do: [:each | allTests add: each].
	^allTests collect: [:each | self wrapTest: each]!

wrapAllTestsFromModel

	^self wrapAllTests: self model listItems!

wrapTest: aTest

	^SUnitTestCaseWrapper
		newOn: aTest
		model: self model! !
!SUnitBrowser categoriesFor: #browseHierarchy!commands!private! !
!SUnitBrowser categoriesFor: #browserName!commands!private! !
!SUnitBrowser categoriesFor: #callbackResetResults:!model callbacks!private! !
!SUnitBrowser categoriesFor: #callbackResetRunningStatus!model callbacks!private! !
!SUnitBrowser categoriesFor: #callbackSetRunningStatus:!model callbacks!private! !
!SUnitBrowser categoriesFor: #callbackToggledShowAll!model callbacks!private! !
!SUnitBrowser categoriesFor: #callbackToggledShowBackgroundColors!model callbacks!private! !
!SUnitBrowser categoriesFor: #callbackToggledShowIcons!model callbacks!private! !
!SUnitBrowser categoriesFor: #callbackToggledShowStatusBackgroundColors!model callbacks!private! !
!SUnitBrowser categoriesFor: #callbackToggledShowToolbar!model callbacks!private! !
!SUnitBrowser categoriesFor: #callbackToggledUseDisplayNames!model callbacks!private! !
!SUnitBrowser categoriesFor: #callbackUpdateTestCaseStatus:withResult:!model callbacks!private! !
!SUnitBrowser categoriesFor: #createComponents!initializing!public! !
!SUnitBrowser categoriesFor: #createSchematicWiring!initializing!public! !
!SUnitBrowser categoriesFor: #debug!commands!private! !
!SUnitBrowser categoriesFor: #inspectSelected!commands!private! !
!SUnitBrowser categoriesFor: #model:!accessing!public! !
!SUnitBrowser categoriesFor: #queryCommand:!commands!private! !
!SUnitBrowser categoriesFor: #refreshTestCaseItemAtIndex:!model callbacks!private! !
!SUnitBrowser categoriesFor: #refreshTestCaseList!model callbacks!private! !
!SUnitBrowser categoriesFor: #refreshTestCaseList:!model callbacks!private! !
!SUnitBrowser categoriesFor: #refreshTestCaseListFromTests:!model callbacks!private! !
!SUnitBrowser categoriesFor: #remove!commands!private! !
!SUnitBrowser categoriesFor: #resetListFromModel!model callbacks!private! !
!SUnitBrowser categoriesFor: #resetTestCaseListFromModel!model callbacks!private! !
!SUnitBrowser categoriesFor: #runAll!commands!private! !
!SUnitBrowser categoriesFor: #runSelected!commands!private! !
!SUnitBrowser categoriesFor: #sbBrowseHierarchy!commands!private! !
!SUnitBrowser categoriesFor: #setLabelState!model callbacks!private! !
!SUnitBrowser categoriesFor: #setModelWithSelectedItems!event handling!private! !
!SUnitBrowser categoriesFor: #setModelWithSelectedTestCases!event handling!private! !
!SUnitBrowser categoriesFor: #setRunningLabel:!model callbacks!private! !
!SUnitBrowser categoriesFor: #setShowAllLabel!model callbacks!private! !
!SUnitBrowser categoriesFor: #setToolbarState!model callbacks!private! !
!SUnitBrowser categoriesFor: #shouldInitializeResources!commands!private! !
!SUnitBrowser categoriesFor: #showAll!commands!private! !
!SUnitBrowser categoriesFor: #showAllTextPresenter!accessing!private! !
!SUnitBrowser categoriesFor: #showAllTextPresenter:!accessing!private! !
!SUnitBrowser categoriesFor: #showBackgroundColors!commands!private! !
!SUnitBrowser categoriesFor: #showIcons!commands!private! !
!SUnitBrowser categoriesFor: #showRunningStatusInList!commands!private! !
!SUnitBrowser categoriesFor: #showStatusPaneBackgroundColors!commands!private! !
!SUnitBrowser categoriesFor: #showToolBar!commands!private! !
!SUnitBrowser categoriesFor: #step!commands!private! !
!SUnitBrowser categoriesFor: #testCaseIndexOf:!model callbacks!private! !
!SUnitBrowser categoriesFor: #testCaseListModel!accessing!private! !
!SUnitBrowser categoriesFor: #testCaseListModel:!accessing!private! !
!SUnitBrowser categoriesFor: #testCaseListPresenter!accessing!private! !
!SUnitBrowser categoriesFor: #testCaseListPresenter:!accessing!private! !
!SUnitBrowser categoriesFor: #updateListStateFor:with:!model callbacks!private! !
!SUnitBrowser categoriesFor: #wrapAllSelectedTestsFromModel!model callbacks!private! !
!SUnitBrowser categoriesFor: #wrapAllTests:!model callbacks!private! !
!SUnitBrowser categoriesFor: #wrapAllTestsFromModel!model callbacks!private! !
!SUnitBrowser categoriesFor: #wrapTest:!model callbacks!private! !

!SUnitBrowser class methodsFor!

defaultModel

	^self defaultModelClass
		newForUI: nil
		builder: TestCase!

defaultModelClass

	^SUnitBrowserModel!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream nextPutAll: 'SUnit Browser'!

initialize

	self initializeToolClass: self!

openOnTestCase: aTestCase 
	| model |
	model := SUnitBrowserModel newForUI: nil builder: aTestCase.
	^(self show)
		model: model;
		yourself!

publishedAspects
	"Answer a Set of the aspects published by  instances of the receiver"

	| aspects |
	aspects := super publishedAspects.
	aspects
		add: (Aspect boolean: #showAll);
		add: (Aspect boolean: #showStatusBackgroundColors);
		add: (Aspect boolean: #shouldInitializeResources).
	^aspects!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 327686 ##(Smalltalk.Color) #default nil 517 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.Toolbar) 34 25 nil 416 34 2 8 1140853572 131073 528 nil 480 nil 519 nil 263174 ##(Smalltalk.Font) nil true 459014 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 159 4 28 198 63 1 0 0 204 53 63 1 3 0 20 59 0 0 0 0 247 0 5 86 111 1] 328198 ##(Smalltalk.Point) 193 193 nil 528 480 8 1877912960 170 192 34 8 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 752 nil nil nil 7 nil nil nil 752 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Toolbar) #resource_Smalltalk_tools nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 674 63 1 674 553 51 752 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 51 1 0 0 25 0 0 0] 8 #() 674 193 193 nil 27 8 'smalltalkTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1088 nil nil nil 7 nil nil nil 1088 818 ##(Smalltalk.Toolbar) #resource_SUnitBrowser_toolbar nil 850 138 144 34 1 914 #createAt:extent: 34 2 674 1 51 674 387 51 1088 994 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 193 0 0 0 50 0 0 0] 1040 1056 nil 27 8 'sunitBrowserTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1328 nil nil nil 7 nil nil nil 1328 818 ##(Smalltalk.Toolbar) #resource_Search_tools nil 850 138 144 34 1 914 #createAt:extent: 34 2 674 615 1 674 437 51 1328 994 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 51 1 0 0 0 0 0 0 13 2 0 0 25 0 0 0] 1040 1056 nil 27 8 'searchTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1568 nil nil nil 7 nil nil nil 1568 818 ##(Smalltalk.Toolbar) #resource_Image_tools nil 850 138 144 34 1 914 #createAt:extent: 34 2 674 1 1 674 63 51 1568 994 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 1040 1056 nil 27 8 'imageTools' 170 192 1040 138 144 1040 nil nil 1 nil 674 33 33 nil nil 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 850 138 144 34 1 914 #createAt:extent: 34 2 674 1 1 674 1169 101 528 994 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 50 0 0 0] 34 4 1568 752 1328 1088 1056 nil 27 410 ##(Smalltalk.StatusBar) 34 18 nil 416 34 2 8 1140850956 1 2048 nil 466 #face3d nil 7 nil nil nil 2048 nil 8 1877614448 170 192 34 4 853766 ##(Smalltalk.StatusBarItem) 1 -1 2048 nil 787814 3 ##(Smalltalk.BlockClosure) 0 nil 1180966 ##(Smalltalk.CompiledExpression) 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:wrapper | wrapper text]' 8 #[30 105 17 158 106] #text 2224 7 257 nil ##(Smalltalk.IconicListAbstract) nil 8 'status' 2178 1 71 2048 nil ##(Smalltalk.BasicListAbstract) nil nil 8 'showAll' 34 2 2336 2192 1115142 ##(Smalltalk.StatusBarNullItem) 513 1 2048 nil nil 850 138 144 34 1 914 #createAt:extent: 34 2 674 1 643 674 1169 41 2048 994 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 65 1 0 0 72 2 0 0 85 1 0 0] 8 #() 1056 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 2576 nil 480 nil 7 nil nil nil 2576 498 1 1 410 ##(Smalltalk.StaticText) 34 16 nil 2576 34 2 8 1140850945 1 2656 nil 2112 nil 7 nil nil nil 2656 466 #black 8 1877802176 852486 ##(Smalltalk.NullConverter) nil nil nil 850 138 144 34 1 914 #createAt:extent: 34 2 674 1 1 674 1169 39 2656 994 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 19 0 0 0] 8 #() 1056 nil 27 nil nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 2576 34 2 8 1140850688 131073 2944 nil 480 nil 7 nil nil nil 2944 1180166 ##(Smalltalk.ProportionalLayout) 170 176 34 4 410 ##(Smalltalk.ListView) 34 45 nil 2944 34 2 8 1140920393 1 3072 590662 2 ##(Smalltalk.ListModel) 138 144 1040 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 466 #white nil 7 265030 4 ##(Smalltalk.Menu) nil true 34 20 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #runAll 8 'Run &All' 1 1 nil nil nil 3282 1 3314 #runSelected 8 '&Run Selected' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 3282 1 3314 #debug 8 '&Debug' 1 1 nil nil nil 3282 1 3314 #step 8 '&Step' 1 1 nil nil nil 3410 4097 3282 1 3314 #inspectSelected 8 '&Inspect' 1 1 nil nil nil 3410 4097 3282 1 3314 #delete 8 'Delete' 1 1 nil nil nil 3410 4097 3282 1 3314 #reset 8 'Reset' 1 1 nil nil nil 3410 4097 3282 1 3314 #sbBrowseHierarchy 8 'Browse &Hierarchy' 1 1 nil nil nil 3282 1 3314 #sbBrowseResources 8 'Browse Resources' 1 1 nil nil nil 3410 4097 3282 1 3314 #showAll 8 'Show All Results' 1 1 nil nil nil 3282 1 3314 #showRunningStatusInList 8 'Show Running Status In List' 1 1 nil nil nil 3282 1 3314 #showStatusPaneBackgroundColors 8 'Show Status Pane Background Colors' 1 1 nil nil nil 3282 1 3314 #useDisplayNames 8 'Use Display Names' 1 1 nil nil nil 3282 1 3314 #shouldInitializeResources 8 'Auto-Initialize Resources' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 3072 nil 8 1877889248 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil 674 65 65 nil nil 138 144 34 6 920646 5 ##(Smalltalk.ListViewColumn) 8 'Suite' 91 #left ##(Smalltalk.BasicListAbstract) 459270 ##(Smalltalk.Message) #<= 8 #() 2210 0 nil 2242 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:suite | suite name]' 8 #[30 105 17 158 106] #name 4304 7 257 nil nil 3072 2210 0 nil 2242 1 83886081 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x|nil]' 8 #[29 105 60 106] 4384 7 257 nil 3 nil nil 4210 8 'Correct' 155 #right ##(Smalltalk.BasicListAbstract) 4258 #<= 8 #() 2210 0 nil 2242 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:test | test numberCorrect]' 8 #[30 105 17 158 106] #numberCorrect 4528 7 257 nil nil 3072 nil 1 nil nil 4210 8 'Failures' 155 #right ##(Smalltalk.BasicListAbstract) 4258 #<= 8 #() 2210 0 nil 2242 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:test | test numberFailures]' 8 #[30 105 17 158 106] #numberFailures 4672 7 257 nil nil 3072 nil 1 nil nil 4210 8 'Errors' 155 #right ##(Smalltalk.BasicListAbstract) 4258 #<= 8 #() 2210 0 nil 2242 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:test | test numberErrors]' 8 #[30 105 17 158 106] #numberErrors 4816 7 257 nil nil 3072 nil 1 nil nil 4210 8 'Not Run' 155 #right ##(Smalltalk.BasicListAbstract) 4258 #<= 8 #() 2210 0 nil 2242 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:test | test numberNotYetRun]' 8 #[30 105 17 158 106] #numberNotYetRun 4960 7 257 nil nil 3072 nil 1 nil nil 4210 8 'Total' 155 #right ##(Smalltalk.BasicListAbstract) 4258 #<= 8 #() 2210 0 nil 2242 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:test | test numberTests]' 8 #[30 105 17 158 106] #numberTests 5104 7 257 nil nil 3072 nil 1 nil nil #report 8 #() nil 133217 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 850 138 144 34 3 914 #createAt:extent: 34 2 674 1 1 674 869 505 3072 914 #contextMenu: 34 1 3248 3072 914 #text: 34 1 8 'Suite' 3072 994 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 178 1 0 0 252 0 0 0] 8 #() 1056 nil 35 7 410 ##(Smalltalk.ListView) 34 45 nil 2944 34 2 8 1140920393 1 5440 3138 138 144 1040 nil 3200 3216 nil 7 3234 nil true 34 17 3282 1 3314 #runSelected 8 '&Run Selected' 1 1 nil nil nil 3410 4097 3282 1 3314 #debug 8 '&Debug' 1 1 nil nil nil 3282 1 3314 #step 8 '&Step' 1 1 nil nil nil 3410 4097 3282 1 3314 #inspectSelected 8 '&Inspect' 1 1 nil nil nil 3410 4097 3282 1 3314 #delete 8 'Delete' 1 1 nil nil nil 3410 4097 3282 1 3314 #reset 8 'Reset' 1 1 nil nil nil 3410 4097 3282 1 3314 #sbBrowseHierarchy 8 'Browse &Hierarchy' 1 1 nil nil nil 3282 1 3314 #sbBrowseResources 8 'Browse Resources' 1 1 nil nil nil 3410 4097 3282 1 3314 #showAll 8 'Show All Results' 1 1 nil nil nil 3282 1 3314 #showStatusPaneBackgroundColors 8 'Show Status &Pane Background Colors' 1 1 nil nil nil 3282 1 3314 #useDisplayNames 8 'Use Display Names' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 5440 nil 8 1877889248 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 4144 nil nil nil 674 65 65 nil nil 138 144 34 1 4210 8 'Test Case' 283 #left ##(Smalltalk.BasicListAbstract) 4258 #<= 8 #() 2210 0 nil 2242 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:testCase | testCase name]' 8 #[30 105 17 158 106] #name 6336 7 257 nil nil 5440 2210 0 nil 2242 1 83886081 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x|nil]' 8 #[29 105 60 106] 6416 7 257 nil 3 nil nil #report 5184 nil 133217 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 850 138 144 34 3 914 #createAt:extent: 34 2 674 879 1 674 291 505 5440 914 #contextMenu: 34 1 5536 5440 914 #text: 34 1 8 'Test Case' 5440 994 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 183 1 0 0 0 0 0 0 72 2 0 0 252 0 0 0] 8 #() 1056 nil 35 3 false 170 192 34 4 3072 8 'list' 5440 8 'testCaseList' nil 850 138 144 34 1 914 #createAt:extent: 34 2 674 1 39 674 1169 505 2944 994 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 19 0 0 0 72 2 0 0 15 1 0 0] 34 3 3072 410 ##(Smalltalk.Splitter) 34 12 nil 2944 34 2 8 1140850688 1 6960 nil 480 nil 519 nil nil nil 1510470 1 ##(Smalltalk.DraggableViewInteractor) 6960 nil 1 #left nil nil nil 674 1 1 674 9 9 nil 7056 nil 850 138 144 34 1 914 #createAt:extent: 34 2 674 869 1 674 11 505 6960 994 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 178 1 0 0 0 0 0 0 183 1 0 0 252 0 0 0] 8 #() 1056 nil 27 5440 1056 nil 27 170 192 34 2 2656 8 'label' nil 850 138 144 34 1 914 #createAt:extent: 34 2 674 1 101 674 1169 543 2576 994 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 50 0 0 0 72 2 0 0 65 1 0 0] 34 2 2656 2944 1056 nil 27 170 192 34 2 528 8 'toolbar' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 6 3234 nil true 34 1 3282 1 3314 #exit 8 '&Exit' 1 1 nil nil nil 8 '&File' nil 1 nil nil 58279 nil nil 3234 nil true 34 3 3282 1 3314 #sbBrowseHierarchy 8 'Browse &Hierarchy' 1 1 nil nil nil 3410 4097 3282 1 3314 #sbBrowseResources 8 'Browse &Resources' 1 1 nil nil nil 8 '&Browse' nil 1 nil nil 58285 nil nil 3234 nil true 34 12 3282 1 3314 #runAll 8 'Run &All' 1 1 nil nil nil 3282 1 3314 #runSelected 8 '&Run Selected' 1 1 nil nil nil 3282 1 3314 #profileSelected 8 '&Profile' 1 1 nil nil nil 3410 4097 3282 1 3314 #debug 8 '&Debug' 1 1 nil nil nil 3282 1 3314 #step 8 '&Step' 1 1 nil nil nil 3410 4097 3282 1 3314 #inspectSelected 8 '&Inspect' 1 1 nil nil nil 3410 4097 3282 1 3314 #delete 8 'Delete' 1 1 nil nil nil 3410 4097 3282 1 3314 #reset 8 'Reset' 1 1 nil nil nil 8 'T&est' nil 1 nil nil 58303 nil nil 3234 nil true 34 5 3282 1 3314 #showAll 8 'Show &All Results' 1 1 nil nil nil 3282 1 3314 #showRunningStatusInList 8 'Show Running Status In List' 1 1 nil nil nil 3282 1 3314 #showStatusPaneBackgroundColors 8 'Show Status &Pane Background Colors' 1 1 nil nil nil 3282 1 3314 #useDisplayNames 8 'Use Display Names' 1 1 nil nil nil 3282 1 3314 #shouldInitializeResources 8 'Auto-Initialize Resources' 1 1 nil nil nil 8 '&Configuration' nil 1 nil nil 58315 nil nil 3234 nil true 8 #() 8 '&Tools' #toolsMenu 1 nil nil 58317 nil nil 3234 nil true 34 15 3282 1 3314 #helpContents 8 '&Contents' 1025 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'Help.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 3282 1 3314 #help 8 'On this &Tool' 1249 1 nil nil nil 3282 1 3314 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 3410 4097 3282 1 3314 #learnSmalltalk 8 'Learn Smalltalk' 1 1 788806 1 ##(Smalltalk.TextTileIcon) $\x1F393 nil 466 #orchid 3216 nil nil 1 nil nil nil nil 3410 4097 3282 1 3314 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 3282 1 3314 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 3282 1 3314 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 3410 4097 3282 1 3314 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 8722 nil true 8768 8 '!!APPLICATION' 8816 nil nil 3282 1 3314 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 3282 1 3314 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 3410 4097 3282 1 3314 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 9010 $\x1F42C nil nil 466 #darkSlateBlue nil nil 1 nil nil nil nil 8 '&Help' #help 134217729 nil nil nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 850 138 144 34 2 914 #createAt:extent: 34 2 674 6143 21 674 1201 801 416 914 #text: 34 1 8 'SUnit Browser' 416 994 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 87 14 0 0 154 1 0 0] 34 3 528 2576 2048 1056 nil 27 )!

shouldInitializeResources

	^self  defaultModelClass shouldInitializeResources!

shouldInitializeResources: aBoolean

	^self defaultModelClass shouldInitializeResources: aBoolean!

showAll

	^self defaultModelClass showAll!

showAll: aBoolean

	^self  defaultModelClass showAll: aBoolean!

showRunningStatusInList

	^self  defaultModelClass showRunningStatusInList!

showRunningStatusInList: aBoolean

	^self defaultModelClass showRunningStatusInList: aBoolean!

showStatusBackgroundColors

	^self  defaultModelClass showStatusBackgroundColors!

showStatusBackgroundColors: aBoolean

	^self defaultModelClass showStatusBackgroundColors: aBoolean!

sunitbShow: aTestCase

	^self openOnTestCase: aTestCase!

sunitbShowAndRun: aTestCase

	(self openOnTestCase: aTestCase) runAll!

toolsFolderHelpId
	^10613!

uninitialize
	"Private - Uninitialize the receiver as it is about to be removed from the system.
	Un-register the system tools folder icon for the receiver.
	Note: This method is in the 'must strip' category so that it is removed in the early
	stages of image stripping. It is not required during stripping, because the system
	folders are cleared down anyway, and it may generate an error if required parts
	of the development system have already been removed."

	self uninitializeToolClass: self! !
!SUnitBrowser class categoriesFor: #defaultModel!accessing!private! !
!SUnitBrowser class categoriesFor: #defaultModelClass!accessing!private! !
!SUnitBrowser class categoriesFor: #displayOn:!displaying!public! !
!SUnitBrowser class categoriesFor: #initialize!initializing!must strip!private! !
!SUnitBrowser class categoriesFor: #openOnTestCase:!instance creation!public! !
!SUnitBrowser class categoriesFor: #publishedAspects!development!public! !
!SUnitBrowser class categoriesFor: #resource_Default_view!public!resources-views! !
!SUnitBrowser class categoriesFor: #shouldInitializeResources!configuring!public! !
!SUnitBrowser class categoriesFor: #shouldInitializeResources:!configuring!public! !
!SUnitBrowser class categoriesFor: #showAll!configuring!public! !
!SUnitBrowser class categoriesFor: #showAll:!configuring!public! !
!SUnitBrowser class categoriesFor: #showRunningStatusInList!configuring!public! !
!SUnitBrowser class categoriesFor: #showRunningStatusInList:!configuring!public! !
!SUnitBrowser class categoriesFor: #showStatusBackgroundColors!configuring!public! !
!SUnitBrowser class categoriesFor: #showStatusBackgroundColors:!configuring!public! !
!SUnitBrowser class categoriesFor: #sunitbShow:!instance creation!public! !
!SUnitBrowser class categoriesFor: #sunitbShowAndRun:!instance creation!public! !
!SUnitBrowser class categoriesFor: #toolsFolderHelpId!public! !
!SUnitBrowser class categoriesFor: #uninitialize!initializing!must strip!private! !

