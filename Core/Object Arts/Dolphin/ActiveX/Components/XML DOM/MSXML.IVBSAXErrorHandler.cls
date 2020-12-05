"Filed out from Dolphin Smalltalk 7"!

OS.COM.IDispatch subclass: #'MSXML.IVBSAXErrorHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
MSXML.IVBSAXErrorHandler guid: (OS.COM.IID fromString: '{d963d3fe-173c-4862-9095-b92f66995f52}')!
MSXML.IVBSAXErrorHandler comment: '<IVBSAXErrorHandler> is a wrapper class for the COM interface ''MSXML2.IVBSAXErrorHandler'' generated from type information in the ''Microsoft XML, v4.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"IVBSAXErrorHandler interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(D963D3FE-173C-4862-9095-B92F66995F52), 
	helpstring("IVBSAXErrorHandler interface"), 
	dual, 
	nonextensible
]
interface IVBSAXErrorHandler : IDispatch
 {
	[id(0x0000053b), helpstring("Receive notification of a recoverable error.")]
	HRESULT __stdcall error(
		[in]IVBSAXLocator* oLocator,
		[in, out]BSTR* strErrorMessage,
		[in]long nErrorCode);
	[id(0x0000053c), helpstring("Receive notification of a non-recoverable error.")]
	HRESULT __stdcall fatalError(
		[in]IVBSAXLocator* oLocator,
		[in, out]BSTR* strErrorMessage,
		[in]long nErrorCode);
	[id(0x0000053d), helpstring("Receive notification of an ignorable warning.")]
	HRESULT __stdcall ignorableWarning(
		[in]IVBSAXLocator* oLocator,
		[in, out]BSTR* strErrorMessage,
		[in]long nErrorCode);
};
'!
!MSXML.IVBSAXErrorHandler categoriesForClass!COM-Interfaces!MSXML2-Interfaces! !
!MSXML.IVBSAXErrorHandler methodsFor!

error: oLocator strErrorMessage: strErrorMessage nErrorCode: nErrorCode
	"Invoke the error() method of the COM object.
	Helpstring: Receive notification of a recoverable error."

	^self
		Error: oLocator
		strErrorMessage: strErrorMessage asBSTR
		nErrorCode: nErrorCode
!

Error: oLocator strErrorMessage: strErrorMessage nErrorCode: nErrorCode
	"Private - Invoke the error() method of the COM object.
	Helpstring: Receive notification of a recoverable error.

		HRESULT __stdcall error(
			[in]IVBSAXLocator* oLocator,
			[in, out]BSTR* strErrorMessage,
			[in]long nErrorCode);"

	<virtual stdcall: hresult 8 IVBSAXLocator* bstr* sdword>
	^self invalidCall: _failureCode!

fatalError: oLocator strErrorMessage: strErrorMessage nErrorCode: nErrorCode
	"Invoke the fatalError() method of the COM object.
	Helpstring: Receive notification of a non-recoverable error."

	^self
		FatalError: oLocator
		strErrorMessage: strErrorMessage asBSTR
		nErrorCode: nErrorCode
!

FatalError: oLocator strErrorMessage: strErrorMessage nErrorCode: nErrorCode
	"Private - Invoke the fatalError() method of the COM object.
	Helpstring: Receive notification of a non-recoverable error.

		HRESULT __stdcall fatalError(
			[in]IVBSAXLocator* oLocator,
			[in, out]BSTR* strErrorMessage,
			[in]long nErrorCode);"

	<virtual stdcall: hresult 9 IVBSAXLocator* bstr* sdword>
	^self invalidCall: _failureCode!

ignorableWarning: oLocator strErrorMessage: strErrorMessage nErrorCode: nErrorCode
	"Invoke the ignorableWarning() method of the COM object.
	Helpstring: Receive notification of an ignorable warning."

	^self
		IgnorableWarning: oLocator
		strErrorMessage: strErrorMessage asBSTR
		nErrorCode: nErrorCode
!

IgnorableWarning: oLocator strErrorMessage: strErrorMessage nErrorCode: nErrorCode
	"Private - Invoke the ignorableWarning() method of the COM object.
	Helpstring: Receive notification of an ignorable warning.

		HRESULT __stdcall ignorableWarning(
			[in]IVBSAXLocator* oLocator,
			[in, out]BSTR* strErrorMessage,
			[in]long nErrorCode);"

	<virtual stdcall: hresult 10 IVBSAXLocator* bstr* sdword>
	^self invalidCall: _failureCode!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^false!

isVBCollection
	"Answer whether the receiver is a VB style collection."

	^false! !
!MSXML.IVBSAXErrorHandler categoriesFor: #error:strErrorMessage:nErrorCode:!**auto generated**!methods!public! !
!MSXML.IVBSAXErrorHandler categoriesFor: #Error:strErrorMessage:nErrorCode:!**auto generated**!COM Interfaces-IVBSAXErrorHandler!private! !
!MSXML.IVBSAXErrorHandler categoriesFor: #fatalError:strErrorMessage:nErrorCode:!**auto generated**!methods!public! !
!MSXML.IVBSAXErrorHandler categoriesFor: #FatalError:strErrorMessage:nErrorCode:!**auto generated**!COM Interfaces-IVBSAXErrorHandler!private! !
!MSXML.IVBSAXErrorHandler categoriesFor: #ignorableWarning:strErrorMessage:nErrorCode:!**auto generated**!methods!public! !
!MSXML.IVBSAXErrorHandler categoriesFor: #IgnorableWarning:strErrorMessage:nErrorCode:!**auto generated**!COM Interfaces-IVBSAXErrorHandler!private! !
!MSXML.IVBSAXErrorHandler categoriesFor: #isExtensible!**auto generated**!public!testing! !
!MSXML.IVBSAXErrorHandler categoriesFor: #isVBCollection!**auto generated**!public!testing! !

!MSXML.IVBSAXErrorHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSXML2.IVBSAXErrorHandler'
		IVBSAXErrorHandler defineTemplate"

	self
		defineFunction: #Error:strErrorMessage:nErrorCode:
			argumentTypes: 'IVBSAXLocator* bstr* sdword';
		defineFunction: #FatalError:strErrorMessage:nErrorCode:
			argumentTypes: 'IVBSAXLocator* bstr* sdword';
		defineFunction: #IgnorableWarning:strErrorMessage:nErrorCode:
			argumentTypes: 'IVBSAXLocator* bstr* sdword'
! !
!MSXML.IVBSAXErrorHandler class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

