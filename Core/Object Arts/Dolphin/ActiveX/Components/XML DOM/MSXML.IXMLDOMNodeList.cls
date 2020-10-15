"Filed out from Dolphin Smalltalk 7"!

OS.COM.IDispatch subclass: #'MSXML.IXMLDOMNodeList'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
MSXML.IXMLDOMNodeList guid: (OS.COM.IID fromString: '{2933bf82-7b36-11d2-b20e-00c04f983e60}')!
MSXML.IXMLDOMNodeList comment: '<IXMLDOMNodeList> is a wrapper class for the COM interface ''MSXML.IXMLDOMNodeList'' generated from type information in the ''Microsoft XML, version 2.0'' library. It contains methods to invoke the member functions exposed by that interface.

IXMLDOMNodeList is used as the result of DOM methods that can return lists of nodes. We always wrap these with a further object (an instance of DOMNodeList) which implements the full node list protocol, but is also a <sequencedReadableCollection>, and which is therefore much more useful in Smalltalk. For this reason all high-level wrapper methods have been removed from this class.'!
!MSXML.IXMLDOMNodeList categoriesForClass!COM-Interfaces!MSXML-Interfaces! !
!MSXML.IXMLDOMNodeList methodsFor!

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

get_item: index listItem: listItem
	"Private - Get the value of the 'item' property of the receiver.

		HRESULT __stdcall item(
			[in]long index,
			[out, retval]IXMLDOMNode** listItem);"

	<virtual stdcall: hresult 8 sdword IXMLDOMNode**>
	^self invalidCall: _failureCode!

get_length: listLength
	"Private - Get the value of the 'length' property of the receiver.

		HRESULT __stdcall length(
			[out, retval]long* listLength);"

	<virtual stdcall: hresult 9 sdword*>
	^self invalidCall: _failureCode!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^false!

isVBCollection
	"Answer whether the receiver is a VB style collection."

	^true!

item: index
	"Answer the <IXMLDOMNode> value of the 'item' property of the receiver.
	Helpstring: collection of nodes"

	| answer |
	answer := IXMLDOMNode newPointer.
	self get_item: index listItem: answer.
	^answer asObject!

length
	"Answer the <sdword> value of the 'length' property of the receiver.
	Helpstring: number of nodes in the collection"

	| answer |
	answer := SDWORD new.
	self get_length: answer.
	^answer asObject!

nextNode
	"Answer the <IXMLDOMNode> result of invoking the nextNode() method of the COM object.
	Helpstring: get next node from iterator"

	| answer |
	answer := IXMLDOMNode newPointer.
	self NextNode: answer.
	^answer asObject!

NextNode: nextItem
	"Private - Invoke the nextNode() method of the COM object.
	Helpstring: get next node from iterator

		HRESULT __stdcall nextNode(
			[out, retval]IXMLDOMNode** nextItem);"

	<virtual stdcall: hresult 10 IXMLDOMNode**>
	^self invalidCall: _failureCode!

Reset
	"Invoke the reset() method of the COM object.
	Helpstring: reset the position of iterator

		HRESULT __stdcall reset();"

	<virtual stdcall: hresult 11>
	^self invalidCall: _failureCode! !
!MSXML.IXMLDOMNodeList categoriesFor: #_newEnum!**auto generated**!properties!public! !
!MSXML.IXMLDOMNodeList categoriesFor: #get__newEnum:!**auto generated**!COM Interfaces-IXMLDOMNodeList!private! !
!MSXML.IXMLDOMNodeList categoriesFor: #get_item:listItem:!**auto generated**!COM Interfaces-IXMLDOMNodeList!private! !
!MSXML.IXMLDOMNodeList categoriesFor: #get_length:!**auto generated**!COM Interfaces-IXMLDOMNodeList!private! !
!MSXML.IXMLDOMNodeList categoriesFor: #isExtensible!**auto generated**!public!testing! !
!MSXML.IXMLDOMNodeList categoriesFor: #isVBCollection!**auto generated**!public!testing! !
!MSXML.IXMLDOMNodeList categoriesFor: #item:!**auto generated**!properties!public! !
!MSXML.IXMLDOMNodeList categoriesFor: #length!**auto generated**!properties!public! !
!MSXML.IXMLDOMNodeList categoriesFor: #nextNode!**auto generated**!methods!public! !
!MSXML.IXMLDOMNodeList categoriesFor: #NextNode:!**auto generated**!COM Interfaces-IXMLDOMNodeList!private! !
!MSXML.IXMLDOMNodeList categoriesFor: #Reset!**auto generated**!COM Interfaces-IXMLDOMNodeList!public! !

!MSXML.IXMLDOMNodeList class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSXML2.IXMLDOMNodeList'
		IXMLDOMNodeList defineTemplate"

	self
		defineFunction: #get_item:listItem:
			argumentTypes: 'sdword IXMLDOMNode**';
		defineFunction: #get_length:
			argumentTypes: 'sdword*';
		defineFunction: #NextNode:
			argumentTypes: 'IXMLDOMNode**';
		defineFunction: #Reset;
		defineFunction: #get__newEnum:
			argumentTypes: 'IUnknown**'
! !
!MSXML.IXMLDOMNodeList class categoriesFor: #defineFunctions!**auto generated**!initializing!private! !

