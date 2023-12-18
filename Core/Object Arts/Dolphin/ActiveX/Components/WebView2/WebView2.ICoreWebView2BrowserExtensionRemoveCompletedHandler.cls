"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2CompletedHandler
	subclass: #'WebView2.ICoreWebView2BrowserExtensionRemoveCompletedHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2BrowserExtensionRemoveCompletedHandler guid: (OS.COM.IID fromString: '{8e41909a-9b18-4bb1-8cdf-930f467a50be}')!
WebView2.ICoreWebView2BrowserExtensionRemoveCompletedHandler comment: '`ICoreWebView2BrowserExtensionRemoveCompletedHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2BrowserExtensionRemoveCompletedHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(8e41909a-9b18-4bb1-8cdf-930f467a50be)
]
interface ICoreWebView2BrowserExtensionRemoveCompletedHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]HRESULT errorCode);
};
```
'!
!WebView2.ICoreWebView2BrowserExtensionRemoveCompletedHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2BrowserExtensionRemoveCompletedHandler methodsFor!

Invoke: errorCode
	"Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			[in]HRESULT errorCode);"

	<virtual stdcall: hresult 4 hresult>
	^self invalidCall: _failureCode! !
!WebView2.ICoreWebView2BrowserExtensionRemoveCompletedHandler categoriesForMethods!
Invoke:!**auto generated**!COM Interfaces-ICoreWebView2BrowserExtensionRemoveCompletedHandler!public! !
!

!WebView2.ICoreWebView2BrowserExtensionRemoveCompletedHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2BrowserExtensionRemoveCompletedHandler'
		ICoreWebView2BrowserExtensionRemoveCompletedHandler defineTemplate"

	self
		defineFunction: #Invoke:
			argumentTypes: 'hresult'
! !
!WebView2.ICoreWebView2BrowserExtensionRemoveCompletedHandler class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

