"Filed out from Dolphin Smalltalk 7"!

IServiceProvider subclass: #ISpResourceManager
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SpeechLibConstants'
	classInstanceVariableNames: ''!
ISpResourceManager guid: (IID fromString: '{93384E18-5014-43D5-ADBB-A78E055926BD}')!
ISpResourceManager comment: '<ISpResourceManager> is a wrapper class for the COM interface ''SpeechLib.ISpResourceManager'' generated from type information in the ''Microsoft Speech Object Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"ISpResourceManager Interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(93384E18-5014-43D5-ADBB-A78E055926BD), 
	helpstring("ISpResourceManager Interface"), 
	restricted
]
interface ISpResourceManager : IServiceProvider {
	[id(0x60020000)]
	HRESULT __stdcall SetObject(
		[in] GUID* guidServiceId,
		[in] IUnknown* punkObject);
	[id(0x60020001)]
	HRESULT __stdcall GetObject(
		[in] GUID* guidServiceId,
		[in] GUID* ObjectCLSID,
		[in] GUID* ObjectIID,
		[in] long fReleaseWhenLastExternalRefReleased,
		[out] void** ppObject);
};
'!
!ISpResourceManager categoriesForClass!COM-Interfaces!SpeechLib-Interfaces! !
!ISpResourceManager methodsFor!

getObject: guidServiceId objectCLSID: objectCLSID objectIID: objectIID fReleaseWhenLastExternalRefReleased: fReleaseWhenLastExternalRefReleased
	"Answer the <VOID> result of invoking the GetObject() method of the COM object."

	| answer |
	answer := (VOID newBufferClass: COMTaskMemory).
	self
		GetObject: guidServiceId
		ObjectCLSID: objectCLSID
		ObjectIID: objectIID
		fReleaseWhenLastExternalRefReleased: fReleaseWhenLastExternalRefReleased
		ppObject: answer.
	^answer asObject
!

GetObject: guidServiceId ObjectCLSID: objectCLSID ObjectIID: objectIID fReleaseWhenLastExternalRefReleased: fReleaseWhenLastExternalRefReleased ppObject: ppObject
	"Private - Invoke the GetObject() method of the COM object.

		HRESULT __stdcall GetObject(
			[in] GUID* guidServiceId,
			[in] GUID* ObjectCLSID,
			[in] GUID* ObjectIID,
			[in] long fReleaseWhenLastExternalRefReleased,
			[out] void** ppObject);"

	<virtual stdcall: hresult 6 GUID* GUID* GUID* sdword void**>
	^self invalidCall
!

setObject: guidServiceId punkObject: punkObject
	"Invoke the SetObject() method of the COM object."

	^self
		SetObject: guidServiceId
		punkObject: punkObject
!

SetObject: guidServiceId punkObject: punkObject
	"Private - Invoke the SetObject() method of the COM object.

		HRESULT __stdcall SetObject(
			[in] GUID* guidServiceId,
			[in] IUnknown* punkObject);"

	<virtual stdcall: hresult 5 GUID* IUnknown*>
	^self invalidCall
! !
!ISpResourceManager categoriesFor: #getObject:objectCLSID:objectIID:fReleaseWhenLastExternalRefReleased:!**auto generated**!methods!public! !
!ISpResourceManager categoriesFor: #GetObject:ObjectCLSID:ObjectIID:fReleaseWhenLastExternalRefReleased:ppObject:!**auto generated**!COM Interfaces-ISpResourceManager!private! !
!ISpResourceManager categoriesFor: #setObject:punkObject:!**auto generated**!methods!public! !
!ISpResourceManager categoriesFor: #SetObject:punkObject:!**auto generated**!COM Interfaces-ISpResourceManager!private! !

!ISpResourceManager class methodsFor!

clsid
	"Private - Answer the CLSID of the coclass (SpResourceManager) for which the receiver is the default interface."

	^CLSID fromString: '{96749373-3391-11D2-9EE3-00C04F797396}'
!

defineFunctions
	"Declare the virtual function table for the COM interface 'SpeechLib.ISpResourceManager'
		ISpResourceManager defineTemplate"

	self
		defineFunction: #SetObject:punkObject:
			argumentTypes: 'GUID* IUnknown*';
		defineFunction: #GetObject:ObjectCLSID:ObjectIID:fReleaseWhenLastExternalRefReleased:ppObject:
			argumentTypes: 'GUID* GUID* GUID* sdword void**'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		ISpResourceManager initializeTypeLib"

	typeLib := SpeechLib! !
!ISpResourceManager class categoriesFor: #clsid!**auto generated**!constants!private! !
!ISpResourceManager class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!ISpResourceManager class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

