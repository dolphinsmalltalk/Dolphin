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

basicRegister: tokenBuffer with: anICoreWebView2Interface
	anICoreWebView2Interface Add_CursorChanged: self token: tokenBuffer!

basicUnregister: anInteger from: anICoreWebView2Interface
	anICoreWebView2Interface Remove_CursorChanged: anInteger!

Invoke: sender args: args
	"Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			[in]ICoreWebView2CompositionController* sender,
			[in]IUnknown* args);"

	<virtual stdcall: hresult 4 ICoreWebView2CompositionController* IUnknown*>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2CursorChangedEventHandler categoriesForMethods!
basicRegister:with:!private!realizing/unrealizing! !
basicUnregister:from:!private!realizing/unrealizing! !
Invoke:args:!**auto generated**!COM Interfaces-ICoreWebView2CursorChangedEventHandler!public! !
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
defineFunctions!initializing!public!template definition! !
eventName!constants!public! !
!

