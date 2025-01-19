"Filed out from Dolphin Smalltalk"!

OS.COM.IUnknown
	subclass: #'OS.COM.ITypeInfo'
	instanceVariableNames: 'attributes allCustData'
	classVariableNames: ''
	imports: #(#{OS.COM.AutomationConstants} #{OS.COM.AutomationErrors})
	classInstanceVariableNames: ''
	classConstants: {}!

OS.COM.ITypeInfo guid: (OS.COM.IID fromString: '{00020401-0000-0000-c000-000000000046}')!

OS.COM.ITypeInfo comment: '`ITypeInfo` is a `COM.Interface` class which wraps an OLE Automation ITypeInfo interface pointer.

ITypeInfo contains member functions which allow one to enquire about the structure and attributes of individual elements of a Type Library. Unfortunately it is rather poorly factored (much in need of conditional elimination in fact) in that an ITypeInfo can describe any one of the following automation elements:
	- an enum		an enumerated type.
	- a struct			a structure definition
	- a module		a library/DLL
	- an interface 		an IUnknown derived custom interface
	- a dispinterface	an IDispatch derived Automation interface
	- a coclass		an instantiable component class with a CLSID
	- a typedef		a C style typedef which defines a name for a type
	- a union			a structure definition with variant fields
	
These types correspond to the members of the `TYPEKIND enumeration`, respectively:
	- `TYPEKIND_ENUM`
	- `TYPEKIND_RECORD`
	- `TYPEKIND_MODULE`
	- `TYPEKIND_INTERFACE`
	- `TYPEKIND_DISPATCH`
	- `TYPEKIND_COCLASS`
	- `TYPEKIND_ALIAS`
	- `TYPEKIND_UNION`

As an `ITypeInfo` can describe any of these quite disparate types, it contains a union of all the necessary methods to access all the possible information for each possible type. This makes it rather a large and complex interface, and also means that a number of the methods may not be relevant any individual `ITypeInfo` instance - one has to do a switch on type(kind) to determine which are relevant. With this in mind we have chosen to provide a separate hierarchy of classes to wrap `ITypeInfo` - see `OS.COM.TypeInfoAnalyzer` and subclasses.'!

!OS.COM.ITypeInfo categoriesForClass!COM-Interfaces! !

!OS.COM.ITypeInfo methodsFor!

AddressOfMember: addressOfMember invKind: invKind ppv: ppv
	"Private - Invoke the AddressOfMember() method of the COM object wrapped by the receiver.

		HRESULT __stdcall AddressOfMember(
			[in] MEMBERID memid,
			[in] INVOKEKIND invKind,
			[out] void** ppv);
	"

	<virtual stdcall: hresult 16 int32 int32 void**>
	^self invalidCall: _failureCode!

allCustData
	^allCustData ifNil: [allCustData := self getAllCustData]!

asImplType
	"Answer an <ITypeInfo> which is the resolved implementation type for the receiver
	(basically this means locating the TKIND_INTERFACE typeinfo on a dual interface
	from the TKIND_DISPATCH, but otherwise answering the receiver)."

	"Yes, this is a switch on type - this COM interface really needs conditional decomposition"
	^(self typekind == TKIND_DISPATCH and: [self isDual])
		ifTrue: [self getImplTypeInfoAt: 0]
		ifFalse: [self]!

attributes
	"Answer a TYPEATTR detailing the receiver's attributes - may raise an HRESULTError.
	Implementation Notes: The attributes are cached for future use.
	The structure is allocated by the ITypeInfo's object, and must be freed by that object. 
	Therefore the ExternalStructure we create to represent it has
	a back pointer to the receiver, and will initiate the ReleaseTypeAttr() call via
	the receiver when finalized."

	attributes isNull ifTrue: [
		attributes := self getTypeAttr.
		attributes piTypeInfo: self].
	^attributes!

basicFree
	"Private - Free the receiver's external resources by releasing the interface.
	We must free the cached attributes before it is too late."

	attributes free.
	super basicFree!

CreateInstance: pUnkOuter riid: riid ppvObj: ppvObj
	"Private - Invoke the CreateInstance() method of the COM object wrapped by the receiver.

		HRESULT __stdcall CreateInstance(
			[in] IUnknown* pUnkOuter,
			[in] GUID* riid,
			[out] IUnknown** ppvObj);
	"

	<virtual stdcall: hresult 17 IUnknown* guid* void**>
	^self invalidCall: _failureCode!

