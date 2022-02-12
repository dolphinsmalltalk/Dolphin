"Filed out from Dolphin Smalltalk"!

External.Structure subclass: #'OS.REGKEYINFO'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_ftLastWriteTime' -> 16r1C.
		'_OffsetOf_maxClassLen' -> 16r8.
		'_OffsetOf_maxSubKeyLen' -> 16r4.
		'_OffsetOf_maxValueLen' -> 16r14.
		'_OffsetOf_maxValueNameLen' -> 16r10.
		'_OffsetOf_securityDescriptorLen' -> 16r18.
		'_OffsetOf_subKeyCount' -> 16r0.
		'_OffsetOf_valueCount' -> 16rC.
		'_REGKEYINFO_Size' -> 16r24
	}!
OS.REGKEYINFO guid: (Core.GUID fromString: '{15e72644-f20b-4040-964a-adfe90d8eb1e}')!
OS.REGKEYINFO comment: 'Not a real Windows structure, but the one that should have been defined as the buffer to receiver values from the RegQueryInfoKey function, if it had been designed to return data through a single structure rather than a large number (11) of pointer parameters.'!
!OS.REGKEYINFO categoriesForClass!External-Data-Structured! !
!OS.REGKEYINFO methodsFor!

ftLastWriteTime
	"Answer the <FILETIME> value of the receiver's 'ftLastWriteTime' field."

	^FILETIME fromAddress: bytes yourAddress + _OffsetOf_ftLastWriteTime!

maxClassLen
	"Answer the <Integer> value of the receiver's 'maxClassLen' field."

	^bytes dwordAtOffset: _OffsetOf_maxClassLen!

maxSubKeyLen
	"Answer the <Integer> value of the receiver's 'maxSubKeyLen' field."

	^bytes dwordAtOffset: _OffsetOf_maxSubKeyLen!

maxValueLen
	"Answer the <Integer> value of the receiver's 'maxValueLen' field."

	^bytes dwordAtOffset: _OffsetOf_maxValueLen!

maxValueLen: anInteger
	"Set the receiver's 'maxValueLen' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_maxValueLen put: anInteger!

maxValueNameLen
	"Answer the <Integer> value of the receiver's 'maxValueNameLen' field."

	^bytes dwordAtOffset: _OffsetOf_maxValueNameLen!

securityDescriptorLen
	"Answer the <Integer> value of the receiver's 'securityDescriptorLen' field."

	^bytes dwordAtOffset: _OffsetOf_securityDescriptorLen!

subKeyCount
	"Answer the <Integer> value of the receiver's 'subKeyCount' field."

	^bytes dwordAtOffset: _OffsetOf_subKeyCount!

valueCount
	"Answer the <Integer> value of the receiver's 'valueCount' field."

	^bytes dwordAtOffset: _OffsetOf_valueCount! !
!OS.REGKEYINFO categoriesForMethods!
ftLastWriteTime!**compiled accessors**!public! !
maxClassLen!**compiled accessors**!public! !
maxSubKeyLen!**compiled accessors**!public! !
maxValueLen!**compiled accessors**!public! !
maxValueLen:!**compiled accessors**!public! !
maxValueNameLen!**compiled accessors**!public! !
securityDescriptorLen!**compiled accessors**!public! !
subKeyCount!**compiled accessors**!public! !
valueCount!**compiled accessors**!public! !
!

!OS.REGKEYINFO class methodsFor!

byteSize
	^_REGKEYINFO_Size!

defineFields
	"
	self compileDefinition
	"

	self
		defineField: #subKeyCount type: DWORDField readOnly;
		defineField: #maxSubKeyLen type: DWORDField readOnly;
		defineField: #maxClassLen type: DWORDField readOnly;
		defineField: #valueCount type: DWORDField readOnly;
		defineField: #maxValueNameLen type: DWORDField readOnly;
		defineField: #maxValueLen type: DWORDField new;
		defineField: #securityDescriptorLen type: DWORDField readOnly;
		defineField: #ftLastWriteTime type: (StructureField type: FILETIME) beReadOnly!

getFieldNames
	^#(#subKeyCount #maxSubKeyLen #maxClassLen #valueCount #maxValueNameLen #maxValueLen #securityDescriptorLen #ftLastWriteTime)! !
!OS.REGKEYINFO class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

