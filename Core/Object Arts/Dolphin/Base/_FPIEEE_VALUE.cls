"Filed out from Dolphin Smalltalk"!

ExternalStructure subclass: #_FPIEEE_VALUE
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_filler _OffsetOf_flags _OffsetOf_value'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

_FPIEEE_VALUE guid: (GUID fromString: '{836cb53c-b7d3-492c-ad33-8574c49bed82}')!

_FPIEEE_VALUE addClassConstant: '_OffsetOf_filler' value: 16r14!
_FPIEEE_VALUE addClassConstant: '_OffsetOf_flags' value: 16r10!
_FPIEEE_VALUE addClassConstant: '_OffsetOf_value' value: 16r0!

_FPIEEE_VALUE comment: '_FPIEEE_VALUE is an <ExternalStructure> class to represent the Win32 structure of the same name. _FPIEEE_VALUE is used in the reporting of IEEE compliant floating point exceptions. It is essentially a discriminated union that can hold the various types of operand that can be used in floating point operations.'!

!_FPIEEE_VALUE categoriesForClass!Unclassified! !

!_FPIEEE_VALUE methodsFor!

flags
	"Answer the <Integer> value of the receiver's 'flags' field."

	^bytes dwordAtOffset: _OffsetOf_flags!

format
	"Answer an <integer> which identifies the type of value stored in the receiver."

	^(self flags bitAnd: 16r1E) bitShift: -1!

formatName
	"Answer the symbolic name of the operation being attemped when the exception
	occurred. See fpieee.h in the MS Win32 SDK for further information."

	^self class formatCodes at: self format + 1 ifAbsent: [#Unknown]!

isValid
	^(self flags allMask: 1)!

value
	"Answer the <Number> value stored in the receiver, of nil if the receiver is not a valid value
	or is of an unsupported format."

	^self isValid ifTrue: [
	    bytes 
		perform: (#(
			floatAtOffset: 
			doubleAtOffset:
			longDoubleAtOffset:	"80-bit float"
			dwordAtOffset:		"128-bit float - not supported on Intel h/w"
			swordAtOffset:
			sdwordAtOffset:
			sqwordAtOffset:
			wordAtOffset:
			dwordAtOffset:
			qwordAtOffset:
			dwordAtOffset: "BCD"
			dwordAtOffset: "compare?"
			dwordAtOffset: "string?")
				at: (self format + 1))
		with: 0]! !

!_FPIEEE_VALUE categoriesForMethods!
flags!**compiled accessors**!public! !
format!accessing!public! !
formatName!accessing!public! !
isValid!public!testing! !
value!accessing!public! !
!

!_FPIEEE_VALUE class methodsFor!

defineFields
	"Define the fields of the _FPIEEE_VALUE 'structure'.

		self compileDefinition
	"

	self
		defineField: #value type: (FillerField byteSize: 16);
		defineField: #flags type: DWORDField readOnly;
		defineField: #filler type: DWORDField filler!

formatCodes
	^#(#Fp32 #Fp64 #Fp80 #Fp128 #I16 #I32 #I64 #U16 #U32 #U64 #Bcd80 #Compare #String #Fp82)!

getFieldNames
	^#(#flags)! !

!_FPIEEE_VALUE class categoriesForMethods!
defineFields!public!template definition! !
formatCodes!constants!public! !
getFieldNames!**compiled accessors**!constants!private! !
!

