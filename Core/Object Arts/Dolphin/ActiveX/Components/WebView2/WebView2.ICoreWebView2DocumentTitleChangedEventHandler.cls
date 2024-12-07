"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2EventHandler
	subclass: #'WebView2.ICoreWebView2DocumentTitleChangedEventHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2DocumentTitleChangedEventHandler guid: (OS.COM.IID fromString: '{f5f2b923-953e-4042-9f95-f3a118e1afd4}')!

WebView2.ICoreWebView2DocumentTitleChangedEventHandler comment: '`ICoreWebView2DocumentTitleChangedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2DocumentTitleChangedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(f5f2b923-953e-4042-9f95-f3a118e1afd4)
]
interface ICoreWebView2DocumentTitleChangedEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2* sender,
		[in]IUnknown* args);
};
```
'!

!WebView2.ICoreWebView2DocumentTitleChangedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2DocumentTitleChangedEventHandler methodsFor!

basicRegister: tokenBuffer with: anICoreWebView2Interface
	anICoreWebView2Interface Add_DocumentTitleChanged: self token: tokenBuffer!

basicUnregister: anInteger from: anICoreWebView2Interface
	anICoreWebView2Interface Remove_DocumentTitleChanged: anInteger!

Invoke: sender args: args
	"Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			[in]ICoreWebView2* sender,
			[in]IUnknown* args);"

	<virtual stdcall: hresult 4 ICoreWebView2* IUnknown*>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2DocumentTitleChangedEventHandler categoriesForMethods!
basicRegister:with:!private!realizing/unrealizing! !
basicUnregister:from:!private!realizing/unrealizing! !
Invoke:args:!**auto generated**!COM Interfaces-ICoreWebView2DocumentTitleChangedEventHandler!public! !
!

!WebView2.ICoreWebView2DocumentTitleChangedEventHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2DocumentTitleChangedEventHandler'
		ICoreWebView2DocumentTitleChangedEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2* IUnknown*'
!

eventName
	"Answer the symbolic name for this event (i.e. the SASE event trigger name)"

	^#documentTitleChanged! !

!WebView2.ICoreWebView2DocumentTitleChangedEventHandler class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
eventName!constants!public! !
!

