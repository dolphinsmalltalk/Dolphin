"Filed out from Dolphin Smalltalk"!

ICoreWebView2EventHandler subclass: #ICoreWebView2FrameDOMContentLoadedEventHandler
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
ICoreWebView2FrameDOMContentLoadedEventHandler guid: (OS.COM.IID fromString: '{38d9520d-340f-4d1e-a775-43fce9753683}')!
ICoreWebView2FrameDOMContentLoadedEventHandler comment: '`ICoreWebView2FrameDOMContentLoadedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2FrameDOMContentLoadedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(38d9520d-340f-4d1e-a775-43fce9753683)
]
interface ICoreWebView2FrameDOMContentLoadedEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2Frame* sender,
		[in]ICoreWebView2DOMContentLoadedEventArgs* args);
};
```
'!
!ICoreWebView2FrameDOMContentLoadedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2FrameDOMContentLoadedEventHandler methodsFor!

basicRegister: tokenBuffer
	source Add_DOMContentLoaded: self token: tokenBuffer!

basicUnregister
	source Remove_DOMContentLoaded: token! !
!ICoreWebView2FrameDOMContentLoadedEventHandler categoriesForMethods!
basicRegister:!private!realizing/unrealizing! !
basicUnregister!private!realizing/unrealizing! !
!

!ICoreWebView2FrameDOMContentLoadedEventHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2FrameDOMContentLoadedEventHandler'
		ICoreWebView2FrameDOMContentLoadedEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2Frame* ICoreWebView2DOMContentLoadedEventArgs*'
!

eventName
	"Answer the symbolic name for this event (i.e. the SASE event trigger name)"

	^#frameDomContentLoaded:! !
!ICoreWebView2FrameDOMContentLoadedEventHandler class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
eventName!constants!public! !
!

