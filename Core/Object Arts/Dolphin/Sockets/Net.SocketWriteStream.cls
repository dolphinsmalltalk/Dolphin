"Filed out from Dolphin Smalltalk 7"!

Core.WriteStream subclass: #'Net.SocketWriteStream'
	instanceVariableNames: 'socket dirty'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Net.SocketWriteStream guid: (Core.GUID fromString: '{87b4c6fe-026e-11d3-9fd7-00a0cc3e4a32}')!
Net.SocketWriteStream comment: 'This class represents a buffered write stream for sending data across a Socket connection.

From an implementation perspective this class is similar to FileStream, in that it uses the inherited stream collection as a buffer, overridding certain operations to note when the buffer is dirty. Data is not sent to the underlying socket until the stream is explictily flushed, or the buffer overflows.'!
!Net.SocketWriteStream categoriesForClass!Collections-Streams!Windows Sockets! !
!Net.SocketWriteStream methodsFor!

close
	"Write any outstanding changes to the socket and close it."

	self flush.
	socket close.
	socket := nil!

flush
	"Flush any buffered modifications to the socket."

	dirty ifFalse: [^self].
	socket send: collection count: position.
	position := 0.
	dirty := false!

growCollection
	"Private - The buffer of a FileStream is fixed at the page size."

	^self shouldNotImplement!

isBinary
	"Answer whether the receiver's data is binary (i.e. consisting of Integers in the range 0..255)."

	^self collection isMemberOf: ByteArray!

isText
	"Answer whether if the receiver's data is characters"

	^self isBinary not!

isText: aBoolean 
	"Set whether the elements of the receiver should be treated as bytes (Integers)
	or characters.."

	collection := aBoolean ifTrue: [collection asString] ifFalse: [collection asByteArray]!

next: sizeInteger putAll: aSequenceableCollection startingAt: startInteger 
	"Append countInteger elements of aSequenceableCollection from startInteger
	to the receiver. Answer aSequenceableCollection."

	| stop |
	stop := position + sizeInteger.
	stop <= writeLimit 
		ifTrue: 
			["The block fits into the current collection and can be
			written directly"
			collection 
				replaceFrom: position + 1
				to: stop
				with: aSequenceableCollection
				startingAt: startInteger.
			position := stop.
			dirty := true]
		ifFalse: 
			["The block will not fit within the current collection."
			self flush.
			self socket 
				send: aSequenceableCollection
				count: sizeInteger
				startingAt: startInteger].
	^aSequenceableCollection!

nextPut: anInteger 
	"Write anIntegerOrCharacter to the receiver and answer the argument."

	dirty := true.
	^self primitiveNextPut: anInteger!

nextPutAll: aCollection
	"Store the elements in the argument, aCollection, as the next elements accessible by the receiver. 
	Answer aCollection"

	^aCollection appendToStream: self!

on: aCollection
	super on: aCollection.
	dirty := false!

primitiveNextPut: anInteger 
	"Private - Write anInteger to the receiver."

	<primitive: 66>
	self flush.
	dirty := true.
	^collection at: (position := position + 1) put: anInteger!

socket
	"Private - Answers the socket instance variable."

	^socket!

socket: aSocket 
	"Private - Sets the socket instance variable to aSocket."

	socket := aSocket! !
!Net.SocketWriteStream categoriesFor: #close!operations!public! !
!Net.SocketWriteStream categoriesFor: #flush!buffer!public! !
!Net.SocketWriteStream categoriesFor: #growCollection!operations!private! !
!Net.SocketWriteStream categoriesFor: #isBinary!public!testing! !
!Net.SocketWriteStream categoriesFor: #isText!public!testing! !
!Net.SocketWriteStream categoriesFor: #isText:!modes!public! !
!Net.SocketWriteStream categoriesFor: #next:putAll:startingAt:!accessing!public! !
!Net.SocketWriteStream categoriesFor: #nextPut:!accessing!public! !
!Net.SocketWriteStream categoriesFor: #nextPutAll:!accessing!public! !
!Net.SocketWriteStream categoriesFor: #on:!initializing!private! !
!Net.SocketWriteStream categoriesFor: #primitiveNextPut:!accessing!private! !
!Net.SocketWriteStream categoriesFor: #socket!accessing!private! !
!Net.SocketWriteStream categoriesFor: #socket:!accessing!private! !

!Net.SocketWriteStream class methodsFor!

bufferSize
	"Answer the size of the buffer to be used."

	^4096!

on: aSocket 
	"Answers a new instance of the receiver for communicating with aSocket."

	^self on: aSocket text: false!

on: aSocket text: aBoolean
	"Answer a new instance of the receiver on the specified <Socket>, to be used for buffered writing 
	string or binary data to that socket depending on the value of <boolean> argument."

	^self basicNew
		socket: aSocket;
		on: ((aBoolean ifTrue: [String] ifFalse: [ByteArray]) newFixed: self bufferSize);
		yourself! !
!Net.SocketWriteStream class categoriesFor: #bufferSize!constants!public! !
!Net.SocketWriteStream class categoriesFor: #on:!instance creation!public! !
!Net.SocketWriteStream class categoriesFor: #on:text:!instance creation!public! !

