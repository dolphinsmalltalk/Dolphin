"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2ViewEventHandler
	subclass: #'WebView2.ICoreWebView2WebResourceRequestedEventHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2WebResourceRequestedEventHandler guid: (OS.COM.IID fromString: '{ab00b74c-15f1-4646-80e8-e76341d25d71}')!

WebView2.ICoreWebView2WebResourceRequestedEventHandler comment: '`ICoreWebView2WebResourceRequestedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2WebResourceRequestedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

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

!WebView2.ICoreWebView2WebResourceRequestedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2WebResourceRequestedEventHandler methodsFor!

basicRegister: tokenBuffer with: anICoreWebView2
	anICoreWebView2 Add_WebResourceRequested: self token: tokenBuffer!

basicUnregister: anInteger from: anICoreWebView2
	anICoreWebView2 Remove_WebResourceRequested: anInteger!

Invoke: sender args: args
	"Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			[in]ICoreWebView2* sender,
			[in]ICoreWebView2WebResourceRequestedEventArgs* args);"

	<virtual stdcall: hresult 4 ICoreWebView2* ICoreWebView2WebResourceRequestedEventArgs*>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2WebResourceRequestedEventHandler categoriesForMethods!
basicRegister:with:!private!realizing/unrealizing! !
basicUnregister:from:!private!realizing/unrealizing! !
Invoke:args:!**auto generated**!COM Interfaces-ICoreWebView2WebResourceRequestedEventHandler!public! !
!

!WebView2.ICoreWebView2WebResourceRequestedEventHandler class methodsFor!

argsClass
	^ICoreWebView2WebResourceRequestedEventArgs!

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

!WebView2.ICoreWebView2WebResourceRequestedEventHandler class categoriesForMethods!
argsClass!constants!public! !
defineFunctions!**auto generated**!initializing!public!template definition! !
eventName!constants!public! !
!

