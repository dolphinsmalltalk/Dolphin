"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'External.Structure'
	instanceVariableNames: 'bytes'
	classVariableNames: 'RecordClasses'
	imports: #()
	classInstanceVariableNames: 'template flags alignment'
	classConstants: {
		'CompiledMask' -> 16r1
	}!
External.Structure guid: (Core.GUID fromString: '{87b4c489-026e-11d3-9fd7-00a0cc3e4a32}')!
External.Structure isNonInstantiable: true!
External.Structure comment: ''!
!External.Structure categoriesForClass!External-Data-Structured! !
!External.Structure methodsFor!

_deepenShallowCopy: clone trail: copiesDictionary
	"Private - Deepen the argument, clone, which is a shallow copy of the receiver.
	Answer the deepened shallow copy (or another object to represent the deep copy
	if you so desire - though if you do this you must update the copiesDictionary).
	We need to override this in order to correctly deepen the contents instance
	variable which might be an external address - if so we copy the data pointed
	at, so that the clone is a true deep copy, and does not reference any of the
	same data as the receiver."

	self isNull 
		ifFalse: 
			["Create a new copy of the internal/referenced data"

			clone
				initialize: self byteSize;
				copyBytes: bytes].
	"Use the standard implementation for the rest of the object"
	2 to: self class instSize + self basicSize
		do: [:i | clone instVarAt: i put: ((clone instVarAt: i) _deepCopy: copiesDictionary)].
	^clone!

= anExternalStructure
	"Answer whether the receiver is equivalent to anExternalStructure.
	Two external structures are considered equivalent if they are of 
	the same type, and they contain the same bytes."

	^self == anExternalStructure or: 
			[self species == anExternalStructure species and: 
					[| isNull |
					(isNull := self isNull) == anExternalStructure isNull and: 
							[isNull or: 
									[(CRTLibrary default
										memcmp: self
										buf2: anExternalStructure
										count: self comparisonSize) == 0]]]]!

alignment
	"Answer the alignment required for instances of the receiver when 
	embedded in arrays or other structures"

	^self class alignment!

asByteArray
	"Answer the raw contents of the receiver as a byte array."

	^self
		copy: ByteArray
		from: 1
		to: self byteSize!

asObject
	"Answer the <Object> value represented by the receiver."

	^self value!

asParameter
	"Answer the receiver in a form suitable for passing
	to an ExternalLibrary call. Although ExternalStructures can be passed to 
	#lpvoid parameter types directly, it is more useful if we answer the contents
	as this allows, for example, DWORDs to be passed as #dword parameters."

	^bytes!

