"Filed out from Dolphin Smalltalk"!

External.WindowsSystemLibrary
	subclass: #'OS.COM.PropsysLibrary'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.COM.OleVariant private})
	classInstanceVariableNames: ''
	classConstants: { 'PSTF_LOCAL' -> 16r1. 'PSTF_UTC' -> 16r0 }!

OS.COM.PropsysLibrary guid: (Core.GUID fromString: '{7f032cc8-dc68-4f93-a985-07d986d746b3}')!

OS.COM.PropsysLibrary comment: ''!

!OS.COM.PropsysLibrary methodsFor!

clearVariantArray: pvars cVars: cVars
	"Frees the memory and references used by an array of VARIANT structures stored in an array.

	void ClearVariantArray(
		_Inout_updates_(cVars) PROPVARIANT *pvars, 
		_In_ UINT cVars)
	);"

	<stdcall: void ClearVariantArray VARIANT* uint32>
	^self invalidCall: _failureCode!

initVariantFromBooleanArray: prgf cElems: cElems pvar: aVARIANT
	"Initializes a VARIANT structure using the contents of a buffer.

	HRESULT InitVariantFromBooleanArray(
		[in]  const BOOL *prgf,
		[in]  ULONG        cElems,
		[out] VARIANT *pvar
	);"

	<stdcall: hresult InitVariantFromBooleanArray varbool* uint32 variant*>
	^self invalidCall: _failureCode!

initVariantFromBuffer: pv cb: cb pvar: aVARIANT
	"Initializes a VARIANT structure using the contents of a buffer.

	HRESULT InitVariantFromBuffer(
		[in]  const void  *pv,
		[in]  UINT        cb,
		[out] PROPVARIANT *ppropvar
	);"

	<stdcall: hresult InitVariantFromBuffer lpvoid uint32 variant*>
	^self invalidCall: _failureCode!

initVariantFromDoubleArray: prgn cElems: cElems pvar: aVARIANT
	"Initializes a VARIANT structure using the contents of a buffer.

	HRESULT InitVariantFromDoubleArray(
		[in]  const DOUBLE *prgn,
		[in]  ULONG        cElems,
		[out] VARIANT *pvar
	);"

	<stdcall: hresult InitVariantFromDoubleArray double* uint32 variant*>
	^self invalidCall: _failureCode!

initVariantFromInt16Array: prgn cElems: cElems pvar: aVARIANT
	"Initializes a VARIANT structure with a SAFEARRAY of integers.

	HRESULT InitVariantFromInt16Array(
		[in]  const SHORT *prgn,
		[in]  ULONG        cElems,
		[out] VARIANT *pvar
	);"

	<stdcall: hresult InitVariantFromInt16Array int16* uint32 variant*>
	^self invalidCall: _failureCode!

initVariantFromInt32Array: prgn cElems: cElems pvar: aVARIANT
	"Initializes a VARIANT structure with a SAFEARRAY of integers.

	HRESULT InitVariantFromInt32Array(
		[in]  const LONG*prgn,
		[in]  ULONG        cElems,
		[out] VARIANT *pvar
	);"

	<stdcall: hresult InitVariantFromInt32Array int32* uint32 variant*>
	^self invalidCall: _failureCode!

initVariantFromInt64Array: prgn cElems: cElems pvar: aVARIANT
	"Initializes a VARIANT structure with a SAFEARRAY of integers.

	HRESULT InitVariantFromInt64Array(
		[in]  const LONGLONG* prgn,
		[in]  ULONG        cElems,
		[out] VARIANT *pvar
	);"

	<stdcall: hresult InitVariantFromInt64Array int64* uint32 variant*>
	^self invalidCall: _failureCode!

