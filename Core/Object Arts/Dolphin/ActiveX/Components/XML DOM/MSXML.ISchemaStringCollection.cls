"Filed out from Dolphin Smalltalk 7"!

OS.COM.IDispatch subclass: #'MSXML.ISchemaStringCollection'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
MSXML.ISchemaStringCollection guid: (OS.COM.IID fromString: '{50ea08b1-dd1b-4664-9a50-c2f40f4bd79a}')!
MSXML.ISchemaStringCollection comment: '<ISchemaStringCollection> is a wrapper class for the COM interface ''MSXML2.ISchemaStringCollection'' generated from type information in the ''Microsoft XML, v4.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"XML Schema String Collection"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(50EA08B1-DD1B-4664-9A50-C2F40F4BD79A), 
	helpstring("XML Schema String Collection"), 
	dual, 
	nonextensible
]
interface ISchemaStringCollection : IDispatch
 {
	[id(0000000000), propget]
	HRESULT __stdcall item(
		[in]long index,
		[out, retval]BSTR* bstr);
	[id(0x000005a7), propget]
	HRESULT __stdcall length(
		[out, retval]long* length);
	[id(0xfffffffc), hidden, propget, restricted]
	HRESULT __stdcall _newEnum(
		[out, retval]IUnknown** ppUnk);
};
'!
!MSXML.ISchemaStringCollection categoriesForClass!COM-Interfaces!MSXML2-Interfaces! !
!MSXML.ISchemaStringCollection methodsFor!

_newEnum
	"Answer the <IUnknown> value of the '_newEnum' property of the receiver."

	| answer |
	answer := IUnknown newPointer.
	self get__newEnum: answer.
	^answer asObject
!

get__newEnum: ppUnk
	"Private - Get the value of the '_newEnum' property of the receiver.

		HRESULT __stdcall _newEnum(
			[out, retval]IUnknown** ppUnk);"

	<virtual stdcall: hresult 10 IUnknown**>
	^self invalidCall: _failureCode!

get_item: index bstr: bstr
	"Private - Get the value of the 'item' property of the receiver.

		HRESULT __stdcall item(
			[in]long index,
			[out, retval]BSTR* bstr);"

	<virtual stdcall: hresult 8 sdword bstr*>
	^self invalidCall: _failureCode!

get_length: length
	"Private - Get the value of the 'length' property of the receiver.

		HRESULT __stdcall length(
			[out, retval]long* length);"

	<virtual stdcall: hresult 9 sdword*>
	^self invalidCall: _failureCode!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^false!

isVBCollection
	"Answer whether the receiver is a VB style collection."

	^true!

item: index
	"Answer the <bstr> value of the 'item' property of the receiver."

	| answer |
	answer := BSTR new.
	self
		get_item: index
		bstr: answer.
	^answer asObject
!

length
	"Answer the <sdword> value of the 'length' property of the receiver."

	| answer |
	answer := (SDWORD new).
	self get_length: answer.
	^answer asObject
! !
!MSXML.ISchemaStringCollection categoriesFor: #_newEnum!**auto generated**!properties!public! !
!MSXML.ISchemaStringCollection categoriesFor: #get__newEnum:!**auto generated**!COM Interfaces-ISchemaStringCollection!private! !
!MSXML.ISchemaStringCollection categoriesFor: #get_item:bstr:!**auto generated**!COM Interfaces-ISchemaStringCollection!private! !
!MSXML.ISchemaStringCollection categoriesFor: #get_length:!**auto generated**!COM Interfaces-ISchemaStringCollection!private! !
!MSXML.ISchemaStringCollection categoriesFor: #isExtensible!**auto generated**!public!testing! !
!MSXML.ISchemaStringCollection categoriesFor: #isVBCollection!**auto generated**!public!testing! !
!MSXML.ISchemaStringCollection categoriesFor: #item:!**auto generated**!properties!public! !
!MSXML.ISchemaStringCollection categoriesFor: #length!**auto generated**!properties!public! !

!MSXML.ISchemaStringCollection class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSXML2.ISchemaStringCollection'
		ISchemaStringCollection defineTemplate"

	self
		defineFunction: #get_item:bstr:
			argumentTypes: 'sdword bstr*';
		defineFunction: #get_length:
			argumentTypes: 'sdword*';
		defineFunction: #get__newEnum:
			argumentTypes: 'IUnknown**'
! !
!MSXML.ISchemaStringCollection class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

