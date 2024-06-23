"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2EventHandler
	subclass: #'WebView2.ICoreWebView2ContentLoadingEventHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2ContentLoadingEventHandler guid: (OS.COM.IID fromString: '{364471e7-f2be-4910-bdba-d72077d51c4b}')!

WebView2.ICoreWebView2ContentLoadingEventHandler comment: '`ICoreWebView2ContentLoadingEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2ContentLoadingEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(364471e7-f2be-4910-bdba-d72077d51c4b)
]
interface ICoreWebView2ContentLoadingEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2* sender,
		[in]ICoreWebView2ContentLoadingEventArgs* args);
};
```
'!

!WebView2.ICoreWebView2ContentLoadingEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2ContentLoadingEventHandler methodsFor!

basicRegister: tokenBuffer
	source Add_ContentLoading: self token: tokenBuffer!

basicUnregister
	source Remove_ContentLoading: token!

Invoke: sender args: args
	"Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			[in]ICoreWebView2* sender,
			[in]ICoreWebView2ContentLoadingEventArgs* args);"

	<virtual stdcall: hresult 4 ICoreWebView2* ICoreWebView2ContentLoadingEventArgs*>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2ContentLoadingEventHandler categoriesForMethods!
basicRegister:!private!realizing/unrealizing! !
basicUnregister!private!realizing/unrealizing! !
Invoke:args:!**auto generated**!COM Interfaces-ICoreWebView2ContentLoadingEventHandler!public! !
!

!WebView2.ICoreWebView2ContentLoadingEventHandler class methodsFor!

argsClass
	^ICoreWebView2ContentLoadingEventArgs!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2ContentLoadingEventHandler'
		ICoreWebView2ContentLoadingEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2* ICoreWebView2ContentLoadingEventArgs*'
!

eventName
	"Answer the symbolic name for this event (i.e. the SASE event trigger name)"

	^#contentLoading:! !

!WebView2.ICoreWebView2ContentLoadingEventHandler class categoriesForMethods!
argsClass!constants!public! !
defineFunctions!**auto generated**!initializing!public!template definition! !
eventName!constants!public! !
!

