﻿"Filed out from Dolphin Smalltalk"!

Core.Object
	variableByteSubclass: #'Core.GUID'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: 'null'
	classConstants: { '_GUID_Size' -> 16r10. 'StringSize' -> 16r26 }!

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

<==> aGUID
	"Answer the receiver's <integer> collation order with respect to the <Magitude> argument."

	"Defined for polymorphism with Strings, where this version of the spaceship operator is case-sensitive (#<=> is not). For GUIDs this is equivalent to #<=>."

	^self <=> aGUID!

<=> aGUID
	"Answer the ordering relationship between the receiver and the argument.
	Colloquially known as the spaceship operator."

	| status answer |
	status := ByteArray newFixed: 4.
	answer := OS.Rpcrt4
				uuidCompare: self
				uuid2: aGUID
				status: status.
	status := status uint32AtOffset: 0.
	status == 0 ifFalse: [OS.RPCError signalWith: status].
	^answer!

= comperand
	"Answer whether the receiver is equivalent to the <Object>, comperand."

	^self species == comperand species and: [self <=> comperand == 0]!

asByteArray
	"Answer the raw contents of the receiver as a ByteArray."

	^self
		replaceBytesOf: (ByteArray new: _GUID_Size)
		from: 1
		to: _GUID_Size
		startingAt: 1!

asInteger
	"Answer the 128-bit integer value of the receiver."

	^LargeInteger fromBytes: self!

asObject
	"Answer the <Object> value represented by the receiver."

	^self!

asString
	"Answer a string representation of the receiver."

	"Implementation Note: We want to use the standard COM string representation, so we need to add curly brackets. We could use the COM function, but that would mean creating a dependency on OLELibrary."

	| pSz string |
	pSz := External.Address new.
	OS.Rpcrt4 uuidToString: self stringUuid: pSz.
	string := (Utf8String new: StringSize)
				at: 1 put: ${;
				replaceFrom: 2
					to: ##(StringSize - 1)
					with: pSz
					startingAt: 1;
				at: StringSize put: $};
				yourself.
	OS.Rpcrt4 rpcStringFree: pSz.
	^string!

byteSize
	^_GUID_Size!

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

	| pSz answer |
	pSz := External.Address new.
	OS.Rpcrt4 uuidToString: self stringUuid: pSz.
	answer := Utf8String fromAddress: pSz.
	OS.Rpcrt4 rpcStringFree: pSz.
	^answer!

isNull
	"Answer whether the receiver is a null GUID."

	^(OS.Ucrt
		memcmp: self
		buf2: #[0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
		count: 16) == 0!

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

	guidBytes
		replaceBytesOf: self
		from: 1
		to: _GUID_Size
		startingAt: 1! !

!Core.GUID categoriesForMethods!
<==>!comparing!public! !
<=>!comparing!public! !
=!comparing!public! !
asByteArray!converting!public! !
asInteger!converting!public! !
asObject!converting!public! !
asString!converting!public! !
byteSize!accessing!public! !
displayOn:!printing!public! !
hash!comparing!public! !
idlString!converting!public! !
isNull!public!testing! !
isSelfEvaluating!public!testing! !
notNull!public!testing! !
printOn:!development!printing!public! !
replaceBytesOf:from:to:startingAt:!double dispatch!primitives!private! !
species!accessing!public! !
stringSize!constants!public! !
value:!accessing!public! !
!

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
	^_GUID_Size!

byteSize
	"Answer the size in bytes of this structure"

	^_GUID_Size!

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

	^_GUID_Size!

fromAddress: ptr
	"Answer a new instance of the receiver with contents copied from
	the  GUID pointed at by ptr"

	^ptr asExternalAddress
		replaceBytesOf: (self new: _GUID_Size)
		from: 1
		to: _GUID_Size
		startingAt: 1!

fromBytes: guidBytes
	"Answer a new instance of the receiver which is a copy of the specified bytes."

	^guidBytes
		replaceBytesOf: self newNull
		from: 1
		to: _GUID_Size
		startingAt: 1!

fromIdlString: aString
	"Answer a new instance of the receiver instantiated from the argument, aString, which is in IDL format, e.g. '87b4c48f-026e-11d3-9fd7-00a0cc3e4a32'"

	| answer |
	answer := self newNull.
	OS.Rpcrt4 uuidFromString: aString uuid: answer.
	^answer!

fromString: aString
	"Answer a new instance of the receiver instantiated from the argument, aString, which is in Microsoft™ GUID format, e.g. '{87b4c48f-026e-11d3-9fd7-00a0cc3e4a32}'"

	| answer |
	answer := self newNull.
	OS.Rpcrt4 uuidFromString: (aString copyFrom: 2 to: aString size - 1) uuid: answer.
	^answer!

init: addressOrBytes
	"Initialize an instance of the structure which instances of the receiver wrap
	which resides at the specified address."!

initialize
	"Private - Initialize the receiver's class variables.
		GUID initialize
	"

	self extraInstanceSpec: _GUID_Size.
	VM registryAt: self name put: self!

new
	"Answer a new, null, instance of the receiver."

	^self new: _GUID_Size!

newBuffer
	"Answer a new instance containing its own buffer."

	^self newFixed: self byteSize!

newNull
	"Answer a new, null, instance of the receiver."

	^self new: _GUID_Size!

newUnique
	"Answer a new instance of the receiver generated using the standard
	algorithm (i.e. the answer should be unique)."

	| answer |
	answer := self new: _GUID_Size.
	OS.Rpcrt4 uuidCreate: answer.
	^answer!

null
	"Answer a null instance of the receiver."

	^null
		ifNil: 
			[null := self newNull
						isImmutable: true;
						yourself]!

onPreStripImage
	"Private - Tidy up the receiver's lazily initialized class vars in preparation for image stripping."

	self uninitialize!

uninitialize
	"Private - Tidy up the receiver in preparation for removal from the system."

	null := nil.
	VM registryAt: self name put: nil.
	"Allow the RPCLibrary to be removed as it is probably no longer required"
	OS.RPCLibrary closeDefault! !

!Core.GUID class categoriesForMethods!
alignment!constants!private! !
atAddress:!instance creation!public! !
basicByteSize!public! !
byteSize!constants!public! !
clear:!public!realizing/unrealizing! !
defineFields!public!template definition! !
elementSize!accessing!private! !
fromAddress:!instance creation!public! !
fromBytes:!instance creation!public! !
fromIdlString:!instance creation!public! !
fromString:!instance creation!public! !
init:!initializing!public! !
initialize!development!initializing!private! !
new!instance creation!public! !
newBuffer!instance creation!public! !
newNull!instance creation!public! !
newUnique!instance creation!public! !
null!constants!public! !
onPreStripImage!class hierarchy-removing!private! !
uninitialize!class hierarchy-removing!private! !
!

Core.GUID class methodProtocol: #'externalStructure class' attributes: #(#readOnly) selectors: #(#alignment #byteSize #clear: #elementSize #fromAddress: #fromBytes: #init: #newBuffer)!

