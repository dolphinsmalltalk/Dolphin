"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'STON.CStyleCommentsSkipStream'
	instanceVariableNames: 'stream peekedCharacter delimiter escape'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
STON.CStyleCommentsSkipStream guid: (Core.GUID fromString: '{cbe95784-18b0-4161-a8b1-142a76001d59}')!
STON.CStyleCommentsSkipStream comment: 'I am STONCStyleCommentsSkipStream, a character ReadStream wrapping another character ReadStream. I skip C style comments, much like a classic C preprocessor.

C, C++, Java, JavaScript style comments are either the multiline

	/* a comment */
	
or the single line, up to end of line

	// a comment 
	
I deal with any end of line convention. Multiline comments cannot be nested. 

You create me #on: another character ReadStream. 

Here is an example:

	(STONCStyleCommentsSkipStream on: ''abc/*comment*/def'' readStream) upToEnd.
	
Comments inside single and double quote delimited strings are ignored. Backslash escapes for single and double quotes inside strings are honored.
'!
!STON.CStyleCommentsSkipStream categoriesForClass!STON-Core-Utilities! !
!STON.CStyleCommentsSkipStream methodsFor!

atEnd
	^ self peek isNil!

close
	stream close!

collectionSpecies
	^String!

consumeComment
	stream peek = $/ ifTrue: [ self consumeToEOL ].
	stream peek = $* ifTrue: [ self consumeToCommentEnd ]!

consumeToCommentEnd
	[ stream atEnd or: [ stream next = $* and: [ stream peekFor: $/ ] ] ] whileFalse!

consumeToEOL
	| eol char |
	eol := false.
	[eol] whileFalse: 
			[char := stream next.
			(char isNil or: [char = Character lf])
				ifTrue: [eol := true]
				ifFalse: 
					[char = Character cr
						ifTrue: 
							[eol := true.
							stream peekFor: Character lf]]]!

escape
	"Return true when we previously read a backslash escape inside a string, 
	so that the next string delimiter should be returned as is"
	
	^ escape = true!

handleStringDelimiter: char
	self escape
		ifTrue: [ escape := false ]
		ifFalse: [ 
			self insideString
				ifTrue: [ 
					char = delimiter
						ifTrue: [ delimiter := nil ] ]
				ifFalse: [ delimiter := char ] ].
	^ char!

