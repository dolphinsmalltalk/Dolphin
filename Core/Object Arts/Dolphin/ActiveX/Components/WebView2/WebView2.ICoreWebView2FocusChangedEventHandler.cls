"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2EventHandler
	subclass: #'WebView2.ICoreWebView2FocusChangedEventHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2FocusChangedEventHandler guid: (OS.COM.IID fromString: '{05ea24bd-6452-4926-9014-4b82b498135d}')!

WebView2.ICoreWebView2FocusChangedEventHandler isNonInstantiable: true!

WebView2.ICoreWebView2FocusChangedEventHandler comment: '`ICoreWebView2FocusChangedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2FocusChangedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(05ea24bd-6452-4926-9014-4b82b498135d)
]
interface ICoreWebView2FocusChangedEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2Controller* sender,
		[in]IUnknown* args);
};
```
'!

!WebView2.ICoreWebView2FocusChangedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2FocusChangedEventHandler methodsFor!

Invoke: sender args: args
	"Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			[in]ICoreWebView2Controller* sender,
			[in]IUnknown* args);"

	<virtual stdcall: hresult 4 ICoreWebView2Controller* IUnknown*>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2FocusChangedEventHandler categoriesForMethods!
Invoke:args:!**auto generated**!COM Interfaces-ICoreWebView2FocusChangedEventHandler!public! !
!

!WebView2.ICoreWebView2FocusChangedEventHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2FocusChangedEventHandler'
		ICoreWebView2FocusChangedEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2Controller* IUnknown*'
!

iid
	^##(self) guid! !

!WebView2.ICoreWebView2FocusChangedEventHandler class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
iid!constants!public! !
!

