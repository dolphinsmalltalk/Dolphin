"Filed out from Dolphin Smalltalk"!

Core.Stream
	subclass: #'Kernel.DebugTraceStream'
	instanceVariableNames: 'buffer kernel32'
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

	^buffer atEnd!

basicNext: countInteger putAll: aSequenceableCollection startingAt: startInteger
	"Private - Append countInteger elements of aSequenceableCollection from startInteger to the receiver. Answer aSequenceableCollection."

	^buffer
		basicNext: countInteger
		putAll: aSequenceableCollection
		startingAt: startInteger!

buffer
	^buffer!

close
	self flush!

contentsSpecies
	"Private - Answer the class of Object to be used when answering collections of elements from the receiver."

	^buffer contentsSpecies!

cr
	"Append a line delimiter to the receiver (N.B. For Windows this is a CR-LF sequence)."

	super cr.
	self flush!

flush
	"Flush the buffered output to the OS debug trace output device."

	buffer position == 0
		ifFalse: 
			[kernel32 outputDebugString: buffer contents.
			buffer reset]!

isEmpty
	"Answer whether the sets of both past and future sequence values are empty."

	^false!

isWriteable
	"Answer whether the receiver can be written to (i.e. it implements the 
	puttableStream protocol)."

	^true!

locale
	"Answer the <Locale> to be used when writing localisable data to this stream."

	^buffer locale!

nextPut: newElem
	"Append the <character>, newElem, to the receiver."

	^buffer nextPut: newElem!

nextPutAll: insertString
	"Append the <readableString>, insertString, to the text of the receiver."

	^buffer nextPutAll: insertString!

reset
	buffer reset!

setBuffer: aWriteStream
	buffer := aWriteStream.
	kernel32 := Kernel32.
	^self! !

!Kernel.DebugTraceStream categoriesForMethods!
atEnd!public!testing! !
basicNext:putAll:startingAt:!public!writing! !
buffer!accessing!public! !
close!operations!public! !
contentsSpecies!constants!private! !
cr!public!writing! !
flush!public!writing! !
isEmpty!public!testing! !
isWriteable!public!testing! !
locale!accessing!public! !
nextPut:!public!writing! !
nextPutAll:!public!writing! !
reset!positioning!public! !
setBuffer:!initializing!private! !
!

Kernel.DebugTraceStream methodProtocol: #puttableStream attributes: #(#ansi #readOnly) selectors: #(#cr #flush #nextPut: #nextPutAll: #space #tab)!

!Kernel.DebugTraceStream class methodsFor!

current
	^Processor activeProcess debugStream!

new
	"On the assumption that we print to the buffer stream more often than we flush to the OutputDebugString API, it is better to buffer in UTF-8 than UTF-16"

	^self over: (String smalltalkWriteStream: 128)!

over: aPuttableStream
	^self basicNew setBuffer: aPuttableStream! !

!Kernel.DebugTraceStream class categoriesForMethods!
current!instance creation!public! !
new!public! !
over:!instance creation!public! !
!

