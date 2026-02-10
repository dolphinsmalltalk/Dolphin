"Filed out from Dolphin Smalltalk"!

OS.COM.OleVariant
	subclass: #'OS.COM.PROPVARIANT'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_OffsetOf___OBSOLETE__VARIANT_BOOL' -> 16r8.
			'_OffsetOf_blob' -> 16r8.
			'_OffsetOf_bstrblobVal' -> 16r8.
			'_OffsetOf_cabool' -> 16r8.
			'_OffsetOf_cabstr' -> 16r8.
			'_OffsetOf_cac' -> 16r8.
			'_OffsetOf_cacy' -> 16r8.
			'_OffsetOf_cadate' -> 16r8.
			'_OffsetOf_cadbl' -> 16r8.
			'_OffsetOf_cafiletime' -> 16r8.
			'_OffsetOf_caflt' -> 16r8.
			'_OffsetOf_cah' -> 16r8.
			'_OffsetOf_cai' -> 16r8.
			'_OffsetOf_cal' -> 16r8.
			'_OffsetOf_calpstr' -> 16r8.
			'_OffsetOf_calpwstr' -> 16r8.
			'_OffsetOf_capropvar' -> 16r8.
			'_OffsetOf_cascode' -> 16r8.
			'_OffsetOf_caub' -> 16r8.
			'_OffsetOf_cauh' -> 16r8.
			'_OffsetOf_caui' -> 16r8.
			'_OffsetOf_caul' -> 16r8.
			'_OffsetOf_cauuid' -> 16r8.
			'_OffsetOf_filetime' -> 16r8.
			'_OffsetOf_hVal' -> 16r8.
			'_OffsetOf_pStorage' -> 16r8.
			'_OffsetOf_pStream' -> 16r8.
			'_OffsetOf_pszVal' -> 16r8.
			'_OffsetOf_puuid' -> 16r8.
			'_OffsetOf_pVersionedStream' -> 16r8.
			'_OffsetOf_pwszVal' -> 16r8.
			'_OffsetOf_uhVal' -> 16r8.
			'_PROPVARIANT_Size' -> 16r10.
			'CountedArrayNames'
				-> #(#badVectorType #badVectorType #cai #cal #caflt #cadbl #cacy #cadate #cabstr #badVectorType #cascode #cabool #capropvar #badVectorType #badVectorType #badVectorType #cac #caub #caui #caul #cah #cauh #badVectorType #badVectorType #badVectorType #badVectorType #badVectorType #badVectorType #badVectorType #badVectorType #calpstr #calpwstr #badVectorType #badVectorType #badVectorType #badVectorType #badVectorType #badVectorType #badVectorType #badVectorType #badVectorType #badVectorType #badVectorType #badVectorType #badVectorType #badVectorType #badVectorType #badVectorType #badVectorType #badVectorType #badVectorType #badVectorType #badVectorType #badVectorType #badVectorType #badVectorType #badVectorType #badVectorType #badVectorType #badVectorType #badVectorType #badVectorType #badVectorType #badVectorType #cafiletime #badVectorType #badVectorType #badVectorType #badVectorType #badVectorType #badVectorType #caclipdata #cauuid #badVectorType).
			'PVCF_DEFAULT' -> 16r0.
			'PVCF_DIGITSASNUMBERS_CASESENSITIVE' -> 16r20.
			'PVCF_TREATEMPTYASGREATERTHAN' -> 16r1.
			'PVCF_USESTRCMP' -> 16r2.
			'PVCF_USESTRCMPC' -> 16r4.
			'PVCF_USESTRCMPI' -> 16r8.
			'PVCF_USESTRCMPIC' -> 16r10.
			'PVCHF_ALPHABOOL' -> 16r2.
			'PVCHF_DEFAULT' -> 16r0.
			'PVCHF_LOCALBOOL' -> 16r8.
			'PVCHF_NOHEXSTRING' -> 16r10.
			'PVCHF_NOUSEROVERRIDE' -> 16r4.
			'PVCU_DAY' -> 16r4.
			'PVCU_DEFAULT' -> 16r0.
			'PVCU_HOUR' -> 16r3.
			'PVCU_MINUTE' -> 16r2.
			'PVCU_MONTH' -> 16r5.
			'PVCU_SECOND' -> 16r1.
			'PVCU_YEAR' -> 16r6
		}!

OS.COM.PROPVARIANT guid: (Core.GUID fromString: '{cf8d6ef1-76eb-48bf-85a6-500ff451c84d}')!

OS.COM.PROPVARIANT comment: '`PROPVARIANT` is an `External.Structure` class to wrap the struct COM Property Storage structure of the same name.

