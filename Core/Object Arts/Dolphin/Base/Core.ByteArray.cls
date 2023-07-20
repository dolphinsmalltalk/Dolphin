"Filed out from Dolphin Smalltalk"!

Core.ArrayedCollection
	variableByteSubclass: #'Core.ByteArray'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.ByteArray guid: (Core.GUID fromString: '{87b4c511-026e-11d3-9fd7-00a0cc3e4a32}')!
Core.ByteArray comment: 'ByteArray is the class of <ArrayedCollection>s whose elements are bytes (i.e. <integer>s in the range 0..255).

ByteArray complies with the ANSI protocols:
	Object
	collection
	sequencedReadableCollection
	sequencedCollection
	ByteArray'!
!Core.ByteArray categoriesForClass!Collections-Arrayed! !
!Core.ByteArray methodsFor!

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
	"Answer the address stored at the specified offset in the receiver."

	^(self uintPtrAtOffset: anInteger) asExternalAddress!

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

basicUInt32AtOffset: anInteger
	"Answer the unsigned 32-bit integer at offset (i.e. zero relative) anInteger in the receiver.

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

basicUInt32AtOffset: anInteger put: anObject
	"Private - Replace the internal contents of the receiver from offset anInteger with the first 4 bytes of anObject."

	<primitive: 121>
	_failureCode == _PrimitiveFailureCode.InvalidParameter2
		ifTrue: 
			[| intVal |
			"Not a suitable value - could be non-Numeric, or not in unsigned 32-bit range.
			Atempt to coerce to Integer and retry. anObject may not understand asInteger."
			intVal := anObject asInteger.
			(intVal >= 0 and: [intVal <= 16rFFFFFFFF])
				ifTrue: [^self basicUInt32AtOffset: anInteger put: intVal]].
	^self updatePrimitiveFailed: _failureCode atOffset: anInteger!

