"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2CompletedHandler
	subclass: #'WebView2.ICoreWebView2CapturePreviewCompletedHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2CapturePreviewCompletedHandler guid: (OS.COM.IID fromString: '{697e05e9-3d8f-45fa-96f4-8ffe1ededaf5}')!
WebView2.ICoreWebView2CapturePreviewCompletedHandler comment: '`ICoreWebView2CapturePreviewCompletedHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2CapturePreviewCompletedHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(697e05e9-3d8f-45fa-96f4-8ffe1ededaf5)
]
interface ICoreWebView2CapturePreviewCompletedHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]HRESULT errorCode);
};
```
'!
!WebView2.ICoreWebView2CapturePreviewCompletedHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2CapturePreviewCompletedHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2CapturePreviewCompletedHandler'
		ICoreWebView2CapturePreviewCompletedHandler defineTemplate
	"

	self defineFunction: #Invoke: argumentTypes: 'hresult'! !
!WebView2.ICoreWebView2CapturePreviewCompletedHandler class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

