"Filed out from Dolphin Smalltalk 7"!

OS.COM.FinalizableStructure subclass: #'OS.COM.VARIANT'
	instanceVariableNames: 'data'
	classVariableNames: 'Unspecified'
	imports: #(#{OS.Win32Constants} #{OS.COM.AutomationConstants} #{OS.COM.AutomationErrors})
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_dblVal' -> 16r8.
		'_OffsetOf_vt' -> 16r0.
		'_OffsetOf_wReserved1' -> 16r2.
		'_OffsetOf_wReserved2' -> 16r4.
		'_OffsetOf_wReserved3' -> 16r6.
		'VTClasses' -> #(#{UndefinedObject} nil #{SWORD} #{SDWORD} #{FLOAT} #{DOUBLE} #{CURRENCY} #{DATE} #{BSTR} #{IDispatch} #{HRESULT} #{VARIANT_BOOL} #{VARIANT} #{IUnknown} #{DECIMAL} nil #{SBYTE} #{BYTE} #{WORD} #{DWORD} #{LARGE_INTEGER} #{ULARGE_INTEGER} #{SDWORD} #{DWORD} #{VOID} #{HRESULT} #{Address} #{SAFEARRAY} #{External.Array} #{Record} #{AnsiString} #{Utf16String} nil nil nil nil #{Structure} nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil #{FILETIME} nil nil nil nil nil nil #{DWORD} #{CLSID}).
		'VTNames' -> #(#nil #null #sword #sdword #float #double #cy #date #bstr #dispatch #hresult #varbool #variant #unknown #decimal #badVarType #sbyte #byte #word #dword #sqword #qword #sdword #dword #void #hresult #lpvoid #safearray #carray #typedef #lpstr #lpwstr #badVarType #badVarType #badVarType #badVarType #struct #badVarType #badVarType #badVarType #badVarType #badVarType #badVarType #badVarType #badVarType #badVarType #badVarType #badVarType #badVarType #badVarType #badVarType #badVarType #badVarType #badVarType #badVarType #badVarType #badVarType #badVarType #badVarType #badVarType #badVarType #badVarType #badVarType #badVarType #filetime #blob #stream #storage #streamed_object #stored_object #blob_object #cf #clsid)
	}!
OS.COM.VARIANT guid: (Core.GUID fromString: '{c06f3b65-0868-11d3-93af-00a024ca708a}')!
OS.COM.VARIANT comment: 'VARIANT is an <ExternalStructure> to represent the OLE Automation VARIANT and VARIANTARG types.

A VARIANT is basically a discriminated union which can represent all the parameter types which can be passed to and returned from member functions of Automation compatible (oleautomation) interfaces by Automation controllers and servers. These types are constrained by those which VB can handle, and hence there are no unsigned integers. A VARIANT''s type tag is stored as a 16-bit <integer> at the start of the structure, and is accessing with the #vt/vt: methods. Note that not all of the VT_XXX types are actually supported by the various variant manipulation functions provided by the Automation library, e.g. VT_LPSTR, as some are intended for type description and other purposes.

One complexity of VARIANTs worth noting is that they may, when used as arguments (i.e. VARIANTARGs) be used to pass parameters by reference. In this case they contain a pointer to the actual data, and the flag VT_BYREF is bitOr''d with the basic VT_XX data type tag. Dolphin handles this usage transparently such that no difference is perceived by users of this class.

It is worth noting that with the default Win32 packing (Zp8), VARIANT aligns on 8 byte boundaries, and may therefore make structures in which it is embedded larger than expected (this is handled correctly by Dolphin''s structure packing algorithm).

Class Variables:
	Accessors		<LookupTable> mapping variant type codes to accessor methods for extracting an object of that type.
'!
!OS.COM.VARIANT categoriesForClass!External-Data-Structured-COM! !
!OS.COM.VARIANT methodsFor!

_deepCopy: copiesDictionary
	"Private - Answer a 'deep copy' of the receiver, cloning only those parts not already included
	in the IdentityDictionary argument, copiesDictionary.
	Implementation Note: We have no copiable instance variables, and so just create a new instance
	and use an appropriate API call to copy the receiver into it."

	| copy |
	copy := VARIANT new.
	OLEAutLibrary default variantCopyInd: copy pvargSrc: self.
	^copy!

< comperand
	"Answer whether the receiver is less than the <VARIANT> argument, comperand."

	^(self cmp: comperand) < 0!

<= comperand
	"Answer whether the receiver is less than or equal to the <VARIANT> argument, comperand."

	^(self cmp: comperand) <= 0!

= comperand
	"Answer whether the receiver is equivalent to argument, comperand."

	^self == comperand or: [
		self species == comperand species and: [(self cmp: comperand) == 0]]!

> comperand
	"Answer whether the receiver is greater than the <VARIANT> argument, comperand."

	^(self cmp: comperand) > 0!

>= comperand
	"Answer whether the receiver is greater than or equal to the <VARIANT> argument, comperand."

	^(self cmp: comperand) >= 0!

array
	"Answer a SAFEARRAY from the receiver.
	Assumes that the receiver actually references an array."

	^SAFEARRAY
		fromAddress: (self isByRef ifTrue: [self refAddress dwordAtOffset: 0] ifFalse: [self ulVal])
		vt: self vartype
		owner: self!

array: newValue
	"Set the <SAFEARRAY>, newValue, into the receiver."

	self vt: newValue vt.
	self ulVal: newValue detach!

arrayRef: newValue
	"Store a reference to the <SAFEARRAY> representation of the argument, newValue, 
	into the receiver, i.e. the receiver will be of type VT_xx|VT_ARRAY|VT_BYREF."

	data := newValue asSAFEARRAY.
	self vt: data vt | VT_BYREF.
	self ulVal: data bytes basicYourAddress!

asString
	"Answer the receiver coerced to a String (if possible)."

	^self vt == VT_BSTR 
		ifTrue: [self bstr]
		ifFalse: [(self changeType: VT_BSTR) bstr]!

asVariant
	"Answer the VARIANT representation of the receiver."

	^self!

badVarType
	^HRESULTError signalWith: DISP_E_BADVARTYPE!

basicFree
	"Private - Free external resources owned by the receiver."

	super basicFree.
	data := nil.
!

bstr
	"Answer the <String> value from the receiver.
	Assumes the receiver is of type VT_BSTR."

	| addr |
	addr := self ulVal.
	^self isByRef
		ifTrue: 
			["See class example1 for more info on by-ref BSTRs"
			LPBSTR fromAddress: addr]
		ifFalse: 
			["Get down to bare metal for speed"
			addr == 0
				ifTrue: 
					["By convention a null BSTR represents the empty string"
					'']
				ifFalse: [Utf16String fromAddress: addr length: (OLEAutLibrary default sysStringLen: addr)]]!

