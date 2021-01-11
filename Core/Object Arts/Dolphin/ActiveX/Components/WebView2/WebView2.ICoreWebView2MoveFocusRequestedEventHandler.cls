"Filed out from Dolphin Smalltalk 7"!

OS.COM.IUnknown subclass: #'WebView2.ICoreWebView2MoveFocusRequestedEventHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2MoveFocusRequestedEventHandler guid: (OS.COM.IID fromString: '{69035451-6dc7-4cb8-9bce-b2bd70ad289f}')!
WebView2.ICoreWebView2MoveFocusRequestedEventHandler comment: '`ICoreWebView2MoveFocusRequestedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2MoveFocusRequestedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(69035451-6dc7-4cb8-9bce-b2bd70ad289f)
]
interface ICoreWebView2MoveFocusRequestedEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2Controller* sender,
		[in]ICoreWebView2MoveFocusRequestedEventArgs* args);
};
```
'!
!WebView2.ICoreWebView2MoveFocusRequestedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2MoveFocusRequestedEventHandler methodsFor!

invoke: sender args: args
	"Invoke the Invoke() method of the COM object."

	^self Invoke: sender args: args!

Invoke: sender args: args
	"Private - Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			[in]ICoreWebView2Controller* sender,
			[in]ICoreWebView2MoveFocusRequestedEventArgs* args);"

	<virtual stdcall: hresult 4 ICoreWebView2Controller* ICoreWebView2MoveFocusRequestedEventArgs*>
	^self invalidCall: _failureCode! !
!WebView2.ICoreWebView2MoveFocusRequestedEventHandler categoriesFor: #invoke:args:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2MoveFocusRequestedEventHandler categoriesFor: #Invoke:args:!**auto generated**!COM Interfaces-ICoreWebView2MoveFocusRequestedEventHandler!private! !

!WebView2.ICoreWebView2MoveFocusRequestedEventHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2MoveFocusRequestedEventHandler'
		ICoreWebView2MoveFocusRequestedEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2Controller* ICoreWebView2MoveFocusRequestedEventArgs*'
! !
!WebView2.ICoreWebView2MoveFocusRequestedEventHandler class categoriesFor: #defineFunctions!**auto generated**!initializing!private! !

