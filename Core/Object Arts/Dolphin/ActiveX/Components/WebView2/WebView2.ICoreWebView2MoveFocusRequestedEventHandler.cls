"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2EventHandler
	subclass: #'WebView2.ICoreWebView2MoveFocusRequestedEventHandler'
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

basicRegister: tokenBuffer
	source Add_MoveFocusRequested: self token: tokenBuffer!

basicUnregister
	source Remove_MoveFocusRequested: token!

Invoke: sender args: args
	"Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			[in]ICoreWebView2Controller* sender,
			[in]ICoreWebView2MoveFocusRequestedEventArgs* args);"

	<virtual stdcall: hresult 4 ICoreWebView2Controller* ICoreWebView2MoveFocusRequestedEventArgs*>
	^self invalidCall: _failureCode! !
!WebView2.ICoreWebView2MoveFocusRequestedEventHandler categoriesForMethods!
basicRegister:!private!realizing/unrealizing! !
basicUnregister!private!realizing/unrealizing! !
Invoke:args:!**auto generated**!COM Interfaces-ICoreWebView2MoveFocusRequestedEventHandler!public! !
!

!WebView2.ICoreWebView2MoveFocusRequestedEventHandler class methodsFor!

argsClass
	^ICoreWebView2MoveFocusRequestedEventArgs!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2MoveFocusRequestedEventHandler'
		ICoreWebView2MoveFocusRequestedEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2Controller* ICoreWebView2MoveFocusRequestedEventArgs*'
!

eventName
	"Answer the symbolic name for this event (i.e. the SASE event trigger name)"

	^#moveFocusRequested:! !
!WebView2.ICoreWebView2MoveFocusRequestedEventHandler class categoriesForMethods!
argsClass!constants!public! !
defineFunctions!**auto generated**!initializing!public!template definition! !
eventName!constants!public! !
!