bstr: aString
	"Set the BSTR value of the receiver to the <String> argument, newValue.
	Implementation Note: If #asBSTR does not create a new BSTR then
	we must copy the <BSTR> argument to avoid having a side effect
	on the argument."

	| bstr |
	(bstr := aString asBSTR) == aString ifTrue: [bstr := bstr copy].
	self ulVal: bstr detach.
	self vt: VT_BSTR!

byte
	"Answer the unsigned 8-bit <integer> value from the receiver.
	N.B. Assumes that the receiver is of type VT_I1."

	^self isByRef 
		ifTrue: [BYTE fromAddress: self refAddress]
		ifFalse: [bytes byteAtOffset: 8]!

byte: newValue
	"Set the unsigned 8-bit integer value of the receiver
	and tag as type VT_UI1"

	bytes byteAtOffset: 8 put: newValue asInteger.
	self vt: VT_UI1.!

changeType: newVT
	"Answer a <VARIANT> containing the receiver's value coerced
	to a new type as specified by the argument, newVT, an <integer> 
	member of the VARTYPE enumeration. If the coercion is not possible,
	then raise an HRESULTError."

	| answer |
	newVT == self vt ifTrue: [^self].	"Already requested type"
	answer := self class new.
	OLEAutLibrary default
		variantChangeType: answer
		pvarSrc: self
		wFlags: 0
		vt: newVT.
	^answer!

changeType: newVT locale: aLocale
	"Answer a <VARIANT> containing the receiver's value coerced to a new type as specified by the argument, newVT, an <integer> member of the VARTYPE enumeration. The conversion is that appropriate for the specified target <Locale>.
	If the coercion is not possible, then raise an HRESULTError."

	| answer |
	newVT == self vt ifTrue: [^self].	"Already requested type"
	answer := self class new.
	OLEAutLibrary default
		variantChangeTypeEx: answer
		pvarSrc: self
		lcid: aLocale lcid
		wFlags: VARIANT_LOCALBOOL
		vt: newVT.
	^answer!

char
	"Answer the ANSI (8-bit) character from the receiver.
	N.B. Assumes that the receiver is of type VT_UI1."

	^Character value: self byte

	!

cmp: comperand
	"Private - Answer a comparison value indicating the relationship
	between the receiver and the VARIANT, comperand."

	| cmp varRight |
	varRight := comperand asVariant.
	cmp := OLEAutLibrary default
				varCmp: self
				pvarRight: varRight
				lcid: NlsConstants.LOCALE_USER_DEFAULT
				dwFlags: 0.
	^(cmp == 3 and: [self vt == varRight vt])
		ifTrue: 
			["Both null, therefore equal"
			0]
		ifFalse: [cmp - 1]	"VARCMP_NULL"!

copy
	"Answer a <VARIANT> which is a copy of the receiver.
	Implementation Note: This is a deep copy of the receiver, unless it is a reference in 
	which case the copy is still a reference. #deepCopy answers a true deep copy even
	in that case."

	| copy |
	copy := VARIANT new.
	OLEAutLibrary default variantCopy: copy pvargSrc: self.
	^copy!

cy
	"Answer a Variant Currency value from the receiver.
	N.B. Assumes that the receiver is of type VT_CY.
	The VT_CY format is a 64-bit fractional value
	scaled by 10000 to give 4 decimal places. It provides
	limited scaled decimal capabilities for simple scripting
	languages such as VB."

	^self isByRef 
		ifTrue: [CURRENCY fromAddress: self refAddress]
		ifFalse: [((bytes sqwordAtOffset: 8)/10000) asScaledDecimal: 4]!

cy: newValue
	"Set the Variant Currency (VT_CY) value of the receiver to the
	argument, newValue."

	bytes sqwordAtOffset: 8 put: (newValue * 10000) asInteger.
	self vt: VT_CY.!

date
	"Answer a <DATE> corresponding to the Variant Date from the receiver.
	Assumes the receiver is of type VT_DATE."

	^self isByRef
		ifTrue: [DATE fromAddress: self refAddress]
		ifFalse: [DATE new value: self dblVal]

"
VARIANT new date: 1.23
"!

date: newValue
	"Set the DATE value, newValue, into the receiver."

	bytes doubleAtOffset: 8 put: newValue.
	self vt: VT_DATE!

dblVal
	"Answer the <Float> value of the receiver's 'dblVal' field."

	^bytes doubleAtOffset: _OffsetOf_dblVal!

dblVal: aFloat
	"Set the receiver's 'dblVal' field to the value of the argument, aFloat"

	bytes doubleAtOffset: _OffsetOf_dblVal put: aFloat!

decimal
	"Answer a <ScaledDecimal> which is the Variant Decimal value 
	from the receiver.
	N.B. Assumes that the receiver is of type VT_DECIMAL.
	The VT_DECIMAL format is a rather complex 16-byte
	fixed point value with 12-bytes to represent the absolute
	value, and a byte each for scale and sign, with the top
	two bytes unused."

	^self isByRef
		ifTrue: [^DECIMAL fromAddress: self refAddress]
		ifFalse: 
			[| sign scale hi32 lo64 |
			#todo.	"Use DECIMAL to do this"
			scale := bytes byteAtOffset: 2.
			sign := (bytes byteAtOffset: 3) == 0 ifTrue: [1] ifFalse: [-1].
			hi32 := bytes dwordAtOffset: 4.
			lo64 := bytes qwordAtOffset: 8.
			((hi32 bitShift: 64) + lo64) * sign / scale exp10 asScaledDecimal: scale]!

decimal: val
	"Set the Variant Decimal value of the receiver to the
	<ScaledDecimal> argument, val. The argument must
	be a <ScaledDecimal> rather than another type of <Number>
	since the scale must be known."

	| scale intVal |
	scale := val scale.
	bytes byteAtOffset: 2 put: scale.
	intVal := val * scale exp10.
	val positive
		ifTrue: [bytes byteAtOffset: 3 put: 0]
		ifFalse: 
			[bytes byteAtOffset: 3 put: 128.
			intVal := intVal negated].
	intVal := intVal asInteger.
	bytes dwordAtOffset: 4 put: (intVal bitShift: -64).
	bytes qwordAtOffset: 8 put: (intVal bitAnd: 16rFFFFFFFFFFFFFFFF).
	self vt: VT_DECIMAL!

detach
	"Detach the receiver from the underlying VARIANT (useful for passing
	ownership)."

	| var |
	var := bytes.
	bytes := nil.
	self beUnfinalizable.
	^var!

