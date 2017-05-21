"Filed out from Dolphin Smalltalk 7"!

ISpDataKey subclass: #ISpObjectTokenCategory
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SpeechLibConstants'
	classInstanceVariableNames: ''!
ISpObjectTokenCategory guid: (IID fromString: '{2D3D3845-39AF-4850-BBF9-40B49780011D}')!
ISpObjectTokenCategory comment: '<ISpObjectTokenCategory> is a wrapper class for the COM interface ''SpeechLib.ISpObjectTokenCategory'' generated from type information in the ''Microsoft Speech Object Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"ISpObjectTokenCategory"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(2D3D3845-39AF-4850-BBF9-40B49780011D), 
	helpstring("ISpObjectTokenCategory"), 
	restricted
]
interface ISpObjectTokenCategory : ISpDataKey {
	[id(0x60020000)]
	HRESULT __stdcall SetId(
		[in] unsigned short* pszCategoryId,
		long fCreateIfNotExist);
	[id(0x60020001)]
	HRESULT __stdcall GetId(
		[out] unsigned short** ppszCoMemCategoryId);
	[id(0x60020002)]
	HRESULT __stdcall GetDataKey(
		SPDATAKEYLOCATION spdkl,
		ISpDataKey** ppDataKey);
	[id(0x60020003)]
	HRESULT __stdcall EnumTokens(
		[in] LPWSTR pzsReqAttribs,
		[in] LPWSTR pszOptAttribs,
		[out] IEnumSpObjectTokens** ppEnum);
	[id(0x60020004)]
	HRESULT __stdcall SetDefaultTokenId(
		[in] unsigned short* pszTokenId);
	[id(0x60020005)]
	HRESULT __stdcall GetDefaultTokenId(
		[out] unsigned short** ppszCoMemTokenId);
};
'!
!ISpObjectTokenCategory categoriesForClass!COM-Interfaces!SpeechLib-Interfaces! !
!ISpObjectTokenCategory methodsFor!

enumTokens: pzsReqAttribs pszOptAttribs: pszOptAttribs
	"Answer the <IEnumSpObjectTokens> result of invoking the EnumTokens() method of the COM object."

	| answer |
	answer := IEnumSpObjectTokens newPointer.
	self
		EnumTokens: pzsReqAttribs asUnicodeString
		pszOptAttribs: pszOptAttribs asUnicodeString
		ppEnum: answer.
	^answer asObject
!

EnumTokens: pzsReqAttribs pszOptAttribs: pszOptAttribs ppEnum: ppEnum
	"Private - Invoke the EnumTokens() method of the COM object.

		HRESULT __stdcall EnumTokens(
			[in] LPWSTR pzsReqAttribs,
			[in] LPWSTR pszOptAttribs,
			[out] IEnumSpObjectTokens** ppEnum);"

	<virtual stdcall: hresult 19 lpwstr lpwstr IEnumSpObjectTokens**>
	^self invalidCall
!

getDataKey: spdkl ppDataKey: ppDataKey
	"Invoke the GetDataKey() method of the COM object."

	^self
		GetDataKey: spdkl
		ppDataKey: ppDataKey
!

GetDataKey: spdkl ppDataKey: ppDataKey
	"Private - Invoke the GetDataKey() method of the COM object.

		HRESULT __stdcall GetDataKey(
			SPDATAKEYLOCATION spdkl,
			ISpDataKey** ppDataKey);"

	<virtual stdcall: hresult 18 sdword ISpDataKey**>
	^self invalidCall
!

getDefaultTokenId
	"Answer the <WORD> result of invoking the GetDefaultTokenId() method of the COM object."

	| answer |
	answer := (WORD newBufferClass: COMTaskMemory).
	self GetDefaultTokenId: answer.
	^answer asObject
!

GetDefaultTokenId: ppszCoMemTokenId
	"Private - Invoke the GetDefaultTokenId() method of the COM object.

		HRESULT __stdcall GetDefaultTokenId(
			[out] unsigned short** ppszCoMemTokenId);"

	<virtual stdcall: hresult 21 word**>
	^self invalidCall
!

