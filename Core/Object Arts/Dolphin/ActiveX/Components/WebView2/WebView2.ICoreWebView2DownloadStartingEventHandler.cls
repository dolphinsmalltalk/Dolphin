"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2ViewEventHandler
	subclass: #'WebView2.ICoreWebView2DownloadStartingEventHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2DownloadStartingEventHandler guid: (OS.COM.IID fromString: '{efedc989-c396-41ca-83f7-07f845a55724}')!

WebView2.ICoreWebView2DownloadStartingEventHandler comment: '`ICoreWebView2DownloadStartingEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2DownloadStartingEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

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

!WebView2.ICoreWebView2DownloadStartingEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2DownloadStartingEventHandler methodsFor!

basicRegister: tokenBuffer with: anICoreWebView2_4
	anICoreWebView2_4 Add_DownloadStarting: self token: tokenBuffer!

basicUnregister: anInteger from: anICoreWebView2_4
	anICoreWebView2_4 Remove_DownloadStarting: anInteger!

Invoke: sender args: args
	"Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			[in]ICoreWebView2* sender,
			[in]ICoreWebView2DownloadStartingEventArgs* args);"

	<virtual stdcall: hresult 4 ICoreWebView2* ICoreWebView2DownloadStartingEventArgs*>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2DownloadStartingEventHandler categoriesForMethods!
basicRegister:with:!private!realizing/unrealizing! !
basicUnregister:from:!private!realizing/unrealizing! !
Invoke:args:!**auto generated**!COM Interfaces-ICoreWebView2DownloadStartingEventHandler!public! !
!

!WebView2.ICoreWebView2DownloadStartingEventHandler class methodsFor!

argsClass
	^ICoreWebView2DownloadStartingEventArgs!

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

!WebView2.ICoreWebView2DownloadStartingEventHandler class categoriesForMethods!
argsClass!constants!public! !
defineFunctions!**auto generated**!initializing!public!template definition! !
eventName!constants!public! !
!

