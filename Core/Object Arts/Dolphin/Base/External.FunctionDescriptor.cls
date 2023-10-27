"Filed out from Dolphin Smalltalk"!

Core.Object
	variableSubclass: #'External.FunctionDescriptor'
	instanceVariableNames: 'descriptor'
	classVariableNames: ''
	imports: #(#{External.ExtCallArgTypes})
	classInstanceVariableNames: ''
	classConstants: {
			'CallingConventions' -> #(#stdcall: #cdecl: #fastcall: #thiscall:).
			'ReferenceTypes'
				-> #(16r1 16rF 16rC 16r1 16r1 #UInt16 #Int16 #UInt32 #Int32 #UInt32 #UInt32 #DOUBLE 16rF 16rF #FLOAT nil #HRESULT 16rF #UInt64 #Int64 16rF 16rF #'OS.COM.VARIANT' #'OS.COM.DATE' #'OS.COM.VARIANT_BOOL' #REFGUID #UIntPtr #IntPtr #Int32 #Int32 16r1 16r1 16r11 16r22 16rF nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 16r35 16r35 16r35 nil nil 16rF nil nil nil nil nil nil nil nil).
			'RetClassIndex' -> 16r4.
			'RetTypeMask' -> 16r3F.
			'TypeNames'
				-> #('void' 'lpvoid' 'char' 'uint8' 'int8' 'uint16' 'int16' 'uint32' 'int32' 'bool' 'handle' 'double' 'lpstr' 'oop' 'float' 'lppvoid' 'hresult' 'lpwstr' 'uint64' 'int64' 'ote' 'bstr' 'variant' 'date' 'varbool' 'guid' 'uintptr' 'intptr' 'ntstatus' 'errno' 'bool8' 'char32' 'char16' 'char8' 'lpstr8' nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil).
			'TypeSizes'
				-> #[0 4 0 4 4 4 4 4 4 4 4 8 4 4 4 4 4 4 8 8 4 4 16 8 4 16 4 4 4 4 4 4 4 4 4 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4 8 4 4 4 0 0 0 0 0 0 0 0].
			'ValueTypes'
				-> (LookupTable withAll: {
								'Address' -> 16r1.
								'bool' -> 16r9.
								'BOOL' -> 16r9.
								'bool8' -> 16r1E.
								'bstr' -> 16r15.
								'BSTR' -> 16r15.
								'byte' -> 16r3.
								'BYTE' -> 16r3.
								'char' -> 16r2.
								'char16' -> 16r20.
								'char32' -> 16r1F.
								'char8' -> 16r21.
								'CLSID' -> 16r19.
								'date' -> 16r17.
								'DATE' -> 16r17.
								'double' -> 16rB.
								'DOUBLE' -> 16rB.
								'dword' -> 16r7.
								'DWORD' -> 16r7.
								'errno' -> 16r1D.
								'float' -> 16rE.
								'FLOAT' -> 16rE.
								'guid' -> 16r19.
								'GUID' -> 16r19.
								'handle' -> 16rA.
								'Handle' -> 16rA.
								'hresult' -> 16r10.
								'HRESULT' -> 16r10.
								'IID' -> 16r19.
								'INT_PTR' -> 16r1B.
								'int16' -> 16r6.
								'Int16' -> 16r6.
								'int32' -> 16r8.
								'Int32' -> 16r8.
								'int64' -> 16r13.
								'Int64' -> 16r13.
								'int8' -> 16r4.
								'Int8' -> 16r4.
								'intptr' -> 16r1B.
								'IntPtr' -> 16r1B.
								'LARGE_INTEGER' -> 16r13.
								'lppvoid' -> 16rF.
								'lpstr' -> 16rC.
								'lpstr8' -> 16r22.
								'lpvoid' -> 16r1.
								'LPVOID' -> 16r1.
								'lpwstr' -> 16r11.
								'LPWSTR' -> 16r11.
								'ntstatus' -> 16r1C.
								'oop' -> 16rD.
								'ote' -> 16r14.
								'qword' -> 16r12.
								'QWORD' -> 16r12.
								'sbyte' -> 16r4.
								'SBYTE' -> 16r4.
								'sdword' -> 16r8.
								'SDWORD' -> 16r8.
								'sqword' -> 16r13.
								'SQWORD' -> 16r13.
								'sword' -> 16r6.
								'SWORD' -> 16r6.
								'UINT_PTR' -> 16r1A.
								'uint16' -> 16r5.
								'UInt16' -> 16r5.
								'uint32' -> 16r7.
								'UInt32' -> 16r7.
								'UInt32Bytes' -> 16r7.
								'uint64' -> 16r12.
								'UInt64' -> 16r12.
								'UInt64Bytes' -> 16r12.
								'uint8' -> 16r3.
								'UInt8' -> 16r3.
								'uintptr' -> 16r1A.
								'UIntPtr' -> 16r1A.
								'UIntPtrBytes' -> 16r1A.
								'ULARGE_INTEGER' -> 16r12.
								'varbool' -> 16r18.
								'variant' -> 16r16.
								'VARIANT' -> 16r16.
								'VARIANT_BOOL' -> 16r18.
								'void' -> 16r0.
								'word' -> 16r5.
								'WORD' -> 16r5
							})
		}!
