"Filed out from Dolphin Smalltalk"!

ICoreWebView2EventHandler subclass: #ICoreWebView2FrameCreatedEventHandler
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{Smalltalk.WebView2Constants})
	classInstanceVariableNames: ''
	classConstants: {}!
ICoreWebView2FrameCreatedEventHandler guid: (OS.COM.IID fromString: '{38059770-9baa-11eb-a8b3-0242ac130003}')!
ICoreWebView2FrameCreatedEventHandler comment: '`ICoreWebView2FrameCreatedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2FrameCreatedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

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
!ICoreWebView2FrameCreatedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2FrameCreatedEventHandler methodsFor!

basicRegister: tokenBuffer
	source Add_FrameCreated: self token: tokenBuffer!

basicUnregister
	source Remove_FrameCreated: token! !
!ICoreWebView2FrameCreatedEventHandler categoriesForMethods!
basicRegister:!private!realizing/unrealizing! !
basicUnregister!private!realizing/unrealizing! !
!

!ICoreWebView2FrameCreatedEventHandler class methodsFor!

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
!ICoreWebView2FrameCreatedEventHandler class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
eventName!constants!public! !
!

