"Filed out from Dolphin Smalltalk"!

External.FinalizableStructure
	subclass: #'OS.COM.STATPROPSTG'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_OffsetOf_lpwstrName' -> 16r0.
			'_OffsetOf_propid' -> 16r4.
			'_OffsetOf_vt' -> 16r8.
			'_STATPROPSTG_Size' -> 16rC
		}!

OS.COM.STATPROPSTG guid: (Core.GUID fromString: '{c7bdff5f-d8f3-4947-b972-f750a1afb75b}')!

OS.COM.STATPROPSTG comment: '`STATPROPSTG` is an `External.Structure` class to represent the Win32/COM Property Storage structure of the same name.

The STATPROPSTG structure contains data about a single property in a property set. This data is the property ID and type tag, and the optional string name that may be associated with the property.

IPropertyStorage::Enum supplies a pointer to the IEnumSTATPROPSTG interface on an enumerator object that can be used to enumerate the STATPROPSTG structures for the properties in the current property set.

IDL definition follows:
```
typedef 
struct tagSTATPROPSTG {
	LPWSTR lpwstrName;
	PROPID propid;
	VARTYPE vt;
} STATPROPSTG;
```
'!

!OS.COM.STATPROPSTG categoriesForClass!WIC-Structs! !

!OS.COM.STATPROPSTG methodsFor!

lpwstrName
	"Answer the <Utf16String> value of the receiver's 'lpwstrName' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_lpwstrName) owner: self fieldOwner!

lpwstrName: anUtf16String
	"Set the receiver's 'lpwstrName' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_lpwstrName put: anUtf16String yourAddress!

name
	"Answer the <readableString> name of the property the receiver describes."

	^self lpwstrName!

name: aString
	"Set the <readableString> name of the property the receiver describes."

	| name size utf16 |
	utf16 := aString asUtf16String.
	size := utf16 byteSize.
	"Note that CoTaskMemAlloc does not guarantee to initialize/zero the memory, so we must be sure to add the null terminator."
	name := Ole32 coTaskMemAlloc: size.
	name
		replaceFrom: 1
			to: size - 2
			with: utf16
			startingAt: 1;
		uint16AtOffset: size - 2 put: 0.
	self lpwstrName: name
	"struct now has ownership of the name"!

propid
	"Answer the <Integer> value of the receiver's 'propid' field."

	^bytes uint32AtOffset: _OffsetOf_propid!

propid: anInteger
	"Set the receiver's 'propid' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_propid put: anInteger!

vt
	"Answer the <Integer> value of the receiver's 'vt' field."

	^bytes uint16AtOffset: _OffsetOf_vt!

vt: anInteger
	"Set the receiver's 'vt' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_vt put: anInteger! !

!OS.COM.STATPROPSTG categoriesForMethods!
lpwstrName!**compiled accessors**!public! !
lpwstrName:!**compiled accessors**!public! !
name!accessing!public! !
name:!accessing!public! !
propid!**compiled accessors**!public! !
propid:!**compiled accessors**!public! !
vt!**compiled accessors**!public! !
vt:!**compiled accessors**!public! !
!

!OS.COM.STATPROPSTG class methodsFor!

byteSize
	^_STATPROPSTG_Size!

clear: addressOrBytes
	"Free external resources referenced by STATPROPSTG structure at the specified address."

	| addr |
	addr := addressOrBytes uintPtrAtOffset: _OffsetOf_lpwstrName.
	addr isNull ifFalse: [Ole32 coTaskMemFree: addr]!

defineFields
	"Define the fields of the STATPROPSTG structure.

	STATPROPSTG compileDefinition

		typedef 
		struct tagSTATPROPSTG {
			LPWSTR lpwstrName;
			unsigned long propid;
			unsigned short vt;
		} STATPROPSTG;
"

	self
		defineField: #lpwstrName type: (PointerField type: Utf16String) offset: 0;
		defineField: #propid type: UInt32Field new offset: 4;
		defineField: #vt type: UInt16Field new offset: 8.
	self byteSize: 12!

getFieldNames
	^#(#lpwstrName #propid #vt)! !

!OS.COM.STATPROPSTG class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
clear:!public!realizing/unrealizing! !
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

