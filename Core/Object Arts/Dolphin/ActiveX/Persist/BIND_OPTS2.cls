"Filed out from Dolphin Smalltalk 7"!

BIND_OPTS subclass: #BIND_OPTS2
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
BIND_OPTS2 guid: (GUID fromString: '{87b4c5bf-026e-11d3-9fd7-00a0cc3e4a32}')!
BIND_OPTS2 comment: 'BIND_OPTS2 is an <ExternalStructure> class to represent the COM structure of the same name.

BIND_OPTS2 is a DCOM extentsion of BIND_OPTS which adds a COSERVERINFO field to enable a remote machine to be specified as the bind destination.'!
!BIND_OPTS2 categoriesForClass!External-Data-Structured-COM! !
!BIND_OPTS2 methodsFor!

dwClassContext
	"Answer the receiver's dwClassContext field as a Smalltalk object."

	^(bytes dwordAtOffset: 20)!

dwClassContext: anObject
	"Set the receiver's dwClassContext field to the value of anObject."

	bytes dwordAtOffset: 20 put: anObject!

dwTrackFlags
	"Answer the receiver's dwTrackFlags field as a Smalltalk object."

	^(bytes dwordAtOffset: 16)!

dwTrackFlags: anObject
	"Set the receiver's dwTrackFlags field to the value of anObject."

	bytes dwordAtOffset: 16 put: anObject!

locale
	"Answer the receiver's locale field as a Smalltalk object."

	^(bytes dwordAtOffset: 24)!

locale: anObject
	"Set the receiver's locale field to the value of anObject."

	bytes dwordAtOffset: 24 put: anObject!

pServerInfo
	"Answer the receiver's pServerInfo field as a Smalltalk object."

	^COSERVERINFO fromAddress: (bytes intPtrAtOffset: 28)!

pServerInfo: anObject 
	"Set the receiver's pServerInfo field to the value of anObject."

	bytes uintPtrAtOffset: 28 put: anObject yourAddress! !
!BIND_OPTS2 categoriesFor: #dwClassContext!**compiled accessors**!public! !
!BIND_OPTS2 categoriesFor: #dwClassContext:!**compiled accessors**!public! !
!BIND_OPTS2 categoriesFor: #dwTrackFlags!**compiled accessors**!public! !
!BIND_OPTS2 categoriesFor: #dwTrackFlags:!**compiled accessors**!public! !
!BIND_OPTS2 categoriesFor: #locale!**compiled accessors**!public! !
!BIND_OPTS2 categoriesFor: #locale:!**compiled accessors**!public! !
!BIND_OPTS2 categoriesFor: #pServerInfo!**compiled accessors**!public! !
!BIND_OPTS2 categoriesFor: #pServerInfo:!**compiled accessors**!public! !

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
		defineField: #dwTrackFlags		type: DWORDField new;
		defineField: #dwClassContext	type: DWORDField new;
		defineField: #locale			type: DWORDField new;
		defineField: #pServerInfo		type: (PointerField type: COSERVERINFO)! !
!BIND_OPTS2 class categoriesFor: #defineFields!initializing!public! !

