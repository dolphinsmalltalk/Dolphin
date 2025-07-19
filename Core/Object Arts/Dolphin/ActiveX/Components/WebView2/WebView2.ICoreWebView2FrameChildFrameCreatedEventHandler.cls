"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2FrameEventHandler
	subclass: #'WebView2.ICoreWebView2FrameChildFrameCreatedEventHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2FrameChildFrameCreatedEventHandler guid: (OS.COM.IID fromString: '{569e40e7-46b7-563d-83ae-1073155664d7}')!

WebView2.ICoreWebView2FrameChildFrameCreatedEventHandler comment: '`ICoreWebView2FrameChildFrameCreatedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2FrameChildFrameCreatedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(569e40e7-46b7-563d-83ae-1073155664d7)
]
interface ICoreWebView2FrameChildFrameCreatedEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2Frame* sender,
		[in]ICoreWebView2FrameCreatedEventArgs* args);
};
```
'!

!WebView2.ICoreWebView2FrameChildFrameCreatedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2FrameChildFrameCreatedEventHandler methodsFor!

basicRegister: tokenBuffer with: anICoreWebView2Frame7
	anICoreWebView2Frame7 Add_FrameCreated: self token: tokenBuffer!

basicUnregister: anInteger from: anICoreWebView2Frame7
	anICoreWebView2Frame7 Remove_FrameCreated: anInteger!

Invoke: sender args: args
	"Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			[in]ICoreWebView2Frame* sender,
			[in]ICoreWebView2FrameCreatedEventArgs* args);"

	<virtual stdcall: hresult 4 ICoreWebView2Frame* ICoreWebView2FrameCreatedEventArgs*>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2FrameChildFrameCreatedEventHandler categoriesForMethods!
basicRegister:with:!private!realizing/unrealizing! !
basicUnregister:from:!private!realizing/unrealizing! !
Invoke:args:!**auto generated**!COM Interfaces-ICoreWebView2FrameChildFrameCreatedEventHandler!public! !
!

!WebView2.ICoreWebView2FrameChildFrameCreatedEventHandler class methodsFor!

argsClass
	^ICoreWebView2FrameCreatedEventArgs!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2FrameChildFrameCreatedEventHandler'
		ICoreWebView2FrameChildFrameCreatedEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2Frame* ICoreWebView2FrameCreatedEventArgs*'
!

eventName
	"Answer the symbolic name for this event (i.e. the SASE event trigger name)"

	^#frame:childFrameCreated:! !

!WebView2.ICoreWebView2FrameChildFrameCreatedEventHandler class categoriesForMethods!
argsClass!constants!public! !
defineFunctions!**auto generated**!initializing!public!template definition! !
eventName!constants!public! !
!

