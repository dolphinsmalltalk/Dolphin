"Filed out from Dolphin Smalltalk"!

ICoreWebView2CompletedHandler subclass: #ICoreWebView2ExecuteScriptCompletedHandler
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ICoreWebView2ExecuteScriptCompletedHandler guid: (IID fromString: '{49511172-cc67-4bca-9923-137112f4c4cc}')!
ICoreWebView2ExecuteScriptCompletedHandler comment: '`ICoreWebView2ExecuteScriptCompletedHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2ExecuteScriptCompletedHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

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
!ICoreWebView2ExecuteScriptCompletedHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2ExecuteScriptCompletedHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2ExecuteScriptCompletedHandler'
		ICoreWebView2ExecuteScriptCompletedHandler defineTemplate
	"

	self defineFunction: #Invoke:arg: argumentTypes: 'hresult lpwstr'! !
!ICoreWebView2ExecuteScriptCompletedHandler class categoriesForMethods!
defineFunctions!initializing!public! !
!

