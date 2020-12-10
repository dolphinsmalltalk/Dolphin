"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTest subclass: #'Tools.Tests.ResourceBrowserTest'
	instanceVariableNames: 'resourceBrowser testClass'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.Tests.ResourceBrowserTest guid: (Core.GUID fromString: '{8d888ba2-f5b7-402c-9bff-e88b2cde2fab}')!
Tools.Tests.ResourceBrowserTest comment: ''!
!Tools.Tests.ResourceBrowserTest categoriesForClass!Unclassified! !
!Tools.Tests.ResourceBrowserTest methodsFor!

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
	self resourceBrowser destroy.
	resourceBrowser := nil.
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
!Tools.Tests.ResourceBrowserTest categoriesFor: #getShellResource!private!unit tests! !
!Tools.Tests.ResourceBrowserTest categoriesFor: #resourceBrowser!private!unit tests! !
!Tools.Tests.ResourceBrowserTest categoriesFor: #resourceDisplayList!private!unit tests! !
!Tools.Tests.ResourceBrowserTest categoriesFor: #resourceList!private!unit tests! !
!Tools.Tests.ResourceBrowserTest categoriesFor: #resourceToolboxPresenter!private!unit tests! !
!Tools.Tests.ResourceBrowserTest categoriesFor: #setUp!private!unit tests! !
!Tools.Tests.ResourceBrowserTest categoriesFor: #tearDown!private!unit tests! !
!Tools.Tests.ResourceBrowserTest categoriesFor: #testAddRemoveResource!public!unit tests! !
!Tools.Tests.ResourceBrowserTest categoriesFor: #testBasicContents!public!unit tests! !