basicFree
	"Private - Free external resources owned by the receiver.
	This is a default implementation which relieves subclasses from
	the responsibility of providing both class (freeElement:) and instance 
	side (#basicFree) methods."

	self class clear: bytes!

beNullHeapPointer
	"Private - Set the receiver's contents to be a NULL heap pointer."

	self initializeAtAddress: self heapPointerClass new!

beNullPointer
	"Private - Set the receiver's contents to be a NULL pointer."

	self initializeAtAddress: self pointerClass new!

bufferClass
	"Private - Answer the default class to use as a contents buffer"

	^ByteArray!

bytes
	"Answer the byte buffer which the receiver represents (a (sub)instance of ExternalBytes)."

	^bytes!

bytes: aByteObject
	"Private - Set the contents of the receiver. Answer the receiver."

	bytes := aByteObject!

bytesAtOffset: anInteger put: anExternalStructureOrByteObject
	"Replace the bytes of the receiver from offset anInteger (0 based)
	with those of the argument aVariableByteObject"

	anExternalStructureOrByteObject
		replaceBytesOf: self bytes
		from: anInteger+1 
		to: anInteger + anExternalStructureOrByteObject size
		startingAt: 1!

byteSize
	"Answer the size in bytes of this structure"

	^self class byteSize!

comparisonSize
	"Private - Answer the number of bytes of the receiver to use in comparisons.
	This may be slightly less than the #byteSize in order to exclude any padding
	bytes that are present to fill the structure out to its packing boundary.
	Subclasses should override as necessary."

	^self byteSize!

copy
	"Answer a suitable copy of the receiver, which does not share the same byte data."

	^super copy
		initialize: self byteSize;
		copyBytes: bytes;
		yourself!

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

copyBytes: aByteObject
	"Private - Set the contents of the receiver (as appropriate for the subclass).
	Answer the receiver."

	aByteObject replaceBytesOf: self bytes from: 1 to: self byteSize startingAt: 1!

copyFrom: start to: stop
	"Answer a copy of the bytes of the receiver starting at index start, 
	until index stop, inclusive."

	^self
		copy: ByteArray
		from: start
		to: stop!

copyStringFrom: start to: stop
	"Answer a copy of the bytes of the receiver starting at index start, 
	until index stop, inclusive, as a String."

	^self
		copy: String
		from: start
		to: stop!

detach
	"Detach the receiver from the object at which it is pointing, answering the address
	of that object. This is useful where one wishes to take-over ownership of an object
	which would otherwise be cleaned up when the receiver is finalized."

	| detached |
	detached := self bytes.
	bytes := nil. 
	self beUnfinalizable.	"reduce Memory Manager load"
	^detached!

doesNotUnderstand: aMessage
	"Sent to the receiver by the VM when a message sent to the receiver was 
	not implemented by the receiver or its superclasses. In this case then the 
	selector of aMessage is looked up in the receiver's class' template, and 
	if found the appropriate field is retrieved/set."

	| key |
	(key := aMessage selector) last == $: ifTrue: [key := key copyFrom: 1 to: key size - 1].
	^(self template lookup: key)
		ifNil: [super doesNotUnderstand: aMessage]
		ifNotNil: 
			[:field |
			| args |
			args := aMessage arguments.
			args size == 0
				ifTrue: [field isReadable ifTrue: [^field readFrom: self]]
				ifFalse: [field isWriteable ifTrue: [^field writeInto: self value: (args at: 1)]].
			super doesNotUnderstand: aMessage]!

fieldsDo: aMonadicValuable
	"Evaluate the <monadicValuable> argument, operation, for each of the receiver's fields."

	self getValidFields do: [:field | aMonadicValuable value: (self getField: field)]!

fieldsDo: aMonadicValuable separatedBy: aNiladicValuable
	"Evaluate the <monadicValuable> argument for each of the receiver's fields, interspersed
	with evaluations of the <niladicValuable> argument. The separator is first evaluated after
	the first field, and is not evaluated after the last."

	self getValidFields do: [:field | aMonadicValuable value: (self getField: field)]
		separatedBy: aNiladicValuable!

free
	"Free external resources owned by the receiver.
	Implementation Note: Whether we free the data or not we must
	make sure that we remove any lock for which we are responsible."

	self beUnfinalizable.
	self needsFree ifTrue: [self basicFree].
	bytes := nil!

getField: fieldNameString
	"Answer the value of the named field of the receiver,
	or if there is no such field then raise an exception."

	^self perform: fieldNameString asSymbol!

getValidFields
	"Private - Answer a <sequencedReadableCollection> of the fields defined 
	in the receiver's template, sorted in ascending order of offset from the start of the
	structure, that are valid in this particular instance (some Windows structures
	have a mask field which identifies which of the other fields have been 
	initialized with a value)."

	^self class getFieldNames!

hash
	"Answer the SmallInteger hash value for the receiver.
	In order for internal structure to have the same value as pointer structures
	we use the VM export here."

	^VMLibrary default hashBytes: bytes count: self comparisonSize!

heapPointerClass
	"Private - Answer the default class to use as a heap pointer"

	^External.Memory!

hresultError: anInteger
	"Signal that a member function in the receiver returned the specified
	hresult."

	^HRESULTError signalWith: anInteger!

initialize
	"Private - Perform any initialization required for the receiver
	which is specific to the value form. Answer the receiver.
	To perform reference specific initialization, override #initializePointer."
!

initialize: anInteger
	"Private - Create an external buffer in the receiver of the specified size.
	Some subclasses, particularly for Win32 structures, may want to override
	to set their first member to their size."

	bytes := self bufferClass newFixed: anInteger.
	self initialize!

initializeAtAddress: anAddress 
	"Private - Initialize the receiver to be a reference to an ExternalStructure
	of the receiver's type at the specified address. Any modifications to the 
	receiver will be reflected back into the structure/object at anAddress."

	bytes := anAddress asExternalAddress.
	self initializePointer!

initializePointer
	"Private - Perform any initialization required for the receiver
	which is specific to the reference form. Answer the receiver.
	To perform value specific initialization, override #initialize."!

invalidArgErrorClass
	"Private - Answer the class of Error to be signalled when an argument to one of the receiver's
	external calls is invalid."

	^InvalidExternalCall!

invalidCall: anInteger
	"An invalid virtual call was attempted through one of the receiver's methods."

	| frame descriptor method |
	anInteger >= 0 ifTrue: [self primitiveFailed: anInteger].
	frame := Processor activeProcess topFrame sender.
	method := frame method.
	descriptor := method descriptor.
	"Reporting of errors related to individual arguments is limited to a maximum of 12 arguments, although API functions with such large numbers of parameters are very rare.
	If the error is with parameter 13+, then it will be the generic _PrimitiveFailureCode.InvalidParameter."
	^(anInteger >= _PrimitiveFailureCode.InvalidParameter1
		and: [anInteger <= _PrimitiveFailureCode.InvalidParameter12])
			ifTrue: 
				[| arg i |
				i := descriptor argumentIndexFromOffset: anInteger - _PrimitiveFailureCode.InvalidParameter1.
				arg := frame method isVirtualFunction ifTrue: [i - 1] ifFalse: [i].
				self invalidArgErrorClass
					invalidArgument: arg
					got: (frame arguments at: arg)
					expected: (descriptor argumentTypes at: i)]
			ifFalse: 
				[self hresultError: (descriptor retType == ExtCallArgTypes.ExtCallArgNTSTATUS
							ifTrue: [(HRESULT decodePrimitiveFailureCode: anInteger) bitOr: HRESULT.FACILITY_NT_BIT]
							ifFalse: [HRESULT decodePrimitiveFailureCode: anInteger])]!

isFieldBrowsable: aSymbol
	^self class isFieldBrowsable: aSymbol!

isNull
	"Answer whether the receiver is a null external data item (that is, a null pointer, or a nilled out structure)."

	<primitive: 170>
	^bytes isNull!

isPointer
	"Answer whether the receiver is a pointer to an external data item."

	^bytes class isIndirection!

maxPrint
	"Private - Answer the maximum number of characters to output when appending the 
	receiver's textual representation to a Stream"

	^500!

needsFree
	"Private - Answer whether the receiver requires freeing of any external resources."

	^false!

notNull
	"Answer whether the receiver is not Null (i.e. not equal to 0)."

	^self isNull not!

pointerClass
	"Private - Answer the default class to use as a pointer"

	^External.Address!

printString
	"Answer a <readableString> whose characters are a description of the receiver 
	as a developer would want to see it."

	^self printStringLimitedTo: self maxPrint!

replaceBytesOf: aByteObject from: start to: stop startingAt: fromStart
	"Private - Standard method for transfering bytes from one variable
	byte object to another, normally double dispatched."

	^bytes replaceBytesOf: aByteObject from: start to: stop startingAt: fromStart!

replaceFrom: start to: stop  with: aByteObject startingAt: fromStart
	"Standard method for transfering bytes from one variable
	byte object to another. See String>>replaceFrom:to:with:startingAt:"

	aByteObject replaceBytesOf: self bytes from: start to: stop startingAt: fromStart!

setField: fieldNameString value: anObject
	"Set the value of the named field of the receiver,
	or if there is no such field then raise an exception."

	^self perform: (fieldNameString, ':') asSymbol with: anObject!

size
	"Answer the size of the receiver's contents (more useful)."

	^self byteSize!

template
	"Private - Answer the receiver's structure template (defines the types and 
	offsets of the fields). Can be overridden by subclasses which wish to vary	
	the template on an instance specific basis, e.g. for a generic structure
	class."

	^self class template!

