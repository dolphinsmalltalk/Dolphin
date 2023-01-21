"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2CompletedHandler subclass: #'WebView2.ICoreWebView2GetCookiesCompletedHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2GetCookiesCompletedHandler guid: (OS.COM.IID fromString: '{5a4f5069-5c15-47c3-8646-f4de1c116670}')!
WebView2.ICoreWebView2GetCookiesCompletedHandler comment: '`ICoreWebView2GetCookiesCompletedHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2GetCookiesCompletedHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(5a4f5069-5c15-47c3-8646-f4de1c116670)
]
interface ICoreWebView2GetCookiesCompletedHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		HRESULT result,
		ICoreWebView2CookieList* cookieList);
};
```
'!
!WebView2.ICoreWebView2GetCookiesCompletedHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2GetCookiesCompletedHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2GetCookiesCompletedHandler'
		ICoreWebView2GetCookiesCompletedHandler defineTemplate
	"

	self defineFunction: #Invoke:arg: argumentTypes: 'hresult ICoreWebView2CookieList*'! !
!WebView2.ICoreWebView2GetCookiesCompletedHandler class categoriesForMethods!
defineFunctions!initializing!public! !
!

