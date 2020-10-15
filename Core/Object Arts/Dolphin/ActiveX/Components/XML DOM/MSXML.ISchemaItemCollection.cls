"Filed out from Dolphin Smalltalk 7"!

OS.COM.IDispatch subclass: #'MSXML.ISchemaItemCollection'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
MSXML.ISchemaItemCollection guid: (OS.COM.IID fromString: '{50ea08b2-dd1b-4664-9a50-c2f40f4bd79a}')!
MSXML.ISchemaItemCollection comment: '<ISchemaItemCollection> is a wrapper class for the COM interface ''MSXML2.ISchemaItemCollection'' generated from type information in the ''Microsoft XML, v4.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"XML Schema Item Collection"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(50EA08B2-DD1B-4664-9A50-C2F40F4BD79A), 
	helpstring("XML Schema Item Collection"), 
	dual, 
	nonextensible
]
interface ISchemaItemCollection : IDispatch
 {
	[id(0000000000), propget]
	HRESULT __stdcall item(
		[in]long index,
		[out, retval]ISchemaItem** item);
	[id(0x0000058f)]
	HRESULT __stdcall itemByName(
		[in]BSTR name,
		[out, retval]ISchemaItem** item);
	[id(0x00000590)]
	HRESULT __stdcall itemByQName(
		[in]BSTR name,
		[in]BSTR namespaceURI,
		[out, retval]ISchemaItem** item);
	[id(0x000005a7), propget]
	HRESULT __stdcall length(
		[out, retval]long* length);
	[id(0xfffffffc), hidden, propget, restricted]
	HRESULT __stdcall _newEnum(
		[out, retval]IUnknown** ppUnk);
};
'!
!MSXML.ISchemaItemCollection categoriesForClass!COM-Interfaces!MSXML2-Interfaces! !
!MSXML.ISchemaItemCollection methodsFor!

_newEnum
	"Answer the <IUnknown> value of the '_newEnum' property of the receiver."

	| answer |
	answer := IUnknown newPointer.
	self get__newEnum: answer.
	^answer asObject!

get__newEnum: ppUnk
	"Private - Get the value of the '_newEnum' property of the receiver.

		HRESULT __stdcall _newEnum(
			[out, retval]IUnknown** ppUnk);"

	<virtual stdcall: hresult 12 IUnknown**>
	^self invalidCall: _failureCode!

get_item: index item: item
	"Private - Get the value of the 'item' property of the receiver.

		HRESULT __stdcall item(
			[in]long index,
			[out, retval]ISchemaItem** item);"

	<virtual stdcall: hresult 8 sdword ISchemaItem**>
	^self invalidCall: _failureCode!

get_length: length
	"Private - Get the value of the 'length' property of the receiver.

		HRESULT __stdcall length(
			[out, retval]long* length);"

	<virtual stdcall: hresult 11 sdword*>
	^self invalidCall: _failureCode!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^false!

isVBCollection
	"Answer whether the receiver is a VB style collection."

	^true!

item: index
	"Answer the <ISchemaItem> value of the 'item' property of the receiver."

	| answer |
	answer := ISchemaItem newPointer.
	self get_item: index item: answer.
	^answer asObject!

itemByName: name
	"Answer the <ISchemaItem> result of invoking the itemByName() method of the COM object."

	| answer |
	answer := ISchemaItem newPointer.
	self ItemByName: name item: answer.
	^answer asObject!

ItemByName: name item: item
	"Private - Invoke the itemByName() method of the COM object.

		HRESULT __stdcall itemByName(
			[in]BSTR name,
			[out, retval]ISchemaItem** item);"

	<virtual stdcall: hresult 9 bstr ISchemaItem**>
	^self invalidCall: _failureCode!

itemByQName: name namespaceURI: namespaceURI
	"Answer the <ISchemaItem> result of invoking the itemByQName() method of the COM object."

	| answer |
	answer := ISchemaItem newPointer.
	self
		ItemByQName: name
		namespaceURI: namespaceURI
		item: answer.
	^answer asObject!

ItemByQName: name namespaceURI: namespaceURI item: item
	"Private - Invoke the itemByQName() method of the COM object.

		HRESULT __stdcall itemByQName(
			[in]BSTR name,
			[in]BSTR namespaceURI,
			[out, retval]ISchemaItem** item);"

	<virtual stdcall: hresult 10 bstr bstr ISchemaItem**>
	^self invalidCall: _failureCode!

length
	"Answer the <sdword> value of the 'length' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_length: answer.
	^answer asObject! !
!MSXML.ISchemaItemCollection categoriesFor: #_newEnum!**auto generated**!properties!public! !
!MSXML.ISchemaItemCollection categoriesFor: #get__newEnum:!**auto generated**!COM Interfaces-ISchemaItemCollection!private! !
!MSXML.ISchemaItemCollection categoriesFor: #get_item:item:!**auto generated**!COM Interfaces-ISchemaItemCollection!private! !
!MSXML.ISchemaItemCollection categoriesFor: #get_length:!**auto generated**!COM Interfaces-ISchemaItemCollection!private! !
!MSXML.ISchemaItemCollection categoriesFor: #isExtensible!**auto generated**!public!testing! !
!MSXML.ISchemaItemCollection categoriesFor: #isVBCollection!**auto generated**!public!testing! !
!MSXML.ISchemaItemCollection categoriesFor: #item:!**auto generated**!properties!public! !
!MSXML.ISchemaItemCollection categoriesFor: #itemByName:!**auto generated**!methods!public! !
!MSXML.ISchemaItemCollection categoriesFor: #ItemByName:item:!**auto generated**!COM Interfaces-ISchemaItemCollection!private! !
!MSXML.ISchemaItemCollection categoriesFor: #itemByQName:namespaceURI:!**auto generated**!methods!public! !
!MSXML.ISchemaItemCollection categoriesFor: #ItemByQName:namespaceURI:item:!**auto generated**!COM Interfaces-ISchemaItemCollection!private! !
!MSXML.ISchemaItemCollection categoriesFor: #length!**auto generated**!properties!public! !

!MSXML.ISchemaItemCollection class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSXML2.ISchemaItemCollection'
		ISchemaItemCollection defineTemplate"

	self
		defineFunction: #get_item:item:
			argumentTypes: 'sdword ISchemaItem**';
		defineFunction: #ItemByName:item:
			argumentTypes: 'bstr ISchemaItem**';
		defineFunction: #ItemByQName:namespaceURI:item:
			argumentTypes: 'bstr bstr ISchemaItem**';
		defineFunction: #get_length:
			argumentTypes: 'sdword*';
		defineFunction: #get__newEnum:
			argumentTypes: 'IUnknown**'
! !
!MSXML.ISchemaItemCollection class categoriesFor: #defineFunctions!**auto generated**!initializing!private! !

