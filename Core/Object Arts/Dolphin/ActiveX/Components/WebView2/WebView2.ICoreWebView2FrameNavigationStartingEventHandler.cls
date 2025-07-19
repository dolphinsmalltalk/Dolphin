"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2FrameEventHandler
	subclass: #'WebView2.ICoreWebView2FrameNavigationStartingEventHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2FrameNavigationStartingEventHandler guid: (OS.COM.IID fromString: '{e79908bf-2d5d-4968-83db-263fea2c1da3}')!

WebView2.ICoreWebView2FrameNavigationStartingEventHandler comment: '`ICoreWebView2FrameNavigationStartingEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2FrameNavigationStartingEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(e79908bf-2d5d-4968-83db-263fea2c1da3)
]
interface ICoreWebView2FrameNavigationStartingEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2Frame* sender,
		[in]ICoreWebView2NavigationStartingEventArgs* args);
};
```
'!

!WebView2.ICoreWebView2FrameNavigationStartingEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2FrameNavigationStartingEventHandler methodsFor!

basicRegister: tokenBuffer with: anICoreWebView2Frame2
	anICoreWebView2Frame2 Add_NavigationStarting: self token: tokenBuffer!

basicUnregister: anInteger from: anICoreWebView2Frame2
	anICoreWebView2Frame2 Remove_NavigationStarting: anInteger!

Invoke: sender args: args
	"Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			[in]ICoreWebView2Frame* sender,
			[in]ICoreWebView2NavigationStartingEventArgs* args);"

	<virtual stdcall: hresult 4 ICoreWebView2Frame* ICoreWebView2NavigationStartingEventArgs*>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2FrameNavigationStartingEventHandler categoriesForMethods!
basicRegister:with:!private!realizing/unrealizing! !
basicUnregister:from:!private!realizing/unrealizing! !
Invoke:args:!**auto generated**!COM Interfaces-ICoreWebView2FrameNavigationStartingEventHandler!public! !
!

!WebView2.ICoreWebView2FrameNavigationStartingEventHandler class methodsFor!

argsClass
	^ICoreWebView2NavigationStartingEventArgs2!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2FrameNavigationStartingEventHandler'
		ICoreWebView2FrameNavigationStartingEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2Frame* ICoreWebView2NavigationStartingEventArgs*'
!

eventName
	"Answer the symbolic name for this event (i.e. the SASE event trigger name)"

	^#frame:navigationStarting:! !

!WebView2.ICoreWebView2FrameNavigationStartingEventHandler class categoriesForMethods!
argsClass!constants!public! !
defineFunctions!**auto generated**!initializing!public!template definition! !
eventName!constants!public! !
!