External.FunctionDescriptor guid: (Core.GUID fromString: '{87b4c487-026e-11d3-9fd7-00a0cc3e4a32}')!
External.FunctionDescriptor comment: '`FunctionDescriptor` instances describe the return type, parameter types, and calling convention of native function calls for external interfacing purposes. They can be used to describe both outbound and inbound calls, represented by `ExternalMethod` and `External.Callback` instances respectively.

The argument/return types supported by the primitive DLL call function are:

  - `void` 		Only valid as a return type - the method answers `self`
  - `lpvoid` 	General pointer type, accepts byte objects e.g. `String`s (pointer to contents passed), `nil` (null pointer), `Integer`s (passes as address), or `ExternalAddress`s (the contained address is passed, not a pointer to the `External.Address` object). When used as a return type, the method answers an instance of `External.Address`.
  - `lppvoid`	Pointer to pointer. Used for functions which take a parameter into which they write an address. The corresponding argument must be an `External.Address` (or other indirection object), or an object whose first instance variable is such (e.g. an `External.Structure`). The address of the `External.Address` itself is passed, so that on return it contains the address written back by the external function. `nil` is not a valid argument value. As a return type answers a pointer instance of `LPVOID` (i.e. LPVOID* = void**).
  - `char`		Signed character. Accepts `Character`s only.
  - `uint8`		Unsigned byte. Accepts `SmallIntegers` only. Passes a 32-bit value generated by zero extending the least significant byte. Fails if not in the range 0..255. Zero extends into a positive `SmallInteger` when a return value.
  - `int8`		Signed byte. Accepts `SmallIntegers` only. Passes a 32-bit value generated by sign extending the least significant byte. Fails if not in range -128..127. Sign extends into a positive or negative `SmallInteger` when a return value.
  - `uint16`	Unsigned 16-bit integer. Passes a 32-bit value generated by zero extending the least significant 16-bits.  Accepts `SmallIntegers` in the range 0..65535. Also accepts a byte object of size 2, which is zero extended to 32-bits. Zero extends into a positive `SmallInteger` when a return value.
  - `int16` 	Signed 16-bit integer. Passes a 32-bit value generated by sign extending the least significant 16-bits. Accepts `SmallIntegers` in the range -32768..32767. Also accepts a byte object of size 2, which is sign extended to 32-bits. Sign extends into a positive or negative `SmallInteger` when a return value.
  - `uint32`	Unsigned 32-bits integers. Positive integers are passed as unsigned, and negative integers in their two''s complement representation.  The largest negative `LargeInteger` which can be passsed is -16r80000000 (or -2147483648) because this is the largest negative number which can be represented in 32-bits in two''s complement notation. Also accepts byte objects of length 4, assumed to be in an unsigned bit representation. 	`nil` is passed as 0. As a return type, answers a `SmallInteger`, or a `LargeInteger` if the result cannot be represented as a positive `SmallInteger` (i.e. in 30 bits).
  - `int32` 	Signed 32-bit integer. Accepts any `Integer` in the range -16r80000000..16r7FFFFFFF (i.e. `Integer`s with a 32-bit two''s complement representation - all `SmallIntegers` and 4-byte `LargeInteger`s). May also be other byte objects of length 4, which are assumed to contain a 2''s complement 32-bit number. As a return type answers a `SmallInteger`, or, if more than 31-bits are required to represent the two''s complement result, a `LargeInteger`. Also accepts `nil` (passed as 0).
  - `uint64`	Unsigned 64-bit integer. Similar to `uint32`, but 64-bit (i.e. the range is -16r8000000000000000, the largest 64-bit two''s complement negative integer, up to 16rFFFFFFFFFFFFFFF the largest positive 
		unsigned 64-bit integer). 8-byte objects are acceptable and assumed to encode an unsigned integer value. `nil` is passed as 0.
  - `int64`		Signed 64-bit integer. Accepts any `Integer` in the range which can be represented as a two''s complement integer in 64 bits (i.e. -16r8000000000000000 to 16r7FFFFFFFFFFFFFFF). Also accepts 8 byte objects, which are assumed to encode 64-bit two''s complement integers. `nil` is passed as 0. As a return type answers the most compact `Integer` form which can contain the 64-bit two''s complement integer.
  - `bool`		Boolean. As an argument type, accepts `true` (translated to 1) or `false` (translated to 0). Also accepts `SmallInteger` values, pushing their host machine representation. As a return type, if the result is 0 answers `false`, if the result is non-zero, answers `true`.
  - `handle`	Pointer-sized handle. Accepts integers in machine address range, `nil`, or a byte object of pointer size. As a return type, answers an `External.Handle`, unless the returned handle is `NULL`, in which case answers `nil`.
  - `double`	64-bit IEEE double-precision floating point number. Accepts instances of class `Float` (which contain a host machine representation of a double precision floating point number). `Integer`s may also be passed (they are promoted to the double precision floating point representation nearest their integral value). As a return type, answers an instance of class `Float`.
  - `lpstr`		Pointer to C (null-terminated) byte string. Accepts null terminated byte objects (e.g. `String`s, `Symbol`s) or `nil` (null pointer). `Utf16String`s are converted to `ANSIString`s implicitly. When used as a return type, 	answers a `String` containing the characters of the C string up to the null terminator. Unlike `lpvoid`, does not accept integer values as pointers, or `External.Address`  (indirection) objects. If the validation is too tight for your requirements, then use `lpvoid`. Do not use this return type where an external function is called which expects the caller to assume ownership of the returned string, and to delete it when it is no longer required, as a memory leak will result (use `lpvoid` instead, and free the memory explicitly).
  - `lpwstr`	Pointer to a null-terminated UTF-16 encoded string. Accepts null terminated byte objects (e.g. `String`s, `Symbol`s), which are implicitly converted to UTF-16, `Utf16String`s, which are passed directly, or `nil` (null pointer). When used as a return type, answers a `Utf16String` containing the characters of the C string up to the null terminator. Otherwise simlar to `lpstr`.
  - `oop`	Object identifier. Any non-SmallInteger can be passed. The value should be treated as an opaque handle, and should not be stored for later use (it may change during a GC). As a return type, answers the object whose Oop is the result. It is recommended that you do not use this type.
  - `float`	32-bit single-precision floating point. Accepts instances of class `Float`, or `SmallInteger`s (as `double`). The conversion of `Float`s (64-bit double precision) to `float` (32-bit single precision) may result in silent loss of precision. As a return type answers an instance of class `Float` (i.e. promotes to double precision).
  - `hresult`	32-bit signed integer value. Validation as #int32. As a return type, if less than 0 (i.e. severity is error), causes the external call primitives to fail with a negative failure reason which is the `HRESULT` value. This is convenient because it means the library can generate an exception automatically when an external function returns an HRESULT error (implemented in `#invalidCall:`)
  - `ntstatus`	32-bit signed ineger value. Handled in the same way as `hresult` by the VM, but separate ext call type allows the library `#invalidCall:` method to translate the error code differently. 
  - `errno`		32-bit signed integer value. Similar to `hresult`, but causes the primitive to fail if the return value is non-zero rather than just negative. Libraries that employ this return type typically have a custom `#invalidCall:` implementation that raised an appropriate type of exception, e.g. see `CRTLibrary`.
  - `<struct>`	For passing/returned the `External.Structure` named by `<struct>` by value (i.e a copy of the bytes). Accepts only the exact matching structure class. When used as a return value, an instance of the named `External.Structure` subclass is answered, with the bytes of the returned structure as its contents (copied into a `ByteArray`).
  - `<struct>*`	For passing/returned the `External.Structure` named by `<struct>` by reference (i.e a pointer to the bytes). When used as a return type, a pointer instance of the named `External.Structure` subclass is answered, holding an `External.Address` pointing at the externally stored value as its first instance variable.
  - `<struct>**`	Equivalent to `lppvoid`.
  - `variant`	`VARIANT`
	
