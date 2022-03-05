"Filed out from Dolphin Smalltalk"!

BrowserEnvironmentTest subclass: #PluggableEnvironmentTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PluggableEnvironmentTest guid: (GUID fromString: '{42174aca-9bf1-402a-843a-d752822b7893}')!
PluggableEnvironmentTest comment: ''!
!PluggableEnvironmentTest categoriesForClass!Unclassified! !
!PluggableEnvironmentTest methodsFor!

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
!PluggableEnvironmentTest categoriesForMethods!
testReferencesTo!public!unit tests! !
!

