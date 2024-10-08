﻿"Filed out from Dolphin Smalltalk"!

MSXML.IXMLDOMNode
	subclass: #'MSXML.IXMLDOMCharacterData'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

MSXML.IXMLDOMCharacterData guid: (OS.COM.IID fromString: '{2933bf84-7b36-11d2-b20e-00c04f983e60}')!

MSXML.IXMLDOMCharacterData isEgressOnly: true!

MSXML.IXMLDOMCharacterData comment: '<IXMLDOMCharacterData> is a wrapper class for the COM interface ''MSXML.IXMLDOMCharacterData'' generated from type information in the ''Microsoft XML, version 2.0'' library. It contains methods to invoke the member functions exposed by that interface.

This interface is an abstract root for the character-oriented node types in the DOM.'!

!MSXML.IXMLDOMCharacterData categoriesForClass!COM-Interfaces!MSXML-Interfaces! !

!MSXML.IXMLDOMCharacterData methodsFor!

= anObject 
	^self class == anObject class and: [self data = anObject data]!

AppendData: data
	"Invoke the appendData() method of the COM object.
	Helpstring: append string to value

		HRESULT __stdcall appendData(
			[in]BSTR data);"

	<virtual stdcall: hresult 48 bstr>
	^self invalidCall: _failureCode!

attributes
	"Text-only nodes do not have any attributes"

	^self shouldNotImplement!

childNodes
	"Answer the a <sequencedReadableCollection> on the <IXMLDOMNodeList> 
	value of the 'childNodes' property of the receiver."

	"Implementation Note: Text, CDATA, and Comment nodes cannot have any child nodes. Although
	the superclass implementation functions correctly, we can speed it up significantly."

	^#()!

data
	"Answer the <bstr> value of the 'data' property of the receiver.
	Helpstring: value of the node"

	| answer |
	answer := BSTR new.
	self get_data: answer.
	^answer asObject!

data: data
	"Set the 'data' property of the receiver to the <bstr> value of the argument.
	Helpstring: value of the node"

	self put_data: data!

DeleteData: offset count: count
	"Invoke the deleteData() method of the COM object.
	Helpstring: delete string within the value

		HRESULT __stdcall deleteData(
			[in]long offset,
			[in]long count);"

	<virtual stdcall: hresult 50 int32 int32>
	^self invalidCall: _failureCode!

get_data: data
	"Private - Get the value of the 'data' property of the receiver.

		HRESULT __stdcall data(
			[out, retval]BSTR* data);"

	<virtual stdcall: hresult 44 bstr*>
	^self invalidCall: _failureCode!

get_length: dataLength
	"Private - Get the value of the 'length' property of the receiver.

		HRESULT __stdcall length(
			[out, retval]long* dataLength);"

	<virtual stdcall: hresult 46 int32*>
	^self invalidCall: _failureCode!

InsertData: offset data: data
	"Invoke the insertData() method of the COM object.
	Helpstring: insert string into value

		HRESULT __stdcall insertData(
			[in]long offset,
			[in]BSTR data);"

	<virtual stdcall: hresult 49 int32 bstr>
	^self invalidCall: _failureCode!

isText
	"Answer whether this is a text only node."

	^true!

length
	"Answer the <sdword> value of the 'length' property of the receiver.
	Helpstring: number of characters in value"

	| answer |
	answer := Int32 new.
	self get_length: answer.
	^answer asObject!

put_data: data
	"Private - Set the value of the 'data' property of the object wrapped by the 
	 receiver to the <bstr> argument, data.

		HRESULT __stdcall data(
			[in]BSTR data);"

	<virtual stdcall: hresult 45 bstr>
	^self invalidCall: _failureCode!

ReplaceData: offset count: count data: data
	"Invoke the replaceData() method of the COM object.
	Helpstring: replace string within the value

		HRESULT __stdcall replaceData(
			[in]long offset,
			[in]long count,
			[in]BSTR data);"

	<virtual stdcall: hresult 51 int32 int32 bstr>
	^self invalidCall: _failureCode!

substringData: offset count: count
	"Answer the <bstr> result of invoking the substringData() method of the COM object.
	Helpstring: retrieve substring of value"

	| answer |
	answer := BSTR new.
	self
		SubstringData: offset
		count: count
		data: answer.
	^answer asObject!

SubstringData: offset count: count data: data
	"Private - Invoke the substringData() method of the COM object.
	Helpstring: retrieve substring of value

		HRESULT __stdcall substringData(
			[in]long offset,
			[in]long count,
			[out, retval]BSTR* data);"

	<virtual stdcall: hresult 47 int32 int32 bstr*>
	^self invalidCall: _failureCode! !

!MSXML.IXMLDOMCharacterData categoriesForMethods!
=!comparing!public! !
AppendData:!**auto generated**!COM Interfaces-IXMLDOMCharacterData!public! !
attributes!properties!public! !
childNodes!properties!public! !
data!**auto generated**!properties!public! !
data:!**auto generated**!properties!public! !
DeleteData:count:!**auto generated**!COM Interfaces-IXMLDOMCharacterData!public! !
get_data:!**auto generated**!COM Interfaces-IXMLDOMCharacterData!private! !
get_length:!**auto generated**!COM Interfaces-IXMLDOMCharacterData!private! !
InsertData:data:!**auto generated**!COM Interfaces-IXMLDOMCharacterData!public! !
isText!public!testing! !
length!**auto generated**!properties!public! !
put_data:!**auto generated**!COM Interfaces-IXMLDOMCharacterData!private! !
ReplaceData:count:data:!**auto generated**!COM Interfaces-IXMLDOMCharacterData!public! !
substringData:count:!**auto generated**!methods!public! !
SubstringData:count:data:!**auto generated**!COM Interfaces-IXMLDOMCharacterData!private! !
!

!MSXML.IXMLDOMCharacterData class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSXML2.IXMLDOMCharacterData'
		IXMLDOMCharacterData defineTemplate"

	self
		defineFunction: #get_data:
			argumentTypes: 'bstr*';
		defineFunction: #put_data:
			argumentTypes: 'bstr';
		defineFunction: #get_length:
			argumentTypes: 'sdword*';
		defineFunction: #SubstringData:count:data:
			argumentTypes: 'sdword sdword bstr*';
		defineFunction: #AppendData:
			argumentTypes: 'bstr';
		defineFunction: #InsertData:data:
			argumentTypes: 'sdword bstr';
		defineFunction: #DeleteData:count:
			argumentTypes: 'sdword sdword';
		defineFunction: #ReplaceData:count:data:
			argumentTypes: 'sdword sdword bstr'
! !

!MSXML.IXMLDOMCharacterData class categoriesForMethods!
defineFunctions!**auto generated**!initializing!private! !
!

