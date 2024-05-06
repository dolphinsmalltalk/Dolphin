"Filed out from Dolphin Smalltalk"!

Object subclass: #Stream
	instanceVariableNames: ''
	classVariableNames: 'EndOfStreamSignal'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

Stream guid: (GUID fromString: '{87b4c4c4-026e-11d3-9fd7-00a0cc3e4a32}')!

Stream isAbstract: true!

Stream comment: 'Stream represents a class of objects which can be used for streaming I/O. Stream itself is abstract.

InstanceVariables
	None.

Class Variables:
	EndOfStreamSignal	<exceptionSignaler/exeptionSelector>. Exception to mark attempts to read off the end of the stream.'!

!Stream categoriesForClass!Collections-Streams! !

!Stream methodsFor!

atEnd
	"Answer whether the receiver is at the end of its values."

	^self subclassResponsibility!

basicContentsSpecies
	"Private - Answer the class of Object to be used when answering collections of undecoded
	elements from the receiver."

	^Array!

basicNext
	"Answer the next raw element accessible by the receiver."

	"For all but encoded streams this is the same as #next"

	^self next!

basicNext: anInteger
	"Private - Answer a <sequencedReadableCollection> containing the next anInteger number of objects
	accessible by the receiver."

	| newStream |
	newStream := self contentsSpecies writeStream: anInteger.
	anInteger timesRepeat: [newStream basicNextPut: self basicNext].
	^newStream contents!

basicNext: countInteger into: aSequenceableCollection startingAt: startInteger 
	"Private - Destructively replace the elements of the <sequenceableCollection> argument in the
	<integer> interval (startAt..startAt+count-1) with the next countInteger undecoded elements
	of the receiver. Answer aSequenceableCollection."

	"Implementation Note: This will fail if the receiver is not readable."

	startInteger to: startInteger + countInteger - 1
		do: [:i | aSequenceableCollection basicAt: i put: self basicNext].
	^aSequenceableCollection!

basicNextAvailable: anInteger
	"Private - Answer up to anInteger undecoded elements of the receiver's collection. Generally, the
	answer will be a collection of the same class as the one accessed by the receiver (though
	this is determined by the receiver), and will contain anInteger undecoded elements, or as
	many as are left in the receiver's collection."

	| writeStream count |
	count := 0.
	writeStream := self basicContentsSpecies writeStream: anInteger.
	[count == anInteger or: [self atEnd]] whileFalse: 
			[writeStream basicNextPut: self basicNext.
			count := count + 1].
	^writeStream grabContents!

close
	"Relinquish any external resources associated with the receiver, and put the
	receiver into a 'closed' state (as appropriate to the subclass). Answer the receiver."

	^self!

contentsSpecies
	"Private - Answer the class of Object to be used when answering collections of elements
	from the receiver."

	^Array!

display: anObject
	"Ask anObject to append its end-user textual description to the receiver."

	anObject displayOn: self!

do: aMonadicValuable 
	"Evaluate the <monadicValuable> argument for each of the receiver's future sequence values,
	terminating only when there are no more future sequence values (i.e. the stream is at an
	end). N.B. If evaluating the valuable has side effects on the receiver stream, then the
	behaviour is undefined."

	[self atEnd] whileFalse: [aMonadicValuable value: self next]!

elementSize
	"Answer the size in bytes of the streamed over elements. It is an error if the stream has #pointers encoding. For example this is 1 for a #utf8 stream because each UTF-8 code unit requires one byte (and each UTF-8 code point may requried between 1 and 4 code units)."

	^self contentsSpecies elementSize!

encoding
	"Answer the encoding of the stream, one of:
	- #binary, e.g. a stream over a ByteArray
	- #pointers, e.g. a Stream over an Array
	- #ansi, a Stream over an AnsiString
	- #utf8, a Stream over a Utf8String
	- #utf16le, a Stream over a Utf16String
	- #utf32, a Stream over a Utf32String."

	^self contentsSpecies encoding!

errorEndOfStream
	"Raise an error to the effect that an attempt was made to read off the end of the collection
	over which the receiver is streaming."

	^self class endOfStreamSignal signalWith: self!

errorNotPositionable
	^self error: 'The stream is not positionable'!

errorNotReadable
	"Private - An attempt was made to read from a write-only stream. Raise an appropriate exception."

	^self error: 'The stream is not readable'!

isPositionable
	"Answer whether the receiver supports the #position[:] messages for querying and setting its position in the data stream."

	^false!

isReadable
	"Answer whether the receiver can be read from (i.e. it implements the gettableStream
	protocol)."

	^false!

isWriteable
	"Answer whether the receiver can be written to (i.e. it implements the puttableStream
	protocol)."

	^false!

next
	"Answer the next object accessible by the receiver."

	"Implementation Note: Must be defined by subclasses which wish to implement the 
	<gettableStream> protocol."

	^self errorNotReadable!

next: anInteger
	"Answer a <sequencedReadableCollection> containing the next anInteger number of objects
	accessible by the receiver."

	| writeStream |
	writeStream := self contentsSpecies writeStream: anInteger.
	anInteger timesRepeat: [writeStream nextPut: self next].
	^writeStream grabContents!

