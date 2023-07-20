"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'External.Structure'
	instanceVariableNames: 'bytes'
	classVariableNames: 'RecordClasses'
	imports: #()
	classInstanceVariableNames: 'template flags alignment'
	classConstants: {
			'_Structure_Size' -> 16r0.
			'CompileNewFieldsMask' -> 16r1.
			'UncompiledFieldsMask' -> 16r2
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
									[(Ucrt
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
	as this allows, for example, UInt32 to be passed as #uint32 parameters."

	^bytes!

basicFree
	"Private - Free external resources owned by the receiver.
	This is a default implementation which relieves subclasses from
	the responsibility of providing both class (freeElement:) and instance 
	side (#basicFree) methods."

	self class clear: bytes!

beImmutableObject
	bytes beImmutableObject.
	^super beImmutableObject!

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

	| fields fieldName |
	fields := self template.
	self class hasUncompiledFields ifFalse: [^super doesNotUnderstand: aMessage].
	fieldName := aMessage selector.
	fieldName lastCodeUnit == $: ifTrue: [fieldName := fieldName copyFrom: 1 to: fieldName size - 1].
	(fields lookup: fieldName)
		ifNotNil: 
			[:field |
			field isUncompiled
				ifTrue: 
					[| args |
					args := aMessage arguments.
					args size == 0
						ifTrue: [field isReadable ifTrue: [^field readFrom: self]]
						ifFalse: [field isWriteable ifTrue: [^field writeInto: self value: (args at: 1)]]]].
	^super doesNotUnderstand: aMessage!

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

	^VM hashBytes: bytes count: self comparisonSize!

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

	^self class pointerClass!

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

value: anObject
	"Set the value buffered by the receiver to anObject."

	^self copyBytes: anObject!

yourAddress
	"Answer the address of the receiver's contents"

	^bytes yourAddress! !
!External.Structure categoriesForMethods!
_deepenShallowCopy:trail:!copying!private! !
=!comparing!public! !
alignment!constants!public! !
asByteArray!converting!public! !
asObject!accessing!public! !
asParameter!converting!public! !
basicFree!private!realizing/unrealizing! !
beImmutableObject!initializing!public! !
beNullHeapPointer!modes!private! !
beNullPointer!modes!private! !
bufferClass!constants!private! !
bytes!accessing!public! !
bytes:!initializing!private! !
bytesAtOffset:put:!accessing!public! !
byteSize!accessing!public! !
comparisonSize!accessing!private! !
copy!copying!public! !
copy:from:to:!copying!private! !
copyBytes:!accessing!private! !
copyFrom:to:!copying!public! !
copyStringFrom:to:!copying!public! !
detach!public!realizing/unrealizing! !
doesNotUnderstand:!exceptions!public! !
fieldsDo:!enumerating!public! !
fieldsDo:separatedBy:!enumerating!public! !
free!public!realizing/unrealizing! !
getField:!accessing!public! !
getValidFields!accessing!private! !
hash!comparing!public! !
heapPointerClass!constants!private! !
hresultError:!exceptions!public! !
initialize!initializing!private! !
initialize:!initializing!private! !
initializeAtAddress:!initializing!private! !
initializePointer!initializing!private! !
invalidArgErrorClass!constants!private! !
invalidCall:!exceptions!public! !
isFieldBrowsable:!printing!private! !
isNull!public!testing! !
isPointer!public!testing! !
maxPrint!constants!private! !
needsFree!private!realizing/unrealizing! !
notNull!public!testing! !
pointerClass!constants!private! !
printString!printing!public! !
replaceBytesOf:from:to:startingAt:!double dispatch!private!replacing! !
replaceFrom:to:with:startingAt:!public!replacing! !
setField:value:!accessing!public! !
size!accessing!public! !
template!constants!private! !
value:!accessing!public! !
yourAddress!accessing!public! !
!

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

	flags := flags maskSet: CompileNewFieldsMask!

beUncompiled
	"Mark the receiver as a structure which is not to be compiled"

	flags := flags maskClear: CompileNewFieldsMask
!

byteSize
	"Answer the size (in bytes) of the structure the receiver represents"

	template ifNil: [self defineTemplate].
	^self basicByteSize!

byteSize: anInteger
	"Private - Set the size (in bytes) of the structure the receiver represents"

	(anInteger between: 0 and: 2 ** 15 - 1)
		ifFalse: [self error: ('Invalid structure size <1p>' expandMacrosWith: anInteger)].
	self extraInstanceSpec: anInteger!

canUnderstand: aSymbol
	^(super canUnderstand: aSymbol) or: 
			[self hasUncompiledFields and: 
					[| size field |
					(aSymbol at: (size := aSymbol size)) == $:
						ifTrue: 
							[field := self template lookup: (aSymbol copyFrom: 1 to: size - 1).
							field notNil and: [field isWriteable]]
						ifFalse: 
							[field := self template lookup: aSymbol.
							field notNil and: [field isReadable]]]]!

changedByteSizeFrom: anInteger
	"Private - If the size of the receiver changes such that it fits into a different type for passing/returning structures by value, then we must recompile all existing referencing methods that might have a static literal snapshot of the byte size of the receiver."

	| newByteSize |
	newByteSize := self basicByteSize.
	self defineSizeConstant: newByteSize.
	anInteger ~= newByteSize ifFalse: [^self].
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
	self shouldCompileNewFields ifFalse: [anExternalField beUncompiled].
	anExternalField isUncompiled ifTrue: [self hasUncompiledFields: true].
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

defineSizeConstant: newByteSize
	| constName |
	constName := '_<1s>_Size' << (self unqualifiedName ?? '').
	self definesNewFields
		ifTrue: [self addClassConstant: constName value: newByteSize]
		ifFalse: [self removeClassVarName: constName]!

definesNewFields
	"Private - Answer whether the receiver defines any new fields, as opposed to
	just inheriting the lot from a superclass."

	^self class includesSelector: #defineFields!

defineTemplate
	"Initialize and answer the receiver class' structure template.
	Implementation Note: We try and share a superclass template if we don't directly implement #defineFields in a particular class. This is a space saving measure, and is necessary because 'template' is a class instance variable."

	| oldByteSize |
	oldByteSize := self basicByteSize.
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
	template notNil ifTrue: [self changedByteSizeFrom: oldByteSize].
	^template!

descriptorClass
	"Private - Return the class of external function descriptor associated with
	the receiver."

	^FunctionDescriptor!

dynamicSelectorsDo: aMonadicValuable
	"Evaluate the <monadicValuable> argument for each of the extra message selectors understood by the receiver at run time that might not have an associated method."

	| fields |
	fields := self template.
	self hasUncompiledFields ifFalse: [^self].
	fields keysAndValuesDo: 
			[:fieldName :field |
			field isUncompiled
				ifTrue: 
					[field isReadable ifTrue: [aMonadicValuable value: fieldName].
					field isWriteable ifTrue: [aMonadicValuable value: (fieldName , ':') asSymbol]]]!

elementSize
	"Answer the size (in bytes) of the structure the receiver represents
	when used as an array element."

	^self byteSize!

ensureDefined
	^template ifNil: [self defineTemplate]!

fieldNamesFromTemplate
	| answer pairs |
	pairs := self template associations.
	answer := OrderedCollection new: pairs size.
	(pairs sort: 
			[:x :y |
			| xoff yoff |
			xoff := x value offset.
			yoff := y value offset.
			xoff == yoff ifTrue: [x key <= y key] ifFalse: [xoff < yoff]])
		do: [:assoc | (assoc key lastCodeUnit == $: or: [assoc value isFiller]) ifFalse: [answer addLast: assoc key]].
	^answer!

fieldOffsetConstantPrefix
	^'_OffsetOf_'!

flags
	^flags!

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

hasUncompiledFields
	"Private - Answer whether the receiver contains any fields which do not have compiled accessors."

	^flags allMask: UncompiledFieldsMask!

hasUncompiledFields: aBoolean
	flags := flags mask: UncompiledFieldsMask set: aBoolean!

inheritTemplate
	| ancestor |
	ancestor := self superclass.
	flags := ancestor flags.
	template := ancestor template.
	self byteSize: ancestor byteSize.
	alignment := ancestor alignment!

init: buffer
	"Initialize a buffer (or buffer at the specified address) to hold an instance of the record type
	described by the receiver. Assumes that the memory is completely uninitialized."

	Kernel32 zeroMemory: buffer length: self byteSize!

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

isFieldBrowsable: aSymbol
	template notNil ifTrue: [(template lookup: aSymbol) ifNotNil: [:field | ^field isBrowsable]].
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

	^self basicNew
		initializeAtAddress: self pointerClass new;
		yourself!

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

	^Address!

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
	existingKey := RecordClasses keyAtValue: structureClass ifAbsent: nil.
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
	flags := CompileNewFieldsMask.
	alignment := template := nil!

setGuid: aGUID
	"Private - Set the value of the receiver's 'guid' instance variable to the 
	<GUID>, aGUID.
	Implementation Note: Override to register the structure in the table mapping GUIDs
	to record classes, and the separate table mapping IIDs to COM Interfaces."

	_guid ~= aGUID ifTrue: [
		self unregister.
		super setGuid: aGUID.
		self register]
!

shouldCompileNewFields
	"Private - Answer whether fields subsequently added to the receiver should, by default, have accessors generated when the receiver's definition is compiled.
	This is usually true, so field accessors are normally generated. However it can be turned off for a whole structure, or part of the structure. Also, individual fields can be marked as uncompiled, overriding this setting."

	^flags anyMask: CompileNewFieldsMask!

stbReadFrom: anSTBInFiler format: anSTBClassConversion size: anInteger
	self ensureDefined.
	^anSTBInFiler
		readObjectOfClass: self
		format: anSTBClassConversion
		size: anInteger!

structurePacker
	"Answer the object which implements the structure packing algorithm
	for use with the receiver.  The object must respond to the <structurePacker>
	protocol."

	^self!

template
	"Private - Answer the receiver's structure template (defines the types and 
	offsets of the fields)"

	^self ensureDefined!

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

	(_guid notNil and: [RecordClasses notNil]) ifTrue: [RecordClasses removeKey: _guid ifAbsent: nil]!

withBytes: aByteObject 
	"Answer a new instance of the receiver with the arguments as its contents"

	self ensureDefined.
	^(self basicNew)
		bytes: aByteObject;
		initialize;
		yourself! !
!External.Structure class categoriesForMethods!
alignment!constants!public! !
atAddress:!instance creation!public! !
baseAlignment!private!template definition! !
basicByteSize!accessing!public! !
beCompiled!modes!public!template definition! !
beUncompiled!modes!public!template definition! !
byteSize!**compiled accessors**!constants!public! !
byteSize:!initializing!private! !
canUnderstand:!methods-testing!public! !
changedByteSizeFrom:!private!template definition! !
clear:!public!realizing/unrealizing! !
defineField:type:!public!template definition! !
defineField:type:offset:!public!template definition! !
defineFields!public!template definition! !
defineSizeConstant:!private!template definition! !
definesNewFields!private!template definition!testing! !
defineTemplate!public!template definition! !
descriptorClass!constants!private! !
dynamicSelectorsDo:!compiling!methods-accessing!public! !
elementSize!accessing!public! !
ensureDefined!instance creation!private! !
fieldNamesFromTemplate!accessing!private! !
fieldOffsetConstantPrefix!constants!private!template definition! !
flags!accessing!private! !
fromAddress:!instance creation!public! !
fromBytes:!instance creation!public! !
getFieldNames!accessing!private! !
hasUncompiledFields!private!testing! !
hasUncompiledFields:!private!testing! !
inheritTemplate!private!template definition! !
init:!initializing!public! !
initializeAfterLoad!development!initializing!private! !
initializeTemplate!private!template definition! !
isFieldBrowsable:!printing!private! !
libraryAndIndex!constants!public! !
new!instance creation!public! !
new:!instance creation!public! !
new:bufferClass:!instance creation!public! !
newBuffer!instance creation!public! !
newBufferClass:!instance creation!public! !
newHeapPointer!instance creation!public! !
newPointer!instance creation!public! !
newPointer:!instance creation!public! !
newTemplate!private!template definition! !
offsetFor:base:!public!template definition! !
offsetOf:!accessing!public! !
packing!constants!public! !
paddedSizeFor:!public!template definition! !
pointerClass!constants!private! !
recompileReferences!private!template definition! !
register!adding!public! !
registerClass:forGUID:!adding!public! !
removeRedundantOffsetConstants!private!template definition! !
resetTemplate!public!template definition! !
setGuid:!accessing!private! !
shouldCompileNewFields!private!testing! !
stbReadFrom:format:size:!binary filing!public! !
structurePacker!public!template definition! !
template!accessing!private! !
uninitializeBeforeRemove!class hierarchy-removing!public! !
unregister!public!removing! !
withBytes:!instance creation!public! !
!

