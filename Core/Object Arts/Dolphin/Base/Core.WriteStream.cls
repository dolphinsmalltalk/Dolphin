"Filed out from Dolphin Smalltalk"!

Core.PositionableStream subclass: #'Core.WriteStream'
	instanceVariableNames: 'writeLimit'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.WriteStream guid: (Core.GUID fromString: '{87b4c6fb-026e-11d3-9fd7-00a0cc3e4a32}')!
Core.WriteStream comment: 'Class WriteStream is a concrete subclass of PositionableStream representing accessors for writing elements into a collecition. None of the next, next:, nor do: messages can be successfully sent to a WriteStream.

Instance Variables:
	writeLimit		<Integer>. Current maximum position up to which the stream may be positioned for writing.'!
!Core.WriteStream categoriesForClass!Collections-Streams! !
!Core.WriteStream methodsFor!

basicNext: countInteger putAll: aSequenceableCollection startingAt: startInteger
	"Private - Append countInteger elements of aSequenceableCollection from startInteger
	to the receiver. Answer aSequenceableCollection."

	| stop |
	stop := position + countInteger.
	stop <= writeLimit
		ifTrue: 
			["The block fits into the current collection and can be
			written directly"
			collection
				replaceFrom: position + 1
				to: stop
				with: aSequenceableCollection
				startingAt: startInteger.
			position := stop]
		ifFalse: 
			["The block will not fit within the current collection, so
			fall back on the slow way"
			startInteger to: startInteger + countInteger - 1
				do: [:i | self basicNextPut: (aSequenceableCollection at: i)]].
	^aSequenceableCollection!

basicNextPut: anObject
	"Private - Store anObject as the next element of the receiver.  If the receiver is not stream 
	over an Array or a String, or if the Array or String becomes full, then the primitive 
	will fail, and the backup Smalltalk code will be activated, grow the collection, and
	attempt to insert the object directly."

	<primitive: 222>
	position < writeLimit
		ifTrue: [collection at: (position := position + 1) put: anObject]
		ifFalse: 
			[self
				growCollection;
				primitiveBasicNextPut: anObject].
	^anObject!

basicNextPutAll: aCollection
	"Private - Store the elements in the argument, aCollection, as the next elements accessible by the receiver. 
	Answer aCollection"

	<primitive: 173>
	aCollection do: [:each | self nextPut: each]!

contents
	"Answer the contents of the streamed over collection up to
	the current position. At the same time adjust the readLimit
	to include that position if it doesn't already. I.E. By accessing
	the contents we have 'read' all the elements in the receiver.
	The readLimit is mostly of use to readable subclasses."

	readLimit < position ifTrue: [readLimit := position].
	^collection copyFrom: 1 to: position!

grabContents
	"Destructively answer the contents of the streamed over collection up to the current position. This may be the actual collection, or a copy of it up to the current position.
	The stream is no longer usable after this, so the message should only be sent to owned streams that are going out of scope."

	| answer |
	answer := position == collection size 
		ifTrue: [collection]
		ifFalse: [collection copyFrom: 1 to: position].
	collection := nil.
	^answer!

growCollection
	"Private - Increase the size of the streamed over collection
	to accommodate more elements."

	collection grow.
	writeLimit := collection size!

initialize
	"Private - Intitialise the receiver."

	position := readLimit := 0.
	writeLimit := collection size!

isWriteable
	"Answer whether the receiver can be written to (i.e. it implements the 
	puttableStream protocol)."

	^true!

moveToEnd
	"Private - Position the receiver to the end of its underlying
	collection."

	readLimit := collection size.
	self setToEnd!

next: countInteger putAll: aSequenceableCollection startingAt: startInteger
	"Append countInteger elements of aSequenceableCollection from startInteger to the receiver. Answer aSequenceableCollection.

	Note that the element count is the number of elements written from the <sequencedReadableCollection> argument. Depending on the receiver's encoding, this may not necessarily result in the receiver's position advancing by the same count."

	^collection
		encodeOn: self
		next: countInteger
		putAll: aSequenceableCollection
		startingAt: startInteger!

