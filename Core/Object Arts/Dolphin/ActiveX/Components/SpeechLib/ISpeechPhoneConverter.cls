"Filed out from Dolphin Smalltalk 7"!

IDispatch subclass: #ISpeechPhoneConverter
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SpeechLibConstants'
	classInstanceVariableNames: ''!
ISpeechPhoneConverter guid: (IID fromString: '{C3E4F353-433F-43D6-89A1-6A62A7054C3D}')!
ISpeechPhoneConverter comment: '<ISpeechPhoneConverter> is a wrapper class for the COM interface ''SpeechLib.ISpeechPhoneConverter'' generated from type information in the ''Microsoft Speech Object Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"ISpeechPhoneConverter Interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(C3E4F353-433F-43D6-89A1-6A62A7054C3D), 
	helpstring("ISpeechPhoneConverter Interface"), 
	dual
]
interface ISpeechPhoneConverter : IDispatch {
	[id(0x00000001), propget, helpstring("LanguageId")]
	HRESULT __stdcall LanguageId(
		[out, retval] long* LanguageId);
	[id(0x00000001), propput, helpstring("LanguageId")]
	HRESULT __stdcall LanguageId(
		[in] long LanguageId);
	[id(0x00000002), helpstring("PhoneToId")]
	HRESULT __stdcall PhoneToId(
		[in] BSTR Phonemes,
		[out, retval] VARIANT* IdArray);
	[id(0x00000003), helpstring("IdToPhone")]
	HRESULT __stdcall IdToPhone(
		[in] VARIANT IdArray,
		[out, retval] BSTR* Phonemes);
};
'!
!ISpeechPhoneConverter categoriesForClass!COM-Interfaces!SpeechLib-Interfaces! !
!ISpeechPhoneConverter methodsFor!

get_LanguageId: languageId
	"Private - Get the value of the 'LanguageId' property of the receiver.

		HRESULT __stdcall LanguageId(
			[out, retval] long* LanguageId);"

	<virtual stdcall: hresult 8 sdword*>
	^self invalidCall
!

idToPhone: idArray
	"Answer the <BSTR> result of invoking the IdToPhone() method of the COM object.
	Helpstring: 'IdToPhone'"

	| answer |
	answer := BSTR new.
	self
		IdToPhone: idArray asVariant
		Phonemes: answer.
	^answer asObject
!

IdToPhone: idArray Phonemes: phonemes
	"Private - Invoke the IdToPhone() method of the COM object.
	Helpstring: 'IdToPhone'

		HRESULT __stdcall IdToPhone(
			[in] VARIANT IdArray,
			[out, retval] BSTR* Phonemes);"

	<virtual stdcall: hresult 11 variant bstr*>
	^self invalidCall
!

languageId
	"Answer the <sdword> value of the 'LanguageId' property of the receiver.
	Helpstring: 'LanguageId'"

	| answer |
	answer := (SDWORD new).
	self get_LanguageId: answer.
	^answer asObject
!

languageId: languageId
	"Set the 'LanguageId' property of the receiver to the <sdword> value of the argument.
	Helpstring: 'LanguageId'"

	self put_LanguageId: languageId
!

phoneToId: phonemes
	"Answer the <VARIANT> result of invoking the PhoneToId() method of the COM object.
	Helpstring: 'PhoneToId'"

	| answer |
	answer := VARIANT new.
	self
		PhoneToId: phonemes
		IdArray: answer.
	^answer asObject
!

PhoneToId: phonemes IdArray: idArray
	"Private - Invoke the PhoneToId() method of the COM object.
	Helpstring: 'PhoneToId'

		HRESULT __stdcall PhoneToId(
			[in] BSTR Phonemes,
			[out, retval] VARIANT* IdArray);"

	<virtual stdcall: hresult 10 bstr variant*>
	^self invalidCall
!

put_LanguageId: languageId
	"Private - Set the value of the 'LanguageId' property of the object wrapped by the 
	 receiver to the <sdword> argument, languageId.

		HRESULT __stdcall LanguageId(
			[in] long LanguageId);"

	<virtual stdcall: hresult 9 sdword>
	^self invalidCall
! !
!ISpeechPhoneConverter categoriesFor: #get_LanguageId:!**auto generated**!COM Interfaces-ISpeechPhoneConverter!private! !
!ISpeechPhoneConverter categoriesFor: #idToPhone:!**auto generated**!methods!public! !
!ISpeechPhoneConverter categoriesFor: #IdToPhone:Phonemes:!**auto generated**!COM Interfaces-ISpeechPhoneConverter!private! !
!ISpeechPhoneConverter categoriesFor: #languageId!**auto generated**!properties!public! !
!ISpeechPhoneConverter categoriesFor: #languageId:!**auto generated**!properties!public! !
!ISpeechPhoneConverter categoriesFor: #phoneToId:!**auto generated**!methods!public! !
!ISpeechPhoneConverter categoriesFor: #PhoneToId:IdArray:!**auto generated**!COM Interfaces-ISpeechPhoneConverter!private! !
!ISpeechPhoneConverter categoriesFor: #put_LanguageId:!**auto generated**!COM Interfaces-ISpeechPhoneConverter!private! !

!ISpeechPhoneConverter class methodsFor!

clsid
	"Private - Answer the CLSID of the coclass (SpPhoneConverter) for which the receiver is the default interface."

	^CLSID fromString: '{9185F743-1143-4C28-86B5-BFF14F20E5C8}'
!

defineFunctions
	"Declare the virtual function table for the COM interface 'SpeechLib.ISpeechPhoneConverter'
		ISpeechPhoneConverter defineTemplate"

	self
		defineFunction: #get_LanguageId:
			argumentTypes: 'sdword*';
		defineFunction: #put_LanguageId:
			argumentTypes: 'sdword';
		defineFunction: #PhoneToId:IdArray:
			argumentTypes: 'bstr variant*';
		defineFunction: #IdToPhone:Phonemes:
			argumentTypes: 'variant bstr*'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		ISpeechPhoneConverter initializeTypeLib"

	typeLib := SpeechLib! !
!ISpeechPhoneConverter class categoriesFor: #clsid!**auto generated**!constants!private! !
!ISpeechPhoneConverter class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!ISpeechPhoneConverter class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

