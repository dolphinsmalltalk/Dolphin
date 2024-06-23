"Filed out from Dolphin Smalltalk"!

External.FinalizableStructure
	subclass: #'OS.COM.VARIANT'
	instanceVariableNames: 'data'
	classVariableNames: 'Unspecified'
	imports: #(#{OS.Win32Constants} #{OS.COM.AutomationConstants} #{OS.COM.AutomationErrors})
	classInstanceVariableNames: ''
	classConstants: {
			'_OffsetOf_boolVal' -> 16r8.
			'_OffsetOf_bstrVal' -> 16r8.
			'_OffsetOf_bVal' -> 16r8.
			'_OffsetOf_byref' -> 16r8.
			'_OffsetOf_cVal' -> 16r8.
			'_OffsetOf_cyVal' -> 16r8.
			'_OffsetOf_date' -> 16r8.
			'_OffsetOf_dblVal' -> 16r8.
			'_OffsetOf_decVal' -> 16r0.
			'_OffsetOf_fltVal' -> 16r8.
			'_OffsetOf_intVal' -> 16r8.
			'_OffsetOf_iVal' -> 16r8.
			'_OffsetOf_llVal' -> 16r8.
			'_OffsetOf_lVal' -> 16r8.
			'_OffsetOf_parray' -> 16r8.
			'_OffsetOf_pboolVal' -> 16r8.
			'_OffsetOf_pbstrVal' -> 16r8.
			'_OffsetOf_pbVal' -> 16r8.
			'_OffsetOf_pcVal' -> 16r8.
			'_OffsetOf_pcyVal' -> 16r8.
			'_OffsetOf_pdate' -> 16r8.
			'_OffsetOf_pdblVal' -> 16r8.
			'_OffsetOf_pdecVal' -> 16r8.
			'_OffsetOf_pdispVal' -> 16r8.
			'_OffsetOf_pfltVal' -> 16r8.
			'_OffsetOf_pintVal' -> 16r8.
			'_OffsetOf_piVal' -> 16r8.
			'_OffsetOf_pllVal' -> 16r8.
			'_OffsetOf_plVal' -> 16r8.
			'_OffsetOf_pparray' -> 16r8.
			'_OffsetOf_ppdispVal' -> 16r8.
			'_OffsetOf_ppunkVal' -> 16r8.
			'_OffsetOf_pRecInfo' -> 16rC.
			'_OffsetOf_pscode' -> 16r8.
			'_OffsetOf_puintVal' -> 16r8.
			'_OffsetOf_puiVal' -> 16r8.
			'_OffsetOf_pullVal' -> 16r8.
			'_OffsetOf_pulVal' -> 16r8.
			'_OffsetOf_punkVal' -> 16r8.
			'_OffsetOf_pvarVal' -> 16r8.
			'_OffsetOf_pvRecord' -> 16r8.
			'_OffsetOf_scode' -> 16r8.
			'_OffsetOf_uintVal' -> 16r8.
			'_OffsetOf_uiVal' -> 16r8.
			'_OffsetOf_ullVal' -> 16r8.
			'_OffsetOf_ulVal' -> 16r8.
			'_OffsetOf_vt' -> 16r0.
			'_OffsetOf_wReserved1' -> 16r2.
			'_OffsetOf_wReserved2' -> 16r4.
			'_OffsetOf_wReserved3' -> 16r6.
			'_VARIANT_Size' -> 16r10.
			'VTClasses'
				-> #(#{Core.UndefinedObject} #{Core.UndefinedObject} #{External.Int16} #{External.Int32} #{External.FLOAT} #{External.DOUBLE} #{OS.COM.CURRENCY} #{OS.COM.DATE} #{OS.COM.BSTR} #{OS.COM.IDispatch} #{OS.HRESULT} #{OS.COM.VARIANT_BOOL} #{OS.COM.VARIANT} #{OS.COM.IUnknown} #{OS.COM.DECIMAL} nil #{External.Int8} #{External.UInt8} #{External.UInt16} #{External.UInt32} #{External.Int64} #{External.UInt64} #{External.Int32} #{External.UInt32} #{External.VOID} #{OS.HRESULT} #{External.Address} #{OS.COM.SAFEARRAY} #{External.Array} #{OS.COM.Record} #{Core.AnsiString} #{Core.Utf16String} nil nil nil nil #{External.Structure} #{External.IntPtr} #{External.UIntPtr} nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil #{OS.FILETIME} #{Core.ByteArray} #{OS.COM.IStream} #{OS.COM.IStorage} #{OS.COM.IStream} #{OS.COM.IStorage} #{Core.ByteArray} #{External.UInt32} #{OS.COM.CLSID}).
			'VTNames'
				-> #(#nil #null #int16 #int32 #float #double #cy #date #bstr #dispatch #hresult #varbool #variant #unknown #decimal #badVarType #int8 #uint8 #uint16 #uint32 #int64 #uint64 #int32 #uint32 #void #hresult #lpvoid #safearray #carray #typedef #lpstr #lpwstr #badVarType #badVarType #badVarType #badVarType #struct #intptr #uintptr #badVarType #badVarType #badVarType #badVarType #badVarType #badVarType #badVarType #badVarType #badVarType #badVarType #badVarType #badVarType #badVarType #badVarType #badVarType #badVarType #badVarType #badVarType #badVarType #badVarType #badVarType #badVarType #badVarType #badVarType #badVarType #filetime #blob #stream #storage #streamed_object #stored_object #blob_object #cf #clsid)
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
	"Private - Answer a 'deep copy' of the receiver, cloning only those parts not already included in the IdentityDictionary argument, copiesDictionary.
	Implementation Note: We have no copiable instance variables, and so just create a new instance	and use an appropriate API call to copy the receiver into it."

	| copy |
	copy := VARIANT new.
	OleAut32 variantCopyInd: copy pvargSrc: self.
	^copy!

< aVARIANT
	"Answer whether the receiver is less than the <VARIANT> argument."

	^(self cmp: aVARIANT) < 0!

<= aVARIANT
	"Answer whether the receiver is less than or equal to the <VARIANT> argument."

	^(self cmp: aVARIANT) <= 0!

= anObject
	"Answer whether the receiver is equivalent to argument."

	^self == anObject or: [
		self species == anObject species and: [(self cmp: anObject) == 0]]!

> aVARIANT
	"Answer whether the receiver is greater than the <VARIANT> argument."

	^(self cmp: aVARIANT) > 0!

>= aVARIANT
	"Answer whether the receiver is greater than or equal to the <VARIANT> argument."

	^(self cmp: aVARIANT) >= 0!

array
	"Answer a <SAFEARRAY> from the receiver. Assumes that the receiver actually references an array."

	^SAFEARRAY
		fromAddress: (self isByRef
				ifTrue: [self refAddress uintPtrAtOffset: 0]
				ifFalse: [bytes uintPtrAtOffset: _OffsetOf_parray])
		vt: self vartype
		owner: self!

array: aSAFEARRAY
	"Detach the <SAFEARRAY> argument into the receiver."

	bytes
		uint16AtOffset: _OffsetOf_vt put: aSAFEARRAY vt;
		uintPtrAtOffset: _OffsetOf_parray put: aSAFEARRAY detach!

arrayRef: newValue
	"Store a reference to the <SAFEARRAY> representation of the argument, newValue, into the receiver, i.e. the receiver will be of type VT_xx|VT_ARRAY|VT_BYREF."

	data := newValue asSAFEARRAY.
	bytes
		uint16AtOffset: _OffsetOf_vt put: (data vt bitOr: VT_BYREF);
		uintPtrAtOffset: _OffsetOf_pparray put: data bytes basicYourAddress!

asString
	"Answer the receiver coerced to a String (if possible)."

	| varBstr string |
	self vt == VT_BSTR ifTrue: [^self value].
	varBstr := self changeType: VT_BSTR.
	string := varBstr value.
	"Avoid generating finalizable garbage"
	varBstr free.
	^string!

asVariant
	"Answer the <VARIANT> representation of the receiver."

	^self!

badVarType
	^HRESULTError signalWith: DISP_E_BADVARTYPE!

basicFree
	"Private - Free external resources owned by the receiver."

	super basicFree.
	data := nil.
!

bstr
	"Answer the <String> value from the receiver. Assumes the receiver is of type VT_BSTR."

	^self isByRef
		ifTrue: 
			["See class example1 for more info on by-ref BSTRs"
			LPBSTR fromAddress: (bytes uintPtrAtOffset: _OffsetOf_bstrVal)]
		ifFalse: 
			[| addr |
			addr := bytes uintPtrAtOffset: _OffsetOf_bstrVal.
			addr == 0
				ifTrue: 
					["By convention a null BSTR represents the empty string"
					'']
				ifFalse: 
					["Get down to bare metal for speed"
					Utf16String fromAddress: addr length: (OleAut32 sysStringLen: addr)]]!

bstr: aString
	"Set the BSTR value of the receiver to the <String> argument."

	"Implementation Note: If #asBSTR does not create a new BSTR then we must copy the <BSTR> argument to avoid having a side effect on the argument."

	| bstr |
	(bstr := aString asBSTR) == aString ifTrue: [bstr := bstr copy].
	bytes
		uintPtrAtOffset: _OffsetOf_bstrVal put: bstr detach;
		uint16AtOffset: _OffsetOf_vt put: VT_BSTR!

changeType: anInteger
	"Answer a <VARIANT> containing the receiver's value coerced to a new type as specified by the argument, an <integer> member of the VARTYPE enumeration. If the coercion is not possible, then raise an HRESULTError."

	^self changeType: anInteger locale: Locale.UserDefault!

changeType: anInteger locale: aLocale
	"Answer a <VARIANT> containing the receiver's value coerced to a new type as specified by the <integer> first argument, a member of the VARTYPE enumeration. The conversion is that appropriate for the specified target <Locale>. If the coercion is not possible, then raise an HRESULTError."

	| answer |
	anInteger == self vt ifTrue: [^self].	"Already requested type"
	answer := self class new.
	OleAut32
		variantChangeTypeEx: answer
		pvarSrc: self
		lcid: aLocale lcid
		wFlags: (aLocale noUserOverrides
				ifTrue: [##(VARIANT_NOUSEROVERRIDE | VARIANT_LOCALBOOL)]
				ifFalse: [VARIANT_LOCALBOOL])
		vt: anInteger.
	^answer!

char
	"Answer the ANSI (8-bit) character from the receiver.
	N.B. Assumes that the receiver is of type VT_UI1."

	^Character value: self uint8

	!

cmp: anObject
	"Private - Answer a comparison value indicating the relationship between the receiver and the <VARIANT> value of the argument."

	| cmp varRight |
	varRight := anObject asVariant.
	cmp := OleAut32
				varCmp: self
				pvarRight: varRight
				lcid: NlsConstants.LOCALE_USER_DEFAULT
				dwFlags: 0.
	^(cmp == VARCMP_NULL and: [self vt == varRight vt])
		ifTrue: 
			["Both null, therefore equal"
			0]
		ifFalse: [cmp - 1]!

copy
	"Answer a <VARIANT> which has the same vartype and value as the receiver."

	"Implementation Note: This is a deep copy of the receiver, unless it is a reference in  which case the copy is still a reference. #deepCopy answers a true deep copy even in that case."

	| copy |
	copy := VARIANT new.
	OleAut32 variantCopy: copy pvargSrc: self.
	^copy!

cy
	"Answer a Variant 'Currency' value from the receiver. N.B. Assumes that the receiver is of type VT_CY."

	"The VT_CY format is a 64-bit fractional value scaled by 10000 to give 4 decimal places. It provides limited scaled decimal capabilities for simple scripting languages such as VB."

	^self isByRef
		ifTrue: [CURRENCY fromAddress: self refAddress]
		ifFalse: [ScaledDecimal newFromNumber: (bytes int64AtOffset: _OffsetOf_cyVal) / 10000 scale: 4]!

cy: aNumber
	"Set the receiver's value to the closest possible Variant Currency (VT_CY) value to the <Number> argument."

	bytes
		int64AtOffset: _OffsetOf_cyVal put: (aNumber * 10000) asInteger;
		uint16AtOffset: _OffsetOf_vt put: VT_CY!

date
	"Answer a <DATE> corresponding to the Variant Date from the receiver. Assumes the receiver is of type VT_DATE."

	^self isByRef
		ifTrue: [DATE fromAddress: self refAddress]
		ifFalse: [DATE new value: (bytes doubleAtOffset: _OffsetOf_date)]!

date: aNumberOrDATE
	"Set the DATE value, newValue, into the receiver."

	bytes
		doubleAtOffset: _OffsetOf_date put: aNumberOrDATE asFloat;
		uint16AtOffset: _OffsetOf_vt put: VT_DATE!

decimal
	"Answer a <ScaledDecimal> which is the Variant DECIMAL value from the receiver. N.B. Assumes that the receiver is of type VT_DECIMAL."

	"The VT_DECIMAL format is a rather complex 16-byte fixed point value with 12-bytes to represent the absolute value, and a byte each for scale and sign, with the top two bytes unused because these overlap the vartype field of a VARIANT."

	^self isByRef
		ifTrue: [^DECIMAL fromAddress: self refAddress]
		ifFalse: 
			[| sign scale hi32 lo64 |
			scale := bytes uint8AtOffset: DECIMAL._OffsetOf_scale.
			sign := (bytes uint8AtOffset: DECIMAL._OffsetOf_sign) == 0 ifTrue: [1] ifFalse: [-1].
			hi32 := bytes uint32AtOffset: DECIMAL._OffsetOf_hi32.
			lo64 := bytes uint64AtOffset: DECIMAL._OffsetOf_lo64.
			ScaledDecimal newFromNumber: ((hi32 bitShift: 64) + lo64) * sign / scale exp10 scale: scale]!

decimal: aScaledDecimalOrInteger
	"Set the Variant Decimal value of the receiver to be as close as possible to the <ScaledDecimal> or <Integer> argument. The argument must be a <ScaledDecimal> or <Integer>, rather than another type of <Number>, since the scale must be known."

	| scale intVal |
	scale := aScaledDecimalOrInteger scale.
	bytes uint8AtOffset: DECIMAL._OffsetOf_scale put: scale.
	intVal := aScaledDecimalOrInteger * scale exp10.
	aScaledDecimalOrInteger positive
		ifTrue: [bytes uint8AtOffset: DECIMAL._OffsetOf_sign put: 0]
		ifFalse: 
			[bytes uint8AtOffset: DECIMAL._OffsetOf_sign put: 128.
			intVal := intVal negated].
	intVal := intVal asInteger.
	bytes uint32AtOffset: DECIMAL._OffsetOf_hi32 put: (intVal bitShift: -64).
	bytes uint64AtOffset: DECIMAL._OffsetOf_lo64 put: (intVal bitAnd: 16rFFFFFFFFFFFFFFFF).
	bytes uint16AtOffset: _OffsetOf_vt put: VT_DECIMAL!

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

	^(self isByRef ifTrue: [LPVOID] ifFalse: [IDispatch])
		fromAddress: (bytes uintPtrAtOffset: _OffsetOf_pdispVal)!

dispatch: newValue
	"Set the IDispatch pointer, newValue, into the receiver."

	newValue _addRef.
	bytes
		uint16AtOffset: _OffsetOf_vt put: VT_DISPATCH;
		uintPtrAtOffset: _OffsetOf_pdispVal put: newValue yourAddress!

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
		ifFalse: [bytes doubleAtOffset: _OffsetOf_dblVal]!

double: newValue
	"Set the double-precision floating point value of the receiver to the
	<Float>, newValue."

	bytes
		doubleAtOffset: _OffsetOf_dblVal put: newValue;
		uint16AtOffset: _OffsetOf_vt put: VT_R8!

float
	"Answer the single precision floating point value from the receiver.
	Assumes the receiver is of type VT_R4."

	^self isByRef
		ifTrue: [FLOAT fromAddress: self refAddress]
		ifFalse: [bytes floatAtOffset: _OffsetOf_fltVal]!

float: newValue
	"Set the single precision floating point value of the receiver to the
	<Float>, newValue."

	bytes
		floatAtOffset: _OffsetOf_fltVal put: newValue;
		uint16AtOffset: _OffsetOf_vt put: VT_R4!

hresult
	"Answer the status code (SCODE) from the receiver.
	N.B. Assumes that the receiver is of type VT_ERROR."

	^self isByRef
		ifTrue: [HRESULT fromAddress: self refAddress]
		ifFalse: [HRESULT fromInteger: (bytes int32AtOffset: _OffsetOf_lVal)]!

hresult: newValue
	"Set the ERROR value, newValue, into the receiver."

	bytes
		int32AtOffset: _OffsetOf_lVal put: newValue asInteger;
		uint16AtOffset: _OffsetOf_vt put: VT_ERROR!

initialize
	"Private - Initialize the receiver.
	Note that this does not null out the data area of the variant, it just sets
	the type to VT_EMPTY."

	super initialize.
	self class init: bytes!

int16
	"Answer the signed 16-bit integer value from the receiver.
	Assumes the receiver is of type VT_I2."

	^self isByRef
		ifTrue: [Int16 fromAddress: self refAddress]
		ifFalse: [bytes int16AtOffset: _OffsetOf_iVal]!

int16: newValue
	"Set the signed 16-bit <integer> value, newValue, into the receiver."

	bytes
		int16AtOffset: _OffsetOf_iVal put: newValue asInteger;
		uint16AtOffset: _OffsetOf_vt put: VT_I2!

int32
	"Answer the signed 32-bit integer value from the receiver.
	Assumes the receiver is of type VT_I4."

	^self isByRef
		ifTrue: [Int32 fromAddress: self refAddress]
		ifFalse: [bytes int32AtOffset: _OffsetOf_lVal]!

int32: newValue
	"Set the signed 32-bit integer value from the receiver."

	bytes
		int32AtOffset: _OffsetOf_lVal put: newValue asInteger;
		uint16AtOffset: _OffsetOf_vt put: VT_I4!

int64
	"Answer the signed 64-bit integer value from the receiver.
	Assumes the receiver is of type VT_I8 (note that this is
	not currently a generally supported variant type but
	we implement for completeness)."

	^self isByRef 
		ifTrue: [Int64 fromAddress: self refAddress]
		ifFalse: [bytes int64AtOffset: _OffsetOf_llVal]!

int64: aLargeInteger
	bytes
		int64AtOffset: _OffsetOf_llVal put: aLargeInteger asInteger;
		uint16AtOffset: _OffsetOf_vt put: VT_I8!

int8
	"Answer the signed 8-bit <integer> value from the receiver.
	N.B. Assumes that the receiver is of type VT_I1."

	^self isByRef 
		ifTrue: [Int8 fromAddress: self refAddress]
		ifFalse: [bytes int8AtOffset: _OffsetOf_bVal]!

int8: newValue
	"Set the VT_I1 value, newValue, into the receiver."

	| intVal |
	intVal := newValue asInteger.
	(newValue < -128 or: [newValue > 127]) ifTrue: [self errorSubscriptBounds: intVal].
	bytes
		int8AtOffset: _OffsetOf_bVal put: newValue asInteger;
		uint16AtOffset: _OffsetOf_vt put: VT_I1!

intPtr: newValue
	"Set the signed integer value of the receiver."

	newValue isInt32 ifTrue: [self int32: newValue] ifFalse: [self uint64: newValue]!

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

nil
	"Answer the nil value.
	N.B. Assumes that the receiver is of type VT_EMPTY."

	^nil!

nil: newValue
	"Clear the receiver."

	bytes
		intPtrAtOffset: _OffsetOf_byref put: 0;
		uint16AtOffset: _OffsetOf_vt put: VT_EMPTY!

null
	"Answer the null value.
	N.B. Assumes that the receiver is of type VT_NULL."

	^nil!

null: newValue
	"Null the receiver."

	bytes
		intPtrAtOffset: _OffsetOf_byref put: 0;
		uint16AtOffset: _OffsetOf_vt put: VT_NULL!

recordInfo
	"Private - Answer the <IRecordInfo> stored in the receiver.
	Assumes the receiver is of type VT_RECORD."

	^IRecordInfo fromAddress: (bytes uintPtrAtOffset: _OffsetOf_pRecInfo)!

refAddress
	"Private - Answer the reference address from the receiver (assumes receiver is a VT_BYREF)."

	^Address fromInteger: (bytes uintPtrAtOffset: _OffsetOf_byref)!

reference: anObject
	"Private - Set the receiver up to be a reference to the specified object (assumes
	receiver is a VT_BYREF)."

	data := anObject.
	bytes uintPtrAtOffset: _OffsetOf_byref put: anObject yourAddress.
	^self!

struct
	"Answer the structure value from the receiver.
	Assumes the receiver is of type VT_RECORD."

	data isNil
		ifTrue: 
			[data := Structure
						fromAddress: (bytes uintPtrAtOffset: _OffsetOf_byref)
						recordInfo: self recordInfo
						owner: self].
	^data!

struct: newValue
	"Private - Set the UDT value of the receiver to be the <ExternalStructure>, newValue.
	Note that what we actually do is to create a reference to the structure."

	| piRecInfo |
	piRecInfo := newValue recordInfo.
	piRecInfo addRef.
	bytes uint32AtOffset: _OffsetOf_pRecInfo put: piRecInfo yourAddress.
	self reference: newValue.
	bytes uint16AtOffset: _OffsetOf_vt put: ##(VT_RECORD | VT_BYREF)!

systemTime
	"Answer a SYSTEMTIME converted from the receiver's OLE
	Automation date (an 8-byte floating point day number and fraction of a day).
	Assumes the receiver is of type VT_DATE."

	| systime |
	systime := SYSTEMTIME new.
	OleAut32 variantTimeToSystemTime: self double lpSystemTime: systime.
	^systime!

typeName
	"Answer the symbolic name of the receiver's basic variant type code 
	without modifiers such as VT_BYREF."

	^self class nameOfVT: self vartype!

uint16
	"Answer the unsigned 16-bit <integer> value from the receiver.
	Assumes the receiver is of type VT_UI2."

	^self isByRef
		ifTrue: [UInt16 fromAddress: self refAddress]
		ifFalse: [bytes uint16AtOffset: _OffsetOf_uiVal]!

uint16: newValue
	"Set the unsigned 16-bit integer value of the receiver to the <integer> newValue, and tag as type VT_UI2."

	bytes
		uint16AtOffset: _OffsetOf_uiVal put: newValue asInteger;
		uint16AtOffset: _OffsetOf_vt put: VT_UI2!

uint32
	"Answer the unsigned 32-bit <integer> value from the receiver.
	Assumes the receiver is of type VT_UI4 (or at least of some unsigned
	32-bit integer type)."

	^self isByRef
		ifTrue: [UInt32 fromAddress: self refAddress]
		ifFalse: [bytes uint32AtOffset: _OffsetOf_ulVal]!

uint32: newValue
	"Set the unsigned 32-bit integer value of the receiver
	to the <integer>, newValue."

	bytes
		uint32AtOffset: _OffsetOf_ulVal put: newValue asInteger;
		uint16AtOffset: _OffsetOf_vt put: VT_UI4!

uint64
	"Answer the unsigned 64-bit integer value from the receiver.
	Assumes the receiver is of type VT_I8 (note that this is
	not currently a generally supported variant type but
	we implement for completeness)."

	^self isByRef
		ifTrue: [UInt64 fromAddress: self refAddress]
		ifFalse: [bytes uint64AtOffset: _OffsetOf_ullVal]!

uint64: aLargeInteger
	bytes
		uint64AtOffset: _OffsetOf_ullVal put: aLargeInteger asInteger;
		uint16AtOffset: _OffsetOf_vt put: VT_UI8!

uint8
	"Answer the unsigned 8-bit <integer> value from the receiver.
	N.B. Assumes that the receiver is of type VT_UI1."

	^self isByRef 
		ifTrue: [UInt8 fromAddress: self refAddress]
		ifFalse: [bytes uint8AtOffset: _OffsetOf_bVal]!

uint8: newValue
	"Set the unsigned 8-bit integer value of the receiver and tag as type VT_UI1"

	bytes
		uint8AtOffset: _OffsetOf_bVal put: newValue asInteger;
		uint16AtOffset: _OffsetOf_vt put: VT_UI1!

unknown
	"Answer the IUnknown pointer in the receiver.
	Assumes that the receiver is of type VT_UNKNOWN.
	Note that if the receiver is a by-reference variant then the answer
	is an untyped doubly-indirected pointer (i.e. its value is the address
	of the IDispatch pointer). If the reference is overwritten then the old
	interface pointer must be Release()d."

	^(self isByRef ifTrue: [LPVOID] ifFalse: [IUnknown])
		fromAddress: (bytes uintPtrAtOffset: _OffsetOf_punkVal)!

unknown: newValue
	"Set the <IUnknown> value, newValue, into the receiver."

	newValue _addRef.
	bytes
		uintPtrAtOffset: _OffsetOf_punkVal put: newValue yourAddress;
		uint16AtOffset: _OffsetOf_vt put: VT_UNKNOWN!

value
	"Answer a Smalltalk <Object> of a suitable type and of the same value (well as close as possible) to the receiver. If the receiver's type is not recognised, then raise a NotFoundError."

	"Implementation Note: The primitive will instantiate Smalltalk objects for types that are well known to the VM, anything else goes through the Smalltalk back up code."

	"Primitive Failure Codes:
		ClassNotRegistered	- The value would be of a class that is not registered with the VM, DATE for a VT_DATE, or IDispatch for a VT_DISPATCH.
		InvalidVariant		- The variant type (vt field) is not recognised.
		InvalidPointer		- The VARIANT object points at the actual VARIANT struct, but the address is null.
		AssertionFailure	- The VARIANT object is a malformed External.Structure."

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
	"Although we may not own the underlying data if we are a reference (pointer) instance, because we are going to overwrite it we must free it regardless. #basicFree can be repeated add infinitum on a VARIANT."
	self basicFree.
	self copyBytes: varNew detach!

varbool
	"Answer a Boolean corresponding to the VARIANT_BOOL value of the receiver (assumes the receiver is of type VT_BOOL)."

	^self isByRef
		ifTrue: [VARIANT_BOOL fromAddress: self refAddress]
		ifFalse: [(bytes int16AtOffset: _OffsetOf_boolVal) ~~ VARIANT_FALSE]!

varbool: newValue
	"Set the VARIANT_BOOL value of the receiver to the <boolean> or <integer>, newValue."

	bytes
		int16AtOffset: _OffsetOf_boolVal
			put: (newValue asParameter == 0 ifTrue: [VARIANT_FALSE] ifFalse: [VARIANT_TRUE]);
		uint16AtOffset: _OffsetOf_vt put: VT_BOOL!

variant
	"Answer a <VARIANT> at the address specified in the receiver.
	N.B. Assumes that the receiver is of type VT_VARIANT|VT_BYREF."

	self assert: [self isByRef].
	^VARIANT fromAddress: (bytes uintPtrAtOffset: _OffsetOf_pvarVal)!

variant: newValue
	"Set the <VARIANT> value, newValue, into the receiver."

	self reference: newValue.
	bytes uint16AtOffset: _OffsetOf_vt put: ##(VT_VARIANT | VT_BYREF)!

vartype
	"Answer the receiver's basic variant type code without modifies such as VT_BYREF."

	^self vt bitAnd: VT_TYPEMASK!

void
	"Answer the void value from the receiver, which is nil unless the receiver is VT_BYREF, in which case it is treated as a void* pointer. Assumes the receiver is of type VT_VOID."

	^self isByRef ifTrue: [VOID fromAddress: self refAddress]!

vt
	"Answer the <Integer> value of the receiver's 'vt' field."

	^bytes uint16AtOffset: _OffsetOf_vt!

vt: anInteger
	"Set the receiver's 'vt' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_vt put: anInteger! !

!OS.COM.VARIANT categoriesForMethods!
_deepCopy:!copying!private! !
<!comparing!public! !
<=!comparing!public! !
=!comparing!public! !
>!comparing!public! !
>=!comparing!public! !
array!accessing!public! !
array:!accessing!public! !
arrayRef:!accessing!public! !
asString!converting!public! !
asVariant!converting!public! !
badVarType!exceptions!private! !
basicFree!private!realizing/unrealizing! !
bstr!accessing!public! !
bstr:!accessing!public! !
changeType:!converting!public! !
changeType:locale:!converting!public! !
char!accessing!public! !
cmp:!comparing!private! !
copy!copying!public! !
cy!accessing!public! !
cy:!accessing!public! !
date!accessing!public! !
date:!accessing!public! !
decimal!accessing!public! !
decimal:!accessing!public! !
detach!public!realizing/unrealizing! !
dispatch!accessing!public! !
dispatch:!accessing!public! !
displayOn:!printing!public! !
double!accessing!public! !
double:!accessing!public! !
float!accessing!public! !
float:!accessing!public! !
hresult!accessing!public! !
hresult:!accessing!public! !
initialize!initializing!private! !
int16!accessing!public! !
int16:!accessing!public! !
int32!accessing!public! !
int32:!accessing!public! !
int64!accessing!public! !
int64:!accessing!public! !
int8!accessing!public! !
int8:!accessing!public! !
intPtr:!accessing!public! !
isArray!public!testing! !
isByRef!private!testing! !
isDispatch!public!testing! !
isEmpty!public!testing! !
isObject!public!testing! !
lpvoid!accessing!public! !
nil!accessing!public! !
nil:!accessing!public! !
null!accessing!public! !
null:!accessing!public! !
recordInfo!accessing!private! !
refAddress!accessing!private! !
reference:!accessing!private! !
struct!accessing!public! !
struct:!accessing!public! !
systemTime!accessing!public! !
typeName!accessing!public! !
uint16!accessing!public! !
uint16:!accessing!public! !
uint32!accessing!public! !
uint32:!accessing!public! !
uint64!accessing!public! !
uint64:!accessing!public! !
uint8!accessing!public! !
uint8:!accessing!public! !
unknown!accessing!public! !
unknown:!accessing!public! !
value!accessing!public! !
value:!accessing!public! !
varbool!accessing!public! !
varbool:!accessing!public! !
variant!accessing!public! !
variant:!accessing!public! !
vartype!accessing!public! !
void!accessing!public! !
vt!**compiled accessors**!public! !
vt:!**compiled accessors**!public! !
!

OS.COM.VARIANT methodProtocol: #variantCompatible attributes: #(#readOnly) selectors: #(#asVariant)!

!OS.COM.VARIANT class methodsFor!

byteSize
	^_VARIANT_Size!

classForVT: anInteger
	"Answer a class of object suitable for representing values of the specified Variant type (i.e. a value from the VT_XXX enumeration which describes a scalar type)."

	^(VTClasses at: anInteger + 1)
		ifNil: [self error: 'Unmapped var type ' , anInteger printString]
		ifNotNil: [:bindingRef | bindingRef value]!

clear: addressOrBytes
	"Free an instance of the structure which instances of the receiver wrap
	which resides at the specified address."

	OleAut32 variantClear: addressOrBytes!

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
						struct {
							PVOID       pvRecord;
							IRecordInfo *pRecInfo;
						} __VARIANT_NAME_4;
					} __VARIANT_NAME_3;
				} __VARIANT_NAME_2;
				DECIMAL decVal;
			} __VARIANT_NAME_1;
		};"

	self
		defineField: #vt type: UInt16Field new offset: 0;
		defineField: #wReserved1 type: UInt16Field filler offset: 2;
		defineField: #wReserved2 type: UInt16Field filler offset: 4;
		defineField: #wReserved3 type: UInt16Field filler offset: 6;
		defineField: #llVal type: Int64Field filler offset: 8;
		defineField: #lVal type: Int32Field filler offset: 8;
		defineField: #bVal type: UInt8Field filler offset: 8;
		defineField: #iVal type: Int16Field filler offset: 8;
		defineField: #fltVal type: FLOATField filler offset: 8;
		defineField: #dblVal type: DOUBLEField filler offset: 8;
		defineField: #boolVal type: Int16Field filler offset: 8;
		defineField: #scode type: Int32Field filler offset: 8;
		defineField: #cyVal type: (StructureField type: CURRENCY) beFiller offset: 8;
		defineField: #date type: (StructureField type: DATE) beFiller offset: 8;
		defineField: #bstrVal type: (PointerField type: BSTR) beFiller offset: 8;
		defineField: #punkVal type: (PointerField type: IUnknown) beFiller offset: 8;
		defineField: #pdispVal type: (PointerField type: IDispatch) beFiller offset: 8;
		defineField: #parray type: LPVOIDField filler offset: 8;
		defineField: #pbVal type: (PointerField type: UInt8) beFiller offset: 8;
		defineField: #piVal type: (PointerField type: Int16) beFiller offset: 8;
		defineField: #plVal type: (PointerField type: Int32) beFiller offset: 8;
		defineField: #pllVal type: (PointerField type: Int64) beFiller offset: 8;
		defineField: #pfltVal type: (PointerField type: FLOAT) beFiller offset: 8;
		defineField: #pdblVal type: (PointerField type: DOUBLE) beFiller offset: 8;
		defineField: #pboolVal type: (PointerField type: VARIANT_BOOL) beFiller offset: 8;
		defineField: #pscode type: (PointerField type: HRESULT) beFiller offset: 8;
		defineField: #pcyVal type: (PointerField type: CURRENCY) beFiller offset: 8;
		defineField: #pdate type: (PointerField type: DATE) beFiller offset: 8;
		defineField: #pbstrVal type: LPVOIDField filler offset: 8;
		defineField: #ppunkVal type: LPVOIDField filler offset: 8;
		defineField: #ppdispVal type: LPVOIDField filler offset: 8;
		defineField: #pparray type: LPVOIDField filler offset: 8;
		defineField: #pvarVal type: (PointerField type: VARIANT) beFiller offset: 8;
		defineField: #byref type: LPVOIDField filler offset: 8;
		defineField: #cVal type: UInt8Field filler offset: 8;
		defineField: #uiVal type: UInt16Field filler offset: 8;
		defineField: #ulVal type: UInt32Field filler offset: 8;
		defineField: #ullVal type: UInt64Field filler offset: 8;
		defineField: #intVal type: Int32Field filler offset: 8;
		defineField: #uintVal type: UInt32Field filler offset: 8;
		defineField: #decVal type: (StructureField type: DECIMAL) beFiller offset: 0;
		defineField: #pdecVal type: (PointerField type: DECIMAL) beFiller offset: 8;
		defineField: #pcVal type: (PointerField type: UInt8) beFiller offset: 8;
		defineField: #puiVal type: (PointerField type: UInt16) beFiller offset: 8;
		defineField: #pulVal type: (PointerField type: UInt32) beFiller offset: 8;
		defineField: #pullVal type: (PointerField type: UInt64) beFiller offset: 8;
		defineField: #pintVal type: (PointerField type: Int32) beFiller offset: 8;
		defineField: #puintVal type: (PointerField type: UInt32) beFiller offset: 8;
		defineField: #pvRecord type: LPVOIDField filler offset: 8;
		defineField: #pRecInfo type: (PointerField type: IRecordInfo) beFiller offset: (8+VMConstants.IntPtrSize).
	self assert: [self basicByteSize = (8 + (2 * VMConstants.IntPtrSize))]!