Note that in general, the `UndefinedObject`, `nil`, is interchangeable with 0, or `NULL`, when interfacing with external library functions. Nullness can be tested with the `#isNull` message, with the `UndefinedObject` and `SmallInteger` zero answering true.'!
!External.FunctionDescriptor categoriesForClass!System-Support! !
!External.FunctionDescriptor methodsFor!

argumentCount
	"Private - Answer the argument count of the external function described by the receiver.
	N.B. This may be one less than the actual number of arguments if the receiver is describing
	a virtual function with implicit 'this' pointer."

	^descriptor at: 2!

argumentIndexFromOffset: anInteger 
	"Private - Convert a zero-based offset into the descriptor array (as used by the VM when marshalling
	the objects onto the stack for an external call) into the index of the corresponding argument. We have
	to take account of the literal indices that are embedded in the descriptor."

	| i offset stop |
	offset := RetClassIndex + 1.
	stop := offset + anInteger.
	i := 0.
	[offset > stop] whileFalse: 
			[| type |
			i := i + 1.
			type := descriptor at: offset.
			offset := offset + 1.
			(self class typeHasArgument: type) ifTrue: [offset := offset + 1]].
	^i!

argumentsDo: operation 
	"Private - Evaluate the dyadic valuable argument, operation, for each of the argument
	types of the receiver, passing the argument type and optional literal parameter#
	as the arguments."

	| i size |
	i := RetClassIndex + 1.
	size := descriptor size.
	[i > size] whileFalse: 
			[| type |
			type := descriptor at: i.
			i := i + 1.
			operation value: type
				value: ((self class typeHasArgument: type) 
						ifTrue: 
							[i := i + 1.
							self at: (descriptor at: i - 1) + 1])]!

argumentsSize
	"Private - Answer the total size, in bytes, that would be occupied by the arguments described 
	by the receiver when pushed onto the machine stack."

	| sum |
	sum := 0.
	self argumentsDo: [:type :class | sum := sum + (self class sizeOf: type type: class)].
	^sum!

argumentTypes
	"Private - Answer a sequenceable collection containing the argument type 
	descriptions for the receiver."

	| types |
	types := Array writeStream: self argumentCount.
	self argumentsDo: [:n :type | types nextPut: (self class nameOf: n type: type)].
	^types grabContents!

calleeCleans
	"Answer whether the receiver describes a function which pops its own arguments
	before returning (e.g. stdcall)."

	^self convention ~= 1	"cdecl is 1"!

callingConvention
	"Private - Answer the calling convention name of the external function described by the receiver.
	This is an integer enumeration."

	^self class nameOfConvention: self convention!

