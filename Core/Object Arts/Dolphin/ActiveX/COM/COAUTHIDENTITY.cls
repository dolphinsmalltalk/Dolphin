"Filed out from Dolphin Smalltalk 7"!

OLEStructure subclass: #COAUTHIDENTITY
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
COAUTHIDENTITY guid: (GUID fromString: '{31387a96-bdf6-40b2-abee-6ef6a2384b67}')!
COAUTHIDENTITY comment: '<COAUTHIDENTITY> is an <ExternalStructure> class to wrap the struct ''OBJIDL.COAUTHIDENTITY'' from type information in the ''ObjIDL Library'' library.

The COAUTHIDENTITY structure represents a user name and password.'!
!COAUTHIDENTITY categoriesForClass!OBJIDL-Structs! !
!COAUTHIDENTITY methodsFor!

Domain
	"Answer the <Utf16String> value of the receiver's 'Domain' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #Domain))!

Domain: anUtf16String
	"Set the receiver's 'Domain' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: ##(self offsetOf: #Domain) put: anUtf16String yourAddress!

DomainLength
	"Answer the <Integer> value of the receiver's 'DomainLength' field."

	^bytes dwordAtOffset: ##(self offsetOf: #DomainLength)!

DomainLength: anInteger
	"Set the receiver's 'DomainLength' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #DomainLength) put: anInteger!

Flags
	"Answer the <Integer> value of the receiver's 'Flags' field."

	^bytes dwordAtOffset: ##(self offsetOf: #Flags)!

Flags: anInteger
	"Set the receiver's 'Flags' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #Flags) put: anInteger!

Password
	"Answer the <Utf16String> value of the receiver's 'Password' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #Password))!

Password: anUtf16String
	"Set the receiver's 'Password' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: ##(self offsetOf: #Password) put: anUtf16String yourAddress!

PasswordLength
	"Answer the <Integer> value of the receiver's 'PasswordLength' field."

	^bytes dwordAtOffset: ##(self offsetOf: #PasswordLength)!

PasswordLength: anInteger
	"Set the receiver's 'PasswordLength' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #PasswordLength) put: anInteger!

User
	"Answer the <Utf16String> value of the receiver's 'User' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: 0)!

User: anUtf16String
	"Set the receiver's 'User' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: 0 put: anUtf16String yourAddress!

UserLength
	"Answer the <Integer> value of the receiver's 'UserLength' field."

	^bytes dwordAtOffset: ##(self offsetOf: #UserLength)!

UserLength: anInteger
	"Set the receiver's 'UserLength' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #UserLength) put: anInteger! !
!COAUTHIDENTITY categoriesFor: #Domain!**compiled accessors**!public! !
!COAUTHIDENTITY categoriesFor: #Domain:!**compiled accessors**!public! !
!COAUTHIDENTITY categoriesFor: #DomainLength!**compiled accessors**!public! !
!COAUTHIDENTITY categoriesFor: #DomainLength:!**compiled accessors**!public! !
!COAUTHIDENTITY categoriesFor: #Flags!**compiled accessors**!public! !
!COAUTHIDENTITY categoriesFor: #Flags:!**compiled accessors**!public! !
!COAUTHIDENTITY categoriesFor: #Password!**compiled accessors**!public! !
!COAUTHIDENTITY categoriesFor: #Password:!**compiled accessors**!public! !
!COAUTHIDENTITY categoriesFor: #PasswordLength!**compiled accessors**!public! !
!COAUTHIDENTITY categoriesFor: #PasswordLength:!**compiled accessors**!public! !
!COAUTHIDENTITY categoriesFor: #User!**compiled accessors**!public! !
!COAUTHIDENTITY categoriesFor: #User:!**compiled accessors**!public! !
!COAUTHIDENTITY categoriesFor: #UserLength!**compiled accessors**!public! !
!COAUTHIDENTITY categoriesFor: #UserLength:!**compiled accessors**!public! !

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
!COAUTHIDENTITY class categoriesFor: #defineFields!**auto generated**!initializing!public! !
!COAUTHIDENTITY class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

