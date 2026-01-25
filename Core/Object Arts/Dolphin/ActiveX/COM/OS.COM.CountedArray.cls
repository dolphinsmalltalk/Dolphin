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

asArray
	"Answer an <Array> containing the constituent elements of the receiver."

	^self collect: [:e | e asObject]!

basicLength: anInteger
	"Private - Set the length (in elements, not bytes) of the receiver."
	
	self cElems: anInteger!

cElems
	"Answer the <Integer> value of the receiver's 'cElems' field."

	^bytes uint32AtOffset: _OffsetOf_cElems!

cElems: anInteger
	"Set the receiver's 'cElems' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_cElems put: anInteger!

elements
	"Private - Answer the receiver's <ExternalArray> of elements."

	elements isNil ifTrue: [elements := self getElements].
	^elements!

getElements
	"Private - Answer the receiver's <ExternalArray> of elements."

	^StructureArray 
		fromAddress: self pElems
		length: self cElems
		elementClass: self elementClass!

initialize
	"Private - Initialize the receiver (common to internal [value] and
	external [reference] buffers.
	These objects are finalizable since they may reference owned external
	resources."

	self beFinalizable!

isSelfEvaluating
	^false!

length
	"Answer the number of elements in the receiver."

	^length := self cElems!

needsFree
	"Private - Answer whether the receiver requires freeing of any external resources.
	In most cases we don't want to free if this object is a reference to a structure
	embedded in an buffer, since that would damage the buffer.
	i.e. it is considered that 'reference' structs do not own the underlying structure as
	this is what is required, for example, in conjunction with StructureArray."

	^self notNull and: [self isPointer not]!

onStartup
	"Private - The system is starting. Modify the state of the receiver to account for the fact than any external memory allocated for the receiver during the previous session is no longer accessible."

	self beUnfinalizable.
	"Since the array of elements is allocated on an external heap, if the CountedArray buffer itself is held in a byte array, we'll get access violations trying to read through the pElems pointer, so we always nil it out."
	bytes := nil!

pElems
	"Answer the <Address> value of the receiver's 'pElems' field."

	^(bytes uintPtrAtOffset: _OffsetOf_pElems) asExternalAddress!

pElems: anAddress
	"Set the receiver's 'pElems' field to the value of the argument, anAddress"

	bytes uintPtrAtOffset: _OffsetOf_pElems put: anAddress!

uncheckedAt: anInteger 
	"Private - Answer the value at the specified index in the receiver."

	^self elements at: anInteger!

uncheckedAt: anInteger put: anObject 
	"Private - Replace the value at the specified <integer> index in the receiver
	with the <Object> argument."

	^self elements at: anInteger put: anObject! !

!OS.COM.CountedArray categoriesForMethods!
asArray!converting!public! !
basicLength:!accessing!private! !
cElems!**compiled accessors**!public! !
cElems:!**compiled accessors**!public! !
elements!accessing!private! !
getElements!accessing!private! !
initialize!initializing!private! !
isSelfEvaluating!public!testing! !
length!accessing!public! !
needsFree!initializing!private!realizing/unrealizing! !
onStartup!event handling!private! !
pElems!**compiled accessors**!public! !
pElems:!**compiled accessors**!public! !
uncheckedAt:!accessing!private!testing! !
uncheckedAt:put:!accessing!private! !
!

!OS.COM.CountedArray class methodsFor!

clear: addressOrBytes
	"Free the counted array body pointed at by the receiver."

	Ole32 coTaskMemFree: (addressOrBytes uintPtrAtOffset: _OffsetOf_pElems)!

defineFields
	"Define the count field common to OLE counted array structures.
		OLECountedArray compileDefinition
	"

	"Although element type will vary by subclass, useful to define DWORD sized default. Could use
	<ConformantStructureArrayPointerField> here, but hand code accessors for best performance."

	self
		defineField: #cElems type: UInt32Field new;
		defineField: #pElems type: LPVOIDField new!

initialize
	"Private - Initialize the receiver.
	Register with session events to clean up sub-instances on startup.
	
		self initialize
	"

	SessionManager current 
		when: #sessionStarted send: #onStartup to: self
!

new: anInteger
	"Answer a new instance of the receiver containing a buffer of the specified size."

	self assert: [anInteger == self byteSize].
	^self basicNew
		initialize: anInteger!

onStartup
	"Private - Notify all the receiver's sub-instances of system startup."

	self primAllSubinstances do: [:i | i onStartup].!

uninitialize
	SessionManager current removeEventsTriggeredFor: self! !

!OS.COM.CountedArray class categoriesForMethods!
clear:!public!realizing/unrealizing! !
defineFields!public!template definition! !
initialize!development!initializing!private! !
new:!instance creation!public! !
onStartup!event handling!private! !
uninitialize!class hierarchy-removing!private! !
!

