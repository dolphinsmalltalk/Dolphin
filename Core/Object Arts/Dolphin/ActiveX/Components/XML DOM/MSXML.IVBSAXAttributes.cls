"Filed out from Dolphin Smalltalk 7"!

OS.COM.IDispatch subclass: #'MSXML.IVBSAXAttributes'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
MSXML.IVBSAXAttributes guid: (OS.COM.IID fromString: '{10dc0586-132b-4cac-8bb3-db00ac8b7ee0}')!
MSXML.IVBSAXAttributes comment: '<IVBSAXAttributes> is a wrapper class for the COM interface ''MSXML2.IVBSAXAttributes'' generated from type information in the ''Microsoft XML, v4.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"IVBSAXAttributes interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(10DC0586-132B-4CAC-8BB3-DB00AC8B7EE0), 
	helpstring("IVBSAXAttributes interface"), 
	dual, 
	nonextensible
]
interface IVBSAXAttributes : IDispatch
 {
	[id(0x00000540), propget, helpstring("Get the number of attributes in the list.")]
	HRESULT __stdcall length(
		[out, retval]int* nLength);
	[id(0x00000541), helpstring("Look up an attribute''s Namespace URI by index.")]
	HRESULT __stdcall getURI(
		[in]int nIndex,
		[out, retval]BSTR* strURI);
	[id(0x00000542), helpstring("Look up an attribute''s local name by index.")]
	HRESULT __stdcall getLocalName(
		[in]int nIndex,
		[out, retval]BSTR* strLocalName);
	[id(0x00000543), helpstring("Look up an attribute''s XML 1.0 qualified name by index.")]
	HRESULT __stdcall getQName(
		[in]int nIndex,
		[out, retval]BSTR* strQName);
	[id(0x00000544), helpstring("Look up the index of an attribute by Namespace name.")]
	HRESULT __stdcall getIndexFromName(
		[in]BSTR strURI,
		[in]BSTR strLocalName,
		[out, retval]int* nIndex);
	[id(0x00000545), helpstring("Look up the index of an attribute by XML 1.0 qualified name.")]
	HRESULT __stdcall getIndexFromQName(
		[in]BSTR strQName,
		[out, retval]int* nIndex);
	[id(0x00000546), helpstring("Look up an attribute''s type by index.")]
	HRESULT __stdcall getType(
		[in]int nIndex,
		[out, retval]BSTR* strType);
	[id(0x00000547), helpstring("Look up an attribute''s type by Namespace name.")]
	HRESULT __stdcall getTypeFromName(
		[in]BSTR strURI,
		[in]BSTR strLocalName,
		[out, retval]BSTR* strType);
	[id(0x00000548), helpstring("Look up an attribute''s type by XML 1.0 qualified name.")]
	HRESULT __stdcall getTypeFromQName(
		[in]BSTR strQName,
		[out, retval]BSTR* strType);
	[id(0x00000549), helpstring("Look up an attribute''s value by index.")]
	HRESULT __stdcall getValue(
		[in]int nIndex,
		[out, retval]BSTR* strValue);
	[id(0x0000054a), helpstring("Look up an attribute''s value by Namespace name.")]
	HRESULT __stdcall getValueFromName(
		[in]BSTR strURI,
		[in]BSTR strLocalName,
		[out, retval]BSTR* strValue);
	[id(0x0000054b), helpstring("Look up an attribute''s value by XML 1.0 qualified name.")]
	HRESULT __stdcall getValueFromQName(
		[in]BSTR strQName,
		[out, retval]BSTR* strValue);
};
'!
!MSXML.IVBSAXAttributes categoriesForClass!COM-Interfaces!MSXML2-Interfaces! !
!MSXML.IVBSAXAttributes methodsFor!

get_length: nLength
	"Private - Get the value of the 'length' property of the receiver.

		HRESULT __stdcall length(
			[out, retval]int* nLength);"

	<virtual stdcall: hresult 8 sdword*>
	^self invalidCall: _failureCode!

getIndexFromName: strURI strLocalName: strLocalName
	"Answer the <SDWORD> result of invoking the getIndexFromName() method of the COM object.
	Helpstring: Look up the index of an attribute by Namespace name."

	| answer |
	answer := (SDWORD new).
	self
		GetIndexFromName: strURI
		strLocalName: strLocalName
		nIndex: answer.
	^answer asObject
!

