"Filed out from Dolphin Smalltalk 7"!

SequencedStream subclass: #LimitedWriteStream
	instanceVariableNames: 'stream limit limitBlock start printed'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
LimitedWriteStream guid: (GUID fromString: '{559e9343-8db5-45dd-bf26-68644d392dcb}')!
LimitedWriteStream comment: ''!
!LimitedWriteStream categoriesForClass!Collections-Streams! !
!LimitedWriteStream methodsFor!

atEnd
	"Answer whether the receiver is at the end of its values."

	^stream atEnd!

checkLimit
	stream position > limit ifTrue: [limitBlock cull: self]!

contents
	"Answer the contents of the streamed over collection up to the current position or the limit, whichever is less."

	stream position > limit ifTrue: [stream position: limit].
	^stream contents!

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

moveToEnd
	stream moveToEnd!

next: anInteger put: aCharacter
	stream position >= limit
		ifTrue: [limitBlock cull: self]
		ifFalse: [stream next: anInteger put: aCharacter].
	^aCharacter!

nextPut: anObject
	"Store anObject as the next element of the receiver, evaluating the limit block if the limit is reached or exceeded."

	stream position >= limit ifTrue: [limitBlock cull: self] ifFalse: [stream nextPut: anObject].
	^anObject!

nextPutAll: aCollection
	"Store the elements in the argument, aCollection, as the next elements accessible by the receiver. 
	Answer aCollection"

	stream position >= limit ifTrue: [limitBlock cull: self] ifFalse: [stream nextPutAll: aCollection].
	^aCollection!

originalContents
	^stream originalContents!

peekFor: anObject
	"Determine the response to the message peek. If it is the same as the argument, anObject,
	then advance the current position and answer true. Otherwise answer false and do not change
	the current position."

	^self errorNotReadable!

position
	^stream position min: limit!

print: aCompositeObject with: aNiladicValuable
	(printed includes: aCompositeObject)
		ifTrue: 
			[self nextPutAll: '... a cyclic ref to '.
			aCompositeObject basicPrintOn: self.
			self nextPutAll: '...'.
			^self].
	printed add: aCompositeObject.
	aNiladicValuable ensure: [printed remove: aCompositeObject ifAbsent: []]!

reset
	stream reset!

setStream: aCollection limit: anInteger limitBlock: aLimitBlock
	stream := aCollection.
	start := stream position.
	limit := start + anInteger.
	limitBlock := aLimitBlock.
	printed := IdentitySet new! !
!LimitedWriteStream categoriesFor: #atEnd!public!testing! !
!LimitedWriteStream categoriesFor: #checkLimit!helpers!private! !
!LimitedWriteStream categoriesFor: #contents!accessing!public! !
!LimitedWriteStream categoriesFor: #isWriteable!public!testing! !
!LimitedWriteStream categoriesFor: #limit!accessing!public! !
!LimitedWriteStream categoriesFor: #limit:!public! !
!LimitedWriteStream categoriesFor: #limitBlock!accessing!public! !
!LimitedWriteStream categoriesFor: #limitBlock:!accessing!public! !
!LimitedWriteStream categoriesFor: #moveToEnd!public! !
!LimitedWriteStream categoriesFor: #next:put:!public! !
!LimitedWriteStream categoriesFor: #nextPut:!accessing!public! !
!LimitedWriteStream categoriesFor: #nextPutAll:!accessing!public! !
!LimitedWriteStream categoriesFor: #originalContents!accessing!public! !
!LimitedWriteStream categoriesFor: #peekFor:!accessing!public! !
!LimitedWriteStream categoriesFor: #position!public! !
!LimitedWriteStream categoriesFor: #print:with:!public! !
!LimitedWriteStream categoriesFor: #reset!public! !
!LimitedWriteStream categoriesFor: #setStream:limit:limitBlock:!initializing!private! !

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

