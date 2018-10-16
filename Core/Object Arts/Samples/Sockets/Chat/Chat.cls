"Filed out from Dolphin Smalltalk 7"!

Presenter subclass: #Chat
	instanceVariableNames: 'calleeAddress outgoingMessage messageDisplay status socket acceptSocket sendQueue'
	classVariableNames: 'Statii'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Chat guid: (GUID fromString: '{87b4c699-026e-11d3-9fd7-00a0cc3e4a32}')!
Chat comment: 'Chat is a <compositePresenter> implementing a simple "chat" service for the purpose of demonstrating the use of the new blocking Dolphin Sockets API. It has a multi-threaded design that would be appropriate for more complex socket client/server applications too. Finally Chat illustrates the use of STB-based messaging, which provides for a simple and efficient way to transmit and receive objects over a socket connection. An instance can be opened on any machine running TCP/IP using:

	Chat show.

This will connect to a TCP/IP port (given by #defaultPort) and start a background process to wait for incoming connections from another Chat window. Ideally the other Chat instance will be created on separate machine, if one is available. However, more than one Chat instance can be created on a single machine but in this case only the first will be able to receive incoming calls since this will be the one that grabs the connection port. 

To establish a Chat session, enter the target machine name or IP address and click Connect. When a connection has successfully been established a pair of threads are forked to manage sending and receiving of messages across the bidirectional socket. Outbound messages are communicated to the sender thread through a shared queue. The sender is responsible for dequeueing messages and forwarding to the remote peer, which it does by writing them to the socket''s buffered write stream. When the complete message has been written the stream is flushed so that the message is transmitted, an  operation which may block the sender thread.  The receiver thread is responsible for receiving complete messages from the socket, and enqueuing them for asynchronous display by the UI process. Note that there is no shared queue for the inbound messages, since the deferred action mechanism process by the InputState object provides this capability in a convenient way for the UI thread.

You can start up a Process Monitor to view the different threads involved in a Chat session and watch how the set changes depending on the session state. 

Messages are transmitted as objects using STB. The message object is just an Association, the key of which identifies the sender, and the value of which is the message text itself. This message format would potentially allow for multiple participants in the conversation, but implementing this is left as an exercise. Note that a validating in-filer is used to guard against executing code that might be transmitted by a malicious remote Smalltalker!!

Messages can then be typed at either end and sent using the Send button.  A conversation can only be held between two Chat sessions at any one time. To disconnect a session click Disconnect or close one of the Chat windows.

Instance Variables:
	calleeAddress		<TextPresenter> holding the IP address to call.
	outgoingMessage	<TextPresenter> for entering a message to send.
	messageDisplay		<RichTextEdit> displaying received messages.
	status				<ValueHolder> holding a <readableString> status message.
	connectSocket		<Socket2> used for connection with a remote Chat instance.
	acceptSocket		<ServerSocket2> used to wait for a connection.
	sendQueue			<SharedQueue> in which outgoing messages are queued for the sender thread.
'!
!Chat categoriesForClass!MVP-Presenters!Samples! !
!Chat methodsFor!

acceptCalls
	"Private - Monitor the port for a connection request. If the port is already in use then we'll
	receive an error and can display an 'Unable to receive calls' status message."

	acceptSocket := [ServerSocket2 port: self defaultPort backlog: 0] on: SocketError
				do: [:ex | nil].
	self setAcceptStatus.
	acceptSocket isNil ifFalse: [self forkAccepter]!

appendMessage: anAssociation 
	"Private - An incoming message of aString has been received so we append this to the message
	display"

	| newMessage msgString partyString |
	msgString := anAssociation value.
	partyString := anAssociation key.
	newMessage := '<1s> says:<N><2s><N>---<N>' expandMacrosWith: partyString with: msgString.
	messageDisplay caretPosition: 0.
	messageDisplay replaceSelection: newMessage!

calleeAddress
	"Answer the proposed connection address. If the address starts with a digit we'll assume
	that it is an IP address. Otherwise let's assume a host name"

	^InternetAddress fromString: calleeAddress value!

canConnect
	"Answer true if the receiver could attempt a connect. This is the case if we are not already
	in a call and have at least something in the calleeAddress."

	| addr localHost |
	self isIdle ifFalse: [^false].
	addr := [self calleeAddress] on: InvalidFormat do: [:ex | nil].
	addr isNil ifTrue: [^false].
	"If can't accept connections, then cannot connect to self"
	acceptSocket isNil ifTrue: [^true].
	"Check not attempting to connect to self..."
	localHost := InternetAddress localHost.
	^((Array 
		with: localHost displayString asLowercase
		with: localHost ipString
		with: '127.0.0.1'
		with: 'localhost') includes: addr displayString asLowercase) 
		not!

closeConnection
	"Private - Forcibly any connection with another chat window.
	Answer whether the connection was actually closed (i.e. 
	the answer will only be true if the connection was previously
	open)."

	socket isNil ifTrue: [^false].
	socket close.
	"Send a dummy message to wake up the send thread so that it terminates - the sender might
	not notice that the socket is closed until the next time it tries to send because it is
	blocked on the SharedQueue, not blocked on the socket (unlike the read process, which is
	blocked in the socket recv())"
	sendQueue nextPut: nil.
	socket := sendQueue := nil.
	^true!

connect
	"Attempt to connect to another chat window using the current calleeAddress. This call blocks
	until some response is received from the connection request."

	| sock |
	sock := Socket2 port: self defaultPort address: self calleeAddress.
	self status: #connecting.
	self invalidateUserInterface.
	self forkConnector: sock!

connectFailed: aSocketError 
	MessageBox errorMsg: aSocketError messageText
		caption: ('Unable to connect to <1d>' expandMacrosWith: self calleeAddress).
	self setAcceptStatus!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	calleeAddress := self add: TextPresenter new name: 'calleeAddress'.
	outgoingMessage := self add: TextPresenter new name: 'outgoingMessage'.
	status := #initializing asValue.!

createSchematicWiring
	"Create the trigger wiring for the receiver"

	super createSchematicWiring.
	SessionManager current 
		when: #sessionStarted
		send: #onStartup
		to: self!

defaultPort
	"Answer the default port to use for chatting."

	^120!

disconnect
	"Disconnect from any other chat window and wait for new calls"

	self closeConnection!

dontAcceptCalls
	"Private - Cancel acceptance of calls. This closes the acceptance server socket and is generally
	performed when in a call (to prevent other calls from being accepted) and when the chat presenter
	is itself closed."

	| sock |
	acceptSocket isNil ifTrue: [^self].
	sock := acceptSocket.
	acceptSocket := nil.
	sock close!

enqueueConnected: aSocket2 
	"Private - Inform the main UI thread that a connection has been established over the <Socket2> argument."

	[self socketConnected: aSocket2] postToMessageQueue!

enqueueDisconnect
	"Private - Request the main thread  to close the socket.
	This is used by the sending process when it encounters an error sending data to 
	the peer."

	[self closeConnection] postToMessageQueue!

enqueueDisconnected
	"Private - Closure of the socket has been detected by the send or receive thread. Inform the main thread
	so that it can tidy up."

	[self socketDisconnected] postToMessageQueue!

enqueueInboundMessage: anAssociation 
	"Private - Enqueue the inbound message represented by the <Assocation> argument 
	to the input queue for subsequent processing by the main UI thread. The key of the
	<Association> is the name of the sender, and the value is the message body."

	[self messageReceived: anAssociation] postToMessageQueue!

enqueueOutboundMessage: anAssociation 
	"Private - Enqueue the outbound message represented by the <Assocation> argument 
	to the output queue for subsequent processing by the sender thread.The key of the
	<Association> is the name of the sender, and the value is the message body."

	sendQueue nextPut: anAssociation!

forkAccepter
	"Private - Start the accept thread that listens for inbound connections.This only listens once, 
	since we only handle one connection at a time, and then shuts down. Once connected 
	other threads are forked to manage the sending and receiving of messages over the socket."

	
	[| sock |
	sock := [acceptSocket accept] on: SocketWaitCancelled
				do: 
					[:ex | 
					"Socket closed"
					nil].
	self dontAcceptCalls.
	sock notNil ifTrue: [self enqueueConnected: sock]] 
			fork!

forkConnector: aSocket2 
	"Private - Start a background thread to connect to the remote peer. A background thread is used
	 because the operation may take a while (particularly if it fails) and we don't want to block	
	the main UI thread in the meantime. The thread will only run for the duration of the connection
	attempt. Once connected other threads are forked to manage the sending and receiving of
	messages over the socket."

	
	[
	[aSocket2 connect.
	self enqueueConnected: aSocket2] on: SocketError
			do: 
				[:ex | 
				SessionManager current logError: ex.
				[self connectFailed: ex] postToMessageQueue]] 
			fork!

forkReceiverOn: aStream 
	"Private - Start the receiver thread. This is responsible for asynchronously reading
	complete messages from the remote peer. Once the thread has read a complete message, it
	dispatches it to the UI process (for asychronous display) via the 'deferred action' queue (a
	<SharedQueue> that is read in synchronisation with the Windows' message queue)."

	[[self receiveMessagesOn: aStream] ensure: [self enqueueDisconnected]] fork!

forkSender
	"Private - Start the sender thread. This is responsible for asynchronously sending any
	messages it receives via a <SharedQueue> to the remote peer."

	sendQueue := SharedQueue new.
	
	[self senderMain.
	self enqueueDisconnect] fork!

isBusy
	^#(#initializing #connecting) includes: self status!

isConnected
	"Answer true if the receiver is currently engaged in a conversation"

	^self status == #connected!

isIdle
	"Answer true if the receiver is currently waiting for a conversation to be initiated."

	^#(#waiting #listening) includes: self status!

messageReceived: anAssociation 
	"Private - Accepts aString as the incoming message.
	N.B. This should only be invoked from the main UI thread."

	self assert: [Processor activeProcess == SessionManager inputState main].
	self appendMessage: anAssociation!

onGetCursor: aSymbol 
	"The named area of the view associated with the receiver has been hit.
	If the initializing or connection then display the wait cursor."

	^self isBusy ifTrue: [Cursor wait] ifFalse: [super onGetCursor: aSymbol]!

onStartup
	"Private - The image has just started. Set up the receiver appropriately."

	self disconnect!

onViewClosed
	"Private - Sent by the receiver's view when it has been closed"

	self
		dontAcceptCalls;
		closeConnection.
	super onViewClosed!

onViewOpened
	"Private - The receiver is ready to go so start accepting calls."

	super onViewOpened.
	messageDisplay := self view viewNamed: 'messageDisplay'.
	(self view viewNamed: 'status') model: (ValueConverter subject: status
				typeConverter: (MappingConverter leftToRight: Statii)).
	self acceptCalls!

peerAddress
	^socket peerAddress displayString!

queryCommand: query 
	"Private - Enters details about a potential command for the receiver into the 
	<CommandQuery>,  query."

	| cmd |
	cmd := query commandSymbol.
	cmd == #connect 
		ifTrue: 
			[query isEnabled: self canConnect.
			^true].
	(#(#disconnect #send) includes: cmd) 
		ifTrue: 
			[query isEnabled: self isConnected.
			^true].
	^super queryCommand: query!

receiveMessagesOn: aStream 
	"Receive messages from the specified <gettableStream>, which is presumably connected to a Socket,
	until the stream is exhausted. The messages are read as objects using STB, but we are careful to use
	a validating in-filer to avoid creating a security hole that might execute code."

	
	[| filer validClasses |
	validClasses := #(#Association #String).
	filer := (STBValidatingInFiler on: aStream)
				validationBlock: [:className | validClasses identityIncludes: className];
				yourself.
	
	[| message |
	message := filer next.
	self enqueueInboundMessage: message] repeat] 
			on: Stream endOfStreamSignal
			do: [:ex | ]!

send
	"Send the current outgoing message to the remote socket"

	| msg |
	msg := self userName -> outgoingMessage value.
	self appendMessage: msg.
	self enqueueOutboundMessage: msg.
	outgoingMessage
		clear;
		setFocus!

senderMain
	"Private - Main loop of sender thread. Note how we use an STBOutFiler to simplify
	transimssion of an arbitrary message format - of course this will only work if the peer is
	also written in Dolphin, but it is secure (unlike the old Chat) because we use a validating
	in-filer to guard against executing code in any malicious messages that might be sent."

	
	[| filer |
	filer := STBOutFiler on: socket writeStream.
	
	[| msg |
	msg := sendQueue next.
	filer nextPut: msg.
	"The stream is buffered, so we have to flush it or the message won't get transmitted immediately"
	filer stream flush] 
			repeat] 
			on: SocketError
			do: [:ex | ]!

setAcceptStatus
	acceptSocket isNil 
		ifTrue: [self status: #waiting]
		ifFalse: [self status: #listening]!

socketConnected: aSocket2 
	self assert: [self isConnected not].
	"We leave the socket in its default binary mode, as we're going to be using STB to transmit/receive objects over the socket."
	socket := aSocket2.
	self dontAcceptCalls.
	self forkReceiverOn: socket readStream.
	self forkSender.
	messageDisplay clear.
	calleeAddress value: self peerAddress.
	self status: #connected.
	"Must validate before attempting to set focus, as can't set focus to a disabled view."
	self validateUserInterface.
	outgoingMessage setFocus!

socketDisconnected
	"Private - Closure of the socket has been detected by the receiver thread, tidy up in the context of the main thread..
	This may have been locally or remotely initiated."

	self closeConnection.
	"The socket may have been disconnected as a result of the view having been closed - we
	obviously don't want to accept further calls in that case"
	self isOpen ifFalse: [^self].
	self acceptCalls.
	self validateUserInterface.
	calleeAddress setFocus!

status
	"Answer the receiver's current state."

	^status value!

status: aSymbol 
	"Sets the receiver's current state"

	self status == aSymbol ifTrue: [^self].
	status value: aSymbol.
	self invalidateUserInterface!

userName
	^SessionManager current userName!

validateUserInterface
	"Set the state of the receiver accordingly. This method is sent at judicious times
	in an attempt to ensure that the receivers state is up to date. "

	super validateUserInterface.
	calleeAddress view isEnabled: self isIdle.
	outgoingMessage view isEnabled: self isConnected! !
!Chat categoriesFor: #acceptCalls!operations!private! !
!Chat categoriesFor: #appendMessage:!operations!private! !
!Chat categoriesFor: #calleeAddress!accessing!public! !
!Chat categoriesFor: #canConnect!public!testing! !
!Chat categoriesFor: #closeConnection!operations!private! !
!Chat categoriesFor: #connect!commands!public! !
!Chat categoriesFor: #connectFailed:!helpers!private! !
!Chat categoriesFor: #createComponents!initializing!public! !
!Chat categoriesFor: #createSchematicWiring!initializing!public! !
!Chat categoriesFor: #defaultPort!accessing!constants!public! !
!Chat categoriesFor: #disconnect!commands!public! !
!Chat categoriesFor: #dontAcceptCalls!operations!private! !
!Chat categoriesFor: #enqueueConnected:!operations!private! !
!Chat categoriesFor: #enqueueDisconnect!helpers!private! !
!Chat categoriesFor: #enqueueDisconnected!helpers!private! !
!Chat categoriesFor: #enqueueInboundMessage:!helpers!private! !
!Chat categoriesFor: #enqueueOutboundMessage:!helpers!private! !
!Chat categoriesFor: #forkAccepter!operations!private! !
!Chat categoriesFor: #forkConnector:!operations!private! !
!Chat categoriesFor: #forkReceiverOn:!private! !
!Chat categoriesFor: #forkSender!helpers!private! !
!Chat categoriesFor: #isBusy!event handling!public! !
!Chat categoriesFor: #isConnected!public!testing! !
!Chat categoriesFor: #isIdle!public!testing! !
!Chat categoriesFor: #messageReceived:!operations!private! !
!Chat categoriesFor: #onGetCursor:!event handling!public! !
!Chat categoriesFor: #onStartup!event handling!private! !
!Chat categoriesFor: #onViewClosed!event handling!private! !
!Chat categoriesFor: #onViewOpened!event handling!private! !
!Chat categoriesFor: #peerAddress!private! !
!Chat categoriesFor: #queryCommand:!commands!private! !
!Chat categoriesFor: #receiveMessagesOn:!private! !
!Chat categoriesFor: #send!commands!public! !
!Chat categoriesFor: #senderMain!operations!private! !
!Chat categoriesFor: #setAcceptStatus!operations!private! !
!Chat categoriesFor: #socketConnected:!helpers!private! !
!Chat categoriesFor: #socketDisconnected!helpers!private! !
!Chat categoriesFor: #status!accessing!public! !
!Chat categoriesFor: #status:!accessing!public! !
!Chat categoriesFor: #userName!operations!private! !
!Chat categoriesFor: #validateUserInterface!operations!public! !

!Chat class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^##(TextTileIcon text: $\x1F5E3 fontName: 'Segoe UI Emoji' color: (ARGB named: #teal))!

initialize
	"Private - Initialize the receiver's class variables
		self initialize
	"

	Smalltalk developmentSystem 
		addSamplesFolderIconFor: self
		description: self sampleDescription
		helpId: 10610.
	Statii := IdentityDictionary new.
	Statii
		at: #initializing put: 'Initializing...';
		at: #listening put: 'Waiting for call...';
		at: #waiting put: 'Unable to receive calls';
		at: #connecting put: 'Connecting...';
		at: #connected put: 'Connected';
		shrink!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ContainerView) 34 15 nil nil 34 2 8 1140850688 131073 416 nil 786694 ##(Smalltalk.ColorDefault) 8 4278190080 nil 7 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 560 nil 721158 ##(Smalltalk.SystemColor) 31 328198 ##(Smalltalk.Point) 1041 241 7 nil nil nil 560 852230 ##(Smalltalk.FramingLayout) 170 176 34 14 410 ##(Smalltalk.StaticText) 34 16 nil 560 34 2 8 1140850944 1 752 nil nil nil 7 nil nil nil 752 nil 8 1915124368 852486 ##(Smalltalk.NullConverter) nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 658 11 91 658 211 51 752 930 #text: 34 1 8 '&Message:' 752 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 45 0 0 0 110 0 0 0 70 0 0 0] 8 #() 658 193 193 nil 27 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedParentLeft 11 1170 #fixedViewLeft 211 1170 #fixedParentTop 91 1170 #fixedViewTop 51 410 ##(Smalltalk.PushButton) 34 20 nil 560 34 2 8 1140924416 1 1248 nil 496 nil 7 nil nil nil 1248 nil 8 1915188384 1180998 4 ##(Smalltalk.CommandDescription) #disconnect 8 '&Disconnect' 1 1 nil nil false nil nil nil 866 138 144 34 2 930 #createAt:extent: 34 2 658 961 165 658 161 51 1248 930 #text: 34 1 8 '&Disconnect' 1248 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 224 1 0 0 82 0 0 0 48 2 0 0 107 0 0 0] 8 #() 1120 nil 29 1138 1170 #fixedParentRight -179 1200 161 1216 165 1232 51 410 ##(Smalltalk.PushButton) 34 20 nil 560 34 2 8 1140924416 1 1616 nil 496 nil 7 nil nil nil 1616 nil 8 1915188384 1330 #connect 8 '&Connect' 1 5 nil nil true nil nil nil 866 138 144 34 2 930 #createAt:extent: 34 2 658 961 15 658 161 51 1616 930 #text: 34 1 8 '&Connect' 1616 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 224 1 0 0 7 0 0 0 48 2 0 0 32 0 0 0] 8 #() 1120 nil 29 1138 1600 -179 1200 161 1216 15 1232 51 410 ##(Smalltalk.PushButton) 34 20 nil 560 34 2 8 1140924416 1 1952 nil 496 nil 7 nil nil nil 1952 nil 8 1915188384 1330 #send 8 '&Send' 1 1 nil nil false nil nil nil 866 138 144 34 2 930 #createAt:extent: 34 2 658 961 85 658 161 51 1952 930 #text: 34 1 8 '&Send' 1952 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 224 1 0 0 42 0 0 0 48 2 0 0 67 0 0 0] 8 #() 1120 nil 29 1138 1600 -179 1200 161 1216 85 1232 51 410 ##(Smalltalk.StaticText) 34 16 nil 560 34 2 8 1140850944 1 2288 nil nil nil 7 nil nil nil 2288 nil 8 1915124368 834 nil nil nil 866 138 144 34 2 930 #createAt:extent: 34 2 658 11 11 658 221 51 2288 930 #text: 34 1 8 'Chat to &address:' 2288 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 115 0 0 0 30 0 0 0] 8 #() 1120 nil 27 1138 1184 11 1200 221 1216 11 1232 51 410 ##(Smalltalk.MultilineTextEdit) 34 16 nil 560 34 2 8 1143017796 1025 2608 nil 496 nil 7 nil nil nil 2608 nil 8 1915280032 834 nil nil 9 866 138 144 34 1 930 #createAt:extent: 34 2 658 231 81 658 681 131 2608 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 115 0 0 0 40 0 0 0 199 1 0 0 105 0 0 0] 8 #() 1120 nil 27 1138 1184 231 1600 -229 1216 81 1232 131 410 ##(Smalltalk.TextEdit) 34 16 nil 560 34 2 8 1140916224 1025 2880 nil 496 nil 7 nil nil nil 2880 nil 8 1915280032 834 nil nil 1 866 138 144 34 1 930 #createAt:extent: 34 2 658 231 11 658 681 51 2880 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 115 0 0 0 5 0 0 0 199 1 0 0 30 0 0 0] 8 #() 1120 nil 27 1138 1184 231 1600 -229 1216 11 1232 51 170 192 34 4 2608 8 'outgoingMessage' 2880 8 'calleeAddress' 590342 ##(Smalltalk.Rectangle) 658 1 1 658 1 1 866 138 144 34 1 930 #createAt:extent: 34 2 658 1 1 658 1141 241 560 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 58 2 0 0 120 0 0 0] 34 7 2880 1616 2608 1952 1248 2288 752 1120 nil 27 410 ##(Smalltalk.StatusBar) 34 18 nil 416 34 2 8 1140850956 1 3440 nil 496 nil 7 nil nil nil 3440 nil 8 1914952576 170 192 34 2 853766 ##(Smalltalk.StatusBarItem) 1 -1 3440 nil 787814 3 ##(Smalltalk.BlockClosure) 0 nil 918822 ##(Smalltalk.CompiledMethod) 2 3 3552 #defaultGetTextBlock 468040131 8 #[30 105 226 0 106] #displayString 3600 7 257 nil nil nil 8 'status' 34 1 3568 1115142 ##(Smalltalk.StatusBarNullItem) 513 1 3440 nil nil 866 138 144 34 1 930 #createAt:extent: 34 2 658 1 601 658 1141 41 3440 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 44 1 0 0 58 2 0 0 64 1 0 0] 8 #() 1120 nil 27 nil nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 416 34 2 8 1142947908 1025 3888 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil 196934 1 ##(Smalltalk.RGB) 25231361 nil 7 nil nil nil 3888 nil 8 1919505872 834 nil nil 3 nil 655622 ##(Smalltalk.EDITSTREAM) 8 #[0 0 0 0 0 0 0 0 32 0 17 4] 866 138 144 34 5 930 #createAt:extent: 34 2 658 1 241 658 1141 361 3888 930 #text: 34 1 524550 ##(Smalltalk.RichText) 8 '{\urtf1\ansi\ansicpg1252\deff0{\fonttbl{\f0\fnil\fcharset0 Microsoft Sans Serif;}}
\viewkind4\uc1\pard\lang2057\f0\fs16\par
}
' 3888 930 #isTextModified: 8 #(true) 3888 930 #textLimit: 8 #(1073741823) 3888 930 #resetCharFormat 8 #() 3888 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 120 0 0 0 58 2 0 0 44 1 0 0] 8 #() 1120 nil 27 170 192 34 2 3888 8 'messageDisplay' nil 866 138 144 34 1 930 #createAt:extent: 34 2 658 3839 21 658 1141 641 416 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 185 9 0 0 74 1 0 0] 34 3 560 3888 3440 1120 nil 27 )!

sampleDescription
	"Private - Answer the description of the receiver to be used in the samples folder."

	^'Sockets Chat'! !
!Chat class categoriesFor: #icon!constants!public! !
!Chat class categoriesFor: #initialize!development!initializing!private! !
!Chat class categoriesFor: #resource_Default_view!public!resources-views! !
!Chat class categoriesFor: #sampleDescription!constants!development!private! !

