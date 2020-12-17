"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTest subclass: #'Net.Tests.SocketErrorTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.WinSocketErrors})
	classInstanceVariableNames: ''
	classConstants: {}!
Net.Tests.SocketErrorTest guid: (Core.GUID fromString: '{a421a921-77e2-485a-b403-fc20d4c13a43}')!
Net.Tests.SocketErrorTest comment: ''!
!Net.Tests.SocketErrorTest categoriesForClass!Unclassified! !
!Net.Tests.SocketErrorTest methodsFor!

testSocketClosed
	self should: [SocketError signalWith: WSAECONNRESET] raise: SocketClosed!

testSocketWaitCancelled
	self should: [SocketError signalWith: WSAEINTR] raise: SocketWaitCancelled!

testSocketWouldBlock
	self should: [SocketError signalWith: WSAEWOULDBLOCK] raise: SocketWouldBlock! !
!Net.Tests.SocketErrorTest categoriesFor: #testSocketClosed!public!unit tests! !
!Net.Tests.SocketErrorTest categoriesFor: #testSocketWaitCancelled!public!unit tests! !
!Net.Tests.SocketErrorTest categoriesFor: #testSocketWouldBlock!public!unit tests! !

