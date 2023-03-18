"Filed out from Dolphin Smalltalk"!

External.Structure
	subclass: #'OS._FPIEEE_VALUE'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'__FPIEEE_VALUE_Size' -> 16r18.
			'_OffsetOf_filler' -> 16r14.
			'_OffsetOf_flags' -> 16r10.
			'_OffsetOf_value' -> 16r0
		}!
OS._FPIEEE_VALUE guid: (Core.GUID fromString: '{836cb53c-b7d3-492c-ad33-8574c49bed82}')!
OS._FPIEEE_VALUE comment: '_FPIEEE_VALUE is an <ExternalStructure> class to represent the Win32 structure of the same name. _FPIEEE_VALUE is used in the reporting of IEEE compliant floating point exceptions. It is essentially a discriminated union that can hold the various types of operand that can be used in floating point operations.'!
!OS._FPIEEE_VALUE categoriesForClass!External-Data-Structured! !
!OS._FPIEEE_VALUE methodsFor!

flags
	"Answer the <Integer> value of the receiver's 'flags' field."

	^bytes uint32AtOffset: _OffsetOf_flags!

format
	"Answer an <integer> which identifies the type of value stored in the receiver."

	^(self flags bitAnd: 16r1E) bitShift: -1!

formatName
	"Answer the symbolic name of the operation being attemped when the exception
	occurred. See fpieee.h in the MS Win32 SDK for further information."

	^self class formatCodes at: self format + 1 ifAbsent: #Unknown!

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
			#uint32AtOffset:		"128-bit float - not supported on Intel h/w"
			#int16AtOffset:
			#int32AtOffset:
			#int64AtOffset:
			#uint16AtOffset:
			#uint32AtOffset:
			#uint64AtOffset:
			#uint32AtOffset: "BCD"
			#uint32AtOffset: "compare?"
			#uint32AtOffset: "string?")
				at: (self format + 1))
		with: 0]! !
!OS._FPIEEE_VALUE categoriesForMethods!
flags!**compiled accessors**!public! !
format!accessing!public! !
formatName!accessing!public! !
isValid!public!testing! !
value!accessing!public! !
!

!OS._FPIEEE_VALUE class methodsFor!

byteSize
	^__FPIEEE_VALUE_Size!

defineFields
	"Define the fields of the _FPIEEE_VALUE 'structure'.

		self compileDefinition
	"

	self
		defineField: #value type: (FillerField byteSize: 16);
		defineField: #flags type: UInt32Field readOnly;
		defineField: #filler type: UInt32Field filler!

formatCodes
	^#(#Fp32 #Fp64 #Fp80 #Fp128 #I16 #I32 #I64 #U16 #U32 #U64 #Bcd80 #Compare #String #Fp82)!

getFieldNames
	^#(#flags)! !
!OS._FPIEEE_VALUE class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
formatCodes!constants!public! !
getFieldNames!**compiled accessors**!constants!private! !
!

