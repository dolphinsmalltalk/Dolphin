"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2FrameEventHandler
	subclass: #'WebView2.ICoreWebView2FrameNameChangedEventHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2FrameNameChangedEventHandler guid: (OS.COM.IID fromString: '{435c7dc8-9baa-11eb-a8b3-0242ac130003}')!

WebView2.ICoreWebView2FrameNameChangedEventHandler comment: '`ICoreWebView2FrameNameChangedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2FrameNameChangedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(435c7dc8-9baa-11eb-a8b3-0242ac130003)
]
interface ICoreWebView2FrameNameChangedEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2Frame* sender,
		[in]IUnknown* args);
};
```
'!

!WebView2.ICoreWebView2FrameNameChangedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2FrameNameChangedEventHandler methodsFor!

basicRegister: tokenBuffer with: anICoreWebView2Frame
	anICoreWebView2Frame Add_NameChanged: self token: tokenBuffer!

basicUnregister: anInteger from: anICoreWebView2Frame
	anICoreWebView2Frame Remove_NameChanged: anInteger! !

!WebView2.ICoreWebView2FrameNameChangedEventHandler categoriesForMethods!
basicRegister:with:!private!realizing/unrealizing! !
basicUnregister:from:!private!realizing/unrealizing! !
!

!WebView2.ICoreWebView2FrameNameChangedEventHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2FrameNameChangedEventHandler'
		ICoreWebView2FrameNameChangedEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2Frame* IUnknown*'
!

eventName
	"Answer the symbolic name for this event (i.e. the SASE event trigger name)"

	^#frameNameChanged:! !

!WebView2.ICoreWebView2FrameNameChangedEventHandler class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
eventName!constants!public! !
!

