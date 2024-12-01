"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2EventHandler
	subclass: #'WebView2.ICoreWebView2SaveAsUIShowingEventHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2SaveAsUIShowingEventHandler guid: (OS.COM.IID fromString: '{6baa177e-3a2e-5ccf-9a13-fad676cd0522}')!

WebView2.ICoreWebView2SaveAsUIShowingEventHandler comment: '`ICoreWebView2SaveAsUIShowingEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2SaveAsUIShowingEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(6baa177e-3a2e-5ccf-9a13-fad676cd0522)
]
interface ICoreWebView2SaveAsUIShowingEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2* sender,
		[in]ICoreWebView2SaveAsUIShowingEventArgs* args);
};
```
'!

!WebView2.ICoreWebView2SaveAsUIShowingEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2SaveAsUIShowingEventHandler methodsFor!

basicRegister: tokenBuffer
	source Add_SaveAsUIShowing: self token: tokenBuffer!

basicUnregister
	source Remove_SaveAsUIShowing: token!

Invoke: sender args: args
	"Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			[in]ICoreWebView2* sender,
			[in]ICoreWebView2SaveAsUIShowingEventArgs* args);"

	<virtual stdcall: hresult 4 ICoreWebView2* ICoreWebView2SaveAsUIShowingEventArgs*>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2SaveAsUIShowingEventHandler categoriesForMethods!
basicRegister:!private!realizing/unrealizing! !
basicUnregister!private!realizing/unrealizing! !
Invoke:args:!**auto generated**!COM Interfaces-ICoreWebView2SaveAsUIShowingEventHandler!public! !
!

!WebView2.ICoreWebView2SaveAsUIShowingEventHandler class methodsFor!

argsClass
	^ICoreWebView2SaveAsUIShowingEventArgs!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2SaveAsUIShowingEventHandler'
		ICoreWebView2SaveAsUIShowingEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2* ICoreWebView2SaveAsUIShowingEventArgs*'
!

eventName
	"Answer the symbolic name for this event (i.e. the SASE event trigger name)"

	^#saveAsUIShowing:! !

!WebView2.ICoreWebView2SaveAsUIShowingEventHandler class categoriesForMethods!
argsClass!constants!public! !
defineFunctions!**auto generated**!initializing!public!template definition! !
eventName!constants!public! !
!

