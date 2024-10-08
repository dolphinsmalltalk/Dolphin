﻿"Filed out from Dolphin Smalltalk"!

OS.COM.IDispatch
	subclass: #'MSXML.IXMLDOMParseError'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

MSXML.IXMLDOMParseError guid: (OS.COM.IID fromString: '{3efaa426-272f-11d2-836f-0000f87a7782}')!

MSXML.IXMLDOMParseError isEgressOnly: true!

MSXML.IXMLDOMParseError comment: '<IXMLDOMParseError> is a wrapper class for the COM interface ''MSXML.IXMLDOMParseError'' generated from type information in the ''Microsoft XML, version 2.0'' library. It contains methods to invoke the member functions exposed by that interface.

The underlying COM object which exposes this interface is effectively a simple data object that encapsulates detailed information about parse errors detected by the XML parser.'!

!MSXML.IXMLDOMParseError categoriesForClass!COM-Interfaces!MSXML-Interfaces! !

!MSXML.IXMLDOMParseError methodsFor!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream nextPutAll: 'Error'.
	self line = 0
		ifFalse: 
			[aPuttableStream
				nextPutAll: ' at ';
				display: self line;
				nextPut: $,;
				display: self linepos].
	aPuttableStream
		nextPutAll: ': ';
		display: (self reason ifNil: ['<unknown>'] ifNotNil: [:reason | reason lines first])!

errorCode
	"Answer the <sdword> value of the 'errorCode' property of the receiver.
	Helpstring: the error code"

	| answer |
	answer := Int32 new.
	self get_errorCode: answer.
	^answer asObject!

filepos
	"Answer the <sdword> value of the 'filepos' property of the receiver.
	Helpstring: the absolute file position in the XML document containing the error"

	| answer |
	answer := Int32 new.
	self get_filepos: answer.
	^answer asObject!

get_errorCode: errorCode
	"Private - Get the value of the 'errorCode' property of the receiver.

		HRESULT __stdcall errorCode(
			[out, retval]long* errorCode);"

	<virtual stdcall: hresult 8 int32*>
	^self invalidCall: _failureCode!

get_filepos: filePosition
	"Private - Get the value of the 'filepos' property of the receiver.

		HRESULT __stdcall filepos(
			[out, retval]long* filePosition);"

	<virtual stdcall: hresult 14 int32*>
	^self invalidCall: _failureCode!

get_line: lineNumber
	"Private - Get the value of the 'line' property of the receiver.

		HRESULT __stdcall line(
			[out, retval]long* lineNumber);"

	<virtual stdcall: hresult 12 int32*>
	^self invalidCall: _failureCode!

get_linepos: linePosition
	"Private - Get the value of the 'linepos' property of the receiver.

		HRESULT __stdcall linepos(
			[out, retval]long* linePosition);"

	<virtual stdcall: hresult 13 int32*>
	^self invalidCall: _failureCode!

get_reason: reasonString
	"Private - Get the value of the 'reason' property of the receiver.

		HRESULT __stdcall reason(
			[out, retval]BSTR* reasonString);"

	<virtual stdcall: hresult 10 bstr*>
	^self invalidCall: _failureCode!

get_srcText: sourceString
	"Private - Get the value of the 'srcText' property of the receiver.

		HRESULT __stdcall srcText(
			[out, retval]BSTR* sourceString);"

	<virtual stdcall: hresult 11 bstr*>
	^self invalidCall: _failureCode!

get_url: urlString
	"Private - Get the value of the 'url' property of the receiver.

		HRESULT __stdcall url(
			[out, retval]BSTR* urlString);"

	<virtual stdcall: hresult 9 bstr*>
	^self invalidCall: _failureCode!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^false!

isVBCollection
	"Answer whether the receiver is a VB style collection."

	^false!

line
	"Answer the <sdword> value of the 'line' property of the receiver.
	Helpstring: the line number in the XML document where the error occurred"

	| answer |
	answer := Int32 new.
	self get_line: answer.
	^answer asObject!

linepos
	"Answer the <sdword> value of the 'linepos' property of the receiver.
	Helpstring: the character position in the line containing the error"

	| answer |
	answer := Int32 new.
	self get_linepos: answer.
	^answer asObject!

reason
	"Answer the <bstr> value of the 'reason' property of the receiver.
	Helpstring: the cause of the error"

	| answer |
	answer := BSTR new.
	self get_reason: answer.
	^answer asObject!

srcText
	"Answer the <bstr> value of the 'srcText' property of the receiver.
	Helpstring: the data where the error occurred"

	| answer |
	answer := BSTR new.
	self get_srcText: answer.
	^answer asObject!

url
	"Answer the <bstr> value of the 'url' property of the receiver.
	Helpstring: the URL of the XML document containing the error"

	| answer |
	answer := BSTR new.
	self get_url: answer.
	^answer asObject!

value
	"Answer the <sdword> value of the 'errorCode' property of the receiver.
	This is the default value (DISPID_VALUE) property of the receiver."

	^self errorCode! !

!MSXML.IXMLDOMParseError categoriesForMethods!
displayOn:!printing!public! !
errorCode!**auto generated**!properties!public! !
filepos!**auto generated**!properties!public! !
get_errorCode:!**auto generated**!COM Interfaces-IXMLDOMParseError!private! !
get_filepos:!**auto generated**!COM Interfaces-IXMLDOMParseError!private! !
get_line:!**auto generated**!COM Interfaces-IXMLDOMParseError!private! !
get_linepos:!**auto generated**!COM Interfaces-IXMLDOMParseError!private! !
get_reason:!**auto generated**!COM Interfaces-IXMLDOMParseError!private! !
get_srcText:!**auto generated**!COM Interfaces-IXMLDOMParseError!private! !
get_url:!**auto generated**!COM Interfaces-IXMLDOMParseError!private! !
isExtensible!**auto generated**!public!testing! !
isVBCollection!**auto generated**!public!testing! !
line!**auto generated**!properties!public! !
linepos!**auto generated**!properties!public! !
reason!**auto generated**!properties!public! !
srcText!**auto generated**!properties!public! !
url!**auto generated**!properties!public! !
value!**auto generated**!properties!public! !
!

!MSXML.IXMLDOMParseError class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSXML2.IXMLDOMParseError'
		IXMLDOMParseError defineTemplate"

	self
		defineFunction: #get_errorCode:
			argumentTypes: 'sdword*';
		defineFunction: #get_url:
			argumentTypes: 'bstr*';
		defineFunction: #get_reason:
			argumentTypes: 'bstr*';
		defineFunction: #get_srcText:
			argumentTypes: 'bstr*';
		defineFunction: #get_line:
			argumentTypes: 'sdword*';
		defineFunction: #get_linepos:
			argumentTypes: 'sdword*';
		defineFunction: #get_filepos:
			argumentTypes: 'sdword*'
!

icon
	^Error icon! !

!MSXML.IXMLDOMParseError class categoriesForMethods!
defineFunctions!**auto generated**!initializing!private! !
icon!public! !
!

