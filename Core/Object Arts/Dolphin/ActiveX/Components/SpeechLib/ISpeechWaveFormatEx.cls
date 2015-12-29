"Filed out from Dolphin Smalltalk X6"!

IDispatch subclass: #ISpeechWaveFormatEx
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SpeechLibConstants'
	classInstanceVariableNames: ''!
ISpeechWaveFormatEx guid: (IID fromString: '{7A1EF0D5-1581-4741-88E4-209A49F11A10}')!
ISpeechWaveFormatEx comment: '<ISpeechWaveFormatEx> is a wrapper class for the COM interface ''SpeechLib.ISpeechWaveFormatEx'' generated from type information in the ''Microsoft Speech Object Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"ISpeechWaveFormatEx Interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(7A1EF0D5-1581-4741-88E4-209A49F11A10), 
	helpstring("ISpeechWaveFormatEx Interface"), 
	dual
]
interface ISpeechWaveFormatEx : IDispatch {
	[id(0x00000001), propget, helpstring("FormatTag")]
	HRESULT __stdcall FormatTag(
		[out, retval] short* FormatTag);
	[id(0x00000001), propput, helpstring("FormatTag")]
	HRESULT __stdcall FormatTag(
		[in] short FormatTag);
	[id(0x00000002), propget, helpstring("Channels")]
	HRESULT __stdcall Channels(
		[out, retval] short* Channels);
	[id(0x00000002), propput, helpstring("Channels")]
	HRESULT __stdcall Channels(
		[in] short Channels);
	[id(0x00000003), propget, helpstring("SamplesPerSec")]
	HRESULT __stdcall SamplesPerSec(
		[out, retval] long* SamplesPerSec);
	[id(0x00000003), propput, helpstring("SamplesPerSec")]
	HRESULT __stdcall SamplesPerSec(
		[in] long SamplesPerSec);
	[id(0x00000004), propget, helpstring("AvgBytesPerSec")]
	HRESULT __stdcall AvgBytesPerSec(
		[out, retval] long* AvgBytesPerSec);
	[id(0x00000004), propput, helpstring("AvgBytesPerSec")]
	HRESULT __stdcall AvgBytesPerSec(
		[in] long AvgBytesPerSec);
	[id(0x00000005), propget, helpstring("BlockAlign")]
	HRESULT __stdcall BlockAlign(
		[out, retval] short* BlockAlign);
	[id(0x00000005), propput, helpstring("BlockAlign")]
	HRESULT __stdcall BlockAlign(
		[in] short BlockAlign);
	[id(0x00000006), propget, helpstring("BitsPerSample")]
	HRESULT __stdcall BitsPerSample(
		[out, retval] short* BitsPerSample);
	[id(0x00000006), propput, helpstring("BitsPerSample")]
	HRESULT __stdcall BitsPerSample(
		[in] short BitsPerSample);
	[id(0x00000007), propget, helpstring("ExtraData")]
	HRESULT __stdcall ExtraData(
		[out, retval] VARIANT* ExtraData);
	[id(0x00000007), propput, helpstring("ExtraData")]
	HRESULT __stdcall ExtraData(
		[in] VARIANT ExtraData);
};
'!
!ISpeechWaveFormatEx categoriesForClass!COM-Interfaces!SpeechLib-Interfaces! !
!ISpeechWaveFormatEx methodsFor!

avgBytesPerSec
	"Answer the <sdword> value of the 'AvgBytesPerSec' property of the receiver.
	Helpstring: 'AvgBytesPerSec'"

	| answer |
	answer := (SDWORD new).
	self get_AvgBytesPerSec: answer.
	^answer asObject
!

avgBytesPerSec: avgBytesPerSec
	"Set the 'AvgBytesPerSec' property of the receiver to the <sdword> value of the argument.
	Helpstring: 'AvgBytesPerSec'"

	self put_AvgBytesPerSec: avgBytesPerSec
!

bitsPerSample
	"Answer the <sword> value of the 'BitsPerSample' property of the receiver.
	Helpstring: 'BitsPerSample'"

	| answer |
	answer := (SWORD new).
	self get_BitsPerSample: answer.
	^answer asObject
!

