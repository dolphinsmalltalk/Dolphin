"Filed out from Dolphin Smallalk"!

ICoreWebView2EventHandler subclass: #ICoreWebView2DevToolsProtocolEventReceivedEventHandler
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ICoreWebView2DevToolsProtocolEventReceivedEventHandler guid: (IID fromString: '{e2fda4be-5456-406c-a261-3d452138362c}')!
ICoreWebView2DevToolsProtocolEventReceivedEventHandler comment: '`ICoreWebView2DevToolsProtocolEventReceivedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2DevToolsProtocolEventReceivedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

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
!ICoreWebView2DevToolsProtocolEventReceivedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2DevToolsProtocolEventReceivedEventHandler methodsFor!

basicRegister: tokenBuffer
	source Add_DevToolsProtocolEventReceived: self token: tokenBuffer!

basicUnregister
	source Remove_DevToolsProtocolEventReceived: token! !
!ICoreWebView2DevToolsProtocolEventReceivedEventHandler categoriesForMethods!
basicRegister:!private!realizing/unrealizing! !
basicUnregister!private!realizing/unrealizing! !
!

!ICoreWebView2DevToolsProtocolEventReceivedEventHandler class methodsFor!

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
!ICoreWebView2DevToolsProtocolEventReceivedEventHandler class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
eventName!constants!public! !
!

