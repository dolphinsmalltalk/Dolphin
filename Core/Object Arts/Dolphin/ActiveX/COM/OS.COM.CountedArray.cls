"Filed out from Dolphin Smalltalk"!

External.ExternalArray
	subclass: #'OS.COM.CountedArray'
	instanceVariableNames: 'elements'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_CountedArray_Size' -> 16r8.
			'_OffsetOf_cElems' -> 16r0.
			'_OffsetOf_pElems' -> 16r4
		}!
OS.COM.CountedArray guid: (Core.GUID fromString: '{44a86404-b2fe-11d3-b376-080046056106}')!
OS.COM.CountedArray isNonInstantiable: true!
OS.COM.CountedArray comment: 'OLECountedArray is an abstract base class for counted array structures used by various OLE/COM interfaces to input/output variable length arrays, where the array storage is allocated from COM task memory.'!
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
	^self subclassResponsibility!

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
	"Private - The system is starting. Modify the state of the receiver to account for the fact
	than any external memory allocated for the receiver during the previous session is no 
	longer accessible."

	self beUnfinalizable.
	self isPointer ifTrue: [
		bytes := nil]!

pElems
	"Answer the <ExternalAddress> value of the receiver's 'pElems' field."

	^(bytes uintPtrAtOffset: _OffsetOf_pElems) asExternalAddress!

pElems: anExternalAddress
	"Set the receiver's 'pElems' field to the value of the argument, anExternalAddress"

	bytes uintPtrAtOffset: _OffsetOf_pElems put: anExternalAddress!

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

byteSize
	^_CountedArray_Size!

clear: addressOrBytes
	"Free an instance of the structure which instances of the receiver wrap
	which resides at the specified address."

	TaskMemory free: (addressOrBytes uintPtrAtOffset: 4)!

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
byteSize!**compiled accessors**!constants!public! !
clear:!public!realizing/unrealizing! !
defineFields!public!template definition! !
initialize!development!initializing!private! !
new:!instance creation!public! !
onStartup!event handling!private! !
uninitialize!class hierarchy-removing!private! !
!

