"Filed out from Dolphin Smalltalk X6"!

IDispatch subclass: #ISpeechObjectTokenCategory
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SpeechLibConstants'
	classInstanceVariableNames: ''!
ISpeechObjectTokenCategory guid: (IID fromString: '{CA7EAC50-2D01-4145-86D4-5AE7D70F4469}')!
ISpeechObjectTokenCategory comment: '<ISpeechObjectTokenCategory> is a wrapper class for the COM interface ''SpeechLib.ISpeechObjectTokenCategory'' generated from type information in the ''Microsoft Speech Object Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"ISpeechObjectTokenCategory Interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(CA7EAC50-2D01-4145-86D4-5AE7D70F4469), 
	helpstring("ISpeechObjectTokenCategory Interface"), 
	dual
]
interface ISpeechObjectTokenCategory : IDispatch {
	[id(0x00000001), propget, helpstring("Id")]
	HRESULT __stdcall Id(
		[out, retval] BSTR* Id);
	[id(0x00000002), propput, helpstring("Default")]
	HRESULT __stdcall Default(
		[in] BSTR TokenId);
	[id(0x00000002), propget, helpstring("Default")]
	HRESULT __stdcall Default(
		[out, retval] BSTR* TokenId);
	[id(0x00000003), helpstring("SetId")]
	HRESULT __stdcall SetId(
		[in] BSTR Id,
		[in, defaultvalue(false)] VARIANT_BOOL CreateIfNotExist);
	[id(0x00000004), hidden, helpstring("GetDataKey")]
	HRESULT __stdcall GetDataKey(
		[in, defaultvalue(0)] SpeechDataKeyLocation Location,
		[out, retval] ISpeechDataKey** DataKey);
	[id(0x00000005), helpstring("EnumerateTokens")]
	HRESULT __stdcall EnumerateTokens(
		[in, defaultvalue("")] BSTR RequiredAttributes,
		[in, defaultvalue("")] BSTR OptionalAttributes,
		[out, retval] ISpeechObjectTokens** Tokens);
};
'!
!ISpeechObjectTokenCategory categoriesForClass!COM-Interfaces!SpeechLib-Interfaces! !
!ISpeechObjectTokenCategory methodsFor!

default
	"Answer the <bstr> value of the 'Default' property of the receiver.
	Helpstring: 'Default'"

	| answer |
	answer := BSTR new.
	self get_Default: answer.
	^answer asObject
!

default: tokenId
	"Set the 'Default' property of the receiver to the <bstr> value of the argument.
	Helpstring: 'Default'"

	self put_Default: tokenId
!

enumerateTokens
	"Answer the <ISpeechObjectTokens> result of invoking the EnumerateTokens() method of the COM object.
	Default values are passed for all optional parameters."

	^self
		 enumerateTokens: ''
		 optionalAttributes: ''!

enumerateTokens: requiredAttributes optionalAttributes: optionalAttributes
	"Answer the <ISpeechObjectTokens> result of invoking the EnumerateTokens() method of the COM object.
	Helpstring: 'EnumerateTokens'"

	| answer |
	answer := ISpeechObjectTokens newPointer.
	self
		EnumerateTokens: requiredAttributes
		OptionalAttributes: optionalAttributes
		Tokens: answer.
	^answer asObject
!

EnumerateTokens: requiredAttributes OptionalAttributes: optionalAttributes Tokens: tokens
	"Private - Invoke the EnumerateTokens() method of the COM object.
	Helpstring: 'EnumerateTokens'

		HRESULT __stdcall EnumerateTokens(
			[in, defaultvalue("")] BSTR RequiredAttributes,
			[in, defaultvalue("")] BSTR OptionalAttributes,
			[out, retval] ISpeechObjectTokens** Tokens);"

	<virtual stdcall: hresult 13 bstr bstr ISpeechObjectTokens**>
	^self invalidCall
!

get_Default: tokenId
	"Private - Get the value of the 'Default' property of the receiver.

		HRESULT __stdcall Default(
			[out, retval] BSTR* TokenId);"

	<virtual stdcall: hresult 10 bstr*>
	^self invalidCall
!

get_Id: id
	"Private - Get the value of the 'Id' property of the receiver.

		HRESULT __stdcall Id(
			[out, retval] BSTR* Id);"

	<virtual stdcall: hresult 8 bstr*>
	^self invalidCall
!

getDataKey
	"Answer the <ISpeechDataKey> result of invoking the GetDataKey() method of the COM object.
	Default values are passed for all optional parameters."

	^self getDataKey: 0!

getDataKey: location
	"Answer the <ISpeechDataKey> result of invoking the GetDataKey() method of the COM object.
	Helpstring: 'GetDataKey'"

	| answer |
	answer := ISpeechDataKey newPointer.
	self
		GetDataKey: location
		DataKey: answer.
	^answer asObject
!

