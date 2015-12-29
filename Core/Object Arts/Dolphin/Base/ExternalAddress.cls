"Filed out from Dolphin Smalltalk X6.1"!

UIntPtrBytes variableByteSubclass: #ExternalAddress
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ExternalAddress guid: (GUID fromString: '{87B4C517-026E-11D3-9FD7-00A0CC3E4A32}')!
ExternalAddress isIndirection: true!
ExternalAddress comment: ''!
!ExternalAddress categoriesForClass!External-Data-Unstructured! !
!ExternalAddress methodsFor!

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

at: anInteger
	"Answer the byte at index, anInteger, based from the address stored as 
	the contents of the receiver."

	^self byteAtOffset: anInteger-1!

at: anInteger put: anIntegerByteValue
	"Answer the byte at index anIntegerIndex based from the address stored 
	as the contents of the receiver"

	^self byteAtOffset: anInteger-1 put: anIntegerByteValue!

byteAtOffset: anInteger
	"Answer the byte at offset anInteger based from the address stored as the 
	contents of the receiver.
	WARNING: The primitive assumes that the receiver is a byte object of size 4; 
	it does not check that the receiver is of the correct shape. The primitive
	works as specified for ExternalAddress, and any correctly defined subclasses, 
	but may produce unexpected results where used inappropriately (e.g. in the 
	methods of a pointer class).

	Primitive failure reasons:
		0 -	anInteger is not a SmallInteger."

	<primitive: 132>
	^self primitiveFailed!

byteAtOffset: anInteger put: anIntegerByteValue
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
	^self primitiveFailed!

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

displayOn: aStream
	"Append a textual representation of the receiver to aStream."

	self isNull 
		ifTrue: [aStream nextPutAll: 'NULL']
		ifFalse: [super displayOn: aStream]!

dwordAtOffset: anInteger
	"Answer the unsigned 4 byte integer at offset (i.e. zero relative) 
	anInteger in the memory pointed at by the receiver.

	Primitive failure reasons:
		0 -	anInteger is not a SmallInteger"

	| answer |
	<primitive: 134>
	answer := 0.
	3 to: 0 by: -1 do: [:i |
		answer := (answer bitShift: 8) + (self byteAtOffset: anInteger + i)].
	^answer!

dwordAtOffset: anInteger put: anObject
	"Store an unsigned 4 byte value at byte offset anInteger 
	within the receiver.

	Primitive failure reasons:
		0 -	anInteger is not a SmallInteger
		2 -	anObject is not a SmallInteger or a 4-byte object
	"
	
	<primitive: 135>
	^self retryDwordAtOffset: anInteger put: anObject!