insideString
	"Return true when we are currently inside a string where comments should be ignored."
	
	^ (delimiter = $') | (delimiter = $")!

isBinary
	^ false!

next
	^ peekedCharacter
		ifNil: [ 
			stream atEnd
				ifFalse: [ self nextNonCommentChar ] ]
		ifNotNil: [ | character |
			character := peekedCharacter.
			peekedCharacter := nil.
			character ]!

next: requestedCount 
	"Read requestedCount elements into new collection and return it,
	 it could be that less elements were available"

	^ self 
		next: requestedCount 
		into: (self collectionSpecies new: requestedCount)!

next: requestedCount into: collection
	"Read requestedCount elements into collection,
	returning a copy if less elements are available"
	
	^ self
		next: requestedCount
		into: collection
		startingAt: 1!

next: requestedCount into: collection startingAt: offset
	"Read requestedCount elements into collection starting at offset,
	returning a copy if less elements are available"
	
	| readCount |
	readCount := self 
		readInto: collection 
		startingAt: offset 
		count: requestedCount.
	^ requestedCount = readCount
		ifTrue: [ collection ]
		ifFalse: [ collection copyFrom: 1 to: offset + readCount - 1 ]!

nextLine
	"Read a CR, LF or CRLF terminated line, returning the contents of the line without the EOL. Return nil when the receiver is #atEnd."

	self atEnd ifTrue: [^nil].
	^self collectionSpecies streamContents: 
			[:out |
			| eol char |
			eol := false.
			[eol] whileFalse: 
					[char := self next.
					(char isNil or: [char = Character lf])
						ifTrue: [eol := true]
						ifFalse: 
							[char = Character cr
								ifTrue: 
									[eol := true.
									self peekFor: Character lf]
								ifFalse: [out nextPut: char]]]]!

nextNonCommentChar
	| char |
	char := stream next.
	(self insideString and: [ char = $\ ])
		ifTrue: [ 
			escape := true. 
			^ char ].
	(char = $') | (char = $")
		ifTrue: [ 
			^ self handleStringDelimiter: char ].
	escape := false. 
	^ (char = $/ and: [ self insideString not and: [ (stream peek = $/) | (stream peek = $*) ] ])
		ifTrue: [ 
			self consumeComment.
			stream next ]
		ifFalse: [ char ]
!

on: readStream
	stream := readStream!

peek
	^ peekedCharacter
		ifNil: [
			stream atEnd
				ifFalse: [ 
					peekedCharacter := self nextNonCommentChar ] ]
!

peekFor: object
	^ self peek = object
		ifTrue: [ 
			self next.
			true ]
		ifFalse: [ false ]!

position
	^ stream position!

readInto: collection startingAt: offset count: requestedCount 
	"Read count elements and place them in collection starting at offset.
	Return the number of elements actually read."
	
	^ peekedCharacter 
		ifNil: [
			0 to: requestedCount - 1 do: [ :count | | object |
				(object := self nextNonCommentChar) ifNil: [ ^ count ].  
				collection at: offset + count put: object ].
			^ requestedCount ]
		ifNotNil: [ 
			collection at: offset put: peekedCharacter.
			peekedCharacter := nil.
			(self 
				readInto: collection 
				startingAt: offset + 1
				count: requestedCount - 1) + 1 ]!

skip: count
	count timesRepeat: [ self next ]!

upTo: anObject 	
	^ self collectionSpecies 
		streamContents: [ :out | | element |
			[ self atEnd or: [ (element := self next) = anObject ] ] whileFalse: [ 
				out nextPut: element ] ]!

upToEnd
	^ self collectionSpecies
		streamContents: [ :collectionStream | 
			[ self atEnd ] whileFalse: [ collectionStream nextPut: self next ] ]!

wrappedStream
	^ stream! !
!STON.CStyleCommentsSkipStream categoriesFor: #atEnd!public!testing! !
!STON.CStyleCommentsSkipStream categoriesFor: #close!initialize/release!public! !
!STON.CStyleCommentsSkipStream categoriesFor: #collectionSpecies!accessing!public! !
!STON.CStyleCommentsSkipStream categoriesFor: #consumeComment!private! !
!STON.CStyleCommentsSkipStream categoriesFor: #consumeToCommentEnd!private! !
!STON.CStyleCommentsSkipStream categoriesFor: #consumeToEOL!private! !
!STON.CStyleCommentsSkipStream categoriesFor: #escape!private! !
!STON.CStyleCommentsSkipStream categoriesFor: #handleStringDelimiter:!private! !
!STON.CStyleCommentsSkipStream categoriesFor: #insideString!private! !
!STON.CStyleCommentsSkipStream categoriesFor: #isBinary!public!testing! !
!STON.CStyleCommentsSkipStream categoriesFor: #next!accessing!public! !
!STON.CStyleCommentsSkipStream categoriesFor: #next:!accessing!public! !
!STON.CStyleCommentsSkipStream categoriesFor: #next:into:!accessing!public! !
!STON.CStyleCommentsSkipStream categoriesFor: #next:into:startingAt:!accessing!public! !
!STON.CStyleCommentsSkipStream categoriesFor: #nextLine!accessing!public! !
!STON.CStyleCommentsSkipStream categoriesFor: #nextNonCommentChar!private! !
!STON.CStyleCommentsSkipStream categoriesFor: #on:!initialize/release!public! !
!STON.CStyleCommentsSkipStream categoriesFor: #peek!accessing!public! !
!STON.CStyleCommentsSkipStream categoriesFor: #peekFor:!accessing!public! !
!STON.CStyleCommentsSkipStream categoriesFor: #position!accessing!public! !
!STON.CStyleCommentsSkipStream categoriesFor: #readInto:startingAt:count:!accessing!public! !
!STON.CStyleCommentsSkipStream categoriesFor: #skip:!accessing!public! !
!STON.CStyleCommentsSkipStream categoriesFor: #upTo:!accessing!public! !
!STON.CStyleCommentsSkipStream categoriesFor: #upToEnd!accessing!public! !
!STON.CStyleCommentsSkipStream categoriesFor: #wrappedStream!accessing!public! !

!STON.CStyleCommentsSkipStream class methodsFor!

on: readStream
	^ self new
		on: readStream;
		yourself! !
!STON.CStyleCommentsSkipStream class categoriesFor: #on:!instance creation!public! !

