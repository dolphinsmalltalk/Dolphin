"Filed out from Dolphin Smalltalk 7"!

OLEStructure subclass: #CATEGORYINFO
	instanceVariableNames: 'wszDescription'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CATEGORYINFO guid: (GUID fromString: '{a8eebb01-0149-481c-8b90-1eeba6516286}')!
CATEGORYINFO comment: '<CATEGORYINFO> is an <ExternalStructure> class to wrap the struct ''COMCAT.CATEGORYINFO'' from type information in the ''OLE Component Categories Library'' library.

CATEGORYINFO is used in conjunction with ICatInformation>>EnumCategories() to enumerate details of the categories registered on the host machine.'!
!CATEGORYINFO categoriesForClass!COM Category Manager! !
!CATEGORYINFO methodsFor!

description
	"Answer the receiver's szDescription field as a <readableString>."

	^self szDescription asString!

description: desc
	"Set the receiver's szDescription field to <UnicodeString> representation
	of the <readableString> argument, desc."

	self szDescription: (wszDescription := desc asUtf16String)!

lcid: anObject 
	"Set the receiver's lcid field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #lcid) put: anObject!

locale: locale
	"Set the receiver's lcid field to <integer> LCID of the <Locale>
	argument, locale."

	self lcid: locale asParameter! !
!CATEGORYINFO categoriesFor: #description!accessing!public! !
!CATEGORYINFO categoriesFor: #description:!accessing!public! !
!CATEGORYINFO categoriesFor: #lcid:!**compiled accessors**!public! !
!CATEGORYINFO categoriesFor: #locale:!accessing!public! !

!CATEGORYINFO class methodsFor!

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
		defineField: #szDescription type: (StringField type: Utf16String length: 128)! !
!CATEGORYINFO class categoriesFor: #defineFields!initializing!public! !

