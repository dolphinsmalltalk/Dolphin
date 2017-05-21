"Filed out from Dolphin Smalltalk 7"!

NPStream subclass: #NPOutStream
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
NPOutStream guid: (GUID fromString: '{2648c8a3-6b87-11d3-97bb-0080c8d59432}')!
NPOutStream comment: 'An NPOutStream is a stream object created by the Dolphin plug-in and supplied to the web browser. It is used for transferring data from the plug-in to the browser and beyond. Such a stream is created with the #newStream:target:context: class method of NPStream and supports the <puttableStream> protocol.'!
!NPOutStream categoriesForClass!Plugin-Support! !
!NPOutStream methodsFor!

cr
	"Append a new line to the receiver."

	self nextPutAll: String lineDelimiter!

flush
	"No-op to allow non-FileStreams to be used interchangeably with FileStream."

	^self!

nextPut: anIntegerOrCharacter
	"Write anIntegerOrCharacter to the receiver and answer the argument."

	self write: (ByteArray with: anIntegerOrCharacter asInteger).
	^anIntegerOrCharacter!

nextPutAll: aStringOrByteArray
	"Write aStringOrByteArray to the receiver and answer the argument."

	self write: aStringOrByteArray.
	^aStringOrByteArray!

onDestroy: reason
	"Notification from the internet browser that a stream is being
	closed and deleted."

	self beUnfinalizable.
	^super onDestroy: reason.!

setApplet: anNPApplet npStream: aNPStream handler: streamHandler
	"Private - Initialize the identity instance variables of the receiver."

	super setApplet: anNPApplet npStream: aNPStream handler: streamHandler.
	self beFinalizable.!

space
	"Append a space to the receiver"

	self nextPut: $ .!

tab
	"Store a tab character as the next element of the receiver"

	self nextPut: Character tab
!

write: byteArray
	"Write the contents of byteArray to the stream. Answer the number
	of bytes consumed by the web browser. A negative value indicates
	that an error has occured and the stream should be destroyed."

	^npStream write: byteArray size buf: byteArray! !
!NPOutStream categoriesFor: #cr!accessing!public! !
!NPOutStream categoriesFor: #flush!accessing!public! !
!NPOutStream categoriesFor: #nextPut:!operations!public! !
!NPOutStream categoriesFor: #nextPutAll:!accessing!public! !
!NPOutStream categoriesFor: #onDestroy:!events-plugin!public! !
!NPOutStream categoriesFor: #setApplet:npStream:handler:!initializing!private! !
!NPOutStream categoriesFor: #space!accessing!public! !
!NPOutStream categoriesFor: #tab!accessing!public! !
!NPOutStream categoriesFor: #write:!operations!public! !

NPOutStream methodProtocol: #puttableStream attributes: #(#ansi #readOnly) selectors: #(#cr #flush #nextPut: #nextPutAll: #space #tab)!

