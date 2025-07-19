"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2DownloadOperationEventHandler
	subclass: #'WebView2.ICoreWebView2EstimatedEndTimeChangedEventHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2EstimatedEndTimeChangedEventHandler guid: (OS.COM.IID fromString: '{28f0d425-93fe-4e63-9f8d-2aeec6d3ba1e}')!

WebView2.ICoreWebView2EstimatedEndTimeChangedEventHandler comment: '`ICoreWebView2EstimatedEndTimeChangedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2EstimatedEndTimeChangedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(28f0d425-93fe-4e63-9f8d-2aeec6d3ba1e)
]
interface ICoreWebView2EstimatedEndTimeChangedEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2DownloadOperation* sender,
		[in]IUnknown* args);
};
```
'!

!WebView2.ICoreWebView2EstimatedEndTimeChangedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2EstimatedEndTimeChangedEventHandler methodsFor!

basicRegister: tokenBuffer with: anICoreWebView2DownloadOperation
	anICoreWebView2DownloadOperation Add_EstimatedEndTimeChanged: self token: tokenBuffer!

basicUnregister: anInteger from: anICoreWebView2DownloadOperation
	anICoreWebView2DownloadOperation Remove_EstimatedEndTimeChanged: anInteger! !

!WebView2.ICoreWebView2EstimatedEndTimeChangedEventHandler categoriesForMethods!
basicRegister:with:!private!realizing/unrealizing! !
basicUnregister:from:!private!realizing/unrealizing! !
!

!WebView2.ICoreWebView2EstimatedEndTimeChangedEventHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2EstimatedEndTimeChangedEventHandler'
		ICoreWebView2EstimatedEndTimeChangedEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2DownloadOperation* IUnknown*'
!

eventName
	"Answer the symbolic name for this event (i.e. the SASE event trigger name)"

	^#downloadEtcChanged:! !

!WebView2.ICoreWebView2EstimatedEndTimeChangedEventHandler class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
eventName!constants!public! !
!

