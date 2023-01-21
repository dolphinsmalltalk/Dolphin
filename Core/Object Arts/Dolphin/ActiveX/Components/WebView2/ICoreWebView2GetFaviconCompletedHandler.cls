"Filed out from Dolphin Smalltalk"!

ICoreWebView2CompletedHandler subclass: #ICoreWebView2GetFaviconCompletedHandler
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ICoreWebView2GetFaviconCompletedHandler guid: (IID fromString: '{a2508329-7da8-49d7-8c05-fa125e4aee8d}')!
ICoreWebView2GetFaviconCompletedHandler comment: '`ICoreWebView2GetFaviconCompletedHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2GetFaviconCompletedHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(a2508329-7da8-49d7-8c05-fa125e4aee8d)
]
interface ICoreWebView2GetFaviconCompletedHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]HRESULT errorCode,
		[in]IStream* faviconStream);
};
```
'!
!ICoreWebView2GetFaviconCompletedHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2GetFaviconCompletedHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2GetFaviconCompletedHandler'
		ICoreWebView2GetFaviconCompletedHandler defineTemplate
	"

	self
		defineFunction: #Invoke:arg:
			argumentTypes: 'hresult IStream*'
! !
!ICoreWebView2GetFaviconCompletedHandler class categoriesForMethods!
defineFunctions!initializing!public! !
!

