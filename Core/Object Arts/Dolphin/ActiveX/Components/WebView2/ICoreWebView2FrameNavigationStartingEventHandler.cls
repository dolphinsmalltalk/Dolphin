"Filed out from Dolphin Smalltalk"!

ICoreWebView2EventHandler subclass: #ICoreWebView2FrameNavigationStartingEventHandler
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
ICoreWebView2FrameNavigationStartingEventHandler guid: (OS.COM.IID fromString: '{e79908bf-2d5d-4968-83db-263fea2c1da3}')!
ICoreWebView2FrameNavigationStartingEventHandler comment: '`ICoreWebView2FrameNavigationStartingEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2FrameNavigationStartingEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

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
!ICoreWebView2FrameNavigationStartingEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2FrameNavigationStartingEventHandler methodsFor!

basicRegister: tokenBuffer
	source Add_FrameNavigationStarting: self token: tokenBuffer!

basicUnregister
	source Remove_FrameNavigationStarting: token! !
!ICoreWebView2FrameNavigationStartingEventHandler categoriesForMethods!
basicRegister:!private!realizing/unrealizing! !
basicUnregister!private!realizing/unrealizing! !
!

!ICoreWebView2FrameNavigationStartingEventHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2FrameNavigationStartingEventHandler'
		ICoreWebView2FrameNavigationStartingEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2Frame* ICoreWebView2NavigationStartingEventArgs*'
!

eventName
	"Answer the symbolic name for this event (i.e. the SASE event trigger name)"

	^#frameNavigationStarting:! !
!ICoreWebView2FrameNavigationStartingEventHandler class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
eventName!constants!public! !
!

