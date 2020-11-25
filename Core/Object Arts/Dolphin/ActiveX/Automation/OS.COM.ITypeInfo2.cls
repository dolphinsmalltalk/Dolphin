"Filed out from Dolphin Smalltalk 7"!

ITypeInfo subclass: #ITypeInfo2
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ITypeInfo2 guid: (IID fromString: '{00020412-0000-0000-c000-000000000046}')!
ITypeInfo2 comment: '''ITypeInfo2 is an interface pointer class to wrap COM interfaces of the same name.

ITypeInfo2 is a refinement of ITypeInfo which adds some bits Microsoft forget about when the defined ITypeInfo, it also adds some capabilities to look up certain pieces of commonly used information that probably made VB quicker. However as we cache the TYPEATTR once retrieved, it is unlikely that ITypeInfo2 will be quicker within Dolphin.
'!
!ITypeInfo2 categoriesForClass!COM-Interfaces! !
!ITypeInfo2 methodsFor!

getAllCustData
	"Answer the <CUSTDATA> result of invoking the COM Object's GetAllCustData() method."

	| pCustData |
	pCustData := CUSTDATA new.
	self GetAllCustData: pCustData.
	^pCustData value
!

GetAllCustData: pCustData
	"Private - Invoke the GetAllCustData() method of the COM object wrapped by the receiver.

		HRESULT __stdcall GetAllCustData(
			[out] CUSTDATA* pCustData);
	"

	<virtual stdcall: hresult 33 CUSTDATA*>
	^self invalidCall: _failureCode!

getAllFuncCustData: index 
	"Answer the <CUSTDATA> result of invoking the COM Object's GetAllFuncCustData() method."

	| pCustData |
	pCustData := CUSTDATA new.
	self GetAllFuncCustData: index pCustData: pCustData.
	^pCustData value
!

GetAllFuncCustData: index pCustData: pCustData
	"Private - Invoke the GetAllFuncCustData() method of the COM object wrapped by the receiver.

		HRESULT __stdcall GetAllFuncCustData(
			[in] unsigned int index,
			[out] CUSTDATA* pCustData);
	"

	<virtual stdcall: hresult 34 dword CUSTDATA*>
	^self invalidCall: _failureCode!

getAllImplTypeCustData: index 
	"Answer the <CUSTDATA> result of invoking the COM Object's GetAllImplTypeCustData() method."

	| pCustData |
	pCustData := CUSTDATA new.
	self GetAllImplTypeCustData: index pCustData: pCustData.
	^pCustData value
!

GetAllImplTypeCustData: index pCustData: pCustData
	"Private - Invoke the GetAllImplTypeCustData() method of the COM object wrapped by the receiver.

		HRESULT __stdcall GetAllImplTypeCustData(
			[in] unsigned int index,
			[out] CUSTDATA* pCustData);
	"

	<virtual stdcall: hresult 37 dword CUSTDATA*>
	^self invalidCall: _failureCode!

getAllParamCustData: indexFunc indexParam: indexParam 
	"Answer the <CUSTDATA> result of invoking the COM Object's GetAllParamCustData() method."

	| pCustData |
	pCustData := CUSTDATA new.
	self GetAllParamCustData: indexFunc indexParam: indexParam pCustData: pCustData.
	^pCustData value
!

GetAllParamCustData: indexFunc indexParam: indexParam pCustData: pCustData
	"Private - Invoke the GetAllParamCustData() method of the COM object wrapped by the receiver.

		HRESULT __stdcall GetAllParamCustData(
			[in] unsigned int indexFunc,
			[in] unsigned int indexParam,
			[out] CUSTDATA* pCustData);
	"

	<virtual stdcall: hresult 35 dword dword CUSTDATA*>
	^self invalidCall: _failureCode!

getAllVarCustData: index 
	"Answer the <CUSTDATA> result of invoking the COM Object's GetAllVarCustData() method."

	| pCustData |
	pCustData := CUSTDATA new.
	self GetAllVarCustData: index pCustData: pCustData.
	^pCustData value
!

GetAllVarCustData: index pCustData: pCustData
	"Private - Invoke the GetAllVarCustData() method of the COM object wrapped by the receiver.

		HRESULT __stdcall GetAllVarCustData(
			[in] unsigned int index,
			[out] CUSTDATA* pCustData);
	"

	<virtual stdcall: hresult 36 dword CUSTDATA*>
	^self invalidCall: _failureCode!

getCustData: guid 
	"Answer the <VARIANT> result of invoking the COM Object's GetCustData() method."

	| pVarVal |
	pVarVal := VARIANT new.
	self GetCustData: guid pVarVal: pVarVal asVariant.
	^pVarVal value
!

GetCustData: guid pVarVal: pVarVal
	"Private - Invoke the GetCustData() method of the COM object wrapped by the receiver.

		HRESULT __stdcall GetCustData(
			[in] GUID* guid,
			[out] VARIANT* pVarVal);
	"

	<virtual stdcall: hresult 27 guid* variant*>
	^self invalidCall: _failureCode!

getDocumentation2: memid lcid: lcid
	"Answer a 3 element <Array> containing the results of invoking the COM Object's 
	GetDocumentation2() method."

	| pbstrHelpStringDll pbstrHelpString pdwHelpStringContext |
	pbstrHelpStringDll := BSTR new.
	pbstrHelpString := BSTR new.
	pdwHelpStringContext := DWORDBytes new.
	self
		GetDocumentation2: memid
		lcid: lcid
		pbstrHelpString: pbstrHelpString
		pdwHelpStringContext: pdwHelpStringContext
		pbstrHelpStringDll: pbstrHelpStringDll.
	^{pbstrHelpString value. pdwHelpStringContext asInteger. pbstrHelpStringDll value}!

GetDocumentation2: memid lcid: lcid pbstrHelpString: pbstrHelpString pdwHelpStringContext: pdwHelpStringContext pbstrHelpStringDll: pbstrHelpStringDll
	"Private - Invoke the GetDocumentation2() method of the COM object wrapped by the receiver.

		HRESULT __stdcall GetDocumentation2(
			[in] long memid,
			[in] unsigned long lcid,
			[out] BSTR* pbstrHelpString,
			[out] unsigned long* pdwHelpStringContext,
			[out] BSTR* pbstrHelpStringDll);
	"

	<virtual stdcall: hresult 32 sdword dword bstr* dword* bstr*>
	^self invalidCall: _failureCode!

getFuncCustData: index guid: guid 
	"Answer the <VARIANT> result of invoking the COM Object's GetFuncCustData() method."

	| pVarVal |
	pVarVal := VARIANT new.
	self GetFuncCustData: index guid: guid pVarVal: pVarVal asVariant.
	^pVarVal value
!

GetFuncCustData: index guid: guid pVarVal: pVarVal
	"Private - Invoke the GetFuncCustData() method of the COM object wrapped by the receiver.

		HRESULT __stdcall GetFuncCustData(
			[in] unsigned int index,
			[in] GUID* guid,
			[out] VARIANT* pVarVal);
	"

	<virtual stdcall: hresult 28 dword guid* variant*>
	^self invalidCall: _failureCode!

getFuncIndexOfMemId: memid invkind: invkind 
	"Answer the <DWORD> result of invoking the COM Object's GetFuncIndexOfMemId() method."

	| pFuncIndex |
	pFuncIndex := DWORD new.
	self GetFuncIndexOfMemId: memid invkind: invkind pFuncIndex: pFuncIndex.
	^pFuncIndex value
!

GetFuncIndexOfMemId: memid invkind: invkind pFuncIndex: pFuncIndex
	"Private - Invoke the GetFuncIndexOfMemId() method of the COM object wrapped by the receiver.

		HRESULT __stdcall GetFuncIndexOfMemId(
			[in] long memid,
			[in] INVOKEKIND invkind,
			[out] unsigned int* pFuncIndex);
	"

	<virtual stdcall: hresult 25 sdword sdword dword*>
	^self invalidCall: _failureCode!

getImplTypeCustData: index guid: guid 
	"Answer the <VARIANT> result of invoking the COM Object's GetImplTypeCustData() method."

	| pVarVal |
	pVarVal := VARIANT new.
	self GetImplTypeCustData: index guid: guid pVarVal: pVarVal asVariant.
	^pVarVal value
!

GetImplTypeCustData: index guid: guid pVarVal: pVarVal
	"Private - Invoke the GetImplTypeCustData() method of the COM object wrapped by the receiver.

		HRESULT __stdcall GetImplTypeCustData(
			[in] unsigned int index,
			[in] GUID* guid,
			[out] VARIANT* pVarVal);
	"

	<virtual stdcall: hresult 31 dword guid* variant*>
	^self invalidCall: _failureCode!

getParamCustData: indexFunc indexParam: indexParam guid: guid 
	"Answer the <VARIANT> result of invoking the COM Object's GetParamCustData() method."

	| pVarVal |
	pVarVal := VARIANT new.
	self GetParamCustData: indexFunc indexParam: indexParam guid: guid pVarVal: pVarVal asVariant.
	^pVarVal value
!

GetParamCustData: indexFunc indexParam: indexParam guid: guid pVarVal: pVarVal
	"Private - Invoke the GetParamCustData() method of the COM object wrapped by the receiver.

		HRESULT __stdcall GetParamCustData(
			[in] unsigned int indexFunc,
			[in] unsigned int indexParam,
			[in] GUID* guid,
			[out] VARIANT* pVarVal);
	"

	<virtual stdcall: hresult 29 dword dword guid* variant*>
	^self invalidCall: _failureCode!

GetTypeFlags: pTypeFlags
	"Private - Invoke the GetTypeFlags() method of the COM object wrapped by the receiver.

		HRESULT __stdcall GetTypeFlags(
			[out] unsigned long* pTypeFlags);
	"

	<virtual stdcall: hresult 24 dword*>
	^self invalidCall: _failureCode!

GetTypeKind: pTypeKind
	"Private - Invoke the GetTypeKind() method of the COM object wrapped by the receiver.

		HRESULT __stdcall GetTypeKind(
			[out] TYPEKIND* pTypeKind);
	"

	<virtual stdcall: hresult 23 sdword*>
	^self invalidCall: _failureCode!

getVarCustData: index guid: guid 
	"Answer the <VARIANT> result of invoking the COM Object's GetVarCustData() method."

	| pVarVal |
	pVarVal := VARIANT new.
	self GetVarCustData: index guid: guid pVarVal: pVarVal asVariant.
	^pVarVal value
!

GetVarCustData: index guid: guid pVarVal: pVarVal
	"Private - Invoke the GetVarCustData() method of the COM object wrapped by the receiver.

		HRESULT __stdcall GetVarCustData(
			[in] unsigned int index,
			[in] GUID* guid,
			[out] VARIANT* pVarVal);
	"

	<virtual stdcall: hresult 30 dword guid* variant*>
	^self invalidCall: _failureCode!

getVarIndexOfMemId: memid 
	"Answer the <DWORD> result of invoking the COM Object's GetVarIndexOfMemId() method."

	| pVarIndex |
	pVarIndex := DWORD new.
	self GetVarIndexOfMemId: memid pVarIndex: pVarIndex.
	^pVarIndex value
!

GetVarIndexOfMemId: memid pVarIndex: pVarIndex
	"Private - Invoke the GetVarIndexOfMemId() method of the COM object wrapped by the receiver.

		HRESULT __stdcall GetVarIndexOfMemId(
			[in] long memid,
			[out] unsigned int* pVarIndex);
	"

	<virtual stdcall: hresult 26 sdword dword*>
	^self invalidCall: _failureCode!

typeFlags
	"Answer the receiver's type flags (from the TYPEFLAGS enumeration).
	Implementation Note: The type flags are retrieved directly and are 
	represented there as 32-bits (cf ITypeInfo>>typeFlags)."

	| answer |
	answer := DWORDBytes new.
	self GetTypeFlags: answer.
	^answer asInteger!

typekind
	"Answer the receiver's typekind (a member of the TYPEKIND enumeration)."

	| answer |
	answer := DWORDBytes new.
	self GetTypeKind: answer.
	^answer asSignedInteger! !
!ITypeInfo2 categoriesFor: #getAllCustData!**auto generated**!public! !
!ITypeInfo2 categoriesFor: #GetAllCustData:!COM Interfaces-OAIDL.ITypeInfo2!private! !
!ITypeInfo2 categoriesFor: #getAllFuncCustData:!**auto generated**!public! !
!ITypeInfo2 categoriesFor: #GetAllFuncCustData:pCustData:!COM Interfaces-OAIDL.ITypeInfo2!private! !
!ITypeInfo2 categoriesFor: #getAllImplTypeCustData:!**auto generated**!public! !
!ITypeInfo2 categoriesFor: #GetAllImplTypeCustData:pCustData:!COM Interfaces-OAIDL.ITypeInfo2!private! !
!ITypeInfo2 categoriesFor: #getAllParamCustData:indexParam:!**auto generated**!public! !
!ITypeInfo2 categoriesFor: #GetAllParamCustData:indexParam:pCustData:!COM Interfaces-OAIDL.ITypeInfo2!private! !
!ITypeInfo2 categoriesFor: #getAllVarCustData:!**auto generated**!accessing!public! !
!ITypeInfo2 categoriesFor: #GetAllVarCustData:pCustData:!COM Interfaces-OAIDL.ITypeInfo2!private! !
!ITypeInfo2 categoriesFor: #getCustData:!**auto generated**!public! !
!ITypeInfo2 categoriesFor: #GetCustData:pVarVal:!COM Interfaces-OAIDL.ITypeInfo2!private! !
!ITypeInfo2 categoriesFor: #getDocumentation2:lcid:!accessing!public! !
!ITypeInfo2 categoriesFor: #GetDocumentation2:lcid:pbstrHelpString:pdwHelpStringContext:pbstrHelpStringDll:!COM Interfaces-OAIDL.ITypeInfo2!private! !
!ITypeInfo2 categoriesFor: #getFuncCustData:guid:!**auto generated**!public! !
!ITypeInfo2 categoriesFor: #GetFuncCustData:guid:pVarVal:!COM Interfaces-OAIDL.ITypeInfo2!private! !
!ITypeInfo2 categoriesFor: #getFuncIndexOfMemId:invkind:!**auto generated**!public! !
!ITypeInfo2 categoriesFor: #GetFuncIndexOfMemId:invkind:pFuncIndex:!COM Interfaces-OAIDL.ITypeInfo2!private! !
!ITypeInfo2 categoriesFor: #getImplTypeCustData:guid:!**auto generated**!public! !
!ITypeInfo2 categoriesFor: #GetImplTypeCustData:guid:pVarVal:!COM Interfaces-OAIDL.ITypeInfo2!private! !
!ITypeInfo2 categoriesFor: #getParamCustData:indexParam:guid:!**auto generated**!public! !
!ITypeInfo2 categoriesFor: #GetParamCustData:indexParam:guid:pVarVal:!COM Interfaces-OAIDL.ITypeInfo2!private! !
!ITypeInfo2 categoriesFor: #GetTypeFlags:!COM Interfaces-OAIDL.ITypeInfo2!private! !
!ITypeInfo2 categoriesFor: #GetTypeKind:!COM Interfaces-OAIDL.ITypeInfo2!private! !
!ITypeInfo2 categoriesFor: #getVarCustData:guid:!**auto generated**!public! !
!ITypeInfo2 categoriesFor: #GetVarCustData:guid:pVarVal:!COM Interfaces-OAIDL.ITypeInfo2!private! !
!ITypeInfo2 categoriesFor: #getVarIndexOfMemId:!**auto generated**!public! !
!ITypeInfo2 categoriesFor: #GetVarIndexOfMemId:pVarIndex:!COM Interfaces-OAIDL.ITypeInfo2!private! !
!ITypeInfo2 categoriesFor: #typeFlags!accessing!public! !
!ITypeInfo2 categoriesFor: #typekind!accessing!public! !

!ITypeInfo2 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'OAIDL.ITypeInfo2'
		ITypeInfo2 defineTemplate
	"

	self
		defineFunction: #GetTypeKind:
			argumentTypes: 'sdword*';
		defineFunction: #GetTypeFlags:
			argumentTypes: 'dword*';
		defineFunction: #GetFuncIndexOfMemId:invkind:pFuncIndex:
			argumentTypes: 'sdword sdword dword*';
		defineFunction: #GetVarIndexOfMemId:pVarIndex:
			argumentTypes: 'sdword dword*';
		defineFunction: #GetCustData:pVarVal:
			argumentTypes: 'GUID* VARIANT*';
		defineFunction: #GetFuncCustData:guid:pVarVal:
			argumentTypes: 'dword GUID* VARIANT*';
		defineFunction: #GetParamCustData:indexParam:guid:pVarVal:
			argumentTypes: 'dword dword GUID* VARIANT*';
		defineFunction: #GetVarCustData:guid:pVarVal:
			argumentTypes: 'dword GUID* VARIANT*';
		defineFunction: #GetImplTypeCustData:guid:pVarVal:
			argumentTypes: 'dword GUID* VARIANT*';
		defineFunction: #GetDocumentation2:lcid:pbstrHelpString:pdwHelpStringContext:pbstrHelpStringDll:
			argumentTypes: 'sdword dword bstr* dword* bstr*';
		defineFunction: #GetAllCustData:
			argumentTypes: 'CUSTDATA*';
		defineFunction: #GetAllFuncCustData:pCustData:
			argumentTypes: 'dword CUSTDATA*';
		defineFunction: #GetAllParamCustData:indexParam:pCustData:
			argumentTypes: 'dword dword CUSTDATA*';
		defineFunction: #GetAllVarCustData:pCustData:
			argumentTypes: 'dword CUSTDATA*';
		defineFunction: #GetAllImplTypeCustData:pCustData:
			argumentTypes: 'dword CUSTDATA*'
! !
!ITypeInfo2 class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

