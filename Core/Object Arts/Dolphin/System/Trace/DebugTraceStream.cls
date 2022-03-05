"Filed out from Dolphin Smalltalk"!

Stream subclass: #DebugTraceStream
	instanceVariableNames: 'buffer bufferProtect'
	classVariableNames: 'Current'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DebugTraceStream guid: (GUID fromString: '{42675a9e-7ef6-4e38-8ff1-c6cd5d1563cc}')!
DebugTraceStream comment: 'DebugTraceStream is a singleton class that implements the <puttableStream> protocol (and some) on top of the Win32 OutputDebugString() API. Like the Transcript the output is buffered until either an end of line is emitted (i.e. #cr is sent) or the the stream is explicitly flushed (i.e. #flush is sent). For convenience the singleton instance is assigned to the global named ''Trace''.

Instance Variables:
	buffer		<WriteStream> on <Utf8String>. Stream used to buffer output until flushed.
	bufferProtect	<Mutex> protecting the stream buffer.

Class Variables:
	Current 	<DebugTraceStream>. Singleton instance.'!
!DebugTraceStream categoriesForClass!Collections-Streams! !
!DebugTraceStream methodsFor!

<< anObject
	"Store the argument, or the elements of the argument if it is a <collection>, as the next element or elements of the receiver."

	anObject appendToStream: self.
	^self!

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

	self nextPutAll: String lineDelimiter; flush!

crtab
	"Append a new line to the receiver followed by a tab"

	self crtab: 1!

crtab: count
	"Append a new line to the receiver followed by <integer>, count, tabs."

	self cr.
	self tab: count!

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

next: size putAll: aSequenceableCollection startingAt: start
	"Append countInteger elements of aSequenceableCollection from startInteger
	to the receiver. Answer aSequenceableCollection."

	self nextPutAll: (aSequenceableCollection copyFrom: start to: start+size-1).
	^aSequenceableCollection!

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

	self nextPutAll: anObject printString!

space
	"Append a space to the receiver."

	self nextPutAll: $\x20!

tab
	"Store a tab character as the next element of the receiver."

	self nextPut: $\t!

tab: tabCount
	"Append the specified number of tabs to the receiver."

	self next: tabCount put: $\t
! !
!DebugTraceStream categoriesForMethods!
<<!accessing!public! !
atEnd!public!testing! !
basicPrint:!printing!private! !
close!operations!public! !
cr!adding!public! !
crtab!adding!public! !
crtab:!adding!public! !
display:!printing!public! !
flush!accessing!public! !
initialize!initializing!private! !
isEmpty!public! !
isWriteable!public!testing! !
next:put:!operations!public! !
next:putAll:startingAt:!accessing!public! !
nextPut:!adding!public! !
nextPutAll:!adding!public! !
print:!printing!public! !
space!adding!public! !
tab!accessing!public! !
tab:!accessing!public! !
!

DebugTraceStream methodProtocol: #puttableStream attributes: #(#ansi #readOnly) selectors: #(#cr #flush #nextPut: #nextPutAll: #space #tab)!

!DebugTraceStream class methodsFor!

current
	^Current!

initialize
	Current := self basicNew initialize.
	Trace := Current! !
!DebugTraceStream class categoriesForMethods!
current!instance creation!public! !
initialize!initializing!public! !
!

