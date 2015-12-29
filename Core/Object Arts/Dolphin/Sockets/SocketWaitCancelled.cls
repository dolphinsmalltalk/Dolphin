"Filed out from Dolphin Smalltalk X6.1"!

SocketError subclass: #SocketWaitCancelled
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SocketWaitCancelled guid: (GUID fromString: '{87B4C56B-026E-11D3-9FD7-00A0CC3E4A32}')!
SocketWaitCancelled comment: 'This exception signals that a wait on a blocking Socket operation has been explicitly cancelled.'!
!SocketWaitCancelled categoriesForClass!Windows Sockets! !
!SocketWaitCancelled methodsFor!

description
	"Answer a String describing the error which the receiver represents."

	^'Socket wait cancelled'! !
!SocketWaitCancelled categoriesFor: #description!displaying!public! !

!SocketWaitCancelled class methodsFor!

errorCode
	^WSAEINTR!

initialize
	ErrorClasses at: self errorCode put: self!

uninitialize
	ErrorClasses removeKey: self errorCode ifAbsent: []! !
!SocketWaitCancelled class categoriesFor: #errorCode!constants!private! !
!SocketWaitCancelled class categoriesFor: #initialize!initializing!public! !
!SocketWaitCancelled class categoriesFor: #uninitialize!class hierarchy-removing!public! !

