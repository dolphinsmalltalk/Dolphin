"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2EventArgs
	subclass: #'WebView2.ICoreWebView2BasicAuthenticationRequestedEventArgs'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2BasicAuthenticationRequestedEventArgs guid: (OS.COM.IID fromString: '{ef05516f-d897-4f9e-b672-d8e2307a3fb0}')!
WebView2.ICoreWebView2BasicAuthenticationRequestedEventArgs isEgressOnly: true!
WebView2.ICoreWebView2BasicAuthenticationRequestedEventArgs comment: '`ICoreWebView2BasicAuthenticationRequestedEventArgs` is a wrapper class for the COM interface ''WebView2.ICoreWebView2BasicAuthenticationRequestedEventArgs'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(ef05516f-d897-4f9e-b672-d8e2307a3fb0)
]
interface ICoreWebView2BasicAuthenticationRequestedEventArgs : IUnknown
 {
	[id(0x60010000), propget]
	HRESULT __stdcall uri(
		[out, retval]LPWSTR* value);
	[id(0x60010001), propget]
	HRESULT __stdcall Challenge(
		[out, retval]LPWSTR* Challenge);
	[id(0x60010002), propget]
	HRESULT __stdcall Response(
		[out, retval]ICoreWebView2BasicAuthenticationResponse** Response);
	[id(0x60010003), propget]
	HRESULT __stdcall Cancel(
		[out, retval]long* Cancel);
	[id(0x60010003), propput]
	HRESULT __stdcall Cancel(
		[in]long Cancel);
	[id(0x60010005)]
	HRESULT __stdcall GetDeferral(
		[out, retval]ICoreWebView2Deferral** deferral);
};
```
'!
!WebView2.ICoreWebView2BasicAuthenticationRequestedEventArgs categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2BasicAuthenticationRequestedEventArgs methodsFor!

cancel
	"Answer the <Boolean> value of the 'Cancel' property of the receiver."

	| answer |
	answer := BOOL newBuffer.
	self get_Cancel: answer.
	^answer value!

cancel: cancel
	"Set the 'Cancel' property of the receiver to the <sdword> value of the argument."

	self put_Cancel: cancel!

challenge
	"Answer the <lpwstr> value of the 'Challenge' property of the receiver."

	"The auto-generated code is functionally correct, but this code is slightly more efficient; in particular it avoids generating finalizable garbage."

	| ptr answer |
	ptr := TaskMemory new.
	self get_Challenge: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer!

get_Cancel: cancel
	"Private - Get the value of the 'Cancel' property of the receiver.

		HRESULT __stdcall Cancel(
			[out, retval]long* Cancel);"

	<virtual stdcall: hresult 7 int32*>
	^self invalidCall: _failureCode!

get_Challenge: challenge
	"Private - Get the value of the 'Challenge' property of the receiver.

		HRESULT __stdcall Challenge(
			[out, retval]LPWSTR* Challenge);"

	<virtual stdcall: hresult 5 lpwstr*>
	^self invalidCall: _failureCode!

get_Response: response
	"Private - Get the value of the 'Response' property of the receiver.

		HRESULT __stdcall Response(
			[out, retval]ICoreWebView2BasicAuthenticationResponse** Response);"

	<virtual stdcall: hresult 6 ICoreWebView2BasicAuthenticationResponse**>
	^self invalidCall: _failureCode!

get_uri: value
	"Private - Get the value of the 'uri' property of the receiver.

		HRESULT __stdcall uri(
			[out, retval]LPWSTR* value);"

	<virtual stdcall: hresult 4 lpwstr*>
	^self invalidCall: _failureCode!

GetDeferral: deferral
	"Private - Invoke the GetDeferral() method of the COM object.

		HRESULT __stdcall GetDeferral(
			[out, retval]ICoreWebView2Deferral** deferral);"

	<virtual stdcall: hresult 9 ICoreWebView2Deferral**>
	^self invalidCall: _failureCode!

printableProperties
	^#(#uri #cancel)!

put_Cancel: cancel
	"Private - Set the value of the 'Cancel' property of the object wrapped by the 
	 receiver to the <sdword> argument, cancel.

		HRESULT __stdcall Cancel(
			[in]long Cancel);"

	<virtual stdcall: hresult 8 int32>
	^self invalidCall: _failureCode!

response
	"Answer the <ICoreWebView2BasicAuthenticationResponse> value of the 'Response' property of the receiver."

	| answer |
	answer := ICoreWebView2BasicAuthenticationResponse newPointer.
	self get_Response: answer.
	^answer asObject!

uri
	"Answer the <lpwstr> value of the 'uri' property of the receiver."

	"The auto-generated code is functionally correct, but this code is slightly more efficient; in particular it avoids generating finalizable garbage."

	| ptr answer |
	ptr := TaskMemory new.
	self get_uri: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer! !
!WebView2.ICoreWebView2BasicAuthenticationRequestedEventArgs categoriesForMethods!
cancel!properties!public! !
cancel:!**auto generated**!properties!public! !
challenge!properties!public! !
get_Cancel:!**auto generated**!COM Interfaces-ICoreWebView2BasicAuthenticationRequestedEventArgs!private! !
get_Challenge:!**auto generated**!COM Interfaces-ICoreWebView2BasicAuthenticationRequestedEventArgs!private! !
get_Response:!**auto generated**!COM Interfaces-ICoreWebView2BasicAuthenticationRequestedEventArgs!private! !
get_uri:!**auto generated**!COM Interfaces-ICoreWebView2BasicAuthenticationRequestedEventArgs!private! !
GetDeferral:!**auto generated**!COM Interfaces-ICoreWebView2BasicAuthenticationRequestedEventArgs!private! !
printableProperties!printing!private! !
put_Cancel:!**auto generated**!COM Interfaces-ICoreWebView2BasicAuthenticationRequestedEventArgs!private! !
response!**auto generated**!properties!public! !
uri!properties!public! !
!

!WebView2.ICoreWebView2BasicAuthenticationRequestedEventArgs class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2BasicAuthenticationRequestedEventArgs'
		ICoreWebView2BasicAuthenticationRequestedEventArgs defineTemplate"

	self
		defineFunction: #get_uri:
			argumentTypes: 'lpwstr*';
		defineFunction: #get_Challenge:
			argumentTypes: 'lpwstr*';
		defineFunction: #get_Response:
			argumentTypes: 'ICoreWebView2BasicAuthenticationResponse**';
		defineFunction: #get_Cancel:
			argumentTypes: 'sdword*';
		defineFunction: #put_Cancel:
			argumentTypes: 'sdword';
		defineFunction: #GetDeferral:
			argumentTypes: 'ICoreWebView2Deferral**'
! !
!WebView2.ICoreWebView2BasicAuthenticationRequestedEventArgs class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

