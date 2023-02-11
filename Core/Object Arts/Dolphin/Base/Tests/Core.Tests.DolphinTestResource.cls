"Filed out from Dolphin Smalltalk"!

XProgramming.SUnit.TestResource subclass: #'Core.Tests.DolphinTestResource'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Tests.DolphinTestResource guid: (Core.GUID fromString: '{1b75ff3b-eede-45ce-9144-898de51c1f3e}')!
Core.Tests.DolphinTestResource isNonInstantiable: true!
Core.Tests.DolphinTestResource comment: ''!
!Core.Tests.DolphinTestResource methodsFor!

createPackage: aString
	| package |
	package := Package name: aString.
	Package manager addPackage: package.
	^package!

setUp
	super setUp.
	Package manager defaultPackage isNil
		ifFalse: [self error: 'Creating test classes with the default package set is a bad idea']! !
!Core.Tests.DolphinTestResource categoriesForMethods!
createPackage:!helpers!private! !
setUp!Init / Release!public! !
!

