﻿"Filed out from Dolphin Smalltalk"!

OS.COM.IUnknown
	subclass: #'OS.COM.ICatInformation'
	instanceVariableNames: ''
	classVariableNames: 'CatMan Controls'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.COM.ICatInformation guid: (OS.COM.IID fromString: '{0002e013-0000-0000-c000-000000000046}')!

OS.COM.ICatInformation comment: '<ICatInformation> is a wrapper class for the COM interface ''COMCAT.ICatInformation'' generated from type information in the ''OLE Component Categories Library'' library. It contains methods to invoke the member functions exposed by that interface.

ICatInformation provides methods for obtaining information about the categories implemented or required by a certain class, as well as information about the categories registered on a given machine.

See MSDN for further information about COM Component Categories.

Class Variables:
	CatMan		<ICatInformation>. Singleton instance.
	Controls		<Array>. Cached <COMObjectRegistration>s for all controls registered on the machine.



ICatInformation new allCategories'!

!OS.COM.ICatInformation categoriesForClass!COM Category Manager!COM-Interfaces! !

!OS.COM.ICatInformation methodsFor!

allCategories
	"Answer a <collection> of <CATEGORYINFO> structures describing all of the registered categories
	for the default system locale."

	^self allCategories: 0!

allCategories: locale
	"Answer a <collection> of <CATEGORYINFO> structures describing all of the registered categories
	for the specified <Locale> (or <integer> lcid), locale."

	^Enumerable onIEnum: (self enumCategories: locale)!

buildGuidArray: guids
	"Private - Answer an <ExternalArray> of <GUID> built from the <collection> of <GUID>s, 
	guids."

	^(StructureArray withAll: guids elementClass: GUID)
		beUnfinalizable;
		yourself!

categoriesOfClass: rclsid
	"Answer a <collection> of <GUID>s identifying all categories implemented by the COM
	component with <CLSID>, rclsid."

	| answer |
	answer := IEnumStruct elementClass: GUID.
	self EnumImplCategoriesOfClass: rclsid ppenumCatid: answer.
	^Enumerable onIEnum: answer!

classesInCategories: implementedCategoryGUIDs requiring: requiredCategoryGUIDs
	"Answer a <collection> of the <CLSID>s of all components registered on the system
	that support the categories identified by the <collection> of <GUID>s, implementedCategoryGUIDs, 
	and which require the <collection> of <GUID>s, requiredCategoryGUIDs, as the categories implemented
	in a potential host."

	^(self enumClassesOfCategories: implementedCategoryGUIDs requiring: requiredCategoryGUIDs)
		collect: [:e | ObjectRegistration clsid: (e becomeA: CLSID)]!

classesInCategory: implementedCategory
	"Answer a <collection> of the <CLSID>s of all components registered on the system
	that support the category identified by CATID <GUID>, implementedCategory."

	^self classesInCategories: {implementedCategory} requiring: #()!

descriptionOfCategory: catid
	"Answer a <readableString> description of the category with <GUID> id, catid,
	localized correctly for the default user locale."

	^self descriptionOfCategory: catid locale: Locale userDefault!

