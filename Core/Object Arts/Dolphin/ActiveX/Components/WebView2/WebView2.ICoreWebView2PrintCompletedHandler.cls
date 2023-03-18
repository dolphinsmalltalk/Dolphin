"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2CompletedHandler
	subclass: #'WebView2.ICoreWebView2PrintCompletedHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2PrintCompletedHandler guid: (OS.COM.IID fromString: '{8fd80075-ed08-42db-8570-f5d14977461e}')!
WebView2.ICoreWebView2PrintCompletedHandler comment: '`ICoreWebView2PrintCompletedHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2PrintCompletedHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(8fd80075-ed08-42db-8570-f5d14977461e)
]
interface ICoreWebView2PrintCompletedHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]HRESULT errorCode,
		[in]COREWEBVIEW2_PRINT_STATUS printStatus);
};
```
'!
!WebView2.ICoreWebView2PrintCompletedHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2PrintCompletedHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2PrintCompletedHandler'
		ICoreWebView2PrintCompletedHandler defineTemplate"

	self
		defineFunction: #Invoke:arg:
			argumentTypes: 'hresult sdword'
! !
!WebView2.ICoreWebView2PrintCompletedHandler class categoriesForMethods!
defineFunctions!initializing!public! !
!

