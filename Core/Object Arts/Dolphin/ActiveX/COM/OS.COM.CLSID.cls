"Filed out from Dolphin Smalltalk 7"!

Core.GUID variableByteSubclass: #'OS.COM.CLSID'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.COM.CLSID guid: (Core.GUID fromString: '{87b4c643-026e-11d3-9fd7-00a0cc3e4a32}')!
OS.COM.CLSID comment: '`OS.COM.CLSID` is the class of 128-bit Globally Unique Identifiers (guids) which are specifically used to uniquely identify coclasses (components) in COM.

The CLSIDs of all coclasses registered on your machine can be found under the HKCR\CLSID key in your registry. Each correctly formed entry will have a human (are VB programmers human?) readable form (a ProgID) directly under HKCR.'!
!OS.COM.CLSID categoriesForClass!External-Data-Structured-COM! !
!OS.COM.CLSID methodsFor!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	[aPuttableStream nextPutAll: self progID] on: HRESULTError
		do: [:e | aPuttableStream nextPutAll: self asString]!

progID
	"Answer the ProgID associated with the receiver (if any). The result is a String and is the least technical way we have to refer to a component, although still not really intended for end-user display.
	If the registry contains no relevant entry, then an appropriate HRESULTError will be raised. Note that a ProgID has a maximum of 39 characters."

	| pProgId answer |
	pProgId := TaskMemory new.
	OLELibrary default progIDFromCLSID: self lplpszProgID: pProgId.
	answer := String fromUtf16String: pProgId.
	pProgId free.
	^answer! !
!OS.COM.CLSID categoriesFor: #displayOn:!displaying!public! !
!OS.COM.CLSID categoriesFor: #progID!displaying!public! !

!OS.COM.CLSID class methodsFor!

fromProgID: aString
	"Answer a new instance of the receiver instantiated from the argument, aString,
	which contains a ProgID which is expected to be in the registry."

	| answer |
	answer := self newNull.
	OLELibrary default clsidFromProgID: aString lpclsid: answer.
	^answer!

fromString: aString
	"Answer an instance of the receiver instantiated from the argument, aString."

	aString isEmpty ifTrue: [^self null].
	aString first ~~ ${ ifTrue: [^self fromProgID: aString].
	^super fromString: aString!

initialize
	"Private - Initialize the receiver's class variables.
		CLSID initialize
	"

	self extraInstanceSpec: ByteSize! !
!OS.COM.CLSID class categoriesFor: #fromProgID:!instance creation!public! !
!OS.COM.CLSID class categoriesFor: #fromString:!instance creation!public! !
!OS.COM.CLSID class categoriesFor: #initialize!development!initializing!private! !

