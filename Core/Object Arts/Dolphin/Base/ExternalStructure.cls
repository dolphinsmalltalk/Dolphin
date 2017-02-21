"Filed out from Dolphin Smalltalk 7"!

Object subclass: #ExternalStructure
	instanceVariableNames: 'bytes'
	classVariableNames: 'CompiledMask RecordClasses'
	poolDictionaries: ''
	classInstanceVariableNames: 'template flags alignment'!
ExternalStructure guid: (GUID fromString: '{87B4C489-026E-11D3-9FD7-00A0CC3E4A32}')!
ExternalStructure comment: ''!
!ExternalStructure categoriesForClass!External-Data-Structured! !
!ExternalStructure methodsFor!

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

	^self copy: ByteArray from: start to: stop!

copyStringFrom: start to: stop
	"Answer a copy of the bytes of the receiver starting at index start, 
	until index stop, inclusive, as a String."

	^self copy: String from: start to: stop!

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

	| args field |
	args := aMessage arguments.
	field := self template at: aMessage selector ifAbsent: [^super doesNotUnderstand: aMessage].
	^args size == 0 
		ifTrue: 
			[field isReadable ifTrue: [field readFrom: self bytes] ifFalse: [super doesNotUnderstand: aMessage]]
		ifFalse: [field writeInto: self bytes value: (args at: 1)]!

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

	^self class getFieldList!

hash
	"Answer the SmallInteger hash value for the receiver.
	In order for internal structure to have the same value as pointer structures
	we use the VM export here."

	^VMLibrary default hashBytes: bytes count: self comparisonSize!

heapPointerClass
	"Private - Answer the default class to use as a heap pointer"

	^ExternalMemory!

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

	^InvalidExternalCall
!

invalidCall
	"An invalid virtual call was attempted through one of the receiver's methods.
	Generate an appropriate error from the following categories:
		-	Argument type error. At least one argument was either out of range or of invalid type.
			Only the first such error is reported.
		-	Unknown primitive failure. An uncategorised primitive failure occurred. Seek assistance."

	| failureCode proc |
	proc := Processor activeProcess.
	(failureCode := proc primitiveFailureCode) < 0 ifTrue: [^self hresultError: proc primitiveFailureData].
	failureCode >= 16 
		ifTrue: 
			[| frame i arg descriptor |
			frame := proc topFrame sender.
			descriptor := frame method descriptor.
			i := descriptor argumentIndexFromOffset: failureCode - 16.
			arg := frame method isVirtualFunction ifTrue: [i - 1] ifFalse: [i].
			self invalidArgErrorClass 
				invalidArgument: arg
				got: (frame arguments at: arg)
				expected: (descriptor argumentTypes at: i)].	"One of the arguments was invalid?"

	"All arguments were apparently valid, it must have been some system or unknown error."
	^self primitiveFailed!

isNull
	"Answer whether the receiver is a null external data item
	(that is, a null pointer, or a nilled out structure)."

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
	"Answer whether the receiver is not Null (i.e. not equal to 0)"

	^self isNull == false!

pointerClass
	"Private - Answer the default class to use as a pointer"

	^ExternalAddress!

printableFields
	^self getValidFields!

printArgumentTypeOn: aStream
	"Private - Append a compilable argument type name, which is the receiver, to aStream."

	self class displayOn: aStream.
	self isPointer ifTrue: [aStream nextPut: $*]!

printCyclicRefOn: aStream
	"Private - Append to the argument, aStream, a String whose characters describe
	a cyclic (or recursive) reference to the receiver. Used by some
	printOn: methods (e.g. see Collection) to prevent an infinite recursion."

	aStream nextPutAll: '... a cyclic ref to '.
	self basicPrintOn: aStream.
	aStream nextPutAll: '...'!

