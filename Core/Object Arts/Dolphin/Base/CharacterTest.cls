"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #CharacterTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CharacterTest guid: (GUID fromString: '{b5b1b518-3a55-4441-9aa3-32c87f1aedba}')!
CharacterTest comment: ''!
!CharacterTest categoriesForClass!Unclassified! !
!CharacterTest methodsFor!

testAsLowercase
	self assert: $a asLowercase sameAs: $a.
	self assert: $A asLowercase sameAs: $a.
	self assert: $\0 asLowercase sameAs: $\0.
	"Turkish, but 8-bit"
	self assert: (Character codePoint: 16rC7) asLowercase equals: (Character codePoint: 16rE7).
	"Cyrillic, 16-bit"
	self assert: (Character codePoint: 16r0400) asLowercase equals: (Character codePoint: 16r450)
!

testAsUppercase
	self assert: $A asUppercase sameAs: $A.
	self assert: $a asUppercase sameAs: $A.
	self assert: $\0 asUppercase sameAs: $\0.
	"Turkish, but 8-bit"
	self assert: (Character codePoint: 16rE7) asUppercase equals: (Character codePoint: 16rC7).
	"Cyrillic, 16-bit"
	self assert: (Character codePoint: 16r0450) asUppercase equals: (Character codePoint: 16r400).
	"Greek delta"
	self assert: (Character codePoint: 16r3B4) asUppercase equals: (Character codePoint: 16r394).
	"Thai 7 - not a letter"
	self assert: (Character codePoint: 16rE57) asUppercase equals: (Character codePoint: 16rE57)!

testAsUtf8String
	#(#($A #[65]) #($\x7F #[16r7F]) #($€ #[16rC2 16r80]) #($\x7FF #[16rDF 16rBF]) #($\x800 #[16rE0 16rA0 16r80]))
		do: 
			[:each |
			| actual subject expected |
			subject := each first.
			expected := each last.
			actual := subject asUtf8String asByteArray.
			self assert: actual asByteArray equals: expected]!

testEquals
	self assert: $a equals: (Character codePoint: 97).
	self deny: $a equals: $A.
	self assert: $\0 equals: (Character codePoint: 0).
	self assert: (Character codePoint: 255) equals: (Character codePoint: 255).
	self assert: (Character codePoint: 16rFFFF) equals: (Character codePoint: 16rFFFF).
	self deny: (Character codePoint: 16rFFFE) equals: (Character codePoint: 16rFFFF).
	self deny: (Character codePoint: 16r200E) equals: 16r200E!

testIdentity
	self assert: $a sameAs: (Character codePoint: 97).
	self assert: (Character codePoint: 255) sameAs: (Character codePoint: 255).
	self deny: (Character codePoint: 256) sameAs: (Character codePoint: 256)!

testIsAlphaNumeric
	self assert: $a isAlphaNumeric.
	self assert: $A isAlphaNumeric.
	self assert: $0 isAlphaNumeric.
	"Punctuation"
	self deny: $" isAlphaNumeric.
	"Control char"
	self deny: $\0 isAlphaNumeric.
	"Left-to-right mark"
	self deny: (Character codePoint: 16r200E) isLowerCase.
	"Turkish, but 8-bit"
	self assert: (Character codePoint: 16rC7) isAlphaNumeric.
	self assert: (Character codePoint: 16rE7) isAlphaNumeric.
	" Cyrillic ie with grave, 16-bit"
	self assert: (Character codePoint: 16r400) isAlphaNumeric.
	self assert: (Character codePoint: 16r450) isAlphaNumeric.
	"Arabic indic digit zero"
	self assert: (Character codePoint: 16r660) isAlphaNumeric.
	"Arabic percent sign"
	self deny: (Character codePoint: 16r066A) isAlphaNumeric.
	"Thai digit for 7"
	self assert: (Character codePoint: 16rE57) isAlphaNumeric!

testIsControl
	"Tests Character>>isControl"

	"C0 and C1 control codes"

	(0 to: 31) , (127 to: 15) do: [:i | self assert: (Character codePoint: i) isControl].
	"All other ASCII chars are not control codes"
	32 to: 126 do: [:i | self deny: (Character codePoint: i) isControl].
	"Left to right mark"
	self assert: (Character codePoint: 16r200E) isControl.
	"Turkish, but ANSI"
	self deny: (Character codePoint: 16rC7) isControl.
	"Cyrillic letter ie with grave"
	self deny: (Character codePoint: 16r0400) isControl.
	"Thai 7"
	self deny: (Character codePoint: 16rE57) isControl!

