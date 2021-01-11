"Filed out from Dolphin Smalltalk 7"!

OS.COM.IUnknown subclass: #'WebView2.ICoreWebView2WebResourceRequestedEventArgs'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2WebResourceRequestedEventArgs guid: (OS.COM.IID fromString: '{453e667f-12c7-49d4-be6d-ddbe7956f57a}')!
WebView2.ICoreWebView2WebResourceRequestedEventArgs comment: '`ICoreWebView2WebResourceRequestedEventArgs` is a wrapper class for the COM interface ''WebView2.ICoreWebView2WebResourceRequestedEventArgs'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(453e667f-12c7-49d4-be6d-ddbe7956f57a)
]
interface ICoreWebView2WebResourceRequestedEventArgs : IUnknown
 {
	[id(0x60010000), propget]
	HRESULT __stdcall Request(
		[out, retval]ICoreWebView2WebResourceRequest** Request);
	[id(0x60010001), propget]
	HRESULT __stdcall Response(
		[out, retval]ICoreWebView2WebResourceResponse** Response);
	[id(0x60010001), propput]
	HRESULT __stdcall Response(
		[in]ICoreWebView2WebResourceResponse* Response);
	[id(0x60010003)]
	HRESULT __stdcall GetDeferral(
		[out, retval]ICoreWebView2Deferral** deferral);
	[id(0x60010004), propget]
	HRESULT __stdcall ResourceContext(
		[out, retval]COREWEBVIEW2_WEB_RESOURCE_CONTEXT* context);
};
```
'!
!WebView2.ICoreWebView2WebResourceRequestedEventArgs categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2WebResourceRequestedEventArgs methodsFor!

get_Request: request
	"Private - Get the value of the 'Request' property of the receiver.

		HRESULT __stdcall Request(
			[out, retval]ICoreWebView2WebResourceRequest** Request);"

	<virtual stdcall: hresult 4 ICoreWebView2WebResourceRequest**>
	^self invalidCall: _failureCode!

get_ResourceContext: context
	"Private - Get the value of the 'ResourceContext' property of the receiver.

		HRESULT __stdcall ResourceContext(
			[out, retval]COREWEBVIEW2_WEB_RESOURCE_CONTEXT* context);"

	<virtual stdcall: hresult 8 sdword*>
	^self invalidCall: _failureCode!

get_Response: response
	"Private - Get the value of the 'Response' property of the receiver.

		HRESULT __stdcall Response(
			[out, retval]ICoreWebView2WebResourceResponse** Response);"

	<virtual stdcall: hresult 5 ICoreWebView2WebResourceResponse**>
	^self invalidCall: _failureCode!

getDeferral
	"Answer the <ICoreWebView2Deferral> result of invoking the GetDeferral() method of the COM object."

	| answer |
	answer := ICoreWebView2Deferral newPointer.
	self GetDeferral: answer.
	^answer asObject!

GetDeferral: deferral
	"Private - Invoke the GetDeferral() method of the COM object.

		HRESULT __stdcall GetDeferral(
			[out, retval]ICoreWebView2Deferral** deferral);"

	<virtual stdcall: hresult 7 ICoreWebView2Deferral**>
	^self invalidCall: _failureCode!

put_Response: response
	"Private - Set the value of the 'Response' property of the object wrapped by the 
	 receiver to the <ICoreWebView2WebResourceResponse*> argument, response.

		HRESULT __stdcall Response(
			[in]ICoreWebView2WebResourceResponse* Response);"

	<virtual stdcall: hresult 6 ICoreWebView2WebResourceResponse*>
	^self invalidCall: _failureCode!

request
	"Answer the <ICoreWebView2WebResourceRequest> value of the 'Request' property of the receiver."

	| answer |
	answer := ICoreWebView2WebResourceRequest newPointer.
	self get_Request: answer.
	^answer asObject!

resourceContext
	"Answer the <sdword> value of the 'ResourceContext' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_ResourceContext: answer.
	^answer asObject!

response
	"Answer the <ICoreWebView2WebResourceResponse> value of the 'Response' property of the receiver."

	| answer |
	answer := ICoreWebView2WebResourceResponse newPointer.
	self get_Response: answer.
	^answer asObject!

response: response
	"Set the 'Response' property of the receiver to the <ICoreWebView2WebResourceResponse*> value of the argument."

	self put_Response: response! !
!WebView2.ICoreWebView2WebResourceRequestedEventArgs categoriesFor: #get_Request:!**auto generated**!COM Interfaces-ICoreWebView2WebResourceRequestedEventArgs!private! !
!WebView2.ICoreWebView2WebResourceRequestedEventArgs categoriesFor: #get_ResourceContext:!**auto generated**!COM Interfaces-ICoreWebView2WebResourceRequestedEventArgs!private! !
!WebView2.ICoreWebView2WebResourceRequestedEventArgs categoriesFor: #get_Response:!**auto generated**!COM Interfaces-ICoreWebView2WebResourceRequestedEventArgs!private! !
!WebView2.ICoreWebView2WebResourceRequestedEventArgs categoriesFor: #getDeferral!**auto generated**!methods!public! !
!WebView2.ICoreWebView2WebResourceRequestedEventArgs categoriesFor: #GetDeferral:!**auto generated**!COM Interfaces-ICoreWebView2WebResourceRequestedEventArgs!private! !
!WebView2.ICoreWebView2WebResourceRequestedEventArgs categoriesFor: #put_Response:!**auto generated**!COM Interfaces-ICoreWebView2WebResourceRequestedEventArgs!private! !
!WebView2.ICoreWebView2WebResourceRequestedEventArgs categoriesFor: #request!**auto generated**!properties!public! !
!WebView2.ICoreWebView2WebResourceRequestedEventArgs categoriesFor: #resourceContext!**auto generated**!properties!public! !
!WebView2.ICoreWebView2WebResourceRequestedEventArgs categoriesFor: #response!**auto generated**!properties!public! !
!WebView2.ICoreWebView2WebResourceRequestedEventArgs categoriesFor: #response:!**auto generated**!properties!public! !

!WebView2.ICoreWebView2WebResourceRequestedEventArgs class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2WebResourceRequestedEventArgs'
		ICoreWebView2WebResourceRequestedEventArgs defineTemplate"

	self
		defineFunction: #get_Request:
			argumentTypes: 'ICoreWebView2WebResourceRequest**';
		defineFunction: #get_Response:
			argumentTypes: 'ICoreWebView2WebResourceResponse**';
		defineFunction: #put_Response:
			argumentTypes: 'ICoreWebView2WebResourceResponse*';
		defineFunction: #GetDeferral:
			argumentTypes: 'ICoreWebView2Deferral**';
		defineFunction: #get_ResourceContext:
			argumentTypes: 'sdword*'
! !
!WebView2.ICoreWebView2WebResourceRequestedEventArgs class categoriesFor: #defineFunctions!**auto generated**!initializing!private! !

