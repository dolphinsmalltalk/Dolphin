"Filed out from Dolphin Smalltalk"!

ICoreWebView2EventHandler subclass: #ICoreWebView2FramePermissionRequestedEventHandler
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ICoreWebView2FramePermissionRequestedEventHandler guid: (IID fromString: '{845d0edd-8bd8-429b-9915-4821789f23e9}')!
ICoreWebView2FramePermissionRequestedEventHandler comment: '`ICoreWebView2FramePermissionRequestedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2FramePermissionRequestedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(845d0edd-8bd8-429b-9915-4821789f23e9)
]
interface ICoreWebView2FramePermissionRequestedEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2Frame* sender,
		[in]ICoreWebView2PermissionRequestedEventArgs2* args);
};
```
'!
!ICoreWebView2FramePermissionRequestedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2FramePermissionRequestedEventHandler methodsFor!

basicRegister: tokenBuffer
	source Add_PermissionRequested: self token: tokenBuffer!

basicUnregister
	source Remove_PermissionRequested: token! !
!ICoreWebView2FramePermissionRequestedEventHandler categoriesForMethods!
basicRegister:!private!realizing/unrealizing! !
basicUnregister!private!realizing/unrealizing! !
!

!ICoreWebView2FramePermissionRequestedEventHandler class methodsFor!

argsClass
	^ICoreWebView2PermissionRequestedEventArgs2!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2FramePermissionRequestedEventHandler'
		ICoreWebView2FramePermissionRequestedEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2Frame* ICoreWebView2PermissionRequestedEventArgs2*'
!

eventName
	"Answer the symbolic name for this event (i.e. the SASE event trigger name)"

	^#framePermissionRequested:! !
!ICoreWebView2FramePermissionRequestedEventHandler class categoriesForMethods!
argsClass!constants!public! !
defineFunctions!**auto generated**!initializing!public! !
eventName!constants!public! !
!

