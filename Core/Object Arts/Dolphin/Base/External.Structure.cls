"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'External.Structure'
	instanceVariableNames: 'bytes owner'
	classVariableNames: 'RecordClasses'
	imports: #()
	classInstanceVariableNames: 'template flags alignment'
	classConstants: {
			'CompileNewFieldsMask' -> 16r1.
			'DefaultFlags' -> 16r1.
			'StructFlagsMask' -> 16rFFFF.
			'TemplateFlagsMask' -> 16r3.
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
	
	"postCopy has already copied the bytes - use the standard implementation for the rest of the object"
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

	self initializeAtAddress: self heapPointerClass new owner: nil!

beNullPointer
	"Private - Set the receiver's contents to be a NULL pointer."

	self initializeAtAddress: self pointerClass new owner: nil!

bufferClass
	"Private - Answer the default class to use as a contents buffer"

	^self class bufferClass!

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

copy: aByteClass from: startInteger to: stopInteger
	"Private - Answer an instance of the byte-object class, aByteClass, holding a copy of the bytes of the receiver starting at <integer> byte index startInteger, until <integer> byte index, stopInteger, inclusive. Note that the indices are byte positions, not element positions. They should specify a whole number of elements or the result is undefined."

	^self class
		copyBytes: bytes
		from: startInteger
		to: stopInteger
		into: (aByteClass new: stopInteger - startInteger + 1)!

copyBuffer: aByteObject size: anInteger
	self
		initializeBuffer: self bufferClass size: anInteger.
	aByteObject ifNotNil: [self copyBytes: aByteObject]!

copyBytes: aByteObject
	"Private - Set the contents of the receiver (as appropriate for the subclass).
	Answer the receiver."

	self class
		copyBytes: aByteObject
		from: 1
		to: self byteSize
		into: bytes!

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

copyToGlobalHeap
	^Memory copyBytesToGlobalHeap: bytes size: self byteSize!

detach
	"Detach the receiver from the object at which it is pointing, answering the address
	of that object. This is useful where one wishes to take-over ownership of an object
	which would otherwise be cleaned up when the receiver is finalized."

	| detached |
	bytes ifNil: [^nil].
	detached := bytes detach.
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

fieldOwner
	"Answer the object that should be considered the owner of any external resources associated with the receiver's fields. This is used to set the owner of any sub-structures created to reference fields in the receiver."

	^owner ?? self!

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

getField: aString
	"Answer the value of the named field of the receiver, or if there is no such field then raise an exception."

	^self perform: aString asSymbol!

getField: aString ifAbsent: aNiladicValuable
	"Answer the value of the field of the receiver named by the <String> 1st argument, or if there is no such field then the result of evaluating the <niladicValuable> 2nd argument."

	| selector |
	selector := aString asSymbol.
	(self getValidFields identityIncludes: selector) ifFalse: [^aNiladicValuable value].
	^self getField: selector!

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
	"Private - Perform any initialization required for the receiver which is specific to the value form. Answer the receiver.
	To perform reference specific initialization, override #initializePointer."
!

initializeAtAddress: anAddress owner: anObject
	"Private - Initialize the receiver to be a reference to an unmanaged structure of the receiver's type at the specified address. Any modifications to the receiver will be reflected back into the structure/object at anAddress."

	bytes := anAddress asExternalAddress.
	owner := anObject.
	self initializePointer.
	^self!

initializeBuffer: bufferClass size: anInteger
	"Private - Allocate an unmanaged buffer in the receiver of the specified size and class to hold unmanaged data in this structure's format. Usually the buffer class will be ByteArray, in which case the buffer is allocated from the Smalltalk heap, but in some circumstances, e.g. when intending to pass ownership of the structure to some external API, for the buffer to be allocated from an external heap. This is achieved by using some alternate buffer class, e.g. TaskMemory, corresponding to the COM task memory heap."

	bytes := bufferClass newFixed: anInteger.
	self initialize!

initializePointer
	"Private - Perform any initialization required for the receiver	which is specific to the reference form. Answer the receiver.
	To perform value specific initialization, override #initialize."!

isFieldBrowsable: aSymbol
	^self class isFieldBrowsable: aSymbol!

isNull
	"Answer whether the receiver is a null external data item (that is, a null pointer, or a nilled out structure)."

	<primitive: 170>
	^bytes isNull!

isPointerStruct
	"Answer whether the receiver is a (possibly null) pointer to an external data item."

	^bytes class isIndirection!

isReferenceStruct
	"Answer whether the receiver is a non-null pointer (reference) to an external structure in memory owned by another object, or possibly even allocated from an external heap."

	^self isNull not and: [self isPointerStruct]!

isValueStruct
	^(self isNull or: [self isPointerStruct]) not!

maxPrint
	"Private - Answer the maximum number of characters to output when appending the 
	receiver's textual representation to a Stream"

	^500!

needsFree
	"Private - Answer whether the receiver requires freeing of any external resources. In most cases we don't want to free if this object is a reference to a structure embedded in an buffer, since that would damage the buffer. In other cases where the buffer is owned, the subclasses may require free'ing, but at an abstract level we assume not."

	^false!

notNull
	"Answer whether the receiver is not Null (i.e. not equal to 0)."

	^self isNull not!

onStartup
	"The system is starting. Finalizable subclasses should modify the state of the receiver to account for the fact than any external memory allocated for the receiver during the previous session is no longer accessible. In general we don't need to do anything, however, because the VM nulls out External.Address subinstances on image load, so any reference instances will be null on startup."
!

owner
	"Answer the object considered to own the data in the receiver structure, or nil if self-owned."

	^owner!

owner: anObject
	"Set the object responsible for managing the storage allocated for the underlying elements.
	This is used both to keep that object alive while the receiver is alive, and to determine who should free the elements. If nil then the receiver frees the elements by passing them back to their class' #free: method, otherwise it is assumed that the owner will free them when it no longer requires them."

	(anObject isNil or: [anObject == self])
		ifTrue: 
			[owner := nil.
			self requiresFinalization ifTrue: [self beFinalizable]]
		ifFalse: 
			[owner := anObject.
			self beUnfinalizable]!

pointerClass
	"Private - Answer the default class to use as a pointer"

	^self class pointerClass!

postCopy
	"Apply any final flourish to the copy that may be required. For Structures the copy must not share the same byte data. If a reference instance the referenced data is dereferenced."

	self copyBuffer: bytes size: self byteSize.
	self owner: nil.
	^self!

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

requiresFinalization
	"Answer whether objects like the receiver may hold external resources that need to be freed. Unknowned structures requiring finalization are marked as finalizable."

	^self class requiresFinalization!

setField: aString value: anObject
	"Set the value of the field of the receiver named by the <String> 1st argument to the <Object> 2nd argument, or if there is no such field then raise an exception."

	^self perform: (aString, ':') asSymbol with: anObject!

setField: aString value: anObject ifAbsent: aNiladicValuable
	"Set the value of the field of the receiver named by the <String> 1st argument, to the variant value of the <variantCompatible> 2nd argument, or if there is no such field then evaluate the <niladicValuable> 3rd argument."

	| selector |
	selector := aString asSymbol.
	(self getValidFields identityIncludes: selector) ifFalse: [^aNiladicValuable value].
	self setField: aString value: anObject!

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
copy:from:to:!copying!private! !
copyBuffer:size:!copying!private! !
copyBytes:!copying!private! !
copyFrom:to:!copying!public! !
copyStringFrom:to:!copying!public! !
copyToGlobalHeap!public! !
detach!public!realizing/unrealizing! !
doesNotUnderstand:!exceptions!public! !
fieldOwner!accessing!public! !
fieldsDo:!enumerating!public! !
fieldsDo:separatedBy:!enumerating!public! !
free!public!realizing/unrealizing! !
getField:!accessing!public! !
getField:ifAbsent:!accessing!public! !
getValidFields!accessing!private! !
hash!comparing!public! !
heapPointerClass!constants!private! !
hresultError:!exceptions!public! !
initialize!initializing!private! !
initializeAtAddress:owner:!initializing!private! !
initializeBuffer:size:!initializing!private! !
initializePointer!initializing!private! !
isFieldBrowsable:!printing!private! !
isNull!public!testing! !
isPointerStruct!public!testing! !
isReferenceStruct!public!testing! !
isValueStruct!public!testing! !
maxPrint!constants!private! !
needsFree!private!realizing/unrealizing! !
notNull!public!testing! !
onStartup!event handling!public! !
owner!accessing!initializing!public! !
owner:!accessing!public! !
pointerClass!constants!private! !
postCopy!copying!public! !
printString!printing!public! !
replaceBytesOf:from:to:startingAt:!double dispatch!private!replacing! !
replaceFrom:to:with:startingAt:!public!replacing! !
requiresFinalization!public!realizing/unrealizing!testing! !
setField:value:!accessing!public! !
setField:value:ifAbsent:!accessing!public! !
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

	self template.
	^alignment!

atAddress: anAddress
	#deprecated.
	^self fromAddress: anAddress!

atAddress: anAddress owner: anObject
	"Answer a new instance of the receiver instantiated from the
	data at the specified address. Normally  this will be a 'reference' 
	instance, that points at the data embedded	at the specified address. 
	However in the case of objects that always have reference form
	(e.g. COM interface pointers, BSTRs, etc) this will be a copy
	of the pointer at that address. This is particularly useful for accessing
	elements of arrays."

	^self fromAddress: anAddress owner: anObject!

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

bufferClass
	"Private - Answer the default class to use as a contents buffer"

	^ByteArray!

byteSize
	"Answer the size (in bytes) of the structure the receiver represents"

	self template.
	^self basicByteSize!

byteSize: anInteger
	"Private - Set the size (in bytes) of the structure the receiver represents"

	(anInteger between: 0 and: ##(2 ** 15 - 1))
		ifFalse: [self error: 'Invalid structure size ' , anInteger printString].
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
	"Finalize an instance of the structure which instances of the receiver wrap which resides at the specified address. Note that 'clearing' is not about freeing the specified memory block itself, but instead is intended to free any resources that it may reference. For example a structure holding pointers to owned heap objects would be expected to free those allocations."!

copyBytes: srcByteObject from: startInteger to: stopInteger into: destByteObject
	"Private - Copy bytes from the byte object, srcByteObject, starting at <integer> byte index startInteger, until <integer> byte index, stopInteger, inclusive into the byte-object, destByteObject. Note that the indices are byte positions. The source and destination bytes are assumed to be buffers for structures of the receiver's type."

	srcByteObject
		replaceBytesOf: destByteObject
		from: 1
		to: stopInteger - startInteger + 1
		startingAt: startInteger.
	^destByteObject!

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
	(newByteSize ~~ 0 and: [self requiresSizeConstant])
		ifTrue: [self addClassConstant: self sizeConstantName value: newByteSize]
		ifFalse: [self removeClassVarName: self sizeConstantName]!

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
	template ifNotNil: [self changedByteSizeFrom: oldByteSize].
	template beImmutableObject.
	^template!

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
	^flags ?? DefaultFlags!

fromAddress: anAddress
	"Answer a new instance that points to the ExternalAddress respresented by anAddress (which responds to the protocol #isNull and #asExternalAddress). The new instance will NOT be considered to own the referenced memory. If anAddress is the null pointer then the answer is nil. This behaviour is useful when referencing an ExternalStructure from a PointerField, since such pointers are commonly Null."
	
	^self fromAddress: anAddress owner: anAddress!

fromAddress: anAddress owner: anObject
	"Answer a new instance that points to the ExternalAddress respresented by anAddress (which responds to the protocol #isNull and #asExternalAddress), with the specified 'owner'. The owner is considered the owner of the memory block at which the new instance points. If the owner is nil, then the new instance is considered to own the memory. 
	If anArray is null, then the answer will be nil. This behaviour is useful when referencing an ExternalStructure from a PointerField, since such pointers are commonly Null."

	^anAddress isNull
		ifFalse: 
			[self template.
			self basicNew initializeAtAddress: anAddress owner: anObject]!

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

	^self flags allMask: UncompiledFieldsMask!

hasUncompiledFields: aBoolean
	flags := self flags mask: UncompiledFieldsMask set: aBoolean!

inheritTemplate
	| ancestor |
	ancestor := self superclass.
	flags := (ancestor flags bitAnd: StructFlagsMask) bitOr: (flags ?? 0 maskClear: TemplateFlagsMask).
	template := ancestor template.
	self byteSize: ancestor byteSize.
	alignment := ancestor alignment!

init: addressOrBytes
	"Initialize a buffer (or buffer at the specified address) to hold an instance of the record type described by the receiver. Assumes that the memory is completely uninitialized."

	Kernel32 zeroMemory: addressOrBytes length: self byteSize!

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

marshal: anObject 
	"Answer an instance of the receiver whose value is the argument."

	self == anObject class ifTrue: [^anObject].
	^(self newBuffer)
		value: anObject;
		yourself!

new
	"Answer a instance of the receiver. This may be either an internal buffer
	(containing a <ByteArray>) or a reference to an external buffer (containing
	a <ExternalAddress>), as appropriate for the subclass. The default is an 
	internal buffer."

	^self newBuffer!

new: anInteger
	"Answer a new instance of the receiver containing a buffer for unmanaged data of the specified size.
	N.B. It is not normally necessary to specify the size of an ExternalStructure, because the concrete subclasses are normally of a fixed length and know their unmanaged size, however some structures may be of variable length."

	^self new: anInteger bufferClass: self bufferClass!

new: anInteger bufferClass: bufferClass
	"Answer a new instance of the receiver containing a buffer for unmanaged data of the specified byte size, allocated by the specified buffer class."

	^self basicNew initializeBuffer: bufferClass size: anInteger!

newBuffer
	"Answer a new instance containing its own buffer."

	^self new: self byteSize bufferClass: self bufferClass!

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

	^self newPointer: self pointerClass!

newPointer: pointerClass
	"Answer a new instance of the receiver suitable for use as a reference
	to an externally allocated object, using the specified pointer class (e.g.
	OS.COM.TaskMemory)"

	^self basicNew initializeAtAddress: pointerClass new owner: nil!

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

onStartup
	"Private - Notify all the receiver's sub-instances of system startup. Subclasses that reference external resources need to override #onStartup on the instance side and clean up their state to remove any potential dangling references from the previous session."

	self primAllSubinstances do: [:i | i onStartup].!

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

	| binding |
	binding := self bindingOrNil.
	binding isNil
		ifTrue: 
			["Not installed, so can't be any references."
			^self].
	Notification signal: ('Recompiling references to <1p> (size <2p>)...' expandMacrosWith: self
				with: self basicByteSize).
	DynamicLinkLibrary
		allMethodsDo: [:each | (each isExternalCall and: [each refersToLiteral: binding]) ifTrue: [each recompile]].
	Structure allMethodsDo: 
			[:each |
			((each refersToLiteral: #basicByteSize) and: [each refersToLiteral: binding])
				ifTrue: [each recompile]]!

register
	"(Re)Register the receiver's as the Record class for its GUID.
	This is used to map VT_RECORD <VARIANT>s and <SAFEARRAY>s
	back to the appropriate <ExternalStructure> class."

	self shouldRegister ifTrue: [self registerClass: self forGUID: _guid]!

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
	classPool ifNil: [^self].
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

requiresFinalization
	"Answer whether instances of the receiver that own their own resources will require free'ing either explicitly or by finalization."

	^false!

requiresSizeConstant
	^self isNonInstantiable not and: [self definesNewFields]!

resetTemplate
	self byteSize: 0.
	flags := (self flags maskClear: UncompiledFieldsMask) bitOr: CompileNewFieldsMask.
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

shouldRegister
	^self isNonInstantiable not!

sizeConstantName
	^'_<1s>_Size' << (self unqualifiedName ?? '')!

structurePacker
	"Answer the object which implements the structure packing algorithm
	for use with the receiver.  The object must respond to the <structurePacker>
	protocol."

	^self!

template
	"Private - Answer the receiver's structure template (defines the types and 
	offsets of the fields)"

	^template ifNil: [self defineTemplate]!

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

	self template.
	^self basicNew
		bytes: aByteObject;
		initialize;
		yourself! !

!External.Structure class categoriesForMethods!
alignment!constants!public! !
atAddress:!instance creation!public! !
atAddress:owner:!public! !
baseAlignment!private!template definition! !
basicByteSize!accessing!public! !
beCompiled!modes!public!template definition! !
beUncompiled!modes!public!template definition! !
bufferClass!constants!private! !
byteSize!constants!public! !
byteSize:!initializing!private! !
canUnderstand:!methods-testing!public! !
changedByteSizeFrom:!private!template definition! !
clear:!public!realizing/unrealizing! !
copyBytes:from:to:into:!copying!private! !
defineField:type:!public!template definition! !
defineField:type:offset:!public!template definition! !
defineFields!public!template definition! !
defineSizeConstant:!private!template definition! !
definesNewFields!private!template definition!testing! !
defineTemplate!public!template definition! !
dynamicSelectorsDo:!compiling!methods-accessing!public! !
elementSize!accessing!public! !
fieldNamesFromTemplate!accessing!private! !
fieldOffsetConstantPrefix!constants!private!template definition! !
flags!accessing!private! !
fromAddress:!instance creation!public! !
fromAddress:owner:!instance creation!public! !
fromBytes:!instance creation!public! !
getFieldNames!accessing!private! !
hasUncompiledFields!private!testing! !
hasUncompiledFields:!private!template definition! !
inheritTemplate!private!template definition! !
init:!initializing!public! !
initializeAfterLoad!development!initializing!private! !
initializeTemplate!private!template definition! !
isFieldBrowsable:!printing!private! !
libraryAndIndex!constants!public! !
marshal:!instance creation!public! !
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
onStartup!event handling!private! !
packing!constants!public! !
paddedSizeFor:!public!template definition! !
pointerClass!constants!private! !
recompileReferences!private!template definition! !
register!adding!public! !
registerClass:forGUID:!adding!public! !
removeRedundantOffsetConstants!private!template definition! !
requiresFinalization!public!realizing/unrealizing!testing! !
requiresSizeConstant!private!template definition! !
resetTemplate!public!template definition! !
setGuid:!accessing!private! !
shouldCompileNewFields!private!testing! !
shouldRegister!private!testing! !
sizeConstantName!private!template definition! !
structurePacker!public!template definition! !
template!accessing!private! !
uninitializeBeforeRemove!class hierarchy-removing!public! !
unregister!public!removing! !
withBytes:!instance creation!public! !
!

External.Structure class methodProtocol: #'externalStructure class' attributes: #(#readOnly) selectors: #(#alignment #atAddress:owner: #byteSize #clear: #elementSize #fromAddress: #fromAddress:owner: #fromBytes: #guid #init: #name #newBuffer #requiresFinalization)!

