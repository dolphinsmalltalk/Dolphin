"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2Interface subclass: #'WebView2.ICoreWebView2WebResourceResponseView'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2WebResourceResponseView guid: (OS.COM.IID fromString: '{79701053-7759-4162-8f7d-f1b3f084928d}')!
WebView2.ICoreWebView2WebResourceResponseView comment: '`ICoreWebView2WebResourceResponseView` is a wrapper class for the COM interface ''WebView2.ICoreWebView2WebResourceResponseView'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(79701053-7759-4162-8f7d-f1b3f084928d)
]
interface ICoreWebView2WebResourceResponseView : IUnknown
 {
	[id(0x60010000), propget]
	HRESULT __stdcall Headers(
		[out, retval]ICoreWebView2HttpResponseHeaders** Headers);
	[id(0x60010001), propget]
	HRESULT __stdcall StatusCode(
		[out, retval]int* StatusCode);
	[id(0x60010002), propget]
	HRESULT __stdcall ReasonPhrase(
		[out, retval]LPWSTR* ReasonPhrase);
	[id(0x60010003)]
	HRESULT __stdcall GetContent(
		[in]ICoreWebView2WebResourceResponseViewGetContentCompletedHandler* handler);
};
```
'!
!WebView2.ICoreWebView2WebResourceResponseView categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2WebResourceResponseView methodsFor!

get_Headers: headers
	"Private - Get the value of the 'Headers' property of the receiver.

		HRESULT __stdcall Headers(
			[out, retval]ICoreWebView2HttpResponseHeaders** Headers);"

	<virtual stdcall: hresult 4 ICoreWebView2HttpResponseHeaders**>
	^self invalidCall: _failureCode!

get_ReasonPhrase: reasonPhrase
	"Private - Get the value of the 'ReasonPhrase' property of the receiver.

		HRESULT __stdcall ReasonPhrase(
			[out, retval]LPWSTR* ReasonPhrase);"

	<virtual stdcall: hresult 6 lpwstr*>
	^self invalidCall: _failureCode!

get_StatusCode: statusCode
	"Private - Get the value of the 'StatusCode' property of the receiver.

		HRESULT __stdcall StatusCode(
			[out, retval]int* StatusCode);"

	<virtual stdcall: hresult 5 sdword*>
	^self invalidCall: _failureCode!

getContent: aDyadicValuable
	"Invoke the GetContent() method of the COM object."

	| handler |
	handler := (WebView2CompletionHandler completionBlock: aDyadicValuable)
				queryInterface: ICoreWebView2WebResourceResponseViewGetContentCompletedHandler.
	self GetContent: handler.
	handler free!

GetContent: handler
	"Private - Invoke the GetContent() method of the COM object.

		HRESULT __stdcall GetContent(
			[in]ICoreWebView2WebResourceResponseViewGetContentCompletedHandler* handler);"

	<virtual stdcall: hresult 7 ICoreWebView2WebResourceResponseViewGetContentCompletedHandler*>
	^self invalidCall: _failureCode!

headers
	"Answer the <ICoreWebView2HttpResponseHeaders> value of the 'Headers' property of the receiver."

	| answer |
	answer := ICoreWebView2HttpResponseHeaders newPointer.
	self get_Headers: answer.
	^answer asObject!

printableProperties
	^#(#statusCode #reasonPhrase)!

reasonPhrase
	"Answer the <lpwstr> value of the 'ReasonPhrase' property of the receiver."

	| ptr answer |
	ptr := TaskMemory new.
	self get_ReasonPhrase: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer!

statusCode
	"Answer the <sdword> value of the 'StatusCode' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_StatusCode: answer.
	^answer asObject! !
!WebView2.ICoreWebView2WebResourceResponseView categoriesForMethods!
get_Headers:!**auto generated**!COM Interfaces-ICoreWebView2WebResourceResponseView!private! !
get_ReasonPhrase:!**auto generated**!COM Interfaces-ICoreWebView2WebResourceResponseView!private! !
get_StatusCode:!**auto generated**!COM Interfaces-ICoreWebView2WebResourceResponseView!private! !
getContent:!**auto generated**!methods!public! !
GetContent:!**auto generated**!COM Interfaces-ICoreWebView2WebResourceResponseView!private! !
headers!**auto generated**!properties!public! !
printableProperties!printing!private! !
reasonPhrase!properties!public! !
statusCode!**auto generated**!properties!public! !
!

!WebView2.ICoreWebView2WebResourceResponseView class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2WebResourceResponseView'
		ICoreWebView2WebResourceResponseView defineTemplate"

	self
		defineFunction: #get_Headers:
			argumentTypes: 'ICoreWebView2HttpResponseHeaders**';
		defineFunction: #get_StatusCode:
			argumentTypes: 'sdword*';
		defineFunction: #get_ReasonPhrase:
			argumentTypes: 'lpwstr*';
		defineFunction: #GetContent:
			argumentTypes: 'ICoreWebView2WebResourceResponseViewGetContentCompletedHandler*'
! !
!WebView2.ICoreWebView2WebResourceResponseView class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

