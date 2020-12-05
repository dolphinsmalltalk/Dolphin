"Filed out from Dolphin Smalltalk 7"!

MSXML.IXMLDOMNode subclass: #'MSXML.IXMLDOMDocumentType'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
MSXML.IXMLDOMDocumentType guid: (OS.COM.IID fromString: '{2933bf8b-7b36-11d2-b20e-00c04f983e60}')!
MSXML.IXMLDOMDocumentType comment: '<IXMLDOMDocumentType> is a wrapper class for the COM interface ''MSXML.IXMLDOMDocumentType'' generated from type information in the ''Microsoft XML, version 2.0'' library. It contains methods to invoke the member functions exposed by that interface.

This is a specialized DOM node to represent document type declarations.'!
!MSXML.IXMLDOMDocumentType categoriesForClass!COM-Interfaces!MSXML-Interfaces! !
!MSXML.IXMLDOMDocumentType methodsFor!

entities
	"Answer the <IXMLDOMNamedNodeMap> value of the 'entities' property of the receiver.
	Helpstring: 'a list of entities in the document'.
	Implementation Note: Originally auto-generated, but modified to answer a Smalltalk
	style <Dictionary>."

	| answer |
	answer := IXMLDOMNamedNodeMap newPointer.
	self get_entities: answer.
	^DOMEntitiesMap onInterface: answer parentNode: self!

get_entities: entityMap
	"Private - Get the value of the 'entities' property of the receiver.

		HRESULT __stdcall entities(
			[out, retval]IXMLDOMNamedNodeMap** entityMap);"

	<virtual stdcall: hresult 45 IXMLDOMNamedNodeMap**>
	^self invalidCall: _failureCode!

get_name: rootName
	"Private - Get the value of the 'name' property of the receiver.

		HRESULT __stdcall name(
			[out, retval]BSTR* rootName);"

	<virtual stdcall: hresult 44 bstr*>
	^self invalidCall: _failureCode!

get_notations: notationMap
	"Private - Get the value of the 'notations' property of the receiver.

		HRESULT __stdcall notations(
			[out, retval]IXMLDOMNamedNodeMap** notationMap);"

	<virtual stdcall: hresult 46 IXMLDOMNamedNodeMap**>
	^self invalidCall: _failureCode!

name
	"Answer the <bstr> value of the 'name' property of the receiver.
	Helpstring: name of the document type (root of the tree)"

	| answer |
	answer := BSTR new.
	self get_name: answer.
	^answer asObject
!

notations
	"Answer the <IXMLDOMNamedNodeMap> value of the 'notations' property of the receiver.
	Helpstring: 'a list of notations in the document'
	Implementation Note: Originally auto-generated, but modified to answer a Smalltalk
	style <dictionary>."

	| answer |
	answer := IXMLDOMNamedNodeMap newPointer.
	self get_notations: answer.
	^DOMNotationsMap onInterface: answer parentNode: self! !
!MSXML.IXMLDOMDocumentType categoriesFor: #entities!properties!public! !
!MSXML.IXMLDOMDocumentType categoriesFor: #get_entities:!**auto generated**!COM Interfaces-IXMLDOMDocumentType!private! !
!MSXML.IXMLDOMDocumentType categoriesFor: #get_name:!**auto generated**!COM Interfaces-IXMLDOMDocumentType!private! !
!MSXML.IXMLDOMDocumentType categoriesFor: #get_notations:!**auto generated**!COM Interfaces-IXMLDOMDocumentType!private! !
!MSXML.IXMLDOMDocumentType categoriesFor: #name!**auto generated**!properties!public! !
!MSXML.IXMLDOMDocumentType categoriesFor: #notations!properties!public! !

!MSXML.IXMLDOMDocumentType class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSXML2.IXMLDOMDocumentType'
		IXMLDOMDocumentType defineTemplate"

	self
		defineFunction: #get_name:
			argumentTypes: 'bstr*';
		defineFunction: #get_entities:
			argumentTypes: 'IXMLDOMNamedNodeMap**';
		defineFunction: #get_notations:
			argumentTypes: 'IXMLDOMNamedNodeMap**'
! !
!MSXML.IXMLDOMDocumentType class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