testIsLowercase
	self assert: $a isLowerCase.
	self deny: $A isLowerCase.
	self deny: $0 isLowerCase.
	self deny: $\0 isLowerCase.
	"Left-to-right mark"
	self deny: (Character codePoint: 16r200E) isLowerCase.
	"Turkish, but 8-bit"
	self deny: (Character codePoint: 16rC7) isLowercase.
	self assert: (Character codePoint: 16rE7) isLowerCase.
	"Cyrillic, 16-bit"
	self deny: (Character codePoint: 16r0400) isLowercase.
	self assert: (Character codePoint: 16r450) isLowerCase.
	"Greek delta"
	self assert: (Character codePoint: 16r3B4) isLowercase.
	self deny: (Character codePoint: 16r394) isLowercase.
	"Thai 7"
	self deny: (Character codePoint: 16rE57) isLowercase!

testIsPunctuation
	self deny: $a isPunctuation.
	self deny: $0 isPunctuation.
	self assert: $. isPunctuation.
	"Solidus"
	self assert: $/ isPunctuation.
	"Left-to-right mark"
	self deny: (Character codePoint: 16r200E) isLowerCase.
	"Greek"
	self deny: (Character codePoint: 16r3B4) isPunctuation.
	self assert: (Character codePoint: 16r37E) isPunctuation.
	"Arabic indic digit zero"
	self deny: (Character codePoint: 16r660) isPunctuation.
	"Arabic percent sign"
	self assert: (Character codePoint: 16r066A) isPunctuation!

testIsUppercase
	self deny: $a isUppercase.
	self assert: $A isUppercase.
	self deny: $0 isUppercase.
	self deny: $\0 isUppercase.
	"Left-to-right mark"
	self deny: (Character codePoint: 16r200E) isLowerCase.
	"Turkish, but 8-bit"
	self assert: (Character codePoint: 16rC7) isUppercase.
	self deny: (Character codePoint: 16rE7) isUppercase.
	"Cyrillic, 16-bit"
	self assert: (Character codePoint: 16r0400) isUppercase.
	self deny: (Character codePoint: 16r450) isUppercase.
	"Greek delta"
	self deny: (Character codePoint: 16r3B4) isUppercase.
	self assert: (Character codePoint: 16r394) isUppercase.
	"Thai 7"
	self deny: (Character codePoint: 16rE57) isUpperCase!

testPrintString
	self assert: $a printString equals: '$a'.
	self assert: $a printString equals: '$a'.
	(1 to: 6) , (14 to: 32) do: 
			[:i |
			self assert: (Character codePoint: i) printString
				equals: '$\x' , (i printStringRadix: 16 showRadix: false)].
	(33 to: 126) , (128 to: 255)
		do: [:i | self deny: ((Character codePoint: i) printString beginsWith: '$\x')].
	self assert: (Character codePoint: 0) printString equals: '$\0'.
	self assert: (Character codePoint: 7) printString equals: '$\a'.
	self assert: (Character codePoint: 8) printString equals: '$\b'.
	self assert: (Character codePoint: 9) printString equals: '$\t'.
	self assert: (Character codePoint: 10) printString equals: '$\n'.
	self assert: (Character codePoint: 11) printString equals: '$\v'.
	self assert: (Character codePoint: 12) printString equals: '$\f'.
	self assert: (Character codePoint: 13) printString equals: '$\r'.
	self assert: (Character codePoint: 127) printString equals: '$\x7F'.
	self assert: (Character codePoint: 16r394) printString equals: '$\x394'.
	"Left-to-right mark"
	self assert: (Character codePoint: 16r200E) printString equals: '$\x200E'!

testSize
	self assert: $a size equals: 0.
	self assert: (Character codePoint: 16rFFFF) size equals: 0! !
!CharacterTest categoriesFor: #testAsLowercase!public! !
!CharacterTest categoriesFor: #testAsUppercase!public! !
!CharacterTest categoriesFor: #testAsUtf8String!public! !
!CharacterTest categoriesFor: #testEquals!public! !
!CharacterTest categoriesFor: #testIdentity!public! !
!CharacterTest categoriesFor: #testIsAlphaNumeric!public! !
!CharacterTest categoriesFor: #testIsControl!public! !
!CharacterTest categoriesFor: #testIsLowercase!public! !
!CharacterTest categoriesFor: #testIsPunctuation!public! !
!CharacterTest categoriesFor: #testIsUppercase!public! !
!CharacterTest categoriesFor: #testPrintString!public! !
!CharacterTest categoriesFor: #testSize!public! !

