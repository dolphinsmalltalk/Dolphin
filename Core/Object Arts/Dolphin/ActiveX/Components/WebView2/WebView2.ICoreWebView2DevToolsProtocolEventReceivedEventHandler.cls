﻿"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2EventHandler
	subclass: #'WebView2.ICoreWebView2DevToolsProtocolEventReceivedEventHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2DevToolsProtocolEventReceivedEventHandler guid: (OS.COM.IID fromString: '{e2fda4be-5456-406c-a261-3d452138362c}')!

WebView2.ICoreWebView2DevToolsProtocolEventReceivedEventHandler comment: '`ICoreWebView2DevToolsProtocolEventReceivedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2DevToolsProtocolEventReceivedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(e2fda4be-5456-406c-a261-3d452138362c)
]
interface ICoreWebView2DevToolsProtocolEventReceivedEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2* sender,
		[in]ICoreWebView2DevToolsProtocolEventReceivedEventArgs* args);
};
```
'!

!WebView2.ICoreWebView2DevToolsProtocolEventReceivedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2DevToolsProtocolEventReceivedEventHandler methodsFor!

basicRegister: tokenBuffer with: anICoreWebView2DevToolsProtocolEventReceiver
	anICoreWebView2DevToolsProtocolEventReceiver Add_DevToolsProtocolEventReceived: self token: tokenBuffer!

basicUnregister: anInteger from: anICoreWebView2DevToolsProtocolEventReceiver
	anICoreWebView2DevToolsProtocolEventReceiver Remove_DevToolsProtocolEventReceived: anInteger!

Invoke: sender args: args
	"Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			[in]ICoreWebView2* sender,
			[in]ICoreWebView2DevToolsProtocolEventReceivedEventArgs* args);"

	<virtual stdcall: hresult 4 ICoreWebView2* ICoreWebView2DevToolsProtocolEventReceivedEventArgs*>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2DevToolsProtocolEventReceivedEventHandler categoriesForMethods!
basicRegister:with:!private!realizing/unrealizing! !
basicUnregister:from:!private!realizing/unrealizing! !
Invoke:args:!**auto generated**!COM Interfaces-ICoreWebView2DevToolsProtocolEventReceivedEventHandler!public! !
!

!WebView2.ICoreWebView2DevToolsProtocolEventReceivedEventHandler class methodsFor!

argsClass
	^ICoreWebView2DevToolsProtocolEventReceivedEventArgs2!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2DevToolsProtocolEventReceivedEventHandler'
		ICoreWebView2DevToolsProtocolEventReceivedEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2* ICoreWebView2DevToolsProtocolEventReceivedEventArgs*'
!

eventName
	"Answer the symbolic name for this event (i.e. the SASE event trigger name)"

	^#devToolsProtocolEvent:! !

!WebView2.ICoreWebView2DevToolsProtocolEventReceivedEventHandler class categoriesForMethods!
argsClass!constants!public! !
defineFunctions!**auto generated**!initializing!public!template definition! !
eventName!constants!public! !
!

