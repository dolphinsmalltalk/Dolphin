"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2Interface
	subclass: #'WebView2.ICoreWebView2ExecuteScriptResult'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2ExecuteScriptResult guid: (OS.COM.IID fromString: '{0ce15963-3698-4df7-9399-71ed6cdd8c9f}')!

WebView2.ICoreWebView2ExecuteScriptResult comment: '`ICoreWebView2ExecuteScriptResult` is a wrapper class for the COM interface ''WebView2.ICoreWebView2ExecuteScriptResult'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(0ce15963-3698-4df7-9399-71ed6cdd8c9f)
]
interface ICoreWebView2ExecuteScriptResult : IUnknown
 {
	[id(0x60010000), propget]
	HRESULT __stdcall Succeeded(
		[out, retval]long* value);
	[id(0x60010001), propget]
	HRESULT __stdcall ResultAsJson(
		[out, retval]LPWSTR* jsonResult);
	[id(0x60010002)]
	HRESULT __stdcall TryGetResultAsString(
		[out]LPWSTR* stringResult,
		[out]long* value);
	[id(0x60010003), propget]
	HRESULT __stdcall Exception(
		[out, retval]ICoreWebView2ScriptException** Exception);
};
```
'!

!WebView2.ICoreWebView2ExecuteScriptResult categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2ExecuteScriptResult methodsFor!

exception
	"Answer the <ICoreWebView2ScriptException> value of the 'Exception' property of the receiver."

	| answer |
	answer := ICoreWebView2ScriptException newPointer.
	self get_Exception: answer.
	^answer asObject!

get_Exception: exception
	"Private - Get the value of the 'Exception' property of the receiver.

		HRESULT __stdcall Exception(
			[out, retval]ICoreWebView2ScriptException** Exception);"

	<virtual stdcall: hresult 7 ICoreWebView2ScriptException**>
	^self invalidCall: _failureCode!

get_ResultAsJson: jsonResult
	"Private - Get the value of the 'ResultAsJson' property of the receiver.

		HRESULT __stdcall ResultAsJson(
			[out, retval]LPWSTR* jsonResult);"

	<virtual stdcall: hresult 5 lpwstr*>
	^self invalidCall: _failureCode!

get_Succeeded: value
	"Private - Get the value of the 'Succeeded' property of the receiver.

		HRESULT __stdcall Succeeded(
			[out, retval]long* value);"

	<virtual stdcall: hresult 4 int32*>
	^self invalidCall: _failureCode!

printableProperties
	^#(#succeeded #resultAsJson #exception)!

resultAsJson
	"Answer the <lpwstr> value of the 'ResultAsJson' property of the receiver."

	| ptr answer |
	ptr := TaskMemory new.
	self get_ResultAsJson: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer!

succeeded
	"Answer the <boolean> value of the 'Succeeded' property of the receiver."

	| answer |
	answer := ByteArray new: 4.
	self get_Succeeded: answer.
	^(answer int32AtOffset: 0) ~~ 0!

tryGetResultAsString
	"Return the string result of the script execution if it succeeded, or nil if it returned a non-string type."

	| ptr result success |
	ptr := TaskMemory new.
	success := ByteArray newFixed: 4.
	self TryGetResultAsString: ptr value: success.
	(success int32AtOffset: 0) == 0 ifTrue: [^nil].
	result := Utf16String fromAddress: ptr.
	ptr free.
	^result!

TryGetResultAsString: stringResult value: value
	"Private - Invoke the TryGetResultAsString() method of the COM object.

		HRESULT __stdcall TryGetResultAsString(
			[out]LPWSTR* stringResult,
			[out]long* value);"

	<virtual stdcall: hresult 6 lpwstr* int32*>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2ExecuteScriptResult categoriesForMethods!
exception!**auto generated**!properties!public! !
get_Exception:!**auto generated**!COM Interfaces-ICoreWebView2ExecuteScriptResult!private! !
get_ResultAsJson:!**auto generated**!COM Interfaces-ICoreWebView2ExecuteScriptResult!private! !
get_Succeeded:!**auto generated**!COM Interfaces-ICoreWebView2ExecuteScriptResult!private! !
printableProperties!printing!private! !
resultAsJson!properties!public! !
succeeded!properties!public! !
tryGetResultAsString!**auto generated**!methods!public! !
TryGetResultAsString:value:!**auto generated**!COM Interfaces-ICoreWebView2ExecuteScriptResult!private! !
!

!WebView2.ICoreWebView2ExecuteScriptResult class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2ExecuteScriptResult'
		ICoreWebView2ExecuteScriptResult defineTemplate"

	self
		defineFunction: #get_Succeeded:
			argumentTypes: 'int32*';
		defineFunction: #get_ResultAsJson:
			argumentTypes: 'lpwstr*';
		defineFunction: #TryGetResultAsString:value:
			argumentTypes: 'lpwstr* int32*';
		defineFunction: #get_Exception:
			argumentTypes: 'ICoreWebView2ScriptException**'
! !

!WebView2.ICoreWebView2ExecuteScriptResult class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

