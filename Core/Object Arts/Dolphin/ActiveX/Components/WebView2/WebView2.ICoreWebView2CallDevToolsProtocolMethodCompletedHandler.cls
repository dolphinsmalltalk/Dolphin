"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2CompletedHandler
	subclass: #'WebView2.ICoreWebView2CallDevToolsProtocolMethodCompletedHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2CallDevToolsProtocolMethodCompletedHandler guid: (OS.COM.IID fromString: '{5c4889f0-5ef6-4c5a-952c-d8f1b92d0574}')!

WebView2.ICoreWebView2CallDevToolsProtocolMethodCompletedHandler comment: '`ICoreWebView2CallDevToolsProtocolMethodCompletedHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2CallDevToolsProtocolMethodCompletedHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

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

!WebView2.ICoreWebView2CallDevToolsProtocolMethodCompletedHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2CallDevToolsProtocolMethodCompletedHandler methodsFor!

Invoke: invoke arg: arg
	"Callout for the ICoreWebView2CallDevToolsProtocolMethodCompletedHandler::Invoke() interface function.
	N.B. This method has been automatically generated from 
	the vtable defined in ICoreWebView2CallDevToolsProtocolMethodCompletedHandler>>defineFunctions. DO NOT MODIFY!!"

	<virtual stdcall: hresult 4 hresult lpwstr>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2CallDevToolsProtocolMethodCompletedHandler categoriesForMethods!
Invoke:arg:!COM Interfaces-ICoreWebView2CallDevToolsProtocolMethodCompletedHandler!public! !
!

!WebView2.ICoreWebView2CallDevToolsProtocolMethodCompletedHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2CallDevToolsProtocolMethodCompletedHandler'
		ICoreWebView2CallDevToolsProtocolMethodCompletedHandler compileFunctions
	"

	self defineFunction: #Invoke:arg: argumentTypes: 'hresult lpwstr'! !

!WebView2.ICoreWebView2CallDevToolsProtocolMethodCompletedHandler class categoriesForMethods!
defineFunctions!initializing!public!template definition! !
!

