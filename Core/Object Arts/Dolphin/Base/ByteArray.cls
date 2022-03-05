"Filed out from Dolphin Smalltalk"!

ArrayedCollection variableByteSubclass: #ByteArray
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ByteArray guid: (GUID fromString: '{87b4c511-026e-11d3-9fd7-00a0cc3e4a32}')!
ByteArray comment: 'ByteArray is the class of <ArrayedCollection>s whose elements are bytes (i.e. <integer>s in the range 0..255).

ByteArray complies with the ANSI protocols:
	Object
	collection
	sequencedReadableCollection
	sequencedCollection
	ByteArray'!
!ByteArray categoriesForClass!Collections-Arrayed! !
!ByteArray methodsFor!

_sameAsString: aString
	"Private - Answer whether the receiver collates the same as <readableString> argument.
	This will only work if the receiver contains integers in the range of character values, if not an exception will be raised.
	Implementation Note: Double dispatched from String>>sameAs:."

	^(aString <=> self asString) == 0!

= comperand
	"Answer whether the receiver is equivalent to the <Object>, comperand.
	Uses standard byte comparison primitive which checks for identical bytes and size.

	Primitive failure reasons:
		InvalidParameter1	- comperand is not the same class as the receiver."

	<primitive: 55>
	^false!

addressAtOffset: anInteger 
	"Answer the 32-bit address stored at the specified offset in the receiver."

	^(self dwordAtOffset: anInteger) asExternalAddress!

asAnsiString
	"Answer an ANSI-encoded String the characters of have the same encoding as the byte elements of the receiver."

	| size |
	size := self basicSize.
	^self
		replaceBytesOf: (AnsiString new: size)
		from: 1
		to: size
		startingAt: 1!

asByteArray
	"Answer a <ByteArray> containing the same elements as the receiver.
	In this case no conversion is required."

	^self!

asHexString
	"Answer a hexadecimal representation of the receiver"

	| string j |
	string := AnsiString new: self size * 2.
	j := 0.
	1 to: self size
		do: 
			[:i |
			| each |
			each := self at: i.
			string
				at: (j := j + 1) put: ('0123456789abcdef' at: (each bitShift: -4) + 1);
				at: (j := j + 1) put: ('0123456789abcdef' at: (each bitAnd: 16rF) + 1)].
	^string!

asString
	"Assuming that the receiver contains the bytes of an ANSI string, return that string."

	^self asAnsiString!

