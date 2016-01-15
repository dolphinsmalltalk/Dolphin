"Filed out from Dolphin Smalltalk 7"!

TestResource subclass: #DolphinTestResource
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DolphinTestResource guid: (GUID fromString: '{1B75FF3B-EEDE-45CE-9144-898DE51C1F3E}')!
DolphinTestResource comment: ''!
!DolphinTestResource categoriesForClass!Unclassified! !
!DolphinTestResource methodsFor!

createPackage: name
	| package |
	package := Package name: name.
	Package manager addPackage: package.
	^package! !
!DolphinTestResource categoriesFor: #createPackage:!helpers!private! !

!DolphinTestResource class methodsFor!

isAbstract
	^self == ##(self)! !
!DolphinTestResource class categoriesFor: #isAbstract!public!Testing! !

