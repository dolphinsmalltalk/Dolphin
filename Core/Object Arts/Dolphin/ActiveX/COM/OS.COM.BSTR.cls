"Filed out from Dolphin Smalltalk"!

External.Address
	variableByteSubclass: #'OS.COM.BSTR'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.COM.BSTR guid: (Core.GUID fromString: '{87b4c519-026e-11d3-9fd7-00a0cc3e4a32}')!
OS.COM.BSTR isIndirection: true!
OS.COM.BSTR comment: 'BSTR is an external structure to represent the OLE Automation string type of the same name.

BSTR is defined as:
	typedef OLECHAR FAR* BSTR;
That is, it is a pointer to a Unicode character string (although it cannot be used interchangeably with the latter - see below). 
As the underlying BSTR type is actually a pointer we define it here as a subclass of ExternalAddress, rather than try to squeeze it into the ExternalStructure hierarchy.

BSTRs are both null-terminated AND counted. They store their length as a 32-bit integer in the location immediately preceding the data of the string. BSTRs may also contain embedded nulls, which are included in the reported size, although the terminating null is not. Furthermore a BSTR may (validly) be null, in which case it behaves as if it were an empty string, as per the OLE Automation convention. It is worth noting that VB will usually pass a NULL pointer in place of the empty string.

BSTRs are stored in memory managed by the OLE Automation Library, which enables ownership to be passed from one function to another:  (down in the depths of OLEAut32.DLL the SysXXX functions map onto the services of the COM task memory allocator). Where a function is expecting a BSTR argument, then a BSTR allocated with SysAllocString must be passed rather than an ordinary Unicode string. The BSTR class can be used to create suitable parameters from other Smalltalk <readableString> classes.

BSTRs use finalization to safely manage the sys. alloc''d string, but they may be explicitly free''d too.'!
!OS.COM.BSTR categoriesForClass!External-Data-Unstructured! !
!OS.COM.BSTR methodsFor!

asBSTR
	"Answer the receiver converted to an AX Automation string."

	^self!

asString
	"Answer a <String> representation of the receiver."

	^self asUtf16String!

asUtf16String
	"Answer a `Utf16String` composed of the characters of the receiver (assumed itself to be UTF-16 encoded), or the empty string if the receiver is a null pointer (by convention a null BSTR is treated the same as an empty string)."

	^self isNull ifTrue: [Utf16String empty] ifFalse: [Utf16String fromAddress: self length: self size]!

asUtf8String
	"Answer a UTF-8 encoded <readableString> representation of the receiver."

	^self asUtf16String asUtf8String!

at: anInteger
	"Answer the character at index, anInteger, in the receiver."

	| index |
	index := anInteger+anInteger.
	^Character value: (super at: index) * 256 + (super at: index-1)!

at: anInteger put: aCharacter
	"Replace the character at index, anInteger, in the receiver with aCharacter."

	^super at: anInteger+anInteger-1 put: aCharacter!

attach: newValue
	"Private - Set the receiver to be a reference to the <bstr>, newValue.
	Answer the receiver."

	^super value: newValue!

basicFree
	"Private - Free the receiver's external resources."

	OleAut32 sysFreeString: self.
	self basicUIntPtrAtOffset: 0 put: 0!

byteSize
	"Answer the size in bytes of the string pointed at by the receiver, including any
	embedded nulls, but excluding the terminating null."

	^OleAut32 sysStringByteLen: self!

copy
	"Answer an <Object> which is a copy of the receiver (by default a copy which shares the receiver's 
	instance variables). This may be reimplemented to return a deep copy, or some other 
	form of copy (e.g. a 2-level copy, or, for an identify object, the same object), whatever
	is appropriate for the receiver."

	^self deepCopy!

copyingClass
	"Private - Answer the class of object expected when the receiver is copied in whole or in part."

	^Utf16String!

deepCopy
	"Answer a 'deep copy' of the receiver. The 'deep copy' is a clone of the receiver,
	sharing only those parts which cannot be copied (e.g. classes, nil, true, false, 
	SmallIntegers, Symbols, Characters, etc).
	Implementation Note: Override #deepCopy rather than #_deepCopy: because this
	is a byte object and the sole purpose of which is to act as a reference to another
	object, and there is no point copying its body."

	^OleAut32 sysAllocString: self!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream nextPutAll: self asString!

