"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2Interface
	subclass: #'WebView2.ICoreWebView2ScriptException'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2ScriptException guid: (OS.COM.IID fromString: '{054dae00-84a3-49ff-bc17-4012a90bc9fd}')!

WebView2.ICoreWebView2ScriptException comment: '`ICoreWebView2ScriptException` is a wrapper class for the COM interface ''WebView2.ICoreWebView2ScriptException'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(054dae00-84a3-49ff-bc17-4012a90bc9fd)
]
interface ICoreWebView2ScriptException : IUnknown
 {
	[id(0x60010000), propget]
	HRESULT __stdcall LineNumber(
		[out, retval]unsigned int* value);
	[id(0x60010001), propget]
	HRESULT __stdcall ColumnNumber(
		[out, retval]unsigned int* value);
	[id(0x60010002), propget]
	HRESULT __stdcall name(
		[out, retval]LPWSTR* value);
	[id(0x60010003), propget]
	HRESULT __stdcall Message(
		[out, retval]LPWSTR* value);
	[id(0x60010004), propget]
	HRESULT __stdcall ToJson(
		[out, retval]LPWSTR* value);
};
```
'!

!WebView2.ICoreWebView2ScriptException categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2ScriptException methodsFor!

columnNumber
	"Answer the <uint32> value of the 'ColumnNumber' property of the receiver."

	| buf |
	buf := UInt32Bytes new.
	self get_ColumnNumber: buf.
	^buf asInteger!

get_ColumnNumber: value
	"Private - Get the value of the 'ColumnNumber' property of the receiver.

		HRESULT __stdcall ColumnNumber(
			[out, retval]unsigned int* value);"

	<virtual stdcall: hresult 5 uint32*>
	^self invalidCall: _failureCode!

get_LineNumber: value
	"Private - Get the value of the 'LineNumber' property of the receiver.

		HRESULT __stdcall LineNumber(
			[out, retval]unsigned int* value);"

	<virtual stdcall: hresult 4 uint32*>
	^self invalidCall: _failureCode!

get_Message: value
	"Private - Get the value of the 'Message' property of the receiver.

		HRESULT __stdcall Message(
			[out, retval]LPWSTR* value);"

	<virtual stdcall: hresult 7 lpwstr*>
	^self invalidCall: _failureCode!

get_name: value
	"Private - Get the value of the 'name' property of the receiver.

		HRESULT __stdcall name(
			[out, retval]LPWSTR* value);"

	<virtual stdcall: hresult 6 lpwstr*>
	^self invalidCall: _failureCode!

get_ToJson: value
	"Private - Get the value of the 'ToJson' property of the receiver.

		HRESULT __stdcall ToJson(
			[out, retval]LPWSTR* value);"

	<virtual stdcall: hresult 8 lpwstr*>
	^self invalidCall: _failureCode!

lineNumber
	"Answer the <uint32> value of the 'LineNumber' property of the receiver."

	| buf |
	buf := UInt32Bytes new.
	self get_LineNumber: buf.
	^buf asInteger!

message
	"Answer the <lpwstr> value of the 'Message' property of the receiver."

	| ptr answer |
	ptr := TaskMemory new.
	self get_Message: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer!

name
	"Answer the <lpwstr> value of the 'name' property of the receiver."

	| ptr answer |
	ptr := TaskMemory new.
	self get_name: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer!

printPropertiesOn: aStream
	"Print any properties of the receiver that might be useful for debugging, and which are not too verbose. Emit nothing by default."

	aStream
		nextPutAll: self name;
		nextPut: $@;
		print: self lineNumber;
		nextPut: $,;
		print: self columnNumber;
		nextPutAll: ': ';
		print: self message!

toJson
	"Answer the <lpwstr> value of the 'ToJson' property of the receiver."

	| ptr answer |
	ptr := TaskMemory new.
	self get_ToJson: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer! !

!WebView2.ICoreWebView2ScriptException categoriesForMethods!
columnNumber!properties!public! !
get_ColumnNumber:!**auto generated**!COM Interfaces-ICoreWebView2ScriptException!private! !
get_LineNumber:!**auto generated**!COM Interfaces-ICoreWebView2ScriptException!private! !
get_Message:!**auto generated**!COM Interfaces-ICoreWebView2ScriptException!private! !
get_name:!**auto generated**!COM Interfaces-ICoreWebView2ScriptException!private! !
get_ToJson:!**auto generated**!COM Interfaces-ICoreWebView2ScriptException!private! !
lineNumber!properties!public! !
message!properties!public! !
name!properties!public! !
printPropertiesOn:!printing!private! !
toJson!properties!public! !
!

!WebView2.ICoreWebView2ScriptException class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2ScriptException'
		ICoreWebView2ScriptException defineTemplate"

	self
		defineFunction: #get_LineNumber:
			argumentTypes: 'uint32*';
		defineFunction: #get_ColumnNumber:
			argumentTypes: 'uint32*';
		defineFunction: #get_name:
			argumentTypes: 'lpwstr*';
		defineFunction: #get_Message:
			argumentTypes: 'lpwstr*';
		defineFunction: #get_ToJson:
			argumentTypes: 'lpwstr*'
! !

!WebView2.ICoreWebView2ScriptException class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

