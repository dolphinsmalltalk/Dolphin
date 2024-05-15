"Filed out from Dolphin Smalltalk"!

CCHITTESTINFO subclass: #TCHITTESTINFO
	instanceVariableNames: 'iItem'
	classVariableNames: '_OffsetOf_flags'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

TCHITTESTINFO guid: (GUID fromString: '{a369fa40-e397-4c16-b3f5-b254fd07aebe}')!

TCHITTESTINFO addClassConstant: '_OffsetOf_flags' value: 16r8!

TCHITTESTINFO comment: 'TCHITTESTINFO is an ExternalStructure class to represent the Win32 common control structure of the same name.

TCHISTTESTINFO is used for hit-testing with Tab View controls.
'!

!TCHITTESTINFO categoriesForClass!External-Data-Structured-Win32! !

!TCHITTESTINFO methodsFor!

handle
	"Private - Answer the item 'handle' associated with the receiver.
	In the case of a TabView hit-test, this is a 1-based integer index."

	^iItem + 1!

iItem: anInteger 
	iItem := anInteger! !

!TCHITTESTINFO categoriesForMethods!
handle!accessing!private! !
iItem:!accessing!private! !
!

!TCHITTESTINFO class methodsFor!

defineFields
	"Define the fields of the Win32 TCHITTESTINFO structure.

		TCHITTESTINFO compileDefinition

		typedef struct tagTCHITTESTINFO {
			POINT pt;
			UINT  flags;
		} TCHITTESTINFO, *LPTCHITTESTINFO;"

	super defineFields.
	self defineField: #flags type: SDWORDField readOnly.
	self assert: [self byteSize = 12]!

getFieldNames
	^#(#pt #flags)! !

!TCHITTESTINFO class categoriesForMethods!
defineFields!development!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

