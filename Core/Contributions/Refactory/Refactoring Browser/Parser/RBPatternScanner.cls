"Filed out from Dolphin Smalltalk X6"!

SmalltalkScanner subclass: #RBPatternScanner
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
RBPatternScanner guid: (GUID fromString: '{4164FA94-B687-42C0-9C94-C9E46FC319E5}')!
RBPatternScanner comment: 'RBPatternScanner is an extended <SmalltalkScanner> that supports the RB''s extended lexicon for pattern matching.'!
!RBPatternScanner categoriesForClass!Refactory-Parser! !
!RBPatternScanner methodsFor!

scanToken
	currentCharacter == PatternVariableCharacter 
		ifTrue: [^self scanPatternVariable].
	currentCharacter == $} ifTrue: [^self scanSpecialCharacter].
	^super scanToken! !
!RBPatternScanner categoriesFor: #scanToken!accessing!public! !