initVariantFromString: aString pvar: aVARIANT
	"Initializes a VARIANT structure with a string.

	HRESULT InitVariantFromString(
		[in]  PCWSTR	psz,
		[out] VARIANT	*pvar
	);"

	"Implemented inline in the propvarutil.h header file."

	| bstr |
	(bstr := aString asBSTR) == aString ifTrue: [bstr := bstr copy].
	aVARIANT bytes
		uintPtrAtOffset: _OffsetOf_bstrVal put: bstr detach;
		uint16AtOffset: _OffsetOf_vt put: VT_BSTR.
	^S_OK!

initVariantFromStringArray: prgsz cElems: cElems pvar: aVARIANT
	"Initializes a VARIANT structure using the contents of a buffer.

	HRESULT InitVariantFromStringVector(
		[in]  PCWSTR *prgsz,
		[in]  ULONG        cElems,
		[out] VARIANT *pvar
	);"

	<stdcall: hresult InitVariantFromStringArray lpwstr* uint32 VARIANT*>
	^self invalidCall: _failureCode!

initVariantFromUInt16Array: prgn cElems: cElems pvar: aVARIANT
	"Initializes a VARIANT structure with a SAFEARRAY of integers.

	HRESULT InitVariantFromUInt16Array(
		[in]  const USHORT *prgn,
		[in]  ULONG        cElems,
		[out] VARIANT *pvar
	);"

	<stdcall: hresult InitVariantFromUInt16Array uint16* uint32 variant*>
	^self invalidCall: _failureCode!

initVariantFromUInt32Array: prgn cElems: cElems pvar: aVARIANT
	"Initializes a VARIANT structure with a SAFEARRAY of integers.

	HRESULT InitVariantFromUInt32Array(
		[in]  const ULONG* prgn,
		[in]  ULONG        cElems,
		[out] VARIANT *pvar
	);"

	<stdcall: hresult InitVariantFromUInt32Array uint32* uint32 variant*>
	^self invalidCall: _failureCode!

initVariantFromUInt64Array: prgn cElems: cElems pvar: aVARIANT
	"Initializes a VARIANT structure with a SAFEARRAY of integers.

	HRESULT InitVariantFromUInt64Array(
		[in]  const ULONGLONG* prgn,
		[in]  ULONG        cElems,
		[out] VARIANT *pvar
	);"

	<stdcall: hresult InitVariantFromUInt64Array uint64* uint32 variant*>
	^self invalidCall: _failureCode!

variantGetElementCount: varIn
	"Get the element count of a VARIANT.  Returns number of elements for values of type VT_ARRAY; returns 1 otherwise.

	ULONG VariantGetElementCount(_In_ REFVARIANT varIn);"

	<stdcall: uint32 VariantGetElementCount variant*>
	^self invalidCall: _failureCode!

variantToBooleanArray: pvar prgf: prgf crgn: crgn pcElem: pcElem
	"Extracts an array of Boolean values from a VARIANT structure of type (VT_ARRAY | VT_BOOL).

	HRESULT VariantToBooleanArray(
		_In_ REFVARIANT propvar,
		_Out_writes_to_(crgn, *pcElem) BOOL *prgf, 
		_In_ ULONG crgn, 
		_Out_ ULONG *pcElem);"

	<stdcall: hresult VariantToBooleanArray VARIANT* BOOL* uint32 uint32*>
	^self invalidCall: _failureCode!

variantToBuffer: varIn pv: pv cb: cb
	"Extracts the contents of a buffer stored in a VARIANT structure of type VT_ARRRAY | VT_UI1.

	HRESULT VariantToBuffer(
		_In_ REFVARIANT varIn,
		_Out_writes_bytes_(cb) void *pv, 
		_In_ ULONG cb);"

	<stdcall: hresult VariantToBuffer VARIANT* void* uint32>
	^self invalidCall: _failureCode!

variantToDoubleArray: pvar prgn: prgn crgn: crgn pcElem: pcElem
	"Extracts an array of double precision floating point values from a VARIANT structure of type (VT_ARRAY | VT_R8).

	HRESULT VariantToBooleanArray(
		_In_ REFVARIANT propvar,
		_Out_writes_to_(crgn, *pcElem) DOUBLE *prgn, 
		_In_ ULONG crgn, 
		_Out_ ULONG *pcElem);"

	<stdcall: hresult VariantToDoubleArray VARIANT* double* uint32 uint32*>
	^self invalidCall: _failureCode!

