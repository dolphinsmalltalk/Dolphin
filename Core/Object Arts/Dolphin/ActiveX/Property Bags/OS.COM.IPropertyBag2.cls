"Filed out from Dolphin Smalltalk 7"!

OS.COM.IUnknown subclass: #'OS.COM.IPropertyBag2'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.COM.IPropertyBag2 guid: (OS.COM.IID fromString: '{22f55882-280b-11d0-a8a9-00a0c90c2004}')!
OS.COM.IPropertyBag2 comment: '`OS.COM.IPropertyBag2` is a wrapper class for the COM interface ''Win32.IPropertyBag2'' generated from type information in the ''Win32 API'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated. **

IDL definition follows:
```
[
	object, 
	uuid(22f55882-280b-11d0-a8a9-00a0c90c2004)
]
interface IPropertyBag2 : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Read(
		[in]ULONG cProperties,
		[in]PROPBAG2* pPropBag,
		[in]IErrorLog* pErrLog,
		[out]VARIANT* pvarValue,
		[in, out]HRESULT* phrError);
	[id(0x60010001)]
	HRESULT __stdcall Write(
		[in]ULONG cProperties,
		[in]PROPBAG2* pPropBag,
		[in]VARIANT* pvarValue);
	[id(0x60010002)]
	HRESULT __stdcall CountProperties(
		[out]ULONG* pcProperties);
	[id(0x60010003)]
	HRESULT __stdcall GetPropertyInfo(
		[in]ULONG iProperty,
		[in]ULONG cProperties,
		[out]PROPBAG2* pPropBag,
		[out]ULONG* pcProperties);
	[id(0x60010004)]
	HRESULT __stdcall LoadObject(
		[in]LPWSTR pstrName,
		[in]DWORD dwHint,
		[in]IUnknown* punkObject,
		[in]IErrorLog* pErrLog);
};
```
'!
!OS.COM.IPropertyBag2 categoriesForClass!COM-Interfaces! !
!OS.COM.IPropertyBag2 methodsFor!

countProperties
	"Answer the <DWORD> result of invoking the CountProperties() method of the COM object."

	| answer |
	answer := DWORD new.
	self CountProperties: answer.
	^answer asObject!

CountProperties: pcProperties
	"Private - Invoke the CountProperties() method of the COM object.

		HRESULT __stdcall CountProperties(
			[out]ULONG* pcProperties);"

	<virtual stdcall: hresult 6 dword*>
	^self invalidCall: _failureCode!

getPropertyInfo: iProperty cProperties: cProperties
	"Invoke the GetPropertyInfo() method of the COM object."

	| outputs |
	outputs := {PROPBAG2 new. DWORD new}.
	self
		GetPropertyInfo: iProperty
		cProperties: cProperties
		pPropBag: (outputs basicAt: 1)
		pcProperties: (outputs basicAt: 2).
	^outputs collect: [:each | each asObject]!

GetPropertyInfo: iProperty cProperties: cProperties pPropBag: pPropBag pcProperties: pcProperties
	"Private - Invoke the GetPropertyInfo() method of the COM object.

		HRESULT __stdcall GetPropertyInfo(
			[in]ULONG iProperty,
			[in]ULONG cProperties,
			[out]PROPBAG2* pPropBag,
			[out]ULONG* pcProperties);"

	<virtual stdcall: hresult 7 dword dword PROPBAG2* dword*>
	^self invalidCall: _failureCode!

loadObject: pstrName dwHint: dwHint punkObject: punkObject pErrLog: pErrLog
	"Invoke the LoadObject() method of the COM object."

	^self
		LoadObject: pstrName asUtf16String
		dwHint: dwHint
		punkObject: punkObject
		pErrLog: pErrLog!

LoadObject: pstrName dwHint: dwHint punkObject: punkObject pErrLog: pErrLog
	"Private - Invoke the LoadObject() method of the COM object.

		HRESULT __stdcall LoadObject(
			[in]LPWSTR pstrName,
			[in]DWORD dwHint,
			[in]IUnknown* punkObject,
			[in]IErrorLog* pErrLog);"

	<virtual stdcall: hresult 8 lpwstr dword IUnknown* IErrorLog*>
	^self invalidCall: _failureCode!

