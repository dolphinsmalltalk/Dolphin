﻿"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2ViewEventHandler
	subclass: #'WebView2.ICoreWebView2FaviconChangedEventHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2FaviconChangedEventHandler guid: (OS.COM.IID fromString: '{2913da94-833d-4de0-8dca-900fc524a1a4}')!

WebView2.ICoreWebView2FaviconChangedEventHandler comment: '`ICoreWebView2FaviconChangedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2FaviconChangedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(2913da94-833d-4de0-8dca-900fc524a1a4)
]
interface ICoreWebView2FaviconChangedEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2* sender,
		[in]IUnknown* args);
};
```
'!

!WebView2.ICoreWebView2FaviconChangedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2FaviconChangedEventHandler methodsFor!

basicRegister: tokenBuffer with: anICoreWebView2_15
	anICoreWebView2_15 Add_FaviconChanged: self token: tokenBuffer!

basicUnregister: anInteger from: anICoreWebView2_15
	anICoreWebView2_15 Remove_FaviconChanged: anInteger! !

!WebView2.ICoreWebView2FaviconChangedEventHandler categoriesForMethods!
basicRegister:with:!private!realizing/unrealizing! !
basicUnregister:from:!private!realizing/unrealizing! !
!

!WebView2.ICoreWebView2FaviconChangedEventHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2FaviconChangedEventHandler'
		ICoreWebView2FaviconChangedEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2* IUnknown*'
!

eventName
	"Answer the symbolic name for this event (i.e. the SASE event trigger name)"

	^#favIconChanged! !

!WebView2.ICoreWebView2FaviconChangedEventHandler class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
eventName!constants!public! !
!

