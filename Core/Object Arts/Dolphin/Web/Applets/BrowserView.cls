"Filed out from Dolphin Smalltalk 7"!

ContainerView subclass: #BrowserView
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
BrowserView guid: (GUID fromString: '{2648c8ba-6b87-11d3-97bb-0080c8d59432}')!
BrowserView comment: 'A BrowserView is a wrapper for the window handle by a web browser to hold and constrain an applet. An instance of this class will be created for each applet, and will typically have a single NPAppletSite as a subview. As the window was created by the web browser in a separate thread, Dolphin does not subclass it to ease avoid cross thread messaging havoc. As a result a BrowserView will not receive any WM_* notifications which limits its use as a general purpose MVP view. 

Note the special instance creation class method, #fromBrowserView:, which is the only legal means of creating a BrowserView.'!
!BrowserView categoriesForClass!Plugin-Support! !
!BrowserView methodsFor!

defaultLayoutManager
	"Private - Answer a default LayoutManager to use."

	^GridLayout new!

defaultWindowStyle
	"Private - Answer the default basic window creation style."

	^super defaultWindowStyle bitOr: WS_CLIPCHILDREN!

preTranslateMessage: aMSG
	"Answer whether the receiver would like to consume the argument aMSG."

	^false! !
!BrowserView categoriesFor: #defaultLayoutManager!constants!private! !
!BrowserView categoriesFor: #defaultWindowStyle!constants!private! !
!BrowserView categoriesFor: #preTranslateMessage:!dispatching!public! !

!BrowserView class methodsFor!

fromBrowserHandle: windowHandle 
	"Answer a new instance of the receiver which has the internet browser
	supplied window as its handle."

	| answer view browserShell |
	answer := self fromHandle: windowHandle.

	"Establish and register the entire parent chain"
	browserShell := answer topShell view.
	view := answer.
	
	[view attachHandle: view handle.
	view = browserShell] 
			whileFalse: [view := view parentView].
	^answer! !
!BrowserView class categoriesFor: #fromBrowserHandle:!instance creation!public! !

