"Filed out from Dolphin Smalltalk X6.1"!

OLEStructure subclass: #COAUTHIDENTITY
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
COAUTHIDENTITY guid: (GUID fromString: '{31387A96-BDF6-40B2-ABEE-6EF6A2384B67}')!
COAUTHIDENTITY comment: '<COAUTHIDENTITY> is an <ExternalStructure> class to wrap the struct ''OBJIDL.COAUTHIDENTITY'' from type information in the ''ObjIDL Library'' library.

The COAUTHIDENTITY structure represents a user name and password.'!
!COAUTHIDENTITY categoriesForClass!OBJIDL-Structs! !
!COAUTHIDENTITY methodsFor!

Domain
	"Answer the receiver's Domain field as a Smalltalk object."

	^UnicodeString fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #Domain))!

Domain: anObject 
	"Set the receiver's Domain field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #Domain) put: anObject yourAddress!

DomainLength
	"Answer the receiver's DomainLength field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #DomainLength)!

DomainLength: anObject 
	"Set the receiver's DomainLength field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #DomainLength) put: anObject!

Flags
	"Answer the receiver's Flags field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #Flags)!

Flags: anObject 
	"Set the receiver's Flags field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #Flags) put: anObject!

Password
	"Answer the receiver's Password field as a Smalltalk object."

	^UnicodeString fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #Password))!

Password: anObject 
	"Set the receiver's Password field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #Password) put: anObject yourAddress!

PasswordLength
	"Answer the receiver's PasswordLength field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #PasswordLength)!

PasswordLength: anObject 
	"Set the receiver's PasswordLength field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #PasswordLength) put: anObject!

User
	"Answer the receiver's User field as a Smalltalk object."

	^UnicodeString fromAddress: (bytes intPtrAtOffset: 0)!

User: anObject 
	"Set the receiver's User field to the value of anObject."

	bytes uintPtrAtOffset: 0 put: anObject yourAddress!

UserLength
	"Answer the receiver's UserLength field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #UserLength)!

UserLength: anObject 
	"Set the receiver's UserLength field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #UserLength) put: anObject! !
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
		defineField: #User type: (PointerField type: UnicodeString);
		defineField: #UserLength type: DWORDField new;
		defineField: #Domain type: (PointerField type: UnicodeString);
		defineField: #DomainLength type: DWORDField new;
		defineField: #Password type: (PointerField type: UnicodeString);
		defineField: #PasswordLength type: DWORDField new;
		defineField: #Flags type: DWORDField new! !
!COAUTHIDENTITY class categoriesFor: #defineFields!**auto generated**!initializing!public! !

