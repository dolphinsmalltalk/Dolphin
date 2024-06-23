"Filed out from Dolphin Smalltalk"!

External.Structure
	subclass: #'OS._FPIEEE_VALUE'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'__FPIEEE_VALUE_Size' -> 16r18.
			'_FpFormatBcd80' -> 16rA.
			'_FpFormatCompare' -> 16rB.
			'_FpFormatFp128' -> 16r3.
			'_FpFormatFp32' -> 16r0.
			'_FpFormatFp64' -> 16r1.
			'_FpFormatFp80' -> 16r2.
			'_FpFormatI16' -> 16r4.
			'_FpFormatI32' -> 16r5.
			'_FpFormatI64' -> 16r6.
			'_FpFormatString' -> 16rC.
			'_FpFormatU16' -> 16r7.
			'_FpFormatU32' -> 16r8.
			'_FpFormatU64' -> 16r9.
			'_FPIEEE_FORMAT'
				-> #('_FpFormatFp32' '_FpFormatFp64' '_FpFormatFp80' '_FpFormatFp128' '_FpFormatI16' '_FpFormatI32' '_FpFormatI64' '_FpFormatU16' '_FpFormatU32' '_FpFormatU64' '_FpFormatBcd80' '_FpFormatCompare' '_FpFormatString').
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

	^_FPIEEE_FORMAT at: self format + 1 ifAbsent: 'Unknown'!

isValid
	^(self flags allMask: 1)!

value
	"Answer the <Number> value stored in the receiver, of nil if the receiver is not a valid value
	or is of an unsupported format."

	^self isValid ifTrue: [
	    bytes 
		perform: (#(
			#floatAtOffset: 
			#doubleAtOffset:
			#longDoubleAtOffset:	"80-bit float"
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

getFieldNames
	^#(#flags)! !

!OS._FPIEEE_VALUE class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

