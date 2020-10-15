"Filed out from Dolphin Smalltalk 7"!

OS.COM.IDispatch subclass: #'MSXML.ISchemaItem'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
MSXML.ISchemaItem guid: (OS.COM.IID fromString: '{50ea08b3-dd1b-4664-9a50-c2f40f4bd79a}')!
MSXML.ISchemaItem comment: '<ISchemaItem> is a wrapper class for the COM interface ''MSXML2.ISchemaItem'' generated from type information in the ''Microsoft XML, v4.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"XML Schema Item"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(50EA08B3-DD1B-4664-9A50-C2F40F4BD79A), 
	helpstring("XML Schema Item"), 
	dual, 
	nonextensible
]
interface ISchemaItem : IDispatch
 {
	[id(0x000005b1), propget]
	HRESULT __stdcall name(
		[out, retval]BSTR* name);
	[id(0x000005b3), propget]
	HRESULT __stdcall namespaceURI(
		[out, retval]BSTR* namespaceURI);
	[id(0x000005bb), propget]
	HRESULT __stdcall schema(
		[out, retval]ISchema** schema);
	[id(0x000005a0), propget]
	HRESULT __stdcall id(
		[out, retval]BSTR* id);
	[id(0x000005a6), propget]
	HRESULT __stdcall itemType(
		[out, retval]SOMITEMTYPE* itemType);
	[id(0x000005c6), propget]
	HRESULT __stdcall unhandledAttributes(
		[out, retval]IVBSAXAttributes** attributes);
	[id(0x000005cb)]
	HRESULT __stdcall writeAnnotation(
		[in]IUnknown* annotationSink,
		[out, retval]VARIANT_BOOL* isWritten);
};
'!
!MSXML.ISchemaItem categoriesForClass!COM-Interfaces!MSXML2-Interfaces! !
!MSXML.ISchemaItem methodsFor!

get_id: id
	"Private - Get the value of the 'id' property of the receiver.

		HRESULT __stdcall id(
			[out, retval]BSTR* id);"

	<virtual stdcall: hresult 11 bstr*>
	^self invalidCall: _failureCode!

get_itemType: itemType
	"Private - Get the value of the 'itemType' property of the receiver.

		HRESULT __stdcall itemType(
			[out, retval]SOMITEMTYPE* itemType);"

	<virtual stdcall: hresult 12 sdword*>
	^self invalidCall: _failureCode!

get_name: name
	"Private - Get the value of the 'name' property of the receiver.

		HRESULT __stdcall name(
			[out, retval]BSTR* name);"

	<virtual stdcall: hresult 8 bstr*>
	^self invalidCall: _failureCode!

get_namespaceURI: namespaceURI
	"Private - Get the value of the 'namespaceURI' property of the receiver.

		HRESULT __stdcall namespaceURI(
			[out, retval]BSTR* namespaceURI);"

	<virtual stdcall: hresult 9 bstr*>
	^self invalidCall: _failureCode!

get_schema: schema
	"Private - Get the value of the 'schema' property of the receiver.

		HRESULT __stdcall schema(
			[out, retval]ISchema** schema);"

	<virtual stdcall: hresult 10 ISchema**>
	^self invalidCall: _failureCode!

get_unhandledAttributes: attributes
	"Private - Get the value of the 'unhandledAttributes' property of the receiver.

		HRESULT __stdcall unhandledAttributes(
			[out, retval]IVBSAXAttributes** attributes);"

	<virtual stdcall: hresult 13 IVBSAXAttributes**>
	^self invalidCall: _failureCode!

id
	"Answer the <bstr> value of the 'id' property of the receiver."

	| answer |
	answer := BSTR new.
	self get_id: answer.
	^answer asObject!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^false!

isVBCollection
	"Answer whether the receiver is a VB style collection."

	^false!

itemType
	"Answer the <sdword> value of the 'itemType' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_itemType: answer.
	^answer asObject!

name
	"Answer the <bstr> value of the 'name' property of the receiver."

	| answer |
	answer := BSTR new.
	self get_name: answer.
	^answer asObject!

