"Filed out from Dolphin Smalltalk 7"!

IDispatch subclass: #ISpeechObjectToken
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SpeechLibConstants'
	classInstanceVariableNames: ''!
ISpeechObjectToken guid: (IID fromString: '{C74A3ADC-B727-4500-A84A-B526721C8B8C}')!
ISpeechObjectToken comment: '<ISpeechObjectToken> is a wrapper class for the COM interface ''SpeechLib.ISpeechObjectToken'' generated from type information in the ''Microsoft Speech Object Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"ISpeechObjectToken Interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(C74A3ADC-B727-4500-A84A-B526721C8B8C), 
	helpstring("ISpeechObjectToken Interface"), 
	dual
]
interface ISpeechObjectToken : IDispatch {
	[id(0x00000001), propget, helpstring("Id")]
	HRESULT __stdcall Id(
		[out, retval] BSTR* ObjectId);
	[id(0x00000002), hidden, propget, helpstring("DataKey")]
	HRESULT __stdcall DataKey(
		[out, retval] ISpeechDataKey** DataKey);
	[id(0x00000003), propget, helpstring("Category")]
	HRESULT __stdcall Category(
		[out, retval] ISpeechObjectTokenCategory** Category);
	[id(0x00000004), helpstring("GetDescription")]
	HRESULT __stdcall GetDescription(
		[in, defaultvalue(0)] long Locale,
		[out, retval] BSTR* Description);
	[id(0x00000005), hidden, helpstring("SetId")]
	HRESULT __stdcall SetId(
		[in] BSTR Id,
		[in, defaultvalue("")] BSTR CategoryID,
		[in, defaultvalue(false)] VARIANT_BOOL CreateIfNotExist);
	[id(0x00000006), helpstring("GetAttribute")]
	HRESULT __stdcall GetAttribute(
		[in] BSTR AttributeName,
		[out, retval] BSTR* AttributeValue);
	[id(0x00000007), helpstring("CreateInstance")]
	HRESULT __stdcall CreateInstance(
		[in, defaultvalue(an IUnknown(an ExternalAddress(NULL)))] IUnknown* pUnkOuter,
		[in, defaultvalue(23)] SpeechTokenContext ClsContext,
		[out, retval] IUnknown** Object);
	[id(0x00000008), hidden, helpstring("Remove")]
	HRESULT __stdcall Remove(
		[in] BSTR ObjectStorageCLSID);
	[id(0x00000009), hidden, helpstring("GetStorageFileName")]
	HRESULT __stdcall GetStorageFileName(
		[in] BSTR ObjectStorageCLSID,
		[in] BSTR KeyName,
		[in] BSTR FileName,
		[in] SpeechTokenShellFolder Folder,
		[out, retval] BSTR* FilePath);
	[id(0x0000000a), hidden, helpstring("RemoveStorageFileName")]
	HRESULT __stdcall RemoveStorageFileName(
		[in] BSTR ObjectStorageCLSID,
		[in] BSTR KeyName,
		[in] VARIANT_BOOL DeleteFile);
	[id(0x0000000b), hidden, helpstring("IsUISupported")]
	HRESULT __stdcall IsUISupported(
		[in] BSTR TypeOfUI,
		[in, defaultvalue("")] VARIANT* ExtraData,
		[in, defaultvalue(an IUnknown(an ExternalAddress(NULL)))] IUnknown* Object,
		[out, retval] VARIANT_BOOL* Supported);
	[id(0x0000000c), hidden, helpstring("DisplayUI")]
	HRESULT __stdcall DisplayUI(
		[in] long hWnd,
		[in] BSTR Title,
		[in] BSTR TypeOfUI,
		[in, defaultvalue("")] VARIANT* ExtraData,
		[in, defaultvalue(an IUnknown(an ExternalAddress(NULL)))] IUnknown* Object);
	[id(0x0000000d), helpstring("MatchesAttributes")]
	HRESULT __stdcall MatchesAttributes(
		[in] BSTR Attributes,
		[out, retval] VARIANT_BOOL* Matches);
};
'!
!ISpeechObjectToken categoriesForClass!COM-Interfaces!SpeechLib-Interfaces! !
!ISpeechObjectToken methodsFor!

