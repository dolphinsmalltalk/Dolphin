"Filed out from Dolphin Smalltalk"!

OLEStructure subclass: #COAUTHIDENTITY
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_Domain _OffsetOf_DomainLength _OffsetOf_Flags _OffsetOf_Password _OffsetOf_PasswordLength _OffsetOf_User _OffsetOf_UserLength'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
COAUTHIDENTITY guid: (GUID fromString: '{31387a96-bdf6-40b2-abee-6ef6a2384b67}')!
COAUTHIDENTITY addClassConstant: '_OffsetOf_Domain' value: 16r8!
COAUTHIDENTITY addClassConstant: '_OffsetOf_DomainLength' value: 16rC!
COAUTHIDENTITY addClassConstant: '_OffsetOf_Flags' value: 16r18!
COAUTHIDENTITY addClassConstant: '_OffsetOf_Password' value: 16r10!
COAUTHIDENTITY addClassConstant: '_OffsetOf_PasswordLength' value: 16r14!
COAUTHIDENTITY addClassConstant: '_OffsetOf_User' value: 16r0!
COAUTHIDENTITY addClassConstant: '_OffsetOf_UserLength' value: 16r4!
COAUTHIDENTITY comment: '<COAUTHIDENTITY> is an <ExternalStructure> class to wrap the struct ''OBJIDL.COAUTHIDENTITY'' from type information in the ''ObjIDL Library'' library.

The COAUTHIDENTITY structure represents a user name and password.'!
!COAUTHIDENTITY categoriesForClass!OBJIDL-Structs! !
!COAUTHIDENTITY methodsFor!

Domain
	"Answer the <Utf16String> value of the receiver's 'Domain' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_Domain)!

Domain: anUtf16String
	"Set the receiver's 'Domain' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_Domain put: anUtf16String yourAddress!

DomainLength
	"Answer the <Integer> value of the receiver's 'DomainLength' field."

	^bytes dwordAtOffset: _OffsetOf_DomainLength!

DomainLength: anInteger
	"Set the receiver's 'DomainLength' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_DomainLength put: anInteger!

Flags
	"Answer the <Integer> value of the receiver's 'Flags' field."

	^bytes dwordAtOffset: _OffsetOf_Flags!

Flags: anInteger
	"Set the receiver's 'Flags' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_Flags put: anInteger!

Password
	"Answer the <Utf16String> value of the receiver's 'Password' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_Password)!

Password: anUtf16String
	"Set the receiver's 'Password' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_Password put: anUtf16String yourAddress!

PasswordLength
	"Answer the <Integer> value of the receiver's 'PasswordLength' field."

	^bytes dwordAtOffset: _OffsetOf_PasswordLength!

PasswordLength: anInteger
	"Set the receiver's 'PasswordLength' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_PasswordLength put: anInteger!

User
	"Answer the <Utf16String> value of the receiver's 'User' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_User)!

User: anUtf16String
	"Set the receiver's 'User' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_User put: anUtf16String yourAddress!

UserLength
	"Answer the <Integer> value of the receiver's 'UserLength' field."

	^bytes dwordAtOffset: _OffsetOf_UserLength!

UserLength: anInteger
	"Set the receiver's 'UserLength' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_UserLength put: anInteger! !
!COAUTHIDENTITY categoriesForMethods!
Domain!**compiled accessors**!public! !
Domain:!**compiled accessors**!public! !
DomainLength!**compiled accessors**!public! !
DomainLength:!**compiled accessors**!public! !
Flags!**compiled accessors**!public! !
Flags:!**compiled accessors**!public! !
Password!**compiled accessors**!public! !
Password:!**compiled accessors**!public! !
PasswordLength!**compiled accessors**!public! !
PasswordLength:!**compiled accessors**!public! !
User!**compiled accessors**!public! !
User:!**compiled accessors**!public! !
UserLength!**compiled accessors**!public! !
UserLength:!**compiled accessors**!public! !
!

!COAUTHIDENTITY class methodsFor!

defineFields
	"Define the fields of the COAUTHIDENTITY structure.
		COAUTHIDENTITY compileDefinition
	
		typedef 		struct tagCOAUTHIDENTITY {
			unsigned short* User;
			unsigned long UserLength;
			unsigned short* Domain;
			unsigned long DomainLength;
			unsigned short* Password;
			unsigned long PasswordLength;
			unsigned long Flags;
		} COAUTHIDENTITY;

	"

	self
		defineField: #User type: (PointerField type: Utf16String);
		defineField: #UserLength type: DWORDField new;
		defineField: #Domain type: (PointerField type: Utf16String);
		defineField: #DomainLength type: DWORDField new;
		defineField: #Password type: (PointerField type: Utf16String);
		defineField: #PasswordLength type: DWORDField new;
		defineField: #Flags type: DWORDField new!

getFieldNames
	^#(#User #UserLength #Domain #DomainLength #Password #PasswordLength #Flags)! !
!COAUTHIDENTITY class categoriesForMethods!
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

