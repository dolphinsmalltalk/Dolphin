"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2EventHandler
	subclass: #'WebView2.ICoreWebView2NotificationReceivedEventHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2NotificationReceivedEventHandler guid: (OS.COM.IID fromString: '{89c5d598-8788-423b-be97-e6e01c0f9ee3}')!

WebView2.ICoreWebView2NotificationReceivedEventHandler comment: '`ICoreWebView2NotificationReceivedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2NotificationReceivedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(89c5d598-8788-423b-be97-e6e01c0f9ee3)
]
interface ICoreWebView2NotificationReceivedEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2* sender,
		[in]ICoreWebView2NotificationReceivedEventArgs* args);
};
```
'!

!WebView2.ICoreWebView2NotificationReceivedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2NotificationReceivedEventHandler methodsFor!

basicRegister: tokenBuffer
	source Add_NotificationReceived: self token: tokenBuffer!

basicUnregister
	source Remove_NotificationReceived: token!

Invoke: sender args: args
	"Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			[in]ICoreWebView2* sender,
			[in]ICoreWebView2NotificationReceivedEventArgs* args);"

	<virtual stdcall: hresult 4 ICoreWebView2* ICoreWebView2NotificationReceivedEventArgs*>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2NotificationReceivedEventHandler categoriesForMethods!
basicRegister:!private!realizing/unrealizing! !
basicUnregister!private!realizing/unrealizing! !
Invoke:args:!**auto generated**!COM Interfaces-ICoreWebView2NotificationReceivedEventHandler!public! !
!

!WebView2.ICoreWebView2NotificationReceivedEventHandler class methodsFor!

argsClass
	^ICoreWebView2NotificationReceivedEventArgs!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2NotificationReceivedEventHandler'
		ICoreWebView2NotificationReceivedEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2* ICoreWebView2NotificationReceivedEventArgs*'
!

eventName
	"Answer the symbolic name for this event (i.e. the SASE event trigger name)"

	^#notificationReceived:! !

!WebView2.ICoreWebView2NotificationReceivedEventHandler class categoriesForMethods!
argsClass!constants!public! !
defineFunctions!**auto generated**!initializing!public!template definition! !
eventName!constants!public! !
!