getId
	"Answer the <WORD> result of invoking the GetId() method of the COM object."

	| answer |
	answer := (WORD newBufferClass: COMTaskMemory).
	self GetId: answer.
	^answer asObject
!

GetId: ppszCoMemCategoryId
	"Private - Invoke the GetId() method of the COM object.

		HRESULT __stdcall GetId(
			[out] unsigned short** ppszCoMemCategoryId);"

	<virtual stdcall: hresult 17 word**>
	^self invalidCall
!

setDefaultTokenId: pszTokenId
	"Invoke the SetDefaultTokenId() method of the COM object."

	^self SetDefaultTokenId: pszTokenId
!

SetDefaultTokenId: pszTokenId
	"Private - Invoke the SetDefaultTokenId() method of the COM object.

		HRESULT __stdcall SetDefaultTokenId(
			[in] unsigned short* pszTokenId);"

	<virtual stdcall: hresult 20 word*>
	^self invalidCall
!

setId: pszCategoryId fCreateIfNotExist: fCreateIfNotExist
	"Invoke the SetId() method of the COM object."

	^self
		SetId: pszCategoryId
		fCreateIfNotExist: fCreateIfNotExist
!

SetId: pszCategoryId fCreateIfNotExist: fCreateIfNotExist
	"Private - Invoke the SetId() method of the COM object.

		HRESULT __stdcall SetId(
			[in] unsigned short* pszCategoryId,
			long fCreateIfNotExist);"

	<virtual stdcall: hresult 16 word* sdword>
	^self invalidCall
! !
!ISpObjectTokenCategory categoriesFor: #enumTokens:pszOptAttribs:!**auto generated**!methods!public! !
!ISpObjectTokenCategory categoriesFor: #EnumTokens:pszOptAttribs:ppEnum:!**auto generated**!COM Interfaces-ISpObjectTokenCategory!private! !
!ISpObjectTokenCategory categoriesFor: #getDataKey:ppDataKey:!**auto generated**!methods!public! !
!ISpObjectTokenCategory categoriesFor: #GetDataKey:ppDataKey:!**auto generated**!COM Interfaces-ISpObjectTokenCategory!private! !
!ISpObjectTokenCategory categoriesFor: #getDefaultTokenId!**auto generated**!methods!public! !
!ISpObjectTokenCategory categoriesFor: #GetDefaultTokenId:!**auto generated**!COM Interfaces-ISpObjectTokenCategory!private! !
!ISpObjectTokenCategory categoriesFor: #getId!**auto generated**!methods!public! !
!ISpObjectTokenCategory categoriesFor: #GetId:!**auto generated**!COM Interfaces-ISpObjectTokenCategory!private! !
!ISpObjectTokenCategory categoriesFor: #setDefaultTokenId:!**auto generated**!methods!public! !
!ISpObjectTokenCategory categoriesFor: #SetDefaultTokenId:!**auto generated**!COM Interfaces-ISpObjectTokenCategory!private! !
!ISpObjectTokenCategory categoriesFor: #setId:fCreateIfNotExist:!**auto generated**!methods!public! !
!ISpObjectTokenCategory categoriesFor: #SetId:fCreateIfNotExist:!**auto generated**!COM Interfaces-ISpObjectTokenCategory!private! !

!ISpObjectTokenCategory class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'SpeechLib.ISpObjectTokenCategory'
		ISpObjectTokenCategory defineTemplate"

	self
		defineFunction: #SetId:fCreateIfNotExist:
			argumentTypes: 'word* sdword';
		defineFunction: #GetId:
			argumentTypes: 'word**';
		defineFunction: #GetDataKey:ppDataKey:
			argumentTypes: 'sdword ISpDataKey**';
		defineFunction: #EnumTokens:pszOptAttribs:ppEnum:
			argumentTypes: 'lpwstr lpwstr IEnumSpObjectTokens**';
		defineFunction: #SetDefaultTokenId:
			argumentTypes: 'word*';
		defineFunction: #GetDefaultTokenId:
			argumentTypes: 'word**'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		ISpObjectTokenCategory initializeTypeLib"

	typeLib := SpeechLib! !
!ISpObjectTokenCategory class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!ISpObjectTokenCategory class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

