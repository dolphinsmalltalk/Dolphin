"Filed out from Dolphin Smalltalk"!

ICoreWebView2EventHandler subclass: #ICoreWebView2MoveFocusRequestedEventHandler
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ICoreWebView2MoveFocusRequestedEventHandler guid: (IID fromString: '{69035451-6dc7-4cb8-9bce-b2bd70ad289f}')!
ICoreWebView2MoveFocusRequestedEventHandler comment: '`ICoreWebView2MoveFocusRequestedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2MoveFocusRequestedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(69035451-6dc7-4cb8-9bce-b2bd70ad289f)
]
interface ICoreWebView2MoveFocusRequestedEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2Controller* sender,
		[in]ICoreWebView2MoveFocusRequestedEventArgs* args);
};
```
'!
!ICoreWebView2MoveFocusRequestedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2MoveFocusRequestedEventHandler methodsFor!

basicRegister: tokenBuffer
	source Add_MoveFocusRequested: self token: tokenBuffer!

basicUnregister
	source Remove_MoveFocusRequested: token! !
!ICoreWebView2MoveFocusRequestedEventHandler categoriesForMethods!
basicRegister:!private!realizing/unrealizing! !
basicUnregister!private!realizing/unrealizing! !
!

!ICoreWebView2MoveFocusRequestedEventHandler class methodsFor!

argsClass
	^ICoreWebView2MoveFocusRequestedEventArgs!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2MoveFocusRequestedEventHandler'
		ICoreWebView2MoveFocusRequestedEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2Controller* ICoreWebView2MoveFocusRequestedEventArgs*'
!

eventName
	"Answer the symbolic name for this event (i.e. the SASE event trigger name)"

	^#moveFocusRequested:! !
!ICoreWebView2MoveFocusRequestedEventHandler class categoriesForMethods!
argsClass!constants!public! !
defineFunctions!**auto generated**!initializing!public! !
eventName!constants!public! !
!

