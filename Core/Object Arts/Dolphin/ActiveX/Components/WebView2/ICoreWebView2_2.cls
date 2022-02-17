"Filed out from Dolphin Smallalk"!

ICoreWebView2 subclass: #ICoreWebView2_2
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'WebView2Constants'
	classInstanceVariableNames: ''!
ICoreWebView2_2 guid: (IID fromString: '{9e8f0cf8-e670-4b5e-b2bc-73e061e3184c}')!
ICoreWebView2_2 comment: '`ICoreWebView2_2` is a wrapper class for the COM interface ''WebView2.ICoreWebView2_2'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

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
!ICoreWebView2_2 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2_2 methodsFor!

add_DOMContentLoaded: eventHandler
	"Answer the <EventRegistrationToken> result of invoking the add_DOMContentLoaded() method of the COM object."

	| answer |
	answer := EventRegistrationToken new.
	self Add_DOMContentLoaded: eventHandler token: answer.
	^answer asObject!

Add_DOMContentLoaded: eventHandler token: token
	"Private - Invoke the add_DOMContentLoaded() method of the COM object.

		HRESULT __stdcall add_DOMContentLoaded(
			[in]ICoreWebView2DOMContentLoadedEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 65 ICoreWebView2DOMContentLoadedEventHandler* EventRegistrationToken*>
	^self invalidCall: _failureCode!

add_WebResourceResponseReceived: eventHandler
	"Answer the <EventRegistrationToken> result of invoking the add_WebResourceResponseReceived() method of the COM object."

	| answer |
	answer := EventRegistrationToken new.
	self Add_WebResourceResponseReceived: eventHandler token: answer.
	^answer asObject!

Add_WebResourceResponseReceived: eventHandler token: token
	"Private - Invoke the add_WebResourceResponseReceived() method of the COM object.

		HRESULT __stdcall add_WebResourceResponseReceived(
			[in]ICoreWebView2WebResourceResponseReceivedEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 62 ICoreWebView2WebResourceResponseReceivedEventHandler* EventRegistrationToken*>
	^self invalidCall: _failureCode!

cookieManager
	"Answer the <ICoreWebView2CookieManager> value of the 'CookieManager' property of the receiver."

	| answer |
	answer := ICoreWebView2CookieManager newPointer.
	self get_CookieManager: answer.
	^answer asObject!

environment
	"Answer the <ICoreWebView2Environment> value of the 'Environment' property of the receiver."

	| answer |
	answer := ICoreWebView2Environment newPointer.
	self get_Environment: answer.
	^answer asObject!

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

navigateWithWebResourceRequest: request
	"Invoke the NavigateWithWebResourceRequest() method of the COM object."

	^self NavigateWithWebResourceRequest: request!

NavigateWithWebResourceRequest: request
	"Private - Invoke the NavigateWithWebResourceRequest() method of the COM object.

		HRESULT __stdcall NavigateWithWebResourceRequest(
			[in]ICoreWebView2WebResourceRequest* Request);"

	<virtual stdcall: hresult 64 ICoreWebView2WebResourceRequest*>
	^self invalidCall: _failureCode!

remove_DOMContentLoaded: token
	"Invoke the remove_DOMContentLoaded() method of the COM object."

	^self Remove_DOMContentLoaded: token!

Remove_DOMContentLoaded: token
	"Private - Invoke the remove_DOMContentLoaded() method of the COM object.

		HRESULT __stdcall remove_DOMContentLoaded(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 66 EventRegistrationToken>
	^self invalidCall: _failureCode!

remove_WebResourceResponseReceived: token
	"Invoke the remove_WebResourceResponseReceived() method of the COM object."

	^self Remove_WebResourceResponseReceived: token!

Remove_WebResourceResponseReceived: token
	"Private - Invoke the remove_WebResourceResponseReceived() method of the COM object.

		HRESULT __stdcall remove_WebResourceResponseReceived(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 63 EventRegistrationToken>
	^self invalidCall: _failureCode! !
!ICoreWebView2_2 categoriesForMethods!
add_DOMContentLoaded:!**auto generated**!methods!public! !
Add_DOMContentLoaded:token:!**auto generated**!COM Interfaces-ICoreWebView2_2!private! !
add_WebResourceResponseReceived:!**auto generated**!methods!public! !
Add_WebResourceResponseReceived:token:!**auto generated**!COM Interfaces-ICoreWebView2_2!private! !
cookieManager!**auto generated**!properties!public! !
environment!**auto generated**!properties!public! !
get_CookieManager:!**auto generated**!COM Interfaces-ICoreWebView2_2!private! !
get_Environment:!**auto generated**!COM Interfaces-ICoreWebView2_2!private! !
navigateWithWebResourceRequest:!**auto generated**!methods!public! !
NavigateWithWebResourceRequest:!**auto generated**!COM Interfaces-ICoreWebView2_2!private! !
remove_DOMContentLoaded:!**auto generated**!methods!public! !
Remove_DOMContentLoaded:!**auto generated**!COM Interfaces-ICoreWebView2_2!private! !
remove_WebResourceResponseReceived:!**auto generated**!methods!public! !
Remove_WebResourceResponseReceived:!**auto generated**!COM Interfaces-ICoreWebView2_2!private! !
!

!ICoreWebView2_2 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2_2'
		ICoreWebView2_2 defineTemplate"

	self
		defineFunction: #Add_WebResourceResponseReceived:token:
			argumentTypes: 'ICoreWebView2WebResourceResponseReceivedEventHandler* EventRegistrationToken*';
		defineFunction: #Remove_WebResourceResponseReceived:
			argumentTypes: 'EventRegistrationToken';
		defineFunction: #NavigateWithWebResourceRequest:
			argumentTypes: 'ICoreWebView2WebResourceRequest*';
		defineFunction: #Add_DOMContentLoaded:token:
			argumentTypes: 'ICoreWebView2DOMContentLoadedEventHandler* EventRegistrationToken*';
		defineFunction: #Remove_DOMContentLoaded:
			argumentTypes: 'EventRegistrationToken';
		defineFunction: #get_CookieManager:
			argumentTypes: 'ICoreWebView2CookieManager**';
		defineFunction: #get_Environment:
			argumentTypes: 'ICoreWebView2Environment**'
! !
!ICoreWebView2_2 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

