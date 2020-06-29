"Filed out from Dolphin Smalltalk 7"!

SUnitAbsModel subclass: #SUnitBrowserModel
	instanceVariableNames: 'suiteBuilder suite testResult numberOfTests'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
SUnitBrowserModel guid: (GUID fromString: '{1069426e-b3a6-4841-bc3e-0468720bf1d1}')!
SUnitBrowserModel comment: ''!
!SUnitBrowserModel categoriesForClass!Unclassified! !
!SUnitBrowserModel methodsFor!

areAllTestsCompleted

	^self testResult runCount = self numberOfTests!

basicNumberOfTests

	^numberOfTests!

buildList

	self listItems: OrderedCollection new.

	self builder isNil
		ifTrue: [self builder: self caseClass].

	self suite: self builder buildSuite.

	self suite isNil
		ifTrue: [^self].

	self testResult clear.

	self
		resetListItems;
		signalResetList!

canAnalyze

	^self isOneDebuggableItemSelected!

canDebug
	#oaModified.
	"	^self isOneDebuggableItemSelected"
	^self hasSelectedItems!

canRemove

	^super canRemove and: [self basicSelectedItems allSatisfy: [:each | self isARootTestCase: each]]!

canRun

	^self hasSelectedItems!

caseClass

	^self class caseClass!

debugIndividualTests: tests 
	#oaAdded.
	self individualTests: tests do: [:each | self debugTest: each]!

debugSelected

	#oaModified.
	self
		signalSetRunningStatus: 'Debugging Selected';
		debugTests: self selectedItems;
		signalResetRunningStatus!

debugTest: aTestCase 
	| aTestResult |
	aTestResult := aTestCase class debugWithResult: aTestCase selector.
	#oaModified.	"Extracted so can use for debug result too."
	self updateTestCase: aTestResult result: aTestCase!

debugTests: tests 
	"tests - a collection of either TestCases or TestSuites"

	#oaAdded.
	self shouldInitializeResources 
		ifTrue: [self debugIndividualTestsWithResources: tests]
		ifFalse: [self debugIndividualTests: tests]!

individualTests: tests do: aMonadicBlock 
	self testResult removeAll: tests.
	self signalResetResults: tests.
	tests do: [:each | each allTests do: aMonadicBlock]!

initialize

	super initialize.
	self testResult: (self resultClass newOn: self)!

inspectSelected

	self withSelectedItem: [:selectedItem | selectedItem inspect]!

invalidateNumberOfTests

	self numberOfTests: nil!

isARootTestCase: aTestCase

	^self topLevelTests includes: aTestCase!

isOneDebuggableItemSelected

	^self isOneItemSelected and: [self selectedItem canDebug]!

name

	^(self suite isNil or: [self suite name isNil])
		ifTrue: ['']
		ifFalse: [self suite name]!

numberCorrectFor: aTest

	^self testResult numberCorrectFor: aTest!

numberErrorsFor: aTest

	^self testResult numberErrorsFor: aTest!

numberFailuresFor: aTest

	^self testResult numberFailuresFor: aTest!

numberNotYetRunFor: aTest

	^self testResult numberNotYetRunFor: aTest!

numberOfTests

	self basicNumberOfTests isNil ifTrue: [self recalculateNumberOfTests].

	^self basicNumberOfTests !

numberOfTests: anObject
	numberOfTests := anObject!

numberTestsIn: aTest
	"count the number of tests in aTest (TestCase or TestSuite)"

	^aTest allTests size!

recalculateNumberOfTests

	self numberOfTests: (
		self topLevelTests
			inject: 0
			into: [:total :each | total + each numberOfTests])!

removeListItems: aCollection

	self topLevelTests sunitbRemoveAll: aCollection.

	aCollection do: [:each | self testResult removeAll: each allTests].

	self invalidateNumberOfTests.

	super removeListItems: aCollection!

resetAllListItems

	self listItems: (self topLevelTests asSortedCollection: self testCaseSortBlock)!

