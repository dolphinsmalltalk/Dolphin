"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2EventHandler
	subclass: #'WebView2.ICoreWebView2SaveFileSecurityCheckStartingEventHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2SaveFileSecurityCheckStartingEventHandler guid: (OS.COM.IID fromString: '{7899576c-19e3-57c8-b7d1-55808292de57}')!

WebView2.ICoreWebView2SaveFileSecurityCheckStartingEventHandler comment: '`ICoreWebView2SaveFileSecurityCheckStartingEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2SaveFileSecurityCheckStartingEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(7899576c-19e3-57c8-b7d1-55808292de57)
]
interface ICoreWebView2SaveFileSecurityCheckStartingEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2* sender,
		[in]ICoreWebView2SaveFileSecurityCheckStartingEventArgs* args);
};
```
'!

!WebView2.ICoreWebView2SaveFileSecurityCheckStartingEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2SaveFileSecurityCheckStartingEventHandler methodsFor!

basicRegister: tokenBuffer
	source Add_SaveFileSecurityCheckStarting: self token: tokenBuffer!

basicUnregister
	source Remove_SaveFileSecurityCheckStarting: token!

Invoke: sender args: args
	"Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			[in]ICoreWebView2* sender,
			[in]ICoreWebView2SaveFileSecurityCheckStartingEventArgs* args);"

	<virtual stdcall: hresult 4 ICoreWebView2* ICoreWebView2SaveFileSecurityCheckStartingEventArgs*>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2SaveFileSecurityCheckStartingEventHandler categoriesForMethods!
basicRegister:!private!realizing/unrealizing! !
basicUnregister!private!realizing/unrealizing! !
Invoke:args:!**auto generated**!COM Interfaces-ICoreWebView2SaveFileSecurityCheckStartingEventHandler!public! !
!

!WebView2.ICoreWebView2SaveFileSecurityCheckStartingEventHandler class methodsFor!

argsClass
	^ICoreWebView2SaveFileSecurityCheckStartingEventArgs!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2SaveFileSecurityCheckStartingEventHandler'
		ICoreWebView2SaveFileSecurityCheckStartingEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2* ICoreWebView2SaveFileSecurityCheckStartingEventArgs*'
!

eventName
	"Answer the symbolic name for this event (i.e. the SASE event trigger name)"

	^#safeFileSecurityCheckStarting:! !

!WebView2.ICoreWebView2SaveFileSecurityCheckStartingEventHandler class categoriesForMethods!
argsClass!constants!public! !
defineFunctions!**auto generated**!initializing!public!template definition! !
eventName!constants!public! !
!