bitsPerSample: bitsPerSample
	"Set the 'BitsPerSample' property of the receiver to the <sword> value of the argument.
	Helpstring: 'BitsPerSample'"

	self put_BitsPerSample: bitsPerSample
!

blockAlign
	"Answer the <sword> value of the 'BlockAlign' property of the receiver.
	Helpstring: 'BlockAlign'"

	| answer |
	answer := (SWORD new).
	self get_BlockAlign: answer.
	^answer asObject
!

blockAlign: blockAlign
	"Set the 'BlockAlign' property of the receiver to the <sword> value of the argument.
	Helpstring: 'BlockAlign'"

	self put_BlockAlign: blockAlign
!

channels
	"Answer the <sword> value of the 'Channels' property of the receiver.
	Helpstring: 'Channels'"

	| answer |
	answer := (SWORD new).
	self get_Channels: answer.
	^answer asObject
!

channels: channels
	"Set the 'Channels' property of the receiver to the <sword> value of the argument.
	Helpstring: 'Channels'"

	self put_Channels: channels
!

extraData
	"Answer the <variant> value of the 'ExtraData' property of the receiver.
	Helpstring: 'ExtraData'"

	| answer |
	answer := VARIANT new.
	self get_ExtraData: answer.
	^answer asObject
!

extraData: extraData
	"Set the 'ExtraData' property of the receiver to the <variant> value of the argument.
	Helpstring: 'ExtraData'"

	self put_ExtraData: extraData asVariant
!

formatTag
	"Answer the <sword> value of the 'FormatTag' property of the receiver.
	Helpstring: 'FormatTag'"

	| answer |
	answer := (SWORD new).
	self get_FormatTag: answer.
	^answer asObject
!

formatTag: formatTag
	"Set the 'FormatTag' property of the receiver to the <sword> value of the argument.
	Helpstring: 'FormatTag'"

	self put_FormatTag: formatTag
!

get_AvgBytesPerSec: avgBytesPerSec
	"Private - Get the value of the 'AvgBytesPerSec' property of the receiver.

		HRESULT __stdcall AvgBytesPerSec(
			[out, retval] long* AvgBytesPerSec);"

	<virtual stdcall: hresult 14 sdword*>
	^self invalidCall
!

get_BitsPerSample: bitsPerSample
	"Private - Get the value of the 'BitsPerSample' property of the receiver.

		HRESULT __stdcall BitsPerSample(
			[out, retval] short* BitsPerSample);"

	<virtual stdcall: hresult 18 sword*>
	^self invalidCall
!

get_BlockAlign: blockAlign
	"Private - Get the value of the 'BlockAlign' property of the receiver.

		HRESULT __stdcall BlockAlign(
			[out, retval] short* BlockAlign);"

	<virtual stdcall: hresult 16 sword*>
	^self invalidCall
!

get_Channels: channels
	"Private - Get the value of the 'Channels' property of the receiver.

		HRESULT __stdcall Channels(
			[out, retval] short* Channels);"

	<virtual stdcall: hresult 10 sword*>
	^self invalidCall
!

get_ExtraData: extraData
	"Private - Get the value of the 'ExtraData' property of the receiver.

		HRESULT __stdcall ExtraData(
			[out, retval] VARIANT* ExtraData);"

	<virtual stdcall: hresult 20 variant*>
	^self invalidCall
!

get_FormatTag: formatTag
	"Private - Get the value of the 'FormatTag' property of the receiver.

		HRESULT __stdcall FormatTag(
			[out, retval] short* FormatTag);"

	<virtual stdcall: hresult 8 sword*>
	^self invalidCall
!

get_SamplesPerSec: samplesPerSec
	"Private - Get the value of the 'SamplesPerSec' property of the receiver.

		HRESULT __stdcall SamplesPerSec(
			[out, retval] long* SamplesPerSec);"

	<virtual stdcall: hresult 12 sdword*>
	^self invalidCall
!

put_AvgBytesPerSec: avgBytesPerSec
	"Private - Set the value of the 'AvgBytesPerSec' property of the object wrapped by the 
	 receiver to the <sdword> argument, avgBytesPerSec.

		HRESULT __stdcall AvgBytesPerSec(
			[in] long AvgBytesPerSec);"

	<virtual stdcall: hresult 15 sdword>
	^self invalidCall