intPtrAtOffset: anInteger 
	"Answer the machine word sized signed integer value (i.e. may be 32 or 64-bit, depending on
	host OS) at offset (i.e. zero relative) anInteger in the receiver. 

	Primitive failure reasons:
		0 -	anInteger is not a SmallInteger
		1 -	anInteger is out of bounds (not in the range 1..receiver's size - sizeof(INT_PTR))."

	| answer |
	<primitive: 186>
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
	<primitive: 187>
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
		0 	- fromStart is not a SmallInteger.
		1	- stop is not a SmallInteger.
		2	- start is not a SmallInteger.
		3	- aByteObject is not a byte object
		4	- 'from' or 'to' interval is out-of-bounds
	"

	| fromOffset |
	<primitive: 143>
	fromOffset := fromStart - start.
	stop to: start by: -1 do: [:i | aByteObject at: i put: (self at: i + fromOffset)].
	^aByteObject!

resize: anInteger
	"Resize the receiver to accomodate anInteger bytes.
	We ignore the request, since we don't know how to resize the object
	pointed at (or even if it is resizable)."!

sdwordAtOffset: anInteger 
	"Answers the signed 4 byte integer at byte offset anInteger in the receiver.

	Primitive failure reasons:
		0 -	anInteger is not a SmallInteger"

	| answer |
	<primitive: 136>
	answer := self dwordAtOffset: anInteger.
	^answer > 16r7FFFFFFF ifTrue: [(answer bitXor: 16rFFFFFFFF) bitInvert] ifFalse: [answer]!

sdwordAtOffset: anInteger put: anObject 
	"Store anObject as a signed integer at anInteger offset in the receiver. anInteger must 
	be representable in 32-bits. Uses the dwordAtOffset:put: primitive."

	| value |
	<primitive: 137>
	value := anObject asInteger.
	value isSDWORD ifFalse: [^self errorCantHold: anObject].
	1 to: 4 do: [:index | self at: anInteger + index put: (value digitAt: index)].
	^anObject!

species
	"Answer the class of object to be used when copying the contents of the receiver. 
	As we are an untyped pointer, and we want to create a copy of the value pointed at,
	the best we can do is to create a ByteArray."

	^ByteArray!

stbSaveOn: anSTBOutFiler
	"Save out a binary representation of the receiver to anSTBOutFiler.
	Output nil in place of the receiver as the future validity of an external address is uncertain."

	anSTBOutFiler saveObject: self as: nil!

swordAtOffset: anInteger
	"Answer the signed 2 byte integer at offset (i.e. zero relative) 
	anInteger in the memory pointed at by the receiver."

	| answer |
	<primitive: 140>
	answer := self wordAtOffset: anInteger.
	^answer >= 16r8000
		ifTrue: [ (16r10000 - answer) negated ]
		ifFalse: [ answer ]
!

swordAtOffset: anInteger put: anObject
	"Store a signed 2 byte value at byte offset anInteger within the receiver (which is the 
	same as storing an unsigned value, except that the range of acceptable values is different).
	If anObject is not representable as a 16-bit signed (Small)Integer, then raise a 'cannot hold' error.

	Primitive failure results:
		0 -	anInteger is not a SmallInteger
		2 -	anObject is not a SmallInteger
		3 -	anObject is not in the range -32768..32767 (i.e. out of signed 16-bit range)."

	<primitive: 141>
	^self retrySWordAtOffset: anInteger put: anObject!

uintPtrAtOffset: anInteger 
	"Answer the machine word sized integer value (i.e. may be 32 or 64-bit, depending on host
	OS) at offset (i.e. zero relative) anInteger in the memory pointed at by the receiver. 

	Primitive failure reasons:
		0 -	anInteger is not a SmallInteger"

	| answer |
	<primitive: 184>
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
		2 -	anObject is not a SmallInteger or in the representable range."

	<primitive: 185>
	^self retryUIntPtrAtOffset: anInteger put: anObject!

value
	"Answer the value of the receiver (the address itself)"

	^self!

value: anInteger 
	"Set the receiver's address value to be anInteger. Answer the receiver.
	Use the basic version of the accessor to avoid the implicit indirection."

	self basicUIntPtrAtOffset: 0 put: anInteger!

wordAtOffset: anInteger
	"Answer the unsigned 2 byte integer at offset (i.e. zero relative) anInteger in the 
	memory pointed at by the receiver.
	On iX86 the high and low order bytes are reversed; i.e. the bytes are ordered least 
	significant first. A GP Fault interrupt will occur if an attempt is made to read inaccessible
	memory via this method. This will not affect the stability of the system.

	Primitive failure reasons:
		0 -	anInteger is not a SmallInteger."

	| answer |
	<primitive: 138>
	answer := 0.
	1 to: 0 by: -1 do: [:i |
		answer := (answer bitShift: 8) + (self byteAtOffset: anInteger + i)].
	^answer!

wordAtOffset: anInteger put: anObject
	"Store an unsigned 2 byte value at byte offset anInteger within the receiver.
	If anObject is not representable as a 16-bit unsigned (Small)Integer, then 
	raise a 'cannot hold' error.

	Primitive failure reasons:
		0 -	anInteger is not a SmallInteger.
		2 -	anObject is not a SmallInteger.
		3 -	anObject is not in the range 0..65535 (i.e. out of unsigned 16-bit range)."

	<primitive: 139>
	^self retryWordAtOffset: anInteger put: anObject!

