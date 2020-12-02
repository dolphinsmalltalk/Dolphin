"Filed out from Dolphin Smalltalk 7"!

SDWORD subclass: #BOOL
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
BOOL guid: (GUID fromString: '{73888634-0c5b-4d09-83dc-c52101c10ba3}')!
BOOL comment: '<BOOL> is an <ExternalStructure> class to represent the Win32 BOOL (integer boolean) type.

Possible values are: 
	0 (defined as FALSE), equivalent to Smalltalk ''false'' object.
	1 (defined as TRUE), or indeed any other non-zero value, equivalent to Smalltalk ''true'' object.'!
!BOOL categoriesForClass!Win32-Structs! !
!BOOL methodsFor!

value
	"Answer the <Boolean> value of the receiver's 'value' field."

	^(bytes dwordAtOffset: _OffsetOf_value) asBoolean!

value: aBoolean
	"Set the receiver's 'value' field to the value of the argument, aBoolean"

	bytes dwordAtOffset: _OffsetOf_value put: aBoolean asParameter! !
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
				yourself)! !
!BOOL class categoriesFor: #defineFields!public!template definition! !

