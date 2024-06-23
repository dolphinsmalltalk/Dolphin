"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2CompletedHandler
	subclass: #'WebView2.ICoreWebView2TrySuspendCompletedHandler'
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

!WebView2.ICoreWebView2TrySuspendCompletedHandler methodsFor!

Invoke: invoke arg: arg
	"Callout for the ICoreWebView2TrySuspendCompletedHandler::Invoke() interface function.
	N.B. This method has been automatically generated from 
	the vtable defined in ICoreWebView2TrySuspendCompletedHandler>>defineFunctions. DO NOT MODIFY!!"

	<virtual stdcall: hresult 4 hresult int32>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2TrySuspendCompletedHandler categoriesForMethods!
Invoke:arg:!COM Interfaces-ICoreWebView2TrySuspendCompletedHandler!public! !
!

!WebView2.ICoreWebView2TrySuspendCompletedHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2TrySuspendCompletedHandler'
		ICoreWebView2TrySuspendCompletedHandler compileFunctions
	"

	self defineFunction: #Invoke:arg: argumentTypes: 'hresult sdword'! !

!WebView2.ICoreWebView2TrySuspendCompletedHandler class categoriesForMethods!
defineFunctions!initializing!public!template definition! !
!

