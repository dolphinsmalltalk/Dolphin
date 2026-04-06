"Filed out from Dolphin Smalltalk"!

OS.COM.OleVariant
	subclass: #'OS.COM.VARIANT'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { 'VARCMP_NULL' -> 16r3 }!

OS.COM.VARIANT guid: (Core.GUID fromString: '{c06f3b65-0868-11d3-93af-00a024ca708a}')!

OS.COM.VARIANT comment: '`VARIANT` is an `External.Structure` to represent the OLE Automation VARIANT and VARIANTARG types.

A VARIANT is basically a discriminated union which can represent all the parameter types which can be passed to and returned from member functions of Automation compatible (oleautomation) interfaces by Automation controllers and servers. These types are constrained by those which VB can handle, and hence there are no unsigned integers. A VARIANT''s type tag is stored as a 16-bit <integer> at the start of the structure, and is accessing with the #vt/vt: methods. Note that not all of the VT_XXX types are actually supported by the various variant manipulation functions provided by the Automation library, e.g. VT_LPSTR, as some are intended for the Property Storage form (PROPVARIANT), type description and other purposes.

One complexity of VARIANTs worth noting is that they may, when used as arguments (i.e. VARIANTARGs) be used to pass parameters by reference. In this case they contain a pointer to the actual data, and the flag VT_BYREF is bitOr''d with the basic VT_XX data type tag. Dolphin handles this usage transparently such that no difference is perceived by users of this class.

It is worth noting that with the default Win32 packing (Zp8), VARIANT aligns on 8 byte boundaries, and may therefore make structures in which it is embedded larger than expected (this is handled correctly by Dolphin''s structure packing algorithm).

Class Variables:
	VTNames		<LookupTable> mapping variant type codes to selectors extracting an object of that type.
'!

!OS.COM.VARIANT categoriesForClass!External-Data-Structured-COM! !

!OS.COM.VARIANT methodsFor!

blob: aByteObject
	self uint8Vector: aByteObject asByteArray!

blobVector
	"Private - Answer a <UInt8Array> containing the receiver's byte data held by the receiver, assumed to be of (VT_ARRAY | VT_I1)."

	^self getVector!

boolVector
	"Private - Answer a <BOOLArray> representing the VARIANT_BOOL elements of the receiver. An error will be thrown if the receiver is not of type VT_VECTOR or VT_ARRAY of VT_BOOL.
	Note that BOOLArray's hold 32-bit BOOL (0/1) values, not 16-bit VARIANT_BOOL (0/-1) values."

	| array count |
	array := BOOLArray new: (count := self elementCount).
	Propsys
		variantToBooleanArray: self
		prgf: array
		crgn: count
		pcElem: (ByteArray newFixed: 4).
	^array!

boolVector: aVarBoolArray
	"Private - Initialize the receiver from the array of `BOOL` argument. Note that the `BOOL` is a 32-bit 0/1 representation of boolean values, but that the resulting variant will contain a VT_ARRAY (SAFEARRAY) of VT_BOOL, which uses the 16-bit VARIANT_BOOL (0/-1) representation. This inconsistency is inherent in the API."

	Propsys
		initVariantFromBooleanArray: aVarBoolArray
		cElems: aVarBoolArray length
		pvar: self!

bstrVector: anArrayOfStrings
	"Private - Initialize the receiver to contain a (VT_ARRAY | VT_BSTR), i.e. <SAFEARRAY> of <BSTR>, holding copies of the strings in the argument."

	self lpwstrVector:  (Utf16StringArray withAll: anArrayOfStrings)!

clsid
	"Private - Answer the CLSID value from the receiver.
	Assumes the receiver is of type VT_RECORD and the record is a _CLSID."

	^self record value!

clsid: aCLSID
	"Private - Set the CLSID value from the receiver."

	self record: aCLSID!

clsidVector: aGUIDArray
	"Private - Initialize the receiver to be hold a single-dimensioned array of CLSIDs copied from the argument."

	self externalArray: aGUIDArray!

