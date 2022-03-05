"Filed out from Dolphin Smalltalk"!

TestResource subclass: #DolphinTestResource
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DolphinTestResource guid: (GUID fromString: '{1b75ff3b-eede-45ce-9144-898de51c1f3e}')!
DolphinTestResource isAbstract: true!
DolphinTestResource comment: ''!
!DolphinTestResource categoriesForClass!Unclassified! !
!DolphinTestResource methodsFor!

createPackage: name
	| package |
	package := Package name: name.
	Package manager addPackage: package.
	^package!

setUp
	super setUp.
	Package manager defaultPackage isNil ifFalse: [self error: 'Creating test classes with the default package set is a bad idea']! !
!DolphinTestResource categoriesForMethods!
createPackage:!helpers!private! !
setUp!Init / Release!public! !
!

