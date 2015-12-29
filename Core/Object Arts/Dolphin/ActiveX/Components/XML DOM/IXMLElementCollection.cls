"Filed out from Dolphin Smalltalk X6"!

IDispatch subclass: #IXMLElementCollection
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'MSXMLConstants'
	classInstanceVariableNames: ''!
IXMLElementCollection guid: (IID fromString: '{65725580-9B5D-11D0-9BFE-00C04FC99C8E}')!
IXMLElementCollection comment: '<IXMLElementCollection> is a wrapper class for the COM interface ''MSXML2.IXMLElementCollection'' generated from type information in the ''Microsoft XML, v4.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"IXMLElementCollection helps to enumerate through a XML document tree."

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(65725580-9B5D-11D0-9BFE-00C04FC99C8E), 
	helpstring("IXMLElementCollection helps to enumerate through a XML document tree."), 
	hidden, 
	dual
]
interface IXMLElementCollection : IDispatch
 {
	[id(0x00010001), hidden, propput, restricted]
	HRESULT __stdcall length(
		[in]long p);
	[id(0x00010001), propget]
	HRESULT __stdcall length(
		[out, retval]long* p);
	[id(0xfffffffc), hidden, propget, restricted]
	HRESULT __stdcall _newEnum(
		[out, retval]IUnknown** ppUnk);
	[id(0x00010003), helpstring("get current item, or (optional) by index and name.")]
	HRESULT __stdcall item(
		[in, optional]VARIANT var1,
		[in, optional]VARIANT var2,
		[out, retval]IDispatch** ppDisp);
};
'!
!IXMLElementCollection categoriesForClass!COM-Interfaces!MSXML2-Interfaces! !
!IXMLElementCollection methodsFor!

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
	^self invalidCall!

get_length: p
	"Private - Get the value of the 'length' property of the receiver.

		HRESULT __stdcall length(
			[out, retval]long* p);"

	<virtual stdcall: hresult 9 sdword*>
	^self invalidCall!

isVBCollection
	"Answer whether the receiver is a VB style collection.
	The receiver is dynamically extensible, so we cannot determine this from the
	type library, and must perform a run-time check for the _NewEnum property."

	^true!

item
	"Answer the <IDispatch> result of invoking the item() method of the COM object.
	Default values are passed for all optional parameters."

	^self
		 item: VARIANT unspecified
		 var2: VARIANT unspecified!

item: var1 var2: var2
	"Answer the <IDispatch> result of invoking the item() method of the COM object.
	Helpstring: get current item, or (optional) by index and name."

	| answer |
	answer := IDispatch newPointer.
	self
		Item: var1 asVariant
		var2: var2 asVariant
		ppDisp: answer.
	^answer asObject
!

Item: var1 var2: var2 ppDisp: ppDisp
	"Private - Invoke the item() method of the COM object.
	Helpstring: get current item, or (optional) by index and name.

		HRESULT __stdcall item(
			[in, optional]VARIANT var1,
			[in, optional]VARIANT var2,
			[out, retval]IDispatch** ppDisp);"

	<virtual stdcall: hresult 11 variant variant IDispatch**>
	^self invalidCall!

length
	"Answer the <sdword> value of the 'length' property of the receiver."

	| answer |
	answer := (SDWORD new).
	self get_length: answer.
	^answer asObject
!

length: p
	"Set the 'length' property of the receiver to the <sdword> value of the argument."

	self put_length: p
!

put_length: p
	"Private - Set the value of the 'length' property of the object wrapped by the 
	 receiver to the <sdword> argument, p.

		HRESULT __stdcall length(
			[in]long p);"

	<virtual stdcall: hresult 8 sdword>
	^self invalidCall! !
!IXMLElementCollection categoriesFor: #_newEnum!**auto generated**!properties!public! !
!IXMLElementCollection categoriesFor: #get__newEnum:!**auto generated**!COM Interfaces-IXMLElementCollection!private! !
!IXMLElementCollection categoriesFor: #get_length:!**auto generated**!COM Interfaces-IXMLElementCollection!private! !
!IXMLElementCollection categoriesFor: #isVBCollection!**auto generated**!public!testing! !
!IXMLElementCollection categoriesFor: #item!**auto generated**!methods!public! !
!IXMLElementCollection categoriesFor: #item:var2:!**auto generated**!methods!public! !
!IXMLElementCollection categoriesFor: #Item:var2:ppDisp:!**auto generated**!COM Interfaces-IXMLElementCollection!private! !
!IXMLElementCollection categoriesFor: #length!**auto generated**!properties!public! !
!IXMLElementCollection categoriesFor: #length:!**auto generated**!properties!public! !
!IXMLElementCollection categoriesFor: #put_length:!**auto generated**!COM Interfaces-IXMLElementCollection!private! !

!IXMLElementCollection class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSXML2.IXMLElementCollection'
		IXMLElementCollection defineTemplate"

	self
		defineFunction: #put_length:
			argumentTypes: 'sdword';
		defineFunction: #get_length:
			argumentTypes: 'sdword*';
		defineFunction: #get__newEnum:
			argumentTypes: 'IUnknown**';
		defineFunction: #Item:var2:ppDisp:
			argumentTypes: 'variant variant IDispatch**'
! !
!IXMLElementCollection class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

