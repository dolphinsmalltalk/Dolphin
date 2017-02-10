"Filed out from Dolphin Smalltalk 7"!

SDWORD subclass: #BOOL
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
BOOL guid: (GUID fromString: '{73888634-0c5b-4d09-83dc-c52101c10ba3}')!
BOOL comment: '<BOOL> is an <ExternalStructure> class to represent the Win32 BOOL (integer boolean) type.

Possible values are: 
	0 (defined as FALSE), equivalent to Smalltalk ''false'' object.
	1 (defined as TRUE), or indeed any other non-zero value, equivalent to Smalltalk ''true'' object.'!
!BOOL categoriesForClass!Win32-Structs! !
!BOOL methodsFor!

value
	"Answer the <Boolean> value of the receiver's 'value' field."

	^(bytes dwordAtOffset: 0) asBoolean!

value: aBoolean
	"Set the receiver's 'value' field to the value of the argument, aBoolean"

	bytes dwordAtOffset: 0 put: aBoolean asParameter! !
!BOOL categoriesFor: #value!**compiled accessors**!public! !
!BOOL categoriesFor: #value:!**compiled accessors**!public! !

!BOOL class methodsFor!

defineFields
	"Define the fields of the BOOL structure.
		BOOL compileDefinition
	
		typedef [uuid(73888634-0C5B-4D09-83DC-C52101C10BA3), 
			helpstring('An integer representing a boolean value (0 if FALSE, any other value TRUE)')]
		struct tagBOOL {
			long value;
		} BOOL;
	"

	self defineField: #value
		type: ((BOOLField new)
				beOverride;
				yourself)!

fieldType
	"Private - Answer the <ExternalField> type to be used to represent the receiver's field type in 
	other structures."

	^BOOLField!

icon
	"Answers an Icon that can be used to represent this class"

	^Boolean icon! !
!BOOL class categoriesFor: #defineFields!initializing!public! !
!BOOL class categoriesFor: #fieldType!constants!development!private! !
!BOOL class categoriesFor: #icon!constants!public! !

