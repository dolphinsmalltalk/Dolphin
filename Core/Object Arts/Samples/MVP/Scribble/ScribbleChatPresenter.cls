"Filed out from Dolphin Smalltalk 1.0 Beta 2"!

ScribblePresenter subclass: #ScribbleChatPresenter
	instanceVariableNames: 'socket '
	classVariableNames: ''
	poolDictionaries: ''!

ScribbleChatPresenter class instanceVariableNames: ''!

ScribbleChatPresenter comment: ''!

!ScribbleChatPresenter categoriesForClass!No category! !

!ScribbleChatPresenter methodsFor!

addMessage: aMessage
	"Private - Adds the Message aMessage to the current Scribble.
	Also, sends aMessage to the ReflectorServer to which we are connected."

	super addMessage: aMessage.
	self socket send: aMessage!

host: aHostString port: anInteger
	"Private - Initialize the receiver to talk to the Scribble chat
	server on aHostString via anInteger port"

	(socket := Socket port: anInteger hostName: aHostString)
		connect;
		messageBlock: [:m | self onMessage: m];
		errorBlock: [:e | self onError: e].
!

onError: aSocketError
	"Private - Handle the exception aSocketError."

	MessageBox notify: ('ScribbleChatPresenter ERROR: ', aSocketError description)!

onMessage: anObject
	"Private - Handle the incoming message anObject.
	Pass the message on to the our model."

	self basicAddMessage: anObject!

onViewOpened
	"Connect the receiver's socket using the default host and port."

	self host: self class defaultHostName port: self class defaultPort
!

socket
	"Private - Answer the Socket associated with the receiver"

	^socket! !

!ScribbleChatPresenter categoriesFor: #addMessage:!adding! !
!ScribbleChatPresenter categoriesFor: #host:port:!sockets! !
!ScribbleChatPresenter categoriesFor: #onError:!events-sockets! !
!ScribbleChatPresenter categoriesFor: #onMessage:!events-sockets! !
!ScribbleChatPresenter categoriesFor: #onViewOpened!events-presenter! !
!ScribbleChatPresenter categoriesFor: #socket!accessing! !

!ScribbleChatPresenter class methodsFor!

defaultHostName
	"Private - Answer the default host for the Scribble ReflectorServer"

	^'pdg.intuitive.co.uk'!

defaultPort
	"Private - Answer the default port number for the Scribble ReflectorServer"

	^50000! !

!ScribbleChatPresenter class categoriesFor: #defaultHostName!constants! !
!ScribbleChatPresenter class categoriesFor: #defaultPort!constants! !

