﻿"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2ContextMenuItemEventHandler
	subclass: #'WebView2.ICoreWebView2CustomItemSelectedEventHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2CustomItemSelectedEventHandler guid: (OS.COM.IID fromString: '{49e1d0bc-fe9e-4481-b7c2-32324aa21998}')!

WebView2.ICoreWebView2CustomItemSelectedEventHandler comment: '`ICoreWebView2CustomItemSelectedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2CustomItemSelectedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(49e1d0bc-fe9e-4481-b7c2-32324aa21998)
]
interface ICoreWebView2CustomItemSelectedEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2ContextMenuItem* sender,
		[in]IUnknown* args);
};
```
'!

!WebView2.ICoreWebView2CustomItemSelectedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2CustomItemSelectedEventHandler methodsFor!

basicRegister: tokenBuffer with: anICoreWebView2ContextMenuItem
	anICoreWebView2ContextMenuItem Add_CustomItemSelected: self token: tokenBuffer!

basicUnregister: anInteger from: anICoreWebView2ContextMenuItem
	anICoreWebView2ContextMenuItem Remove_CustomItemSelected: anInteger! !

!WebView2.ICoreWebView2CustomItemSelectedEventHandler categoriesForMethods!
basicRegister:with:!private!realizing/unrealizing! !
basicUnregister:from:!private!realizing/unrealizing! !
!

!WebView2.ICoreWebView2CustomItemSelectedEventHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2CustomItemSelectedEventHandler'
		ICoreWebView2CustomItemSelectedEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2ContextMenuItem* IUnknown*'
!

eventName
	"Answer the symbolic name for this event (i.e. the SASE event trigger name)"

	^#contextMenuCustomItemSelected:! !

!WebView2.ICoreWebView2CustomItemSelectedEventHandler class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
eventName!constants!public! !
!

