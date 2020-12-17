"Filed out from Dolphin Smalltalk 7"!

View subclass: #WinAsyncSocket
	instanceVariableNames: '_reserved1 _reserved2'
	classVariableNames: 'DefaultInstance SocketMessageMap UserMessageMap WsaEvent WsaHostInfo'
	poolDictionaries: 'WinSocketConstants'
	classInstanceVariableNames: ''
	classConstants: {}!
WinAsyncSocket guid: (GUID fromString: '{87b4c717-026e-11d3-9fd7-00a0cc3e4a32}')!
WinAsyncSocket comment: '** This class is part of the old asynchronous Sockets Connection package which has been superseded by the Dolphin Sockets package **

WinAsyncSocket  represents a hidden singleton <view> capable of receiving callbacks from the Windows WSA asynchronous socket library functions. Its singleton instance receives notifications of WSA_XXX events by means of Windows messages. These notifications are interpreted and then passed on to the appropriate handler methods within a <SocketAbstract>. 

Instance Variables:
	acceptSemaphore		<Semaphore> reserved for future use.
	hostInfoSemaphore		<Semaphore> reserved for future use.

Class Variables:
	SocketMessageMap		<IdentityDictionary> mapping Windows socket messages to <selector>s.
	UserMessageMap		<IdentityDictionary> mapping Windows user socket messages to <selector>s.
	WsaEvent			<integer> Windows message for WSA events.
	WsaHostInfo		<integer> Windows message for WSA host information.
	DefaultInstance		<WinAsyncSocket> which is the singleton instance of this class.

'!
!WinAsyncSocket categoriesForClass!Windows Sockets! !
!WinAsyncSocket methodsFor!

cancelSocket: aSocket 
	"Private - Cancel any outstanding asynchronous calls."

	| result |
	result := WSockLibrary default 
				wsaAsyncSelect: aSocket asParameter
				hWnd: self asParameter
				wMsg: 0
				lEvent: 0.
	result = 0 ifFalse: [self error]!

defaultExtent
	"Answer the default size of the receiver"

	^400 @ 100!

dispatchUser: userId wParam: wParam lParam: lParam 
	"Private - The message WM_USER+userId was sent to the receiver,
	the actual message defined by wParam and lParam.
	Here we make use of the WinWindow helper function
	to dispatch via our local message map."

	^self 
		dispatchUser: userId
		wParam: wParam
		lParam: lParam
		map: UserMessageMap!

error
	"Private - Throw a SocketError exception.
	The actual error code will be retrieved during the SocketError instantiation."

	SocketError signal!

monitorSocket: aSocket 
	"Register an interest in accept, read, write and close events."

	| result |
	result := WSockLibrary default 
				wsaAsyncSelect: aSocket asParameter
				hWnd: self asParameter
				wMsg: WsaEvent
				lEvent: FD_ACCEPT | FD_READ | FD_WRITE | FD_CLOSE | FD_CONNECT.
	result = 0 ifFalse: [self error]!

wsaEvent: message wParam: wParam lParam: lParam 
	"Private - Handles the notification of a WSA event.
	Determine which socket the notification is for, and
	send it the appropriate notification message."

	| error socketDescriptor socket event selector |
	socketDescriptor := wParam.
	socket := SocketAbstract fromDescriptor: socketDescriptor.
	socket isNil ifTrue: [^nil].
	error := lParam highWord.
	error = 0 
		ifFalse: 
			[socket onAsyncError: error.
			^nil].
	event := lParam lowWord.
	selector := SocketMessageMap at: event ifAbsent: nil.
	selector notNil ifTrue: [socket perform: selector]! !
!WinAsyncSocket categoriesFor: #cancelSocket:!operations!private! !
!WinAsyncSocket categoriesFor: #defaultExtent!constants!public! !
!WinAsyncSocket categoriesFor: #dispatchUser:wParam:lParam:!dispatching!private! !
!WinAsyncSocket categoriesFor: #error!exceptions!private! !
!WinAsyncSocket categoriesFor: #monitorSocket:!operations!public! !
!WinAsyncSocket categoriesFor: #wsaEvent:wParam:lParam:!event handling-win32!private! !

!WinAsyncSocket class methodsFor!

default
	"Answers the singleton instance."

	DefaultInstance isNil 
		ifTrue: 
			[DefaultInstance := (self new)
						parentView: View desktop;
						create;
						yourself].
	^DefaultInstance!

defaultWmUserOffset
	"Private - Answers the default offset to be added to WM_USER to avoid collisions."

	^1000!

initialize
	self onStartup!

onStartup
	"Private - Perform any startup operations."

	| socketMessageBase |
	socketMessageBase := WM_USER + self defaultWmUserOffset.
	WsaEvent := socketMessageBase + 0.
	WsaHostInfo := socketMessageBase + 1.
	UserMessageMap := (IdentityDictionary new)
				at: WsaEvent - WM_USER put: #wsaEvent:wParam:lParam:;
				shrink;
				yourself.
	SocketMessageMap := (IdentityDictionary new)
				at: FD_CLOSE put: #onAsyncClose;
				at: FD_READ put: #onAsyncRead;
				at: FD_WRITE put: #onAsyncWrite;
				at: FD_ACCEPT put: #onAsyncAccept;
				at: FD_CONNECT put: #onAsyncConnect;
				shrink;
				yourself.

	"Ensure the singleton is recreated."
	DefaultInstance := nil!

uninitialize
	"Private - Uninitialize the receiver as it is about to be removed from the system."

	DefaultInstance notNil 
		ifTrue: 
			[DefaultInstance destroy.
			DefaultInstance := nil]! !
!WinAsyncSocket class categoriesFor: #default!accessing!public! !
!WinAsyncSocket class categoriesFor: #defaultWmUserOffset!constants!private! !
!WinAsyncSocket class categoriesFor: #initialize!initializing!private! !
!WinAsyncSocket class categoriesFor: #onStartup!initializing!private! !
!WinAsyncSocket class categoriesFor: #uninitialize!class hierarchy-removing!private! !