dispatch
	"Answer an IDispatch pointer from the receiver, or nil if empty. 
	Assumes that the receiver is of type VT_DISPATCH.
	Note that if the receiver is a by-reference variant then the answer
	is an untyped doubly-indirected pointer (i.e. its value is the address
	of the IDispatch pointer). If the reference is overwritten then the old
	interface pointer must be Release()d."

	^(self isByRef 
		ifTrue: [LPVOID]
		ifFalse: [IDispatch]) fromAddress: self ulVal!

dispatch: newValue
	"Set the IDispatch pointer, newValue, into the receiver."

	newValue _addRef.
	self vt: VT_DISPATCH.
	self ulVal: newValue yourAddress.!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	self isArray
		ifTrue: 
			[| array |
			array := self array.
			array displayOn: aPuttableStream.
			array free]
		ifFalse: 
			[| asBstr |
			asBstr := self changeType: VT_BSTR locale: aPuttableStream locale.
			aPuttableStream nextPutAll: asBstr value.
			asBstr == self ifFalse: [asBstr free]]!

double
	"Answer the double precision floating point value from the receiver.
	Assumes the receiver is of type VT_R8 (or VT_DATE)."

	^self isByRef 
		ifTrue: [DOUBLE fromAddress: self refAddress]
		ifFalse: [self dblVal]!

double: newValue
	"Set the double-precision floating point value of the receiver to the
	<Float>, newValue."

	self dblVal: newValue.
	self vt: VT_R8.!

dword
	"Answer the unsigned 32-bit <integer> value from the receiver.
	Assumes the receiver is of type VT_UI4 (or at least of some unsigned
	32-bit integer type)."

	^self isByRef 
		ifTrue: [DWORD fromAddress: self refAddress]
		ifFalse: [bytes dwordAtOffset: 8]!

dword: newValue
	"Set the unsigned 32-bit integer value of the receiver
	to the <integer>, newValue."

	self ulVal: newValue asInteger.
	self vt: VT_UI4!

float
	"Answer the single precision floating point value from the receiver.
	Assumes the receiver is of type VT_R4."

	^self isByRef 
		ifTrue: [FLOAT fromAddress: self refAddress]
		ifFalse: [bytes floatAtOffset: 8]!

float: newValue
	"Set the single precision floating point value of the receiver to the
	<Float>, newValue."

	bytes floatAtOffset: 8 put: newValue.
	self vt: VT_R4.!

hresult
	"Answer the status code (SCODE) from the receiver.
	N.B. Assumes that the receiver is of type VT_ERROR."

	^self isByRef 
		ifTrue: [HRESULT fromAddress: self refAddress]
		ifFalse: [HRESULT fromInteger: self lVal]

	!

hresult: newValue
	"Set the ERROR value, newValue, into the receiver."

	bytes sdwordAtOffset: 8 put: newValue asInteger.
	self vt: VT_ERROR.!

initialize
	"Private - Initialize the receiver.
	Note that this does not null out the data area of the variant, it just sets
	the type to VT_EMPTY."

	super initialize.
	self class init: bytes!

intPtr: newValue 
	"Set the signed integer value of the receiver."

	newValue isSDWORD ifTrue: [self sdword: newValue] ifFalse: [self qword: newValue]!

isArray
	"Answer whether the receiver points at a SAFEARRAY."

	^self vt allMask: VT_ARRAY!

isByRef
	"Private - Answer whether the receiver is a by-reference parameter."

	^self vt allMask: VT_BYREF!

isDispatch
	"Answer whether the receiver wraps an <IDispatch> interface on a COM object."

	^self vt == VT_DISPATCH
!

isEmpty
	^self vt == VT_EMPTY!

isObject
	"Answer whether the receiver wraps a COM object."

	| vt |
	vt := self vt.
	^vt == VT_UNKNOWN or: [vt == VT_DISPATCH]
!

lpvoid
	"Answer an <ExternalAddress> corresponding to the VT_PTR value of the receiver."

	^self refAddress!

lVal
	"Private - Answer the 32-bit unsigned integer value from the receiver."

	^bytes sdwordAtOffset: 8!

nil
	"Answer the nil value.
	N.B. Assumes that the receiver is of type VT_EMPTY."

	^nil!

nil: newValue
	"Clear the receiver."

	self ulVal: 0.
	self vt: VT_EMPTY!

null
	"Answer the null value.
	N.B. Assumes that the receiver is of type VT_NULL."

	^nil!

null: newValue
	"Null the receiver."

	self ulVal: 0.
	self vt: VT_NULL!

qword
	"Answer the unsigned 64-bit integer value from the receiver.
	Assumes the receiver is of type VT_I8 (note that this is
	not currently a generally supported variant type but
	we implement for completeness)."

	^self isByRef 
		ifTrue: [ULARGE_INTEGER fromAddress: self refAddress]
		ifFalse: [bytes qwordAtOffset: 8]!

qword: aLargeInteger 
	bytes qwordAtOffset: 8 put: aLargeInteger asInteger.
	self vt: VT_UI8!

recordInfo
	"Private - Answer the <IRecordInfo> stored in the receiver.
	Assumes the receiver is of type VT_RECORD."

	^IRecordInfo fromAddress: (bytes intPtrAtOffset: 12)!

refAddress
	"Private - Answer the reference address from the receiver (assumes receiver is a VT_BYREF)."

	^Address fromInteger: self ulVal!

reference: anObject
	"Private - Set the receiver up to be a reference to the specified object (assumes
	receiver is a VT_BYREF)."

	data := anObject.
	^self ulVal: anObject yourAddress!

sbyte
	"Answer the signed 8-bit <integer> value from the receiver.
	N.B. Assumes that the receiver is of type VT_I1."

	^self isByRef 
		ifTrue: [SBYTE fromAddress: self refAddress]
		ifFalse: [bytes sbyteAtOffset: 8]!

sbyte: newValue
	"Set the VT_I1 value, newValue, into the receiver."

	| intVal |
	intVal := newValue asInteger.
	(newValue < -128 or: [newValue > 127]) ifTrue: [self errorSubscriptBounds: intVal].
	bytes sbyteAtOffset: 8 put: newValue asInteger.
	self vt: VT_I1.!

sdword
	"Answer the signed 32-bit integer value from the receiver.
	Assumes the receiver is of type VT_I4."

	^self isByRef 
		ifTrue: [SDWORD fromAddress: self refAddress]
		ifFalse: [self lVal]!

sdword: newValue
	"Set the signed 32-bit integer value from the receiver."

	bytes sdwordAtOffset: 8 put: newValue asInteger.
	self vt: VT_I4!

sqword
	"Answer the signed 64-bit integer value from the receiver.
	Assumes the receiver is of type VT_I8 (note that this is
	not currently a generally supported variant type but
	we implement for completeness)."

	^self isByRef 
		ifTrue: [LARGE_INTEGER fromAddress: self refAddress]
		ifFalse: [bytes sqwordAtOffset: 8]!

