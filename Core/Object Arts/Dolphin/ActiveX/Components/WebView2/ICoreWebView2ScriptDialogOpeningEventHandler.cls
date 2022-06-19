"Filed out from Dolphin Smalltalk"!

ICoreWebView2EventHandler subclass: #ICoreWebView2ScriptDialogOpeningEventHandler
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ICoreWebView2ScriptDialogOpeningEventHandler guid: (IID fromString: '{ef381bf9-afa8-4e37-91c4-8ac48524bdfb}')!
ICoreWebView2ScriptDialogOpeningEventHandler comment: '`ICoreWebView2ScriptDialogOpeningEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2ScriptDialogOpeningEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

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
!ICoreWebView2ScriptDialogOpeningEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2ScriptDialogOpeningEventHandler methodsFor!

basicRegister: tokenBuffer
	source Add_ScriptDialogOpening: self token: tokenBuffer!

basicUnregister
	source Remove_ScriptDialogOpening: token! !
!ICoreWebView2ScriptDialogOpeningEventHandler categoriesForMethods!
basicRegister:!private!realizing/unrealizing! !
basicUnregister!private!realizing/unrealizing! !
!

!ICoreWebView2ScriptDialogOpeningEventHandler class methodsFor!

argsClass
	^ICoreWebView2ScriptDialogOpeningEventArgs!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2ScriptDialogOpeningEventHandler'
		ICoreWebView2ScriptDialogOpeningEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2* ICoreWebView2ScriptDialogOpeningEventArgs*'
!

eventName
	"Answer the symbolic name for this event (i.e. the SASE event trigger name)"

	^#scriptDialogOpening:! !
!ICoreWebView2ScriptDialogOpeningEventHandler class categoriesForMethods!
argsClass!constants!public! !
defineFunctions!**auto generated**!initializing!public! !
eventName!constants!public! !
!