value
	"Answer the receiver's value field as an equivalent Smalltalk object."

	^self!

value: anObject
	"Set the value buffered by the receiver to anObject."

	^self copyBytes: anObject!

yourAddress
	"Answer the address of the receiver's contents"

	^bytes yourAddress! !
!External.Structure categoriesFor: #_deepenShallowCopy:trail:!copying!private! !
!External.Structure categoriesFor: #=!comparing!public! !
!External.Structure categoriesFor: #alignment!constants!public! !
!External.Structure categoriesFor: #asByteArray!converting!public! !
!External.Structure categoriesFor: #asObject!accessing!public! !
!External.Structure categoriesFor: #asParameter!converting!public! !
!External.Structure categoriesFor: #basicFree!private!realizing/unrealizing! !
!External.Structure categoriesFor: #beNullHeapPointer!modes!private! !
!External.Structure categoriesFor: #beNullPointer!modes!private! !
!External.Structure categoriesFor: #bufferClass!constants!private! !
!External.Structure categoriesFor: #bytes!accessing!public! !
!External.Structure categoriesFor: #bytes:!initializing!private! !
!External.Structure categoriesFor: #bytesAtOffset:put:!accessing!public! !
!External.Structure categoriesFor: #byteSize!accessing!public! !
!External.Structure categoriesFor: #comparisonSize!accessing!private! !
!External.Structure categoriesFor: #copy!copying!public! !
!External.Structure categoriesFor: #copy:from:to:!copying!private! !
!External.Structure categoriesFor: #copyBytes:!accessing!private! !
!External.Structure categoriesFor: #copyFrom:to:!copying!public! !
!External.Structure categoriesFor: #copyStringFrom:to:!copying!public! !
!External.Structure categoriesFor: #detach!public!realizing/unrealizing! !
!External.Structure categoriesFor: #doesNotUnderstand:!exceptions!public! !
!External.Structure categoriesFor: #fieldsDo:!enumerating!public! !
!External.Structure categoriesFor: #fieldsDo:separatedBy:!enumerating!public! !
!External.Structure categoriesFor: #free!public!realizing/unrealizing! !
!External.Structure categoriesFor: #getField:!accessing!public! !
!External.Structure categoriesFor: #getValidFields!accessing!private! !
!External.Structure categoriesFor: #hash!comparing!public! !
!External.Structure categoriesFor: #heapPointerClass!constants!private! !
!External.Structure categoriesFor: #hresultError:!exceptions!public! !
!External.Structure categoriesFor: #initialize!initializing!private! !
!External.Structure categoriesFor: #initialize:!initializing!private! !
!External.Structure categoriesFor: #initializeAtAddress:!initializing!private! !
!External.Structure categoriesFor: #initializePointer!initializing!private! !
!External.Structure categoriesFor: #invalidArgErrorClass!constants!private! !
!External.Structure categoriesFor: #invalidCall:!exceptions!public! !
!External.Structure categoriesFor: #isFieldBrowsable:!printing!private! !
!External.Structure categoriesFor: #isNull!public!testing! !
!External.Structure categoriesFor: #isPointer!public!testing! !
!External.Structure categoriesFor: #maxPrint!constants!private! !
!External.Structure categoriesFor: #needsFree!private!realizing/unrealizing! !
!External.Structure categoriesFor: #notNull!public!testing! !
!External.Structure categoriesFor: #pointerClass!constants!private! !
!External.Structure categoriesFor: #printString!printing!public! !
!External.Structure categoriesFor: #replaceBytesOf:from:to:startingAt:!double dispatch!private!replacing! !
!External.Structure categoriesFor: #replaceFrom:to:with:startingAt:!public!replacing! !
!External.Structure categoriesFor: #setField:value:!accessing!public! !
!External.Structure categoriesFor: #size!accessing!public! !
!External.Structure categoriesFor: #template!constants!private! !
!External.Structure categoriesFor: #value!accessing!public! !
!External.Structure categoriesFor: #value:!accessing!public! !
!External.Structure categoriesFor: #yourAddress!accessing!public! !

