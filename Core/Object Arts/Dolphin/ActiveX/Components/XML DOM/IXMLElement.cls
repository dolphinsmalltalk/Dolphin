"Filed out from Dolphin Smalltalk 7"!

IDispatch subclass: #IXMLElement
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'MSXMLConstants'
	classInstanceVariableNames: ''!
IXMLElement guid: (IID fromString: '{3F7F31AC-E15F-11D0-9C25-00C04FC99C8E}')!
IXMLElement comment: '<IXMLElement> is a wrapper class for the COM interface ''MSXML2.IXMLElement'' generated from type information in the ''Microsoft XML, v4.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"IXMLElement represents an element in the XML document tree."

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(3F7F31AC-E15F-11D0-9C25-00C04FC99C8E), 
	helpstring("IXMLElement represents an element in the XML document tree."), 
	hidden, 
	dual
]
interface IXMLElement : IDispatch
 {
	[id(0x000100c9), propget, helpstring("get tag name.")]
	HRESULT __stdcall tagName(
		[out, retval]BSTR* p);
	[id(0x000100c9), propput, helpstring("get tag name.")]
	HRESULT __stdcall tagName(
		[in]BSTR p);
	[id(0x000100ca), propget, helpstring("get parent IXMLElement.")]
	HRESULT __stdcall parent(
		[out, retval]IXMLElement** ppParent);
	[id(0x000100cb), helpstring("set attribute.")]
	HRESULT __stdcall setAttribute(
		[in]BSTR strPropertyName,
		[in]VARIANT PropertyValue);
	[id(0x000100cc), helpstring("get attribute.")]
	HRESULT __stdcall getAttribute(
		[in]BSTR strPropertyName,
		[out, retval]VARIANT* PropertyValue);
	[id(0x000100cd), helpstring("remove attribute.")]
	HRESULT __stdcall removeAttribute(
		[in]BSTR strPropertyName);
	[id(0x000100ce), propget, helpstring("get a IXMLElementCollection of children.")]
	HRESULT __stdcall children(
		[out, retval]IXMLElementCollection** pp);
	[id(0x000100cf), propget, helpstring("get type of this IXMLElement.")]
	HRESULT __stdcall type(
		[out, retval]long* plType);
	[id(0x000100d0), propget, helpstring("get text.")]
	HRESULT __stdcall text(
		[out, retval]BSTR* p);
	[id(0x000100d0), propput, helpstring("get text.")]
	HRESULT __stdcall text(
		[in]BSTR p);
	[id(0x000100d1), helpstring("add a child.")]
	HRESULT __stdcall addChild(
		[in]IXMLElement* pChildElem,
		long lIndex,
		long lReserved);
	[id(0x000100d2), helpstring("remove a child.")]
	HRESULT __stdcall removeChild(
		[in]IXMLElement* pChildElem);
};
'!
!IXMLElement categoriesForClass!COM-Interfaces!MSXML2-Interfaces! !
!IXMLElement methodsFor!

AddChild: pChildElem lIndex: lIndex lReserved: lReserved
	"Invoke the addChild() method of the COM object.
	Helpstring: add a child.

		HRESULT __stdcall addChild(
			[in]IXMLElement* pChildElem,
			long lIndex,
			long lReserved);"

	<virtual stdcall: hresult 18 IXMLElement* sdword sdword>
	^self invalidCall!

children
	"Answer the <IXMLElementCollection> value of the 'children' property of the receiver.
	Helpstring: get a IXMLElementCollection of children."

	| answer |
	answer := IXMLElementCollection newPointer.
	self get_children: answer.
	^answer asObject
!

get_children: pp
	"Private - Get the value of the 'children' property of the receiver.

		HRESULT __stdcall children(
			[out, retval]IXMLElementCollection** pp);"

	<virtual stdcall: hresult 14 IXMLElementCollection**>
	^self invalidCall!

