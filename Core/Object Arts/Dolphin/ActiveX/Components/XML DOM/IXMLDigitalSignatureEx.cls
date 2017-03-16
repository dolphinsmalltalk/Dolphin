"Filed out from Dolphin Smalltalk 7"!

IXMLDigitalSignature subclass: #IXMLDigitalSignatureEx
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'MSXMLConstants'
	classInstanceVariableNames: ''!
IXMLDigitalSignatureEx guid: (IID fromString: '{7474853E-20B3-437E-83F7-8E7F3064BE90}')!
IXMLDigitalSignatureEx comment: '<IXMLDigitalSignatureEx> is a wrapper class for the COM interface ''MSXML2.IXMLDigitalSignatureEx'' generated from type information in the ''Microsoft XML, v6.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"XML Digital Signature"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(7474853E-20B3-437E-83F7-8E7F3064BE90), 
	helpstring("XML Digital Signature"), 
	nonextensible
]
interface IXMLDigitalSignatureEx : IXMLDigitalSignature
 {
	[id(0x60030000)]
	HRESULT __stdcall createKeyFromCertContext(
		[in]void* pCertContext,
		[out, retval]IXMLDSigKeyEx** keyRef);
	[id(0x60030001)]
	HRESULT __stdcall createKeyFromHMACSecretBinary(
		[in]BYTE* pSecret,
		[in]long nSecretLen,
		[in]long lHMACOutputLength,
		[out, retval]IXMLDSigKeyEx** keyRef);
	[id(0x60030002)]
	HRESULT __stdcall setStoreHandle(
		[in]void* hCertStore);
	[id(0x60030003)]
	HRESULT __stdcall getStoreHandle(
		[out, retval]void** hCertStore);
	[id(0x60030004)]
	HRESULT __stdcall setDebugOutput(
		[in]IStream* debugOutput);
};
'!
!IXMLDigitalSignatureEx categoriesForClass!COM-Interfaces!MSXML2-Interfaces! !
!IXMLDigitalSignatureEx methodsFor!

createKeyFromCertContext: pCertContext
	"Answer the <IXMLDSigKeyEx> result of invoking the createKeyFromCertContext() method of the COM object."

	| answer |
	answer := IXMLDSigKeyEx newPointer.
	self
		CreateKeyFromCertContext: pCertContext
		keyRef: answer.
	^answer asObject
!

CreateKeyFromCertContext: pCertContext keyRef: keyRef
	"Private - Invoke the createKeyFromCertContext() method of the COM object.

		HRESULT __stdcall createKeyFromCertContext(
			[in]void* pCertContext,
			[out, retval]IXMLDSigKeyEx** keyRef);"

	<virtual stdcall: hresult 19 void* IXMLDSigKeyEx**>
	^self invalidCall!

createKeyFromHMACSecretBinary: pSecret nSecretLen: nSecretLen lHMACOutputLength: lHMACOutputLength
	"Answer the <IXMLDSigKeyEx> result of invoking the createKeyFromHMACSecretBinary() method of the COM object."

	| answer |
	answer := IXMLDSigKeyEx newPointer.
	self
		CreateKeyFromHMACSecretBinary: pSecret
		nSecretLen: nSecretLen
		lHMACOutputLength: lHMACOutputLength
		keyRef: answer.
	^answer asObject
!

CreateKeyFromHMACSecretBinary: pSecret nSecretLen: nSecretLen lHMACOutputLength: lHMACOutputLength keyRef: keyRef
	"Private - Invoke the createKeyFromHMACSecretBinary() method of the COM object.

		HRESULT __stdcall createKeyFromHMACSecretBinary(
			[in]BYTE* pSecret,
			[in]long nSecretLen,
			[in]long lHMACOutputLength,
			[out, retval]IXMLDSigKeyEx** keyRef);"

	<virtual stdcall: hresult 20 byte* sdword sdword IXMLDSigKeyEx**>
	^self invalidCall!

getStoreHandle
	"Answer the <VOID> result of invoking the getStoreHandle() method of the COM object."

	| answer |
	answer := (VOID newBufferClass: COMTaskMemory).
	self GetStoreHandle: answer.
	^answer asObject
!

GetStoreHandle: hCertStore
	"Private - Invoke the getStoreHandle() method of the COM object.

		HRESULT __stdcall getStoreHandle(
			[out, retval]void** hCertStore);"

	<virtual stdcall: hresult 22 void**>
	^self invalidCall!

SetDebugOutput: debugOutput
	"Invoke the setDebugOutput() method of the COM object.

		HRESULT __stdcall setDebugOutput(
			[in]IStream* debugOutput);"

	<virtual stdcall: hresult 23 IStream*>
	^self invalidCall!

SetStoreHandle: hCertStore
	"Invoke the setStoreHandle() method of the COM object.

		HRESULT __stdcall setStoreHandle(
			[in]void* hCertStore);"

	<virtual stdcall: hresult 21 void*>
	^self invalidCall! !
!IXMLDigitalSignatureEx categoriesFor: #createKeyFromCertContext:!**auto generated**!methods!public! !
!IXMLDigitalSignatureEx categoriesFor: #CreateKeyFromCertContext:keyRef:!**auto generated**!COM Interfaces-IXMLDigitalSignatureEx!private! !
!IXMLDigitalSignatureEx categoriesFor: #createKeyFromHMACSecretBinary:nSecretLen:lHMACOutputLength:!**auto generated**!methods!public! !
!IXMLDigitalSignatureEx categoriesFor: #CreateKeyFromHMACSecretBinary:nSecretLen:lHMACOutputLength:keyRef:!**auto generated**!COM Interfaces-IXMLDigitalSignatureEx!private! !
!IXMLDigitalSignatureEx categoriesFor: #getStoreHandle!**auto generated**!methods!public! !
!IXMLDigitalSignatureEx categoriesFor: #GetStoreHandle:!**auto generated**!COM Interfaces-IXMLDigitalSignatureEx!private! !
!IXMLDigitalSignatureEx categoriesFor: #SetDebugOutput:!**auto generated**!COM Interfaces-IXMLDigitalSignatureEx!public! !
!IXMLDigitalSignatureEx categoriesFor: #SetStoreHandle:!**auto generated**!COM Interfaces-IXMLDigitalSignatureEx!public! !

!IXMLDigitalSignatureEx class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSXML2.IXMLDigitalSignatureEx'
		IXMLDigitalSignatureEx defineTemplate"

	self
		defineFunction: #CreateKeyFromCertContext:keyRef:
			argumentTypes: 'void* IXMLDSigKeyEx**';
		defineFunction: #CreateKeyFromHMACSecretBinary:nSecretLen:lHMACOutputLength:keyRef:
			argumentTypes: 'byte* sdword sdword IXMLDSigKeyEx**';
		defineFunction: #SetStoreHandle:
			argumentTypes: 'void*';
		defineFunction: #GetStoreHandle:
			argumentTypes: 'void**';
		defineFunction: #SetDebugOutput:
			argumentTypes: 'IStream*'
! !
!IXMLDigitalSignatureEx class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

