"Filed out from Dolphin Smalltalk 7"!

StLiteralToken subclass: #StNumberLiteralToken
	instanceVariableNames: 'source'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StNumberLiteralToken guid: (GUID fromString: '{777F55AE-A939-4A73-9CC8-2CEF3A91F41E}')!
StNumberLiteralToken comment: ''!
!StNumberLiteralToken categoriesForClass!Unclassified! !
!StNumberLiteralToken methodsFor!

acceptVisitor: aTokenVisitor 
	^aTokenVisitor acceptNumberLiteralToken: self!

forgetNegative
	value := value negated.
	source := source copyFrom: 2.
	sourcePointer := sourcePointer + 1!

formatOn: aStream source: aString 
	"For numbers, retain the original source form as unless it is a plain integer it may have
	been deliberatey expressed in a particular format by the user."

	source ifNil: [self value printOn: aStream] ifNotNil: [aStream nextPutAll: source]!

isNegative
	^self source first == $-!

source
	^source!

source: aString 
	source := aString! !
!StNumberLiteralToken categoriesFor: #acceptVisitor:!public!visitor! !
!StNumberLiteralToken categoriesFor: #forgetNegative!helpers!private! !
!StNumberLiteralToken categoriesFor: #formatOn:source:!printing!public! !
!StNumberLiteralToken categoriesFor: #isNegative!testing!public! !
!StNumberLiteralToken categoriesFor: #source!accessing!public! !
!StNumberLiteralToken categoriesFor: #source:!accessing!public! !

!StNumberLiteralToken class methodsFor!

value: aNumber start: anInteger stop: stopInteger source: sourceString 
	^(self 
		value: aNumber
		start: anInteger
		stop: stopInteger)
		source: sourceString;
		yourself! !
!StNumberLiteralToken class categoriesFor: #value:start:stop:source:!instance creation!public! !

