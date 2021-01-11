"Filed out from Dolphin Smalltalk 7"!

OS.COM.IUnknown subclass: #'WebView2.ICoreWebView2AcceleratorKeyPressedEventHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2AcceleratorKeyPressedEventHandler guid: (OS.COM.IID fromString: '{b29c7e28-fa79-41a8-8e44-65811c76dcb2}')!
WebView2.ICoreWebView2AcceleratorKeyPressedEventHandler comment: '`ICoreWebView2AcceleratorKeyPressedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2AcceleratorKeyPressedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(b29c7e28-fa79-41a8-8e44-65811c76dcb2)
]
interface ICoreWebView2AcceleratorKeyPressedEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2Controller* sender,
		[in]ICoreWebView2AcceleratorKeyPressedEventArgs* args);
};
```
'!
!WebView2.ICoreWebView2AcceleratorKeyPressedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2AcceleratorKeyPressedEventHandler methodsFor!

invoke: sender args: args
	"Invoke the Invoke() method of the COM object."

	^self Invoke: sender args: args!

Invoke: sender args: args
	"Private - Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			[in]ICoreWebView2Controller* sender,
			[in]ICoreWebView2AcceleratorKeyPressedEventArgs* args);"

	<virtual stdcall: hresult 4 ICoreWebView2Controller* ICoreWebView2AcceleratorKeyPressedEventArgs*>
	^self invalidCall: _failureCode! !
!WebView2.ICoreWebView2AcceleratorKeyPressedEventHandler categoriesFor: #invoke:args:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2AcceleratorKeyPressedEventHandler categoriesFor: #Invoke:args:!**auto generated**!COM Interfaces-ICoreWebView2AcceleratorKeyPressedEventHandler!private! !

!WebView2.ICoreWebView2AcceleratorKeyPressedEventHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2AcceleratorKeyPressedEventHandler'
		ICoreWebView2AcceleratorKeyPressedEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2Controller* ICoreWebView2AcceleratorKeyPressedEventArgs*'
! !
!WebView2.ICoreWebView2AcceleratorKeyPressedEventHandler class categoriesFor: #defineFunctions!**auto generated**!initializing!private! !

