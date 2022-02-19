"Filed out from Dolphin Smallalk"!

ICoreWebViewCompletedHandler subclass: #ICoreWebView2CallDevToolsProtocolMethodCompletedHandler
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ICoreWebView2CallDevToolsProtocolMethodCompletedHandler guid: (IID fromString: '{5c4889f0-5ef6-4c5a-952c-d8f1b92d0574}')!
ICoreWebView2CallDevToolsProtocolMethodCompletedHandler comment: '`ICoreWebView2CallDevToolsProtocolMethodCompletedHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2CallDevToolsProtocolMethodCompletedHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(5c4889f0-5ef6-4c5a-952c-d8f1b92d0574)
]
interface ICoreWebView2CallDevToolsProtocolMethodCompletedHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]HRESULT errorCode,
		[in]LPWSTR returnObjectAsJson);
};
```
'!
!ICoreWebView2CallDevToolsProtocolMethodCompletedHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2CallDevToolsProtocolMethodCompletedHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2CallDevToolsProtocolMethodCompletedHandler'
		ICoreWebView2CallDevToolsProtocolMethodCompletedHandler defineTemplate
	"

	self defineFunction: #value:value: argumentTypes: 'hresult lpwstr'! !
!ICoreWebView2CallDevToolsProtocolMethodCompletedHandler class categoriesForMethods!
defineFunctions!initializing!public! !
!

