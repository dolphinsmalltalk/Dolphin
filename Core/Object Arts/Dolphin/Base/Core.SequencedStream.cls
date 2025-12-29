"Filed out from Dolphin Smalltalk"!

Core.Stream
	subclass: #'Core.SequencedStream'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Core.SequencedStream guid: (Core.GUID fromString: '{9b6a5665-c80e-457c-b384-f716399f271d}')!

Core.SequencedStream isNonInstantiable: true!

Core.SequencedStream comment: 'SequencedStream is an class of <Stream>s that stream over a finite number of past and future sequence values, maintaining a current position among those sequence values and allowing that position to be altered. Sub-instances of <SequencedStream> conform to the ANSI <sequencedStream> protocol.'!

!Core.SequencedStream categoriesForClass!Collections-Streams! !

!Core.SequencedStream methodsFor!

basicNext: countInteger putAll: aSequenceableCollection startingAt: startInteger
	"Private - Append countInteger elements of aSequenceableCollection (assumed to be of the same encoding as the receiver), starting with that at startInteger, to the receiver. Answer aSequenceableCollection."

	self errorNotWriteable!

contents
	"Answer a <sequencedReadableCollection> that contains the receiver's past and future
	sequence values, in order, i.e. the complete contents of the stream."

	^self subclassResponsibility
!

copyFrom: startInteger to: stopInteger 
	"Answer a new <sequencedReadableCollection> like that streamed over by the receiver
	containing those elements of the receiver between the specified one-based <integer> indices,
	inclusive, and in the same order. The stream position is left unchanged."

	| answer mark |
	mark := self position.
	self position: startInteger - 1.
	answer := self basicNext: stopInteger - startInteger + 1.
	self position: mark.
	^answer!

isEmpty
	"Answer whether the sets of both past and future sequence values are empty."

	^self size == 0!

isPositionable
	"Answer whether the receiver supports the #position[:] messages for querying and setting its position in the data stream."

	^true!

locale: aLocale
	self subclassResponsibility!

nextWord
	"Answer the next 'word' in the receiver's element stream, where a word is defined as a
	sequence of one or more elements delimited by an elements which answer true to #isSeparator,
	or nil if there are no more words in the receiver. Leading separators are skipped. The
	stream is left positioned after the first trailing separator."

	| wordStream element |
	self skipSeparators ifFalse: [^nil].
	wordStream := self contentsSpecies writeStream: 32.
	[(element := self nextAvailable) isNil or: [element isSeparator]]
		whileFalse: [wordStream nextPut: element].
	^wordStream contents!

notEmpty
	"Answer whether there are any sequence values in the receiver."

	^self isEmpty not!

pop
	"Move back one position in the stream."

	self skip: -1!

position
	"Answer the current <integer> position in the stream of  values."

	^self subclassResponsibility!

position: anInteger 
	"Set the current position in the stream of values to the <integer> argument."

	^self subclassResponsibility!

reset
	"Reset the position of the receiver to be at the beginning of the stream of values, i.e. the
	stream will answer the first sequence value (if any) in response to the #next message."

	self position: 0!

reverseContents
	"Answer a copy of the receiver's contents in reverse order."

	^self contents reverse!

size
	"Answer the number of values in the stream."

	^self subclassResponsibility!

skipSeparators
	"Advance the receiver's position over any leading whitespace. Answer whether their are more
	elements remaining in the receiver after the separators."

	"Implementation Note: Implementable in terms of #skipWhile:, but this is called so
	frequently that we open code to avoid instantiating a block."

	| next pos |
	
	[pos := self position.
	(next := self nextAvailable) isNil] whileFalse: 
				[next isSeparator
					ifFalse: 
						[self position: pos.
						^true]].
	^false!

skipWhile: aMonadicValuable
	"Advance the receiver's current position to be past the sequence of future values for which
	the <monadicValuable> argument evaluates to true. Answer true if there are more elements on
	the stream of false otherwise."

	[self atEnd] whileFalse: 
			[| pos |
			pos := self position.
			(aMonadicValuable value: self next)
				ifFalse: 
					[self position: pos.
					^true]].
	^false!

skipWhileMatchAll: aCollection 
	"Advance the receiver's current position to be past the sequence of future values which
	match those in the <Collection> argument. Answer true if the match succeeds completely and
	the stream is left positioned after the final match. If the match fails at any point then
	false is answered and the stream is re-positioned to its initial position. The collection's
	elements are matched against the receiver's future sequence values in the same order as they
	would be enumerated by the collection's implementation of the #do: message."

	^aCollection skipOver: self! !

!Core.SequencedStream categoriesForMethods!
basicNext:putAll:startingAt:!private!writing! !
contents!public!reading! !
copyFrom:to:!public!reading! !
isEmpty!public!testing! !
isPositionable!public!testing! !
locale:!accessing!public! !
nextWord!public!reading! !
notEmpty!public!testing! !
pop!positioning!public! !
position!positioning!public! !
position:!positioning!public! !
reset!positioning!public! !
reverseContents!public!reading! !
size!accessing!public! !
skipSeparators!positioning!public! !
skipWhile:!positioning!public! !
skipWhileMatchAll:!positioning!public! !
!

