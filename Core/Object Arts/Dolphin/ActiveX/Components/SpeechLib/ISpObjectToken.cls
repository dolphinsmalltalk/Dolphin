"Filed out from Dolphin Smalltalk X6"!

ISpDataKey subclass: #ISpObjectToken
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SpeechLibConstants'
	classInstanceVariableNames: ''!
ISpObjectToken guid: (IID fromString: '{14056589-E16C-11D2-BB90-00C04F8EE6C0}')!
ISpObjectToken comment: '<ISpObjectToken> is a wrapper class for the COM interface ''SpeechLib.ISpObjectToken'' generated from type information in the ''Microsoft Speech Object Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"ISpObjectToken Interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(14056589-E16C-11D2-BB90-00C04F8EE6C0), 
	helpstring("ISpObjectToken Interface"), 
	restricted
]
interface ISpObjectToken : ISpDataKey {
	[id(0x60020000)]
	HRESULT __stdcall SetId(
		unsigned short* pszCategoryId,
		unsigned short* pszTokenId,
		long fCreateIfNotExist);
	[id(0x60020001)]
	HRESULT __stdcall GetId(
		unsigned short** ppszCoMemTokenId);
	[id(0x60020002)]
	HRESULT __stdcall GetCategory(
		ISpObjectTokenCategory** ppTokenCategory);
	[id(0x60020003)]
	HRESULT __stdcall CreateInstance(
		[in] IUnknown* pUnkOuter,
		[in] unsigned long dwClsContext,
		[in] GUID* riid,
		[out] void** ppvObject);
	[id(0x60020004)]
	HRESULT __stdcall GetStorageFileName(
		[in] GUID* clsidCaller,
		[in] unsigned short* pszValueName,
		[in] unsigned short* pszFileNameSpecifier,
		[in] unsigned long nFolder,
		[out] unsigned short** ppszFilePath);
	[id(0x60020005)]
	HRESULT __stdcall RemoveStorageFileName(
		[in] GUID* clsidCaller,
		[in] unsigned short* pszKeyName,
		[in] long fDeleteFile);
	[id(0x60020006)]
	HRESULT __stdcall Remove(
		GUID* pclsidCaller);
	[id(0x60020007)]
	HRESULT __stdcall IsUISupported(
		[in] unsigned short* pszTypeOfUI,
		[in] void* pvExtraData,
		[in] unsigned long cbExtraData,
		[in] IUnknown* punkObject,
		[out] long* pfSupported);
	[id(0x60020008)]
	HRESULT __stdcall DisplayUI(
		[in] wireHWND hWndParent,
		[in] unsigned short* pszTitle,
		[in] unsigned short* pszTypeOfUI,
		[in] void* pvExtraData,
		[in] unsigned long cbExtraData,
		[in] IUnknown* punkObject);
	[id(0x60020009)]
	HRESULT __stdcall MatchesAttributes(
		[in] unsigned short* pszAttributes,
		[out] long* pfMatches);
};
'!
!ISpObjectToken categoriesForClass!COM-Interfaces!SpeechLib-Interfaces! !
!ISpObjectToken methodsFor!

createInstance: pUnkOuter dwClsContext: dwClsContext riid: riid
	"Answer the <VOID> result of invoking the CreateInstance() method of the COM object."

	| answer |
	answer := (VOID newBufferClass: COMTaskMemory).
	self
		CreateInstance: pUnkOuter
		dwClsContext: dwClsContext
		riid: riid
		ppvObject: answer.
	^answer asObject
!

CreateInstance: pUnkOuter dwClsContext: dwClsContext riid: riid ppvObject: ppvObject
	"Private - Invoke the CreateInstance() method of the COM object.

		HRESULT __stdcall CreateInstance(
			[in] IUnknown* pUnkOuter,
			[in] unsigned long dwClsContext,
			[in] GUID* riid,
			[out] void** ppvObject);"

	<virtual stdcall: hresult 19 IUnknown* dword GUID* void**>
	^self invalidCall
!

displayUI: hWndParent pszTitle: pszTitle pszTypeOfUI: pszTypeOfUI pvExtraData: pvExtraData cbExtraData: cbExtraData punkObject: punkObject
	"Invoke the DisplayUI() method of the COM object."

	^self
		DisplayUI: hWndParent
		pszTitle: pszTitle
		pszTypeOfUI: pszTypeOfUI
		pvExtraData: pvExtraData
		cbExtraData: cbExtraData
		punkObject: punkObject
!

DisplayUI: hWndParent pszTitle: pszTitle pszTypeOfUI: pszTypeOfUI pvExtraData: pvExtraData cbExtraData: cbExtraData punkObject: punkObject
	"Private - Invoke the DisplayUI() method of the COM object.

		HRESULT __stdcall DisplayUI(
			[in] wireHWND hWndParent,
			[in] unsigned short* pszTitle,
			[in] unsigned short* pszTypeOfUI,
			[in] void* pvExtraData,
			[in] unsigned long cbExtraData,
			[in] IUnknown* punkObject);"

	<virtual stdcall: hresult 24 handle* word* word* void* dword IUnknown*>
	^self invalidCall