basicDwordAtOffset: anInteger
	"Answer the unsigned 4-byte integer at offset (i.e. zero relative) anInteger in the receiver.

	Primitive failure reasons:
		InvalidParameter1 	- anInteger is not a SmallInteger
		OutOfBounds		- anInteger is out of bounds (not in the range 0..receiver's size - (4 + 1))."

	<primitive: 120>
	| answer offset |
	offset := anInteger + 1.
	answer := 0.
	3 to: 0
		by: -1
		do: [:i | answer := (answer bitShift: 8) + (self basicAt: offset + i)].
	^answer!

basicDwordAtOffset: anInteger put: anObject
	"Private - Replace the internal contents of the receiver from offset anInteger with the first 4 bytes of anObject."

	<primitive: 121>
	_failureCode == _PrimitiveFailureCode.InvalidParameter2
		ifTrue: 
			[| intVal |
			"Not a suitable value - could be non-Numeric, or not in unsigned 32-bit range.
			Atempt to coerce to Integer and retry. anObject may not understand asInteger."
			intVal := anObject asInteger.
			(intVal >= 0 and: [intVal <= 16rFFFFFFFF])
				ifTrue: [^self basicDwordAtOffset: anInteger put: intVal]].
	^self updatePrimitiveFailed: _failureCode atOffset: anInteger!

basicUIntPtrAtOffset: anInteger
	"Answer the unsigned machine word sized integer at offset (i.e. zero relative) 
	anInteger in the receiver.

	Primitive failure reasons:
		InvalidParameter1 	- anInteger is not a SmallInteger
		OutOfBounds		- anInteger is out of bounds (not in the range 0..receiver's size - (sizeof(UINT_PTR)+1))."

	<primitive: 120>
	| answer offset |
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
	_failureCode == _PrimitiveFailureCode.InvalidParameter2
		ifTrue: 
			[| intVal |
			"Not a suitable value - could be non-Numeric, or not in unsigned machine word range.
			Atempt to coerce to Integer and retry. anObject may not understand asInteger."
			intVal := anObject asInteger.
			(intVal >= 0 and: [intVal <= VMConstants.UIntPtrMax])
				ifTrue: [^self basicUIntPtrAtOffset: anInteger put: intVal]].
	^self updatePrimitiveFailed: _failureCode atOffset: anInteger!

byteAt: anInteger
	"Answer the byte at offset anInteger in the receiver"

	<primitive: 60>
	^self basicAt: anInteger!

byteAt: aSmallInteger put: value
	"Replace the byte at the specified index in the receiver with the specified integer byte value."

	"Primitive Failure Reasons:
		InvalidParameter1	- aSmallInteger is not a SmallInteger
		OutOfBounds		- aSmallInteger out of bounds (not in the range 0..receiver's indexable size - 1) 
		InvalidParameter2	- the argument, value, is not a SmallInteger.
		IntegerOutOfRange	- the argument is a SmallInteger, but not in the range [0..255]"

	<primitive: 61>
	^self
		_primitiveError: _failureCode
		at: aSmallInteger
		put: value!

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
	"Answer the double precision floating point value at offset (i.e. zero relative) anInteger in the receiver, as a Smalltalk Float object (double precision)."

	"Primitive failure reasons:
		InvalidParameter1	- anInteger is not a SmallInteger
		OutOfBounds		- anInteger is out of bounds (not in the range 0..receiver's size - (sizeof(double)+1))."

	<primitive: 128>
	self
		validateOffset: anInteger
		failureCode: _failureCode.
	^self primitiveFailed: _failureCode!

doubleAtOffset: anInteger put: aFloat
	"Store the Smalltalk floating point Number, aFloat, as a double precision floating point value (e.g. a C double) at byte offset (i.e. zero based) anInteger within the receiver.
	If the argument is not a float, then the primitive is retried having converted it to a Float. This allows other number types to be passed as arguments."

	"Primitive failure reasons:
		InvalidParameter1	- anInteger is not a SmallInteger
		OutOfBounds		- anInteger is out of bounds (not in the range 0..receiver's size - (sizeof(double)+1)).
		InvalidParameter2	- aFloat is not a ,<Float>"

	<primitive: 129>
	_failureCode == _PrimitiveFailureCode.InvalidParameter2
		ifTrue: 
			[self doubleAtOffset: anInteger put: aFloat asFloat.
			^aFloat].	"coerce to float and retry"
	^self updatePrimitiveFailed: _failureCode atOffset: anInteger!

dwordAtOffset: anInteger
	"Answer the unsigned 4 byte integer at offset (i.e. zero relative) anInteger in the receiver."

	"Primitive failure reasons:
		InvalidParameter1	- anInteger is not a SmallInteger
		OutOfBounds	 	- anInteger is out of bounds (not in the range 0..receiver's size - (4+1))."

	<primitive: 120>
	| answer |
	answer := 0.
	3 to: 0
		by: -1
		do: [:i | answer := (answer bitShift: 8) + (self byteAtOffset: anInteger + i)].
	^answer!

dwordAtOffset: anInteger put: anObject
	"Store an unsigned 4 byte value at byte offset anInteger within the receiver."

	"Primitive failure reasons:
		InvalidParameter1	- anInteger is not a SmallInteger
		OutOfBounds	 	- anInteger is out of bounds (not in the range 0..receiver's size - (4+1)).
		InvalidParameter2	- anObject is not a SmallInteger or a 4-byte object"

	<primitive: 121>
	^self
		retryDwordAtOffset: anInteger
		put: anObject
		failureCode: _failureCode!

encodedAt: anInteger put: anObject
	"Private - Encoded the specified object beginning at the specified position in the receiver. Answer
	the <integer> index of the last element updated."

	self at: anInteger put: anObject.
	^anInteger!

encoding
	^#binary!

floatAtOffset: anInteger
	"Answer the single precision floating point value at offset (i.e. zero relative) anInteger in the receiver, as a Smalltalk Float object (double precision).
	N.B. To access a double precision value (e.g. a C double) use #doubleAtOffset:"

	"Primitive failure reasons:
		InvalidParameter1	- anInteger is not a SmallInteger
		OutOfBounds	 	- anInteger is out of bounds (not in the range 0..receiver's size - (sizeof(float)+1))."

	<primitive: 130>
	self validOffset: anInteger failureCode: _failureCode.
	^self primitiveFailed: _failureCode!

floatAtOffset: anInteger put: aFloat
	"Store the Smalltalk floating point Number, aFloat, as a single precision floating point value (e.g. a C float) at byte offset (i.e. zero based) anInteger 
	within the receiver. N.B. Some loss of precision is likely, to store a Smalltalk Float as a double precision value in an ExternalBytes buffer, use #doubleAt:put:."

	"Primitive failure reasons:
		InvalidParameter1 	- anInteger is not a SmallInteger
		OutOfBounds		- anInteger is out of bounds (not in the range 0..receiver's size - (sizeof(float)+1)).
		InvalidParameter2	- aFloat is not a Float."

	<primitive: 131>
	_failureCode == _PrimitiveFailureCode.InvalidParameter2
		ifTrue: [^self floatAtOffset: anInteger put: aFloat asFloat].	"coerce to float and retry"
	^self updatePrimitiveFailed: _failureCode atOffset: anInteger!

hash
	"Hash the bytes of the object using the standard byte hashing
	primitive (which should not fail)."

	<primitive: 106>
	| hash |
	hash := 2166136261.
	"FNV1a"
	1 to: self size do: [:i | hash := (hash bitXor: (self basicAt: i)) * 16777619 bitAnd: 16rFFFFFFFF].
	"Fold to 30 bits so is always positive SmallInteger"
	^(hash bitShift: -30) bitXor: (hash bitAnd: 16r3FFFFFFF)!

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
		InvalidParameter1	- targetSequence is not of the same class as the receiver.
		InvalidParameter2	- start is not a SmallInteger
		OutOfBounds		- start is out of bounds (not in the range 1..receiver's indexable size) 

	Implementation Note: The string search primitive is implemented using the 
	Boyer-Moore algorithm unless the receiver is less than 512 bytes long, in which
	case it isn't worth initializing the skip array in most cases, so a simple brute
	force search (much like that of the superclass) is used."

	<primitive: 149>
	^super indexOfSubCollection: targetSequence startingAt: start!

intPtrAtOffset: anInteger
	"Answer the machine-word-sized signed integer value (i.e. may be 32 or 64-bit, depending on host OS) at offset (i.e. zero relative) anInteger in the receiver."

	"Primitive failure reasons:
		InvalidParameter1	- anInteger is not a SmallInteger
		OutOfBounds	 	- anInteger is out of bounds (not in the range 0..receiver's size - (sizeof(INT_PTR)+1))."

	<primitive: 182>
	| answer |
	answer := 0.
	VMConstants.IntPtrSize - 1 to: 0
		by: -1
		do: [:i | answer := (answer bitShift: 8) + (self byteAtOffset: anInteger + i)].
	answer byteSize > VMConstants.IntPtrSize ifTrue: [answer := answer bitInvert + 1].
	^answer!

intPtrAtOffset: anInteger put: anObject
	"Store anObject as a signed machine-word sized integer at anInteger offset in the receiver. anInteger must 
	be representable in a machine word. Uses the longPtrAtOffset:put: primitive."

	<primitive: 183>
	| value |
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
	"Answer the 80-bit floating point value at offset (i.e. zero relative) anInteger in the receiver, as a Smalltalk Float object (i.e. 64-bit precision, so some precision may be lost)."

	"Primitive failure reasons:
		InvalidParameter1	- anInteger is not a SmallInteger
		OutOfBounds	 	- anInteger is out of bounds (not in the range 0..receiver's size - (sizeof(long double)+1))."

	<primitive: 159>
	self
		validateOffset: anInteger
		failureCode: _failureCode.
	^self primitiveFailed: _failureCode!

notNull
	"Answer whether the receiver is not Null (i.e. not equal to 0)."

	^self isNull not!

printHexOn: aStream
	"Append a hex string representation of the receiver to the <puttableStream> argument."

	1 to: self size
		do: 
			[:i |
			| each |
			each := self at: i.
			aStream
				nextPut: ('0123456789abcdef' at: (each bitShift: -4) + 1);
				nextPut: ('0123456789abcdef' at: (each bitAnd: 15) + 1)]!

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

qwordAtOffset: anInteger
	"Answer an <integer> representing the unsigned 8 byte integer at the specified <integer> offset (i.e. zero relative), in the receiver."

	"Primitive failure reasons:
		InvalidParameter1	- anInteger is not a SmallInteger
		OutOfBounds	 	- anInteger is out of bounds (not in the range 0..receiver's size - (sizeof(QWORD)+1))."

	<primitive: 191>
	^((self dwordAtOffset: anInteger + 4) bitShift: 32) + (self dwordAtOffset: anInteger)!

qwordAtOffset: offset put: value
	"Replace the unsigned 8 byte integer at <integer> offset (i.e. zero relative), offset,
	in the receiver, with the <integer> argument, value."

	self 
		dwordAtOffset: offset put: (value bitAnd: 16rFFFFFFFF);
		dwordAtOffset: offset+4 put: (value bitShift: -32)!

replaceBytesOf: aByteObject from: start to: stop startingAt: fromStart
	"Private - Standard method for transfering bytes from one variable byte object to another, normally double dispatched from #replaceFrom:to:with:startingAt:"

	"Primitive Failure Reasons:
		InvalidParameter1	- aByteObject is not a byte object
		InvalidParameter2	- start is not a SmallInteger.
		InvalidParameter3	- stop is not a SmallInteger.
		InvalidParameter4	- fromStart is not a SmallInteger.
		OutOfBounds		- 'from' or 'to' interval is out-of-bounds
	"

	<primitive: 142>
	| fromOffset |
	fromOffset := fromStart - start.
	stop to: start
		by: -1
		do: [:i | aByteObject at: i put: (self basicAt: i + fromOffset)].
	^aByteObject!

replaceFrom: startInteger to: stopInteger with: aByteObject startingAt: startAtInteger 
	"Standard method for transfering bytes from one variable
	byte object to another. See String>>replaceFrom:to:with:startingAt:."

	aByteObject 
		replaceBytesOf: self
		from: startInteger
		to: stopInteger
		startingAt: startAtInteger!

retryDwordAtOffset: anInteger put: anObject failureCode: failureCode
	"Private - Fallback code for storing unsigned 32-bit integer into the receiver when a
	primitive fails. Either raises an appropriate error, or converts the argument to an Integer
	and retries."

	failureCode == _PrimitiveFailureCode.InvalidParameter2
		ifTrue: 
			[| intVal |
			"Not a suitable value. Attempt to coerce to Integer and retry. Will error if anObject does understand #asInteger."
			intVal := anObject asInteger.
			(intVal >= 0 and: [intVal <= 16rFFFFFFFF]) ifTrue: [^self dwordAtOffset: anInteger put: intVal]].
	^self updatePrimitiveFailed: failureCode atOffset: anInteger!

retrySWordAtOffset: anInteger put: anObject failureCode: failureCode
	"Private - Fallback code for storing signed word into the reciever when a primitive fails.
	Either raises an appropriate error, or converts the argument to an Integer and retries."

	failureCode == _PrimitiveFailureCode.InvalidParameter2
		ifTrue: 
			[| int |
			"Not a suitable value - could be non-Numeric, or just not a SmallInteger. Attempt to coerce anObject and retry. anObject may not understand asInteger."
			int := anObject asInteger.
			(int >= -16r8000 and: [int < 16r8000]) ifTrue: [^self swordAtOffset: anInteger put: int]].
	^self updatePrimitiveFailed: failureCode atOffset: anInteger!

retryUIntPtrAtOffset: anInteger put: anObject failureCode: failureCode
	"Private - Fallback code for storing an unsigned pointer sized integer into the receiver when a primitive fails. Either raises an appropriate error, or converts the argument to an Integer and retries."

	failureCode == _PrimitiveFailureCode.InvalidParameter2
		ifTrue: 
			[| intVal |
			"Not a suitable value. Attempt to coerce to Integer and retry. Will error if anObject does understand #asInteger."
			intVal := anObject asInteger.
			(intVal >= 0 and: [intVal <= VMConstants.UIntPtrMax])
				ifTrue: [^self uintPtrAtOffset: anInteger put: intVal]].
	^self updatePrimitiveFailed: failureCode atOffset: anInteger!

retryWordAtOffset: anInteger put: anObject failureCode: failureCode
	"Private - Fallback code for storing unsigned word into the reciever when a primitive fails.
	Either raises an appropriate error, or converts the argument to an Integer and retries."

	failureCode == _PrimitiveFailureCode.InvalidParameter2
		ifTrue: 
			[| int |
			"Not a suitable value - could be non-Numeric, or just not a SmallInteger. Attempt to coerce anObject and retry. anObject may not understand asInteger."
			int := anObject asInteger.
			(int >= 0 and: [int <= 16rFFFF]) ifTrue: [^self wordAtOffset: anInteger put: int]].
	^self updatePrimitiveFailed: failureCode atOffset: anInteger!

sbyteAtOffset: anInteger 
	"Answer the signed 8-bit <Integer> at offset anInteger in the receiver"

	| answer |
	answer := self byteAtOffset: anInteger.
	^answer > 127 ifTrue: [answer - 256] ifFalse: [answer]!

sbyteAtOffset: anInteger put: aByte
	"Replace the byte of the receiver at offset anInteger with aByte. Answer aByte."

	^self byteAtOffset: anInteger put: (255 bitAnd: aByte)!

sdwordAtOffset: anInteger
	"Answers the signed 4-byte integer at byte offset anInteger in the receiver."

	"Primitive failure reasons:
		InvalidParameter1	- anInteger is not a SmallInteger
		OutOfBounds	 	- anInteger is out of bounds (not in the range 0..receiver's size - (sizeof(SDWORD)+1))."

	<primitive: 122>
	| answer |
	answer := self dwordAtOffset: anInteger.
	^answer > 16r7FFFFFFF ifTrue: [(answer bitXor: 16rFFFFFFFF) bitInvert] ifFalse: [answer]!

sdwordAtOffset: anInteger put: anObject
	"Store anObject as a signed integer at anInteger offset in the receiver. anInteger must 
	be representable in 32-bits. Uses the dwordAtOffset:put: primitive."

	<primitive: 123>
	| value |
	value := anObject asInteger.
	value isSDWORD ifFalse: [^self errorCantHold: anObject].
	1 to: 4 do: [:index | self basicAt: anInteger + index put: (value digitAt: index)].
	^anObject!

sqwordAtOffset: anInteger
	"Answer the signed 8-byte integer at the specified <integer> offset (i.e. zero relative) in
	the receiver."

	"Primitive failure reasons:
		InvalidParameter1	- anInteger is not a SmallInteger
		OutOfBounds	 	- anInteger is out of bounds (not in the range 0..receiver's size - (sizeof(SQWORD)+1))."

	<primitive: 192>
	^((self sdwordAtOffset: anInteger + 4) bitShift: 32) + (self dwordAtOffset: anInteger)!

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
	1 to: self size
		do: 
			[:i |
			(self at: i)
				printOn: puttableStream
				base: 10.
			puttableStream nextPut: $\x20].
	self printSuffixOn: puttableStream

!

swordAtOffset: anInteger
	"Answer the signed 2-byte integer at offset (i.e. zero relative) anInteger in the receiver."

	<primitive: 126>
	| answer |
	answer := self wordAtOffset: anInteger.
	^answer >= 16r8000 ifTrue: [answer - 16r10000] ifFalse: [answer]

!

swordAtOffset: anInteger put: anObject
	"Store a signed 2-byte value at byte offset anInteger within the receiver (which is the same as storing an unsigned value). If anObject is not representable as a 16-bit signed (Small)Integer, then raise a 'cannot hold' error."

	"Primitive failure results:
		InvalidParameter1	- anInteger is not a SmallInteger
		OutOfBounds	 	- anInteger is out of bounds (not in the range 0..receiver's size - (sizeof(UINT_PTR)+1)).
		InvalidParameter2	- anObject is not a SmallInteger
		IntegerOutOfRange 	- anObject is not in the range -32768..32767 (i.e. out of signed 16-bit range)."

	<primitive: 127>
	^self
		retrySWordAtOffset: anInteger
		put: anObject
		failureCode: _failureCode!

uintPtrAtOffset: anInteger
	"Answer the machine word sized integer value (i.e. may be 32 or 64-bit, depending on host OS) at offset (i.e. zero relative) anInteger in the receiver."

	"Primitive failure reasons:
		InvalidParameter1 	- anInteger is not a SmallInteger
		OutOfBounds	 	- anInteger is out of bounds (not in the range 0..receiver's size - (sizeof(UINT_PTR)+1))."

	<primitive: 180>
	| answer |
	answer := 0.
	VMConstants.IntPtrSize - 1 to: 0
		by: -1
		do: [:i | answer := (answer bitShift: 8) + (self byteAtOffset: anInteger + i)].
	^answer!

uintPtrAtOffset: anInteger put: anObject
	"Store an unsigned 4-byte value at byte offset anInteger within the receiver."

	"Primitive failure reasons:
		InvalidParameter1	- anInteger is not a SmallInteger
		OutOfBounds		- anInteger is out of bounds (not in the range 0..receiver's size - (sizeof(UINT_PTR)+1)).
		InvalidParameter2	- anObject it not an integer of byte object of suitable size for storing as a UINT_PTR value."

	<primitive: 181>
	^self
		retryUIntPtrAtOffset: anInteger
		put: anObject
		failureCode: _failureCode!

updatePrimitiveFailed: failureCode atOffset: anInteger
	"Private - Primitive failure checking code for validating an offset argument to be called immediately after a buffer accessing primitive has failed.
	Raises an appropriate error."

	failureCode == _PrimitiveFailureCode.AccessViolation
		ifTrue: [^Processor constWriteSignal signalWith: self].
	^(self validOffset: anInteger failureCode: failureCode) ifNil: [self primitiveFailed: failureCode]!

validOffset: anInteger failureCode: failureCode
	failureCode == _PrimitiveFailureCode.OutOfBounds ifTrue: [^self errorSubscriptBounds: anInteger].
	failureCode == _PrimitiveFailureCode.InvalidParameter1 ifTrue: [^Error nonIntegerIndex: anInteger].
	^nil!

wordAtOffset: anInteger
	"Answer the unsigned 2-byte integer at offset (i.e. zero relative) anInteger in the receiver. 
	On iX86 the high and low order bytes are reversed; i.e. the bytes are ordered least  significant first."

	"Primitive failure reasons:
		InvalidParameter1	- anInteger is not a SmallInteger
		OutOfBounds	 	- anInteger is out of bounds"

	<primitive: 124>
	| answer |
	answer := 0.
	1 to: 0
		by: -1
		do: [:i | answer := (answer bitShift: 8) + (self byteAtOffset: anInteger + i)].
	^answer!

wordAtOffset: anInteger put: anObject
	"Store an unsigned 16-bit value at byte offset anInteger within the receiver.
	If anObject is not representable as a 16-bit unsigned (Small)Integer, then 
	raise a 'cannot hold' error.

	Primitive failure reasons:
		InvalidParameter1	- anInteger is not a SmallInteger
		OutOfBounds	 	- anInteger is out of bounds (not in the range 0..receiver's size - (sizeof(WORD)+1)).
		InvalidParameter2	- anObject is not a SmallInteger
		IntegerOutOfRange 	- anObject is not in the range 0..65535 (i.e. out of unsigned 16-bit range)."

	<primitive: 125>
	^self
		retryWordAtOffset: anInteger
		put: anObject
		failureCode: _failureCode! !
!ByteArray categoriesForMethods!
_sameAsString:!comparing!private! !
=!comparing!primitives!public! !
addressAtOffset:!accessing!public! !
asAnsiString!public! !
asByteArray!converting!public! !
asHexString!converting!public! !
asString!converting!public! !
basicDwordAtOffset:!accessing!primitives!public! !
basicDwordAtOffset:put:!accessing!primitives!private! !
basicUIntPtrAtOffset:!accessing!primitives!public! !
basicUIntPtrAtOffset:put:!accessing!primitives!private! !
byteAt:!accessing!public! !
byteAt:put:!accessing!public! !
byteAtOffset:!accessing!public! !
byteAtOffset:put:!accessing!public! !
bytesAtOffset:put:!accessing!public! !
byteSize!accessing!private! !
copy:from:to:!copying!private! !
copyStringFrom:to:!copying!public! !
doubleAtOffset:!accessing!primitives!public! !
doubleAtOffset:put:!accessing!primitives!public! !
dwordAtOffset:!accessing!primitives!public! !
dwordAtOffset:put:!accessing!primitives!public! !
encodedAt:put:!accessing!encode/decode!private! !
encoding!constants!encode/decode!private! !
floatAtOffset:!accessing!primitives!public! !
floatAtOffset:put:!accessing!primitives!public! !
hash!comparing!primitives!public! !
hexStoreOn:!printing!public! !
includes:!public!searching! !
indexOfSubCollection:startingAt:!public!searching! !
intPtrAtOffset:!accessing!primitives!public! !
intPtrAtOffset:put:!accessing!primitives!public! !
isLiteral!public!testing! !
isNull!public!testing! !
longDoubleAtOffset:!accessing!primitives!public! !
notNull!public!testing! !
printHexOn:!printing!public! !
printHexString!printing!public! !
printPrefixOn:!printing!private! !
printSuffixOn:!printing!private! !
qwordAtOffset:!accessing!public! !
qwordAtOffset:put:!accessing!public! !
replaceBytesOf:from:to:startingAt:!double dispatch!primitives!private! !
replaceFrom:to:with:startingAt:!public!replacing! !
retryDwordAtOffset:put:failureCode:!accessing!private! !
retrySWordAtOffset:put:failureCode:!accessing!private! !
retryUIntPtrAtOffset:put:failureCode:!accessing!helpers!private! !
retryWordAtOffset:put:failureCode:!accessing!private! !
sbyteAtOffset:!accessing!public! !
sbyteAtOffset:put:!accessing!public! !
sdwordAtOffset:!accessing!primitives!public! !
sdwordAtOffset:put:!accessing!primitives!public! !
sqwordAtOffset:!accessing!public! !
sqwordAtOffset:put:!accessing!public! !
stbSaveOn:!binary filing!public! !
storeOn:!printing!public! !
swordAtOffset:!accessing!primitives!public! !
swordAtOffset:put:!accessing!primitives!public! !
uintPtrAtOffset:!accessing!primitives!public! !
uintPtrAtOffset:put:!accessing!primitives!public! !
updatePrimitiveFailed:atOffset:!accessing!private! !
validOffset:failureCode:!accessing!private! !
wordAtOffset:!accessing!primitives!public! !
wordAtOffset:put:!accessing!primitives!public! !
!

!ByteArray class methodsFor!

elementSize
	"Private - Answer the size of the receiver's constituent elements in bytes."

	^1.
!

empty
	"Answer an empty (zero length) instance of the receiver."

	^#[]!

fromAddress: anAddress length: anInteger
	"Answer a new instance of the receiver, of size anInteger, copied from the first anInteger
	bytes at the specified address."

	^anAddress asExternalAddress
		replaceBytesOf: (self new: anInteger)
		from: 1 to: anInteger startingAt: 1
!

fromGlobalHandle: anExternalHandle
	"Answer a new <ByteArray> instantiated from the contents of the global heap block with the
	specified handle."

	| bytes len |
	bytes := KernelLibrary default globalLock: anExternalHandle.
	len := ExternalMemory GetSize: bytes.
	bytes := self fromAddress: bytes length: len.
	KernelLibrary default globalUnlock: anExternalHandle.
	^bytes!

fromHexString: aString
	"Answer a new instance of the receiver instantiated from the contents of the hexadecimal <String> argument."

	| answer count digits |
	count := aString size.
	(count bitAnd: 1) == 0 ifFalse: [self error: 'Invalid hex string (odd length)'].
	count := count bitShift: -1.
	answer := self new: count.
	digits := #(0 1 2 3 4 5 6 7 8 9 nil nil nil nil nil nil nil 10 11 12 13 14 15 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 10 11 12 13 14 15).
	1 to: count
		do: 
			[:i |
			| j |
			answer at: i
				put: (digits at: (aString basicAt: (j := i + i) - 1) - ##($0 codePoint - 1)) * 16
						+ (digits at: (aString basicAt: j) - ##($0 codePoint - 1))].
	^answer!

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
!ByteArray class categoriesForMethods!
elementSize!constants!private! !
empty!instance creation!public! !
fromAddress:length:!instance creation!public! !
fromGlobalHandle:!instance creation!public! !
fromHexString:!instance creation!public! !
stbReadFrom:format:!binary filing!public! !
!