sqword: aLargeInteger 
	bytes sqwordAtOffset: 8 put: aLargeInteger asInteger.
	self vt: VT_I8!

struct
	"Answer the structure value from the receiver.
	Assumes the receiver is of type VT_RECORD."

	data isNil ifTrue: [data := Structure fromAddress: self ulVal recordInfo: self recordInfo owner: self].
	^data
!

struct: newValue
	"Private - Set the UDT value of the receiver to be the <ExternalStructure>, newValue.
	Note that what we actually do is to create a reference to the structure."

	| piRecInfo |
	piRecInfo := newValue recordInfo.
	piRecInfo addRef.
	bytes dwordAtOffset: 12 put: piRecInfo yourAddress.
	self reference: newValue.
	self vt: ##(VT_RECORD|VT_BYREF).
!

sword
	"Answer the signed 16-bit integer value from the receiver.
	Assumes the receiver is of type VT_I2."

	^self isByRef 
		ifTrue: [SWORD fromAddress: self refAddress]
		ifFalse: [bytes swordAtOffset: 8]!

sword: newValue
	"Set the signed 16-bit <integer> value, newValue, into the receiver."

	bytes swordAtOffset: 8 put: newValue asInteger.
	self vt: VT_I2!

systemTime
	"Answer a SYSTEMTIME converted from the receiver's OLE
	Automation date (an 8-byte floating point day number and fraction of a day).
	Assumes the receiver is of type VT_DATE."

	| systime |
	systime := SYSTEMTIME new.
	OLEAutLibrary default variantTimeToSystemTime: self double lpSystemTime: systime.
	^systime!

typeName
	"Answer the symbolic name of the receiver's basic variant type code 
	without modifiers such as VT_BYREF."

	^self class nameOfVT: self vartype!

ulVal
	"Private - Answer the 32-bit unsigned integer value from the receiver."

	^bytes dwordAtOffset: 8!

ulVal: ul
	"Private - Set the receiver's ulVal field to the 32-bit unsigned integer value, ul."

	bytes dwordAtOffset: 8 put: ul!

unknown
	"Answer the IUnknown pointer in the receiver.
	Assumes that the receiver is of type VT_UNKNOWN.
	Note that if the receiver is a by-reference variant then the answer
	is an untyped doubly-indirected pointer (i.e. its value is the address
	of the IDispatch pointer). If the reference is overwritten then the old
	interface pointer must be Release()d."

	^(self isByRef ifTrue: [LPVOID] ifFalse: [IUnknown]) fromAddress: self ulVal!

unknown: newValue
	"Set the <IUnknown> value, newValue, into the receiver."

	newValue _addRef.
	self ulVal: newValue yourAddress.
	self vt: VT_UNKNOWN.!

value
	"Answer a Smalltalk <Object> of a suitable type and of the same value (well as close as possible) to the receiver. If the receiver's type is not recognised, then raise a NotFoundError."
	"Implementation Note: The primitive will instantiate Smalltalk objects for types that are well known to the VM, anything else goes through the Smalltalk back up code."

	"Primitive Failure Codes:
		ClassNotRegistered	- The value would be of a class that is not registered with the VM, DATE for a VT_DATE, or IDispatch for a VT_DISPATCH.
		InvalidVariant		- The variant type (vt field) is not recognised.
		InvalidPointer		- The VARIANT object points at the actual VARIANT struct, but the address is null.
		AssertionFailure		- The VARIANT object is a malformed ExternalStructure."


	<primitive: 172>
	| vt |
	^((vt := self vt) allMask: VT_ARRAY)
		ifTrue: [self array]
		ifFalse: [self perform: (VTNames at: (vt bitAnd: VT_TYPEMASK) + 1)]!

value: newValue
	"Set the receiver's value to the <variantCompatible>, newValue."

	| varNew |
	varNew := newValue asVariant.
	varNew == newValue ifTrue: [varNew := varNew copy].
	"Although we may not own the underlying data if we are a reference (pointer) instance,
	 because we are going to overwrite it we must free it regardless. #basicFree can be
	 repeated add infinitum on a VARIANT."
	self basicFree.
	self copyBytes: varNew detach	

!

varbool
	"Answer a Boolean corresponding to the VARIANT_BOOL value 
	of the receiver (assumes the receiver is of type VT_BOOL)."

	^self isByRef 
		ifTrue: [VARIANT_BOOL fromAddress: self refAddress]
		ifFalse: [(bytes swordAtOffset: 8) ~~ VARIANT_FALSE]!

varbool: newValue
	"Set the VARIANT_BOOL value of the receiver to the <boolean> or <integer>,
	newValue."

	bytes swordAtOffset: 8 put: (newValue asParameter == 0 
							ifTrue: [VARIANT_FALSE] 
							ifFalse: [VARIANT_TRUE]).
	self vt: VT_BOOL!

variant
	"Answer a <VARIANT> at the address specified in the receiver.
	N.B. Assumes that the receiver is of type VT_VARIANT|VT_BYREF."

	self assert: [self isByRef].
	^VARIANT fromAddress: self ulVal!

variant: newValue
	"Set the <VARIANT> value, newValue, into the receiver."

	self reference: newValue.
	self vt: ##(VT_VARIANT|VT_BYREF)!

vartype
	"Answer the receiver's basic variant type code without modifies such as VT_BYREF."

	^self vt bitAnd: VT_TYPEMASK!

void
	"Answer the void value from the receiver, which is nil unless the receiver
	is VT_BYREF, in which case it is treated as a void* pointer.
	Assumes the receiver is of type VT_VOID."

	^self isByRef 
		ifTrue: [VOID fromAddress: self refAddress]!

vt
	"Answer the <Integer> value of the receiver's 'vt' field."

	^bytes wordAtOffset: _OffsetOf_vt!

vt: anInteger
	"Set the receiver's 'vt' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_vt put: anInteger!

word
	"Answer the unsigned 16-bit <integer> value from the receiver.
	Assumes the receiver is of type VT_UI2."

	^self isByRef 
		ifTrue: [WORD fromAddress: self refAddress]
		ifFalse: [bytes wordAtOffset: 8]!

word: newValue
	"Set the unsigned 16-bit integer value of the receiver
	to the <integer> newValue, and tag as type VT_UI2."

	bytes wordAtOffset: 8 put: newValue asInteger.
	self vt: VT_UI2! !
