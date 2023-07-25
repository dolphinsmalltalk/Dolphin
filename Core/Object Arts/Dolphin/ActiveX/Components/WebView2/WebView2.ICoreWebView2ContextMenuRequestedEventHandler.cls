"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2EventHandler
	subclass: #'WebView2.ICoreWebView2ContextMenuRequestedEventHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2ContextMenuRequestedEventHandler guid: (OS.COM.IID fromString: '{04d3fe1d-ab87-42fb-a898-da241d35b63c}')!
WebView2.ICoreWebView2ContextMenuRequestedEventHandler comment: '`ICoreWebView2ContextMenuRequestedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2ContextMenuRequestedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(04d3fe1d-ab87-42fb-a898-da241d35b63c)
]
interface ICoreWebView2ContextMenuRequestedEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2* sender,
		[in]ICoreWebView2ContextMenuRequestedEventArgs* args);
};
```
'!
!WebView2.ICoreWebView2ContextMenuRequestedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2ContextMenuRequestedEventHandler methodsFor!

basicRegister: tokenBuffer
	source Add_ContextMenuRequested: self token: tokenBuffer!

basicUnregister
	source Remove_ContextMenuRequested: token! !
!WebView2.ICoreWebView2ContextMenuRequestedEventHandler categoriesForMethods!
basicRegister:!private!realizing/unrealizing! !
basicUnregister!private!realizing/unrealizing! !
!

!WebView2.ICoreWebView2ContextMenuRequestedEventHandler class methodsFor!

argsClass
	^ICoreWebView2ContextMenuRequestedEventArgs!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2ContextMenuRequestedEventHandler'
		ICoreWebView2ContextMenuRequestedEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2* ICoreWebView2ContextMenuRequestedEventArgs*'
!

eventName
	"Answer the symbolic name for this event (i.e. the SASE event trigger name)"

	^#contextMenuRequested:! !
!WebView2.ICoreWebView2ContextMenuRequestedEventHandler class categoriesForMethods!
argsClass!constants!public! !
defineFunctions!**auto generated**!initializing!public!template definition! !
eventName!constants!public! !
!

