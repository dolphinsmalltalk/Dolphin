"Filed out from Dolphin Smalltalk 7"!

OS.COM.IUnknown subclass: #'WebView2.ICoreWebView2ZoomFactorChangedEventHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2ZoomFactorChangedEventHandler guid: (OS.COM.IID fromString: '{b52d71d6-c4df-4543-a90c-64a3e60f38cb}')!
WebView2.ICoreWebView2ZoomFactorChangedEventHandler comment: '`ICoreWebView2ZoomFactorChangedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2ZoomFactorChangedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(b52d71d6-c4df-4543-a90c-64a3e60f38cb)
]
interface ICoreWebView2ZoomFactorChangedEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2Controller* sender,
		[in]IUnknown* args);
};
```
'!
!WebView2.ICoreWebView2ZoomFactorChangedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2ZoomFactorChangedEventHandler methodsFor!

invoke: sender args: args
	"Invoke the Invoke() method of the COM object."

	^self Invoke: sender args: args!

Invoke: sender args: args
	"Private - Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			[in]ICoreWebView2Controller* sender,
			[in]IUnknown* args);"

	<virtual stdcall: hresult 4 ICoreWebView2Controller* IUnknown*>
	^self invalidCall: _failureCode! !
!WebView2.ICoreWebView2ZoomFactorChangedEventHandler categoriesFor: #invoke:args:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2ZoomFactorChangedEventHandler categoriesFor: #Invoke:args:!**auto generated**!COM Interfaces-ICoreWebView2ZoomFactorChangedEventHandler!private! !

!WebView2.ICoreWebView2ZoomFactorChangedEventHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2ZoomFactorChangedEventHandler'
		ICoreWebView2ZoomFactorChangedEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2Controller* IUnknown*'
! !
!WebView2.ICoreWebView2ZoomFactorChangedEventHandler class categoriesFor: #defineFunctions!**auto generated**!initializing!private! !

