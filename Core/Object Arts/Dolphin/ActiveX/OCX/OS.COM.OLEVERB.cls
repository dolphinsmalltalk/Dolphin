"Filed out from Dolphin Smalltalk"!

External.Structure
	subclass: #'OS.COM.OLEVERB'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_OffsetOf_fuFlags' -> 16r8.
			'_OffsetOf_grfAttribs' -> 16rC.
			'_OffsetOf_lpszVerbName' -> 16r4.
			'_OffsetOf_lVerb' -> 16r0.
			'_OLEVERB_Size' -> 16r10
		}!
OS.COM.OLEVERB guid: (Core.GUID fromString: '{33eb8491-3919-4df6-8dbe-d88c4be8d413}')!
OS.COM.OLEVERB comment: '<OLEVERB> is an <ExternalStructure> class to wrap the struct ''Win32.OLEVERB'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef 
struct tagOLEVERB {
	long lVerb;
	LPWSTR lpszVerbName;
	DWORD fuFlags;
	DWORD grfAttribs;
} OLEVERB;
'!
!OS.COM.OLEVERB categoriesForClass!Win32-Structs! !
!OS.COM.OLEVERB methodsFor!

fuFlags
	"Answer the <Integer> value of the receiver's 'fuFlags' field."

	^bytes uint32AtOffset: _OffsetOf_fuFlags!

fuFlags: anInteger
	"Set the receiver's 'fuFlags' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_fuFlags put: anInteger!

grfAttribs
	"Answer the <Integer> value of the receiver's 'grfAttribs' field."

	^bytes uint32AtOffset: _OffsetOf_grfAttribs!

grfAttribs: anInteger
	"Set the receiver's 'grfAttribs' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_grfAttribs put: anInteger!

lpszVerbName
	"Answer the <Utf16String> value of the receiver's 'lpszVerbName' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_lpszVerbName)!

lpszVerbName: anUtf16String
	"Set the receiver's 'lpszVerbName' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_lpszVerbName put: anUtf16String yourAddress!

lVerb
	"Answer the <Integer> value of the receiver's 'lVerb' field."

	^bytes int32AtOffset: _OffsetOf_lVerb!

lVerb: anInteger
	"Set the receiver's 'lVerb' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_lVerb put: anInteger!

printOn: aStream 
	"Append a textual representation of the receiver to aStream."

	aStream
		basicPrint: self;
		nextPut: $(;
		print: self lVerb;
		nextPutAll: ': ';
		print: self lpszVerbName;
		nextPut: $)! !
!OS.COM.OLEVERB categoriesForMethods!
fuFlags!**compiled accessors**!public! !
fuFlags:!**compiled accessors**!public! !
grfAttribs!**compiled accessors**!public! !
grfAttribs:!**compiled accessors**!public! !
lpszVerbName!**compiled accessors**!public! !
lpszVerbName:!**compiled accessors**!public! !
lVerb!**compiled accessors**!public! !
lVerb:!**compiled accessors**!public! !
printOn:!development!printing!public! !
!

!OS.COM.OLEVERB class methodsFor!

byteSize
	^_OLEVERB_Size!

defineFields
	"Define the fields of the OLEVERB structure.

	OLEVERB  compileDefinition

		typedef 
		struct tagOLEVERB {
			long lVerb;
			LPWSTR lpszVerbName;
			DWORD fuFlags;
			DWORD grfAttribs;
		} OLEVERB;
"

	self
		defineField: #lVerb type: Int32Field new;
		defineField: #lpszVerbName type: (PointerField type: Utf16String);
		defineField: #fuFlags type: UInt32Field new;
		defineField: #grfAttribs type: UInt32Field new!

getFieldNames
	^#(#lVerb #lpszVerbName #fuFlags #grfAttribs)! !
!OS.COM.OLEVERB class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

