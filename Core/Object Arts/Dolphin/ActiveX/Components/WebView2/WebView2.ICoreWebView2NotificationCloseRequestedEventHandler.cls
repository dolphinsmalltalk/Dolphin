"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2EventHandler
	subclass: #'WebView2.ICoreWebView2NotificationCloseRequestedEventHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2NotificationCloseRequestedEventHandler guid: (OS.COM.IID fromString: '{47c32d23-1e94-4733-85f1-d9bf4acd0974}')!

WebView2.ICoreWebView2NotificationCloseRequestedEventHandler comment: '`ICoreWebView2NotificationCloseRequestedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2NotificationCloseRequestedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(47c32d23-1e94-4733-85f1-d9bf4acd0974)
]
interface ICoreWebView2NotificationCloseRequestedEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2Notification* sender,
		[in]IUnknown* args);
};
```
'!

!WebView2.ICoreWebView2NotificationCloseRequestedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2NotificationCloseRequestedEventHandler methodsFor!

basicRegister: tokenBuffer with: anICoreWebView2Interface
	anICoreWebView2Interface Add_CloseRequested: self token: tokenBuffer!

basicUnregister: anInteger from: anICoreWebView2Interface
	anICoreWebView2Interface Remove_CloseRequested: anInteger!

Invoke: sender args: args
	"Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			[in]ICoreWebView2Notification* sender,
			[in]IUnknown* args);"

	<virtual stdcall: hresult 4 ICoreWebView2Notification* IUnknown*>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2NotificationCloseRequestedEventHandler categoriesForMethods!
basicRegister:with:!private!realizing/unrealizing! !
basicUnregister:from:!private!realizing/unrealizing! !
Invoke:args:!**auto generated**!COM Interfaces-ICoreWebView2NotificationCloseRequestedEventHandler!public! !
!

!WebView2.ICoreWebView2NotificationCloseRequestedEventHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2NotificationCloseRequestedEventHandler'
		ICoreWebView2NotificationCloseRequestedEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2Notification* IUnknown*'
!

eventName
	"Answer the symbolic name for this event (i.e. the SASE event trigger name)"

	^#notificationCloseRequested! !

!WebView2.ICoreWebView2NotificationCloseRequestedEventHandler class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
eventName!constants!public! !
!

