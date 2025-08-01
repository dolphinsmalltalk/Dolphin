﻿"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2ViewEventHandler
	subclass: #'WebView2.ICoreWebView2WebResourceResponseReceivedEventHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2WebResourceResponseReceivedEventHandler guid: (OS.COM.IID fromString: '{7de9898a-24f5-40c3-a2de-d4f458e69828}')!

WebView2.ICoreWebView2WebResourceResponseReceivedEventHandler comment: '`ICoreWebView2WebResourceResponseReceivedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2WebResourceResponseReceivedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(7de9898a-24f5-40c3-a2de-d4f458e69828)
]
interface ICoreWebView2WebResourceResponseReceivedEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2* sender,
		[in]ICoreWebView2WebResourceResponseReceivedEventArgs* args);
};
```
'!

!WebView2.ICoreWebView2WebResourceResponseReceivedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2WebResourceResponseReceivedEventHandler methodsFor!

basicRegister: tokenBuffer with: anICoreWebView2_2
	anICoreWebView2_2 Add_WebResourceResponseReceived: self token: tokenBuffer!

basicUnregister: anInteger from: anICoreWebView2_2
	anICoreWebView2_2 Remove_WebResourceResponseReceived: anInteger!

Invoke: sender args: args
	"Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			[in]ICoreWebView2* sender,
			[in]ICoreWebView2WebResourceResponseReceivedEventArgs* args);"

	<virtual stdcall: hresult 4 ICoreWebView2* ICoreWebView2WebResourceResponseReceivedEventArgs*>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2WebResourceResponseReceivedEventHandler categoriesForMethods!
basicRegister:with:!private!realizing/unrealizing! !
basicUnregister:from:!private!realizing/unrealizing! !
Invoke:args:!**auto generated**!COM Interfaces-ICoreWebView2WebResourceResponseReceivedEventHandler!public! !
!

!WebView2.ICoreWebView2WebResourceResponseReceivedEventHandler class methodsFor!

argsClass
	^ICoreWebView2WebResourceResponseReceivedEventArgs!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2WebResourceResponseReceivedEventHandler'
		ICoreWebView2WebResourceResponseReceivedEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2* ICoreWebView2WebResourceResponseReceivedEventArgs*'
!

eventName
	"Answer the symbolic name for this event (i.e. the SASE event trigger name)"

	^#webResourceResponseReceived:! !

!WebView2.ICoreWebView2WebResourceResponseReceivedEventHandler class categoriesForMethods!
argsClass!constants!public! !
defineFunctions!**auto generated**!initializing!public!template definition! !
eventName!constants!public! !
!

