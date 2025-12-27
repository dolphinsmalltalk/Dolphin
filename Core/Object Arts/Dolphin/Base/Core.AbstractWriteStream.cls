"Filed out from Dolphin Smalltalk"!

Core.PositionableStream
	subclass: #'Core.AbstractWriteStream'
	instanceVariableNames: 'writeLimit'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Core.AbstractWriteStream guid: (Core.GUID fromString: '{4af177af-5e8f-4e09-b3af-23d85c150cb4}')!

Core.AbstractWriteStream isNonInstantiable: true!

Core.AbstractWriteStream comment: '`AbstractWriteStream` is an abstract class of writeable (and in some cases readable) `PositionableStream`s. Subclasses conform to at least the ANSI `<puttableStream>` protocol.

## Instance Variables:
  `writeLimit`		`<integer>`

'!

!Core.AbstractWriteStream methodsFor!

basicNext: countInteger putAll: aSequenceableCollection startingAt: startInteger
	"Private - Append countInteger elements of aSequenceableCollection from startInteger to the receiver. Answer aSequenceableCollection."

	| stop |
	stop := position + countInteger.
	stop <= writeLimit
		ifTrue: 
			["The block fits into the current collection and can be written directly"
			collection
				replaceFrom: position + 1
				to: stop
				with: aSequenceableCollection
				startingAt: startInteger.
			position := stop]
		ifFalse: 
			["The block will not fit within the current collection, so fall back on a (probably) slower way"
			self
				overflowBasicNext: countInteger
				putAll: aSequenceableCollection
				startingAt: startInteger].
	^aSequenceableCollection!

basicNextPut: anObject
	"Private - Store anObject as the next element of the receiver.  If the receiver is not stream over an Array or a String, or if the Array or String becomes full, then the primitive will fail, and the backup Smalltalk code will be activated, grow the collection, and attempt to insert the object directly."

	<primitive: 222>
	position < writeLimit
		ifTrue: [collection at: (position := position + 1) put: anObject]
		ifFalse: [self overflowBasicNextPut: anObject].
	^anObject!

basicNextPutAll: aCollection
	"Private - Store the elements in the argument, aCollection, as the next elements accessible by the receiver. Answer aCollection"

	<primitive: 173>
	aCollection do: [:each | self nextPut: each]!

initialize
	"Private - Intitialise the receiver."

	position := readLimit := 0.
	writeLimit := collection size!

isWriteable
	"Answer whether the receiver can be written to (i.e. it implements the 
	puttableStream protocol)."

	^true!

nextPut: anObject
	"Store anObject as the next element of the receiver.  If the receiver is not stream over an Array or a String, or if there is insufficient capacity to put the argument, then the primitive will fail, and the backup Smalltalk code will be activated."

	<primitive: 66>
	_failureCode == _PrimitiveFailureCode.OutOfBounds
		ifTrue: [self overflowNextPut: anObject]
		ifFalse: [collection encodeOn: self put: anObject].
	^anObject!

nextPutAll: aCollection
	"Store the elements in the argument, aCollection, as the next elements accessible by the receiver. 
	Answer aCollection"

	<primitive: 173>
	_failureCode == _PrimitiveFailureCode.OutOfBounds
		ifTrue: [self overflowNextPutAll: aCollection]
		ifFalse: [aCollection appendToStream: self].
	^aCollection!

on: aCollection
	writeLimit := (collection := aCollection) size.
	position := readLimit := 0.
	locale := Locale.UserDefault!

overflowBasicNext: countInteger putAll: aSequenceableCollection startingAt: startInteger
	startInteger to: startInteger + countInteger - 1
		do: [:i | self basicNextPut: (aSequenceableCollection basicAt: i)]!

overflowBasicNextPut: anObject
	self subclassResponsibility!

overflowNextPut: anObject
	"Private - A #nextPut: operation would exceed the current write limit. The response to this depends on the subclass, but may include growing the target to increase the write limit before trying again, or flushing buffered content to make room."

	collection encodeOn: self put: anObject!

overflowNextPutAll: aCollection
	"Private - A #nextPutAll: operation would exceed the current write limit. The response to this depends on the subclass, but may include growing the target to increase the write limit before trying again, or flushing buffered content to make room."

	aCollection appendToStream: self!

padTo: anInteger put: anObject
	"Align the receiver's position to the next multiple of anInteger, padding with the 
	argument, anObject.  Answer the number of elements written."

	| delta |
	delta := anInteger - (self position \\ anInteger).
	^delta = anInteger ifTrue: [0] ifFalse: [self next: delta put: anObject]!

peekFor: anObject
	"Determine the response to the message peek. If it is the same as the argument, anObject, then advance the current position and answer true. Otherwise answer false and do not change the current position."

	self errorNotReadable!

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
	position := collection encodedAt: position + 1 put: anObject.
	^anObject!

primitiveNextPutAll: aCollection
	<primitive: 173>
	^aCollection appendToStream: self!

reset
	readLimit < position ifTrue: [readLimit := position].
	position := 0! !

!Core.AbstractWriteStream categoriesForMethods!
basicNext:putAll:startingAt:!private!writing! !
basicNextPut:!private!writing! !
basicNextPutAll:!private!writing! !
initialize!initializing!private! !
isWriteable!public!testing! !
nextPut:!public!writing! !
nextPutAll:!public!writing! !
on:!initializing!private! !
overflowBasicNext:putAll:startingAt:!private!writing! !
overflowBasicNextPut:!private!writing! !
overflowNextPut:!private!writing! !
overflowNextPutAll:!private!writing! !
padTo:put:!public!writing! !
peekFor:!public!reading! !
position:!positioning!public! !
primitiveBasicNextPut:!private!writing! !
primitiveNextPut:!private!writing! !
primitiveNextPutAll:!private!writing! !
reset!positioning!public! !
!

Core.AbstractWriteStream methodProtocol: #puttableStream attributes: #(#ansi #readOnly) selectors: #(#cr #flush #nextPut: #nextPutAll: #space #tab)!

