"Filed out from Dolphin Smalltalk 7"!

Core.Object variableByteSubclass: #'Core.GUID'
	instanceVariableNames: ''
	classVariableNames: 'Null'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'ByteSize' -> 16r10.
		'StringSize' -> 16r26
	}!
Core.GUID guid: (Core.GUID fromString: '{87b4c48f-026e-11d3-9fd7-00a0cc3e4a32}')!
Core.GUID comment: 'GUID is the class of 128-bit Globally Unique Identifiers (guids) which are used wherever a unique identifier is required in COM, for example to identify specific coclasses and interfaces.

You can easily allocate a new GUID by sending #newUnique to this class. Note that this process is very fast, so there is no particular reason not to use GUIDs for other purposes requiring unique identifiers such as records in a database.

Note: In versions of Dolphin prior to 2.2 GUID was a subclass of ExternalStructure. Although logically GUID belongs under ExternalStructure, it was move for reasons of space efficiency (every class now has a unique GUID).

Instance Variables:
	None (byte class)

Class Variables:
	Null	- The null <GUID>.'!
!Core.GUID categoriesForClass!External-Data-Structured-COM! !
!Core.GUID methodsFor!

<=> aGUID
	"Answer the ordering relationship between the receiver and the argument.
	Colloquially known as the spaceship operator."

	| status answer |
	status := ByteArray newFixed: 4.
	answer := OS.RPCLibrary default
				uuidCompare: self
				uuid2: aGUID
				status: status.
	status := status dwordAtOffset: 0.
	status == 0 ifFalse: [OS.RPCError signalWith: status].
	^answer!

= comperand
	"Answer whether the receiver is equivalent to the <Object>, comperand."

	^self species = comperand species and: [self <=> comperand == 0]!

asByteArray
	"Answer the raw contents of the receiver as a ByteArray."

	| answer |
	answer := ByteArray new: ByteSize.
	self
		replaceBytesOf: answer
		from: 1
		to: ByteSize
		startingAt: 1.
	^answer!

asInteger
	"Answer the 128-bit integer value of the receiver."

	^LargeInteger fromBytes: self asByteArray!

asObject
	"Answer the <Object> value represented by the receiver."

	^self!

asString
	"Answer a string representation of the receiver."

	"Implementation Note: We want to use the standard COM string representation, so we need to add curly brackets. We could use the COM function, but that would mean creating a dependency on OLELibrary."

	| pSz lib string |
	pSz := External.Address new.
	lib := OS.RPCLibrary default.
	lib uuidToString: self stringUuid: pSz.
	string := (Utf8String new: StringSize)
				at: 1 put: ${;
				replaceFrom: 2
					to: ##(StringSize - 1)
					with: pSz
					startingAt: 1;
				at: StringSize put: $};
				yourself.
	lib rpcStringFree: pSz.
	^string!

displayOn: aPuttableStream
	"Append to the <puttableStream> argument a String whose characters are a representation of the receiver that an end-user might want to see.
	GUIDs are a fairly technical concept, but they do appear in the registry in a certain format, which we use here."

	aPuttableStream nextPutAll: self asString!

hash
	"Hash the bytes of the object using the standard byte hashing
	primitive (which should not fail)."

	<primitive: 106>
	| hash |
	hash := 2166136261.
	"FNV1a"
	1 to: self basicSize
		do: [:i | hash := (hash bitXor: (self basicAt: i)) * 16777619 bitAnd: 16rFFFFFFFF].
	"Fold to 30 bits so is always positive SmallInteger"
	^(hash bitShift: -30) bitXor: (hash bitAnd: 16r3FFFFFFF)!

idlString
	"Answer the IDL string representation of the receiver.
		self newUnique idlString
	"

	| pSz lib answer |
	pSz := External.Address new.
	lib := OS.RPCLibrary default.
	lib uuidToString: self stringUuid: pSz.
	answer := Utf8String fromAddress: pSz.
	lib rpcStringFree: pSz.
	^answer!

isNull
	"Answer whether the receiver is a null external data item
	(that is, a null pointer, or a nilled out structure)."

	^self = self class null!

isSelfEvaluating
	"Answer whether or not the receiver has a printString representation that evaluates back to an equivalent object."

	^true!

notNull
	"Answer whether the receiver is a null external data item (that is, a null pointer, or a
	nilled out structure)."

	^self isNull not!