getAllCustData
	"Answer a <CUSTDATA> describing the custom data associated with the type described by this ITypeInfo."

	^self nullCustData!

getAllFuncCustData: index 
	"Answer a <CUSTDATA> for the function of the type described by the receiver with the specified zero-based index."

	^self nullCustData
!

getAllParamCustData: indexFunc indexParam: indexParam
	"Answer the <CUSTDATA> result of invoking the COM Object's GetAllParamCustData() method."

	^self nullCustData!

getAllVarCustData: anInteger
	"Answer a <CUSTDATA> for the variable of the type described by the receiver with the specified zero-based index."

	^self nullCustData!

GetContainingTypeLib: ppTLib pIndex: pIndex
	"Private - Invoke the GetContainingTypeLib() method of the COM object wrapped by the receiver.

		HRESULT __stdcall GetContainingTypeLib(
			[out] ITypeLib** ppTLib,
			[out] unsigned int* pIndex);
	"

	<virtual stdcall: hresult 19 ITypeLib** uint32*>
	^self invalidCall: _failureCode!

GetDllEntry: memid invkind: invkind pBstrDllName: pBstrDllName pBstrName: pBstrName pwOrdinal: pwOrdinal
	"Private - Invoke the GetDllEntry() method of the COM object wrapped by the receiver.

		HRESULT __stdcall RemoteGetDllEntry(
			[in] long memid,
			[in] INVOKEKIND invkind,
			[out] BSTR* pBstrDllName,
			[out] BSTR* pBstrName,
			[out] unsigned short* pwOrdinal);
	"

	<virtual stdcall: hresult 14 int32 int32 bstr* bstr* uint16*>
	^self invalidCall: _failureCode!

GetDocumentation: memid pBstrName: pBstrName pBstrDocString: pBstrDocString pdwHelpContext: pdwHelpContext pBstrHelpFile: pBstrHelpFile
	"Private - Invoke the GetDocumentation() method of the COM object wrapped by the receiver.

		HRESULT __stdcall GetDocumentation(
			[in] long memid,
			[out] BSTR* pBstrName,
			[out] BSTR* pBstrDocString,
			[out] unsigned long* pdwHelpContext,
			[out] BSTR* pBstrHelpFile);
	"

	<virtual stdcall: int32 13 int32 bstr* bstr* uint32* bstr*>
	^self invalidCall: _failureCode!

getFuncDesc: index
	"Answer the <FUNCDESC> result of invoking the COM Object's GetFuncDesc() method."

	| ppFuncDesc |
	ppFuncDesc := FUNCDESC newPointer.
	self GetFuncDesc: index ppFuncDesc: ppFuncDesc.
	^ppFuncDesc!

GetFuncDesc: index ppFuncDesc: ppFuncDesc
	"Private - Invoke the GetFuncDesc() method of the COM object wrapped by the receiver.

		HRESULT __stdcall GetFuncDesc(
			[in] unsigned int index,
			[out] FUNCDESC** ppFuncDesc);
	"

	<virtual stdcall: hresult 6 uint32 FUNCDESC**>
	^self invalidCall: _failureCode!

getIDsOfNames: aCollectionOfStrings
	"Answer a `<sequencedReadableCollection>` of the `<integer>` ids of the named members of the type described by the receiver.
	Note that when GetIDsOfNames is called with more than one name, the first name (rgszNames[0]) corresponds to the member name, and subsequent names correspond to the names of the member's parameters. In other words you cannot use this method to retrieve the names of multiple distinct properties or methods at once. Given that the id's of parameters are probably (a) not set, and (b) not terribly interesting, #idOfName: is likely to be more useful, and faster."

	| rgszNames uNames cNames pMemId hr |
	uNames := aCollectionOfStrings collect: [:each | each asUtf16String].
	rgszNames := PointerArray withAll: uNames elementClass: Utf16String.
	cNames := rgszNames size.
	pMemId := Int32Array new: cNames.
	hr := self
				GetIDsOfNames: rgszNames
				cNames: cNames
				pMemId: pMemId.
	hr < 0 ifTrue: [self hresultError: hr].
	^pMemId asArray!

