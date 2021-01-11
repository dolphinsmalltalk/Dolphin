"Filed out from Dolphin Smalltalk 7"!

OS.COM.IUnknown subclass: #'WebView2.ICoreWebView2HistoryChangedEventHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2HistoryChangedEventHandler guid: (OS.COM.IID fromString: '{c79a420c-efd9-4058-9295-3e8b4bcab645}')!
WebView2.ICoreWebView2HistoryChangedEventHandler comment: '`ICoreWebView2HistoryChangedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2HistoryChangedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(c79a420c-efd9-4058-9295-3e8b4bcab645)
]
interface ICoreWebView2HistoryChangedEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2* sender,
		[in]IUnknown* args);
};
```
'!
!WebView2.ICoreWebView2HistoryChangedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2HistoryChangedEventHandler methodsFor!

invoke: sender args: args
	"Invoke the Invoke() method of the COM object."

	^self Invoke: sender args: args!

Invoke: sender args: args
	"Private - Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			[in]ICoreWebView2* sender,
			[in]IUnknown* args);"

	<virtual stdcall: hresult 4 ICoreWebView2* IUnknown*>
	^self invalidCall: _failureCode! !
!WebView2.ICoreWebView2HistoryChangedEventHandler categoriesFor: #invoke:args:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2HistoryChangedEventHandler categoriesFor: #Invoke:args:!**auto generated**!COM Interfaces-ICoreWebView2HistoryChangedEventHandler!private! !

!WebView2.ICoreWebView2HistoryChangedEventHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2HistoryChangedEventHandler'
		ICoreWebView2HistoryChangedEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2* IUnknown*'
! !
!WebView2.ICoreWebView2HistoryChangedEventHandler class categoriesFor: #defineFunctions!**auto generated**!initializing!private! !

