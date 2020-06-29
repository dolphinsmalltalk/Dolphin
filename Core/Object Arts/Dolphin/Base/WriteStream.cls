"Filed out from Dolphin Smalltalk 7"!

PositionableStream subclass: #WriteStream
	instanceVariableNames: 'writeLimit'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
WriteStream guid: (GUID fromString: '{87b4c6fb-026e-11d3-9fd7-00a0cc3e4a32}')!
WriteStream comment: 'Class WriteStream is a concrete subclass of PositionableStream representing accessors for writing elements into a collecition. None of the next, next:, nor do: messages can be successfully sent to a WriteStream.

Instance Variables:
	writeLimit		<Integer>. Current maximum position up to which the stream may be positioned for writing.'!
!WriteStream categoriesForClass!Collections-Streams! !
!WriteStream methodsFor!

<< anObject
	"Store the argument, or the elements of the argument if it is a <collection>, as the next element or elements of the receiver."

	anObject appendToStream: self.
	^self!

basicNext: sizeInteger putAll: aSequenceableCollection startingAt: startInteger 
	"Private - Append countInteger elements of aSequenceableCollection from startInteger
	to the receiver. Answer aSequenceableCollection."

	| stop |
	stop := position + sizeInteger.
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

			startInteger to: startInteger + sizeInteger - 1
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

basicPrint: printee
	"Private - Ask the <Object>, printee, to append its basic textual description
	to the receiver."

	printee basicPrintOn: self!

binaryStore: anObject
	"Ask anObject to append to the receiver binary byte which when
	read will result in an Object equivalent to anObject"

	anObject binaryStoreOn: self
!

contents
	"Answer the contents of the streamed over collection up to
	the current position. At the same time adjust the readLimit
	to include that position if it doesn't already. I.E. By accessing
	the contents we have 'read' all the elements in the receiver.
	The readLimit is mostly of use to readable subclasses."

	readLimit := readLimit max: position.
	^collection copyFrom: 1 to: position!

cr
	"Store the line delimiter character sequence (as required by
	the environment) as the next element(s) of the receiver."

	self nextPutAll: String lineDelimiter!

crtab
	"Append a line-delimiter and a tab to the receiver."

	self cr; tab!

crtab: tabCount
	"Append a line-delimiter and the specified number of tabs to the receiver."

	self cr; tab: tabCount!

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
	to accomodate more elements."

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

next
	"Answer the next object accessible by the receiver. WriteStreams do not support reading.
	This effectively stubs out all the read methods inherited from superclasses."

	^self errorNotReadable!

next: anInteger put: anObject
	"Store the argument, anObject, as the next anInteger number of elements accessible by the receiver. 
	Answer anObject."

	anInteger timesRepeat: [self nextPut: anObject].
	^anObject!

next: sizeInteger putAll: aSequenceableCollection startingAt: startInteger
	"Append countInteger elements of aSequenceableCollection from startInteger to the receiver.
	Answer aSequenceableCollection.

	Note that the element count is in terms of the <sequencedReadableCollection argument.
	Depending on the receiver's encoding, this may not necessarily result in the receiver's
	position advancing by the same count. "

	^collection
		encodeOn: self
		next: sizeInteger
		putAll: aSequenceableCollection
		startingAt: startInteger!

nextDWORDPut: anInteger 
	"Append a 32-bit unsigned integer representation as the next 4 bytes on the receiver."

	self nextPutAll: ((ByteArray new: 4)
				dwordAtOffset: 0 put: anInteger;
				yourself).
	^anInteger!

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
	^aCollection appendToStream: self!

nextSDWORDPut: anInteger
	"Append a 32-bit signed integer in 2's complement representation 
	as the next 4 bytes on the receiver."

	self nextPutAll: 
		((ByteArray new: 4)
			sdwordAtOffset: 0 put: anInteger;
			yourself).
	^anInteger!

on: aCollection
	collection := aCollection.
	writeLimit := collection size.
	position := readLimit := 0.
!

