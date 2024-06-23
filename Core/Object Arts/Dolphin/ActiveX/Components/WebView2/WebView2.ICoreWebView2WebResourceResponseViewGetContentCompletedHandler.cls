"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2CompletedHandler
	subclass: #'WebView2.ICoreWebView2WebResourceResponseViewGetContentCompletedHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2WebResourceResponseViewGetContentCompletedHandler guid: (OS.COM.IID fromString: '{875738e1-9fa2-40e3-8b74-2e8972dd6fe7}')!

WebView2.ICoreWebView2WebResourceResponseViewGetContentCompletedHandler comment: '`ICoreWebView2WebResourceResponseViewGetContentCompletedHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2WebResourceResponseViewGetContentCompletedHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(875738e1-9fa2-40e3-8b74-2e8972dd6fe7)
]
interface ICoreWebView2WebResourceResponseViewGetContentCompletedHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]HRESULT errorCode,
		[in]IStream* Content);
};
```
'!

!WebView2.ICoreWebView2WebResourceResponseViewGetContentCompletedHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2WebResourceResponseViewGetContentCompletedHandler methodsFor!

Invoke: invoke arg: arg
	"Callout for the ICoreWebView2WebResourceResponseViewGetContentCompletedHandler::Invoke() interface function.
	N.B. This method has been automatically generated from 
	the vtable defined in ICoreWebView2WebResourceResponseViewGetContentCompletedHandler>>defineFunctions. DO NOT MODIFY!!"

	<virtual stdcall: hresult 4 hresult OS.COM.IStream*>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2WebResourceResponseViewGetContentCompletedHandler categoriesForMethods!
Invoke:arg:!COM Interfaces-ICoreWebView2WebResourceResponseViewGetContentCompletedHandler!public! !
!

!WebView2.ICoreWebView2WebResourceResponseViewGetContentCompletedHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2WebResourceResponseViewGetContentCompletedHandler'
		ICoreWebView2WebResourceResponseViewGetContentCompletedHandler compileFunctions
	"

	self defineFunction: #Invoke:arg: argumentTypes: 'hresult IStream*'! !

!WebView2.ICoreWebView2WebResourceResponseViewGetContentCompletedHandler class categoriesForMethods!
defineFunctions!initializing!public!template definition! !
!

