"Filed out from Dolphin Smalltalk"!

OS.CCHITTESTINFO
	subclass: #'OS.TCHITTESTINFO'
	instanceVariableNames: 'iItem'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { '_OffsetOf_flags' -> 16r8. '_TCHITTESTINFO_Size' -> 16rC }!
OS.TCHITTESTINFO guid: (Core.GUID fromString: '{a369fa40-e397-4c16-b3f5-b254fd07aebe}')!
OS.TCHITTESTINFO comment: 'TCHITTESTINFO is an ExternalStructure class to represent the Win32 common control structure of the same name.

TCHISTTESTINFO is used for hit-testing with Tab View controls.
'!
!OS.TCHITTESTINFO categoriesForClass!External-Data-Structured-Win32! !
!OS.TCHITTESTINFO methodsFor!

flags
	"Answer the <Integer> value of the receiver's 'flags' field."

	^bytes uint32AtOffset: _OffsetOf_flags!

handle
	"Private - Answer the item 'handle' associated with the receiver.
	In the case of a TabView hit-test, this is a 1-based integer index. The index is not stored in the struct itself, but is returned by the call to TCM_HITTEST and stored down then for later use."

	^iItem + 1!

iItem: anInteger 
	iItem := anInteger! !
!OS.TCHITTESTINFO categoriesForMethods!
flags!**compiled accessors**!public! !
handle!accessing!private! !
iItem:!accessing!private! !
!

!OS.TCHITTESTINFO class methodsFor!

byteSize
	^_TCHITTESTINFO_Size!

defineFields
	"Define the fields of the Win32 TCHITTESTINFO structure.

		TCHITTESTINFO compileDefinition

		typedef struct tagTCHITTESTINFO {
			POINT pt;
			UINT  flags;
		} TCHITTESTINFO, *LPTCHITTESTINFO;"

	super defineFields.
	self
		defineField: #flags type: UInt32Field readOnly.
	self assert: [self byteSize = 12]!

getFieldNames
	^#(#pt #flags)! !
!OS.TCHITTESTINFO class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!development!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