cmp: anObject
	"Private - Answer a comparison value indicating the relationship between the receiver and the <VARIANT> value of the argument."

	| cmp varRight |
	varRight := anObject asVariant.
	cmp := OleAut32
				varCmp: self
				pvarRight: varRight
				lcid: Locale.LOCALE_USER_DEFAULT
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

cyVector: aCYArray
	"Private - Initialize the receiver to contain a VT_VECTOR (CACY) or VT_ARRAY (SAFEARRAY of VT_CY)>, holding copies of the <CY> values in the <ExternalArray> argument."

	self externalArray: aCYArray!

dateVector: aDATEArray
	"Private - Initialize the receiver to be hold a single-dimensioned array of DATEs copied from the argument."

	self externalArray: aDATEArray!

dispatch
	"Private - Answer an IDispatch pointer from the receiver, or nil if empty. 
	Assumes that the receiver is of type VT_DISPATCH.
	Note that if the receiver is a by-reference variant then the answer
	is an untyped doubly-indirected pointer (i.e. its value is the address
	of the IDispatch pointer). If the reference is overwritten then the old
	interface pointer must be Release()d."

	^(self isByRef ifTrue: [LPVOID] ifFalse: [IDispatch])
		fromAddress: (bytes uintPtrAtOffset: _OffsetOf_pdispVal)!

doubleVector
	| array count |
	array := DOUBLEArray new: (count := self elementCount).
	Propsys
		variantToDoubleArray: self
		prgn: array
		crgn: count
		pcElem: (ByteArray newFixed: 4).
	^array!

doubleVector: aDOUBLEArray
	"Private - Initialize the receiver to be of type (VT_ARRAY | VT_R8), containing a SAFEARRAY holding double-precision floating-point values copied from the <DOUBLEArray> argument."

	Propsys
		initVariantFromDoubleArray: aDOUBLEArray
		cElems: aDOUBLEArray length
		pvar: self!

elementCount
	"Answer the <integer> element count of a VT_ARRAY value; or 1 otherwise."

	^Propsys variantGetElementCount: self!

externalArray: anExternalArray
	"Private - Initialize the receiver to hold a SAFEARRAY of appropriate vartype containing the elements copied from the <ExternalArray> argument."

	| sa |
	sa := anExternalArray asSAFEARRAY.
	sa == anExternalArray ifTrue: [sa := sa copy].
	self array: sa!

filetime
	"Private - Answer the FILETIME value from the receiver.
	Assumes the receiver is of type VT_FILETIME."

	| answer |
	answer := FILETIME new.
	Propsys variantToFileTime: self pstfOut: PSTF_UTC pftOut: answer.
	^answer!

filetime: aDateAndTimeObject
	"Private - Initialize the receiver to hold the best available VARIANT representation of a <DateAndTime>, which in this case is VT_DATE. As variant timestamps have quite limited range and precision down to seconds only, precise round-tripping of Smalltalk <DateAndTime> objects, or even Win32 <FILETIME>s, is not possible."

	"We don't use InitVariantFromFileTime because it throws away sub-second precision, which is not necessary."
	self date: aDateAndTimeObject asDATE!

floatVector: aFLOATArray
	"Private - Initialize the receiver to be a VT_ARRAY (SAFEARRAY) of VT_R4, containing single-precision floating-point values copied from the <FLOATArray> argument."

	"There is no propvarutil API to initialize a VARIANT with a native arrays of FLOATs, even though one exists for PROPVARIANT. We can just use our general purpose conversion to SAFEARRAY and detach the result into the variant."

	self array: aFLOATArray asSAFEARRAY!

getArray: anInteger
	^self getSafeArray: anInteger!

getVector
	^self getSafeArrayAsVector: (bytes uint16AtOffset: _OffsetOf_vt)!

hresultVector: anHRESULTArray
	"Private - Initialize the receiver to be hold a single-dimensioned array of HRESULTs copied from the argument."

	self externalArray: anHRESULTArray!

