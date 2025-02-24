﻿"Filed out from Dolphin Smalltalk"!

OS.COM.IDispatch
	subclass: #'MSXML.IXMLDOMParseErrorCollection'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

MSXML.IXMLDOMParseErrorCollection guid: (OS.COM.IID fromString: '{3efaa429-272f-11d2-836f-0000f87a7782}')!

MSXML.IXMLDOMParseErrorCollection isEgressOnly: true!

MSXML.IXMLDOMParseErrorCollection comment: '<IXMLDOMParseErrorCollection> is a wrapper class for the COM interface ''MSXML2.IXMLDOMParseErrorCollection'' generated from type information in the ''Microsoft XML, v6.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"structure for reporting parser errors"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(3EFAA429-272F-11D2-836F-0000F87A7782), 
	helpstring("structure for reporting parser errors"), 
	nonextensible, 
	dual
]
interface IXMLDOMParseErrorCollection : IDispatch
 {
	[id(0000000000), propget]
	HRESULT __stdcall item(
		[in]long index,
		[out, retval]IXMLDOMParseError2** error);
	[id(0x000000c1), propget]
	HRESULT __stdcall length(
		[out, retval]long* length);
	[id(0x000000c2), propget]
	HRESULT __stdcall next(
		[out, retval]IXMLDOMParseError2** error);
	[id(0x000000c3)]
	HRESULT __stdcall reset();
	[id(0xfffffffc), hidden, propget, restricted]
	HRESULT __stdcall _newEnum(
		[out, retval]IUnknown** ppUnk);
};
'!

!MSXML.IXMLDOMParseErrorCollection categoriesForClass!COM-Interfaces!MSXML2-Interfaces! !

!MSXML.IXMLDOMParseErrorCollection methodsFor!

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

get_item: index error: error
	"Private - Get the value of the 'item' property of the receiver.

		HRESULT __stdcall item(
			[in]long index,
			[out, retval]IXMLDOMParseError2** error);"

	<virtual stdcall: hresult 8 int32 IXMLDOMParseError2**>
	^self invalidCall: _failureCode!

get_length: length
	"Private - Get the value of the 'length' property of the receiver.

		HRESULT __stdcall length(
			[out, retval]long* length);"

	<virtual stdcall: hresult 9 int32*>
	^self invalidCall: _failureCode!

get_next: error
	"Private - Get the value of the 'next' property of the receiver.

		HRESULT __stdcall next(
			[out, retval]IXMLDOMParseError2** error);"

	<virtual stdcall: hresult 10 IXMLDOMParseError2**>
	^self invalidCall: _failureCode!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^false!

isVBCollection
	"Answer whether the receiver is a VB style collection."

	^true!

item: index
	"Answer the <IXMLDOMParseError2> value of the 'item' property of the receiver."

	| answer |
	answer := IXMLDOMParseError2 newPointer.
	self get_item: index error: answer.
	^answer asObject!

length
	"Answer the <sdword> value of the 'length' property of the receiver."

	| answer |
	answer := Int32 new.
	self get_length: answer.
	^answer asObject!

next
	"Answer the <IXMLDOMParseError2> value of the 'next' property of the receiver."

	| answer |
	answer := IXMLDOMParseError2 newPointer.
	self get_next: answer.
	^answer asObject!

Reset
	"Invoke the reset() method of the COM object.

		HRESULT __stdcall reset();"

	<virtual stdcall: hresult 11>
	^self invalidCall: _failureCode! !

!MSXML.IXMLDOMParseErrorCollection categoriesForMethods!
_newEnum!**auto generated**!properties!public! !
get__newEnum:!**auto generated**!COM Interfaces-IXMLDOMParseErrorCollection!private! !
get_item:error:!**auto generated**!COM Interfaces-IXMLDOMParseErrorCollection!private! !
get_length:!**auto generated**!COM Interfaces-IXMLDOMParseErrorCollection!private! !
get_next:!**auto generated**!COM Interfaces-IXMLDOMParseErrorCollection!private! !
isExtensible!**auto generated**!public!testing! !
isVBCollection!**auto generated**!public!testing! !
item:!**auto generated**!properties!public! !
length!**auto generated**!properties!public! !
next!**auto generated**!properties!public! !
Reset!**auto generated**!COM Interfaces-IXMLDOMParseErrorCollection!public! !
!

!MSXML.IXMLDOMParseErrorCollection class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSXML2.IXMLDOMParseErrorCollection'
		IXMLDOMParseErrorCollection defineTemplate"

	self
		defineFunction: #get_item:error:
			argumentTypes: 'sdword IXMLDOMParseError2**';
		defineFunction: #get_length:
			argumentTypes: 'sdword*';
		defineFunction: #get_next:
			argumentTypes: 'IXMLDOMParseError2**';
		defineFunction: #Reset;
		defineFunction: #get__newEnum:
			argumentTypes: 'IUnknown**'
! !

!MSXML.IXMLDOMParseErrorCollection class categoriesForMethods!
defineFunctions!**auto generated**!initializing!private! !
!

