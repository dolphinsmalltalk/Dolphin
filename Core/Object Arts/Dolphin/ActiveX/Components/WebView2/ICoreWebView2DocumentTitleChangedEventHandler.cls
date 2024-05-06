"Filed out from Dolphin Smalltalk"!

ICoreWebView2EventHandler subclass: #ICoreWebView2DocumentTitleChangedEventHandler
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ICoreWebView2DocumentTitleChangedEventHandler guid: (IID fromString: '{f5f2b923-953e-4042-9f95-f3a118e1afd4}')!

ICoreWebView2DocumentTitleChangedEventHandler comment: '`ICoreWebView2DocumentTitleChangedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2DocumentTitleChangedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

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

!ICoreWebView2DocumentTitleChangedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!ICoreWebView2DocumentTitleChangedEventHandler methodsFor!

basicRegister: tokenBuffer
	source Add_DocumentTitleChanged: self token: tokenBuffer!

basicUnregister
	source Remove_DocumentTitleChanged: token! !

!ICoreWebView2DocumentTitleChangedEventHandler categoriesForMethods!
basicRegister:!private!realizing/unrealizing! !
basicUnregister!private!realizing/unrealizing! !
!

!ICoreWebView2DocumentTitleChangedEventHandler class methodsFor!

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

!ICoreWebView2DocumentTitleChangedEventHandler class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
eventName!constants!public! !
!