GetIDsOfNames: getIDsOfNames cNames: cNames pMemId: pMemId
	"Private - Invoke the GetIDsOfNames() method of the COM object wrapped by the receiver.

		HRESULT __stdcall GetIDsOfNames(
	                [in] LPOLESTR * rgszNames,
	                [in] UINT cNames,
        		        [out] MEMBERID * pMemId);
	"

	<virtual stdcall: int32 11 lpwstr* uint32 int32*>
	^self invalidCall: _failureCode!

getImplTypeFlags: index 
	"Answer the <Int32> result of invoking the COM Object's GetImplTypeFlags() method."

	| pImplTypeFlags |
	pImplTypeFlags := Int32 new.
	self GetImplTypeFlags: index pImplTypeFlags: pImplTypeFlags.
	^pImplTypeFlags value
!

GetImplTypeFlags: index pImplTypeFlags: pImplTypeFlags
	"Private - Invoke the GetImplTypeFlags() method of the COM object wrapped by the receiver.

		HRESULT __stdcall GetImplTypeFlags(
			[in] unsigned int index,
			[out] int* pImplTypeFlags);
	"

	<virtual stdcall: hresult 10 uint32 int32*>
	^self invalidCall: _failureCode!

getImplTypeInfoAt: anInteger
	"Answer the an ITypeInfo describing the implementation type at the specified index in the receiver.
	Only applicable to Coclass and interface typekinds. The index is one based, although there is a special
	case for index 0 , which can be used to access the dual interface definition, if one exists, for a dispinterface."

	| href |
	href := self getRefTypeOfImplType: anInteger - 1.
	^self getRefTypeInfo: href!

getMops: memid
	"Answer the <BSTR> result of invoking the COM Object's GetMops() method."

	| pBstrMops |
	pBstrMops := BSTR new.
	self GetMops: memid pBstrMops: pBstrMops.
	^pBstrMops value!

GetMops: memid pBstrMops: pBstrMops
	"Private - Invoke the GetMops() method of the COM object wrapped by the receiver.

		HRESULT __stdcall GetMops(
			[in] long memid,
			[out] BSTR* pBstrMops);
	"

	<virtual stdcall: hresult 18 int32 bstr*>
	^self invalidCall: _failureCode!

GetNames: memid rgBstrNames: rgBstrNames cMaxNames: cMaxNames pcNames: pcNames
	"Private - Invoke the GetNames() method of the COM object wrapped by the receiver.

		HRESULT __stdcall GetNames(
			[in] long memid,
			[out] BSTR* rgBstrNames,
			[in] unsigned int cMaxNames,
			[out] unsigned int* pcNames);
	"

	<virtual stdcall: hresult 8 int32 bstr* uint32 uint32*>
	^self invalidCall: _failureCode!

getNamesOfMember: memid count: cMaxNames
	"Answer an array containing the names of the member of the
	receiver identified by the <MEMBERID>, memid."

	| names cNames strings |
	names := BSTRArray new: cMaxNames.
	cNames := UInt32Bytes new.
	self
		GetNames: memid
		rgBstrNames: names
		cMaxNames: cMaxNames
		pcNames: cNames.
	strings := names copyFrom: 1 to: cNames asInteger.
	names free.
	^strings!

getRefTypeInfo: hreftype
	"Answer the <ITypeInfo> result of invoking the COM Object's GetRefTypeInfo() method."

	| ppTInfo |
	ppTInfo := ITypeInfo newPointer.
	self GetRefTypeInfo: hreftype ppTInfo: ppTInfo.
	^ppTInfo!

GetRefTypeInfo: hreftype ppTInfo: ppTInfo
	"Private - Invoke the GetRefTypeInfo() method of the COM object wrapped by the receiver.

		HRESULT __stdcall GetRefTypeInfo(
			[in] unsigned long hreftype,
			[out] ITypeInfo** ppTInfo);
	"

	<virtual stdcall: hresult 15 uint32 ITypeInfo**>
	^self invalidCall: _failureCode!

getRefTypeOfImplType: index 
	"Private - Answer the <UInt32> result of invoking the COM Object's GetRefTypeOfImplType() method.
	Note that the index is zero based."

	| pRefType |
	pRefType := UInt32 new.
	self GetRefTypeOfImplType: index pRefType: pRefType.
	^pRefType value
