"Filed out from Dolphin Smalltalk 7"!

External.Address variableByteSubclass: #'External.REFGUID'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.REFGUID guid: (Core.GUID fromString: '{f44c9141-2b3f-11d3-8368-7a8b5a000000}')!
External.REFGUID isIndirection: true!
External.REFGUID comment: 'REFGUID is a pointer class for referencing guids. It is mainly for use in situations where a GUID* pointer is passed back into Smalltalk, e.g. in block callbacks and COM method implementations.

Two distinct classes are provided for guids because, as of version 3.0, all classes in the system have an associated <GUID>. The GUID class is now a standard byte object subclassed directly from Object. The advantage of moving GUID itself out of the ExternalStructure hierarchy is that it avoids doubling the number of objects required to hold the per-class guids. The disadvantage is that GUID instances are no longer able to act as a pointer/references to externally stored guids, and hence we need this class to meet that requirement.

e.g.

REFGUID fromAddress: Object guid yourAddress'!
!External.REFGUID categoriesForClass!External-Data-Unstructured! !
!External.REFGUID methodsFor!

<=> aGUID
	"Answer the ordering relationship between the receiver and the argument."

	| status answer |
	status := ByteArray newFixed: 4.
	answer := RPCLibrary default
				uuidCompare: self
				uuid2: aGUID
				status: status.
	status := status dwordAtOffset: 0.
	status == 0 ifFalse: [RPCError signalWith: status].
	^answer!

= comperand
	"Answer whether the receiver is equivalent to the <Object>, comperand."

	^self species = comperand species and: [(self <=> comperand) == 0]!

asString
	"Answer a string representation of the receiver."

	^self value asString!

copyingClass
	"Private - Answer the class of object expected when the receiver is copied in whole or in part."

	^GUID!

displayOn: aPuttableStream
	"Append to the <puttableStream> argument a String whose characters are a representation of the receiver that an end-user might want to see."

	self value displayOn: aPuttableStream!

hash
	"Answer the SmallInteger hash value for the receiver."

	^self value hash!

printOn: aStream
	"Append a developer friendly textual representation of the receiver to aStream."

	aStream 
		basicPrint: self;
		display: self value!

species
	"Answer the preferred class of the receiver - not always the same as the answer to #class."

	^GUID!

value
	"Answer the <GUID> at which the receiver points."

	^self copyingClass fromAddress: self!

value: guid
	"Set the 16-byte GUID pointed at by the receiver to the <GUID>, guid."

	self replaceFrom: 1 to: 16 with: guid startingAt: 1! !
!External.REFGUID categoriesFor: #<=>!comparing!public! !
!External.REFGUID categoriesFor: #=!comparing!public! !
!External.REFGUID categoriesFor: #asString!converting!public! !
!External.REFGUID categoriesFor: #copyingClass!copying!private! !
!External.REFGUID categoriesFor: #displayOn:!printing!public! !
!External.REFGUID categoriesFor: #hash!comparing!public! !
!External.REFGUID categoriesFor: #printOn:!printing!public! !
!External.REFGUID categoriesFor: #species!accessing!public! !
!External.REFGUID categoriesFor: #value!accessing!public! !
!External.REFGUID categoriesFor: #value:!accessing!public! !

!External.REFGUID class methodsFor!

fromInteger: anInteger
	"Answer a new instance of the receiver with contents copied from anInteger"

	^self new 
		basicDwordAtOffset: 0 put: anInteger;
		yourself! !
!External.REFGUID class categoriesFor: #fromInteger:!instance creation!public! !

