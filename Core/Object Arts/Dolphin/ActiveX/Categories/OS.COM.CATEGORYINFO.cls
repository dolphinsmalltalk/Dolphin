"Filed out from Dolphin Smalltalk 7"!

OS.COM.OLEStructure subclass: #'OS.COM.CATEGORYINFO'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_catid' -> 16r0.
		'_OffsetOf_lcid' -> 16r10.
		'_OffsetOf_szDescription' -> 16r14
	}!
OS.COM.CATEGORYINFO guid: (Core.GUID fromString: '{a8eebb01-0149-481c-8b90-1eeba6516286}')!
OS.COM.CATEGORYINFO comment: '<CATEGORYINFO> is an <ExternalStructure> class to wrap the struct ''COMCAT.CATEGORYINFO'' from type information in the ''OLE Component Categories Library'' library.

CATEGORYINFO is used in conjunction with ICatInformation>>EnumCategories() to enumerate details of the categories registered on the host machine.'!
!OS.COM.CATEGORYINFO categoriesForClass!COM Category Manager! !
!OS.COM.CATEGORYINFO methodsFor!

catid
	"Answer the <GUID> value of the receiver's 'catid' field."

	^GUID fromAddress: bytes yourAddress!

catid: aGUID
	"Set the receiver's 'catid' field to the value of the argument, aGUID"

	aGUID
		replaceBytesOf: bytes
		from: ##(_OffsetOf_catid + 1)
		to: ##(_OffsetOf_catid + GUID basicByteSize)
		startingAt: 1!

description
	"Answer the receiver's szDescription field as a <readableString>."

	^self szDescription asString!

description: desc
	"Set the receiver's szDescription field to <Utf16String> representation
	of the <readableString> argument, desc."

	self szDescription: desc asUtf16String!

lcid
	"Answer the <Integer> value of the receiver's 'lcid' field."

	^bytes dwordAtOffset: _OffsetOf_lcid!

lcid: anInteger
	"Set the receiver's 'lcid' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_lcid put: anInteger!

locale: locale
	"Set the receiver's lcid field to <integer> LCID of the <Locale>
	argument, locale."

	self lcid: locale asParameter!

szDescription
	"Answer the <Utf16String> value of the receiver's 'szDescription' field."

	^Utf16String fromAddress: bytes yourAddress + _OffsetOf_szDescription!

szDescription: anUtf16String
	"Set the receiver's 'szDescription' field to the value of the argument, anUtf16String"

	| size |
	size := anUtf16String byteSize - 2 min: ##(127 * 2).
	anUtf16String
		replaceBytesOf: bytes
		from: ##(_OffsetOf_szDescription + 1)
		to: _OffsetOf_szDescription + size
		startingAt: 1.
	bytes wordAtOffset: _OffsetOf_szDescription + size put: 0! !
!OS.COM.CATEGORYINFO categoriesFor: #catid!**compiled accessors**!public! !
!OS.COM.CATEGORYINFO categoriesFor: #catid:!**compiled accessors**!public! !
!OS.COM.CATEGORYINFO categoriesFor: #description!accessing!public! !
!OS.COM.CATEGORYINFO categoriesFor: #description:!accessing!public! !
!OS.COM.CATEGORYINFO categoriesFor: #lcid!**compiled accessors**!public! !
!OS.COM.CATEGORYINFO categoriesFor: #lcid:!**compiled accessors**!public! !
!OS.COM.CATEGORYINFO categoriesFor: #locale:!accessing!public! !
!OS.COM.CATEGORYINFO categoriesFor: #szDescription!**compiled accessors**!public! !
!OS.COM.CATEGORYINFO categoriesFor: #szDescription:!**compiled accessors**!public! !

!OS.COM.CATEGORYINFO class methodsFor!

defineFields
	"Define the fields of the CATEGORYINFO structure.
		CATEGORYINFO compileDefinition
	
		typedef 		struct tagCATEGORYINFO {
			GUID catid;
			unsigned long lcid;
			short szDescription[128];
		} CATEGORYINFO;

	Originally generated from a type library built from the Microsoft supplied IDL (comcat.idl), but
	the szDescription member is of course a wide string, and there is some loss of information in the
	typelib which we must correct here.
	"

	self
		defineField: #catid type: (StructureField type: GUID);
		defineField: #lcid type: DWORDField new;
		defineField: #szDescription type: (StringField type: Utf16String length: 128)!

getFieldNames
	^#(#catid #lcid #szDescription)! !
!OS.COM.CATEGORYINFO class categoriesFor: #defineFields!public!template definition! !
!OS.COM.CATEGORYINFO class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

