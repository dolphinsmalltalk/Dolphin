"Filed out from Dolphin Smalltalk 7"!

IUnknown subclass: #ISpProperties
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SpeechLibConstants'
	classInstanceVariableNames: ''!
ISpProperties guid: (IID fromString: '{5B4FB971-B115-4DE1-AD97-E482E3BF6EE4}')!
ISpProperties comment: '<ISpProperties> is a wrapper class for the COM interface ''SpeechLib.ISpProperties'' generated from type information in the ''Microsoft Speech Object Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"ISpProperties Interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(5B4FB971-B115-4DE1-AD97-E482E3BF6EE4), 
	helpstring("ISpProperties Interface"), 
	restricted
]
interface ISpProperties : IUnknown {
	[id(0x60010000)]
	HRESULT __stdcall SetPropertyNum(
		[in] unsigned short* pName,
		[in] long lValue);
	[id(0x60010001)]
	HRESULT __stdcall GetPropertyNum(
		[in] unsigned short* pName,
		[out] long* plValue);
	[id(0x60010002)]
	HRESULT __stdcall SetPropertyString(
		[in] unsigned short* pName,
		[in] unsigned short* pValue);
	[id(0x60010003)]
	HRESULT __stdcall GetPropertyString(
		[in] unsigned short* pName,
		[out] unsigned short** ppCoMemValue);
};
'!
!ISpProperties categoriesForClass!COM-Interfaces!SpeechLib-Interfaces! !
!ISpProperties methodsFor!

getPropertyNum: pName
	"Answer the <SDWORD> result of invoking the GetPropertyNum() method of the COM object."

	| answer |
	answer := (SDWORD new).
	self
		GetPropertyNum: pName
		plValue: answer.
	^answer asObject
!

GetPropertyNum: pName plValue: plValue
	"Private - Invoke the GetPropertyNum() method of the COM object.

		HRESULT __stdcall GetPropertyNum(
			[in] unsigned short* pName,
			[out] long* plValue);"

	<virtual stdcall: hresult 5 word* sdword*>
	^self invalidCall
!

getPropertyString: pName
	"Answer the <WORD> result of invoking the GetPropertyString() method of the COM object."

	| answer |
	answer := (WORD newBufferClass: COMTaskMemory).
	self
		GetPropertyString: pName
		ppCoMemValue: answer.
	^answer asObject
!

GetPropertyString: pName ppCoMemValue: ppCoMemValue
	"Private - Invoke the GetPropertyString() method of the COM object.

		HRESULT __stdcall GetPropertyString(
			[in] unsigned short* pName,
			[out] unsigned short** ppCoMemValue);"

	<virtual stdcall: hresult 7 word* word**>
	^self invalidCall
!

setPropertyNum: pName lValue: lValue
	"Invoke the SetPropertyNum() method of the COM object."

	^self
		SetPropertyNum: pName
		lValue: lValue
!

SetPropertyNum: pName lValue: lValue
	"Private - Invoke the SetPropertyNum() method of the COM object.

		HRESULT __stdcall SetPropertyNum(
			[in] unsigned short* pName,
			[in] long lValue);"

	<virtual stdcall: hresult 4 word* sdword>
	^self invalidCall
!

setPropertyString: pName pValue: pValue
	"Invoke the SetPropertyString() method of the COM object."

	^self
		SetPropertyString: pName
		pValue: pValue
!

SetPropertyString: pName pValue: pValue
	"Private - Invoke the SetPropertyString() method of the COM object.

		HRESULT __stdcall SetPropertyString(
			[in] unsigned short* pName,
			[in] unsigned short* pValue);"

	<virtual stdcall: hresult 6 word* word*>
	^self invalidCall
! !
!ISpProperties categoriesFor: #getPropertyNum:!**auto generated**!methods!public! !
!ISpProperties categoriesFor: #GetPropertyNum:plValue:!**auto generated**!COM Interfaces-ISpProperties!private! !
!ISpProperties categoriesFor: #getPropertyString:!**auto generated**!methods!public! !
!ISpProperties categoriesFor: #GetPropertyString:ppCoMemValue:!**auto generated**!COM Interfaces-ISpProperties!private! !
!ISpProperties categoriesFor: #setPropertyNum:lValue:!**auto generated**!methods!public! !
!ISpProperties categoriesFor: #SetPropertyNum:lValue:!**auto generated**!COM Interfaces-ISpProperties!private! !
!ISpProperties categoriesFor: #setPropertyString:pValue:!**auto generated**!methods!public! !
!ISpProperties categoriesFor: #SetPropertyString:pValue:!**auto generated**!COM Interfaces-ISpProperties!private! !

!ISpProperties class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'SpeechLib.ISpProperties'
		ISpProperties defineTemplate"

	self
		defineFunction: #SetPropertyNum:lValue:
			argumentTypes: 'word* sdword';
		defineFunction: #GetPropertyNum:plValue:
			argumentTypes: 'word* sdword*';
		defineFunction: #SetPropertyString:pValue:
			argumentTypes: 'word* word*';
		defineFunction: #GetPropertyString:ppCoMemValue:
			argumentTypes: 'word* word**'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		ISpProperties initializeTypeLib"

	typeLib := SpeechLib! !
!ISpProperties class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!ISpProperties class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

