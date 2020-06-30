"Filed out from Dolphin Smalltalk 7"!

TestResource subclass: #DolphinTestResource
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
DolphinTestResource guid: (GUID fromString: '{1b75ff3b-eede-45ce-9144-898de51c1f3e}')!
DolphinTestResource isAbstract: true!
DolphinTestResource comment: ''!
!DolphinTestResource categoriesForClass!Unclassified! !
!DolphinTestResource methodsFor!

createPackage: aString
	| package |
	package := Package name: aString.
	Package manager addPackage: package.
	^package!

setUp
	super setUp.
	Package manager defaultPackage isNil ifFalse: [self error: 'Creating test classes with the default package set is a bad idea']! !
!DolphinTestResource categoriesFor: #createPackage:!helpers!private! !
!DolphinTestResource categoriesFor: #setUp!Init / Release!public! !