variantToFileTime: propVar pstfOut: pstfOut pftOut: pftOut
	"Extracts a FILETIME structure from a variant structure.

	HRESULT VariantToFileTime(
		[in]  REFVARIANT	varIn,
		[in]  PSTIME_FLAGS	pstfOut,
		[out] FILETIME		*pftOut
	);"

	<stdcall: hresult VariantToFileTime VARIANT* uint32 FILETIME*>
	^self invalidCall: _failureCode!

variantToInt16Array: pvar prgn: prgn crgn: crgn pcElem: pcElem
	"Extracts an array of signed 16-bit integer values from a VARIANT structure of type (VT_ARRAY | VT_I2).

	HRESULT VariantToBooleanArray(
		_In_ REFVARIANT propvar,
		_Out_writes_to_(crgn, *pcElem) SHORT *prgn, 
		_In_ ULONG crgn, 
		_Out_ ULONG *pcElem);"

	<stdcall: hresult VariantToInt16Array VARIANT* int16* uint32 uint32*>
	^self invalidCall: _failureCode!

variantToInt32Array: pvar prgn: prgn crgn: crgn pcElem: pcElem
	"Extracts an array of signed 32-bit integer values from a VARIANT structure of type (VT_ARRAY | VT_I4).

	HRESULT VariantToInt32Array(
		_In_ REFVARIANT propvar,
		_Out_writes_to_(crgn, *pcElem) LONG *prgn, 
		_In_ ULONG crgn, 
		_Out_ ULONG *pcElem);"

	<stdcall: hresult VariantToInt32Array VARIANT* int32* uint32 uint32*>
	^self invalidCall: _failureCode!

variantToInt64Array: pvar prgn: prgn crgn: crgn pcElem: pcElem
	"Extracts an array of signed 64-bit integer values from a VARIANT structure of type (VT_ARRAY | VT_I4).

	HRESULT VariantToInt64Array(
		_In_ REFVARIANT propvar,
		_Out_writes_to_(crgn, *pcElem) LONGLONG *prgn, 
		_In_ ULONG crgn, 
		_Out_ ULONG *pcElem);"

	<stdcall: hresult VariantToInt64Array VARIANT* int64* uint32 uint32*>
	^self invalidCall: _failureCode!

variantToStringArray: pvar prgsz: prgsz crgsz: crgsz pcElem: pcElem
	"Extracts data from a VARIANT structure of type (VT_ARRAY | VT_BSTR) into a String array.

	HRESULT VariantToStringArray(
		_In_ REFVARIANT var,
		_Out_writes_to_(crgsz, *pcElem) PWSTR *prgsz,
		_In_ ULONG crgsz,
		_Out_ ULONG *pcElem);;"

	<stdcall: hresult VariantToStringArray VARIANT* lpwstr* uint32 uint32*>
	^self invalidCall: _failureCode!

variantToUInt16Array: pvar prgn: prgn crgn: crgn pcElem: pcElem
	"Extracts an array of unsigned 16-bit integer values from a VARIANT structure of type (VT_ARRAY | VT_UI2).

	HRESULT VariantToUInt16Array(
		_In_ REFVARIANT propvar,
		_Out_writes_to_(crgn, *pcElem) USHORT *prgn, 
		_In_ ULONG crgn, 
		_Out_ ULONG *pcElem);"

	<stdcall: hresult VariantToUInt16Array VARIANT* uint16* uint32 uint32*>
	^self invalidCall: _failureCode!

