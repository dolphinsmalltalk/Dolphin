"Filed out from Dolphin Smalltalk 7"!

MSXML.IXMLDOMNode subclass: #'MSXML.IXMLDOMNotation'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
MSXML.IXMLDOMNotation guid: (OS.COM.IID fromString: '{2933bf8c-7b36-11d2-b20e-00c04f983e60}')!
MSXML.IXMLDOMNotation comment: '<IXMLDOMNotation> is a wrapper class for the COM interface ''MSXML.IXMLDOMNotation'' generated from type information in the ''Microsoft XML, version 2.0'' library. It contains methods to invoke the member functions exposed by that interface.

This is a specialized DOM node to represent notations declared in the DTD or schema.
'!
!MSXML.IXMLDOMNotation categoriesForClass!COM-Interfaces!MSXML-Interfaces! !
!MSXML.IXMLDOMNotation methodsFor!

childNodes
	"Answer the a <sequencedReadableCollection> on the <IXMLDOMNodeList> 
	value of the 'childNodes' property of the receiver."

	"Implementation Note: A Notation node cannot have any child nodes."

	^#()!

get_publicId: publicId
	"Private - Get the value of the 'publicId' property of the receiver.

		HRESULT __stdcall publicId(
			[out, retval]VARIANT* publicId);"

	<virtual stdcall: hresult 44 variant*>
	^self invalidCall: _failureCode!

get_systemId: systemId
	"Private - Get the value of the 'systemId' property of the receiver.

		HRESULT __stdcall systemId(
			[out, retval]VARIANT* systemId);"

	<virtual stdcall: hresult 45 variant*>
	^self invalidCall: _failureCode!

key
	"Answer the <readableString> name of the receiver."

	^self nodeName!

key: arg1 
	"This is part of the protocol <association>, but is not supported by DOM notations (the key
	is fixed at creation time)."

	^self shouldNotImplement!

publicId
	"Answer the <variant> value of the 'publicId' property of the receiver.
	Helpstring: the public ID"

	| answer |
	answer := VARIANT new.
	self get_publicId: answer.
	^answer asObject!

systemId
	"Answer the <variant> value of the 'systemId' property of the receiver.
	Helpstring: the system ID"

	| answer |
	answer := VARIANT new.
	self get_systemId: answer.
	^answer asObject!

value
	| publicId stream systemId |
	publicId := self publicId.
	stream := String writeStream.
	publicId notEmpty 
		ifTrue: 
			[stream
				nextPutAll: 'PUBLIC ';
				nextPut: $";
				nextPutAll: publicId;
				nextPut: $"]
		ifFalse: [stream nextPutAll: 'SYSTEM'].
	systemId := self systemId.
	systemId notEmpty 
		ifTrue: 
			[stream
				space;
				nextPut: $";
				nextPutAll: systemId;
				nextPut: $"].
	^stream contents!

value: arg1 
	"This is part of the protocol <association>, but is not supported by DOM entities (the value
	is fixed)."

	^self shouldNotImplement! !
!MSXML.IXMLDOMNotation categoriesFor: #childNodes!properties!public! !
!MSXML.IXMLDOMNotation categoriesFor: #get_publicId:!**auto generated**!COM Interfaces-IXMLDOMNotation!private! !
!MSXML.IXMLDOMNotation categoriesFor: #get_systemId:!**auto generated**!COM Interfaces-IXMLDOMNotation!private! !
!MSXML.IXMLDOMNotation categoriesFor: #key!accessing!public! !
!MSXML.IXMLDOMNotation categoriesFor: #key:!accessing!public! !
!MSXML.IXMLDOMNotation categoriesFor: #publicId!**auto generated**!properties!public! !
!MSXML.IXMLDOMNotation categoriesFor: #systemId!**auto generated**!properties!public! !
!MSXML.IXMLDOMNotation categoriesFor: #value!accessing!public! !
!MSXML.IXMLDOMNotation categoriesFor: #value:!accessing!public! !

MSXML.IXMLDOMNotation methodProtocol: #association attributes: #(#ansi #readOnly) selectors: #(#key #key: #value #value:)!

!MSXML.IXMLDOMNotation class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSXML2.IXMLDOMNotation'
		IXMLDOMNotation defineTemplate"

	self
		defineFunction: #get_publicId:
			argumentTypes: 'variant*';
		defineFunction: #get_systemId:
			argumentTypes: 'variant*'
! !
!MSXML.IXMLDOMNotation class categoriesFor: #defineFunctions!**auto generated**!initializing!private! !

