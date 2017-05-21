"Filed out from Dolphin Smalltalk 7"!

IDispatch subclass: #ISpeechAudioFormat
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SpeechLibConstants'
	classInstanceVariableNames: ''!
ISpeechAudioFormat guid: (IID fromString: '{E6E9C590-3E18-40E3-8299-061F98BDE7C7}')!
ISpeechAudioFormat comment: '<ISpeechAudioFormat> is a wrapper class for the COM interface ''SpeechLib.ISpeechAudioFormat'' generated from type information in the ''Microsoft Speech Object Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"ISpeechAudioFormat Interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(E6E9C590-3E18-40E3-8299-061F98BDE7C7), 
	helpstring("ISpeechAudioFormat Interface"), 
	dual
]
interface ISpeechAudioFormat : IDispatch {
	[id(0x00000001), propget, helpstring("Type")]
	HRESULT __stdcall Type(
		[out, retval] SpeechAudioFormatType* AudioFormat);
	[id(0x00000001), propput, helpstring("Type")]
	HRESULT __stdcall Type(
		[in] SpeechAudioFormatType AudioFormat);
	[id(0x00000002), hidden, propget, helpstring("Guid")]
	HRESULT __stdcall Guid(
		[out, retval] BSTR* Guid);
	[id(0x00000002), hidden, propput, helpstring("Guid")]
	HRESULT __stdcall Guid(
		[in] BSTR Guid);
	[id(0x00000003), hidden, helpstring("GetWaveFormatEx")]
	HRESULT __stdcall GetWaveFormatEx(
		[out, retval] ISpeechWaveFormatEx** WaveFormatEx);
	[id(0x00000004), hidden, helpstring("SetWaveFormatEx")]
	HRESULT __stdcall SetWaveFormatEx(
		[in] ISpeechWaveFormatEx* WaveFormatEx);
};
'!
!ISpeechAudioFormat categoriesForClass!COM-Interfaces!SpeechLib-Interfaces! !
!ISpeechAudioFormat methodsFor!

get_Guid: guid
	"Private - Get the value of the 'Guid' property of the receiver.

		HRESULT __stdcall Guid(
			[out, retval] BSTR* Guid);"

	<virtual stdcall: hresult 10 bstr*>
	^self invalidCall
!

get_Type: audioFormat
	"Private - Get the value of the 'Type' property of the receiver.

		HRESULT __stdcall Type(
			[out, retval] SpeechAudioFormatType* AudioFormat);"

	<virtual stdcall: hresult 8 sdword*>
	^self invalidCall
!

getWaveFormatEx
	"Answer the <ISpeechWaveFormatEx> result of invoking the GetWaveFormatEx() method of the COM object.
	Helpstring: 'GetWaveFormatEx'"

	| answer |
	answer := ISpeechWaveFormatEx newPointer.
	self GetWaveFormatEx: answer.
	^answer asObject
!

GetWaveFormatEx: waveFormatEx
	"Private - Invoke the GetWaveFormatEx() method of the COM object.
	Helpstring: 'GetWaveFormatEx'

		HRESULT __stdcall GetWaveFormatEx(
			[out, retval] ISpeechWaveFormatEx** WaveFormatEx);"

	<virtual stdcall: hresult 12 ISpeechWaveFormatEx**>
	^self invalidCall
!

guid
	"Answer the <bstr> value of the 'Guid' property of the receiver.
	Helpstring: 'Guid'"

	| answer |
	answer := BSTR new.
	self get_Guid: answer.
	^answer asObject
!

guid: guid
	"Set the 'Guid' property of the receiver to the <bstr> value of the argument.
	Helpstring: 'Guid'"

	self put_Guid: guid
!

put_Guid: guid
	"Private - Set the value of the 'Guid' property of the object wrapped by the 
	 receiver to the <bstr> argument, guid.

		HRESULT __stdcall Guid(
			[in] BSTR Guid);"

	<virtual stdcall: hresult 11 bstr>
	^self invalidCall
!

