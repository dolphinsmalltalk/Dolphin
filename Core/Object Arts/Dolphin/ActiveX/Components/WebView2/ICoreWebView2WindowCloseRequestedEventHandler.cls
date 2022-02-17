"Filed out from Dolphin Smallalk"!

IUnknown subclass: #ICoreWebView2WindowCloseRequestedEventHandler
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'WebView2Constants'
	classInstanceVariableNames: ''!
ICoreWebView2WindowCloseRequestedEventHandler guid: (IID fromString: '{5c19e9e0-092f-486b-affa-ca8231913039}')!
ICoreWebView2WindowCloseRequestedEventHandler comment: '`ICoreWebView2WindowCloseRequestedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2WindowCloseRequestedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(5c19e9e0-092f-486b-affa-ca8231913039)
]
interface ICoreWebView2WindowCloseRequestedEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2* sender,
		[in]IUnknown* args);
};
```
'!
!ICoreWebView2WindowCloseRequestedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2WindowCloseRequestedEventHandler methodsFor!

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
!ICoreWebView2WindowCloseRequestedEventHandler categoriesForMethods!
invoke:args:!**auto generated**!methods!public! !
Invoke:args:!**auto generated**!COM Interfaces-ICoreWebView2WindowCloseRequestedEventHandler!private! !
!

!ICoreWebView2WindowCloseRequestedEventHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2WindowCloseRequestedEventHandler'
		ICoreWebView2WindowCloseRequestedEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2* IUnknown*'
! !
!ICoreWebView2WindowCloseRequestedEventHandler class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