GetIndexFromName: strURI strLocalName: strLocalName nIndex: nIndex
	"Private - Invoke the getIndexFromName() method of the COM object.
	Helpstring: Look up the index of an attribute by Namespace name.

		HRESULT __stdcall getIndexFromName(
			[in]BSTR strURI,
			[in]BSTR strLocalName,
			[out, retval]int* nIndex);"

	<virtual stdcall: hresult 12 bstr bstr sdword*>
	^self invalidCall: _failureCode!

getIndexFromQName: strQName
	"Answer the <SDWORD> result of invoking the getIndexFromQName() method of the COM object.
	Helpstring: Look up the index of an attribute by XML 1.0 qualified name."

	| answer |
	answer := (SDWORD new).
	self
		GetIndexFromQName: strQName
		nIndex: answer.
	^answer asObject
!

GetIndexFromQName: strQName nIndex: nIndex
	"Private - Invoke the getIndexFromQName() method of the COM object.
	Helpstring: Look up the index of an attribute by XML 1.0 qualified name.

		HRESULT __stdcall getIndexFromQName(
			[in]BSTR strQName,
			[out, retval]int* nIndex);"

	<virtual stdcall: hresult 13 bstr sdword*>
	^self invalidCall: _failureCode!

getLocalName: nIndex
	"Answer the <BSTR> result of invoking the getLocalName() method of the COM object.
	Helpstring: Look up an attribute's local name by index."

	| answer |
	answer := BSTR new.
	self
		GetLocalName: nIndex
		strLocalName: answer.
	^answer asObject
!

GetLocalName: nIndex strLocalName: strLocalName
	"Private - Invoke the getLocalName() method of the COM object.
	Helpstring: Look up an attribute's local name by index.

		HRESULT __stdcall getLocalName(
			[in]int nIndex,
			[out, retval]BSTR* strLocalName);"

	<virtual stdcall: hresult 10 sdword bstr*>
	^self invalidCall: _failureCode!

getQName: nIndex
	"Answer the <BSTR> result of invoking the getQName() method of the COM object.
	Helpstring: Look up an attribute's XML 1.0 qualified name by index."

	| answer |
	answer := BSTR new.
	self
		GetQName: nIndex
		strQName: answer.
	^answer asObject
!

GetQName: nIndex strQName: strQName
	"Private - Invoke the getQName() method of the COM object.
	Helpstring: Look up an attribute's XML 1.0 qualified name by index.

		HRESULT __stdcall getQName(
			[in]int nIndex,
			[out, retval]BSTR* strQName);"

	<virtual stdcall: hresult 11 sdword bstr*>
	^self invalidCall: _failureCode!

getType: nIndex
	"Answer the <BSTR> result of invoking the getType() method of the COM object.
	Helpstring: Look up an attribute's type by index."

	| answer |
	answer := BSTR new.
	self
		GetType: nIndex
		strType: answer.
	^answer asObject
!

GetType: nIndex strType: strType
	"Private - Invoke the getType() method of the COM object.
	Helpstring: Look up an attribute's type by index.

		HRESULT __stdcall getType(
			[in]int nIndex,
			[out, retval]BSTR* strType);"

	<virtual stdcall: hresult 14 sdword bstr*>
	^self invalidCall: _failureCode!

getTypeFromName: strURI strLocalName: strLocalName
	"Answer the <BSTR> result of invoking the getTypeFromName() method of the COM object.
	Helpstring: Look up an attribute's type by Namespace name."

	| answer |
	answer := BSTR new.
	self
		GetTypeFromName: strURI
		strLocalName: strLocalName
		strType: answer.
	^answer asObject
!

GetTypeFromName: strURI strLocalName: strLocalName strType: strType
	"Private - Invoke the getTypeFromName() method of the COM object.
	Helpstring: Look up an attribute's type by Namespace name.

		HRESULT __stdcall getTypeFromName(
			[in]BSTR strURI,
			[in]BSTR strLocalName,
			[out, retval]BSTR* strType);"

	<virtual stdcall: hresult 15 bstr bstr bstr*>
	^self invalidCall: _failureCode!

getTypeFromQName: strQName
	"Answer the <BSTR> result of invoking the getTypeFromQName() method of the COM object.
	Helpstring: Look up an attribute's type by XML 1.0 qualified name."

	| answer |
	answer := BSTR new.
	self
		GetTypeFromQName: strQName
		strType: answer.
	^answer asObject
