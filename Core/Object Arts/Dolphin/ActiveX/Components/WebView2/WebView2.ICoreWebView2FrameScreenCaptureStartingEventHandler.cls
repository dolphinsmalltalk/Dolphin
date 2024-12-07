"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2EventHandler
	subclass: #'WebView2.ICoreWebView2FrameScreenCaptureStartingEventHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2FrameScreenCaptureStartingEventHandler guid: (OS.COM.IID fromString: '{a6c1d8ad-bb80-59c5-895b-fba1698b9309}')!

WebView2.ICoreWebView2FrameScreenCaptureStartingEventHandler comment: '`ICoreWebView2FrameScreenCaptureStartingEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2FrameScreenCaptureStartingEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(a6c1d8ad-bb80-59c5-895b-fba1698b9309)
]
interface ICoreWebView2FrameScreenCaptureStartingEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2Frame* sender,
		[in]ICoreWebView2ScreenCaptureStartingEventArgs* args);
};
```
'!

!WebView2.ICoreWebView2FrameScreenCaptureStartingEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2FrameScreenCaptureStartingEventHandler methodsFor!

basicRegister: tokenBuffer with: anICoreWebView2Interface
	anICoreWebView2Interface Add_ScreenCaptureStarting: self token: tokenBuffer!

basicUnregister: anInteger from: anICoreWebView2Interface
	anICoreWebView2Interface Remove_ScreenCaptureStarting: anInteger!

Invoke: sender args: args
	"Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			[in]ICoreWebView2Frame* sender,
			[in]ICoreWebView2ScreenCaptureStartingEventArgs* args);"

	<virtual stdcall: hresult 4 ICoreWebView2Frame* ICoreWebView2ScreenCaptureStartingEventArgs*>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2FrameScreenCaptureStartingEventHandler categoriesForMethods!
basicRegister:with:!private!realizing/unrealizing! !
basicUnregister:from:!private!realizing/unrealizing! !
Invoke:args:!**auto generated**!COM Interfaces-ICoreWebView2FrameScreenCaptureStartingEventHandler!public! !
!

!WebView2.ICoreWebView2FrameScreenCaptureStartingEventHandler class methodsFor!

argsClass
	^ICoreWebView2ScreenCaptureStartingEventArgs!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2FrameScreenCaptureStartingEventHandler'
		ICoreWebView2FrameScreenCaptureStartingEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2Frame* ICoreWebView2ScreenCaptureStartingEventArgs*'
!

eventName
	"Answer the symbolic name for this event (i.e. the SASE event trigger name)"

	^#screenCaptureStarting:! !

!WebView2.ICoreWebView2FrameScreenCaptureStartingEventHandler class categoriesForMethods!
argsClass!constants!public! !
defineFunctions!**auto generated**!initializing!public!template definition! !
eventName!constants!public! !
!

