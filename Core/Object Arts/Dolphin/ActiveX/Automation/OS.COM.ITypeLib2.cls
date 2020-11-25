"Filed out from Dolphin Smalltalk 7"!

ITypeLib subclass: #ITypeLib2
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ITypeLib2 guid: (IID fromString: '{00020411-0000-0000-c000-000000000046}')!
ITypeLib2 comment: '<ITypeLib2> is a wrapper class for the COM interface ''OAIDL.ITypeLib2'' generated from type information in the ''Ole Automation Type Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface.

WARNING: This comment was automatically generated from the interface''s type information and any changes made here may be overwritten the next time this wrapper class is so generated.'!
!ITypeLib2 categoriesForClass!COM-Interfaces! !
!ITypeLib2 methodsFor!

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

	<virtual stdcall: hresult 17 CUSTDATA*>
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

	<virtual stdcall: hresult 14 guid* variant*>
	^self invalidCall: _failureCode!

getDocumentation2: memid lcid: lcid
	"Answer thes 3 element <Array> containing the results of invoking the COM Object's GetDocumentation2() method."

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

GetDocumentation2: index lcid: lcid pbstrHelpString: pbstrHelpString pdwHelpStringContext: pdwHelpStringContext pbstrHelpStringDll: pbstrHelpStringDll
	"Private - Invoke the GetDocumentation2() method of the COM object wrapped by the receiver.

		HRESULT __stdcall GetDocumentation2(
			[in] int index,
			[in] unsigned long lcid,
			[out] BSTR* pbstrHelpString,
			[out] unsigned long* pdwHelpStringContext,
			[out] BSTR* pbstrHelpStringDll);
	"

	<virtual stdcall: hresult 16 sdword dword bstr* dword* bstr*>
	^self invalidCall: _failureCode!

getLibStatistics
	"Answer a two element array of integer statistics for the library useful for sizing
	hash tables, etc."

	| pcchUniqueNames pcUniqueNames |
	pcchUniqueNames := DWORD new.
	pcUniqueNames := DWORD new.
	self GetLibStatistics: pcUniqueNames pcchUniqueNames: pcchUniqueNames.
	^{pcUniqueNames asInteger. pcchUniqueNames asInteger}!

GetLibStatistics: pcUniqueNames pcchUniqueNames: pcchUniqueNames
	"Private - Invoke the GetLibStatistics() method of the COM object wrapped by the receiver.

		HRESULT __stdcall GetLibStatistics(
			[out] unsigned long* pcUniqueNames,
			[out] unsigned long* pcchUniqueNames);
	"

	<virtual stdcall: hresult 15 dword* dword*>
	^self invalidCall: _failureCode! !
!ITypeLib2 categoriesFor: #getAllCustData!**auto generated**!public! !
!ITypeLib2 categoriesFor: #GetAllCustData:!COM Interfaces-OAIDL.ITypeLib2!private! !
!ITypeLib2 categoriesFor: #getCustData:!**auto generated**!public! !
!ITypeLib2 categoriesFor: #GetCustData:pVarVal:!COM Interfaces-OAIDL.ITypeLib2!private! !
!ITypeLib2 categoriesFor: #getDocumentation2:lcid:!**auto generated**!public! !
!ITypeLib2 categoriesFor: #GetDocumentation2:lcid:pbstrHelpString:pdwHelpStringContext:pbstrHelpStringDll:!COM Interfaces-OAIDL.ITypeLib2!private! !
!ITypeLib2 categoriesFor: #getLibStatistics!accessing!public! !
!ITypeLib2 categoriesFor: #GetLibStatistics:pcchUniqueNames:!COM Interfaces-OAIDL.ITypeLib2!private! !

!ITypeLib2 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'OAIDL.ITypeLib2'
		ITypeLib2 defineTemplate
	"

	self
		defineFunction: #GetCustData:pVarVal:
			argumentTypes: 'GUID* VARIANT*';
		defineFunction: #GetLibStatistics:pcchUniqueNames:
			argumentTypes: 'dword* dword*';
		defineFunction: #GetDocumentation2:lcid:pbstrHelpString:pdwHelpStringContext:pbstrHelpStringDll:
			argumentTypes: 'sdword dword bstr* dword* bstr*';
		defineFunction: #GetAllCustData:
			argumentTypes: 'CUSTDATA*'
! !
!ITypeLib2 class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

