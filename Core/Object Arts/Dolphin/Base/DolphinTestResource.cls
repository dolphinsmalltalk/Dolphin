"Filed out from Dolphin Smalltalk 7"!

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
	^package! !
!DolphinTestResource categoriesFor: #createPackage:!helpers!private! !