category
	"Answer the <ISpeechObjectTokenCategory> value of the 'Category' property of the receiver.
	Helpstring: 'Category'"

	| answer |
	answer := ISpeechObjectTokenCategory newPointer.
	self get_Category: answer.
	^answer asObject
!

createInstance: pUnkOuter clsContext: clsContext
	"Answer the <IUnknown> result of invoking the CreateInstance() method of the COM object.
	Helpstring: 'CreateInstance'"

	| answer |
	answer := IUnknown newPointer.
	self
		CreateInstance: pUnkOuter
		ClsContext: clsContext
		Object: answer.
	^answer asObject
!

CreateInstance: pUnkOuter ClsContext: clsContext Object: object
	"Private - Invoke the CreateInstance() method of the COM object.
	Helpstring: 'CreateInstance'

		HRESULT __stdcall CreateInstance(
			[in, defaultvalue(an IUnknown(an ExternalAddress(NULL)))] IUnknown* pUnkOuter,
			[in, defaultvalue(23)] SpeechTokenContext ClsContext,
			[out, retval] IUnknown** Object);"

	<virtual stdcall: hresult 14 IUnknown* sdword IUnknown**>
	^self invalidCall
!

dataKey
	"Answer the <ISpeechDataKey> value of the 'DataKey' property of the receiver.
	Helpstring: 'DataKey'"

	| answer |
	answer := ISpeechDataKey newPointer.
	self get_DataKey: answer.
	^answer asObject
!

displayUI: hWnd title: title typeOfUI: typeOfUI extraData: extraData object: object
	"Invoke the DisplayUI() method of the COM object.
	Helpstring: 'DisplayUI'"

	^self
		DisplayUI: hWnd
		Title: title
		TypeOfUI: typeOfUI
		ExtraData: extraData asVariant
		Object: object
!

DisplayUI: hWnd Title: title TypeOfUI: typeOfUI ExtraData: extraData Object: object
	"Private - Invoke the DisplayUI() method of the COM object.
	Helpstring: 'DisplayUI'

		HRESULT __stdcall DisplayUI(
			[in] long hWnd,
			[in] BSTR Title,
			[in] BSTR TypeOfUI,
			[in, defaultvalue("")] VARIANT* ExtraData,
			[in, defaultvalue(an IUnknown(an ExternalAddress(NULL)))] IUnknown* Object);"

	<virtual stdcall: hresult 19 sdword bstr bstr variant* IUnknown*>
	^self invalidCall
!

get_Category: category
	"Private - Get the value of the 'Category' property of the receiver.

		HRESULT __stdcall Category(
			[out, retval] ISpeechObjectTokenCategory** Category);"

	<virtual stdcall: hresult 10 ISpeechObjectTokenCategory**>
	^self invalidCall
!

get_DataKey: dataKey
	"Private - Get the value of the 'DataKey' property of the receiver.

		HRESULT __stdcall DataKey(
			[out, retval] ISpeechDataKey** DataKey);"

	<virtual stdcall: hresult 9 ISpeechDataKey**>
	^self invalidCall
!

get_Id: objectId
	"Private - Get the value of the 'Id' property of the receiver.

		HRESULT __stdcall Id(
			[out, retval] BSTR* ObjectId);"

	<virtual stdcall: hresult 8 bstr*>
	^self invalidCall
!

getAttribute: attributeName
	"Answer the <BSTR> result of invoking the GetAttribute() method of the COM object.
	Helpstring: 'GetAttribute'"

	| answer |
	answer := BSTR new.
	self
		GetAttribute: attributeName
		AttributeValue: answer.
	^answer asObject
!

GetAttribute: attributeName AttributeValue: attributeValue
	"Private - Invoke the GetAttribute() method of the COM object.
	Helpstring: 'GetAttribute'

		HRESULT __stdcall GetAttribute(
			[in] BSTR AttributeName,
			[out, retval] BSTR* AttributeValue);"

	<virtual stdcall: hresult 13 bstr bstr*>
	^self invalidCall
