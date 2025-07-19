"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2ViewEventHandler
	subclass: #'WebView2.ICoreWebView2StatusBarTextChangedEventHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2StatusBarTextChangedEventHandler guid: (OS.COM.IID fromString: '{a5e3b0d0-10df-4156-bfad-3b43867acac6}')!

WebView2.ICoreWebView2StatusBarTextChangedEventHandler comment: '`ICoreWebView2StatusBarTextChangedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2StatusBarTextChangedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(a5e3b0d0-10df-4156-bfad-3b43867acac6)
]
interface ICoreWebView2StatusBarTextChangedEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2* sender,
		[in]IUnknown* args);
};
```
'!

!WebView2.ICoreWebView2StatusBarTextChangedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2StatusBarTextChangedEventHandler methodsFor!

basicRegister: tokenBuffer with: anICoreWebView2_12
	anICoreWebView2_12 Add_StatusBarTextChanged: self token: tokenBuffer!

basicUnregister: anInteger from: anICoreWebView2_12
	anICoreWebView2_12 Remove_StatusBarTextChanged: anInteger! !

!WebView2.ICoreWebView2StatusBarTextChangedEventHandler categoriesForMethods!
basicRegister:with:!private!realizing/unrealizing! !
basicUnregister:from:!private!realizing/unrealizing! !
!

!WebView2.ICoreWebView2StatusBarTextChangedEventHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2StatusBarTextChangedEventHandler'
		ICoreWebView2StatusBarTextChangedEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2* IUnknown*'
!

eventName
	"Answer the symbolic name for this event (i.e. the SASE event trigger name)"

	^#statusBarTextChanged! !

!WebView2.ICoreWebView2StatusBarTextChangedEventHandler class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
eventName!constants!public! !
!

