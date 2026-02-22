"Filed out from Dolphin Smalltalk"!

External.ExternalArray
	subclass: #'OS.COM.CountedArray'
	instanceVariableNames: 'elements'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { '_OffsetOf_cElems' -> 16r0. '_OffsetOf_pElems' -> 16r4 }!

OS.COM.CountedArray guid: (Core.GUID fromString: '{44a86404-b2fe-11d3-b376-080046056106}')!

OS.COM.CountedArray isNonInstantiable: true!

OS.COM.CountedArray comment: '`OS.COM.CountedArray` is an abstract base class for counted array structures used by various OLE/COM interfaces to input/output variable length arrays, where the array storage is allocated from COM task memory.

Counted arrays always have the same memory layout, which is a 32-bit element count, followed by a pointer to the task memory. On a 32-bit system this will be an 8-byte block. On a 16-bit system it will be 16-bytes because the C compiler inserts 4 bytes of padding to keep the pointer aligned. For example:

```
typedef 
struct tagCAUL {
	ULONG cElems;
	[size_is("cElems")] ULONG* pElems;
} CAUL;
```

Note that if `cElems` is zero, then `pElems` is allowed to be `NULL`, although it need not be. If `pElems` is not `NULL` then it must be a valid pointer allocated from the task memory heap, e.g. with `CoTaskMemAlloc`.

The various structures for counted arrays all have a common layout where the first structure member is an unsigned 32-bit count of the number of elements, and the 2nd is a pointer to the memory block holding the array data. The element block is expected to be allocated from COM task memory. 
* Array elements can be accessed in reference form by sending `#elements`. This accessor will return an `ExternalArray` that points at the unmanaged array in memory, and which itself is an array over the unmanaged elements.
* To obtain the array by value (i.e. an independent copy of the array with elements unmarshalled to appropriate Smalltalk values) send `#value`. 
* The unmanaged array contents can be replaced entirely with `#elements:`, the argument being an appropriate type of `ExternalArray`, or with `#value:`, the argument being a Smalltalk collection of Smalltalk objects that are marshalled to the array''s unmanaged element type. In either case the COM task memory for the original elements must be free''d. This will involve at least freeing the block of task memory allocated for the array itself. For some subtypes (e.g. CALPWSTR) the array elements are themselves allocated from the task heap, and so must be individually free''d. 
* Individual elements of the unmanaged array can be accessed by 1-based integer index with `#at:`. The values returned will be unmarshalled for all scalar element types, updated with `#at:put:`.
* When individual array elements are updated with #at:put:, in cases where the elements are heap allocated these are free''d and reallocated appropriately.

## Instance Variables:
  `elements`	`ExternalArray` subinstance pointing at the elements.

'!

!OS.COM.CountedArray categoriesForClass!External-Data-Structured-COM! !

!OS.COM.CountedArray methodsFor!

allocateElements: anInteger
	| pElems cb |
	anInteger == 0 ifTrue: [^self].
	pElems := Ole32 coTaskMemAlloc: (cb := anInteger * self elementSize).
	Kernel32 zeroMemory: pElems length: cb.
	bytes
		uintPtrAtOffset: _OffsetOf_pElems put: pElems;
		uint32AtOffset: _OffsetOf_cElems put: anInteger.
	self beFinalizable!

arrayClass
	^self elementClass arrayType!

asByteArray
	"Answer a <ByteArray> containing the constituent elements of the receiver."

	^self elements asByteArray!

asExternalArray
	"Answer an <ExternalArray> containing a copy of the receiver's elements."

	^self elements copy!

basicLength: anInteger
	"Private - Set the length (in elements, not bytes) of the receiver."
	
	self cElems: anInteger!

basicUncheckedAt: anInteger 
	"Private - Answer the value at the specified index in the receiver."

	^self elements basicUncheckedAt: anInteger!

basicUncheckedAt: anInteger put: anObject 
	"Private - Replace the element at the specified <integer> index in the receiver with the <Object> argument."

	^self elements basicUncheckedAt: anInteger put: anObject!

byteSize
	"Answer the size in bytes of this structure. In a CountedArray the array elements are out of line in an independently allocated task memory block, so they are not included in the byte size. In fact the byte size of a CountedArray is fixed as they must only ever contain a 32-bit element count, and pointer to the element array."

	"So that pElems is aligned there there are 4 bytes of padding on Win64"

	^##(VMConstants.IntPtrSize * 2)!

