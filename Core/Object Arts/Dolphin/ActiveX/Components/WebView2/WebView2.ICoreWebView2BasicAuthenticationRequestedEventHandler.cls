"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2EventHandler
	subclass: #'WebView2.ICoreWebView2BasicAuthenticationRequestedEventHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2BasicAuthenticationRequestedEventHandler guid: (OS.COM.IID fromString: '{58b4d6c2-18d4-497e-b39b-9a96533fa278}')!
WebView2.ICoreWebView2BasicAuthenticationRequestedEventHandler comment: '`ICoreWebView2BasicAuthenticationRequestedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2BasicAuthenticationRequestedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

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
!WebView2.ICoreWebView2BasicAuthenticationRequestedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2BasicAuthenticationRequestedEventHandler methodsFor!

basicRegister: tokenBuffer
	source Add_BasicAuthenticationRequested: self token: tokenBuffer!

basicUnregister
	source Remove_BasicAuthenticationRequested: token!

Invoke: sender args: args
	"Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			[in]ICoreWebView2* sender,
			[in]ICoreWebView2BasicAuthenticationRequestedEventArgs* args);"

	<virtual stdcall: hresult 4 ICoreWebView2* ICoreWebView2BasicAuthenticationRequestedEventArgs*>
	^self invalidCall: _failureCode! !
!WebView2.ICoreWebView2BasicAuthenticationRequestedEventHandler categoriesForMethods!
basicRegister:!private!realizing/unrealizing! !
basicUnregister!private!realizing/unrealizing! !
Invoke:args:!**auto generated**!COM Interfaces-ICoreWebView2BasicAuthenticationRequestedEventHandler!public! !
!

!WebView2.ICoreWebView2BasicAuthenticationRequestedEventHandler class methodsFor!

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
!WebView2.ICoreWebView2BasicAuthenticationRequestedEventHandler class categoriesForMethods!
argsClass!constants!public! !
defineFunctions!**auto generated**!initializing!public!template definition! !
eventName!constants!public! !
!

