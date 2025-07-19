"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2ViewEventHandler
	subclass: #'WebView2.ICoreWebView2ScreenCaptureStartingEventHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2ScreenCaptureStartingEventHandler guid: (OS.COM.IID fromString: '{e24ff05a-1db5-59d9-89f3-3c864268db4a}')!

WebView2.ICoreWebView2ScreenCaptureStartingEventHandler comment: '`ICoreWebView2ScreenCaptureStartingEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2ScreenCaptureStartingEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(e24ff05a-1db5-59d9-89f3-3c864268db4a)
]
interface ICoreWebView2ScreenCaptureStartingEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2* sender,
		[in]ICoreWebView2ScreenCaptureStartingEventArgs* args);
};
```
'!

!WebView2.ICoreWebView2ScreenCaptureStartingEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2ScreenCaptureStartingEventHandler methodsFor!

basicRegister: tokenBuffer with: anICoreWebView2_27
	anICoreWebView2_27 Add_ScreenCaptureStarting: self token: tokenBuffer!

basicUnregister: anInteger from: anICoreWebView2_27
	anICoreWebView2_27 Remove_ScreenCaptureStarting: anInteger!

Invoke: sender args: args
	"Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			[in]ICoreWebView2* sender,
			[in]ICoreWebView2ScreenCaptureStartingEventArgs* args);"

	<virtual stdcall: hresult 4 ICoreWebView2* ICoreWebView2ScreenCaptureStartingEventArgs*>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2ScreenCaptureStartingEventHandler categoriesForMethods!
basicRegister:with:!private!realizing/unrealizing! !
basicUnregister:from:!private!realizing/unrealizing! !
Invoke:args:!**auto generated**!COM Interfaces-ICoreWebView2ScreenCaptureStartingEventHandler!public! !
!

!WebView2.ICoreWebView2ScreenCaptureStartingEventHandler class methodsFor!

argsClass
	^ICoreWebView2ScreenCaptureStartingEventArgs!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2ScreenCaptureStartingEventHandler'
		ICoreWebView2ScreenCaptureStartingEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2* ICoreWebView2ScreenCaptureStartingEventArgs*'
!

eventName
	"Answer the symbolic name for this event (i.e. the SASE event trigger name)"

	^#screenCaptureStarting:! !

!WebView2.ICoreWebView2ScreenCaptureStartingEventHandler class categoriesForMethods!
argsClass!constants!public! !
defineFunctions!**auto generated**!initializing!public!template definition! !
eventName!constants!public! !
!