!OS.COM.VARIANT categoriesFor: #_deepCopy:!copying!private! !
!OS.COM.VARIANT categoriesFor: #<!comparing!public! !
!OS.COM.VARIANT categoriesFor: #<=!comparing!public! !
!OS.COM.VARIANT categoriesFor: #=!comparing!public! !
!OS.COM.VARIANT categoriesFor: #>!comparing!public! !
!OS.COM.VARIANT categoriesFor: #>=!comparing!public! !
!OS.COM.VARIANT categoriesFor: #array!accessing!public! !
!OS.COM.VARIANT categoriesFor: #array:!accessing!public! !
!OS.COM.VARIANT categoriesFor: #arrayRef:!accessing!public! !
!OS.COM.VARIANT categoriesFor: #asString!converting!public! !
!OS.COM.VARIANT categoriesFor: #asVariant!converting!public! !
!OS.COM.VARIANT categoriesFor: #badVarType!exceptions!private! !
!OS.COM.VARIANT categoriesFor: #basicFree!private!realizing/unrealizing! !
!OS.COM.VARIANT categoriesFor: #bstr!accessing!public! !
!OS.COM.VARIANT categoriesFor: #bstr:!accessing!public! !
!OS.COM.VARIANT categoriesFor: #byte!accessing!public! !
!OS.COM.VARIANT categoriesFor: #byte:!accessing!public! !
!OS.COM.VARIANT categoriesFor: #changeType:!converting!public! !
!OS.COM.VARIANT categoriesFor: #changeType:locale:!converting!public! !
!OS.COM.VARIANT categoriesFor: #char!accessing!public! !
!OS.COM.VARIANT categoriesFor: #cmp:!comparing!private! !
!OS.COM.VARIANT categoriesFor: #copy!copying!public! !
!OS.COM.VARIANT categoriesFor: #cy!accessing!public! !
!OS.COM.VARIANT categoriesFor: #cy:!accessing!public! !
!OS.COM.VARIANT categoriesFor: #date!accessing!public! !
!OS.COM.VARIANT categoriesFor: #date:!accessing!public! !
!OS.COM.VARIANT categoriesFor: #dblVal!**compiled accessors**!public! !
!OS.COM.VARIANT categoriesFor: #dblVal:!**compiled accessors**!public! !
!OS.COM.VARIANT categoriesFor: #decimal!accessing!public! !
!OS.COM.VARIANT categoriesFor: #decimal:!accessing!public! !
!OS.COM.VARIANT categoriesFor: #detach!public!realizing/unrealizing! !
!OS.COM.VARIANT categoriesFor: #dispatch!accessing!public! !
!OS.COM.VARIANT categoriesFor: #dispatch:!accessing!public! !
!OS.COM.VARIANT categoriesFor: #displayOn:!printing!public! !
!OS.COM.VARIANT categoriesFor: #double!accessing!public! !
!OS.COM.VARIANT categoriesFor: #double:!accessing!public! !
!OS.COM.VARIANT categoriesFor: #dword!accessing!public! !
!OS.COM.VARIANT categoriesFor: #dword:!accessing!public! !
!OS.COM.VARIANT categoriesFor: #float!accessing!public! !
!OS.COM.VARIANT categoriesFor: #float:!accessing!public! !
!OS.COM.VARIANT categoriesFor: #hresult!accessing!public! !
!OS.COM.VARIANT categoriesFor: #hresult:!accessing!public! !
!OS.COM.VARIANT categoriesFor: #initialize!initializing!private! !
!OS.COM.VARIANT categoriesFor: #intPtr:!accessing!public! !
!OS.COM.VARIANT categoriesFor: #isArray!public!testing! !
!OS.COM.VARIANT categoriesFor: #isByRef!private!testing! !
!OS.COM.VARIANT categoriesFor: #isDispatch!public!testing! !
!OS.COM.VARIANT categoriesFor: #isEmpty!public!testing! !
!OS.COM.VARIANT categoriesFor: #isObject!public!testing! !
!OS.COM.VARIANT categoriesFor: #lpvoid!accessing!public! !
!OS.COM.VARIANT categoriesFor: #lVal!accessing!private! !
!OS.COM.VARIANT categoriesFor: #nil!accessing!public! !
!OS.COM.VARIANT categoriesFor: #nil:!accessing!public! !
!OS.COM.VARIANT categoriesFor: #null!accessing!public! !
!OS.COM.VARIANT categoriesFor: #null:!accessing!public! !
!OS.COM.VARIANT categoriesFor: #qword!accessing!public! !
!OS.COM.VARIANT categoriesFor: #qword:!accessing!public! !
!OS.COM.VARIANT categoriesFor: #recordInfo!accessing!private! !
!OS.COM.VARIANT categoriesFor: #refAddress!accessing!private! !
!OS.COM.VARIANT categoriesFor: #reference:!accessing!private! !
!OS.COM.VARIANT categoriesFor: #sbyte!accessing!public! !
!OS.COM.VARIANT categoriesFor: #sbyte:!accessing!public! !
!OS.COM.VARIANT categoriesFor: #sdword!accessing!public! !
!OS.COM.VARIANT categoriesFor: #sdword:!accessing!public! !
!OS.COM.VARIANT categoriesFor: #sqword!accessing!public! !
!OS.COM.VARIANT categoriesFor: #sqword:!accessing!public! !
!OS.COM.VARIANT categoriesFor: #struct!accessing!public! !
!OS.COM.VARIANT categoriesFor: #struct:!accessing!public! !
!OS.COM.VARIANT categoriesFor: #sword!accessing!public! !
!OS.COM.VARIANT categoriesFor: #sword:!accessing!public! !
!OS.COM.VARIANT categoriesFor: #systemTime!accessing!public! !
!OS.COM.VARIANT categoriesFor: #typeName!accessing!public! !
!OS.COM.VARIANT categoriesFor: #ulVal!accessing!private! !
!OS.COM.VARIANT categoriesFor: #ulVal:!accessing!private! !
!OS.COM.VARIANT categoriesFor: #unknown!accessing!public! !
!OS.COM.VARIANT categoriesFor: #unknown:!accessing!public! !
!OS.COM.VARIANT categoriesFor: #value!accessing!public! !
!OS.COM.VARIANT categoriesFor: #value:!accessing!public! !
!OS.COM.VARIANT categoriesFor: #varbool!accessing!public! !
!OS.COM.VARIANT categoriesFor: #varbool:!accessing!public! !
!OS.COM.VARIANT categoriesFor: #variant!accessing!public! !
!OS.COM.VARIANT categoriesFor: #variant:!accessing!public! !
!OS.COM.VARIANT categoriesFor: #vartype!accessing!public! !
!OS.COM.VARIANT categoriesFor: #void!accessing!public! !
!OS.COM.VARIANT categoriesFor: #vt!**compiled accessors**!public! !
!OS.COM.VARIANT categoriesFor: #vt:!**compiled accessors**!public! !
!OS.COM.VARIANT categoriesFor: #word!accessing!public! !
!OS.COM.VARIANT categoriesFor: #word:!accessing!public! !

