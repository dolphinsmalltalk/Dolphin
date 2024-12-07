"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2EventHandler
	subclass: #'WebView2.ICoreWebView2NewBrowserVersionAvailableEventHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2NewBrowserVersionAvailableEventHandler guid: (OS.COM.IID fromString: '{f9a2976e-d34e-44fc-adee-81b6b57ca914}')!

WebView2.ICoreWebView2NewBrowserVersionAvailableEventHandler comment: '`ICoreWebView2NewBrowserVersionAvailableEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2NewBrowserVersionAvailableEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(f9a2976e-d34e-44fc-adee-81b6b57ca914)
]
interface ICoreWebView2NewBrowserVersionAvailableEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2Environment* sender,
		[in]IUnknown* args);
};
```
'!

!WebView2.ICoreWebView2NewBrowserVersionAvailableEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2NewBrowserVersionAvailableEventHandler methodsFor!

basicRegister: tokenBuffer with: anICoreWebView2Interface
	anICoreWebView2Interface Add_NewBrowserVersionAvailable: self token: tokenBuffer!

basicUnregister: anInteger from: anICoreWebView2Interface
	anICoreWebView2Interface Remove_NewBrowserVersionAvailable: anInteger!

Invoke: sender args: args
	"Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			[in]ICoreWebView2Environment* sender,
			[in]IUnknown* args);"

	<virtual stdcall: hresult 4 ICoreWebView2Environment* IUnknown*>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2NewBrowserVersionAvailableEventHandler categoriesForMethods!
basicRegister:with:!private!realizing/unrealizing! !
basicUnregister:from:!private!realizing/unrealizing! !
Invoke:args:!**auto generated**!COM Interfaces-ICoreWebView2NewBrowserVersionAvailableEventHandler!public! !
!

!WebView2.ICoreWebView2NewBrowserVersionAvailableEventHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2NewBrowserVersionAvailableEventHandler'
		ICoreWebView2NewBrowserVersionAvailableEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2Environment* IUnknown*'
!

eventName
	"Answer the symbolic name for this event (i.e. the SASE event trigger name)"

	^#newBrowserVersionAvailable! !

!WebView2.ICoreWebView2NewBrowserVersionAvailableEventHandler class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
eventName!constants!public! !
!

