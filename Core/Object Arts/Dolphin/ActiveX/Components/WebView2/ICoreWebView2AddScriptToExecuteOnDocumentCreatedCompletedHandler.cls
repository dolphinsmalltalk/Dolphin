"Filed out from Dolphin Smalltalk"!

ICoreWebView2CompletedHandler subclass: #ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler guid: (IID fromString: '{b99369f3-9b11-47b5-bc6f-8e7895fcea17}')!
ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler comment: '`ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(b99369f3-9b11-47b5-bc6f-8e7895fcea17)
]
interface ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]HRESULT errorCode,
		[in]LPWSTR id);
};
```
'!
!ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler'
		ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler defineTemplate
	"

	self defineFunction: #value:value: argumentTypes: 'hresult lpwstr'! !
!ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler class categoriesForMethods!
defineFunctions!initializing!public! !
!

