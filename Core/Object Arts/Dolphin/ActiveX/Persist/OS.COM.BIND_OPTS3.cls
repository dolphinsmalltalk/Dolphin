"Filed out from Dolphin Smalltalk"!

BIND_OPTS2 subclass: #BIND_OPTS3
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_hwnd'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
BIND_OPTS3 guid: (GUID fromString: '{4ff80f9b-48b3-4cb4-af46-8c77a6173a31}')!
BIND_OPTS3 addClassConstant: '_OffsetOf_hwnd' value: 16r20!
BIND_OPTS3 comment: 'BIND_OPTS3 is an <ExternalStructure> class to represent the OLE Persistence and Data Transfer structure of the same name.'!
!BIND_OPTS3 categoriesForClass!External-Data-Structured-COM! !
!BIND_OPTS3 methodsFor!

dwSize: anInteger
	"Set the receiver's 'dwSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwSize put: anInteger!

hwnd
	"Answer the <ExternalHandle> value of the receiver's 'hwnd' field."

	^(bytes uintPtrAtOffset: _OffsetOf_hwnd) asExternalHandle!

hwnd: anExternalHandle
	"Set the receiver's 'hwnd' field to the value of the argument, anExternalHandle"

	bytes uintPtrAtOffset: _OffsetOf_hwnd put: anExternalHandle! !
!BIND_OPTS3 categoriesForMethods!
dwSize:!**compiled accessors**!public! !
hwnd!**compiled accessors**!public! !
hwnd:!**compiled accessors**!public! !
!

!BIND_OPTS3 class methodsFor!

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
!BIND_OPTS3 class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

