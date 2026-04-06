"Filed out from Dolphin Smalltalk"!

OS.NMHDR
	subclass: #'OS.NMIPADDRESS'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_NMIPADDRESS_Size' -> 16r14.
			'_OffsetOf_iField' -> 16rC.
			'_OffsetOf_iValue' -> 16r10
		}!

OS.NMIPADDRESS guid: (Core.GUID fromString: '{425d0ea6-542e-11d3-998b-d5ca2c3c1d61}')!

OS.NMIPADDRESS comment: '`OS.NMIPADDRESS` is an `External.Structure` class to represent the Win32 IP Address control notification structure of the same name.'!

!OS.NMIPADDRESS methodsFor!

iField
	"Answer the <Integer> value of the receiver's 'iField' field."

	^bytes int32AtOffset: _OffsetOf_iField!

iValue
	"Answer the <Integer> value of the receiver's 'iValue' field."

	^bytes int32AtOffset: _OffsetOf_iValue!

iValue: anInteger
	"Set the receiver's 'iValue' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_iValue put: anInteger!

key
	^self iField+1!

value
	^self iValue!

value: aNumber 
	self iValue: aNumber asInteger! !

!OS.NMIPADDRESS categoriesForMethods!
iField!**compiled accessors**!public! !
iValue!**compiled accessors**!public! !
iValue:!**compiled accessors**!public! !
key!accessing!public! !
value!accessing!public! !
value:!accessing!public! !
!

!OS.NMIPADDRESS class methodsFor!

byteSize
	^_NMIPADDRESS_Size!

defineFields
	"Define the fields of the Win32 NMIPADDRESS structure.

		NMIPADDRESS compileDefinition

	"

	super
		defineFields;
		defineField: #iField type: Int32Field readOnly;
		defineField: #iValue type: Int32Field new!

getFieldNames
	^#(#hwndFrom #idFrom #code #iField #iValue)! !

!OS.NMIPADDRESS class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!initializing!public! !
getFieldNames!**compiled accessors**!constants!private! !
!

