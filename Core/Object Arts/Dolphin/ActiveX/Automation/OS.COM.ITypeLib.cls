"Filed out from Dolphin Smalltalk 7"!

IUnknown subclass: #ITypeLib
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'AXAutomationConstants AXAutomationErrors'
	classInstanceVariableNames: ''
	classConstants: {}!
ITypeLib guid: (IID fromString: '{00020402-0000-0000-c000-000000000046}')!
ITypeLib comment: 'ITypeLib is a <COMInterface> class which wraps an COM Automation ITypeLib interface pointer.

The purpose of ITypeLib is to serve as the top-level entry point to a COM type library, which is a repository of meta-information about COM objects and interfaces. An ITypeLib is typically acquired either by loading a type library explicitly from the resources of a COM server or a .TLB file, or directly from a COM object via an interface such as IProvideClassInfo.

The member functions of ITypeLib permit one to enquire about general attributes of the library, but more importantly they enable one to enumerate through the individual meta-elements by acquiring ITypeInfo interfaces on them.

ITypeLib is a complex and very powerful interface so we have chosen to separate most of Dolphin''s higher level wrapping into a separate class, namely AXTypeLibraryAnalyzer. Therefore the only methods implemented here are the virtual call outs and a few simple wrappers for those.

ITypeLib is primarily of use in the construction of programming tools (it is fundamental to Dolphin''s support for auto-generation of COM object wrappers), but it is unlikely to be of much relevance to most applications.'!
!ITypeLib categoriesForClass!COM-Interfaces!OCIDL-Interfaces! !
!ITypeLib methodsFor!

FindName: findName lHashVal: lHashVal ppTInfo: ppTInfo rgMemId: rgMemId pcFound: pcFound
	"Invoke the FindName() method of the COM object wrapped by the receiver.

		HRESULT __stdcall FindName(
			[in] LPWSTR szNameBuf,
			[in] unsigned long lHashVal,
			[out] ITypeInfo** ppTInfo,
			[out] long* rgMemId,
			[in, out] unsigned short* pcFound);
	"

	<virtual stdcall: hresult 12 lpwstr dword lppvoid sdword* dword*>
	^self invalidCall: _failureCode!

getAllCustData
	"Answer a <CUSTDATA> describing the custom data associated with the type library."

	^CUSTDATA new beUnfinalizable; yourself
!

GetDocumentation: index pBstrName: pBstrName pBstrDocString: pBstrDocString pdwHelpContext: pdwHelpContext pBstrHelpFile: pBstrHelpFile
	"Private - Invoke the GetDocumentation() method of the COM object wrapped by the receiver.

		HRESULT __stdcall GetDocumentation(
			[in] int index,
			[out] BSTR* pBstrName,
			[out] BSTR* pBstrDocString,
			[out] unsigned long* pdwHelpContext,
			[out] BSTR* pBstrHelpFile);

	Note that we deliberately return the HRESULT code as an integer value rather than having an
	exception raised."

	<virtual stdcall: sdword 10 sdword lppvoid lppvoid dword* lppvoid>
	^self invalidCall: _failureCode!

getLibAttr
	"Answer a <TLIBATTR> detailing the library attributes for the receiver
	(its LIBID, version, locale id, some flags, and an enumerator identifying
	the target OS - which will always be Win32 in our case).
	Note that the answer MUST be free'd using ReleaseLibAttr()."

	| libattr |
	libattr:= TLIBATTR newPointer.
	self GetLibAttr: libattr.
	^libattr!

GetLibAttr: getLibAttr
	"Private - Invoke the GetLibAttr() method of the COM object wrapped by the receiver.

		HRESULT __stdcall GetLibAttr(
			[out] TLIBATTR** ppTLibAttr);
	"

	<virtual stdcall: hresult 8 TLIBATTR**>
	^self invalidCall: _failureCode!

getTypeComp
	"Answer the <ITypeComp> result of invoking the COM Object's GetTypeComp() method."

	| answer |
	answer := ITypeComp newPointer.
	self
		GetTypeComp: answer.
	^answer asObject
!

