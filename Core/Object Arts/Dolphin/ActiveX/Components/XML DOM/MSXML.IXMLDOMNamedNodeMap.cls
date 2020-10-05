"Filed out from Dolphin Smalltalk 7"!

IDispatch subclass: #IXMLDOMNamedNodeMap
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'MSXMLConstants'
	classInstanceVariableNames: ''
	classConstants: {}!
IXMLDOMNamedNodeMap guid: (IID fromString: '{2933bf83-7b36-11d2-b20e-00c04f983e60}')!
IXMLDOMNamedNodeMap comment: '<IXMLDOMNamedNodeMap> is a wrapper class for the COM interface ''MSXML.IXMLDOMNamedNodeMap'' generated from type information in the ''Microsoft XML, version 2.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

IXMLDOMNamedNodeMap is used as the result of DOM methods that can return dictionary of nodes. We always wrap these with a further object (a subinstance of DOMNamedNodeMap) which implements the full node map protocol, but which is also specialized to the type of the nodes stored there-in, and implements <abstractDictionary>, which makes it much more useful in Smalltalk. For this reason all high-level wrapper methods have been removed from this class.

Note that node maps support access by both string (node name) and integer (positional) keys, i.e. they are ordered, unlike traditional Smalltalk dictionaries. Node maps also include support for namespaces.'!
!IXMLDOMNamedNodeMap categoriesForClass!COM-Interfaces!MSXML-Interfaces! !
!IXMLDOMNamedNodeMap methodsFor!

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

	<virtual stdcall: hresult 17 IUnknown**>
	^self invalidCall: _failureCode!

get_item: index listItem: listItem
	"Private - Get the value of the 'item' property of the receiver.

		HRESULT __stdcall item(
			[in]long index,
			[out, retval]IXMLDOMNode** listItem);"

	<virtual stdcall: hresult 11 sdword IXMLDOMNode**>
	^self invalidCall: _failureCode!

get_length: listLength
	"Private - Get the value of the 'length' property of the receiver.

		HRESULT __stdcall length(
			[out, retval]long* listLength);"

	<virtual stdcall: hresult 12 sdword*>
	^self invalidCall: _failureCode!

getNamedItem: name
	"Answer the <IXMLDOMNode> result of invoking the getNamedItem() method of the COM object.
	Helpstring: lookup item by name"

	| answer |
	answer := IXMLDOMNode newPointer.
	self
		GetNamedItem: name
		namedItem: answer.
	^answer asObject
!

GetNamedItem: name namedItem: namedItem
	"Private - Invoke the getNamedItem() method of the COM object.
	Helpstring: lookup item by name

		HRESULT __stdcall getNamedItem(
			[in]BSTR name,
			[out, retval]IXMLDOMNode** namedItem);"

	<virtual stdcall: hresult 8 bstr IXMLDOMNode**>
	^self invalidCall: _failureCode!

getQualifiedItem: baseName namespaceURI: namespaceURI
	"Answer the <IXMLDOMNode> result of invoking the getQualifiedItem() method of the COM object.
	Helpstring: lookup the item by name and namespace"

	| answer |
	answer := IXMLDOMNode newPointer.
	self
		GetQualifiedItem: baseName
		namespaceURI: namespaceURI
		qualifiedItem: answer.
	^answer asObject
!

GetQualifiedItem: baseName namespaceURI: namespaceURI qualifiedItem: qualifiedItem
	"Private - Invoke the getQualifiedItem() method of the COM object.
	Helpstring: lookup the item by name and namespace

		HRESULT __stdcall getQualifiedItem(
			[in]BSTR baseName,
			[in]BSTR namespaceURI,
			[out, retval]IXMLDOMNode** qualifiedItem);"

	<virtual stdcall: hresult 13 bstr bstr IXMLDOMNode**>
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
	self
		get_item: index
		listItem: answer.
	^answer asObject
!