initializeFromVariant: aVARIANT
	"Private - Source and dest same type, so just a copy"

	OleAut32 variantCopy: self pvargSrc: aVARIANT!

initializeVariant: anOleVariant
	"Private - Initialize another VARIANT or PROPVARIANT from this VARIANT. If the target is a VARIANT, we want to just copy to it. If a PROPVARIANT, we want to widen to the richer type system."

	anOleVariant initializeFromVariant: self!

int16Vector
	"Private - Answer an <Int16Array> containing the signed 16-bit integer values held by the receiver, assumed to be of type (VT_ARRAY | VT_I2)."

	| array count |
	array := Int16Array new: (count := self elementCount).
	Propsys
		variantToInt16Array: self
		prgn: array
		crgn: count
		pcElem: (ByteArray newFixed: 4).
	^array!

int16Vector: anInt16Array
	"Private - Initialize the receiver to be of type (VT_ARRAY | VT_I2), containing a SAFEARRAY holding 16-bit signed integer values copied from the <Int16Array> argument."

	Propsys
		initVariantFromInt16Array: anInt16Array
		cElems: anInt16Array length
		pvar: self!

int32Vector
	"Private - Answer an <Int32Array> containing the signed 32-bit integer values held by the receiver, assumed to be of type (VT_ARRAY | VT_I4)."

	| array count |
	array := Int32Array new: (count := self elementCount).
	Propsys
		variantToInt32Array: self
		prgn: array
		crgn: count
		pcElem: (ByteArray newFixed: 4).
	^array!

int32Vector: anInt32Array
	"Private - Initialize the receiver to be of type (VT_ARRAY | VT_I4), containing a SAFEARRAY holding 32-bit signed integer values copied from the <Int32Array> argument."

	Propsys
		initVariantFromInt32Array: anInt32Array
		cElems: anInt32Array length
		pvar: self!

int64Vector
	"Private - Answer an <Int64Array> containing the signed 64-bit integer values held by the receiver, assumed to be of type (VT_ARRAY | VT_I8)."

	| array count |
	array := Int64Array new: (count := self elementCount).
	Propsys
		variantToInt64Array: self
		prgn: array
		crgn: count
		pcElem: (ByteArray newFixed: 4).
	^array!

int64Vector: anInt64Array
	"Private - Initialize the receiver to be of type (VT_ARRAY | VT_I8), containing a SAFEARRAY holding 64-bit signed integer values copied from the <Int64Array> argument."

	Propsys
		initVariantFromInt64Array: anInt64Array
		cElems: anInt64Array length
		pvar: self!

int8Vector: anInt8Array
	"Private - Initialize the receiver to be of type (VT_ARRAY | VT_I1), containing a SAFEARRAY holding 8-bit signed integer values (i.e. signed bytes) copied from the <Int8Array> argument."

	Propsys
		initVariantFromBuffer: anInt8Array
		cb: anInt8Array size
		pvar: self.
	self vt: ##(VT_ARRAY | VT_I1)!

isVtString
	^(bytes uint16AtOffset: _OffsetOf_vt) == VT_BSTR!

lpstr: anAnsiString
	"Private - Initialize the receiver to contain a VT_BSTR, i.e. <BSTR>, copy of the <AnsiString> argument."

	bytes
		uintPtrAtOffset: _OffsetOf_bstrVal put: anAnsiString asAnsiString asBSTR detach;
		uint16AtOffset: _OffsetOf_vt put: VT_BSTR!

lpstrVector
	"Private - Answer a <AnsiStringArray> containing ANSI string encodings of the <BSTR> elements of the <SAFEARRAY> held by the receiver. An error will be thrown if the receiver is not of type VT_ARRAY | VT_BSTR."

	| wideStrings count ansiStrings |
	wideStrings := self lpwstrVector.
	count := wideStrings size.
	ansiStrings := AnsiStringArray new: count.
	1 to: count do: [:i | ansiStrings uncheckedAt: i put: (wideStrings uncheckedAt: i) asAnsiString].
	wideStrings free.
	^ansiStrings!

