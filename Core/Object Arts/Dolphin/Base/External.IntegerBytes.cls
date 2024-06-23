"Filed out from Dolphin Smalltalk"!

Core.ByteArray
	variableByteSubclass: #'External.IntegerBytes'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

External.IntegerBytes guid: (Core.GUID fromString: '{f5016870-059b-445b-a045-9e17ef13beec}')!

External.IntegerBytes isNonInstantiable: true!

External.IntegerBytes comment: ''!

!External.IntegerBytes categoriesForClass!External-Data-Unstructured! !

!External.IntegerBytes methodsFor!

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

copyingClass
	"Private - Answer the class of object expected when the receiver is copied in whole or in part."

	^ByteArray!

displayOn: aPuttableStream
	"Append to the <puttableStream> argument a String whose characters are a representation of the receiver that an end-user might want to see."

	self asInteger
		printOn: aPuttableStream
		base: 16
		showRadix: true!

expandMacrosIn: aString

	"Private - Expand aString with the replaceable argument represented by the receiver."

	^aString expandMacrosWith: self!

hash
	"Answer the SmallInteger hash value for the receiver."

	^self asInteger hash!

isNull
	"Answer whether the receiver is Null (i.e. equal to 0). 
	This message is a useful way of testing for NULL pointers or handles.
	Implementation Note: The speed of this test is important."

	<primitive: 171>
	^self asInteger == 0!

printOn: aStream
	"Append a textual representation of the receiver to aStream."

	aStream
		basicPrint: self;
		nextPut: $(; display: self; nextPut: $)
!

value
	"Answer the 32-bit unsigned <integer> value stored in the receiver."

	^self asInteger!

value: anObject 
	^self subclassResponsibility! !

!External.IntegerBytes categoriesForMethods!
=!comparing!public! !
asInteger!converting!public! !
asObject!accessing!public! !
asSignedInteger!converting!public! !
asUIntPtr!converting!public! !
byteSize!accessing!public! !
clear!initializing!public! !
copyingClass!copying!private! !
displayOn:!displaying!public! !
expandMacrosIn:!double dispatch!private! !
hash!comparing!public! !
isNull!public!testing! !
printOn:!printing!public! !
value!accessing!public! !
value:!accessing!public! !
!

!External.IntegerBytes class methodsFor!

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
		IntegerBytes initialize
	"

	self withAllSubclassesDo: [:e | e extraInstanceSpec: self elementSize]!

new
	"Answer a new instance of the receiver of the required size."

	^self newFixed: self elementSize!

pointerFieldType
	^PointerField!

valueAtAddress: anAddress 
	^self subclassResponsibility! !

!External.IntegerBytes class categoriesForMethods!
atAddress:!instance creation!public! !
fromAddress:!instance creation!public! !
fromInteger:!instance creation!public! !
initialize!development!initializing!private! !
new!instance creation!public! !
pointerFieldType!constants!private! !
valueAtAddress:!helpers!private! !
!

