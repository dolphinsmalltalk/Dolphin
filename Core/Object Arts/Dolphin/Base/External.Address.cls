"Filed out from Dolphin Smalltalk"!

External.UIntPtrBytes
	variableByteSubclass: #'External.Address'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.Address guid: (Core.GUID fromString: '{87b4c517-026e-11d3-9fd7-00a0cc3e4a32}')!
External.Address isIndirection: true!
External.Address comment: ''!
!External.Address categoriesForClass!External-Data-Unstructured! !
!External.Address methodsFor!

approxSize
	"Private - Answer the approximate size of the receiver.
	Implementation Note: As we have no idea how large the item is we are pointing at,
	we revert to the Collection implementation."

	^2!

asExternalAddress
	"Answer the receiver as an ExternalAddress"

	^self!

asInteger
	"Answer the 32-bit unsigned integer value of the receiver. ExternalAddress 
	needs to be careful NOT to return the positive integer value of the first 4 bytes 
	of the object  at which the receiver points, but its own value, so we use the 
	basic version of the accessor."

	^self basicUIntPtrAtOffset: 0!

asUtf16String
	"Answer a <Utf16String> containing the same characters as the null-terminated UTF16-encoded string pointed at by the receiver. If the receiver doesn't point at a string, you'll get garbage and possibly an access violation, so use with care."

	^Utf16String fromAddress: self!

at: anInteger
	"Answer the byte at index, anInteger, based from the address stored as 
	the contents of the receiver."

	^self uint8AtOffset: anInteger-1!

at: anInteger put: anIntegerByteValue
	"Answer the byte at index anIntegerIndex based from the address stored 
	as the contents of the receiver"

	^self uint8AtOffset: anInteger-1 put: anIntegerByteValue!

byteAtOffset: anInteger put: aByte
	"Soft deprecated. Retain in applications that still refer to the old FFI class names, e.g. BYTE."

	^self uint8AtOffset: anInteger put: aByte!

copyFrom: startInteger to: stopInteger
	"Answer a new <sequencedReadableCollection> like the receiver containing those elements of
	the receiver between the <integer> indices startInteger and stopInteger, inclusive, and in
	the same order."

	| len |
	len := stopInteger - startInteger + 1.
	^(self copyingClass new: len)
		replaceFrom: 1
		to: len
		with: self
		startingAt: startInteger!

deepCopy
	"ExternalAddresses do not know how to deep copy themselves in general, as they
	do not know the size of the object they point at. In order to deep copy objects
	containing external addresses correctly, you must implement #deepenShallowCopies:trail:
	in the parent/owning/referencing object"

	^self shouldNotImplement!

detach
	"Detach the receiver from the object at which it is pointing, answering the address
	of that object. This is useful where one wishes to take-over ownership of an object
	which would otherwise be cleaned up when the receiver is finalized."

	| address |
	address := self asInteger.
	self value: 0. 
	self beUnfinalizable.	"reduce Memory Manager load"
	^address asExternalAddress!

displayOn: aPuttableStream
	"Append to the <puttableStream> argument a String whose characters are a representation of the receiver that an end-user might want to see."

	self isNull ifTrue: [aPuttableStream nextPutAll: 'NULL'] ifFalse: [super displayOn: aPuttableStream]!

int16AtOffset: anInteger
	"Answer the signed 2-byte integer at offset (i.e. zero relative) anInteger in the memory pointed at by the receiver."

	<primitive: 140>
	| answer |
	answer := self uint16AtOffset: anInteger.
	^answer >= 16r8000 ifTrue: [(16r10000 - answer) negated] ifFalse: [answer]!

int16AtOffset: anInteger put: anObject
	"Store a signed 2-byte value at byte offset anInteger within the receiver (which is the same as storing an unsigned value, except that the range of acceptable values is different).
	If anObject is not representable as a 16-bit signed (Small)Integer, then raise a 'cannot hold' error."

	"Primitive failure results:
		InvalidParameter1	- anInteger is not a SmallInteger
		InvalidParameter2	- anObject is not a SmallInteger
		IntegerOutOfRange 	- anObject is not in the range -32768..32767 (i.e. out of signed 16-bit range)."

	<primitive: 141>
	^self
		retryInt16AtOffset: anInteger
		put: anObject
		failureCode: _failureCode!

int32AtOffset: anInteger
	"Answers the signed 4-byte integer at byte offset anInteger in the receiver."

	"Primitive failure reasons:
		InvalidParameter1	- anInteger is not a SmallInteger."

	<primitive: 136>
	| answer |
	answer := self uint32AtOffset: anInteger.
	^answer > 16r7FFFFFFF ifTrue: [(answer bitXor: 16rFFFFFFFF) bitInvert] ifFalse: [answer]!

int32AtOffset: anInteger put: anObject
	"Store anObject as a signed integer at anInteger offset in the receiver. anInteger must 
	be representable in 32-bits. Uses the dwordAtOffset:put: primitive."

	<primitive: 137>
	| value |
	value := anObject asInteger.
	value isInt32 ifFalse: [^self errorCantHold: anObject].
	1 to: 4 do: [:index | self at: anInteger + index put: (value digitAt: index)].
	^anObject!

