"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2EventHandler
	subclass: #'WebView2.ICoreWebView2FrameContentLoadingEventHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2FrameContentLoadingEventHandler guid: (OS.COM.IID fromString: '{0d6156f2-d332-49a7-9e03-7d8f2feeee54}')!
WebView2.ICoreWebView2FrameContentLoadingEventHandler comment: '`ICoreWebView2FrameContentLoadingEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2FrameContentLoadingEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(0d6156f2-d332-49a7-9e03-7d8f2feeee54)
]
interface ICoreWebView2FrameContentLoadingEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2Frame* sender,
		[in]ICoreWebView2ContentLoadingEventArgs* args);
};
```
'!
!WebView2.ICoreWebView2FrameContentLoadingEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2FrameContentLoadingEventHandler methodsFor!

basicRegister: tokenBuffer
	source Add_ContentLoading: self token: tokenBuffer!

basicUnregister
	source Remove_ContentLoading: token!

Invoke: sender args: args
	"Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			[in]ICoreWebView2Frame* sender,
			[in]ICoreWebView2ContentLoadingEventArgs* args);"

	<virtual stdcall: hresult 4 ICoreWebView2Frame* ICoreWebView2ContentLoadingEventArgs*>
	^self invalidCall: _failureCode! !
!WebView2.ICoreWebView2FrameContentLoadingEventHandler categoriesForMethods!
basicRegister:!private!realizing/unrealizing! !
basicUnregister!private!realizing/unrealizing! !
Invoke:args:!**auto generated**!COM Interfaces-ICoreWebView2FrameContentLoadingEventHandler!public! !
!

!WebView2.ICoreWebView2FrameContentLoadingEventHandler class methodsFor!

argsClass
	^ICoreWebView2ContentLoadingEventArgs!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2FrameContentLoadingEventHandler'
		ICoreWebView2FrameContentLoadingEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2Frame* ICoreWebView2ContentLoadingEventArgs*'
!

eventName
	"Answer the symbolic name for this event (i.e. the SASE event trigger name)"

	^#frameContentLoading:! !
!WebView2.ICoreWebView2FrameContentLoadingEventHandler class categoriesForMethods!
argsClass!constants!public! !
defineFunctions!**auto generated**!initializing!public!template definition! !
eventName!constants!public! !
!