nextPut: anObject
	"Store anObject as the next element of the receiver.  If the receiver is not stream 
	over an Array or a String, or if the Array or String becomes full, then the primitive 
	will fail, and the backup Smalltalk code will be activated."

	<primitive: 66>
	^position + collection maxEncoding <= writeLimit
		ifTrue: [position := collection encodedAt: position + 1 put: anObject]
		ifFalse: 
			[self
				growCollection;
				primitiveNextPut: anObject]!

nextPutAll: aCollection
	"Store the elements in the argument, aCollection, as the next elements accessible by the receiver. 
	Answer aCollection"

	<primitive: 173>
	^_failureCode == _PrimitiveFailureCode.OutOfBounds
		ifTrue: 
			[self
				growCollection;
				primitiveNextPutAll: aCollection]
		ifFalse: [aCollection appendToStream: self]!

on: aCollection
	writeLimit := (collection := aCollection) size.
	position := readLimit := 0.
	locale := Locale.UserDefault!

padTo: anInteger put: anObject
	"Align the receiver's position to the next multiple of anInteger, padding with the 
	argument, anObject.  Answer the number of elements written."

	| delta |
	delta := anInteger - (self position \\ anInteger).
	^delta = anInteger ifTrue: [0] ifFalse: [self next: delta put: anObject]!

position: anInteger
	"Set the receiver's current position reference for accessing the collection
	to the argument, anInteger. If the argument is not within the bounds of
	the receiver's collection, report an error.
	Override to update the readLimit."

	readLimit < position ifTrue: [readLimit := position].
	super position: anInteger!

primitiveBasicNextPut: anObject
	<primitive: 222>
	^collection at: (position := position + 1) put: anObject!

primitiveNextPut: anObject
	<primitive: 66>
	position := collection encodedAt: position + 1 put: anObject!

primitiveNextPutAll: aCollection
	<primitive: 173>
	^aCollection appendToStream: self!

reset
	readLimit < position ifTrue: [readLimit := position].
	position := 0!

setToEnd
	"Set the receiver's position reference to the end of the collection,
	updating the readLimit if necessary."

	position := self size! !
!Core.WriteStream categoriesForMethods!
basicNext:putAll:startingAt:!accessing!private! !
basicNextPut:!accessing!private! !
basicNextPutAll:!accessing!private! !
contents!accessing!public! !
grabContents!accessing!public! !
growCollection!operations!private! !
initialize!initializing!private! !
isWriteable!public!testing! !
moveToEnd!positioning!private! !
next:putAll:startingAt:!accessing!public! !
nextPut:!accessing!public! !
nextPutAll:!accessing!public! !
on:!initializing!private! !
padTo:put:!positioning!public! !
position:!positioning!public! !
primitiveBasicNextPut:!accessing!private! !
primitiveNextPut:!accessing!private! !
primitiveNextPutAll:!accessing!private! !
reset!positioning!public! !
setToEnd!positioning!public! !
!

Core.WriteStream methodProtocol: #puttableStream attributes: #(#ansi #readOnly) selectors: #(#cr #flush #nextPut: #nextPutAll: #space #tab)!
Core.WriteStream methodProtocol: #WriteStream attributes: #(#ansi #readOnly) selectors: #(#close #contents #cr #flush #isEmpty #nextPut: #nextPutAll: #position #position: #reset #setToEnd #space #tab)!

!Core.WriteStream class methodsFor!

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
!Core.WriteStream class categoriesForMethods!
with:!instance creation!public! !
with:from:to:!instance creation!public! !
!

Core.WriteStream class methodProtocol: #'WriteStream factory' attributes: #(#ansi #readOnly) selectors: #(#with:)!

