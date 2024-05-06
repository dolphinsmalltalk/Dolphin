"Filed out from Dolphin Smalltalk"!

ICoreWebView2EventHandler subclass: #ICoreWebView2ProcessFailedEventHandler
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ICoreWebView2ProcessFailedEventHandler guid: (IID fromString: '{79e0aea4-990b-42d9-aa1d-0fcc2e5bc7f1}')!

ICoreWebView2ProcessFailedEventHandler comment: '`ICoreWebView2ProcessFailedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2ProcessFailedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(79e0aea4-990b-42d9-aa1d-0fcc2e5bc7f1)
]
interface ICoreWebView2ProcessFailedEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2* sender,
		[in]ICoreWebView2ProcessFailedEventArgs* args);
};
```
'!

!ICoreWebView2ProcessFailedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!ICoreWebView2ProcessFailedEventHandler methodsFor!

basicRegister: tokenBuffer
	source Add_ProcessFailed: self token: tokenBuffer!

basicUnregister
	source Remove_ProcessFailed: token! !

!ICoreWebView2ProcessFailedEventHandler categoriesForMethods!
basicRegister:!private!realizing/unrealizing! !
basicUnregister!private!realizing/unrealizing! !
!

!ICoreWebView2ProcessFailedEventHandler class methodsFor!

argsClass
	^ICoreWebView2ProcessFailedEventArgs2!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2ProcessFailedEventHandler'
		ICoreWebView2ProcessFailedEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2* ICoreWebView2ProcessFailedEventArgs*'
!

eventName
	"Answer the symbolic name for this event (i.e. the SASE event trigger name)"

	^#processFailed:! !

!ICoreWebView2ProcessFailedEventHandler class categoriesForMethods!
argsClass!constants!public! !
defineFunctions!**auto generated**!initializing!public! !
eventName!constants!public! !
!

