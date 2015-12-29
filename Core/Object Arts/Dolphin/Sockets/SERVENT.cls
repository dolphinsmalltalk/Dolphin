"Filed out from Dolphin Smalltalk X6.1"!

Win32Structure subclass: #SERVENT
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SERVENT guid: (GUID fromString: '{87B4C610-026E-11D3-9FD7-00A0CC3E4A32}')!
SERVENT comment: '<SERVENT> is an <ExternalStructure> class to wrap the struct ''WINSOCK2Lib.servent'' from type information in the ''Windows Sockets 2 Type Library'' library. The SERVENT structure is used to hold service information. The structure is allocated by Windows Sockets, one per thread, and the contents must not be modified. 

IDL definition follows:

typedef struct tagservent {
	CHAR* s_name;
	CHAR** s_aliases;
	short s_port;
	CHAR* s_proto;
} servent;
'!
!SERVENT categoriesForClass!External-Data-Structured-Win32!Windows Sockets! !
!SERVENT methodsFor!

s_name
	"Answer the receiver's s_name field as a Smalltalk object."

	^String fromAddress: (bytes intPtrAtOffset: 0)!

s_port
	"Answer the receiver's s_port field as a Smalltalk object."

	^(bytes swordAtOffset: 8)!

s_proto
	"Answer the receiver's s_proto field as a Smalltalk object."

	^String fromAddress: (bytes intPtrAtOffset: 12)! !
!SERVENT categoriesFor: #s_name!**compiled accessors**!public! !
!SERVENT categoriesFor: #s_port!**compiled accessors**!public! !
!SERVENT categoriesFor: #s_proto!**compiled accessors**!public! !

!SERVENT class methodsFor!

defineFields
	"Define the fields of the servent structure.
		SERVENT compileDefinition
	
		typedef 		struct tagservent {
			CHAR* s_name;
			CHAR** s_aliases;
			short s_port;
			CHAR* s_proto;
		} servent;
"

	self
		defineField: #s_name type: (PointerField type: String) beReadOnly;
		defineField: #s_aliases type: LPVOIDField filler;
		defineField: #s_port type: SWORDField readOnly;
		defineField: #s_proto type: (PointerField type: String) beReadOnly! !
!SERVENT class categoriesFor: #defineFields!initializing!public! !

