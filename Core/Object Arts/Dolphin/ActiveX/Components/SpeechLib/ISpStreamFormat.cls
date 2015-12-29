"Filed out from Dolphin Smalltalk X6"!

IStream subclass: #ISpStreamFormat
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SpeechLibConstants'
	classInstanceVariableNames: ''!
ISpStreamFormat guid: (IID fromString: '{BED530BE-2606-4F4D-A1C0-54C5CDA5566F}')!
ISpStreamFormat comment: '<ISpStreamFormat> is a wrapper class for the COM interface ''SpeechLib.ISpStreamFormat'' generated from type information in the ''Microsoft Speech Object Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"ISpStreamFormat Interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(BED530BE-2606-4F4D-A1C0-54C5CDA5566F), 
	helpstring("ISpStreamFormat Interface"), 
	restricted
]
interface ISpStreamFormat : IStream {
	[id(0x60030000)]
	HRESULT __stdcall GetFormat(
		GUID* pguidFormatId,
		WaveFormatEx** ppCoMemWaveFormatEx);
};
'!
!ISpStreamFormat categoriesForClass!COM-Interfaces!SpeechLib-Interfaces! !
!ISpStreamFormat methodsFor!

getFormat: pguidFormatId ppCoMemWaveFormatEx: ppCoMemWaveFormatEx
	"Invoke the GetFormat() method of the COM object."

	^self
		GetFormat: pguidFormatId
		ppCoMemWaveFormatEx: ppCoMemWaveFormatEx
!

GetFormat: pguidFormatId ppCoMemWaveFormatEx: ppCoMemWaveFormatEx
	"Private - Invoke the GetFormat() method of the COM object.

		HRESULT __stdcall GetFormat(
			GUID* pguidFormatId,
			WaveFormatEx** ppCoMemWaveFormatEx);"

	<virtual stdcall: hresult 15 GUID* WaveFormatEx**>
	^self invalidCall
! !
!ISpStreamFormat categoriesFor: #getFormat:ppCoMemWaveFormatEx:!**auto generated**!methods!public! !
!ISpStreamFormat categoriesFor: #GetFormat:ppCoMemWaveFormatEx:!**auto generated**!COM Interfaces-ISpStreamFormat!private! !

!ISpStreamFormat class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'SpeechLib.ISpStreamFormat'
		ISpStreamFormat defineTemplate"

	self
		defineFunction: #GetFormat:ppCoMemWaveFormatEx:
			argumentTypes: 'GUID* WaveFormatEx**'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		ISpStreamFormat initializeTypeLib"

	typeLib := SpeechLib! !
!ISpStreamFormat class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!ISpStreamFormat class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

