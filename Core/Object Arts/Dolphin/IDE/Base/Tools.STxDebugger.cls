"Filed out from Dolphin Smalltalk"!

Kernel.STxInFilerWrapper
	subclass: #'Tools.STxDebugger'
	instanceVariableNames: 'indentLevel count traceStream printOffsets'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Tools.STxDebugger guid: (Core.GUID fromString: '{8a787f20-7f70-4b61-993a-a324bc0645a5}')!

Tools.STxDebugger isNonInstantiable: true!

Tools.STxDebugger comment: '`STxDebugger` is an abstract class of `STxInFiler` decorators that can create a textual dump of the content of an STx object stream for diagnostic purposes. There are concrete subclasses specific to STB and STL.'!

!Tools.STxDebugger categoriesForClass!System-Binary storage! !

!Tools.STxDebugger methodsFor!

basicNext
	^self subclassResponsibility!

dump
	self preamble.
	[self atEnd] whileFalse: [self next].
	self postamble!

next
	"Answer the next object from the receiver's stream."

	| answer |
	indentLevel := 0.
	answer := [self basicNext] on: Notification
				do: 
					[:ex |
					traceStream
						cr;
						cr.
					80 timesRepeat: [traceStream nextPutAll: $*].
					traceStream
						cr;
						display: ex;
						cr.
					80 timesRepeat: [traceStream nextPutAll: $*].
					traceStream cr.
					ex resume].
	traceStream cr.
	^answer!

objectAt: anInteger
	"Answer the map value at anInteger. If anInteger is zero then answer nil.
	Signal an exception if there is no such entry."

	^anInteger == 0 ifFalse: [decorated objectAt: anInteger]!

postamble
	traceStream
		nextPutAll: 'End of ';
		print: count;
		nextPutAll: ' object'.
	count ~= 1 ifTrue: [traceStream nextPut: $s]!

preamble
	traceStream
		nextPutAll: self stxFormatName;
		nextPutAll: ' version ';
		print: self version;
		nextPut: $:!

printOffsets
	^printOffsets notNil!

printOffsets: aBoolean
	printOffsets := aBoolean
				ifTrue: 
					[
					[stream position
						printOn: traceStream
						base: 10
						nDigits: 6.
					traceStream space]]!

stream: aStream
	traceStream := String writeStream.
	count := indentLevel := 0.
	self printOffsets: true.
	super stream: aStream!

traceStream
	^traceStream!

traceStream: aPuttableStream 
	traceStream := aPuttableStream! !

!Tools.STxDebugger categoriesForMethods!
basicNext!private! !
dump!operations!public! !
next!accessing!public! !
objectAt:!accessing!private! !
postamble!operations!private! !
preamble!operations!private! !
printOffsets!accessing!public! !
printOffsets:!accessing!public! !
stream:!initializing!private! !
traceStream!accessing!public! !
traceStream:!accessing!public! !
!

!Tools.STxDebugger class methodsFor!

dump: aReadStream
	^((self on: aReadStream)
		dump;
		traceStream) contents!

dumpToTranscript: aReadStream
	(self on: aReadStream)
		traceStream: Transcript;
		dump.
	Transcript cr! !

!Tools.STxDebugger class categoriesForMethods!
dump:!public! !
dumpToTranscript:!public! !
!