!

getDescription
	"Answer the <BSTR> result of invoking the GetDescription() method of the COM object.
	Default values are passed for all optional parameters."

	^self getDescription: 0!

getDescription: locale
	"Answer the <BSTR> result of invoking the GetDescription() method of the COM object.
	Helpstring: 'GetDescription'"

	| answer |
	answer := BSTR new.
	self
		GetDescription: locale
		Description: answer.
	^answer asObject
!

GetDescription: locale Description: description
	"Private - Invoke the GetDescription() method of the COM object.
	Helpstring: 'GetDescription'

		HRESULT __stdcall GetDescription(
			[in, defaultvalue(0)] long Locale,
			[out, retval] BSTR* Description);"

	<virtual stdcall: hresult 11 sdword bstr*>
	^self invalidCall
!

getStorageFileName: objectStorageCLSID keyName: keyName fileName: fileName folder: folder
	"Answer the <BSTR> result of invoking the GetStorageFileName() method of the COM object.
	Helpstring: 'GetStorageFileName'"

	| answer |
	answer := BSTR new.
	self
		GetStorageFileName: objectStorageCLSID
		KeyName: keyName
		FileName: fileName
		Folder: folder
		FilePath: answer.
	^answer asObject
!

GetStorageFileName: objectStorageCLSID KeyName: keyName FileName: fileName Folder: folder FilePath: filePath
	"Private - Invoke the GetStorageFileName() method of the COM object.
	Helpstring: 'GetStorageFileName'

		HRESULT __stdcall GetStorageFileName(
			[in] BSTR ObjectStorageCLSID,
			[in] BSTR KeyName,
			[in] BSTR FileName,
			[in] SpeechTokenShellFolder Folder,
			[out, retval] BSTR* FilePath);"

	<virtual stdcall: hresult 16 bstr bstr bstr sdword bstr*>
	^self invalidCall
!

id
	"Answer the <bstr> value of the 'Id' property of the receiver.
	Helpstring: 'Id'"

	| answer |
	answer := BSTR new.
	self get_Id: answer.
	^answer asObject
!

isUISupported: typeOfUI extraData: extraData object: object
	"Answer the <VARIANT_BOOL> result of invoking the IsUISupported() method of the COM object.
	Helpstring: 'IsUISupported'"

	| answer |
	answer := (VARIANT_BOOL new).
	self
		IsUISupported: typeOfUI
		ExtraData: extraData asVariant
		Object: object
		Supported: answer.
	^answer asObject
!

IsUISupported: typeOfUI ExtraData: extraData Object: object Supported: supported
	"Private - Invoke the IsUISupported() method of the COM object.
	Helpstring: 'IsUISupported'

		HRESULT __stdcall IsUISupported(
			[in] BSTR TypeOfUI,
			[in, defaultvalue("")] VARIANT* ExtraData,
			[in, defaultvalue(an IUnknown(an ExternalAddress(NULL)))] IUnknown* Object,
			[out, retval] VARIANT_BOOL* Supported);"

	<virtual stdcall: hresult 18 bstr variant* IUnknown* varbool*>
	^self invalidCall
!

matchesAttributes: attributes
	"Answer the <VARIANT_BOOL> result of invoking the MatchesAttributes() method of the COM object.
	Helpstring: 'MatchesAttributes'"

	| answer |
	answer := (VARIANT_BOOL new).
	self
		MatchesAttributes: attributes
		Matches: answer.
	^answer asObject
!

MatchesAttributes: attributes Matches: matches
	"Private - Invoke the MatchesAttributes() method of the COM object.
	Helpstring: 'MatchesAttributes'

		HRESULT __stdcall MatchesAttributes(
			[in] BSTR Attributes,
			[out, retval] VARIANT_BOOL* Matches);"

	<virtual stdcall: hresult 20 bstr varbool*>
	^self invalidCall
!

remove: objectStorageCLSID
	"Invoke the Remove() method of the COM object.
	Helpstring: 'Remove'"

	^self Remove: objectStorageCLSID
