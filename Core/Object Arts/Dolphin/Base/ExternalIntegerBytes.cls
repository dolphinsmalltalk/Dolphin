"Filed out from Dolphin Smalltalk"!

ByteArray variableByteSubclass: #ExternalIntegerBytes
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ExternalIntegerBytes guid: (GUID fromString: '{f5016870-059b-445b-a045-9e17ef13beec}')!

ExternalIntegerBytes isAbstract: true!

ExternalIntegerBytes comment: ''!

!ExternalIntegerBytes categoriesForClass!External-Data-Unstructured! !

!ExternalIntegerBytes methodsFor!

= anObject
	"Answer whether the receiver is equivalent to anObject."

	^anObject = self asInteger!

asInteger
	^self subclassResponsibility!

asObject
	"Answer the <Object> value represented by the receiver."

	^self value!

asSignedInteger
	^self subclassResponsibility!

asUIntPtr
	"Answer the receiver in a form suitable for passing/returning as a Windows LRESULT
	(32 or 64-bit, depending on host OS) return value. The default is self (which will cause the
	default window proc. of the window to be called for most objects other than Integers when
	used as a return value)."

	^self asInteger!

byteSize
	"Answer the size in bytes of this structure."

	^self size!

clear
	"Initialize the receiver's value to zero."

	self value: 0!

displayOn: aStream
	"Append a textual representation of the receiver to aStream."

	self asInteger printOn: aStream base: 16 showRadix: true!

expandMacrosIn: aString

	"Private - Expand aString with the replaceable argument represented by the receiver."

	^aString expandMacrosWith: self!

hash
	"Answer the SmallInteger hash value for the receiver."

	^self asInteger hash!

isNull
	"Answer whether the receiver is Null (i.e. equal to 0). 
	This message is useful way of testing for NULL pointers or handles.
	Implementation Note: The speed of this test is important."

	<primitive: 171>
	^self asInteger == 0!

printOn: aStream
	"Append a textual representation of the receiver to aStream."

	aStream
		basicPrint: self;
		nextPut: $(; display: self; nextPut: $)
!

species
	"Answer the class of object to be used when copying the contents of the receiver."

	^ByteArray!

value
	"Answer the 32-bit unsigned <integer> value stored in the receiver."

	^self asInteger!

value: anObject 
	^self subclassResponsibility! !

!ExternalIntegerBytes categoriesForMethods!
=!comparing!public! !
asInteger!converting!public! !
asObject!accessing!public! !
asSignedInteger!converting!public! !
asUIntPtr!converting!public! !
byteSize!accessing!public! !
clear!initializing!public! !
displayOn:!displaying!public! !
expandMacrosIn:!double dispatch!private! !
hash!comparing!public! !
isNull!public!testing! !
printOn:!printing!public! !
species!constants!public! !
value!accessing!public! !
value:!accessing!public! !
!

!ExternalIntegerBytes class methodsFor!

atAddress: anAddress 
	"Answer a new instance of the receiver with contents copied from
	the external integer pointed at by anAddress."

	^self fromInteger: (self valueAtAddress: anAddress)!

fromAddress: anAddress 
	"Answer a new instance of the receiver with contents *copied* from
	the external integer pointed at by anAddress (this is not a reference object
	and so must copy in response to #fromAddress:)"

	^self atAddress: anAddress!

fromInteger: anInteger
	"Answer a new instance of the receiver with contents copied from anInteger"

	^self new value: anInteger!

initialize
	"Private - Initialize the receiver's class variables.
		DWORDBytes initialize
	"

	self withAllSubclassesDo: [:e | e extraInstanceSpec: self elementSize]!

new
	"Answer a new instance of the receiver of the required size."

	^self newFixed: self elementSize!

valueAtAddress: anAddress 
	^self subclassResponsibility! !

!ExternalIntegerBytes class categoriesForMethods!
atAddress:!instance creation!public! !
fromAddress:!instance creation!public! !
fromInteger:!instance creation!public! !
initialize!development!initializing!private! !
new!instance creation!public! !
valueAtAddress:!helpers!private! !
!