GetTypeComp: getTypeComp
	"Callout for the ITypeLib::GetTypeComp() interface function.
	N.B. This method has been automatically generated from 
	the vtable defined in ITypeLib>>defineFunctions. DO NOT MODIFY!!"

	<virtual stdcall: hresult 9 lppvoid>
	^self invalidCall: _failureCode!

GetTypeInfo: index ppTInfo: ppTInfo
	"Callout for the ITypeLib::GetTypeInfo() interface function."

	<virtual stdcall: hresult 5 dword lppvoid>
	^self invalidCall: _failureCode!

GetTypeInfoCount
	"Private - Invoke the GetTypeInfoCount() method of the COM object wrapped by the receiver.

		DWORD__stdcall GetTypeInfoCount();
	"

	<virtual stdcall: dword 4>
	^self invalidCall: _failureCode!

getTypeInfoOfGuid: guid ifNone: exceptionHandler
	"Answer an ITypeInfo for the type with <GUID>, guid, or if there is no
	type information in this library with that unique id, then the result of
	evaluating the <niladicValuable> exceptionHandler."

	| answer hr |
	answer := ITypeInfo newPointer.
	hr := self GetTypeInfoOfGuid: guid ppTInfo: answer.
	^hr >= 0 
		ifTrue: [answer]
		ifFalse: [
			hr = TYPE_E_ELEMENTNOTFOUND
				ifTrue: [exceptionHandler value]
				ifFalse: [HRESULTError signalWith: hr]]!

GetTypeInfoOfGuid: guid ppTInfo: ppTInfo
	"Private - Invoke the GetTypeInfoOfGuid() method of the COM object wrapped by the receiver.
	
		HRESULT __stdcall GetTypeInfoOfGuid(
			[in] GUID* guid,
			[out] ITypeInfo** ppTInfo);
	"

	"Modified to return integer code rather than raising an exception here"

	<virtual stdcall: sdword 7 guid* ITypeInfo**>
	^self invalidCall: _failureCode!

GetTypeInfoType: index pTKind: pTKind
	"Callout for the ITypeLib::GetTypeInfoType() interface function."

	<virtual stdcall: hresult 6 dword sdword*>
	^self invalidCall: _failureCode!

isName: aString
	"Answer whether specified string is the name of a member in the receiver."

	| answer |
	answer := DWORDBytes new.
	self
		IsName: aString asUtf16String
		lHashVal: 0
		pfName: answer.
	^answer value asBoolean!

IsName: szNameBuf lHashVal: lHashVal pfName: pfName
	"Private - Invoke the IsName() method of the COM object wrapped by the receiver.

		HRESULT __stdcall IsName(
			[in] LPWSTR szNameBuf,
			[in] unsigned long lHashVal,
			[out] long* pfName,
			[out] BSTR* pBstrLibName);
	"

	<virtual stdcall: hresult 11 lpwstr dword dword*>
	^self invalidCall: _failureCode!

nameAt: index
	"Private - Answer the 'name' of the element with the specified <integer> 
	index in the receiver."

	^self nameAt: index ifAbsent: [self errorNotFound: index]!

nameAt: index ifAbsent: exceptionHandler
	"Private - Answer the 'name' of the element with the specified <integer> 
	index in the receiver."

	| bstrName name hr |
	bstrName := BSTR new.
	"We could use documentationAt:, but that involves a lot of extra
	processing for information we don't need."
	hr := self 
		GetDocumentation: index-1
		pBstrName: bstrName
		pBstrDocString: nil
		pdwHelpContext: nil
		pBstrHelpFile: nil.
	hr < 0 ifTrue: [
		hr = TYPE_E_ELEMENTNOTFOUND ifTrue: [^exceptionHandler value].
		^HRESULTError signalWith: hr].
	name := bstrName asString.
	bstrName free.
	^name!

ReleaseTLibAttr: releaseTLibAttr
	"Private - Invoke the ReleaseTLibAttr() method of the COM object wrapped by the receiver.

		HRESULT __stdcall ReleaseTLibAttr();
	"

	<virtual stdcall: void 13 TLIBATTR*>
	^self invalidCall: _failureCode!

typeComp
	"Answer an ITypeComp on the receiver."

	| answer |
	answer := ITypeComp newPointer.
	self GetTypeComp: answer.
	^answer!