!

Remove: objectStorageCLSID
	"Private - Invoke the Remove() method of the COM object.
	Helpstring: 'Remove'

		HRESULT __stdcall Remove(
			[in] BSTR ObjectStorageCLSID);"

	<virtual stdcall: hresult 15 bstr>
	^self invalidCall
!

removeStorageFileName: objectStorageCLSID keyName: keyName deleteFile: deleteFile
	"Invoke the RemoveStorageFileName() method of the COM object.
	Helpstring: 'RemoveStorageFileName'"

	^self
		RemoveStorageFileName: objectStorageCLSID
		KeyName: keyName
		DeleteFile: deleteFile
!

RemoveStorageFileName: objectStorageCLSID KeyName: keyName DeleteFile: deleteFile
	"Private - Invoke the RemoveStorageFileName() method of the COM object.
	Helpstring: 'RemoveStorageFileName'

		HRESULT __stdcall RemoveStorageFileName(
			[in] BSTR ObjectStorageCLSID,
			[in] BSTR KeyName,
			[in] VARIANT_BOOL DeleteFile);"

	<virtual stdcall: hresult 17 bstr bstr varbool>
	^self invalidCall
!

setId: id
	"Invoke the SetId() method of the COM object.
	Default values are passed for all optional parameters."

	^self
		 setId: id
		 categoryID: ''
		 createIfNotExist: false!

setId: id categoryID: categoryID createIfNotExist: createIfNotExist
	"Invoke the SetId() method of the COM object.
	Helpstring: 'SetId'"

	^self
		SetId: id
		CategoryID: categoryID
		CreateIfNotExist: createIfNotExist
!

SetId: id CategoryID: categoryID CreateIfNotExist: createIfNotExist
	"Private - Invoke the SetId() method of the COM object.
	Helpstring: 'SetId'

		HRESULT __stdcall SetId(
			[in] BSTR Id,
			[in, defaultvalue("")] BSTR CategoryID,
			[in, defaultvalue(false)] VARIANT_BOOL CreateIfNotExist);"

	<virtual stdcall: hresult 12 bstr bstr varbool>
	^self invalidCall
! !
!ISpeechObjectToken categoriesFor: #category!**auto generated**!properties!public! !
!ISpeechObjectToken categoriesFor: #createInstance:clsContext:!**auto generated**!methods!public! !
!ISpeechObjectToken categoriesFor: #CreateInstance:ClsContext:Object:!**auto generated**!COM Interfaces-ISpeechObjectToken!private! !
!ISpeechObjectToken categoriesFor: #dataKey!**auto generated**!properties!public! !
!ISpeechObjectToken categoriesFor: #displayUI:title:typeOfUI:extraData:object:!**auto generated**!methods!public! !
!ISpeechObjectToken categoriesFor: #DisplayUI:Title:TypeOfUI:ExtraData:Object:!**auto generated**!COM Interfaces-ISpeechObjectToken!private! !
!ISpeechObjectToken categoriesFor: #get_Category:!**auto generated**!COM Interfaces-ISpeechObjectToken!private! !
!ISpeechObjectToken categoriesFor: #get_DataKey:!**auto generated**!COM Interfaces-ISpeechObjectToken!private! !
!ISpeechObjectToken categoriesFor: #get_Id:!**auto generated**!COM Interfaces-ISpeechObjectToken!private! !
!ISpeechObjectToken categoriesFor: #getAttribute:!**auto generated**!methods!public! !
!ISpeechObjectToken categoriesFor: #GetAttribute:AttributeValue:!**auto generated**!COM Interfaces-ISpeechObjectToken!private! !
!ISpeechObjectToken categoriesFor: #getDescription!**auto generated**!methods!public! !
!ISpeechObjectToken categoriesFor: #getDescription:!**auto generated**!methods!public! !
!ISpeechObjectToken categoriesFor: #GetDescription:Description:!**auto generated**!COM Interfaces-ISpeechObjectToken!private! !
!ISpeechObjectToken categoriesFor: #getStorageFileName:keyName:fileName:folder:!**auto generated**!methods!public! !
!ISpeechObjectToken categoriesFor: #GetStorageFileName:KeyName:FileName:Folder:FilePath:!**auto generated**!COM Interfaces-ISpeechObjectToken!private! !
!ISpeechObjectToken categoriesFor: #id!**auto generated**!properties!public! !
!ISpeechObjectToken categoriesFor: #isUISupported:extraData:object:!**auto generated**!methods!public! !
!ISpeechObjectToken categoriesFor: #IsUISupported:ExtraData:Object:Supported:!**auto generated**!COM Interfaces-ISpeechObjectToken!private! !
!ISpeechObjectToken categoriesFor: #matchesAttributes:!**auto generated**!methods!public! !
!ISpeechObjectToken categoriesFor: #MatchesAttributes:Matches:!**auto generated**!COM Interfaces-ISpeechObjectToken!private! !
!ISpeechObjectToken categoriesFor: #remove:!**auto generated**!methods!public! !
!ISpeechObjectToken categoriesFor: #Remove:!**auto generated**!COM Interfaces-ISpeechObjectToken!private! !
!ISpeechObjectToken categoriesFor: #removeStorageFileName:keyName:deleteFile:!**auto generated**!methods!public! !
!ISpeechObjectToken categoriesFor: #RemoveStorageFileName:KeyName:DeleteFile:!**auto generated**!COM Interfaces-ISpeechObjectToken!private! !
!ISpeechObjectToken categoriesFor: #setId:!**auto generated**!methods!public! !
!ISpeechObjectToken categoriesFor: #setId:categoryID:createIfNotExist:!**auto generated**!methods!public! !
!ISpeechObjectToken categoriesFor: #SetId:CategoryID:CreateIfNotExist:!**auto generated**!COM Interfaces-ISpeechObjectToken!private! !

