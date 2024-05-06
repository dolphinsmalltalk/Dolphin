"Filed out from Dolphin Smalltalk"!

SUnitAbsModel subclass: #SUnitBrowserModel
	instanceVariableNames: 'suiteBuilder suite testResult numberOfTests'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

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

!SUnitBrowserModel categoriesForMethods!
areAllTestsCompleted!private!querying! !
basicNumberOfTests!accessing!private! !
buildList!actions!private! !
canAnalyze!public!querying! !
canDebug!public!querying! !
canRemove!public!querying! !
canRun!public!querying! !
caseClass!accessing!private! !
debugIndividualTests:!actions!private! !
debugSelected!actions!public! !
debugTest:!actions!private! !
debugTests:!actions!private! !
individualTests:do:!actions!private! !
initialize!initializing!private! !
inspectSelected!actions!public! !
invalidateNumberOfTests!private!statistics! !
isARootTestCase:!private!querying! !
isOneDebuggableItemSelected!private!querying! !
name!accessing!public! !
numberCorrectFor:!public!statistics! !
numberErrorsFor:!public!statistics! !
numberFailuresFor:!public!statistics! !
numberNotYetRunFor:!public!statistics! !
numberOfTests!public!statistics! !
numberOfTests:!accessing!private! !
numberTestsIn:!public!statistics! !
recalculateNumberOfTests!private!statistics! !
removeListItems:!actions!private! !
resetAllListItems!actions!private! !
resetDefectListItems!actions!public! !
resetListItems!actions!private! !
resourcesFor:!actions!private! !
resultClass!constants!private! !
resultStateString!displaying!public! !
runAll!actions!public! !
runIndividualTests:!actions!private! !
runIndividualTestsWithResources:!actions!private! !
runSelected!actions!public! !
runTest:!actions!private! !
runTests:!actions!private! !
shouldInitializeResources!configuring!public! !
shouldInitializeResources:!configuring!public! !
showAll!configuring!public! !
showAll:!configuring!public! !
showAllColorSymbol!displaying!public! !
showAllLabel!displaying!public! !
showRunningStatusInList!configuring!public! !
showRunningStatusInList:!configuring!public! !
showStatusBackgroundColors!configuring!public! !
showStatusBackgroundColors:!configuring!public! !
signalResetResults:!private!signalling! !
signalResetRunningStatus!private!signalling! !
signalSetRunningStatus:!private!signalling! !
signalToggledShowAll!private!signalling! !
signalToggledShowStatusBackgroundColors!private!signalling! !
signalUpdateTestCaseStatus:withResult:!private!signalling! !
startResources:!actions!private! !
stepSelected!actions!public! !
stopResources:!actions!private! !
suite!accessing!private! !
suite:!accessing!private! !
suiteBuilder!accessing!private! !
suiteBuilder:!accessing!private! !
testCaseSortBlock!actions!private! !
testResult!accessing!private! !
testResult:!accessing!private! !
toggleShouldInitializeResources!configuring!public! !
toggleShowAll!configuring!public! !
toggleShowRunningStatusInList!configuring!public! !
toggleShowStatusBackgroundColors!configuring!public! !
topLevelTests!accessing!private! !
updateListItemsFor:with:!actions!private! !
updateTestCase:result:!actions!private! !
withSelectedItem:!actions!private! !
!

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

!SUnitBrowserModel class categoriesForMethods!
builderClass!constants!public! !
caseClass!constants!public! !
configurationClass!constants!public! !
initializeDefaultConfiguration!initializing!public! !
resultClass!constants!public! !
shouldInitializeResources!configuring!public! !
shouldInitializeResources:!configuring!public! !
showAll!configuring!public! !
showAll:!configuring!public! !
showRunningStatusInList!configuring!public! !
showRunningStatusInList:!configuring!public! !
showStatusBackgroundColors!configuring!public! !
showStatusBackgroundColors:!configuring!public! !
stateClass!constants!public! !
uninitialize!class hierarchy-removing!public! !
!

