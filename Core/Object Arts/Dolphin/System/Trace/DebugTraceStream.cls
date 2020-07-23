"Filed out from Dolphin Smalltalk 7"!

Stream subclass: #DebugTraceStream
	instanceVariableNames: 'buffer bufferProtect'
	classVariableNames: 'Current'
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
DebugTraceStream guid: (GUID fromString: '{42675a9e-7ef6-4e38-8ff1-c6cd5d1563cc}')!
DebugTraceStream comment: 'DebugTraceStream is a singleton class that implements the <puttableStream> protocol (and some) on top of the Win32 OutputDebugString() API. Like the Transcript the output is buffered until either an end of line is emitted (i.e. #cr is sent) or the the stream is explicitly flushed (i.e. #flush is sent). For convenience the singleton instance is assigned to the global named ''Trace''.

Instance Variables:
	buffer		<WriteStream> on <Utf8String>. Stream used to buffer output until flushed.
	bufferProtect	<Mutex> protecting the stream buffer.

Class Variables:
	Current 	<DebugTraceStream>. Singleton instance.'!
!DebugTraceStream categoriesForClass!Collections-Streams! !
!DebugTraceStream methodsFor!

atEnd
	"Answer whether the receiver cannot access any more objects"

	^self shouldNotImplement!

basicPrint: printee
	"Private - Ask the <Object>, printee, to append its basic textual description
	to the receiver."

	self nextPutAll: printee basicPrintString!

close
	self flush!

cr
	"Append a line delimiter to the receiver (N.B. For Windows this is a CR-LF sequence)."

	super cr.
	self flush!

display: anObject
	"Ask anObject to append its end-user textual description to the receiver."

	bufferProtect critical: [anObject displayOn: buffer]!

flush
	"Flush the buffered output to the display."

	buffer position == 0 
		ifFalse: 
			[bufferProtect critical: 
					[KernelLibrary default outputDebugString: buffer contents asUtf16String.
					buffer reset]]!

initialize
	"Private - Initialize the receiver."

	"On the assumption that we print to the buffer stream more often than we flush to the Windows API, it is better to buffer in UTF-8"
	buffer := String writeStream: 128.
	bufferProtect := Mutex new.!

isEmpty
	"Answer whether the sets of both past and future sequence values are empty."

	^false!

isWriteable
	"Answer whether the receiver can be written to (i.e. it implements the 
	puttableStream protocol)."

	^true!

next: anInteger put: anObject
	"Store the argument, anObject, as the next anInteger number of elements accessible by the receiver. 
	Answer anObject."

	self nextPutAll: (Utf8String new: anInteger withAll: anObject).
	^anObject!

nextPut: newElem
	"Append the <character>, newElem, to the receiver."

	self nextPutAll: (Utf8String with: newElem).
	^newElem!

nextPutAll: insertString
	"Append the <readableString>, insertString, to the text of the receiver."

	bufferProtect critical: [buffer nextPutAll: insertString].
	^insertString!

print: anObject
	"Prints anObject at the end of the receiver."

	"To avoid locking the buffer for longer than necessary, do the printing first"
	self nextPutAll: anObject printString!

tab: tabCount
	"Append the specified number of tabs to the receiver."

	self next: tabCount put: $\t
! !
!DebugTraceStream categoriesFor: #atEnd!public!testing! !
!DebugTraceStream categoriesFor: #basicPrint:!printing!private! !
!DebugTraceStream categoriesFor: #close!operations!public! !
!DebugTraceStream categoriesFor: #cr!adding!public! !
!DebugTraceStream categoriesFor: #display:!printing!public! !
!DebugTraceStream categoriesFor: #flush!accessing!public! !
!DebugTraceStream categoriesFor: #initialize!initializing!private! !
!DebugTraceStream categoriesFor: #isEmpty!public! !
!DebugTraceStream categoriesFor: #isWriteable!public!testing! !
!DebugTraceStream categoriesFor: #next:put:!operations!public! !
!DebugTraceStream categoriesFor: #nextPut:!adding!public! !
!DebugTraceStream categoriesFor: #nextPutAll:!adding!public! !
!DebugTraceStream categoriesFor: #print:!printing!public! !
!DebugTraceStream categoriesFor: #tab:!accessing!public! !

DebugTraceStream methodProtocol: #puttableStream attributes: #(#ansi #readOnly) selectors: #(#cr #flush #nextPut: #nextPutAll: #space #tab)!

!DebugTraceStream class methodsFor!

current
	^Current!

initialize
	Current := self basicNew initialize.
	Trace := Current! !
!DebugTraceStream class categoriesFor: #current!instance creation!public! !
!DebugTraceStream class categoriesFor: #initialize!initializing!public! !

