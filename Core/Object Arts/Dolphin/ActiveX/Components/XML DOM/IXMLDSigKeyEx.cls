"Filed out from Dolphin Smalltalk 7"!

IXMLDSigKey subclass: #IXMLDSigKeyEx
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'MSXMLConstants'
	classInstanceVariableNames: ''!
IXMLDSigKeyEx guid: (IID fromString: '{7474853C-20B3-437E-83F7-8E7F3064BE90}')!
IXMLDSigKeyEx comment: '<IXMLDSigKeyEx> is a wrapper class for the COM interface ''MSXML2.IXMLDSigKeyEx'' generated from type information in the ''Microsoft XML, v6.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"XML Digital Signature Key"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(7474853C-20B3-437E-83F7-8E7F3064BE90), 
	helpstring("XML Digital Signature Key"), 
	nonextensible
]
interface IXMLDSigKeyEx : IXMLDSigKey
 {
	[id(0x60030000)]
	HRESULT __stdcall getCSPHandle(
		[out, retval]ULONG_PTR* hProvider);
	[id(0x60030001)]
	HRESULT __stdcall getVerifyingCertificateContext(
		[out, retval]void** certContext);
};
'!
!IXMLDSigKeyEx categoriesForClass!COM-Interfaces!MSXML2-Interfaces! !
!IXMLDSigKeyEx methodsFor!

getCSPHandle
	"Answer the <DWORD> result of invoking the getCSPHandle() method of the COM object."

	| answer |
	answer := (DWORD new).
	self GetCSPHandle: answer.
	^answer asObject
!

GetCSPHandle: hProvider
	"Private - Invoke the getCSPHandle() method of the COM object.

		HRESULT __stdcall getCSPHandle(
			[out, retval]ULONG_PTR* hProvider);"

	<virtual stdcall: hresult 9 uintptr*>
	^self invalidCall!

getVerifyingCertificateContext
	"Answer the <VOID> result of invoking the getVerifyingCertificateContext() method of the COM object."

	| answer |
	answer := (VOID newBufferClass: COMTaskMemory).
	self GetVerifyingCertificateContext: answer.
	^answer asObject
!

GetVerifyingCertificateContext: certContext
	"Private - Invoke the getVerifyingCertificateContext() method of the COM object.

		HRESULT __stdcall getVerifyingCertificateContext(
			[out, retval]void** certContext);"

	<virtual stdcall: hresult 10 void**>
	^self invalidCall! !
!IXMLDSigKeyEx categoriesFor: #getCSPHandle!**auto generated**!methods!public! !
!IXMLDSigKeyEx categoriesFor: #GetCSPHandle:!**auto generated**!COM Interfaces-IXMLDSigKeyEx!private! !
!IXMLDSigKeyEx categoriesFor: #getVerifyingCertificateContext!**auto generated**!methods!public! !
!IXMLDSigKeyEx categoriesFor: #GetVerifyingCertificateContext:!**auto generated**!COM Interfaces-IXMLDSigKeyEx!private! !

!IXMLDSigKeyEx class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSXML2.IXMLDSigKeyEx'
		IXMLDSigKeyEx defineTemplate"

	self
		defineFunction: #GetCSPHandle:
			argumentTypes: 'dword*';
		defineFunction: #GetVerifyingCertificateContext:
			argumentTypes: 'void**'
! !
!IXMLDSigKeyEx class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