!

GetTypeFromQName: strQName strType: strType
	"Private - Invoke the getTypeFromQName() method of the COM object.
	Helpstring: Look up an attribute's type by XML 1.0 qualified name.

		HRESULT __stdcall getTypeFromQName(
			[in]BSTR strQName,
			[out, retval]BSTR* strType);"

	<virtual stdcall: hresult 16 bstr bstr*>
	^self invalidCall: _failureCode!

getURI: nIndex
	"Answer the <BSTR> result of invoking the getURI() method of the COM object.
	Helpstring: Look up an attribute's Namespace URI by index."

	| answer |
	answer := BSTR new.
	self
		GetURI: nIndex
		strURI: answer.
	^answer asObject
!

GetURI: nIndex strURI: strURI
	"Private - Invoke the getURI() method of the COM object.
	Helpstring: Look up an attribute's Namespace URI by index.

		HRESULT __stdcall getURI(
			[in]int nIndex,
			[out, retval]BSTR* strURI);"

	<virtual stdcall: hresult 9 sdword bstr*>
	^self invalidCall: _failureCode!

getValue: nIndex
	"Answer the <BSTR> result of invoking the getValue() method of the COM object.
	Helpstring: Look up an attribute's value by index."

	| answer |
	answer := BSTR new.
	self
		GetValue: nIndex
		strValue: answer.
	^answer asObject
!

GetValue: nIndex strValue: strValue
	"Private - Invoke the getValue() method of the COM object.
	Helpstring: Look up an attribute's value by index.

		HRESULT __stdcall getValue(
			[in]int nIndex,
			[out, retval]BSTR* strValue);"

	<virtual stdcall: hresult 17 sdword bstr*>
	^self invalidCall: _failureCode!

getValueFromName: strURI strLocalName: strLocalName
	"Answer the <BSTR> result of invoking the getValueFromName() method of the COM object.
	Helpstring: Look up an attribute's value by Namespace name."

	| answer |
	answer := BSTR new.
	self
		GetValueFromName: strURI
		strLocalName: strLocalName
		strValue: answer.
	^answer asObject
!

GetValueFromName: strURI strLocalName: strLocalName strValue: strValue
	"Private - Invoke the getValueFromName() method of the COM object.
	Helpstring: Look up an attribute's value by Namespace name.

		HRESULT __stdcall getValueFromName(
			[in]BSTR strURI,
			[in]BSTR strLocalName,
			[out, retval]BSTR* strValue);"

	<virtual stdcall: hresult 18 bstr bstr bstr*>
	^self invalidCall: _failureCode!

getValueFromQName: strQName
	"Answer the <BSTR> result of invoking the getValueFromQName() method of the COM object.
	Helpstring: Look up an attribute's value by XML 1.0 qualified name."

	| answer |
	answer := BSTR new.
	self
		GetValueFromQName: strQName
		strValue: answer.
	^answer asObject
!

GetValueFromQName: strQName strValue: strValue
	"Private - Invoke the getValueFromQName() method of the COM object.
	Helpstring: Look up an attribute's value by XML 1.0 qualified name.

		HRESULT __stdcall getValueFromQName(
			[in]BSTR strQName,
			[out, retval]BSTR* strValue);"

	<virtual stdcall: hresult 19 bstr bstr*>
	^self invalidCall: _failureCode!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^false!

isVBCollection
	"Answer whether the receiver is a VB style collection."

	^false!

length
	"Answer the <sdword> value of the 'length' property of the receiver.
	Helpstring: Get the number of attributes in the list."

	| answer |
	answer := (SDWORD new).
	self get_length: answer.
	^answer asObject
