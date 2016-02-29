"Filed out from Dolphin Smalltalk 7"!

SUnitAbsBrowser subclass: #SUnitBrowser
	instanceVariableNames: 'testCaseListModel showAllTextPresenter testCaseListPresenter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SUnitBrowser guid: (GUID fromString: '{FC3AA1DE-E128-4ADE-A04C-035EBDA3B5C2}')!
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
!SUnitBrowser categoriesFor: #updateListStateFor:with:!*-unreferenced selectors!model callbacks!private! !
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

displayOn: aStream
	"Append, to aStream, a String whose characters are a representation of the receiver as a user
	would want to see it."

	aStream nextPutAll: 'SUnit Browser'!

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

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy) 8 ##(Smalltalk.ShellView) 98 27 0 0 98 2 27131905 131073 416 0 524550 ##(Smalltalk.ColorRef) 8 4278190080 0 551 0 0 0 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 8 ##(Smalltalk.Toolbar) 98 25 0 416 98 2 8 1140851524 131073 560 0 482 8 4278190080 0 519 0 263174 ##(Smalltalk.Font) 0 16 459014 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 159 4 28 198 63 1 0 0 204 53 63 1 3 0 20 59 0 0 0 0 247 0 5 86 111 1] 328198 ##(Smalltalk.Point) 193 193 0 560 482 656 8 4294903529 234 256 98 6 410 8 ##(Smalltalk.ReferenceView) 98 14 0 560 98 2 8 1140850688 131073 848 0 0 0 7 0 0 0 848 1180166 ##(Smalltalk.ResourceIdentifier) 8 ##(Smalltalk.SUnitToolbar) 8 #resource_Default_view 0 983302 ##(Smalltalk.MessageSequence) 202 208 98 1 721670 ##(Smalltalk.MessageSend) 8 #createAt:extent: 98 2 754 1 51 754 387 51 848 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 193 0 0 0 50 0 0 0] 98 0 754 193 193 0 27 8 'sunitBrowserTools' 410 864 98 14 0 560 98 2 8 1140850688 131073 1248 0 0 0 7 0 0 0 1248 930 576 8 #resource_Image_tools 0 994 202 208 98 1 1058 1088 98 2 754 1 1 754 63 51 1248 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 1200 1216 0 27 8 'imageTools' 410 864 98 14 0 560 98 2 8 1140850688 131073 1504 0 0 0 7 0 0 0 1504 930 576 8 #resource_Smalltalk_tools 0 994 202 208 98 1 1058 1088 98 2 754 63 1 754 991 51 1504 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 14 2 0 0 25 0 0 0] 1200 1216 0 27 8 'smalltalkTools' 234 256 1200 202 208 1200 234 240 1200 0 1 0 754 33 33 754 45 45 0 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 994 202 208 98 2 1058 1088 98 2 754 1 1 754 1169 101 560 1058 8 #updateSizePosted 1200 560 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 50 0 0 0] 98 3 1248 1504 848 1216 0 27 410 8 ##(Smalltalk.StatusBar) 98 18 0 416 98 2 8 1140850956 1 2064 0 721158 ##(Smalltalk.SystemColor) 31 0 7 0 0 0 2064 0 8 4294905391 234 256 98 4 853766 ##(Smalltalk.StatusBarItem) 1 -1 2064 0 787814 3 ##(Smalltalk.BlockClosure) 0 0 1180966 ##(Smalltalk.CompiledExpression) 2 1 8 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:wrapper | wrapper text]' 8 #[30 105 17 158 106] 8 #text 2272 7 257 0 8 ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) 8 'status' 2226 1 71 2064 0 8 ##(Smalltalk.BasicListAbstract) 0 2432 8 'showAll' 98 2 2464 2240 1115142 ##(Smalltalk.StatusBarNullItem) 513 1 2064 0 0 994 202 208 98 1 1058 1088 98 2 754 1 643 754 1169 41 2064 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 65 1 0 0 72 2 0 0 85 1 0 0] 98 0 1216 0 27 0 0 410 8 ##(Smalltalk.ContainerView) 98 15 0 416 98 2 8 1140850688 131073 2720 0 482 8 4278190080 0 7 0 0 0 2720 530 1 1 410 8 ##(Smalltalk.StaticText) 98 16 0 2720 98 2 8 1140850945 1 2848 0 2146 31 0 7 0 0 0 2848 196934 1 ##(Smalltalk.RGB) 1 8 4294908187 852486 ##(Smalltalk.NullConverter) 0 0 0 994 202 208 98 1 1058 1088 98 2 754 1 1 754 1169 39 2848 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 19 0 0 0] 98 0 1216 0 27 0 0 0 410 2736 98 15 0 2720 98 2 8 1140850688 131073 3184 0 482 512 0 7 0 0 0 3184 1180166 ##(Smalltalk.ProportionalLayout) 234 240 98 4 410 8 ##(Smalltalk.ListView) 98 30 0 3184 98 2 8 1140920393 1 3328 590662 2 ##(Smalltalk.ListModel) 202 208 1200 0 1310726 ##(Smalltalk.IdentitySearchPolicy) 2946 33554431 0 7 265030 4 ##(Smalltalk.Menu) 0 16 98 20 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) 8 #runAll 8 'Run &All' 1 1 0 0 0 3554 1 3586 8 #runSelected 8 '&Run Selected' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem) 4097 3554 1 3586 8 #debug 8 '&Debug' 1 1 0 0 0 3554 1 3586 8 #step 8 '&Step' 1 1 0 0 0 3714 4097 3554 1 3586 8 #inspectSelected 8 '&Inspect' 1 1 0 0 0 3714 4097 3554 1 3586 8 #delete 8 'Delete' 1 1 0 0 0 3714 4097 3554 1 3586 8 #reset 8 'Reset' 1 1 0 0 0 3714 4097 3554 1 3586 8 #sbBrowseHierarchy 8 'Browse &Hierarchy' 1 1 0 0 0 3554 1 3586 8 #sbBrowseResources 8 'Browse Resources' 1 1 0 0 0 3714 4097 3554 1 3586 8 #showAll 8 'Show All Results' 1 1 0 0 0 3554 1 3586 8 #showRunningStatusInList 8 'Show Running Status In List' 1 1 0 0 0 3554 1 3586 8 #showStatusPaneBackgroundColors 8 'Show Status Pane Background Colors' 1 1 0 0 0 3554 1 3586 8 #useDisplayNames 8 'Use Display Names' 1 1 0 0 0 3554 1 3586 8 #shouldInitializeResources 8 'Auto-Initialize Resources' 1 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 0 3328 0 8 4294909021 2480 2400 2432 0 0 0 754 65 65 0 0 202 208 98 6 920646 5 ##(Smalltalk.ListViewColumn) 8 'Suite' 91 8 #left 2480 8 ##(Smalltalk.SortedCollection) 2258 0 0 2290 2 1 2320 8 'doIt' 8 '[:suite | suite name]' 8 #[30 105 17 158 106] 8 #name 4752 7 257 0 0 3328 2258 0 0 2290 1 83886081 2320 8 'doIt' 8 '[:x|nil]' 8 #[29 105 60 106] 4848 7 257 0 3 0 0 4674 8 'Correct' 155 8 #right 2480 4736 2258 0 0 2290 2 1 2320 8 'doIt' 8 '[:test | test numberCorrect]' 8 #[30 105 17 158 106] 8 #numberCorrect 4976 7 257 0 0 3328 0 1 0 0 4674 8 'Failures' 155 4960 2480 4736 2258 0 0 2290 2 1 2320 8 'doIt' 8 '[:test | test numberFailures]' 8 #[30 105 17 158 106] 8 #numberFailures 5104 7 257 0 0 3328 0 1 0 0 4674 8 'Errors' 155 4960 2480 4736 2258 0 0 2290 2 1 2320 8 'doIt' 8 '[:test | test numberErrors]' 8 #[30 105 17 158 106] 8 #numberErrors 5232 7 257 0 0 3328 0 1 0 0 4674 8 'Not Run' 155 4960 2480 4736 2258 0 0 2290 2 1 2320 8 'doIt' 8 '[:test | test numberNotYetRun]' 8 #[30 105 17 158 106] 8 #numberNotYetRun 5360 7 257 0 0 3328 0 1 0 0 4674 8 'Total' 155 4960 2480 4736 2258 0 0 2290 2 1 2320 8 'doIt' 8 '[:test | test numberTests]' 8 #[30 105 17 158 106] 8 #numberTests 5488 7 257 0 0 3328 0 1 0 0 8 #report 1200 0 133217 0 98 1 0 994 202 208 98 3 1058 1088 98 2 754 1 1 754 869 505 3328 1058 8 #contextMenu: 98 1 3520 3328 1058 8 #text: 98 1 8 'Suite' 3328 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 178 1 0 0 252 0 0 0] 98 0 1216 0 27 7 410 3344 98 30 0 3184 98 2 8 1140920393 1 5888 3410 202 208 1200 0 3472 2946 33554431 0 7 3506 0 16 98 17 3554 1 3586 3680 8 '&Run Selected' 1 1 0 0 0 3714 4097 3554 1 3586 3776 8 '&Debug' 1 1 0 0 0 3554 1 3586 3840 8 '&Step' 1 1 0 0 0 3714 4097 3554 1 3586 3920 8 '&Inspect' 1 1 0 0 0 3714 4097 3554 1 3586 4000 8 'Delete' 1 1 0 0 0 3714 4097 3554 1 3586 4080 8 'Reset' 1 1 0 0 0 3714 4097 3554 1 3586 4160 8 'Browse &Hierarchy' 1 1 0 0 0 3554 1 3586 4224 8 'Browse Resources' 1 1 0 0 0 3714 4097 3554 1 3586 4304 8 'Show All Results' 1 1 0 0 0 3554 1 3586 4432 8 'Show Status &Pane Background Colors' 1 1 0 0 0 3554 1 3586 4496 8 'Use Display Names' 1 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 0 5888 0 8 4294909021 2480 2400 2432 0 0 0 754 65 65 0 0 202 208 98 1 4674 8 'Test Case' 283 4720 2480 4736 2258 0 0 2290 2 1 2320 8 'doIt' 8 '[:testCase | testCase name]' 8 #[30 105 17 158 106] 4832 6768 7 257 0 0 5888 2258 0 0 2290 1 83886081 2320 8 'doIt' 8 '[:x|nil]' 8 #[29 105 60 106] 6848 7 257 0 3 0 0 5584 1200 0 133217 0 98 1 0 994 202 208 98 3 1058 1088 98 2 754 879 1 754 291 505 5888 1058 5744 98 1 6000 5888 1058 5792 98 1 8 'Test Case' 5888 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 183 1 0 0 0 0 0 0 72 2 0 0 252 0 0 0] 98 0 1216 0 27 3 32 234 256 98 4 3328 8 'list' 5888 8 'testCaseList' 0 994 202 208 98 1 1058 1088 98 2 754 1 39 754 1169 505 3184 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 19 0 0 0 72 2 0 0 15 1 0 0] 98 3 3328 410 8 ##(Smalltalk.Splitter) 98 12 0 3184 98 2 8 1140850688 1 7408 0 482 512 0 519 0 0 0 7408 994 202 208 98 1 1058 1088 98 2 754 869 1 754 11 505 7408 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 178 1 0 0 0 0 0 0 183 1 0 0 252 0 0 0] 98 0 1216 0 27 5888 1216 0 27 234 256 98 2 2848 8 'label' 0 994 202 208 98 1 1058 1088 98 2 754 1 101 754 1169 543 2720 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 50 0 0 0 72 2 0 0 65 1 0 0] 98 2 2848 3184 1216 0 27 234 256 98 2 560 8 'toolbar' 0 461638 4 ##(Smalltalk.MenuBar) 0 16 98 6 3506 0 16 98 1 3554 1 3586 8 #exit 8 '&Exit' 1 1 0 0 0 8 '&File' 0 1 0 0 47713 0 0 3506 0 16 98 3 3554 1 3586 4160 8 'Browse &Hierarchy' 1 1 0 0 0 3714 4097 3554 1 3586 4224 8 'Browse &Resources' 1 1 0 0 0 8 '&Browse' 0 1 0 0 47719 0 0 3506 0 16 98 12 3554 1 3586 3616 8 'Run &All' 1 1 0 0 0 3554 1 3586 3680 8 '&Run Selected' 1 1 0 0 0 3554 1 3586 8 #profileSelected 8 '&Profile' 1 1 0 0 0 3714 4097 3554 1 3586 3776 8 '&Debug' 1 1 0 0 0 3554 1 3586 3840 8 '&Step' 1 1 0 0 0 3714 4097 3554 1 3586 3920 8 '&Inspect' 1 1 0 0 0 3714 4097 3554 1 3586 4000 8 'Delete' 1 1 0 0 0 3714 4097 3554 1 3586 4080 8 'Reset' 1 1 0 0 0 8 'T&est' 0 1 0 0 47737 0 0 3506 0 16 98 5 3554 1 3586 4304 8 'Show &All Results' 1 1 0 0 0 3554 1 3586 4368 8 'Show Running Status In List' 1 1 0 0 0 3554 1 3586 4432 8 'Show Status &Pane Background Colors' 1 1 0 0 0 3554 1 3586 4496 8 'Use Display Names' 1 1 0 0 0 3554 1 3586 4560 8 'Auto-Initialize Resources' 1 1 0 0 0 8 '&Configuration' 0 1 0 0 47749 0 0 3506 0 16 98 0 8 '&Tools' 8 #toolsMenu 1 0 0 47751 0 0 3506 0 16 98 15 3554 1 3586 8 #helpContents 8 '&Contents' 1025 1 263494 3 ##(Smalltalk.Icon) 0 16 1572870 ##(Smalltalk.ImageRelativeFileLocator) 49 786694 ##(Smalltalk.ShellLibrary) 0 0 3554 1 3586 8 #help 8 'On this &Tool' 1249 1 0 0 0 3554 1 3586 8 #helpWhatsThis 8 'What''s This?' 5345 1 0 0 0 3714 4097 3554 1 3586 8 #learnSmalltalk 8 'Learn Smalltalk' 1 1 0 0 0 3714 4097 3554 1 3586 8 #helpWhatsNew 8 'What''s &New' 1 1 0 0 0 3554 1 3586 8 #helpGuidedTour 8 '&Guided Tour' 1 1 0 0 0 3554 1 3586 8 #helpTutorials 8 'Tutorials' 1 1 0 0 0 3714 4097 3554 1 3586 8 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 0 0 0 3554 1 3586 8 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 0 0 0 3554 1 3586 8 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 0 0 0 3714 4097 3554 1 3586 8 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 9202 0 16 9248 8 '!!APPLICATION' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' 0 0 0 8 '&Help' 0 134217729 0 0 47775 0 0 8 '' 0 1 0 0 0 0 0 0 0 0 1 0 0 0 0 1 0 0 994 202 208 98 3 1058 1088 98 2 754 3839 21 754 1201 801 416 1058 5792 98 1 8 'SUnit Browser' 416 1058 8 #updateMenuBar 1200 416 1154 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 215 9 0 0 154 1 0 0] 98 3 560 2720 2064 1216 0 27 )!

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

