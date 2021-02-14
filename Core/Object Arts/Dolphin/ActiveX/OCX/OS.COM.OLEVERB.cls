"Filed out from Dolphin Smalltalk 7"!

OS.COM.OLEStructure subclass: #'OS.COM.OLEVERB'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_fuFlags' -> 16r8.
		'_OffsetOf_grfAttribs' -> 16rC.
		'_OffsetOf_lpszVerbName' -> 16r4.
		'_OffsetOf_lVerb' -> 16r0
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

	^bytes dwordAtOffset: _OffsetOf_fuFlags!

fuFlags: anInteger
	"Set the receiver's 'fuFlags' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_fuFlags put: anInteger!

grfAttribs
	"Answer the <Integer> value of the receiver's 'grfAttribs' field."

	^bytes dwordAtOffset: _OffsetOf_grfAttribs!

grfAttribs: anInteger
	"Set the receiver's 'grfAttribs' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_grfAttribs put: anInteger!

lpszVerbName
	"Answer the <Utf16String> value of the receiver's 'lpszVerbName' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_lpszVerbName)!

lpszVerbName: anUtf16String
	"Set the receiver's 'lpszVerbName' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_lpszVerbName put: anUtf16String yourAddress!

lVerb
	"Answer the <Integer> value of the receiver's 'lVerb' field."

	^bytes sdwordAtOffset: _OffsetOf_lVerb!

lVerb: anInteger
	"Set the receiver's 'lVerb' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_lVerb put: anInteger!

printOn: aStream 
	"Append a textual representation of the receiver to aStream."

	aStream
		basicPrint: self;
		nextPut: $(;
		print: self lVerb;
		nextPutAll: ': ';
		print: self lpszVerbName;
		nextPut: $)! !
!OS.COM.OLEVERB categoriesFor: #fuFlags!**compiled accessors**!public! !
!OS.COM.OLEVERB categoriesFor: #fuFlags:!**compiled accessors**!public! !
!OS.COM.OLEVERB categoriesFor: #grfAttribs!**compiled accessors**!public! !
!OS.COM.OLEVERB categoriesFor: #grfAttribs:!**compiled accessors**!public! !
!OS.COM.OLEVERB categoriesFor: #lpszVerbName!**compiled accessors**!public! !
!OS.COM.OLEVERB categoriesFor: #lpszVerbName:!**compiled accessors**!public! !
!OS.COM.OLEVERB categoriesFor: #lVerb!**compiled accessors**!public! !
!OS.COM.OLEVERB categoriesFor: #lVerb:!**compiled accessors**!public! !
!OS.COM.OLEVERB categoriesFor: #printOn:!development!printing!public! !

!OS.COM.OLEVERB class methodsFor!

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
		defineField: #lVerb type: SDWORDField new;
		defineField: #lpszVerbName type: (PointerField type: Utf16String);
		defineField: #fuFlags type: DWORDField new;
		defineField: #grfAttribs type: DWORDField new!

getFieldNames
	^#(#lVerb #lpszVerbName #fuFlags #grfAttribs)! !
!OS.COM.OLEVERB class categoriesFor: #defineFields!**auto generated**!public!template definition! !
!OS.COM.OLEVERB class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

