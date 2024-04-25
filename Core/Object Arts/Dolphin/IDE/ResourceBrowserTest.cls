"Filed out from Dolphin Smalltalk"!

DolphinTest subclass: #ResourceBrowserTest
	instanceVariableNames: 'resourceBrowser testClass'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ResourceBrowserTest guid: (GUID fromString: '{8d888ba2-f5b7-402c-9bff-e88b2cde2fab}')!

ResourceBrowserTest comment: ''!

!ResourceBrowserTest categoriesForClass!Unclassified! !

!ResourceBrowserTest methodsFor!

getShellResource
	^(ResourceIdentifier class: Shell) resource!

resourceBrowser
	^resourceBrowser!

resourceDisplayList
	^self resourceToolboxPresenter resourcesPresenter list!

resourceList
	^self resourceToolboxPresenter list!

resourceToolboxPresenter
	^self resourceBrowser resourceToolboxPresenter!

setUp
	super setUp.
	resourceBrowser := ResourceBrowser show.
	testClass := self class 
				subclass: #ResourceBrowserTestSampleClass
				instanceVariableNames: ''
				classVariableNames: ''
				poolDictionaries: ''
				classInstanceVariableNames: ''!

tearDown
	resourceBrowser
		ifNotNil: 
			[resourceBrowser destroy.
			resourceBrowser := nil].
	testClass removeFromSystem.
	super tearDown!

testAddRemoveResource
	| sampleResourceId |
	
	[sampleResourceId := ResourceIdentifier class: testClass.
	self resourceBrowser selectCategory: 'Misc'.
	self deny: (self resourceList includes: sampleResourceId).
	self deny: (self resourceDisplayList includes: sampleResourceId).
	sampleResourceId assign: self getShellResource.
	self assert: (self resourceList includes: sampleResourceId).
	self assert: (self resourceDisplayList includes: sampleResourceId).
	testClass class removeSelector: sampleResourceId selector.
	self deny: (self resourceList includes: sampleResourceId).
	self deny: (self resourceDisplayList includes: sampleResourceId)] 
			ensure: [testClass class removeSelector: sampleResourceId selector ifAbsent: []]!

testBasicContents
	self assert: self resourceList notEmpty.
	self assert: self resourceList first isKindOf: ResourceIdentifier.
	self assert: self resourceList size > 100.
	self assert: (self resourceList includes: (ResourceIdentifier class: Shell)).
	self assert: (self resourceList includes: (ResourceIdentifier class: SystemBrowserShell))! !

!ResourceBrowserTest categoriesForMethods!
getShellResource!private!unit tests! !
resourceBrowser!private!unit tests! !
resourceDisplayList!private!unit tests! !
resourceList!private!unit tests! !
resourceToolboxPresenter!private!unit tests! !
setUp!private!unit tests! !
tearDown!private!unit tests! !
testAddRemoveResource!public!unit tests! !
testBasicContents!public!unit tests! !
!

