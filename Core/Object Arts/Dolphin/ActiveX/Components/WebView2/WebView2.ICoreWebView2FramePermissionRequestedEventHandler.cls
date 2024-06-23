"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2EventHandler
	subclass: #'WebView2.ICoreWebView2FramePermissionRequestedEventHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2FramePermissionRequestedEventHandler guid: (OS.COM.IID fromString: '{845d0edd-8bd8-429b-9915-4821789f23e9}')!

WebView2.ICoreWebView2FramePermissionRequestedEventHandler comment: '`ICoreWebView2FramePermissionRequestedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2FramePermissionRequestedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

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

!WebView2.ICoreWebView2FramePermissionRequestedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2FramePermissionRequestedEventHandler methodsFor!

basicRegister: tokenBuffer
	source Add_PermissionRequested: self token: tokenBuffer!

basicUnregister
	source Remove_PermissionRequested: token!

Invoke: sender args: args
	"Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			[in]ICoreWebView2Frame* sender,
			[in]ICoreWebView2PermissionRequestedEventArgs2* args);"

	<virtual stdcall: hresult 4 ICoreWebView2Frame* ICoreWebView2PermissionRequestedEventArgs2*>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2FramePermissionRequestedEventHandler categoriesForMethods!
basicRegister:!private!realizing/unrealizing! !
basicUnregister!private!realizing/unrealizing! !
Invoke:args:!**auto generated**!COM Interfaces-ICoreWebView2FramePermissionRequestedEventHandler!public! !
!

!WebView2.ICoreWebView2FramePermissionRequestedEventHandler class methodsFor!

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

!WebView2.ICoreWebView2FramePermissionRequestedEventHandler class categoriesForMethods!
argsClass!constants!public! !
defineFunctions!**auto generated**!initializing!public!template definition! !
eventName!constants!public! !
!