externalTypeNames
	^#(#{UInt8} #{Int8} #{UInt16} #{Int16} #{FLOAT} #{DOUBLE} #{UInt32} #{Int32} #{Int64} #{UInt64})!

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
		ifTrue: [answer int32: aLargeInteger]
		ifFalse: 
			[words > 2
				ifTrue: 
					["Might error if too large (or negative)"
					answer uint64: aLargeInteger]
				ifFalse: [answer int64: aLargeInteger]].
	^answer!

fromSmallInteger: aSmallInteger
	"Answer a new VT_I4/VT_I8 instance of the receiver holding the specified <SmallInteger> value.
	It is an error if the argument is too large to be represented in 32/64 bits."

	^self new
		int32: aSmallInteger;
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
	^#(#vt)!

init: buffer
	"Initialize a buffer (or buffer at the specified address) to hold an instance of the record type
	described by the receiver. Assumes that the memory is completely uninitialized."

	OleAut32 variantInit: buffer!

initialize
	"Private - Initialize the receiver's class variables.
		VARIANT initialize
	"

	Unspecified := self new
				hresult: DISP_E_PARAMNOTFOUND;
				beUnfinalizable;
				yourself.
	self addClassConstant: 'VTNames' value: self vtNames.
	self addClassConstant: 'VTClasses' value: self vtClasses.
	self externalTypeNames do: [:each | VM registryAt: each asSymbol put: each value].
	VM registryAt: self name put: self!

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

	Unspecified := nil.
	"The VM only needs a ref to certain classes to implement the VARIANT>>value primitive, so these can be
	 cleared out if this class is removed."
	self externalTypeNames do: [:each | VM registryAt: each asSymbol put: nil].
	VM registryAt: self name put: nil!

