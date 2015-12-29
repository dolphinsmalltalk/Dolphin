"Filed out from Dolphin Smalltalk X6.1"!

Win32Structure subclass: #PROTOENT
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PROTOENT guid: (GUID fromString: '{87B4C60A-026E-11D3-9FD7-00A0CC3E4A32}')!
PROTOENT comment: '<PROTOENT> is an <ExternalStructure> class to wrap the struct ''WINSOCK2Lib.protoent'' from type information in the ''Windows Sockets 2 Type Library'' library.

This class represents the Windows PROTOENT structure used to hold protocol information. The structure is allocated by Windows Sockets, one per thread, and the contents must not be modified. 

IDL definition follows:

typedef struct tagprotoent {
	CHAR* p_name;
	CHAR** p_aliases;
	short p_proto;
} protoent;
'!
!PROTOENT categoriesForClass!External-Data-Structured-Win32!Windows Sockets! !
!PROTOENT methodsFor!

p_name
	"Answer the receiver's p_name field as a Smalltalk object."

	^String fromAddress: (bytes intPtrAtOffset: 0)!

p_proto
	"Answer the receiver's p_proto field as a Smalltalk object."

	^(bytes swordAtOffset: 8)! !
!PROTOENT categoriesFor: #p_name!**compiled accessors**!public! !
!PROTOENT categoriesFor: #p_proto!**compiled accessors**!public! !

!PROTOENT class methodsFor!

defineFields
	"Define the fields of the protoent structure.
		PROTOENT compileDefinition
	
		typedef 		struct tagprotoent {
			CHAR* p_name;
			CHAR** p_aliases;
			short p_proto;
		} protoent;"

	"Implementation Note: Originally auto-generated, but modifications applied."

	self
		defineField: #p_name type: (PointerField type: String) beReadOnly;
		defineField: #p_aliases type: LPVOIDField filler;
		defineField: #p_proto type: SWORDField readOnly! !
!PROTOENT class categoriesFor: #defineFields!initializing!public! !