read: cProperties pPropBag: pPropBag pErrLog: pErrLog phrError: phrError
	"Invoke the Read() method of the COM object."

	| outputs |
	outputs := {VARIANT new.
				HRESULT new
					value: phrError;
					yourself}.
	self
		Read: cProperties
		pPropBag: pPropBag
		pErrLog: pErrLog
		pvarValue: (outputs basicAt: 1)
		phrError: (outputs basicAt: 2).
	^outputs collect: [:each | each asObject]!

Read: cProperties pPropBag: pPropBag pErrLog: pErrLog pvarValue: pvarValue phrError: phrError
	"Private - Invoke the Read() method of the COM object.

		HRESULT __stdcall Read(
			[in]ULONG cProperties,
			[in]PROPBAG2* pPropBag,
			[in]IErrorLog* pErrLog,
			[out]VARIANT* pvarValue,
			[in, out]HRESULT* phrError);"

	<virtual stdcall: hresult 4 dword PROPBAG2* IErrorLog* variant* hresult*>
	^self invalidCall: _failureCode!

write: cProperties pPropBag: pPropBag pvarValue: pvarValue
	"Invoke the Write() method of the COM object."

	^self
		Write: cProperties
		pPropBag: pPropBag
		pvarValue: pvarValue asVariant!

Write: cProperties pPropBag: pPropBag pvarValue: pvarValue
	"Private - Invoke the Write() method of the COM object.

		HRESULT __stdcall Write(
			[in]ULONG cProperties,
			[in]PROPBAG2* pPropBag,
			[in]VARIANT* pvarValue);"

	<virtual stdcall: hresult 5 dword PROPBAG2* variant*>
	^self invalidCall: _failureCode! !
!OS.COM.IPropertyBag2 categoriesFor: #countProperties!**auto generated**!methods!public! !
!OS.COM.IPropertyBag2 categoriesFor: #CountProperties:!**auto generated**!COM Interfaces-IPropertyBag2!private! !
!OS.COM.IPropertyBag2 categoriesFor: #getPropertyInfo:cProperties:!**auto generated**!methods!public! !
!OS.COM.IPropertyBag2 categoriesFor: #GetPropertyInfo:cProperties:pPropBag:pcProperties:!**auto generated**!COM Interfaces-IPropertyBag2!private! !
!OS.COM.IPropertyBag2 categoriesFor: #loadObject:dwHint:punkObject:pErrLog:!**auto generated**!methods!public! !
!OS.COM.IPropertyBag2 categoriesFor: #LoadObject:dwHint:punkObject:pErrLog:!**auto generated**!COM Interfaces-IPropertyBag2!private! !
!OS.COM.IPropertyBag2 categoriesFor: #read:pPropBag:pErrLog:phrError:!**auto generated**!methods!public! !
!OS.COM.IPropertyBag2 categoriesFor: #Read:pPropBag:pErrLog:pvarValue:phrError:!**auto generated**!COM Interfaces-IPropertyBag2!private! !
!OS.COM.IPropertyBag2 categoriesFor: #write:pPropBag:pvarValue:!**auto generated**!methods!public! !
!OS.COM.IPropertyBag2 categoriesFor: #Write:pPropBag:pvarValue:!**auto generated**!COM Interfaces-IPropertyBag2!private! !

OS.COM.IPropertyBag2 methodProtocol: #IPropertyBag2 attributes: #(#readOnly) selectors: #(#CountProperties: #GetPropertyInfo:cProperties:pPropBag:pcProperties: #LoadObject:dwHint:punkObject:pErrLog: #Read:pPropBag:pErrLog:pvarValue:phrError: #Write:pPropBag:pvarValue:)!

!OS.COM.IPropertyBag2 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'Win32.IPropertyBag2'
		IPropertyBag2 defineTemplate"

	self
		defineFunction: #Read:pPropBag:pErrLog:pvarValue:phrError:
			argumentTypes: 'dword PROPBAG2* IErrorLog* variant* hresult*';
		defineFunction: #Write:pPropBag:pvarValue:
			argumentTypes: 'dword PROPBAG2* variant*';
		defineFunction: #CountProperties:
			argumentTypes: 'dword*';
		defineFunction: #GetPropertyInfo:cProperties:pPropBag:pcProperties:
			argumentTypes: 'dword dword PROPBAG2* dword*';
		defineFunction: #LoadObject:dwHint:punkObject:pErrLog:
			argumentTypes: 'lpwstr dword IUnknown* IErrorLog*'
! !
!OS.COM.IPropertyBag2 class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