!ISpeechObjectToken class methodsFor!

clsid
	"Private - Answer the CLSID of the coclass (SpObjectToken) for which the receiver is the default interface."

	^CLSID fromString: '{EF411752-3736-4CB4-9C8C-8EF4CCB58EFE}'
!

defineFunctions
	"Declare the virtual function table for the COM interface 'SpeechLib.ISpeechObjectToken'
		ISpeechObjectToken defineTemplate"

	self
		defineFunction: #get_Id:
			argumentTypes: 'bstr*';
		defineFunction: #get_DataKey:
			argumentTypes: 'ISpeechDataKey**';
		defineFunction: #get_Category:
			argumentTypes: 'ISpeechObjectTokenCategory**';
		defineFunction: #GetDescription:Description:
			argumentTypes: 'sdword bstr*';
		defineFunction: #SetId:CategoryID:CreateIfNotExist:
			argumentTypes: 'bstr bstr varbool';
		defineFunction: #GetAttribute:AttributeValue:
			argumentTypes: 'bstr bstr*';
		defineFunction: #CreateInstance:ClsContext:Object:
			argumentTypes: 'IUnknown* sdword IUnknown**';
		defineFunction: #Remove:
			argumentTypes: 'bstr';
		defineFunction: #GetStorageFileName:KeyName:FileName:Folder:FilePath:
			argumentTypes: 'bstr bstr bstr sdword bstr*';
		defineFunction: #RemoveStorageFileName:KeyName:DeleteFile:
			argumentTypes: 'bstr bstr varbool';
		defineFunction: #IsUISupported:ExtraData:Object:Supported:
			argumentTypes: 'bstr variant* IUnknown* varbool*';
		defineFunction: #DisplayUI:Title:TypeOfUI:ExtraData:Object:
			argumentTypes: 'sdword bstr bstr variant* IUnknown*';
		defineFunction: #MatchesAttributes:Matches:
			argumentTypes: 'bstr varbool*'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		ISpeechObjectToken initializeTypeLib"

	typeLib := SpeechLib! !
!ISpeechObjectToken class categoriesFor: #clsid!**auto generated**!constants!private! !
!ISpeechObjectToken class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!ISpeechObjectToken class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

