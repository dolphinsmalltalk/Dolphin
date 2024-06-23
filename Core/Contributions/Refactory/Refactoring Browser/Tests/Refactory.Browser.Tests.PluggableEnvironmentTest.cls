"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.BrowserEnvironmentTest
	subclass: #'Refactory.Browser.Tests.PluggableEnvironmentTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Refactory.Browser.Tests.PluggableEnvironmentTest guid: (Core.GUID fromString: '{42174aca-9bf1-402a-843a-d752822b7893}')!

Refactory.Browser.Tests.PluggableEnvironmentTest comment: ''!

!Refactory.Browser.Tests.PluggableEnvironmentTest methodsFor!

testReferencesTo
	| printString env |
	env := BrowserEnvironment new forClasses: (OrderedCollection new
						add: Error;
						add: Error class;
						add: Object;
						add: Object class;
						add: Package;
						add: Package class;
						yourself).
	printString := Smalltalk developmentSystem referencesTo: #printString in: env.
	self universalTestFor: printString.
	self assert: printString numberSelectors equals: (env referencesTo: #printString) numberSelectors.
	self assert: printString numberClasses equals: (env referencesTo: #printString) numberClasses! !

!Refactory.Browser.Tests.PluggableEnvironmentTest categoriesForMethods!
testReferencesTo!public!unit tests! !
!

