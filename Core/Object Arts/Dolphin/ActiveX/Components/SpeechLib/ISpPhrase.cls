"Filed out from Dolphin Smalltalk 7"!

IUnknown subclass: #ISpPhrase
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SpeechLibConstants'
	classInstanceVariableNames: ''!
ISpPhrase guid: (IID fromString: '{1A5C0354-B621-4B5A-8791-D306ED379E53}')!
ISpPhrase comment: '<ISpPhrase> is a wrapper class for the COM interface ''SpeechLib.ISpPhrase'' generated from type information in the ''Microsoft Speech Object Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"ISpPhrase Interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(1A5C0354-B621-4B5A-8791-D306ED379E53), 
	helpstring("ISpPhrase Interface"), 
	restricted
]
interface ISpPhrase : IUnknown {
	[id(0x60010000)]
	HRESULT __stdcall GetPhrase(
		[out] SPPHRASE** ppCoMemPhrase);
	[id(0x60010001)]
	HRESULT __stdcall GetSerializedPhrase(
		[out] SPSERIALIZEDPHRASE** ppCoMemPhrase);
	[id(0x60010002)]
	HRESULT __stdcall GetText(
		[in] unsigned long ulStart,
		[in] unsigned long ulCount,
		[in] long fUseTextReplacements,
		[out] unsigned short** ppszCoMemText,
		[out] BYTE* pbDisplayAttributes);
	[id(0x60010003)]
	HRESULT __stdcall Discard(
		[in] unsigned long dwValueTypes);
};
'!
!ISpPhrase categoriesForClass!COM-Interfaces!SpeechLib-Interfaces! !
!ISpPhrase methodsFor!

discard: dwValueTypes
	"Invoke the Discard() method of the COM object."

	^self Discard: dwValueTypes
!

Discard: dwValueTypes
	"Private - Invoke the Discard() method of the COM object.

		HRESULT __stdcall Discard(
			[in] unsigned long dwValueTypes);"

	<virtual stdcall: hresult 7 dword>
	^self invalidCall
!

getPhrase
	"Answer the <SPPHRASE> result of invoking the GetPhrase() method of the COM object."

	| answer |
	answer := (SPPHRASE newBufferClass: COMTaskMemory).
	self GetPhrase: answer.
	^answer asObject
!

GetPhrase: ppCoMemPhrase
	"Private - Invoke the GetPhrase() method of the COM object.

		HRESULT __stdcall GetPhrase(
			[out] SPPHRASE** ppCoMemPhrase);"

	<virtual stdcall: hresult 4 SPPHRASE**>
	^self invalidCall
!

getSerializedPhrase
	"Answer the <SPSERIALIZEDPHRASE> result of invoking the GetSerializedPhrase() method of the COM object."

	| answer |
	answer := (SPSERIALIZEDPHRASE newBufferClass: COMTaskMemory).
	self GetSerializedPhrase: answer.
	^answer asObject
!

GetSerializedPhrase: ppCoMemPhrase
	"Private - Invoke the GetSerializedPhrase() method of the COM object.

		HRESULT __stdcall GetSerializedPhrase(
			[out] SPSERIALIZEDPHRASE** ppCoMemPhrase);"

	<virtual stdcall: hresult 5 SPSERIALIZEDPHRASE**>
	^self invalidCall
!

getText: ulStart ulCount: ulCount fUseTextReplacements: fUseTextReplacements
	"Invoke the GetText() method of the COM object."

	| answer |
	answer := (Array new: 2)
				basicAt: 1 put: (WORD newBufferClass: COMTaskMemory);
				basicAt: 2 put: (BYTE new);
				yourself.
	self
		GetText: ulStart
		ulCount: ulCount
		fUseTextReplacements: fUseTextReplacements
		ppszCoMemText: (answer basicAt: 1)
		pbDisplayAttributes: (answer basicAt: 2).
	^answer collect: [:e | e asObject]
!

GetText: ulStart ulCount: ulCount fUseTextReplacements: fUseTextReplacements ppszCoMemText: ppszCoMemText pbDisplayAttributes: pbDisplayAttributes
	"Private - Invoke the GetText() method of the COM object.

		HRESULT __stdcall GetText(
			[in] unsigned long ulStart,
			[in] unsigned long ulCount,
			[in] long fUseTextReplacements,
			[out] unsigned short** ppszCoMemText,
			[out] BYTE* pbDisplayAttributes);"

	<virtual stdcall: hresult 6 dword dword sdword word** byte*>
	^self invalidCall
! !
!ISpPhrase categoriesFor: #discard:!**auto generated**!methods!public! !
!ISpPhrase categoriesFor: #Discard:!**auto generated**!COM Interfaces-ISpPhrase!private! !
!ISpPhrase categoriesFor: #getPhrase!**auto generated**!methods!public! !
!ISpPhrase categoriesFor: #GetPhrase:!**auto generated**!COM Interfaces-ISpPhrase!private! !
!ISpPhrase categoriesFor: #getSerializedPhrase!**auto generated**!methods!public! !
!ISpPhrase categoriesFor: #GetSerializedPhrase:!**auto generated**!COM Interfaces-ISpPhrase!private! !
!ISpPhrase categoriesFor: #getText:ulCount:fUseTextReplacements:!**auto generated**!methods!public! !
!ISpPhrase categoriesFor: #GetText:ulCount:fUseTextReplacements:ppszCoMemText:pbDisplayAttributes:!**auto generated**!COM Interfaces-ISpPhrase!private! !

!ISpPhrase class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'SpeechLib.ISpPhrase'
		ISpPhrase defineTemplate"

	self
		defineFunction: #GetPhrase:
			argumentTypes: 'SPPHRASE**';
		defineFunction: #GetSerializedPhrase:
			argumentTypes: 'SPSERIALIZEDPHRASE**';
		defineFunction: #GetText:ulCount:fUseTextReplacements:ppszCoMemText:pbDisplayAttributes:
			argumentTypes: 'dword dword sdword word** byte*';
		defineFunction: #Discard:
			argumentTypes: 'dword'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		ISpPhrase initializeTypeLib"

	typeLib := SpeechLib! !
!ISpPhrase class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!ISpPhrase class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

