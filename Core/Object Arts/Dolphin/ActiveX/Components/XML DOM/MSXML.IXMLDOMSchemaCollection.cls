﻿"Filed out from Dolphin Smalltalk"!

OS.COM.IDispatch
	subclass: #'MSXML.IXMLDOMSchemaCollection'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

MSXML.IXMLDOMSchemaCollection guid: (OS.COM.IID fromString: '{373984c8-b845-449b-91e7-45ac83036ade}')!

MSXML.IXMLDOMSchemaCollection isEgressOnly: true!

MSXML.IXMLDOMSchemaCollection comment: '<IXMLDOMSchemaCollection> is a wrapper class for the COM interface ''MSXML2.IXMLDOMSchemaCollection'' generated from type information in the ''Microsoft XML, v4.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"XML Schemas Collection"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(373984C8-B845-449B-91E7-45AC83036ADE), 
	helpstring("XML Schemas Collection"), 
	dual, 
	nonextensible
]
interface IXMLDOMSchemaCollection : IDispatch
 {
	[id(0x00000002), helpstring("add a new schema")]
	HRESULT __stdcall add(
		[in]BSTR namespaceURI,
		[in]VARIANT var);
	[id(0x00000003), helpstring("lookup schema by namespaceURI")]
	HRESULT __stdcall get(
		[in]BSTR namespaceURI,
		[out, retval]IXMLDOMNode** schemaNode);
	[id(0x00000004), helpstring("remove schema by namespaceURI")]
	HRESULT __stdcall remove(
		[in]BSTR namespaceURI);
	[id(0x00000005), propget, helpstring("number of schemas in collection")]
	HRESULT __stdcall length(
		[out, retval]long* length);
	[id(0000000000), propget, helpstring("Get namespaceURI for schema by index")]
	HRESULT __stdcall namespaceURI(
		[in]long index,
		[out, retval]BSTR* length);
	[id(0x00000006), helpstring("copy & merge other collection into this one")]
	HRESULT __stdcall addCollection(
		[in]IXMLDOMSchemaCollection* otherCollection);
	[id(0xfffffffc), hidden, propget, restricted]
	HRESULT __stdcall _newEnum(
		[out, retval]IUnknown** ppUnk);
};
'!

!MSXML.IXMLDOMSchemaCollection categoriesForClass!COM-Interfaces!MSXML2-Interfaces! !

!MSXML.IXMLDOMSchemaCollection methodsFor!

_newEnum
	"Answer the <IUnknown> value of the '_newEnum' property of the receiver."

	| answer |
	answer := IUnknown newPointer.
	self get__newEnum: answer.
	^answer asObject!

add: namespaceURI var: var
	"Invoke the add() method of the COM object.
	Helpstring: add a new schema"

	^self Add: namespaceURI var: var asVariant!

Add: namespaceURI var: var
	"Private - Invoke the add() method of the COM object.
	Helpstring: add a new schema

		HRESULT __stdcall add(
			[in]BSTR namespaceURI,
			[in]VARIANT var);"

	<virtual stdcall: hresult 8 bstr variant>
	^self invalidCall: _failureCode!

AddCollection: otherCollection
	"Invoke the addCollection() method of the COM object.
	Helpstring: copy & merge other collection into this one

		HRESULT __stdcall addCollection(
			[in]IXMLDOMSchemaCollection* otherCollection);"

	<virtual stdcall: hresult 13 IXMLDOMSchemaCollection*>
	^self invalidCall: _failureCode!

get: namespaceURI
	"Answer the <IXMLDOMNode> result of invoking the get() method of the COM object.
	Helpstring: lookup schema by namespaceURI"

	| answer |
	answer := IXMLDOMNode newPointer.
	self Get: namespaceURI schemaNode: answer.
	^answer asObject!

Get: namespaceURI schemaNode: schemaNode
	"Private - Invoke the get() method of the COM object.
	Helpstring: lookup schema by namespaceURI

		HRESULT __stdcall get(
			[in]BSTR namespaceURI,
			[out, retval]IXMLDOMNode** schemaNode);"

	<virtual stdcall: hresult 9 bstr IXMLDOMNode**>
	^self invalidCall: _failureCode!

