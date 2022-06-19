"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2EventHandler subclass: #'WebView2.ICoreWebView2DOMContentLoadedEventHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2DOMContentLoadedEventHandler guid: (OS.COM.IID fromString: '{4bac7e9c-199e-49ed-87ed-249303acf019}')!
WebView2.ICoreWebView2DOMContentLoadedEventHandler comment: '`ICoreWebView2DOMContentLoadedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2DOMContentLoadedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(4bac7e9c-199e-49ed-87ed-249303acf019)
]
interface ICoreWebView2DOMContentLoadedEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2* sender,
		[in]ICoreWebView2DOMContentLoadedEventArgs* args);
};
```
'!
!WebView2.ICoreWebView2DOMContentLoadedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2DOMContentLoadedEventHandler methodsFor!

basicRegister: tokenBuffer
	source Add_DOMContentLoaded: self token: tokenBuffer!

basicUnregister
	source Remove_DOMContentLoaded: token! !
!WebView2.ICoreWebView2DOMContentLoadedEventHandler categoriesForMethods!
basicRegister:!private!realizing/unrealizing! !
basicUnregister!private!realizing/unrealizing! !
!

!WebView2.ICoreWebView2DOMContentLoadedEventHandler class methodsFor!

argsClass
	^ICoreWebView2DOMContentLoadedEventArgs!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2DOMContentLoadedEventHandler'
		ICoreWebView2DOMContentLoadedEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2* ICoreWebView2DOMContentLoadedEventArgs*'
!

eventName
	"Answer the symbolic name for this event (i.e. the SASE event trigger name)"

	^#domContentLoaded:! !
!WebView2.ICoreWebView2DOMContentLoadedEventHandler class categoriesForMethods!
argsClass!constants!public! !
defineFunctions!**auto generated**!initializing!public! !
eventName!constants!public! !
!

