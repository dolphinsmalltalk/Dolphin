"Filed out from Dolphin Smalltalk 7"!

IDispatch subclass: #IXMLDOMParseError
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'MSXMLConstants'
	classInstanceVariableNames: ''
	classConstants: {}!
IXMLDOMParseError guid: (IID fromString: '{3efaa426-272f-11d2-836f-0000f87a7782}')!
IXMLDOMParseError comment: '<IXMLDOMParseError> is a wrapper class for the COM interface ''MSXML.IXMLDOMParseError'' generated from type information in the ''Microsoft XML, version 2.0'' library. It contains methods to invoke the member functions exposed by that interface.

The underlying COM object which exposes this interface is effectively a simple data object that encapsulates detailed information about parse errors detected by the XML parser.'!
!IXMLDOMParseError categoriesForClass!COM-Interfaces!MSXML-Interfaces! !
!IXMLDOMParseError methodsFor!

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
	answer := (SDWORD new).
	self get_errorCode: answer.
	^answer asObject
!

filepos
	"Answer the <sdword> value of the 'filepos' property of the receiver.
	Helpstring: the absolute file position in the XML document containing the error"

	| answer |
	answer := (SDWORD new).
	self get_filepos: answer.
	^answer asObject
!

get_errorCode: errorCode
	"Private - Get the value of the 'errorCode' property of the receiver.

		HRESULT __stdcall errorCode(
			[out, retval]long* errorCode);"

	<virtual stdcall: hresult 8 sdword*>
	^self invalidCall: _failureCode!

get_filepos: filePosition
	"Private - Get the value of the 'filepos' property of the receiver.

		HRESULT __stdcall filepos(
			[out, retval]long* filePosition);"

	<virtual stdcall: hresult 14 sdword*>
	^self invalidCall: _failureCode!

get_line: lineNumber
	"Private - Get the value of the 'line' property of the receiver.

		HRESULT __stdcall line(
			[out, retval]long* lineNumber);"

	<virtual stdcall: hresult 12 sdword*>
	^self invalidCall: _failureCode!

get_linepos: linePosition
	"Private - Get the value of the 'linepos' property of the receiver.

		HRESULT __stdcall linepos(
			[out, retval]long* linePosition);"

	<virtual stdcall: hresult 13 sdword*>
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
	answer := (SDWORD new).
	self get_line: answer.
	^answer asObject
!

linepos
	"Answer the <sdword> value of the 'linepos' property of the receiver.
	Helpstring: the character position in the line containing the error"

	| answer |
	answer := (SDWORD new).
	self get_linepos: answer.
	^answer asObject
!

reason
	"Answer the <bstr> value of the 'reason' property of the receiver.
	Helpstring: the cause of the error"

	| answer |
	answer := BSTR new.
	self get_reason: answer.
	^answer asObject
!

srcText
	"Answer the <bstr> value of the 'srcText' property of the receiver.
	Helpstring: the data where the error occurred"

	| answer |
	answer := BSTR new.
	self get_srcText: answer.
	^answer asObject
!

url
	"Answer the <bstr> value of the 'url' property of the receiver.
	Helpstring: the URL of the XML document containing the error"

	| answer |
	answer := BSTR new.
	self get_url: answer.
	^answer asObject
!

value
	"Answer the <sdword> value of the 'errorCode' property of the receiver.
	This is the default value (DISPID_VALUE) property of the receiver."

	^self errorCode
! !
!IXMLDOMParseError categoriesFor: #displayOn:!printing!public! !
!IXMLDOMParseError categoriesFor: #errorCode!**auto generated**!properties!public! !
!IXMLDOMParseError categoriesFor: #filepos!**auto generated**!properties!public! !
!IXMLDOMParseError categoriesFor: #get_errorCode:!**auto generated**!COM Interfaces-IXMLDOMParseError!private! !
!IXMLDOMParseError categoriesFor: #get_filepos:!**auto generated**!COM Interfaces-IXMLDOMParseError!private! !
!IXMLDOMParseError categoriesFor: #get_line:!**auto generated**!COM Interfaces-IXMLDOMParseError!private! !
!IXMLDOMParseError categoriesFor: #get_linepos:!**auto generated**!COM Interfaces-IXMLDOMParseError!private! !
!IXMLDOMParseError categoriesFor: #get_reason:!**auto generated**!COM Interfaces-IXMLDOMParseError!private! !
!IXMLDOMParseError categoriesFor: #get_srcText:!**auto generated**!COM Interfaces-IXMLDOMParseError!private! !
!IXMLDOMParseError categoriesFor: #get_url:!**auto generated**!COM Interfaces-IXMLDOMParseError!private! !
!IXMLDOMParseError categoriesFor: #isExtensible!**auto generated**!public!testing! !
!IXMLDOMParseError categoriesFor: #isVBCollection!**auto generated**!public!testing! !
!IXMLDOMParseError categoriesFor: #line!**auto generated**!properties!public! !
!IXMLDOMParseError categoriesFor: #linepos!**auto generated**!properties!public! !
!IXMLDOMParseError categoriesFor: #reason!**auto generated**!properties!public! !
!IXMLDOMParseError categoriesFor: #srcText!**auto generated**!properties!public! !
!IXMLDOMParseError categoriesFor: #url!**auto generated**!properties!public! !
!IXMLDOMParseError categoriesFor: #value!**auto generated**!properties!public! !

!IXMLDOMParseError class methodsFor!

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
!IXMLDOMParseError class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!IXMLDOMParseError class categoriesFor: #icon!public! !

