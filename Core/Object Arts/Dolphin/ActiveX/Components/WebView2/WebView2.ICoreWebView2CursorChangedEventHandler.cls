"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2EventHandler
	subclass: #'WebView2.ICoreWebView2CursorChangedEventHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2CursorChangedEventHandler guid: (OS.COM.IID fromString: '{9da43ccc-26e1-4dad-b56c-d8961c94c571}')!
WebView2.ICoreWebView2CursorChangedEventHandler comment: '`ICoreWebView2CursorChangedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2CursorChangedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(9da43ccc-26e1-4dad-b56c-d8961c94c571)
]
interface ICoreWebView2CursorChangedEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2CompositionController* sender,
		[in]IUnknown* args);
};
```
'!
!WebView2.ICoreWebView2CursorChangedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2CursorChangedEventHandler methodsFor!

basicRegister: tokenBuffer
	source Add_CursorChanged: self token: tokenBuffer!

basicUnregister
	source Remove_CursorChanged: token! !
!WebView2.ICoreWebView2CursorChangedEventHandler categoriesForMethods!
basicRegister:!private!realizing/unrealizing! !
basicUnregister!private!realizing/unrealizing! !
!

!WebView2.ICoreWebView2CursorChangedEventHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2CursorChangedEventHandler'
		ICoreWebView2CursorChangedEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2CompositionController* IUnknown*'
!

eventName
	"Answer the symbolic name for this event (i.e. the SASE event trigger name)"

	^#cursorChanged! !
!WebView2.ICoreWebView2CursorChangedEventHandler class categoriesForMethods!
defineFunctions!initializing!public! !
eventName!constants!public! !
!

