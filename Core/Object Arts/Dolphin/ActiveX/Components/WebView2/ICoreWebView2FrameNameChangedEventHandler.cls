"Filed out from Dolphin Smallalk"!

IUnknown subclass: #ICoreWebView2FrameNameChangedEventHandler
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'WebView2Constants'
	classInstanceVariableNames: ''!
ICoreWebView2FrameNameChangedEventHandler guid: (IID fromString: '{435c7dc8-9baa-11eb-a8b3-0242ac130003}')!
ICoreWebView2FrameNameChangedEventHandler comment: '`ICoreWebView2FrameNameChangedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2FrameNameChangedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(435c7dc8-9baa-11eb-a8b3-0242ac130003)
]
interface ICoreWebView2FrameNameChangedEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2Frame* sender,
		[in]IUnknown* args);
};
```
'!
!ICoreWebView2FrameNameChangedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2FrameNameChangedEventHandler methodsFor!

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
!ICoreWebView2FrameNameChangedEventHandler categoriesForMethods!
invoke:args:!**auto generated**!methods!public! !
Invoke:args:!**auto generated**!COM Interfaces-ICoreWebView2FrameNameChangedEventHandler!private! !
!

!ICoreWebView2FrameNameChangedEventHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2FrameNameChangedEventHandler'
		ICoreWebView2FrameNameChangedEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2Frame* IUnknown*'
! !
!ICoreWebView2FrameNameChangedEventHandler class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

