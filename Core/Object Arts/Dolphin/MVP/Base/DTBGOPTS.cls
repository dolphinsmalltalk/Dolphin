"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #DTBGOPTS
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DTBGOPTS guid: (GUID fromString: '{cdf611d8-4c3f-48a1-b3eb-fd222762e69b}')!
DTBGOPTS comment: '<DTBGOPTS> is an <ExternalStructure> class to wrap the struct ''Win32.DTBGOPTS'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains the following helpstring for this struct
	"Defines the options for the DrawThemeBackgroundEx function."

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(CDF611D8-4C3F-48A1-B3EB-FD222762E69B), helpstring("Defines the options for the DrawThemeBackgroundEx function.")]
struct tagDTBGOPTS {
	[helpstring("size of the struct")] unsigned long dwSize;
	[helpstring("which options have been specified")] unsigned long dwFlags;
	[helpstring("clipping rectangle")] RECT rcClip;
} DTBGOPTS;
'!
!DTBGOPTS categoriesForClass!Win32-Structs! !
!DTBGOPTS methodsFor!

dwFlags
	"Answer the receiver's dwFlags field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #dwFlags)!

dwFlags: anObject 
	"Set the receiver's dwFlags field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #dwFlags) put: anObject!

dwSize
	"Answer the receiver's dwSize field as a Smalltalk object."

	^bytes dwordAtOffset: 0!

dwSize: anObject 
	"Set the receiver's dwSize field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject!

rcClip
	"Answer the receiver's rcClip field as a Smalltalk object."

	^RECT fromAddress: bytes yourAddress + ##(self offsetOf: #rcClip)!

rcClip: anObject 
	"Set the receiver's rcClip field to the value of anObject."

	anObject 
		replaceBytesOf: bytes
		from: ##((self offsetOf: #rcClip) + 1)
		to: ##((self offsetOf: #rcClip) + RECT basicByteSize)
		startingAt: 1! !
!DTBGOPTS categoriesFor: #dwFlags!**compiled accessors**!public! !
!DTBGOPTS categoriesFor: #dwFlags:!**compiled accessors**!public! !
!DTBGOPTS categoriesFor: #dwSize!**compiled accessors**!public! !
!DTBGOPTS categoriesFor: #dwSize:!**compiled accessors**!public! !
!DTBGOPTS categoriesFor: #rcClip!**compiled accessors**!public! !
!DTBGOPTS categoriesFor: #rcClip:!**compiled accessors**!public! !

!DTBGOPTS class methodsFor!

defineFields
	"Define the fields of the DTBGOPTS structure.
		DTBGOPTS compileDefinition
	
		typedef [uuid(CDF611D8-4C3F-48A1-B3EB-FD222762E69B), helpstring('Defines the options for the DrawThemeBackgroundEx function.')]
		struct tagDTBGOPTS {
			[helpstring('size of the struct')] unsigned long dwSize;
			[helpstring('which options have been specified')] unsigned long dwFlags;
			[helpstring('clipping rectangle')] RECT rcClip;
		} DTBGOPTS;
"

	self
		defineField: #dwSize type: DWORDField new;
		defineField: #dwFlags type: DWORDField new;
		defineField: #rcClip type: (StructureField type: RECT)! !
!DTBGOPTS class categoriesFor: #defineFields!**auto generated**!initializing!public! !