lpstrVector: anExternalArrayOfStrings
	"Private - Initialize the receiver to contain a (VT_ARRAY | VT_BSTR), i.e. <SAFEARRAY> of <BSTR>, holding copies of the ANSI strings in the <ExternalArray> argument."

	self externalArray: anExternalArrayOfStrings!

lpwstr: aString
	"Private - Initialize the receiver to contain a VT_BSTR, i.e. <BSTR>, copy of the <String> argument."

	Propsys initVariantFromString: aString pvar: self!

lpwstrVector
	"Private - Answer a <LPWSTRArray> representing the wide string elements of the receiver. An error will be thrown if the receiver is not of type VT_ARRAY | VT_BSTR."

	| array count |
	array := LPWSTRArray new: (count := self elementCount).
	Propsys
		variantToStringArray: self
		prgsz: array
		crgsz: count
		pcElem: (ByteArray newFixed: 4).
	^array!

lpwstrVector: anExternalArrayOfWideStrings
	"Private - Initialize the receiver to contain a (VT_ARRAY | VT_BSTR), i.e. <SAFEARRAY> of <BSTR>, holding copies of the strings in the <LPWSTRArray> argument."

	Propsys
		initVariantFromStringArray: anExternalArrayOfWideStrings
		cElems: anExternalArrayOfWideStrings length
		pvar: self!

preferredVtString
	^VT_BSTR!

uint16Vector
	"Private - Answer an <Int16Array> containing the unsigned 16-bit integer values held by the receiver, assumed to be of (VT_ARRAY | VT_UI2)."

	| array count |
	array := UInt16Array new: (count := self elementCount).
	Propsys
		variantToUInt16Array: self
		prgn: array
		crgn: count
		pcElem: (ByteArray newFixed: 4).
	^array!

uint16Vector: aUInt16Array
	"Private - Initialize the receiver to be of type (VT_ARRAY | VT_UI2), containing a SAFEARRAY holding 16-bit unsigned integer values copied from the <UInt16Array> argument."

	Propsys
		initVariantFromUInt16Array: aUInt16Array
		cElems: aUInt16Array length
		pvar: self!

uint32Vector
	"Private - Answer an <Int32Array> containing the unsigned 32-bit integer values held by the receiver, assumed to be of (VT_ARRAY | VT_UI4)."

	| array count |
	array := UInt32Array new: (count := self elementCount).
	Propsys
		variantToUInt32Array: self
		prgn: array
		crgn: count
		pcElem: (ByteArray newFixed: 4).
	^array!

uint32Vector: aUInt32Array
	"Private - Initialize the receiver to be of type (VT_ARRAY | VT_UI4), containing a SAFEARRAY holding 32-bit unsigned integer values copied from the <UInt32Array> argument."

	Propsys
		initVariantFromUInt32Array: aUInt32Array
		cElems: aUInt32Array length
		pvar: self!

uint64Vector
	"Private - Answer an <Int64Array> containing the unsigned 64-bit integer values held by the receiver, assumed to be of (VT_ARRAY | VT_UI8)."

	| array count |
	array := UInt64Array new: (count := self elementCount).
	Propsys
		variantToUInt64Array: self
		prgn: array
		crgn: count
		pcElem: (ByteArray newFixed: 4).
	^array!

uint64Vector: aUInt64Array
	"Private - Initialize the receiver to be of type (VT_ARRAY | VT_UI8), containing a SAFEARRAY holding 64-bit unsigned integer values copied from the <UInt64Array> argument."

	Propsys
		initVariantFromUInt64Array: aUInt64Array
		cElems: aUInt64Array length
		pvar: self!

