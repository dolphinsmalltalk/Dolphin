"Filed out from Dolphin Smallalk"!

IUnknown subclass: #ICoreWebView2HistoryChangedEventHandler
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'WebView2Constants'
	classInstanceVariableNames: ''!
ICoreWebView2HistoryChangedEventHandler guid: (IID fromString: '{c79a420c-efd9-4058-9295-3e8b4bcab645}')!
ICoreWebView2HistoryChangedEventHandler comment: '`ICoreWebView2HistoryChangedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2HistoryChangedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

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
!ICoreWebView2HistoryChangedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2HistoryChangedEventHandler methodsFor!

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
!ICoreWebView2HistoryChangedEventHandler categoriesForMethods!
invoke:args:!**auto generated**!methods!public! !
Invoke:args:!**auto generated**!COM Interfaces-ICoreWebView2HistoryChangedEventHandler!private! !
!

!ICoreWebView2HistoryChangedEventHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2HistoryChangedEventHandler'
		ICoreWebView2HistoryChangedEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2* IUnknown*'
! !
!ICoreWebView2HistoryChangedEventHandler class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

