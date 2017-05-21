"Filed out from Dolphin Smalltalk 7"!

OLEStructure subclass: #BINDINFO
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
BINDINFO guid: (GUID fromString: '{464f7fac-9ba3-4055-8492-dc95aba83383}')!
BINDINFO comment: '<BINDINFO> is an <ExternalStructure> class to wrap the struct ''UrlMon.tagBINDINFO'' from type information in the ''UrlMon Library'' library.
'!
!BINDINFO categoriesForClass!OCIDL-Structs! !
!BINDINFO methodsFor!

cbstgmedData
	"Answer the receiver's cbstgmedData field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #cbstgmedData)!

cbstgmedData: anObject 
	"Set the receiver's cbstgmedData field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #cbstgmedData) put: anObject!

dwBindVerb
	"Answer the receiver's dwBindVerb field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #dwBindVerb)!

dwBindVerb: anObject 
	"Set the receiver's dwBindVerb field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #dwBindVerb) put: anObject!

dwSize: anObject 
	"Set the receiver's dwSize field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject!

grfBindInfoF
	"Answer the receiver's grfBindInfoF field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #grfBindInfoF)!

grfBindInfoF: anObject 
	"Set the receiver's grfBindInfoF field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #grfBindInfoF) put: anObject!

stgmedData
	"Answer the receiver's stgmedData field as a Smalltalk object."

	^STGMEDIUM fromAddress: bytes yourAddress + ##(self offsetOf: #stgmedData)!

stgmedData: anObject 
	"Set the receiver's stgmedData field to the value of anObject."

	anObject 
		replaceBytesOf: bytes
		from: ##((self offsetOf: #stgmedData) + 1)
		to: ##((self offsetOf: #stgmedData) + STGMEDIUM basicByteSize)
		startingAt: 1!

szCustomVerb
	"Answer the receiver's szCustomVerb field as a Smalltalk object."

	^UnicodeString fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #szCustomVerb))!

szCustomVerb: anObject 
	"Set the receiver's szCustomVerb field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #szCustomVerb) put: anObject yourAddress!

szExtraInfo
	"Answer the receiver's szExtraInfo field as a Smalltalk object."

	^UnicodeString fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #szExtraInfo))!

szExtraInfo: anObject 
	"Set the receiver's szExtraInfo field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #szExtraInfo) put: anObject yourAddress! !
!BINDINFO categoriesFor: #cbstgmedData!**compiled accessors**!public! !
!BINDINFO categoriesFor: #cbstgmedData:!**compiled accessors**!public! !
!BINDINFO categoriesFor: #dwBindVerb!**compiled accessors**!public! !
!BINDINFO categoriesFor: #dwBindVerb:!**compiled accessors**!public! !
!BINDINFO categoriesFor: #dwSize:!**compiled accessors**!public! !
!BINDINFO categoriesFor: #grfBindInfoF!**compiled accessors**!public! !
!BINDINFO categoriesFor: #grfBindInfoF:!**compiled accessors**!public! !
!BINDINFO categoriesFor: #stgmedData!**compiled accessors**!public! !
!BINDINFO categoriesFor: #stgmedData:!**compiled accessors**!public! !
!BINDINFO categoriesFor: #szCustomVerb!**compiled accessors**!public! !
!BINDINFO categoriesFor: #szCustomVerb:!**compiled accessors**!public! !
!BINDINFO categoriesFor: #szExtraInfo!**compiled accessors**!public! !
!BINDINFO categoriesFor: #szExtraInfo:!**compiled accessors**!public! !

!BINDINFO class methodsFor!

defineFields
	"Define the fields of the BINDINFO structure.
		BINDINFO compileDefinition
	
		typedef 		struct tagtBINDINFO {
			unsigned long cbSize;
			LPWSTR szExtraInfo;
			STGMEDIUM stgmedData;
			unsigned long grfBindInfoF;
			unsigned long dwBindVerb;
			LPWSTR szCustomVerb;
			unsigned long cbstgmedData;
		} BINDINFO;

	"

	self
		defineField: #dwSize type: DWORDField writeOnly;
		defineField: #szExtraInfo type: (PointerField type: UnicodeString);
		defineField: #stgmedData type: (StructureField type: STGMEDIUM);
		defineField: #grfBindInfoF type: DWORDField new;
		defineField: #dwBindVerb type: DWORDField new;
		defineField: #szCustomVerb type: (PointerField type: UnicodeString);
		defineField: #cbstgmedData type: DWORDField new.! !
!BINDINFO class categoriesFor: #defineFields!initializing!public! !

