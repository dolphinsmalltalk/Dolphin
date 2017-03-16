"Filed out from Dolphin Smalltalk 7"!

IDispatch subclass: #IXMLAttribute
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'MSXMLConstants'
	classInstanceVariableNames: ''!
IXMLAttribute guid: (IID fromString: '{D4D4A0FC-3B73-11D1-B2B4-00C04FB92596}')!
IXMLAttribute comment: '<IXMLAttribute> is a wrapper class for the COM interface ''MSXML2.IXMLAttribute'' generated from type information in the ''Microsoft XML, v4.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"IXMLAttribute allows to get attributes of an IXMLElement."

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(D4D4A0FC-3B73-11D1-B2B4-00C04FB92596), 
	helpstring("IXMLAttribute allows to get attributes of an IXMLElement."), 
	hidden, 
	dual
]
interface IXMLAttribute : IDispatch
 {
	[id(0x00010191), propget, helpstring("get attribute name.")]
	HRESULT __stdcall name(
		[out, retval]BSTR* n);
	[id(0x00010192), propget, helpstring("get attribute value.")]
	HRESULT __stdcall value(
		[out, retval]BSTR* v);
};
'!
!IXMLAttribute categoriesForClass!COM-Interfaces!MSXML2-Interfaces! !
!IXMLAttribute methodsFor!

get_name: n
	"Private - Get the value of the 'name' property of the receiver.

		HRESULT __stdcall name(
			[out, retval]BSTR* n);"

	<virtual stdcall: hresult 8 bstr*>
	^self invalidCall!

get_value: v
	"Private - Get the value of the 'value' property of the receiver.

		HRESULT __stdcall value(
			[out, retval]BSTR* v);"

	<virtual stdcall: hresult 9 bstr*>
	^self invalidCall!

name
	"Answer the <bstr> value of the 'name' property of the receiver.
	Helpstring: get attribute name."

	| answer |
	answer := BSTR new.
	self get_name: answer.
	^answer asObject
!

value
	"Answer the <bstr> value of the 'value' property of the receiver.
	Helpstring: get attribute value."

	| answer |
	answer := BSTR new.
	self get_value: answer.
	^answer asObject
! !
!IXMLAttribute categoriesFor: #get_name:!**auto generated**!COM Interfaces-IXMLAttribute!private! !
!IXMLAttribute categoriesFor: #get_value:!**auto generated**!COM Interfaces-IXMLAttribute!private! !
!IXMLAttribute categoriesFor: #name!**auto generated**!properties!public! !
!IXMLAttribute categoriesFor: #value!**auto generated**!properties!public! !

!IXMLAttribute class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSXML2.IXMLAttribute'
		IXMLAttribute defineTemplate"

	self
		defineFunction: #get_name:
			argumentTypes: 'bstr*';
		defineFunction: #get_value:
			argumentTypes: 'bstr*'
! !
!IXMLAttribute class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

