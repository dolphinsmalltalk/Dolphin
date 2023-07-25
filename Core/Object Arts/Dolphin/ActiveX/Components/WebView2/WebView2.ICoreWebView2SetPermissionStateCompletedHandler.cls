"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2CompletedHandler
	subclass: #'WebView2.ICoreWebView2SetPermissionStateCompletedHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2SetPermissionStateCompletedHandler guid: (OS.COM.IID fromString: '{fc77fb30-9c9e-4076-b8c7-7644a703ca1b}')!
WebView2.ICoreWebView2SetPermissionStateCompletedHandler comment: '`ICoreWebView2SetPermissionStateCompletedHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2SetPermissionStateCompletedHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(fc77fb30-9c9e-4076-b8c7-7644a703ca1b)
]
interface ICoreWebView2SetPermissionStateCompletedHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]HRESULT errorCode);
};
```
'!
!WebView2.ICoreWebView2SetPermissionStateCompletedHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2SetPermissionStateCompletedHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2SetPermissionStateCompletedHandler'
		ICoreWebView2SetPermissionStateCompletedHandler defineTemplate"

	self
		defineFunction: #Invoke:
			argumentTypes: 'hresult'
! !
!WebView2.ICoreWebView2SetPermissionStateCompletedHandler class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

