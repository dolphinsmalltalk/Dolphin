"Filed out from Dolphin Smalltalk"!

ICoreWebView2EventHandler subclass: #ICoreWebView2DownloadStartingEventHandler
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ICoreWebView2DownloadStartingEventHandler guid: (IID fromString: '{efedc989-c396-41ca-83f7-07f845a55724}')!
ICoreWebView2DownloadStartingEventHandler comment: '`ICoreWebView2DownloadStartingEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2DownloadStartingEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(efedc989-c396-41ca-83f7-07f845a55724)
]
interface ICoreWebView2DownloadStartingEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2* sender,
		[in]ICoreWebView2DownloadStartingEventArgs* args);
};
```
'!
!ICoreWebView2DownloadStartingEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2DownloadStartingEventHandler methodsFor!

basicRegister: tokenBuffer
	source Add_DownloadStarting: self token: tokenBuffer!

basicUnregister
	source Remove_DownloadStarting: token! !
!ICoreWebView2DownloadStartingEventHandler categoriesForMethods!
basicRegister:!private!realizing/unrealizing! !
basicUnregister!private!realizing/unrealizing! !
!

!ICoreWebView2DownloadStartingEventHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2DownloadStartingEventHandler'
		ICoreWebView2DownloadStartingEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2* ICoreWebView2DownloadStartingEventArgs*'
!

eventName
	"Answer the symbolic name for this event (i.e. the SASE event trigger name)"

	^#downloadStarting:! !
!ICoreWebView2DownloadStartingEventHandler class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
eventName!constants!public! !
!

