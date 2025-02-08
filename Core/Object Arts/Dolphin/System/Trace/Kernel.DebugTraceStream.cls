"Filed out from Dolphin Smalltalk"!

Core.Stream
	subclass: #'Kernel.DebugTraceStream'
	instanceVariableNames: 'buffer'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Kernel.DebugTraceStream guid: (Core.GUID fromString: '{42675a9e-7ef6-4e38-8ff1-c6cd5d1563cc}')!

Kernel.DebugTraceStream comment: 'DebugTraceStream is a singleton class that implements the <puttableStream> protocol (and some) on top of the Win32 OutputDebugString() API. Like the Transcript the output is buffered until either an end of line is emitted (i.e. #cr is sent) or the stream is explicitly flushed (i.e. #flush is sent). For convenience the singleton instance is assigned to the global named ''Trace''.

Instance Variables:
	buffer		<WriteStream> on <Utf8String>. Stream used to buffer output until flushed.
	bufferProtect	<Mutex> protecting the stream buffer.

Class Variables:
	Current 	<DebugTraceStream>. Singleton instance.'!

!Kernel.DebugTraceStream categoriesForClass!Collections-Streams! !

!Kernel.DebugTraceStream methodsFor!

atEnd
	"Answer whether the receiver cannot access any more objects"

	^self shouldNotImplement!

close
	self flush!

cr
	"Append a line delimiter to the receiver (N.B. For Windows this is a CR-LF sequence)."

	super cr.
	self flush!

flush
	"Flush the buffered output to the OS debug trace output device."

	buffer position == 0
		ifFalse: 
			[Kernel32 outputDebugString: buffer contents.
			buffer reset]!

initialize
	"Private - Initialize the receiver."

	"On the assumption that we print to the buffer stream more often than we flush to the OutputDebugString API, it is better to buffer in UTF-8 than UTF-16"

	buffer := String smalltalkWriteStream: 128.
	^self!

isEmpty
	"Answer whether the sets of both past and future sequence values are empty."

	^false!

isWriteable
	"Answer whether the receiver can be written to (i.e. it implements the 
	puttableStream protocol)."

	^true!

locale
	"Answer the <Locale> to be used when emitting localisable data to/from this stream."

	^buffer locale!

nextPut: newElem
	"Append the <character>, newElem, to the receiver."

	^buffer nextPut: newElem!

nextPutAll: insertString
	"Append the <readableString>, insertString, to the text of the receiver."

	^buffer nextPutAll: insertString! !

!Kernel.DebugTraceStream categoriesForMethods!
atEnd!public!testing! !
close!operations!public! !
cr!public!writing! !
flush!public!writing! !
initialize!initializing!private! !
isEmpty!public! !
isWriteable!public!testing! !
locale!accessing!public! !
nextPut:!public!writing! !
nextPutAll:!public!writing! !
!

Kernel.DebugTraceStream methodProtocol: #puttableStream attributes: #(#ansi #readOnly) selectors: #(#cr #flush #nextPut: #nextPutAll: #space #tab)!

!Kernel.DebugTraceStream class methodsFor!

current
	^Processor activeProcess debugStream!

new
	"Streams must be instantiated onto something."

	^self basicNew initialize! !

!Kernel.DebugTraceStream class categoriesForMethods!
current!instance creation!public! !
new!public! !
!

