"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2EventHandler
	subclass: #'WebView2.ICoreWebView2AcceleratorKeyPressedEventHandler'
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

basicRegister: tokenBuffer
	source Add_AcceleratorKeyPressed: self token: tokenBuffer!

basicUnregister
	source Remove_AcceleratorKeyPressed: token!

Invoke: sender args: args
	"Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			[in]ICoreWebView2Controller* sender,
			[in]ICoreWebView2AcceleratorKeyPressedEventArgs* args);"

	<virtual stdcall: hresult 4 ICoreWebView2Controller* ICoreWebView2AcceleratorKeyPressedEventArgs*>
	^self invalidCall: _failureCode! !
!WebView2.ICoreWebView2AcceleratorKeyPressedEventHandler categoriesForMethods!
basicRegister:!private!realizing/unrealizing! !
basicUnregister!private!realizing/unrealizing! !
Invoke:args:!**auto generated**!COM Interfaces-ICoreWebView2AcceleratorKeyPressedEventHandler!public! !
!

!WebView2.ICoreWebView2AcceleratorKeyPressedEventHandler class methodsFor!

argsClass
	^ICoreWebView2AcceleratorKeyPressedEventArgs!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2AcceleratorKeyPressedEventHandler'
		ICoreWebView2AcceleratorKeyPressedEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2Controller* ICoreWebView2AcceleratorKeyPressedEventArgs*'
!

eventName
	"Answer the symbolic name for this event (i.e. the SASE event trigger name)"

	^#acceleratorKeyPressed:! !
!WebView2.ICoreWebView2AcceleratorKeyPressedEventHandler class categoriesForMethods!
argsClass!constants!public! !
defineFunctions!**auto generated**!initializing!public!template definition! !
eventName!constants!public! !
!

