"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2Interface
	subclass: #'WebView2.ICoreWebView2EventHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2EventHandler guid: (OS.COM.IID fromString: '{f3b5c8b4-bce0-47ed-beab-353e8d8d1b88}')!

WebView2.ICoreWebView2EventHandler isNonInstantiable: true!

WebView2.ICoreWebView2EventHandler comment: '`ICoreWebView2EventHandler` is not defined in the WebView2 IDL, but is defined here to group all the similar event handler interfaces in an attempt to make the large API easier to navigate and understand. The subclasses are further grouped under additional abstract interface classes, that are also not defined in IDL, according to the type of WebView2 object that publishes the event. 

There are a large number of event handler interfaces that have essentially the same definition of single Invoke() method with two parameters, the first of which is the source interface for the event (e.g. `ICoreWebView2Controller`) and the 2nd of which is an interface of a type specific to the event and from which details about the event can be queried, and in some cases mutated. For example the `ICoreWebVie2NavigationStartingEventHandler` has a `Cancel` property which can be set to 1 (true) to prevent the navigation taking place.'!

!WebView2.ICoreWebView2EventHandler categoriesForClass!COM-Interfaces! !

!WebView2.ICoreWebView2EventHandler methodsFor!

basicRegister: tokenBuffer with: anICoreWebView2Interface
	^self subclassResponsibility!

basicUnregister: anInteger from: anICoreWebView2Interface
	self subclassResponsibility!

Invoke: anICoreWebView2Interface args: anIUnknown
	^self subclassResponsibility!

register: anICoreWebView2Interface
	| tokenBuf |
	tokenBuf := ByteArray newFixed: 8.
	self basicRegister: tokenBuf with: anICoreWebView2Interface.
	^tokenBuf int64AtOffset: 0!

unregister: anInteger from: anICoreWebView2Interface
	anInteger ifNil: [^self].
	self basicUnregister: anInteger from: anICoreWebView2Interface! !

!WebView2.ICoreWebView2EventHandler categoriesForMethods!
basicRegister:with:!private!realizing/unrealizing! !
basicUnregister:from:!private!realizing/unrealizing! !
Invoke:args:!event handling!public! !
register:!public!realizing/unrealizing! !
unregister:from:!public!realizing/unrealizing! !
!

WebView2.ICoreWebView2EventHandler methodProtocol: #ICoreWebView2EventHandler attributes: #(#readOnly) selectors: #(#Invoke:args:)!

!WebView2.ICoreWebView2EventHandler class methodsFor!

argsClass
	^IUnknown!

eventName
	"Answer the symbolic name for this event (i.e. the SASE event trigger name)"

	^self subclassResponsibility!

hasArgs
	^self argsClass ~~ IUnknown!

triggerBlockFor: aUrlPresenter
	| event argc |
	event := self eventName.
	argc := event argumentCount.
	^argc == 2
		ifTrue: 
			[
			[:source :args |
			aUrlPresenter
				trigger: event
				with: source
				with: args]]
		ifFalse: 
			[self hasArgs
				ifTrue: [[:source :args | aUrlPresenter trigger: event with: args]]
				ifFalse: 
					[argc == 1
						ifTrue: [[:source :args | aUrlPresenter trigger: event with: source]]
						ifFalse: [[aUrlPresenter trigger: event]]]]! !

!WebView2.ICoreWebView2EventHandler class categoriesForMethods!
argsClass!constants!public! !
eventName!constants!public! !
hasArgs!public!testing! !
triggerBlockFor:!helpers!private! !
!

