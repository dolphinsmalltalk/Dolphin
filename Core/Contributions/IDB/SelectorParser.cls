"Filed out from Dolphin Smalltalk"!

Object subclass: #SelectorParser
	instanceVariableNames: 'stream'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SelectorParser guid: (GUID fromString: '{bcef9177-1432-4eb4-80d9-6197b30bc4ab}')!

SelectorParser comment: 'Parse a method definition string to obtain the method''s selector.

Usage:
SelectorParser parse: aString

Advantages over using the compiler to obtain the selector...
- faster
- will work on methods that don''t compile correctly

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!

!SelectorParser categoriesForClass!IDB Goodies! !

!SelectorParser methodsFor!

isKeyword: aString
	"Answer true if aString is a valid keyword token"

	| len |
	len := aString size.
	^len > 1 and: [(aString at: len) == $: and: [(Scanner classify: (aString at: 1)) == #alphabetic]]!

parse: aString
	"Answer the Smalltalk selector parsed from aString. If the first token
	is a binary or unary token we need do no more, otherwise we have to
	get keyword tokens but omit the intervening arguments"

	| token keywords |
	stream := ReadStream on: aString.
	token := self scanFirstToken.
	(self isKeyword: token) ifFalse: [^token].
	keywords := WriteStream on: (aString class new: 40).
	
	[keywords nextPutAll: token.
	self scanKeywordOrArgumentToken.
	self isKeyword: (token := self scanKeywordOrArgumentToken)]
			whileTrue.
	^keywords contents!

scanBinaryToken
	"Answer the binary token from aStream"

	| ch start |
	start := stream position + 1.
	[(Scanner classify: (ch := stream nextAvailable)) == #binary] whileTrue.
	^stream collection copyFrom: start to: (ch ifNil: [stream position] ifNotNil: [stream position - 1])!

scanFirstToken
	"Answer the first token from the current position in the stream. After skipping separators and comments we know the next token will be either a binary selector or unary/keyword selector"

	[stream skipSeparators and: [stream peekFor: $"]] whileTrue: [stream skipTo: $"].
	^(Scanner classify: stream peek) == #binary
		ifTrue: [self scanBinaryToken]
		ifFalse: [self scanKeywordOrUnaryToken]!

scanKeywordOrArgumentToken
	"Answer the next token from aStream. Once we have got past separators
	and (possibly recursive) comments we can treat it in the same way (in terms 
	of character sequences) as the initial unary/keyword token. "

	[stream skipSeparators and: [stream peekFor: $"]] whileTrue: [stream skipTo: $"].
	^self scanKeywordOrUnaryToken!

scanKeywordOrUnaryToken
	"Answer the unary or keyword token from aStream. The only difference
	is that the unary token needs to be answered without it's delimiter but the
	keyword tokens needs to include it's delimiter - a colon"

	| ch start stop |
	start := stream position + 1.
	
	[| charClass |
	charClass := Scanner classify: (ch := stream nextAvailable).
	charClass == #alphabetic or: [charClass == #digit]]
			whileTrue.
	stop := stream position.
	(ch == $: or: [ch isNil]) ifFalse: [stream position: (stop := stop - 1)].
	"We know the stream is a ReadStream over the original source string, so access the collection directly for speed"
	^stream collection copyFrom: start to: stop! !

!SelectorParser categoriesForMethods!
isKeyword:!public!testing! !
parse:!operations!public! !
scanBinaryToken!operations!public! !
scanFirstToken!operations!public! !
scanKeywordOrArgumentToken!operations!public! !
scanKeywordOrUnaryToken!operations!public! !
!

!SelectorParser class methodsFor!

parse: aString 
	"Shortcut to create the receiver and perform the parsing "

	^self new parse: aString! !

!SelectorParser class categoriesForMethods!
parse:!instance creation!public! !
!