!External.Structure class methodsFor!

alignment
	"Answer the natural alignment for instances of the receiver when embedded in arrays or other
	structures. This is the natural alignment of the largest field in the receiver. The actual
	alignment used may be different if the structure packing overrides it."

	self ensureDefined.
	^alignment!

atAddress: anAddress
	"Answer a new instance of the receiver instantiated from the
	data at the specified address. Normally  this will be a 'reference' 
	instance, that points at the data embedded	at the specified address. 
	However in the case of objects that always have reference form
	(e.g. COM interface pointers, BSTRs, etc) this will be a copy
	of the pointer at that address. This is particularly useful for accessing
	elements of arrays."

	^self fromAddress: anAddress!

baseAlignment
	^self == ##(self) ifTrue: [1] ifFalse: [self superclass alignment]!

basicByteSize
	"Answer the size (in bytes) of the structure the receiver represents, or zero if not yet defined."

	<primitive: 151>
	^self extraInstanceSpec!

beCompiled
	"Mark the receiver as a structure which is to be compiled"

	flags := flags maskSet: CompiledMask!

beUncompiled
	"Mark the receiver as a structure which is not to be compiled"

	flags := flags maskClear: CompiledMask
!

byteSize
	"Answer the size (in bytes) of the structure the receiver represents"

	self ensureDefined.	"ensure the byte size has been calculated by lazy template accessor"
	^self basicByteSize!

byteSize: anInteger
	"Private - Set the size (in bytes) of the structure the receiver represents"

	(anInteger between: 0 and: 2 ** 15 - 1)
		ifFalse: [self error: ('Invalid structure size <1p>' expandMacrosWith: anInteger)].
	self extraInstanceSpec: anInteger!

canUnderstand: aSymbol
	^(super canUnderstand: aSymbol) or: 
			[| size field |
			size := aSymbol size.
			(aSymbol at: size) == $:
				ifTrue: 
					[field := self template lookup: (aSymbol copyFrom: 1 to: size - 1).
					field notNil and: [field isWriteable]]
				ifFalse: 
					[field := self template lookup: aSymbol.
					field notNil and: [field isReadable]]]!

changedByteSizeFrom: oldByteSize
	"Private - If the size of the receiver changes such that it fits into a different type for passing/returning structures by value, then we must recompile all existing referencing methods that might have a static literal snapshot of the byte size of the receiver."

	oldByteSize ~= self byteSize ifFalse: [^self].
	self recompileReferences!

clear: addressOrBytes
	"Finalize an instance of the structure which instances of the receiver wrap
	which resides at the specified address. Note that this is not about freeing
	the specified memory block, but any resources which it references."!