!

getCategory: ppTokenCategory
	"Invoke the GetCategory() method of the COM object."

	^self GetCategory: ppTokenCategory
!

GetCategory: ppTokenCategory
	"Private - Invoke the GetCategory() method of the COM object.

		HRESULT __stdcall GetCategory(
			ISpObjectTokenCategory** ppTokenCategory);"

	<virtual stdcall: hresult 18 ISpObjectTokenCategory**>
	^self invalidCall
!

getId: ppszCoMemTokenId
	"Invoke the GetId() method of the COM object."

	^self GetId: ppszCoMemTokenId
!

GetId: ppszCoMemTokenId
	"Private - Invoke the GetId() method of the COM object.

		HRESULT __stdcall GetId(
			unsigned short** ppszCoMemTokenId);"

	<virtual stdcall: hresult 17 word**>
	^self invalidCall
!

getStorageFileName: clsidCaller pszValueName: pszValueName pszFileNameSpecifier: pszFileNameSpecifier nFolder: nFolder
	"Answer the <WORD> result of invoking the GetStorageFileName() method of the COM object."

	| answer |
	answer := (WORD newBufferClass: COMTaskMemory).
	self
		GetStorageFileName: clsidCaller
		pszValueName: pszValueName
		pszFileNameSpecifier: pszFileNameSpecifier
		nFolder: nFolder
		ppszFilePath: answer.
	^answer asObject
!

GetStorageFileName: clsidCaller pszValueName: pszValueName pszFileNameSpecifier: pszFileNameSpecifier nFolder: nFolder ppszFilePath: ppszFilePath
	"Private - Invoke the GetStorageFileName() method of the COM object.

		HRESULT __stdcall GetStorageFileName(
			[in] GUID* clsidCaller,
			[in] unsigned short* pszValueName,
			[in] unsigned short* pszFileNameSpecifier,
			[in] unsigned long nFolder,
			[out] unsigned short** ppszFilePath);"

	<virtual stdcall: hresult 20 GUID* word* word* dword word**>
	^self invalidCall
!

isUISupported: pszTypeOfUI pvExtraData: pvExtraData cbExtraData: cbExtraData punkObject: punkObject
	"Answer the <SDWORD> result of invoking the IsUISupported() method of the COM object."

	| answer |
	answer := (SDWORD new).
	self
		IsUISupported: pszTypeOfUI
		pvExtraData: pvExtraData
		cbExtraData: cbExtraData
		punkObject: punkObject
		pfSupported: answer.
	^answer asObject
!

IsUISupported: pszTypeOfUI pvExtraData: pvExtraData cbExtraData: cbExtraData punkObject: punkObject pfSupported: pfSupported
	"Private - Invoke the IsUISupported() method of the COM object.

		HRESULT __stdcall IsUISupported(
			[in] unsigned short* pszTypeOfUI,
			[in] void* pvExtraData,
			[in] unsigned long cbExtraData,
			[in] IUnknown* punkObject,
			[out] long* pfSupported);"

	<virtual stdcall: hresult 23 word* void* dword IUnknown* sdword*>
	^self invalidCall
!

matchesAttributes: pszAttributes
	"Answer the <SDWORD> result of invoking the MatchesAttributes() method of the COM object."

	| answer |
	answer := (SDWORD new).
	self
		MatchesAttributes: pszAttributes
		pfMatches: answer.
	^answer asObject
!

MatchesAttributes: pszAttributes pfMatches: pfMatches
	"Private - Invoke the MatchesAttributes() method of the COM object.

		HRESULT __stdcall MatchesAttributes(
			[in] unsigned short* pszAttributes,
			[out] long* pfMatches);"

	<virtual stdcall: hresult 25 word* sdword*>
	^self invalidCall
!

remove: pclsidCaller
	"Invoke the Remove() method of the COM object."

	^self Remove: pclsidCaller
!

Remove: pclsidCaller
	"Private - Invoke the Remove() method of the COM object.

		HRESULT __stdcall Remove(
			GUID* pclsidCaller);"

	<virtual stdcall: hresult 22 GUID*>
	^self invalidCall
!

removeStorageFileName: clsidCaller pszKeyName: pszKeyName fDeleteFile: fDeleteFile
	"Invoke the RemoveStorageFileName() method of the COM object."

	^self
		RemoveStorageFileName: clsidCaller
		pszKeyName: pszKeyName
		fDeleteFile: fDeleteFile
!

RemoveStorageFileName: clsidCaller pszKeyName: pszKeyName fDeleteFile: fDeleteFile
	"Private - Invoke the RemoveStorageFileName() method of the COM object.

		HRESULT __stdcall RemoveStorageFileName(
			[in] GUID* clsidCaller,
			[in] unsigned short* pszKeyName,
			[in] long fDeleteFile);"

	<virtual stdcall: hresult 21 GUID* word* sdword>
	^self invalidCall
!

setId: pszCategoryId pszTokenId: pszTokenId fCreateIfNotExist: fCreateIfNotExist
	"Invoke the SetId() method of the COM object."

	^self
		SetId: pszCategoryId
		pszTokenId: pszTokenId
		fCreateIfNotExist: fCreateIfNotExist
