"Filed out from Dolphin Smalltalk 7"!

SocketError subclass: #SocketWaitCancelled
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
SocketWaitCancelled guid: (GUID fromString: '{87b4c56b-026e-11d3-9fd7-00a0cc3e4a32}')!
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