OS.COM.VARIANT methodProtocol: #variantCompatible attributes: #(#readOnly) selectors: #(#asVariant)!

!OS.COM.VARIANT class methodsFor!

classForVT: anInteger
	"Answer a class of object suitable for representing values of the specified Variant type (i.e. a value from the VT_XXX enumeration which describes a scalar type)."

	^(VTClasses at: anInteger + 1)
		ifNil: [self error: 'Unmapped var type ' , anInteger printString]
		ifNotNil: [:bindingRef | bindingRef value]!

clear: addressOrBytes
	"Free an instance of the structure which instances of the receiver wrap
	which resides at the specified address."

	OLEAutLibrary default variantClear: addressOrBytes!

defineFields
	"Define the fields of the VARIANT structure.
	As this is a large and complex union, we define only the 16-bit type type, and a DWORD field
	to simplify the common case of accessing the first 32-bits of data stored in a VARIANT.

		VARIANT compileDefinition.

		struct  tagVARIANT
		{
			union 
			{
				struct  __tagVARIANT
				{
					VARTYPE vt;
					WORD wReserved1;
					WORD wReserved2;
					WORD wReserved3;
					union 
					{
						LONG lVal;
						BYTE bVal;
						SHORT iVal;
						FLOAT fltVal;
						DOUBLE dblVal;
						VARIANT_BOOL boolVal;
						_VARIANT_BOOL bool;
						SCODE scode;
						CY cyVal;
						DATE date;
						BSTR bstrVal;
						IUnknown __RPC_FAR *punkVal;
						IDispatch __RPC_FAR *pdispVal;
						SAFEARRAY __RPC_FAR *parray;
						BYTE __RPC_FAR *pbVal;
						SHORT __RPC_FAR *piVal;
						LONG __RPC_FAR *plVal;
						FLOAT __RPC_FAR *pfltVal;
						DOUBLE __RPC_FAR *pdblVal;
						VARIANT_BOOL __RPC_FAR *pboolVal;
						_VARIANT_BOOL __RPC_FAR *pbool;
						SCODE __RPC_FAR *pscode;
						CY __RPC_FAR *pcyVal;
						DATE __RPC_FAR *pdate;
						BSTR __RPC_FAR *pbstrVal;
						IUnknown __RPC_FAR *__RPC_FAR *ppunkVal;
						IDispatch __RPC_FAR *__RPC_FAR *ppdispVal;
						SAFEARRAY __RPC_FAR *__RPC_FAR *pparray;
						VARIANT __RPC_FAR *pvarVal;
						PVOID byref;
						CHAR cVal;
						USHORT uiVal;
						ULONG ulVal;
						INT intVal;
						UINT uintVal;
						DECIMAL __RPC_FAR *pdecVal;
						CHAR __RPC_FAR *pcVal;
						USHORT __RPC_FAR *puiVal;
						ULONG __RPC_FAR *pulVal;
						INT __RPC_FAR *pintVal;
						UINT __RPC_FAR *puintVal;
					}	__VARIANT_NAME_3;
				}	__VARIANT_NAME_2;
				DECIMAL decVal;
			}	__VARIANT_NAME_1;
		};"

	self
		defineField: #vt			type: WORDField new;	"VARTYPE = unsigned short"
		defineField: #wReserved1	type: WORDField filler;
		defineField: #wReserved2	type: WORDField filler;
		defineField: #wReserved3	type: WORDField filler;
		"We must use a double field as the declared union member in order to get the alignment right, i.e. 8"
		defineField: #dblVal		type: DOUBLEField new
		!

externalTypeNames
	^#(#{BYTE} #{SBYTE} #{WORD} #{SWORD} #{FLOAT} #{DOUBLE} #{DWORD} #{SDWORD} #{LARGE_INTEGER} #{ULARGE_INTEGER})!

fromBoolean: bool
	"Answer a new instance of the receiver of type VT_BOOL containing
	the VARIANT_BOOL equivalent of the <Boolean> value, bool."

	^self new
		varbool: bool;
		yourself
		!

fromCollection: objects 
	"Answer a new instance of the receiver of type VT_ARRAY|VT_XX containing
	the <VARIANT> representations of the elements of the <collection>, objects."

	^(self new)
		array: objects asSAFEARRAY;
		yourself!

fromDATE: aDATE
	"Answer a new instance of the receiver of type VT_DATE containing
	the <DATE> equivalent of the argument."

	^self new
		date: aDATE;
		yourself
		!

fromDispatch: piDisp
	"Answer a new instance of the receiver of type VT_DISPATCH containing
	the <IDispatch> pointer, piDisp."

	^self new
		dispatch: piDisp;
		yourself
		!

fromFloat: aFloat 
	"Answer a new instance of the receiver of type VT_DOUBLE containing
	the <Float> value, fValue."

	^(self new)
		double: aFloat;
		yourself!

fromInteger: anInteger 
	"Answer a new instance of the receiver holding the specified <integer> value. The VT
	will be VT_I4 if the integer is in the 32-bit 2's complemente range, or a VT_I8 for
	the 64-bit 2's complement range, or VT_UI8 for 64-bit positive numbers that are
	greater than 2^63-1. It is an error if the argument is too large to be represented in 
	64 bits."

	^anInteger asInteger asVariant!

fromLargeInteger: aLargeInteger 
	"Answer a new instance of the receiver holding the specified <LargeInteger> value.
	 The VT will be VT_I8 for the 64-bit 2's complement range, or VT_UI8 for 64-bit positive 
	numbers that are greater than 2^63-1. It is an error if the argument is too large to be 
	represented in 64 bits."

	| answer words |
	answer := self new.
	words := aLargeInteger limbSize.
	words <= 1 
		ifTrue: [answer sdword: aLargeInteger]
		ifFalse: 
			[words > 2 
				ifTrue: 
					["Might error if too large (or negative)"
					answer qword: aLargeInteger]
				ifFalse: [answer sqword: aLargeInteger]].
	^answer!

fromSmallInteger: aSmallInteger 
	"Answer a new VT_I4/VT_I8 instance of the receiver holding the specified <SmallInteger> value.
	It is an error if the argument is too large to be represented in 32/64 bits."

	^(self new)
		sdword: aSmallInteger;
		yourself!

fromString: aString
	"Answer a new BSTR instance of the receiver pointing at a copy of the 
	<readableString> argument."

	^self new 
		bstr: aString;
		yourself!

fromUnknown: piUnk
	"Answer a new instance of the receiver of type VT_UNKNOWN containing
	the <IUnknown> pointer, piUnk."

	^self new
		unknown: piUnk;
		yourself
		!

