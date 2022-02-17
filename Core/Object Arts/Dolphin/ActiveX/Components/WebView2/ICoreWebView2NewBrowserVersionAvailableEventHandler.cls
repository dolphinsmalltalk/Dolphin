"Filed out from Dolphin Smallalk"!

IUnknown subclass: #ICoreWebView2NewBrowserVersionAvailableEventHandler
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'WebView2Constants'
	classInstanceVariableNames: ''!
ICoreWebView2NewBrowserVersionAvailableEventHandler guid: (IID fromString: '{f9a2976e-d34e-44fc-adee-81b6b57ca914}')!
ICoreWebView2NewBrowserVersionAvailableEventHandler comment: '`ICoreWebView2NewBrowserVersionAvailableEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2NewBrowserVersionAvailableEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(f9a2976e-d34e-44fc-adee-81b6b57ca914)
]
interface ICoreWebView2NewBrowserVersionAvailableEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2Environment* sender,
		[in]IUnknown* args);
};
```
'!
!ICoreWebView2NewBrowserVersionAvailableEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2NewBrowserVersionAvailableEventHandler methodsFor!

invoke: sender args: args
	"Invoke the Invoke() method of the COM object."

	^self Invoke: sender args: args!

Invoke: sender args: args
	"Private - Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			[in]ICoreWebView2Environment* sender,
			[in]IUnknown* args);"

	<virtual stdcall: hresult 4 ICoreWebView2Environment* IUnknown*>
	^self invalidCall: _failureCode! !
!ICoreWebView2NewBrowserVersionAvailableEventHandler categoriesForMethods!
invoke:args:!**auto generated**!methods!public! !
Invoke:args:!**auto generated**!COM Interfaces-ICoreWebView2NewBrowserVersionAvailableEventHandler!private! !
!

!ICoreWebView2NewBrowserVersionAvailableEventHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2NewBrowserVersionAvailableEventHandler'
		ICoreWebView2NewBrowserVersionAvailableEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2Environment* IUnknown*'
! !
!ICoreWebView2NewBrowserVersionAvailableEventHandler class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

