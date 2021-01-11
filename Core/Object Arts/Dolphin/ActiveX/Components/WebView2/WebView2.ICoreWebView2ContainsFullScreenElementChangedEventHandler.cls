"Filed out from Dolphin Smalltalk 7"!

OS.COM.IUnknown subclass: #'WebView2.ICoreWebView2ContainsFullScreenElementChangedEventHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2ContainsFullScreenElementChangedEventHandler guid: (OS.COM.IID fromString: '{e45d98b1-afef-45be-8baf-6c7728867f73}')!
WebView2.ICoreWebView2ContainsFullScreenElementChangedEventHandler comment: '`ICoreWebView2ContainsFullScreenElementChangedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2ContainsFullScreenElementChangedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

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
!WebView2.ICoreWebView2ContainsFullScreenElementChangedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2ContainsFullScreenElementChangedEventHandler methodsFor!

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
!WebView2.ICoreWebView2ContainsFullScreenElementChangedEventHandler categoriesFor: #invoke:args:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2ContainsFullScreenElementChangedEventHandler categoriesFor: #Invoke:args:!**auto generated**!COM Interfaces-ICoreWebView2ContainsFullScreenElementChangedEventHandler!private! !

!WebView2.ICoreWebView2ContainsFullScreenElementChangedEventHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2ContainsFullScreenElementChangedEventHandler'
		ICoreWebView2ContainsFullScreenElementChangedEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2* IUnknown*'
! !
!WebView2.ICoreWebView2ContainsFullScreenElementChangedEventHandler class categoriesFor: #defineFunctions!**auto generated**!initializing!private! !

