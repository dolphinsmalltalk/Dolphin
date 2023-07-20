"Filed out from Dolphin Smalltalk"!

UI.Presenter
	subclass: #'Net.Examples.Chat'
	instanceVariableNames: 'calleeAddress outgoingMessage messageDisplay status socket acceptSocket sendQueue outgoingPort incomingPort'
	classVariableNames: 'Statii'
	imports: #(#{UI})
	classInstanceVariableNames: ''
	classConstants: {}!
Net.Examples.Chat guid: (Core.GUID fromString: '{87b4c699-026e-11d3-9fd7-00a0cc3e4a32}')!
Net.Examples.Chat comment: 'Chat is a <compositePresenter> implementing a simple "chat" service for the purpose of demonstrating the use of the new blocking Dolphin Sockets API. It has a multi-threaded design that would be appropriate for more complex socket client/server applications too. Finally Chat illustrates the use of STB-based messaging, which provides for a simple and efficient way to transmit and receive objects over a socket connection. An instance can be opened on any machine running TCP/IP using:

```
	Chat show.
```

This will connect to a TCP/IP port (given by #defaultPort) and start a background process to wait for incoming connections from another Chat window. Ideally the other Chat instance will be created on separate machine, if one is available. However, more than one Chat instance can be created on a single machine but in this case only the first will be able to receive incoming calls since this will be the one that grabs the connection port. To run both ends of the Chat session on one machine, specify non-default ports for one of the connection directions as follows:

```
	chat1 := Chat show 
		outgoingPort: 121.
	chat2 := Chat show
		incomingPort: 121.
```

To establish a Chat session, enter the target machine name or IP address (e.g. localhost if on the same machine) and click Connect. When a connection has successfully been established a pair of threads are forked to manage sending and receiving of messages across the bidirectional socket. Outbound messages are communicated to the sender thread through a shared queue. The sender is responsible for dequeueing messages and forwarding to the remote peer, which it does by writing them to the socket''s buffered write stream. When the complete message has been written the stream is flushed so that the message is transmitted, an  operation which may block the sender thread.  The receiver thread is responsible for receiving complete messages from the socket, and enqueuing them for asynchronous display by the UI process. Note that there is no shared queue for the inbound messages, since the deferred action mechanism process by the InputState object provides this capability in a convenient way for the UI thread.

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
!Net.Examples.Chat categoriesForClass!MVP-Presenters!Samples! !
!Net.Examples.Chat methodsFor!

acceptCalls
	"Private - Monitor the port for a connection request. If the port is already in use then we'll
	receive an error and can display an 'Unable to receive calls' status message."

	acceptSocket := [Net.ServerSocket port: self incomingPort backlog: 0] on: Net.SocketError
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
	self incomingPort = self outgoingPort ifFalse: [^true].
	"Check not attempting to connect to self..."
	localHost := InternetAddress localHost.
	^({localHost displayString asLowercase. localHost ipString. '127.0.0.1'. 'localhost'}
		includes: addr displayString asLowercase) not!

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
	sock := Net.Socket port: self outgoingPort address: self calleeAddress.
	self status: #connecting.
	self invalidateUserInterface.
	self forkConnector: sock!

connectFailed: aSocketError
	MessageBox new
		headline: 'Unable to connect to <1d>' << self calleeAddress;
		errorMsg: aSocketError messageText.
	self setAcceptStatus!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	calleeAddress := self add: TextPresenter new name: 'calleeAddress'.
	outgoingMessage := self add: TextPresenter new name: 'outgoingMessage'.
	status := #initializing asValue!

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
	sock := [acceptSocket accept] on: Net.SocketWaitCancelled
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
	self enqueueConnected: aSocket2] on: Net.SocketError
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

incomingPort
	^incomingPort ?? self defaultPort!

incomingPort: anInteger
	incomingPort := anInteger!

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

outgoingPort
	^outgoingPort ?? self defaultPort!

outgoingPort: anInteger
	outgoingPort := anInteger!

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

	
	[| filer |
	"The messages are a pair of strings in an Assocation. We don't allow any other objects to be deserialised."
	filer := (Kernel.STBValidatingInFiler on: aStream)
				validClasses: #(#{Core.Association} #{Core.AnsiString} #{Core.Utf8String} #{Core.Utf16String});
				yourself.
	
	[| message |
	message := filer next.
	self enqueueInboundMessage: message.
	filer stream atEnd]
			whileFalse: [filer reset]]
			on: Kernel.STBError
			do: [:ex | self enqueueInboundMessage: 'Chat' -> ex description]
			on: Stream endOfStreamSignal
			do: [:ex | self enqueueInboundMessage: 'Chat' -> 'Disconnected']!

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
	"For interop with D7 Chat client"
	filer := Kernel.STBOutFiler on: socket writeStream version: 4.
	
	[| msg |
	msg := sendQueue next.
	filer nextPut: msg.
	"The stream is buffered, so we have to flush it or the message won't get transmitted immediately"
	filer stream flush.
	filer reset]
			repeat]
			on: Net.SocketError
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
	messageDisplay clearAll.
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
	in an attempt to ensure that the receiver's state is up to date. "

	super validateUserInterface.
	calleeAddress view isEnabled: self isIdle.
	outgoingMessage view isEnabled: self isConnected! !
