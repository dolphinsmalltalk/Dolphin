"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2EventHandler
	subclass: #'WebView2.ICoreWebView2ProcessInfosChangedEventHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2ProcessInfosChangedEventHandler guid: (OS.COM.IID fromString: '{f4af0c39-44b9-40e9-8b11-0484cfb9e0a1}')!
WebView2.ICoreWebView2ProcessInfosChangedEventHandler comment: '`ICoreWebView2ProcessInfosChangedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2ProcessInfosChangedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(f4af0c39-44b9-40e9-8b11-0484cfb9e0a1)
]
interface ICoreWebView2ProcessInfosChangedEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2Environment* sender,
		[in]IUnknown* args);
};
```
'!
!WebView2.ICoreWebView2ProcessInfosChangedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2ProcessInfosChangedEventHandler methodsFor!

basicRegister: tokenBuffer
	source Add_ProcessInfosChanged: self token: tokenBuffer!

basicUnregister
	source Remove_ProcessInfosChanged: token!

Invoke: sender args: args
	"Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			[in]ICoreWebView2Environment* sender,
			[in]IUnknown* args);"

	<virtual stdcall: hresult 4 ICoreWebView2Environment* IUnknown*>
	^self invalidCall: _failureCode! !
!WebView2.ICoreWebView2ProcessInfosChangedEventHandler categoriesForMethods!
basicRegister:!private!realizing/unrealizing! !
basicUnregister!private!realizing/unrealizing! !
Invoke:args:!**auto generated**!COM Interfaces-ICoreWebView2ProcessInfosChangedEventHandler!public! !
!

!WebView2.ICoreWebView2ProcessInfosChangedEventHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2ProcessInfosChangedEventHandler'
		ICoreWebView2ProcessInfosChangedEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2Environment* IUnknown*'
!

eventName
	"Answer the symbolic name for this event (i.e. the SASE event trigger name)"

	^#processInfosChanged! !
!WebView2.ICoreWebView2ProcessInfosChangedEventHandler class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
eventName!constants!public! !
!