! !
!MSXML.IVBSAXAttributes categoriesFor: #get_length:!**auto generated**!COM Interfaces-IVBSAXAttributes!private! !
!MSXML.IVBSAXAttributes categoriesFor: #getIndexFromName:strLocalName:!**auto generated**!methods!public! !
!MSXML.IVBSAXAttributes categoriesFor: #GetIndexFromName:strLocalName:nIndex:!**auto generated**!COM Interfaces-IVBSAXAttributes!private! !
!MSXML.IVBSAXAttributes categoriesFor: #getIndexFromQName:!**auto generated**!methods!public! !
!MSXML.IVBSAXAttributes categoriesFor: #GetIndexFromQName:nIndex:!**auto generated**!COM Interfaces-IVBSAXAttributes!private! !
!MSXML.IVBSAXAttributes categoriesFor: #getLocalName:!**auto generated**!methods!public! !
!MSXML.IVBSAXAttributes categoriesFor: #GetLocalName:strLocalName:!**auto generated**!COM Interfaces-IVBSAXAttributes!private! !
!MSXML.IVBSAXAttributes categoriesFor: #getQName:!**auto generated**!methods!public! !
!MSXML.IVBSAXAttributes categoriesFor: #GetQName:strQName:!**auto generated**!COM Interfaces-IVBSAXAttributes!private! !
!MSXML.IVBSAXAttributes categoriesFor: #getType:!**auto generated**!methods!public! !
!MSXML.IVBSAXAttributes categoriesFor: #GetType:strType:!**auto generated**!COM Interfaces-IVBSAXAttributes!private! !
!MSXML.IVBSAXAttributes categoriesFor: #getTypeFromName:strLocalName:!**auto generated**!methods!public! !
!MSXML.IVBSAXAttributes categoriesFor: #GetTypeFromName:strLocalName:strType:!**auto generated**!COM Interfaces-IVBSAXAttributes!private! !
!MSXML.IVBSAXAttributes categoriesFor: #getTypeFromQName:!**auto generated**!methods!public! !
!MSXML.IVBSAXAttributes categoriesFor: #GetTypeFromQName:strType:!**auto generated**!COM Interfaces-IVBSAXAttributes!private! !
!MSXML.IVBSAXAttributes categoriesFor: #getURI:!**auto generated**!methods!public! !
!MSXML.IVBSAXAttributes categoriesFor: #GetURI:strURI:!**auto generated**!COM Interfaces-IVBSAXAttributes!private! !
!MSXML.IVBSAXAttributes categoriesFor: #getValue:!**auto generated**!methods!public! !
!MSXML.IVBSAXAttributes categoriesFor: #GetValue:strValue:!**auto generated**!COM Interfaces-IVBSAXAttributes!private! !
!MSXML.IVBSAXAttributes categoriesFor: #getValueFromName:strLocalName:!**auto generated**!methods!public! !
!MSXML.IVBSAXAttributes categoriesFor: #GetValueFromName:strLocalName:strValue:!**auto generated**!COM Interfaces-IVBSAXAttributes!private! !
!MSXML.IVBSAXAttributes categoriesFor: #getValueFromQName:!**auto generated**!methods!public! !
!MSXML.IVBSAXAttributes categoriesFor: #GetValueFromQName:strValue:!**auto generated**!COM Interfaces-IVBSAXAttributes!private! !
!MSXML.IVBSAXAttributes categoriesFor: #isExtensible!**auto generated**!public!testing! !
!MSXML.IVBSAXAttributes categoriesFor: #isVBCollection!**auto generated**!public!testing! !
!MSXML.IVBSAXAttributes categoriesFor: #length!**auto generated**!properties!public! !

!MSXML.IVBSAXAttributes class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSXML2.IVBSAXAttributes'
		IVBSAXAttributes defineTemplate"

	self
		defineFunction: #get_length:
			argumentTypes: 'sdword*';
		defineFunction: #GetURI:strURI:
			argumentTypes: 'sdword bstr*';
		defineFunction: #GetLocalName:strLocalName:
			argumentTypes: 'sdword bstr*';
		defineFunction: #GetQName:strQName:
			argumentTypes: 'sdword bstr*';
		defineFunction: #GetIndexFromName:strLocalName:nIndex:
			argumentTypes: 'bstr bstr sdword*';
		defineFunction: #GetIndexFromQName:nIndex:
			argumentTypes: 'bstr sdword*';
		defineFunction: #GetType:strType:
			argumentTypes: 'sdword bstr*';
		defineFunction: #GetTypeFromName:strLocalName:strType:
			argumentTypes: 'bstr bstr bstr*';
		defineFunction: #GetTypeFromQName:strType:
			argumentTypes: 'bstr bstr*';
		defineFunction: #GetValue:strValue:
			argumentTypes: 'sdword bstr*';
		defineFunction: #GetValueFromName:strLocalName:strValue:
			argumentTypes: 'bstr bstr bstr*';
		defineFunction: #GetValueFromQName:strValue:
			argumentTypes: 'bstr bstr*'
! !
!MSXML.IVBSAXAttributes class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