cElems
	"Answer the <Integer> value of the receiver's 'cElems' field."

	^bytes uint32AtOffset: _OffsetOf_cElems!

cElems: anInteger
	"Set the receiver's 'cElems' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_cElems put: anInteger!

copyBytes: aByteObject
	self class
		copyBytes: aByteObject
		from: 1
		to: (aByteObject uint32AtOffset: _OffsetOf_cElems) * self elementSize
		into: bytes.
	elements := nil!

elements
	"Answer the receiver's <ExternalArray> of elements."

	^elements ifNil: [elements := self getElements]!

getElements
	^self arrayClass
		fromAddress: (bytes uintPtrAtOffset: _OffsetOf_pElems)
		owner: self fieldOwner 
		length: (bytes uint32AtOffset: _OffsetOf_cElems)
		elementClass: self elementClass!

initialize
	"Private - Initialize the receiver (common to internal [value] and external [reference] buffers.
	These objects are finalizable since the array block is allocated independently from COM task memory. The array elements themselves may also be heap allocated in some concrete subclasses.
	The array block and elements may either be allocated when the counted array is instantiated, or by some external API call to which the receiver is passed to receive output, the latter being the reason we mark the receiver finalizable even if not performing the allocation ourselves."

	super initialize.
	self beFinalizable!

isSelfEvaluating
	^self notNull and: [self elements isSelfEvaluating]!

length
	"Answer the number of elements in the receiver."

	^length := bytes uint32AtOffset: _OffsetOf_cElems!

length: anInteger
	elements ifNil: [self allocateElements: anInteger] ifNotNil: [elements length: anInteger].
	^self!

needsFree
	"Private - Answer whether the receiver requires freeing of any external resources."
	
	"To free a CountedArray, we must release the independently allocated task memory block that is pointed at by pElems. We typically don't need to free the structure memory itself, because that is either allocated from the Smalltalk heap (and will be GC'd), or we are referencing memory owned elsewhere. Therefore, we only need to free value instances."

	^self isValueStruct!

onStartup
	"Private - The system is starting. Modify the state of the receiver to account for the fact than any external memory allocated for the receiver during the previous session is no longer accessible."

	self beUnfinalizable.
	"Since the array of elements is allocated on an external heap, if the CountedArray buffer itself is held in a byte array, we'll get access violations trying to read through the pElems pointer, so we always nil it out."
	bytes := nil!

pElems
	"Answer the <Address> value of the receiver's 'pElems' field."

	^(bytes uintPtrAtOffset: _OffsetOf_pElems) asExternalAddress!

pElems: anExternalArray
	bytes uintPtrAtOffset: _OffsetOf_pElems put: anExternalArray yourAddress!

