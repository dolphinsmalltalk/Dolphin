"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2EventHandler
	subclass: #'WebView2.ICoreWebView2HistoryChangedEventHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2HistoryChangedEventHandler guid: (OS.COM.IID fromString: '{c79a420c-efd9-4058-9295-3e8b4bcab645}')!
WebView2.ICoreWebView2HistoryChangedEventHandler comment: '`ICoreWebView2HistoryChangedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2HistoryChangedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(c79a420c-efd9-4058-9295-3e8b4bcab645)
]
interface ICoreWebView2HistoryChangedEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2* sender,
		[in]IUnknown* args);
};
```
'!
!WebView2.ICoreWebView2HistoryChangedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2HistoryChangedEventHandler methodsFor!

basicRegister: tokenBuffer
	source Add_HistoryChanged: self token: tokenBuffer!

basicUnregister
	source Remove_HistoryChanged: token! !
!WebView2.ICoreWebView2HistoryChangedEventHandler categoriesForMethods!
basicRegister:!private!realizing/unrealizing! !
basicUnregister!private!realizing/unrealizing! !
!

!WebView2.ICoreWebView2HistoryChangedEventHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2HistoryChangedEventHandler'
		ICoreWebView2HistoryChangedEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2* IUnknown*'
!

eventName
	"Answer the symbolic name for this event (i.e. the SASE event trigger name)"

	^#historyChanged! !
!WebView2.ICoreWebView2HistoryChangedEventHandler class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
eventName!constants!public! !
!

