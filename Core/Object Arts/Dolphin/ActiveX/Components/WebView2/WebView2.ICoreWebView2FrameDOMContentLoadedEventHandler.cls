﻿"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2FrameEventHandler
	subclass: #'WebView2.ICoreWebView2FrameDOMContentLoadedEventHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2FrameDOMContentLoadedEventHandler guid: (OS.COM.IID fromString: '{38d9520d-340f-4d1e-a775-43fce9753683}')!

WebView2.ICoreWebView2FrameDOMContentLoadedEventHandler comment: '`ICoreWebView2FrameDOMContentLoadedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2FrameDOMContentLoadedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(38d9520d-340f-4d1e-a775-43fce9753683)
]
interface ICoreWebView2FrameDOMContentLoadedEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2Frame* sender,
		[in]ICoreWebView2DOMContentLoadedEventArgs* args);
};
```
'!

!WebView2.ICoreWebView2FrameDOMContentLoadedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2FrameDOMContentLoadedEventHandler methodsFor!

basicRegister: tokenBuffer with: anICoreWebView2Frame2
	anICoreWebView2Frame2 Add_DOMContentLoaded: self token: tokenBuffer!

basicUnregister: anInteger from: anICoreWebView2Frame2
	anICoreWebView2Frame2 Remove_DOMContentLoaded: anInteger!

Invoke: sender args: args
	"Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			[in]ICoreWebView2Frame* sender,
			[in]ICoreWebView2DOMContentLoadedEventArgs* args);"

	<virtual stdcall: hresult 4 ICoreWebView2Frame* ICoreWebView2DOMContentLoadedEventArgs*>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2FrameDOMContentLoadedEventHandler categoriesForMethods!
basicRegister:with:!private!realizing/unrealizing! !
basicUnregister:from:!private!realizing/unrealizing! !
Invoke:args:!**auto generated**!COM Interfaces-ICoreWebView2FrameDOMContentLoadedEventHandler!public! !
!

!WebView2.ICoreWebView2FrameDOMContentLoadedEventHandler class methodsFor!

argsClass
	^ICoreWebView2DOMContentLoadedEventArgs!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2FrameDOMContentLoadedEventHandler'
		ICoreWebView2FrameDOMContentLoadedEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2Frame* ICoreWebView2DOMContentLoadedEventArgs*'
!

eventName
	"Answer the symbolic name for this event (i.e. the SASE event trigger name)"

	^#frame:domContentLoaded:! !

!WebView2.ICoreWebView2FrameDOMContentLoadedEventHandler class categoriesForMethods!
argsClass!constants!public! !
defineFunctions!**auto generated**!initializing!public!template definition! !
eventName!constants!public! !
!

