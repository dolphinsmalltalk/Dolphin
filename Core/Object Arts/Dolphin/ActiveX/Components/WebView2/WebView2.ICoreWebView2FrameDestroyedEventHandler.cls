"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2AcceleratorKeyPressedEventHandler subclass: #'WebView2.ICoreWebView2FrameDestroyedEventHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2FrameDestroyedEventHandler guid: (OS.COM.IID fromString: '{59dd7b4c-9baa-11eb-a8b3-0242ac130003}')!
WebView2.ICoreWebView2FrameDestroyedEventHandler comment: '`ICoreWebView2FrameDestroyedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2FrameDestroyedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(59dd7b4c-9baa-11eb-a8b3-0242ac130003)
]
interface ICoreWebView2FrameDestroyedEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2Frame* sender,
		[in]IUnknown* args);
};
```
'!
!WebView2.ICoreWebView2FrameDestroyedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2FrameDestroyedEventHandler methodsFor!

basicRegister: tokenBuffer
	source Add_Destroyed: self token: tokenBuffer!

basicUnregister
	source Remove_Destroyed: token! !
!WebView2.ICoreWebView2FrameDestroyedEventHandler categoriesForMethods!
basicRegister:!private!realizing/unrealizing! !
basicUnregister!private!realizing/unrealizing! !
!

!WebView2.ICoreWebView2FrameDestroyedEventHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2FrameDestroyedEventHandler'
		ICoreWebView2FrameDestroyedEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2Frame* IUnknown*'
!

eventName
	"Answer the symbolic name for this event (i.e. the SASE event trigger name)"

	^#frameDestroyed! !
!WebView2.ICoreWebView2FrameDestroyedEventHandler class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
eventName!constants!public! !
!