defineField: fieldName type: anExternalField
	"Add the argument anExternalField as the next field of the receiver's template, 
	with the name, fieldName"

	| offset |
	offset :=self structurePacker offsetFor: anExternalField base: self basicByteSize.
	self defineField: fieldName type: anExternalField offset: offset.
!

defineField: fieldName type: anExternalField offset: offset
	"Add the argument anExternalField as the next field of the receiver's template, 
	with the name, fieldName, and the <integer> byte offset in the structure, offset.
	N.B. This should only be used where the offset is known, note also that the
	byte size is updated if the field is added at the end."

	| offsetConstant |
	anExternalField structClass: self.
	self isCompiled ifFalse: [anExternalField beUncompiled].
	alignment := alignment max: anExternalField alignment.
	anExternalField offset: offset.
	self byteSize: (self basicByteSize max: offset + anExternalField byteSize).
	"We always retain the read selector in the template - this is needed to calc the field
	offset when compiling methods, and might be required for evaluating size_is expressions."
	template at: fieldName asSymbol put: anExternalField.
	"Define a class constant for the field offset, if needed"
	offsetConstant := self fieldOffsetConstantPrefix , fieldName.
	(self hierarchyBindingFor: offsetConstant) ifNotNil: [:var | var value == offset ifTrue: [^self]].
	"If the offset has changed, any referencing methods will be automatically recompiled by the standard mechanism for class constants"
	self addClassConstant: offsetConstant value: offset!

defineFields
	"Set the structure template for the receiver. Implemented
	by subclasses which wish to make use of the Structure Template
	support"

!

definesNewFields
	"Private - Answer whether the receiver defines any new fields, as opposed to
	just inheriting the lot from a superclass."

	^self class includesSelector: #defineFields!

defineTemplate
	"Initialize the receiver class' structure template.
	Implementation Note: We try and share a superclass template if we don't directly implement #defineFields in a particular class. This is a space saving measure, and is necessary because 'template' is a class instance variable."

	| oldByteSize |
	oldByteSize := self extraInstanceSpec.
	self definesNewFields
		ifTrue: 
			[self
				initializeTemplate;
				defineFields;
				byteSize: (self structurePacker paddedSizeFor: self basicByteSize).
			template shrink]
		ifFalse: 
			["Receiver doesn't define any new fields, so inherit the lot"
			self inheritTemplate].
	self removeRedundantOffsetConstants.
	template notNil ifTrue: [self changedByteSizeFrom: oldByteSize]!

descriptorClass
	"Private - Return the class of external function descriptor associated with
	the receiver."

	^FunctionDescriptor!

dynamicSelectorsDo: aMonadicValuable
	"Evaluate the <monadicValuable> argument for each of the extra message selectors understood by the receiver at run time that might not have an associated method."

	self template keysAndValuesDo: 
			[:fieldName :field |
			field isReadable ifTrue: [aMonadicValuable value: fieldName].
			field isWriteable ifTrue: [aMonadicValuable value: (fieldName copyWith: $:) asSymbol]]!

elementSize
	"Answer the size (in bytes) of the structure the receiver represents
	when used as an array element."

	^self byteSize!

ensureDefined
	template isNil ifTrue: [self defineTemplate]	"ensure the structure accessors are correctly defined"!

fieldNamesFromTemplate
	| answer pairs |
	pairs := self template associations.
	answer := OrderedCollection new: pairs size.
	(pairs asSortedCollection: 
			[:x :y |
			| xoff yoff |
			xoff := x value offset.
			yoff := y value offset.
			xoff == yoff ifTrue: [x key <= y key] ifFalse: [xoff < yoff]])
		do: [:assoc | (assoc key last == $: or: [assoc value isFiller]) ifFalse: [answer add: assoc key]].
	^answer!

fieldOffsetConstantPrefix
	^'_OffsetOf_'!

fromAddress: anAddress 
	"Answer a new instance that points to the ExternalAddress 
	respresented by anAddress (which responds to the protocol
	#isNull and #asExternalAddress).
	Implementation Note: If anAddress is the null pointer then 
	the answer is nil. This behaviour is useful when referencing
	an ExternalStructure from a PointerField, since such pointers
	are commonly Null."

	^anAddress isNull 
		ifFalse: 
			[self ensureDefined.
			self basicNew initializeAtAddress: anAddress]!

fromBytes: aByteObject
	"Answer a new instance of the receiver with contents copied from aByteObject"

	^self new copyBytes: aByteObject!

getFieldNames
	"Private - Answer a <sequencedReadableCollection> of the fields defined 
	in the receiver's template, sorted in ascending order of offset from the start of the
	structure, that may be valid in this class of structure."

	^self fieldNamesFromTemplate!

inheritTemplate
	| ancestor |
	ancestor := self superclass.
	self byteSize: ancestor byteSize.
	template := ancestor template.
	alignment := ancestor alignment!

init: buffer
	"Initialize a buffer (or buffer at the specified address) to hold an instance of the record type
	described by the receiver. Assumes that the memory is completely uninitialized."

	KernelLibrary default zeroMemory: buffer length: self byteSize!

initializeAfterLoad
	"Private - Ensure the template is removed. This could have been incorrectly initialised
	during compilation of methods on load that caused the template to be lazily initialised
	BEFORE the #defineFields method had been loaded, or before any pre-requisite structures were
	correctly defined. Therefore we discard any existing template and leave it up to lazy
	initialisation to ensure the templates are built correctly and the relevant methods
	recompiled."

	self resetTemplate.
	super initializeAfterLoad!

initializeTemplate
	"Private - Initialize the template instance variables of the receiver."

	self resetTemplate.
	self newTemplate!

isCompiled
	"Private - Answer whether the receiver is a compiled definition (i.e. methods have been generated
	from the template)."

	^flags anyMask: CompiledMask!

