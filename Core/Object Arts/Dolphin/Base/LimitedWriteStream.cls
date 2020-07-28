"Filed out from Dolphin Smalltalk 7"!

SequencedStream subclass: #LimitedWriteStream
	instanceVariableNames: 'stream limit limitBlock start visited visitedBlock'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
LimitedWriteStream guid: (GUID fromString: '{559e9343-8db5-45dd-bf26-68644d392dcb}')!
LimitedWriteStream comment: ''!
!LimitedWriteStream categoriesForClass!Collections-Streams! !
!LimitedWriteStream methodsFor!

alreadyVisited: aCompositeObject
	self visitedBlock
		ifNil: 
			[self nextPutAll: '... a cyclic ref to '.
			aCompositeObject basicPrintOn: self.
			self nextPutAll: '...']
		ifNotNil: [:block | block value: aCompositeObject]!

atEnd
	"Answer whether the receiver is at the end of its values."

	^stream atEnd!

checkLimit
	stream position > limit ifTrue: [limitBlock cull: self]!

contents
	"Answer the contents of the streamed over collection up to the current position or the limit, whichever is less."

	stream position > limit ifTrue: [stream position: limit].
	^stream contents!

contentsSpecies
	"Private - Answer the class of Object to be used when answering collections of elements from the receiver."

	^stream contentsSpecies!

encodedSizeOf: anObject
	"Answer the number of units that would be occupied by anObject if it were present in this stream."

	^stream encodedSizeOf: anObject!

isWriteable
	"Answer whether the receiver can be written to (i.e. it implements the 
	puttableStream protocol)."

	^true!

limit
	^limit - start!

limit: anInteger
	limit := start + anInteger.
	stream position > limit ifTrue: [limitBlock value]!

limitBlock
	^limitBlock!

limitBlock: aMonadicValuable
	limitBlock := aMonadicValuable!

locale
	"Answer the <Locale> to be used when emitting or reaading localisable data to/from this stream."

	^stream locale!

locale: aLocale
	stream locale: aLocale!

moveToEnd
	stream moveToEnd!

next: anInteger put: aCharacter
	| pos |
	pos := stream position.
	stream position + anInteger > limit
		ifTrue: 
			[stream next: (limit - pos max: 0) put: aCharacter.
			limitBlock cull: self]
		ifFalse: [stream next: anInteger put: aCharacter].
	^aCharacter!

nextPut: anObject
	"Store anObject as the next element of the receiver, evaluating the limit block if the limit is reached or would be exceeded."

	stream position + (stream encodedSizeOf: anObject) > limit
		ifTrue: [limitBlock cull: self]
		ifFalse: [stream nextPut: anObject].
	^anObject!

nextPutAll: aSequencedReadableCollection
	"Store the elements in the argument as the next elements accessible by the receiver. If the stream would exceed the limit then only those elements of aCollection up to the limit will be written and the limit block will be evaluated. Answer the argument."

	| pos |
	pos := stream position.
	pos + aSequencedReadableCollection size > limit
		ifTrue: 
			[stream
				next: (limit - pos max: 0)
				putAll: aSequencedReadableCollection
				startingAt: 1.
			limitBlock cull: self]
		ifFalse: [stream nextPutAll: aSequencedReadableCollection].
	^aSequencedReadableCollection!

originalContents
	^stream originalContents!

peekFor: anObject
	"Determine the response to the message peek. If it is the same as the argument, anObject,
	then advance the current position and answer true. Otherwise answer false and do not change
	the current position."

	^self errorNotReadable!

position
	^stream position min: limit!

reset
	stream reset!

setStream: aCollection limit: anInteger limitBlock: aLimitBlock
	stream := aCollection.
	start := stream position.
	limit := start + anInteger.
	limitBlock := aLimitBlock!

visit: aCompositeObject do: aNiladicValuable
	visited
		ifNil: [visited := IdentitySet with: aCompositeObject]
		ifNotNil: 
			[(visited includes: aCompositeObject)
				ifTrue: 
					[self alreadyVisited: aCompositeObject.
					^self].
			visited add: aCompositeObject].
	aNiladicValuable ensure: [visited remove: aCompositeObject ifAbsent: []]!

visitedBlock
	^visitedBlock!

visitedBlock: anObject
	visitedBlock := anObject! !