next: countInteger into: aSequenceableCollection startingAt: startInteger
	"Destructively replace the elements of the <sequenceableCollection> argument in the
	<integer> interval (startAt..startAt+count-1) with the next countInteger elements of the
	receiver. Answer aSequenceableCollection."

	| last pos |
	last := startInteger + countInteger.
	pos := startInteger.
	[pos >= last] whileFalse: [pos := (aSequenceableCollection encodedAt: pos put: self next) + 1].
	^aSequenceableCollection!

nextAvailable
	"Answer the next of the receiver's future sequence values, or nil if at the end of the stream."

	^self atEnd ifFalse: [self next]!

nextAvailable: anInteger
	"Answer up to anInteger elements of the receiver's collection. Generally, the answer will be
	a collection of the same class as the one accessed by the receiver (though this is
	determined by the receiver), and will contain anInteger elements, or as many as are left in
	the receiver's collection."

	| newStream count |
	newStream := self contentsSpecies writeStream: (count := anInteger).
	[count == 0 or: [self atEnd]] whileFalse: 
			[newStream nextPut: self next.
			count := count - 1].
	^newStream contents!

nextInto: aSequenceableCollection
	"Destructively replace all elements of the argument, aSequenceableCollection,
	with the next elements of the receiver. Answer aSequenceableCollection."

	^self next: aSequenceableCollection size into: aSequenceableCollection startingAt: 1!

nextMatchFor: anObject 
	"Access the next object and answer whether it is equal to the argument, anObject. Raise an
	end of stream exception (via #next) if there are no more elements in the receiver."

	^anObject = self next!

print: anObject
	"Ask anObject to append its textual description to the receiver"

	anObject printOn: self!

skipThrough: anObject 
	"Set the receivers position reference to be past the next occurrence of the argument,
	anObject, in the collection. Answer the receiver, or nil if no such occurrence existed."

	"Included for compatibility with VisualWorks - the ANSI standard message #skipTo: should be
	used in preference"

	[self atEnd] whileFalse: [self next = anObject ifTrue: [^self]].
	^nil!

skipTo: anObject 
	"Set the receivers position reference to be past the next occurrence of the argument,
	anObject, in the collection. Answer whether such an occurrence existed."

	[self atEnd] whileFalse: [self next = anObject ifTrue: [^true]].
	^false!

store: anObject
	"Ask anObject to append its storeString to the receiver."

	anObject storeOn: self!

upTo: anObject
	"Answer a collection of elements starting with the next element accessed by the receiver,
	and up to, not inclusive of, the next element that is equal to anObject. Positions the
	stream after anObject if found. If anObject is not in the collection, answer the entire rest
	of the collection. If the receiver is at its end, answer an empty Collection."

	| newStream nextObject |
	newStream := self contentsSpecies writeStream: 128.
	[self atEnd or: [(nextObject := self next) = anObject]] whileFalse: [newStream nextPut: nextObject].
	^newStream contents!

upToEnd
	"Answer a collection consisting of the future sequence values of the receiver (i.e. from the
	current position to the end)."

	| remainder |
	remainder := self contentsSpecies writeStream: 128.
	[self atEnd] whileFalse: [remainder nextPut: self next].
	^remainder contents! !

!Stream categoriesForMethods!
atEnd!public!testing! !
basicContentsSpecies!accessing!private! !
basicNext!accessing!public! !
basicNext:!accessing!private! !
basicNext:into:startingAt:!accessing!private! !
basicNextAvailable:!accessing!private! !
close!operations!public! !
contentsSpecies!constants!private! !
display:!printing!public! !
do:!enumerating!public! !
elementSize!constants!public! !
encoding!constants!public! !
errorEndOfStream!exceptions!public! !
errorNotPositionable!exceptions!private! !
errorNotReadable!exceptions!private! !
isPositionable!public!testing! !
isReadable!public!testing! !
isWriteable!public!testing! !
next!accessing!public! !
next:!accessing!public! !
next:into:startingAt:!accessing!public! !
nextAvailable!accessing!public! !
nextAvailable:!accessing!public! !
nextInto:!accessing!public! !
nextMatchFor:!accessing!public! !
print:!printing!public! !
skipThrough:!positioning!public! !
skipTo:!positioning!public! !
store:!printing!public! !
upTo:!accessing!public! !
upToEnd!accessing!public! !
!

!Stream class methodsFor!

endOfStreamSignal
	"Answer an exceptionSignaler/exceptionSelector object raised when an attempt is 
	made to read off the end of the stream. Those interested in catching end of 
	Stream exceptions should use this accessor to get the exceptionSelector to pass
	as the first parameter to an #on:do: message. Current the answer is a Signal
	instance, but it could be an Exception subclass in future."

	^EndOfStreamSignal!

initialize
	"Private - Initialize the receiver's class variables.
		Stream initialize
	"

	EndOfStreamSignal := Signal description: 'End of stream'!

new
	"Streams must be instantiated onto something."

	^self shouldNotImplement! !

!Stream class categoriesForMethods!
endOfStreamSignal!constants!public! !
initialize!development!initializing!private! !
new!instance creation!public! !
!

