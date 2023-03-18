"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2CompletedHandler
	subclass: #'WebView2.ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler guid: (OS.COM.IID fromString: '{b99369f3-9b11-47b5-bc6f-8e7895fcea17}')!
WebView2.ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler comment: '`ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

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
!WebView2.ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler'
		ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler defineTemplate
	"

	self defineFunction: #Invoke:arg: argumentTypes: 'hresult lpwstr'! !
!WebView2.ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler class categoriesForMethods!
defineFunctions!initializing!public! !
!