!Net.Examples.Chat categoriesForMethods!
acceptCalls!operations!private! !
appendMessage:!operations!private! !
calleeAddress!accessing!public! !
canConnect!public!testing! !
closeConnection!operations!private! !
connect!commands!public! !
connectFailed:!helpers!private! !
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
defaultPort!accessing!constants!public! !
disconnect!commands!public! !
dontAcceptCalls!operations!private! !
enqueueConnected:!operations!private! !
enqueueDisconnect!helpers!private! !
enqueueDisconnected!helpers!private! !
enqueueInboundMessage:!helpers!private! !
enqueueOutboundMessage:!helpers!private! !
forkAccepter!operations!private! !
forkConnector:!operations!private! !
forkReceiverOn:!private! !
forkSender!helpers!private! !
incomingPort!accessing!public! !
incomingPort:!accessing!public! !
isBusy!event handling!public! !
isConnected!public!testing! !
isIdle!public!testing! !
messageReceived:!operations!private! !
onGetCursor:!event handling!public! !
onStartup!event handling!private! !
onViewClosed!event handling!private! !
onViewOpened!event handling!private! !
outgoingPort!accessing!public! !
outgoingPort:!accessing!public! !
peerAddress!private! !
queryCommand:!commands!private! !
receiveMessagesOn:!private! !
send!commands!public! !
senderMain!operations!private! !
setAcceptStatus!operations!private! !
socketConnected:!helpers!private! !
socketDisconnected!helpers!private! !
status!accessing!public! !
status:!accessing!public! !
userName!operations!private! !
validateUserInterface!operations!public! !
!

