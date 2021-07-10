"Filed out from Dolphin Smalltalk"!

SUnitAbsModel subclass: #SUnitResourceBrowserModel
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SUnitResourceBrowserModel guid: (GUID fromString: '{2342a0cf-f99b-4f61-a061-56dbee09429a}')!
SUnitResourceBrowserModel comment: ''!
!SUnitResourceBrowserModel categoriesForClass!Unclassified! !
!SUnitResourceBrowserModel methodsFor!

availableCount

	^self availableResources size!

availableResources

	^self listItems select: [:each | each isAvailable]!

availableSelectedResources

	^self basicSelectedItems select: [:each | each isAvailable]!

buildList

	| resourceList |

	self builder isNil
		ifTrue: [self builder: self caseClass].

	resourceList := self buildResourcesOn: self builder.

	self
		listItems: (resourceList asSortedCollection: self testResourceSortBlock);
		signalResetList!

buildResourcesOn: aTestResourceClass

	| resources |

	resources := Bag new.

	aTestResourceClass withAllSubclasses do: [:each |
		each isAbstract
			ifFalse: [resources add: each current]].

	^resources!

canStart

	^self hasUnavailableSelectedResources!

canStartAll

	^self hasUnavailableResources!

canStop

	^self hasAvailableSelectedResources!

canStopAll

	^self hasAvailableResources!

hasAvailableResources

	^self availableResources notEmpty!

hasAvailableSelectedResources

	^self availableSelectedResources notEmpty!

hasUnavailableResources

	^self unavailableResources notEmpty!

hasUnavailableSelectedResources

	^self unavailableSelectedResources notEmpty!

signalStartedTestResource: aTestResource

	self hasBrowser
		ifFalse: [^self].

	self browser callbackStartedTestResource: aTestResource!

signalStoppedTestResource: aTestResource

	self hasBrowser
		ifFalse: [^self].

	self browser callbackStoppedTestResource: aTestResource!

startAll

	self startResources: self listItems!

startResource: aTestResource

	aTestResource setUp.
	self signalStartedTestResource: aTestResource!

startResources: testResources

	testResources do: [:each | self startResource: each]!

startSelected

	self startResources: self selectedItems!

stopAll

	self stopResources: self listItems!

stopResource: aTestResource

	aTestResource isAvailable
		ifFalse: [^self].

	aTestResource tearDown.
	self signalStoppedTestResource: aTestResource!

stopResources: testResources

	testResources do: [:each | self stopResource: each]!

stopSelected

	self stopResources: self selectedItems!

testResourceSortBlock

	^self nameSortBlock!

unavailableCount

	^self unavailableResources size!

unavailableResources

	^self listItems select: [:each | each isUnavailable]!

unavailableSelectedResources

	^self basicSelectedItems select: [:each | each isUnavailable]! !
!SUnitResourceBrowserModel categoriesForMethods!
availableCount!accessing!private! !
availableResources!accessing!private! !
availableSelectedResources!accessing!private! !
buildList!actions!public! !
buildResourcesOn:!actions!private! !
canStart!public!querying! !
canStartAll!public!querying! !
canStop!public!querying! !
canStopAll!public!querying! !
hasAvailableResources!private!querying! !
hasAvailableSelectedResources!private!querying! !
hasUnavailableResources!private!querying! !
hasUnavailableSelectedResources!private!querying! !
signalStartedTestResource:!private!signalling! !
signalStoppedTestResource:!private!signalling! !
startAll!actions!public! !
startResource:!actions!private! !
startResources:!actions!private! !
startSelected!actions!public! !
stopAll!actions!public! !
stopResource:!actions!private! !
stopResources:!actions!private! !
stopSelected!actions!public! !
testResourceSortBlock!actions!private! !
unavailableCount!accessing!private! !
unavailableResources!accessing!private! !
unavailableSelectedResources!accessing!private! !
!

!SUnitResourceBrowserModel class methodsFor!

builderClass

	^self resourceClass!

configurationClass

	^SUnitResourceBrowserConfig!

resourceClass

	^TestResource!

stateClass

	^SUnitResourceBrowserUIState!

uninitialize
	defaultConfiguration := nil! !
!SUnitResourceBrowserModel class categoriesForMethods!
builderClass!constants!public! !
configurationClass!constants!public! !
resourceClass!constants!public! !
stateClass!constants!public! !
uninitialize!class hierarchy-removing!public! !
!