length
	"Answer the <sdword> value of the 'length' property of the receiver.
	Helpstring: number of nodes in the collection"

	| answer |
	answer := (SDWORD new).
	self get_length: answer.
	^answer asObject
!

nextNode
	"Answer the <IXMLDOMNode> result of invoking the nextNode() method of the COM object.
	Helpstring: get next node from iterator"

	| answer |
	answer := IXMLDOMNode newPointer.
	self NextNode: answer.
	^answer asObject
!

NextNode: nextItem
	"Private - Invoke the nextNode() method of the COM object.
	Helpstring: get next node from iterator

		HRESULT __stdcall nextNode(
			[out, retval]IXMLDOMNode** nextItem);"

	<virtual stdcall: hresult 15 IXMLDOMNode**>
	^self invalidCall: _failureCode!

removeNamedItem: name
	"Answer the <IXMLDOMNode> result of invoking the removeNamedItem() method of the COM object.
	Helpstring: remove item by name"

	| answer |
	answer := IXMLDOMNode newPointer.
	self
		RemoveNamedItem: name
		namedItem: answer.
	^answer asObject
!

RemoveNamedItem: name namedItem: namedItem
	"Private - Invoke the removeNamedItem() method of the COM object.
	Helpstring: remove item by name

		HRESULT __stdcall removeNamedItem(
			[in]BSTR name,
			[out, retval]IXMLDOMNode** namedItem);"

	<virtual stdcall: hresult 10 bstr IXMLDOMNode**>
	^self invalidCall: _failureCode!

removeQualifiedItem: baseName namespaceURI: namespaceURI
	"Answer the <IXMLDOMNode> result of invoking the removeQualifiedItem() method of the COM object.
	Helpstring: remove the item by name and namespace"

	| answer |
	answer := IXMLDOMNode newPointer.
	self
		RemoveQualifiedItem: baseName
		namespaceURI: namespaceURI
		qualifiedItem: answer.
	^answer asObject
!

RemoveQualifiedItem: baseName namespaceURI: namespaceURI qualifiedItem: qualifiedItem
	"Private - Invoke the removeQualifiedItem() method of the COM object.
	Helpstring: remove the item by name and namespace

		HRESULT __stdcall removeQualifiedItem(
			[in]BSTR baseName,
			[in]BSTR namespaceURI,
			[out, retval]IXMLDOMNode** qualifiedItem);"

	<virtual stdcall: hresult 14 bstr bstr IXMLDOMNode**>
	^self invalidCall: _failureCode!

Reset
	"Invoke the reset() method of the COM object.
	Helpstring: reset the position of iterator

		HRESULT __stdcall reset();"

	<virtual stdcall: hresult 16>
	^self invalidCall: _failureCode!

setNamedItem: newItem
	"Answer the <IXMLDOMNode> result of invoking the setNamedItem() method of the COM object.
	Helpstring: set item by name"

	| answer |
	answer := IXMLDOMNode newPointer.
	self
		SetNamedItem: newItem
		nameItem: answer.
	^answer asObject
!

SetNamedItem: newItem nameItem: nameItem
	"Private - Invoke the setNamedItem() method of the COM object.
	Helpstring: set item by name

		HRESULT __stdcall setNamedItem(
			[in]IXMLDOMNode* newItem,
			[out, retval]IXMLDOMNode** nameItem);"

	<virtual stdcall: hresult 9 IXMLDOMNode* IXMLDOMNode**>
	^self invalidCall: _failureCode! !
