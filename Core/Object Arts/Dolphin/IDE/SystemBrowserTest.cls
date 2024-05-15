"Filed out from Dolphin Smalltalk"!

ClassBrowserAbstractTest subclass: #SystemBrowserTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SystemBrowserTest guid: (GUID fromString: '{2e020526-2bd1-4fb6-b539-9c2456468a2c}')!

SystemBrowserTest comment: ''!

!SystemBrowserTest categoriesForClass!Unclassified! !

!SystemBrowserTest methodsFor!

classToTest
	^SystemBrowserShell!

testBrowseItOpensSystemBrowserOnPackageOfLooseMethod
	| default |
	#nocreate.
	#'1512'.
	default := SmalltalkSystem current defaultBrowserClass.
	
	[| method |
	SmalltalkSystem current defaultBrowserClass: SystemBrowserShell.
	method := Object compiledMethodAt: #asValue.
	self assert: method isLoose.
	presenter := method browse.
	self assert: presenter packages equals: {method owningPackage}]
			ensure: [SmalltalkSystem current defaultBrowserClass: default]! !

!SystemBrowserTest categoriesForMethods!
classToTest!public!Running! !
testBrowseItOpensSystemBrowserOnPackageOfLooseMethod!public!unit tests! !
!

