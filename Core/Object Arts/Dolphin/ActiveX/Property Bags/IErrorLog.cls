"Filed out from Dolphin Smalltalk 7"!

IUnknown subclass: #IErrorLog
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
IErrorLog guid: (IID fromString: '{3127ca40-446e-11ce-8135-00aa004bb851}')!
IErrorLog comment: '<IErrorLog> is a wrapper class for the COM interface ''OCIDL.IErrorLog'' generated from type information in the ''OCIDL Library'' library. It contains methods to invoke the member functions exposed by that interface.

The IErrorLog interface is an abstraction for an error log that is used to communicate detailed error information between a client and an object, and example being the error log associated with an IPersistPropertyBag::Load() operation.'!
!IErrorLog categoriesForClass!COM-Interfaces! !
!IErrorLog methodsFor!

addError: pszPropName pExcepInfo: pExcepInfo
	"Invoke the AddError() method of the COM Object."

	self AddError: pszPropName asUtf16String pExcepInfo: pExcepInfo!

AddError: pszPropName pExcepInfo: pExcepInfo
	"Private - Invoke the AddError() method of the COM object wrapped by the receiver.

		HRESULT __stdcall AddError(
			[in] LPWSTR pszPropName,
			[in] EXCEPINFO* pExcepInfo);
	"

	<virtual stdcall: hresult 4 lpwstr EXCEPINFO*>
	^self invalidCall: _failureCode! !
!IErrorLog categoriesFor: #addError:pExcepInfo:!**auto generated**!methods!public! !
!IErrorLog categoriesFor: #AddError:pExcepInfo:!**auto generated**!COM Interfaces-IErrorLog!private! !

IErrorLog methodProtocol: #IErrorLog attributes: #(#readOnly) selectors: #(#AddError:pExcepInfo:)!

!IErrorLog class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'OCIDL.IErrorLog'
		IErrorLog defineTemplate
	"

	self
		defineFunction: #AddError:pExcepInfo:
			argumentTypes: 'lpwstr EXCEPINFO*'
! !
!IErrorLog class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

