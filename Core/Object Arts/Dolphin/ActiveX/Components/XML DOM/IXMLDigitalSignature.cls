"Filed out from Dolphin Smalltalk X6"!

IDispatch subclass: #IXMLDigitalSignature
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'MSXMLConstants'
	classInstanceVariableNames: ''!
IXMLDigitalSignature guid: (IID fromString: '{7474853D-20B3-437E-83F7-8E7F3064BE90}')!
IXMLDigitalSignature comment: '<IXMLDigitalSignature> is a wrapper class for the COM interface ''MSXML2.IXMLDigitalSignature'' generated from type information in the ''Microsoft XML, v6.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"XML Digital Signature"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(7474853D-20B3-437E-83F7-8E7F3064BE90), 
	helpstring("XML Digital Signature"), 
	nonextensible, 
	dual
]
interface IXMLDigitalSignature : IDispatch
 {
	[id(0x00000008), propputref]
	HRESULT __stdcall signature(
		[in]IXMLDOMNode* signatureNode);
	[id(0x00000008), propget]
	HRESULT __stdcall signature(
		[out, retval]IXMLDOMNode** signatureNode);
	[id(0x00000009), propputref]
	HRESULT __stdcall store(
		[in]IUnknown* store);
	[id(0x00000009), propget]
	HRESULT __stdcall store(
		[out, retval]IUnknown** store);
	[id(0x00000007)]
	HRESULT __stdcall sign(
		[in]IXMLDSigKey* keyRef,
		[in]XMLDSIG_WRITEKEYINFO wki,
		[out, retval]IXMLDSigKey** signKeyRef);
	[id(0x0000000a)]
	HRESULT __stdcall verify(
		[in]IXMLDSigKey* keyRef,
		[out, retval]IXMLDSigKey** verifyKeyRef);
	[id(0x00000006)]
	HRESULT __stdcall setReferenceData(
		[in]BSTR uri,
		[in]IUnknown* punk);
	[id(0x00000004)]
	HRESULT __stdcall createSAXProxy(
		[out, retval]IUnknown** saxProxy);
	[id(0x00000001)]
	HRESULT __stdcall createKeyFromCSP(
		[in]long providerType,
		[in]BSTR providerName,
		[in]BSTR keyContainerName,
		[in]long flags,
		[out, retval]IXMLDSigKey** keyRef);
	[id(0x00000002)]
	HRESULT __stdcall createKeyFromHMACSecret(
		[in]BSTR base64Secret,
		[in]long lHMACOutputLength,
		[out, retval]IXMLDSigKey** keyRef);
	[id(0x00000003)]
	HRESULT __stdcall createKeyFromNode(
		[in]IXMLDOMNode* node,
		[out, retval]IXMLDSigKey** keyRef);
};
'!
!IXMLDigitalSignature categoriesForClass!COM-Interfaces!MSXML2-Interfaces! !
!IXMLDigitalSignature methodsFor!

createKeyFromCSP: providerType providerName: providerName keyContainerName: keyContainerName flags: flags
	"Answer the <IXMLDSigKey> result of invoking the createKeyFromCSP() method of the COM object."

	| answer |
	answer := IXMLDSigKey newPointer.
	self
		CreateKeyFromCSP: providerType
		providerName: providerName
		keyContainerName: keyContainerName
		flags: flags
		keyRef: answer.
	^answer asObject
!

CreateKeyFromCSP: providerType providerName: providerName keyContainerName: keyContainerName flags: flags keyRef: keyRef
	"Private - Invoke the createKeyFromCSP() method of the COM object.

		HRESULT __stdcall createKeyFromCSP(
			[in]long providerType,
			[in]BSTR providerName,
			[in]BSTR keyContainerName,
			[in]long flags,
			[out, retval]IXMLDSigKey** keyRef);"

	<virtual stdcall: hresult 16 sdword bstr bstr sdword IXMLDSigKey**>
	^self invalidCall!

createKeyFromHMACSecret: base64Secret lHMACOutputLength: lHMACOutputLength
	"Answer the <IXMLDSigKey> result of invoking the createKeyFromHMACSecret() method of the COM object."

	| answer |
	answer := IXMLDSigKey newPointer.
	self
		CreateKeyFromHMACSecret: base64Secret
		lHMACOutputLength: lHMACOutputLength
		keyRef: answer.
	^answer asObject
!

CreateKeyFromHMACSecret: base64Secret lHMACOutputLength: lHMACOutputLength keyRef: keyRef
	"Private - Invoke the createKeyFromHMACSecret() method of the COM object.

		HRESULT __stdcall createKeyFromHMACSecret(
			[in]BSTR base64Secret,
			[in]long lHMACOutputLength,
			[out, retval]IXMLDSigKey** keyRef);"

	<virtual stdcall: hresult 17 bstr sdword IXMLDSigKey**>
	^self invalidCall!

