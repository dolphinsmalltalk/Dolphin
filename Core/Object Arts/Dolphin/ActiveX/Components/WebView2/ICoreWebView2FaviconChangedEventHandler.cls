"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2EventHandler subclass: #ICoreWebView2FaviconChangedEventHandler
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ICoreWebView2FaviconChangedEventHandler guid: (IID fromString: '{2913da94-833d-4de0-8dca-900fc524a1a4}')!
ICoreWebView2FaviconChangedEventHandler comment: '`ICoreWebView2FaviconChangedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2FaviconChangedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(2913da94-833d-4de0-8dca-900fc524a1a4)
]
interface ICoreWebView2FaviconChangedEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2* sender,
		[in]IUnknown* args);
};
```
'!
!ICoreWebView2FaviconChangedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2FaviconChangedEventHandler methodsFor!

basicRegister: tokenBuffer
	source Add_FaviconChanged: self token: tokenBuffer!

basicUnregister
	source Remove_FaviconChanged: token! !
!ICoreWebView2FaviconChangedEventHandler categoriesForMethods!
basicRegister:!private!realizing/unrealizing! !
basicUnregister!private!realizing/unrealizing! !
!

!ICoreWebView2FaviconChangedEventHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2FaviconChangedEventHandler'
		ICoreWebView2FaviconChangedEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'WebView2.ICoreWebView2* IUnknown*'
!

eventName
	"Answer the symbolic name for this event (i.e. the SASE event trigger name)"

	^#favIconChanged! !
!ICoreWebView2FaviconChangedEventHandler class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
eventName!constants!public! !
!