resetDefectListItems

	self listItems: (
		self testResult isNil
			ifTrue: [#()]
			ifFalse: [self testResult defects asSortedCollection: self testCaseSortBlock])!

resetListItems

	self showAll
		ifTrue: [self resetAllListItems]
		ifFalse: [self resetDefectListItems]!

resourcesFor: tests

	| resources |

	resources := Set new.
	tests do: [:each | each allTests do: [:eachTest | resources addAll: eachTest resources]].

	^resources !

resultClass

	^SUnitBrowserResult!

resultStateString

	^self state resultStateString!

runAll

	self testResult clear.
	self 
		resetListItems; 
		signalResetList.
	self
		signalSetRunningStatus: 'Running All';
		runTests: (
			self showAll
				ifTrue: [self listItems]
				ifFalse: [self topLevelTests]);
		signalResetRunningStatus.

	self showRunningStatusInList ifFalse: [self signalResetList]!

runIndividualTests: tests 
	"tests - a collection of either TestCases or TestSuites"

	#oaModified.	"Refactored so can use for debugging too"
	self individualTests: tests do: [:each | self runTest: each]!

runIndividualTestsWithResources: tests
	"tests - a collection of either TestCases or TestSuites"

	| resources |
	resources := self resourcesFor: tests.
	
	[self
		startResources: resources;
		runIndividualTests: tests]
			ensure: [self stopResources: resources]!

runSelected

	self
		signalSetRunningStatus: 'Running Selected';
		runTests: self selectedItems;
		signalResetRunningStatus!

runTest: aTestCase 
	| aTestResult |
	aTestResult := aTestCase class run: aTestCase selector.
	#oaModified.	"Extracted so can use for debug result too."
	self updateTestCase: aTestResult result: aTestCase.
	"Dolphin specific: Pump UI messages to allow display to update between tests"
	SessionManager inputState pumpMessages!

runTests: tests 
	"tests - a collection of either TestCases or TestSuites"

	self shouldInitializeResources 
		ifTrue: [self runIndividualTestsWithResources: tests]
		ifFalse: [self runIndividualTests: tests]!

shouldInitializeResources

	^self configuration shouldInitializeResources!

shouldInitializeResources: aBoolean

	self configuration shouldInitializeResources: aBoolean!

showAll

	^self configuration showAll!

showAll: aBoolean

	self configuration showAll: aBoolean.
	self resetListItems!

showAllColorSymbol

	^self state showAllColorSymbol!

showAllLabel

	^self state showAllLabel!

showRunningStatusInList

	^self configuration showRunningStatusInList!

showRunningStatusInList: aBoolean

	self configuration showRunningStatusInList: aBoolean!

showStatusBackgroundColors

	^self configuration showStatusBackgroundColors!

showStatusBackgroundColors: aBoolean

	self configuration showStatusBackgroundColors: aBoolean!

signalResetResults: results

	self hasBrowser
		ifFalse: [^self].

	self browser callbackResetResults: results!

signalResetRunningStatus

	self hasBrowser
		ifFalse: [^self].

	self browser callbackResetRunningStatus!

signalSetRunningStatus: aString

	self hasBrowser
		ifFalse: [^self].

	self browser callbackSetRunningStatus: aString!

signalToggledShowAll

	self hasBrowser
		ifFalse: [^self].

	self browser callbackToggledShowAll!

signalToggledShowStatusBackgroundColors

	self hasBrowser
		ifFalse: [^self].

	self browser callbackToggledShowStatusBackgroundColors!

signalUpdateTestCaseStatus: aTestCase withResult: aTestResult

	self hasBrowser
		ifFalse: [^self].

	self browser
		callbackUpdateTestCaseStatus: aTestCase
		withResult: aTestResult!

startResources: resources

	resources do: [:each | 
		each reset.
		each isAvailable 
			ifFalse: [TestResult signalErrorWith: 'Resource ' , each name , ' could not be initialized']]!

stepSelected

	self withSelectedItem: [:selectedItem |
		[
			self signalSetRunningStatus: 'Stepping'.
			selectedItem step]
				ensure: [self signalResetRunningStatus]]!

stopResources: resources

	resources do: [:each | each reset]!

suite

	^suite!

suite: aTestSuite

	suite := aTestSuite.
	self invalidateNumberOfTests!

suiteBuilder
	"anything that answers selector #buildSuite"

	^suiteBuilder!

suiteBuilder: aTestSuiteBuilder
	"anything that answers selector #suite"

	suiteBuilder := aTestSuiteBuilder!

testCaseSortBlock

	^self nameSortBlock!

testResult

	^testResult!

testResult: aTestResult

	testResult := aTestResult!

toggleShouldInitializeResources

	self configuration toggleShouldInitializeResources!

toggleShowAll

	self configuration toggleShowAll.
	self
		resetListItems;
		signalResetList;
		signalToggledShowAll!

toggleShowRunningStatusInList

	self configuration toggleShowRunningStatusInList!

toggleShowStatusBackgroundColors

	self configuration toggleShowStatusBackgroundColors.
	self signalToggledShowStatusBackgroundColors!

topLevelTests
	"top level tests in suite"

	^self suite tests!

updateListItemsFor: aTestCase with: aTestResult

	| foundInListItems |

	self showAll 
		ifTrue: [^self].

	foundInListItems := self listItems includes: aTestCase.

	aTestResult hasPassed
		ifTrue: [ 
			foundInListItems ifTrue: [
				self listItems remove: aTestCase]]
		ifFalse: [
			foundInListItems ifFalse: [
				self listItems add: aTestCase]]!

updateTestCase: aTestResult result: aTestCase 
	self updateListItemsFor: aTestCase with: aTestResult.
	self testResult merge: aTestResult for: aTestCase.
	self signalUpdateTestCaseStatus: aTestCase withResult: aTestResult!

withSelectedItem: aSingleArgumentBlock

	| selectedItem |

	selectedItem := self selectedItem.
	selectedItem isNil
		ifTrue: [^self].

	aSingleArgumentBlock value: selectedItem! !
!SUnitBrowserModel categoriesFor: #areAllTestsCompleted!private!querying! !
!SUnitBrowserModel categoriesFor: #basicNumberOfTests!accessing!private! !
!SUnitBrowserModel categoriesFor: #buildList!actions!private! !
!SUnitBrowserModel categoriesFor: #canAnalyze!public!querying! !
!SUnitBrowserModel categoriesFor: #canDebug!public!querying! !
!SUnitBrowserModel categoriesFor: #canRemove!public!querying! !
!SUnitBrowserModel categoriesFor: #canRun!public!querying! !
!SUnitBrowserModel categoriesFor: #caseClass!accessing!private! !
!SUnitBrowserModel categoriesFor: #debugIndividualTests:!actions!private! !
!SUnitBrowserModel categoriesFor: #debugSelected!actions!public! !
!SUnitBrowserModel categoriesFor: #debugTest:!actions!private! !
!SUnitBrowserModel categoriesFor: #debugTests:!actions!private! !
!SUnitBrowserModel categoriesFor: #individualTests:do:!actions!private! !
!SUnitBrowserModel categoriesFor: #initialize!initializing!private! !
!SUnitBrowserModel categoriesFor: #inspectSelected!actions!public! !
!SUnitBrowserModel categoriesFor: #invalidateNumberOfTests!private!statistics! !
!SUnitBrowserModel categoriesFor: #isARootTestCase:!private!querying! !
!SUnitBrowserModel categoriesFor: #isOneDebuggableItemSelected!private!querying! !
!SUnitBrowserModel categoriesFor: #name!accessing!public! !
!SUnitBrowserModel categoriesFor: #numberCorrectFor:!public!statistics! !
!SUnitBrowserModel categoriesFor: #numberErrorsFor:!public!statistics! !
!SUnitBrowserModel categoriesFor: #numberFailuresFor:!public!statistics! !
!SUnitBrowserModel categoriesFor: #numberNotYetRunFor:!public!statistics! !
!SUnitBrowserModel categoriesFor: #numberOfTests!public!statistics! !
!SUnitBrowserModel categoriesFor: #numberOfTests:!accessing!private! !
!SUnitBrowserModel categoriesFor: #numberTestsIn:!public!statistics! !
!SUnitBrowserModel categoriesFor: #recalculateNumberOfTests!private!statistics! !
!SUnitBrowserModel categoriesFor: #removeListItems:!actions!private! !
!SUnitBrowserModel categoriesFor: #resetAllListItems!actions!private! !
!SUnitBrowserModel categoriesFor: #resetDefectListItems!actions!public! !
!SUnitBrowserModel categoriesFor: #resetListItems!actions!private! !
!SUnitBrowserModel categoriesFor: #resourcesFor:!actions!private! !
!SUnitBrowserModel categoriesFor: #resultClass!constants!private! !
!SUnitBrowserModel categoriesFor: #resultStateString!displaying!public! !
!SUnitBrowserModel categoriesFor: #runAll!actions!public! !
!SUnitBrowserModel categoriesFor: #runIndividualTests:!actions!private! !
!SUnitBrowserModel categoriesFor: #runIndividualTestsWithResources:!actions!private! !
!SUnitBrowserModel categoriesFor: #runSelected!actions!public! !
!SUnitBrowserModel categoriesFor: #runTest:!actions!private! !
!SUnitBrowserModel categoriesFor: #runTests:!actions!private! !
!SUnitBrowserModel categoriesFor: #shouldInitializeResources!configuring!public! !
!SUnitBrowserModel categoriesFor: #shouldInitializeResources:!configuring!public! !
!SUnitBrowserModel categoriesFor: #showAll!configuring!public! !
!SUnitBrowserModel categoriesFor: #showAll:!configuring!public! !
!SUnitBrowserModel categoriesFor: #showAllColorSymbol!displaying!public! !
!SUnitBrowserModel categoriesFor: #showAllLabel!displaying!public! !
!SUnitBrowserModel categoriesFor: #showRunningStatusInList!configuring!public! !
!SUnitBrowserModel categoriesFor: #showRunningStatusInList:!configuring!public! !
!SUnitBrowserModel categoriesFor: #showStatusBackgroundColors!configuring!public! !
!SUnitBrowserModel categoriesFor: #showStatusBackgroundColors:!configuring!public! !
!SUnitBrowserModel categoriesFor: #signalResetResults:!private!signalling! !
!SUnitBrowserModel categoriesFor: #signalResetRunningStatus!private!signalling! !
!SUnitBrowserModel categoriesFor: #signalSetRunningStatus:!private!signalling! !
!SUnitBrowserModel categoriesFor: #signalToggledShowAll!private!signalling! !
!SUnitBrowserModel categoriesFor: #signalToggledShowStatusBackgroundColors!private!signalling! !
!SUnitBrowserModel categoriesFor: #signalUpdateTestCaseStatus:withResult:!private!signalling! !
!SUnitBrowserModel categoriesFor: #startResources:!actions!private! !
!SUnitBrowserModel categoriesFor: #stepSelected!actions!public! !
!SUnitBrowserModel categoriesFor: #stopResources:!actions!private! !
!SUnitBrowserModel categoriesFor: #suite!accessing!private! !
!SUnitBrowserModel categoriesFor: #suite:!accessing!private! !
!SUnitBrowserModel categoriesFor: #suiteBuilder!accessing!private! !
!SUnitBrowserModel categoriesFor: #suiteBuilder:!accessing!private! !
!SUnitBrowserModel categoriesFor: #testCaseSortBlock!actions!private! !
!SUnitBrowserModel categoriesFor: #testResult!accessing!private! !
!SUnitBrowserModel categoriesFor: #testResult:!accessing!private! !
!SUnitBrowserModel categoriesFor: #toggleShouldInitializeResources!configuring!public! !
!SUnitBrowserModel categoriesFor: #toggleShowAll!configuring!public! !
!SUnitBrowserModel categoriesFor: #toggleShowRunningStatusInList!configuring!public! !
!SUnitBrowserModel categoriesFor: #toggleShowStatusBackgroundColors!configuring!public! !
!SUnitBrowserModel categoriesFor: #topLevelTests!accessing!private! !
!SUnitBrowserModel categoriesFor: #updateListItemsFor:with:!actions!private! !
!SUnitBrowserModel categoriesFor: #updateTestCase:result:!actions!private! !
!SUnitBrowserModel categoriesFor: #withSelectedItem:!actions!private! !

!SUnitBrowserModel class methodsFor!

builderClass

	^self caseClass!

caseClass

	^TestCase!

configurationClass

	^SUnitBrowserConfig!

initializeDefaultConfiguration

	super initializeDefaultConfiguration.

	self defaultConfiguration
		showAll: true;
		showStatusBackgroundColors: true;
		shouldInitializeResources: false;
		showRunningStatusInList: true!

resultClass

	^TestResult!

shouldInitializeResources

	^self defaultConfiguration shouldInitializeResources!

shouldInitializeResources: aBoolean

	self defaultConfiguration shouldInitializeResources: aBoolean!

showAll

	^self defaultConfiguration showAll!

showAll: aBoolean

	self defaultConfiguration showAll: aBoolean!

showRunningStatusInList

	^self defaultConfiguration showRunningStatusInList!

showRunningStatusInList: aBoolean

	self defaultConfiguration showRunningStatusInList: aBoolean!

showStatusBackgroundColors

	^self defaultConfiguration showStatusBackgroundColors!

showStatusBackgroundColors: aBoolean

	self defaultConfiguration showStatusBackgroundColors: aBoolean!

stateClass

	^SUnitBrowserUIState!

uninitialize
	defaultConfiguration := nil! !
!SUnitBrowserModel class categoriesFor: #builderClass!constants!public! !
!SUnitBrowserModel class categoriesFor: #caseClass!constants!public! !
!SUnitBrowserModel class categoriesFor: #configurationClass!constants!public! !
!SUnitBrowserModel class categoriesFor: #initializeDefaultConfiguration!initializing!public! !
!SUnitBrowserModel class categoriesFor: #resultClass!constants!public! !
!SUnitBrowserModel class categoriesFor: #shouldInitializeResources!configuring!public! !
!SUnitBrowserModel class categoriesFor: #shouldInitializeResources:!configuring!public! !
!SUnitBrowserModel class categoriesFor: #showAll!configuring!public! !
!SUnitBrowserModel class categoriesFor: #showAll:!configuring!public! !
!SUnitBrowserModel class categoriesFor: #showRunningStatusInList!configuring!public! !
!SUnitBrowserModel class categoriesFor: #showRunningStatusInList:!configuring!public! !
!SUnitBrowserModel class categoriesFor: #showStatusBackgroundColors!configuring!public! !
!SUnitBrowserModel class categoriesFor: #showStatusBackgroundColors:!configuring!public! !
!SUnitBrowserModel class categoriesFor: #stateClass!constants!public! !
!SUnitBrowserModel class categoriesFor: #uninitialize!class hierarchy-removing!public! !