createKeyFromNode: node
	"Answer the <IXMLDSigKey> result of invoking the createKeyFromNode() method of the COM object."

	| answer |
	answer := IXMLDSigKey newPointer.
	self
		CreateKeyFromNode: node
		keyRef: answer.
	^answer asObject
!

CreateKeyFromNode: node keyRef: keyRef
	"Private - Invoke the createKeyFromNode() method of the COM object.

		HRESULT __stdcall createKeyFromNode(
			[in]IXMLDOMNode* node,
			[out, retval]IXMLDSigKey** keyRef);"

	<virtual stdcall: hresult 18 IXMLDOMNode* IXMLDSigKey**>
	^self invalidCall!

createSAXProxy
	"Answer the <IUnknown> result of invoking the createSAXProxy() method of the COM object."

	| answer |
	answer := IUnknown newPointer.
	self CreateSAXProxy: answer.
	^answer asObject
!

CreateSAXProxy: saxProxy
	"Private - Invoke the createSAXProxy() method of the COM object.

		HRESULT __stdcall createSAXProxy(
			[out, retval]IUnknown** saxProxy);"

	<virtual stdcall: hresult 15 IUnknown**>
	^self invalidCall!

get_signature: signatureNode
	"Private - Get the value of the 'signature' property of the receiver.

		HRESULT __stdcall signature(
			[out, retval]IXMLDOMNode** signatureNode);"

	<virtual stdcall: hresult 9 IXMLDOMNode**>
	^self invalidCall!

get_store: store
	"Private - Get the value of the 'store' property of the receiver.

		HRESULT __stdcall store(
			[out, retval]IUnknown** store);"

	<virtual stdcall: hresult 11 IUnknown**>
	^self invalidCall!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^false!

isVBCollection
	"Answer whether the receiver is a VB style collection."

	^false!

putref_signature: signatureNode
	"Private - Set the value of the 'signature' property of the object wrapped by the 
	 receiver to the <IXMLDOMNode*> argument, signatureNode.

		HRESULT __stdcall signature(
			[in]IXMLDOMNode* signatureNode);"

	<virtual stdcall: hresult 8 IXMLDOMNode*>
	^self invalidCall!

putref_store: store
	"Private - Set the value of the 'store' property of the object wrapped by the 
	 receiver to the <IUnknown*> argument, store.

		HRESULT __stdcall store(
			[in]IUnknown* store);"

	<virtual stdcall: hresult 10 IUnknown*>
	^self invalidCall!

SetReferenceData: uri punk: punk
	"Invoke the setReferenceData() method of the COM object.

		HRESULT __stdcall setReferenceData(
			[in]BSTR uri,
			[in]IUnknown* punk);"

	<virtual stdcall: hresult 14 bstr IUnknown*>
	^self invalidCall!

setSignature: signatureNode
	"Set the 'signature' property of the receiver to the <IXMLDOMNode*> value of the argument."

	self putref_signature: signatureNode
!

setStore: store
	"Set the 'store' property of the receiver to the <IUnknown*> value of the argument."

	self putref_store: store
!

sign: keyRef wki: wki
	"Answer the <IXMLDSigKey> result of invoking the sign() method of the COM object."

	| answer |
	answer := IXMLDSigKey newPointer.
	self
		Sign: keyRef
		wki: wki
		signKeyRef: answer.
	^answer asObject
!

Sign: keyRef wki: wki signKeyRef: signKeyRef
	"Private - Invoke the sign() method of the COM object.

		HRESULT __stdcall sign(
			[in]IXMLDSigKey* keyRef,
			[in]XMLDSIG_WRITEKEYINFO wki,
			[out, retval]IXMLDSigKey** signKeyRef);"

	<virtual stdcall: hresult 12 IXMLDSigKey* sdword IXMLDSigKey**>
	^self invalidCall!

signature
	"Answer the <IXMLDOMNode> value of the 'signature' property of the receiver."

	| answer |
	answer := IXMLDOMNode newPointer.
	self get_signature: answer.
	^answer asObject
!

store
	"Answer the <IUnknown> value of the 'store' property of the receiver."

	| answer |
	answer := IUnknown newPointer.
	self get_store: answer.
	^answer asObject
!

verify: keyRef
	"Answer the <IXMLDSigKey> result of invoking the verify() method of the COM object."

	| answer |
	answer := IXMLDSigKey newPointer.
	self
		Verify: keyRef
		verifyKeyRef: answer.
	^answer asObject
!

Verify: keyRef verifyKeyRef: verifyKeyRef
	"Private - Invoke the verify() method of the COM object.

		HRESULT __stdcall verify(
			[in]IXMLDSigKey* keyRef,
			[out, retval]IXMLDSigKey** verifyKeyRef);"

	<virtual stdcall: hresult 13 IXMLDSigKey* IXMLDSigKey**>
	^self invalidCall! !
