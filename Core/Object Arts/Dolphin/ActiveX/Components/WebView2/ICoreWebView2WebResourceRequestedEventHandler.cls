"Filed out from Dolphin Smalltalk"!

ICoreWebView2EventHandler subclass: #ICoreWebView2WebResourceRequestedEventHandler
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ICoreWebView2WebResourceRequestedEventHandler guid: (IID fromString: '{ab00b74c-15f1-4646-80e8-e76341d25d71}')!
ICoreWebView2WebResourceRequestedEventHandler comment: '`ICoreWebView2WebResourceRequestedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2WebResourceRequestedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(ab00b74c-15f1-4646-80e8-e76341d25d71)
]
interface ICoreWebView2WebResourceRequestedEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2* sender,
		[in]ICoreWebView2WebResourceRequestedEventArgs* args);
};
```
'!
!ICoreWebView2WebResourceRequestedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2WebResourceRequestedEventHandler methodsFor!

basicRegister: tokenBuffer
	source Add_WebResourceRequested: self token: tokenBuffer!

basicUnregister
	source Remove_WebResourceRequested: token! !
!ICoreWebView2WebResourceRequestedEventHandler categoriesForMethods!
basicRegister:!private!realizing/unrealizing! !
basicUnregister!private!realizing/unrealizing! !
!

!ICoreWebView2WebResourceRequestedEventHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2WebResourceRequestedEventHandler'
		ICoreWebView2WebResourceRequestedEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2* ICoreWebView2WebResourceRequestedEventArgs*'
!

eventName
	"Answer the symbolic name for this event (i.e. the SASE event trigger name)"

	^#webResourceRequested:! !
!ICoreWebView2WebResourceRequestedEventHandler class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
eventName!constants!public! !
!

