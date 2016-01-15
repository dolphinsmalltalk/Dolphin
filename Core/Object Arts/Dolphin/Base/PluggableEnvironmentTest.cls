"Filed out from Dolphin Smalltalk 7"!

BrowserEnvironmentTest subclass: #PluggableEnvironmentTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PluggableEnvironmentTest guid: (GUID fromString: '{42174ACA-9BF1-402A-843A-D752822B7893}')!
PluggableEnvironmentTest comment: ''!
!PluggableEnvironmentTest categoriesForClass!Unclassified! !
!PluggableEnvironmentTest methodsFor!

testReferencesTo
	| printString |
	printString := Smalltalk developmentSystem referencesTo: #printString.
	self universalTestFor: printString.
	self assert: printString numberSelectors 
				= (printString referencesTo: #printString) numberSelectors.
	self assert: printString numberClasses 
				= (printString referencesTo: #printString) numberClasses! !
!PluggableEnvironmentTest categoriesFor: #testReferencesTo!public!unit tests! !

