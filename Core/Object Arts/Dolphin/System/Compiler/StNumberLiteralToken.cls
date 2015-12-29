"Filed out from Dolphin Smalltalk X6"!

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

source
	^source!

source: aString 
	source := aString!

storeOn: aStream 
	aStream nextPutAll: source! !
!StNumberLiteralToken categoriesFor: #acceptVisitor:!public!visitor! !
!StNumberLiteralToken categoriesFor: #source!accessing!public! !
!StNumberLiteralToken categoriesFor: #source:!accessing!public! !
!StNumberLiteralToken categoriesFor: #storeOn:!printing!public! !

!StNumberLiteralToken class methodsFor!

value: aNumber start: anInteger stop: stopInteger source: sourceString 
	^(self 
		value: aNumber
		start: anInteger
		stop: stopInteger)
		source: sourceString;
		yourself! !
!StNumberLiteralToken class categoriesFor: #value:start:stop:source:!instance creation!public! !

