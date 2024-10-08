﻿"Filed out from Dolphin Smalltalk"!

OS.COM.IDispatch
	subclass: #'MSXML.IMXAttributes'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

MSXML.IMXAttributes guid: (OS.COM.IID fromString: '{f10d27cc-3ec0-415c-8ed8-77ab1c5e7262}')!

MSXML.IMXAttributes isEgressOnly: true!

MSXML.IMXAttributes comment: '<IMXAttributes> is a wrapper class for the COM interface ''MSXML2.IMXAttributes'' generated from type information in the ''Microsoft XML, v4.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"IMXAttributes interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(F10D27CC-3EC0-415C-8ED8-77AB1C5E7262), 
	helpstring("IMXAttributes interface"), 
	dual, 
	nonextensible
]
interface IMXAttributes : IDispatch
 {
	[id(0x0000055d), helpstring("Add an attribute to the end of the list.")]
	HRESULT __stdcall addAttribute(
		[in]BSTR strURI,
		[in]BSTR strLocalName,
		[in]BSTR strQName,
		[in]BSTR strType,
		[in]BSTR strValue);
	[id(0x00000567), helpstring("Add an attribute, whose value is equal to the indexed attribute in the input attributes object, to the end of the list.")]
	HRESULT __stdcall addAttributeFromIndex(
		[in]VARIANT varAtts,
		[in]int nIndex);
	[id(0x0000055e), helpstring("Clear the attribute list for reuse.")]
	HRESULT __stdcall clear();
	[id(0x0000055f), helpstring("Remove an attribute from the list.")]
	HRESULT __stdcall removeAttribute(
		[in]int nIndex);
	[id(0x00000560), helpstring("Set an attribute in the list.")]
	HRESULT __stdcall setAttribute(
		[in]int nIndex,
		[in]BSTR strURI,
		[in]BSTR strLocalName,
		[in]BSTR strQName,
		[in]BSTR strType,
		[in]BSTR strValue);
	[id(0x00000561), helpstring("Copy an entire Attributes object.")]
	HRESULT __stdcall setAttributes(
		[in]VARIANT varAtts);
	[id(0x00000562), helpstring("Set the local name of a specific attribute.")]
	HRESULT __stdcall setLocalName(
		[in]int nIndex,
		[in]BSTR strLocalName);
	[id(0x00000563), helpstring("Set the qualified name of a specific attribute.")]
	HRESULT __stdcall setQName(
		[in]int nIndex,
		[in]BSTR strQName);
	[id(0x00000564), helpstring("Set the type of a specific attribute.")]
	HRESULT __stdcall setType(
		[in]int nIndex,
		[in]BSTR strType);
	[id(0x00000565), helpstring("Set the Namespace URI of a specific attribute.")]
	HRESULT __stdcall setURI(
		[in]int nIndex,
		[in]BSTR strURI);
	[id(0x00000566), helpstring("Set the value of a specific attribute.")]
	HRESULT __stdcall setValue(
		[in]int nIndex,
		[in]BSTR strValue);
};
'!

!MSXML.IMXAttributes categoriesForClass!COM-Interfaces!MSXML2-Interfaces! !

!MSXML.IMXAttributes methodsFor!

AddAttribute: strURI strLocalName: strLocalName strQName: strQName strType: strType strValue: strValue
	"Invoke the addAttribute() method of the COM object.
	Helpstring: Add an attribute to the end of the list.

		HRESULT __stdcall addAttribute(
			[in]BSTR strURI,
			[in]BSTR strLocalName,
			[in]BSTR strQName,
			[in]BSTR strType,
			[in]BSTR strValue);"

	<virtual stdcall: hresult 8 bstr bstr bstr bstr bstr>
	^self invalidCall: _failureCode!

addAttributeFromIndex: varAtts nIndex: nIndex
	"Invoke the addAttributeFromIndex() method of the COM object.
	Helpstring: Add an attribute, whose value is equal to the indexed attribute in the input attributes object, to the end of the list."

	^self AddAttributeFromIndex: varAtts asVariant nIndex: nIndex!

AddAttributeFromIndex: varAtts nIndex: nIndex
	"Private - Invoke the addAttributeFromIndex() method of the COM object.
	Helpstring: Add an attribute, whose value is equal to the indexed attribute in the input attributes object, to the end of the list.

		HRESULT __stdcall addAttributeFromIndex(
			[in]VARIANT varAtts,
			[in]int nIndex);"

	<virtual stdcall: hresult 9 variant int32>
	^self invalidCall: _failureCode!

Clear
	"Invoke the clear() method of the COM object.
	Helpstring: Clear the attribute list for reuse.

		HRESULT __stdcall clear();"

	<virtual stdcall: hresult 10>
	^self invalidCall: _failureCode!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^false!

isVBCollection
	"Answer whether the receiver is a VB style collection."

	^false!

RemoveAttribute: nIndex
	"Invoke the removeAttribute() method of the COM object.
	Helpstring: Remove an attribute from the list.

		HRESULT __stdcall removeAttribute(
			[in]int nIndex);"

	<virtual stdcall: hresult 11 int32>
	^self invalidCall: _failureCode!

SetAttribute: nIndex strURI: strURI strLocalName: strLocalName strQName: strQName strType: strType strValue: strValue
	"Invoke the setAttribute() method of the COM object.
	Helpstring: Set an attribute in the list.

		HRESULT __stdcall setAttribute(
			[in]int nIndex,
			[in]BSTR strURI,
			[in]BSTR strLocalName,
			[in]BSTR strQName,
			[in]BSTR strType,
			[in]BSTR strValue);"

	<virtual stdcall: hresult 12 int32 bstr bstr bstr bstr bstr>
	^self invalidCall: _failureCode!

