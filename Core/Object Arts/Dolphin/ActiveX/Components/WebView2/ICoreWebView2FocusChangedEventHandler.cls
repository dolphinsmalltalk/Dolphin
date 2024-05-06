"Filed out from Dolphin Smalltalk"!

ICoreWebView2EventHandler subclass: #ICoreWebView2FocusChangedEventHandler
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ICoreWebView2FocusChangedEventHandler guid: (IID fromString: '{05ea24bd-6452-4926-9014-4b82b498135d}')!

ICoreWebView2FocusChangedEventHandler isAbstract: true!

ICoreWebView2FocusChangedEventHandler comment: '`ICoreWebView2FocusChangedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2FocusChangedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

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

!ICoreWebView2FocusChangedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!ICoreWebView2FocusChangedEventHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2FocusChangedEventHandler'
		ICoreWebView2FocusChangedEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2Controller* IUnknown*'
!

iid
	^##(self) guid! !

!ICoreWebView2FocusChangedEventHandler class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
iid!constants!public! !
!

