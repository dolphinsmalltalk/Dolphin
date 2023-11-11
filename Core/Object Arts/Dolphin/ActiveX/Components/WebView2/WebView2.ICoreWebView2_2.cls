"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2
	subclass: #'WebView2.ICoreWebView2_2'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2_2 guid: (OS.COM.IID fromString: '{9e8f0cf8-e670-4b5e-b2bc-73e061e3184c}')!
WebView2.ICoreWebView2_2 isEgressOnly: true!
WebView2.ICoreWebView2_2 comment: '`ICoreWebView2_2` is a wrapper class for the COM interface ''WebView2.ICoreWebView2_2'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(9e8f0cf8-e670-4b5e-b2bc-73e061e3184c)
]
interface ICoreWebView2_2 : ICoreWebView2
 {
	[id(0x60020000)]
	HRESULT __stdcall add_WebResourceResponseReceived(
		[in]ICoreWebView2WebResourceResponseReceivedEventHandler* eventHandler,
		[out]EventRegistrationToken* token);
	[id(0x60020001)]
	HRESULT __stdcall remove_WebResourceResponseReceived(
		[in]EventRegistrationToken token);
	[id(0x60020002)]
	HRESULT __stdcall NavigateWithWebResourceRequest(
		[in]ICoreWebView2WebResourceRequest* Request);
	[id(0x60020003)]
	HRESULT __stdcall add_DOMContentLoaded(
		[in]ICoreWebView2DOMContentLoadedEventHandler* eventHandler,
		[out]EventRegistrationToken* token);
	[id(0x60020004)]
	HRESULT __stdcall remove_DOMContentLoaded(
		[in]EventRegistrationToken token);
	[id(0x60020005), propget]
	HRESULT __stdcall CookieManager(
		[out, retval]ICoreWebView2CookieManager** CookieManager);
	[id(0x60020006), propget]
	HRESULT __stdcall Environment(
		[out, retval]ICoreWebView2Environment** Environment);
};
```
'!
!WebView2.ICoreWebView2_2 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2_2 methodsFor!

Add_DOMContentLoaded: eventHandler token: token
	"Private - Invoke the add_DOMContentLoaded() method of the COM object.

		HRESULT __stdcall add_DOMContentLoaded(
			[in]ICoreWebView2DOMContentLoadedEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 65 ICoreWebView2DOMContentLoadedEventHandler* int64*>
	^self invalidCall: _failureCode!

Add_WebResourceResponseReceived: eventHandler token: token
	"Private - Invoke the add_WebResourceResponseReceived() method of the COM object.

		HRESULT __stdcall add_WebResourceResponseReceived(
			[in]ICoreWebView2WebResourceResponseReceivedEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 62 ICoreWebView2WebResourceResponseReceivedEventHandler* int64*>
	^self invalidCall: _failureCode!

get_CookieManager: cookieManager
	"Private - Get the value of the 'CookieManager' property of the receiver.

		HRESULT __stdcall CookieManager(
			[out, retval]ICoreWebView2CookieManager** CookieManager);"

	<virtual stdcall: hresult 67 ICoreWebView2CookieManager**>
	^self invalidCall: _failureCode!

get_Environment: environment
	"Private - Get the value of the 'Environment' property of the receiver.

		HRESULT __stdcall Environment(
			[out, retval]ICoreWebView2Environment** Environment);"

	<virtual stdcall: hresult 68 ICoreWebView2Environment**>
	^self invalidCall: _failureCode!

NavigateWithWebResourceRequest: request
	"Private - Invoke the NavigateWithWebResourceRequest() method of the COM object.

		HRESULT __stdcall NavigateWithWebResourceRequest(
			[in]ICoreWebView2WebResourceRequest* Request);"

	<virtual stdcall: hresult 64 ICoreWebView2WebResourceRequest*>
	^self invalidCall: _failureCode!

Remove_DOMContentLoaded: token
	"Private - Invoke the remove_DOMContentLoaded() method of the COM object.

		HRESULT __stdcall remove_DOMContentLoaded(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 66 int64>
	^self invalidCall: _failureCode!

Remove_WebResourceResponseReceived: token
	"Private - Invoke the remove_WebResourceResponseReceived() method of the COM object.

		HRESULT __stdcall remove_WebResourceResponseReceived(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 63 int64>
	^self invalidCall: _failureCode! !
!WebView2.ICoreWebView2_2 categoriesForMethods!
Add_DOMContentLoaded:token:!**auto generated**!COM Interfaces-ICoreWebView2_2!private! !
Add_WebResourceResponseReceived:token:!**auto generated**!COM Interfaces-ICoreWebView2_2!private! !
get_CookieManager:!**auto generated**!COM Interfaces-ICoreWebView2_2!private! !
get_Environment:!**auto generated**!COM Interfaces-ICoreWebView2_2!private! !
NavigateWithWebResourceRequest:!**auto generated**!COM Interfaces-ICoreWebView2_2!private! !
Remove_DOMContentLoaded:!**auto generated**!COM Interfaces-ICoreWebView2_2!private! !
Remove_WebResourceResponseReceived:!**auto generated**!COM Interfaces-ICoreWebView2_2!private! !
!

!WebView2.ICoreWebView2_2 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2_2'
		ICoreWebView2_2 defineTemplate"

	self
		defineFunction: #Add_WebResourceResponseReceived:token:
			argumentTypes: 'ICoreWebView2WebResourceResponseReceivedEventHandler* sqword*';
		defineFunction: #Remove_WebResourceResponseReceived:
			argumentTypes: 'sqword';
		defineFunction: #NavigateWithWebResourceRequest:
			argumentTypes: 'ICoreWebView2WebResourceRequest*';
		defineFunction: #Add_DOMContentLoaded:token:
			argumentTypes: 'ICoreWebView2DOMContentLoadedEventHandler* sqword*';
		defineFunction: #Remove_DOMContentLoaded:
			argumentTypes: 'sqword';
		defineFunction: #get_CookieManager:
			argumentTypes: 'ICoreWebView2CookieManager**';
		defineFunction: #get_Environment:
			argumentTypes: 'ICoreWebView2Environment**'
! !
!WebView2.ICoreWebView2_2 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

