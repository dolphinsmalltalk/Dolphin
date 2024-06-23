"Filed out from Dolphin Smalltalk"!

Core.Tests.SequencedGrowableCollectionTest
	subclass: #'UI.Tests.ListModelTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.Tests.ListModelTest guid: (Core.GUID fromString: '{7c1aa951-808d-4acf-a642-6e54fea10c32}')!

UI.Tests.ListModelTest comment: ''!

!UI.Tests.ListModelTest methodsFor!

collectionClass
	^ListModel!

testStbConvertFromVersion0
	| bytes subject |
	bytes := #[33 83 84 66 32 48 32 6 1 9 0 76 105 115 116 77 111 100 101 108 0 0 0 0 14 2 18 0 83 84 66 67 111 108 108 101 99 116 105 111 110 80 114 111 120 121 0 0 0 0 14 1 13 0 83 84 66 67 108 97 115 115 80 114 111 120 121 0 0 0 0 54 0 6 0 83 116 114 105 110 103 17 0 0 0 79 114 100 101 114 101 100 67 111 108 108 101 99 116 105 111 110 38 0 5 0 65 114 114 97 121 3 0 0 0 3 0 0 0 178 0 0 0 1 0 0 0 50 54 0 5 0 70 108 111 97 116 8 0 0 0 0 0 0 0 0 0 8 64].
	subject := Object fromBinaryStoreBytes: bytes.
	self assert: subject isKindOf: ListModel.
	self assert: subject equals: (ListModel withAll: #(1 '2' 3.0)).
	self assertIsNil: subject getEvents.
	self assert: subject searchPolicy identicalTo: SearchPolicy identity!

testStbConvertFromVersion1
	| bytes subject |
	bytes := #[33 83 84 66 32 48 32 70 2 9 0 1 0 0 0 76 105 115 116 77 111 100 101 108 0 0 0 0 14 2 18 0 83 84 66 67 111 108 108 101 99 116 105 111 110 80 114 111 120 121 0 0 0 0 14 1 13 0 83 84 66 67 108 97 115 115 80 114 111 120 121 0 0 0 0 54 0 6 0 83 116 114 105 110 103 17 0 0 0 79 114 100 101 114 101 100 67 111 108 108 101 99 116 105 111 110 38 0 5 0 65 114 114 97 121 3 0 0 0 3 0 0 0 178 0 0 0 1 0 0 0 50 54 0 5 0 70 108 111 97 116 8 0 0 0 0 0 0 0 0 0 8 64 0 0 0 0].
	subject := Object fromBinaryStoreBytes: bytes.
	self assert: subject isKindOf: ListModel.
	self assert: subject equals: (ListModel withAll: #(1 '2' 3.0)).
	self assertIsNil: subject getEvents.
	self assert: subject searchPolicy identicalTo: SearchPolicy identity!

testStbConvertFromVersion2
	| bytes subject |
	self assert: ListModel stbVersion equals: 2.	"If this fails, time to capture the new format in another test"
	bytes := #[33 83 84 66 32 48 32 70 3 9 0 2 0 0 0 76 105 115 116 77 111 100 101 108 0 0 0 0 14 2 18 0 83 84 66 67 111 108 108 101 99 116 105 111 110 80 114 111 120 121 0 0 0 0 78 2 13 0 1 0 0 0 83 84 66 67 108 97 115 115 80 114 111 120 121 0 0 0 0 54 0 6 0 83 116 114 105 110 103 7 0 0 0 68 111 108 112 104 105 110 178 0 0 0 17 0 0 0 79 114 100 101 114 101 100 67 111 108 108 101 99 116 105 111 110 38 0 5 0 65 114 114 97 121 3 0 0 0 3 0 0 0 178 0 0 0 1 0 0 0 50 54 0 5 0 70 108 111 97 116 8 0 0 0 0 0 0 0 0 0 8 64 0 0 0 0 6 0 20 0 73 100 101 110 116 105 116 121 83 101 97 114 99 104 80 111 108 105 99 121 0 0 0 0].
	"Tools.STBDebugger dumpToTranscript: bytes readStream"
	subject := Object fromBinaryStoreBytes: bytes.
	self assert: subject isKindOf: ListModel.
	self assert: subject equals: (ListModel withAll: #(1 '2' 3.0)).
	self assertIsNil: subject getEvents.
	self assert: subject searchPolicy identicalTo: SearchPolicy identity! !

!UI.Tests.ListModelTest categoriesForMethods!
collectionClass!constants!private! !
testStbConvertFromVersion0!public! !
testStbConvertFromVersion1!public! !
testStbConvertFromVersion2!public! !
!

