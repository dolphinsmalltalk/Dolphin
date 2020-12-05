"Filed out from Dolphin Smalltalk 7"!

MSXML.IXMLDOMNode subclass: #'MSXML.IXMLDOMAttribute'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
MSXML.IXMLDOMAttribute guid: (OS.COM.IID fromString: '{2933bf85-7b36-11d2-b20e-00c04f983e60}')!
MSXML.IXMLDOMAttribute comment: '<IXMLDOMAttribute> is a wrapper class for the COM interface ''MSXML.IXMLDOMAttribute'' generated from type information in the ''Microsoft XML, version 2.0'' library. It contains methods to invoke the member functions exposed by that interface.

This is a specialized node type to represent DOM attributes.'!
!MSXML.IXMLDOMAttribute categoriesForClass!COM-Interfaces!MSXML-Interfaces! !
!MSXML.IXMLDOMAttribute methodsFor!

<= comperand 
	"Answer whether the receiver should be sorted before the <IXMLDOMAttribute> argument (see
	'Canonical XML', http://www.w3.org/TR/xml-c14n, for a description of the ordering
	convention."

	^self prefix = 'xmlns' 
		ifTrue: 
			[comperand prefix ~= 'xmlns' or: 
					["Both are namespace declarations, order by the namespace prefix so declared"
					self baseName <= comperand baseName]]
		ifFalse: 
			[comperand prefix ~= 'xmlns' and: 
					["Neither are namespace declarations, order by namespace URI
					(default namespace sorting first), and within that by
					attribute name"
					self namespaceURI <= comperand namespaceURI and: [self baseName <= comperand baseName]]]!

= anObject 
	^self class == anObject class and: [self key = anObject key and: [self value = anObject value]]!

get_name: attributeName
	"Private - Get the value of the 'name' property of the receiver.

		HRESULT __stdcall name(
			[out, retval]BSTR* attributeName);"

	<virtual stdcall: hresult 44 bstr*>
	^self invalidCall: _failureCode!

get_value: attributeValue
	"Private - Get the value of the 'value' property of the receiver.

		HRESULT __stdcall value(
			[out, retval]VARIANT* attributeValue);"

	<virtual stdcall: hresult 45 variant*>
	^self invalidCall: _failureCode!

key
	"Answer the <readableString> name of the receiver."

	^self nodeName!

key: arg1
	"This is part of the protocol <association>, but is not supported by 
	DOM attributes (the key is considered fixed)."

	^self shouldNotImplement!

name
	"Answer the <bstr> value of the 'name' property of the receiver.
	Helpstring: get name of the attribute"

	| answer |
	answer := BSTR new.
	self get_name: answer.
	^answer asObject
!

printValueOn: aStream
	[aStream nextPutAll: self xml] on: HRESULTError
		do: [:e | aStream print: bytes]!

put_value: attributeValue
	"Private - Set the value of the 'value' property of the object wrapped by the 
	 receiver to the <variant> argument, attributeValue.

		HRESULT __stdcall value(
			[in]VARIANT attributeValue);"

	<virtual stdcall: hresult 46 variant>
	^self invalidCall: _failureCode!

value
	"Answer the <variant> value of the 'value' property of the receiver.
	Helpstring: string value of the attribute"

	| answer |
	answer := VARIANT new.
	self get_value: answer.
	^answer asObject
!

value: attributeValue
	"Set the 'value' property of the receiver to the <variant> value of the argument.
	Helpstring: string value of the attribute"

	self put_value: attributeValue asVariant
! !
!MSXML.IXMLDOMAttribute categoriesFor: #<=!comparing!public! !
!MSXML.IXMLDOMAttribute categoriesFor: #=!comparing!public! !
!MSXML.IXMLDOMAttribute categoriesFor: #get_name:!**auto generated**!COM Interfaces-IXMLDOMAttribute!private! !
!MSXML.IXMLDOMAttribute categoriesFor: #get_value:!**auto generated**!COM Interfaces-IXMLDOMAttribute!private! !
!MSXML.IXMLDOMAttribute categoriesFor: #key!accessing!public! !
!MSXML.IXMLDOMAttribute categoriesFor: #key:!accessing!public! !
!MSXML.IXMLDOMAttribute categoriesFor: #name!**auto generated**!properties!public! !
!MSXML.IXMLDOMAttribute categoriesFor: #printValueOn:!printing!private! !
!MSXML.IXMLDOMAttribute categoriesFor: #put_value:!**auto generated**!COM Interfaces-IXMLDOMAttribute!private! !
!MSXML.IXMLDOMAttribute categoriesFor: #value!**auto generated**!properties!public! !
!MSXML.IXMLDOMAttribute categoriesFor: #value:!**auto generated**!properties!public! !

MSXML.IXMLDOMAttribute methodProtocol: #association attributes: #(#ansi #readOnly) selectors: #(#key #key: #value #value:)!

!MSXML.IXMLDOMAttribute class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSXML2.IXMLDOMAttribute'
		IXMLDOMAttribute defineTemplate"

	self
		defineFunction: #get_name:
			argumentTypes: 'bstr*';
		defineFunction: #get_value:
			argumentTypes: 'variant*';
		defineFunction: #put_value:
			argumentTypes: 'variant'
! !
!MSXML.IXMLDOMAttribute class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