getFieldNames
	^#(#vt #dblVal)!

init: buffer
	"Initialize a buffer (or buffer at the specified address) to hold an instance of the record type
	described by the receiver. Assumes that the memory is completely uninitialized."

	OLEAutLibrary default variantInit: buffer!

initialize
	"Private - Initialize the receiver's class variables.
		VARIANT initialize
	"

	| vm |
	Unspecified := self new
				hresult: DISP_E_PARAMNOTFOUND;
				beUnfinalizable;
				yourself.
	self
		initializeVTNames;
		initializeVTClasses.
	vm := VMLibrary default.
	self externalTypeNames do: [:each | vm registryAt: each asSymbol put: each value].
	vm registryAt: self name put: self!

initializeVTClasses
	"Private - Initialize the map of VARENUM type codes to suitable buffer classes.
		VARIANT initializeVTClasses
	N.B. Not all VT_XXX members of the VARENUM enumeration are valid as types in a VARIANT
	used for Automation purposes (see wtypes.h) so a number have no mapping."

	| vtClasses |
	vtClasses := (Array new: VT_CLSID + 1)
		"at: VT_BLOB+1			put: #{ByteArray};		Blob - OLE Property sets only"
		"at: VT_BLOB_OBJECT+1	put: #{ByteArray};		Blob containing an object - OLE Property sets only"
		at: VT_BOOL+1			put: #{VARIANT_BOOL};	"Automation (Basic) boolean"
		at: VT_BSTR+1			put: #{BSTR};			"Automation (Basic) String"
		at: VT_CARRAY+1		put: #{External.Array};	"C-style array - TYPEDESC only"
		at: VT_CF+1			put: #{DWORD};		"Clipboard format - OLE Property sets only"
		at: VT_CLSID+1			put: #{CLSID};		"Class ID - OLE Property sets only"
		at: VT_CY+1			put: #{CURRENCY};	"Automation Currency - 64-bit fixed point, 4 decimal places"
		at: VT_DATE+1			put: #{DATE};			"Automation (double) date"
		at: VT_DECIMAL+1		put: #{DECIMAL};		"16-byte fixed point"
		at: VT_DISPATCH+1		put: #{IDispatch};		"IDispatch pointer"
		at: VT_EMPTY+1		put: #{UndefinedObject};"nil (in ST) or Nothing (in VB)"
		at: VT_ERROR+1		put: #{HRESULT};		"Status code (SCODE)"
		at: VT_FILETIME+1		put: #{FILETIME};		"FILETIME - OLE Property sets only"
		at: VT_I1+1			put: #{SBYTE};		"Signed 8-bit integer"
		at: VT_I2+1			put: #{SWORD};		"16-bit signed integer"
		at: VT_I4+1			put: #{SDWORD};		"32-bit signed integer"
		at: VT_I8+1			put: #{LARGE_INTEGER};	"64-bit signed integer - supported type on WinXP"
		at: VT_INT+1			put: #{SDWORD};		"signed machine dependent integer - TYPEDESC only"
		at: VT_LPSTR+1			put: #{AnsiString};		"Null-terminated ANSI string - OLE Property Sets and TYPEDESC only"
		at: VT_LPWSTR+1		put: #{Utf16String};	"Null-terminated UTF16 string - OLE Property Sets and TYPEDESC only"
		"at: VT_NULL+1			put: #{UndefinedObject};	""SQL Null (i.e. nil)"
		at: VT_PTR+1			put: #{Address};	"Pointer type - TYPEDESC only"
		at: VT_R4+1			put: #{FLOAT};		"Single precision floating point"
		at: VT_R8+1			put: #{DOUBLE};		"Double precision floating point"
		at: VT_SAFEARRAY+1		put: #{SAFEARRAY};	"As VT_ARRAY, but TYPEDESC only"
		"at: VT_STORAGE+1		put: #{IStorage};		Name of storage - OLE Property Sets only"
		"at: VT_STORED_OBJECT+1	put: #{IStorage};		Storage containing object - OLE Property Sets only"
		"at: VT_STREAM+1			put: #{IStream};	Name of storage - OLE Property Sets only"
		"at: VT_STREAMED_OBJECT+1	put: #{IStream};	Stream containing object - OLE Property Sets only"
		at: VT_UINT+1			put: #{DWORD};		"unsigned machine dependent integer - TYPEDESC only"
		at: VT_UI1+1			put: #{BYTE};			"8-bit unsigned integer (byte)"
		at: VT_UI2+1			put: #{WORD};		"16-bit unsigned integer (word)"
		at: VT_UI4+1			put: #{DWORD};		"32-bit unsigned integer (qword)"
		at: VT_UI8+1			put: #{ULARGE_INTEGER};"64-bit unsigned integer - OLE Prop Sets, TYPEDESC only"
		at: VT_UNKNOWN+1		put: #{IUnknown};		"IUnknown pointer"
		at: VT_USERDEFINED+1	put: #{Record};		"user defined type, a typedef in face - TYPEDESC only"
		at: VT_RECORD+1		put: #{Structure};
		at: VT_VARIANT+1		put: #{VARIANT};		"Reference to another VARIANT"
		"at: VT_VECTOR+1		put: #{External.Array};	Simple counted array - OLE property sets only"
		at: VT_VOID+1			put: #{VOID};			"C void - TYPEDESC only, for generic pointer outputs"
		at: VT_HRESULT+1		put: #{HRESULT}; 		"HRESULT return code - TYPEDESC only"
		yourself.
	self addClassConstant: 'VTClasses' value: vtClasses!