variantToUInt32Array: pvar prgn: prgn crgn: crgn pcElem: pcElem
	"Extracts an array of unsigned 32-bit integer values from a VARIANT structure of type (VT_ARRAY | VT_UI4).

	HRESULT VariantToUInt32Array(
		_In_ REFVARIANT propvar,
		_Out_writes_to_(crgn, *pcElem) ULONG *prgn, 
		_In_ ULONG crgn, 
		_Out_ ULONG *pcElem);"

	<stdcall: hresult VariantToUInt32Array VARIANT* uint32* uint32 uint32*>
	^self invalidCall: _failureCode!

variantToUInt64Array: pvar prgn: prgn crgn: crgn pcElem: pcElem
	"Extracts an array of unsigned 64-bit integer values from a VARIANT structure of type (VT_ARRAY | VT_UI8).

	HRESULT VariantToUInt64Array(
		_In_ REFVARIANT propvar,
		_Out_writes_to_(crgn, *pcElem) ULONGLONG *prgn, 
		_In_ ULONG crgn, 
		_Out_ ULONG *pcElem);"

	<stdcall: hresult VariantToUInt64Array VARIANT* uint64* uint32 uint32*>
	^self invalidCall: _failureCode! !

!OS.COM.PropsysLibrary categoriesForMethods!
clearVariantArray:cVars:!Automation Functions-Variant Manipulation!public! !
initVariantFromBooleanArray:cElems:pvar:!Automation Functions-Variant Manipulation!public! !
initVariantFromBuffer:cb:pvar:!Automation Functions-Variant Manipulation!public! !
initVariantFromDoubleArray:cElems:pvar:!Automation Functions-Variant Manipulation!public! !
initVariantFromInt16Array:cElems:pvar:!Automation Functions-Variant Manipulation!public! !
initVariantFromInt32Array:cElems:pvar:!Automation Functions-Variant Manipulation!public! !
initVariantFromInt64Array:cElems:pvar:!Automation Functions-Variant Manipulation!public! !
initVariantFromString:pvar:!Automation Functions-Variant Manipulation!public! !
initVariantFromStringArray:cElems:pvar:!Automation Functions-Variant Manipulation!public! !
initVariantFromUInt16Array:cElems:pvar:!Automation Functions-Variant Manipulation!public! !
initVariantFromUInt32Array:cElems:pvar:!Automation Functions-Variant Manipulation!public! !
initVariantFromUInt64Array:cElems:pvar:!Automation Functions-Variant Manipulation!public! !
variantGetElementCount:!Automation Functions-Variant Manipulation!public! !
variantToBooleanArray:prgf:crgn:pcElem:!Automation Functions-Variant Manipulation!public! !
variantToBuffer:pv:cb:!Automation Functions-Variant Manipulation!public! !
variantToDoubleArray:prgn:crgn:pcElem:!Automation Functions-Variant Manipulation!public! !
variantToFileTime:pstfOut:pftOut:!Automation Functions-Variant Manipulation!public! !
variantToInt16Array:prgn:crgn:pcElem:!Automation Functions-Variant Manipulation!public! !
variantToInt32Array:prgn:crgn:pcElem:!Automation Functions-Variant Manipulation!public! !
variantToInt64Array:prgn:crgn:pcElem:!Automation Functions-Variant Manipulation!public! !
variantToStringArray:prgsz:crgsz:pcElem:!Automation Functions-Variant Manipulation!public! !
variantToUInt16Array:prgn:crgn:pcElem:!Automation Functions-Variant Manipulation!public! !
variantToUInt32Array:prgn:crgn:pcElem:!Automation Functions-Variant Manipulation!public! !
variantToUInt64Array:prgn:crgn:pcElem:!Automation Functions-Variant Manipulation!public! !
!

!OS.COM.PropsysLibrary class methodsFor!

fileName
	"Answer the host system file name of the external library which the receiver represents."

	^'propsys'!

sharedVariableName
	^#{OS.COM.Propsys}! !

!OS.COM.PropsysLibrary class categoriesForMethods!
fileName!constants!public! !
sharedVariableName!constants!private! !
!