get__newEnum: ppUnk
	"Private - Get the value of the '_newEnum' property of the receiver.

		HRESULT __stdcall _newEnum(
			[out, retval]IUnknown** ppUnk);"

	<virtual stdcall: hresult 14 IUnknown**>
	^self invalidCall: _failureCode!

get_length: length
	"Private - Get the value of the 'length' property of the receiver.

		HRESULT __stdcall length(
			[out, retval]long* length);"

	<virtual stdcall: hresult 11 int32*>
	^self invalidCall: _failureCode!

get_namespaceURI: index length: length
	"Private - Get the value of the 'namespaceURI' property of the receiver.

		HRESULT __stdcall namespaceURI(
			[in]long index,
			[out, retval]BSTR* length);"

	<virtual stdcall: hresult 12 int32 bstr*>
	^self invalidCall: _failureCode!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^false!

isVBCollection
	"Answer whether the receiver is a VB style collection."

	^true!

length
	"Answer the <sdword> value of the 'length' property of the receiver.
	Helpstring: number of schemas in collection"

	| answer |
	answer := Int32 new.
	self get_length: answer.
	^answer asObject!

namespaceURI: index
	"Answer the <bstr> value of the 'namespaceURI' property of the receiver.
	Helpstring: Get namespaceURI for schema by index"

	| answer |
	answer := BSTR new.
	self get_namespaceURI: index length: answer.
	^answer asObject!

Remove: namespaceURI
	"Invoke the remove() method of the COM object.
	Helpstring: remove schema by namespaceURI

		HRESULT __stdcall remove(
			[in]BSTR namespaceURI);"

	<virtual stdcall: hresult 10 bstr>
	^self invalidCall: _failureCode! !

!MSXML.IXMLDOMSchemaCollection categoriesForMethods!
_newEnum!**auto generated**!properties!public! !
add:var:!**auto generated**!methods!public! !
Add:var:!**auto generated**!COM Interfaces-IXMLDOMSchemaCollection!private! !
AddCollection:!**auto generated**!COM Interfaces-IXMLDOMSchemaCollection!public! !
get:!**auto generated**!methods!public! !
Get:schemaNode:!**auto generated**!COM Interfaces-IXMLDOMSchemaCollection!private! !
get__newEnum:!**auto generated**!COM Interfaces-IXMLDOMSchemaCollection!private! !
get_length:!**auto generated**!COM Interfaces-IXMLDOMSchemaCollection!private! !
get_namespaceURI:length:!**auto generated**!COM Interfaces-IXMLDOMSchemaCollection!private! !
isExtensible!**auto generated**!public!testing! !
isVBCollection!**auto generated**!public!testing! !
length!**auto generated**!properties!public! !
namespaceURI:!**auto generated**!properties!public! !
Remove:!**auto generated**!COM Interfaces-IXMLDOMSchemaCollection!public! !
!

!MSXML.IXMLDOMSchemaCollection class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSXML2.IXMLDOMSchemaCollection'
		IXMLDOMSchemaCollection defineTemplate"

	self
		defineFunction: #Add:var:
			argumentTypes: 'bstr variant';
		defineFunction: #Get:schemaNode:
			argumentTypes: 'bstr IXMLDOMNode**';
		defineFunction: #Remove:
			argumentTypes: 'bstr';
		defineFunction: #get_length:
			argumentTypes: 'sdword*';
		defineFunction: #get_namespaceURI:length:
			argumentTypes: 'sdword bstr*';
		defineFunction: #AddCollection:
			argumentTypes: 'IXMLDOMSchemaCollection*';
		defineFunction: #get__newEnum:
			argumentTypes: 'IUnknown**'
! !

!MSXML.IXMLDOMSchemaCollection class categoriesForMethods!
defineFunctions!**auto generated**!initializing!private! !
!