get_parent: ppParent
	"Private - Get the value of the 'parent' property of the receiver.

		HRESULT __stdcall parent(
			[out, retval]IXMLElement** ppParent);"

	<virtual stdcall: hresult 10 IXMLElement**>
	^self invalidCall!

get_tagName: p
	"Private - Get the value of the 'tagName' property of the receiver.

		HRESULT __stdcall tagName(
			[out, retval]BSTR* p);"

	<virtual stdcall: hresult 8 bstr*>
	^self invalidCall!

get_text: p
	"Private - Get the value of the 'text' property of the receiver.

		HRESULT __stdcall text(
			[out, retval]BSTR* p);"

	<virtual stdcall: hresult 16 bstr*>
	^self invalidCall!

get_type: plType
	"Private - Get the value of the 'type' property of the receiver.

		HRESULT __stdcall type(
			[out, retval]long* plType);"

	<virtual stdcall: hresult 15 sdword*>
	^self invalidCall!

getAttribute: strPropertyName
	"Answer the <VARIANT> result of invoking the getAttribute() method of the COM object.
	Helpstring: get attribute."

	| answer |
	answer := VARIANT new.
	self
		GetAttribute: strPropertyName
		propertyValue: answer.
	^answer asObject
!

GetAttribute: strPropertyName propertyValue: propertyValue
	"Private - Invoke the getAttribute() method of the COM object.
	Helpstring: get attribute.

		HRESULT __stdcall getAttribute(
			[in]BSTR strPropertyName,
			[out, retval]VARIANT* PropertyValue);"

	<virtual stdcall: hresult 12 bstr variant*>
	^self invalidCall!

parent
	"Answer the <IXMLElement> value of the 'parent' property of the receiver.
	Helpstring: get parent IXMLElement."

	| answer |
	answer := IXMLElement newPointer.
	self get_parent: answer.
	^answer asObject
!

put_tagName: p
	"Private - Set the value of the 'tagName' property of the object wrapped by the 
	 receiver to the <bstr> argument, p.

		HRESULT __stdcall tagName(
			[in]BSTR p);"

	<virtual stdcall: hresult 9 bstr>
	^self invalidCall!

put_text: p
	"Private - Set the value of the 'text' property of the object wrapped by the 
	 receiver to the <bstr> argument, p.

		HRESULT __stdcall text(
			[in]BSTR p);"

	<virtual stdcall: hresult 17 bstr>
	^self invalidCall!

RemoveAttribute: strPropertyName
	"Invoke the removeAttribute() method of the COM object.
	Helpstring: remove attribute.

		HRESULT __stdcall removeAttribute(
			[in]BSTR strPropertyName);"

	<virtual stdcall: hresult 13 bstr>
	^self invalidCall!

RemoveChild: pChildElem
	"Invoke the removeChild() method of the COM object.
	Helpstring: remove a child.

		HRESULT __stdcall removeChild(
			[in]IXMLElement* pChildElem);"

	<virtual stdcall: hresult 19 IXMLElement*>
	^self invalidCall!

setAttribute: strPropertyName propertyValue: propertyValue
	"Invoke the setAttribute() method of the COM object.
	Helpstring: set attribute."

	^self
		SetAttribute: strPropertyName
		propertyValue: propertyValue asVariant
!

SetAttribute: strPropertyName propertyValue: propertyValue
	"Private - Invoke the setAttribute() method of the COM object.
	Helpstring: set attribute.

		HRESULT __stdcall setAttribute(
			[in]BSTR strPropertyName,
			[in]VARIANT PropertyValue);"

	<virtual stdcall: hresult 11 bstr variant>
	^self invalidCall!

tagName
	"Answer the <bstr> value of the 'tagName' property of the receiver.
	Helpstring: get tag name."

	| answer |
	answer := BSTR new.
	self get_tagName: answer.
	^answer asObject
!

tagName: p
	"Set the 'tagName' property of the receiver to the <bstr> value of the argument.
	Helpstring: get tag name."

	self put_tagName: p
!