!

GetRefTypeOfImplType: index pRefType: pRefType
	"Private - Invoke the GetRefTypeOfImplType() method of the COM object wrapped by the receiver.

		HRESULT __stdcall GetRefTypeOfImplType(
			[in] unsigned int index,
			[out] unsigned long* pRefType);
	"

	<virtual stdcall: hresult 9 uint32 uint32*>
	^self invalidCall: _failureCode!

getTypeAttr
	"Answer the <TYPEATTR*> result of invoking the COM Object's GetTypeAttr() method."

	| ppTypeAttr |
	ppTypeAttr := TYPEATTR newPointer.
	self GetTypeAttr: ppTypeAttr.
	^ppTypeAttr!

GetTypeAttr: ppTypeAttr
	"Private - Invoke the GetTypeAttr() method of the COM object wrapped by the receiver.

		HRESULT __stdcall GetTypeAttr(
			[out] TYPEATTR** ppTypeAttr);
	"

	<virtual stdcall: hresult 4 TYPEATTR**>
	^self invalidCall: _failureCode!

getTypeComp
	"Answer the <ITypeComp> result of invoking the COM Object's GetTypeComp() method."

	| ppTComp |
	ppTComp := ITypeComp newPointer.
	self GetTypeComp: ppTComp.
	^ppTComp
!

GetTypeComp: ppTComp
	"Private - Invoke the GetTypeComp() method of the COM object wrapped by the receiver.

		HRESULT __stdcall GetTypeComp(
			[out] ITypeComp** ppTComp);
	"

	<virtual stdcall: hresult 5 ITypeComp**>
	^self invalidCall: _failureCode!

getVarDesc: index
	"Answer the <VARDESC> result of invoking the COM Object's GetVarDesc() method."

	| ppVarDesc |
	ppVarDesc := VARDESC newPointer.
	self GetVarDesc: index ppVarDesc: ppVarDesc.
	^ppVarDesc!

GetVarDesc: index ppVarDesc: ppVarDesc
	"Private - Invoke the GetVarDesc() method of the COM object wrapped by the receiver.

		HRESULT __stdcall RemoteGetVarDesc(
			[in] unsigned int index,
			[out] VARDESC** ppVarDesc);
	"

	<virtual stdcall: hresult 7 uint32 VARDESC**>
	^self invalidCall: _failureCode!

guid
	"Answer the guid associated with the receiver.
	This is a globally unique identifier for this particular type, although
	it will often be null when the type is not a co-class or interface."

	^self attributes guid!

idOfName: aString
	"Answer the `<integer>` DISPID of the member named by the `<readableString>` argument in the receiver. Throw a NotFoundError if the name is not recognised."

	"Implementation Note: Although implementable in terms of #getIDsOfNames:, this is much faster for the common case of looking up a single name."

	^self idOfName: aString ifAbsent: [self errorNotFound: aString]!

idOfName: aString ifAbsent: aNiladicValuable
	"Answer the `<integer>` DISPID of the member named by the `<readableString>` 1st argument in the receiver, or the result of evaluating the <niladicValuable> 2nd argument if the name is not associated with an id."

	"Implementation Note: Although implementable in terms of #getIDsOfNames:, this is much faster for the common case of looking up a single member name."

	| dispId uName hr |
	dispId := UInt32Bytes new.
	uName := aString asUtf16String.
	hr := self
				GetIDsOfNames: (PointerArray with: uName)
				cNames: 1
				pMemId: dispId.
	^hr < 0
		ifTrue: 
			[(hr = DISP_E_UNKNOWNNAME or: [hr = E_NOTIMPL])
				ifTrue: [aNiladicValuable value]
				ifFalse: [self hresultError: hr]]
		ifFalse: [dispId asSignedInteger]!

index
	"Answer the receiver's index in its owning type library."

	| lib myIndex |
	lib := ITypeLib newPointer.
	myIndex := UInt32Bytes new.
	self GetContainingTypeLib: lib pIndex: myIndex.
	lib free.
	^myIndex asInteger + 1!

