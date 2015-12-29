"Filed out from Dolphin Smalltalk X6"!

ExternalStructure subclass: #INPUT
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
INPUT guid: (GUID fromString: '{6A520D8F-1DCB-456C-9933-95EE79174BD6}')!
INPUT comment: '<INPUT> is an <ExternalStructure> class to wrap the struct ''Win32.INPUT'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains the following helpstring for this struct
	"Used by SendInput() to store information for synthesizing input events such as keystrokes, mouse movement, and mouse clicks."

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(6A520D8F-1DCB-456C-9933-95EE79174BD6), helpstring("Used by SendInput() to store information for synthesizing input events such as keystrokes, mouse movement, and mouse clicks.")]
struct tagINPUT {
	[helpstring("Specifies the type of the input event")] INPUTSources Type;
	union {
		[helpstring("Contains information about a simulated mouse event.")] MOUSEINPUT mi;
		[helpstring("Contains information about a simulated keyboard event.")] KEYBDINPUT ki;
		[helpstring("Contains information about a simulated event from input hardware other than a keyboard or mouse.")] HARDWAREINPUT hi;
	} ;

} INPUT;
'!
!INPUT categoriesForClass!Win32-Structs! !
!INPUT methodsFor!

hi
	"Answer the receiver's hi field as a Smalltalk object."

	^HARDWAREINPUT fromAddress: (bytes yourAddress + 4)!

hi: anObject
	"Set the receiver's hi field to the value of anObject."

	anObject replaceBytesOf: bytes from: 5 to: 4 startingAt: 1!

ki
	"Answer the receiver's ki field as a Smalltalk object."

	^KEYBDINPUT fromAddress: (bytes yourAddress + 4)!

ki: anObject
	"Set the receiver's ki field to the value of anObject."

	anObject replaceBytesOf: bytes from: 5 to: 4 startingAt: 1!

mi
	"Answer the receiver's mi field as a Smalltalk object."

	^MOUSEINPUT fromAddress: (bytes yourAddress + 4)!

mi: anObject
	"Set the receiver's mi field to the value of anObject."

	anObject replaceBytesOf: bytes from: 5 to: 4 startingAt: 1!

Type
	"Answer the receiver's Type field as a Smalltalk object."

	^(bytes sdwordAtOffset: 0)!

Type: anObject
	"Set the receiver's Type field to the value of anObject."

	bytes sdwordAtOffset: 0 put: anObject! !
!INPUT categoriesFor: #hi!**compiled accessors**!public! !
!INPUT categoriesFor: #hi:!**compiled accessors**!public! !
!INPUT categoriesFor: #ki!**compiled accessors**!public! !
!INPUT categoriesFor: #ki:!**compiled accessors**!public! !
!INPUT categoriesFor: #mi!**compiled accessors**!public! !
!INPUT categoriesFor: #mi:!**compiled accessors**!public! !
!INPUT categoriesFor: #Type!**compiled accessors**!public! !
!INPUT categoriesFor: #Type:!**compiled accessors**!public! !

!INPUT class methodsFor!

defineFields
	"Define the fields of the INPUT structure.

	INPUT  compileDefinition

		typedef [uuid(6A520D8F-1DCB-456C-9933-95EE79174BD6), helpstring('Used by SendInput() to store information for synthesizing input events such as keystrokes, mouse movement, and mouse clicks.')]
		struct tagINPUT {
			[helpstring('Specifies the type of the input event')] INPUTSources Type;
			union {
				[helpstring('Contains information about a simulated mouse event.')] MOUSEINPUT mi;
				[helpstring('Contains information about a simulated keyboard event.')] KEYBDINPUT ki;
				[helpstring('Contains information about a simulated event from input hardware other than a keyboard or mouse.')] HARDWAREINPUT hi;
			} ;

		} INPUT;
"

	self
		defineField: #Type type: SDWORDField new offset: 0;
		defineField: #mi type: (StructureField type: MOUSEINPUT) offset: 4;
		defineField: #ki type: (StructureField type: KEYBDINPUT) offset: 4;
		defineField: #hi type: (StructureField type: HARDWAREINPUT) offset: 4.
	self byteSize: 28! !
!INPUT class categoriesFor: #defineFields!**auto generated**!initializing!public! !

