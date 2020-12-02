"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #GdiplusStartupInput
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_DebugEventCallback' -> 16r4.
		'_OffsetOf_GdiplusVersion' -> 16r0.
		'_OffsetOf_SuppressBackgroundThread' -> 16r8.
		'_OffsetOf_SuppressExternalCodecs' -> 16rC
	}!
GdiplusStartupInput guid: (GUID fromString: '{0cb202b5-b002-428d-8a31-f44d2919cb02}')!
GdiplusStartupInput comment: '<GdiplusStartupInput> is an <ExternalStructure> class to wrap the struct ''Gdiplus.GdiplusStartupInput'' from type information in the ''GDI+ Library 1.0'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(0CB202B5-B002-428D-8A31-F44D2919CB02)]
struct tagGdiplusStartupInput {
	unsigned long GdiplusVersion;
	void* DebugEventCallback;
	long SuppressBackgroundThread;
	long SuppressExternalCodecs;
} GdiplusStartupInput;
'!
!GdiplusStartupInput categoriesForClass!Unclassified! !
!GdiplusStartupInput methodsFor!

GdiplusVersion: anInteger
	"Set the receiver's 'GdiplusVersion' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_GdiplusVersion put: anInteger! !
!GdiplusStartupInput categoriesFor: #GdiplusVersion:!**compiled accessors**!public! !

!GdiplusStartupInput class methodsFor!

defineFields
	"Define the fields of the GdiplusStartupInput structure.
		GdiplusStartupInput compileDefinition
	
		typedef [uuid(0CB202B5-B002-428D-8A31-F44D2919CB02)]
		struct tagGdiplusStartupInput {
			unsigned long GdiplusVersion;
			void* DebugEventCallback;
			long SuppressBackgroundThread;
			long SuppressExternalCodecs;
		} GdiplusStartupInput;
"

	self
		defineField: #GdiplusVersion type: DWORDField writeOnly offset: 0;
		defineField: #DebugEventCallback type: LPVOIDField filler offset: 4;
		defineField: #SuppressBackgroundThread type: BOOLField filler offset: 8;
		defineField: #SuppressExternalCodecs type: BOOLField filler offset: 12.
	self byteSize: 16!

getFieldNames
	^#(#GdiplusVersion)! !
!GdiplusStartupInput class categoriesFor: #defineFields!public!template definition! !
!GdiplusStartupInput class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