printOn: aStream
	"Append a textual representation of the receiver to aStream."

	self isNull
		ifTrue: 
			[aStream
				print: self class;
				space;
				display: #null]
		ifFalse: 
			[aStream
				nextPut: $(;
				print: self class;
				space;
				display: #fromString:;
				space;
				print: self asString;
				nextPut: $)]!

replaceBytesOf: aByteObject from: start to: stop startingAt: fromStart
	"Private - Standard method for transfering bytes from one variable
	byte object to another, normally double dispatched from #replaceFrom:to:with:startingAt:

	Primitive Failure Reasons:
		InvalidParameter1	- aByteObject is not a byte object
		InvalidParameter2	- start is not a SmallInteger.
		InvalidParameter3	- stop is not a SmallInteger.
		InvalidParameter4	- fromStart is not a SmallInteger.
		OutOfBounds		- 'from' or 'to' interval is out-of-bounds
	"

	<primitive: 142>
	| fromOffset |
	fromOffset := fromStart - start.
	stop to: start
		by: -1
		do: [:i | aByteObject at: i put: (self basicAt: i + fromOffset)].
	^aByteObject!

species
	"Answer the preferred class of the receiver - not always the same as the answer to #class (although this implementation uses the class primitive, which should not fail). Normally used when comparing two objects to determine if they are of the comparable types.
	In this case the species of GUID and its subclasses is always GUID."

	^GUID!

stringSize
	"Answer the number of characters in a GUID string."

	^StringSize!

value: guidBytes
	"Set the raw binary value of the receiver from those of the argument."

	guidBytes replaceBytesOf: self from: 1 to: self class byteSize startingAt: 1! !
!Core.GUID categoriesFor: #<=>!comparing!public! !
!Core.GUID categoriesFor: #=!comparing!public! !
!Core.GUID categoriesFor: #asByteArray!converting!public! !
!Core.GUID categoriesFor: #asInteger!converting!public! !
!Core.GUID categoriesFor: #asObject!accessing!public! !
!Core.GUID categoriesFor: #asString!converting!public! !
!Core.GUID categoriesFor: #displayOn:!printing!public! !
!Core.GUID categoriesFor: #hash!comparing!public! !
!Core.GUID categoriesFor: #idlString!converting!public! !
!Core.GUID categoriesFor: #isNull!public!testing! !
!Core.GUID categoriesFor: #isSelfEvaluating!public!testing! !
!Core.GUID categoriesFor: #notNull!public!testing! !
!Core.GUID categoriesFor: #printOn:!development!printing!public! !
!Core.GUID categoriesFor: #replaceBytesOf:from:to:startingAt:!double dispatch!primitives!private! !
!Core.GUID categoriesFor: #species!accessing!public! !
!Core.GUID categoriesFor: #stringSize!constants!public! !
!Core.GUID categoriesFor: #value:!accessing!public! !

!Core.GUID class methodsFor!

alignment
	"Answer the alignment requirements for the receiver.
	Implementation Note: The receiver is actually defined as a structure
	of the following form:
		typedef struct _GUID {
		    unsigned long  Data1;
		    unsigned short Data2;
		    unsigned short Data3;
		    unsigned char  Data4[ 8 ];
		} GUID;
	This means it's maximum alignment requirement is for a 32-bit integer,
	i.e. 4 rather than 16.
	"

	^4!

atAddress: anAddress
	"Answer a new instance of the receiver instantiated from the
	data at the specified address. Normally  this will be a 'reference' 
	instance, that points at the data embedded	at the specified address. 
	However in the case of objects that always have reference form
	(e.g. COM interface pointers, BSTRs, etc) this will be a copy
	of the pointer at that address. This is particularly useful for accessing
	elements of arrays."

	^self fromAddress: anAddress!

basicByteSize
	^ByteSize!

byteSize
	"Answer the size in bytes of this structure"

	^ByteSize!

clear: addressOrBytes
	"Finalize an instance of the structure which instances of the receiver wrap
	which resides at the specified address. Note that this is not about freeing
	the specified memory block, but any resources which it references."!

defineFields
	"Define the fields of the GUID structure.
		GUID defineTemplate
	
		typedef 		struct tagGUID {
			unsigned long Data1;
			unsigned short Data2;
			unsigned short Data3;
			char Data4[8];
		} GUID;

	"

	"This method only present to prevent auto-generation from stdole type library

	self
		defineField: #Data1 type: DWORDField new offset: 0;
		defineField: #Data2 type: WORDField new offset: 4;
		defineField: #Data3 type: WORDField new offset: 6;
		defineField: #Data4 type: (ArrayField type: ByteArray length: 8) offset: 8.
	self byteSize: 16"


!

elementSize
	"Private - Answer the size (in bytes) of the structure the receiver represents
	when used as an array element."

	^ByteSize!

fromAddress: ptr
	"Answer a new instance of the receiver with contents copied from
	the  GUID pointed at by ptr"

	^ptr asExternalAddress
		replaceBytesOf: self newNull
		from: 1 to: ByteSize startingAt: 1!

fromBytes: guidBytes
	"Answer a new instance of the receiver which is a copy of the specified bytes."

	^guidBytes replaceBytesOf: self newNull from: 1 to: ByteSize startingAt: 1
!

fromIdlString: aString
	"Answer a new instance of the receiver instantiated from the argument, aString, which is in IDL format, e.g. '87b4c48f-026e-11d3-9fd7-00a0cc3e4a32'"

	| answer |
	answer := self newNull.
	OS.RPCLibrary default uuidFromString: aString uuid: answer.
	^answer!

fromString: aString
	"Answer a new instance of the receiver instantiated from the argument, aString, which is in Microsoft™ GUID format, e.g. '{87b4c48f-026e-11d3-9fd7-00a0cc3e4a32}'"

	| answer |
	answer := self newNull.
	OS.RPCLibrary default uuidFromString: (aString copyFrom: 2 to: aString size - 1) uuid: answer.
	^answer!

init: addressOrBytes
	"Initialize an instance of the structure which instances of the receiver wrap
	which resides at the specified address."!

initialize
	"Private - Initialize the receiver's class variables.
		GUID initialize
	"
	self extraInstanceSpec: ByteSize.
	VMLibrary default registryAt: self name put: self!

new
	"Answer a new, null, instance of the receiver."

	^self new: ByteSize!

newBuffer
	"Answer a new instance containing its own buffer."

	^self newNull
!

newNull
	"Answer a new, null, instance of the receiver."

	^self new: ByteSize!

newUnique
	"Answer a new instance of the receiver generated using the standard
	algorithm (i.e. the answer should be unique)."

	| answer |
	answer := self new: ByteSize.
	OS.RPCLibrary default uuidCreate: answer.
	^answer!

null
	"Answer a null instance of the receiver."

	^Null ifNil: [Null := self newNull]!

onPreStripImage
	"Private - Tidy up the receiver's lazily initialized class vars in preparation for image stripping."

	self uninitialize!

uninitialize
	"Private - Tidy up the receiver in preparation for removal from the system."

	Null := nil.
	VMLibrary default registryAt: self name put: nil! !
!Core.GUID class categoriesFor: #alignment!constants!private! !
!Core.GUID class categoriesFor: #atAddress:!instance creation!public! !
!Core.GUID class categoriesFor: #basicByteSize!public! !
!Core.GUID class categoriesFor: #byteSize!constants!public! !
!Core.GUID class categoriesFor: #clear:!public!realizing/unrealizing! !
!Core.GUID class categoriesFor: #defineFields!public!template definition! !
!Core.GUID class categoriesFor: #elementSize!accessing!private! !
!Core.GUID class categoriesFor: #fromAddress:!instance creation!public! !
!Core.GUID class categoriesFor: #fromBytes:!instance creation!public! !
!Core.GUID class categoriesFor: #fromIdlString:!instance creation!public! !
!Core.GUID class categoriesFor: #fromString:!instance creation!public! !
!Core.GUID class categoriesFor: #init:!initializing!public! !
!Core.GUID class categoriesFor: #initialize!development!initializing!private! !
!Core.GUID class categoriesFor: #new!instance creation!public! !
!Core.GUID class categoriesFor: #newBuffer!instance creation!public! !
!Core.GUID class categoriesFor: #newNull!instance creation!public! !
!Core.GUID class categoriesFor: #newUnique!instance creation!public! !
!Core.GUID class categoriesFor: #null!constants!public! !
!Core.GUID class categoriesFor: #onPreStripImage!class hierarchy-removing!private! !
!Core.GUID class categoriesFor: #uninitialize!class hierarchy-removing!private! !

Core.GUID class methodProtocol: #'externalStructure class' attributes: #(#readOnly) selectors: #(#alignment #byteSize #clear: #elementSize #fromAddress: #fromBytes: #init: #newBuffer)!

