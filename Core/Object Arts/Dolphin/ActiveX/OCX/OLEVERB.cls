"Filed out from Dolphin Smalltalk 7"!

OLEStructure subclass: #OLEVERB
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
OLEVERB guid: (GUID fromString: '{33eb8491-3919-4df6-8dbe-d88c4be8d413}')!
OLEVERB comment: '<OLEVERB> is an <ExternalStructure> class to wrap the struct ''Win32.OLEVERB'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

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
!OLEVERB categoriesForClass!Win32-Structs! !
!OLEVERB methodsFor!

fuFlags
	"Answer the <Integer> value of the receiver's 'fuFlags' field."

	^bytes dwordAtOffset: ##(self offsetOf: #fuFlags)!

fuFlags: anInteger
	"Set the receiver's 'fuFlags' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #fuFlags) put: anInteger!

grfAttribs
	"Answer the <Integer> value of the receiver's 'grfAttribs' field."

	^bytes dwordAtOffset: ##(self offsetOf: #grfAttribs)!

grfAttribs: anInteger
	"Set the receiver's 'grfAttribs' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #grfAttribs) put: anInteger!

lpszVerbName
	"Answer the <Utf16String> value of the receiver's 'lpszVerbName' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #lpszVerbName))!

lpszVerbName: anUtf16String
	"Set the receiver's 'lpszVerbName' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: ##(self offsetOf: #lpszVerbName) put: anUtf16String yourAddress!

lVerb
	"Answer the <Integer> value of the receiver's 'lVerb' field."

	^bytes sdwordAtOffset: 0!

lVerb: anInteger
	"Set the receiver's 'lVerb' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: 0 put: anInteger!

printOn: aStream 
	"Append a textual representation of the receiver to aStream."

	aStream
		basicPrint: self;
		nextPut: $(;
		print: self lVerb;
		nextPutAll: ': ';
		print: self lpszVerbName;
		nextPut: $)! !
!OLEVERB categoriesFor: #fuFlags!**compiled accessors**!public! !
!OLEVERB categoriesFor: #fuFlags:!**compiled accessors**!public! !
!OLEVERB categoriesFor: #grfAttribs!**compiled accessors**!public! !
!OLEVERB categoriesFor: #grfAttribs:!**compiled accessors**!public! !
!OLEVERB categoriesFor: #lpszVerbName!**compiled accessors**!public! !
!OLEVERB categoriesFor: #lpszVerbName:!**compiled accessors**!public! !
!OLEVERB categoriesFor: #lVerb!**compiled accessors**!public! !
!OLEVERB categoriesFor: #lVerb:!**compiled accessors**!public! !
!OLEVERB categoriesFor: #printOn:!development!printing!public! !

!OLEVERB class methodsFor!

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
		defineField: #grfAttribs type: DWORDField new! !
!OLEVERB class categoriesFor: #defineFields!**auto generated**!initializing!public! !