!LimitedWriteStream categoriesFor: #alreadyVisited:!private! !
!LimitedWriteStream categoriesFor: #atEnd!public!testing! !
!LimitedWriteStream categoriesFor: #checkLimit!helpers!private! !
!LimitedWriteStream categoriesFor: #contents!accessing!public! !
!LimitedWriteStream categoriesFor: #contentsSpecies!constants!private! !
!LimitedWriteStream categoriesFor: #encodedSizeOf:!encode/decode!public! !
!LimitedWriteStream categoriesFor: #isWriteable!public!testing! !
!LimitedWriteStream categoriesFor: #limit!accessing!public! !
!LimitedWriteStream categoriesFor: #limit:!public! !
!LimitedWriteStream categoriesFor: #limitBlock!accessing!public! !
!LimitedWriteStream categoriesFor: #limitBlock:!accessing!public! !
!LimitedWriteStream categoriesFor: #locale!accessing!public! !
!LimitedWriteStream categoriesFor: #locale:!accessing!public! !
!LimitedWriteStream categoriesFor: #moveToEnd!public! !
!LimitedWriteStream categoriesFor: #next:put:!public! !
!LimitedWriteStream categoriesFor: #nextPut:!accessing!public! !
!LimitedWriteStream categoriesFor: #nextPutAll:!accessing!public! !
!LimitedWriteStream categoriesFor: #originalContents!accessing!public! !
!LimitedWriteStream categoriesFor: #peekFor:!accessing!public! !
!LimitedWriteStream categoriesFor: #position!public! !
!LimitedWriteStream categoriesFor: #reset!public! !
!LimitedWriteStream categoriesFor: #setStream:limit:limitBlock:!initializing!private! !
!LimitedWriteStream categoriesFor: #visit:do:!public! !
!LimitedWriteStream categoriesFor: #visitedBlock!public! !
!LimitedWriteStream categoriesFor: #visitedBlock:!public! !

!LimitedWriteStream class methodsFor!

defaultLimit
	^1000!

defaultLimitBlock
	^
	[:stream |
	"Do nothing - the contents of the stream will still be restricted to the limit on access, but writing past the limit will be allowed to continue"
	]!

on: aCollection
	"Answer an instance of a kind of the receiver that streams over the 
	argument aCollection. If the new stream is writeable, the initial position
	is at the beginning of the collection (i.e. overwrite). See also 
	WriteStream>>#with:"

	^self on: aCollection limit: self defaultLimit!

on: aCollection from: firstIndex to: lastIndex
	"Answer an instance of a kind of the receiver that streams over a
	copy of a subcollection of the argument, aCollectionm from firstIndex to
	lastIndex. If the new stream is writeable, the initial position
	is at the beginning of the collection (i.e. overwrite). See also 
	WriteStream>>#with:from:to:"

	^self on: (aCollection copyFrom: firstIndex to: lastIndex)
!

on: aCollection limit: anInteger
	^self
		on: aCollection
		limit: anInteger
		limitBlock: self defaultLimitBlock!

on: aCollection limit: anInteger limitBlock: aLimitBlock
	^self
		over: aCollection writeStream
		limit: anInteger
		limitBlock: aLimitBlock!

over: aPuttableStream limit: anInteger
	^self
		over: aPuttableStream
		limit: anInteger
		limitBlock: self defaultLimitBlock!

over: aPuttableStream limit: anInteger limitBlock: aLimitBlock
	^self basicNew
		setStream: aPuttableStream
		limit: anInteger
		limitBlock: aLimitBlock!

with: aCollection
	"Answer a new instance of the receiver accessing the <collection>, aCollection,
	but positioned to store the next element at the end of it, i.e. an APPEND stream."

	^(self on: aCollection)
		moveToEnd;
		yourself

!

with: aCollection from: firstIndex to: lastIndex
	"Answer an instance of WriteStream accessing the subcollection of argument, 
	aCollection, from location firstIndex to lastIndex, but positioned to store
	the next element at the end of the subcollection, i.e. an APPEND stream."

	^(self on: aCollection from: firstIndex to: lastIndex)
		moveToEnd;
		yourself! !
!LimitedWriteStream class categoriesFor: #defaultLimit!constants!private! !
!LimitedWriteStream class categoriesFor: #defaultLimitBlock!constants!private! !
!LimitedWriteStream class categoriesFor: #on:!instance creation!public! !
!LimitedWriteStream class categoriesFor: #on:from:to:!instance creation!public! !
!LimitedWriteStream class categoriesFor: #on:limit:!accessing!public! !
!LimitedWriteStream class categoriesFor: #on:limit:limitBlock:!instance creation!public! !
!LimitedWriteStream class categoriesFor: #over:limit:!accessing!public! !
!LimitedWriteStream class categoriesFor: #over:limit:limitBlock:!instance creation!public! !
!LimitedWriteStream class categoriesFor: #with:!instance creation!public! !
!LimitedWriteStream class categoriesFor: #with:from:to:!instance creation!public! !