printEvaluationOn: aStream
	self pElems isNull
		ifTrue: 
			[aStream
				nextPut: $(;
				print: self class;
				nextPutAll: ' new)']
		ifFalse: [super printEvaluationOn: aStream]!

requiresFinalization
	"Answer may hold external resources that need to be freed. Unknowned structures requiring finalization are marked as finalizable."

	^true!

uncheckedAt: anInteger 
	"Private - Answer the value at the specified index in the receiver."

	^self elements uncheckedAt: anInteger!

uncheckedAt: anInteger put: anObject 
	"Private - Replace the value at the specified <integer> index in the receiver
	with the <Object> argument."

	^self elements uncheckedAt: anInteger put: anObject!

value
	^self elements value!

value: anExternalArray
	elements free.
	elements := anExternalArray.
	bytes uintPtrAtOffset: _OffsetOf_pElems put: anExternalArray yourAddress;
		uint32AtOffset: _OffsetOf_cElems put: anExternalArray size! !

!OS.COM.CountedArray categoriesForMethods!
allocateElements:!initializing!private! !
arrayClass!accessing!private! !
asByteArray!converting!public! !
asExternalArray!converting!public! !
basicLength:!accessing!private! !
basicUncheckedAt:!accessing!private!testing! !
basicUncheckedAt:put:!accessing!private! !
byteSize!accessing!public! !
cElems!**compiled accessors**!public! !
cElems:!**compiled accessors**!public! !
copyBytes:!copying!private! !
elements!accessing!private! !
getElements!accessing!private! !
initialize!private! !
isSelfEvaluating!public!testing! !
length!accessing!public! !
length:!accessing!public! !
needsFree!initializing!private!realizing/unrealizing! !
onStartup!event handling!private! !
pElems!**compiled accessors**!public! !
pElems:!accessing!public! !
printEvaluationOn:!printing!private! !
requiresFinalization!public!realizing/unrealizing!testing! !
uncheckedAt:!accessing!private!testing! !
uncheckedAt:put:!accessing!private! !
value!accessing!public! !
value:!accessing!public! !
!

!OS.COM.CountedArray class methodsFor!

alignment
	"Answer the natural alignment for instances of the receiver when embedded in arrays or other structures. This is the natural alignment of the largest field in the receiver. The actual alignment used may be different if the structure packing overrides it."

	"Implementation Note: Unlike most other ExternalArray's, the elements of a CountedArray are stored in a separate buffer referenced by a pointer in the CountedArray. Hence the size of the array elements isn't relevant to the alignment, and we revert to the Structure behaviour of using the alignment of the largest field. In practice the alignment will be that of the pointer, i.e. 4 in a 32-bit system or 8 in a 64-bit system."

	^alignment!

baseAlignment
	^1!

clear: addressOrBytes
	"Free the counted array body pointed at by the receiver."

	Ole32 coTaskMemFree: (addressOrBytes uintPtrAtOffset: _OffsetOf_pElems)!

copyBytes: srcByteObject from: startInteger to: stopInteger into: destByteObject
	| byteSize |
	byteSize := stopInteger - startInteger + 1.
	byteSize == 0
		ifTrue: [destByteObject uintPtrAtOffset: _OffsetOf_pElems put: 0]
		ifFalse: 
			[| pElems elementClass |
			pElems := Ole32 coTaskMemAlloc: byteSize.
			elementClass := self elementClass.
			elementClass arrayType
				copyBytes: (srcByteObject uintPtrAtOffset: _OffsetOf_pElems) asExternalAddress from: startInteger to: stopInteger into: pElems.
			destByteObject
				uintPtrAtOffset: _OffsetOf_pElems put: pElems;
				uintPtrAtOffset: _OffsetOf_cElems put: byteSize / elementClass elementSize].
	^destByteObject!

defineFields
	"Define the count field common to OLE counted array structures.
		CountedArray compileDefinition
	"

	self
		defineField: #cElems type: UInt32Field new;
		defineField: #pElems type: LPVOIDField new!

elementClass
	^self subclassResponsibility!

fromAddress: anAddress owner: anObject
	"We have to override back to the Structure implementation as ExternalArray stubs out"

	^anAddress isNull
		ifFalse: 
			[self template.
			self basicNew initializeAtAddress: anAddress owner: anObject]!

length: countInteger elementSize: sizeInteger bufferClass: bufferClass
	"Private - Answer a new instance of the receiver allocated with space for countInteger elements of sizeInteger bytes."

	^(self basicNew initializeBuffer: bufferClass size: self byteSize)
		length: countInteger;
		yourself!

newBuffer
	"Answer a new buffer instance of the receiver, typically using a ByteArray for the buffer. CountedArray's store the actual elements out of line (and allocated from the external COM Task Memory heap), so here we are creating the buffer for the header structure (which holds a pointer to the element buffer, and a count of the number of elements in that buffer), not the actual elements. The new instance will not have an element buffer allocated. This is usually passed by reference to some API that will allocated the element buffer from task memory and then pointer and count in the header structure."

	^self basicNew initializeBuffer: self bufferClass size: self byteSize!

requiresFinalization
	"Answer whether instances of the receiver that own their own resources will require free'ing either explicitly or by finalization
	The actual array block of CountedArray's is an independent allocation from the task block. The array elements themselves may also be independent allocations."

	^true! !

!OS.COM.CountedArray class categoriesForMethods!
alignment!constants!public! !
baseAlignment!constants!public! !
clear:!public!realizing/unrealizing! !
copyBytes:from:to:into:!copying!private! !
defineFields!public!template definition! !
elementClass!constants!public! !
fromAddress:owner:!instance creation!public! !
length:elementSize:bufferClass:!instance creation!private! !
newBuffer!instance creation!public! !
requiresFinalization!public!realizing/unrealizing!testing! !
!

