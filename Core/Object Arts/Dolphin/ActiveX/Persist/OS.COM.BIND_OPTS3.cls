"Filed out from Dolphin Smalltalk"!

OS.COM.BIND_OPTS2
	subclass: #'OS.COM.BIND_OPTS3'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { '_BIND_OPTS3_Size' -> 16r24. '_OffsetOf_hwnd' -> 16r20 }!

OS.COM.BIND_OPTS3 guid: (Core.GUID fromString: '{4ff80f9b-48b3-4cb4-af46-8c77a6173a31}')!

OS.COM.BIND_OPTS3 comment: 'BIND_OPTS3 is an <ExternalStructure> class to represent the OLE Persistence and Data Transfer structure of the same name.'!

!OS.COM.BIND_OPTS3 categoriesForClass!External-Data-Structured-COM! !

!OS.COM.BIND_OPTS3 methodsFor!

hwnd
	"Answer the <Handle> value of the receiver's 'hwnd' field."

	^(bytes uintPtrAtOffset: _OffsetOf_hwnd) asExternalHandle!

hwnd: aHandle
	"Set the receiver's 'hwnd' field to the value of the argument, aHandle"

	bytes uintPtrAtOffset: _OffsetOf_hwnd put: aHandle! !

!OS.COM.BIND_OPTS3 categoriesForMethods!
hwnd!**compiled accessors**!public! !
hwnd:!**compiled accessors**!public! !
!

!OS.COM.BIND_OPTS3 class methodsFor!

byteSize
	^_BIND_OPTS3_Size!

defineFields
	"Define the fields of the BIND_OPTS2 structure.

	BIND_OPTS3 compileDefinition

	typedef struct tagBIND_OPTS3 {
		DWORD        cbStruct;
		DWORD        grfFlags;
		DWORD        grfMode;
		DWORD        dwTickCountDeadline;
		DWORD        dwTrackFlags;
		DWORD        dwClassContext;
		LCID         locale;
		COSERVERINFO *pServerInfo;
		HWND         hwnd;
	} BIND_OPTS3, *LPBIND_OPTS3;
	"

	super defineFields.
	self defineField: #hwnd type: HANDLEField new!

getFieldNames
	^#(#dwSize #grfFlags #grfMode #dwTickCountDeadline #dwTrackFlags #dwClassContext #locale #pServerInfo #hwnd)! !

!OS.COM.BIND_OPTS3 class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

