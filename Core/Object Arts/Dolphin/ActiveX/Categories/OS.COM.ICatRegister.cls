"Filed out from Dolphin Smalltalk 7"!

OS.COM.IUnknown subclass: #'OS.COM.ICatRegister'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.COM.ICatRegister guid: (OS.COM.IID fromString: '{0002e012-0000-0000-c000-000000000046}')!
OS.COM.ICatRegister comment: '<ICatRegister> is a wrapper class for the COM interface ''COMCAT.ICatRegister'' generated from type information in the ''OLE Component Categories Library'' library. It contains methods to invoke the member functions exposed by that interface.

ICatRegister provides methods for registering and unregistering component category information in the Registry. This includes both the human-readable names of categories and the categories implemented/required by a given component or class.
'!
!OS.COM.ICatRegister categoriesForClass!COM Category Manager!COM-Interfaces! !
!OS.COM.ICatRegister methodsFor!

buildCatIdArray: catids
	"Private - Build an answer an <ExternalArray> of <GUID>s from the 
	<collection> of <GUID>s, catids.."

	^(StructureArray withAll: catids elementClass: GUID)
		beUnfinalizable;
		yourself!

registerCategories: categoryInfos
	"Register the specified <collection> of <CATEGORYINFO>, rgCategoryInfo."

	| rgCategoryInfo i |
	rgCategoryInfo := StructureArray length: categoryInfos size elementClass: CATEGORYINFO.
	i := 1.
	categoryInfos do: 
			[:cat |
			rgCategoryInfo at: i put: cat asParameter.
			i := i + 1].
	self RegisterCategories: categoryInfos size rgCategoryInfo: rgCategoryInfo!

RegisterCategories: cCategories rgCategoryInfo: rgCategoryInfo
	"Private - Invoke the RegisterCategories() method of the COM object wrapped by the receiver.

		HRESULT __stdcall RegisterCategories(
			[in] unsigned long cCategories,
			[in] CATEGORYINFO* rgCategoryInfo);
	"

	<virtual stdcall: hresult 4 dword CATEGORYINFO*>
	^self invalidCall: _failureCode!

registerCategory: catid description: desc
	"Register a single category with the <GUID>, catid, <readableString> description, desc, 
	for the default locale."

	self registerCategory: catid description: desc locale: Locale userDefault!

registerCategory: catid description: desc locale: locale
	"Register a single category with the <GUID>, catid, <readableString> description, desc, 
	and <Locale> (or <integer> locale id), locale."

	| cat |
	cat := CATEGORYINFO new.
	cat
		catid: catid;
		description: desc;
		locale: locale.
	self RegisterCategories: 1 rgCategoryInfo: cat!

RegisterClassImplCategories: rclsid cCategories: cCategories rgcatid: rgcatid
	"Private - Invoke the RegisterClassImplCategories() method of the COM object wrapped by the receiver.

		HRESULT __stdcall RegisterClassImplCategories(
			[in] GUID* rclsid,
			[in] unsigned long cCategories,
			[in] GUID* rgcatid);
	"

	<virtual stdcall: hresult 6 guid* dword guid*>
	^self invalidCall: _failureCode!

RegisterClassReqCategories: rclsid cCategories: cCategories rgcatid: rgcatid
	"Private - Invoke the RegisterClassReqCategories() method of the COM object wrapped by the receiver.

		HRESULT __stdcall RegisterClassReqCategories(
			[in] GUID* rclsid,
			[in] unsigned long cCategories,
			[in] GUID* rgcatid);
	"

	<virtual stdcall: hresult 8 guid* dword guid*>
	^self invalidCall: _failureCode!

registerCoClass: rclsid categories: catids
	"Register the COM component with <CLSID>, rclsid, as an implementor of the
	categories listed in the <collection> of <GUID>s, catids."

	| rgcatid |
	rgcatid := self buildCatIdArray: catids.
	self
		RegisterClassImplCategories: rclsid
		cCategories: rgcatid size
		rgcatid: rgcatid
!

registerCoClass: rclsid category: catid
	"Register the COM component with <CLSID>, rclsid, as an implementor of the
	category identified by the <GUID>, catid."

	self
		RegisterClassImplCategories: rclsid
		cCategories: 1
		rgcatid: catid