Invoke: invoke memid: memid wFlags: wFlags pDispParams: pDispParams pVarResult: pVarResult pExcepInfo: pExcepInfo puArgErr: puArgErr
	"Invoke the Invoke() method of the COM object wrapped by the receiver.
	
		HRESULT __stdcall Invoke(
			[in] void* pvInstance,
			[in] sdword memid,
			[in] word wFlags,
			[in, out] DISPPARAMS * pDispParams,
			[out] VARIANT * pVarResult,
			[out] EXCEPINFO * pExcepInfo,
			[out] dword* puArgErr);
	"

	<virtual stdcall: hresult 12 void* uint32 uint16 DISPPARAMS* variant* EXCEPINFO* uint32*>
	^self invalidCall: _failureCode!

isDual
	"Answer whether the receiver is describing a custom interface
	which derives from IDispatch and which can be early or late
	bound."

	^self typeFlags allMask: TYPEFLAG_FDUAL!

isHidden
	"Answer whether the receiver is describing a type which should
	not be displayed in type library browsers.
	Applicable to all typekinds."

	^self typeFlags allMask: TYPEFLAG_FHIDDEN!

libraryAndIndex
	"Answer an <Association> between an <ITypeLib>, which is the receiver's containing type library, and an <integer>, which is the one-based index of the receiver in that type library ."

	| lib myIndex |
	self GetContainingTypeLib: (lib := ITypeLib newPointer) pIndex: (myIndex := UInt32Bytes new).
	^((lib queryInterface: ITypeLib2 ifNone: nil)
		ifNil: [lib]
		ifNotNil: 
			[:lib2 |
			lib free.
			lib2]) -> (myIndex asInteger + 1)!

nameOfID: anInteger
	"Answer a <readableString> name for the member of the 
	receiver identified by the <integer> member id argument. Note that this
	differs from ITypeLib, where indices are used to access the elements.
	We can use this as the reverse mapping to GetIDsOfNames."

	^self nameOfID: anInteger ifAbsent: [self errorNotFound: anInteger]!

nameOfID: anInteger ifAbsent: exceptionHandler
	"Answer a <readableString> name for the member of the 
	receiver identified by the <integer> member id argument. Note that this
	differs from ITypeLib, where indices are used to access the elements.
	We can use this as the reverse mapping to GetIDsOfNames."

	| bstrName name hr |
	bstrName := BSTR basicNew.
	"We could use documentationForMember:, but that involves a lot of extra
	processing for information we don't need."
	hr := self
				GetDocumentation: anInteger
				pBstrName: bstrName
				pBstrDocString: nil
				pdwHelpContext: nil
				pBstrHelpFile: nil.
	hr < 0
		ifTrue: 
			[^hr = TYPE_E_ELEMENTNOTFOUND ifTrue: [exceptionHandler value] ifFalse: [HRESULTError signalWith: hr]].
	name := bstrName asString.
	bstrName basicFree.
	^name!

nullCustData
	^CUSTDATA new
		beUnfinalizable;
		yourself!

onStartup
	allCustData beUnfinalizable.
	allCustData := nil.
	^super onStartup!

recordInfoIfNone: exceptionHandler
	"Answer an <IRecordInfo> on the receiver's type information."

	| answer hr |
	answer := IRecordInfo newPointer.
	hr := OleAut32 getRecordInfoFromTypeInfo: self asParameter ppRecInfo: answer.
	^hr < 0 ifTrue: [exceptionHandler value] ifFalse: [answer]!

ReleaseFuncDesc: pFuncDesc
	"Invoke the ReleaseFuncDesc() method of the COM object wrapped by the receiver.

		void __stdcall ReleaseFuncDesc(
			[in] FUNCDESC* pFuncDesc
		);"

	<virtual stdcall: void 21 FUNCDESC*>
	^self invalidCall: _failureCode!

ReleaseTypeAttr: pTypeAttr
	"Invoke the ReleaseFuncDesc() method of the COM object wrapped by the receiver.

		void __stdcall ReleaseTypeAttr(
			TYPEATTR * pTypeAttr
		);"

	<virtual stdcall: void 20 TYPEATTR*>
	^self invalidCall: _failureCode!

ReleaseVarDesc: pVarDesc
	"Invoke the ReleaseFuncDesc() method of the COM object wrapped by the receiver.

		void __stdcall ReleaseVarDesc(
			[in] VARDESC* pVarDesc
		);"

	<virtual stdcall: void 22 VARDESC*>
	^self invalidCall: _failureCode!

