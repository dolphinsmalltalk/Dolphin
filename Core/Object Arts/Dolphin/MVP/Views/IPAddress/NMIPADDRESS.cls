"Filed out from Dolphin Smalltalk X6"!

NMHDR subclass: #NMIPADDRESS
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'IPAddressControlConstants'
	classInstanceVariableNames: ''!
NMIPADDRESS guid: (GUID fromString: '{425D0EA6-542E-11D3-998B-D5CA2C3C1D61}')!
NMIPADDRESS comment: 'NMIPADDRESS  is an <ExternalStructure> class to represent the Win32 IP Address control notification structure of the same name.

All the fields in this structure are read-only. Specialized sub-structures provide fields which can be written to in order to pass custom draw settings back to the control (for example the foreground and background text colours). The DC associated with this structure can also be updated by changing the font, and so forth.

'!
!NMIPADDRESS categoriesForClass!Unclassified! !
!NMIPADDRESS methodsFor!

iField
	"Answer the receiver's iField field as a Smalltalk object."

	^(bytes sdwordAtOffset: 12)!

iField: anObject
	"Set the receiver's iField field to the value of anObject."

	bytes sdwordAtOffset: 12 put: anObject!

iValue
	"Answer the receiver's iValue field as a Smalltalk object."

	^(bytes sdwordAtOffset: 16)!

iValue: anObject
	"Set the receiver's iValue field to the value of anObject."

	bytes sdwordAtOffset: 16 put: anObject!

key
	^self iField+1!

value
	^self iValue!

value: aNumber 
	self iValue: aNumber asInteger! !
!NMIPADDRESS categoriesFor: #iField!**compiled accessors**!public! !
!NMIPADDRESS categoriesFor: #iField:!**compiled accessors**!public! !
!NMIPADDRESS categoriesFor: #iValue!**compiled accessors**!public! !
!NMIPADDRESS categoriesFor: #iValue:!**compiled accessors**!public! !
!NMIPADDRESS categoriesFor: #key!accessing!public! !
!NMIPADDRESS categoriesFor: #value!accessing!public! !
!NMIPADDRESS categoriesFor: #value:!accessing!public! !

!NMIPADDRESS class methodsFor!

defineFields
	"Define the fields of the Win32 NMIPADDRESS structure.

		NMIPADDRESS compileDefinition

	"

	super
		defineFields;
		defineField: #iField type: SDWORDField new;
		defineField: #iValue type: SDWORDField new! !
!NMIPADDRESS class categoriesFor: #defineFields!initializing!public! !

