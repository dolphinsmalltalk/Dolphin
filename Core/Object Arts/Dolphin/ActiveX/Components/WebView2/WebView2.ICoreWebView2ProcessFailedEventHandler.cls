"Filed out from Dolphin Smalltalk 7"!

OS.COM.IUnknown subclass: #'WebView2.ICoreWebView2ProcessFailedEventHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2ProcessFailedEventHandler guid: (OS.COM.IID fromString: '{79e0aea4-990b-42d9-aa1d-0fcc2e5bc7f1}')!
WebView2.ICoreWebView2ProcessFailedEventHandler comment: '`ICoreWebView2ProcessFailedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2ProcessFailedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(79e0aea4-990b-42d9-aa1d-0fcc2e5bc7f1)
]
interface ICoreWebView2ProcessFailedEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2* sender,
		[in]ICoreWebView2ProcessFailedEventArgs* args);
};
```
'!
!WebView2.ICoreWebView2ProcessFailedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2ProcessFailedEventHandler methodsFor!

invoke: sender args: args
	"Invoke the Invoke() method of the COM object."

	^self Invoke: sender args: args!

Invoke: sender args: args
	"Private - Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			[in]ICoreWebView2* sender,
			[in]ICoreWebView2ProcessFailedEventArgs* args);"

	<virtual stdcall: hresult 4 ICoreWebView2* ICoreWebView2ProcessFailedEventArgs*>
	^self invalidCall: _failureCode! !
!WebView2.ICoreWebView2ProcessFailedEventHandler categoriesFor: #invoke:args:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2ProcessFailedEventHandler categoriesFor: #Invoke:args:!**auto generated**!COM Interfaces-ICoreWebView2ProcessFailedEventHandler!private! !

!WebView2.ICoreWebView2ProcessFailedEventHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2ProcessFailedEventHandler'
		ICoreWebView2ProcessFailedEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2* ICoreWebView2ProcessFailedEventArgs*'
! !
!WebView2.ICoreWebView2ProcessFailedEventHandler class categoriesFor: #defineFunctions!**auto generated**!initializing!private! !

