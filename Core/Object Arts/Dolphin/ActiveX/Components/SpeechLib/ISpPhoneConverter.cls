"Filed out from Dolphin Smalltalk X6"!

ISpObjectWithToken subclass: #ISpPhoneConverter
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SpeechLibConstants'
	classInstanceVariableNames: ''!
ISpPhoneConverter guid: (IID fromString: '{8445C581-0CAC-4A38-ABFE-9B2CE2826455}')!
ISpPhoneConverter comment: '<ISpPhoneConverter> is a wrapper class for the COM interface ''SpeechLib.ISpPhoneConverter'' generated from type information in the ''Microsoft Speech Object Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"ISpPhoneConverter Interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(8445C581-0CAC-4A38-ABFE-9B2CE2826455), 
	helpstring("ISpPhoneConverter Interface"), 
	restricted
]
interface ISpPhoneConverter : ISpObjectWithToken {
	[id(0x60020000)]
	HRESULT __stdcall PhoneToId(
		[in] unsigned short* pszPhone,
		[out] unsigned short* pId);
	[id(0x60020001)]
	HRESULT __stdcall IdToPhone(
		[in] unsigned short* pId,
		[out] unsigned short* pszPhone);
};
'!
!ISpPhoneConverter categoriesForClass!COM-Interfaces!SpeechLib-Interfaces! !
!ISpPhoneConverter methodsFor!

idToPhone: pId
	"Answer the <WORD> result of invoking the IdToPhone() method of the COM object."

	| answer |
	answer := (WORD new).
	self
		IdToPhone: pId
		pszPhone: answer.
	^answer asObject
!

IdToPhone: pId pszPhone: pszPhone
	"Private - Invoke the IdToPhone() method of the COM object.

		HRESULT __stdcall IdToPhone(
			[in] unsigned short* pId,
			[out] unsigned short* pszPhone);"

	<virtual stdcall: hresult 7 word* word*>
	^self invalidCall
!

phoneToId: pszPhone
	"Answer the <WORD> result of invoking the PhoneToId() method of the COM object."

	| answer |
	answer := (WORD new).
	self
		PhoneToId: pszPhone
		pId: answer.
	^answer asObject
!

PhoneToId: pszPhone pId: pId
	"Private - Invoke the PhoneToId() method of the COM object.

		HRESULT __stdcall PhoneToId(
			[in] unsigned short* pszPhone,
			[out] unsigned short* pId);"

	<virtual stdcall: hresult 6 word* word*>
	^self invalidCall
! !
!ISpPhoneConverter categoriesFor: #idToPhone:!**auto generated**!methods!public! !
!ISpPhoneConverter categoriesFor: #IdToPhone:pszPhone:!**auto generated**!COM Interfaces-ISpPhoneConverter!private! !
!ISpPhoneConverter categoriesFor: #phoneToId:!**auto generated**!methods!public! !
!ISpPhoneConverter categoriesFor: #PhoneToId:pId:!**auto generated**!COM Interfaces-ISpPhoneConverter!private! !

!ISpPhoneConverter class methodsFor!

clsid
	"Private - Answer the CLSID of the coclass (SpNullPhoneConverter) for which the receiver is the default interface."

	^CLSID fromString: '{455F24E9-7396-4A16-9715-7C0FDBE3EFE3}'
!

defineFunctions
	"Declare the virtual function table for the COM interface 'SpeechLib.ISpPhoneConverter'
		ISpPhoneConverter defineTemplate"

	self
		defineFunction: #PhoneToId:pId:
			argumentTypes: 'word* word*';
		defineFunction: #IdToPhone:pszPhone:
			argumentTypes: 'word* word*'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		ISpPhoneConverter initializeTypeLib"

	typeLib := SpeechLib! !
!ISpPhoneConverter class categoriesFor: #clsid!**auto generated**!constants!private! !
!ISpPhoneConverter class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!ISpPhoneConverter class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