GetDataKey: location DataKey: dataKey
	"Private - Invoke the GetDataKey() method of the COM object.
	Helpstring: 'GetDataKey'

		HRESULT __stdcall GetDataKey(
			[in, defaultvalue(0)] SpeechDataKeyLocation Location,
			[out, retval] ISpeechDataKey** DataKey);"

	<virtual stdcall: hresult 12 sdword ISpeechDataKey**>
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

put_Default: tokenId
	"Private - Set the value of the 'Default' property of the object wrapped by the 
	 receiver to the <bstr> argument, tokenId.

		HRESULT __stdcall Default(
			[in] BSTR TokenId);"

	<virtual stdcall: hresult 9 bstr>
	^self invalidCall
!

setId: id
	"Invoke the SetId() method of the COM object.
	Default values are passed for all optional parameters."

	^self
		 setId: id
		 createIfNotExist: false!

setId: id createIfNotExist: createIfNotExist
	"Invoke the SetId() method of the COM object.
	Helpstring: 'SetId'"

	^self
		SetId: id
		CreateIfNotExist: createIfNotExist
!

SetId: id CreateIfNotExist: createIfNotExist
	"Private - Invoke the SetId() method of the COM object.
	Helpstring: 'SetId'

		HRESULT __stdcall SetId(
			[in] BSTR Id,
			[in, defaultvalue(false)] VARIANT_BOOL CreateIfNotExist);"

	<virtual stdcall: hresult 11 bstr varbool>
	^self invalidCall
! !
!ISpeechObjectTokenCategory categoriesFor: #default!**auto generated**!properties!public! !
!ISpeechObjectTokenCategory categoriesFor: #default:!**auto generated**!properties!public! !
!ISpeechObjectTokenCategory categoriesFor: #enumerateTokens!**auto generated**!methods!public! !
!ISpeechObjectTokenCategory categoriesFor: #enumerateTokens:optionalAttributes:!**auto generated**!methods!public! !
!ISpeechObjectTokenCategory categoriesFor: #EnumerateTokens:OptionalAttributes:Tokens:!**auto generated**!COM Interfaces-ISpeechObjectTokenCategory!private! !
!ISpeechObjectTokenCategory categoriesFor: #get_Default:!**auto generated**!COM Interfaces-ISpeechObjectTokenCategory!private! !
!ISpeechObjectTokenCategory categoriesFor: #get_Id:!**auto generated**!COM Interfaces-ISpeechObjectTokenCategory!private! !
!ISpeechObjectTokenCategory categoriesFor: #getDataKey!**auto generated**!methods!public! !
!ISpeechObjectTokenCategory categoriesFor: #getDataKey:!**auto generated**!methods!public! !
!ISpeechObjectTokenCategory categoriesFor: #GetDataKey:DataKey:!**auto generated**!COM Interfaces-ISpeechObjectTokenCategory!private! !
!ISpeechObjectTokenCategory categoriesFor: #id!**auto generated**!properties!public! !
!ISpeechObjectTokenCategory categoriesFor: #put_Default:!**auto generated**!COM Interfaces-ISpeechObjectTokenCategory!private! !
!ISpeechObjectTokenCategory categoriesFor: #setId:!**auto generated**!methods!public! !
!ISpeechObjectTokenCategory categoriesFor: #setId:createIfNotExist:!**auto generated**!methods!public! !
!ISpeechObjectTokenCategory categoriesFor: #SetId:CreateIfNotExist:!**auto generated**!COM Interfaces-ISpeechObjectTokenCategory!private! !

!ISpeechObjectTokenCategory class methodsFor!

clsid
	"Private - Answer the CLSID of the coclass (SpObjectTokenCategory) for which the receiver is the default interface."

	^CLSID fromString: '{A910187F-0C7A-45AC-92CC-59EDAFB77B53}'
!

defineFunctions
	"Declare the virtual function table for the COM interface 'SpeechLib.ISpeechObjectTokenCategory'
		ISpeechObjectTokenCategory defineTemplate"

	self
		defineFunction: #get_Id:
			argumentTypes: 'bstr*';
		defineFunction: #put_Default:
			argumentTypes: 'bstr';
		defineFunction: #get_Default:
			argumentTypes: 'bstr*';
		defineFunction: #SetId:CreateIfNotExist:
			argumentTypes: 'bstr varbool';
		defineFunction: #GetDataKey:DataKey:
			argumentTypes: 'sdword ISpeechDataKey**';
		defineFunction: #EnumerateTokens:OptionalAttributes:Tokens:
			argumentTypes: 'bstr bstr ISpeechObjectTokens**'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		ISpeechObjectTokenCategory initializeTypeLib"

	typeLib := SpeechLib! !
!ISpeechObjectTokenCategory class categoriesFor: #clsid!**auto generated**!constants!private! !
!ISpeechObjectTokenCategory class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!ISpeechObjectTokenCategory class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

