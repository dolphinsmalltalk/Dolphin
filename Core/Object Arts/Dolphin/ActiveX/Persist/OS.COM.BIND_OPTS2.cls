"Filed out from Dolphin Smalltalk"!

OS.COM.BIND_OPTS
	subclass: #'OS.COM.BIND_OPTS2'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_BIND_OPTS2_Size' -> 16r20.
			'_OffsetOf_dwClassContext' -> 16r14.
			'_OffsetOf_dwTrackFlags' -> 16r10.
			'_OffsetOf_locale' -> 16r18.
			'_OffsetOf_pServerInfo' -> 16r1C
		}!

OS.COM.BIND_OPTS2 guid: (Core.GUID fromString: '{87b4c5bf-026e-11d3-9fd7-00a0cc3e4a32}')!

OS.COM.BIND_OPTS2 comment: 'BIND_OPTS2 is an <ExternalStructure> class to represent the COM structure of the same name.

BIND_OPTS2 is a DCOM extentsion of BIND_OPTS which adds a COSERVERINFO field to enable a remote machine to be specified as the bind destination.'!

!OS.COM.BIND_OPTS2 categoriesForClass!External-Data-Structured-COM! !

!OS.COM.BIND_OPTS2 methodsFor!

dwClassContext
	"Answer the <Integer> value of the receiver's 'dwClassContext' field."

	^bytes uint32AtOffset: _OffsetOf_dwClassContext!

dwClassContext: anInteger
	"Set the receiver's 'dwClassContext' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_dwClassContext put: anInteger!

dwTrackFlags
	"Answer the <Integer> value of the receiver's 'dwTrackFlags' field."

	^bytes uint32AtOffset: _OffsetOf_dwTrackFlags!

dwTrackFlags: anInteger
	"Set the receiver's 'dwTrackFlags' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_dwTrackFlags put: anInteger!

locale
	"Answer the <Integer> value of the receiver's 'locale' field."

	^bytes uint32AtOffset: _OffsetOf_locale!

locale: anInteger
	"Set the receiver's 'locale' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_locale put: anInteger!

pServerInfo
	"Answer the <COSERVERINFO> value of the receiver's 'pServerInfo' field."

	^COSERVERINFO fromAddress: (bytes intPtrAtOffset: _OffsetOf_pServerInfo)!

pServerInfo: aCOSERVERINFO
	"Set the receiver's 'pServerInfo' field to the value of the argument, aCOSERVERINFO"

	bytes uintPtrAtOffset: _OffsetOf_pServerInfo put: aCOSERVERINFO yourAddress! !

!OS.COM.BIND_OPTS2 categoriesForMethods!
dwClassContext!**compiled accessors**!public! !
dwClassContext:!**compiled accessors**!public! !
dwTrackFlags!**compiled accessors**!public! !
dwTrackFlags:!**compiled accessors**!public! !
locale!**compiled accessors**!public! !
locale:!**compiled accessors**!public! !
pServerInfo!**compiled accessors**!public! !
pServerInfo:!**compiled accessors**!public! !
!

!OS.COM.BIND_OPTS2 class methodsFor!

byteSize
	^_BIND_OPTS2_Size!

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
		defineField: #dwTrackFlags type: UInt32Field new;
		defineField: #dwClassContext type: UInt32Field new;
		defineField: #locale type: UInt32Field new;
		defineField: #pServerInfo type: (PointerField type: COSERVERINFO)!

getFieldNames
	^#(#dwSize #grfFlags #grfMode #dwTickCountDeadline #dwTrackFlags #dwClassContext #locale #pServerInfo)! !

!OS.COM.BIND_OPTS2 class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

