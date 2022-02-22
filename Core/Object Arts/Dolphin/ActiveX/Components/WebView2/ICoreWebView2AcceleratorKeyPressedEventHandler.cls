"Filed out from Dolphin Smalltalk"!

ICoreWebView2EventHandler subclass: #ICoreWebView2AcceleratorKeyPressedEventHandler
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{Smalltalk.WebView2Constants})
	classInstanceVariableNames: ''
	classConstants: {}!
ICoreWebView2AcceleratorKeyPressedEventHandler guid: (OS.COM.IID fromString: '{b29c7e28-fa79-41a8-8e44-65811c76dcb2}')!
ICoreWebView2AcceleratorKeyPressedEventHandler comment: '`ICoreWebView2AcceleratorKeyPressedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2AcceleratorKeyPressedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

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
!ICoreWebView2AcceleratorKeyPressedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2AcceleratorKeyPressedEventHandler methodsFor!

basicRegister: tokenBuffer
	source Add_AcceleratorKeyPressed: self token: tokenBuffer!

basicUnregister
	source Remove_AcceleratorKeyPressed: token! !
!ICoreWebView2AcceleratorKeyPressedEventHandler categoriesForMethods!
basicRegister:!private!realizing/unrealizing! !
basicUnregister!private!realizing/unrealizing! !
!

!ICoreWebView2AcceleratorKeyPressedEventHandler class methodsFor!

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
!ICoreWebView2AcceleratorKeyPressedEventHandler class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
eventName!constants!public! !
!