!

registerCoClass: rclsid requiredCategories: catids
	"Register the COM component with <CLSID>, rclsid, as requiring the 
	categories listed in the <collection> of <GUID>s, catids, from its clients."

	| rgcatid |
	rgcatid := self buildCatIdArray: catids.
	self
		RegisterClassReqCategories: rclsid
		cCategories: rgcatid size
		rgcatid: rgcatid
!

revokeCategories: catids
	"Revoke the registrations of the the categories identified by the 
	<collection> of <GUID>s, catids."

	| rgcatid |
	rgcatid := self buildCatIdArray: catids.
	self
		UnRegisterCategories: rgcatid size
		rgcatid: rgcatid
!

revokeCategory: catid
	"Unregister the category identified by the <GUID>, catid."

	self
		UnRegisterCategories: 1
		rgcatid: catid
!

revokeCoClass: rclsid categories: catids
	"Remove the registration of the the COM component with <CLSID>, rclsid, 
	from the categories listed in the <collection> of <GUID>s, catids."

	| rgcatid |
	rgcatid := self buildCatIdArray: catids.
	self
		UnRegisterClassImplCategories: rclsid
		cCategories: rgcatid size
		rgcatid: rgcatid
!

revokeCoClass: rclsid category: catid
	"Revoke the registration of the the COM component with <CLSID>, rclsid, 
	from the category with <GUID>, catid."

	self
		UnRegisterClassImplCategories: rclsid
		cCategories: 1
		rgcatid: catid
!

revokeCoClass: rclsid requiredCategories: catids
	"Revoke the registrations of the categories listed in the <collection> of <GUID>s, 
	catids, from the list categories that coclass with <CLSID>, rclsid, expects
	of its clients."

	| rgcatid |
	rgcatid := self buildCatIdArray: catids.
	self
		UnRegisterClassReqCategories: rclsid
		cCategories: rgcatid size
		rgcatid: rgcatid
!

UnRegisterCategories: cCategories rgcatid: rgcatid
	"Private - Invoke the UnRegisterCategories() method of the COM object wrapped by the receiver.

		HRESULT __stdcall UnRegisterCategories(
			[in] unsigned long cCategories,
			[in] GUID* rgcatid);
	"

	<virtual stdcall: hresult 5 dword guid*>
	^self invalidCall: _failureCode!

UnRegisterClassImplCategories: rclsid cCategories: cCategories rgcatid: rgcatid
	"Private - Invoke the UnRegisterClassImplCategories() method of the COM object wrapped by the receiver.

		HRESULT __stdcall UnRegisterClassImplCategories(
			[in] GUID* rclsid,
			[in] unsigned long cCategories,
			[in] GUID* rgcatid);
	"

	<virtual stdcall: hresult 7 guid* dword guid*>
	^self invalidCall: _failureCode!

UnRegisterClassReqCategories: rclsid cCategories: cCategories rgcatid: rgcatid
	"Private - Invoke the UnRegisterClassReqCategories() method of the COM object wrapped by the receiver.

		HRESULT __stdcall UnRegisterClassReqCategories(
			[in] GUID* rclsid,
			[in] unsigned long cCategories,
			[in] GUID* rgcatid);
	"

	<virtual stdcall: hresult 9 guid* dword guid*>
	^self invalidCall: _failureCode! !