!Net.Examples.Chat class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^##(TextTileIcon
		text: $\x1F5E3
		fontName: 'Segoe UI Emoji'
		color: Color teal)!

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
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.ContainerView} 34 15 nil nil 34 2 8 1140850688 131073 416 nil 917510 #{Graphics.Color} #default nil 7 nil nil nil 416 984838 #{UI.BorderLayout} 1 1 410 #{UI.ContainerView} 34 15 nil 416 34 2 8 1140850688 131073 544 nil 482 #face3d 918022 #{Graphics.Point} 1041 241 7 nil nil nil 544 1048838 #{UI.FramingLayout} 170 176 34 14 410 #{UI.MultilineTextEdit} 34 16 nil 544 34 2 8 1143017796 1025 720 nil 496 nil 7 nil nil nil 720 nil 8 1815092992 1049094 #{UI.NullConverter} nil nil 9 1310982 #{Core.MessageSequence} 34 1 1049350 #{Core.MessageSend} #createAt:extent: 34 2 626 231 81 626 681 131 720 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 115 0 0 0 40 0 0 0 199 1 0 0 105 0 0 0] 8 #() 626 193 193 nil 27 1378374 2 #{UI.FramingConstraints} 1377286 #{UI.FramingCalculation} #fixedParentLeft 231 1074 #fixedParentRight -229 1074 #fixedParentTop 81 1074 #fixedViewTop 131 410 #{UI.PushButton} 34 20 nil 544 34 2 8 1140924416 1 1152 nil 496 nil 7 nil nil nil 1152 nil 8 1815097472 1377606 4 #{UI.CommandDescription} #connect 8 '&Connect' 1 5 nil nil true nil nil nil 834 34 2 882 #createAt:extent: 34 2 626 961 15 626 161 51 1152 882 #text: 34 1 8 '&Connect' 1152 962 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 224 1 0 0 7 0 0 0 48 2 0 0 32 0 0 0] 8 #() 1024 nil 29 1042 1104 -179 1074 #fixedViewLeft 161 1120 15 1136 51 410 #{UI.TextEdit} 34 16 nil 544 34 2 8 1140916224 1025 1504 nil 496 nil 7 nil nil nil 1504 nil 8 1815092992 802 nil nil 1 834 34 1 882 #createAt:extent: 34 2 626 231 11 626 681 51 1504 962 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 115 0 0 0 5 0 0 0 199 1 0 0 30 0 0 0] 8 #() 1024 nil 27 1042 1088 231 1104 -229 1120 11 1136 51 410 #{UI.StaticText} 34 16 nil 544 34 2 8 1140850944 1 1760 nil nil nil 7 nil nil nil 1760 nil 8 1815137184 802 nil nil nil 834 34 2 882 #createAt:extent: 34 2 626 11 11 626 221 51 1760 882 #text: 34 1 8 'Chat to &address:' 1760 962 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 115 0 0 0 30 0 0 0] 8 #() 1024 nil 27 1042 1088 11 1488 221 1120 11 1136 51 410 #{UI.PushButton} 34 20 nil 544 34 2 8 1140924416 1 2064 nil 496 nil 7 nil nil nil 2064 nil 8 1815097472 1234 #disconnect 8 '&Disconnect' 1 1 nil nil false nil nil nil 834 34 2 882 #createAt:extent: 34 2 626 961 165 626 161 51 2064 882 #text: 34 1 8 '&Disconnect' 2064 962 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 224 1 0 0 82 0 0 0 48 2 0 0 107 0 0 0] 8 #() 1024 nil 29 1042 1104 -179 1488 161 1120 165 1136 51 410 #{UI.StaticText} 34 16 nil 544 34 2 8 1140850944 1 2384 nil nil nil 7 nil nil nil 2384 nil 8 1815137184 802 nil nil nil 834 34 2 882 #createAt:extent: 34 2 626 11 91 626 211 51 2384 882 #text: 34 1 8 '&Message:' 2384 962 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 45 0 0 0 110 0 0 0 70 0 0 0] 8 #() 1024 nil 27 1042 1088 11 1488 211 1120 91 1136 51 410 #{UI.PushButton} 34 20 nil 544 34 2 8 1140924416 1 2688 nil 496 nil 7 nil nil nil 2688 nil 8 1815097472 1234 #send 8 '&Send' 1 1 nil nil false nil nil nil 834 34 2 882 #createAt:extent: 34 2 626 961 85 626 161 51 2688 882 #text: 34 1 8 '&Send' 2688 962 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 224 1 0 0 42 0 0 0 48 2 0 0 67 0 0 0] 8 #() 1024 nil 29 1042 1104 -179 1488 161 1120 85 1136 51 170 192 34 4 1504 8 'calleeAddress' 720 8 'outgoingMessage' 1180166 #{Graphics.Rectangle} 626 1 1 626 1 1 834 34 1 882 #createAt:extent: 34 2 626 1 1 626 1141 241 544 962 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 58 2 0 0 120 0 0 0] 34 7 1504 1152 720 2688 2064 1760 2384 1024 nil 27 410 #{UI.StatusBar} 34 21 nil 416 34 2 8 1140850956 1 3280 nil 496 nil 7 nil nil nil 3280 nil 8 1814628368 170 192 34 2 1050438 1 #{UI.StatusBarItem} 8193 -1 3280 nil 786950 #{Core.Message} #displayString 8 #() nil nil 8 'status' nil nil nil 34 1 3408 1311814 1 #{UI.StatusBarNullItem} 8705 1 3280 nil nil 834 34 1 882 #createAt:extent: 34 2 626 1 601 626 1141 41 3280 962 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 44 1 0 0 58 2 0 0 64 1 0 0] 8 #() 1024 nil 29 nil nil 410 #{UI.RichTextEdit} 34 18 nil 416 34 2 8 1142947908 1025 3680 918598 2 #{UI.ValueHolder} nil false 1769478 #{Kernel.EqualitySearchPolicy} nil 1245702 #{Graphics.ThemeColor} #smalltalkSystem nil 7 nil nil nil 3680 nil 8 1348699616 802 nil nil 3 nil 852230 #{OS.EDITSTREAM} 8 #[0 0 0 0 0 0 0 0 16 0 112 5] 834 34 5 882 #createAt:extent: 34 2 626 1 241 626 1141 361 3680 882 #text: 34 1 721158 #{UI.RichText} 8 '{\urtf1\ansi\ansicpg1252\deff0{\fonttbl{\f0\fnil\fcharset0 Microsoft Sans Serif;}}
\viewkind4\uc1\pard\lang2057\f0\fs16\par
}
' 3680 882 #isTextModified: 8 #(true) 3680 882 #textLimit: 8 #(1073741823) 3680 882 #resetCharFormat 3456 3680 962 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 120 0 0 0 58 2 0 0 44 1 0 0] 8 #() 1024 nil 27 170 192 34 2 3680 8 'messageDisplay' nil 834 34 1 882 #createAt:extent: 34 2 626 12287 21 626 1141 641 416 962 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 57 26 0 0 74 1 0 0] 34 3 544 3680 3280 1024 nil 27)!

sampleDescription
	"Private - Answer the description of the receiver to be used in the samples folder."

	^'Sockets Chat'! !
!Net.Examples.Chat class categoriesForMethods!
icon!constants!public! !
initialize!development!initializing!private! !
resource_Default_view!public!resources-views! !
sampleDescription!constants!development!private! !
!