safeInvoke: invoke memid: memid wFlags: wFlags pDispParams: pDispParams pVarResult: pVarResult pExcepInfo: pExcepInfo puArgErr: puArgErr
	"Invoke the Invoke() method of the COM object wrapped by the receiver, but 
	don't raise an exception if it should fail (just return the HRESULT code).
	Implementation Note: We implement a non-exception version of this function
	for efficiency of implementation of dual interfaces in Dolphin."

	<virtual stdcall: int32 12 void* uint32 uint16 DISPPARAMS* variant* EXCEPINFO* uint32*>
	^self invalidCall: _failureCode!

typeComp
	"Answer an ITypeComp on the receiver."

	| answer |
	answer := ITypeComp newPointer.
	self GetTypeComp: answer.
	^answer!

typeFlags
	"Answer the receiver's type flags (from the TYPEFLAGS enumeration).
	Implementation Note: The type flags are retrieved from the receiver's cached TYPEATTR
	information, and are represented there as only 16-bits."

	^self attributes wTypeFlags!

typekind
	"Answer the receiver's typekind (a member of the TYPEKIND enumeration)."

	^self attributes typekind!

typeLib
	"Answer an <ITypeLib> on the receiver's containing type library."

	^self libraryAndIndex key
! !

!OS.COM.ITypeInfo categoriesForMethods!
AddressOfMember:invKind:ppv:!COM Interfaces-OAIDL.ITypeInfo!private! !
allCustData!public! !
asImplType!accessing!converting!public! !
attributes!accessing!public! !
basicFree!private!realizing/unrealizing! !
CreateInstance:riid:ppvObj:!COM Interfaces-OAIDL.ITypeInfo!private! !
getAllCustData!accessing!public! !
getAllFuncCustData:!**auto generated**!public! !
getAllParamCustData:indexParam:!**auto generated**!public! !
getAllVarCustData:!accessing!public! !
GetContainingTypeLib:pIndex:!COM Interfaces-OAIDL.ITypeInfo!private! !
GetDllEntry:invkind:pBstrDllName:pBstrName:pwOrdinal:!COM Interfaces-OAIDL.ITypeInfo!private! !
GetDocumentation:pBstrName:pBstrDocString:pdwHelpContext:pBstrHelpFile:!COM Interfaces-OAIDL.ITypeInfo!private! !
getFuncDesc:!**auto generated**!public! !
GetFuncDesc:ppFuncDesc:!COM Interfaces-OAIDL.ITypeInfo!private! !
getIDsOfNames:!accessing!public! !
GetIDsOfNames:cNames:pMemId:!COM Interfaces-OAIDL.ITypeInfo!private! !
getImplTypeFlags:!**auto generated**!public! !
GetImplTypeFlags:pImplTypeFlags:!COM Interfaces-OAIDL.ITypeInfo!private! !
getImplTypeInfoAt:!accessing!public! !
getMops:!**auto generated**!public! !
GetMops:pBstrMops:!COM Interfaces-OAIDL.ITypeInfo!private! !
GetNames:rgBstrNames:cMaxNames:pcNames:!COM Interfaces-OAIDL.ITypeInfo!private! !
getNamesOfMember:count:!accessing!public! !
getRefTypeInfo:!**auto generated**!public! !
GetRefTypeInfo:ppTInfo:!COM Interfaces-OAIDL.ITypeInfo!private! !
getRefTypeOfImplType:!methods!private! !
GetRefTypeOfImplType:pRefType:!COM Interfaces-OAIDL.ITypeInfo!private! !
getTypeAttr!**auto generated**!public! !
GetTypeAttr:!COM Interfaces-OAIDL.ITypeInfo!private! !
getTypeComp!**auto generated**!public! !
GetTypeComp:!COM Interfaces-OAIDL.ITypeInfo!private! !
getVarDesc:!**auto generated**!public! !
GetVarDesc:ppVarDesc:!COM Interfaces-OAIDL.ITypeInfo!private! !
guid!accessing!public! !
idOfName:!accessing!public! !
idOfName:ifAbsent:!accessing!public! !
index!accessing!public! !
Invoke:memid:wFlags:pDispParams:pVarResult:pExcepInfo:puArgErr:!COM Interfaces-OAIDL.ITypeInfo!private! !
isDual!public!testing! !
isHidden!public!testing! !
libraryAndIndex!accessing!public! !
nameOfID:!accessing!public! !
nameOfID:ifAbsent:!accessing!public! !
nullCustData!accessing!public! !
onStartup!public! !
recordInfoIfNone:!accessing!public! !
ReleaseFuncDesc:!COM Interfaces-OAIDL.ITypeInfo!private! !
ReleaseTypeAttr:!COM Interfaces-OAIDL.ITypeInfo!private! !
ReleaseVarDesc:!COM Interfaces-OAIDL.ITypeInfo!private! !
safeInvoke:memid:wFlags:pDispParams:pVarResult:pExcepInfo:puArgErr:!operations!private! !
typeComp!accessing!public! !
typeFlags!accessing!public! !
typekind!accessing!public! !
typeLib!accessing!public! !
!

