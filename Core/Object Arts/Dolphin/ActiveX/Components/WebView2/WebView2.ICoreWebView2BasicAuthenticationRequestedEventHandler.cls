"Filed out from Dolphin Smalltalk"!

ICoreWebView2EventHandler subclass: #ICoreWebView2BasicAuthenticationRequestedEventHandler
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ICoreWebView2BasicAuthenticationRequestedEventHandler guid: (IID fromString: '{58b4d6c2-18d4-497e-b39b-9a96533fa278}')!
ICoreWebView2BasicAuthenticationRequestedEventHandler comment: '`ICoreWebView2BasicAuthenticationRequestedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2BasicAuthenticationRequestedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(58b4d6c2-18d4-497e-b39b-9a96533fa278)
]
interface ICoreWebView2BasicAuthenticationRequestedEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2* sender,
		[in]ICoreWebView2BasicAuthenticationRequestedEventArgs* args);
};
```
'!
!ICoreWebView2BasicAuthenticationRequestedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2BasicAuthenticationRequestedEventHandler methodsFor!

basicRegister: tokenBuffer
	source Add_BasicAuthenticationRequested: self token: tokenBuffer!

basicUnregister
	source Remove_BasicAuthenticationRequested: token! !
!ICoreWebView2BasicAuthenticationRequestedEventHandler categoriesForMethods!
basicRegister:!private!realizing/unrealizing! !
basicUnregister!private!realizing/unrealizing! !
!

!ICoreWebView2BasicAuthenticationRequestedEventHandler class methodsFor!

argsClass
	^ICoreWebView2BasicAuthenticationRequestedEventArgs!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2BasicAuthenticationRequestedEventHandler'
		ICoreWebView2BasicAuthenticationRequestedEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2* ICoreWebView2BasicAuthenticationRequestedEventArgs*'
!

eventName
	"Answer the symbolic name for this event (i.e. the SASE event trigger name)"

	^#basicAuthenticationRequested:! !
!ICoreWebView2BasicAuthenticationRequestedEventHandler class categoriesForMethods!
argsClass!constants!public! !
defineFunctions!**auto generated**!initializing!public! !
eventName!constants!public! !
!

