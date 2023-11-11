"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2EventHandler
	subclass: #'WebView2.ICoreWebView2FrameWebMessageReceivedEventHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2FrameWebMessageReceivedEventHandler guid: (OS.COM.IID fromString: '{e371e005-6d1d-4517-934b-a8f1629c62a5}')!
WebView2.ICoreWebView2FrameWebMessageReceivedEventHandler comment: '`ICoreWebView2FrameWebMessageReceivedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2FrameWebMessageReceivedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

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
!WebView2.ICoreWebView2FrameWebMessageReceivedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2FrameWebMessageReceivedEventHandler methodsFor!

basicRegister: tokenBuffer
	source Add_WebMessageReceived: self token: tokenBuffer!

basicUnregister
	source Remove_WebMessageReceived: token!

Invoke: sender args: args
	"Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			[in]ICoreWebView2Frame* sender,
			[in]ICoreWebView2WebMessageReceivedEventArgs* args);"

	<virtual stdcall: hresult 4 ICoreWebView2Frame* ICoreWebView2WebMessageReceivedEventArgs*>
	^self invalidCall: _failureCode! !
!WebView2.ICoreWebView2FrameWebMessageReceivedEventHandler categoriesForMethods!
basicRegister:!private!realizing/unrealizing! !
basicUnregister!private!realizing/unrealizing! !
Invoke:args:!**auto generated**!COM Interfaces-ICoreWebView2FrameWebMessageReceivedEventHandler!public! !
!

!WebView2.ICoreWebView2FrameWebMessageReceivedEventHandler class methodsFor!

argsClass
	^ICoreWebView2WebMessageReceivedEventArgs!

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
!WebView2.ICoreWebView2FrameWebMessageReceivedEventHandler class categoriesForMethods!
argsClass!constants!public! !
defineFunctions!**auto generated**!initializing!public!template definition! !
eventName!constants!public! !
!