printFieldsOn: aStream limit: anInteger
	| sep |
	self isNull
		ifTrue: 
			[aStream nextPutAll: 'NULL'.
			^self].
	sep := [sep := [aStream space]].
	self printableFields do: 
			[:each |
			| field |
			aStream position > anInteger
				ifTrue: 
					[aStream nextPutAll: '... etc ...'.
					^self].
			field := self template at: each.
			field isReadable
				ifTrue: 
					[sep value.
					aStream
						display: each;
						nextPutAll: '=';
						print: (self getField: each)]]!

printOn: aStream 
	"Append a textual representation of the receiver to aStream.
	We use the template definition to do this in a generic way for all correctly 
	defined subclasses. Fields are printed in the order of their offset"

	| printed |
	printed := Processor activeProcess _alreadyPrinted.
	(printed includes: self) ifTrue: [^self printCyclicRefOn: aStream].
	printed add: self.
	
	[| tooMany |
	tooMany := aStream position + self maxPrint.
	super printOn: aStream.
	aStream nextPut: $(.
	self printFieldsOn: aStream limit: tooMany.
	aStream nextPut: $)] 
			ensure: [printed remove: self ifAbsent: []]!

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
!ExternalStructure categoriesFor: #_deepenShallowCopy:trail:!copying!private! !
!ExternalStructure categoriesFor: #=!comparing!public! !
!ExternalStructure categoriesFor: #alignment!constants!public! !
!ExternalStructure categoriesFor: #asByteArray!converting!public! !
!ExternalStructure categoriesFor: #asObject!accessing!public! !
!ExternalStructure categoriesFor: #asParameter!converting!public! !
!ExternalStructure categoriesFor: #basicFree!private!realizing/unrealizing! !
!ExternalStructure categoriesFor: #beNullHeapPointer!modes!private! !
!ExternalStructure categoriesFor: #beNullPointer!modes!private! !
!ExternalStructure categoriesFor: #bufferClass!constants!private! !
!ExternalStructure categoriesFor: #bytes!accessing!public! !
!ExternalStructure categoriesFor: #bytes:!initializing!private! !
!ExternalStructure categoriesFor: #bytesAtOffset:put:!accessing!public! !
!ExternalStructure categoriesFor: #byteSize!accessing!public! !
!ExternalStructure categoriesFor: #comparisonSize!accessing!private! !
!ExternalStructure categoriesFor: #copy!copying!public! !
!ExternalStructure categoriesFor: #copy:from:to:!copying!private! !
!ExternalStructure categoriesFor: #copyBytes:!accessing!private! !
!ExternalStructure categoriesFor: #copyFrom:to:!copying!public! !
!ExternalStructure categoriesFor: #copyStringFrom:to:!copying!public! !
!ExternalStructure categoriesFor: #detach!public!realizing/unrealizing! !
!ExternalStructure categoriesFor: #doesNotUnderstand:!exceptions!public! !
!ExternalStructure categoriesFor: #fieldsDo:!enumerating!public! !
!ExternalStructure categoriesFor: #fieldsDo:separatedBy:!enumerating!public! !
!ExternalStructure categoriesFor: #free!public!realizing/unrealizing! !
!ExternalStructure categoriesFor: #getField:!accessing!public! !
!ExternalStructure categoriesFor: #getValidFields!accessing!private! !
!ExternalStructure categoriesFor: #hash!comparing!public! !
!ExternalStructure categoriesFor: #heapPointerClass!constants!private! !
!ExternalStructure categoriesFor: #hresultError:!exceptions!public! !
!ExternalStructure categoriesFor: #initialize!initializing!private! !
!ExternalStructure categoriesFor: #initialize:!initializing!private! !
!ExternalStructure categoriesFor: #initializeAtAddress:!initializing!private! !
!ExternalStructure categoriesFor: #initializePointer!initializing!private! !
!ExternalStructure categoriesFor: #invalidArgErrorClass!constants!private! !
!ExternalStructure categoriesFor: #invalidCall!exceptions!public! !
!ExternalStructure categoriesFor: #isNull!public!testing! !
!ExternalStructure categoriesFor: #isPointer!public!testing! !
!ExternalStructure categoriesFor: #maxPrint!constants!private! !
!ExternalStructure categoriesFor: #needsFree!private!realizing/unrealizing! !
!ExternalStructure categoriesFor: #notNull!public!testing! !
!ExternalStructure categoriesFor: #pointerClass!constants!private! !
!ExternalStructure categoriesFor: #printableFields!development!printing!private! !
!ExternalStructure categoriesFor: #printArgumentTypeOn:!printing!private! !
!ExternalStructure categoriesFor: #printCyclicRefOn:!printing!private! !
!ExternalStructure categoriesFor: #printFieldsOn:limit:!development!printing!private! !
!ExternalStructure categoriesFor: #printOn:!development!printing!public! !
!ExternalStructure categoriesFor: #replaceBytesOf:from:to:startingAt:!double dispatch!private!replacing! !
!ExternalStructure categoriesFor: #replaceFrom:to:with:startingAt:!public!replacing! !
!ExternalStructure categoriesFor: #setField:value:!accessing!public! !
!ExternalStructure categoriesFor: #size!accessing!public! !
!ExternalStructure categoriesFor: #template!constants!private! !
!ExternalStructure categoriesFor: #value!accessing!public! !
!ExternalStructure categoriesFor: #value:!accessing!public! !
!ExternalStructure categoriesFor: #yourAddress!accessing!public! !

