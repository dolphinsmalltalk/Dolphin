"Filed out from Dolphin Smallalk"!

IUnknown subclass: #ICoreWebView2ContainsFullScreenElementChangedEventHandler
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'WebView2Constants'
	classInstanceVariableNames: ''!
ICoreWebView2ContainsFullScreenElementChangedEventHandler guid: (IID fromString: '{e45d98b1-afef-45be-8baf-6c7728867f73}')!
ICoreWebView2ContainsFullScreenElementChangedEventHandler comment: '`ICoreWebView2ContainsFullScreenElementChangedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2ContainsFullScreenElementChangedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(e45d98b1-afef-45be-8baf-6c7728867f73)
]
interface ICoreWebView2ContainsFullScreenElementChangedEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2* sender,
		[in]IUnknown* args);
};
```
'!
!ICoreWebView2ContainsFullScreenElementChangedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2ContainsFullScreenElementChangedEventHandler methodsFor!

invoke: sender args: args
	"Invoke the Invoke() method of the COM object."

	^self Invoke: sender args: args!

Invoke: sender args: args
	"Private - Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			[in]ICoreWebView2* sender,
			[in]IUnknown* args);"

	<virtual stdcall: hresult 4 ICoreWebView2* IUnknown*>
	^self invalidCall: _failureCode! !
!ICoreWebView2ContainsFullScreenElementChangedEventHandler categoriesForMethods!
invoke:args:!**auto generated**!methods!public! !
Invoke:args:!**auto generated**!COM Interfaces-ICoreWebView2ContainsFullScreenElementChangedEventHandler!private! !
!

!ICoreWebView2ContainsFullScreenElementChangedEventHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2ContainsFullScreenElementChangedEventHandler'
		ICoreWebView2ContainsFullScreenElementChangedEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2* IUnknown*'
! !
!ICoreWebView2ContainsFullScreenElementChangedEventHandler class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

