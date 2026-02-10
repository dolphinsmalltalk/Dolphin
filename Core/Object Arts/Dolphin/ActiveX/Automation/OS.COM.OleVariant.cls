"Filed out from Dolphin Smalltalk"!

External.FinalizableStructure
	subclass: #'OS.COM.OleVariant'
	instanceVariableNames: 'data'
	classVariableNames: 'Unspecified'
	imports: #(#{OS.COM.AutomationConstants} #{OS.COM.AutomationErrors} #{OS.COM.PropsysLibrary private})
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
			'VT_ARRAY' -> 16r2000.
			'VT_BLOB' -> 16r41.
			'VT_BLOB_OBJECT' -> 16r46.
			'VT_BOOL' -> 16rB.
			'VT_BSTR' -> 16r8.
			'VT_BYREF' -> 16r4000.
			'VT_CARRAY' -> 16r1C.
			'VT_CF' -> 16r47.
			'VT_CLSID' -> 16r48.
			'VT_CY' -> 16r6.
			'VT_DATE' -> 16r7.
			'VT_DECIMAL' -> 16rE.
			'VT_DISPATCH' -> 16r9.
			'VT_EMPTY' -> 16r0.
			'VT_ERROR' -> 16rA.
			'VT_FILETIME' -> 16r40.
			'VT_HRESULT' -> 16r19.
			'VT_I1' -> 16r10.
			'VT_I2' -> 16r2.
			'VT_I4' -> 16r3.
			'VT_I8' -> 16r14.
			'VT_INT' -> 16r16.
			'VT_INT_PTR' -> 16r25.
			'VT_LPSTR' -> 16r1E.
			'VT_LPWSTR' -> 16r1F.
			'VT_NULL' -> 16r1.
			'VT_PTR' -> 16r1A.
			'VT_R4' -> 16r4.
			'VT_R8' -> 16r5.
			'VT_RECORD' -> 16r24.
			'VT_SAFEARRAY' -> 16r1B.
			'VT_STORAGE' -> 16r43.
			'VT_STORED_OBJECT' -> 16r45.
			'VT_STREAM' -> 16r42.
			'VT_STREAMED_OBJECT' -> 16r44.
			'VT_TYPEMASK' -> 16rFFF.
			'VT_UI1' -> 16r11.
			'VT_UI2' -> 16r12.
			'VT_UI4' -> 16r13.
			'VT_UI8' -> 16r15.
			'VT_UINT' -> 16r17.
			'VT_UINT_PTR' -> 16r26.
			'VT_UNKNOWN' -> 16rD.
			'VT_USERDEFINED' -> 16r1D.
			'VT_VARIANT' -> 16rC.
			'VT_VECTOR' -> 16r1000.
			'VT_VERSIONED_STREAM' -> 16r49.
			'VT_VOID' -> 16r18.
			'VTClasses'
				-> #(#{Core.UndefinedObject} #{Core.UndefinedObject} #{External.Int16} #{External.Int32} #{External.FLOAT} #{External.DOUBLE} #{OS.COM.CY} #{OS.COM.DATE} #{OS.COM.BSTR} #{OS.COM.IDispatch} #{OS.HRESULT} #{OS.COM.VARIANT_BOOL} #{OS.COM.VARIANT} #{OS.COM.IUnknown} #{OS.COM.DECIMAL} nil #{External.Int8} #{External.UInt8} #{External.UInt16} #{External.UInt32} #{External.Int64} #{External.UInt64} #{External.Int32} #{External.UInt32} #{External.VOID} #{OS.HRESULT} #{External.Address} #{OS.COM.SAFEARRAY} #{External.Array} #{OS.COM.Record} #{Core.AnsiString} #{Core.Utf16String} nil nil nil nil nil #{External.IntPtr} #{External.UIntPtr} nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil #{OS.FILETIME} #{OS.COM.BLOB} #{OS.COM.IStream} #{OS.COM.IStorage} #{OS.COM.IStream} #{OS.COM.IStorage} #{Core.ByteArray} #{External.UInt32} #{OS.COM.CLSID} #{OS.COM.IStream}).
			'VTNames'
				-> #(#nil #null #int16 #int32 #float #double #cy #date #bstr #dispatch #hresult #varbool #variant #unknown #decimal #badVarType #int8 #uint8 #uint16 #uint32 #int64 #uint64 #int32 #uint32 #void #hresult #lpvoid #array #carray #typedef #lpstr #lpwstr #badVarType #badVarType #badVarType #badVarType #record #intptr #uintptr #badVarType #badVarType #badVarType #badVarType #badVarType #badVarType #badVarType #badVarType #badVarType #badVarType #badVarType #badVarType #badVarType #badVarType #badVarType #badVarType #badVarType #badVarType #badVarType #badVarType #badVarType #badVarType #badVarType #badVarType #badVarType #filetime #blob #stream #storage #streamed_object #stored_object #blob_object #clipdata #clsid #versioned_stream)
		}!

OS.COM.OleVariant guid: (Core.GUID fromString: '{19bfe1bb-2352-4f53-ba52-277d04465ff0}')!

OS.COM.OleVariant isNonInstantiable: true!

OS.COM.OleVariant comment: '`OleVariant` is the abstract class of OLE/COM variant data types. These are essentially a discriminated union. There are two distinct sub-types:
	`VARIANT` - Variant used for OLE Automation (IDispatch) in scripting languages
	`PROPVARIANT` - Variant used in the Property Storage system

`PROPVARIANT` is broadly a superset of `VARIANT`, although notably support for `VT_DECIMAL`, and `VT_UINT` is missing or incomplete. Some header documentation suggests it doesn''t support `VT_IDISPATCH` or `VT_IUNKNOWN` too, but this appears to be false.

VARENUM usage key:

 [V] - may appear in a VARIANT
 [T] - may appear in a TYPEDESC
 [P] - may appear in an OLE property set
 [S] - may appear in a Safe Array


 VT_EMPTY				[V]   [P]		Nothing
 VT_NULL					[V]   [P]		SQL style Null
 VT_I2					[V][T][P][S]	16-bit signed int
 VT_I4					[V][T][P][S]	32-bit signed int
 VT_R4					[V][T][P][S]	32-bit floating point
 VT_R8					[V][T][P][S]	64-bit floating point
 VT_CY					[V][T][P][S]	CURRENCY
 VT_DATE					[V][T][P][S]	DATE
 VT_BSTR					[V][T][P][S]	OLE Automation string
 VT_DISPATCH				[V][T][P][S]	IDispatch*
 VT_ERROR				[V][T][P][S]	SCODE
 VT_BOOL				[V][T][P][S]	VARIANT_BOOL, i.e. True=-1, False=0
 VT_VARIANT				[V][T][P][S]	VARIANT*
 VT_UNKNOWN			[V][T][P][S]	IUnknown*
 VT_DECIMAL          		[V][T]   [S]	14-byte fixed point
 VT_RECORD				[V]   [P][S]	User-defined type
 VT_I1					[V][T][P][S]	Signed 8-bit int
 VT_UI1					[V][T][P][S]	Unsigned 8-bit int
 VT_UI2					[V][T][P][S]	Unsigned 16-bit int
 VT_UI4					[V][T][P][S]	Unsigned 32-bit int
 VT_I8					    [T][P]		Signed 64-bit int
 VT_UI8					    [T][P]		Unsigned 64-bit int
 VT_INT					[V][T][P][S]	Signed machine int
 VT_UINT					[V][T]    [S]	Unsigned machine int
 VT_INT_PTR				    [T]		Signed machine register size width
 VT_UINT_PTR				    [T]		Unsigned machine register size width
 VT_VOID					    [T]		C-style void
 VT_HRESULT				    [T]		Standard COM return type
 VT_PTR					    [T]		Pointer type
 VT_SAFEARRAY			    [T]		(Use VT_ARRAY in VARIANT)
 VT_CARRAY				    [T]		C-style array
 VT_USERDEFINED			    [T]		User-defined type
 VT_LPSTR				    [T][P]		Null-terminated ANSI string
 VT_LPWSTR				    [T][P]		Null-terminated UTF-16 string
 VT_FILETIME				        [P]		FILETIME
 VT_BLOB					        [P]		Length-prefixed bytes
 VT_STREAM				        [P]		Name of the stream follows
 VT_STORAGE				        [P]		Name of the storage follows
 VT_STREAMED_OBJECT		        [P]		Stream contains an object
 VT_STORED_OBJECT		        [P]		Storage contains an object
 VT_VERSIONED_STREAM	        [P]		VERSIONED_STREAM (IStream with a GUID version)
 VT_BLOB_OBJECT			        [P]		BLOB containing an object 
 VT_CF					        [P]		CLIPDATA (Clipboard format)
 VT_CLSID				        [P]		CLSID (Class GUID)
 VT_VECTOR				        [P]		Simple counted array
 VT_ARRAY				[V]			SAFEARRAY*
 VT_BYREF				[V]			void* for local use
 VT_BSTR_BLOB						Reserved for system use'!

