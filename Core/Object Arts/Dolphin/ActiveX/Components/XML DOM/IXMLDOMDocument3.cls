"Filed out from Dolphin Smalltalk 7"!

IXMLDOMDocument2 subclass: #IXMLDOMDocument3
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'MSXMLConstants'
	classInstanceVariableNames: ''
	classConstants: {}!
IXMLDOMDocument3 guid: (IID fromString: '{2933bf96-7b36-11d2-b20e-00c04f983e60}')!
IXMLDOMDocument3 comment: '<IXMLDOMDocument3> is a wrapper class for the COM interface ''MSXML2.IXMLDOMDocument3'' generated from type information in the ''Microsoft XML, v6.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(2933BF96-7B36-11D2-B20E-00C04F983E60), 
	nonextensible, 
	dual
]
interface IXMLDOMDocument3 : IXMLDOMDocument2
 {
	[id(0x000000d0), helpstring("perform runtime validation on the currently loaded XML document node")]
	HRESULT __stdcall validateNode(
		[in]IXMLDOMNode* node,
		[out, retval]IXMLDOMParseError** errorObj);
	[id(0x000000d1), helpstring("clone node such that clones ownerDocument is this document")]
	HRESULT __stdcall importNode(
		[in]IXMLDOMNode* node,
		[in]VARIANT_BOOL deep,
		[out, retval]IXMLDOMNode** clone);
};
'!
!IXMLDOMDocument3 categoriesForClass!COM-Interfaces!MSXML2-Interfaces! !
!IXMLDOMDocument3 methodsFor!

importNode: node deep: deep
	"Answer the <IXMLDOMNode> result of invoking the importNode() method of the COM object.
	Helpstring: clone node such that clones ownerDocument is this document"

	| answer |
	answer := IXMLDOMNode newPointer.
	self
		ImportNode: node
		deep: deep
		clone: answer.
	^answer asObject
!

ImportNode: node deep: deep clone: clone
	"Private - Invoke the importNode() method of the COM object.
	Helpstring: clone node such that clones ownerDocument is this document

		HRESULT __stdcall importNode(
			[in]IXMLDOMNode* node,
			[in]VARIANT_BOOL deep,
			[out, retval]IXMLDOMNode** clone);"

	<virtual stdcall: hresult 84 IXMLDOMNode* varbool IXMLDOMNode**>
	^self invalidCall: _failureCode!

validateNode: node
	"Answer the <IXMLDOMParseError> result of invoking the validateNode() method of the COM object.
	Helpstring: perform runtime validation on the currently loaded XML document node"

	| answer |
	answer := IXMLDOMParseError newPointer.
	self
		ValidateNode: node
		errorObj: answer.
	^answer asObject
!

ValidateNode: node errorObj: errorObj
	"Private - Invoke the validateNode() method of the COM object.
	Helpstring: perform runtime validation on the currently loaded XML document node

		HRESULT __stdcall validateNode(
			[in]IXMLDOMNode* node,
			[out, retval]IXMLDOMParseError** errorObj);"

	<virtual stdcall: hresult 83 IXMLDOMNode* IXMLDOMParseError**>
	^self invalidCall: _failureCode! !
!IXMLDOMDocument3 categoriesFor: #importNode:deep:!**auto generated**!methods!public! !
!IXMLDOMDocument3 categoriesFor: #ImportNode:deep:clone:!**auto generated**!COM Interfaces-IXMLDOMDocument3!private! !
!IXMLDOMDocument3 categoriesFor: #validateNode:!**auto generated**!methods!public! !
!IXMLDOMDocument3 categoriesFor: #ValidateNode:errorObj:!**auto generated**!COM Interfaces-IXMLDOMDocument3!private! !

!IXMLDOMDocument3 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSXML2.IXMLDOMDocument3'
		IXMLDOMDocument3 defineTemplate"

	self
		defineFunction: #ValidateNode:errorObj:
			argumentTypes: 'IXMLDOMNode* IXMLDOMParseError**';
		defineFunction: #ImportNode:deep:clone:
			argumentTypes: 'IXMLDOMNode* varbool IXMLDOMNode**'
!

newDOMDocument60
	"Answer a new instance of the receiver on the DOMDocument60 COM object"

	^self onCLSID: (CLSID fromString: '{88D96A05-F192-11D4-A65F-0040963251E5}')
!

newFreeThreadedDOMDocument60
	"Answer a new instance of the receiver on the FreeThreadedDOMDocument60 COM object"

	^self onCLSID: (CLSID fromString: '{88D96A06-F192-11D4-A65F-0040963251E5}')
! !
!IXMLDOMDocument3 class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!IXMLDOMDocument3 class categoriesFor: #newDOMDocument60!**auto generated**!instance creation!public! !
!IXMLDOMDocument3 class categoriesFor: #newFreeThreadedDOMDocument60!**auto generated**!instance creation!public! !

