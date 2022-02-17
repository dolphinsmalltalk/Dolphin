"Filed out from Dolphin Smallalk"!

IUnknown subclass: #ICoreWebView2TrySuspendCompletedHandler
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'WebView2Constants'
	classInstanceVariableNames: ''!
ICoreWebView2TrySuspendCompletedHandler guid: (IID fromString: '{00f206a7-9d17-4605-91f6-4e8e4de192e3}')!
ICoreWebView2TrySuspendCompletedHandler comment: '`ICoreWebView2TrySuspendCompletedHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2TrySuspendCompletedHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

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
!ICoreWebView2TrySuspendCompletedHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2TrySuspendCompletedHandler methodsFor!

invoke: errorCode isSuccessful: isSuccessful
	"Invoke the Invoke() method of the COM object."

	^self Invoke: errorCode isSuccessful: isSuccessful!

Invoke: errorCode isSuccessful: isSuccessful
	"Private - Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			[in]HRESULT errorCode,
			[in]long isSuccessful);"

	<virtual stdcall: hresult 4 hresult sdword>
	^self invalidCall: _failureCode! !
!ICoreWebView2TrySuspendCompletedHandler categoriesForMethods!
invoke:isSuccessful:!**auto generated**!methods!public! !
Invoke:isSuccessful:!**auto generated**!COM Interfaces-ICoreWebView2TrySuspendCompletedHandler!private! !
!

!ICoreWebView2TrySuspendCompletedHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2TrySuspendCompletedHandler'
		ICoreWebView2TrySuspendCompletedHandler defineTemplate"

	self
		defineFunction: #Invoke:isSuccessful:
			argumentTypes: 'hresult sdword'
! !
!ICoreWebView2TrySuspendCompletedHandler class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

