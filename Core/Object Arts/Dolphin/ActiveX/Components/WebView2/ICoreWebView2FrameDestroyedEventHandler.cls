"Filed out from Dolphin Smallalk"!

IUnknown subclass: #ICoreWebView2FrameDestroyedEventHandler
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'WebView2Constants'
	classInstanceVariableNames: ''!
ICoreWebView2FrameDestroyedEventHandler guid: (IID fromString: '{59dd7b4c-9baa-11eb-a8b3-0242ac130003}')!
ICoreWebView2FrameDestroyedEventHandler comment: '`ICoreWebView2FrameDestroyedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2FrameDestroyedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(59dd7b4c-9baa-11eb-a8b3-0242ac130003)
]
interface ICoreWebView2FrameDestroyedEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2Frame* sender,
		[in]IUnknown* args);
};
```
'!
!ICoreWebView2FrameDestroyedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2FrameDestroyedEventHandler methodsFor!

invoke: sender args: args
	"Invoke the Invoke() method of the COM object."

	^self Invoke: sender args: args!

Invoke: sender args: args
	"Private - Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			[in]ICoreWebView2Frame* sender,
			[in]IUnknown* args);"

	<virtual stdcall: hresult 4 ICoreWebView2Frame* IUnknown*>
	^self invalidCall: _failureCode! !
!ICoreWebView2FrameDestroyedEventHandler categoriesForMethods!
invoke:args:!**auto generated**!methods!public! !
Invoke:args:!**auto generated**!COM Interfaces-ICoreWebView2FrameDestroyedEventHandler!private! !
!

!ICoreWebView2FrameDestroyedEventHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2FrameDestroyedEventHandler'
		ICoreWebView2FrameDestroyedEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2Frame* IUnknown*'
! !
!ICoreWebView2FrameDestroyedEventHandler class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

