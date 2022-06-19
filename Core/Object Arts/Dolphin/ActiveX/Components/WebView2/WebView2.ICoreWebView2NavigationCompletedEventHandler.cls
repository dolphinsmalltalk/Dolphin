"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2EventHandler subclass: #'WebView2.ICoreWebView2NavigationCompletedEventHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2NavigationCompletedEventHandler guid: (OS.COM.IID fromString: '{d33a35bf-1c49-4f98-93ab-006e0533fe1c}')!
WebView2.ICoreWebView2NavigationCompletedEventHandler comment: '`ICoreWebView2NavigationCompletedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2NavigationCompletedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(d33a35bf-1c49-4f98-93ab-006e0533fe1c)
]
interface ICoreWebView2NavigationCompletedEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2* sender,
		[in]ICoreWebView2NavigationCompletedEventArgs* args);
};
```
'!
!WebView2.ICoreWebView2NavigationCompletedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2NavigationCompletedEventHandler methodsFor!

basicRegister: tokenBuffer
	source Add_NavigationCompleted: self token: tokenBuffer!

basicUnregister
	source Remove_NavigationCompleted: token! !
!WebView2.ICoreWebView2NavigationCompletedEventHandler categoriesForMethods!
basicRegister:!private!realizing/unrealizing! !
basicUnregister!private!realizing/unrealizing! !
!

!WebView2.ICoreWebView2NavigationCompletedEventHandler class methodsFor!

argsClass
	^ICoreWebView2NavigationCompletedEventArgs2!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2NavigationCompletedEventHandler'
		ICoreWebView2NavigationCompletedEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2* ICoreWebView2NavigationCompletedEventArgs*'
!

eventName
	"Answer the symbolic name for this event (i.e. the SASE event trigger name)"

	^#navigationCompleted:! !
!WebView2.ICoreWebView2NavigationCompletedEventHandler class categoriesForMethods!
argsClass!constants!public! !
defineFunctions!**auto generated**!initializing!public! !
eventName!constants!public! !
!

