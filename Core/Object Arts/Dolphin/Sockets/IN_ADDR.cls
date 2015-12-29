"Filed out from Dolphin Smalltalk X6.1"!

Win32Structure subclass: #IN_ADDR
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IN_ADDR guid: (GUID fromString: '{87B4C5F6-026E-11D3-9FD7-00A0CC3E4A32}')!
IN_ADDR comment: '<IN_ADDR> is an <ExternalStructure> class to wrap the struct ''WINSOCK2Lib.in_addr'' from type information in the ''Windows Sockets 2 Type Library'' library. IN_ADDR structures are used to hold IP addresses.
'!
!IN_ADDR categoriesForClass!External-Data-Structured-Sockets!Windows Sockets! !
!IN_ADDR methodsFor!

address
	"Answers the InternetAddress for the receiver"

	^InternetAddress ipAddress: (ByteArray 
				with: self s_b1
				with: self s_b2
				with: self s_b3
				with: self s_b4)!

address: anInternetAddress 
	"Sets the address for the receiver to anInternetAddress"

	self s_addr: anInternetAddress ipAddress!

displayOn: aStream 
	"Append, to aStream, a String whose characters are a representation of the receiver as a user
	would want to see it. In this case we print the address in the classic dotted IPv4 format."

	(1 to: 4) do: [:i | aStream print: (bytes at: i)] separatedBy: [aStream nextPut: $.]!

s_addr
	"Answer the receiver's s_addr field as a Smalltalk object."

	^(bytes dwordAtOffset: 0)!

s_addr: anObject
	"Set the receiver's s_addr field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject!

s_b1
	"Answer the receiver's s_b1 field as a Smalltalk object."

	^(bytes byteAtOffset: 0)!

s_b1: anObject
	"Set the receiver's s_b1 field to the value of anObject."

	bytes byteAtOffset: 0 put: anObject!

s_b2
	"Answer the receiver's s_b2 field as a Smalltalk object."

	^(bytes byteAtOffset: 1)!

s_b2: anObject
	"Set the receiver's s_b2 field to the value of anObject."

	bytes byteAtOffset: 1 put: anObject!

s_b3
	"Answer the receiver's s_b3 field as a Smalltalk object."

	^(bytes byteAtOffset: 2)!

s_b3: anObject
	"Set the receiver's s_b3 field to the value of anObject."

	bytes byteAtOffset: 2 put: anObject!

s_b4
	"Answer the receiver's s_b4 field as a Smalltalk object."

	^(bytes byteAtOffset: 3)!

s_b4: anObject
	"Set the receiver's s_b4 field to the value of anObject."

	bytes byteAtOffset: 3 put: anObject! !
!IN_ADDR categoriesFor: #address!accessing!public! !
!IN_ADDR categoriesFor: #address:!accessing!public! !
!IN_ADDR categoriesFor: #displayOn:!displaying!public! !
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

defineFields
	"Define the fields of the in_addr structure.
		IN_ADDR compileDefinition
	
		typedef  struct tagin_addr {
			union {
				struct {BYTE s_b1, s_b2, s_b3, BYTE s_b4; } S_un_b;
				struct { unsigned short s_w1, s_w2; } S_un_w;
				unsigned long S_addr;
			} S_un;
		} in_addr;
	"

	"Implementation Note: Originally auto-generated, but unions subsequently inlined."

	"S_un_b"

	self
		defineField: #s_b1 type: BYTEField new;
		defineField: #s_b2 type: BYTEField new;
		defineField: #s_b3 type: BYTEField new;
		defineField: #s_b4 type: BYTEField new.
	"S_un_w"
	self
		defineField: #s_w1
			type: WORDField filler
			offset: 0;
		defineField: #s_w2
			type: WORDField filler
			offset: 2.

	"S_addr"
	self 
		defineField: #s_addr
		type: DWORDField new
		offset: 0! !
!IN_ADDR class categoriesFor: #address:!instance creation!public! !
!IN_ADDR class categoriesFor: #defineFields!initializing!public! !