convention
	"Private - Answer the calling convention type (a small integer)."

	^descriptor first!

descriptor
	^descriptor!

descriptor: aByteArray
	"Private - Set the descriptor byte array for the external function described by the receiver."

	descriptor := aByteArray!

literals: args
	"Set the literal argument parameters to those in the SequenceableCollection argument, args.
	Answer the receiver."

	args keysAndValuesDo: [:i :e | self at: i put: e]
	!

name
	"Answer the 'name' of the external function described by the receiver."

	^'_'
	!

name: aString 
	"Set the 'name' of the external function described by the receiver to the argument.
	At the moment we discard this."

	^self!

printDescription
	"Answer the descriptor string for the external function described by the receiver."

	| stream |
	stream := String writeStream: 60.
	self printDescriptionOn: stream.
	^stream contents!

printDescriptionOn: aWriteStream
	| types |
	aWriteStream
		nextPutAll: self callingConvention;
		space;
		nextPutAll: self returnType.
	types := self argumentTypes.
	types do: 
			[:each |
			aWriteStream
				space;
				nextPutAll: each]!

printOn: aStream
	"Append a debug description of the receiver to aStream."

	aStream
		basicPrint: self;
		nextPut: $(.
	self printDescriptionOn: aStream.
	aStream nextPut: $)!

retType
	"Private - Answer the return type as a value from the external type enumeration."

	^(descriptor at: 3) bitAnd: RetTypeMask!

returnType
	"Private - Answer the return type name of the external function described by the receiver.
	This is an integer enumeration."

	| type class |
	type := self retType.
	class := (self class typeHasArgument: type) ifTrue: [self at: (descriptor at: RetClassIndex) + 1].
	^self class nameOf: type type: class! !
!External.FunctionDescriptor categoriesForMethods!
argumentCount!accessing!private! !
argumentIndexFromOffset:!helpers!private! !
argumentsDo:!accessing!private! !
argumentsSize!accessing!private! !
argumentTypes!accessing!private! !
calleeCleans!public!testing! !
callingConvention!accessing!private! !
convention!accessing!private! !
descriptor!accessing!private! !
descriptor:!accessing!private! !
literals:!accessing!public! !
name!accessing!public! !
name:!accessing!public! !
printDescription!printing!public! !
printDescriptionOn:!printing!private! !
printOn:!printing!public! !
retType!accessing!private! !
returnType!accessing!private! !
!

!External.FunctionDescriptor class methodsFor!

argumentTypes: argString
	"Answer an instance of the receiver instantiated from the argument, which is a String
	specifying a list of argument types in the standard Dolphin format. The return type is
	defaulted to 'uintptr' (i.e. UIntPtr) and the calling convention to 'stdcall:'."

	^self
		returnType: 'uintptr'
		argumentTypes: argString!

callingConvention: convString returnType: retString argumentTypes: argString
	"Answer an instance of the receiver instantiated from the arguments specifying, respectively, the calling convention, return type, and argument types as parseable strings.
	Any class names present in return type or argument types strings will be bound in the context of the Smalltalk namespace."

	^self callingConvention: convString returnType: retString argumentTypes: argString environment: Smalltalk!

callingConvention: convString returnType: retString argumentTypes: argString environment: aNamespace
	"Answer an instance of the receiver instantiated from the arguments specifying, respectively, the calling convention, return type, and argument types as parseable strings.
	Any class names present in return type or argument types strings will be bound in the context of the specified namespace (which can be in fact be any class)."

	^self fromString: convString, ' ', retString, ' ', argString environment: aNamespace!

conventionFromName: aString
	"Answer the type name for the specified integer type, or -1 if not recognised."

	^(CallingConventions indexOf: aString)-1!

descriptor: aByteArray literals: aSequenceableCollection
	"Private - Answer an instance of the receiver instantiated from the arguments."

	^(self new: aSequenceableCollection size)
		descriptor: aByteArray;
		literals: aSequenceableCollection;
		yourself!

fromString: aString environment: aNamespace
	"Answer an instance of the receiver instantiated from the argument, which
	is a Dolphin format external function descriptor, e.g:

		External.FunctionDescriptor fromString: 'stdcall: hresult GUID* lppvoid'
	"

	| pair |
	pair := self parseDescriptor: aString environment: aNamespace.
	^self descriptor: pair first literals: pair second!

initialize
	"Private - Initialize the class variables of the receiver.
		self initialize
	"

	"Maximum arg type value is currently 63"

	self addClassConstant: 'RetTypeMask' value: ExtCallArgMax.
	self initializeExternalTypes.
	self initializeExternalRefTypes.

	"Remember that bytes and words are still pushed as 32-bit values"
	self initializeTypeSizes.
	self initializeCallingConventions.
	self addClassConstant: 'RetClassIndex' value: 4!

initializeCallingConventions
	"Private - All possible calling conventions (not all are supported)"

	self addClassConstant: 'CallingConventions' value: #(#stdcall: #cdecl: #fastcall: #thiscall:)!

