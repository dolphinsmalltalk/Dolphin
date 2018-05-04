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
	"Answer the receiver's Domain field as a Smalltalk object."

	^Utf16String fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #Domain))!

Domain: aWORD
	"Set the receiver's 'Domain' field to the value of the argument, aWORD"

	bytes uintPtrAtOffset: ##(self offsetOf: #Domain) put: aWORD yourAddress!

DomainLength
	"Answer the <Integer> value of the receiver's 'DomainLength' field."

	^bytes dwordAtOffset: ##(self offsetOf: #DomainLength)!

DomainLength: anInteger
	"Set the receiver's 'DomainLength' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #DomainLength) put: anInteger!

flags
	"Answer the <Integer> value of the receiver's 'flags' field."

	^bytes dwordAtOffset: ##(self offsetOf: #flags)!

flags: anInteger
	"Set the receiver's 'flags' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #flags) put: anInteger!

Password
	"Answer the receiver's Password field as a Smalltalk object."

	^Utf16String fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #Password))!

Password: aWORD
	"Set the receiver's 'Password' field to the value of the argument, aWORD"

	bytes uintPtrAtOffset: ##(self offsetOf: #Password) put: aWORD yourAddress!

PasswordLength
	"Answer the <Integer> value of the receiver's 'PasswordLength' field."

	^bytes dwordAtOffset: ##(self offsetOf: #PasswordLength)!

PasswordLength: anInteger
	"Set the receiver's 'PasswordLength' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #PasswordLength) put: anInteger!

User
	"Answer the receiver's User field as a Smalltalk object."

	^Utf16String fromAddress: (bytes intPtrAtOffset: 0)!

User: aWORD
	"Set the receiver's 'User' field to the value of the argument, aWORD"

	bytes uintPtrAtOffset: 0 put: aWORD yourAddress!

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
!COAUTHIDENTITY categoriesFor: #flags!**compiled accessors**!public! !
!COAUTHIDENTITY categoriesFor: #flags:!**compiled accessors**!public! !
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
		defineField: #Flags type: DWORDField new! !
!COAUTHIDENTITY class categoriesFor: #defineFields!**auto generated**!initializing!public! !

