﻿"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2ViewEventHandler
	subclass: #'WebView2.ICoreWebView2IsDefaultDownloadDialogOpenChangedEventHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2IsDefaultDownloadDialogOpenChangedEventHandler guid: (OS.COM.IID fromString: '{3117da26-ae13-438d-bd46-edbeb2c4ce81}')!

WebView2.ICoreWebView2IsDefaultDownloadDialogOpenChangedEventHandler comment: '`ICoreWebView2IsDefaultDownloadDialogOpenChangedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2IsDefaultDownloadDialogOpenChangedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(3117da26-ae13-438d-bd46-edbeb2c4ce81)
]
interface ICoreWebView2IsDefaultDownloadDialogOpenChangedEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2* sender,
		[in]IUnknown* args);
};
```
'!

!WebView2.ICoreWebView2IsDefaultDownloadDialogOpenChangedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2IsDefaultDownloadDialogOpenChangedEventHandler methodsFor!

basicRegister: tokenBuffer with: anICoreWebView2_9
	anICoreWebView2_9 Add_IsDefaultDownloadDialogOpenChanged: self token: tokenBuffer!

basicUnregister: anInteger from: anICoreWebView2_9
	anICoreWebView2_9 Remove_IsDefaultDownloadDialogOpenChanged: anInteger! !

!WebView2.ICoreWebView2IsDefaultDownloadDialogOpenChangedEventHandler categoriesForMethods!
basicRegister:with:!private!realizing/unrealizing! !
basicUnregister:from:!private!realizing/unrealizing! !
!

!WebView2.ICoreWebView2IsDefaultDownloadDialogOpenChangedEventHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2IsDefaultDownloadDialogOpenChangedEventHandler'
		ICoreWebView2IsDefaultDownloadDialogOpenChangedEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2* IUnknown*'
!

eventName
	"Answer the symbolic name for this event (i.e. the SASE event trigger name)"

	^#isDefaultDownloadDialogOpenChanged! !

!WebView2.ICoreWebView2IsDefaultDownloadDialogOpenChangedEventHandler class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
eventName!constants!public! !
!