!

put_BitsPerSample: bitsPerSample
	"Private - Set the value of the 'BitsPerSample' property of the object wrapped by the 
	 receiver to the <sword> argument, bitsPerSample.

		HRESULT __stdcall BitsPerSample(
			[in] short BitsPerSample);"

	<virtual stdcall: hresult 19 sword>
	^self invalidCall
!

put_BlockAlign: blockAlign
	"Private - Set the value of the 'BlockAlign' property of the object wrapped by the 
	 receiver to the <sword> argument, blockAlign.

		HRESULT __stdcall BlockAlign(
			[in] short BlockAlign);"

	<virtual stdcall: hresult 17 sword>
	^self invalidCall
!

put_Channels: channels
	"Private - Set the value of the 'Channels' property of the object wrapped by the 
	 receiver to the <sword> argument, channels.

		HRESULT __stdcall Channels(
			[in] short Channels);"

	<virtual stdcall: hresult 11 sword>
	^self invalidCall
!

put_ExtraData: extraData
	"Private - Set the value of the 'ExtraData' property of the object wrapped by the 
	 receiver to the <variant> argument, extraData.

		HRESULT __stdcall ExtraData(
			[in] VARIANT ExtraData);"

	<virtual stdcall: hresult 21 variant>
	^self invalidCall
!

put_FormatTag: formatTag
	"Private - Set the value of the 'FormatTag' property of the object wrapped by the 
	 receiver to the <sword> argument, formatTag.

		HRESULT __stdcall FormatTag(
			[in] short FormatTag);"

	<virtual stdcall: hresult 9 sword>
	^self invalidCall
!

put_SamplesPerSec: samplesPerSec
	"Private - Set the value of the 'SamplesPerSec' property of the object wrapped by the 
	 receiver to the <sdword> argument, samplesPerSec.

		HRESULT __stdcall SamplesPerSec(
			[in] long SamplesPerSec);"

	<virtual stdcall: hresult 13 sdword>
	^self invalidCall
!

samplesPerSec
	"Answer the <sdword> value of the 'SamplesPerSec' property of the receiver.
	Helpstring: 'SamplesPerSec'"

	| answer |
	answer := (SDWORD new).
	self get_SamplesPerSec: answer.
	^answer asObject
!

samplesPerSec: samplesPerSec
	"Set the 'SamplesPerSec' property of the receiver to the <sdword> value of the argument.
	Helpstring: 'SamplesPerSec'"

	self put_SamplesPerSec: samplesPerSec
