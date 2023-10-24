﻿"Filed out from Dolphin Smalltalk"!

ICoreWebView2EventHandler subclass: #ICoreWebView2StateChangedEventHandler
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ICoreWebView2StateChangedEventHandler guid: (IID fromString: '{81336594-7ede-4ba9-bf71-acf0a95b58dd}')!
ICoreWebView2StateChangedEventHandler comment: '`ICoreWebView2StateChangedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2StateChangedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(81336594-7ede-4ba9-bf71-acf0a95b58dd)
]
interface ICoreWebView2StateChangedEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2DownloadOperation* sender,
		[in]IUnknown* args);
};
```
'!
!ICoreWebView2StateChangedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2StateChangedEventHandler methodsFor!

basicRegister: tokenBuffer
	source Add_StateChanged: self token: tokenBuffer!

basicUnregister
	source Remove_StateChanged: token! !
!ICoreWebView2StateChangedEventHandler categoriesForMethods!
basicRegister:!private!realizing/unrealizing! !
basicUnregister!private!realizing/unrealizing! !
!

!ICoreWebView2StateChangedEventHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2StateChangedEventHandler'
		ICoreWebView2StateChangedEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2DownloadOperation* IUnknown*'
!

eventName
	"Answer the symbolic name for this event (i.e. the SASE event trigger name)"

	^#dowloadStateChanged! !
!ICoreWebView2StateChangedEventHandler class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
eventName!constants!public! !
!
