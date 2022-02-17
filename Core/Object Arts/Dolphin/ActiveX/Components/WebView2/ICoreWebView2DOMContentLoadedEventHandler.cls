"Filed out from Dolphin Smallalk"!

IUnknown subclass: #ICoreWebView2DOMContentLoadedEventHandler
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'WebView2Constants'
	classInstanceVariableNames: ''!
ICoreWebView2DOMContentLoadedEventHandler guid: (IID fromString: '{4bac7e9c-199e-49ed-87ed-249303acf019}')!
ICoreWebView2DOMContentLoadedEventHandler comment: '`ICoreWebView2DOMContentLoadedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2DOMContentLoadedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(4bac7e9c-199e-49ed-87ed-249303acf019)
]
interface ICoreWebView2DOMContentLoadedEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2* sender,
		[in]ICoreWebView2DOMContentLoadedEventArgs* args);
};
```
'!
!ICoreWebView2DOMContentLoadedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2DOMContentLoadedEventHandler methodsFor!

invoke: sender args: args
	"Invoke the Invoke() method of the COM object."

	^self Invoke: sender args: args!

Invoke: sender args: args
	"Private - Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			[in]ICoreWebView2* sender,
			[in]ICoreWebView2DOMContentLoadedEventArgs* args);"

	<virtual stdcall: hresult 4 ICoreWebView2* ICoreWebView2DOMContentLoadedEventArgs*>
	^self invalidCall: _failureCode! !
!ICoreWebView2DOMContentLoadedEventHandler categoriesForMethods!
invoke:args:!**auto generated**!methods!public! !
Invoke:args:!**auto generated**!COM Interfaces-ICoreWebView2DOMContentLoadedEventHandler!private! !
!

!ICoreWebView2DOMContentLoadedEventHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2DOMContentLoadedEventHandler'
		ICoreWebView2DOMContentLoadedEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2* ICoreWebView2DOMContentLoadedEventArgs*'
! !
!ICoreWebView2DOMContentLoadedEventHandler class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

