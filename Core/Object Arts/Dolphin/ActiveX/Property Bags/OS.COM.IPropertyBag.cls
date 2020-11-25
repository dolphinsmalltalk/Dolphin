"Filed out from Dolphin Smalltalk 7"!

IUnknown subclass: #IPropertyBag
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
IPropertyBag guid: (IID fromString: '{55272a00-42cb-11ce-8135-00aa004bb851}')!
IPropertyBag comment: '`IPropertyBag` is a wrapper class for the COM interface ''Win32.IPropertyBag'' generated from type information in the ''Win32 API'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated. **

IDL definition follows:
```
[
	object, 
	uuid(55272a00-42cb-11ce-8135-00aa004bb851)
]
interface IPropertyBag : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall RemoteRead(
		[in]LPWSTR pszPropName,
		[out]VARIANT* pVar,
		[in]IErrorLog* pErrorLog,
		[in]unsigned long varType,
		[in]IUnknown* pUnkObj);
	[id(0x60010001)]
	HRESULT __stdcall Write(
		[in]LPWSTR pszPropName,
		[in]VARIANT* pVar);
};
```
'!
!IPropertyBag categoriesForClass!COM-Interfaces! !
!IPropertyBag methodsFor!

read: pszPropName pErrorLog: pErrorLog
	"Answer the <VARIANT> result of invoking the RemoteRead() method of the COM object."

	| answer |
	answer := VARIANT new.
	self
		Read: pszPropName asUtf16String
		pVar: answer
		pErrorLog: pErrorLog.
	^answer asObject!

Read: pszPropName pVar: pVar pErrorLog: pErrorLog
	"Private - Invoke the RemoteRead() method of the COM object.

		HRESULT __stdcall Read(
			[in]LPWSTR pszPropName,
			[out]VARIANT* pVar,
			[in]IErrorLog* pErrorLog);"

	<virtual stdcall: hresult 4 lpwstr variant* IErrorLog*>
	^self invalidCall: _failureCode!

write: pszPropName pVar: pVar
	"Invoke the Write() method of the COM object."

	^self Write: pszPropName asUtf16String pVar: pVar asVariant!

Write: pszPropName pVar: pVar
	"Private - Invoke the Write() method of the COM object.

		HRESULT __stdcall Write(
			[in]LPWSTR pszPropName,
			[in]VARIANT* pVar);"

	<virtual stdcall: hresult 5 lpwstr variant*>
	^self invalidCall: _failureCode! !
!IPropertyBag categoriesFor: #read:pErrorLog:!**auto generated**!methods!public! !
!IPropertyBag categoriesFor: #Read:pVar:pErrorLog:!**auto generated**!COM Interfaces-IPropertyBag!private! !
!IPropertyBag categoriesFor: #write:pVar:!**auto generated**!methods!public! !
!IPropertyBag categoriesFor: #Write:pVar:!**auto generated**!COM Interfaces-IPropertyBag!private! !

IPropertyBag methodProtocol: #IPropertyBag attributes: #(#readOnly) selectors: #(#Read:pVar:pErrorLog: #Write:pVar:)!

!IPropertyBag class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'OCIDL.IPropertyBag'
		IPropertyBag defineTemplate
	"

	self
		defineFunction: #Read:pVar:pErrorLog:
			argumentTypes: 'lpwstr VARIANT* IErrorLog*';
		defineFunction: #Write:pVar:
			argumentTypes: 'lpwstr VARIANT*'
! !
!IPropertyBag class categoriesFor: #defineFunctions!initializing!public! !

