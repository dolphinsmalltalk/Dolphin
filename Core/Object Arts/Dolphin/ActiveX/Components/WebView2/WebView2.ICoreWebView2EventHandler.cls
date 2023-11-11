"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2Interface
	subclass: #'WebView2.ICoreWebView2EventHandler'
	instanceVariableNames: 'source token'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2EventHandler guid: (OS.COM.IID fromString: '{f3b5c8b4-bce0-47ed-beab-353e8d8d1b88}')!
WebView2.ICoreWebView2EventHandler isNonInstantiable: true!
WebView2.ICoreWebView2EventHandler comment: '`ICoreWebView2EventHandler` is not defined in the WebView2 IDL, but is defined here to group all the similar event handler interfaces in an attempt to make the large API easier to navigate and understand.

There are a large number of event handler interfaces that have essentially the same definition of single Invoke() method with two parameters, the first of which is the source interface for the event (e.g. `ICoreWebView2Controller`) and the 2nd of which is an interface of a type specific to the event and from which details about the event can be queried, and in some cases mutated. For example the `ICoreWebVie2NavigationStartingEventHandler` has a `Cancel` property which can be set to 1 (true) to prevent the navigation taking place.'!
!WebView2.ICoreWebView2EventHandler categoriesForClass!COM-Interfaces! !
!WebView2.ICoreWebView2EventHandler methodsFor!

basicRegister: tokenBuffer
	^self subclassResponsibility!

basicUnregister
	self subclassResponsibility!

Invoke: sender args: args
	^self subclassResponsibility!

register
	token ifNotNil: [^self].
	token := ByteArray new: 8.
	self basicRegister: token.
	token := token int64AtOffset: 0!

source: anICoreWebView2EventSource
	source := anICoreWebView2EventSource!

unregister
	token ifNil: [^self].
	self basicUnregister.
	token := nil! !
!WebView2.ICoreWebView2EventHandler categoriesForMethods!
basicRegister:!private!realizing/unrealizing! !
basicUnregister!private!realizing/unrealizing! !
Invoke:args:!**auto generated**!COM Interfaces-ICoreWebView2AcceleratorKeyPressedEventHandler!public! !
register!public!realizing/unrealizing! !
source:!initializing!private! !
unregister!public!realizing/unrealizing! !
!

WebView2.ICoreWebView2EventHandler methodProtocol: #ICoreWebView2EventHandler attributes: #(#readOnly) selectors: #(#Invoke:args:)!

!WebView2.ICoreWebView2EventHandler class methodsFor!

argsClass
	^IUnknown!

eventName
	"Answer the symbolic name for this event (i.e. the SASE event trigger name)"

	^self subclassResponsibility!

hasArgs
	^self argsClass == IUnknown!

triggerBlockFor: aUrlPresenter
	| event |
	event := self eventName.
	^self hasArgs
		ifTrue: [[aUrlPresenter trigger: event]]
		ifFalse: [[:source :args | aUrlPresenter trigger: event with: args]]! !
!WebView2.ICoreWebView2EventHandler class categoriesForMethods!
argsClass!constants!public! !
eventName!constants!public! !
hasArgs!public!testing! !
triggerBlockFor:!helpers!private! !
!

