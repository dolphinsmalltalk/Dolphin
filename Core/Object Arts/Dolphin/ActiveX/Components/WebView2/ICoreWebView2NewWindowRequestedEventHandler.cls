"Filed out from Dolphin Smallalk"!

IUnknown subclass: #ICoreWebView2NewWindowRequestedEventHandler
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'WebView2Constants'
	classInstanceVariableNames: ''!
ICoreWebView2NewWindowRequestedEventHandler guid: (IID fromString: '{d4c185fe-c81c-4989-97af-2d3fa7ab5651}')!
ICoreWebView2NewWindowRequestedEventHandler comment: '`ICoreWebView2NewWindowRequestedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2NewWindowRequestedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(d4c185fe-c81c-4989-97af-2d3fa7ab5651)
]
interface ICoreWebView2NewWindowRequestedEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2* sender,
		[in]ICoreWebView2NewWindowRequestedEventArgs* args);
};
```
'!
!ICoreWebView2NewWindowRequestedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2NewWindowRequestedEventHandler methodsFor!

invoke: sender args: args
	"Invoke the Invoke() method of the COM object."

	^self Invoke: sender args: args!

Invoke: sender args: args
	"Private - Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			[in]ICoreWebView2* sender,
			[in]ICoreWebView2NewWindowRequestedEventArgs* args);"

	<virtual stdcall: hresult 4 ICoreWebView2* ICoreWebView2NewWindowRequestedEventArgs*>
	^self invalidCall: _failureCode! !
!ICoreWebView2NewWindowRequestedEventHandler categoriesForMethods!
invoke:args:!**auto generated**!methods!public! !
Invoke:args:!**auto generated**!COM Interfaces-ICoreWebView2NewWindowRequestedEventHandler!private! !
!

!ICoreWebView2NewWindowRequestedEventHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2NewWindowRequestedEventHandler'
		ICoreWebView2NewWindowRequestedEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2* ICoreWebView2NewWindowRequestedEventArgs*'
! !
!ICoreWebView2NewWindowRequestedEventHandler class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

