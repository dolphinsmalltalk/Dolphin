"Filed out from Dolphin Smalltalk"!

Core.Tests.AbstractWriteStreamTest
	subclass: #'Core.Tests.WriteStreamTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Core.Tests.WriteStreamTest guid: (Core.GUID fromString: '{9d14176b-5486-40dc-bc22-694add104427}')!

Core.Tests.WriteStreamTest comment: ''!

!Core.Tests.WriteStreamTest methodsFor!

expectedAnsiProtocolNames
	^#(#collectionStream #Object #puttableStream #sequencedStream #WriteStream)!

testOverflow
	| subject |
	subject := Array writeStream.
	self assert: subject collection isEmpty.
	subject nextPut: 1.
	self assert: subject collection equals: #(1 nil).
	subject nextPutAll: #(2 3).
	self assert: subject collection equals: #(1 2 3 nil).
	subject nextPutAll: #(4 5 6 7 8).
	self assert: subject collection equals: #(1 2 3 4 5 6 7 8 nil nil nil nil).
! !

!Core.Tests.WriteStreamTest categoriesForMethods!
expectedAnsiProtocolNames!constants!private! !
testOverflow!public!unit tests! !
!

!Core.Tests.WriteStreamTest class methodsFor!

streamClass
	^WriteStream! !

!Core.Tests.WriteStreamTest class categoriesForMethods!
streamClass!helpers!private! !
!