text
	"Answer the <bstr> value of the 'text' property of the receiver.
	Helpstring: get text."

	| answer |
	answer := BSTR new.
	self get_text: answer.
	^answer asObject
!

text: p
	"Set the 'text' property of the receiver to the <bstr> value of the argument.
	Helpstring: get text."

	self put_text: p
!

type
	"Answer the <sdword> value of the 'type' property of the receiver.
	Helpstring: get type of this IXMLElement."

	| answer |
	answer := (SDWORD new).
	self get_type: answer.
	^answer asObject
! !
!IXMLElement categoriesFor: #AddChild:lIndex:lReserved:!**auto generated**!COM Interfaces-IXMLElement!public! !
!IXMLElement categoriesFor: #children!**auto generated**!properties!public! !
!IXMLElement categoriesFor: #get_children:!**auto generated**!COM Interfaces-IXMLElement!private! !
!IXMLElement categoriesFor: #get_parent:!**auto generated**!COM Interfaces-IXMLElement!private! !
!IXMLElement categoriesFor: #get_tagName:!**auto generated**!COM Interfaces-IXMLElement!private! !
!IXMLElement categoriesFor: #get_text:!**auto generated**!COM Interfaces-IXMLElement!private! !
!IXMLElement categoriesFor: #get_type:!**auto generated**!COM Interfaces-IXMLElement!private! !
!IXMLElement categoriesFor: #getAttribute:!**auto generated**!methods!public! !
!IXMLElement categoriesFor: #GetAttribute:propertyValue:!**auto generated**!COM Interfaces-IXMLElement!private! !
!IXMLElement categoriesFor: #parent!**auto generated**!properties!public! !
!IXMLElement categoriesFor: #put_tagName:!**auto generated**!COM Interfaces-IXMLElement!private! !
!IXMLElement categoriesFor: #put_text:!**auto generated**!COM Interfaces-IXMLElement!private! !
!IXMLElement categoriesFor: #RemoveAttribute:!**auto generated**!COM Interfaces-IXMLElement!public! !
!IXMLElement categoriesFor: #RemoveChild:!**auto generated**!COM Interfaces-IXMLElement!public! !
!IXMLElement categoriesFor: #setAttribute:propertyValue:!**auto generated**!methods!public! !
!IXMLElement categoriesFor: #SetAttribute:propertyValue:!**auto generated**!COM Interfaces-IXMLElement!private! !
!IXMLElement categoriesFor: #tagName!**auto generated**!properties!public! !
!IXMLElement categoriesFor: #tagName:!**auto generated**!properties!public! !
!IXMLElement categoriesFor: #text!**auto generated**!properties!public! !
!IXMLElement categoriesFor: #text:!**auto generated**!properties!public! !
!IXMLElement categoriesFor: #type!**auto generated**!properties!public! !

!IXMLElement class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSXML2.IXMLElement'
		IXMLElement defineTemplate"

	self
		defineFunction: #get_tagName:
			argumentTypes: 'bstr*';
		defineFunction: #put_tagName:
			argumentTypes: 'bstr';
		defineFunction: #get_parent:
			argumentTypes: 'IXMLElement**';
		defineFunction: #SetAttribute:propertyValue:
			argumentTypes: 'bstr variant';
		defineFunction: #GetAttribute:propertyValue:
			argumentTypes: 'bstr variant*';
		defineFunction: #RemoveAttribute:
			argumentTypes: 'bstr';
		defineFunction: #get_children:
			argumentTypes: 'IXMLElementCollection**';
		defineFunction: #get_type:
			argumentTypes: 'sdword*';
		defineFunction: #get_text:
			argumentTypes: 'bstr*';
		defineFunction: #put_text:
			argumentTypes: 'bstr';
		defineFunction: #AddChild:lIndex:lReserved:
			argumentTypes: 'IXMLElement* sdword sdword';
		defineFunction: #RemoveChild:
			argumentTypes: 'IXMLElement*'
! !
!IXMLElement class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

