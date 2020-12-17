"Filed out from Dolphin Smalltalk 7"!

Core.ReadStream subclass: #'Net.SocketReadStream'
	instanceVariableNames: 'socket'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Net.SocketReadStream guid: (Core.GUID fromString: '{87b4c6fc-026e-11d3-9fd7-00a0cc3e4a32}')!
Net.SocketReadStream comment: 'This class represents a buffered read stream for receiving data across a Socket connection. The #next call will receive the next element from the stream and will block until there is data available. In order to avoid blocking (when executing on the user interface thread, for example) the #hasInput method may be used to check for the presence of available input before calling #next.'!
!Net.SocketReadStream categoriesForClass!Collections-Streams!Windows Sockets! !
!Net.SocketReadStream methodsFor!

atEnd
	"Answer whether the receiver cannot access any more objects."

	"Implementation Note: If there is any input available in the buffer, which the superclass implementation
	can tell us, then we know we are not at end. Otherwise we need to attempt to read some more input
	from the socket to find out whether it has been closed or not. This could, of course, cause the stream
	to block, but this is correct since we can't truthfully answer whether we are at end until either
	more input arrives, or the socket is closed."

	super atEnd ifFalse: [^false].
	^self socket isOpen not or: 
			[self readPage.
			readLimit = 0]!

basicNext: countInteger into: aSequenceableCollection startingAt: startInteger 
	"Destructively replace the elements of the argument, aSequenceableCollection,
	in the interval (startAt..startAt+count-1) with the next, count, elements of
	the receiver. Answer aSequenceableCollection."

	startInteger to: startInteger + countInteger - 1
		do: [:i | aSequenceableCollection at: i put: self next].
	^aSequenceableCollection!

contents
	"We don't maintain past history, so we cannot implement this correctly."

	^self errorNotPositionable!

hasInput
	"Answer true if there is data available on the receiver without blocking"

	^super atEnd not or: [self socket hasInput]!

isBinary
	"Answer whether the receiver's data is binary (i.e. consisting of Integers in the range 0..255)."

	^self collection isMemberOf: ByteArray!

isText
	"Answer whether if the receiver's data is characters."

	^self isBinary not!

isText: aBoolean 
	"Set whether the elements of the receiver should be treated as bytes (Integers)
	or characters.."

	collection := aBoolean ifTrue: [collection asString] ifFalse: [collection asByteArray]!

next
	"Answer the receiver's next byte, an Integer.
	Signal an EndOfStream Exception if we are atEnd."

	<primitive: 65>
	self readPage.
	^super next!

next: countInteger into: aSequenceableCollection startingAt: startInteger 
	"Destructively replace the elements of the argument, aSequenceableCollection,
	in the interval (startAt..startAt+count-1) with the next, count, elements of
	the receiver. Answer aSequenceableCollection."

	startInteger to: startInteger + countInteger - 1
		do: [:i | aSequenceableCollection at: i put: self next].
	^aSequenceableCollection!

nextAvailable
	"Answer a <Character>, or <integer> in the range 0..255, being the next of the 
	receiver's future sequence values. Answer nil if at EOF."

	^self atEnd ifFalse: [self next]!

nextAvailable: anInteger
	"Answer up to anInteger elements of the receiver's collection. Generally, the answer will be
	a collection of the same class as the one accessed by the receiver (though this is
	determined by the receiver), and will contain anInteger elements, or as many as are left in
	the receiver's collection."

	| newStream count |
	newStream := self contentsSpecies writeStream: (count := anInteger).
	[count == 0 or: [self atEnd]] whileFalse: 
			[newStream nextPut: self next.
			count := count - 1].
	^newStream contents!

on: aCollection
	super on: aCollection.
	readLimit := 0!

readPage
	"Private - Read ahead, a whole page or as much input as is available, into the buffer."

	readLimit := 
			[socket
				receiveSome: collection
				count: collection size
				startingAt: 1]
					on: SocketClosed
					do: [:ex | 0].
	position := 0!

setToEnd
	"The receiver is not positionable."

	^self errorNotPositionable!

size
	"We don't know the number of elements in the past sequence values, only the number
	currently in the buffer, so cannot provide a sensible implementation of this message."

	^self errorNotPositionable!

socket
	"Private - Answers the socket instance variable."

	^socket!

socket: aSocket 
	"Private - Sets the socket instance variable to aSocket."

	socket := aSocket!

upTo: anObject 
	"Answer a collection of elements starting with the next element accessed by the receiver,
	and up to, not inclusive of, the next element that is equal to anObject. Positions the
	stream after anObject if found. If anObject is not in the collection, answer the entire rest
	of the collection. If the receiver is at its end, answer an empty Collection."

	| newStream nextObject |
	newStream := self contentsSpecies writeStream: 128.
	[(nextObject := self nextAvailable) isNil or: [nextObject = anObject]] 
		whileFalse: [newStream nextPut: nextObject].
	^newStream contents!

upToEnd
	"Answer a collection consisting of the remaining elements in the receiver (i.e. from the current
	position to the end)."

	| remainder |
	remainder := self contentsSpecies writeStream: 128.
	[self atEnd] whileFalse: [remainder nextPut: self next].
	^remainder contents! !
!Net.SocketReadStream categoriesFor: #atEnd!public!testing! !
!Net.SocketReadStream categoriesFor: #basicNext:into:startingAt:!accessing!public! !
!Net.SocketReadStream categoriesFor: #contents!accessing!public! !
!Net.SocketReadStream categoriesFor: #hasInput!public!testing! !
!Net.SocketReadStream categoriesFor: #isBinary!public!testing! !
!Net.SocketReadStream categoriesFor: #isText!public!testing! !
!Net.SocketReadStream categoriesFor: #isText:!modes!public! !
!Net.SocketReadStream categoriesFor: #next!accessing!public! !
!Net.SocketReadStream categoriesFor: #next:into:startingAt:!accessing!public! !
!Net.SocketReadStream categoriesFor: #nextAvailable!public! !
!Net.SocketReadStream categoriesFor: #nextAvailable:!accessing!public! !
!Net.SocketReadStream categoriesFor: #on:!accessing!initializing!private! !
!Net.SocketReadStream categoriesFor: #readPage!operations!private! !
!Net.SocketReadStream categoriesFor: #setToEnd!positioning!public! !
!Net.SocketReadStream categoriesFor: #size!accessing!public! !
!Net.SocketReadStream categoriesFor: #socket!accessing!private! !
!Net.SocketReadStream categoriesFor: #socket:!accessing!private! !
!Net.SocketReadStream categoriesFor: #upTo:!accessing!public! !
!Net.SocketReadStream categoriesFor: #upToEnd!accessing!public! !

!Net.SocketReadStream class methodsFor!

bufferSize
	"Private - Answer the size of the buffer to be used."

	^4096!

on: aSocket 
	"Answers a new instance of the receiver for communicating with aSocket."

	^self on: aSocket text: false!

on: aSocket text: aBoolean
	"Answer a new instance of the receiver on the specified <Socket>, to be used for buffered reading
	string or binary data from that socket depending on the value of <boolean> argument."

	^self basicNew
		socket: aSocket;
		on: ((aBoolean ifTrue: [String] ifFalse: [ByteArray]) newFixed: self bufferSize);
		yourself! !
!Net.SocketReadStream class categoriesFor: #bufferSize!constants!private! !
!Net.SocketReadStream class categoriesFor: #on:!instance creation!public! !
!Net.SocketReadStream class categoriesFor: #on:text:!instance creation!public! !