namespaceURI
	"Answer the <bstr> value of the 'namespaceURI' property of the receiver."

	| answer |
	answer := BSTR new.
	self get_namespaceURI: answer.
	^answer asObject!

schema
	"Answer the <ISchema> value of the 'schema' property of the receiver."

	| answer |
	answer := ISchema newPointer.
	self get_schema: answer.
	^answer asObject!

unhandledAttributes
	"Answer the <IVBSAXAttributes> value of the 'unhandledAttributes' property of the receiver."

	| answer |
	answer := IVBSAXAttributes newPointer.
	self get_unhandledAttributes: answer.
	^answer asObject!

writeAnnotation: annotationSink
	"Answer the <varbool> result of invoking the writeAnnotation() method of the COM object."

	| answer |
	answer := VARIANT_BOOL new.
	self WriteAnnotation: annotationSink isWritten: answer.
	^answer asObject!

WriteAnnotation: annotationSink isWritten: isWritten
	"Private - Invoke the writeAnnotation() method of the COM object.

		HRESULT __stdcall writeAnnotation(
			[in]IUnknown* annotationSink,
			[out, retval]VARIANT_BOOL* isWritten);"

	<virtual stdcall: hresult 14 IUnknown* varbool*>
	^self invalidCall: _failureCode! !
!MSXML.ISchemaItem categoriesFor: #get_id:!**auto generated**!COM Interfaces-ISchemaItem!private! !
!MSXML.ISchemaItem categoriesFor: #get_itemType:!**auto generated**!COM Interfaces-ISchemaItem!private! !
!MSXML.ISchemaItem categoriesFor: #get_name:!**auto generated**!COM Interfaces-ISchemaItem!private! !
!MSXML.ISchemaItem categoriesFor: #get_namespaceURI:!**auto generated**!COM Interfaces-ISchemaItem!private! !
!MSXML.ISchemaItem categoriesFor: #get_schema:!**auto generated**!COM Interfaces-ISchemaItem!private! !
!MSXML.ISchemaItem categoriesFor: #get_unhandledAttributes:!**auto generated**!COM Interfaces-ISchemaItem!private! !
!MSXML.ISchemaItem categoriesFor: #id!**auto generated**!properties!public! !
!MSXML.ISchemaItem categoriesFor: #isExtensible!**auto generated**!public!testing! !
!MSXML.ISchemaItem categoriesFor: #isVBCollection!**auto generated**!public!testing! !
!MSXML.ISchemaItem categoriesFor: #itemType!**auto generated**!properties!public! !
!MSXML.ISchemaItem categoriesFor: #name!**auto generated**!properties!public! !
!MSXML.ISchemaItem categoriesFor: #namespaceURI!**auto generated**!properties!public! !
!MSXML.ISchemaItem categoriesFor: #schema!**auto generated**!properties!public! !
!MSXML.ISchemaItem categoriesFor: #unhandledAttributes!**auto generated**!properties!public! !
!MSXML.ISchemaItem categoriesFor: #writeAnnotation:!**auto generated**!methods!public! !
!MSXML.ISchemaItem categoriesFor: #WriteAnnotation:isWritten:!**auto generated**!COM Interfaces-ISchemaItem!private! !

!MSXML.ISchemaItem class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSXML2.ISchemaItem'
		ISchemaItem defineTemplate"

	self
		defineFunction: #get_name:
			argumentTypes: 'bstr*';
		defineFunction: #get_namespaceURI:
			argumentTypes: 'bstr*';
		defineFunction: #get_schema:
			argumentTypes: 'ISchema**';
		defineFunction: #get_id:
			argumentTypes: 'bstr*';
		defineFunction: #get_itemType:
			argumentTypes: 'sdword*';
		defineFunction: #get_unhandledAttributes:
			argumentTypes: 'IVBSAXAttributes**';
		defineFunction: #WriteAnnotation:isWritten:
			argumentTypes: 'IUnknown* varbool*'
! !
!MSXML.ISchemaItem class categoriesFor: #defineFunctions!**auto generated**!initializing!private! !

