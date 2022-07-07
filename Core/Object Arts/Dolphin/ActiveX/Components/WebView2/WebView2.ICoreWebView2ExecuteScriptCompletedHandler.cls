﻿"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2CompletedHandler subclass: #'WebView2.ICoreWebView2ExecuteScriptCompletedHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2ExecuteScriptCompletedHandler guid: (OS.COM.IID fromString: '{49511172-cc67-4bca-9923-137112f4c4cc}')!
WebView2.ICoreWebView2ExecuteScriptCompletedHandler comment: '`ICoreWebView2ExecuteScriptCompletedHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2ExecuteScriptCompletedHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(49511172-cc67-4bca-9923-137112f4c4cc)
]
interface ICoreWebView2ExecuteScriptCompletedHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]HRESULT errorCode,
		[in]LPWSTR resultObjectAsJson);
};
```
'!
!WebView2.ICoreWebView2ExecuteScriptCompletedHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2ExecuteScriptCompletedHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2ExecuteScriptCompletedHandler'
		ICoreWebView2ExecuteScriptCompletedHandler defineTemplate
	"

	self defineFunction: #value:value: argumentTypes: 'hresult lpwstr'! !
!WebView2.ICoreWebView2ExecuteScriptCompletedHandler class categoriesForMethods!
defineFunctions!initializing!public! !
!
