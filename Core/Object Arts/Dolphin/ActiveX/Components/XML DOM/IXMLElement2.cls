"Filed out from Dolphin Smalltalk X6"!

IXMLElement subclass: #IXMLElement2
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'MSXMLConstants'
	classInstanceVariableNames: ''!
IXMLElement2 guid: (IID fromString: '{2B8DE2FF-8D2D-11D1-B2FC-00C04FD915A9}')!
IXMLElement2 comment: '<IXMLElement2> is a wrapper class for the COM interface ''MSXML2.IXMLElement2'' generated from type information in the ''Microsoft XML, v4.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"IXMLElement2 extends IXMLElement."

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(2B8DE2FF-8D2D-11D1-B2FC-00C04FD915A9), 
	helpstring("IXMLElement2 extends IXMLElement."), 
	hidden, 
	dual
]
interface IXMLElement2 : IDispatch
 {
	[id(0x000100c9), propget, helpstring("get tag name.")]
	HRESULT __stdcall tagName(
		[out, retval]BSTR* p);
	[id(0x000100c9), propput, helpstring("get tag name.")]
	HRESULT __stdcall tagName(
		[in]BSTR p);
	[id(0x000100ca), propget, helpstring("get parent IXMLElement.")]
	HRESULT __stdcall parent(
		[out, retval]IXMLElement2** ppParent);
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
	[id(0x000100ce), propget, helpstring("get a IXMLElementCollection of all children.")]
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
		[in]IXMLElement2* pChildElem,
		long lIndex,
		long lReserved);
	[id(0x000100d2), helpstring("remove a child.")]
	HRESULT __stdcall removeChild(
		[in]IXMLElement2* pChildElem);
	[id(0x000100d3), propget, helpstring("get a IXMLElementCollection of all attributes.")]
	HRESULT __stdcall attributes(
		[out, retval]IXMLElementCollection** pp);
};
'!
!IXMLElement2 categoriesForClass!COM-Interfaces!MSXML2-Interfaces! !
!IXMLElement2 methodsFor!

AddChild: pChildElem lIndex: lIndex lReserved: lReserved
	"Invoke the addChild() method of the COM object.
	Helpstring: add a child.

		HRESULT __stdcall addChild(
			[in]IXMLElement2* pChildElem,
			long lIndex,
			long lReserved);"

	<virtual stdcall: hresult 18 IXMLElement2* sdword sdword>
	^self invalidCall!

attributes
	"Answer the <IXMLElementCollection> value of the 'attributes' property of the receiver.
	Helpstring: get a IXMLElementCollection of all attributes."

	| answer |
	answer := IXMLElementCollection newPointer.
	self get_attributes: answer.
	^answer asObject
!

get_attributes: pp
	"Private - Get the value of the 'attributes' property of the receiver.

		HRESULT __stdcall attributes(
			[out, retval]IXMLElementCollection** pp);"

	<virtual stdcall: hresult 20 IXMLElementCollection**>
	^self invalidCall!

get_parent: ppParent
	"Private - Get the value of the 'parent' property of the receiver.

		HRESULT __stdcall parent(
			[out, retval]IXMLElement2** ppParent);"

	<virtual stdcall: hresult 10 IXMLElement2**>
	^self invalidCall!

parent
	"Answer the <IXMLElement2> value of the 'parent' property of the receiver.
	Helpstring: get parent IXMLElement."

	| answer |
	answer := IXMLElement2 newPointer.
	self get_parent: answer.
	^answer asObject
!

RemoveChild: pChildElem
	"Invoke the removeChild() method of the COM object.
	Helpstring: remove a child.

		HRESULT __stdcall removeChild(
			[in]IXMLElement2* pChildElem);"

	<virtual stdcall: hresult 19 IXMLElement2*>
	^self invalidCall! !
!IXMLElement2 categoriesFor: #AddChild:lIndex:lReserved:!**auto generated**!COM Interfaces-IXMLElement2!public! !
!IXMLElement2 categoriesFor: #attributes!**auto generated**!properties!public! !
!IXMLElement2 categoriesFor: #get_attributes:!**auto generated**!COM Interfaces-IXMLElement2!private! !
!IXMLElement2 categoriesFor: #get_parent:!**auto generated**!COM Interfaces-IXMLElement2!private! !
!IXMLElement2 categoriesFor: #parent!**auto generated**!properties!public! !
!IXMLElement2 categoriesFor: #RemoveChild:!**auto generated**!COM Interfaces-IXMLElement2!public! !

!IXMLElement2 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSXML2.IXMLElement2'
		IXMLElement2 defineTemplate"

	self
		defineFunction: #get_tagName:
			argumentTypes: 'bstr*';
		defineFunction: #put_tagName:
			argumentTypes: 'bstr';
		defineFunction: #get_parent:
			argumentTypes: 'IXMLElement2**';
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
			argumentTypes: 'IXMLElement2* sdword sdword';
		defineFunction: #RemoveChild:
			argumentTypes: 'IXMLElement2*';
		defineFunction: #get_attributes:
			argumentTypes: 'IXMLElementCollection**'
! !
!IXMLElement2 class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

