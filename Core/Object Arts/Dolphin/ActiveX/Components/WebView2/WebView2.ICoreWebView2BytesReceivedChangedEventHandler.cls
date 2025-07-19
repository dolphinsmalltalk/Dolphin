"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2DownloadOperationEventHandler
	subclass: #'WebView2.ICoreWebView2BytesReceivedChangedEventHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2BytesReceivedChangedEventHandler guid: (OS.COM.IID fromString: '{828e8ab6-d94c-4264-9cef-5217170d6251}')!

WebView2.ICoreWebView2BytesReceivedChangedEventHandler comment: '`ICoreWebView2BytesReceivedChangedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2BytesReceivedChangedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(828e8ab6-d94c-4264-9cef-5217170d6251)
]
interface ICoreWebView2BytesReceivedChangedEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2DownloadOperation* sender,
		[in]IUnknown* args);
};
```
'!

!WebView2.ICoreWebView2BytesReceivedChangedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2BytesReceivedChangedEventHandler methodsFor!

basicRegister: tokenBuffer with: anICoreWebView2DownloadOperation
	anICoreWebView2DownloadOperation Add_BytesReceivedChanged: self token: tokenBuffer!

basicUnregister: anInteger from: anICoreWebView2DownloadOperation
	anICoreWebView2DownloadOperation Remove_BytesReceivedChanged: anInteger! !

!WebView2.ICoreWebView2BytesReceivedChangedEventHandler categoriesForMethods!
basicRegister:with:!private!realizing/unrealizing! !
basicUnregister:from:!private!realizing/unrealizing! !
!

!WebView2.ICoreWebView2BytesReceivedChangedEventHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2BytesReceivedChangedEventHandler'
		ICoreWebView2BytesReceivedChangedEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2DownloadOperation* IUnknown*'
!

eventName
	"Answer the symbolic name for this event (i.e. the SASE event trigger name)"

	^#bytesReceivedChanged:! !

!WebView2.ICoreWebView2BytesReceivedChangedEventHandler class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
eventName!constants!public! !
!

