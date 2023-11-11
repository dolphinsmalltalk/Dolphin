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
!WebView2.ICoreWebView2CreateCoreWebView2ControllerCompletedHandler methodsFor!

Invoke: invoke arg: arg
	"Callout for the ICoreWebView2CreateCoreWebView2ControllerCompletedHandler::Invoke() interface function.
	N.B. This method has been automatically generated from 
	the vtable defined in ICoreWebView2CreateCoreWebView2ControllerCompletedHandler>>defineFunctions. DO NOT MODIFY!!"

	<virtual stdcall: hresult 4 hresult WebView2.ICoreWebView2Controller*>
	^self invalidCall: _failureCode! !
!WebView2.ICoreWebView2CreateCoreWebView2ControllerCompletedHandler categoriesForMethods!
Invoke:arg:!COM Interfaces-ICoreWebView2CreateCoreWebView2ControllerCompletedHandler!public! !
!

!WebView2.ICoreWebView2CreateCoreWebView2ControllerCompletedHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2CreateCoreWebView2ControllerCompletedHandler'
		ICoreWebView2CreateCoreWebView2ControllerCompletedHandler compileFunctions
	"

	self defineFunction: #Invoke:arg: argumentTypes: 'hresult ICoreWebView2Controller*'! !
!WebView2.ICoreWebView2CreateCoreWebView2ControllerCompletedHandler class categoriesForMethods!
defineFunctions!initializing!public!template definition! !
!