!OS.COM.ITypeInfo class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'OAIDL.ITypeInfo'
		ITypeInfo defineTemplate
	"

	self
		defineFunction: #GetTypeAttr:
			argumentTypes: 'TYPEATTR**';
		defineFunction: #GetTypeComp:
			argumentTypes: 'ITypeComp**';
		defineFunction: #GetFuncDesc:ppFuncDesc:
			argumentTypes: 'uint32 FUNCDESC**';
		defineFunction: #GetVarDesc:ppVarDesc:
			argumentTypes: 'int32 VARDESC**';
		defineFunction: #GetNames:rgBstrNames:cMaxNames:pcNames:
			argumentTypes: 'int32 bstr* uint32 uint32*';
		defineFunction: #GetRefTypeOfImplType:pRefType:
			argumentTypes: 'uint32 uint32*';
		defineFunction: #GetImplTypeFlags:pImplTypeFlags:
			argumentTypes: 'uint32 int32*';
		defineFunction: #GetIDsOfNames:cNames:pMemId: 
			returnType: 'int32'
			argumentTypes: 'lpwstr* uint32 int32*';
		defineFunction: #Invoke:memid:wFlags:pDispParams:pVarResult:pExcepInfo:puArgErr:
			argumentTypes: 'lpvoid uint32 uint16 DISPPARAMS* VARIANT* EXCEPINFO* uint32*';
		defineFunction: #GetDocumentation:pBstrName:pBstrDocString:pdwHelpContext:pBstrHelpFile:
			argumentTypes: 'int32 bstr* bstr* uint32* bstr*';
		defineFunction: #GetDllEntry:invkind:pBstrDllName:pBstrName:pwOrdinal:
			argumentTypes: 'int32 int32 bstr* bstr* uint16*';
		defineFunction: #GetRefTypeInfo:ppTInfo:
			argumentTypes: 'uint32 ITypeInfo**';
		defineFunction: #AddressOfMember:invKind:ppv: 
			argumentTypes: 'int32 int32 lppvoid'; 
		defineFunction: #CreateInstance:riid:ppvObj:
			argumentTypes: 'IUnknown* GUID* void**';
		defineFunction: #GetMops:pBstrMops:
			argumentTypes: 'int32 bstr*';
		defineFunction: #GetContainingTypeLib:pIndex:
			argumentTypes: 'ITypeLib** uint32*';

		"This group of methods is for releasing the structures returned by methods 1, 3, and 4 respectively"
		defineFunction: #ReleaseTypeAttr: 
			returnType: 'void' 
			argumentTypes: 'TYPEATTR*';
		defineFunction: #ReleaseFuncDesc: 
			returnType: 'void' 
			argumentTypes: 'FUNCDESC*';
		defineFunction: #ReleaseVarDesc: 
			returnType: 'void' 
			argumentTypes: 'VARDESC*'
!

stbConvertFrom: anSTBClassFormat
	"Version 1 adds allCustData instance variable, initially nil."

	anSTBClassFormat version == 0
		ifTrue: 
			[^
			[:data |
			| newInstance |
			newInstance := self basicNew.
			1 to: data size do: [:i | newInstance instVarAt: i put: (data at: i)].
			newInstance]].
	^super stbConvertFrom: anSTBClassFormat!

stbVersion
	^1! !

!OS.COM.ITypeInfo class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
stbConvertFrom:!binary filing!public! !
stbVersion!binary filing!public! !
!

