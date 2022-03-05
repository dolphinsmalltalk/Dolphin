"Filed out from Dolphin Smalltalk"!

ICoreWebView2EventHandler subclass: #ICoreWebView2SourceChangedEventHandler
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ICoreWebView2SourceChangedEventHandler guid: (IID fromString: '{3c067f9f-5388-4772-8b48-79f7ef1ab37c}')!
ICoreWebView2SourceChangedEventHandler comment: '`ICoreWebView2SourceChangedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2SourceChangedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(3c067f9f-5388-4772-8b48-79f7ef1ab37c)
]
interface ICoreWebView2SourceChangedEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2* sender,
		[in]ICoreWebView2SourceChangedEventArgs* args);
};
```
'!
!ICoreWebView2SourceChangedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2SourceChangedEventHandler methodsFor!

basicRegister: tokenBuffer
	source Add_SourceChanged: self token: tokenBuffer!

basicUnregister
	source Remove_SourceChanged: token! !
!ICoreWebView2SourceChangedEventHandler categoriesForMethods!
basicRegister:!private!realizing/unrealizing! !
basicUnregister!private!realizing/unrealizing! !
!

!ICoreWebView2SourceChangedEventHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2SourceChangedEventHandler'
		ICoreWebView2SourceChangedEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2* ICoreWebView2SourceChangedEventArgs*'
!

eventName
	"Answer the symbolic name for this event (i.e. the SASE event trigger name)"

	^#sourceChanged:! !
!ICoreWebView2SourceChangedEventHandler class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
eventName!constants!public! !
!

