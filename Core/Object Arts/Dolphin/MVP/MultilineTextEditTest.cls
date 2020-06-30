"Filed out from Dolphin Smalltalk 7"!

AbstractTextEditTest subclass: #MultilineTextEditTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
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
!MultilineTextEditTest categoriesFor: #classToTest!helpers!private! !
!MultilineTextEditTest categoriesFor: #margins!private!unit tests! !
!MultilineTextEditTest categoriesFor: #text!constants!private! !

