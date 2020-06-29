"Filed out from Dolphin Smalltalk 7"!

Object subclass: #SelectorParser
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
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

binaryTokenFrom: aStream 
	"Answer the binary token from aStream"

	| start stop |
	start := aStream position.
	
	[aStream atEnd 
		ifTrue: 
			[aStream position: start.
			^aStream upToEnd].
	(self isBinaryDelimiter: aStream next) 
		ifTrue: 
			[stop := aStream position.
			aStream position: start.
			^aStream next: stop - start - 1]] 
			repeat!

firstTokenFrom: aStream 
	"Answer the first token from the current position in the stream. After skipping 
	separators and (recursively) comment we know the next token will be either a 
	binary selector or unary/keyword selector"

	aStream skipSeparators ifFalse: [^String new].
	(aStream peekFor: $") 
		ifTrue: 
			[aStream skipTo: $".
			^self firstTokenFrom: aStream].
	^(self isBinaryStarter: aStream peek) 
		ifTrue: [self binaryTokenFrom: aStream]
		ifFalse: [self keywordOrUnaryTokenFrom: aStream]!

isBinaryDelimiter: aCharacter 
	"Answer true is aCharacter cannot be part of a binary selector"

	^(##(' "_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789' , Character tab asString 
		, Character cr asString , Character nl asString 
		, Character newPage asString) indexOf: aCharacter) 
		~= 0!

isBinaryStarter: aCharacter 
	"Answer true is aCharacter can be the first character in a binary selector.
	Defined with regard to the current image. Adding binary selectors to the
	image may also require modifications here. See class comment"

	^(##('<=>\@|~&%*+,-/') indexOf: aCharacter) ~= 0!

isKeyword: aString 
	"Answer true if aString is a valid keyword token"

	^aString size >= 2 and: [aString last = $: and: [self isKeywordStarter: aString first]]!

isKeywordStarter: aCharacter 
	"Answer true is aCharacter is the first character of a keyword selector"

	^(##('_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ') indexOf: aCharacter) ~= 0!

isNonBinaryDelimiter: aCharacter 
	"Answer true is aCharacter cannot be part of a unary selector, keyword
	selector or the arguments in a selector string"

	^(##(' "#''^([<|-' , Character tab asString , Character cr asString , Character nl asString 
		, Character newPage asString) indexOf: aCharacter) 
		~= 0!

keywordOrArgumentTokenFrom: aStream 
	"Answer the next token from aStream. Once we have got past separators
	and (possibly recursive) comments we can treat it in the same way (in terms 
	of character sequences) as the initial unary/keyword token. "

	aStream skipSeparators ifFalse: [^String new].
	(aStream peekFor: $") 
		ifTrue: 
			[aStream skipTo: $".
			^self keywordOrArgumentTokenFrom: aStream].
	^self keywordOrUnaryTokenFrom: aStream!

keywordOrUnaryTokenFrom: aStream 
	"Answer the unary or keyword token from aStream. The only difference
	is that the unary token needs to be answered without it's delimiter but the
	keyword tokens needs to include it's delimiter - a colon"

	| start stop char |
	start := aStream position.
	
	[aStream atEnd 
		ifTrue: 
			[aStream position: start.
			^aStream upToEnd].
	(char := aStream next) = $: 
		ifTrue: 
			[stop := aStream position.
			aStream position: start.
			^aStream next: stop - start].
	(self isNonBinaryDelimiter: char) 
		ifTrue: 
			[stop := aStream position.
			aStream position: start.
			^aStream next: stop - start - 1]] 
			repeat!

parse: aString 
	"Answer the Smalltalk selector parsed from aString. If the first token
	is a binary or unary token we need do no more, otherwise we have to
	get keyword tokens but omit the intervening arguments"

	| readStream writeStream token |
	readStream := aString readStream.
	token := self firstTokenFrom: readStream.
	(self isKeyword: token) ifFalse: [^token].
	writeStream := String writeStream: 100.
	[self isKeyword: token] whileTrue: 
			[writeStream nextPutAll: token.
			self keywordOrArgumentTokenFrom: readStream.
			token := self keywordOrArgumentTokenFrom: readStream].
	^writeStream contents! !
!SelectorParser categoriesFor: #binaryTokenFrom:!operations!public! !
!SelectorParser categoriesFor: #firstTokenFrom:!operations!public! !
!SelectorParser categoriesFor: #isBinaryDelimiter:!public!testing! !
!SelectorParser categoriesFor: #isBinaryStarter:!public!testing! !
!SelectorParser categoriesFor: #isKeyword:!public!testing! !
!SelectorParser categoriesFor: #isKeywordStarter:!public!testing! !
!SelectorParser categoriesFor: #isNonBinaryDelimiter:!public!testing! !
!SelectorParser categoriesFor: #keywordOrArgumentTokenFrom:!operations!public! !
!SelectorParser categoriesFor: #keywordOrUnaryTokenFrom:!operations!public! !
!SelectorParser categoriesFor: #parse:!operations!public! !

!SelectorParser class methodsFor!

parse: aString 
	"Shortcut to create the receiver and perform the parsing "

	^self new parse: aString! !
!SelectorParser class categoriesFor: #parse:!instance creation!public! !

