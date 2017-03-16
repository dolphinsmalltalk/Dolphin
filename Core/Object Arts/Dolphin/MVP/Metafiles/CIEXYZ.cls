"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #CIEXYZ
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CIEXYZ guid: (GUID fromString: '{bf6d67a4-8fbc-4f17-825f-465254239f8b}')!
CIEXYZ comment: '<CIEXYZ> is an <ExternalStructure> class to wrap the struct ''Win32.CIEXYZ'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(BF6D67A4-8FBC-4F17-825F-465254239F8B)]
struct tagCIEXYZ {
	long ciexyzX;
	long ciexyzY;
	long ciexyzZ;
} CIEXYZ;
'!
!CIEXYZ categoriesForClass!Win32-Structs! !
!CIEXYZ methodsFor!

ciexyzX
	"Answer the receiver's ciexyzX field as a Smalltalk object."

	^bytes sdwordAtOffset: 0!

ciexyzX: anObject 
	"Set the receiver's ciexyzX field to the value of anObject."

	bytes sdwordAtOffset: 0 put: anObject!

ciexyzY
	"Answer the receiver's ciexyzY field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #ciexyzY)!

ciexyzY: anObject 
	"Set the receiver's ciexyzY field to the value of anObject."

	bytes sdwordAtOffset: ##(self offsetOf: #ciexyzY) put: anObject!

ciexyzZ
	"Answer the receiver's ciexyzZ field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #ciexyzZ)!

ciexyzZ: anObject 
	"Set the receiver's ciexyzZ field to the value of anObject."

	bytes sdwordAtOffset: ##(self offsetOf: #ciexyzZ) put: anObject! !
!CIEXYZ categoriesFor: #ciexyzX!**compiled accessors**!public! !
!CIEXYZ categoriesFor: #ciexyzX:!**compiled accessors**!public! !
!CIEXYZ categoriesFor: #ciexyzY!**compiled accessors**!public! !
!CIEXYZ categoriesFor: #ciexyzY:!**compiled accessors**!public! !
!CIEXYZ categoriesFor: #ciexyzZ!**compiled accessors**!public! !
!CIEXYZ categoriesFor: #ciexyzZ:!**compiled accessors**!public! !

!CIEXYZ class methodsFor!

defineFields
	"Define the fields of the CIEXYZ structure.

	CIEXYZ  compileDefinition

		typedef [uuid(BF6D67A4-8FBC-4F17-825F-465254239F8B)]
		struct tagCIEXYZ {
			long ciexyzX;
			long ciexyzY;
			long ciexyzZ;
		} CIEXYZ;
"

	self
		defineField: #ciexyzX type: SDWORDField new offset: 0;
		defineField: #ciexyzY type: SDWORDField new offset: 4;
		defineField: #ciexyzZ type: SDWORDField new offset: 8.
	self byteSize: 12! !
!CIEXYZ class categoriesFor: #defineFields!**auto generated**!initializing!public! !

