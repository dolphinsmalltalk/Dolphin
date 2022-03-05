"Filed out from Dolphin Smalltalk"!

ICoreWebView2EventHandler subclass: #ICoreWebView2FrameWebMessageReceivedEventHandler
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ICoreWebView2FrameWebMessageReceivedEventHandler guid: (IID fromString: '{e371e005-6d1d-4517-934b-a8f1629c62a5}')!
ICoreWebView2FrameWebMessageReceivedEventHandler comment: '`ICoreWebView2FrameWebMessageReceivedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2FrameWebMessageReceivedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(e371e005-6d1d-4517-934b-a8f1629c62a5)
]
interface ICoreWebView2FrameWebMessageReceivedEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2Frame* sender,
		[in]ICoreWebView2WebMessageReceivedEventArgs* args);
};
```
'!
!ICoreWebView2FrameWebMessageReceivedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2FrameWebMessageReceivedEventHandler methodsFor!

basicRegister: tokenBuffer
	source Add_WebMessageReceived: self token: tokenBuffer!

basicUnregister
	source Remove_WebMessageReceived: token! !
!ICoreWebView2FrameWebMessageReceivedEventHandler categoriesForMethods!
basicRegister:!private!realizing/unrealizing! !
basicUnregister!private!realizing/unrealizing! !
!

!ICoreWebView2FrameWebMessageReceivedEventHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2FrameWebMessageReceivedEventHandler'
		ICoreWebView2FrameWebMessageReceivedEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2Frame* ICoreWebView2WebMessageReceivedEventArgs*'
!

eventName
	"Answer the symbolic name for this event (i.e. the SASE event trigger name)"

	^#frameWebMessageReceived:! !
!ICoreWebView2FrameWebMessageReceivedEventHandler class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
eventName!constants!public! !
!

