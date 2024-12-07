"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2EventHandler
	subclass: #'WebView2.ICoreWebView2ProfileDeletedEventHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2ProfileDeletedEventHandler guid: (OS.COM.IID fromString: '{df35055d-772e-4dbe-b743-5fbf74a2b258}')!

WebView2.ICoreWebView2ProfileDeletedEventHandler comment: '`ICoreWebView2ProfileDeletedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2ProfileDeletedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(df35055d-772e-4dbe-b743-5fbf74a2b258)
]
interface ICoreWebView2ProfileDeletedEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2Profile* sender,
		[in]IUnknown* args);
};
```
'!

!WebView2.ICoreWebView2ProfileDeletedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2ProfileDeletedEventHandler methodsFor!

basicRegister: tokenBuffer with: anICoreWebView2Interface
	anICoreWebView2Interface Add_Deleted: self token: tokenBuffer!

basicUnregister: anInteger from: anICoreWebView2Interface
	anICoreWebView2Interface Remove_Deleted: anInteger!

Invoke: sender args: args
	"Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			[in]ICoreWebView2Profile* sender,
			[in]IUnknown* args);"

	<virtual stdcall: hresult 4 ICoreWebView2Profile* IUnknown*>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2ProfileDeletedEventHandler categoriesForMethods!
basicRegister:with:!private!realizing/unrealizing! !
basicUnregister:from:!private!realizing/unrealizing! !
Invoke:args:!**auto generated**!COM Interfaces-ICoreWebView2ProfileDeletedEventHandler!public! !
!

!WebView2.ICoreWebView2ProfileDeletedEventHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2ProfileDeletedEventHandler'
		ICoreWebView2ProfileDeletedEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2Profile* IUnknown*'
!

eventName
	"Answer the symbolic name for this event (i.e. the SASE event trigger name)"

	^#profileDeleted! !

!WebView2.ICoreWebView2ProfileDeletedEventHandler class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
eventName!constants!public! !
!

