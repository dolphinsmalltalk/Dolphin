"Filed out from Dolphin Smalltalk X6.1"!

OLEStructure subclass: #OLEVERB
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
OLEVERB guid: (GUID fromString: '{33EB8491-3919-4DF6-8DBE-D88C4BE8D413}')!
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
	"Answer the receiver's fuFlags field as a Smalltalk object."

	^(bytes dwordAtOffset: 8)!

fuFlags: anObject
	"Set the receiver's fuFlags field to the value of anObject."

	bytes dwordAtOffset: 8 put: anObject!

grfAttribs
	"Answer the receiver's grfAttribs field as a Smalltalk object."

	^(bytes dwordAtOffset: 12)!

grfAttribs: anObject
	"Set the receiver's grfAttribs field to the value of anObject."

	bytes dwordAtOffset: 12 put: anObject!

lpszVerbName
	"Answer the receiver's lpszVerbName field as a Smalltalk object."

	^UnicodeString fromAddress: (bytes intPtrAtOffset: 4)!

lpszVerbName: anObject
	"Set the receiver's lpszVerbName field to the value of anObject."

	bytes uintPtrAtOffset: 4 put: anObject yourAddress!

lVerb
	"Answer the receiver's lVerb field as a Smalltalk object."

	^(bytes sdwordAtOffset: 0)!

lVerb: anObject
	"Set the receiver's lVerb field to the value of anObject."

	bytes sdwordAtOffset: 0 put: anObject!

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
		defineField: #lpszVerbName type: (PointerField type: UnicodeString);
		defineField: #fuFlags type: DWORDField new;
		defineField: #grfAttribs type: DWORDField new! !
!OLEVERB class categoriesFor: #defineFields!**auto generated**!initializing!public! !

