"Filed out from Dolphin Smalltalk 7"!

OS.COM.IUnknown subclass: #'WebView2.ICoreWebView2ScriptDialogOpeningEventHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2ScriptDialogOpeningEventHandler guid: (OS.COM.IID fromString: '{ef381bf9-afa8-4e37-91c4-8ac48524bdfb}')!
WebView2.ICoreWebView2ScriptDialogOpeningEventHandler comment: '`ICoreWebView2ScriptDialogOpeningEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2ScriptDialogOpeningEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(ef381bf9-afa8-4e37-91c4-8ac48524bdfb)
]
interface ICoreWebView2ScriptDialogOpeningEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2* sender,
		[in]ICoreWebView2ScriptDialogOpeningEventArgs* args);
};
```
'!
!WebView2.ICoreWebView2ScriptDialogOpeningEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2ScriptDialogOpeningEventHandler methodsFor!

invoke: sender args: args
	"Invoke the Invoke() method of the COM object."

	^self Invoke: sender args: args!

Invoke: sender args: args
	"Private - Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			[in]ICoreWebView2* sender,
			[in]ICoreWebView2ScriptDialogOpeningEventArgs* args);"

	<virtual stdcall: hresult 4 ICoreWebView2* ICoreWebView2ScriptDialogOpeningEventArgs*>
	^self invalidCall: _failureCode! !
!WebView2.ICoreWebView2ScriptDialogOpeningEventHandler categoriesFor: #invoke:args:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2ScriptDialogOpeningEventHandler categoriesFor: #Invoke:args:!**auto generated**!COM Interfaces-ICoreWebView2ScriptDialogOpeningEventHandler!private! !

!WebView2.ICoreWebView2ScriptDialogOpeningEventHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2ScriptDialogOpeningEventHandler'
		ICoreWebView2ScriptDialogOpeningEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2* ICoreWebView2ScriptDialogOpeningEventArgs*'
! !
!WebView2.ICoreWebView2ScriptDialogOpeningEventHandler class categoriesFor: #defineFunctions!**auto generated**!initializing!private! !

