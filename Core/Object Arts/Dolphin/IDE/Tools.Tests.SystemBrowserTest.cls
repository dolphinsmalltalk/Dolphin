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

browserClass
	^SystemBrowserShell!

testBrowseItOpensSystemBrowserOnPackageOfLooseMethod
	| default |
	#'1512'.
	default := SmalltalkSystem current defaultBrowserClass.
	
	[| method |
	SmalltalkSystem current defaultBrowserClass: SystemBrowserShell.
	method := Object compiledMethodAt: #asValue.
	self assert: method isLoose.
	browser := method browse.
	self assert: browser packages equals: {method owningPackage}]
			ensure: [SmalltalkSystem current defaultBrowserClass: default]! !
!Tools.Tests.SystemBrowserTest categoriesForMethods!
browserClass!public!Running! !
testBrowseItOpensSystemBrowserOnPackageOfLooseMethod!public!unit tests! !
!