typeInfoAt: index
	"Answer an <ITypeInfo> for the member with the specified one-based
	<integer> index in the receiver."

	| answer |
	answer := ITypeInfo newPointer.
	self GetTypeInfo: index-1 ppTInfo: answer.
	^answer!

typekindAt: anInteger
	"Private - Answer the TYPEKIND of the member with the specified index in the receiver.

		enum TYPEKIND
		{	
			TKIND_ENUM		= 0,
			TKIND_RECORD	= TKIND_ENUM + 1,
			TKIND_MODULE	= TKIND_RECORD + 1,
			TKIND_INTERFACE	= TKIND_MODULE + 1,
			TKIND_DISPATCH	= TKIND_INTERFACE + 1,
			TKIND_COCLASS	= TKIND_DISPATCH + 1,
			TKIND_ALIAS		= TKIND_COCLASS + 1,
			TKIND_UNION		= TKIND_ALIAS + 1,
			TKIND_MAX		= TKIND_UNION + 1
		};
	"

	| answer |
	answer := SDWORD new.
	self GetTypeInfoType: anInteger-1 pTKind: answer.
	^answer value! !
!ITypeLib categoriesFor: #FindName:lHashVal:ppTInfo:rgMemId:pcFound:!COM Interfaces-ITypeLib!primitives!public! !
!ITypeLib categoriesFor: #getAllCustData!accessing!public! !
!ITypeLib categoriesFor: #GetDocumentation:pBstrName:pBstrDocString:pdwHelpContext:pBstrHelpFile:!COM Interfaces-ITypeLib!primitives!private! !
!ITypeLib categoriesFor: #getLibAttr!accessing!public! !
!ITypeLib categoriesFor: #GetLibAttr:!COM Interfaces-ITypeLib!primitives!private! !
!ITypeLib categoriesFor: #getTypeComp!**auto generated**!methods!public! !
!ITypeLib categoriesFor: #GetTypeComp:!COM Interfaces-ITypeLib!primitives!public! !
!ITypeLib categoriesFor: #GetTypeInfo:ppTInfo:!COM Interfaces-ITypeLib!primitives!public! !
!ITypeLib categoriesFor: #GetTypeInfoCount!COM Interfaces-ITypeLib!primitives!private! !
!ITypeLib categoriesFor: #getTypeInfoOfGuid:ifNone:!accessing!public! !
!ITypeLib categoriesFor: #GetTypeInfoOfGuid:ppTInfo:!COM Interfaces-ITypeLib!private! !
!ITypeLib categoriesFor: #GetTypeInfoType:pTKind:!COM Interfaces-ITypeLib!primitives!public! !
!ITypeLib categoriesFor: #isName:!accessing!public! !
!ITypeLib categoriesFor: #IsName:lHashVal:pfName:!COM Interfaces-ITypeLib!primitives!private! !
!ITypeLib categoriesFor: #nameAt:!accessing!private! !
!ITypeLib categoriesFor: #nameAt:ifAbsent:!accessing!private! !
!ITypeLib categoriesFor: #ReleaseTLibAttr:!COM Interfaces-ITypeLib!primitives!private! !
!ITypeLib categoriesFor: #typeComp!accessing!public! !
!ITypeLib categoriesFor: #typeInfoAt:!accessing!public! !
!ITypeLib categoriesFor: #typekindAt:!accessing!private! !

!ITypeLib class methodsFor!

defineFunctions
	"Declare the virtual functions supported by the receiver.
		ITypeLib compileFunctions
	"

	self
		defineFunction: #GetTypeInfoCount returnType: 'dword';
		defineFunction: #GetTypeInfo:ppTInfo: argumentTypes: 'dword ITypeInfo**';
		defineFunction: #GetTypeInfoType:pTKind: argumentTypes: 'dword SDWORD*';
		defineFunction: #GetTypeInfoOfGuid:ppTInfo: argumentTypes: 'GUID* ITypeInfo**';
		defineFunction: #GetLibAttr: argumentTypes: 'TLIBATTR**';
		defineFunction: #GetTypeComp: argumentTypes: 'ITypeComp**';        
		defineFunction: #GetDocumentation:pBstrName:pBstrDocString:pdwHelpContext:pBstrHelpFile:
			argumentTypes: 'sdword BSTR* BSTR* DWORD* BSTR*';
		defineFunction: #IsName:lHashVal:pfName: argumentTypes: 'lpwstr dword DWORD*';		
		defineFunction: #FindName:lHashVal:ppTInfo:rgMemId:pcFound:
			argumentTypes: 'lpwstr dword ITypeInfo** SDWORD* DWORD*';
		defineFunction: #ReleaseTLibAttr: returnType: 'void' argumentTypes: 'TLIBATTR*'!

