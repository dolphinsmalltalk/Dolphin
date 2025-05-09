﻿"Filed out from Dolphin Smalltalk"!

OS.COM.IDispatch
	subclass: #'MSXML.IMXNamespacePrefixes'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

MSXML.IMXNamespacePrefixes guid: (OS.COM.IID fromString: '{c90352f4-643c-4fbc-bb23-e996eb2d51fd}')!

MSXML.IMXNamespacePrefixes isEgressOnly: true!

MSXML.IMXNamespacePrefixes comment: '<IMXNamespacePrefixes> is a wrapper class for the COM interface ''MSXML2.IMXNamespacePrefixes'' generated from type information in the ''Microsoft XML, v4.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"IMXNamespacePrefixes interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(C90352F4-643C-4FBC-BB23-E996EB2D51FD), 
	helpstring("IMXNamespacePrefixes interface"), 
	dual, 
	nonextensible
]
interface IMXNamespacePrefixes : IDispatch
 {
	[id(0000000000), propget]
	HRESULT __stdcall item(
		[in]long index,
		[out, retval]BSTR* prefix);
	[id(0x00000588), propget]
	HRESULT __stdcall length(
		[out, retval]long* length);
	[id(0xfffffffc), hidden, propget, restricted]
	HRESULT __stdcall _newEnum(
		[out, retval]IUnknown** ppUnk);
};
'!

!MSXML.IMXNamespacePrefixes categoriesForClass!COM-Interfaces!MSXML2-Interfaces! !

!MSXML.IMXNamespacePrefixes methodsFor!

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

	<virtual stdcall: hresult 10 IUnknown**>
	^self invalidCall: _failureCode!

get_item: index prefix: prefix
	"Private - Get the value of the 'item' property of the receiver.

		HRESULT __stdcall item(
			[in]long index,
			[out, retval]BSTR* prefix);"

	<virtual stdcall: hresult 8 int32 bstr*>
	^self invalidCall: _failureCode!

get_length: length
	"Private - Get the value of the 'length' property of the receiver.

		HRESULT __stdcall length(
			[out, retval]long* length);"

	<virtual stdcall: hresult 9 int32*>
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
	self get_item: index prefix: answer.
	^answer asObject!

length
	"Answer the <sdword> value of the 'length' property of the receiver."

	| answer |
	answer := Int32 new.
	self get_length: answer.
	^answer asObject! !

!MSXML.IMXNamespacePrefixes categoriesForMethods!
_newEnum!**auto generated**!properties!public! !
get__newEnum:!**auto generated**!COM Interfaces-IMXNamespacePrefixes!private! !
get_item:prefix:!**auto generated**!COM Interfaces-IMXNamespacePrefixes!private! !
get_length:!**auto generated**!COM Interfaces-IMXNamespacePrefixes!private! !
isExtensible!**auto generated**!public!testing! !
isVBCollection!**auto generated**!public!testing! !
item:!**auto generated**!properties!public! !
length!**auto generated**!properties!public! !
!

!MSXML.IMXNamespacePrefixes class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSXML2.IMXNamespacePrefixes'
		IMXNamespacePrefixes defineTemplate"

	self
		defineFunction: #get_item:prefix:
			argumentTypes: 'sdword bstr*';
		defineFunction: #get_length:
			argumentTypes: 'sdword*';
		defineFunction: #get__newEnum:
			argumentTypes: 'IUnknown**'
! !

!MSXML.IMXNamespacePrefixes class categoriesForMethods!
defineFunctions!**auto generated**!initializing!private! !
!

