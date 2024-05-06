"Filed out from Dolphin Smalltalk"!

AbstractTextEditTest subclass: #MultilineTextEditTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MultilineTextEditTest guid: (GUID fromString: '{2eedba10-3618-4267-9a38-179fd63152c0}')!

MultilineTextEditTest comment: ''!

!MultilineTextEditTest categoriesForClass!Unclassified! !

!MultilineTextEditTest methodsFor!

classToTest
	^MultilineTextEdit!

margins
	^1 @ 1!

text
	^Object comment copyWithout: Character tab! !

!MultilineTextEditTest categoriesForMethods!
classToTest!helpers!private! !
margins!private!unit tests! !
text!constants!private! !
!