unspecified
	"Answer an instance of the receiver appropriate to use as an unspecified optional argument."

	^Unspecified!

vt
	"Answer the VARTYPE (one of the VT_XXX constants) used to describe the receiver's 
	type when represented in a <VARIANT>."

	^VT_VARIANT!

vtClasses 
	^(Array new: VT_CLSID + 1)
		at: VT_BLOB+1			put: #{Core.ByteArray};			"Blob - OLE Property sets only"
		at: VT_BLOB_OBJECT+1		put: #{Core.ByteArray};			"Blob containing an object - OLE Property sets only"
		at: VT_BOOL+1			put: #{OS.COM.VARIANT_BOOL};	"Automation (Basic) boolean"
		at: VT_BSTR+1				put: #{OS.COM.BSTR};			"Automation (Basic) String"
		at: VT_CARRAY+1			put: #{External.Array};			"C-style array - TYPEDESC only"
		at: VT_CF+1				put: #{External.UInt32};			"Clipboard format - OLE Property sets only"
		at: VT_CLSID+1			put: #{OS.COM.CLSID};			"Class ID - OLE Property sets only"
		at: VT_CY+1				put: #{OS.COM.CURRENCY};		"Automation Currency - 64-bit fixed point, 4 decimal places"
		at: VT_DATE+1				put: #{OS.COM.DATE};			"Automation (double) date"
		at: VT_DECIMAL+1			put: #{OS.COM.DECIMAL};		"16-byte fixed point"
		at: VT_DISPATCH+1			put: #{OS.COM.IDispatch};		"IDispatch pointer"
		at: VT_EMPTY+1			put: #{Core.UndefinedObject};		"nil (in ST) or Nothing (in VB)"
		at: VT_ERROR+1			put: #{OS.HRESULT};			"Status code (SCODE)"
		at: VT_FILETIME+1			put: #{OS.FILETIME};			"FILETIME - OLE Property sets only"
		at: VT_I1+1				put: #{External.Int8};			"Signed 8-bit integer"
		at: VT_I2+1				put: #{External.Int16};			"16-bit signed integer"
		at: VT_I4+1				put: #{External.Int32};			"32-bit signed integer"
		at: VT_I8+1				put: #{External.Int64};			"64-bit signed integer"
		at: VT_INT+1				put: #{External.Int32};			"signed machine dependent integer - TYPEDESC only"
		at: VT_LPSTR+1			put: #{Core.AnsiString};			"Null-terminated ANSI string - OLE Property Sets and TYPEDESC only"
		at: VT_LPWSTR+1			put: #{Core.Utf16String};			"Null-terminated UTF16 string - OLE Property Sets and TYPEDESC only"
		at: VT_NULL+1			put: #{Core.UndefinedObject};		"SQL Null (i.e. nil)"
		at: VT_PTR+1				put: #{External.Address};			"Pointer type - TYPEDESC only"
		at: VT_R4+1				put: #{External.FLOAT};			"Single precision floating point"
		at: VT_R8+1				put: #{External.DOUBLE};			"Double precision floating point"
		at: VT_SAFEARRAY+1		put: #{OS.COM.SAFEARRAY};		"As VT_ARRAY, but TYPEDESC only"
		at: VT_STORAGE+1			put: #{OS.COM.IStorage};		"Name of storage - OLE Property Sets only"
		at: VT_STORED_OBJECT+1	put: #{OS.COM.IStorage};		"Storage containing object - OLE Property Sets only"
		at: VT_STREAM+1			put: #{OS.COM.IStream};			"Name of storage - OLE Property Sets only"
		at: VT_STREAMED_OBJECT+1	put: #{OS.COM.IStream};			"Stream containing object - OLE Property Sets only"
		at: VT_UINT+1				put: #{External.UInt32};			"unsigned machine dependent integer - TYPEDESC only"
		at: VT_UI1+1				put: #{External.UInt8};			"8-bit unsigned integer"
		at: VT_UI2+1				put: #{External.UInt16};			"16-bit unsigned integer"
		at: VT_UI4+1				put: #{External.UInt32};			"32-bit unsigned integer"
		at: VT_UI8+1				put: #{External.UInt64};				"64-bit unsigned integer - OLE Prop Sets, TYPEDESC only"
		at: VT_UNKNOWN+1		put: #{OS.COM.IUnknown};		"IUnknown pointer"
		at: VT_USERDEFINED+1		put: #{OS.COM.Record};			"user defined type, a typedef in face - TYPEDESC only"
		at: VT_RECORD+1			put: #{External.Structure};
		at: VT_VARIANT+1			put: #{OS.COM.VARIANT};		"Reference to another VARIANT"
		at: VT_VOID+1			put: #{External.VOID};			"C void - TYPEDESC only, for generic pointer outputs"
		at: VT_HRESULT+1			put: #{OS.HRESULT}; 			"HRESULT return code - TYPEDESC only"
		at: VT_INT_PTR+1			put: #{External.IntPtr};			"signed machine register size width - TYPEDESC only"
		at: VT_UINT_PTR+1			put: #{External.UIntPtr};		"unsigned machine register size width - TYPEDESC only"
		yourself!