!IXMLDOMNamedNodeMap categoriesFor: #_newEnum!**auto generated**!properties!public! !
!IXMLDOMNamedNodeMap categoriesFor: #get__newEnum:!**auto generated**!COM Interfaces-IXMLDOMNamedNodeMap!private! !
!IXMLDOMNamedNodeMap categoriesFor: #get_item:listItem:!**auto generated**!COM Interfaces-IXMLDOMNamedNodeMap!private! !
!IXMLDOMNamedNodeMap categoriesFor: #get_length:!**auto generated**!COM Interfaces-IXMLDOMNamedNodeMap!private! !
!IXMLDOMNamedNodeMap categoriesFor: #getNamedItem:!**auto generated**!methods!public! !
!IXMLDOMNamedNodeMap categoriesFor: #GetNamedItem:namedItem:!**auto generated**!COM Interfaces-IXMLDOMNamedNodeMap!private! !
!IXMLDOMNamedNodeMap categoriesFor: #getQualifiedItem:namespaceURI:!**auto generated**!methods!public! !
!IXMLDOMNamedNodeMap categoriesFor: #GetQualifiedItem:namespaceURI:qualifiedItem:!**auto generated**!COM Interfaces-IXMLDOMNamedNodeMap!private! !
!IXMLDOMNamedNodeMap categoriesFor: #isExtensible!**auto generated**!public!testing! !
!IXMLDOMNamedNodeMap categoriesFor: #isVBCollection!**auto generated**!public!testing! !
!IXMLDOMNamedNodeMap categoriesFor: #item:!**auto generated**!properties!public! !
!IXMLDOMNamedNodeMap categoriesFor: #length!**auto generated**!properties!public! !
!IXMLDOMNamedNodeMap categoriesFor: #nextNode!**auto generated**!methods!public! !
!IXMLDOMNamedNodeMap categoriesFor: #NextNode:!**auto generated**!COM Interfaces-IXMLDOMNamedNodeMap!private! !
!IXMLDOMNamedNodeMap categoriesFor: #removeNamedItem:!**auto generated**!methods!public! !
!IXMLDOMNamedNodeMap categoriesFor: #RemoveNamedItem:namedItem:!**auto generated**!COM Interfaces-IXMLDOMNamedNodeMap!private! !
!IXMLDOMNamedNodeMap categoriesFor: #removeQualifiedItem:namespaceURI:!**auto generated**!methods!public! !
!IXMLDOMNamedNodeMap categoriesFor: #RemoveQualifiedItem:namespaceURI:qualifiedItem:!**auto generated**!COM Interfaces-IXMLDOMNamedNodeMap!private! !
!IXMLDOMNamedNodeMap categoriesFor: #Reset!**auto generated**!COM Interfaces-IXMLDOMNamedNodeMap!public! !
!IXMLDOMNamedNodeMap categoriesFor: #setNamedItem:!**auto generated**!methods!public! !
!IXMLDOMNamedNodeMap categoriesFor: #SetNamedItem:nameItem:!**auto generated**!COM Interfaces-IXMLDOMNamedNodeMap!private! !

!IXMLDOMNamedNodeMap class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSXML2.IXMLDOMNamedNodeMap'
		IXMLDOMNamedNodeMap defineTemplate"

	self
		defineFunction: #GetNamedItem:namedItem:
			argumentTypes: 'bstr IXMLDOMNode**';
		defineFunction: #SetNamedItem:nameItem:
			argumentTypes: 'IXMLDOMNode* IXMLDOMNode**';
		defineFunction: #RemoveNamedItem:namedItem:
			argumentTypes: 'bstr IXMLDOMNode**';
		defineFunction: #get_item:listItem:
			argumentTypes: 'sdword IXMLDOMNode**';
		defineFunction: #get_length:
			argumentTypes: 'sdword*';
		defineFunction: #GetQualifiedItem:namespaceURI:qualifiedItem:
			argumentTypes: 'bstr bstr IXMLDOMNode**';
		defineFunction: #RemoveQualifiedItem:namespaceURI:qualifiedItem:
			argumentTypes: 'bstr bstr IXMLDOMNode**';
		defineFunction: #NextNode:
			argumentTypes: 'IXMLDOMNode**';
		defineFunction: #Reset;
		defineFunction: #get__newEnum:
			argumentTypes: 'IUnknown**'
! !
!IXMLDOMNamedNodeMap class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

