"Filed out from Dolphin Smalltalk 7"!

IUnknown subclass: #IEnumSpObjectTokens
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SpeechLibConstants'
	classInstanceVariableNames: ''!
IEnumSpObjectTokens guid: (IID fromString: '{06B64F9E-7FDA-11D2-B4F2-00C04F797396}')!
IEnumSpObjectTokens comment: '<IEnumSpObjectTokens> is a wrapper class for the COM interface ''SpeechLib.IEnumSpObjectTokens'' generated from type information in the ''Microsoft Speech Object Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"IEnumSpObjectTokens Interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(06B64F9E-7FDA-11D2-B4F2-00C04F797396), 
	helpstring("IEnumSpObjectTokens Interface"), 
	restricted
]
interface IEnumSpObjectTokens : IUnknown {
	[id(0x60010000)]
	HRESULT __stdcall Next(
		[in] unsigned long celt,
		[out] ISpObjectToken** pelt,
		[out] unsigned long* pceltFetched);
	[id(0x60010001)]
	HRESULT __stdcall Skip(
		[in] unsigned long celt);
	[id(0x60010002)]
	HRESULT __stdcall Reset();
	[id(0x60010003)]
	HRESULT __stdcall Clone(
		[out] IEnumSpObjectTokens** ppEnum);
	[id(0x60010004)]
	HRESULT __stdcall Item(
		[in] unsigned long Index,
		[out] ISpObjectToken** ppToken);
	[id(0x60010005)]
	HRESULT __stdcall GetCount(
		[out] unsigned long* pCount);
};
'!
!IEnumSpObjectTokens categoriesForClass!COM-Interfaces!SpeechLib-Interfaces! !
!IEnumSpObjectTokens methodsFor!

clone
	"Answer the <IEnumSpObjectTokens> result of invoking the Clone() method of the COM object."

	| answer |
	answer := IEnumSpObjectTokens newPointer.
	self Clone: answer.
	^answer asObject
!

Clone: ppEnum
	"Private - Invoke the Clone() method of the COM object.

		HRESULT __stdcall Clone(
			[out] IEnumSpObjectTokens** ppEnum);"

	<virtual stdcall: hresult 7 IEnumSpObjectTokens**>
	^self invalidCall
!

getCount
	"Answer the <DWORD> result of invoking the GetCount() method of the COM object."

	| answer |
	answer := (DWORD new).
	self GetCount: answer.
	^answer asObject
!

GetCount: pCount
	"Private - Invoke the GetCount() method of the COM object.

		HRESULT __stdcall GetCount(
			[out] unsigned long* pCount);"

	<virtual stdcall: hresult 9 dword*>
	^self invalidCall
!

item: index
	"Answer the <ISpObjectToken> result of invoking the Item() method of the COM object."

	| answer |
	answer := ISpObjectToken newPointer.
	self
		Item: index
		ppToken: answer.
	^answer asObject
!

Item: index ppToken: ppToken
	"Private - Invoke the Item() method of the COM object.

		HRESULT __stdcall Item(
			[in] unsigned long Index,
			[out] ISpObjectToken** ppToken);"

	<virtual stdcall: hresult 8 dword ISpObjectToken**>
	^self invalidCall
!

next: celt
	"Invoke the Next() method of the COM object."

	| answer |
	answer := (Array new: 2)
				basicAt: 1 put: ISpObjectToken newPointer;
				basicAt: 2 put: (DWORD new);
				yourself.
	self
		Next: celt
		pelt: (answer basicAt: 1)
		pceltFetched: (answer basicAt: 2).
	^answer collect: [:e | e asObject]
!

Next: celt pelt: pelt pceltFetched: pceltFetched
	"Private - Invoke the Next() method of the COM object.

		HRESULT __stdcall Next(
			[in] unsigned long celt,
			[out] ISpObjectToken** pelt,
			[out] unsigned long* pceltFetched);"

	<virtual stdcall: hresult 4 dword ISpObjectToken** dword*>
	^self invalidCall
!

reset
	"Invoke the Reset() method of the COM object."

	^self Reset
!

Reset
	"Private - Invoke the Reset() method of the COM object.

		HRESULT __stdcall Reset();"

	<virtual stdcall: hresult 6>
	^self invalidCall
!

skip: celt
	"Invoke the Skip() method of the COM object."

	^self Skip: celt
!

Skip: celt
	"Private - Invoke the Skip() method of the COM object.

		HRESULT __stdcall Skip(
			[in] unsigned long celt);"

	<virtual stdcall: hresult 5 dword>
	^self invalidCall
! !
!IEnumSpObjectTokens categoriesFor: #clone!**auto generated**!methods!public! !
!IEnumSpObjectTokens categoriesFor: #Clone:!**auto generated**!COM Interfaces-IEnumSpObjectTokens!private! !
!IEnumSpObjectTokens categoriesFor: #getCount!**auto generated**!methods!public! !
!IEnumSpObjectTokens categoriesFor: #GetCount:!**auto generated**!COM Interfaces-IEnumSpObjectTokens!private! !
!IEnumSpObjectTokens categoriesFor: #item:!**auto generated**!methods!public! !
!IEnumSpObjectTokens categoriesFor: #Item:ppToken:!**auto generated**!COM Interfaces-IEnumSpObjectTokens!private! !
!IEnumSpObjectTokens categoriesFor: #next:!**auto generated**!methods!public! !
!IEnumSpObjectTokens categoriesFor: #Next:pelt:pceltFetched:!**auto generated**!COM Interfaces-IEnumSpObjectTokens!private! !
!IEnumSpObjectTokens categoriesFor: #reset!**auto generated**!methods!public! !
!IEnumSpObjectTokens categoriesFor: #Reset!**auto generated**!COM Interfaces-IEnumSpObjectTokens!private! !
!IEnumSpObjectTokens categoriesFor: #skip:!**auto generated**!methods!public! !
!IEnumSpObjectTokens categoriesFor: #Skip:!**auto generated**!COM Interfaces-IEnumSpObjectTokens!private! !

!IEnumSpObjectTokens class methodsFor!

clsid
	"Private - Answer the CLSID of the coclass (SpMMAudioEnum) for which the receiver is the default interface."

	^CLSID fromString: '{AB1890A0-E91F-11D2-BB91-00C04F8EE6C0}'
!

defineFunctions
	"Declare the virtual function table for the COM interface 'SpeechLib.IEnumSpObjectTokens'
		IEnumSpObjectTokens defineTemplate"

	self
		defineFunction: #Next:pelt:pceltFetched:
			argumentTypes: 'dword ISpObjectToken** dword*';
		defineFunction: #Skip:
			argumentTypes: 'dword';
		defineFunction: #Reset;
		defineFunction: #Clone:
			argumentTypes: 'IEnumSpObjectTokens**';
		defineFunction: #Item:ppToken:
			argumentTypes: 'dword ISpObjectToken**';
		defineFunction: #GetCount:
			argumentTypes: 'dword*'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		IEnumSpObjectTokens initializeTypeLib"

	typeLib := SpeechLib! !
!IEnumSpObjectTokens class categoriesFor: #clsid!**auto generated**!constants!private! !
!IEnumSpObjectTokens class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!IEnumSpObjectTokens class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

