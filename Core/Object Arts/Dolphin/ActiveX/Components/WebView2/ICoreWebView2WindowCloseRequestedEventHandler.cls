"Filed out from Dolphin Smalltalk"!

ICoreWebView2EventHandler subclass: #ICoreWebView2WindowCloseRequestedEventHandler
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ICoreWebView2WindowCloseRequestedEventHandler guid: (IID fromString: '{5c19e9e0-092f-486b-affa-ca8231913039}')!
ICoreWebView2WindowCloseRequestedEventHandler comment: '`ICoreWebView2WindowCloseRequestedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2WindowCloseRequestedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

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
!ICoreWebView2WindowCloseRequestedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2WindowCloseRequestedEventHandler methodsFor!

basicRegister: tokenBuffer
	source Add_WindowCloseRequested: self token: tokenBuffer!

basicUnregister
	source Remove_WindowCloseRequested: token! !
!ICoreWebView2WindowCloseRequestedEventHandler categoriesForMethods!
basicRegister:!private!realizing/unrealizing! !
basicUnregister!private!realizing/unrealizing! !
!

!ICoreWebView2WindowCloseRequestedEventHandler class methodsFor!

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
!ICoreWebView2WindowCloseRequestedEventHandler class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
eventName!constants!public! !
!