!OS.COM.ICatRegister categoriesFor: #buildCatIdArray:!helpers!private! !
!OS.COM.ICatRegister categoriesFor: #registerCategories:!operations!public! !
!OS.COM.ICatRegister categoriesFor: #RegisterCategories:rgCategoryInfo:!**auto generated**!COM Interfaces-ICatRegister!private! !
!OS.COM.ICatRegister categoriesFor: #registerCategory:description:!operations!public! !
!OS.COM.ICatRegister categoriesFor: #registerCategory:description:locale:!operations!public! !
!OS.COM.ICatRegister categoriesFor: #RegisterClassImplCategories:cCategories:rgcatid:!**auto generated**!COM Interfaces-ICatRegister!private! !
!OS.COM.ICatRegister categoriesFor: #RegisterClassReqCategories:cCategories:rgcatid:!**auto generated**!COM Interfaces-ICatRegister!private! !
!OS.COM.ICatRegister categoriesFor: #registerCoClass:categories:!operations!public! !
!OS.COM.ICatRegister categoriesFor: #registerCoClass:category:!operations!public! !
!OS.COM.ICatRegister categoriesFor: #registerCoClass:requiredCategories:!operations!public! !
!OS.COM.ICatRegister categoriesFor: #revokeCategories:!operations!public! !
!OS.COM.ICatRegister categoriesFor: #revokeCategory:!operations!public! !
!OS.COM.ICatRegister categoriesFor: #revokeCoClass:categories:!operations!public! !
!OS.COM.ICatRegister categoriesFor: #revokeCoClass:category:!operations!public! !
!OS.COM.ICatRegister categoriesFor: #revokeCoClass:requiredCategories:!operations!public! !
!OS.COM.ICatRegister categoriesFor: #UnRegisterCategories:rgcatid:!**auto generated**!COM Interfaces-ICatRegister!private! !
!OS.COM.ICatRegister categoriesFor: #UnRegisterClassImplCategories:cCategories:rgcatid:!**auto generated**!COM Interfaces-ICatRegister!private! !
!OS.COM.ICatRegister categoriesFor: #UnRegisterClassReqCategories:cCategories:rgcatid:!**auto generated**!COM Interfaces-ICatRegister!private! !

OS.COM.ICatRegister methodProtocol: #ICatRegister attributes: #(#readOnly) selectors: #(#RegisterCategories:rgCategoryInfo: #RegisterClassImplCategories:cCategories:rgcatid: #RegisterClassReqCategories:cCategories:rgcatid: #UnRegisterCategories:rgcatid: #UnRegisterClassImplCategories:cCategories:rgcatid: #UnRegisterClassReqCategories:cCategories:rgcatid:)!

!OS.COM.ICatRegister class methodsFor!

current
	"Answer the singleton instance of the receiver."

	^ICatInformation current queryInterface: self!

defineFunctions
	"Declare the virtual function table for the COM interface 'COMCAT.ICatRegister'
		ICatRegister defineTemplate
	"

	self
		defineFunction: #RegisterCategories:rgCategoryInfo:
			argumentTypes: 'dword CATEGORYINFO*';
		defineFunction: #UnRegisterCategories:rgcatid:
			argumentTypes: 'dword GUID*';
		defineFunction: #RegisterClassImplCategories:cCategories:rgcatid:
			argumentTypes: 'GUID* dword GUID*';
		defineFunction: #UnRegisterClassImplCategories:cCategories:rgcatid:
			argumentTypes: 'GUID* dword GUID*';
		defineFunction: #RegisterClassReqCategories:cCategories:rgcatid:
			argumentTypes: 'GUID* dword GUID*';
		defineFunction: #UnRegisterClassReqCategories:cCategories:rgcatid:
			argumentTypes: 'GUID* dword GUID*'
!

example1
	"Example of usage of ICatRegister and ICatInformation.
	Evaluate the lines one-by-one to display the results."

	| reg catid clsid info |
	reg := ICatRegister current.
	catid := GUID newUnique.
	reg registerCategory: catid description: 'Powered by Dolphin'.	"Create the category"
	clsid := CLSID newUnique.	"A dummy coclass"
	reg registerCoClass: clsid category: catid.	"Register it"
	info := ICatInformation current.
	info descriptionOfCategory: catid.	"Query back the name of the category"
	info classesInCategory: catid.	"Enumerate the coclasses - contains only the dummy"
	reg revokeCoClass: clsid category: catid.
	info classesInCategory: catid.	"Enumerate again - should be empty now"
	reg revokeCategory: catid.	"Remove the category"
	info descriptionOfCategory: catid	"Expect an error"!

new
	"The receiver is a singleton."

	^self shouldNotImplement! !
!OS.COM.ICatRegister class categoriesFor: #current!instance creation!public! !
!OS.COM.ICatRegister class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!OS.COM.ICatRegister class categoriesFor: #example1!examples!must strip!public! !
!OS.COM.ICatRegister class categoriesFor: #new!instance creation!public! !

