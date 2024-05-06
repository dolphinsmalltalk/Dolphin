"Filed out from Dolphin Smalltalk"!

SmalltalkScanner subclass: #RBPatternScanner
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

RBPatternScanner guid: (GUID fromString: '{4164fa94-b687-42c0-9c94-c9e46fc319e5}')!

RBPatternScanner comment: 'RBPatternScanner is an extended <SmalltalkScanner> that supports the RB''s extended lexicon for pattern matching.'!

!RBPatternScanner categoriesForClass!Refactory-Parser! !

!RBPatternScanner methodsFor!

scanToken
	currentCharacter == PatternVariableCharacter 
		ifTrue: [^self scanPatternVariable].
	currentCharacter == $} ifTrue: [^self scanSpecialCharacter].
	^super scanToken! !

!RBPatternScanner categoriesForMethods!
scanToken!accessing!public! !
!