setAttributes: varAtts
	"Invoke the setAttributes() method of the COM object.
	Helpstring: Copy an entire Attributes object."

	^self SetAttributes: varAtts asVariant!

SetAttributes: varAtts
	"Private - Invoke the setAttributes() method of the COM object.
	Helpstring: Copy an entire Attributes object.

		HRESULT __stdcall setAttributes(
			[in]VARIANT varAtts);"

	<virtual stdcall: hresult 13 variant>
	^self invalidCall: _failureCode!

SetLocalName: nIndex strLocalName: strLocalName
	"Invoke the setLocalName() method of the COM object.
	Helpstring: Set the local name of a specific attribute.

		HRESULT __stdcall setLocalName(
			[in]int nIndex,
			[in]BSTR strLocalName);"

	<virtual stdcall: hresult 14 int32 bstr>
	^self invalidCall: _failureCode!

SetQName: nIndex strQName: strQName
	"Invoke the setQName() method of the COM object.
	Helpstring: Set the qualified name of a specific attribute.

		HRESULT __stdcall setQName(
			[in]int nIndex,
			[in]BSTR strQName);"

	<virtual stdcall: hresult 15 int32 bstr>
	^self invalidCall: _failureCode!

SetType: nIndex strType: strType
	"Invoke the setType() method of the COM object.
	Helpstring: Set the type of a specific attribute.

		HRESULT __stdcall setType(
			[in]int nIndex,
			[in]BSTR strType);"

	<virtual stdcall: hresult 16 int32 bstr>
	^self invalidCall: _failureCode!

SetURI: nIndex strURI: strURI
	"Invoke the setURI() method of the COM object.
	Helpstring: Set the Namespace URI of a specific attribute.

		HRESULT __stdcall setURI(
			[in]int nIndex,
			[in]BSTR strURI);"

	<virtual stdcall: hresult 17 int32 bstr>
	^self invalidCall: _failureCode!

SetValue: nIndex strValue: strValue
	"Invoke the setValue() method of the COM object.
	Helpstring: Set the value of a specific attribute.

		HRESULT __stdcall setValue(
			[in]int nIndex,
			[in]BSTR strValue);"

	<virtual stdcall: hresult 18 int32 bstr>
	^self invalidCall: _failureCode! !

!MSXML.IMXAttributes categoriesForMethods!
AddAttribute:strLocalName:strQName:strType:strValue:!**auto generated**!COM Interfaces-IMXAttributes!public! !
addAttributeFromIndex:nIndex:!**auto generated**!methods!public! !
AddAttributeFromIndex:nIndex:!**auto generated**!COM Interfaces-IMXAttributes!private! !
Clear!**auto generated**!COM Interfaces-IMXAttributes!public! !
isExtensible!**auto generated**!public!testing! !
isVBCollection!**auto generated**!public!testing! !
RemoveAttribute:!**auto generated**!COM Interfaces-IMXAttributes!public! !
SetAttribute:strURI:strLocalName:strQName:strType:strValue:!**auto generated**!COM Interfaces-IMXAttributes!public! !
setAttributes:!**auto generated**!methods!public! !
SetAttributes:!**auto generated**!COM Interfaces-IMXAttributes!private! !
SetLocalName:strLocalName:!**auto generated**!COM Interfaces-IMXAttributes!public! !
SetQName:strQName:!**auto generated**!COM Interfaces-IMXAttributes!public! !
SetType:strType:!**auto generated**!COM Interfaces-IMXAttributes!public! !
SetURI:strURI:!**auto generated**!COM Interfaces-IMXAttributes!public! !
SetValue:strValue:!**auto generated**!COM Interfaces-IMXAttributes!public! !
!

!MSXML.IMXAttributes class methodsFor!

clsid
	"Private - Answer the CLSID of the coclass (SAXAttributes60) for which the receiver is the default interface."

	^CLSID fromString: '{88d96a0e-f192-11d4-a65f-0040963251e5}'
!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSXML2.IMXAttributes'
		IMXAttributes defineTemplate"

	self
		defineFunction: #AddAttribute:strLocalName:strQName:strType:strValue:
			argumentTypes: 'bstr bstr bstr bstr bstr';
		defineFunction: #AddAttributeFromIndex:nIndex:
			argumentTypes: 'variant sdword';
		defineFunction: #Clear;
		defineFunction: #RemoveAttribute:
			argumentTypes: 'sdword';
		defineFunction: #SetAttribute:strURI:strLocalName:strQName:strType:strValue:
			argumentTypes: 'sdword bstr bstr bstr bstr bstr';
		defineFunction: #SetAttributes:
			argumentTypes: 'variant';
		defineFunction: #SetLocalName:strLocalName:
			argumentTypes: 'sdword bstr';
		defineFunction: #SetQName:strQName:
			argumentTypes: 'sdword bstr';
		defineFunction: #SetType:strType:
			argumentTypes: 'sdword bstr';
		defineFunction: #SetURI:strURI:
			argumentTypes: 'sdword bstr';
		defineFunction: #SetValue:strValue:
			argumentTypes: 'sdword bstr'
! !

!MSXML.IMXAttributes class categoriesForMethods!
clsid!**auto generated**!constants!private! !
defineFunctions!**auto generated**!initializing!private! !
!

