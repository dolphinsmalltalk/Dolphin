"Filed out from Dolphin Smalltalk"!

Kernel.Scanner subclass: #'Refactory.Browser.RBPatternScanner'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'CascadeCharacter' -> $;.
		'ListCharacter' -> $@.
		'VariableCharacter' -> $`
	}!
Refactory.Browser.RBPatternScanner guid: (Core.GUID fromString: '{4164fa94-b687-42c0-9c94-c9e46fc319e5}')!
Refactory.Browser.RBPatternScanner comment: 'RBPatternScanner is an extended <SmalltalkScanner> that supports the RB''s extended lexicon for pattern matching.'!
!Refactory.Browser.RBPatternScanner categoriesForClass!Refactory-Parser! !
!Refactory.Browser.RBPatternScanner methodsFor!

scanToken
	currentCharacter == VariableCharacter ifTrue: [^self scanPatternVariable].
	currentCharacter == $} ifTrue: [^self scanSpecialCharacter].
	^super scanToken! !
!Refactory.Browser.RBPatternScanner categoriesForMethods!
scanToken!accessing!public! !
!

