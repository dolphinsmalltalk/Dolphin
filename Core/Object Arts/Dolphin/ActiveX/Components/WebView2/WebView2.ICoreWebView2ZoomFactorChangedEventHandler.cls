"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2EventHandler subclass: #'WebView2.ICoreWebView2ZoomFactorChangedEventHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2ZoomFactorChangedEventHandler guid: (OS.COM.IID fromString: '{b52d71d6-c4df-4543-a90c-64a3e60f38cb}')!
WebView2.ICoreWebView2ZoomFactorChangedEventHandler comment: '`ICoreWebView2ZoomFactorChangedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2ZoomFactorChangedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(b52d71d6-c4df-4543-a90c-64a3e60f38cb)
]
interface ICoreWebView2ZoomFactorChangedEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2Controller* sender,
		[in]IUnknown* args);
};
```
'!
!WebView2.ICoreWebView2ZoomFactorChangedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2ZoomFactorChangedEventHandler methodsFor!

basicRegister: tokenBuffer
	source Add_ZoomFactorChanged: self token: tokenBuffer!

basicUnregister
	source Remove_ZoomFactorChanged: token! !
!WebView2.ICoreWebView2ZoomFactorChangedEventHandler categoriesForMethods!
basicRegister:!private!realizing/unrealizing! !
basicUnregister!private!realizing/unrealizing! !
!

!WebView2.ICoreWebView2ZoomFactorChangedEventHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2ZoomFactorChangedEventHandler'
		ICoreWebView2ZoomFactorChangedEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2Controller* IUnknown*'
!

eventName
	"Answer the symbolic name for this event (i.e. the SASE event trigger name)"

	^#zoomFactorChanged! !
!WebView2.ICoreWebView2ZoomFactorChangedEventHandler class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
eventName!constants!public! !
!

