"Filed out from Dolphin Smalltalk X6.1"!

ArrayedCollection variableByteSubclass: #ByteArray
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ByteArray guid: (GUID fromString: '{87B4C511-026E-11D3-9FD7-00A0CC3E4A32}')!
ByteArray comment: 'ByteArray is the class of <ArrayedCollection>s whose elements are bytes (i.e. <integer>s in the range 0..255).

ByteArray complies with the ANSI protocols:
	Object
	collection
	sequencedReadableCollection
	sequencedCollection
	ByteArray'!
!ByteArray categoriesForClass!Collections-Arrayed! !
!ByteArray methodsFor!

_sameAsString: comparand
	"Private - Answer whether the receiver collates the same as <readableString> 
	argument, comparand.
	This will only work if the receiver contains integers in the range of character
	values, if not an exception will be raised.
	Implementation Note: Double dispatched from String>>sameAs:."

	^(comparand _collate: self asString) == 0!

= comperand
	"Answer whether the receiver is equivalent to the <Object>, comperand.
	Uses standard byte comparison primitive which checks for identical bytes and size.

	Primitive failure reasons:
		0 -	comperand is not the same class as the receiver."

	<primitive: 55>
	^false!

addressAtOffset: anInteger 
	"Answer the 32-bit address stored at the specified offset in the receiver."

	^(self dwordAtOffset: anInteger) asExternalAddress!

asByteArray
	"Answer a <ByteArray> containing the same elements as the receiver.
	In this case no conversion is required."

	^self!

asString
	"Answer a byte String containing the same elements as the receiver."

	| size |
	size := self basicSize.
	^(String new: size) replaceFrom: 1 to: size with: self startingAt: 1!

