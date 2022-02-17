"Filed out from Dolphin Smallalk"!

IUnknown subclass: #ICoreWebView2FrameCreatedEventHandler
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'WebView2Constants'
	classInstanceVariableNames: ''!
ICoreWebView2FrameCreatedEventHandler guid: (IID fromString: '{38059770-9baa-11eb-a8b3-0242ac130003}')!
ICoreWebView2FrameCreatedEventHandler comment: '`ICoreWebView2FrameCreatedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2FrameCreatedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(38059770-9baa-11eb-a8b3-0242ac130003)
]
interface ICoreWebView2FrameCreatedEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2* sender,
		[in]ICoreWebView2FrameCreatedEventArgs* args);
};
```
'!
!ICoreWebView2FrameCreatedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2FrameCreatedEventHandler methodsFor!

invoke: sender args: args
	"Invoke the Invoke() method of the COM object."

	^self Invoke: sender args: args!

Invoke: sender args: args
	"Private - Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			[in]ICoreWebView2* sender,
			[in]ICoreWebView2FrameCreatedEventArgs* args);"

	<virtual stdcall: hresult 4 ICoreWebView2* ICoreWebView2FrameCreatedEventArgs*>
	^self invalidCall: _failureCode! !
!ICoreWebView2FrameCreatedEventHandler categoriesForMethods!
invoke:args:!**auto generated**!methods!public! !
Invoke:args:!**auto generated**!COM Interfaces-ICoreWebView2FrameCreatedEventHandler!private! !
!

!ICoreWebView2FrameCreatedEventHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2FrameCreatedEventHandler'
		ICoreWebView2FrameCreatedEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2* ICoreWebView2FrameCreatedEventArgs*'
! !
!ICoreWebView2FrameCreatedEventHandler class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