initializeExternalRefTypes
	"Private - Reference types are the types to be used for the value type with one level of indirection, where the name
	of a struct class appears, this is assumed to be associated with an ExtCallArgLP argument type."

	| referenceTypes |
	referenceTypes := Array new: ExtCallArgMax + 1.
	referenceTypes
		at: ExtCallArgVOID + 1 put: ExtCallArgLPVOID;
		at: ExtCallArgLPPVOID + 1 put: nil;
		at: ExtCallArgChar + 1 put: ExtCallArgLPSTR;
		at: ExtCallArgUInt8 + 1 put: ExtCallArgLPVOID;
		at: ExtCallArgInt8 + 1 put: ExtCallArgLPVOID;
		at: ExtCallArgUInt16 + 1 put: #UInt16;
		at: ExtCallArgInt16 + 1 put: #Int16;
		at: ExtCallArgUInt32 + 1 put: #UInt32;
		at: ExtCallArgInt32 + 1 put: #Int32;
		at: ExtCallArgUIntPtr + 1 put: #UIntPtr;
		at: ExtCallArgIntPtr + 1 put: #IntPtr;
		at: ExtCallArgBOOL + 1 put: #UInt32;
		at: ExtCallArgHANDLE + 1 put: #UInt32;
		at: ExtCallArgDOUBLE + 1 put: #DOUBLE;
		at: ExtCallArgLPSTR + 1 put: ExtCallArgLPPVOID;
		at: ExtCallArgOOP + 1 put: ExtCallArgLPPVOID;
		at: ExtCallArgFLOAT + 1 put: #FLOAT;
		at: ExtCallArgLPVOID + 1 put: ExtCallArgLPPVOID;
		at: ExtCallArgHRESULT + 1 put: #HRESULT;
		at: ExtCallArgLPWSTR + 1 put: ExtCallArgLPPVOID;
		at: ExtCallArgUInt64 + 1 put: #UInt64;
		at: ExtCallArgInt64 + 1 put: #Int64;
		at: ExtCallArgOTE + 1 put: ExtCallArgLPPVOID;
		at: ExtCallArgBSTR + 1 put: ExtCallArgLPPVOID;
		at: ExtCallArgVARIANT + 1 put: #'OS.COM.VARIANT';
		at: ExtCallArgDATE + 1 put: #'OS.COM.DATE';
		at: ExtCallArgVARBOOL + 1 put: #'OS.COM.VARIANT_BOOL';
		at: ExtCallArgGUID + 1 put: #REFGUID;
		at: ExtCallArgSTRUCT + 1 put: ExtCallArgLP;
		at: ExtCallArgSTRUCT4 + 1 put: ExtCallArgLP;
		at: ExtCallArgSTRUCT8 + 1 put: ExtCallArgLP;
		at: ExtCallArgNTSTATUS + 1 put: #Int32;
		at: ExtCallArgErrno + 1 put: #Int32;
		at: ExtCallArgBool8 + 1 put: ExtCallArgLPVOID;
		at: ExtCallArgChar32 + 1 put: ExtCallArgLPVOID;
		at: ExtCallArgChar16 + 1 put: ExtCallArgLPWSTR;
		at: ExtCallArgChar8 + 1 put: ExtCallArgLPSTR8;
		at: ExtCallArgLPSTR8 + 1 put: ExtCallArgLPPVOID;
		at: ExtCallArgCOMPTR + 1 put: ExtCallArgLPPVOID.
	self addClassConstant: 'ReferenceTypes' value: referenceTypes!

