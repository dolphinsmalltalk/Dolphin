"Filed out from Dolphin Smalltalk X6.1"!

Win32Structure subclass: #HOSTENT
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'WinSocketConstants'
	classInstanceVariableNames: ''!
HOSTENT guid: (GUID fromString: '{87B4C5F4-026E-11D3-9FD7-00A0CC3E4A32}')!
HOSTENT comment: '<HOSTENT> is an <ExternalStructure> class to wrap the struct ''WINSOCK2Lib.hostent'' from type information in the ''Windows Sockets 2 Type Library'' library.

This class represents the Windows HOSTENT structure used to hold host information. The structure is allocated by Windows Sockets, one per thread, and the contents must not be modified. 

IDL definition follows:

typedef struct taghostent {
	CHAR* h_name;
	CHAR** h_aliases;
	short h_addrtype;
	short h_length;
	CHAR** h_addr_list;
} hostent;
'!
!HOSTENT categoriesForClass!External-Data-Structured-Win32!Windows Sockets! !
!HOSTENT methodsFor!

address
	"Answer the primary <InternetAddress> for the receiver"

	^(IN_ADDR fromAddress: self h_addr) address!

allAddresses
	"Answer an <Array> of <InternetAddress>, composed from the receiver's
	address list."

	^self reifyNullTerminatedArray: self h_addr_list!

allAliases
	"Answer an <Array> of <InternetAddress>, composed from the receiver's
	alias list."

	^self reifyNullTerminatedArray: self h_aliases!

h_addr
	"Answer the FIRST entry in the receiver's h_addr_list field"

	^self h_addr_list dwordAtOffset: 0!

h_addr_list
	"Answer the receiver's h_addr_list field as a Smalltalk object."

	^(bytes uintPtrAtOffset: 12) asExternalAddress!

h_addrtype
	"Answer the receiver's h_addrtype field as a Smalltalk object."

	^(bytes swordAtOffset: 8)!

h_aliases
	"Answer the receiver's h_aliases field as a Smalltalk object."

	^(bytes uintPtrAtOffset: 4) asExternalAddress!

h_length
	"Answer the receiver's h_length field as a Smalltalk object."

	^(bytes swordAtOffset: 10)!

h_name
	"Answer the receiver's h_name field as a Smalltalk object."

	^String fromAddress: (bytes intPtrAtOffset: 0)!

host
	"Answer the host name embedded in the receiver, trimming trailing nulls."

	^self h_name trimNulls!

reifyNullTerminatedArray: list 
	| i each addresses |
	addresses := OrderedCollection new.
	i := 0.
	
	[each := list dwordAtOffset: i.
	each isNull] whileFalse: 
				[addresses add: (IN_ADDR fromAddress: each) address.
				i := i + 4].
	^addresses asArray! !
!HOSTENT categoriesFor: #address!accessing!public! !
!HOSTENT categoriesFor: #allAddresses!accessing!public! !
!HOSTENT categoriesFor: #allAliases!accessing!public! !
!HOSTENT categoriesFor: #h_addr!accessing!public! !
!HOSTENT categoriesFor: #h_addr_list!**compiled accessors**!public! !
!HOSTENT categoriesFor: #h_addrtype!**compiled accessors**!public! !
!HOSTENT categoriesFor: #h_aliases!**compiled accessors**!public! !
!HOSTENT categoriesFor: #h_length!**compiled accessors**!public! !
!HOSTENT categoriesFor: #h_name!**compiled accessors**!public! !
!HOSTENT categoriesFor: #host!accessing!public! !
!HOSTENT categoriesFor: #reifyNullTerminatedArray:!helpers!private! !

!HOSTENT class methodsFor!

defineFields
	"Define the fields of the hostent structure.
		HOSTENT compileDefinition
	
		typedef 		struct taghostent {
			CHAR* h_name;
			CHAR** h_aliases;
			short h_addrtype;
			short h_length;
			CHAR** h_addr_list;
		} hostent;"

	"Implementation Note: Originally auto-generated, but modifications applied; in particular
	the the real length of the h_add_list field is not known statically."

	self
		defineField: #h_name type: (PointerField type: String) beReadOnly;
		defineField: #h_aliases type: LPVOIDField readOnly;
		defineField: #h_addrtype type: SWORDField readOnly;
		defineField: #h_length type: SWORDField readOnly;
		defineField: #h_addr_list type: LPVOIDField readOnly!

host: aStringHostName 
	"Answer a new instance of the receiver describing a host with the name 
	held in aStringHostName."

	| answer |
	answer := WS2_32Library default gethostbyname: aStringHostName.
	^answer isNull 
		ifTrue: [SocketError signalWith: Processor activeProcess lastError]
		ifFalse: [answer]! !
!HOSTENT class categoriesFor: #defineFields!initializing!public! !
!HOSTENT class categoriesFor: #host:!instance creation!public! !

