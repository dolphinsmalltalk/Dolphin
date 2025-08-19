"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2FindEventHandler
	subclass: #'WebView2.ICoreWebView2FindActiveMatchIndexChangedEventHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2FindActiveMatchIndexChangedEventHandler guid: (OS.COM.IID fromString: '{0054f514-9a8e-5876-aed5-30b37f8c86a5}')!

WebView2.ICoreWebView2FindActiveMatchIndexChangedEventHandler comment: '`ICoreWebView2FindActiveMatchIndexChangedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2FindActiveMatchIndexChangedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(0054f514-9a8e-5876-aed5-30b37f8c86a5)
]
interface ICoreWebView2FindActiveMatchIndexChangedEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2Find* sender,
		[in]IUnknown* args);
};
```
'!

!WebView2.ICoreWebView2FindActiveMatchIndexChangedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2FindActiveMatchIndexChangedEventHandler methodsFor!

basicRegister: tokenBuffer with: anICoreWebView2Find
	anICoreWebView2Find Add_ActiveMatchIndexChanged: self token: tokenBuffer!

basicUnregister: anInteger from: anICoreWebView2Find
	anICoreWebView2Find Remove_ActiveMatchIndexChanged: anInteger! !

!WebView2.ICoreWebView2FindActiveMatchIndexChangedEventHandler categoriesForMethods!
basicRegister:with:!private!realizing/unrealizing! !
basicUnregister:from:!private!realizing/unrealizing! !
!

!WebView2.ICoreWebView2FindActiveMatchIndexChangedEventHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2FindActiveMatchIndexChangedEventHandler'
		ICoreWebView2FindActiveMatchIndexChangedEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2Find* IUnknown*'
!

eventName
	"Answer the symbolic name for this event (i.e. the SASE event trigger name)"

	^#findActiveMatchIndexChanged:! !

!WebView2.ICoreWebView2FindActiveMatchIndexChangedEventHandler class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
eventName!constants!public! !
!

