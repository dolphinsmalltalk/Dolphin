"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2EventHandler
	subclass: #'WebView2.ICoreWebView2IsDefaultDownloadDialogOpenChangedEventHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2IsDefaultDownloadDialogOpenChangedEventHandler guid: (OS.COM.IID fromString: '{3117da26-ae13-438d-bd46-edbeb2c4ce81}')!
WebView2.ICoreWebView2IsDefaultDownloadDialogOpenChangedEventHandler comment: '`ICoreWebView2IsDefaultDownloadDialogOpenChangedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2IsDefaultDownloadDialogOpenChangedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(3117da26-ae13-438d-bd46-edbeb2c4ce81)
]
interface ICoreWebView2IsDefaultDownloadDialogOpenChangedEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2* sender,
		[in]IUnknown* args);
};
```
'!
!WebView2.ICoreWebView2IsDefaultDownloadDialogOpenChangedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2IsDefaultDownloadDialogOpenChangedEventHandler methodsFor!

basicRegister: tokenBuffer
	source Add_IsDefaultDownloadDialogOpenChanged: self token: tokenBuffer!

basicUnregister
	source Remove_IsDefaultDownloadDialogOpenChanged: token!

Invoke: sender args: args
	"Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			[in]ICoreWebView2* sender,
			[in]IUnknown* args);"

	<virtual stdcall: hresult 4 ICoreWebView2* IUnknown*>
	^self invalidCall: _failureCode! !
!WebView2.ICoreWebView2IsDefaultDownloadDialogOpenChangedEventHandler categoriesForMethods!
basicRegister:!private!realizing/unrealizing! !
basicUnregister!private!realizing/unrealizing! !
Invoke:args:!**auto generated**!COM Interfaces-ICoreWebView2IsDefaultDownloadDialogOpenChangedEventHandler!public! !
!

!WebView2.ICoreWebView2IsDefaultDownloadDialogOpenChangedEventHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2IsDefaultDownloadDialogOpenChangedEventHandler'
		ICoreWebView2IsDefaultDownloadDialogOpenChangedEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2* IUnknown*'
!

eventName
	"Answer the symbolic name for this event (i.e. the SASE event trigger name)"

	^#isDefaultDownloadDialogOpenChanged! !
!WebView2.ICoreWebView2IsDefaultDownloadDialogOpenChangedEventHandler class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
eventName!constants!public! !
!

