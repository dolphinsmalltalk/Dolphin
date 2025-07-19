"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2ViewEventHandler
	subclass: #'WebView2.ICoreWebView2WebMessageReceivedEventHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2WebMessageReceivedEventHandler guid: (OS.COM.IID fromString: '{57213f19-00e6-49fa-8e07-898ea01ecbd2}')!

WebView2.ICoreWebView2WebMessageReceivedEventHandler comment: '`ICoreWebView2WebMessageReceivedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2WebMessageReceivedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(57213f19-00e6-49fa-8e07-898ea01ecbd2)
]
interface ICoreWebView2WebMessageReceivedEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2* sender,
		[in]ICoreWebView2WebMessageReceivedEventArgs* args);
};
```
'!

!WebView2.ICoreWebView2WebMessageReceivedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2WebMessageReceivedEventHandler methodsFor!

basicRegister: tokenBuffer with: anICoreWebView2
	anICoreWebView2 Add_WebMessageReceived: self token: tokenBuffer!

basicUnregister: anInteger from: anICoreWebView2
	anICoreWebView2 Remove_WebMessageReceived: anInteger!

Invoke: sender args: args
	"Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			[in]ICoreWebView2* sender,
			[in]ICoreWebView2WebMessageReceivedEventArgs* args);"

	<virtual stdcall: hresult 4 ICoreWebView2* ICoreWebView2WebMessageReceivedEventArgs*>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2WebMessageReceivedEventHandler categoriesForMethods!
basicRegister:with:!private!realizing/unrealizing! !
basicUnregister:from:!private!realizing/unrealizing! !
Invoke:args:!**auto generated**!COM Interfaces-ICoreWebView2WebMessageReceivedEventHandler!public! !
!

!WebView2.ICoreWebView2WebMessageReceivedEventHandler class methodsFor!

argsClass
	^ICoreWebView2WebMessageReceivedEventArgs!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2WebMessageReceivedEventHandler'
		ICoreWebView2WebMessageReceivedEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2* ICoreWebView2WebMessageReceivedEventArgs*'
!

eventName
	"Answer the symbolic name for this event (i.e. the SASE event trigger name)"

	^#webMessageReceived:! !

!WebView2.ICoreWebView2WebMessageReceivedEventHandler class categoriesForMethods!
argsClass!constants!public! !
defineFunctions!**auto generated**!initializing!public!template definition! !
eventName!constants!public! !
!

