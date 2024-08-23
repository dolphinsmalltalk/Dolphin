"Filed out from Dolphin Smalltalk"!

External.Structure
	subclass: #'OS.COM.PROPSPEC'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_OffsetOf_lpwstr' -> 16r4.
			'_OffsetOf_propid' -> 16r4.
			'_OffsetOf_ulKind' -> 16r0.
			'_PROPSPEC_Size' -> 16r8
		}!

OS.COM.PROPSPEC guid: (Core.GUID fromString: '{25eb5be3-ca5d-49bc-8359-1d1efa196bc5}')!

OS.COM.PROPSPEC comment: '<PROPSPEC> is an <ExternalStructure> class to wrap the OLE Property Set structure  of the same name.
'!

!OS.COM.PROPSPEC categoriesForClass!OBJIDL-Structs! !

!OS.COM.PROPSPEC methodsFor!

lpwstr
	"Answer the <Utf16String> value of the receiver's 'lpwstr' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_lpwstr)!

lpwstr: anUtf16String
	"Set the receiver's 'lpwstr' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_lpwstr put: anUtf16String yourAddress!

propid
	"Answer the <Integer> value of the receiver's 'propid' field."

	^bytes uint32AtOffset: _OffsetOf_propid!

propid: anInteger
	"Set the receiver's 'propid' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_propid put: anInteger!

ulKind
	"Answer the <Integer> value of the receiver's 'ulKind' field."

	^bytes uint32AtOffset: _OffsetOf_ulKind!

ulKind: anInteger
	"Set the receiver's 'ulKind' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_ulKind put: anInteger! !

!OS.COM.PROPSPEC categoriesForMethods!
lpwstr!**compiled accessors**!public! !
lpwstr:!**compiled accessors**!public! !
propid!**compiled accessors**!public! !
propid:!**compiled accessors**!public! !
ulKind!**compiled accessors**!public! !
ulKind:!**compiled accessors**!public! !
!

!OS.COM.PROPSPEC class methodsFor!

byteSize
	^_PROPSPEC_Size!

defineFields
	"Define the fields of the PROPSPEC structure.
		PROPSPEC compileDefinition
	
		typedef 		struct tagPROPSPEC {
			unsigned long ulKind;
			union {
				PROPID propid;
				LPOLESTR lpwstr;
				};
		} PROPSPEC;

	"

	self
		defineField: #ulKind type: UInt32Field new;
		defineField: #propid type: UInt32Field new.
	"Note the Union"
	self 
		defineField: #lpwstr
		type: (PointerField type: Utf16String)
		offset: (self offsetOf: #propid)!

getFieldNames
	^#(#ulKind #lpwstr #propid)! !

!OS.COM.PROPSPEC class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!initializing!public! !
getFieldNames!**compiled accessors**!constants!private! !
!