!OS.COM.OleVariant categoriesForClass!External-Data-Structured-COM! !

!OS.COM.OleVariant methodsFor!

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
	"Private - Answer the <SAFEARRAY> or <CountedArray> value of the receiver. Note that the answered array references the same underlying data, so mutating it will implicitly mutate the variant."

	^self getArray: (bytes uint16AtOffset: _OffsetOf_vt)!

array: aSAFEARRAY
	"Private - Initialize the receiver to hold (and own) the <SAFEARAY> argument. Note that this argument is detached from the underlying SAFEARRAY, so a copy must be passed if it is necessary to preserve the original."

	bytes
		uint16AtOffset: _OffsetOf_vt put: aSAFEARRAY vt;
		uintPtrAtOffset: _OffsetOf_parray put: aSAFEARRAY detach!

arrayRef: aCollection
	"Private - Initialize the receiver to be a reference to the <SAFEARRAY> representation of the argument, i.e. the receiver will be of type VT_xx|VT_ARRAY|VT_BYREF."

	data := aCollection asSAFEARRAY.
	bytes
		uint16AtOffset: _OffsetOf_vt put: (data vt bitOr: VT_BYREF);
		uintPtrAtOffset: _OffsetOf_pparray put: data bytes basicYourAddress!

asExternalArray
	"Answer an <ExternalArray> containing a copy of the elements of the receiver. An error will be thrown if the receiver is not a VT_VECTOR or VT_ARRAY."

	^self perform: self elementClass variantVectorName!

asString
	"Answer the receiver coerced to a String (if possible)."

	| varstr string |
	self isVtString ifTrue: [^self value].
	"We convert to VT_<string> rather than call [Prop]VariantToStringAlloc, because [Prop]VariantChangeType supports richer conversions (e.g. VARIANT_TRUE -> 'True')."
	varstr := self changeType: self preferredVtString.
	string := varstr value.
	varstr free.
	^string!

asVariant: aClass
	"Answer the <VARIANT> representation of the receiver."

	aClass == self class ifTrue: [^self].
	^super asVariant: aClass!

badVarType
	^HRESULTError signalWith: DISP_E_BADVARTYPE!

basicFree
	"Private - Free external resources owned by the receiver."

	super basicFree.
	data := nil.
!

blob: aByteObject
	self subclassResponsibility!

blobVector
	"Private - Answer a <UInt8Array> containing the receiver's byte data held by the receiver, assumed to be of (VT_ARRAY | VT_I1)."

	^self subclassResponsibility!

boolVector
	"Private - Answer a <BOOLArray> representing the VARIANT_BOOL elements of the receiver. An error will be thrown if the receiver is not of type VT_VECTOR or VT_ARRAY of VT_BOOL.
	Note that BOOLArray's hold 32-bit BOOL (0/1) values, not 16-bit VARIANT_BOOL (0/-1) values."

	^self subclassResponsibility!

boolVector: aBOOLArray
	"Private - Initialize the receiver from the array of `BOOL` argument. Note that the `BOOL` is a 32-bit 0/1 representation of boolean values, but that the resulting variant will contain a VT_VECTOR or VT_ARRAY of VT_BOOL, which uses the 16-bit VARIANT_BOOL (0/-1) representation. This inconsistency is inherent in the API."

	self subclassResponsibility!

bstr
	"Private - Answer the <String> value from the receiver. Assumes the receiver is of type VT_BSTR."

	^self isByRef
		ifTrue: 
			["See VARIANT class>>#example1 for more info on by-ref BSTRs"
			LPBSTR fromAddress: (bytes uintPtrAtOffset: _OffsetOf_bstrVal) owner: self fieldOwner]
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
	"Private - Initialize the receiver to hold a VT_BSTR copy of the <String> argument."

	"Implementation Note: If #asBSTR does not create a new BSTR then we must copy the <BSTR> argument to avoid having a side effect on the argument."

	| bstr |
	(bstr := aString asBSTR) == aString ifTrue: [bstr := bstr copy].
	bytes
		uintPtrAtOffset: _OffsetOf_bstrVal put: bstr detach;
		uint16AtOffset: _OffsetOf_vt put: VT_BSTR!

bstrVector
	"Private - Answer a <BSTRArray> containing the BSTR values held by the receiver, assumed to be a VT_VECTOR or VT_ARRAY of VT_BSTR."

	^self getVector!

bstrVector: anArrayOfStrings
	"Private - Initialize the receiver to contain a vector holding <BSTR> copies of the strings in the argument, using the preferred representation of the concrete subclass."

	^self subclassResponsibility!

changeType: anInteger
	"Answer a <VARIANT> containing the receiver's value coerced to a new type as specified by the argument, an <integer> member of the VARTYPE enumeration. If the coercion is not possible, then raise an HRESULTError."

	^self changeType: anInteger locale: Locale.UserDefault!

changeType: anInteger locale: aLocale
	"Answer a <VARIANT> containing the receiver's value coerced to a new type as specified by the <integer> first argument, a member of the VARTYPE enumeration. The conversion is that appropriate for the specified target <Locale>. If the coercion is not possible, then raise an HRESULTError."

	| answer |
	anInteger == (bytes uint16AtOffset: _OffsetOf_vt) ifTrue: [^self].	"Already requested type"
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
	"Private - Answer the ANSI (8-bit) character from the receiver.
	N.B. Assumes that the receiver is of type VT_UI1."

	^Character value: self uint8

	!

clsid
	"Private - Answer the <CLSID> value from the receiver. Assumes the receiver is of an appropriate type, depending on the concrete subclass."

	^self subclassResponsibility!

clsid: aCLSID
	"Private - Initialize the receiver to hold the <CLSID> argument."

	self subclassResponsibility!

clsidVector
	"Private - Answer an <CLSIDArray> containing the CLSID values held by the receiver, assumed to be a (VT_VECTOR|VT_CLSID) or (VT_ARRAY|VT_RECORD), where the records are CLSIDs."

	^self getVector!

clsidVector: aCLSIDArray
	"Private - Initialize the receiver to be hold a single-dimensioned array of CLSIDs copied from the argument."

	self subclassResponsibility!

cmp: anAbstractVARIANT
	^self subclassResponsibility!

cy
	"Private - Answer a Variant 'currency' value from the receiver. N.B. Assumes that the receiver is of type VT_CY."

	"The VT_CY format is a 64-bit fractional value scaled by 10000 to give 4 decimal places. It provides limited scaled decimal capabilities for simple scripting languages such as VB."

	^self isByRef
		ifTrue: [CY fromAddress: self refAddress owner: self]
		ifFalse: [ScaledDecimal newFromNumber: (bytes int64AtOffset: _OffsetOf_cyVal) / 10000 scale: 4]!

cy: aNumber
	"Private - Initialize the receiver to be a VT_CY holding a <CY> value as close as possible to the <Number> argument."

	bytes
		int64AtOffset: _OffsetOf_cyVal put: (aNumber * 10000) asInteger;
		uint16AtOffset: _OffsetOf_vt put: VT_CY!

cyVector
	"Private - Answer a <CYArray> containing the CY values held by the receiver, assumed to be a VT_VECTOR or VT_ARRAY of VT_CY."

	^self getVector!

cyVector: aCYArray
	"Private - Initialize the receiver to contain a VT_VECTOR (CACY) or VT_ARRAY (SAFEARRAY of VT_CY)>, holding copies of the <CY> values in the <ExternalArray> argument."

	self subclassResponsibility!