free
	"Private - Frees the receiver's external resources by releasing the interface."

	self isNull ifFalse: [self basicFree].
	self beUnfinalizable!

onStartup
	"Private - The system is starting. Modify the state of the receiver to account for the fact
	than any external memory allocated for the receiver during the previous session is no 
	longer accessible."

	self beUnfinalizable.
	super value: 0!

printOn: aStream
	"Append a developer friendly textual representation of the receiver to aStream."

	aStream 
		basicPrint: self;
		nextPut: $(;
		print: self asUtf16String ;
		nextPut: $)!

size
	"Answer the number of characters (including any embedded nulls, but excluding the 
	terminating null) in the receiver. If the receiver is a null pointer, then the answer will
	be zero."

	^OleAut32 sysStringLen: self!

species
	^Utf16String!

value
	"Answer the receiver's value as a Smalltalk <String>."

	^self asString!

value: newValue
	"Set the contents of the receiver to be a BSTR (String) representation of the 
	representation of the specified object. If the argument is itself a BSTR, then a copy
	is taken. Answer the receiver."

	| bstr |
	newValue isInteger 
		ifTrue: [bstr := self class fromAddress: newValue]
		ifFalse: [
			bstr := newValue asBSTR.
			bstr == newValue ifTrue: [bstr := bstr copy]].
	super value: (bstr beUnfinalizable; yourself)! !
!OS.COM.BSTR categoriesForMethods!
asBSTR!converting!public! !
asString!converting!public! !
asUtf16String!converting!public! !
asUtf8String!converting!public! !
at:!accessing!public! !
at:put:!accessing!public! !
attach:!accessing!private! !
basicFree!private!realizing/unrealizing! !
byteSize!accessing!public! !
copy!copying!public! !
copyingClass!copying!private! !
deepCopy!copying!public! !
displayOn:!printing!public! !
free!private!realizing/unrealizing! !
onStartup!event handling!private! !
printOn:!development!printing!public! !
size!accessing!public! !
species!constants!public! !
value!accessing!public! !
value:!accessing!public! !
!

!OS.COM.BSTR class methodsFor!

basicNew
	^self newFixed: 4!

clear: anExternalAddress
	OleAut32 sysFreeString: (anExternalAddress uint32AtOffset: 0)!

fromInteger: anAddress
	"Answer a new instance of the receiver that points at a copy of the 
	BSTR at the address, anInteger.
	Implementation Note: Override to answer a BSTR regardless of
	whether anAddress is null, since null is a valid BSTR value,
	also we must take a copy to avoid ownership problems."

	^anAddress isNull
		ifTrue: [self new]
		ifFalse: 
			[| answer |
			answer := OleAut32 sysAllocString: anAddress.
			answer isNull
				ifTrue: [OutOfMemoryError signal]
				ifFalse: 
					[answer
						beFinalizable;
						yourself]]!

fromString: aString
	"Answer a new instance of the receiver with the same contents as aString."

	| wstr |
	wstr := aString asUtf16String.
	wstr size == 0 ifTrue: [^self new].
	^self fromInteger: wstr yourAddress!

icon
	"Answers an Icon that can be used to represent this class"

	^String icon!

initialize
	"Private - Initialize the receiver.
	Register with session events to clean up instances on startup.
	
		BSTR initialize
	"

	SessionManager current 
		when: #sessionStarted send: #onStartup to: self!

new
	"Answer a new instance of the receiver of the initially holding a null pointer."

	^(self basicNew)
		beFinalizable;
		yourself!

newBuffer
	"Answer a new instance containing its own buffer (in this case the buffer
	is just for a pointer)."

	^self new
!

onStartup
	"Private - Notify all the receiver's sub-instances of system startup."

	self primAllInstances do: [:i | i onStartup]!

uninitialize
	"Private - Uninitialize the receiver immediately prior to its removal from the system."

	VM registryAt: #BSTR put: nil.
	SessionManager current removeEventsTriggeredFor: self! !
!OS.COM.BSTR class categoriesForMethods!
basicNew!instance creation!private! !
clear:!public!realizing/unrealizing! !
fromInteger:!instance creation!public! !
fromString:!instance creation!public! !
icon!constants!public! !
initialize!development!initializing!private! !
new!instance creation!public! !
newBuffer!instance creation!public! !
onStartup!event handling!private! !
uninitialize!class hierarchy-removing!private! !
!

