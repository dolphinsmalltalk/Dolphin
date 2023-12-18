"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2CompletedHandler
	subclass: #'WebView2.ICoreWebView2BrowserExtensionEnableCompletedHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2BrowserExtensionEnableCompletedHandler guid: (OS.COM.IID fromString: '{30c186ce-7fad-421f-a3bc-a8eaf071ddb8}')!
WebView2.ICoreWebView2BrowserExtensionEnableCompletedHandler comment: '`ICoreWebView2BrowserExtensionEnableCompletedHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2BrowserExtensionEnableCompletedHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(30c186ce-7fad-421f-a3bc-a8eaf071ddb8)
]
interface ICoreWebView2BrowserExtensionEnableCompletedHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]HRESULT errorCode);
};
```
'!
!WebView2.ICoreWebView2BrowserExtensionEnableCompletedHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2BrowserExtensionEnableCompletedHandler methodsFor!

Invoke: errorCode
	"Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			[in]HRESULT errorCode);"

	<virtual stdcall: hresult 4 hresult>
	^self invalidCall: _failureCode! !
!WebView2.ICoreWebView2BrowserExtensionEnableCompletedHandler categoriesForMethods!
Invoke:!**auto generated**!COM Interfaces-ICoreWebView2BrowserExtensionEnableCompletedHandler!public! !
!

!WebView2.ICoreWebView2BrowserExtensionEnableCompletedHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2BrowserExtensionEnableCompletedHandler'
		ICoreWebView2BrowserExtensionEnableCompletedHandler defineTemplate"

	self
		defineFunction: #Invoke:
			argumentTypes: 'hresult'
! !
!WebView2.ICoreWebView2BrowserExtensionEnableCompletedHandler class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

