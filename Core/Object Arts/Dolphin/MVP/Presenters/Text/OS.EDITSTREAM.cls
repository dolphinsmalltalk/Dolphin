"Filed out from Dolphin Smalltalk"!

OS.Win32Structure subclass: #'OS.EDITSTREAM'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_EDITSTREAM_Size' -> 16rC.
		'_OffsetOf_dwCookie' -> 16r0.
		'_OffsetOf_dwError' -> 16r4.
		'_OffsetOf_pfnCallback' -> 16r8
	}!
OS.EDITSTREAM guid: (Core.GUID fromString: '{87b4c5ef-026e-11d3-9fd7-00a0cc3e4a32}')!
OS.EDITSTREAM comment: ''!
!OS.EDITSTREAM categoriesForClass!External-Data-Structured-Win32! !
!OS.EDITSTREAM methodsFor!

pfnCallback: anExternalAddress
	"Set the receiver's 'pfnCallback' field to the value of the argument, anExternalAddress"

	bytes uintPtrAtOffset: _OffsetOf_pfnCallback put: anExternalAddress! !
!OS.EDITSTREAM categoriesForMethods!
pfnCallback:!**compiled accessors**!public! !
!

!OS.EDITSTREAM class methodsFor!

byteSize
	^_EDITSTREAM_Size!

defineFields
	"Define the fields of the Win32 EDITSTREAM structure.

		EDITSTREAM compileDefinition

	typedef struct _editstream { 
		DWORD dwCookie; 
		DWORD dwError; 
		EDITSTREAMCALLBACK pfnCallback; 
	} EDITSTREAM;"

	self
		defineField: #dwCookie type: UInt32Field filler;
		defineField: #dwError type: UInt32Field filler;
		defineField: #pfnCallback type: LPVOIDField writeOnly!

getFieldNames
	^#(#pfnCallback)! !
!OS.EDITSTREAM class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