!ExternalStructure class methodsFor!

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

autoGenCategories
	"Private - Answer a <sequencedReadableCollection> of <MethodCategory>s into 
	which the auto-generated the structure accessors for the receiver should be compiled."

	^Array
		with: self autoGenCategory
		with: self methodCategoryClass public.!

autoGenCategory
	"Private - Answer the basic<MethodCategory>s into which the auto-generated 
	structure accessors for the receiver should be compiled."

	^self methodCategoryClass name: '**compiled accessors**'!

autoGenComment
	"Private - Answer a suitable piece of comment to warn the user that a
	method is automatically generated and should not be modified.
	Implementation Note: As of v2.2 this is empty by default as otherwise
	it tends to lead to rather bloated source files."

	^''!

baseAlignment
	^self == ##(self) ifTrue: [1] ifFalse: [self superclass alignment]!

basicByteSize
	"Answer the size (in bytes) of the structure the receiver represents, or zero if not yet defined."

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
		ifFalse: [self error: 'Invalid structure size ' , anInteger displayString].
	self extraInstanceSpec: anInteger!

changedByteSizeFrom: oldByteSize
	"Private - If the size of the receiver changes such that it fits into a different type for passing
	/ returning structures by value , then we must recompile all existing referencing methods"

	| newByteSize recompileRefs |
	newByteSize := self byteSize.
	oldByteSize ~= newByteSize ifFalse: [^self].
	"Recompile own methods so that they have the correct offsets encoded"
	recompileRefs := [:each | (each refersToLiteral: #offsetOf:) ifTrue: [each recompile]].
	self methodDictionary do: recompileRefs.
	self class methodDictionary do: recompileRefs.
	"Recompile any references that might have a static literal snapshot of the byte size of the receiver."
	self recompileReferences
!

clear: addressOrBytes
	"Finalize an instance of the structure which instances of the receiver wrap
	which resides at the specified address. Note that this is not about freeing
	the specified memory block, but any resources which it references."!

compileAllDefinitions
	"Compile the definitions of the receiver and all its subclasses"

	self withAllSubclassesDo: [:each | each compileDefinition].
!

compileDefinition
	"Builds a new template and generates compiled methods for accessing the fields 
	described by it. Depending on the description held in each field, some accessor
	methods may be left as uncompiled to be addressed via the template and 
	#doesNotUnderstand:"

	self
		newTemplate;
		defineTemplate;
		recompileDefinition;
		shrink!

compileGetMethod: aSymbol forField: anExternalField 
	"Private - Generate a compiled 'get' accessor method for the selector aSymbol 
	and field definition anExternalField."

	| methodText remark |
	anExternalField canGenerateAccessor ifFalse: [^self].
	methodText := String writeStream: 256.
	methodText
		nextPutAll: aSymbol;
		crtab;
		nextPutAll: '"Answer the receiver''s ';
		nextPutAll: aSymbol;
		nextPutAll: ' field as a Smalltalk object.'.
	remark := self autoGenComment.
	remark notEmpty 
		ifTrue: 
			[methodText
				crtab;
				nextPutAll: remark].
	methodText
		nextPut: $";
		cr;
		crtab.
	anExternalField printAccessorBody: aSymbol on: methodText.
	self formatAndCompile: methodText contents categories: self autoGenCategories!

compileSetMethod: aSelector forField: anExternalField 
	"Private - Generate a compiled 'set' accessor method for the selector aSymbol 
	and field definition, anExternalField"

	| methodText remark fieldName |
	anExternalField canGenerateMutator ifFalse: [^self].
	methodText := String writeStream: 256.
	fieldName := aSelector allButLast asSymbol.
	methodText
		nextPutAll: aSelector;
		nextPutAll: ' anObject';
		crtab;
		nextPutAll: '"Set the receiver''s ';
		display: fieldName;
		nextPutAll: ' field to the value of anObject.'.
	remark := self autoGenComment.
	remark notEmpty 
		ifTrue: 
			[methodText
				crtab;
				nextPutAll: remark].
	methodText
		nextPut: $";
		cr;
		crtab.
	anExternalField printMutatorBody: fieldName on: methodText.
	self formatAndCompile: methodText contents categories: self autoGenCategories!

contentsAccessText
	"Private - Answer the method text that must be inserted to get access to the
	contents (bytes) of the instances of the receiver"

	^'bytes'!

decompileDefinition
	"Remove generated accessor methods from the receiver, and rebuild the
	structure template"

	[self removeCategory: self autoGenCategory] on: NotFoundError do: [:e | e notify]!

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

	self isCompiled ifFalse: [anExternalField beUncompiled].
	alignment := alignment max: anExternalField alignment.
	anExternalField offset: offset.
	self byteSize: (self basicByteSize max: offset + anExternalField byteSize).
	"We always retain the read selector in the template - this is needed to calc the field
	offset when compiling methods"
	template at: fieldName asSymbol put: anExternalField.
	anExternalField isWriteable ifTrue: [template at: (fieldName , ':') asSymbol put: anExternalField]!

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
	Implementation Note: We try and share a superclass template
	if we don't directly implement #defineFields in a particular class.
	This is a space saving measure, and is necessary because 'template' is
	a class instance variable."

	| oldByteSize |
	oldByteSize := self extraInstanceSpec.
	self definesNewFields 
		ifFalse: 
			["Receiver doesn't define any new fields, so inherit the lot"
			self inheritTemplate.
			template notNil ifTrue: [^self changedByteSizeFrom: oldByteSize]].
	self
		initializeTemplate;
		defineFields;
		byteSize: (self structurePacker paddedSizeFor: self basicByteSize).
	template shrink.
	self changedByteSizeFrom: oldByteSize!

descriptorClass
	"Private - Return the class of external function descriptor associated with
	the receiver."

	^ExternalDescriptor!

elementSize
	"Answer the size (in bytes) of the structure the receiver represents
	when used as an array element."

	^self byteSize!

ensureDefined
	template isNil ifTrue: [self defineTemplate]	"ensure the structure accessors are correctly defined"!

fieldType
	"Private - Answer the <ExternalField> type to be used to represent the receiver's field type in 
	other structures."

	^StructureField!

formatAndCompile: aString categories: categories 
	| source |
	source := (Smalltalk at: #SmalltalkSystem ifPresent: [:c | c current]) 
				ifNil: [aString]
				ifNotNil: [:devSys | devSys reformatSource: aString in: self].
	"Notification signal: source."
	^self compile: source categories: categories!

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

getFieldList
	"Private - Answer a <sequencedReadableCollection> of the fields defined 
	in the receiver's template, sorted in ascending order of offset from the start of the
	structure."

	| answer |
	answer := OrderedCollection new.
	(self template associations asSortedCollection: [:x :y | x value offset <= y value offset]) 
		do: [:assoc | (assoc key last == $: or: [assoc value isFiller]) ifFalse: [answer add: assoc key]].
	^answer!

hasHandCodedMethodFor: selector
	"Private - Answer whether the receiver appears to have a hand coded implementation
	for the specified selector <Symbol>."

	| method |
	method := self compiledMethodAt: selector ifAbsent: [^false].
	^(self autoGenCategory includesMethod: method) not!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

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

initialize
	"Private - Initialize the receiver class.
		ExternalStructure initialize
	"

	CompiledMask := 16r1.!

initializeAfterBinaryLoad
	"Private - Perform any post-binary load initialisation for the class. 
	Implementation Note: Use the template lazy accessor to cause the template
	to be defined (if not already). This is a non-destructive way to ensure the class
	is initialized."

	self template.
	self register!

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
	COMTaskMemory)"

	^self basicNew initializeAtAddress: pointerClass new!

newTemplate
	"Private - Reset the template instance variable of the receiver in preparation for loading a
	new template."

	template := IdentityDictionary new.
	alignment := self baseAlignment.
!

offsetFor: anExternalField base: anInteger 
	"Answer the adjusted offset for the <ExternalField> from the base offset, anInteger.
	Typically this will round up to some granularity which is the minimum off the field size and
	the structure packing (typically 8) - e.g. 32-bit field typically packed to a four byte
	boundary, a 12-byte structure would be packed to an 8-byte boundary.."

	^anInteger roundUpTo: (anExternalField alignment min: self packing)!

offsetOf: aSymbol 
	"Answer the offset of the named field, or -1 if there is no such field."

	"Implementation Note: We want to avoid realising the template when compiling instance side
	methods before the template definition is available on the class side, so access the inst
	var directly"

	template ifNotNil: [(template at: aSymbol ifAbsent: []) ifNotNil: [:field | ^field offset]].
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

	^ExternalAddress!

recompileDefinition
	"Private - Recompiles the existing template for the receiver"

	self decompileDefinition.
	self definesNewFields ifFalse: [^self].
	self template keysAndValuesDo: 
			[:selector :field | 
			(self shouldCompile: selector forField: field) 
				ifTrue: 
					[selector last == $: 
						ifTrue: [self compileSetMethod: selector forField: field]
						ifFalse: [self compileGetMethod: selector forField: field]]
				ifFalse: 
					[Notification signal: self name , ': Compiled accessor ' , selector printString , ' not generated']]

!

recompileReferences
	"Private - Recompile all directly referencing external call methods that might need to
	change if the receiver's size changes."

	| pred |
	Notification signal: ('Recompiling references to <1d> (size <2d>)...' expandMacrosWith: self
				with: self basicByteSize).
	"Then recompile any FFI calls that reference the class in case they are passing/returning by
	value (the calling conventions vary depending on the structure length), AND any
	ExternalStructure methods that might be using static expressions to get the byte-size."
	pred := self referenceFilterFor: self classBinding.
	ExternalLibrary allMethodsDo: 
			[:each |
			(each isExternalCall and: [pred value: each])
				ifTrue: 
					[Notification signal: 'Recompiling ' , each printString.
					each recompile]].
	ExternalStructure allMethodsDo: 
			[:each |
			((each refersToLiteral: #basicByteSize) and: [pred value: each])
				ifTrue: 
					[Notification signal: 'Recompiling ' , each printString.
					each recompile]]!

register
	"(Re)Register the receiver's as the Record class for its GUID.
	This is used to map VT_RECORD <VARIANT>s and <SAFEARRAY>s
	back to the appropriate <ExternalStructure> class."

	self registerClass: self forGUID: _guid!

registerClass: structureClass forGUID: aGUID
	"Register the specified <ExternalStructure> class as the Record class
	for the specified <GUID>. Any existing registration is first removed.
	If the <GUID> is null, then only the removal occurs."

	| existingKey |
	RecordClasses isNil ifTrue: [^self].
	existingKey := RecordClasses keyAtValue: structureClass ifAbsent: [].
	existingKey isNil ifFalse: [RecordClasses removeKey: existingKey].
	aGUID isNull ifFalse: [RecordClasses at: aGUID put: structureClass]!

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

shouldCompile: selector forField: anExternalField
	"Private - Answer whether to compile an accessor method
	with the specified selector for the specified field in the
	receiver."

	^anExternalField canGenerateAccessors 
		and: [(self hasHandCodedMethodFor: selector) not		"Don't overwrite manually written methods"
			and: ["Don't generate inherited fields unless specifically marked for override"
				anExternalField isOverride or: [
					(self superclass template includesKey: (selector upTo: $:) asSymbol) not]]]!

shrink
	"Private - Reduce the size of the structure template by removing the write accessors.
	This should only be done to compiled structures."

	self template keysAndValuesDo: [:k :f |
		(k last == $: and: [f canGenerateMutator])
			ifTrue: [self template removeKey: k]]

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

understoodSelectors
	"Answer a Set of all message selectors understood by the receiver, not including those understood because
	they are implemented in superclasses. This should however include those that are not in the method dictionary
	but will be understood as a result of #doesNotUnderstand: processing, if that is possible."

	^(IdentitySet withAll: super understoodSelectors)
		addAll: self template keys;
		yourself!

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
!ExternalStructure class categoriesFor: #alignment!constants!public! !
!ExternalStructure class categoriesFor: #atAddress:!instance creation!public! !
!ExternalStructure class categoriesFor: #autoGenCategories!constants!development!private! !
!ExternalStructure class categoriesFor: #autoGenCategory!constants!development!private! !
!ExternalStructure class categoriesFor: #autoGenComment!constants!development!private! !
!ExternalStructure class categoriesFor: #baseAlignment!accessing!private! !
!ExternalStructure class categoriesFor: #basicByteSize!accessing!public! !
!ExternalStructure class categoriesFor: #beCompiled!modes!public! !
!ExternalStructure class categoriesFor: #beUncompiled!modes!public! !
!ExternalStructure class categoriesFor: #byteSize!accessing!public! !
!ExternalStructure class categoriesFor: #byteSize:!accessing!private! !
!ExternalStructure class categoriesFor: #changedByteSizeFrom:!development!initializing!private! !
!ExternalStructure class categoriesFor: #clear:!public!realizing/unrealizing! !
!ExternalStructure class categoriesFor: #compileAllDefinitions!development!public! !
!ExternalStructure class categoriesFor: #compileDefinition!development!public! !
!ExternalStructure class categoriesFor: #compileGetMethod:forField:!development!private! !
!ExternalStructure class categoriesFor: #compileSetMethod:forField:!development!private! !
!ExternalStructure class categoriesFor: #contentsAccessText!constants!private! !
!ExternalStructure class categoriesFor: #decompileDefinition!development!public! !
!ExternalStructure class categoriesFor: #defineField:type:!initializing!public! !
!ExternalStructure class categoriesFor: #defineField:type:offset:!initializing!public! !
!ExternalStructure class categoriesFor: #defineFields!initializing!public! !
!ExternalStructure class categoriesFor: #definesNewFields!private!testing! !
!ExternalStructure class categoriesFor: #defineTemplate!initializing!public! !
!ExternalStructure class categoriesFor: #descriptorClass!constants!private! !
!ExternalStructure class categoriesFor: #elementSize!accessing!public! !
!ExternalStructure class categoriesFor: #ensureDefined!instance creation!private! !
!ExternalStructure class categoriesFor: #fieldType!constants!development!private! !
!ExternalStructure class categoriesFor: #formatAndCompile:categories:!compiling!private! !
!ExternalStructure class categoriesFor: #fromAddress:!instance creation!public! !
!ExternalStructure class categoriesFor: #fromBytes:!instance creation!public! !
!ExternalStructure class categoriesFor: #getFieldList!accessing!private! !
!ExternalStructure class categoriesFor: #hasHandCodedMethodFor:!development!private!testing! !
!ExternalStructure class categoriesFor: #icon!constants!public! !
!ExternalStructure class categoriesFor: #inheritTemplate!initializing!private! !
!ExternalStructure class categoriesFor: #init:!initializing!public! !
!ExternalStructure class categoriesFor: #initialize!development!initializing!private! !
!ExternalStructure class categoriesFor: #initializeAfterBinaryLoad!initializing!private! !
!ExternalStructure class categoriesFor: #initializeAfterLoad!initializing!private! !
!ExternalStructure class categoriesFor: #initializeTemplate!initializing!private! !
!ExternalStructure class categoriesFor: #isCompiled!private!testing! !
!ExternalStructure class categoriesFor: #libraryAndIndex!constants!public! !
!ExternalStructure class categoriesFor: #new!instance creation!public! !
!ExternalStructure class categoriesFor: #new:!instance creation!public! !
!ExternalStructure class categoriesFor: #new:bufferClass:!instance creation!public! !
!ExternalStructure class categoriesFor: #newBuffer!instance creation!public! !
!ExternalStructure class categoriesFor: #newBufferClass:!instance creation!public! !
!ExternalStructure class categoriesFor: #newHeapPointer!instance creation!public! !
!ExternalStructure class categoriesFor: #newPointer!instance creation!public! !
!ExternalStructure class categoriesFor: #newPointer:!instance creation!public! !
!ExternalStructure class categoriesFor: #newTemplate!accessing!private! !
!ExternalStructure class categoriesFor: #offsetFor:base:!helpers!public! !
!ExternalStructure class categoriesFor: #offsetOf:!accessing!public! !
!ExternalStructure class categoriesFor: #packing!constants!public! !
!ExternalStructure class categoriesFor: #paddedSizeFor:!helpers!public! !
!ExternalStructure class categoriesFor: #pointerClass!constants!private! !
!ExternalStructure class categoriesFor: #recompileDefinition!development!private! !
!ExternalStructure class categoriesFor: #recompileReferences!development!private! !
!ExternalStructure class categoriesFor: #register!adding!public! !
!ExternalStructure class categoriesFor: #registerClass:forGUID:!adding!public! !
!ExternalStructure class categoriesFor: #resetTemplate!initializing!public! !
!ExternalStructure class categoriesFor: #setGuid:!accessing!private! !
!ExternalStructure class categoriesFor: #shouldCompile:forField:!development!private!testing! !
!ExternalStructure class categoriesFor: #shrink!operations!private! !
!ExternalStructure class categoriesFor: #stbReadFrom:format:!binary filing!public! !
!ExternalStructure class categoriesFor: #structurePacker!accessing!public! !
!ExternalStructure class categoriesFor: #template!accessing!private! !
!ExternalStructure class categoriesFor: #understoodSelectors!methods-accessing!public! !
!ExternalStructure class categoriesFor: #uninitializeBeforeRemove!class hierarchy-removing!public! !
!ExternalStructure class categoriesFor: #unregister!public!removing! !
!ExternalStructure class categoriesFor: #withBytes:!instance creation!public! !

ExternalStructure class methodProtocol: #'externalStructure class' attributes: #(#readOnly) selectors: #(#alignment #byteSize #clear: #compileDefinition #elementSize #fromAddress: #fromBytes: #init: #newBuffer)!