initializeExternalTypes
	| valueTypes typeNames |
	valueTypes := LookupTable new.
	valueTypes
		at: 'int32' put: ExtCallArgInt32;
		at: 'uint32' put: ExtCallArgUInt32;
		at: 'uintptr' put: ExtCallArgUIntPtr;
		at: 'intptr' put: ExtCallArgIntPtr;
		at: 'lpvoid' put: ExtCallArgLPVOID;
		at: 'handle' put: ExtCallArgHANDLE;
		at: 'lppvoid' put: ExtCallArgLPPVOID;
		at: 'lpstr' put: ExtCallArgLPSTR;
		at: 'bool' put: ExtCallArgBOOL;
		at: 'double' put: ExtCallArgDOUBLE;
		at: 'float' put: ExtCallArgFLOAT;
		at: 'hresult' put: ExtCallArgHRESULT;
		at: 'char' put: ExtCallArgChar;
		at: 'uint8' put: ExtCallArgUInt8;
		at: 'int8' put: ExtCallArgInt8;
		at: 'uint16' put: ExtCallArgUInt16;
		at: 'int16' put: ExtCallArgInt16;
		at: 'oop' put: ExtCallArgOOP;
		at: 'lpwstr' put: ExtCallArgLPWSTR;
		at: 'bstr' put: ExtCallArgBSTR;
		at: 'uint64' put: ExtCallArgUInt64;
		at: 'int64' put: ExtCallArgInt64;
		at: 'ote' put: ExtCallArgOTE;
		at: 'variant' put: ExtCallArgVARIANT;
		at: 'varbool' put: ExtCallArgVARBOOL;
		at: 'guid' put: ExtCallArgGUID;
		at: 'date' put: ExtCallArgDATE;
		at: 'ntstatus' put: ExtCallArgNTSTATUS;
		at: 'errno' put: ExtCallArgErrno;
		at: 'bool8' put: ExtCallArgBool8;
		at: 'char32' put: ExtCallArgChar32;
		at: 'char16' put: ExtCallArgChar16;
		at: 'char8' put: ExtCallArgChar8;
		at: 'lpstr8' put: ExtCallArgLPSTR8.

	"void is only valid as a return type, not an argument type."
	valueTypes at: 'void' put: ExtCallArgVOID.

	"Init the reverse mapping of the type enumeration to string names"
	typeNames := Array new: ExtCallArgMax + 1.
	valueTypes keysAndValuesDo: [:eachKey :eachValue | typeNames at: eachValue + 1 put: eachKey].

	"Legacy names"
	valueTypes
		at: 'sdword' put: ExtCallArgInt32;
		at: 'dword' put: ExtCallArgUInt32;
		at: 'byte' put: ExtCallArgUInt8;
		at: 'sbyte' put: ExtCallArgInt8;
		at: 'word' put: ExtCallArgUInt16;
		at: 'sword' put: ExtCallArgInt16;
		at: 'qword' put: ExtCallArgUInt64;
		at: 'sqword' put: ExtCallArgInt64.

	"Convert a few class types to the special types to save space and time"
	valueTypes
		at: 'Address' put: ExtCallArgLPVOID;
		at: 'Handle' put: ExtCallArgHANDLE;
		at: 'BOOL' put: ExtCallArgBOOL;
		at: 'Int32' put: ExtCallArgInt32;
		at: 'SDWORD' put: ExtCallArgInt32;
		at: 'UInt32Bytes' put: ExtCallArgUInt32;
		at: 'UInt32' put: ExtCallArgUInt32;
		at: 'DWORD' put: ExtCallArgUInt32;
		at: 'IntPtr' put: ExtCallArgIntPtr;
		at: 'INT_PTR' put: ExtCallArgIntPtr;
		at: 'UIntPtrBytes' put: ExtCallArgUIntPtr;
		at: 'UIntPtr' put: ExtCallArgUIntPtr;
		at: 'UINT_PTR' put: ExtCallArgUIntPtr;
		at: 'LPVOID' put: ExtCallArgLPVOID;
		at: 'DOUBLE' put: ExtCallArgDOUBLE;
		at: 'FLOAT' put: ExtCallArgFLOAT;
		at: 'HRESULT' put: ExtCallArgHRESULT;
		at: 'UInt8' put: ExtCallArgUInt8;
		at: 'BYTE' put: ExtCallArgUInt8;
		at: 'Int8' put: ExtCallArgInt8;
		at: 'SBYTE' put: ExtCallArgInt8;
		at: 'UInt16' put: ExtCallArgUInt16;
		at: 'WORD' put: ExtCallArgUInt16;
		at: 'Int16' put: ExtCallArgInt16;
		at: 'SWORD' put: ExtCallArgInt16;
		at: 'LPWSTR' put: ExtCallArgLPWSTR;
		at: 'UInt64Bytes' put: ExtCallArgUInt64;
		at: 'UInt64' put: ExtCallArgUInt64;
		at: 'QWORD' put: ExtCallArgUInt64;
		at: 'ULARGE_INTEGER' put: ExtCallArgUInt64;
		at: 'Int64' put: ExtCallArgInt64;
		at: 'SQWORD' put: ExtCallArgInt64;
		at: 'LARGE_INTEGER' put: ExtCallArgInt64;
		at: 'GUID' put: ExtCallArgGUID;
		at: 'IID' put: ExtCallArgGUID;
		at: 'CLSID' put: ExtCallArgGUID;
		at: 'BSTR' put: ExtCallArgBSTR;
		at: 'VARIANT' put: ExtCallArgVARIANT;
		at: 'VARIANT_BOOL' put: ExtCallArgVARBOOL;
		at: 'DATE' put: ExtCallArgDATE;
		shrink.
	"The ValueTypes variable is assigned for testing purposes"
	self addClassConstant: 'ValueTypes' value: valueTypes.
	self addClassConstant: 'TypeNames' value: typeNames!

