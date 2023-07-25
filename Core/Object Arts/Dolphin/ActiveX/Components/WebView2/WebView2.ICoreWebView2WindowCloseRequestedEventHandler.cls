"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2EventHandler
	subclass: #'WebView2.ICoreWebView2WindowCloseRequestedEventHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2WindowCloseRequestedEventHandler guid: (OS.COM.IID fromString: '{5c19e9e0-092f-486b-affa-ca8231913039}')!
WebView2.ICoreWebView2WindowCloseRequestedEventHandler comment: '`ICoreWebView2WindowCloseRequestedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2WindowCloseRequestedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(5c19e9e0-092f-486b-affa-ca8231913039)
]
interface ICoreWebView2WindowCloseRequestedEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2* sender,
		[in]IUnknown* args);
};
```
'!
!WebView2.ICoreWebView2WindowCloseRequestedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2WindowCloseRequestedEventHandler methodsFor!

basicRegister: tokenBuffer
	source Add_WindowCloseRequested: self token: tokenBuffer!

basicUnregister
	source Remove_WindowCloseRequested: token! !
!WebView2.ICoreWebView2WindowCloseRequestedEventHandler categoriesForMethods!
basicRegister:!private!realizing/unrealizing! !
basicUnregister!private!realizing/unrealizing! !
!

!WebView2.ICoreWebView2WindowCloseRequestedEventHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2WindowCloseRequestedEventHandler'
		ICoreWebView2WindowCloseRequestedEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2* IUnknown*'
!

eventName
	"Answer the symbolic name for this event (i.e. the SASE event trigger name)"

	^#windowCloseRequested! !
!WebView2.ICoreWebView2WindowCloseRequestedEventHandler class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
eventName!constants!public! !
!

