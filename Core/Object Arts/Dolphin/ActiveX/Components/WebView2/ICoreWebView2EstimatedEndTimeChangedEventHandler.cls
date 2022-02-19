"Filed out from Dolphin Smallalk"!

ICoreWebView2EventHandler subclass: #ICoreWebView2EstimatedEndTimeChangedEventHandler
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ICoreWebView2EstimatedEndTimeChangedEventHandler guid: (IID fromString: '{28f0d425-93fe-4e63-9f8d-2aeec6d3ba1e}')!
ICoreWebView2EstimatedEndTimeChangedEventHandler comment: '`ICoreWebView2EstimatedEndTimeChangedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2EstimatedEndTimeChangedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

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
!ICoreWebView2EstimatedEndTimeChangedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2EstimatedEndTimeChangedEventHandler methodsFor!

basicRegister: tokenBuffer
	source Add_EstimatedEndTimeChanged: self token: tokenBuffer!

basicUnregister
	source Remove_EstimatedEndTimeChanged: token! !
!ICoreWebView2EstimatedEndTimeChangedEventHandler categoriesForMethods!
basicRegister:!private!realizing/unrealizing! !
basicUnregister!private!realizing/unrealizing! !
!

!ICoreWebView2EstimatedEndTimeChangedEventHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2EstimatedEndTimeChangedEventHandler'
		ICoreWebView2EstimatedEndTimeChangedEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2DownloadOperation* IUnknown*'
!

eventName
	"Answer the symbolic name for this event (i.e. the SASE event trigger name)"

	^#estimatedEndTimeChanged! !
!ICoreWebView2EstimatedEndTimeChangedEventHandler class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
eventName!constants!public! !
!

