"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2CompletedHandler subclass: #'WebView2.ICoreWebView2TrySuspendCompletedHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2TrySuspendCompletedHandler guid: (OS.COM.IID fromString: '{00f206a7-9d17-4605-91f6-4e8e4de192e3}')!
WebView2.ICoreWebView2TrySuspendCompletedHandler comment: '`ICoreWebView2TrySuspendCompletedHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2TrySuspendCompletedHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(00f206a7-9d17-4605-91f6-4e8e4de192e3)
]
interface ICoreWebView2TrySuspendCompletedHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]HRESULT errorCode,
		[in]long isSuccessful);
};
```
'!
!WebView2.ICoreWebView2TrySuspendCompletedHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2TrySuspendCompletedHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2TrySuspendCompletedHandler'
		ICoreWebView2TrySuspendCompletedHandler defineTemplate
	"

	self defineFunction: #Invoke:arg: argumentTypes: 'hresult sdword'! !
!WebView2.ICoreWebView2TrySuspendCompletedHandler class categoriesForMethods!
defineFunctions!initializing!public! !
!

