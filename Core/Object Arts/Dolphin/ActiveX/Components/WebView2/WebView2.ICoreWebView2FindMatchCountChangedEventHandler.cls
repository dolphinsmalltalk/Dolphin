"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2FindEventHandler
	subclass: #'WebView2.ICoreWebView2FindMatchCountChangedEventHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2FindMatchCountChangedEventHandler guid: (OS.COM.IID fromString: '{da0d6827-4254-5b10-a6d9-412076afc9f3}')!

WebView2.ICoreWebView2FindMatchCountChangedEventHandler comment: '`ICoreWebView2FindMatchCountChangedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2FindMatchCountChangedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(da0d6827-4254-5b10-a6d9-412076afc9f3)
]
interface ICoreWebView2FindMatchCountChangedEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2Find* sender,
		[in]IUnknown* args);
};
```
'!

!WebView2.ICoreWebView2FindMatchCountChangedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2FindMatchCountChangedEventHandler methodsFor!

basicRegister: tokenBuffer with: anICoreWebView2Find
	anICoreWebView2Find Add_MatchCountChanged: self token: tokenBuffer!

basicUnregister: anInteger from: anICoreWebView2Find
	anICoreWebView2Find Remove_MatchCountChanged: anInteger! !

!WebView2.ICoreWebView2FindMatchCountChangedEventHandler categoriesForMethods!
basicRegister:with:!private!realizing/unrealizing! !
basicUnregister:from:!private!realizing/unrealizing! !
!

!WebView2.ICoreWebView2FindMatchCountChangedEventHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2FindMatchCountChangedEventHandler'
		ICoreWebView2FindMatchCountChangedEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2Find* IUnknown*'
!

eventName
	"Answer the symbolic name for this event (i.e. the SASE event trigger name)"

	^#findMatchCountChanged:! !

!WebView2.ICoreWebView2FindMatchCountChangedEventHandler class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
eventName!constants!public! !
!

