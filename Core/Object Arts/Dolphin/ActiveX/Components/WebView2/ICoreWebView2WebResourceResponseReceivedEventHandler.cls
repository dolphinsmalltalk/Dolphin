"Filed out from Dolphin Smalltalk"!

ICoreWebView2EventHandler subclass: #ICoreWebView2WebResourceResponseReceivedEventHandler
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ICoreWebView2WebResourceResponseReceivedEventHandler guid: (IID fromString: '{7de9898a-24f5-40c3-a2de-d4f458e69828}')!
ICoreWebView2WebResourceResponseReceivedEventHandler comment: '`ICoreWebView2WebResourceResponseReceivedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2WebResourceResponseReceivedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(7de9898a-24f5-40c3-a2de-d4f458e69828)
]
interface ICoreWebView2WebResourceResponseReceivedEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2* sender,
		[in]ICoreWebView2WebResourceResponseReceivedEventArgs* args);
};
```
'!
!ICoreWebView2WebResourceResponseReceivedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2WebResourceResponseReceivedEventHandler methodsFor!

basicRegister: tokenBuffer
	source Add_WebResourceResponseReceived: self token: tokenBuffer!

basicUnregister
	source Remove_WebResourceResponseReceived: token! !
!ICoreWebView2WebResourceResponseReceivedEventHandler categoriesForMethods!
basicRegister:!private!realizing/unrealizing! !
basicUnregister!private!realizing/unrealizing! !
!

!ICoreWebView2WebResourceResponseReceivedEventHandler class methodsFor!

argsClass
	^ICoreWebView2WebResourceResponseReceivedEventArgs!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2WebResourceResponseReceivedEventHandler'
		ICoreWebView2WebResourceResponseReceivedEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2* ICoreWebView2WebResourceResponseReceivedEventArgs*'
!

eventName
	"Answer the symbolic name for this event (i.e. the SASE event trigger name)"

	^#webResourceResponseReceived:! !
!ICoreWebView2WebResourceResponseReceivedEventHandler class categoriesForMethods!
argsClass!constants!public! !
defineFunctions!**auto generated**!initializing!public! !
eventName!constants!public! !
!

