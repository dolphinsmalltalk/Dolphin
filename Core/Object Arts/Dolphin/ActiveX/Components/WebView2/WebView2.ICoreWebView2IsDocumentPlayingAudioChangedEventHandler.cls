"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2EventHandler subclass: #'WebView2.ICoreWebView2IsDocumentPlayingAudioChangedEventHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2IsDocumentPlayingAudioChangedEventHandler guid: (OS.COM.IID fromString: '{5def109a-2f4b-49fa-b7f6-11c39e513328}')!
WebView2.ICoreWebView2IsDocumentPlayingAudioChangedEventHandler comment: '`ICoreWebView2IsDocumentPlayingAudioChangedEventHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2IsDocumentPlayingAudioChangedEventHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(5def109a-2f4b-49fa-b7f6-11c39e513328)
]
interface ICoreWebView2IsDocumentPlayingAudioChangedEventHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]ICoreWebView2* sender,
		[in]IUnknown* args);
};
```
'!
!WebView2.ICoreWebView2IsDocumentPlayingAudioChangedEventHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2IsDocumentPlayingAudioChangedEventHandler methodsFor!

basicRegister: tokenBuffer
	source Add_IsDocumentPlayingAudioChanged: self token: tokenBuffer!

basicUnregister
	source Remove_IsDocumentPlayingAudioChanged: token! !
!WebView2.ICoreWebView2IsDocumentPlayingAudioChangedEventHandler categoriesForMethods!
basicRegister:!private!realizing/unrealizing! !
basicUnregister!private!realizing/unrealizing! !
!

!WebView2.ICoreWebView2IsDocumentPlayingAudioChangedEventHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2IsDocumentPlayingAudioChangedEventHandler'
		ICoreWebView2IsDocumentPlayingAudioChangedEventHandler defineTemplate"

	self
		defineFunction: #Invoke:args:
			argumentTypes: 'ICoreWebView2* IUnknown*'
!

eventName
	"Answer the symbolic name for this event (i.e. the SASE event trigger name)"

	^#isDocumentPlayingAudioChanged! !
!WebView2.ICoreWebView2IsDocumentPlayingAudioChangedEventHandler class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
eventName!constants!public! !
!

