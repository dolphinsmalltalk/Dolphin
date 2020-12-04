"Filed out from Dolphin Smalltalk 7"!

STON.CStyleCommentsSkipStream subclass: #'STON.DolphinCStyleCommentsSkipStream'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
STON.DolphinCStyleCommentsSkipStream guid: (Core.GUID fromString: '{c5873f76-4d78-4e57-9352-92f7bc94b1f3}')!
STON.DolphinCStyleCommentsSkipStream comment: ''!
!STON.DolphinCStyleCommentsSkipStream categoriesForClass!STON-Core-Utilities! !
!STON.DolphinCStyleCommentsSkipStream methodsFor!

consumeToEOL
	"Override to use #nextAvailable rather than #next"

	| eol char |
	eol := false.
	[eol] whileFalse: 
			[char := stream nextAvailable.
			(char isNil or: [char == $\n])
				ifTrue: [eol := true]
				ifFalse: 
					[char == $\r
						ifTrue: 
							[eol := true.
							stream peekFor: $\n]]]!

insideString
	"Return true when we are currently inside a string where comments should be ignored."

	^delimiter == $' or: [delimiter == $"]!

isPositionable
	^stream isPositionable!

nextAvailable
	^peekedCharacter
		ifNil: [stream atEnd ifFalse: [self nextNonCommentChar]]
		ifNotNil: 
			[| character |
			character := peekedCharacter.
			peekedCharacter := nil.
			character]!

nextNonCommentChar
	"We have to override this because Dolphin's ReadStream>>next throws end of stream on attempts to read off the end, as opposed to returning nil.
	We use nextAvailable instead."

	| char |
	char := stream nextAvailable.
	(self insideString and: [char == $\])
		ifTrue: 
			[escape := true.
			^char].
	(char == $' or: [char == $"]) ifTrue: [^self handleStringDelimiter: char].
	escape := false.
	^(char == $/
		and: [self insideString not and: 
					[| ch |
					(ch := stream peek) == $/ or: [ch == $*]]])
			ifTrue: 
				[self consumeComment.
				stream nextAvailable]
			ifFalse: [char]! !
!STON.DolphinCStyleCommentsSkipStream categoriesFor: #consumeToEOL!private! !
!STON.DolphinCStyleCommentsSkipStream categoriesFor: #insideString!private! !
!STON.DolphinCStyleCommentsSkipStream categoriesFor: #isPositionable!public! !
!STON.DolphinCStyleCommentsSkipStream categoriesFor: #nextAvailable!public! !
!STON.DolphinCStyleCommentsSkipStream categoriesFor: #nextNonCommentChar!private! !

