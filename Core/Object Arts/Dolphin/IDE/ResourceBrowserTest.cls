"Filed out from Dolphin Smalltalk"!

PresenterTest subclass: #ResourceBrowserTest
	instanceVariableNames: 'testClass'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ResourceBrowserTest guid: (GUID fromString: '{8d888ba2-f5b7-402c-9bff-e88b2cde2fab}')!

ResourceBrowserTest comment: ''!

!ResourceBrowserTest categoriesForClass!Unclassified! !

!ResourceBrowserTest methodsFor!

classToTest
	^ResourceBrowser!

getShellResource
	^(ResourceIdentifier class: Shell) resource!

resourceBrowser
	^presenter!

resourceDisplayList
	^self resourceToolboxPresenter resourcesPresenter list!

resourceList
	^self resourceToolboxPresenter list!

resourceToolboxPresenter
	^self resourceBrowser resourceToolboxPresenter!

tearDown
	testClass ifNotNil: [testClass removeFromSystem].
	super tearDown!

testAddRemoveResource
	| sampleResourceId |
	
	[sampleResourceId := ResourceIdentifier class: self testClass.
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
	| list |
	list := self resourceList.
	self assert: list notEmpty.
	self assert: list first isKindOf: ResourceIdentifier.
	self assert: list size > 100.
	self assert: (list includes: (ResourceIdentifier class: Shell)).
	self assert: (list includes: (ResourceIdentifier class: SystemBrowserShell))!

testClass
	^testClass ifNil: [testClass := Object
				subclass: #ResourceBrowserTestSampleClass
				instanceVariableNames: ''
				classVariableNames: ''
				poolDictionaries: ''
				classInstanceVariableNames: '']! !

!ResourceBrowserTest categoriesForMethods!
classToTest!constants!private! !
getShellResource!helpers!private! !
resourceBrowser!accessing!private! !
resourceDisplayList!accessing!private! !
resourceList!accessing!private! !
resourceToolboxPresenter!accessing!private! !
tearDown!private!running! !
testAddRemoveResource!public!unit tests! !
testBasicContents!public!unit tests! !
testClass!accessing!private! !
!