initializeVTNames
	"Private - Initialize the map of VARENUM type codes ot symbolic type names.
		VARIANT initializeVTNames
	N.B. Not all VT_XXX members of the VARENUM enumeration are valid as types in a VARIANT
	used for Automation purposes (see wtypes.h) so a number are currently not supported for
	accessing as objects by Dolphin."

	| vtNames |
	vtNames := Array new: VT_CLSID+1 withAll: #badVarType.
	vtNames
		at: VT_BLOB+1			put: #blob;			"Blob - OLE Property sets only"
		at: VT_BLOB_OBJECT+1	put: #blob_object;"Blob containing an object - OLE Property sets only"
		at: VT_BOOL+1			put: #varbool;			"VARIANT_BOOL - i.e. True=-1, False=0"
		at: VT_BSTR+1			put: #bstr;			"Automation (Basic) String"
		at: VT_CARRAY+1		put: #carray;		"C-style array - TYPEDESC only"
		at: VT_CF+1			put: #cf;				"Clipboard format - OLE Property sets only"
		at: VT_CLSID+1			put: #clsid;			"Class ID - OLE Property sets only"
		at: VT_CY+1			put: #cy;				"Automation Currency"
		at: VT_DATE+1			put: #date;			"Automation (double) date"
		at: VT_DECIMAL+1		put: #decimal;	"16-byte fixed point - not implemented"
		at: VT_DISPATCH+1		put: #dispatch;	"IDispatch pointer"
		at: VT_EMPTY+1			put: #nil;				"nil (in ST) or Nothing (in VB)"
		at: VT_ERROR+1			put: #hresult;		"Status code (SCODE)"
		at: VT_FILETIME+1		put: #filetime;		"FILETIME - OLE Property sets only"
		at: VT_HRESULT+1		put: #hresult;		"HRESULT return code - TYPEDESC only"
		at: VT_I1+1				put: #sbyte;			"Signed 8-bit integer"
		at: VT_I2+1				put: #sword;		"16-bit signed integer"
		at: VT_I4+1				put: #sdword;		"32-bit signed integer"
		at: VT_I8+1				put: #sqword;		"64-bit signed integer - OLE Property Sets and TYPEDESC only"
		at: VT_INT+1			put: #sdword;		"signed machine dependent integer - TYPEDESC only"
		at: VT_LPSTR+1			put: #lpstr;			"Null-terminated ANSI string - OLE Property Sets and TYPEDESC only"
		at: VT_LPWSTR+1		put: #lpwstr;		"Null-terminated Unicode string - OLE Property Sets and TYPEDESC only"
		at: VT_NULL+1			put: #null;				"SQL Null (i.e. nil)"
		at: VT_PTR+1			put: #lpvoid;		"Pointer type - TYPEDESC only"
		at: VT_R4+1			put: #float;			"Single precision floating point"
		at: VT_R8+1			put: #double;		"Double precision floating point"
		at: VT_SAFEARRAY+1		put: #safearray;	"As VT_ARRAY, but TYPEDESC only"
		at: VT_STORAGE+1		put: #storage;		"Name of storage - OLE Property Sets only"
		at: VT_STORED_OBJECT+1	put: #stored_object;		"Storage containing object - OLE Property Sets only"
		at: VT_STREAM+1		put: #stream;		"Name of storage - OLE Property Sets only"
		at: VT_STREAMED_OBJECT+1	put: #streamed_object;	"Stream containing object - OLE Property Sets only"
		at: VT_UINT+1			put: #dword;		"unsigned machine dependent integer - TYPEDESC only"
		at: VT_UI1+1			put: #byte;			"8-bit unsigned integer (byte)"
		at: VT_UI2+1			put: #word;			"16-bit unsigned integer (word)"
		at: VT_UI4+1			put: #dword;		"32-bit unsigned integer (qword)"
		at: VT_UI8+1			put: #qword;		"64-bit unsigned integer - OLE Property Sets and TYPEDESC only"
		at: VT_UNKNOWN+1		put: #unknown;	"IUnknown pointer"
		at: VT_USERDEFINED+1	put: #typedef;		"user defined type - TYPEDESC only"
		at: VT_RECORD+1		put: #struct;
		at: VT_VARIANT+1		put: #variant;		"Reference to another VARIANT"
		at: VT_VOID+1			put: #void.			"C void - TYPEDESC only"
	self addClassConstant: 'VTNames' value: vtNames!

nameOfVT: vartype
	"Answer the symbolic name of the specified variant type code."

	| vtName |
	vtName := VTNames at: vartype + 1.
	^vtName == #badVarType ifTrue: [VTNames errorNotFound: vartype] ifFalse: [vtName]!

null
	"Answer a null (VT_NULL) instance of the receiver. This is not the same
	as a nil, (VT_EMPTY) instance."

	^self new
		vt: VT_NULL;
		yourself!

typeName
	"Private - Answer the Dolphin external type name for the receiver.
	There is an appropriate built-in type which we can substitute."

	^#variant!

uninitialize
	"Private - Uninitialize the receiver prior to its removal from the image."

	| vm |
	Unspecified := nil.
	"The VM only needs a ref to certain classes to implement the VARIANT>>value primitive, so these can be
	 cleared out if this class is removed."
	vm := VMLibrary default.
	self externalTypeNames do: [:each | vm registryAt: each asSymbol put: nil].
	vm registryAt: self name put: nil!

unspecified
	"Answer an instance of the receiver appropriate to use as an unspecified optional argument."

	^Unspecified!

vt
	"Answer the VARTYPE (one of the VT_XXX constants) used to describe the receiver's 
	type when represented in a <VARIANT>."

	^VT_VARIANT! !
!OS.COM.VARIANT class categoriesFor: #classForVT:!enquiries!public! !
!OS.COM.VARIANT class categoriesFor: #clear:!public!realizing/unrealizing! !
!OS.COM.VARIANT class categoriesFor: #defineFields!public!template definition! !
!OS.COM.VARIANT class categoriesFor: #externalTypeNames!constants!private! !
!OS.COM.VARIANT class categoriesFor: #fromBoolean:!instance creation!public! !
!OS.COM.VARIANT class categoriesFor: #fromCollection:!instance creation!public! !
!OS.COM.VARIANT class categoriesFor: #fromDATE:!instance creation!public! !
!OS.COM.VARIANT class categoriesFor: #fromDispatch:!instance creation!public! !
!OS.COM.VARIANT class categoriesFor: #fromFloat:!instance creation!public! !
!OS.COM.VARIANT class categoriesFor: #fromInteger:!instance creation!public! !
!OS.COM.VARIANT class categoriesFor: #fromLargeInteger:!instance creation!public! !
!OS.COM.VARIANT class categoriesFor: #fromSmallInteger:!instance creation!public! !
!OS.COM.VARIANT class categoriesFor: #fromString:!instance creation!public! !
!OS.COM.VARIANT class categoriesFor: #fromUnknown:!instance creation!public! !
!OS.COM.VARIANT class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !
!OS.COM.VARIANT class categoriesFor: #init:!initializing!public! !
!OS.COM.VARIANT class categoriesFor: #initialize!development!initializing!private! !
!OS.COM.VARIANT class categoriesFor: #initializeVTClasses!initializing!must not strip!private! !
!OS.COM.VARIANT class categoriesFor: #initializeVTNames!initializing!must not strip!private! !
!OS.COM.VARIANT class categoriesFor: #nameOfVT:!enquiries!public! !
!OS.COM.VARIANT class categoriesFor: #null!instance creation!public! !
!OS.COM.VARIANT class categoriesFor: #typeName!constants!private! !
!OS.COM.VARIANT class categoriesFor: #uninitialize!class hierarchy-removing!private! !
!OS.COM.VARIANT class categoriesFor: #unspecified!instance creation!public! !
!OS.COM.VARIANT class categoriesFor: #vt!constants!public! !