yourAddress
	"Answer the address at which the receiver points, rather than the address of 
	the receiver's bytes"

	^self asInteger! !
!ExternalAddress categoriesFor: #approxSize!accessing!private! !
!ExternalAddress categoriesFor: #asExternalAddress!converting!public! !
!ExternalAddress categoriesFor: #asInteger!accessing!public! !
!ExternalAddress categoriesFor: #at:!accessing!public! !
!ExternalAddress categoriesFor: #at:put:!accessing!public! !
!ExternalAddress categoriesFor: #byteAtOffset:!accessing!primitives!public! !
!ExternalAddress categoriesFor: #byteAtOffset:put:!accessing!primitives!public! !
!ExternalAddress categoriesFor: #deepCopy!copying!public! !
!ExternalAddress categoriesFor: #detach!public!realizing/unrealizing! !
!ExternalAddress categoriesFor: #displayOn:!displaying!public! !
!ExternalAddress categoriesFor: #dwordAtOffset:!accessing!primitives!public! !
!ExternalAddress categoriesFor: #dwordAtOffset:put:!accessing!primitives!public! !
!ExternalAddress categoriesFor: #intPtrAtOffset:!accessing!primitives!public! !
!ExternalAddress categoriesFor: #intPtrAtOffset:put:!accessing!primitives!public! !
!ExternalAddress categoriesFor: #replaceBytesOf:from:to:startingAt:!double dispatch!primitives!private!replacing! !
!ExternalAddress categoriesFor: #resize:!mutating!public! !
!ExternalAddress categoriesFor: #sdwordAtOffset:!accessing!primitives!public! !
!ExternalAddress categoriesFor: #sdwordAtOffset:put:!accessing!primitives!public! !
!ExternalAddress categoriesFor: #species!constants!public! !
!ExternalAddress categoriesFor: #stbSaveOn:!binary filing!public! !
!ExternalAddress categoriesFor: #swordAtOffset:!accessing!primitives!public! !
!ExternalAddress categoriesFor: #swordAtOffset:put:!accessing!primitives!public! !
!ExternalAddress categoriesFor: #uintPtrAtOffset:!accessing!primitives!public! !
!ExternalAddress categoriesFor: #uintPtrAtOffset:put:!accessing!primitives!public! !
!ExternalAddress categoriesFor: #value!accessing!public! !
!ExternalAddress categoriesFor: #value:!accessing!public! !
!ExternalAddress categoriesFor: #wordAtOffset:!accessing!primitives!public! !
!ExternalAddress categoriesFor: #wordAtOffset:put:!accessing!primitives!public! !
!ExternalAddress categoriesFor: #yourAddress!accessing!public! !

!ExternalAddress class methodsFor!

alignment
	"Answer the natural alignment for instances of the receiver when 
	embedded in arrays or other structures."

	^VMConstants.IntPtrSize!

fieldType
	"Private - Answer the <ExternalField> type to be used to represent the receiver's field type in 
	other structures."

	^LPVOIDField!

fromAddress: anAddress
	"Answer a new instance of the receiver with contents *copied* from
	the DWORD pointed at by anAddress (this is not a reference object
	and so must copy in response to #fromAddress:)"

	^self fromInteger: anAddress!

fromBytes: aByteArray
	"Not quite sure what to do here, so assume ByteArray contains an address"

	^self fromInteger: aByteArray!

fromInteger: anInteger
	"Answer a new instance of the receiver with contents copied from anInteger
	Implementation note: Override superclass to make use of the external call
	primitive coercion trick."

	^VMLibrary default addressFromInteger: anInteger! !
!ExternalAddress class categoriesFor: #alignment!constants!public! !
!ExternalAddress class categoriesFor: #fieldType!constants!development!private! !
!ExternalAddress class categoriesFor: #fromAddress:!instance creation!public! !
!ExternalAddress class categoriesFor: #fromBytes:!instance creation!public! !
!ExternalAddress class categoriesFor: #fromInteger:!instance creation!public! !

