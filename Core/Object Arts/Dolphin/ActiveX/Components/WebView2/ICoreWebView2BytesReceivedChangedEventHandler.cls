"Filed out from Dolphin Smalltalk"!

ICoreWebView2EventHandler subclass: #ICoreWebView2BytesReceivedChangedEventHandler
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ICoreWebView2BytesReceivedChangedEventHandler guid: (IID fromString: '{828e8ab6-d94c-4264-9cef-5217170d6251}')!
ICoreWebView2BytesReceivedChangedEventHandler comment: '`ICoreWebView2BytesReceivedChangedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2BytesReceivedChangedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

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
!ICoreWebView2BytesReceivedChangedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2BytesReceivedChangedEventHandler methodsFor!

basicRegister: tokenBuffer
	source Add_BytesReceivedChanged: self token: tokenBuffer!

basicUnregister
	source Remove_BytesReceivedChanged: token! !
!ICoreWebView2BytesReceivedChangedEventHandler categoriesForMethods!
basicRegister:!private!realizing/unrealizing! !
basicUnregister!private!realizing/unrealizing! !
!

!ICoreWebView2BytesReceivedChangedEventHandler class methodsFor!

argsClass
	^ICoreWebView2BytesReceivedChangedEventHandler!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2BytesReceivedChangedEventHandler'
		ICoreWebView2BytesReceivedChangedEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2DownloadOperation* IUnknown*'
!

eventName
	"Answer the symbolic name for this event (i.e. the SASE event trigger name)"

	^#bytesReceivedChanged! !
!ICoreWebView2BytesReceivedChangedEventHandler class categoriesForMethods!
argsClass!constants!public! !
defineFunctions!**auto generated**!initializing!public! !
eventName!constants!public! !
!

