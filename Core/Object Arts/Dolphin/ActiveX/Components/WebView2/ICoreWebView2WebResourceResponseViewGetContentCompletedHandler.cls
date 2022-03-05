"Filed out from Dolphin Smalltalk"!

ICoreWebView2CompletedHandler subclass: #ICoreWebView2WebResourceResponseViewGetContentCompletedHandler
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ICoreWebView2WebResourceResponseViewGetContentCompletedHandler guid: (IID fromString: '{875738e1-9fa2-40e3-8b74-2e8972dd6fe7}')!
ICoreWebView2WebResourceResponseViewGetContentCompletedHandler comment: '`ICoreWebView2WebResourceResponseViewGetContentCompletedHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2WebResourceResponseViewGetContentCompletedHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

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
!ICoreWebView2WebResourceResponseViewGetContentCompletedHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2WebResourceResponseViewGetContentCompletedHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2WebResourceResponseViewGetContentCompletedHandler'
		ICoreWebView2WebResourceResponseViewGetContentCompletedHandler defineTemplate
	"

	self defineFunction: #value:value: argumentTypes: 'hresult IStream*'! !
!ICoreWebView2WebResourceResponseViewGetContentCompletedHandler class categoriesForMethods!
defineFunctions!initializing!public! !
!

