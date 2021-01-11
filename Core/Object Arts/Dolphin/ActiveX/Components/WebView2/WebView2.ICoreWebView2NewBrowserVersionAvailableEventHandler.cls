"Filed out from Dolphin Smalltalk 7"!

OS.COM.IUnknown subclass: #'WebView2.ICoreWebView2NewBrowserVersionAvailableEventHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2NewBrowserVersionAvailableEventHandler guid: (OS.COM.IID fromString: '{f9a2976e-d34e-44fc-adee-81b6b57ca914}')!
WebView2.ICoreWebView2NewBrowserVersionAvailableEventHandler comment: '`ICoreWebView2NewBrowserVersionAvailableEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2NewBrowserVersionAvailableEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

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
		[in]ICoreWebView2Environment* webviewEnvironment,
		[in]IUnknown* args);
};
```
'!
!WebView2.ICoreWebView2NewBrowserVersionAvailableEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2NewBrowserVersionAvailableEventHandler methodsFor!

invoke: webviewEnvironment args: args
	"Invoke the Invoke() method of the COM object."

	^self Invoke: webviewEnvironment args: args!

Invoke: webviewEnvironment args: args
	"Private - Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			[in]ICoreWebView2Environment* webviewEnvironment,
			[in]IUnknown* args);"

	<virtual stdcall: hresult 4 ICoreWebView2Environment* IUnknown*>
	^self invalidCall: _failureCode! !
!WebView2.ICoreWebView2NewBrowserVersionAvailableEventHandler categoriesFor: #invoke:args:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2NewBrowserVersionAvailableEventHandler categoriesFor: #Invoke:args:!**auto generated**!COM Interfaces-ICoreWebView2NewBrowserVersionAvailableEventHandler!private! !

!WebView2.ICoreWebView2NewBrowserVersionAvailableEventHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2NewBrowserVersionAvailableEventHandler'
		ICoreWebView2NewBrowserVersionAvailableEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2Environment* IUnknown*'
! !
!WebView2.ICoreWebView2NewBrowserVersionAvailableEventHandler class categoriesFor: #defineFunctions!**auto generated**!initializing!private! !