!IXMLDigitalSignature categoriesFor: #createKeyFromCSP:providerName:keyContainerName:flags:!**auto generated**!methods!public! !
!IXMLDigitalSignature categoriesFor: #CreateKeyFromCSP:providerName:keyContainerName:flags:keyRef:!**auto generated**!COM Interfaces-IXMLDigitalSignature!private! !
!IXMLDigitalSignature categoriesFor: #createKeyFromHMACSecret:lHMACOutputLength:!**auto generated**!methods!public! !
!IXMLDigitalSignature categoriesFor: #CreateKeyFromHMACSecret:lHMACOutputLength:keyRef:!**auto generated**!COM Interfaces-IXMLDigitalSignature!private! !
!IXMLDigitalSignature categoriesFor: #createKeyFromNode:!**auto generated**!methods!public! !
!IXMLDigitalSignature categoriesFor: #CreateKeyFromNode:keyRef:!**auto generated**!COM Interfaces-IXMLDigitalSignature!private! !
!IXMLDigitalSignature categoriesFor: #createSAXProxy!**auto generated**!methods!public! !
!IXMLDigitalSignature categoriesFor: #CreateSAXProxy:!**auto generated**!COM Interfaces-IXMLDigitalSignature!private! !
!IXMLDigitalSignature categoriesFor: #get_signature:!**auto generated**!COM Interfaces-IXMLDigitalSignature!private! !
!IXMLDigitalSignature categoriesFor: #get_store:!**auto generated**!COM Interfaces-IXMLDigitalSignature!private! !
!IXMLDigitalSignature categoriesFor: #isExtensible!**auto generated**!public!testing! !
!IXMLDigitalSignature categoriesFor: #isVBCollection!**auto generated**!public!testing! !
!IXMLDigitalSignature categoriesFor: #putref_signature:!**auto generated**!COM Interfaces-IXMLDigitalSignature!private! !
!IXMLDigitalSignature categoriesFor: #putref_store:!**auto generated**!COM Interfaces-IXMLDigitalSignature!private! !
!IXMLDigitalSignature categoriesFor: #SetReferenceData:punk:!**auto generated**!COM Interfaces-IXMLDigitalSignature!public! !
!IXMLDigitalSignature categoriesFor: #setSignature:!**auto generated**!properties!public! !
!IXMLDigitalSignature categoriesFor: #setStore:!**auto generated**!properties!public! !
!IXMLDigitalSignature categoriesFor: #sign:wki:!**auto generated**!methods!public! !
!IXMLDigitalSignature categoriesFor: #Sign:wki:signKeyRef:!**auto generated**!COM Interfaces-IXMLDigitalSignature!private! !
!IXMLDigitalSignature categoriesFor: #signature!**auto generated**!properties!public! !
!IXMLDigitalSignature categoriesFor: #store!**auto generated**!properties!public! !
!IXMLDigitalSignature categoriesFor: #verify:!**auto generated**!methods!public! !
!IXMLDigitalSignature categoriesFor: #Verify:verifyKeyRef:!**auto generated**!COM Interfaces-IXMLDigitalSignature!private! !

!IXMLDigitalSignature class methodsFor!

clsid
	"Private - Answer the CLSID of the coclass (MXDigitalSignature60) for which the receiver is the default interface."

	^CLSID fromString: '{88D96A13-F192-11D4-A65F-0040963251E5}'
!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSXML2.IXMLDigitalSignature'
		IXMLDigitalSignature defineTemplate"

	self
		defineFunction: #putref_signature:
			argumentTypes: 'IXMLDOMNode*';
		defineFunction: #get_signature:
			argumentTypes: 'IXMLDOMNode**';
		defineFunction: #putref_store:
			argumentTypes: 'IUnknown*';
		defineFunction: #get_store:
			argumentTypes: 'IUnknown**';
		defineFunction: #Sign:wki:signKeyRef:
			argumentTypes: 'IXMLDSigKey* sdword IXMLDSigKey**';
		defineFunction: #Verify:verifyKeyRef:
			argumentTypes: 'IXMLDSigKey* IXMLDSigKey**';
		defineFunction: #SetReferenceData:punk:
			argumentTypes: 'bstr IUnknown*';
		defineFunction: #CreateSAXProxy:
			argumentTypes: 'IUnknown**';
		defineFunction: #CreateKeyFromCSP:providerName:keyContainerName:flags:keyRef:
			argumentTypes: 'sdword bstr bstr sdword IXMLDSigKey**';
		defineFunction: #CreateKeyFromHMACSecret:lHMACOutputLength:keyRef:
			argumentTypes: 'bstr sdword IXMLDSigKey**';
		defineFunction: #CreateKeyFromNode:keyRef:
			argumentTypes: 'IXMLDOMNode* IXMLDSigKey**'
! !
!IXMLDigitalSignature class categoriesFor: #clsid!**auto generated**!constants!private! !
!IXMLDigitalSignature class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