put_Type: audioFormat
	"Private - Set the value of the 'Type' property of the object wrapped by the 
	 receiver to the <sdword> argument, audioFormat.

		HRESULT __stdcall Type(
			[in] SpeechAudioFormatType AudioFormat);"

	<virtual stdcall: hresult 9 sdword>
	^self invalidCall
!

setWaveFormatEx: waveFormatEx
	"Invoke the SetWaveFormatEx() method of the COM object.
	Helpstring: 'SetWaveFormatEx'"

	^self SetWaveFormatEx: waveFormatEx
!

SetWaveFormatEx: waveFormatEx
	"Private - Invoke the SetWaveFormatEx() method of the COM object.
	Helpstring: 'SetWaveFormatEx'

		HRESULT __stdcall SetWaveFormatEx(
			[in] ISpeechWaveFormatEx* WaveFormatEx);"

	<virtual stdcall: hresult 13 ISpeechWaveFormatEx*>
	^self invalidCall
!

type
	"Answer the <sdword> value of the 'Type' property of the receiver.
	Helpstring: 'Type'"

	| answer |
	answer := (SDWORD new).
	self get_Type: answer.
	^answer asObject
!

type: audioFormat
	"Set the 'Type' property of the receiver to the <sdword> value of the argument.
	Helpstring: 'Type'"

	self put_Type: audioFormat
! !
!ISpeechAudioFormat categoriesFor: #get_Guid:!**auto generated**!COM Interfaces-ISpeechAudioFormat!private! !
!ISpeechAudioFormat categoriesFor: #get_Type:!**auto generated**!COM Interfaces-ISpeechAudioFormat!private! !
!ISpeechAudioFormat categoriesFor: #getWaveFormatEx!**auto generated**!methods!public! !
!ISpeechAudioFormat categoriesFor: #GetWaveFormatEx:!**auto generated**!COM Interfaces-ISpeechAudioFormat!private! !
!ISpeechAudioFormat categoriesFor: #guid!**auto generated**!properties!public! !
!ISpeechAudioFormat categoriesFor: #guid:!**auto generated**!properties!public! !
!ISpeechAudioFormat categoriesFor: #put_Guid:!**auto generated**!COM Interfaces-ISpeechAudioFormat!private! !
!ISpeechAudioFormat categoriesFor: #put_Type:!**auto generated**!COM Interfaces-ISpeechAudioFormat!private! !
!ISpeechAudioFormat categoriesFor: #setWaveFormatEx:!**auto generated**!methods!public! !
!ISpeechAudioFormat categoriesFor: #SetWaveFormatEx:!**auto generated**!COM Interfaces-ISpeechAudioFormat!private! !
!ISpeechAudioFormat categoriesFor: #type!**auto generated**!properties!public! !
!ISpeechAudioFormat categoriesFor: #type:!**auto generated**!properties!public! !

!ISpeechAudioFormat class methodsFor!

clsid
	"Private - Answer the CLSID of the coclass (SpAudioFormat) for which the receiver is the default interface."

	^CLSID fromString: '{9EF96870-E160-4792-820D-48CF0649E4EC}'
!

defineFunctions
	"Declare the virtual function table for the COM interface 'SpeechLib.ISpeechAudioFormat'
		ISpeechAudioFormat defineTemplate"

	self
		defineFunction: #get_Type:
			argumentTypes: 'sdword*';
		defineFunction: #put_Type:
			argumentTypes: 'sdword';
		defineFunction: #get_Guid:
			argumentTypes: 'bstr*';
		defineFunction: #put_Guid:
			argumentTypes: 'bstr';
		defineFunction: #GetWaveFormatEx:
			argumentTypes: 'ISpeechWaveFormatEx**';
		defineFunction: #SetWaveFormatEx:
			argumentTypes: 'ISpeechWaveFormatEx*'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		ISpeechAudioFormat initializeTypeLib"

	typeLib := SpeechLib! !
!ISpeechAudioFormat class categoriesFor: #clsid!**auto generated**!constants!private! !
!ISpeechAudioFormat class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!ISpeechAudioFormat class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