! !
!ISpeechWaveFormatEx categoriesFor: #avgBytesPerSec!**auto generated**!properties!public! !
!ISpeechWaveFormatEx categoriesFor: #avgBytesPerSec:!**auto generated**!properties!public! !
!ISpeechWaveFormatEx categoriesFor: #bitsPerSample!**auto generated**!properties!public! !
!ISpeechWaveFormatEx categoriesFor: #bitsPerSample:!**auto generated**!properties!public! !
!ISpeechWaveFormatEx categoriesFor: #blockAlign!**auto generated**!properties!public! !
!ISpeechWaveFormatEx categoriesFor: #blockAlign:!**auto generated**!properties!public! !
!ISpeechWaveFormatEx categoriesFor: #channels!**auto generated**!properties!public! !
!ISpeechWaveFormatEx categoriesFor: #channels:!**auto generated**!properties!public! !
!ISpeechWaveFormatEx categoriesFor: #extraData!**auto generated**!properties!public! !
!ISpeechWaveFormatEx categoriesFor: #extraData:!**auto generated**!properties!public! !
!ISpeechWaveFormatEx categoriesFor: #formatTag!**auto generated**!properties!public! !
!ISpeechWaveFormatEx categoriesFor: #formatTag:!**auto generated**!properties!public! !
!ISpeechWaveFormatEx categoriesFor: #get_AvgBytesPerSec:!**auto generated**!COM Interfaces-ISpeechWaveFormatEx!private! !
!ISpeechWaveFormatEx categoriesFor: #get_BitsPerSample:!**auto generated**!COM Interfaces-ISpeechWaveFormatEx!private! !
!ISpeechWaveFormatEx categoriesFor: #get_BlockAlign:!**auto generated**!COM Interfaces-ISpeechWaveFormatEx!private! !
!ISpeechWaveFormatEx categoriesFor: #get_Channels:!**auto generated**!COM Interfaces-ISpeechWaveFormatEx!private! !
!ISpeechWaveFormatEx categoriesFor: #get_ExtraData:!**auto generated**!COM Interfaces-ISpeechWaveFormatEx!private! !
!ISpeechWaveFormatEx categoriesFor: #get_FormatTag:!**auto generated**!COM Interfaces-ISpeechWaveFormatEx!private! !
!ISpeechWaveFormatEx categoriesFor: #get_SamplesPerSec:!**auto generated**!COM Interfaces-ISpeechWaveFormatEx!private! !
!ISpeechWaveFormatEx categoriesFor: #put_AvgBytesPerSec:!**auto generated**!COM Interfaces-ISpeechWaveFormatEx!private! !
!ISpeechWaveFormatEx categoriesFor: #put_BitsPerSample:!**auto generated**!COM Interfaces-ISpeechWaveFormatEx!private! !
!ISpeechWaveFormatEx categoriesFor: #put_BlockAlign:!**auto generated**!COM Interfaces-ISpeechWaveFormatEx!private! !
!ISpeechWaveFormatEx categoriesFor: #put_Channels:!**auto generated**!COM Interfaces-ISpeechWaveFormatEx!private! !
!ISpeechWaveFormatEx categoriesFor: #put_ExtraData:!**auto generated**!COM Interfaces-ISpeechWaveFormatEx!private! !
!ISpeechWaveFormatEx categoriesFor: #put_FormatTag:!**auto generated**!COM Interfaces-ISpeechWaveFormatEx!private! !
!ISpeechWaveFormatEx categoriesFor: #put_SamplesPerSec:!**auto generated**!COM Interfaces-ISpeechWaveFormatEx!private! !
!ISpeechWaveFormatEx categoriesFor: #samplesPerSec!**auto generated**!properties!public! !
!ISpeechWaveFormatEx categoriesFor: #samplesPerSec:!**auto generated**!properties!public! !

!ISpeechWaveFormatEx class methodsFor!

clsid
	"Private - Answer the CLSID of the coclass (SpWaveFormatEx) for which the receiver is the default interface."

	^CLSID fromString: '{C79A574C-63BE-44B9-801F-283F87F898BE}'
!

defineFunctions
	"Declare the virtual function table for the COM interface 'SpeechLib.ISpeechWaveFormatEx'
		ISpeechWaveFormatEx defineTemplate"

	self
		defineFunction: #get_FormatTag:
			argumentTypes: 'sword*';
		defineFunction: #put_FormatTag:
			argumentTypes: 'sword';
		defineFunction: #get_Channels:
			argumentTypes: 'sword*';
		defineFunction: #put_Channels:
			argumentTypes: 'sword';
		defineFunction: #get_SamplesPerSec:
			argumentTypes: 'sdword*';
		defineFunction: #put_SamplesPerSec:
			argumentTypes: 'sdword';
		defineFunction: #get_AvgBytesPerSec:
			argumentTypes: 'sdword*';
		defineFunction: #put_AvgBytesPerSec:
			argumentTypes: 'sdword';
		defineFunction: #get_BlockAlign:
			argumentTypes: 'sword*';
		defineFunction: #put_BlockAlign:
			argumentTypes: 'sword';
		defineFunction: #get_BitsPerSample:
			argumentTypes: 'sword*';
		defineFunction: #put_BitsPerSample:
			argumentTypes: 'sword';
		defineFunction: #get_ExtraData:
			argumentTypes: 'variant*';
		defineFunction: #put_ExtraData:
			argumentTypes: 'variant'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		ISpeechWaveFormatEx initializeTypeLib"

	typeLib := SpeechLib! !
!ISpeechWaveFormatEx class categoriesFor: #clsid!**auto generated**!constants!private! !
!ISpeechWaveFormatEx class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!ISpeechWaveFormatEx class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

