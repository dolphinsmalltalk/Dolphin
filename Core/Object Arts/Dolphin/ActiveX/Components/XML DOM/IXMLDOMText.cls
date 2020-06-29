"Filed out from Dolphin Smalltalk 7"!

IXMLDOMCharacterData subclass: #IXMLDOMText
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'MSXMLConstants'
	classInstanceVariableNames: ''
	classConstants: {}!
IXMLDOMText guid: (IID fromString: '{2933bf87-7b36-11d2-b20e-00c04f983e60}')!
IXMLDOMText comment: '<IXMLDOMText> is a wrapper class for the COM interface ''MSXML.IXMLDOMText'' generated from type information in the ''Microsoft XML, version 2.0'' library. It contains methods to invoke the member functions exposed by that interface.

This is a specialized DOM node to represent text nodes. Text nodes represent the text content of an element of attribute, and have no children.'!
!IXMLDOMText categoriesForClass!COM-Interfaces!MSXML-Interfaces! !
!IXMLDOMText methodsFor!

splitText: offset
	"Answer the <IXMLDOMText> result of invoking the splitText() method of the COM object.
	Helpstring: split the text node into two text nodes at the position specified"

	| answer |
	answer := IXMLDOMText newPointer.
	self
		SplitText: offset
		rightHandTextNode: answer.
	^answer asObject
!

SplitText: offset rightHandTextNode: rightHandTextNode
	"Private - Invoke the splitText() method of the COM object.
	Helpstring: split the text node into two text nodes at the position specified

		HRESULT __stdcall splitText(
			[in]long offset,
			[out, retval]IXMLDOMText** rightHandTextNode);"

	<virtual stdcall: hresult 52 sdword IXMLDOMText**>
	^self invalidCall: _failureCode! !
!IXMLDOMText categoriesFor: #splitText:!**auto generated**!methods!public! !
!IXMLDOMText categoriesFor: #SplitText:rightHandTextNode:!**auto generated**!COM Interfaces-IXMLDOMText!private! !

!IXMLDOMText class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSXML2.IXMLDOMText'
		IXMLDOMText defineTemplate"

	self
		defineFunction: #SplitText:rightHandTextNode:
			argumentTypes: 'sdword IXMLDOMText**'
! !
!IXMLDOMText class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

