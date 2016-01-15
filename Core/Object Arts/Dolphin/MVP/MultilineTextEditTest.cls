"Filed out from Dolphin Smalltalk 7"!

TextEditTest subclass: #MultilineTextEditTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MultilineTextEditTest guid: (GUID fromString: '{2EEDBA10-3618-4267-9A38-179FD63152C0}')!
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

