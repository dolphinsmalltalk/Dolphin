"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2EventHandler
	subclass: #'WebView2.ICoreWebView2FrameDestroyedEventHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2FrameDestroyedEventHandler guid: (OS.COM.IID fromString: '{59dd7b4c-9baa-11eb-a8b3-0242ac130003}')!

WebView2.ICoreWebView2FrameDestroyedEventHandler comment: '`ICoreWebView2FrameDestroyedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2FrameDestroyedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(59dd7b4c-9baa-11eb-a8b3-0242ac130003)
]
interface ICoreWebView2FrameDestroyedEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2Frame* sender,
		[in]IUnknown* args);
};
```
'!

!WebView2.ICoreWebView2FrameDestroyedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2FrameDestroyedEventHandler methodsFor!

basicRegister: tokenBuffer with: anICoreWebView2Interface
	anICoreWebView2Interface Add_Destroyed: self token: tokenBuffer!

basicUnregister: anInteger from: anICoreWebView2Interface
	anICoreWebView2Interface Remove_Destroyed: anInteger!

Invoke: sender args: args
	"Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			[in]ICoreWebView2Frame* sender,
			[in]IUnknown* args);"

	<virtual stdcall: hresult 4 ICoreWebView2Frame* IUnknown*>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2FrameDestroyedEventHandler categoriesForMethods!
basicRegister:with:!private!realizing/unrealizing! !
basicUnregister:from:!private!realizing/unrealizing! !
Invoke:args:!**auto generated**!COM Interfaces-ICoreWebView2FrameDestroyedEventHandler!public! !
!

!WebView2.ICoreWebView2FrameDestroyedEventHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2FrameDestroyedEventHandler'
		ICoreWebView2FrameDestroyedEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2Frame* IUnknown*'
!

eventName
	"Answer the symbolic name for this event (i.e. the SASE event trigger name)"

	^#frameDestroyed! !

!WebView2.ICoreWebView2FrameDestroyedEventHandler class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
eventName!constants!public! !
!

