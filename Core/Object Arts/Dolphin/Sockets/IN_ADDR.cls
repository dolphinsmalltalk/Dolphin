"Filed out from Dolphin Smalltalk 7"!

AbstractIN_ADDR subclass: #IN_ADDR
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IN_ADDR guid: (GUID fromString: '{87B4C5F6-026E-11D3-9FD7-00A0CC3E4A32}')!
IN_ADDR comment: '<IN_ADDR> is an <ExternalStructure> class to wrap the struct ''Win32.IN_ADDR'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"IPv4 Internet address. This is an ''on-wire'' format structure."

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(87B4C5F6-026E-11D3-9FD7-00A0CC3E4A32), helpstring("IPv4 Internet address. This is an ''on-wire'' format structure.")]
struct tagIN_ADDR {
	union {
		struct {
			BYTE s_b1;
			BYTE s_b2;
			BYTE s_b3;
			BYTE s_b4;
		};
		struct {
			unsigned short s_w1;
			unsigned short s_w2;
		};
		unsigned long s_addr;
	};
} IN_ADDR;
'!
!IN_ADDR categoriesForClass!External-Data-Structured-Sockets!Windows Sockets! !
!IN_ADDR methodsFor!

address
	"Answers the InternetAddress for the receiver"

	^InternetAddress ipAddress: self!

address: anInternetAddress
	"Sets the address for the receiver to anInternetAddress"

	self s_addr: anInternetAddress ipAddress!

s_addr
	"Answer the receiver's s_addr field as a Smalltalk object."

	^bytes dwordAtOffset: 0!

s_addr: anObject
	"Set the receiver's s_addr field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject!

s_b1
	"Answer the receiver's s_b1 field as a Smalltalk object."

	^bytes byteAtOffset: 0!

s_b1: anObject
	"Set the receiver's s_b1 field to the value of anObject."

	bytes byteAtOffset: 0 put: anObject!

s_b2
	"Answer the receiver's s_b2 field as a Smalltalk object."

	^bytes byteAtOffset: ##(self offsetOf: #s_b2)!

s_b2: anObject
	"Set the receiver's s_b2 field to the value of anObject."

	bytes byteAtOffset: ##(self offsetOf: #s_b2) put: anObject!

s_b3
	"Answer the receiver's s_b3 field as a Smalltalk object."

	^bytes byteAtOffset: ##(self offsetOf: #s_b3)!

s_b3: anObject
	"Set the receiver's s_b3 field to the value of anObject."

	bytes byteAtOffset: ##(self offsetOf: #s_b3) put: anObject!

s_b4
	"Answer the receiver's s_b4 field as a Smalltalk object."

	^bytes byteAtOffset: ##(self offsetOf: #s_b4)!

s_b4: anObject
	"Set the receiver's s_b4 field to the value of anObject."

	bytes byteAtOffset: ##(self offsetOf: #s_b4) put: anObject! !
!IN_ADDR categoriesFor: #address!accessing!public! !
!IN_ADDR categoriesFor: #address:!accessing!public! !
!IN_ADDR categoriesFor: #s_addr!**compiled accessors**!public! !
!IN_ADDR categoriesFor: #s_addr:!**compiled accessors**!public! !
!IN_ADDR categoriesFor: #s_b1!**compiled accessors**!public! !
!IN_ADDR categoriesFor: #s_b1:!**compiled accessors**!public! !
!IN_ADDR categoriesFor: #s_b2!**compiled accessors**!public! !
!IN_ADDR categoriesFor: #s_b2:!**compiled accessors**!public! !
!IN_ADDR categoriesFor: #s_b3!**compiled accessors**!public! !
!IN_ADDR categoriesFor: #s_b3:!**compiled accessors**!public! !
!IN_ADDR categoriesFor: #s_b4!**compiled accessors**!public! !
!IN_ADDR categoriesFor: #s_b4:!**compiled accessors**!public! !

!IN_ADDR class methodsFor!

address: anInternetAddress 
	^(self new)
		address: anInternetAddress;
		yourself!

addressFamily
	^WinSocketConstants.AF_INET!

defineFields
	"Define the fields of the IN_ADDR structure.

	IN_ADDR  compileDefinition

		typedef [uuid(87B4C5F6-026E-11D3-9FD7-00A0CC3E4A32), helpstring('IPv4 Internet address. This is an 'on-wire' format structure.')]
		struct tagIN_ADDR {
			union {
				struct {
					BYTE s_b1;
					BYTE s_b2;
					BYTE s_b3;
					BYTE s_b4;
				};
				struct {
					unsigned short s_w1;
					unsigned short s_w2;
				};
				unsigned long s_addr;
			};
		} IN_ADDR;
"

	self
		defineField: #s_b1 type: BYTEField new offset: 0;
		defineField: #s_b2 type: BYTEField new offset: 1;
		defineField: #s_b3 type: BYTEField new offset: 2;
		defineField: #s_b4 type: BYTEField new offset: 3;
		defineField: #s_w1 type: WORDField filler offset: 0;
		defineField: #s_w2 type: WORDField filler offset: 2;
		defineField: #s_addr type: DWORDField new offset: 0.
	self byteSize: 4! !
!IN_ADDR class categoriesFor: #address:!instance creation!public! !
!IN_ADDR class categoriesFor: #addressFamily!public! !
!IN_ADDR class categoriesFor: #defineFields!initializing!public! !

