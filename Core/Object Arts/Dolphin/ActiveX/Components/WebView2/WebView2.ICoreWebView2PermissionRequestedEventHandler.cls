"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2EventHandler
	subclass: #'WebView2.ICoreWebView2PermissionRequestedEventHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2PermissionRequestedEventHandler guid: (OS.COM.IID fromString: '{15e1c6a3-c72a-4df3-91d7-d097fbec6bfd}')!
WebView2.ICoreWebView2PermissionRequestedEventHandler comment: '`ICoreWebView2PermissionRequestedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2PermissionRequestedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(15e1c6a3-c72a-4df3-91d7-d097fbec6bfd)
]
interface ICoreWebView2PermissionRequestedEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2* sender,
		[in]ICoreWebView2PermissionRequestedEventArgs* args);
};
```
'!
!WebView2.ICoreWebView2PermissionRequestedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2PermissionRequestedEventHandler methodsFor!

basicRegister: tokenBuffer
	source Add_PermissionRequested: self token: tokenBuffer!

basicUnregister
	source Remove_PermissionRequested: token! !
!WebView2.ICoreWebView2PermissionRequestedEventHandler categoriesForMethods!
basicRegister:!private!realizing/unrealizing! !
basicUnregister!private!realizing/unrealizing! !
!

!WebView2.ICoreWebView2PermissionRequestedEventHandler class methodsFor!

argsClass
	^ICoreWebView2PermissionRequestedEventArgs2!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2PermissionRequestedEventHandler'
		ICoreWebView2PermissionRequestedEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2* ICoreWebView2PermissionRequestedEventArgs*'
!

eventName
	"Answer the symbolic name for this event (i.e. the SASE event trigger name)"

	^#permissionRequested:! !
!WebView2.ICoreWebView2PermissionRequestedEventHandler class categoriesForMethods!
argsClass!constants!public! !
defineFunctions!**auto generated**!initializing!public!template definition! !
eventName!constants!public! !
!