isFieldBrowsable: aSymbol
	template notNil
		ifTrue: [(template at: aSymbol ifAbsent: []) ifNotNil: [:field | ^field isBrowsable]].
	^self canUnderstand: aSymbol!

libraryAndIndex
	"Answer an <Asssociation> between an <AXTypeLibraryAnalyzer> on the receiver's type library
	and the index of the receiver's type information in that library, or nil if no type information is
	available."

	^nil!

new
	"Answer a instance of the receiver. This may be either an internal buffer
	(containing a <ByteArray>) or a reference to an external buffer (containing
	a <ExternalAddress>), as appropriate for the subclass. The default is an 
	internal buffer."

	^self newBuffer!

new: anInteger
	"Answer a new instance of the receiver containing a buffer of the specified size.
	N.B. It is not normally necessary to specify the size of an ExternalStructure, because
	the subclasses normally know. However some structures may be of variable length."

	^super new
		initialize: anInteger!

new: anInteger bufferClass: bufferClass
	"Answer a new instance of the receiver containing a buffer of the specified size
	allocated by the specified buffer class."

	^super new
		bytes: (bufferClass newFixed: anInteger);
		initialize;
		yourself
!

newBuffer
	"Answer a new instance containing its own buffer."

	^self new: self byteSize!

newBufferClass: bufferClass
	"Answer a new instance of the receiver containing a buffer of the receiver's size
	allocated by the specified buffer class."

	^self new: self byteSize bufferClass: bufferClass!

newHeapPointer
	"Answer a new instance of the receiver suitable for use as a reference
	to an object allocated by some third party from the heap, but which
	we must free."

	^self basicNew beNullHeapPointer!

newPointer
	"Answer a new instance of the receiver suitable for use as a reference
	to an externally allocated object."

	^self basicNew beNullPointer!

newPointer: pointerClass
	"Answer a new instance of the receiver suitable for use as a reference
	to an externally allocated object, using the specified pointer class (e.g.
	OS.COM.TaskMemory)"

	^self basicNew initializeAtAddress: pointerClass new!

newTemplate
	"Private - Reset the template instance variable of the receiver in preparation for loading a
	new template."

	template := LookupTable new.
	alignment := self baseAlignment!

offsetFor: anExternalField base: anInteger 
	"Answer the adjusted offset for the <ExternalField> from the base offset, anInteger.
	Typically this will round up to some granularity which is the minimum off the field size and
	the structure packing (typically 8) - e.g. 32-bit field typically packed to a four byte
	boundary, a 12-byte structure would be packed to an 8-byte boundary.."

	^anInteger roundUpTo: (anExternalField alignment min: self packing)!

offsetOf: aSymbol
	"Answer the offset of the named field, or -1 if there is no such field."

	self template ifNotNil: [:dict | (dict lookup: aSymbol) ifNotNil: [:field | ^field offset]].
	^-1!

packing
	"Answer the default packing for instances of the receiver. N.B. This corresponds to the C
	compiler's /Zp parameter, and is the maximum alignment to which members of the structure
	after the first are padded. Each field type has a natural alignment (e.g. ints align to
	32-bit boundaries), and it is the smaller of the packing and the natural alignment which is
	used to decide the padding necessary for the field in the structure. Consider this simple
	example:

	struct S { char ch; int i; };

	1-byte packing (/Zp1) would pack fields on 1 byte boundaries so 'i' would be contiguous with
	'ch', i.e. the offset of 'i' would be 1. 2-byte packing (/Zp2) would align on 2 byte
	boundaries so there would need to be be one byte of padding between 'ch' and 'i', i.e. the
	offset of 'i' would be 2. 4-byte packing would align on 4 byte boundaries so there would
	need to be three bytes of padding between 'ch' and 'i', i.e. the offset of 'i' would be 4,
	making it naturally aligned. 8-byte packing (/Zp8) would be no different to 4-byte in this
	case because the natural alignment of 'i' is 4. If 'i' were an intptr, then seven bytes of
	padding would be needed to align to an 8-byte boundary (i.e. start at offset 8) on a 64-bit
	platform.

	Note that packing a structure so that fields are not aligned naturally can have very
	significant performance impact, particularly on 64-bit platforms.

	For Win32 and Win64 the default packing is 8."

	^8!

