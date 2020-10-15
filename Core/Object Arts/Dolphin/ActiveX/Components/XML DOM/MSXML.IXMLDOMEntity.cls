"Filed out from Dolphin Smalltalk 7"!

MSXML.IXMLDOMNode subclass: #'MSXML.IXMLDOMEntity'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
MSXML.IXMLDOMEntity guid: (OS.COM.IID fromString: '{2933bf8d-7b36-11d2-b20e-00c04f983e60}')!
MSXML.IXMLDOMEntity comment: '<IXMLDOMEntity> is a wrapper class for the COM interface ''MSXML.IXMLDOMEntity'' generated from type information in the ''Microsoft XML, version 2.0'' library. It contains methods to invoke the member functions exposed by that interface.

This is a specialized DOM node to represent parsed or unparsed entities in the XML document.'!
!MSXML.IXMLDOMEntity categoriesForClass!COM-Interfaces!MSXML-Interfaces! !
!MSXML.IXMLDOMEntity methodsFor!

get_notationName: name
	"Private - Get the value of the 'notationName' property of the receiver.

		HRESULT __stdcall notationName(
			[out, retval]BSTR* name);"

	<virtual stdcall: hresult 46 bstr*>
	^self invalidCall: _failureCode!

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
	"This is part of the protocol <association>, but is not supported by DOM entities (the key
	is considered fixed)."

	^self shouldNotImplement!

notationName
	"Answer the <bstr> value of the 'notationName' property of the receiver.
	Helpstring: the name of the notation"

	| answer |
	answer := BSTR new.
	self get_notationName: answer.
	^answer asObject!

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
!MSXML.IXMLDOMEntity categoriesFor: #get_notationName:!**auto generated**!COM Interfaces-IXMLDOMEntity!private! !
!MSXML.IXMLDOMEntity categoriesFor: #get_publicId:!**auto generated**!COM Interfaces-IXMLDOMEntity!private! !
!MSXML.IXMLDOMEntity categoriesFor: #get_systemId:!**auto generated**!COM Interfaces-IXMLDOMEntity!private! !
!MSXML.IXMLDOMEntity categoriesFor: #key!accessing!public! !
!MSXML.IXMLDOMEntity categoriesFor: #key:!accessing!public! !
!MSXML.IXMLDOMEntity categoriesFor: #notationName!**auto generated**!properties!public! !
!MSXML.IXMLDOMEntity categoriesFor: #publicId!**auto generated**!properties!public! !
!MSXML.IXMLDOMEntity categoriesFor: #systemId!**auto generated**!properties!public! !
!MSXML.IXMLDOMEntity categoriesFor: #value!accessing!public! !
!MSXML.IXMLDOMEntity categoriesFor: #value:!accessing!public! !

MSXML.IXMLDOMEntity methodProtocol: #association attributes: #(#ansi #readOnly) selectors: #(#key #key: #value #value:)!

!MSXML.IXMLDOMEntity class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSXML2.IXMLDOMEntity'
		IXMLDOMEntity defineTemplate"

	self
		defineFunction: #get_publicId:
			argumentTypes: 'variant*';
		defineFunction: #get_systemId:
			argumentTypes: 'variant*';
		defineFunction: #get_notationName:
			argumentTypes: 'bstr*'
! !
!MSXML.IXMLDOMEntity class categoriesFor: #defineFunctions!**auto generated**!initializing!private! !

