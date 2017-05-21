"Filed out from Dolphin Smalltalk 7"!

IUnknown subclass: #ISpObjectWithToken
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SpeechLibConstants'
	classInstanceVariableNames: ''!
ISpObjectWithToken guid: (IID fromString: '{5B559F40-E952-11D2-BB91-00C04F8EE6C0}')!
ISpObjectWithToken comment: '<ISpObjectWithToken> is a wrapper class for the COM interface ''SpeechLib.ISpObjectWithToken'' generated from type information in the ''Microsoft Speech Object Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"ISpObjectWithToken Interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(5B559F40-E952-11D2-BB91-00C04F8EE6C0), 
	helpstring("ISpObjectWithToken Interface"), 
	restricted
]
interface ISpObjectWithToken : IUnknown {
	[id(0x60010000)]
	HRESULT __stdcall SetObjectToken(
		ISpObjectToken* pToken);
	[id(0x60010001)]
	HRESULT __stdcall GetObjectToken(
		ISpObjectToken** ppToken);
};
'!
!ISpObjectWithToken categoriesForClass!COM-Interfaces!SpeechLib-Interfaces! !
!ISpObjectWithToken methodsFor!

getObjectToken: ppToken
	"Invoke the GetObjectToken() method of the COM object."

	^self GetObjectToken: ppToken
!

GetObjectToken: ppToken
	"Private - Invoke the GetObjectToken() method of the COM object.

		HRESULT __stdcall GetObjectToken(
			ISpObjectToken** ppToken);"

	<virtual stdcall: hresult 5 ISpObjectToken**>
	^self invalidCall
!

setObjectToken: pToken
	"Invoke the SetObjectToken() method of the COM object."

	^self SetObjectToken: pToken
!

SetObjectToken: pToken
	"Private - Invoke the SetObjectToken() method of the COM object.

		HRESULT __stdcall SetObjectToken(
			ISpObjectToken* pToken);"

	<virtual stdcall: hresult 4 ISpObjectToken*>
	^self invalidCall
! !
!ISpObjectWithToken categoriesFor: #getObjectToken:!**auto generated**!methods!public! !
!ISpObjectWithToken categoriesFor: #GetObjectToken:!**auto generated**!COM Interfaces-ISpObjectWithToken!private! !
!ISpObjectWithToken categoriesFor: #setObjectToken:!**auto generated**!methods!public! !
!ISpObjectWithToken categoriesFor: #SetObjectToken:!**auto generated**!COM Interfaces-ISpObjectWithToken!private! !

!ISpObjectWithToken class methodsFor!

clsid
	"Private - Answer the CLSID of the coclass (SpRecPlayAudio) for which the receiver is the default interface."

	^CLSID fromString: '{FEE225FC-7AFD-45E9-95D0-5A318079D911}'
!

defineFunctions
	"Declare the virtual function table for the COM interface 'SpeechLib.ISpObjectWithToken'
		ISpObjectWithToken defineTemplate"

	self
		defineFunction: #SetObjectToken:
			argumentTypes: 'ISpObjectToken*';
		defineFunction: #GetObjectToken:
			argumentTypes: 'ISpObjectToken**'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		ISpObjectWithToken initializeTypeLib"

	typeLib := SpeechLib! !
!ISpObjectWithToken class categoriesFor: #clsid!**auto generated**!constants!private! !
!ISpObjectWithToken class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!ISpObjectWithToken class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