basicDwordAtOffset: anInteger
	"Answer the unsigned 4 byte integer at offset (i.e. zero relative) 
	anInteger in the receiver.

	Primitive failure reasons:
		0 -	anInteger is not a SmallInteger
		1 -	anInteger is out of bounds (not in the range 1..receiver's size - 4)."

	| answer offset |
	<primitive: 120>
	offset := anInteger + 1.
	answer := 0.
	3 to: 0 by: -1 do: [:i |
		answer := (answer bitShift: 8) + (self basicAt: offset + i)].
	^answer
!

basicDwordAtOffset: anInteger put: anObject 
	"Private - Replace the internal contents of the receiver from offset anInteger with
	the first 4 bytes of anObject."

	<primitive: 121>
	(self validateOffset: anInteger forUpdate: true) == 2 
		ifTrue: 
			["Not a suitable value - could be non-Numeric, or not in unsigned 32-bit range.
			Atempt to coerce to Integer and retry. anObject may not understand asInteger."
			| intVal |
			intVal := anObject asInteger.
			(intVal >= 0 and: [intVal <= 16rFFFFFFFF]) 
				ifTrue: [^self basicDwordAtOffset: anInteger put: intVal]].
	^self errorCantHold: anObject!

basicUIntPtrAtOffset: anInteger 
	"Answer the unsigned machine word sized integer at offset (i.e. zero relative) 
	anInteger in the receiver.

	Primitive failure reasons:
		0 -	anInteger is not a SmallInteger
		1 -	anInteger is out of bounds (not in the range 1..receiver's size - sizeof(UINT_PTR))."

	| answer offset |
	<primitive: 120>
	offset := anInteger + 1.
	answer := 0.
	VMConstants.IntPtrSize to: 0
		by: -1
		do: [:i | answer := (answer bitShift: 8) + (self basicAt: offset + i)].
	^answer!

basicUIntPtrAtOffset: anInteger put: anObject 
	"Private - Replace the internal contents of the receiver from offset anInteger with
	the first machine word of anObject."

	<primitive: 121>
	(self validateOffset: anInteger forUpdate: true) == 2 
		ifTrue: 
			["Not a suitable value - could be non-Numeric, or not in unsigned machine word range.
			Atempt to coerce to Integer and retry. anObject may not understand asInteger."
			| intVal |
			intVal := anObject asInteger.
			(intVal >= 0 and: [intVal <= VMConstants.UIntPtrMax]) 
				ifTrue: [^self basicUIntPtrAtOffset: anInteger put: intVal]].
	^self errorCantHold: anObject!

byteAtOffset: anInteger
	"Answer the byte at offset anInteger in the receiver"

	^self basicAt: anInteger+1!

byteAtOffset: anInteger put: aByte
	"Replace the byte of the receiver at offset anInteger with aByte. Answer aByte."

	^self basicAt: anInteger+1 put: aByte
!

bytesAtOffset: anInteger put: anExternalStructureOrByteObject
	"Replace the bytes of the receiver from offset anInteger (0 based)
	with those of the argument aVariableByteObject"

	self replaceFrom: anInteger+1 
		to: anInteger + anExternalStructureOrByteObject size
		with: anExternalStructureOrByteObject
		startingAt: 1!

byteSize
	"Private - Answer the size in bytes of this structure."

	^self basicSize!

copy: aByteClass from: start to: stop 
	"Private - Answer a copy of the bytes of the receiver starting at index start, 
	until index stop, inclusive, as an instance of the argument, aByteClass."

	| len |
	len := stop - start + 1.
	^self 
		replaceBytesOf: (aByteClass new: len)
		from: 1
		to: len
		startingAt: start!

copyStringFrom: start to: stop
	"Answer a copy of the bytes of the receiver starting at index start, 
	until index stop, inclusive, as a String."

	^self copy: String from: start to: stop!

doubleAtOffset: anInteger
	"Answer the double precision floating point value at offset (i.e. zero relative) 
	anInteger in the receiver, as a Smalltalk Float object (double precision).

	Primitive failure reasons:
		0 -	anInteger is not a SmallInteger
		1 -	anInteger is out of bounds (not in the range 1..receiver's size - 8)."

	<primitive: 128>
	self validateOffset: anInteger forUpdate: false.
	^self primitiveFailed!

doubleAtOffset: anInteger put: aFloat 
	"Store the Smalltalk floating point Number, aFloat, as a double precision
	floating point value (e.g. a C double) at byte offset (i.e. zero based) anInteger 
	within the receiver. 

	Primitive failure reasons:
		0 -	anInteger is not a SmallInteger
		1 -	anInteger is out of bounds (not in the range 1..receiver's size - 8).
		2 -	aFloat is not a Float.

	If the argument is not a float, then the primitive is retried having converted it
	to a Float. This allows other number types to be passed as arguments."

	<primitive: 129>
	(self validateOffset: anInteger forUpdate: true) == 2 
		ifTrue: 
			[self doubleAtOffset: anInteger put: aFloat asFloat.
			^aFloat].	"coerce to float and retry"
	^self primitiveFailed!

dwordAtOffset: anInteger
	"Answer the unsigned 4 byte integer at offset (i.e. zero relative) 
	anInteger IN the receiver.

	Primitive failure reasons:
		0 -	anInteger is not a SmallInteger
		1 -	anInteger is out of bounds (not in the range 1..receiver's size - 4)."

	| answer |
	<primitive: 120>
	answer := 0.
	3 to: 0 by: -1 do: [:i |
		answer := (answer bitShift: 8) + (self byteAtOffset: anInteger + i)].
	^answer!

dwordAtOffset: anInteger put: anObject
	"Store an unsigned 4 byte value at byte offset anInteger 
	within the receiver.

	Primitive failure reasons:
		0 -	anInteger is not a SmallInteger
		1 -	anInteger is out of bounds (not in the range 1..receiver's size - 4).
		2 -	anObject is not a SmallInteger or a 4-byte object
	"
	
	<primitive: 121>
	^self retryDwordAtOffset: anInteger put: anObject!

floatAtOffset: anInteger
	"Answer the single precision floating point value at offset (i.e. zero relative) 
	anInteger in the receiver, as a Smalltalk Float object (double precision).
	N.B. To access a double precision value (e.g. a C double) use #doubleAt:

	Primitive failure reasons:
		0 -	anInteger is not a SmallInteger
	`	1 -	anInteger is out of bounds (not in the range 1..receiver's size - 4)."

	<primitive: 130>
	self validateOffset: anInteger forUpdate: false.
	^self primitiveFailed!

floatAtOffset: anInteger put: aFloat
	"Store the Smalltalk floating point Number, aFloat, as a single precision
	floating point value (e.g. a C float) at byte offset (i.e. zero based) anInteger 
	within the receiver. N.B. Some loss of precision is likely, to store a Smalltalk
	Float as a double precision value in an ExternalBytes buffer, use #doubleAt:put:.

	Primitive failure reasons:
		0 -	anInteger is not a SmallInteger
		1 -	anInteger is out of bounds (not in the range 1..receiver's size - 4).
		2 -	aFloat is not a Float."

	<primitive: 131>
	(self validateOffset: anInteger forUpdate: true) == 2 
		ifTrue: [^self floatAtOffset: anInteger put: aFloat asFloat].	"coerce to float and retry"
	^self primitiveFailed!

hash
	"Hash the bytes of the object using the standard byte hashing
	primitive (which should not fail)."

	<primitive: 106>
	^VMLibrary default hashBytes: self count: self basicSize!

hexStoreOn: puttableStream
	"Print the literal string representation of the receiver to the <puttableStream>
	argument."

	puttableStream nextPut: $(; 
		print: self class; space; nextPutAll: #fromHexString:; space;
		nextPut: $'.
	self printHexOn: puttableStream.
	puttableStream nextPutAll: ''')'!

includes: target
	"Answer whether the argument, target, is one of the elements of the receiver.
	Implementation Note: Override superclass to provide a more efficient implementation."

	^self identityIncludes: target!

indexOfSubCollection: targetSequence startingAt: start
	"Answer the <integer> index of the next occurrence within the 
	receiver of the <sequencedReadableCollection> targetSequence,
	starting at the <integer> index start. If there are no such occurrences, answer 0.

	Primitive Failure Reasons:
		0	- start is not a SmallInteger
		1	- start is out of bounds (not in the range 1..receiver's indexable size) 
		2	- targetSequence is not of the same class as the receiver.

	Implementation Note: The string search primitive is implemented using the 
	Boyer-Moore algorithm unless the receiver is less than 512 bytes long, in which
	case it isn't worth initializing the skip array in most cases, so a simple brute
	force search (much like that of the superclass) is used."

	<primitive: 149>
	^super indexOfSubCollection: targetSequence startingAt: start!

intPtrAtOffset: anInteger 
	"Answer the machine word sized signed integer value (i.e. may be 32 or 64-bit, depending on
	host OS) at offset (i.e. zero relative) anInteger in the receiver. 

	Primitive failure reasons:
		0 -	anInteger is not a SmallInteger
		1 -	anInteger is out of bounds (not in the range 1..receiver's size - sizeof(INT_PTR))."

	| answer |
	<primitive: 182>
	answer := 0.
	VMConstants.IntPtrSize - 1 to: 0
		by: -1
		do: [:i | answer := (answer bitShift: 8) + (self byteAtOffset: anInteger + i)].
	answer byteSize > VMConstants.IntPtrSize ifTrue: [answer := answer bitInvert + 1].
	^answer!

intPtrAtOffset: anInteger put: anObject 
	"Store anObject as a signed machine-word sized integer at anInteger offset in the receiver. anInteger must 
	be representable in a machine word. Uses the longPtrAtOffset:put: primitive."

	| value |
	<primitive: 183>
	value := anObject asInteger.
	value byteSize > VMConstants.IntPtrSize ifFalse: [^self errorCantHold: anObject].
	1 to: VMConstants.IntPtrSize do: [:index | self at: anInteger + index put: (value digitAt: index)].
	^anObject!

isLiteral
	"Answer whether or not the receiver has a literal representation (probably its
	printString) which is directly recognised by the Compiler."

	^self class == ##(self)!

isNull
	"Answer whether the receiver is Null (i.e. equal to 0). 
	This message is useful way of testing for NULL pointers or handles."

	^false!

longDoubleAtOffset: anInteger
	"Answer the 80-bit floating point value at offset (i.e. zero relative) anInteger in the 
	receiver, as a Smalltalk Float object (i.e. 64-bit precision, so some precision may be
	lost).

	Primitive failure reasons:
		0 -	anInteger is not a SmallInteger
		1 -	anInteger is out of bounds (not in the range 1..receiver's size - 8)."

	<primitive: 159>
	self validateOffset: anInteger forUpdate: false.
	^self primitiveFailed!

notNull
	"Answer whether the receiver is not Null (i.e. not equal to 0)"

	^self isNull == false!

printHexOn: aStream
	"Append a hex string representation of the receiver to the <puttableStream> argument."

	self do: [:byte |
		aStream 
			nextPut: (Character digitValue: (byte // 16));
			nextPut: (Character digitValue: (byte \\ 16))]!

printHexString
	"Answer a hex string representation of the receiver. N.B. For reasons of backwards
	compatibility the result includes quotes, if this is not what you want then use
	#printHexOn:."

	| stream |
	stream := String writeStream: self size * 2 + 2.
	stream nextPut: $'.
	self printHexOn: stream.
	stream nextPut: $'.
	^stream contents!

printPrefixOn: aStream
	"Private - Print a prefix string for the debug representation of the receiver on aStream."

	aStream nextPutAll: '#['!

printSuffixOn: aStream
	"Private - Print a suffix string for the debug representation of the receiver on aStream."

	aStream nextPut: $]!

qwordAtOffset: offset
	"Answer an <integer> representing the unsigned 8 byte integer at 
	<integer> offset (i.e. zero relative), offset, in the receiver."

	#todo "Add a primitive (easy)".
	^((self dwordAtOffset: offset+4) bitShift: 32) +
		(self dwordAtOffset: offset)!

qwordAtOffset: offset put: value
	"Replace the unsigned 8 byte integer at <integer> offset (i.e. zero relative), offset,
	in the receiver, with the <integer> argument, value."

	self 
		dwordAtOffset: offset put: (value bitAnd: 16rFFFFFFFF);
		dwordAtOffset: offset+4 put: (value bitShift: -32)!

replaceBytesOf: aByteObject from: start to: stop startingAt: fromStart
	"Private - Standard method for transfering bytes from one variable
	byte object to another, normally double dispatched from #replaceFrom:to:with:startingAt:

	Primitive Failure Reasons:
		0 	- fromStart is not a SmallInteger.
		1	- stop is not a SmallInteger.
		2	- start is not a SmallInteger.
		3	- aByteObject is not a byte object
		4	- 'from' or 'to' interval is out-of-bounds
	"

	| fromOffset |
	<primitive: 142>
	fromOffset := fromStart - start.
	stop to: start by: -1 do: [:i | aByteObject at: i put: (self basicAt: i + fromOffset)].
	^aByteObject!

replaceFrom: start to: stop with: aByteObject startingAt: fromStart
	"Standard method for transfering bytes from one variable
	byte object to another. See String>>replaceFrom:to:with:startingAt:."

	aByteObject replaceBytesOf: self from: start to: stop startingAt: fromStart!

retryDwordAtOffset: anInteger put: anObject 
	"Private - Fallback code for storing unsigned 32-bit integer into the receiver when a
	primitive fails. Either raises an appropriate error, or converts the argument to an Integer
	and retries."

	(self validateOffset: anInteger forUpdate: true) == 2 
		ifTrue: 
			["Not a suitable value - could be non-Numeric, or not in unsigned 32-bit
			 range. Attempt to coerce to Integer and retry. anObject may not understand
			 asInteger."
			| intVal |
			intVal := anObject asInteger.
			(intVal >= 0 and: [intVal <= 16rFFFFFFFF]) ifTrue: [^self dwordAtOffset: anInteger put: intVal]].
	^self errorCantHold: anObject!

retrySWordAtOffset: anInteger put: anObject 
	"Private - Fallback code for storing signed word into the reciever when a primitive fails.
	Either raises an appropriate error, or converts the argument to an Integer and retries."

	(self validateOffset: anInteger forUpdate: true) == 2 
		ifTrue: 
			["Not a suitable value - could be non-Numeric, or not in signed 16-bit
			 range. Attempt to coerce anObject and retry. anObject may not understand
			 asInteger."
			| int |
			int := anObject asInteger.
			(int >= -16r8000 and: [int < 16r8000]) ifTrue: [^self swordAtOffset: anInteger put: int]].
	^self errorCantHold: anObject!

retryUIntPtrAtOffset: anInteger put: anObject 
	"Private - Fallback code for storing unsigned machine-word sized integer into the receiver
	when a primitive fails. Either raises an appropriate error, or converts the argument to an
	Integer and retries."

	(self validateOffset: anInteger forUpdate: true) == 2 
		ifTrue: 
			["Not a suitable value - could be non-Numeric, or not in unsigned
			 machine-word sized range. Attempt to coerce to Integer and retry. anObject
			 may not understand asInteger."
			| intVal |
			intVal := anObject asInteger.
			(intVal >= 0 and: [intVal <= VMConstants.UIntPtrMax]) ifTrue: [^self uintPtrAtOffset: anInteger put: intVal]].
	^self errorCantHold: anObject!

retryWordAtOffset: anInteger put: anObject 
	"Private - Fallback code for storing unsigned word into the reciever when a primitive fails.
	Either raises an appropriate error, or converts the argument to an Integer and retries."

	(self validateOffset: anInteger forUpdate: true) == 2 
		ifTrue: 
			["Not a suitable value - could be non-Numeric, or not in unsigned 16-bit
			 range. Attempt to coerce to Integer and retry. anObject may not understand
			 asInteger."
			| int |
			int := anObject asInteger.
			(int >= 0 and: [int <= 16rFFFF]) ifTrue: [^self wordAtOffset: anInteger put: int]].
	^self errorCantHold: anObject!

sbyteAtOffset: anInteger 
	"Answer the signed 8-bit <Integer> at offset anInteger in the receiver"

	| answer |
	answer := self byteAtOffset: anInteger.
	^answer > 127 ifTrue: [answer - 256] ifFalse: [answer]!

sbyteAtOffset: anInteger put: aByte
	"Replace the byte of the receiver at offset anInteger with aByte. Answer aByte."

	^self byteAtOffset: anInteger put: (255 bitAnd: aByte)!

sdwordAtOffset: anInteger 
	"Answers the signed 4 byte integer at byte offset anInteger in the receiver.

	Primitive failure reasons:
		0 -	anInteger is not a SmallInteger
		1 -	anInteger is out of bounds."

	| answer |
	<primitive: 122>
	answer := self dwordAtOffset: anInteger.
	^answer > 16r7FFFFFFF ifTrue: [(answer bitXor: 16rFFFFFFFF) bitInvert] ifFalse: [answer]!

sdwordAtOffset: anInteger put: anObject 
	"Store anObject as a signed integer at anInteger offset in the receiver. anInteger must 
	be representable in 32-bits. Uses the dwordAtOffset:put: primitive."

	| value |
	<primitive: 123>
	value := anObject asInteger.
	value isSDWORD ifFalse: [^self errorCantHold: anObject].
	1 to: 4 do: [:index | self basicAt: anInteger + index put: (value digitAt: index)].
	^anObject!

sqwordAtOffset: anInteger
	"Answer the signed 8 byte integer at offset (i.e. zero relative) 
	anInteger in the receiver."

	^((self sdwordAtOffset: anInteger+4) bitShift: 32) +
		(self dwordAtOffset: anInteger)!

sqwordAtOffset: offset put: value
	"Replace the signed 64-bit integer at the specified <integer> offset (i.e. zero relative)
	in the receiver, with the <integer> argument, value."

	self 
		dwordAtOffset: offset put: (value bitAnd: 16rFFFFFFFF);
		sdwordAtOffset: offset+4 put: (value bitShift: -32)!

stbSaveOn: anSTBOutFiler 
	"Save out a binary representation of the receiver to anSTBOutFiler.
	We override because we know we can use a block write here. The format
	of the serialized byte array in the resulting STB stream is the same though."

	| size |
	anSTBOutFiler writePreambleFor: self.
	size := self basicSize.
	anSTBOutFiler writeInteger: size.
	anSTBOutFiler stream 
		next: size
		putAll: self
		startingAt: 1!

storeOn: puttableStream
	"Print the literal string representation of the receiver to the <puttableStream>
	argument."

	self printPrefixOn: puttableStream.
	1 to: self size do: [:i | 
		(self at: i) printDigitsOn: puttableStream base: 10.
		puttableStream nextPut: $ ].
	self printSuffixOn: puttableStream.!

swordAtOffset: anInteger
	"Answer the signed 2 byte integer at offset (i.e. zero relative) anInteger
	in the receiver."

	| answer |
	<primitive: 126>
	answer := self wordAtOffset: anInteger.
	^answer >= 16r8000
		ifTrue: [(16r10000 - answer) negated]
		ifFalse: [answer]!

swordAtOffset: anInteger put: anObject
	"Store a signed 2 byte value at byte offset anInteger within the receiver (which is the 
	same as storing an unsigned value). If anObject is not representable as a 16-bit
	signed (Small)Integer, then raise a 'cannot hold' error.

	Primitive failure results:
		0 -	anInteger is not a SmallInteger
		1 - 	anInteger is out of bounds
		2 -	anObject is not a SmallInteger
		3 -	anObject is not in the range -32768..32767 (i.e. out of signed 16-bit range)."

	<primitive: 127>
	^self retrySWordAtOffset: anInteger put: anObject!

uintPtrAtOffset: anInteger 
	"Answer the machine word sized integer value (i.e. may be 32 or 64-bit, depending on host
	OS) at offset (i.e. zero relative) anInteger in the receiver. 

	Primitive failure reasons:
		0 -	anInteger is not a SmallInteger
		1 -	anInteger is out of bounds (not in the range 1..receiver's size - sizeof(UINT_PTR))."

	| answer |
	<primitive: 180>
	answer := 0.
	VMConstants.IntPtrSize - 1 to: 0
		by: -1
		do: [:i | answer := (answer bitShift: 8) + (self byteAtOffset: anInteger + i)].
	^answer!

uintPtrAtOffset: anInteger put: anObject 
	"Store an unsigned 4 byte value at byte offset anInteger 
	within the receiver.

	Primitive failure reasons:
		0 -	anInteger is not a SmallInteger
		1 -	anInteger is out of bounds (not in the range 1..receiver's size - sizeof(UINT_PTR)).
		2 -	anObject is not a SmallInteger or in the representable range."

	<primitive: 181>
	^self retryUIntPtrAtOffset: anInteger put: anObject!

validateOffset: anInteger forUpdate: aBoolean 
	"Private - Primitive failure checking code for validating an offset argument to be
	called immediately after a buffer accessing primitive has failed. Raises an error
	if anInteger is not a valid offset, or the primitive error code."

	| code |
	code := Processor activeProcess primitiveFailureCode.
	code < 2 
		ifTrue: 
			["Erroneous offset parameter"
		^code == 0 
			ifTrue: [Error nonIntegerIndex: anInteger]
				ifFalse: 
					[(aBoolean and: [self isImmutable]) 
						ifTrue: [Processor constWriteSignal signalWith: self]
						ifFalse: [self errorSubscriptBounds: anInteger]]].
	^code!

wordAtOffset: anInteger
	"Answer the unsigned 2 byte integer at offset (i.e. zero relative) anInteger in the receiver. 
	On iX86 the high and low order bytes are reversed; i.e. the bytes are ordered least 
	significant first.

	Primitive failure reasons:
		0 -	anInteger is not a SmallInteger.
		1 -	anInteger is out of bounds."

	| answer |
	<primitive: 124>
	answer := 0.
	1 to: 0 by: -1 do: [:i |
		answer := (answer bitShift: 8) + (self byteAtOffset: anInteger + i)].
	^answer!

wordAtOffset: anInteger put: anObject
	"Store an unsigned 16-bit value at byte offset anInteger within the receiver.
	If anObject is not representable as a 16-bit unsigned (Small)Integer, then 
	raise a 'cannot hold' error.

	Primitive failure reasons:
		0 -	anInteger is not a SmallInteger.
		1 -	anInteger is out of bounds.
		2 -	anObject is not a SmallInteger
		3 -	anObject is not in the range -32768..32767 (i.e. out of signed 16-bit range)."

	<primitive: 125>
	^self retryWordAtOffset: anInteger put: anObject! !
!ByteArray categoriesFor: #_sameAsString:!comparing!private! !
!ByteArray categoriesFor: #=!comparing!primitives!public! !
!ByteArray categoriesFor: #addressAtOffset:!accessing!public! !
!ByteArray categoriesFor: #asByteArray!converting!public! !
!ByteArray categoriesFor: #asString!converting!public! !
!ByteArray categoriesFor: #basicDwordAtOffset:!accessing!primitives!public! !
!ByteArray categoriesFor: #basicDwordAtOffset:put:!accessing!primitives!private! !
!ByteArray categoriesFor: #basicUIntPtrAtOffset:!accessing!primitives!public! !
!ByteArray categoriesFor: #basicUIntPtrAtOffset:put:!accessing!primitives!private! !
!ByteArray categoriesFor: #byteAtOffset:!accessing!public! !
!ByteArray categoriesFor: #byteAtOffset:put:!accessing!public! !
!ByteArray categoriesFor: #bytesAtOffset:put:!accessing!public! !
!ByteArray categoriesFor: #byteSize!accessing!private! !
!ByteArray categoriesFor: #copy:from:to:!copying!private! !
!ByteArray categoriesFor: #copyStringFrom:to:!copying!public! !
!ByteArray categoriesFor: #doubleAtOffset:!accessing!primitives!public! !
!ByteArray categoriesFor: #doubleAtOffset:put:!accessing!primitives!public! !
!ByteArray categoriesFor: #dwordAtOffset:!accessing!primitives!public! !
!ByteArray categoriesFor: #dwordAtOffset:put:!accessing!primitives!public! !
!ByteArray categoriesFor: #floatAtOffset:!accessing!primitives!public! !
!ByteArray categoriesFor: #floatAtOffset:put:!accessing!primitives!public! !
!ByteArray categoriesFor: #hash!comparing!primitives!public! !
!ByteArray categoriesFor: #hexStoreOn:!printing!public! !
!ByteArray categoriesFor: #includes:!public!searching! !
!ByteArray categoriesFor: #indexOfSubCollection:startingAt:!public!searching! !
!ByteArray categoriesFor: #intPtrAtOffset:!accessing!primitives!public! !
!ByteArray categoriesFor: #intPtrAtOffset:put:!accessing!primitives!public! !
!ByteArray categoriesFor: #isLiteral!public!testing! !
!ByteArray categoriesFor: #isNull!public!testing! !
!ByteArray categoriesFor: #longDoubleAtOffset:!accessing!primitives!public! !
!ByteArray categoriesFor: #notNull!public!testing! !
!ByteArray categoriesFor: #printHexOn:!printing!public! !
!ByteArray categoriesFor: #printHexString!printing!public! !
!ByteArray categoriesFor: #printPrefixOn:!printing!private! !
!ByteArray categoriesFor: #printSuffixOn:!printing!private! !
!ByteArray categoriesFor: #qwordAtOffset:!accessing!public! !
!ByteArray categoriesFor: #qwordAtOffset:put:!accessing!public! !
!ByteArray categoriesFor: #replaceBytesOf:from:to:startingAt:!double dispatch!primitives!private! !
!ByteArray categoriesFor: #replaceFrom:to:with:startingAt:!public!replacing! !
!ByteArray categoriesFor: #retryDwordAtOffset:put:!accessing!private! !
!ByteArray categoriesFor: #retrySWordAtOffset:put:!accessing!private! !
!ByteArray categoriesFor: #retryUIntPtrAtOffset:put:!accessing!helpers!private! !
!ByteArray categoriesFor: #retryWordAtOffset:put:!accessing!private! !
!ByteArray categoriesFor: #sbyteAtOffset:!accessing!public! !
!ByteArray categoriesFor: #sbyteAtOffset:put:!accessing!public! !
!ByteArray categoriesFor: #sdwordAtOffset:!accessing!primitives!public! !
!ByteArray categoriesFor: #sdwordAtOffset:put:!accessing!primitives!public! !
!ByteArray categoriesFor: #sqwordAtOffset:!accessing!public! !
!ByteArray categoriesFor: #sqwordAtOffset:put:!accessing!public! !
!ByteArray categoriesFor: #stbSaveOn:!binary filing!public! !
!ByteArray categoriesFor: #storeOn:!printing!public! !
!ByteArray categoriesFor: #swordAtOffset:!accessing!primitives!public! !
!ByteArray categoriesFor: #swordAtOffset:put:!accessing!primitives!public! !
!ByteArray categoriesFor: #uintPtrAtOffset:!accessing!primitives!public! !
!ByteArray categoriesFor: #uintPtrAtOffset:put:!accessing!primitives!public! !
!ByteArray categoriesFor: #validateOffset:forUpdate:!accessing!private! !
!ByteArray categoriesFor: #wordAtOffset:!accessing!primitives!public! !
!ByteArray categoriesFor: #wordAtOffset:put:!accessing!primitives!public! !

!ByteArray class methodsFor!

elementSize
	"Private - Answer the size of the receiver's constituent elements in bytes."

	^1.
!

fromAddress: anAddress length: anInteger
	"Answer a new instance of the receiver, of size anInteger, copied from the first anInteger
	bytes at the specified address."

	^anAddress asExternalAddress
		replaceBytesOf: (self new: anInteger)
		from: 1 to: anInteger startingAt: 1
!

fromHexString: aString
	"Answer a new instance of the receiver instantiated from the contents of the hexadecimal <String> argument."

	| answer size |
	size := aString size / 2.
	size isInteger ifFalse: [self error: 'Invalid hex string (odd length)'].
	answer := self new: size.
	1 to: size do: [:i | | j |
		j := (i * 2)-1.
		answer at: i put: ((aString at: j) digitValue * 16) + ((aString at: j+1) digitValue)].
	^answer
			
!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

stbReadFrom: anSTBInFiler format: anSTBClassConversion 
	"Read an instance of the receiver from the binary filer, aSTBInFiler. Note that we can
	ignore the format argument, since ByteArray is a pre-registered class that cannot be
	versioned. The format we read here is the same as that which would be read by the in-filer
	itself, but we can do the job more efficiently since we know that a block read from the
	stream is possible."

	| stream size answer |
	stream := anSTBInFiler stream.
	size := stream nextSDWORD.
	answer := stream next: size.
	anSTBInFiler register: answer.
	^answer! !
!ByteArray class categoriesFor: #elementSize!constants!private! !
!ByteArray class categoriesFor: #fromAddress:length:!instance creation!public! !
!ByteArray class categoriesFor: #fromHexString:!instance creation!public! !
!ByteArray class categoriesFor: #icon!constants!public! !
!ByteArray class categoriesFor: #stbReadFrom:format:!binary filing!public! !

