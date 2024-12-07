"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2EventHandler
	subclass: #'WebView2.ICoreWebView2FrameCreatedEventHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2FrameCreatedEventHandler guid: (OS.COM.IID fromString: '{38059770-9baa-11eb-a8b3-0242ac130003}')!

WebView2.ICoreWebView2FrameCreatedEventHandler comment: '`ICoreWebView2FrameCreatedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2FrameCreatedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(38059770-9baa-11eb-a8b3-0242ac130003)
]
interface ICoreWebView2FrameCreatedEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2* sender,
		[in]ICoreWebView2FrameCreatedEventArgs* args);
};
```
'!

!WebView2.ICoreWebView2FrameCreatedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2FrameCreatedEventHandler methodsFor!

basicRegister: tokenBuffer with: anICoreWebView2Interface
	anICoreWebView2Interface Add_FrameCreated: self token: tokenBuffer!

basicUnregister: anInteger from: anICoreWebView2Interface
	anICoreWebView2Interface Remove_FrameCreated: anInteger!

Invoke: sender args: args
	"Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			[in]ICoreWebView2* sender,
			[in]ICoreWebView2FrameCreatedEventArgs* args);"

	<virtual stdcall: hresult 4 ICoreWebView2* ICoreWebView2FrameCreatedEventArgs*>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2FrameCreatedEventHandler categoriesForMethods!
basicRegister:with:!private!realizing/unrealizing! !
basicUnregister:from:!private!realizing/unrealizing! !
Invoke:args:!**auto generated**!COM Interfaces-ICoreWebView2FrameCreatedEventHandler!public! !
!

!WebView2.ICoreWebView2FrameCreatedEventHandler class methodsFor!

argsClass
	^ICoreWebView2FrameCreatedEventArgs!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2FrameCreatedEventHandler'
		ICoreWebView2FrameCreatedEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2* ICoreWebView2FrameCreatedEventArgs*'
!

eventName
	"Answer the symbolic name for this event (i.e. the SASE event trigger name)"

	^#frameCreated:! !

!WebView2.ICoreWebView2FrameCreatedEventHandler class categoriesForMethods!
argsClass!constants!public! !
defineFunctions!**auto generated**!initializing!public!template definition! !
eventName!constants!public! !
!

