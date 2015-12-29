"Filed out from Dolphin Smalltalk X6.1"!

ExternalArray subclass: #OLECountedArray
	instanceVariableNames: 'elements'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
OLECountedArray guid: (GUID fromString: '{44A86404-B2FE-11D3-B376-080046056106}')!
OLECountedArray comment: 'OLECountedArray is an abstract base class for counted array structures used by various OLE/COM interfaces to input/output variable length arrays, where the array storage is allocated from COM task memory.'!
!OLECountedArray categoriesForClass!Unclassified! !
!OLECountedArray methodsFor!

asArray
	"Answer an <Array> containing the constituent elements of the receiver."

	^self collect: [:e | e asObject]!

basicLength: anInteger
	"Private - Set the length (in elements, not bytes) of the receiver."
	
	self cElems: anInteger!

cElems
	"Answer the receiver's cElems field as a Smalltalk object."

	^bytes dwordAtOffset: 0!

cElems: anObject 
	"Set the receiver's cElems field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject!

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
	"Answer the receiver's pElems field as a Smalltalk object."

	^(bytes uintPtrAtOffset: ##(self offsetOf: #pElems)) asExternalAddress!

pElems: anObject 
	"Set the receiver's pElems field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #pElems) put: anObject!

uncheckedAt: anInteger 
	"Private - Answer the value at the specified index in the receiver."

	^self elements at: anInteger!

uncheckedAt: anInteger put: anObject 
	"Private - Replace the value at the specified <integer> index in the receiver
	with the <Object> argument."

	^self elements at: anInteger put: anObject! !
!OLECountedArray categoriesFor: #asArray!converting!public! !
!OLECountedArray categoriesFor: #basicLength:!accessing!private! !
!OLECountedArray categoriesFor: #cElems!**compiled accessors**!public! !
!OLECountedArray categoriesFor: #cElems:!**compiled accessors**!public! !
!OLECountedArray categoriesFor: #elements!accessing!private! !
!OLECountedArray categoriesFor: #getElements!accessing!private! !
!OLECountedArray categoriesFor: #initialize!initializing!private! !
!OLECountedArray categoriesFor: #length!accessing!public! !
!OLECountedArray categoriesFor: #needsFree!initializing!private!realizing/unrealizing! !
!OLECountedArray categoriesFor: #onStartup!event handling!private! !
!OLECountedArray categoriesFor: #pElems!**compiled accessors**!public! !
!OLECountedArray categoriesFor: #pElems:!**compiled accessors**!public! !
!OLECountedArray categoriesFor: #uncheckedAt:!accessing!private!testing! !
!OLECountedArray categoriesFor: #uncheckedAt:put:!accessing!private! !

!OLECountedArray class methodsFor!

clear: addressOrBytes
	"Free an instance of the structure which instances of the receiver wrap
	which resides at the specified address."
	
	COMTaskMemory free: (addressOrBytes dwordAtOffset: 4)!

defineFields
	"Define the count field common to OLE counted array structures.
		OLECountedArray compileDefinition
	"

	"Although element type will vary by subclass, useful to define DWORD sized default. Could use
	<ConformantStructureArrayPointerField> here, but hand code accessors for best performance."

	self
		defineField: #cElems type: DWORDField new;
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
!OLECountedArray class categoriesFor: #clear:!public!realizing/unrealizing! !
!OLECountedArray class categoriesFor: #defineFields!initializing!public! !
!OLECountedArray class categoriesFor: #initialize!development!initializing!private! !
!OLECountedArray class categoriesFor: #new:!instance creation!public! !
!OLECountedArray class categoriesFor: #onStartup!event handling!private! !
!OLECountedArray class categoriesFor: #uninitialize!class hierarchy-removing!private! !