padTo: anInteger put: anObject
	"Align the receiver's position to the next multiple of anInteger, padding with the 
	argument, anObject.  Answer the number of elements written."

	| delta |
	delta := anInteger - (self position \\ anInteger).
	^delta = anInteger ifTrue: [0] ifFalse: [self next: delta put: anObject]!

position: anInteger
	"Set the receiver's current position reference for accessing the collection
	to the the argument, anInteger. If the argument is not within the bounds of
	the receiver's collection, report an error.
	Override to update the readLimit."

	readLimit := readLimit max: position.
	super position: anInteger!

primitiveBasicNextPut: anObject
	<primitive: 222>
	^collection at: (position := position + 1) put: anObject!

primitiveNextPut: anObject
	<primitive: 66>
	position := collection encodedAt: position + 1 put: anObject!

reset
	readLimit := readLimit max: position.
	position := 0!

setToEnd
	"Set the receivers position reference to the end of the collection,
	updating the readLimit if necessary."

	position := self size!

space
	"Store a space character as the next element of the receiver"

	self nextPut: $\x20!

tab
	"Store a tab character as the next element of the receiver"

	self nextPut: $\t!

tab: tabCount
	"Append the specified number of tabs to the receiver."

	tabCount timesRepeat: [self tab]! !
!WriteStream categoriesFor: #<<!accessing!public! !
!WriteStream categoriesFor: #basicNext:putAll:startingAt:!accessing!private! !
!WriteStream categoriesFor: #basicNextPut:!accessing!private! !
!WriteStream categoriesFor: #basicNextPutAll:!accessing!private! !
!WriteStream categoriesFor: #basicPrint:!printing!private! !
!WriteStream categoriesFor: #binaryStore:!binary filing!public!storing! !
!WriteStream categoriesFor: #contents!accessing!public! !
!WriteStream categoriesFor: #cr!accessing!public! !
!WriteStream categoriesFor: #crtab!accessing!public! !
!WriteStream categoriesFor: #crtab:!accessing!public! !
!WriteStream categoriesFor: #grabContents!accessing!public! !
!WriteStream categoriesFor: #growCollection!operations!private! !
!WriteStream categoriesFor: #initialize!initializing!private! !
!WriteStream categoriesFor: #isWriteable!public!testing! !
!WriteStream categoriesFor: #moveToEnd!positioning!private! !
!WriteStream categoriesFor: #next!accessing!public! !
!WriteStream categoriesFor: #next:put:!accessing!public! !
!WriteStream categoriesFor: #next:putAll:startingAt:!accessing!public! !
!WriteStream categoriesFor: #nextDWORDPut:!binary filing!public! !
!WriteStream categoriesFor: #nextPut:!accessing!public! !
!WriteStream categoriesFor: #nextPutAll:!accessing!public! !
!WriteStream categoriesFor: #nextSDWORDPut:!binary filing!public! !
!WriteStream categoriesFor: #on:!initializing!private! !
!WriteStream categoriesFor: #padTo:put:!positioning!public! !
!WriteStream categoriesFor: #position:!positioning!public! !
!WriteStream categoriesFor: #primitiveBasicNextPut:!accessing!private! !
!WriteStream categoriesFor: #primitiveNextPut:!accessing!private! !
!WriteStream categoriesFor: #reset!positioning!public! !
!WriteStream categoriesFor: #setToEnd!positioning!public! !
!WriteStream categoriesFor: #space!constants!public! !
!WriteStream categoriesFor: #tab!accessing!public! !
!WriteStream categoriesFor: #tab:!accessing!public! !

WriteStream methodProtocol: #puttableStream attributes: #(#ansi #readOnly) selectors: #(#cr #flush #nextPut: #nextPutAll: #space #tab)!
WriteStream methodProtocol: #WriteStream attributes: #(#ansi #readOnly) selectors: #(#close #contents #cr #flush #isEmpty #nextPut: #nextPutAll: #position #position: #reset #setToEnd #space #tab)!

!WriteStream class methodsFor!

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
!WriteStream class categoriesFor: #with:!instance creation!public! !
!WriteStream class categoriesFor: #with:from:to:!instance creation!public! !

WriteStream class methodProtocol: #'WriteStream factory' attributes: #(#ansi #readOnly) selectors: #(#with:)!

