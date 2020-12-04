"Filed out from Dolphin Smalltalk 7"!

Kernel.StValueToken subclass: #'Kernel.StSpecialCharacterToken'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.StSpecialCharacterToken guid: (Core.GUID fromString: '{6d27cd5e-b145-43c8-b556-242906a6b9d8}')!
Kernel.StSpecialCharacterToken comment: ''!
!Kernel.StSpecialCharacterToken categoriesForClass!System-Compiler! !
!Kernel.StSpecialCharacterToken methodsFor!

acceptVisitor: aTokenVisitor
	^aTokenVisitor visitSpecialCharacterToken: self!

isSpecial
	^true!

isSpecial: aCharacter
	^self value == aCharacter!

length
	^1! !
!Kernel.StSpecialCharacterToken categoriesFor: #acceptVisitor:!public!visitor! !
!Kernel.StSpecialCharacterToken categoriesFor: #isSpecial!public!testing! !
!Kernel.StSpecialCharacterToken categoriesFor: #isSpecial:!public!testing! !
!Kernel.StSpecialCharacterToken categoriesFor: #length!accessing!private! !

