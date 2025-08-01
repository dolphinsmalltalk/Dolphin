﻿"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Core.Stream'
	instanceVariableNames: ''
	classVariableNames: 'EndOfStreamSignal'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Core.Stream guid: (Core.GUID fromString: '{87b4c4c4-026e-11d3-9fd7-00a0cc3e4a32}')!

Core.Stream isNonInstantiable: true!

Core.Stream comment: 'Stream represents a class of objects which can be used for streaming I/O. Stream itself is abstract.

InstanceVariables
	None.

Class Variables:
	EndOfStreamSignal	<exceptionSignaler/exeptionSelector>. Exception to mark attempts to read off the end of the stream.'!

!Core.Stream categoriesForClass!Collections-Streams! !

!Core.Stream methodsFor!

<< anObject
	"Store the argument, or the elements of the argument if it is a <collection>, as the next element or elements of the receiver."

	anObject appendToStream: self.
	^self!

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

basicNextPut: anObject
	"Private - Store anObject as the next element of the receiver."

	^self nextPut: anObject!

basicNextPutAll: aCollection
	"Private - Store the elements in the argument, aCollection, as the next elements accessible by the receiver. 
	Answer aCollection"

	^self nextPutAll: aCollection!

basicPrint: anObject
	anObject basicPrintOn: self!

close
	"Relinquish any external resources associated with the receiver, and put the
	receiver into a 'closed' state (as appropriate to the subclass). Answer the receiver."

	^self!

contentsSpecies
	"Private - Answer the class of Object to be used when answering collections of elements
	from the receiver."

	^self basicContentsSpecies!

cr
	"Store the line delimiter character sequence (as required by the environment) as the next element(s) of the receiver."

	self
		nextPut: $\r;
		nextPut: $\n!

crtab
	"Append a line-delimiter and a tab to the receiver."

	self cr; tab!

crtab: tabCount
	"Append a line-delimiter and the specified number of tabs to the receiver."

	self cr; tab: tabCount!

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

encodedSizeOf: anObject
	"Answer the number of units that would be occupied by anObject if it were present in this stream."

	^self contentsSpecies empty encodedSizeOf: anObject!

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

errorNotWriteable
	"Private - An attempt was made to write to a read-only stream. Raise an appropriate exception."

	^self error: 'The stream is not writeable'!

flush
	"Flush any buffered output."

	^self!

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

locale
	"Answer the <Locale> to be used when emitting or reading localisable data to/from this stream."

	^Locale.UserDefault!

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

	| pos last |
	last := startInteger + countInteger.
	pos := startInteger.
	[pos >= last] whileFalse: [pos := (aSequenceableCollection encodedAt: pos put: self next) + 1].
	^aSequenceableCollection!

next: anInteger put: anObject
	"Store the argument, anObject, as the next anInteger number of elements accessible by the receiver. 
	Answer anObject."

	anInteger timesRepeat: [self nextPut: anObject].
	^anObject!

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

nextInt32Put: anInteger
	"Append a 32-bit signed integer in 2's complement representation 
	as the next 4 bytes on the receiver."

	self nextPutAll: ((ByteArray new: 4)
				int32AtOffset: 0 put: anInteger;
				yourself).
	^anInteger!

nextInto: aSequenceableCollection
	"Destructively replace all elements of the argument, aSequenceableCollection,
	with the next elements of the receiver. Answer aSequenceableCollection."

	^self next: aSequenceableCollection size into: aSequenceableCollection startingAt: 1!

nextMatchFor: anObject 
	"Access the next object and answer whether it is equal to the argument, anObject. Raise an
	end of stream exception (via #next) if there are no more elements in the receiver."

	^anObject = self next!

nextPut: anObject
	"Store anObject as the next element of the receiver."

	self errorNotWriteable!

nextPutAll: aCollection
	"Store the elements in the argument, aCollection, as the next elements accessible by the receiver. 
	Answer aCollection"

	aCollection do: [:each | self nextPut: each].
	^aCollection!

nextUInt32Put: anInteger
	"Append a 32-bit unsigned integer representation as the next 4 bytes on the receiver."

	self nextPutAll: ((ByteArray new: 4)
				uint32AtOffset: 0 put: anInteger;
				yourself).
	^anInteger!

print: anObject
	"Ask anObject to append its textual description to the receiver"

	anObject printOn: self!

skip: anInteger
	"Set the receiver's position reference to be the current position plus
	the argument, anInteger, possibly adjusting the result so as to remain
	within the bounds of the collection."

	anInteger < 0 ifTrue: [self error: 'Cannot move backwards in non-positionable stream'].
	anInteger timesRepeat: [self next]!

skipThrough: anObject 
	"Set the receiver's position reference to be past the next occurrence of the argument,
	anObject, in the collection. Answer the receiver, or nil if no such occurrence existed."

	"Included for compatibility with VisualWorks - the ANSI standard message #skipTo: should be
	used in preference"

	[self atEnd] whileFalse: [self next = anObject ifTrue: [^self]].
	^nil!

skipTo: anObject 
	"Set the receiver's position reference to be past the next occurrence of the argument,
	anObject, in the collection. Answer whether such an occurrence existed."

	[self atEnd] whileFalse: [self next = anObject ifTrue: [^true]].
	^false!

space
	"Store a space character as the next element of the receiver"

	self nextPut: $\x20!

store: anObject
	"Ask anObject to append its storeString to the receiver."

	anObject storeOn: self!

tab
	"Store a tab character as the next element of the receiver"

	self nextPut: $\t!

tab: tabCount
	"Append the specified number of tabs to the receiver."

	tabCount timesRepeat: [self tab]!

visit: anObject do: aNiladicValue
	aNiladicValue value! !

!Core.Stream categoriesForMethods!
<<!public!writing! !
atEnd!public!testing! !
basicContentsSpecies!accessing!private! !
basicNext!public!reading! !
basicNext:!private!reading! !
basicNext:into:startingAt:!private!reading! !
basicNextAvailable:!private!reading! !
basicNextPut:!private!writing! !
basicNextPutAll:!private!writing! !
basicPrint:!printing!public! !
close!operations!public! !
contentsSpecies!constants!private! !
cr!public!writing! !
crtab!public!writing! !
crtab:!public!writing! !
display:!printing!public! !
do:!enumerating!public! !
elementSize!constants!public! !
encodedSizeOf:!encode/decode!public! !
encoding!constants!encode/decode!public! !
errorEndOfStream!exceptions!public! !
errorNotPositionable!exceptions!private! !
errorNotReadable!exceptions!private! !
errorNotWriteable!exceptions!private! !
flush!operations!public! !
isPositionable!public!testing! !
isReadable!public!testing! !
isWriteable!public!testing! !
locale!accessing!public! !
next!public!reading! !
next:!public!reading! !
next:into:startingAt:!public!reading! !
next:put:!public!writing! !
nextAvailable!public!reading! !
nextAvailable:!public!reading! !
nextInt32Put:!public!writing! !
nextInto:!public!reading! !
nextMatchFor:!public!reading! !
nextPut:!public!writing! !
nextPutAll:!public!writing! !
nextUInt32Put:!public!writing! !
print:!printing!public! !
skip:!positioning!public! !
skipThrough:!positioning!public! !
skipTo:!positioning!public! !
space!public!writing! !
store:!printing!public! !
tab!public!writing! !
tab:!public!writing! !
visit:do:!operations!public! !
!

!Core.Stream class methodsFor!

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

!Core.Stream class categoriesForMethods!
endOfStreamSignal!constants!public! !
initialize!development!initializing!private! !
new!instance creation!public! !
!

