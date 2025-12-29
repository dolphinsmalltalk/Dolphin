"Filed out from Dolphin Smalltalk"!

Core.Tests.AbstractWriteStreamTest
	subclass: #'Kernel.Tests.DebugTraceStreamTest'
	instanceVariableNames: 'mockKernel outputDebugStrings'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Kernel.Tests.DebugTraceStreamTest guid: (Core.GUID fromString: '{844dec1a-ffff-4d71-8ca8-4176b6213a05}')!

Kernel.Tests.DebugTraceStreamTest comment: ''!

!Kernel.Tests.DebugTraceStreamTest methodsFor!

bufferSizeOfStream: aDebugTraceStream 
	^aDebugTraceStream buffer originalContents size!

expectedAnsiProtocolNames
	^#(#Object #puttableStream)!

newStream
	| stream |
	outputDebugStrings removeAll.
	stream := self streamClass new.
	stream kernel32: mockKernel.
	^stream!

setUp
	mockKernel := MockUnorderedObject new.
	outputDebugStrings := OrderedCollection new.
	mockKernel on: #outputDebugString: evaluate: [:output | outputDebugStrings add: output]!

streamedContents: aStream
	| residue |
	residue := aStream buffer contents.
	^residue class streamContents: 
			[:strm |
			outputDebugStrings do: [:each | strm nextPutAll: each].
			strm nextPutAll: residue]!

streamWith: aSequenceableCollection
	"Private - Answer a <gettableStream> of the type the receiver is testing, on the <SequenceableCollection> argument."

	| stream |
	outputDebugStrings removeAll.
	stream := super streamWith: aSequenceableCollection.
	stream kernel32: mockKernel.
	^stream!

testCrFlushes
	| subject |
	subject := self newStream.
	subject
		nextPutAll: 'Hello';
		cr;
		nextPutAll: 'World'.
	self assert: outputDebugStrings single equals: 'Hello', String lineDelimiter.
	subject flush.
	self assert: outputDebugStrings size equals: 2.
	self assert: outputDebugStrings second equals: 'World'!

testNew
	| subject |
	subject := self newStream.
	self assert: subject bufferClass equals: Utf8String!

writeableCollections
	^self strings! !

!Kernel.Tests.DebugTraceStreamTest categoriesForMethods!
bufferSizeOfStream:!public! !
expectedAnsiProtocolNames!constants!private! !
newStream!helpers!private! !
setUp!public!running! !
streamedContents:!helpers!private! !
streamWith:!helpers!private! !
testCrFlushes!public! !
testNew!public! !
writeableCollections!constants!private! !
!

!Kernel.Tests.DebugTraceStreamTest class methodsFor!

streamClass
	^DebugTraceStream! !

!Kernel.Tests.DebugTraceStreamTest class categoriesForMethods!
streamClass!constants!private! !
!

