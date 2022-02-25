"Filed out from Dolphin Smalltalk"!

ICoreWebView2EventHandler subclass: #ICoreWebView2ContainsFullScreenElementChangedEventHandler
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
ICoreWebView2ContainsFullScreenElementChangedEventHandler guid: (OS.COM.IID fromString: '{e45d98b1-afef-45be-8baf-6c7728867f73}')!
ICoreWebView2ContainsFullScreenElementChangedEventHandler comment: '`ICoreWebView2ContainsFullScreenElementChangedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2ContainsFullScreenElementChangedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(e45d98b1-afef-45be-8baf-6c7728867f73)
]
interface ICoreWebView2ContainsFullScreenElementChangedEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2* sender,
		[in]IUnknown* args);
};
```
'!
!ICoreWebView2ContainsFullScreenElementChangedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2ContainsFullScreenElementChangedEventHandler methodsFor!

basicRegister: tokenBuffer
	source Add_ContainsFullScreenElementChanged: self token: tokenBuffer!

basicUnregister
	source Remove_ContainsFullScreenElementChanged: token! !
!ICoreWebView2ContainsFullScreenElementChangedEventHandler categoriesForMethods!
basicRegister:!private!realizing/unrealizing! !
basicUnregister!private!realizing/unrealizing! !
!

!ICoreWebView2ContainsFullScreenElementChangedEventHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2ContainsFullScreenElementChangedEventHandler'
		ICoreWebView2ContainsFullScreenElementChangedEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2* IUnknown*'
!

eventName
	"Answer the symbolic name for this event (i.e. the SASE event trigger name)"

	^#containsFullScreenElementChanged! !
!ICoreWebView2ContainsFullScreenElementChangedEventHandler class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
eventName!constants!public! !
!