paddedSizeFor: size
	"Answer the adjusted size for the receiver rounded up from the 
	<integer>, size. Structures are padded so that there size is rounded
	up to the minimum of their natural alignment (which is the alignment
	of the largest member) and the packing setting 
	You may need to override this (or preferably the #packing method)
	if the external structure is compiled with a different packing (/Zp or 
	#pragma pack)"

	^self offsetFor: self base: size!

pointerClass
	"Private - Answer the default class to use as a pointer"

	^External.Address!

recompileReferences
	"Private - Recompile all directly referencing external call methods that might need to
	change if the receiver's size changes such any External.DynamicLinkLibrary FFI methods that reference
	the class and might be passing/returning by value (the calling conventions vary depending on
	the structure length), AND any External.Structure methods that might be using static
	expressions to get the byte-size."

	| pred binding |
	binding := self bindingOrNil.
	binding isNil
		ifTrue: 
			["Not installed, so can't be any references."
			^self].
	Notification signal: ('Recompiling references to <1p> (size <2p>)...' expandMacrosWith: self
				with: self basicByteSize).
	pred := self referenceFilterFor: binding.
	DynamicLinkLibrary
		allMethodsDo: [:each | (each isExternalCall and: [pred value: each]) ifTrue: [each recompile]].
	Structure allMethodsDo: 
			[:each |
			((each refersToLiteral: #basicByteSize) and: [pred value: each]) ifTrue: [each recompile]]!

register
	"(Re)Register the receiver's as the Record class for its GUID.
	This is used to map VT_RECORD <VARIANT>s and <SAFEARRAY>s
	back to the appropriate <ExternalStructure> class."

	self registerClass: self forGUID: _guid!

registerClass: structureClass forGUID: aGUID
	"Register the specified <External.Structure> class as the Record class
	for the specified <GUID>. Any existing registration is first removed.
	If the <GUID> is null, then only the removal occurs."

	| existingKey |
	RecordClasses isNil ifTrue: [^self].
	existingKey := RecordClasses keyAtValue: structureClass ifAbsent: [].
	existingKey isNil ifFalse: [RecordClasses removeKey: existingKey].
	aGUID isNull ifFalse: [RecordClasses at: aGUID put: structureClass]!

removeRedundantOffsetConstants
	| prefix redundant |
	classPool isNil ifTrue: [^self].
	prefix := self fieldOffsetConstantPrefix.
	redundant := OrderedCollection new.
	classPool associationsDo: 
			[:each |
			| varName |
			varName := each key.
			((varName beginsWith: prefix) and: 
					[template isNil or: 
							[| fieldName |
							fieldName := (varName copyFrom: prefix size + 1) asSymbol.
							(template includesKey: fieldName) not or: 
									[| binding |
									binding := superclass hierarchyBindingFor: varName.
									binding notNil and: [binding value == each value]]]])
				ifTrue: [redundant add: varName]].
	redundant do: [:each | self removeClassVarName: each]!

resetTemplate
	self byteSize: 0.
	flags := CompiledMask.
	alignment := template := nil!

setGuid: aGUID
	"Private - Set the value of the receiver's 'guid' instance variable to the 
	<GUID>, aGUID.
	Implementation Note: Override to register the structure in the table mapping GUIDs
	to record classes."

	_guid ~= aGUID ifTrue: [
		super setGuid: aGUID.
		self register]
!

stbReadFrom: anSTBInFiler format: anSTBClassConversion 
	self ensureDefined.
	^super stbReadFrom: anSTBInFiler format: anSTBClassConversion!

structurePacker
	"Answer the object which implements the structure packing algorithm
	for use with the receiver.  The object must respond to the <structurePacker>
	protocol."

	^self!

template
	"Private - Answer the receiver's structure template (defines the types and 
	offsets of the fields)"

	self ensureDefined.
	^template!

uninitializeBeforeRemove
	"Perform any pre-removal uninitialisation for the class.
	We need to unregister all subclasses as they are removed. This
	can't be done by #uninitialize since this only gets sent to classes
	that explicitly implement it; i.e. it is not inherited by our subclasses."

	_guid notNil ifTrue: [self unregister].
	template := _guid := nil.
	super uninitializeBeforeRemove!

unregister
	"Unregister the receiver as a Record class for its guid."

	(_guid notNil and: [RecordClasses notNil]) ifTrue: [
		RecordClasses removeKey: _guid ifAbsent: []]!

withBytes: aByteObject 
	"Answer a new instance of the receiver with the arguments as its contents"

	self ensureDefined.
	^(self basicNew)
		bytes: aByteObject;
		initialize;
		yourself! !
!External.Structure class categoriesFor: #alignment!constants!public! !
!External.Structure class categoriesFor: #atAddress:!instance creation!public! !
!External.Structure class categoriesFor: #baseAlignment!private!template definition! !
!External.Structure class categoriesFor: #basicByteSize!accessing!public! !
!External.Structure class categoriesFor: #beCompiled!modes!public!template definition! !
!External.Structure class categoriesFor: #beUncompiled!modes!public!template definition! !
!External.Structure class categoriesFor: #byteSize!accessing!public! !
!External.Structure class categoriesFor: #byteSize:!initializing!private! !
!External.Structure class categoriesFor: #canUnderstand:!methods-testing!public! !
!External.Structure class categoriesFor: #changedByteSizeFrom:!private!template definition! !
!External.Structure class categoriesFor: #clear:!public!realizing/unrealizing! !
!External.Structure class categoriesFor: #defineField:type:!public!template definition! !
!External.Structure class categoriesFor: #defineField:type:offset:!public!template definition! !
!External.Structure class categoriesFor: #defineFields!public!template definition! !
!External.Structure class categoriesFor: #definesNewFields!private!template definition!testing! !
!External.Structure class categoriesFor: #defineTemplate!public!template definition! !
!External.Structure class categoriesFor: #descriptorClass!constants!private! !
!External.Structure class categoriesFor: #dynamicSelectorsDo:!compiling!methods-accessing!public! !
!External.Structure class categoriesFor: #elementSize!accessing!public! !
!External.Structure class categoriesFor: #ensureDefined!instance creation!private! !
!External.Structure class categoriesFor: #fieldNamesFromTemplate!accessing!private! !
!External.Structure class categoriesFor: #fieldOffsetConstantPrefix!constants!private!template definition! !
!External.Structure class categoriesFor: #fromAddress:!instance creation!public! !
!External.Structure class categoriesFor: #fromBytes:!instance creation!public! !
!External.Structure class categoriesFor: #getFieldNames!accessing!private! !
!External.Structure class categoriesFor: #inheritTemplate!private!template definition! !
!External.Structure class categoriesFor: #init:!initializing!public! !
!External.Structure class categoriesFor: #initializeAfterLoad!development!initializing!private! !
!External.Structure class categoriesFor: #initializeTemplate!private!template definition! !
!External.Structure class categoriesFor: #isCompiled!private!testing! !
!External.Structure class categoriesFor: #isFieldBrowsable:!printing!private! !
!External.Structure class categoriesFor: #libraryAndIndex!constants!public! !
!External.Structure class categoriesFor: #new!instance creation!public! !
!External.Structure class categoriesFor: #new:!instance creation!public! !
!External.Structure class categoriesFor: #new:bufferClass:!instance creation!public! !
!External.Structure class categoriesFor: #newBuffer!instance creation!public! !
!External.Structure class categoriesFor: #newBufferClass:!instance creation!public! !
!External.Structure class categoriesFor: #newHeapPointer!instance creation!public! !
!External.Structure class categoriesFor: #newPointer!instance creation!public! !
!External.Structure class categoriesFor: #newPointer:!instance creation!public! !
!External.Structure class categoriesFor: #newTemplate!private!template definition! !
!External.Structure class categoriesFor: #offsetFor:base:!public!template definition! !
!External.Structure class categoriesFor: #offsetOf:!accessing!public! !
!External.Structure class categoriesFor: #packing!constants!public! !
!External.Structure class categoriesFor: #paddedSizeFor:!public!template definition! !
!External.Structure class categoriesFor: #pointerClass!constants!private! !
!External.Structure class categoriesFor: #recompileReferences!private!template definition! !
!External.Structure class categoriesFor: #register!adding!public! !
!External.Structure class categoriesFor: #registerClass:forGUID:!adding!public! !
!External.Structure class categoriesFor: #removeRedundantOffsetConstants!private!template definition! !
!External.Structure class categoriesFor: #resetTemplate!public!template definition! !
!External.Structure class categoriesFor: #setGuid:!accessing!private! !
!External.Structure class categoriesFor: #stbReadFrom:format:!binary filing!public! !
!External.Structure class categoriesFor: #structurePacker!public!template definition! !
!External.Structure class categoriesFor: #template!accessing!private! !
!External.Structure class categoriesFor: #uninitializeBeforeRemove!class hierarchy-removing!public! !
!External.Structure class categoriesFor: #unregister!public!removing! !
!External.Structure class categoriesFor: #withBytes:!instance creation!public! !

