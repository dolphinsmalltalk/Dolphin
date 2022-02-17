"Filed out from Dolphin Smallalk"!

IUnknown subclass: #ICoreWebView2CursorChangedEventHandler
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'WebView2Constants'
	classInstanceVariableNames: ''!
ICoreWebView2CursorChangedEventHandler guid: (IID fromString: '{9da43ccc-26e1-4dad-b56c-d8961c94c571}')!
ICoreWebView2CursorChangedEventHandler comment: '`ICoreWebView2CursorChangedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2CursorChangedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(9da43ccc-26e1-4dad-b56c-d8961c94c571)
]
interface ICoreWebView2CursorChangedEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2CompositionController* sender,
		[in]IUnknown* args);
};
```
'!
!ICoreWebView2CursorChangedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2CursorChangedEventHandler methodsFor!

invoke: sender args: args
	"Invoke the Invoke() method of the COM object."

	^self Invoke: sender args: args!

Invoke: sender args: args
	"Private - Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			[in]ICoreWebView2CompositionController* sender,
			[in]IUnknown* args);"

	<virtual stdcall: hresult 4 ICoreWebView2CompositionController* IUnknown*>
	^self invalidCall: _failureCode! !
!ICoreWebView2CursorChangedEventHandler categoriesForMethods!
invoke:args:!**auto generated**!methods!public! !
Invoke:args:!**auto generated**!COM Interfaces-ICoreWebView2CursorChangedEventHandler!private! !
!

!ICoreWebView2CursorChangedEventHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2CursorChangedEventHandler'
		ICoreWebView2CursorChangedEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2CompositionController* IUnknown*'
! !
!ICoreWebView2CursorChangedEventHandler class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

