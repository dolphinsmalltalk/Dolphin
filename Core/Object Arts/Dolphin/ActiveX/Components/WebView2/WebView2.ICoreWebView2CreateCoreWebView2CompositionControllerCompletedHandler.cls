"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2CompletedHandler
	subclass: #'WebView2.ICoreWebView2CreateCoreWebView2CompositionControllerCompletedHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2CreateCoreWebView2CompositionControllerCompletedHandler guid: (OS.COM.IID fromString: '{02fab84b-1428-4fb7-ad45-1b2e64736184}')!

WebView2.ICoreWebView2CreateCoreWebView2CompositionControllerCompletedHandler comment: '`ICoreWebView2CreateCoreWebView2CompositionControllerCompletedHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2CreateCoreWebView2CompositionControllerCompletedHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(02fab84b-1428-4fb7-ad45-1b2e64736184)
]
interface ICoreWebView2CreateCoreWebView2CompositionControllerCompletedHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		HRESULT errorCode,
		ICoreWebView2CompositionController* webView);
};
```
'!

!WebView2.ICoreWebView2CreateCoreWebView2CompositionControllerCompletedHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2CreateCoreWebView2CompositionControllerCompletedHandler methodsFor!

Invoke: invoke arg: arg
	"Callout for the ICoreWebView2CreateCoreWebView2CompositionControllerCompletedHandler::Invoke() interface function.
	N.B. This method has been automatically generated from 
	the vtable defined in ICoreWebView2CreateCoreWebView2CompositionControllerCompletedHandler>>defineFunctions. DO NOT MODIFY!!"

	<virtual stdcall: hresult 4 hresult WebView2.ICoreWebView2CompositionController*>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2CreateCoreWebView2CompositionControllerCompletedHandler categoriesForMethods!
Invoke:arg:!COM Interfaces-ICoreWebView2CreateCoreWebView2CompositionControllerCompletedHandler!public! !
!

!WebView2.ICoreWebView2CreateCoreWebView2CompositionControllerCompletedHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2CreateCoreWebView2CompositionControllerCompletedHandler'
		ICoreWebView2CreateCoreWebView2CompositionControllerCompletedHandler compileFunctions
	"

	self defineFunction: #Invoke:arg: argumentTypes: 'hresult ICoreWebView2CompositionController*'! !

!WebView2.ICoreWebView2CreateCoreWebView2CompositionControllerCompletedHandler class categoriesForMethods!
defineFunctions!initializing!public!template definition! !
!