`PROPVARIANT` shares a largely common layout with `VARIANT`, but supports a richer set of types, although unfortunately not a complete superset, and some VARIANT types are handled only partially with the documentation being contradictory as to whether some types are supported at all, e.g. `VT_DECIMAL`, `VT_UNKNOWN`, and `VT_DISPATCH`. For example the main page for [PROPVARIANT](https://learn.microsoft.com/en-us/windows/win32/api/propidl/ns-propidl-propvariant) states explicitly in its Remarks section that `VT_DECIMAL` _is_ supported. However that for [PropVariantChangeType](https://learn.microsoft.com/en-us/windows/win32/api/propvarutil/nf-propvarutil-propvariantchangetype) does not list it as a potential source or target of conversions, and indeed the API returns a `DISP_E_BADVARTYPE` for `VT_DECIMAL` source or destination type. The truth is that it is version specific: According to [Property Set Serialization](https://learn.microsoft.com/en-us/windows/win32/stg/version-0-vs--version-1-property-set-serialization) `VT_DECIMAL` is not by format verion 0 property sets, but is supported in version 1, although it seems that not all the `PROPVARIANT` Apis were updated for version 2.

IDL definition follows:
```
typedef 
struct tagPROPVARIANT {
	unsigned short vt;
	BYTE wReserved1;
	BYTE wReserved2;
	ULONG wReserved3;
	union {
		BYTE cVal;
		UCHAR bVal;
		short iVal;
		USHORT uiVal;
		long lVal;
		ULONG ulVal;
		int intVal;
		unsigned int uintVal;
		LARGE_INTEGER hVal;
		ULARGE_INTEGER uhVal;
		float fltVal;
		double dblVal;
		VARIANT_BOOL boolVal;
		VARIANT_BOOL __OBSOLETE__VARIANT_BOOL;
		SCODE scode;
		CURRENCY cyVal;
		DATE date;
		FILETIME filetime;
		GUID* puuid;
		CLIPDATA* pClipData;
		BSTR bstrVal;
		BSTRBLOB bstrblobVal;
		BLOB blob;
		LPSTR pszVal;
		LPWSTR pwszVal;
		IUnknown* punkVal;
		IDispatch* pdispVal;
		IStream* pStream;
		IStorage* pStorage;
		VersionedStream* pVersionedStream;
		SAFEARRAY parray;
		CAC cac;
		CAUB caub;
		CAI cai;
		CAUI caui;
		CAL cal;
		CAUL caul;
		CAH cah;
		CAUH cauh;
		CAFLT caflt;
		CADBL cadbl;
		CABOOL cabool;
		CASCODE cascode;
		CACY cacy;
		CADATE cadate;
		CAFILETIME cafiletime;
		CACLSID cauuid;
		CACLIPDATA caclipdata;
		CABSTR cabstr;
		CABSTRBLOB cabstrblob;
		CALPSTR calpstr;
		CALPWSTR calpwstr;
		CAPROPVARIANT capropvar;
		BYTE* pcVal;
		UCHAR* pbVal;
		short* piVal;
		USHORT* puiVal;
		long* plVal;
		ULONG* pulVal;
		int* pintVal;
		unsigned int* puintVal;
		float* pfltVal;
		double* pdblVal;
		VARIANT_BOOL* pboolVal;
		DECIMAL* pdecVal;
		SCODE* pscode;
		CURRENCY* pcyVal;
		DATE* pdate;
		BSTR* pbstrVal;
		IUnknown** ppunkVal;
		IDispatch** ppdispVal;
		SAFEARRAY* pparray;
		PROPVARIANT* pvarVal;
	};
} PROPVARIANT;
```
'!

!OS.COM.PROPVARIANT categoriesForClass!External-Data-Structured-COM! !

!OS.COM.PROPVARIANT methodsFor!

_deepCopy: copiesDictionary
	"Private - Answer a 'deep copy' of the receiver, cloning only those parts not already included in the IdentityDictionary argument, copiesDictionary.
	Implementation Note: We have no copiable instance variables, and so just create a new instance	and use an appropriate API call to copy the receiver into it."

	"There is no equivalent of VariantCopyInd, so we will need to implement the copy of byref's ourselves somehow."
	self isByRef ifTrue: [^super _deepCopy: copiesDictionary].
	^self copy!

badVectorType
	^HRESULTError signalWith: DISP_E_BADVARTYPE!

blob
	"Answer the BLOB value from the receiver.
	Assumes the receiver is of type VT_BLOB."

	^BLOB fromAddress: (bytes yourAddress + _OffsetOf_blob) owner: self fieldOwner!

blob: aByteObject
	"Private - Initialize the receiver to be of type VT_BLOB, referencing a task memory copy of the byte object argument."

	bytes
		uint16AtOffset: _OffsetOf_vt put: VT_BLOB;
		uintPtrAtOffset: ##(_OffsetOf_blob + BLOB._OffsetOf_pBlobData) put: aByteObject copyToCOMTaskMemory detach;
		uint32AtOffset: ##(_OffsetOf_blob + BLOB._OffsetOf_cbSize) put: aByteObject size
!

blobVector
	"Answer a <UInt8Array) representing the BLOB data from the receiver.
	Assumes the receiver is of type VT_BLOB."

	^self blob asExternalArray!

boolVector
	"Private - Answer a <BOOLArray> representing the VARIANT_BOOL elements of the receiver. An error will be thrown if the receiver is not of type VT_VECTOR or VT_ARRAY of VT_BOOL.
	Note that BOOLArray's hold 32-bit BOOL (0/1) values, not 16-bit VARIANT_BOOL (0/-1) values."

	| array count |
	array := BOOLArray new: (count := self elementCount).
	Propsys
		propVariantToBooleanVector: self
		prgf: array
		crgf: count
		pcElem: (ByteArray newFixed: 4).
	^array!

boolVector: aVarBoolArray
	"Private - Initialize the receiver from the array of `BOOL` argument. Note that the `BOOL` is a 32-bit 0/1 representation of boolean values, but that the resulting variant will contain a CABOOL, which uses the 16-bit VARIANT_BOOL (0/-1) representation. This inconsistency is inherent in the API."

	Propsys
		initPropVariantFromBooleanVector: aVarBoolArray
		cElems: aVarBoolArray length
		ppropvar: self!

bstrVector: anArrayOfStrings
	"Private - Initialize the receiver to contain a (VT_VECTOR | VT_BSTR) counted array, i.e. <CABSTR>, holding <BSTR> copies of the strings in argument."

	| vector |
	vector := BSTRArray withAll: anArrayOfStrings bufferClass: TaskMemory.
	bytes
		uint16AtOffset: _OffsetOf_vt put: ##(VT_BSTR | VT_VECTOR);
		uintPtrAtOffset: ##(_OffsetOf_cabstr + CountedArray._OffsetOf_pElems) put: vector detach;
		uint32AtOffset: ##(_OffsetOf_cabstr + CountedArray._OffsetOf_cElems) put: vector length!

cabool
	"Answer the <CABOOL> value of the receiver's 'cabool' field."

	^CABOOL fromAddress: bytes yourAddress + _OffsetOf_cabool owner: self fieldOwner!

cabstr
	"Answer the <CABSTR> value of the receiver's 'cabstr' field."

	^CABSTR fromAddress: bytes yourAddress + _OffsetOf_cabstr owner: self fieldOwner!

cac
	"Answer the <CAC> value of the receiver's 'cac' field."

	^CAC fromAddress: bytes yourAddress + _OffsetOf_cac owner: self fieldOwner!

caclipdata
	"Answer the CACLIPDATA value from the receiver.
	Assumes the receiver is of type VT_VECTOR | VT_CF."

	^Error notYetImplemented!

cacy
	"Answer the <CACY> value of the receiver's 'cacy' field."

	^CACY fromAddress: bytes yourAddress + _OffsetOf_cacy owner: self fieldOwner!

cadate
	"Answer the <CADATE> value of the receiver's 'cadate' field."

	^CADATE fromAddress: bytes yourAddress + _OffsetOf_cadate owner: self fieldOwner!

cadbl
	"Answer the <CADBL> value of the receiver's 'cadbl' field."

	^CADBL fromAddress: bytes yourAddress + _OffsetOf_cadbl owner: self fieldOwner!

cafiletime
	"Answer the <CAFILETIME> value of the receiver's 'cafiletime' field."

	^CAFILETIME fromAddress: bytes yourAddress + _OffsetOf_cafiletime owner: self fieldOwner!

caflt
	"Answer the <CAFLT> value of the receiver's 'caflt' field."

	^CAFLT fromAddress: bytes yourAddress + _OffsetOf_caflt owner: self fieldOwner!

cah
	"Answer the <CAH> value of the receiver's 'cah' field."

	^CAH fromAddress: bytes yourAddress + _OffsetOf_cah owner: self fieldOwner!

cai
	"Answer the <CAI> value of the receiver's 'cai' field."

	^CAI fromAddress: bytes yourAddress + _OffsetOf_cai owner: self fieldOwner!

cal
	"Answer the <CAL> value of the receiver's 'cal' field."

	^CAL fromAddress: bytes yourAddress + _OffsetOf_cal owner: self fieldOwner!

calpstr
	"Answer the <CALPSTR> value of the receiver's 'calpstr' field."

	^CALPSTR fromAddress: bytes yourAddress + _OffsetOf_calpstr owner: self fieldOwner!

calpwstr
	"Answer the <CALPOLESTR> value of the receiver's 'calpwstr' field."

	^CALPOLESTR fromAddress: bytes yourAddress + _OffsetOf_calpwstr owner: self fieldOwner!

capropvar
	"Answer the <CAPROPVARIANT> value of the receiver's 'capropvar' field."

	^CAPROPVARIANT fromAddress: bytes yourAddress + _OffsetOf_capropvar owner: self fieldOwner!

cascode
	"Answer the <CASCODE> value of the receiver's 'cascode' field."

	^CASCODE fromAddress: bytes yourAddress + _OffsetOf_cascode owner: self fieldOwner!

caub
	"Answer the <CAUB> value of the receiver's 'caub' field."

	^CAUB fromAddress: bytes yourAddress + _OffsetOf_caub owner: self fieldOwner!

cauh
	"Answer the <CAUH> value of the receiver's 'cauh' field."

	^CAUH fromAddress: bytes yourAddress + _OffsetOf_cauh owner: self fieldOwner!

caui
	"Answer the <CAUI> value of the receiver's 'caui' field."

	^CAUI fromAddress: bytes yourAddress + _OffsetOf_caui owner: self fieldOwner!

caul
	"Answer the <CADWORD> value of the receiver's 'caul' field."

	^CADWORD fromAddress: bytes yourAddress + _OffsetOf_caul owner: self fieldOwner!

cauuid
	"Answer the <CACLSID> value of the receiver's 'cauuid' field."

	^CACLSID fromAddress: bytes yourAddress + _OffsetOf_cauuid owner: self fieldOwner!

changeType: anInteger locale: aLocale
	"Answer a <PROPVARIANT> containing the receiver's value coerced to a new type as specified by the <integer> first argument, a member of the VARTYPE enumeration. Note that for PROPVARIANTs the locale argument is ignored. Per the documentation, date/time conversions use a canonical string form, but for numbers the default locale decimal separator is used (which is rather inconsistent). If the coercion is not possible, then raise an HRESULTError."

	| answer |
	"PropVariantChangeType fails for VT_DECIMAL, even though the docs state 'The PROPVARIANT structure can also hold a value of VT_DECIMAL'"
	(anInteger == VT_DECIMAL or: [self vartype == VT_DECIMAL])
		ifTrue: [^super changeType: anInteger locale: Locale invariant].
	answer := self class new.
	Propsys
		propVariantChangeType: answer
		propvarSrc: self
		flags: (aLocale noUserOverrides
				ifTrue: [##(PVCHF_NOUSEROVERRIDE | PVCHF_ALPHABOOL | PVCHF_LOCALBOOL)]
				ifFalse: [##(PVCHF_ALPHABOOL|PVCHF_LOCALBOOL)])
		vt: anInteger.
	^answer!

clipdata
	"Answer the CLIPDATA value from the receiver.
	Assumes the receiver is of type VT_CF."

	^Error notYetImplemented!

clsid
	"Private - Answer the CLSID value from the receiver.
	Assumes the receiver is of type VT_CLSID."

	^CLSID fromAddress: (bytes uintPtrAtOffset: _OffsetOf_puuid)!

clsid: aCLSID
	"Private - Set the CLSID value from the receiver."

	Propsys initPropVariantFromCLSID: aCLSID ppropvar: self!

clsidVector: aCLSIDArray
	"Private - Initialize the receiver to be of type (VT_VECTOR | VT_CLSID), holding copies of the GUIDs in the collection argument."

	bytes
		uint16AtOffset: _OffsetOf_vt put: ##(VT_CLSID | VT_VECTOR);
		uintPtrAtOffset: ##(_OffsetOf_cauuid + CountedArray._OffsetOf_pElems) put: aCLSIDArray copyToCOMTaskMemory detach;
		uint32AtOffset: ##(_OffsetOf_cauuid + CountedArray._OffsetOf_cElems) put: aCLSIDArray size!

cmp: anObject
	"Private - Answer a comparison value indicating the relationship between the receiver and the <PROPVARIANT> representation of the argument."

	| varRight |
	varRight := anObject asVariant: PROPVARIANT.
	^Propsys
		propVariantCompareEx: self
		propvar2: varRight
		unit: 0
		flags: PVCU_DEFAULT!

copy
	"Answer a <PROPVARIANT> which has the same vartype and value as the receiver."

	"Implementation Note: This is a deep copy of the receiver, unless it is a reference in which case the copy is still a reference. #deepCopy answers a true deep copy even in that case."

	| copy |
	copy := PROPVARIANT new.
	Ole32 propVariantCopy: copy pvarSrc: self.
	^copy!

cyVector: aCYArray
	"Private - Initialize the receiver to be of type (VT_VECTOR | VT_CY), containing a <CACY> holding the fixed point decimal values copied from the <CYArray> argument."

	"There are no propvarutil APIs to work with variants and native arrays of CYs, but we can leverage the fact that the memory layout for CACY is common with CAUH and use the initialization function for UInt64Array, and then just change the vartype. The alternative would be to just initialize the CACY fields ourselves (remembering to allocate the memory block from the task memory heap), which would not be difficult, but this is faster."
	Propsys
		initPropVariantFromUInt64Vector: aCYArray
		cElems: aCYArray length
		ppropvar: self.
	self vt: ##(VT_VECTOR | VT_CY)!

dateVector
	"Private - Answer an <DATEArray> containing the DATE values held by the receiver, assumed to be a VT_VECTOR or VT_ARRAY of VT_DATE."

	^self getVector!

dateVector: aDATEArray
	"Private - Initialize the receiver to be of type (VT_VECTOR | VT_DATE), holding copies of the DATEs in the <DATEArray> argument."

	bytes
		uint16AtOffset: _OffsetOf_vt put: ##(VT_DATE| VT_VECTOR);
		uintPtrAtOffset: ##(_OffsetOf_cadate + CountedArray._OffsetOf_pElems) put: aDATEArray copyToCOMTaskMemory detach;
		uint32AtOffset: ##(_OffsetOf_cadate + CountedArray._OffsetOf_cElems) put: aDATEArray size
!

displayArrayOn: aPuttableStream
	| locale |
	locale := aPuttableStream locale.
	aPuttableStream locale: Locale invariant.
	[super displayArrayOn: aPuttableStream] ensure: [aPuttableStream locale: locale]!

doubleVector
	| array count |
	array := DOUBLEArray new: (count := self elementCount).
	Propsys
		propVariantToDoubleVector: self
		prgn: array
		crgn: count
		pcElem: (ByteArray newFixed: 4).
	^array!

doubleVector: aDOUBLEArray
	"Private - Initialize the receiver to be of type (VT_VECTOR | VT_R8), containing a <CADBL> holding double-precision floating-point values copied from the <DOUBLEArray> argument."

	Propsys
		initPropVariantFromDoubleVector: aDOUBLEArray
		cElems: aDOUBLEArray length
		ppropvar: self!

elementCount
	"Answer the <integer> element count of a VT_VECTOR value; or 1 otherwise."

	^Propsys propVariantGetElementCount: self!

externalArray: anExternalArray
	"Private - Initialize the receiver to hold a SAFEARRAY of appropriate vartype containing the elements copied from the <ExternalArray> argument."

	self array: anExternalArray asSAFEARRAY!

filetime
	"Private - Answer a <DateAndTime> representing the <FILETIME> value of the receiver.
	Assumes the receiver is of type VT_FILETIME."

	| answer |
	answer := FILETIME new.
	Propsys propVariantToFileTime: self pstfOut: PSTF_UTC pftOut: answer.
	^answer asDateAndTime!

filetime: aDateAndTimeObject
	"Private - Initialize the receiver to hold the best available PROPVARIANT representation of a <DateAndTime>, i.e. as a VT_FILETIME (which may lose precision and range)."

	Propsys initPropVariantFromFileTime: aDateAndTimeObject asFILETIME ppropvar: self!

filetimeVector
	| array count |
	array := FILETIMEArray new: (count := self elementCount).
	Propsys
		propVariantToFileTimeVector: self
		prgft: array
		crgft: count
		pcElem: (ByteArray newFixed: 4).
	^array!

filetimeVector: aFILETIMEArray
	Propsys
		initPropVariantFromFileTimeVector: aFILETIMEArray
		cElems: aFILETIMEArray length
		ppropvar: self!

floatVector: aFLOATArray
	"Private - Initialize the receiver to be a (VT_VECTOR | VT_R4), containing a <CAFLT> holding single-precision floating-point values copied from the <FLOATArray> argument."

	"There are no propvarutil APIs to work with variants and native arrays of FLOATs, but we can leverage the fact that the memory layout for CAFLT is common with CAUINT and use the initialization function for UInt32Array, and then just change the vartype. The alternative would be to just initialize the CAFLT fields ourselves (remembering to allocate the memory block from the task memory heap), which would not be difficult, but this is faster."
	Propsys
		initPropVariantFromUInt32Vector: aFLOATArray
		cElems: aFLOATArray length
		ppropvar: self.
	self vt: ##(VT_VECTOR | VT_R4)!

getArray: anInteger
	^(anInteger allMask: VT_VECTOR)
		ifTrue: [self getVector: anInteger]
		ifFalse: [self getSafeArray: anInteger]!

getVector
	| vt |
	vt := bytes uint16AtOffset: _OffsetOf_vt.
	^(vt allMask: VT_VECTOR)
		ifTrue: [(self getVector: vt) asExternalArray]
		ifFalse: [self getSafeArrayAsVector: vt]!

getVector: anInteger
	^self perform: (CountedArrayNames at: (anInteger bitAnd: VT_TYPEMASK) + 1)!

hresultVector: anInt32Array
	"Private - Initialize the receiver to be of type (VT_VECTOR | VT_ERROR), containing a counted array of 32-bit signed integer HRESULTvalues, i.e. <CASCODE>, copied from the <HRESULTArray> argument."

	Propsys
		initPropVariantFromInt32Vector: anInt32Array
		cElems: anInt32Array length
		ppropvar: self.
	self vt: ##(VT_VECTOR | VT_ERROR)!

initializeFromPropVariant: aPROPVARIANT
	"Private - Source and dest same type, so just a copy"

	Ole32 propVariantCopy: self pvarSrc: aPROPVARIANT!

initializeFromVariant: aVARIANT
	"VariantToPropVariant appears to be a thin wrapper around VariantCopy. It doesn't do any of the translations one might expect, such as VT_BSTR -> VT_LPWSTR, or VT_ARRAY to VT_VECTOR."

	#todo.	"Implement widening conversions for strings, vectors, etc, to the richer PROPVARIANT type system than this essentially pointless API"
	Propsys variantToPropVariant: aVARIANT pPropVar: self!

initializeVariant: anOleVariant
	"Private - Initialize another VARIANT or PROPVARIANT from this VARIANT. If the target is a PROPVARIANT, we want to just copy to it. If a VARIANT, we need to narrow to its simpler type system."

	anOleVariant initializeFromPropVariant: self!

int16Vector
	"Private - Answer an <Int16Array> containing the signed 16-bit integer values held by the receiver, assumed to be a VT_VECTOR or VT_ARRAY of VT_I2."

	| array count |
	array := Int16Array new: (count := self elementCount).
	Propsys
		propVariantToInt16Vector: self
		prgn: array
		crgn: count
		pcElem: (ByteArray newFixed: 4).
	^array!

int16Vector: anInt16Array
	"Private - Initialize the receiver to be of type (VT_VECTOR | VT_I2), containing a counted array of 16-bit signed integer values, i.e. <CAI>, copied from the <Int16Array> argument."

	Propsys
		initPropVariantFromInt16Vector: anInt16Array
		cElems: anInt16Array length
		ppropvar: self!

int32Vector
	"Private - Answer an <Int32Array> containing the signed 32-bit integer values held by the receiver, assumed to be a VT_VECTOR or VT_ARRAY of VT_I4."

	| array count |
	array := Int32Array new: (count := self elementCount).
	Propsys
		propVariantToInt32Vector: self
		prgn: array
		crgn: count
		pcElem: (ByteArray newFixed: 4).
	^array!

int32Vector: anInt32Array
	"Private - Initialize the receiver to be of type (VT_VECTOR | VT_I4), containing a counted array of 32-bit signed integer values, i.e. <CAL>, copied from the <Int32Array> argument."

	Propsys
		initPropVariantFromInt32Vector: anInt32Array
		cElems: anInt32Array length
		ppropvar: self!

int64Vector
	| array count |
	array := Int64Array new: (count := self elementCount).
	Propsys
		propVariantToInt64Vector: self
		prgn: array
		crgn: count
		pcElem: (ByteArray newFixed: 4).
	^array!

int64Vector: anInt64Array
	"Private - Initialize the receiver to be of type (VT_VECTOR | VT_I8), containing a counted array of 64-bit signed integer values, i.e. <CAH>, copied from the <Int64Array> argument."

	Propsys
		initPropVariantFromInt64Vector: anInt64Array
		cElems: anInt64Array length
		ppropvar: self!

int8Vector: anInt8Array
	"Private - Initialize the receiver to be of type (VT_VECTOR | VT_I1), containing a counted array of 8-bit signed integer values, i.e. <CAC>, copied from the <Int8Array> argument."

	Propsys
		initPropVariantFromBuffer: anInt8Array
		cb: anInt8Array size
		ppropvar: self.
	self vt: ##(VT_VECTOR | VT_I1)!

isVtString
	| vt |
	vt := bytes uint16AtOffset: _OffsetOf_vt.
	^vt == VT_LPWSTR or: [vt == VT_BSTR]!

lpstr
	"Private - Answer the LPSTR value of the receiver. Assumes the receiver is a VT_LPSTR."

	^self isByRef
		ifTrue: [LPSTR fromAddress: (bytes uintPtrAtOffset: _OffsetOf_pszVal) owner: self fieldOwner]
		ifFalse: [AnsiString fromAddress: (bytes uintPtrAtOffset: _OffsetOf_pszVal)]!

lpstr: aString
	"Private - Initialize the receiver to contain a copy of the <AnsiString> argument, using the preferred representation of the concrete subclass."

	bytes
		uintPtrAtOffset: _OffsetOf_pszVal put: aString asAnsiString copyToCOMTaskMemory detach;
		uintPtrAtOffset: _OffsetOf_vt put: VT_LPSTR!

lpstrVector
	"Private - Answer an <LPSTRArray> containing the ANSI string values held by the receiver, assumed to be a (VT_VECTOR | VT_LPSTR)."

	^self dateVector!

lpstrVector: anExternalArrayOfStrings
	"Private - Initialize the receiver to contain a (VT_VECTOR | VT_LPSTR) counted array, i.e. <CALPSTR>, holding copies of the strings in the <ExternalArray> argument."

	bytes
		uint16AtOffset: _OffsetOf_vt put: ##(VT_LPSTR | VT_VECTOR);
		uintPtrAtOffset: ##(_OffsetOf_calpstr + CountedArray._OffsetOf_pElems) put: anExternalArrayOfStrings copyToCOMTaskMemory detach;
		uint32AtOffset: ##(_OffsetOf_calpstr + CountedArray._OffsetOf_cElems) put: anExternalArrayOfStrings size!

lpwstr
	"Private - Answer the LPWSTR value of the receiver."

	^self isByRef
		ifTrue: [LPWSTR fromAddress: (bytes uintPtrAtOffset: _OffsetOf_pwszVal) owner: self fieldOwner]
		ifFalse: [Utf16String fromAddress: (bytes uintPtrAtOffset: _OffsetOf_pwszVal)]!

lpwstr: aString
	"Private - Initialize the receiver to contain a VT_LPWSTR, task-memory allocated wide string, copy of the <String> argument."

	Propsys initPropVariantFromString: aString ppropvar: self!

lpwstrVector
	| array count |
	array := LPWSTRArray new: (count := self elementCount).
	Propsys
		propVariantToStringVector: self
		prgsz: array
		crgsz: count
		pcElem: (ByteArray newFixed: 4).
	^array!

lpwstrVector: anExternalArrayOfWideStrings
	"Private - Initialize the receiver to contain a (VT_VECTOR | VT_LPWSTR) counted array, i.e. <CALPWSTR>, holding copies of the strings in the <ExternalArray> argument."

	Propsys
		initPropVariantFromStringVector: anExternalArrayOfWideStrings
		cElems: anExternalArrayOfWideStrings length
		ppropvar: self!

preferredVtString
	^VT_LPWSTR!

storage
	"Private - Answer the <IStorage> value from the receiver.
	Assumes the receiver is of type VT_STORAGE."

	^self isByRef
		ifTrue: [LPVOID fromAddress: (bytes uintPtrAtOffset: _OffsetOf_pStorage) owner: self fieldOwner]
		ifFalse: [IStorage fromAddress: (bytes uintPtrAtOffset: _OffsetOf_pStorage)]!

storage: anIStorage
	"Private - Initialize the receiver to be a VT_STORAGE containing the <IStorage> interface pointer argument."

	anIStorage _addRef.
	bytes
		uintPtrAtOffset: _OffsetOf_pStorage put: anIStorage yourAddress;
		uint16AtOffset: _OffsetOf_vt put: VT_STORAGE!

stream
	"Private - Answer the <IStream> value from the receiver.
	Assumes the receiver is of type VT_STREAM."

	^self isByRef
		ifTrue: [LPVOID fromAddress: (bytes uintPtrAtOffset: _OffsetOf_pStream) owner: self fieldOwner]
		ifFalse: [IStream fromAddress: (bytes uintPtrAtOffset: _OffsetOf_pStream)]!

stream: anIStream
	"Private - Initialize the receiver to be a VT_STREAM containing the <IStream> interface pointer argument."

	anIStream _addRef.
	bytes
		uintPtrAtOffset: _OffsetOf_pStream put: anIStream yourAddress;
		uint16AtOffset: _OffsetOf_vt put: VT_STREAM!

typeMismatch
	^HRESULTError signalWith: DISP_E_TYPEMISMATCH!

typeName
	"Answer the symbolic name of the receiver's basic variant type code without modifiers such as VT_BYREF."

	| vt |
	vt := bytes uint16AtOffset: _OffsetOf_vt.
	^(vt allMask: VT_VECTOR)
		ifTrue: [CountedArrayNames at: (vt bitAnd: VT_TYPEMASK) + 1]
		ifFalse: [self class nameOfVT: (vt bitAnd: VT_TYPEMASK)]!

uint16Vector
	"Private - Answer a <UInt16Array> containing the unsigned 16-bit integer values held by the receiver, assumed to be a VT_VECTOR or VT_ARRAY of VT_UI2."

	| array count |
	array := UInt16Array new: (count := self elementCount).
	Propsys
		propVariantToUInt16Vector: self
		prgn: array
		crgn: count
		pcElem: (ByteArray newFixed: 4).
	^array!

uint16Vector: aUInt16Array
	"Private - Initialize the receiver to be of type (VT_VECTOR | VT_UI2), containing a CAUI holding 16-bit unsigned integer values copied from the <UInt16Array> argument."

	Propsys
		initPropVariantFromUInt16Vector: aUInt16Array
		cElems: aUInt16Array length
		ppropvar: self!

uint32Vector
	| array count |
	array := UInt32Array new: (count := self elementCount).
	Propsys
		propVariantToUInt32Vector: self
		prgn: array
		crgn: count
		pcElem: (ByteArray newFixed: 4).
	^array!

uint32Vector: aUInt32Array
	"Private - Initialize the receiver to be of type (VT_VECTOR | VT_UI4), containing a CAUL holding 32-bit unsigned integer values copied from the <UInt32Array> argument."

	Propsys
		initPropVariantFromUInt32Vector: aUInt32Array
		cElems: aUInt32Array length
		ppropvar: self!

uint64Vector
	| array count |
	array := UInt64Array new: (count := self elementCount).
	Propsys
		propVariantToUInt64Vector: self
		prgn: array
		crgn: count
		pcElem: (ByteArray newFixed: 4).
	^array!

uint64Vector: aUInt64Array
	"Private - Initialize the receiver to be of type (VT_VECTOR | VT_UI8), containing a CAUH holding 64-bit unsigned integer values copied from the <UInt64Array> argument."

	Propsys
		initPropVariantFromUInt64Vector: aUInt64Array
		cElems: aUInt64Array length
		ppropvar: self!

uint8Vector
	"Private - Answer a <UInt8Array> containing the unsigned 8-bit integer values held by the receiver, assumed to be a VT_VECTOR or VT_ARRAY of VT_UI1."

	| array count |
	array := UInt8Array new: (count := self elementCount).
	Propsys
		propVariantToBuffer: self
		pv: array
		cb: count.
	^array!

uint8Vector: aUInt8Array
	Propsys
		initPropVariantFromBuffer: aUInt8Array
		cb: aUInt8Array size
		ppropvar: self!

varBoolVector: aVARIANT_BOOLArray
	"Private - Initialize the receiver from the array of `VARIANT_BOOL` argument, resulting in a VT_VECTOR | VT_BOOL containing copies of the VARIANT_BOOL values in the argument."

	self int16Vector: aVARIANT_BOOLArray.
	self vt: ##(VT_VECTOR | VT_BOOL)!

variantVector: aPROPVARIANTArray
	"Private - Initialize the receiver to be of type (VT_VECTOR | VT_VARIANT), holding copies of the PROPVARIANTs in the <PROPVARIANTArray> argument."

	bytes
		uint16AtOffset: _OffsetOf_vt put: ##(VT_VARIANT | VT_VECTOR);
		uintPtrAtOffset: ##(_OffsetOf_capropvar + CountedArray._OffsetOf_pElems) put: aPROPVARIANTArray copyToCOMTaskMemory detach;
		uint32AtOffset: ##(_OffsetOf_capropvar + CountedArray._OffsetOf_cElems) put: aPROPVARIANTArray size!

vectorMask
	^VT_VECTOR! !

!OS.COM.PROPVARIANT categoriesForMethods!
_deepCopy:!copying!private! !
badVectorType!exceptions!private! !
blob!accessing!private! !
blob:!initializing!private! !
blobVector!accessing!private! !
boolVector!accessing!private! !
boolVector:!initializing!private! !
bstrVector:!initializing!private! !
cabool!**compiled accessors**!public! !
cabstr!**compiled accessors**!public! !
cac!**compiled accessors**!public! !
caclipdata!accessing!public! !
cacy!**compiled accessors**!public! !
cadate!**compiled accessors**!public! !
cadbl!**compiled accessors**!public! !
cafiletime!**compiled accessors**!public! !
caflt!**compiled accessors**!public! !
cah!**compiled accessors**!public! !
cai!**compiled accessors**!public! !
cal!**compiled accessors**!public! !
calpstr!**compiled accessors**!public! !
calpwstr!**compiled accessors**!public! !
capropvar!**compiled accessors**!public! !
cascode!**compiled accessors**!public! !
caub!**compiled accessors**!public! !
cauh!**compiled accessors**!public! !
caui!**compiled accessors**!public! !
caul!**compiled accessors**!public! !
cauuid!**compiled accessors**!public! !
changeType:locale:!converting!public! !
clipdata!accessing!public! !
clsid!accessing!private! !
clsid:!initializing!private! !
clsidVector:!initializing!private! !
cmp:!comparing!private! !
copy!copying!public! !
cyVector:!initializing!private! !
dateVector!accessing!private! !
dateVector:!initializing!private! !
displayArrayOn:!displaying!private! !
doubleVector!accessing!private! !
doubleVector:!initializing!private! !
elementCount!accessing!public! !
externalArray:!initializing!private! !
filetime!accessing!private! !
filetime:!initializing!private! !
filetimeVector!accessing!private! !
filetimeVector:!initializing!private! !
floatVector:!initializing!private! !
getArray:!accessing!private! !
getVector!accessing!private! !
getVector:!accessing!private! !
hresultVector:!initializing!private! !
initializeFromPropVariant:!converting!double dispatch!private! !
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
lpstr!accessing!private! !
lpstr:!initializing!private! !
lpstrVector!accessing!private! !
lpstrVector:!initializing!private! !
lpwstr!accessing!private! !
lpwstr:!initializing!private! !
lpwstrVector!accessing!private! !
lpwstrVector:!initializing!private! !
preferredVtString!constants!private! !
storage!accessing!private! !
storage:!initializing!private! !
stream!accessing!private! !
stream:!initializing!private! !
typeMismatch!exceptions!private! !
typeName!accessing!public! !
uint16Vector!accessing!private! !
uint16Vector:!initializing!private! !
uint32Vector!accessing!private! !
uint32Vector:!initializing!private! !
uint64Vector!accessing!private! !
uint64Vector:!initializing!private! !
uint8Vector!accessing!private! !
uint8Vector:!initializing!private! !
varBoolVector:!initializing!private! !
variantVector:!private! !
vectorMask!constants!private! !
!

!OS.COM.PROPVARIANT class methodsFor!

arrayType
	"Answer the class of object (typically an <ExternalArray> subclass) to be used to represent arrays of the receiver's field type in other structures."

	^PROPVARIANTArray!

byteSize
	^_PROPVARIANT_Size!

clear: addressOrBytes
	"Free a PROPVARIANT at the specified address."

	Ole32 propVariantClear: addressOrBytes!

countedArrayNames
	"Private - Answer a map from vector VT's to the accessor name for the corresponding counted array.
	Note that we don't support CACLIPDATA as this is a legacy format unlikely to be encountered today.

	[case (VT_VECTOR | VT_I1)]       CAC           cac;       // new
	[case (VT_VECTOR | VT_UI1)] CAUB          caub;
	[case (VT_VECTOR | VT_I2)] CAI           cai;
	[case (VT_VECTOR | VT_UI2)] CAUI          caui;
	[case (VT_VECTOR | VT_I4)] CAL           cal;
	[case (VT_VECTOR | VT_UI4)] CAUL          caul;
	[case (VT_VECTOR | VT_I8)] CAH           cah;
	[case (VT_VECTOR | VT_UI8)] CAUH          cauh;
	[case (VT_VECTOR | VT_R4)] CAFLT         caflt;
	[case (VT_VECTOR | VT_R8)] CADBL         cadbl;
	[case (VT_VECTOR | VT_BOOL)] CABOOL        cabool;
	[case (VT_VECTOR | VT_ERROR)] CASCODE       cascode;
	[case (VT_VECTOR | VT_CY)] CACY          cacy;
	[case (VT_VECTOR | VT_DATE)] CADATE        cadate;
	[case (VT_VECTOR | VT_FILETIME)] CAFILETIME    cafiletime;
	[case (VT_VECTOR | VT_CLSID)] CACLSID       cauuid;
	[case (VT_VECTOR | VT_CF)] CACLIPDATA    caclipdata;
	[case (VT_VECTOR | VT_BSTR)] CABSTR        cabstr;
	[case (VT_VECTOR | VT_BSTR_BLOB)] CABSTRBLOB    cabstrblob; // System use only
	[case (VT_VECTOR | VT_LPSTR)] CALPSTR       calpstr;
	[case (VT_VECTOR | VT_LPWSTR)] CALPWSTR      calpwstr;
	[case (VT_VECTOR | VT_VARIANT)] CAPROPVARIANT capropvar;
"

	^(Array new: VT_VERSIONED_STREAM + 1 withAll: #badVectorType)
		at: VT_I1 + 1 put: #cac;
		at: VT_UI1 + 1 put: #caub;
		at: VT_I2 + 1 put: #cai;
		at: VT_UI2 + 1 put: #caui;
		at: VT_I4 + 1 put: #cal;
		at: VT_UI4 + 1 put: #caul;
		at: VT_I8 + 1 put: #cah;
		at: VT_UI8 + 1 put: #cauh;
		at: VT_R4 + 1 put: #caflt;
		at: VT_R8 + 1 put: #cadbl;
		at: VT_BOOL + 1 put: #cabool;
		at: VT_ERROR + 1 put: #cascode;
		at: VT_CY + 1 put: #cacy;
		at: VT_DATE + 1 put: #cadate;
		at: VT_FILETIME + 1 put: #cafiletime;
		at: VT_CLSID + 1 put: #cauuid;
		at: VT_CF + 1 put: #caclipdata;
		at: VT_BSTR + 1 put: #cabstr;
		at: VT_LPSTR + 1 put: #calpstr;
		at: VT_LPWSTR + 1 put: #calpwstr;
		at: VT_VARIANT + 1 put: #capropvar;
		yourself!

defineFields
	"Define the fields of the PROPVARIANT structure.

	PROPVARIANT compileDefinition

		typedef 
		struct tag_PROPVARIANT {
			unsigned short vt;
			BYTE wReserved1;
			BYTE wReserved2;
			ULONG wReserved3;
			union {
				CHAR cVal;
				UCHAR bVal;
				short iVal;
				USHORT uiVal;
				long lVal;
				ULONG ulVal;
				int intVal;
				unsigned int uintVal;
				LARGE_INTEGER hVal;
				ULARGE_INTEGER uhVal;
				float fltVal;
				double dblVal;
				VARIANT_BOOL boolVal;
				VARIANT_BOOL __OBSOLETE__VARIANT_BOOL;
				SCODE scode;
				CY cyVal;
				DATE date;
				FILETIME filetime;
				GUID* puuid;
				CLIPDATA* pClipData;
				BSTR bstrVal;
				BSTRBLOB bstrblobVal;
				BLOB blob;
				LPSTR pszVal;
				LPWSTR pwszVal;
				IUnknown* punkVal;
				IDispatch* pdispVal;
				IStream* pStream;
				IStorage* pStorage;
				VersionedStream* pVersionedStream;
				wirePSAFEARRAY parray;
				CAC cac;
				CAUB caub;
				CAI cai;
				CAUI caui;
				CAL cal;
				CAUL caul;
				CAH cah;
				CAUH cauh;
				CAFLT caflt;
				CADBL cadbl;
				CABOOL cabool;
				CASCODE cascode;
				CACY cacy;
				CADATE cadate;
				CAFILETIME cafiletime;
				CACLSID cauuid;
				CACLIPDATA caclipdata;
				CABSTR cabstr;
				CABSTRBLOB cabstrblob;
				CALPSTR calpstr;
				CALPWSTR calpwstr;
				CAPROPVARIANT capropvar;
				CHAR* pcVal;
				UCHAR* pbVal;
				short* piVal;
				USHORT* puiVal;
				long* plVal;
				ULONG* pulVal;
				int* pintVal;
				unsigned int* puintVal;
				float* pfltVal;
				double* pdblVal;
				VARIANT_BOOL* pboolVal;
				DECIMAL* pdecVal;
				SCODE* pscode;
				CY* pcyVal;
				DATE* pdate;
				BSTR* pbstrVal;
				IUnknown** ppunkVal;
				IDispatch** ppdispVal;
				wirePSAFEARRAY* pparray;
				PROPVARIANT* pvarVal;
			};
		} PROPVARIANT;

	Note that we exclude CLIPDATA and CACLIPDATA as the use of clipboard formats in properties is for legacy support only, and unlikely to be encountered today."

	super defineFields.
	self
		defineField: #hVal type: Int64Field filler offset: 8;
		defineField: #uhVal type: UInt64Field filler offset: 8;
		defineField: #__OBSOLETE__VARIANT_BOOL type: Int16Field filler offset: 8;
		defineField: #filetime type: (StructureField type: FILETIME) beFiller offset: 8;
		defineField: #puuid type: (PointerField type: GUID) beFiller offset: 8;
		defineField: #bstrblobVal type: (StructureField type: BLOB) beFiller offset: 8;
		defineField: #blob type: (StructureField type: BLOB) beFiller offset: 8;
		defineField: #pszVal type: (PointerField type: AnsiString) beFiller offset: 8;
		defineField: #pwszVal type: (PointerField type: Utf16String) beFiller offset: 8;
		defineField: #pStream type: (PointerField type: IStream) beFiller offset: 8;
		defineField: #pStorage type: (PointerField type: IStorage) beFiller offset: 8;
		defineField: #pVersionedStream type: (PointerField type: VersionedStream) beFiller offset: 8;
		defineField: #cac type: (StructureField type: CAC) beReadOnly offset: 8;
		defineField: #caub type: (StructureField type: CAUB) beReadOnly offset: 8;
		defineField: #cai type: (StructureField type: CAI) beReadOnly offset: 8;
		defineField: #caui type: (StructureField type: CAUI) beReadOnly offset: 8;
		defineField: #cal type: (StructureField type: CAL) beReadOnly offset: 8;
		defineField: #caul type: (StructureField type: CAUL) beReadOnly offset: 8;
		defineField: #cah type: (StructureField type: CAH) beReadOnly offset: 8;
		defineField: #cauh type: (StructureField type: CAUH) beReadOnly offset: 8;
		defineField: #caflt type: (StructureField type: CAFLT) beReadOnly offset: 8;
		defineField: #cadbl type: (StructureField type: CADBL) beReadOnly offset: 8;
		defineField: #cabool type: (StructureField type: CABOOL) beReadOnly offset: 8;
		defineField: #cascode type: (StructureField type: CASCODE) beReadOnly offset: 8;
		defineField: #cacy type: (StructureField type: CACY) beReadOnly offset: 8;
		defineField: #cadate type: (StructureField type: CADATE) beReadOnly offset: 8;
		defineField: #cafiletime type: (StructureField type: CAFILETIME) beReadOnly offset: 8;
		defineField: #cauuid type: (StructureField type: CACLSID) beReadOnly offset: 8;
		defineField: #cabstr type: (StructureField type: CABSTR) beReadOnly offset: 8;
		defineField: #calpstr type: (StructureField type: CALPSTR) beReadOnly offset: 8;
		defineField: #calpwstr type: (StructureField type: CALPOLESTR) beReadOnly offset: 8;
		defineField: #capropvar type: (StructureField type: CAPROPVARIANT) beReadOnly offset: 8;
		defineField: #pvarVal type: (PointerField type: PROPVARIANT) beFiller offset: 8.
	self byteSize: 16!

getFieldNames
	^#(#vt #cabool #cabstr #cac #cacy #cadate #cadbl #cafiletime #caflt #cah #cai #cal #calpstr #calpwstr #capropvar #cascode #caub #cauh #caui #caul #cauuid)!

init: buffer
	"Initialize a buffer (or buffer at the specified address) to hold an instance of the record type
	described by the receiver. Assumes that the memory is completely uninitialized."

	Ole32 propVariantInit: buffer!

initialize
	"Private - Initialize the receiver's class variables.
		PROPVARIANT initialize
	"

	self addClassConstant: 'CountedArrayNames' value: self countedArrayNames! !

!OS.COM.PROPVARIANT class categoriesForMethods!
arrayType!constants!public! !
byteSize!**compiled accessors**!constants!public! !
clear:!public!realizing/unrealizing! !
countedArrayNames!constants!private! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
init:!initializing!public! !
initialize!development!initializing!private! !
!

