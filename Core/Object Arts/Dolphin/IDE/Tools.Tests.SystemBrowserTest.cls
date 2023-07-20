"Filed out from Dolphin Smalltalk"!

Tools.Tests.ClassBrowserAbstractTest
	subclass: #'Tools.Tests.SystemBrowserTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.Tests.SystemBrowserTest guid: (Core.GUID fromString: '{2e020526-2bd1-4fb6-b539-9c2456468a2c}')!
Tools.Tests.SystemBrowserTest comment: ''!
!Tools.Tests.SystemBrowserTest methodsFor!

classToTest
	^SystemBrowserShell!

testBrowseItOpensSystemBrowserOnPackageOfLooseMethod
	<nocreate>
	| default |
	#'1512'.
	default := SmalltalkSystem current defaultBrowserClass.
	
	[| method |
	SmalltalkSystem current defaultBrowserClass: SystemBrowserShell.
	method := Object compiledMethodAt: #asValue.
	self assert: method isLoose.
	presenter := method browse.
	self assert: presenter packages equals: {method owningPackage}]
			ensure: [SmalltalkSystem current defaultBrowserClass: default]! !
!Tools.Tests.SystemBrowserTest categoriesForMethods!
classToTest!public!Running! !
testBrowseItOpensSystemBrowserOnPackageOfLooseMethod!public!unit tests! !
!

