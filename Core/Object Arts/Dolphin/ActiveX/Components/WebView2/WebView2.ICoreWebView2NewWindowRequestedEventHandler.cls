"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2EventHandler
	subclass: #'WebView2.ICoreWebView2NewWindowRequestedEventHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2NewWindowRequestedEventHandler guid: (OS.COM.IID fromString: '{d4c185fe-c81c-4989-97af-2d3fa7ab5651}')!
WebView2.ICoreWebView2NewWindowRequestedEventHandler comment: '`ICoreWebView2NewWindowRequestedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2NewWindowRequestedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(d4c185fe-c81c-4989-97af-2d3fa7ab5651)
]
interface ICoreWebView2NewWindowRequestedEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2* sender,
		[in]ICoreWebView2NewWindowRequestedEventArgs* args);
};
```
'!
!WebView2.ICoreWebView2NewWindowRequestedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2NewWindowRequestedEventHandler methodsFor!

basicRegister: tokenBuffer
	source Add_NewWindowRequested: self token: tokenBuffer!

basicUnregister
	source Remove_NewWindowRequested: token! !
!WebView2.ICoreWebView2NewWindowRequestedEventHandler categoriesForMethods!
basicRegister:!private!realizing/unrealizing! !
basicUnregister!private!realizing/unrealizing! !
!

!WebView2.ICoreWebView2NewWindowRequestedEventHandler class methodsFor!

argsClass
	^ICoreWebView2NewWindowRequestedEventArgs2!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2NewWindowRequestedEventHandler'
		ICoreWebView2NewWindowRequestedEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2* ICoreWebView2NewWindowRequestedEventArgs*'
!

eventName
	"Answer the symbolic name for this event (i.e. the SASE event trigger name)"

	^#newWindowRequested:! !
!WebView2.ICoreWebView2NewWindowRequestedEventHandler class categoriesForMethods!
argsClass!constants!public! !
defineFunctions!**auto generated**!initializing!public!template definition! !
eventName!constants!public! !
!