intPtrAtOffset: anInteger
	"Answer the machine-word sized signed integer value (i.e. may be 32 or 64-bit, depending on host OS) at offset (i.e. zero relative) anInteger in the receiver."

	"Primitive failure reasons:
		InvalidParameter1	- anInteger is not a SmallInteger
		InvalidParameter2	- anObject it not an integer of byte object of suitable size for storing as a IntPtr value."

	<primitive: 186>
	| answer |
	answer := 0.
	VMConstants.IntPtrSize - 1 to: 0
		by: -1
		do: [:i | answer := (answer bitShift: 8) + (self uint8AtOffset: anInteger + i)].
	answer byteSize > VMConstants.IntPtrSize ifTrue: [answer := answer bitInvert + 1].
	^answer!

intPtrAtOffset: anInteger put: anObject
	"Store anObject as a signed machine-word sized integer at anInteger offset in the receiver. anInteger must 
	be representable in a machine word. Uses the longPtrAtOffset:put: primitive."

	<primitive: 187>
	| value |
	value := anObject asInteger.
	value byteSize > VMConstants.IntPtrSize ifFalse: [^self errorCantHold: anObject].
	1 to: VMConstants.IntPtrSize do: [:index | self at: anInteger + index put: (value digitAt: index)].
	^anObject!

replaceBytesOf: aByteObject from: start to: stop startingAt: fromStart
	"Private - Standard method for transfering bytes from one variable
	byte object to another, normally double dispatched from #replaceFrom:to:with:startingAt:.
	Implementation Note: ExternalAddress uses a slightly different primitive for this
	purpose, as it is not the contents of the receiver that get replaced, but the
	object at which the receiver points.
	
	Primitive Failure Reasons:
		InvalidParameter1	- aByteObject is not a byte object
		InvalidParameter2	- start is not a SmallInteger.
		InvalidParameter3	- stop is not a SmallInteger.
		InvalidParameter4	- fromStart is not a SmallInteger.

	Note that bounds errors cannot be detected, so this is an unsafe operation that may overwrite arbitrary memory if not used carefully.
	"

	<primitive: 143>
	| fromOffset |
	fromOffset := fromStart - start.
	stop to: start
		by: -1
		do: [:i | aByteObject at: i put: (self at: i + fromOffset)].
	^aByteObject!

resize: anInteger
	"Resize the receiver to accommodate anInteger bytes.
	We ignore the request, since we don't know how to resize the object
	pointed at (or even if it is resizable)."!

uint16AtOffset: anInteger
	"Answer the unsigned 2-byte integer at offset (i.e. zero relative) anInteger in the memory pointed at by the receiver.
	On iX86 the high and low order bytes are reversed; i.e. the bytes are ordered least significant first. 
	A GP Fault interrupt will occur if an attempt is made to read inaccessible memory via this method. This will not affect the stability of the system."

	"Primitive failure reasons:
		InvalidParameter1	- anInteger is not a SmallInteger"

	<primitive: 138>
	| answer |
	answer := 0.
	1 to: 0
		by: -1
		do: [:i | answer := (answer bitShift: 8) + (self uint8AtOffset: anInteger + i)].
	^answer!

uint16AtOffset: anInteger put: anObject
	"Store an unsigned 2-byte value at byte offset anInteger within the receiver.
	If anObject is not representable as a 16-bit unsigned (Small)Integer, then raise a 'cannot hold' error."

	"Primitive failure reasons:
		InvalidParameter1	- anInteger is not a SmallInteger
		InvalidParameter2	- anObject is not a SmallInteger
		IntegerOutOfRange 	- anObject is not in the range 0..65535 (i.e. out of unsigned 16-bit range)."

	<primitive: 139>
	^self
		retryUInt16AtOffset: anInteger
		put: anObject
		failureCode: _failureCode!

uint32AtOffset: anInteger
	"Answer the unsigned 4-byte integer at offset (i.e. zero relative) anInteger in the memory pointed at by the receiver."

	"Primitive failure reasons:
		InvalidParameter1	- anInteger is not a SmallInteger"

	<primitive: 134>
	| answer |
	answer := 0.
	3 to: 0
		by: -1
		do: [:i | answer := (answer bitShift: 8) + (self uint8AtOffset: anInteger + i)].
	^answer!

uint32AtOffset: anInteger put: anObject
	"Store an unsigned 4-byte value at byte offset anInteger within the receiver."

	"Primitive failure reasons:
		InvalidParameter1	- anInteger is not a SmallInteger
		InvalidParameter2	- anObject is not a SmallInteger or a 4-byte object"

	<primitive: 135>
	^self
		retryUInt32AtOffset: anInteger
		put: anObject
		failureCode: _failureCode!

