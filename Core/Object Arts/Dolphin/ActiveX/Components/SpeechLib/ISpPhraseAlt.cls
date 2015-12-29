"Filed out from Dolphin Smalltalk X6"!

ISpPhrase subclass: #ISpPhraseAlt
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SpeechLibConstants'
	classInstanceVariableNames: ''!
ISpPhraseAlt guid: (IID fromString: '{8FCEBC98-4E49-4067-9C6C-D86A0E092E3D}')!
ISpPhraseAlt comment: '<ISpPhraseAlt> is a wrapper class for the COM interface ''SpeechLib.ISpPhraseAlt'' generated from type information in the ''Microsoft Speech Object Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"ISpPhraseAlt Interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(8FCEBC98-4E49-4067-9C6C-D86A0E092E3D), 
	helpstring("ISpPhraseAlt Interface"), 
	restricted
]
interface ISpPhraseAlt : ISpPhrase {
	[id(0x60020000)]
	HRESULT __stdcall GetAltInfo(
		ISpPhrase** ppParent,
		unsigned long* pulStartElementInParent,
		unsigned long* pcElementsInParent,
		unsigned long* pcElementsInAlt);
	[id(0x60020001)]
	HRESULT __stdcall Commit();
};
'!
!ISpPhraseAlt categoriesForClass!COM-Interfaces!SpeechLib-Interfaces! !
!ISpPhraseAlt methodsFor!

commit
	"Invoke the Commit() method of the COM object."

	^self Commit
!

Commit
	"Private - Invoke the Commit() method of the COM object.

		HRESULT __stdcall Commit();"

	<virtual stdcall: hresult 9>
	^self invalidCall
!

getAltInfo: ppParent pulStartElementInParent: pulStartElementInParent pcElementsInParent: pcElementsInParent pcElementsInAlt: pcElementsInAlt
	"Invoke the GetAltInfo() method of the COM object."

	^self
		GetAltInfo: ppParent
		pulStartElementInParent: pulStartElementInParent
		pcElementsInParent: pcElementsInParent
		pcElementsInAlt: pcElementsInAlt
!

GetAltInfo: ppParent pulStartElementInParent: pulStartElementInParent pcElementsInParent: pcElementsInParent pcElementsInAlt: pcElementsInAlt
	"Private - Invoke the GetAltInfo() method of the COM object.

		HRESULT __stdcall GetAltInfo(
			ISpPhrase** ppParent,
			unsigned long* pulStartElementInParent,
			unsigned long* pcElementsInParent,
			unsigned long* pcElementsInAlt);"

	<virtual stdcall: hresult 8 ISpPhrase** dword* dword* dword*>
	^self invalidCall
! !
!ISpPhraseAlt categoriesFor: #commit!**auto generated**!methods!public! !
!ISpPhraseAlt categoriesFor: #Commit!**auto generated**!COM Interfaces-ISpPhraseAlt!private! !
!ISpPhraseAlt categoriesFor: #getAltInfo:pulStartElementInParent:pcElementsInParent:pcElementsInAlt:!**auto generated**!methods!public! !
!ISpPhraseAlt categoriesFor: #GetAltInfo:pulStartElementInParent:pcElementsInParent:pcElementsInAlt:!**auto generated**!COM Interfaces-ISpPhraseAlt!private! !

!ISpPhraseAlt class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'SpeechLib.ISpPhraseAlt'
		ISpPhraseAlt defineTemplate"

	self
		defineFunction: #GetAltInfo:pulStartElementInParent:pcElementsInParent:pcElementsInAlt:
			argumentTypes: 'ISpPhrase** dword* dword* dword*';
		defineFunction: #Commit
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		ISpPhraseAlt initializeTypeLib"

	typeLib := SpeechLib! !
!ISpPhraseAlt class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!ISpPhraseAlt class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

