"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2CompletedHandler
	subclass: #'WebView2.ICoreWebView2CreateCoreWebView2ControllerCompletedHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2CreateCoreWebView2ControllerCompletedHandler guid: (OS.COM.IID fromString: '{6c4819f3-c9b7-4260-8127-c9f5bde7f68c}')!
WebView2.ICoreWebView2CreateCoreWebView2ControllerCompletedHandler comment: '`ICoreWebView2CreateCoreWebView2ControllerCompletedHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2CreateCoreWebView2ControllerCompletedHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(6c4819f3-c9b7-4260-8127-c9f5bde7f68c)
]
interface ICoreWebView2CreateCoreWebView2ControllerCompletedHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		HRESULT errorCode,
		ICoreWebView2Controller* createdController);
};
```
'!
!WebView2.ICoreWebView2CreateCoreWebView2ControllerCompletedHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2CreateCoreWebView2ControllerCompletedHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2CreateCoreWebView2ControllerCompletedHandler'
		ICoreWebView2CreateCoreWebView2ControllerCompletedHandler defineTemplate
	"

	self defineFunction: #Invoke:arg: argumentTypes: 'hresult ICoreWebView2Controller*'! !
!WebView2.ICoreWebView2CreateCoreWebView2ControllerCompletedHandler class categoriesForMethods!
defineFunctions!initializing!public!template definition! !
!

