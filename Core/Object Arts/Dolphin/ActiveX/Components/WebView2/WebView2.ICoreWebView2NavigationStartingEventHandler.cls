"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2EventHandler
	subclass: #'WebView2.ICoreWebView2NavigationStartingEventHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2NavigationStartingEventHandler guid: (OS.COM.IID fromString: '{9adbe429-f36d-432b-9ddc-f8881fbd76e3}')!

WebView2.ICoreWebView2NavigationStartingEventHandler comment: '`ICoreWebView2NavigationStartingEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2NavigationStartingEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(9adbe429-f36d-432b-9ddc-f8881fbd76e3)
]
interface ICoreWebView2NavigationStartingEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2* sender,
		[in]ICoreWebView2NavigationStartingEventArgs* args);
};
```
'!

!WebView2.ICoreWebView2NavigationStartingEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2NavigationStartingEventHandler methodsFor!

basicRegister: tokenBuffer
	source Add_NavigationStarting: self token: tokenBuffer!

basicUnregister
	source Remove_NavigationStarting: token!

Invoke: sender args: args
	"Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			[in]ICoreWebView2* sender,
			[in]ICoreWebView2NavigationStartingEventArgs* args);"

	<virtual stdcall: hresult 4 ICoreWebView2* ICoreWebView2NavigationStartingEventArgs*>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2NavigationStartingEventHandler categoriesForMethods!
basicRegister:!private!realizing/unrealizing! !
basicUnregister!private!realizing/unrealizing! !
Invoke:args:!**auto generated**!COM Interfaces-ICoreWebView2NavigationStartingEventHandler!public! !
!

!WebView2.ICoreWebView2NavigationStartingEventHandler class methodsFor!

argsClass
	^ICoreWebView2NavigationStartingEventArgs!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2NavigationStartingEventHandler'
		ICoreWebView2NavigationStartingEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2* ICoreWebView2NavigationStartingEventArgs*'
!

eventName
	"Answer the symbolic name for this event (i.e. the SASE event trigger name)"

	^#navigationStarting:! !

!WebView2.ICoreWebView2NavigationStartingEventHandler class categoriesForMethods!
argsClass!constants!public! !
defineFunctions!**auto generated**!initializing!public!template definition! !
eventName!constants!public! !
!

