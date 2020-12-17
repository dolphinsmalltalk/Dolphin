"Filed out from Dolphin Smalltalk 7"!

Net.SocketError subclass: #'Net.SocketWaitCancelled'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Net.SocketWaitCancelled guid: (Core.GUID fromString: '{87b4c56b-026e-11d3-9fd7-00a0cc3e4a32}')!
Net.SocketWaitCancelled comment: 'This exception signals that a wait on a blocking Socket operation has been explicitly cancelled.'!
!Net.SocketWaitCancelled categoriesForClass!Windows Sockets! !
!Net.SocketWaitCancelled methodsFor!

description
	"Answer a String describing the error which the receiver represents."

	^'Socket wait cancelled'! !
!Net.SocketWaitCancelled categoriesFor: #description!displaying!public! !

!Net.SocketWaitCancelled class methodsFor!

errorCode
	^WSAEINTR!

initialize
	ErrorClasses at: self errorCode put: self!

uninitialize
	ErrorClasses removeKey: self errorCode ifAbsent: []! !
!Net.SocketWaitCancelled class categoriesFor: #errorCode!constants!private! !
!Net.SocketWaitCancelled class categoriesFor: #initialize!initializing!public! !
!Net.SocketWaitCancelled class categoriesFor: #uninitialize!class hierarchy-removing!public! !