date
	"Private - Answer a date and time object corresponding to the Variant DATE from the receiver. Assumes the receiver is of type VT_DATE."

	^self isByRef
		ifTrue: [DATE fromAddress: self refAddress owner: self]
		ifFalse: [DateAndTime fromDATE: (bytes doubleAtOffset: _OffsetOf_date)]!

date: aNumberOrDATE
	"Private - Initialize the receiver to be a VT_DATE holding a <DATE> value that is the closest possible representation of the argument."

	bytes
		doubleAtOffset: _OffsetOf_date put: aNumberOrDATE asFloat;
		uint16AtOffset: _OffsetOf_vt put: VT_DATE!

dateVector
	"Private - Answer an <DATEArray> containing the DATE values held by the receiver, assumed to be a VT_VECTOR or VT_ARRAY of VT_DATE."

	^self getVector!

dateVector: aDATEArray
	"Private - Initialize the receiver to be a VT_VECTOR (CADATE) or VT_ARRAY (SAFEARAY) of VT_DATE, containing DATE values copied from the <DATEArray> argument."

	self subclassResponsibility!

decimal
	"Private - Answer a <ScaledDecimal> which is the Variant DECIMAL value from the receiver. N.B. Assumes that the receiver is of type VT_DECIMAL."

	"The VT_DECIMAL format is a rather complex 16-byte fixed point value with 12-bytes to represent the absolute value, and a byte each for scale and sign, with the top two bytes unused because these overlap the vartype field of a VARIANT."

	^self isByRef
		ifTrue: [^DECIMAL fromAddress: self refAddress owner: self]
		ifFalse: 
			[| sign scale hi32 lo64 |
			scale := bytes uint8AtOffset: DECIMAL._OffsetOf_scale.
			sign := (bytes uint8AtOffset: DECIMAL._OffsetOf_sign) == 0 ifTrue: [1] ifFalse: [-1].
			hi32 := bytes uint32AtOffset: DECIMAL._OffsetOf_hi32.
			lo64 := bytes uint64AtOffset: DECIMAL._OffsetOf_lo64.
			ScaledDecimal newFromNumber: ((hi32 bitShift: 64) + lo64) * sign / scale exp10 scale: scale]!

decimal: aScaledDecimalOrInteger
	"Private - Initialize the receiver to be a VT_DECIMAL holding a value as close as possible to the <ScaledDecimal> or <Integer> argument. 
	The argument must be a <ScaledDecimal> or <Integer>, rather than another type of <Number>, since the scale must be known."

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

decimalVector
	"Private - Answer a <DECIMALArray> containing the DECIMAL values held by the receiver, assumed to be a VT_ARRAY of VT_DECIMAL."

	^self getVector!

decimalVector: aDECIMALArray
	"Private - Initialize the receiver to contain a VT_ARRAY (SAFEARRAY of VT_DECIMAL)>, holding copies of the <DECIMAL> values in the <ExternalArray> argument."

	self externalArray: aDECIMALArray!

detach
	"Detach the receiver from the underlying VARIANT (useful for passing
	ownership)."

	| var |
	var := bytes.
	bytes := nil.
	self beUnfinalizable.
	^var!

dispatch: newValue
	"Private - Set the IDispatch pointer, newValue, into the receiver."

	newValue _addRef.
	bytes
		uintPtrAtOffset: _OffsetOf_pdispVal put: newValue yourAddress;
		uint16AtOffset: _OffsetOf_vt put: VT_DISPATCH
!

