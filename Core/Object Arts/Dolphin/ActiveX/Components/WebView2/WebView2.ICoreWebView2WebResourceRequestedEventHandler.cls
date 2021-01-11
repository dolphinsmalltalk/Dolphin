"Filed out from Dolphin Smalltalk 7"!

OS.COM.IUnknown subclass: #'WebView2.ICoreWebView2WebResourceRequestedEventHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2WebResourceRequestedEventHandler guid: (OS.COM.IID fromString: '{ab00b74c-15f1-4646-80e8-e76341d25d71}')!
WebView2.ICoreWebView2WebResourceRequestedEventHandler comment: '`ICoreWebView2WebResourceRequestedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2WebResourceRequestedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(ab00b74c-15f1-4646-80e8-e76341d25d71)
]
interface ICoreWebView2WebResourceRequestedEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2* sender,
		[in]ICoreWebView2WebResourceRequestedEventArgs* args);
};
```
'!
!WebView2.ICoreWebView2WebResourceRequestedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2WebResourceRequestedEventHandler methodsFor!

invoke: sender args: args
	"Invoke the Invoke() method of the COM object."

	^self Invoke: sender args: args!

Invoke: sender args: args
	"Private - Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			[in]ICoreWebView2* sender,
			[in]ICoreWebView2WebResourceRequestedEventArgs* args);"

	<virtual stdcall: hresult 4 ICoreWebView2* ICoreWebView2WebResourceRequestedEventArgs*>
	^self invalidCall: _failureCode! !
!WebView2.ICoreWebView2WebResourceRequestedEventHandler categoriesFor: #invoke:args:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2WebResourceRequestedEventHandler categoriesFor: #Invoke:args:!**auto generated**!COM Interfaces-ICoreWebView2WebResourceRequestedEventHandler!private! !

!WebView2.ICoreWebView2WebResourceRequestedEventHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2WebResourceRequestedEventHandler'
		ICoreWebView2WebResourceRequestedEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2* ICoreWebView2WebResourceRequestedEventArgs*'
! !
!WebView2.ICoreWebView2WebResourceRequestedEventHandler class categoriesFor: #defineFunctions!**auto generated**!initializing!private! !