!

SetId: pszCategoryId pszTokenId: pszTokenId fCreateIfNotExist: fCreateIfNotExist
	"Private - Invoke the SetId() method of the COM object.

		HRESULT __stdcall SetId(
			unsigned short* pszCategoryId,
			unsigned short* pszTokenId,
			long fCreateIfNotExist);"

	<virtual stdcall: hresult 16 word* word* sdword>
	^self invalidCall
! !
!ISpObjectToken categoriesFor: #createInstance:dwClsContext:riid:!**auto generated**!methods!public! !
!ISpObjectToken categoriesFor: #CreateInstance:dwClsContext:riid:ppvObject:!**auto generated**!COM Interfaces-ISpObjectToken!private! !
!ISpObjectToken categoriesFor: #displayUI:pszTitle:pszTypeOfUI:pvExtraData:cbExtraData:punkObject:!**auto generated**!methods!public! !
!ISpObjectToken categoriesFor: #DisplayUI:pszTitle:pszTypeOfUI:pvExtraData:cbExtraData:punkObject:!COM Interfaces-ISpObjectToken!private! !
!ISpObjectToken categoriesFor: #getCategory:!**auto generated**!methods!public! !
!ISpObjectToken categoriesFor: #GetCategory:!**auto generated**!COM Interfaces-ISpObjectToken!private! !
!ISpObjectToken categoriesFor: #getId:!**auto generated**!methods!public! !
!ISpObjectToken categoriesFor: #GetId:!**auto generated**!COM Interfaces-ISpObjectToken!private! !
!ISpObjectToken categoriesFor: #getStorageFileName:pszValueName:pszFileNameSpecifier:nFolder:!**auto generated**!methods!public! !
!ISpObjectToken categoriesFor: #GetStorageFileName:pszValueName:pszFileNameSpecifier:nFolder:ppszFilePath:!**auto generated**!COM Interfaces-ISpObjectToken!private! !
!ISpObjectToken categoriesFor: #isUISupported:pvExtraData:cbExtraData:punkObject:!**auto generated**!methods!public! !
!ISpObjectToken categoriesFor: #IsUISupported:pvExtraData:cbExtraData:punkObject:pfSupported:!**auto generated**!COM Interfaces-ISpObjectToken!private! !
!ISpObjectToken categoriesFor: #matchesAttributes:!**auto generated**!methods!public! !
!ISpObjectToken categoriesFor: #MatchesAttributes:pfMatches:!**auto generated**!COM Interfaces-ISpObjectToken!private! !
!ISpObjectToken categoriesFor: #remove:!**auto generated**!methods!public! !
!ISpObjectToken categoriesFor: #Remove:!**auto generated**!COM Interfaces-ISpObjectToken!private! !
!ISpObjectToken categoriesFor: #removeStorageFileName:pszKeyName:fDeleteFile:!**auto generated**!methods!public! !
!ISpObjectToken categoriesFor: #RemoveStorageFileName:pszKeyName:fDeleteFile:!**auto generated**!COM Interfaces-ISpObjectToken!private! !
!ISpObjectToken categoriesFor: #setId:pszTokenId:fCreateIfNotExist:!**auto generated**!methods!public! !
!ISpObjectToken categoriesFor: #SetId:pszTokenId:fCreateIfNotExist:!**auto generated**!COM Interfaces-ISpObjectToken!private! !

!ISpObjectToken class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'SpeechLib.ISpObjectToken'
		ISpObjectToken defineTemplate"

	self
		defineFunction: #SetId:pszTokenId:fCreateIfNotExist:
			argumentTypes: 'word* word* sdword';
		defineFunction: #GetId:
			argumentTypes: 'word**';
		defineFunction: #GetCategory:
			argumentTypes: 'ISpObjectTokenCategory**';
		defineFunction: #CreateInstance:dwClsContext:riid:ppvObject:
			argumentTypes: 'IUnknown* dword GUID* void**';
		defineFunction: #GetStorageFileName:pszValueName:pszFileNameSpecifier:nFolder:ppszFilePath:
			argumentTypes: 'GUID* word* word* dword word**';
		defineFunction: #RemoveStorageFileName:pszKeyName:fDeleteFile:
			argumentTypes: 'GUID* word* sdword';
		defineFunction: #Remove:
			argumentTypes: 'GUID*';
		defineFunction: #IsUISupported:pvExtraData:cbExtraData:punkObject:pfSupported:
			argumentTypes: 'word* void* dword IUnknown* sdword*';
		defineFunction: #DisplayUI:pszTitle:pszTypeOfUI:pvExtraData:cbExtraData:punkObject:
			argumentTypes: 'handle* word* word* void* dword IUnknown*';
		defineFunction: #MatchesAttributes:pfMatches:
			argumentTypes: 'word* sdword*'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		ISpObjectToken initializeTypeLib"

	typeLib := SpeechLib! !
!ISpObjectToken class categoriesFor: #defineFunctions!initializing!public! !
!ISpObjectToken class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

