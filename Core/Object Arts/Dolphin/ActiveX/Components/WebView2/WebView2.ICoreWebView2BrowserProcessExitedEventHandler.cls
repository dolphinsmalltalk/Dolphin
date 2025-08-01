﻿"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2EnvironmentEventHandler
	subclass: #'WebView2.ICoreWebView2BrowserProcessExitedEventHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2BrowserProcessExitedEventHandler guid: (OS.COM.IID fromString: '{fa504257-a216-4911-a860-fe8825712861}')!

WebView2.ICoreWebView2BrowserProcessExitedEventHandler comment: '`ICoreWebView2BrowserProcessExitedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2BrowserProcessExitedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(fa504257-a216-4911-a860-fe8825712861)
]
interface ICoreWebView2BrowserProcessExitedEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2Environment* sender,
		[in]ICoreWebView2BrowserProcessExitedEventArgs* args);
};
```
'!

!WebView2.ICoreWebView2BrowserProcessExitedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2BrowserProcessExitedEventHandler methodsFor!

basicRegister: tokenBuffer with: anICoreWebView2Environment5
	anICoreWebView2Environment5 Add_BrowserProcessExited: self token: tokenBuffer!

basicUnregister: anInteger from: anICoreWebView2Environment5
	anICoreWebView2Environment5 Remove_BrowserProcessExited: anInteger!

Invoke: sender args: args
	"Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			[in]ICoreWebView2Environment* sender,
			[in]ICoreWebView2BrowserProcessExitedEventArgs* args);"

	<virtual stdcall: hresult 4 ICoreWebView2Environment* ICoreWebView2BrowserProcessExitedEventArgs*>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2BrowserProcessExitedEventHandler categoriesForMethods!
basicRegister:with:!private!realizing/unrealizing! !
basicUnregister:from:!private!realizing/unrealizing! !
Invoke:args:!**auto generated**!COM Interfaces-ICoreWebView2BrowserProcessExitedEventHandler!public! !
!

!WebView2.ICoreWebView2BrowserProcessExitedEventHandler class methodsFor!

argsClass
	^ICoreWebView2BrowserProcessExitedEventArgs!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2BrowserProcessExitedEventHandler'
		ICoreWebView2BrowserProcessExitedEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2Environment* ICoreWebView2BrowserProcessExitedEventArgs*'
!

eventName
	"Answer the symbolic name for this event (i.e. the SASE event trigger name)"

	^#processExited:! !

!WebView2.ICoreWebView2BrowserProcessExitedEventHandler class categoriesForMethods!
argsClass!constants!public! !
defineFunctions!**auto generated**!initializing!public!template definition! !
eventName!constants!public! !
!