basicUIntPtrAtOffset: anInteger
	"Answer the 32-bit unsigned integer at offset (i.e. zero relative) anInteger in the receiver.

	Primitive failure reasons:
		InvalidParameter1 	- the argument is not a SmallInteger
		OutOfBounds		- the argument is out of bounds (not in the range 0..receiver's size - (sizeof(UIntPtr)+1))."

	<primitive: 120>
	| answer offset |
	offset := anInteger + 1.
	answer := 0.
	VMConstants.IntPtrSize to: 0
		by: -1
		do: [:i | answer := (answer bitShift: 8) + (self basicAt: offset + i)].
	^answer!

basicUIntPtrAtOffset: anInteger put: anObject
	"Private - Replace the internal contents of the receiver from offset anInteger with the first machine word of anObject."

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
		InvalidParameter1	- the 1st argument is not a SmallInteger
		OutOfBounds		- the 1st argument is out of bounds (not in the range 0..receiver's indexable size - 1) 
		InvalidParameter2	- the 2nd argument is not a SmallInteger.
		IntegerOutOfRange	- the 2nd argument is a SmallInteger, but not in the range [0..255]"

	<primitive: 61>
	^self
		_primitiveError: _failureCode
		at: aSmallInteger
		put: value!

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

	^self
		copy: String
		from: start
		to: stop!

doubleAtOffset: anInteger
	"Answer the double precision floating point value at offset (i.e. zero relative) anInteger in the receiver, as a Smalltalk Float object (double precision)."

	"Primitive failure reasons:
		InvalidParameter1	- anInteger is not a SmallInteger
		OutOfBounds		- anInteger is out of bounds (not in the range 0..receiver's size - (sizeof(double)+1))."

	<primitive: 128>
	self validOffset: anInteger failureCode: _failureCode.
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
	"Hash the bytes of the object using the standard byte hashing primitive."

	<primitive: 106>
	| hash |
	"The primitive should not fail; this is how it is implemented"
	hash := 2166136261.
	"FNV1a"
	1 to: self size do: [:i | hash := (hash bitXor: (self basicAt: i)) * 16777619 bitAnd: 16rFFFFFFFF].
	"Fold to 30 bits so is always positive SmallInteger"
	^(hash bitShift: ##(VMConstants.SmallIntegerMax highBit negated))
		bitXor: (hash bitAnd: VMConstants.SmallIntegerMax)!

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

int16AtOffset: anInteger
	"Answer the 16-bit signed integer value at the specified zero-relative <integer> offset in the receiver's bytes."

	<primitive: 126>
	| answer |
	answer := self uint16AtOffset: anInteger.
	^answer >= 16r8000 ifTrue: [answer - 16r10000] ifFalse: [answer]!

int16AtOffset: anInteger put: anObject
	"Store the 16-bit signed integer value of the 2nd argument at the zero-relative offset in the receiver's bytes  specifiec by the <integer> 1st argument."

	"Primitive failure results:
		InvalidParameter1	- the 1st argument is not a SmallInteger
		OutOfBounds	 	- the 1st argument is out of bounds (not in the range 0..receiver's size - (sizeof(Int16)+1)).
		InvalidParameter2	- the 2nd argument is not a SmallInteger
		IntegerOutOfRange - the 2nd argument is not in the range -32768..32767 (i.e. out of signed 16-bit range)."

	<primitive: 127>
	^self
		retryInt16AtOffset: anInteger
		put: anObject
		failureCode: _failureCode!

int32AtOffset: anInteger
	"Answer the 32-bit signed integer value at the specified zero-relative <integer> offset in the receiver's bytes."

	"Primitive failure reasons:
		InvalidParameter1	- the argument is not a SmallInteger
		OutOfBounds	 	- the argument is out of bounds (not in the range 0..receiver's size - (sizeof(Int32)+1))."

	<primitive: 122>
	| answer |
	answer := self uint32AtOffset: anInteger.
	^answer > 16r7FFFFFFF ifTrue: [(answer bitXor: 16rFFFFFFFF) bitInvert] ifFalse: [answer]!

int32AtOffset: anInteger put: anObject
	"Store the 32-bit signed integer value of the 2nd argument at the zero-relative offset in the receiver's bytes  specifiec by the <integer> 1st argument."

	<primitive: 123>
	^self
		retryInt32AtOffset: anInteger
		put: anObject
		failureCode: _failureCode!

int64AtOffset: anInteger
	"Answer the 64-bit signed integer value at the specified zero-relative <integer> offset in the receiver's bytes."

	"Primitive failure reasons:
		InvalidParameter1	- the argument is not a SmallInteger
		OutOfBounds	 	- the argument is out of bounds (not in the range 0..receiver's size - (sizeof(SQWORD)+1))."

	<primitive: 192>
	^((self int32AtOffset: anInteger + 4) bitShift: 32) + (self uint32AtOffset: anInteger)!

int64AtOffset: anInteger put: anObject
	"Store the 64-bit signed integer value of the 2nd argument at the zero-relative offset in the receiver's bytes  specifiec by the <integer> 1st argument."

	self
		uint32AtOffset: anInteger put: (16rFFFFFFFF bitAnd: anObject);
		int32AtOffset: anInteger + 4 put: (anObject bitShift: -32)!

int8AtOffset: anInteger
	"Answer the 8-bit signed integer value at the specified zero-relative <integer> offset in the receiver's bytes."

	| answer |
	answer := self uint8AtOffset: anInteger.
	^answer > 127 ifTrue: [answer - 256] ifFalse: [answer]!

int8AtOffset: anInteger put: anObject
	"Store the 8-bit signed integer value of the 2nd argument at the zero-relative offset in the receiver's bytes  specifiec by the <integer> 1st argument."

	^self uint8AtOffset: anInteger put: (255 bitAnd: anObject)!

intPtrAtOffset: anInteger
	"Answer the 1machine-word-sized signed integer value (i.e. may be 32 or 64-bit, depending on host OS) at the specified zero-relative <integer> offset in the receiver's bytes."

	"Primitive failure reasons:
		InvalidParameter1	- the argument is not a SmallInteger
		OutOfBounds	 	- the argument is out of bounds (not in the range 0..receiver's size - (sizeof(IntPtr)+1))."

	<primitive: 182>
	| answer |
	answer := 0.
	VMConstants.IntPtrSize - 1 to: 0
		by: -1
		do: [:i | answer := (answer bitShift: 8) + (self uint8AtOffset: anInteger + i)].
	answer byteSize > VMConstants.IntPtrSize ifTrue: [answer := answer bitInvert + 1].
	^answer!

intPtrAtOffset: anInteger put: anObject
	"Store anObject as a signed machine-word sized integer at anInteger offset in the receiver. anObject must be representable in a machine word."

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
		InvalidParameter1	- the argument is not a SmallInteger
		OutOfBounds	 	- the argument is out of bounds (not in the range 0..receiver's size - (sizeof(long double)+1))."

	<primitive: 159>
	self validOffset: anInteger failureCode: _failureCode.
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

printOn: aStream
	aStream nextPutAll: '#['.
	self do: 
			[:each |
			"Use the optimized SmallInteger>>printString"
			aStream nextPutAll: each printString]
		separatedBy: [aStream space].
	aStream nextPut: $]!

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

retryInt16AtOffset: anInteger put: anObject failureCode: failureCode
	"Private - Fallback code for storing signed word into the reciever when a primitive fails.
	Either raises an appropriate error, or converts the argument to an Integer and retries."

	failureCode == _PrimitiveFailureCode.InvalidParameter2
		ifTrue: 
			[| int |
			"Not a suitable value - could be non-Numeric, or just not a SmallInteger. Attempt to coerce anObject and retry. anObject may not understand asInteger."
			int := anObject asInteger.
			(int >= -16r8000 and: [int < 16r8000]) ifTrue: [^self int16AtOffset: anInteger put: int]].
	^self updatePrimitiveFailed: failureCode atOffset: anInteger!

retryInt32AtOffset: anInteger put: anObject failureCode: failureCode
	"Private - Fallback code for storing unsigned 32-bit integer into the receiver when a
	primitive fails. Either raises an appropriate error, or converts the argument to an Integer
	and retries."

	failureCode == _PrimitiveFailureCode.InvalidParameter2
		ifTrue: 
			[| intVal |
			"Not a suitable value. Attempt to coerce to Integer and retry. Will error if anObject does understand #asInteger."
			intVal := anObject asInteger.
			intVal isInt32 ifTrue: [^self uint32AtOffset: anInteger put: intVal]].
	^self updatePrimitiveFailed: failureCode atOffset: anInteger!

retryUInt16AtOffset: anInteger put: anObject failureCode: failureCode
	"Private - Fallback code for storing unsigned word into the reciever when a primitive fails.
	Either raises an appropriate error, or converts the argument to an Integer and retries."

	failureCode == _PrimitiveFailureCode.InvalidParameter2
		ifTrue: 
			[| int |
			"Not a suitable value - could be non-Numeric, or just not a SmallInteger. Attempt to coerce anObject and retry. anObject may not understand asInteger."
			int := anObject asInteger.
			(int >= 0 and: [int <= 16rFFFF]) ifTrue: [^self uint16AtOffset: anInteger put: int]].
	^self updatePrimitiveFailed: failureCode atOffset: anInteger!

retryUInt32AtOffset: anInteger put: anObject failureCode: failureCode
	"Private - Fallback code for storing unsigned 32-bit integer into the receiver when a
	primitive fails. Either raises an appropriate error, or converts the argument to an Integer
	and retries."

	failureCode == _PrimitiveFailureCode.InvalidParameter2
		ifTrue: 
			[| intVal |
			"Not a suitable value. Attempt to coerce to Integer and retry. Will error if anObject does understand #asInteger."
			intVal := anObject asInteger.
			(intVal ~~ anObject and: [intVal >= 0 and: [intVal <= 16rFFFFFFFF]])
				ifTrue: [^self uint32AtOffset: anInteger put: intVal]].
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

stbSaveOn: anSTBOutFiler
	"Save out a binary representation of the receiver to anSTBOutFiler."

	"We override as an optimization because we know we can use a block write here. The format of the serialized byte array in the resulting STB stream is the same though. 
	Note that this won't be invoked by the STL filer because ByteArrays have a literal form and are written directly to the stream as is."

	anSTBOutFiler writeByteObject: self!

storeOn: puttableStream
	"Print the literal string representation of the receiver to the <puttableStream> argument.
	Implementation Note. This is written for speed, not elegance. We avoid #do:separatedBy: because it requires full blocks. Also we know that SmallInteger>>#printString has a primitive implementation."

	| count |
	count := self size.
	count == 0
		ifTrue: 
			[puttableStream nextPutAll: '#[]'.
			^self].
	puttableStream
		nextPutAll: '#[';
		nextPutAll: (self at: 1) printString.
	2 to: count
		do: 
			[:i |
			puttableStream
				nextPut: $\x20;
				nextPutAll: (self at: i) printString].
	puttableStream nextPut: $]!

uint16AtOffset: anInteger
	"Answer the 16-bit unsigned integer at the specified zero-relative <integer> offset in the receiver."

	"Primitive failure reasons:
		InvalidParameter1	- the argument is not a SmallInteger
		OutOfBounds	 	- the argument is out of bounds"

	<primitive: 124>
	| answer |
	answer := 0.
	"The iX86 is litle-endian, so the high and low order bytes are reversed; i.e. the bytes are ordered least  significant first."
	1 to: 0
		by: -1
		do: [:i | answer := (answer bitShift: 8) + (self uint8AtOffset: anInteger + i)].
	^answer!

uint16AtOffset: anInteger put: anObject
	"Store the 16-bit unsigned integer value of the 2nd argument at the zero-relative offset in the receiver's bytes  specifiec by the <integer> 1st argument."

	"Primitive failure reasons:
		InvalidParameter1	- the 1st argument is not a SmallInteger
		OutOfBounds	 	- the 1st argument is out of bounds (not in the range 0..receiver's size - (sizeof(WORD)+1)).
		InvalidParameter2	- the 2nd argument is not a SmallInteger
		IntegerOutOfRange - the 2nd argument is not in the range 0..65535 (i.e. out of unsigned 16-bit range)."

	<primitive: 125>
	^self
		retryUInt16AtOffset: anInteger
		put: anObject
		failureCode: _failureCode!

uint32AtOffset: anInteger
	"Answer the 32-bit unsigned integer at the specified zero-relative <integer> offset in the receiver."

	"Primitive failure reasons:
		InvalidParameter1	- the argument is not a SmallInteger
		OutOfBounds	 	- the argument is out of bounds (not in the range 0..receiver's size - (4+1))."

	<primitive: 120>
	| answer |
	answer := 0.
	3 to: 0
		by: -1
		do: [:i | answer := (answer bitShift: 8) + (self uint8AtOffset: anInteger + i)].
	^answer!

uint32AtOffset: anInteger put: anObject
	"Store the 32-bit unsigned integer value of the 2nd argument at the zero-relative offset in the receiver's bytes  specifiec by the <integer> 1st argument."

	"Primitive failure reasons:
		InvalidParameter1	- the 1st argument is not a SmallInteger
		OutOfBounds	 	- the 1st argument is out of bounds (not in the range 0..receiver's size - (4+1)).
		InvalidParameter2	- the 2nd argument is not a SmallInteger or a 4-byte object"

	<primitive: 121>
	^self
		retryUInt32AtOffset: anInteger
		put: anObject
		failureCode: _failureCode!

uint64AtOffset: anInteger
	"Answer the 64-bit unsigned integer at the specified zero-relative <integer> offset in the receiver."

	"Primitive failure reasons:
		InvalidParameter1	- the argument is not a SmallInteger
		OutOfBounds	 	- the argument is out of bounds (not in the range 0..receiver's size - (sizeof(QWORD)+1))."

	<primitive: 191>
	^((self uint32AtOffset: anInteger + 4) bitShift: 32) + (self uint32AtOffset: anInteger)!

uint64AtOffset: anIntegerOffset put: anIntegerValue
	"Replace the unsigned 64-bit integer in the receiver at the <integer> offset (i.e. zero relative) specified by the first argument with the value of the second <integer> argument."

	self
		uint32AtOffset: anIntegerOffset put: (16rFFFFFFFF bitAnd: anIntegerValue);
		uint32AtOffset: anIntegerOffset + 4 put: (anIntegerValue bitShift: -32)!

uint8AtOffset: anInteger
	"Answer the 8-bit unsigned integer at the specified zero-relative <integer> offset in the receiver."

	^self basicAt: anInteger + 1!

uint8AtOffset: anInteger put: aByte
	"Replace the byte of the receiver at offset anInteger with aByte. Answer aByte."

	^self basicAt: anInteger + 1 put: aByte!

uintPtrAtOffset: anInteger
	"Answer the machine word sized integer value (i.e. may be 32 or 64-bit, depending on host OS) at offset (i.e. zero relative) anInteger in the receiver."

	"Primitive failure reasons:
		InvalidParameter1 	- the argument is not a SmallInteger
		OutOfBounds	 	- the argument is out of bounds (not in the range 0..receiver's size - (sizeof(UIntPtr)+1))."

	<primitive: 180>
	| answer |
	answer := 0.
	VMConstants.IntPtrSize - 1 to: 0
		by: -1
		do: [:i | answer := (answer bitShift: 8) + (self uint8AtOffset: anInteger + i)].
	^answer!

uintPtrAtOffset: anInteger put: anObject
	"Store an unsigned 4-byte value at byte offset anInteger within the receiver."

	"Primitive failure reasons:
		InvalidParameter1	- the 1st argument is not a SmallInteger
		OutOfBounds		- the 1st argument is out of bounds (not in the range 0..receiver's size - (sizeof(UIntPtr)+1)).
		InvalidParameter2	- the 2nd argument is not an integer or byte object of suitable size for storing as a UIntPtr value."

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
	^nil! !
!Core.ByteArray categoriesForMethods!
_sameAsString:!comparing!private! !
=!comparing!public! !
addressAtOffset:!accessing!public! !
asAnsiString!public! !
asByteArray!converting!public! !
asHexString!converting!public! !
asString!converting!public! !
basicUInt32AtOffset:!accessing!public! !
basicUInt32AtOffset:put:!accessing!private! !
basicUIntPtrAtOffset:!accessing!public! !
basicUIntPtrAtOffset:put:!accessing!private! !
byteAt:!accessing!public! !
byteAt:put:!accessing!public! !
bytesAtOffset:put:!accessing!public! !
byteSize!accessing!private! !
copy:from:to:!copying!private! !
copyStringFrom:to:!copying!public! !
doubleAtOffset:!accessing!public! !
doubleAtOffset:put:!accessing!public! !
floatAtOffset:!accessing!public! !
floatAtOffset:put:!accessing!public! !
hash!comparing!public! !
hexStoreOn:!printing!public! !
includes:!public!searching! !
indexOfSubCollection:startingAt:!public!searching! !
int16AtOffset:!accessing!public! !
int16AtOffset:put:!accessing!public! !
int32AtOffset:!accessing!public! !
int32AtOffset:put:!accessing!public! !
int64AtOffset:!accessing!public! !
int64AtOffset:put:!accessing!public! !
int8AtOffset:!accessing!public! !
int8AtOffset:put:!accessing!public! !
intPtrAtOffset:!accessing!public! !
intPtrAtOffset:put:!accessing!public! !
isLiteral!public!testing! !
isNull!public!testing! !
longDoubleAtOffset:!accessing!public! !
notNull!public!testing! !
printHexOn:!printing!public! !
printHexString!printing!public! !
printOn:!printing!public! !
replaceBytesOf:from:to:startingAt:!double dispatch!private! !
replaceFrom:to:with:startingAt:!public!replacing! !
retryInt16AtOffset:put:failureCode:!accessing!private! !
retryInt32AtOffset:put:failureCode:!accessing!private! !
retryUInt16AtOffset:put:failureCode:!accessing!private! !
retryUInt32AtOffset:put:failureCode:!accessing!private! !
retryUIntPtrAtOffset:put:failureCode:!accessing!helpers!private! !
stbSaveOn:!binary filing!public! !
storeOn:!printing!public! !
uint16AtOffset:!accessing!public! !
uint16AtOffset:put:!accessing!public! !
uint32AtOffset:!accessing!public! !
uint32AtOffset:put:!accessing!public! !
uint64AtOffset:!accessing!public! !
uint64AtOffset:put:!accessing!public! !
uint8AtOffset:!accessing!public! !
uint8AtOffset:put:!accessing!public! !
uintPtrAtOffset:!accessing!public! !
uintPtrAtOffset:put:!accessing!public! !
updatePrimitiveFailed:atOffset:!accessing!private! !
validOffset:failureCode:!accessing!private! !
!

!Core.ByteArray class methodsFor!

elementSize
	"Private - Answer the size of the receiver's constituent elements in bytes."

	^1.
!

empty
	"Answer an empty (zero length) instance of the receiver."

	^#[]!

encoding
	^#binary!

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
	bytes := OS.Kernel32 globalLock: anExternalHandle.
	len := External.Memory GetSize: bytes.
	bytes := self fromAddress: bytes length: len.
	OS.Kernel32 globalUnlock: anExternalHandle.
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

stbReadFrom: anSTBInFiler format: anSTBClassConversion size: anInteger
	"Read an instance of the receiver from the binary filer, aSTBInFiler. Note that we can ignore the format argument, since ByteArray is a pre-registered class that cannot be versioned. The format we read here is the same as that which would be read by the in-filer itself, but we can do the job more efficiently since we know that a block read from the byte stream is possible."

	| answer |
	answer := self basicNew: anInteger.
	anSTBInFiler stream
		basicNext: anInteger
		into: answer
		startingAt: 1.
	anSTBInFiler register: answer.
	^answer! !
!Core.ByteArray class categoriesForMethods!
elementSize!constants!private! !
empty!instance creation!public! !
encoding!constants!public! !
fromAddress:length:!instance creation!public! !
fromGlobalHandle:!instance creation!public! !
fromHexString:!instance creation!public! !
stbReadFrom:format:size:!binary filing!public! !
!