uint8Vector
	"Private - Answer an <Int64Array> containing the unsigned 8-bit integer values (i.e. bytes) held by the receiver, assumed to be of (VT_ARRAY | VT_UI1)."

	| array count |
	array := UInt8Array new: (count := self elementCount).
	Propsys
		variantToBuffer: self
		pv: array
		cb: count.
	^array!

uint8Vector: aUInt8Array
	"Private - Initialize the receiver to be of type (VT_ARRAY | VT_UI1), containing a SAFEARRAY holding 8-bit unsigned integer values (i.e. bytes) copied from the <UInt8Array> argument."

	Propsys
		initVariantFromBuffer: aUInt8Array
		cb: aUInt8Array size
		pvar: self!

varBoolVector: aVARIANT_BOOLArray
	"Private - Initialize the receiver from the array of `VARIANT_BOOL` argument, resulting in a (VT_ARRAY | VT_BOOL) containing copies of the VARIANT_BOOL values in the argument."

	self array: aVARIANT_BOOLArray asSAFEARRAY!

variantVector: anOleVariantArray
	"Private - Initialize the receiver to be hold a single-dimensioned array of variants copied from the argument."

	self externalArray: anOleVariantArray!

vectorMask
	^VT_ARRAY! !

!OS.COM.VARIANT categoriesForMethods!
blob:!initializing!private! !
blobVector!accessing!private! !
boolVector!accessing!private! !
boolVector:!initializing!private! !
bstrVector:!initializing!private! !
clsid!accessing!private! !
clsid:!initializing!private! !
clsidVector:!initializing!private! !
cmp:!comparing!private! !
copy!copying!public! !
cyVector:!initializing!private! !
dateVector:!initializing!private! !
dispatch!accessing!private! !
doubleVector!accessing!private! !
doubleVector:!initializing!private! !
elementCount!accessing!public! !
externalArray:!initializing!private! !
filetime!accessing!private! !
filetime:!initializing!private! !
floatVector:!initializing!private! !
getArray:!accessing!private! !
getVector!accessing!private! !
hresultVector:!initializing!private! !
initializeFromVariant:!converting!double dispatch!private! !
initializeVariant:!converting!private! !
int16Vector!accessing!private! !
int16Vector:!initializing!private! !
int32Vector!accessing!private! !
int32Vector:!initializing!private! !
int64Vector!accessing!private! !
int64Vector:!initializing!private! !
int8Vector:!initializing!private! !
isVtString!public!testing! !
lpstr:!initializing!private! !
lpstrVector!accessing!private! !
lpstrVector:!initializing!private! !
lpwstr:!initializing!private! !
lpwstrVector!accessing!private! !
lpwstrVector:!initializing!private! !
preferredVtString!constants!private! !
uint16Vector!accessing!private! !
uint16Vector:!initializing!private! !
uint32Vector!accessing!private! !
uint32Vector:!initializing!private! !
uint64Vector!accessing!private! !
uint64Vector:!initializing!private! !
uint8Vector!accessing!private! !
uint8Vector:!initializing!private! !
varBoolVector:!initializing!private! !
variantVector:!initializing!private! !
vectorMask!constants!private! !
!

!OS.COM.VARIANT class methodsFor!

arrayType
	"Answer the class of object (typically an <ExternalArray> subclass) to be used to represent arrays of the receiver's field type in other structures."

	^VARIANTArray!

clear: addressOrBytes
	"Free a VARIANT at the specified address."

	OleAut32 variantClear: addressOrBytes!

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
	VM registryAt: self name put: self!

uninitialize
	"Private - Uninitialize the receiver prior to its removal from the image."

	Unspecified := nil.
	VM registryAt: self name put: nil!

unspecified
	"Answer an instance of the receiver appropriate to use as an unspecified optional argument."

	^Unspecified! !

!OS.COM.VARIANT class categoriesForMethods!
arrayType!constants!public! !
clear:!public!realizing/unrealizing! !
init:!initializing!public! !
initialize!development!initializing!private! !
uninitialize!class hierarchy-removing!private! !
unspecified!instance creation!public! !
!

