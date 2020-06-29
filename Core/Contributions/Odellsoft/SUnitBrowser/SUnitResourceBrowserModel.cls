"Filed out from Dolphin Smalltalk 7"!

SUnitAbsModel subclass: #SUnitResourceBrowserModel
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
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
!SUnitResourceBrowserModel categoriesFor: #availableCount!accessing!private! !
!SUnitResourceBrowserModel categoriesFor: #availableResources!accessing!private! !
!SUnitResourceBrowserModel categoriesFor: #availableSelectedResources!accessing!private! !
!SUnitResourceBrowserModel categoriesFor: #buildList!actions!public! !
!SUnitResourceBrowserModel categoriesFor: #buildResourcesOn:!actions!private! !
!SUnitResourceBrowserModel categoriesFor: #canStart!public!querying! !
!SUnitResourceBrowserModel categoriesFor: #canStartAll!public!querying! !
!SUnitResourceBrowserModel categoriesFor: #canStop!public!querying! !
!SUnitResourceBrowserModel categoriesFor: #canStopAll!public!querying! !
!SUnitResourceBrowserModel categoriesFor: #hasAvailableResources!private!querying! !
!SUnitResourceBrowserModel categoriesFor: #hasAvailableSelectedResources!private!querying! !
!SUnitResourceBrowserModel categoriesFor: #hasUnavailableResources!private!querying! !
!SUnitResourceBrowserModel categoriesFor: #hasUnavailableSelectedResources!private!querying! !
!SUnitResourceBrowserModel categoriesFor: #signalStartedTestResource:!private!signalling! !
!SUnitResourceBrowserModel categoriesFor: #signalStoppedTestResource:!private!signalling! !
!SUnitResourceBrowserModel categoriesFor: #startAll!actions!public! !
!SUnitResourceBrowserModel categoriesFor: #startResource:!actions!private! !
!SUnitResourceBrowserModel categoriesFor: #startResources:!actions!private! !
!SUnitResourceBrowserModel categoriesFor: #startSelected!actions!public! !
!SUnitResourceBrowserModel categoriesFor: #stopAll!actions!public! !
!SUnitResourceBrowserModel categoriesFor: #stopResource:!actions!private! !
!SUnitResourceBrowserModel categoriesFor: #stopResources:!actions!private! !
!SUnitResourceBrowserModel categoriesFor: #stopSelected!actions!public! !
!SUnitResourceBrowserModel categoriesFor: #testResourceSortBlock!actions!private! !
!SUnitResourceBrowserModel categoriesFor: #unavailableCount!accessing!private! !
!SUnitResourceBrowserModel categoriesFor: #unavailableResources!accessing!private! !
!SUnitResourceBrowserModel categoriesFor: #unavailableSelectedResources!accessing!private! !

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
!SUnitResourceBrowserModel class categoriesFor: #builderClass!constants!public! !
!SUnitResourceBrowserModel class categoriesFor: #configurationClass!constants!public! !
!SUnitResourceBrowserModel class categoriesFor: #resourceClass!constants!public! !
!SUnitResourceBrowserModel class categoriesFor: #stateClass!constants!public! !
!SUnitResourceBrowserModel class categoriesFor: #uninitialize!class hierarchy-removing!public! !

