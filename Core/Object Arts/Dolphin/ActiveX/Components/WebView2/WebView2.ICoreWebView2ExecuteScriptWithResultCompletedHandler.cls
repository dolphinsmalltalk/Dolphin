"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2CompletedHandler
	subclass: #'WebView2.ICoreWebView2ExecuteScriptWithResultCompletedHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2ExecuteScriptWithResultCompletedHandler guid: (OS.COM.IID fromString: '{1bb5317b-8238-4c67-a7ff-baf6558f289d}')!

WebView2.ICoreWebView2ExecuteScriptWithResultCompletedHandler comment: '`ICoreWebView2ExecuteScriptWithResultCompletedHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2ExecuteScriptWithResultCompletedHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(1bb5317b-8238-4c67-a7ff-baf6558f289d)
]
interface ICoreWebView2ExecuteScriptWithResultCompletedHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]HRESULT errorCode,
		[in]ICoreWebView2ExecuteScriptResult* result);
};
```
'!

!WebView2.ICoreWebView2ExecuteScriptWithResultCompletedHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2ExecuteScriptWithResultCompletedHandler methodsFor!

Invoke: errorCode arg: result
	"Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			[in]HRESULT errorCode,
			[in]ICoreWebView2ExecuteScriptResult* result);"

	<virtual stdcall: hresult 4 hresult ICoreWebView2ExecuteScriptResult*>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2ExecuteScriptWithResultCompletedHandler categoriesForMethods!
Invoke:arg:!COM Interfaces-ICoreWebView2ExecuteScriptWithResultCompletedHandler!public! !
!

!WebView2.ICoreWebView2ExecuteScriptWithResultCompletedHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2ExecuteScriptWithResultCompletedHandler'
		ICoreWebView2ExecuteScriptWithResultCompletedHandler defineTemplate"

	self
		defineFunction: #Invoke:arg:
			argumentTypes: 'hresult ICoreWebView2ExecuteScriptResult*'
! !

!WebView2.ICoreWebView2ExecuteScriptWithResultCompletedHandler class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

