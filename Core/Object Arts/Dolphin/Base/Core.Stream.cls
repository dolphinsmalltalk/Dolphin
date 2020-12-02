"Filed out from Dolphin Smalltalk 7"!

Object subclass: #Stream
	instanceVariableNames: ''
	classVariableNames: 'EndOfStreamSignal'
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Stream guid: (GUID fromString: '{87b4c4c4-026e-11d3-9fd7-00a0cc3e4a32}')!
Stream isAbstract: true!
Stream comment: 'Stream represents a class of objects which can be used for streaming I/O. Stream itself is abstract.

InstanceVariables
	None.

Class Variables:
	EndOfStreamSignal	<exceptionSignaler/exeptionSelector>. Exception to mark attempts to read off the end of the stream.'!
!Stream categoriesForClass!Collections-Streams! !
!Stream methodsFor!

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

basicNext: countInteger putAll: aSequenceableCollection startingAt: startInteger
	"Private - Append countInteger elements of aSequenceableCollection from startInteger
	to the receiver. Answer aSequenceableCollection."

	^self
		next: countInteger
		putAll: aSequenceableCollection
		startingAt: startInteger!

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

binaryStore: anObject
	"Ask anObject to append to the receiver binary byte which when
	read will result in an Object equivalent to anObject"

	anObject binaryStoreOn: self
!

close
	"Relinquish any external resources associated with the receiver, and put the
	receiver into a 'closed' state (as appropriate to the subclass). Answer the receiver."

	^self!

contentsSpecies
	"Private - Answer the class of Object to be used when answering collections of elements
	from the receiver."

	^Array!

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
	"Answer the <Locale> to be used when emitting or reaading localisable data to/from this stream."

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

	| last pos |
	last := startInteger + countInteger.
	pos := startInteger.
	[pos >= last] whileFalse: [pos := (aSequenceableCollection encodedAt: pos put: self next) + 1].
	^aSequenceableCollection!

next: anInteger put: anObject
	"Store the argument, anObject, as the next anInteger number of elements accessible by the receiver. 
	Answer anObject."

	anInteger timesRepeat: [self nextPut: anObject].
	^anObject!

next: countInteger putAll: aSequenceableCollection startingAt: startInteger
	"Append countInteger elements of aSequenceableCollection from startInteger to the receiver. Answer aSequenceableCollection."

	self nextPutAll: ((startInteger == 1 and: [countInteger == aSequenceableCollection size])
				ifTrue: [aSequenceableCollection]
				ifFalse: [aSequenceableCollection copyFrom: startInteger to: startInteger + countInteger - 1]).
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

nextDWORDPut: anInteger 
	"Append a 32-bit unsigned integer representation as the next 4 bytes on the receiver."

	self nextPutAll: ((ByteArray new: 4)
				dwordAtOffset: 0 put: anInteger;
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

nextSDWORDPut: anInteger
	"Append a 32-bit signed integer in 2's complement representation 
	as the next 4 bytes on the receiver."

	self nextPutAll: 
		((ByteArray new: 4)
			sdwordAtOffset: 0 put: anInteger;
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
	^remainder contents!

visit: anObject do: aNiladicValue
	aNiladicValue value! !
!Stream categoriesFor: #<<!accessing!public! !
!Stream categoriesFor: #atEnd!public!testing! !
!Stream categoriesFor: #basicContentsSpecies!accessing!private! !
!Stream categoriesFor: #basicNext!accessing!public! !
!Stream categoriesFor: #basicNext:!accessing!private! !
!Stream categoriesFor: #basicNext:into:startingAt:!accessing!private! !
!Stream categoriesFor: #basicNext:putAll:startingAt:!accessing!private! !
!Stream categoriesFor: #basicNextAvailable:!accessing!private! !
!Stream categoriesFor: #basicNextPut:!accessing!private! !
!Stream categoriesFor: #basicNextPutAll:!accessing!private! !
!Stream categoriesFor: #basicPrint:!public! !
!Stream categoriesFor: #binaryStore:!binary filing!public!storing! !
!Stream categoriesFor: #close!operations!public! !
!Stream categoriesFor: #contentsSpecies!constants!private! !
!Stream categoriesFor: #cr!accessing!public! !
!Stream categoriesFor: #crtab!accessing!public! !
!Stream categoriesFor: #crtab:!accessing!public! !
!Stream categoriesFor: #display:!printing!public! !
!Stream categoriesFor: #do:!enumerating!public! !
!Stream categoriesFor: #elementSize!constants!public! !
!Stream categoriesFor: #encodedSizeOf:!encode/decode!public! !
!Stream categoriesFor: #encoding!constants!encode/decode!public! !
!Stream categoriesFor: #errorEndOfStream!exceptions!public! !
!Stream categoriesFor: #errorNotPositionable!exceptions!private! !
!Stream categoriesFor: #errorNotReadable!exceptions!private! !
!Stream categoriesFor: #errorNotWriteable!exceptions!private! !
!Stream categoriesFor: #isPositionable!public!testing! !
!Stream categoriesFor: #isReadable!public!testing! !
!Stream categoriesFor: #isWriteable!public!testing! !
!Stream categoriesFor: #locale!accessing!public! !
!Stream categoriesFor: #next!accessing!public! !
!Stream categoriesFor: #next:!accessing!public! !
!Stream categoriesFor: #next:into:startingAt:!accessing!public! !
!Stream categoriesFor: #next:put:!accessing!public! !
!Stream categoriesFor: #next:putAll:startingAt:!accessing!public! !
!Stream categoriesFor: #nextAvailable!accessing!public! !
!Stream categoriesFor: #nextAvailable:!accessing!public! !
!Stream categoriesFor: #nextDWORDPut:!binary filing!public! !
!Stream categoriesFor: #nextInto:!accessing!public! !
!Stream categoriesFor: #nextMatchFor:!accessing!public! !
!Stream categoriesFor: #nextPut:!accessing!public! !
!Stream categoriesFor: #nextPutAll:!accessing!public! !
!Stream categoriesFor: #nextSDWORDPut:!binary filing!public! !
!Stream categoriesFor: #print:!printing!public! !
!Stream categoriesFor: #skip:!positioning!public! !
!Stream categoriesFor: #skipThrough:!positioning!public! !
!Stream categoriesFor: #skipTo:!positioning!public! !
!Stream categoriesFor: #space!constants!public! !
!Stream categoriesFor: #store:!printing!public! !
!Stream categoriesFor: #tab!accessing!public! !
!Stream categoriesFor: #tab:!accessing!public! !
!Stream categoriesFor: #upTo:!accessing!public! !
!Stream categoriesFor: #upToEnd!accessing!public! !
!Stream categoriesFor: #visit:do:!public! !

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
!Stream class categoriesFor: #endOfStreamSignal!constants!public! !
!Stream class categoriesFor: #initialize!development!initializing!private! !
!Stream class categoriesFor: #new!instance creation!public! !

