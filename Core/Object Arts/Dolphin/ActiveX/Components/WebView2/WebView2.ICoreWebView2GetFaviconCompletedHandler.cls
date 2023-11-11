"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2CompletedHandler
	subclass: #'WebView2.ICoreWebView2GetFaviconCompletedHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2GetFaviconCompletedHandler guid: (OS.COM.IID fromString: '{a2508329-7da8-49d7-8c05-fa125e4aee8d}')!
WebView2.ICoreWebView2GetFaviconCompletedHandler comment: '`ICoreWebView2GetFaviconCompletedHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2GetFaviconCompletedHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

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
!WebView2.ICoreWebView2GetFaviconCompletedHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2GetFaviconCompletedHandler methodsFor!

Invoke: invoke arg: arg
	"Callout for the ICoreWebView2GetFaviconCompletedHandler::Invoke() interface function.
	N.B. This method has been automatically generated from 
	the vtable defined in ICoreWebView2GetFaviconCompletedHandler>>defineFunctions. DO NOT MODIFY!!"

	<virtual stdcall: hresult 4 hresult OS.COM.IStream*>
	^self invalidCall: _failureCode! !
!WebView2.ICoreWebView2GetFaviconCompletedHandler categoriesForMethods!
Invoke:arg:!COM Interfaces-ICoreWebView2GetFaviconCompletedHandler!public! !
!

!WebView2.ICoreWebView2GetFaviconCompletedHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2GetFaviconCompletedHandler'
		ICoreWebView2GetFaviconCompletedHandler compileFunctions
	"

	self
		defineFunction: #Invoke:arg:
			argumentTypes: 'hresult IStream*'
! !
!WebView2.ICoreWebView2GetFaviconCompletedHandler class categoriesForMethods!
defineFunctions!initializing!public!template definition! !
!

