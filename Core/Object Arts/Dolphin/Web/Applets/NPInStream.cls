"Filed out from Dolphin Smalltalk 7"!

NPStream subclass: #NPInStream
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
NPInStream guid: (GUID fromString: '{2648c8a2-6b87-11d3-97bb-0080c8d59432}')!
NPInStream comment: 'An NPInStream is a stream object created by the web browser and supplied to the Dolphin plug-in. It is used for transferring data from the browser to the plug-in.'!
!NPInStream categoriesForClass!Plugin-Support! !
!NPInStream methodsFor!

isAsFileMode
	"Answer whether the mode of the stream matches NP_ASFILE. In this
	mode a series of pluginWriteReady and pluginWrite notifications are received
	followed by a pluginStreamAsFile."

	^self mode == NP_ASFILE!

isAsFileOnlyMode
	"Answer whether the mode of the stream matches NP_ASFILEONLY. In this
	mode the receiver's is only informed when the url contents have been
	copied to a local file with the pluginStreamAsFile message.

	Introduced with Netscape 3.0"

	^self mode == NP_ASFILEONLY!

isNormalMode
	"Answer whether the mode of the stream matches NP_NORMAL. In this
	mode a series of pluginWriteReady and pluginWrite notifications are received.
	This is the default mode if you have not modified it during the onNewStream:...
	notification."

	^self mode == NP_NORMAL!

isSeekMode
	"Answer whether the mode of the stream matches NP_SEEK."

	^self mode == NP_SEEK!

requestReadFrom: start to: end
	"Requests a range of bytes from the receiver's stream
	to be delivered through a series of onWriteReady: and
	#onWrite: notifications. An HRESULTError exception
	will be raised if the request could not be satisfied."

	npStream RequestRead: start-1 Length: (start to: end) size! !
!NPInStream categoriesFor: #isAsFileMode!public!testing! !
!NPInStream categoriesFor: #isAsFileOnlyMode!public!testing! !
!NPInStream categoriesFor: #isNormalMode!public!testing! !
!NPInStream categoriesFor: #isSeekMode!public!testing! !
!NPInStream categoriesFor: #requestReadFrom:to:!operations!public! !