initializeTypeSizes
	| typeSizes |
	"Remember that bytes and words are still pushed as 32-bit values"
	typeSizes := ByteArray new: 64.
	typeSizes
		at: ExtCallArgVOID + 1 put: 0;
		at: ExtCallArgLPVOID + 1 put: VMConstants.IntPtrSize;
		at: ExtCallArgUInt8 + 1 put: 4;
		at: ExtCallArgInt8 + 1 put: 4;
		at: ExtCallArgUInt16 + 1 put: 4;
		at: ExtCallArgInt16 + 1 put: 4;
		at: ExtCallArgUInt32 + 1 put: 4;
		at: ExtCallArgInt32 + 1 put: 4;
		at: ExtCallArgBOOL + 1 put: 4;
		at: ExtCallArgHANDLE + 1 put: VMConstants.IntPtrSize;
		at: ExtCallArgDOUBLE + 1 put: 8;
		at: ExtCallArgLPSTR + 1 put: VMConstants.IntPtrSize;
		at: ExtCallArgOOP + 1 put: VMConstants.IntPtrSize;
		at: ExtCallArgFLOAT + 1 put: 4;
		at: ExtCallArgLPPVOID + 1 put: VMConstants.IntPtrSize;
		at: ExtCallArgHRESULT + 1 put: 4;
		at: ExtCallArgLPWSTR + 1 put: VMConstants.IntPtrSize;
		at: ExtCallArgUInt64 + 1 put: 8;
		at: ExtCallArgInt64 + 1 put: 8;
		at: ExtCallArgOTE + 1 put: VMConstants.IntPtrSize;
		at: ExtCallArgBSTR + 1 put: VMConstants.IntPtrSize;
		at: ExtCallArgVARIANT + 1 put: 16;
		at: ExtCallArgDATE + 1 put: 8;
		at: ExtCallArgVARBOOL + 1 put: 4;
		at: ExtCallArgGUID + 1 put: 16;
		at: ExtCallArgUIntPtr + 1 put: VMConstants.IntPtrSize;
		at: ExtCallArgIntPtr + 1 put: VMConstants.IntPtrSize;
		at: ExtCallArgNTSTATUS + 1 put: 4;
		at: ExtCallArgErrno + 1 put: 4;
		at: ExtCallArgBool8 + 1 put: 4;
		at: ExtCallArgChar32 + 1 put: 4;
		at: ExtCallArgChar16 + 1 put: 4;
		at: ExtCallArgChar8 + 1 put: 4;
		at: ExtCallArgLPSTR8 + 1 put: VMConstants.IntPtrSize;
		at: ExtCallArgSTRUCT + 1 put: 0;
		at: ExtCallArgSTRUCT4 + 1 put: 4;
		at: ExtCallArgSTRUCT8 + 1 put: 8;
		at: ExtCallArgLP + 1 put: VMConstants.IntPtrSize;
		at: ExtCallArgLPP + 1 put: VMConstants.IntPtrSize;
		at: ExtCallArgCOMPTR + 1 put: VMConstants.IntPtrSize.
	self assert: [ValueTypes asSortedArray last < typeSizes size].
	self addClassConstant: 'TypeSizes' value: typeSizes!

isPointerToStruct: anInteger 
	^anInteger == ExtCallArgLP or: [anInteger == ExtCallArgCOMPTR]!

nameOf: typeOrdinal type: aClass 
	"Answer the type name for the specified type."

	^(self typeHasArgument: typeOrdinal) 
		ifTrue: 
			[aClass fullName , (((self isPointerToStruct: typeOrdinal) and: [aClass isIndirection not]) 
						ifTrue: ['*']
						ifFalse: [''])]
		ifFalse: [TypeNames at: typeOrdinal + 1]!

nameOfConvention: anInteger
	"Answer the calling convention name for the specified convention type ordinal."

	^CallingConventions at: anInteger + 1!

oneStringArg
	"Answer a shared instance of the receiver describing a standard function
	with a single string argument."

	#deprecated.
	^self argumentTypes: 'lpstr'!

parseArgDesc: aString environment: aNamespace
	"Private - Parse the next argument type from the input stream argument, aStream, answering
	an association between the type number and an optional argument (a subclass of ExternalStructure)."

	| qualifier typeName assoc |
	typeName := aString upTo: $*.
	qualifier := aString copyFrom: typeName size + 1 to: aString size.

	"Get an association between a type code for the name and the associated indirection type code or class name"
	assoc := (self typeFromName: typeName ifAbsent: [])
				ifNil: 
					["Not a built-in type, so try as a class..."
					ExtCallArgSTRUCT -> typeName asSymbol]
				ifNotNil: [:code | code -> (self referenceTypeFor: code)].
	qualifier = '**'
		ifTrue: 
			[^self
				parseDoubleIndirection: assoc
				typeName: typeName
				environment: aNamespace].
	qualifier = '*' ifTrue: [^self parseSingleIndirection: assoc environment: aNamespace].
	^self parseValueType: assoc environment: aNamespace!

parseCallingConvention: aStream
	"Private - Answer the calling convention number specified by the input stream."

	^self conventionFromName: aStream nextWord!

parseDescriptor: aString environment: aNamespace
	"Private - Parse a literal string which describes an external function in the standard
	Dolphin format. This is very simplistic pending Smalltalk compiler support."

	| descriptor literals stream argCount returnType |
	stream := aString readStream.
	descriptor := ByteArray writeStream: 10.
	descriptor nextPut: (self parseCallingConvention: stream).
	descriptor nextPut: 0.	"Reserve slot for argument count"
	returnType := self parseArgDesc: stream nextWord environment: aNamespace.
	descriptor nextPut: returnType key.
	descriptor nextPut: 0.
	literals := WriteStream on: {}.
	returnType value notNil ifTrue: [literals nextPut: returnType value].
	argCount := 0.
	stream skipSeparators.
	[stream atEnd] whileFalse: 
			[| argType |
			argType := self parseArgDesc: stream nextWord environment: aNamespace.
			argCount := argCount + 1.
			descriptor nextPut: argType key.
			argType value notNil
				ifTrue: 
					[descriptor nextPut: literals size.
					literals nextPut: argType value]].
	descriptor := descriptor contents.
	descriptor at: 2 put: argCount.
	^Pair first: descriptor second: literals contents!

parseDoubleIndirection: assoc typeName: typeName environment: aNamespace
	| pointerType |
	pointerType := assoc value.
	"If indirection type is #lppvoid or an indirection class, then cannot indirect it further"
	(pointerType == ExtCallArgLPPVOID or: 
			[pointerType isInteger not and: 
					[assoc key == ExtCallArgSTRUCT
						and: [(BindingReference pathString: pointerType home: aNamespace) value isIndirection]]])
		ifTrue: 
			[Notification
				signal: '<s>**: Only one further level of indirection to an indirection type is possible. Will be treated as lppvoid'
						<< typeName].
	^ExtCallArgLPPVOID -> nil!