vtNames 
	^(Array new: VT_CLSID+1 withAll: #badVarType)
		at: VT_BLOB+1			put: #blob;			"Blob - OLE Property sets only"
		at: VT_BLOB_OBJECT+1		put: #blob_object;		"Blob containing an object - OLE Property sets only"
		at: VT_BOOL+1			put: #varbool;			"VARIANT_BOOL - i.e. True=-1, False=0"
		at: VT_BSTR+1				put: #bstr;			"Automation (Basic) String"
		at: VT_CARRAY+1			put: #carray;			"C-style array - TYPEDESC only"
		at: VT_CF+1				put: #cf;				"Clipboard format - OLE Property sets only"
		at: VT_CLSID+1			put: #clsid;			"Class ID - OLE Property sets only"
		at: VT_CY+1				put: #cy;				"Automation Currency"
		at: VT_DATE+1				put: #date;			"Automation (double) date"
		at: VT_DECIMAL+1			put: #decimal;			"14-byte fixed point"
		at: VT_DISPATCH+1			put: #dispatch;		"IDispatch pointer"
		at: VT_EMPTY+1			put: #nil;				"nil (in ST) or Nothing (in VB)"
		at: VT_ERROR+1			put: #hresult;			"Status code (SCODE)"
		at: VT_FILETIME+1			put: #filetime;			"FILETIME - OLE Property sets only"
		at: VT_HRESULT+1			put: #hresult;			"HRESULT return code - TYPEDESC only"
		at: VT_I1+1				put: #int8;
		at: VT_I2+1				put: #int16;
		at: VT_I4+1				put: #int32;
		at: VT_I8+1				put: #int64;			"OLE Property Sets and TYPEDESC only"
		at: VT_INT+1				put: #int32;			"signed machine dependent integer - TYPEDESC only"
		at: VT_LPSTR+1			put: #lpstr;			"Null-terminated ANSI string - OLE Property Sets and TYPEDESC only"
		at: VT_LPWSTR+1			put: #lpwstr;			"Null-terminated UTF-16 string - OLE Property Sets and TYPEDESC only"
		at: VT_NULL+1			put: #null;			"SQL Null (i.e. nil)"
		at: VT_PTR+1				put: #lpvoid;			"Pointer type - TYPEDESC only"
		at: VT_R4+1				put: #float;			"Single precision floating point"
		at: VT_R8+1				put: #double;			"Double precision floating point"
		at: VT_SAFEARRAY+1		put: #safearray;		"As VT_ARRAY, but TYPEDESC only"
		at: VT_STORAGE+1			put: #storage;			"Name of storage - OLE Property Sets only"
		at: VT_STORED_OBJECT+1	put: #stored_object;	"Storage containing object - OLE Property Sets only"
		at: VT_STREAM+1			put: #stream;			"Name of storage - OLE Property Sets only"
		at: VT_STREAMED_OBJECT+1	put: #streamed_object;	"Stream containing object - OLE Property Sets only"
		at: VT_UINT+1				put: #uint32;			"unsigned machine dependent integer - TYPEDESC only"
		at: VT_UI1+1				put: #uint8;
		at: VT_UI2+1				put: #uint16;
		at: VT_UI4+1				put: #uint32;
		at: VT_UI8+1				put: #uint64;			"OLE Property Sets and TYPEDESC only"
		at: VT_UNKNOWN+1		put: #unknown;		"IUnknown pointer"
		at: VT_USERDEFINED+1		put: #typedef;			"user defined type - TYPEDESC only"
		at: VT_RECORD+1			put: #struct;
		at: VT_VARIANT+1			put: #variant;			"Reference to another VARIANT"
		at: VT_VOID+1			put: #void;			"C void - TYPEDESC only"
		at: VT_INT_PTR+1			put: #intptr;			"signed machine register size width - TYPEDESC only"
		at: VT_UINT_PTR+1			put: #uintptr;			"unsigned machine register size width - TYPEDESC only"
		yourself! !

!OS.COM.VARIANT class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
classForVT:!enquiries!public! !
clear:!public!realizing/unrealizing! !
defineFields!public!template definition! !
externalTypeNames!constants!private! !
fromBoolean:!instance creation!public! !
fromCollection:!instance creation!public! !
fromDATE:!instance creation!public! !
fromDispatch:!instance creation!public! !
fromFloat:!instance creation!public! !
fromInteger:!instance creation!public! !
fromLargeInteger:!instance creation!public! !
fromSmallInteger:!instance creation!public! !
fromString:!instance creation!public! !
fromUnknown:!instance creation!public! !
getFieldNames!**compiled accessors**!constants!private! !
init:!initializing!public! !
initialize!development!initializing!private! !
nameOfVT:!enquiries!public! !
null!instance creation!public! !
typeName!constants!private! !
uninitialize!class hierarchy-removing!private! !
unspecified!instance creation!public! !
vt!constants!public! !
vtClasses!constants!private! !
vtNames!constants!must not strip!private! !
!

