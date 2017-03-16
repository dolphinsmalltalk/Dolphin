"Filed out from Dolphin Smalltalk 7"!

IDispatch subclass: #IXMLDSigKey
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'MSXMLConstants'
	classInstanceVariableNames: ''!
IXMLDSigKey guid: (IID fromString: '{7474853B-20B3-437E-83F7-8E7F3064BE90}')!
IXMLDSigKey comment: '<IXMLDSigKey> is a wrapper class for the COM interface ''MSXML2.IXMLDSigKey'' generated from type information in the ''Microsoft XML, v6.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"XML Digital Signature Key"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(7474853B-20B3-437E-83F7-8E7F3064BE90), 
	helpstring("XML Digital Signature Key"), 
	nonextensible, 
	dual
]
interface IXMLDSigKey : IDispatch
 {
	[id(0x00000005)]
	HRESULT __stdcall getVerifyingCertificate(
		[out, retval]IUnknown** certificate);
};
'!
!IXMLDSigKey categoriesForClass!COM-Interfaces!MSXML2-Interfaces! !
!IXMLDSigKey methodsFor!

getVerifyingCertificate
	"Answer the <IUnknown> result of invoking the getVerifyingCertificate() method of the COM object."

	| answer |
	answer := IUnknown newPointer.
	self GetVerifyingCertificate: answer.
	^answer asObject
!

GetVerifyingCertificate: certificate
	"Private - Invoke the getVerifyingCertificate() method of the COM object.

		HRESULT __stdcall getVerifyingCertificate(
			[out, retval]IUnknown** certificate);"

	<virtual stdcall: hresult 8 IUnknown**>
	^self invalidCall!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^false!

isVBCollection
	"Answer whether the receiver is a VB style collection."

	^false! !
!IXMLDSigKey categoriesFor: #getVerifyingCertificate!**auto generated**!methods!public! !
!IXMLDSigKey categoriesFor: #GetVerifyingCertificate:!**auto generated**!COM Interfaces-IXMLDSigKey!private! !
!IXMLDSigKey categoriesFor: #isExtensible!**auto generated**!public!testing! !
!IXMLDSigKey categoriesFor: #isVBCollection!**auto generated**!public!testing! !

!IXMLDSigKey class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSXML2.IXMLDSigKey'
		IXMLDSigKey defineTemplate"

	self
		defineFunction: #GetVerifyingCertificate:
			argumentTypes: 'IUnknown**'
! !
!IXMLDSigKey class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