uint8AtOffset: anInteger
	"Answer the byte at offset anInteger based from the address stored as the 
	contents of the receiver.
	WARNING: The primitive assumes that the receiver is a byte object of size 4; 
	it does not check that the receiver is of the correct shape. The primitive
	works as specified for ExternalAddress, and any correctly defined subclasses, 
	but may produce unexpected results where used inappropriately (e.g. in the 
	methods of a pointer class).

	Primitive failure reasons:
		InvalidParameter1 -	anInteger is not a SmallInteger."

	<primitive: 132>
	^self primitiveFailed: _failureCode!

uint8AtOffset: anInteger put: anIntegerByteValue
	"Replace the byte at offset anInteger from the base address stored as the 
	contents of the receiver with anIntegerByteValue.
	WARNING: Careless use of this method may result in unexpected behavior similar 
	to the results of 	writing through unprotected pointers in other languages, 
	in particular it is possible to compromise	the VM by corrupting objects and 
	other areas of memory. If a GP Fault directly results, then operation should
	continue normally.

	Primitive failure reasons:
		0 -	anInteger is not a SmallInteger.
		2 -	anIntegerByteValue is not a SmallInteger.
		3 -	anIntegerByteValue is not in the range 0..255."

	<primitive: 133>
	^self primitiveFailed: _failureCode!

uintPtrAtOffset: anInteger
	"Answer the machine word sized integer value (i.e. may be 32 or 64-bit, depending on host OS) at offset (i.e. zero relative) anInteger in the memory pointed at by the receiver."

	"Primitive failure reasons:
		InvalidParameter1	- anInteger is not a SmallInteger"

	<primitive: 184>
	| answer |
	answer := 0.
	VMConstants.IntPtrSize - 1 to: 0
		by: -1
		do: [:i | answer := (answer bitShift: 8) + (self uint8AtOffset: anInteger + i)].
	^answer!

uintPtrAtOffset: anInteger put: anObject
	"Store an unsigned 4-byte value at byte offset anInteger within the receiver."

	"Primitive failure reasons:
		InvalidParameter1	- anInteger is not a SmallInteger
		InvalidParameter2	- anObject it not an integer of byte object of suitable size for storing as a UIntPtr value."

	<primitive: 185>
	^self
		retryUIntPtrAtOffset: anInteger
		put: anObject
		failureCode: _failureCode!

value
	"Answer the value of the receiver (the address itself)"

	^self!

value: anInteger 
	"Set the receiver's address value to be anInteger. Answer the receiver.
	Use the basic version of the accessor to avoid the implicit indirection."

	self basicUIntPtrAtOffset: 0 put: anInteger!

yourAddress
	"Answer the address at which the receiver points, rather than the address of 
	the receiver's bytes"

	^self basicUIntPtrAtOffset: 0! !
!External.Address categoriesForMethods!
approxSize!accessing!private! !
asExternalAddress!converting!public! !
asInteger!accessing!public! !
asUtf16String!converting!public! !
at:!accessing!public! !
at:put:!accessing!public! !
byteAtOffset:put:!accessing!primitives!public! !
copyFrom:to:!copying!public! !
deepCopy!copying!public! !
detach!public!realizing/unrealizing! !
displayOn:!displaying!public! !
int16AtOffset:!accessing!primitives!public! !
int16AtOffset:put:!accessing!primitives!public! !
int32AtOffset:!accessing!primitives!public! !
int32AtOffset:put:!accessing!primitives!public! !
intPtrAtOffset:!accessing!primitives!public! !
intPtrAtOffset:put:!accessing!primitives!public! !
replaceBytesOf:from:to:startingAt:!double dispatch!primitives!private!replacing! !
resize:!mutating!public! !
uint16AtOffset:!accessing!primitives!public! !
uint16AtOffset:put:!accessing!primitives!public! !
uint32AtOffset:!accessing!primitives!public! !
uint32AtOffset:put:!accessing!primitives!public! !
uint8AtOffset:!accessing!primitives!public! !
uint8AtOffset:put:!accessing!primitives!public! !
uintPtrAtOffset:!accessing!primitives!public! !
uintPtrAtOffset:put:!accessing!primitives!public! !
value!accessing!public! !
value:!accessing!public! !
yourAddress!accessing!public! !
!

!External.Address class methodsFor!

alignment
	"Answer the natural alignment for instances of the receiver when 
	embedded in arrays or other structures."

	^VMConstants.IntPtrSize!

fromAddress: anAddress
	"Answer a new instance of the receiver with contents *copied* from
	the intptr pointed at by anAddress (this is not a reference object
	and so must copy in response to #fromAddress:)"

	^self fromInteger: anAddress!

fromBytes: aByteArray
	"Not quite sure what to do here, so assume ByteArray contains an address"

	^self fromInteger: aByteArray!

fromInteger: anInteger
	"Answer a new instance of the receiver with contents copied from anInteger
	Implementation note: Override superclass to make use of the external call
	primitive coercion trick."

	^VM addressFromInteger: anInteger! !
!External.Address class categoriesForMethods!
alignment!constants!public! !
fromAddress:!instance creation!public! !
fromBytes:!instance creation!public! !
fromInteger:!instance creation!public! !
!

