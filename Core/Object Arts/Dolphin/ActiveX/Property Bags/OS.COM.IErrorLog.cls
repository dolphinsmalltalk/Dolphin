"Filed out from Dolphin Smalltalk 7"!

OS.COM.IUnknown subclass: #'OS.COM.IErrorLog'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.COM.IErrorLog guid: (OS.COM.IID fromString: '{3127ca40-446e-11ce-8135-00aa004bb851}')!
OS.COM.IErrorLog comment: '`OS.COM.IErrorLog` is a wrapper class for the COM interface ''OCIDL.IErrorLog'' generated from type information in the ''OCIDL Library'' library. It contains methods to invoke the member functions exposed by that interface.

The IErrorLog interface is an abstraction for an error log that is used to communicate detailed error information between a client and an object, and example being the error log associated with an IPersistPropertyBag::Load() operation.'!
!OS.COM.IErrorLog categoriesForClass!COM-Interfaces! !
!OS.COM.IErrorLog methodsFor!

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
!OS.COM.IErrorLog categoriesFor: #addError:pExcepInfo:!**auto generated**!methods!public! !
!OS.COM.IErrorLog categoriesFor: #AddError:pExcepInfo:!**auto generated**!COM Interfaces-IErrorLog!private! !

OS.COM.IErrorLog methodProtocol: #IErrorLog attributes: #(#readOnly) selectors: #(#AddError:pExcepInfo:)!

!OS.COM.IErrorLog class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'OCIDL.IErrorLog'
		IErrorLog defineTemplate
	"

	self
		defineFunction: #AddError:pExcepInfo:
			argumentTypes: 'lpwstr EXCEPINFO*'
! !
!OS.COM.IErrorLog class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

