"Filed out from Dolphin Smalltalk"!

ICoreWebView2EventHandler subclass: #ICoreWebView2BrowserProcessExitedEventHandler
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ICoreWebView2BrowserProcessExitedEventHandler guid: (IID fromString: '{fa504257-a216-4911-a860-fe8825712861}')!
ICoreWebView2BrowserProcessExitedEventHandler comment: '`ICoreWebView2BrowserProcessExitedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2BrowserProcessExitedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

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
!ICoreWebView2BrowserProcessExitedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2BrowserProcessExitedEventHandler methodsFor!

basicRegister: tokenBuffer
	source Add_BrowserProcessExited: self token: tokenBuffer!

basicUnregister
	source Remove_BrowserProcessExited: token! !
!ICoreWebView2BrowserProcessExitedEventHandler categoriesForMethods!
basicRegister:!private!realizing/unrealizing! !
basicUnregister!private!realizing/unrealizing! !
!

!ICoreWebView2BrowserProcessExitedEventHandler class methodsFor!

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
!ICoreWebView2BrowserProcessExitedEventHandler class categoriesForMethods!
argsClass!constants!public! !
defineFunctions!**auto generated**!initializing!public! !
eventName!constants!public! !
!