displayArrayOn: aPuttableStream
	| array |
	array := self array.
	array displayOn: aPuttableStream.
	array free!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	| vt |
	^((vt := self vt) anyMask: ##(VT_ARRAY | VT_VECTOR))
		ifTrue: [self displayArrayOn: aPuttableStream]
		ifFalse: 
			[(vt == VT_BSTR or: [vt == VT_LPWSTR])
				ifTrue: [aPuttableStream nextPutAll: self value]
				ifFalse: [self displayScalarOn: aPuttableStream]]!

displayScalarOn: aPuttableStream
	| str |
	str := self changeType: VT_BSTR locale: aPuttableStream locale.
	aPuttableStream nextPutAll: str value.
	str == self ifFalse: [str free]!

double
	"Private - Answer the double precision floating point value from the receiver.
	Assumes the receiver is of type VT_R8 (or VT_DATE)."

	^self isByRef
		ifTrue: [DOUBLE fromAddress: self refAddress owner: self fieldOwner]
		ifFalse: [bytes doubleAtOffset: _OffsetOf_dblVal]!

double: aFloat
	"Private - Initialize the receiver to be a VT_R8 holding the specified double-precision <Float> value."

	bytes
		doubleAtOffset: _OffsetOf_dblVal put: aFloat;
		uint16AtOffset: _OffsetOf_vt put: VT_R8!

doubleVector
	"Private - Answer an <DOUBLEArray> containing the double precision floating-point values held by the receiver, assumed to be a VT_VECTOR or VT_ARRAY of VT_R8."

	^self subclassResponsibility!

doubleVector: aDOUBLEArray
	"Private - Initialize the receiver to be a VT_VECTOR (CADLBL) or VT_ARRAY (SAFEARAY) of VT_R8, containing double-precision floating-point values copied from the <DOUBLEArray> argument."

	self subclassResponsibility!

elementClass
	| vt |
	vt := self vartype.
	^vt == VT_RECORD
		ifTrue: 
			[| recInfo |
			recInfo := self recordInfo.
			Structure classForGUID: recInfo guid ifNone: [RecordClass recordInfo: recInfo]]
		ifFalse: [self class classForVT: vt]!

elementCount
	"Answer the <integer> element count of a VT_VECTOR or VT_ARRAY value; or 1 otherwise."

	^self subclassResponsibility!

elementSize
	^self elementClass elementSize!

externalArray: anExternalArray
	"Private - Initialize the receiver to hold a SAFEARRAY of appropriate vartype containing the elements copied from the <ExternalArray> argument."

	self subclassResponsibility!

filetime
	self subclassResponsibility!

filetime: aDateAndTimeObject
	"Private - Initialize the receiver to hold the best available variant representation of a <DateAndTime>, either VT_DATE or (preferably) VT_FILETIME."

	self subclassResponsibility!

float
	"Private - Answer the single precision floating point value from the receiver.
	Assumes the receiver is of type VT_R4."

	^self isByRef
		ifTrue: [FLOAT fromAddress: self refAddress owner: self fieldOwner]
		ifFalse: [bytes floatAtOffset: _OffsetOf_fltVal]!

float: aFloat
	"Private - Initialize the receiver to be a VT_R4 holding the specified single-precision <Float> value."

	bytes
		floatAtOffset: _OffsetOf_fltVal put: aFloat;
		uint16AtOffset: _OffsetOf_vt put: VT_R4!

floatVector
	"Private - Answer an <FLOATArray> containing the single precision floating-point values held by the receiver, assumed to be a VT_VECTOR or VT_ARRAY of VT_R4."

	"propvarutil is missing APIs to handle VT_R4 arrays/vectors, so we copy from either the CAFLT (VT_VECTOR) or SAFEARRAY (VT_ARRAY)."

	^self getVector!

floatVector: aFLOATArray
	"Private - Initialize the receiver to be a VT_VECTOR (counted array) or VT_ARRAY (SAFEARRAY) of VT_R4, containing single-precision floating-point values copied from the <FLOATArray> argument."

	self subclassResponsibility!

getArray: anInteger
	^self subclassResponsibility!

getSafeArray: anInteger
	^SAFEARRAY
		fromAddress: self pArray
		vt: (anInteger bitAnd: VT_TYPEMASK)
		owner: self!

getSafeArrayAsVector: anInteger
	| vector safearray |
	safearray := self getSafeArray: anInteger.
	vector := safearray asExternalArray.
	safearray free.
	^vector!

getValue
	| vt |
	^((vt := bytes uint16AtOffset: _OffsetOf_vt) anyMask: ##(VT_ARRAY | VT_VECTOR))
		ifTrue: [self getArray: vt]
		ifFalse: [self perform: (VTNames at: (vt bitAnd: VT_TYPEMASK) + 1)]!

getVector
	^self subclassResponsibility!

hresult
	"Private - Answer the status code (SCODE) from the receiver.
	N.B. Assumes that the receiver is of type VT_ERROR."

	^self isByRef
		ifTrue: [HRESULT fromAddress: self refAddress owner: self]
		ifFalse: [HRESULT fromInteger: (bytes int32AtOffset: _OffsetOf_lVal)]!

hresult: aHRESULT
	"Private - Initialize the receiver to be a VT_ERROR holding the specified <HRESULT> code."

	bytes
		int32AtOffset: _OffsetOf_lVal put: aHRESULT asInteger;
		uint16AtOffset: _OffsetOf_vt put: VT_ERROR!

hresultVector: aCollection
	"Private - Initialize the receiver to be hold a single-dimensioned array of HRESULTs copied from the argument."

	self subclassResponsibility!

initialize
	"Private - Initialize the receiver, which is a value (not pointer) instance.
	Note that this does not null out the data area of the variant, it just sets the type to VT_EMPTY."

	super initialize.
	self class init: bytes!

int16
	"Private - Answer the signed 16-bit integer value from the receiver.
	Assumes the receiver is of type VT_I2."

	^self isByRef
		ifTrue: [Int16 fromAddress: self refAddress owner: self fieldOwner]
		ifFalse: [bytes int16AtOffset: _OffsetOf_iVal]!

int16: anIngeger
	"Private - Initialize the receiver to be a VT_I2 holding the specified signed 16-bit <integer>."

	bytes
		int16AtOffset: _OffsetOf_iVal put: anIngeger asInteger;
		uint16AtOffset: _OffsetOf_vt put: VT_I2!

int16Vector
	"Private - Answer an <Int16Array> containing the signed 16-bit integer values held by the receiver, assumed to be a VT_VECTOR or VT_ARRAY of VT_I2."

	^self subclassResponsibility!

int16Vector: anInt16Array
	"Private - Initialize the receiver to be a VT_VECTOR (CAI) or VT_ARRAY (SAFEARRAY) of VT_I2, containing 16-bit signed integer values copied from the <Int16Array> argument."

	self subclassResponsibility!

int32
	"Private - Answer the signed 32-bit integer value from the receiver.
	Assumes the receiver is of type VT_I4."

	^self isByRef
		ifTrue: [Int32 fromAddress: self refAddress owner: self fieldOwner]
		ifFalse: [bytes int32AtOffset: _OffsetOf_lVal]!

int32: anInteger
	"Private - Initialize the receiver to be a VT_I4 holding the specified signed 32-bit <integer>."

	bytes
		int32AtOffset: _OffsetOf_lVal put: anInteger asInteger;
		uint16AtOffset: _OffsetOf_vt put: VT_I4!

int32Vector
	"Private - Answer an <Int32Array> containing the signed 32-bit integer values held by the receiver, assumed to be a VT_VECTOR or VT_ARRAY of VT_I4."

	^self subclassResponsibility!

int32Vector: anInt32Array
	"Private - Initialize the receiver to be a VT_VECTOR (CAL) or VT_ARRAY (SAFEARRAY) of VT_I4, containing 32-bit signed integer values copied from the <Int32Array> argument."

	self subclassResponsibility!

int64
	"Private - Answer the signed 64-bit integer value from the receiver.
	Assumes the receiver is of type VT_I8 (note that this is
	not currently a generally supported variant type but
	we implement for completeness)."

	^self isByRef 
		ifTrue: [Int64 fromAddress: self refAddress owner: self fieldOwner]
		ifFalse: [bytes int64AtOffset: _OffsetOf_llVal]!

int64: anInteger
	"Private - Initialize the receiver to be a VT_I8 holding the specified signed 64-bit <integer>."

	bytes
		int64AtOffset: _OffsetOf_llVal put: anInteger asInteger;
		uint16AtOffset: _OffsetOf_vt put: VT_I8!

int64Vector
	"Private - Answer an <Int64Array> containing the signed 64-bit integer values held by the receiver, assumed to be a VT_VECTOR or VT_ARRAY of VT_I4."

	^self subclassResponsibility!

int64Vector: anInt64Array
	"Private - Initialize the receiver to be a VT_VECTOR (CAH) or VT_ARRAY (SAFEARRAY) of VT_I8, containing 64-bit signed integer values copied from the <Int64Array> argument."

	self subclassResponsibility!

int8
	"Private - Answer the signed 8-bit <integer> value from the receiver.
	N.B. Assumes that the receiver is of type VT_I1."

	^self isByRef 
		ifTrue: [Int8 fromAddress: self refAddress owner: self fieldOwner]
		ifFalse: [bytes int8AtOffset: _OffsetOf_bVal]!

int8: anInteger
	"Private - Initialize the receiver to be a VT_I1 holding the specified signed 8-bit <integer>."

	| intVal |
	intVal := anInteger asInteger.
	(anInteger < -128 or: [anInteger > 127]) ifTrue: [self errorSubscriptBounds: intVal].
	bytes
		int8AtOffset: _OffsetOf_bVal put: anInteger asInteger;
		uint16AtOffset: _OffsetOf_vt put: VT_I1!

int8Vector
	"Private - Answer an <Int8Array> containing the signed 8-bit integer values held by the receiver, assumed to be a VT_VECTOR or VT_ARRAY of VT_I1."

	^self getVector!

int8Vector: anInt8Array
	"Private - Initialize the receiver to be a VT_VECTOR (counted array) or VT_ARRAY (SAFEARRAY) of VT_I1, containing 8-bit signed integer values copied from the <Int8Array> argument."

	self subclassResponsibility!

intptr
	^bytes intPtrAtOffset: _OffsetOf_pintVal!

intptr: newValue
	"Private - Initialize the receiver to hold a signed pointer-sized integer value.
	Note that although VT_INT_PTR exists as a vartype, this is only used in TYPEDESCs, and cannot appear in variants, so the result will be an initialized VT_I4 on a 32-bit system, or VT_I8 on a 64-bit system."

	VMConstants.IsWin64 ifTrue: [self int64: newValue] ifFalse: [self int32: newValue]!

isArray
	"Answer whether the receiver points at a SAFEARRAY."

	^(bytes uint16AtOffset: _OffsetOf_vt) allMask: VT_ARRAY!

isByRef
	"Private - Answer whether the receiver is a by-reference parameter."

	^(bytes uint16AtOffset: _OffsetOf_vt) allMask: VT_BYREF!

isDispatch
	"Answer whether the receiver wraps an <IDispatch> interface on a COM object."

	^(bytes uint16AtOffset: _OffsetOf_vt) == VT_DISPATCH!

isEmpty
	^(bytes uint16AtOffset: _OffsetOf_vt) == VT_EMPTY!

isObject
	"Answer whether the receiver wraps a COM object."

	| vt |
	vt := bytes uint16AtOffset: _OffsetOf_vt.
	^vt == VT_UNKNOWN or: [vt == VT_DISPATCH]!

isVtString
	^self subclassResponsibility!

largeInteger: aLargeInteger

	| words |
	words := aLargeInteger limbSize.
	words <= 1
		ifTrue: [self int32: aLargeInteger]
		ifFalse: 
			[words > 2
				ifTrue: 
					["Might error if too large (or negative)"
					self uint64: aLargeInteger]
				ifFalse: [self int64: aLargeInteger]]!

lpstr: aString
	"Private - Initialize the receiver to contain a copy of the <AnsiString> argument, using the preferred representation of the concrete subclass."

	self subclassResponsibility!

lpstrVector: anExternalArrayOfAnsiStrings
	"Private - Initialize the receiver to contain a vector holding copies of the ANSI strings in the <ExternalArray> argument, using the preferred representation of the concrete subclass."

	self subclassResponsibility!

lpvoid
	"Private - Answer an <ExternalAddress> corresponding to the VT_PTR value of the receiver."

	^self refAddress!

lpwstr: aString
	"Private - Initialize the receiver to contain a wide string (UTF-16) copy of the <String> argument, using the preferred representation of the concrete subclass."

	self subclassResponsibility!

lpwstrVector
	^self subclassResponsibility!

lpwstrVector: anExternalArrayOfWideStrings
	"Private - Initialize the receiver to contain a vector holding copies of the wide strings in the array argument, using the preferred representation of the concrete subclass."

	self subclassResponsibility!

needsFree
	"Private - Answer whether the receiver requires freeing of any external resources. Instances that are not owned elsewhere (e.g. pointer instances that reference into a VARIANTArray) will need to be VariantClear'd. This applies even for VT_BYREF, as there may be metadata that needs to be cleaned up, even if the value is considered referenced, for example VT_RECORD|VT_BYREF instances will hold a reference count on the IRecordInfo assigned into the pRecInfo field. Consequently we must free if there is no other owner."

	^owner isNil and: [self notNull]!

nil
	"Answer the nil value.
	N.B. Assumes that the receiver is of type VT_EMPTY."

	^nil!

nil: anUndefinedObject
	"Private - Initialize the receiver to be empty (VT_EMPTY)."

	bytes
		intPtrAtOffset: _OffsetOf_byref put: 0;
		uint16AtOffset: _OffsetOf_vt put: VT_EMPTY!

null
	"Private - Answer the null value.
	N.B. Assumes that the receiver is of type VT_NULL."

	^nil!

null: anUndefinedObject
	"Private - Initialize the receiver to be null (VT_NULL)."

	bytes
		intPtrAtOffset: _OffsetOf_byref put: 0;
		uint16AtOffset: _OffsetOf_vt put: VT_NULL!

pArray
	^self isByRef
		ifTrue: [self refAddress uintPtrAtOffset: 0]
		ifFalse: [bytes uintPtrAtOffset: _OffsetOf_parray]!

preferredVtString
	^self subclassResponsibility!

record
	"Private - Answer the structure value from the receiver.
	Assumes the receiver is of type VT_RECORD."

	data isNil
		ifTrue: 
			[data := Structure
						fromAddress: (bytes uintPtrAtOffset: _OffsetOf_pvRecord)
						recordInfo: self recordInfo
						owner: self].
	^data!

record: aStructure
	| piRecInfo copy |
	piRecInfo := aStructure recordInfo.
	copy := TaskMemory new.
	piRecInfo RecordCreateCopy: aStructure yourAddress ppvDest: copy.
	bytes
		uint32AtOffset: _OffsetOf_pRecInfo
			put: (piRecInfo
					addRef;
					yourAddress);
		uintPtrAtOffset: _OffsetOf_pvRecord put: copy detach;
		uint16AtOffset: _OffsetOf_vt put: VT_RECORD!

recordInfo
	"Private - Answer the <IRecordInfo> stored in the receiver.
	Assumes the receiver is of type VT_RECORD."

	^(self isArray
		ifTrue: 
			[| recInfo |
			recInfo := IRecordInfo newPointer.
			OleAut32 safeArrayGetRecordInfo: self pArray prinfo: recInfo.
			recInfo]
		ifFalse: [IRecordInfo fromAddress: (bytes uintPtrAtOffset: _OffsetOf_pRecInfo)]) asObject!

refAddress
	"Private - Answer the reference address from the receiver (assumes receiver is a VT_BYREF)."

	^Address fromInteger: (bytes uintPtrAtOffset: _OffsetOf_byref)!

reference: anObject
	"Private - Initialize the receiver to be a reference to the specified object (assumes receiver is a VT_BYREF)."

	data := anObject.
	bytes uintPtrAtOffset: _OffsetOf_byref put: anObject yourAddress.
	^self!

struct
	"Private - Answer the structure value from the receiver.
	Assumes the receiver is of type VT_RECORD."

	^self record!

struct: anExternalStructure
	"Private - Initialize the receiver to be hold a pure unowned reference to the <ExternalStructure> argument as user-defined type (VT_RECORD | VT_BYREF).
	N.B. Something else must be maintaining a reference to both the structure, and the IRecordInfo. VariantClear() does not even release the IRecordInfo for a VT_BYREF, so if we AddRef then the IRecordInfo will leak. This does mean it is very easy to create dangling pointers with VT_BYREF variants - they are dangerous."

	| piRecInfo |
	piRecInfo := anExternalStructure recordInfo.
	bytes uint32AtOffset: _OffsetOf_pRecInfo put: piRecInfo yourAddress.
	self reference: anExternalStructure.
	bytes uint16AtOffset: _OffsetOf_vt put: ##(VT_RECORD | VT_BYREF)!

systemTime
	"Private - Answer a SYSTEMTIME converted from the receiver's OLE
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
	"Private - Answer the unsigned 16-bit <integer> value from the receiver.
	Assumes the receiver is of type VT_UI2."

	^self isByRef
		ifTrue: [UInt16 fromAddress: self refAddress owner: self fieldOwner]
		ifFalse: [bytes uint16AtOffset: _OffsetOf_uiVal]!

uint16: anInteger
	"Private - Initialize the receiver to be a VT_UI2 holding the specified unsigned 16-bit <integer> value."

	bytes
		uint16AtOffset: _OffsetOf_uiVal put: anInteger asInteger;
		uint16AtOffset: _OffsetOf_vt put: VT_UI2!

uint16Vector
	"Private - Answer a <UInt16Array> containing the unsigned 16-bit integer values held by the receiver, assumed to be a VT_VECTOR or VT_ARRAY of VT_UI2."

	^self subclassResponsibility!

uint16Vector: aUInt16Array
	"Private - Initialize the receiver to be a VT_VECTOR (CAUI) or VT_ARRAY (SAFEARRAY) of VT_UI2, containing 16-bit unsigned integer values copied from the <UInt16Array> argument."

	self subclassResponsibility!

uint32
	"Private - Answer the unsigned 32-bit <integer> value from the receiver.
	Assumes the receiver is of type VT_UI4 (or at least of some unsigned
	32-bit integer type)."

	^self isByRef
		ifTrue: [UInt32 fromAddress: self refAddress owner: self fieldOwner]
		ifFalse: [bytes uint32AtOffset: _OffsetOf_ulVal]!

uint32: anInteger
	"Private - Initialize the receiver to be a VT_UI4 holding the specified unsigned 32-bit <integer> value."

	bytes
		uint32AtOffset: _OffsetOf_ulVal put: anInteger asInteger;
		uint16AtOffset: _OffsetOf_vt put: VT_UI4!

uint32Vector
	"Private - Answer a <UInt32Array> containing the unsigned 32-bit integer values held by the receiver, assumed to be a VT_VECTOR or VT_ARRAY of VT_UI4."

	^self subclassResponsibility!

uint32Vector: aUInt32Array
	"Private - Initialize the receiver to be a VT_VECTOR (CAUL) or VT_ARRAY (SAFEARRAY) of VT_UI4, containing 32-bit unsigned integer values copied from the <UInt32Array> argument."

	self subclassResponsibility!

uint64
	"Private - Answer the unsigned 64-bit integer value from the receiver.
	Assumes the receiver is of type VT_I8 (note that this is
	not currently a generally supported variant type but
	we implement for completeness)."

	^self isByRef
		ifTrue: [UInt64 fromAddress: self refAddress owner: self]
		ifFalse: [bytes uint64AtOffset: _OffsetOf_ullVal]!

uint64: anInteger
	"Private - Initialize the receiver to be a VT_UI8 holding the specified unsigned 64-bit <integer> value."

	bytes
		uint64AtOffset: _OffsetOf_ullVal put: anInteger asInteger;
		uint16AtOffset: _OffsetOf_vt put: VT_UI8!

uint64Vector
	"Private - Answer a <UInt64Array> containing the unsigned 64-bit integer values held by the receiver, assumed to be a VT_VECTOR or VT_ARRAY of VT_UI8."

	^self subclassResponsibility!

uint64Vector: aUInt64Array
	"Private - Initialize the receiver to be a VT_VECTOR (CAUH) or VT_ARRAY (SAFEARRAY) of VT_UI8, containing 64-bit unsigned integer values copied from the <UInt64Array> argument."

	self subclassResponsibility!

uint8
	"Private - Answer the unsigned 8-bit <integer> value from the receiver.
	N.B. Assumes that the receiver is of type VT_UI1."

	^self isByRef 
		ifTrue: [UInt8 fromAddress: self refAddress owner: self]
		ifFalse: [bytes uint8AtOffset: _OffsetOf_bVal]!

uint8: anInteger
	"Private - Initialize the receiver to be a VT_UI1 holding the specified unsigned 8-bit <integer> value."

	bytes
		uint8AtOffset: _OffsetOf_bVal put: anInteger asInteger;
		uint16AtOffset: _OffsetOf_vt put: VT_UI1!

uint8Vector
	"Private - Answer a <UInt8Array> containing the unsigned 8-bit integer values held by the receiver, assumed to be a VT_VECTOR or VT_ARRAY of VT_UI1."

	^self subclassResponsibility!

uint8Vector: aUInt8Array
	"Private - Initialize the receiver to be a VT_VECTOR (CAUB) or VT_ARRAY (SAFEARRAY) of VT_UI8, containing 8-bit unsigned integer values copied from the <UInt8Array> argument."

	self subclassResponsibility!

uintptr
	^bytes uintPtrAtOffset: _OffsetOf_pintVal!

uintptr: anInteger
	"Private - Initialize the receiver to be a VT_UI4 or VT_UI8 holding the specified unsigned pointer-sized <integer> value.
	Note that although VT_UINT_PTR exists as a vartype, this is only used in TYPEDESCs, and cannot appear in variants, so the result will be an initialized VT_UI4 on a 32-bit system, or VT_UI8 on a 64-bit system."

	VMConstants.IsWin64 ifTrue: [self uint64: anInteger] ifFalse: [self uint32: anInteger]!

unknown
	"Private - Answer the IUnknown pointer in the receiver. Assumes that the receiver is of type VT_UNKNOWN.
	Note that if the receiver is a by-reference variant then the answer is an untyped doubly-indirected pointer (i.e. its value is the address of the IDispatch pointer). If the reference is overwritten then the old interface pointer must be Release()d."

	^self isByRef
		ifTrue: [LPVOID fromAddress: (bytes uintPtrAtOffset: _OffsetOf_punkVal) owner: self fieldOwner]
		ifFalse: [IUnknown fromAddress: (bytes uintPtrAtOffset: _OffsetOf_punkVal)]!

unknown: newValue
	"Private - Set the <IUnknown> value, newValue, into the receiver."

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
	^self getValue!

value: newValue
	"Set the receiver's value to the <variantCompatible>, newValue."

	"Although we may not own the underlying data if we are a reference (pointer) instance, because we are going to overwrite it we must free it regardless. #basicFree can be repeated add infinitum on a VARIANT."
	self basicFree.
	newValue initializeVariant: self!

varbool
	"Private - Answer a Boolean corresponding to the VARIANT_BOOL value of the receiver (assumes the receiver is of type VT_BOOL)."

	^self isByRef
		ifTrue: [VARIANT_BOOL fromAddress: self refAddress owner: self fieldOwner]
		ifFalse: [(bytes int16AtOffset: _OffsetOf_boolVal) ~~ VARIANT_FALSE]!

varbool: anObject
	"Private - Initialize the receiver to be a VT_BOOL holding the VARIANT_BOOL value (0/-1) of the receiver to the <boolean> or <integer> argument."

	bytes
		int16AtOffset: _OffsetOf_boolVal
			put: (anObject asParameter == 0 ifTrue: [VARIANT_FALSE] ifFalse: [VARIANT_TRUE]);
		uint16AtOffset: _OffsetOf_vt put: VT_BOOL!

varBoolVector
	"Private - Answer a <VARIANT_BOOLArray> containing the VARIANT_BOOL values held by the receiver, assumed to be a VT_VECTOR or VT_ARRAY of VT_BOOL."

	^self getVector!

varBoolVector: aVARIANT_BOOLArray
	"Private - Initialize the receiver to be a VT_VECTOR (CABOOL) or VT_ARRAY (SAFEARRAY) of VT_BOOL, containing the VARIANT_BOOL values copied from the <aVARIANT_BOOLArray> argument."

	self subclassResponsibility!

variant
	"Private - Answer a <VARIANT> at the address specified in the receiver.
	N.B. Assumes that the receiver is of type VT_VARIANT|VT_BYREF."

	self assert: [self isByRef].
	^self class fromAddress: (bytes uintPtrAtOffset: _OffsetOf_pvarVal) owner: self fieldOwner!

variant: newValue
	"Private - Set the <VARIANT> value, newValue, into the receiver."

	self reference: newValue.
	bytes uint16AtOffset: _OffsetOf_vt put: ##(VT_VARIANT | VT_BYREF)!

variantVector
	"Private - Answer an <VARIANTArray> containing the VARIANT values held by the receiver. This assumes that the receiver is a (VT_ARRAY | VT_VARIANT)."

	^self getVector!

variantVector: anOleVariantArray
	"Private - Initialize the receiver to be hold a single-dimensioned array of variants copied from the argument."

	self subclassResponsibility!

vartype
	"Answer the receiver's basic variant type code without modifies such as VT_BYREF."

	^(bytes uint16AtOffset: _OffsetOf_vt) bitAnd: VT_TYPEMASK!

vectorMask
	^self subclassResponsibility!

void
	"Private - Answer the void value from the receiver, which is nil unless the receiver is VT_BYREF, in which case it is treated as a void* pointer. Assumes the receiver is of type VT_VOID."

	^self isByRef ifTrue: [VOID fromAddress: self refAddress owner: self fieldOwner]!

vt
	"Answer the <Integer> value of the receiver's 'vt' field."

	^bytes uint16AtOffset: _OffsetOf_vt!

vt: anInteger
	"Private - Set the receiver's 'vt' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_vt put: anInteger! !

!OS.COM.OleVariant categoriesForMethods!
_deepCopy:!copying!private! !
<!comparing!public! !
<=!comparing!public! !
=!comparing!public! !
>!comparing!public! !
>=!comparing!public! !
array!accessing!private! !
array:!initializing!private! !
arrayRef:!initializing!private! !
asExternalArray!converting!public! !
asString!converting!public! !
asVariant:!converting!public! !
badVarType!exceptions!private! !
basicFree!private!realizing/unrealizing! !
blob:!initializing!private! !
blobVector!accessing!private! !
boolVector!accessing!private! !
boolVector:!initializing!private! !
bstr!accessing!private! !
bstr:!initializing!private! !
bstrVector!accessing!private! !
bstrVector:!initializing!private! !
changeType:!converting!public! !
changeType:locale:!converting!public! !
char!accessing!private! !
clsid!accessing!private! !
clsid:!accessing!private! !
clsidVector!accessing!private! !
clsidVector:!initializing!private! !
cmp:!comparing!private! !
cy!accessing!private! !
cy:!initializing!private! !
cyVector!accessing!private! !
cyVector:!initializing!private! !
date!accessing!private! !
date:!initializing!private! !
dateVector!accessing!private! !
dateVector:!initializing!private! !
decimal!accessing!private! !
decimal:!initializing!private! !
decimalVector!accessing!private! !
decimalVector:!initializing!private! !
detach!public!realizing/unrealizing! !
dispatch:!initializing!private! !
displayArrayOn:!displaying!private! !
displayOn:!displaying!public! !
displayScalarOn:!displaying!private! !
double!accessing!private! !
double:!initializing!private! !
doubleVector!accessing!private! !
doubleVector:!initializing!private! !
elementClass!accessing!public! !
elementCount!accessing!public! !
elementSize!accessing!public! !
externalArray:!initializing!private! !
filetime!accessing!private! !
filetime:!initializing!private! !
float!accessing!private! !
float:!initializing!private! !
floatVector!accessing!private! !
floatVector:!initializing!private! !
getArray:!accessing!private! !
getSafeArray:!accessing!private! !
getSafeArrayAsVector:!accessing!private! !
getValue!accessing!private! !
getVector!accessing!private! !
hresult!accessing!private! !
hresult:!initializing!private! !
hresultVector:!initializing!private! !
initialize!initializing!private! !
int16!accessing!private! !
int16:!initializing!private! !
int16Vector!accessing!private! !
int16Vector:!initializing!private! !
int32!accessing!private! !
int32:!initializing!private! !
int32Vector!accessing!private! !
int32Vector:!initializing!private! !
int64!accessing!private! !
int64:!initializing!private! !
int64Vector!accessing!private! !
int64Vector:!initializing!private! !
int8!accessing!private! !
int8:!initializing!private! !
int8Vector!accessing!private! !
int8Vector:!initializing!private! !
intptr!accessing!private! !
intptr:!initializing!private! !
isArray!public!testing! !
isByRef!private!testing! !
isDispatch!public!testing! !
isEmpty!public!testing! !
isObject!public!testing! !
isVtString!public!testing! !
largeInteger:!instance creation!public! !
lpstr:!initializing!private! !
lpstrVector:!initializing!private! !
lpvoid!accessing!private! !
lpwstr:!initializing!private! !
lpwstrVector!accessing!private! !
lpwstrVector:!initializing!private! !
needsFree!private!realizing/unrealizing! !
nil!accessing!private! !
nil:!initializing!private! !
null!accessing!private! !
null:!initializing!private! !
pArray!accessing!private! !
preferredVtString!constants!private! !
record!accessing!private! !
record:!initializing!private! !
recordInfo!accessing!private! !
refAddress!accessing!private! !
reference:!initializing!private! !
struct!accessing!private! !
struct:!initializing!private! !
systemTime!accessing!private! !
typeName!accessing!public! !
uint16!accessing!private! !
uint16:!initializing!private! !
uint16Vector!accessing!private! !
uint16Vector:!initializing!private! !
uint32!accessing!private! !
uint32:!initializing!private! !
uint32Vector!accessing!private! !
uint32Vector:!initializing!private! !
uint64!accessing!private! !
uint64:!initializing!private! !
uint64Vector!accessing!private! !
uint64Vector:!initializing!private! !
uint8!accessing!private! !
uint8:!initializing!private! !
uint8Vector!accessing!private! !
uint8Vector:!initializing!private! !
uintptr!accessing!private! !
uintptr:!initializing!private! !
unknown!accessing!private! !
unknown:!initializing!private! !
value!accessing!public! !
value:!accessing!public! !
varbool!accessing!private! !
varbool:!initializing!private! !
varBoolVector!accessing!private! !
varBoolVector:!initializing!private! !
variant!accessing!private! !
variant:!initializing!private! !
variantVector!accessing!private! !
variantVector:!initializing!private! !
vartype!accessing!public! !
vectorMask!constants!private! !
void!accessing!private! !
vt!**compiled accessors**!public! !
vt:!initializing!public! !
!

!OS.COM.OleVariant class methodsFor!

classForVT: anInteger
	"Answer a class of object suitable for representing values of the specified Variant type (i.e. a value from the VT_XXX enumeration which describes a scalar type)."

	^self classForVT: anInteger ifNone: ['Unmapped var type ' , anInteger printString]!

classForVT: anInteger ifNone: aNiladicValuable
	"Answer a class of object suitable for representing values of the specified Variant type (i.e. a value from the VT_XXX enumeration which describes a scalar type)."

	^(VTClasses at: anInteger + 1)
		ifNil: [aNiladicValuable value]
		ifNotNil: [:bindingRef | bindingRef value]!

defineFields
	"Define the fields common to VARIANT/PROPVARIANT structures.

		self compileDefinition.

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
		defineField: #cyVal type: (StructureField type: CY) beFiller offset: 8;
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
		defineField: #pcyVal type: (PointerField type: CY) beFiller offset: 8;
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
		defineField: #pdecVal type: (PointerField type: DECIMAL) beFiller offset: 8;
		defineField: #pcVal type: (PointerField type: UInt8) beFiller offset: 8;
		defineField: #puiVal type: (PointerField type: UInt16) beFiller offset: 8;
		defineField: #pulVal type: (PointerField type: UInt32) beFiller offset: 8;
		defineField: #pullVal type: (PointerField type: UInt64) beFiller offset: 8;
		defineField: #pintVal type: (PointerField type: Int32) beFiller offset: 8;
		defineField: #puintVal type: (PointerField type: UInt32) beFiller offset: 8;
		defineField: #pvRecord type: LPVOIDField filler offset: 8;
		defineField: #pRecInfo type: (PointerField type: IRecordInfo) beFiller offset: (8+VMConstants.IntPtrSize);
		defineField: #decVal type: (StructureField type: DECIMAL) beFiller offset: 0.
	self assert: [self basicByteSize = (8 + (2 * VMConstants.IntPtrSize))]!

externalTypeNames
	^#(#{UInt8} #{Int8} #{UInt16} #{Int16} #{FLOAT} #{DOUBLE} #{UInt32} #{Int32} #{Int64} #{UInt64})!

fromBoolean: bool
	"Answer a new instance of the receiver of type VT_BOOL containing
	the VARIANT_BOOL equivalent of the <Boolean> value, bool."

	^self fromObject: bool!

fromCollection: aCollection 
	"Answer a new instance of the receiver of type VT_ARRAY|VT_XX containing the variant representations of the elements of the <collection> argument.
	Note that an error will be thrown if any of the objects in the collection cannot be stored individually in a VARIANT."

	^self fromObject: aCollection!

fromDATE: aDATE
	"Answer a new instance of the receiver of type VT_DATE containing
	the <DATE> equivalent of the argument."

	^self fromObject: aDATE!

fromDispatch: piDisp
	"Answer a new instance of the receiver of type VT_DISPATCH containing
	the <IDispatch> pointer, piDisp."

	^self fromObject: piDisp!

fromFloat: aFloat 
	"Answer a new instance of the receiver of type VT_DOUBLE containing the <Float> value, fValue."

	^self fromObject: aFloat!

fromInteger: anInteger
	"Answer a new instance of the receiver holding the specified <integer> value. The VT
	will be VT_I4 if the integer is in the 32-bit 2's complemente range, or a VT_I8 for
	the 64-bit 2's complement range, or VT_UI8 for 64-bit positive numbers that are
	greater than 2^63-1. It is an error if the argument is too large to be represented in 
	64 bits."

	^self fromObject: anInteger!

fromLargeInteger: aLargeInteger
	"Answer a new instance of the receiver holding the specified <LargeInteger> value.
	 The VT will be VT_I8 for the 64-bit 2's complement range, or VT_UI8 for 64-bit positive 
	numbers that are greater than 2^63-1. It is an error if the argument is too large to be 
	represented in 64 bits."

	^self fromObject: aLargeInteger!

fromObject: anObject
	"Answer a new instance of the receiver of the best type to wrap the <Object> argument."

	| variant |
	variant := self new.
	anObject initializeVariant: variant.
	^variant!

fromScaledDecimal: aScaledDecimal
	^self fromObject: aScaledDecimal!

fromSmallInteger: aSmallInteger
	"Answer a new VT_I4/VT_I8 instance of the receiver holding the specified <SmallInteger> value.
	It is an error if the argument is too large to be represented in 32/64 bits."

	^self fromObject: aSmallInteger!

fromString: aString
	"Answer a new VT_BSTR or VT_LPWSTR or VT_LPSTR instance of the receiver pointing at a copy of the <readableString> argument. The vartype will depend on the concrete subclass of the receiver being instantiated and the class of <String>."

	^self fromObject: aString!

fromUnknown: piUnk
	"Answer a new instance of the receiver of type VT_UNKNOWN containing
	the <IUnknown> pointer, piUnk."

	^self fromObject: piUnk!

initialize
	"Private - Initialize the receiver's class variables.
		VARIANT initialize
	"

	self addClassConstant: 'VTNames' value: self vtNames.
	self addClassConstant: 'VTClasses' value: self vtClasses.
	self externalTypeNames do: [:each | VM registryAt: each asSymbol put: each value]!

nameOfVT: vartype
	"Answer the symbolic name of the specified variant type code."

	| vtName |
	vtName := VTNames at: vartype + 1.
	^vtName == #badVarType ifTrue: [VTNames errorNotFound: vartype] ifFalse: [vtName]!

newSAFEARRAY: anInteger
	"Private - Answer a new SAFEARRAY initialized to hold <integer>, anInteger, instances of the receiver."

	^SAFEARRAY
		length: anInteger
		vt: VT_VARIANT
		elementClass: self!

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

	"The VM only needs a ref to certain classes to implement the VARIANT>>value primitive, so these can be
	 cleared out if this class is removed."
	self externalTypeNames do: [:each | VM registryAt: each asSymbol put: nil]!

variantVectorName
	"Private - Answer the symbolic name of the accessor for a variant holding a vector of the receiver's element type."

	^#variantVector!

vt
	"Answer the VARTYPE (one of the VT_XXX constants) used to describe the receiver's 
	type when represented in a <VARIANT>."

	^VT_VARIANT!

vtClasses
	^(Array new: VT_VERSIONED_STREAM + 1)
		at: VT_BLOB + 1 put: #{OS.COM.BLOB};
		at: VT_BLOB_OBJECT + 1 put: #{Core.ByteArray};
		at: VT_BOOL + 1 put: #{OS.COM.VARIANT_BOOL};
		at: VT_BSTR + 1 put: #{OS.COM.BSTR};
		at: VT_CARRAY + 1 put: #{External.Array};
		at: VT_CF + 1 put: #{External.UInt32};
		at: VT_CLSID + 1 put: #{OS.COM.CLSID};
		at: VT_CY + 1 put: #{OS.COM.CY};
		at: VT_DATE + 1 put: #{OS.COM.DATE};
		at: VT_DECIMAL + 1 put: #{OS.COM.DECIMAL};
		at: VT_DISPATCH + 1 put: #{OS.COM.IDispatch};
		at: VT_EMPTY + 1 put: #{Core.UndefinedObject};
		at: VT_ERROR + 1 put: #{OS.HRESULT};
		at: VT_FILETIME + 1 put: #{OS.FILETIME};
		at: VT_I1 + 1 put: #{External.Int8};
		at: VT_I2 + 1 put: #{External.Int16};
		at: VT_I4 + 1 put: #{External.Int32};
		at: VT_I8 + 1 put: #{External.Int64};
		at: VT_INT + 1 put: #{External.Int32};
		at: VT_LPSTR + 1 put: #{Core.AnsiString};
		at: VT_LPWSTR + 1 put: #{Core.Utf16String};
		at: VT_NULL + 1 put: #{Core.UndefinedObject};
		at: VT_PTR + 1 put: #{External.Address};
		at: VT_R4 + 1 put: #{External.FLOAT};
		at: VT_R8 + 1 put: #{External.DOUBLE};
		at: VT_SAFEARRAY + 1 put: #{OS.COM.SAFEARRAY};
		at: VT_STORAGE + 1 put: #{OS.COM.IStorage};
		at: VT_STORED_OBJECT + 1 put: #{OS.COM.IStorage};
		at: VT_STREAM + 1 put: #{OS.COM.IStream};
		at: VT_STREAMED_OBJECT + 1 put: #{OS.COM.IStream};
		at: VT_UINT + 1 put: #{External.UInt32};
		at: VT_UI1 + 1 put: #{External.UInt8};
		at: VT_UI2 + 1 put: #{External.UInt16};
		at: VT_UI4 + 1 put: #{External.UInt32};
		at: VT_UI8 + 1 put: #{External.UInt64};
		at: VT_UNKNOWN + 1 put: #{OS.COM.IUnknown};
		at: VT_USERDEFINED + 1 put: #{OS.COM.Record};
		at: VT_RECORD + 1 put: nil;
		at: VT_VARIANT + 1 put: #{OS.COM.VARIANT};
		at: VT_VOID + 1 put: #{External.VOID};
		at: VT_HRESULT + 1 put: #{OS.HRESULT};
		at: VT_INT_PTR + 1 put: #{External.IntPtr};
		at: VT_UINT_PTR + 1 put: #{External.UIntPtr};
		at: VT_VERSIONED_STREAM + 1 put: #{OS.COM.IStream};
		yourself!

vtNames 
	^(Array new: VT_VERSIONED_STREAM+1 withAll: #badVarType)
		at: VT_BLOB+1			put: #blob;			"Blob - OLE Property sets only"
		at: VT_BLOB_OBJECT+1		put: #blob_object;		"Blob containing an object - OLE Property sets only"
		at: VT_BOOL+1			put: #varbool;			"VARIANT_BOOL - i.e. True=-1, False=0"
		at: VT_BSTR+1				put: #bstr;			"Automation (Basic) String"
		at: VT_CARRAY+1			put: #carray;			"C-style array - TYPEDESC only"
		at: VT_CF+1				put: #clipdata;			"Clipboard format - Legacy OLE Property sets only. Not supported in Dolphin."
		at: VT_CLSID+1			put: #clsid;			"Class ID - OLE Property sets only"
		at: VT_CY+1				put: #cy;				"Automation Currency (fixed-point number)"
		at: VT_DATE+1				put: #date;			"Automation (double) date"
		at: VT_DECIMAL+1			put: #decimal;			"14-byte fixed-point number"
		at: VT_DISPATCH+1			put: #dispatch;		"IDispatch pointer"
		at: VT_EMPTY+1			put: #nil;				"nil (in ST) or Nothing (in VB)"
		at: VT_ERROR+1			put: #hresult;			"Status code (SCODE)"
		at: VT_FILETIME+1			put: #filetime;			"FILETIME - OLE Property sets only"
		at: VT_HRESULT+1			put: #hresult;			"HRESULT return code - TYPEDESC only"
		at: VT_I1+1				put: #int8;			"Signed 8-bit integer"
		at: VT_I2+1				put: #int16;			"Signed 16-bit integer"
		at: VT_I4+1				put: #int32;			"Signed 32-bit integer"
		at: VT_I8+1				put: #int64;			"Signed 64-bit integer - OLE Property Sets and TYPEDESC only"
		at: VT_INT+1				put: #int32;			"Signed machine dependent integer - TYPEDESC only"
		at: VT_LPSTR+1			put: #lpstr;			"Null-terminated ANSI string - OLE Property Sets and TYPEDESC only"
		at: VT_LPWSTR+1			put: #lpwstr;			"Null-terminated UTF-16 string - OLE Property Sets and TYPEDESC only"
		at: VT_NULL+1			put: #null;			"SQL Null (i.e. nil)"
		at: VT_PTR+1				put: #lpvoid;			"Pointer type - TYPEDESC only"
		at: VT_R4+1				put: #float;			"Single precision floating point"
		at: VT_R8+1				put: #double;			"Double precision floating point"
		at: VT_SAFEARRAY+1		put: #array;		"As VT_ARRAY, but TYPEDESC only"
		at: VT_STORAGE+1			put: #storage;			"Name of storage - OLE Property Sets only"
		at: VT_STORED_OBJECT+1	put: #stored_object;	"Storage containing object - OLE Property Sets only"
		at: VT_STREAM+1			put: #stream;			"Name of storage - OLE Property Sets only"
		at: VT_STREAMED_OBJECT+1	put: #streamed_object;	"Stream containing object - OLE Property Sets only"
		at: VT_UINT+1				put: #uint32;			"unsigned machine dependent integer - TYPEDESC/Property Sets only"
		at: VT_UI1+1				put: #uint8;			"Unsigned 8-bit integer"
		at: VT_UI2+1				put: #uint16;			"Unsigned 16-bit integer"
		at: VT_UI4+1				put: #uint32;			"Unsigned 32-bit integer"
		at: VT_UI8+1				put: #uint64;			"Unsigned 64-bit integer - OLE Property Sets and TYPEDESC only"
		at: VT_UNKNOWN+1		put: #unknown;		"IUnknown pointer"
		at: VT_USERDEFINED+1		put: #typedef;			"user defined type - TYPEDESC only"
		at: VT_RECORD+1			put: #record;
		at: VT_VARIANT+1			put: #variant;			"Reference to another VARIANT"
		at: VT_VOID+1			put: #void;			"C void - TYPEDESC only"
		at: VT_INT_PTR+1			put: #intptr;			"signed machine register size width - TYPEDESC only"
		at: VT_UINT_PTR+1			put: #uintptr;			"unsigned machine register size width - TYPEDESC only"
		at: VT_VERSIONED_STREAM+1 put: #versioned_stream; "Stream with a GUID version"
		yourself! !

!OS.COM.OleVariant class categoriesForMethods!
classForVT:!enquiries!public! !
classForVT:ifNone:!public! !
defineFields!public!template definition! !
externalTypeNames!constants!private! !
fromBoolean:!instance creation!public! !
fromCollection:!instance creation!public! !
fromDATE:!instance creation!public! !
fromDispatch:!instance creation!public! !
fromFloat:!instance creation!public! !
fromInteger:!instance creation!public! !
fromLargeInteger:!instance creation!public! !
fromObject:!instance creation!public! !
fromScaledDecimal:!converting!public! !
fromSmallInteger:!instance creation!public! !
fromString:!instance creation!public! !
fromUnknown:!instance creation!public! !
initialize!development!initializing!private! !
nameOfVT:!enquiries!public! !
newSAFEARRAY:!double dispatch!private! !
null!instance creation!public! !
typeName!constants!private! !
uninitialize!class hierarchy-removing!private! !
variantVectorName!constants!private! !
vt!constants!public! !
vtClasses!constants!private! !
vtNames!constants!must not strip!private! !
!