fromAttributes: attr
	"Open the registered type library with the attributes in the <TLIBATTR>, attr."

	^self 
		load: attr guid 
		major: attr wMajorVerNum 
		minor: attr wMinorVerNum 
		locale: attr lcid!

load: libid major: verMajor minor: verMinor locale: locale
	"Open the registered type library with the specified GUID, version, and locale.
	Note that you may actually get back a library with a higher minor version number
	by the rules of QueryPathRegTypeLib()."

	| answer |
"	^self 
		open: (self queryPath: libid major: verMajor minor: verMinor locale: locale)
		register: false"
	answer := self newPointer.
	OLEAutLibrary default
		loadRegTypeLib: libid 
		wVerMajor: verMajor wVerMinor: verMinor 
		lcid: locale asParameter
		pptlib: answer.
	^answer queryInterface: ITypeLib2 ifNone: [answer]!

open: pathName
	"Open the type library at the specified path and answer an instance of the
	receiver on it."

	^self open: pathName register: true!

open: aString register: aBoolean
	"Open the type library at the specified path and answer an instance of the
	receiver on it. Optionally (re)register the type library."

	| answer oleaut |
	answer := self newPointer.
	oleaut := OLEAutLibrary default.
	oleaut loadTypeLib: aString pptlib: answer.
	aBoolean
		ifTrue: 
			["Attempt to register system wide first - this will fail if not running elevated"
			(oleaut
				registerTypeLib: answer
				wszFullPath: aString
				wszHelpDir: nil) < S_OK
				ifTrue: 
					["Fall back on user specific registration, which does not require admin priviledges"
					oleaut
						registerTypeLibForUser: answer
						szFullPath: aString
						szHelpDir: nil]].
	^answer!

queryPath: libid major: major minor: minor locale: locale
	"Answer the path of the type library with attributes exactly as detailed
	by the arguments (although a higher minor version number is considered
	acceptable). If the library is not registered on the host machine then 
	answer an empty string."

	^self queryPath: libid major: major minor: minor locale: locale
		ifNone: [HRESULTError signalWith: TYPE_E_LIBNOTREGISTERED]!

queryPath: libid major: major minor: minor locale: locale ifNone: exceptionHandler
	"Answer the path of the type library with attributes as detailed
	by the arguments. If the library is not registered on the host machine
	then answer the result of evaluating the <niladicValuable>, exceptionHandler."
	
	| answer hr |
	answer := BSTR new.
	hr := OLEAutLibrary default
		queryPathOfRegTypeLib: libid
		wVerMajor: major
		wVerMinor: minor
		lcid: locale asParameter
		lpbstrPathName: answer.
	^hr < 0 
		ifTrue: [
			hr = TYPE_E_LIBNOTREGISTERED 
				ifTrue: [exceptionHandler value]
				ifFalse: [HRESULTError signalWith: hr]]
		ifFalse: [answer asString trimNulls]
! !
!ITypeLib class categoriesFor: #defineFunctions!initializing!public! !
!ITypeLib class categoriesFor: #fromAttributes:!instance creation!public! !
!ITypeLib class categoriesFor: #load:major:minor:locale:!instance creation!public! !
!ITypeLib class categoriesFor: #open:!instance creation!public! !
!ITypeLib class categoriesFor: #open:register:!instance creation!public! !
!ITypeLib class categoriesFor: #queryPath:major:minor:locale:!enquiries!public! !
!ITypeLib class categoriesFor: #queryPath:major:minor:locale:ifNone:!enquiries!public! !