descriptionOfCategory: catid locale: locale
	"Answer a <readableString> description of the category with <GUID> id, catid,
	localized correctly for the <Locale> (or <integer> locale id>, locale."

	| buf |
	buf := StructurePointer newNull: TaskMemory elementClass: Utf16String.
	self
		GetCategoryDesc: catid
		lcid: locale asParameter
		pszDesc: buf.
	^buf value asString!

enumCategories: locale
	"Answer an <IEnumCATEGORYINFO> enumerator on all the categories registered
	on the host system for the <Locale> (or <integer> locale id), locale."

	| answer |
	answer := IEnumStruct elementClass: CATEGORYINFO.
	self EnumCategories: locale asParameter ppenumCategoryInfo: answer.
	^answer!

EnumCategories: lcid ppenumCategoryInfo: ppenumCategoryInfo
	"Private - Invoke the EnumCategories() method of the COM object wrapped by the receiver.

		HRESULT __stdcall EnumCategories(
			[in] unsigned long lcid,
			[out] IEnumCATEGORYINFO** ppenumCategoryInfo);
	"

	<virtual stdcall: hresult 4 uint32 void**>
	^self invalidCall: _failureCode!

enumClassesOfCategories: implementedCategoryGUIDs requiring: requiredCategoryGUIDs
	"Answer an <IEnumGUID> enumerator on the <CLSID>s of all components registered on the system
	that support the categories identified by the <collection> of <GUID>s, implementedCategoryGUIDs, 
	and which require the <collection> of <GUID>s, requiredCategoryGUIDs, as the categories implemented
	in a potential host."

	| answer rgcatidImpl cImplemented cRequired rgcatidReq |
	answer := IEnumStruct elementClass: GUID.
	implementedCategoryGUIDs isEmpty
		ifTrue: [cImplemented := -1]
		ifFalse: 
			[rgcatidImpl := self buildGuidArray: implementedCategoryGUIDs.
			cImplemented := implementedCategoryGUIDs size].
	requiredCategoryGUIDs isEmpty
		ifTrue: [cRequired := -1]
		ifFalse: 
			[rgcatidReq := self buildGuidArray: requiredCategoryGUIDs.
			cRequired := requiredCategoryGUIDs size].
	self
		EnumClassesOfCategories: cImplemented
		rgcatidImpl: rgcatidImpl
		cRequired: cRequired
		rgcatidReq: rgcatidReq
		ppenumClsid: answer.
	^answer!

EnumClassesOfCategories: cImplemented rgcatidImpl: rgcatidImpl cRequired: cRequired rgcatidReq: rgcatidReq ppenumClsid: ppenumClsid
	"Private - Invoke the EnumClassesOfCategories() method of the COM object wrapped by the receiver.

		HRESULT __stdcall EnumClassesOfCategories(
			[in] unsigned long cImplemented,
			[in] GUID* rgcatidImpl,
			[in] unsigned long cRequired,
			[in] GUID* rgcatidReq,
			[out] IEnumGUID** ppenumClsid);
	"

	<virtual stdcall: hresult 6 uint32 guid* uint32 guid* void**>
	^self invalidCall: _failureCode!

EnumImplCategoriesOfClass: rclsid ppenumCatid: ppenumCatid
	"Private - Invoke the EnumImplCategoriesOfClass() method of the COM object wrapped by the receiver.

		HRESULT __stdcall EnumImplCategoriesOfClass(
			[in] GUID* rclsid,
			[out] IEnumGUID** ppenumCatid);
	"

	<virtual stdcall: hresult 8 guid* void**>
	^self invalidCall: _failureCode!

EnumReqCategoriesOfClass: rclsid ppenumCatid: ppenumCatid
	"Private - Invoke the EnumReqCategoriesOfClass() method of the COM object wrapped by the receiver.

		HRESULT __stdcall EnumReqCategoriesOfClass(
			[in] GUID* rclsid,
			[out] IEnumGUID** ppenumCatid);
	"

	<virtual stdcall: hresult 9 guid* void**>
	^self invalidCall: _failureCode!

GetCategoryDesc: rcatid lcid: lcid pszDesc: pszDesc
	"Private - Invoke the GetCategoryDesc() method of the COM object wrapped by the receiver.

		HRESULT __stdcall GetCategoryDesc(
			[in] GUID* rcatid,
			[in] unsigned long lcid,
			[out] LPWSTR* pszDesc);
	"

	<virtual stdcall: hresult 5 guid* uint32 lpwstr*>
	^self invalidCall: _failureCode!

IsClassOfCategories: rclsid cImplemented: cImplemented rgcatidImpl: rgcatidImpl cRequired: cRequired rgcatidReq: rgcatidReq
	"Private - Invoke the IsClassOfCategories() method of the COM object wrapped by the receiver.

		HRESULT __stdcall IsClassOfCategories(
			[in] GUID* rclsid,
			[in] unsigned long cImplemented,
			[in] GUID* rgcatidImpl,
			[in] unsigned long cRequired,
			[in] GUID* rgcatidReq);
	"

	<virtual stdcall: hresult 7 guid* uint32 guid* uint32 guid*>
	^self invalidCall: _failureCode!

requiredCategoriesOfClass: rclsid
	"Answer a <collection> of <GUID>s identifying all categories required (of clients) by the COM
	component with <CLSID>, rclsid."

	| answer |
	answer := IEnumStruct elementClass: GUID.
	self EnumReqCategoriesOfClass: rclsid ppenumCatid: answer.
	^Enumerable onIEnum: answer! !

!OS.COM.ICatInformation categoriesForMethods!
allCategories!enquiries!public! !
allCategories:!enquiries!public! !
buildGuidArray:!helpers!methods!private! !
categoriesOfClass:!enquiries!public! !
classesInCategories:requiring:!enquiries!public! !
classesInCategory:!enquiries!public! !
descriptionOfCategory:!enquiries!public! !
descriptionOfCategory:locale:!enquiries!public! !
enumCategories:!enquiries!public! !
EnumCategories:ppenumCategoryInfo:!**auto generated**!COM Interfaces-ICatInformation!private! !
enumClassesOfCategories:requiring:!enquiries!public! !
EnumClassesOfCategories:rgcatidImpl:cRequired:rgcatidReq:ppenumClsid:!COM Interfaces-ICatInformation!private! !
EnumImplCategoriesOfClass:ppenumCatid:!**auto generated**!COM Interfaces-ICatInformation!private! !
EnumReqCategoriesOfClass:ppenumCatid:!**auto generated**!COM Interfaces-ICatInformation!private! !
GetCategoryDesc:lcid:pszDesc:!**auto generated**!COM Interfaces-ICatInformation!private! !
IsClassOfCategories:cImplemented:rgcatidImpl:cRequired:rgcatidReq:!COM Interfaces-ICatInformation!private! !
requiredCategoriesOfClass:!enquiries!public! !
!

OS.COM.ICatInformation methodProtocol: #ICatInformation attributes: #(#readOnly) selectors: #(#EnumCategories:ppenumCategoryInfo: #EnumClassesOfCategories:rgcatidImpl:cRequired:rgcatidReq:ppenumClsid: #EnumImplCategoriesOfClass:ppenumCatid: #EnumReqCategoriesOfClass:ppenumCatid: #GetCategoryDesc:lcid:pszDesc: #IsClassOfCategories:cImplemented:rgcatidImpl:cRequired:rgcatidReq:)!

!OS.COM.ICatInformation class methodsFor!

clsid
	"Answer the <CLSID> of the standard system implementation of this interface."

	^CLSID fromString: '{0002E005-0000-0000-C000-000000000046}'!

controls
	"Answer a <collection> of <COMObjectRegistration>s describing all registered Active-X 
	controls registered on the host machine. Note that the collection is cached because it takes a 
	long while to generate."

	| catman |
	catman := self current.
	Controls isNil ifTrue: [ | ocxcatid |
		ocxcatid  := (GUID fromString: '{40FC6ED4-2438-11CF-A3DB-080036F12502}').
		Controls := ((catman classesInCategory: ocxcatid) 
					asSortedCollection: [:a :b | a description < b description]) asArray].
	^Controls

!

current
	"Answer the singleton instance of the receiver."

	CatMan isNull ifTrue: [
		Controls := nil.
		CatMan := super new].
	^CatMan!

defineFunctions
	"Declare the virtual function table for the COM interface 'COMCAT.ICatInformation'
		ICatInformation defineTemplate
	"

	self
		defineFunction: #EnumCategories:ppenumCategoryInfo:
			argumentTypes: 'dword void**';
		defineFunction: #GetCategoryDesc:lcid:pszDesc:
			argumentTypes: 'GUID* dword lpwstr*';
		defineFunction: #EnumClassesOfCategories:rgcatidImpl:cRequired:rgcatidReq:ppenumClsid:
			argumentTypes: 'dword GUID* dword GUID* void**';
		defineFunction: #IsClassOfCategories:cImplemented:rgcatidImpl:cRequired:rgcatidReq:
			argumentTypes: 'GUID* dword GUID* dword GUID*';
		defineFunction: #EnumImplCategoriesOfClass:ppenumCatid:
			argumentTypes: 'GUID* void**';
		defineFunction: #EnumReqCategoriesOfClass:ppenumCatid:
			argumentTypes: 'GUID* void**'
!

new
	"The receiver is a singleton."

	^self shouldNotImplement!

onPreStripImage
	"Private -  Assist in the image stripping process by clearning down any
	lazily initialized variables held by the receiver."

	self uninitialize!

uninitialize
	"Private -  Uninitialize the receiver as it is about to be removed from the image."

	CatMan := Controls := nil.! !

!OS.COM.ICatInformation class categoriesForMethods!
clsid!constants!public! !
controls!enquiries!public! !
current!instance creation!public! !
defineFunctions!initializing!public! !
new!instance creation!public! !
onPreStripImage!class hierarchy-removing!private! !
uninitialize!class hierarchy-removing!private! !
!

