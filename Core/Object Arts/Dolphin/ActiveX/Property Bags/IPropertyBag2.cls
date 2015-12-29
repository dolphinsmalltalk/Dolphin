"Filed out from Dolphin Smalltalk X6"!

IUnknown subclass: #IPropertyBag2
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IPropertyBag2 guid: (IID fromString: '{22F55882-280B-11D0-A8A9-00A0C90C2004}')!
IPropertyBag2 comment: '<IPropertyBag2> is a wrapper class for the COM interface ''OCIDL.IPropertyBag2'' generated from type information in the ''OCIDL Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

WARNING: This comment was automatically generated from the interface''s type information and any changes made here may be overwritten the next time this wrapper class is so generated.'!
!IPropertyBag2 categoriesForClass!COM-Interfaces! !
!IPropertyBag2 methodsFor!

countProperties
	"Answer the <DWORD> result of invoking the COM Object's CountProperties() method."

	| answer |
	answer := (DWORD new).
	self
		CountProperties: answer.
	^answer asObject
!

CountProperties: pcProperties
	"Private - Invoke the CountProperties() method of the COM object wrapped by the receiver.

		HRESULT __stdcall CountProperties(
			[out] unsigned long* pcProperties);
	"

	<virtual stdcall: hresult 6 dword*>
	^self invalidCall
!

getPropertyInfo: iProperty cProperties: cProperties 
	"Invoke the GetPropertyInfo() method of the COM Object."

	| answer |
	answer := (Array new: 2)
				basicAt: 1 put: (PROPBAG2 new);
				basicAt: 2 put: (DWORD new);
				yourself.
	self
		GetPropertyInfo: iProperty
		cProperties: cProperties
		pPropBag: (answer basicAt: 1)
		pcProperties: (answer basicAt: 2).
	^answer collect: [:e | e asObject]
!

GetPropertyInfo: iProperty cProperties: cProperties pPropBag: pPropBag pcProperties: pcProperties
	"Private - Invoke the GetPropertyInfo() method of the COM object wrapped by the receiver.

		HRESULT __stdcall GetPropertyInfo(
			[in] unsigned long iProperty,
			[in] unsigned long cProperties,
			[out] PROPBAG2* pPropBag,
			[out] unsigned long* pcProperties);
	"

	<virtual stdcall: hresult 7 dword dword PROPBAG2* dword*>
	^self invalidCall
!

loadObject: pstrName dwHint: dwHint punkObject: punkObject pErrLog: pErrLog 
	"Invoke the LoadObject() method of the COM Object."

	self
		LoadObject: pstrName asUnicodeString
		dwHint: dwHint
		punkObject: punkObject
		pErrLog: pErrLog
!

LoadObject: pstrName dwHint: dwHint punkObject: punkObject pErrLog: pErrLog
	"Private - Invoke the LoadObject() method of the COM object wrapped by the receiver.

		HRESULT __stdcall LoadObject(
			[in] LPWSTR pstrName,
			[in] unsigned long dwHint,
			[in] IUnknown* punkObject,
			[in] IErrorLog* pErrLog);
	"

	<virtual stdcall: hresult 8 lpwstr dword IUnknown* IErrorLog*>
	^self invalidCall
!

read: cProperties pPropBag: pPropBag pErrLog: pErrLog 
	"Invoke the Read() method of the COM Object."

	| answer |
	answer := (Array new: 2)
				basicAt: 1 put: VARIANT new;
				basicAt: 2 put: (HRESULT new);
				yourself.
	self
		Read: cProperties
		pPropBag: pPropBag
		pErrLog: pErrLog
		pvarValue: (answer basicAt: 1)
		phrError: (answer basicAt: 2).
	^answer collect: [:e | e asObject]
!

Read: cProperties pPropBag: pPropBag pErrLog: pErrLog pvarValue: pvarValue phrError: phrError
	"Private - Invoke the Read() method of the COM object wrapped by the receiver.

		HRESULT __stdcall Read(
			[in] unsigned long cProperties,
			[in] PROPBAG2* pPropBag,
			[in] IErrorLog* pErrLog,
			[out] VARIANT* pvarValue,
			[out] HRESULT* phrError);
	"

	<virtual stdcall: hresult 4 dword PROPBAG2* IErrorLog* VARIANT* hresult*>
	^self invalidCall
!

write: cProperties pPropBag: pPropBag pvarValue: pvarValue 
	"Invoke the Write() method of the COM Object."

	self
		Write: cProperties
		pPropBag: pPropBag
		pvarValue: pvarValue asVariant
!

Write: cProperties pPropBag: pPropBag pvarValue: pvarValue
	"Private - Invoke the Write() method of the COM object wrapped by the receiver.

		HRESULT __stdcall Write(
			[in] unsigned long cProperties,
			[in] PROPBAG2* pPropBag,
			[in] VARIANT* pvarValue);
	"

	<virtual stdcall: hresult 5 dword PROPBAG2* VARIANT*>
	^self invalidCall
! !
!IPropertyBag2 categoriesFor: #countProperties!**auto generated**!methods!public! !
!IPropertyBag2 categoriesFor: #CountProperties:!**auto generated**!COM Interfaces-IPropertyBag2!private! !
!IPropertyBag2 categoriesFor: #getPropertyInfo:cProperties:!**auto generated**!methods!public! !
!IPropertyBag2 categoriesFor: #GetPropertyInfo:cProperties:pPropBag:pcProperties:!**auto generated**!COM Interfaces-IPropertyBag2!private! !
!IPropertyBag2 categoriesFor: #loadObject:dwHint:punkObject:pErrLog:!**auto generated**!methods!public! !
!IPropertyBag2 categoriesFor: #LoadObject:dwHint:punkObject:pErrLog:!**auto generated**!COM Interfaces-IPropertyBag2!private! !
!IPropertyBag2 categoriesFor: #read:pPropBag:pErrLog:!**auto generated**!methods!public! !
!IPropertyBag2 categoriesFor: #Read:pPropBag:pErrLog:pvarValue:phrError:!**auto generated**!COM Interfaces-IPropertyBag2!private! !
!IPropertyBag2 categoriesFor: #write:pPropBag:pvarValue:!**auto generated**!methods!public! !
!IPropertyBag2 categoriesFor: #Write:pPropBag:pvarValue:!**auto generated**!COM Interfaces-IPropertyBag2!private! !

IPropertyBag2 methodProtocol: #IPropertyBag2 attributes: #(#readOnly) selectors: #(#CountProperties: #GetPropertyInfo:cProperties:pPropBag:pcProperties: #LoadObject:dwHint:punkObject:pErrLog: #Read:pPropBag:pErrLog:pvarValue:phrError: #Write:pPropBag:pvarValue:)!

!IPropertyBag2 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'OCIDL.IPropertyBag2'
		IPropertyBag2 defineTemplate
	"

	self
		defineFunction: #Read:pPropBag:pErrLog:pvarValue:phrError:
			argumentTypes: 'dword PROPBAG2* IErrorLog* VARIANT* hresult*';
		defineFunction: #Write:pPropBag:pvarValue:
			argumentTypes: 'dword PROPBAG2* VARIANT*';
		defineFunction: #CountProperties:
			argumentTypes: 'dword*';
		defineFunction: #GetPropertyInfo:cProperties:pPropBag:pcProperties:
			argumentTypes: 'dword dword PROPBAG2* dword*';
		defineFunction: #LoadObject:dwHint:punkObject:pErrLog:
			argumentTypes: 'lpwstr dword IUnknown* IErrorLog*'
! !
!IPropertyBag2 class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