parsePointerToStruct: anAssociation environment: aNamespace
	| structClass |
	structClass := (BindingReference pathString: anAssociation value home: aNamespace) value.
	^(structClass isIndirection and: [anAssociation key == ExtCallArgSTRUCT])
		ifTrue: [ExtCallArgLPPVOID -> nil]
		ifFalse: 
			[(#{COM.IUnknown} valueOrNil
				ifNil: [ExtCallArgLP]
				ifNotNil: [:unkClass | (structClass includesBehavior: unkClass) ifTrue: [ExtCallArgCOMPTR] ifFalse: [ExtCallArgLP]])
					-> structClass]!

parseSingleIndirection: anAssociation environment: aNamespace
	^anAssociation value
		ifNil: 
			[self error: ('<s> cannot be further indirected'
						expandMacrosWith: (self nameOf: anAssociation key type: nil))]
		ifNotNil: 
			[:pointerType |
			pointerType isInteger not
				ifTrue: [self parsePointerToStruct: anAssociation environment: aNamespace]
				ifFalse: [pointerType -> nil]]!

parseStructArg: assoc environment: aNamespace
	| structClass |
	structClass := (BindingReference pathString: assoc value home: aNamespace) value.
	^(structClass isIndirection
		ifTrue: [ExtCallArgLP]
		ifFalse: 
			[| bytes |
			bytes := structClass byteSize.
			bytes <= 4
				ifTrue: [ExtCallArgSTRUCT4]
				ifFalse: [bytes <= 8 ifTrue: [ExtCallArgSTRUCT8] ifFalse: [ExtCallArgSTRUCT]]])
			-> structClass!

parseValueType: assoc environment: aNamespace
	assoc key == ExtCallArgSTRUCT ifTrue: [^self parseStructArg: assoc environment: aNamespace].
	^assoc key -> nil!

referenceTypeFor: valueType
	^ReferenceTypes at: valueType + 1!

returnType: retString argumentTypes: argString
	"Answer an instance of the receiver instantiated from the argument, which
	is a String specifying a list of argument types in the standard Dolphin
	format. The return type is defaulted to 'dword' and the calling convention
	to 'stdcall:'."

	^self
		callingConvention: 'stdcall:'
		returnType: retString
		argumentTypes: argString!

sizeOf: anInteger type: aClass 
	"Private - Answer the size of the specified type."

	^anInteger == ExtCallArgSTRUCT 
		ifTrue: [aClass byteSize]
		ifFalse: [TypeSizes at: anInteger + 1]!

structTypeForSize: anInteger
	"Private - Answer the structure type to use for structures of the specified byte size."

	anInteger <= 8
		ifTrue: 
			[anInteger <= 4 ifTrue: [anInteger > 0 ifTrue: [^ExtCallArgSTRUCT4]] ifFalse: [^ExtCallArgSTRUCT8]].
	^ExtCallArgSTRUCT!

typeFromName: typeName
	"Answer the type code for the specified <readableString> type name."

	^self typeFromName: typeName ifAbsent: [self errorNotFound: typeName]!

typeFromName: typeName ifAbsent: exceptionHandler
	"Answer the type code for the specified <readableString> type name, 
	or the result of executing the niladic valuable, exceptionHandler, if the
	type is not recognised."

	^ValueTypes at: typeName ifAbsent: exceptionHandler!

typeHasArgument: ordinalType
	"Private - Answer whether the specified type (identified by ordinal) has an argument
	accompanying it."

	^ordinalType >= ExtCallArgSTRUCT! !
!External.FunctionDescriptor class categoriesForMethods!
argumentTypes:!instance creation!public! !
callingConvention:returnType:argumentTypes:!instance creation!public! !
callingConvention:returnType:argumentTypes:environment:!instance creation!public! !
conventionFromName:!constants!public! !
descriptor:literals:!instance creation!private! !
fromString:environment:!instance creation!public! !
initialize!development!initializing!private! !
initializeCallingConventions!development!initializing!private! !
initializeExternalRefTypes!development!initializing!private! !
initializeExternalTypes!development!initializing!private! !
initializeTypeSizes!development!initializing!private! !
isPointerToStruct:!helpers!private! !
nameOf:type:!constants!public! !
nameOfConvention:!constants!public! !
oneStringArg!instance creation!public! !
parseArgDesc:environment:!parsing!private! !
parseCallingConvention:!parsing!private! !
parseDescriptor:environment:!parsing!private! !
parseDoubleIndirection:typeName:environment:!helpers!private! !
parsePointerToStruct:environment:!parsing!private! !
parseSingleIndirection:environment:!helpers!private! !
parseStructArg:environment:!parsing!private! !
parseValueType:environment:!parsing!private! !
referenceTypeFor:!parsing!public! !
returnType:argumentTypes:!instance creation!public! !
sizeOf:type:!constants!private! !
structTypeForSize:!constants!private! !
typeFromName:!constants!public! !
typeFromName:ifAbsent:!constants!public! !
typeHasArgument:!enquiries!private! !
!

