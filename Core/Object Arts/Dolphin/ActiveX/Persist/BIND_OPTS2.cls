"Filed out from Dolphin Smalltalk"!

BIND_OPTS subclass: #BIND_OPTS2
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_dwClassContext _OffsetOf_dwTrackFlags _OffsetOf_locale _OffsetOf_pServerInfo'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

BIND_OPTS2 guid: (GUID fromString: '{87b4c5bf-026e-11d3-9fd7-00a0cc3e4a32}')!

BIND_OPTS2 addClassConstant: '_OffsetOf_dwClassContext' value: 16r14!
BIND_OPTS2 addClassConstant: '_OffsetOf_dwTrackFlags' value: 16r10!
BIND_OPTS2 addClassConstant: '_OffsetOf_locale' value: 16r18!
BIND_OPTS2 addClassConstant: '_OffsetOf_pServerInfo' value: 16r1C!

BIND_OPTS2 comment: 'BIND_OPTS2 is an <ExternalStructure> class to represent the COM structure of the same name.

BIND_OPTS2 is a DCOM extentsion of BIND_OPTS which adds a COSERVERINFO field to enable a remote machine to be specified as the bind destination.'!

!BIND_OPTS2 categoriesForClass!External-Data-Structured-COM! !

!BIND_OPTS2 methodsFor!

dwClassContext
	"Answer the <Integer> value of the receiver's 'dwClassContext' field."

	^bytes dwordAtOffset: _OffsetOf_dwClassContext!

dwClassContext: anInteger
	"Set the receiver's 'dwClassContext' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwClassContext put: anInteger!

dwSize: anInteger
	"Set the receiver's 'dwSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwSize put: anInteger!

dwTrackFlags
	"Answer the <Integer> value of the receiver's 'dwTrackFlags' field."

	^bytes dwordAtOffset: _OffsetOf_dwTrackFlags!

dwTrackFlags: anInteger
	"Set the receiver's 'dwTrackFlags' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwTrackFlags put: anInteger!

locale
	"Answer the <Integer> value of the receiver's 'locale' field."

	^bytes dwordAtOffset: _OffsetOf_locale!

locale: anInteger
	"Set the receiver's 'locale' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_locale put: anInteger!

pServerInfo
	"Answer the <COSERVERINFO> value of the receiver's 'pServerInfo' field."

	^COSERVERINFO fromAddress: (bytes intPtrAtOffset: _OffsetOf_pServerInfo)!

pServerInfo: aCOSERVERINFO
	"Set the receiver's 'pServerInfo' field to the value of the argument, aCOSERVERINFO"

	bytes uintPtrAtOffset: _OffsetOf_pServerInfo put: aCOSERVERINFO yourAddress! !

!BIND_OPTS2 categoriesForMethods!
dwClassContext!**compiled accessors**!public! !
dwClassContext:!**compiled accessors**!public! !
dwSize:!**compiled accessors**!public! !
dwTrackFlags!**compiled accessors**!public! !
dwTrackFlags:!**compiled accessors**!public! !
locale!**compiled accessors**!public! !
locale:!**compiled accessors**!public! !
pServerInfo!**compiled accessors**!public! !
pServerInfo:!**compiled accessors**!public! !
!

!BIND_OPTS2 class methodsFor!

defineFields
	"Define the additional fields of the BIND_OPTS2 structure.

		BIND_OPTS2 compileDefinition.

		struct  BIND_OPTS2
		{
			DWORD	cbStruct;
			DWORD	grfFlags;
			DWORD	grfMode;
			DWORD 	dwTickCountDeadline;
			DWORD   dwTrackFlags;
			DWORD   dwClassContext;
			LCID        locale;
			COSERVERINFO * pServerInfo;
		};
	"

	super defineFields.
	self
		defineField: #dwTrackFlags type: DWORDField new;
		defineField: #dwClassContext type: DWORDField new;
		defineField: #locale type: DWORDField new;
		defineField: #pServerInfo type: (PointerField type: COSERVERINFO)!

getFieldNames
	^#(#dwSize #grfFlags #grfMode #dwTickCountDeadline #dwTrackFlags #dwClassContext #locale #pServerInfo)! !

!BIND_OPTS2 class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

