"Filed out from Dolphin Smalltalk"!

Object subclass: #AXTypeLibRegistration
	instanceVariableNames: 'description guidString versionString minor major'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
AXTypeLibRegistration guid: (GUID fromString: '{187aaa33-6992-4cfc-bac1-e8a4cb9ea0f9}')!
AXTypeLibRegistration comment: 'AXTypeLibRegistration is a simple class to hold registration information for a type library which might not yet be loaded.

Instance Variables:
	description		<String>
	guidString		<String>
	versionString	<String>

'!
!AXTypeLibRegistration categoriesForClass!Unclassified! !
!AXTypeLibRegistration methodsFor!

< operand
	"Answer whether the receiver collates before the <AXTypeLibRegistration>, 
	operand. Handy for sorting."

	^self description < operand description
		or: [self description = operand and: [self versionString < operand versionString]]!

<= operand
	"Answer whether the receiver collates before or the same as the <AXTypeLibRegistration>,
	operand. Handy for sorting."

	^(operand < self) not!

= comparand
	"Answer whether the receiver and the <Object>, comparand, 
	are considered equivalent.
	Implementation Note: Two typelibs are considered equivalent
	if they have the same LIBID."

	^comparand species == self species and: [comparand libid = self libid]!

buildVersionNumbers
	"Private -"

	| versionParts |
	versionParts := $. split: self versionString asUppercase.
	major := Integer readFrom: (versionParts at: 1 ifAbsent: ['']) readStream radix: 16.
	minor := Integer readFrom: (versionParts at: 2 ifAbsent: ['']) readStream radix: 16!

description
	"Answer the description from the typelib's registration details."

	^description!

description: dString guidString: gString versionString: vString
	"Private - Initialize the receiver's identity instance variables.
	Answer the receiver."

	description := dString.
	guidString := gString.
	versionString := vString
!

hash
	"Answer the <integer> hash value for the receiver."

	^self libid hash!

libid
	"Answer a <GUID> which is the typelib's unique id (LIBID)."

	^GUID fromString: guidString!

majorVersion
	"Answer the receiver's minor version number."

	major isNil ifTrue: [self buildVersionNumbers].
	^major!

minorVersion
	"Answer the receiver's minor version number."

	minor isNil ifTrue: [self buildVersionNumbers].
	^minor!

versionString
	"Answer the version string from the typelib's registration details."

	^versionString! !
!AXTypeLibRegistration categoriesForMethods!
<!comparing!public! !
<=!comparing!public! !
=!comparing!public! !
buildVersionNumbers!accessing!helpers!private! !
description!accessing!public! !
description:guidString:versionString:!initializing!private! !
hash!comparing!public! !
libid!accessing!public! !
majorVersion!accessing!public! !
minorVersion!accessing!public! !
versionString!accessing!public! !
!

!AXTypeLibRegistration class methodsFor!

description: dString guidString: gString versionString: vString
	"Answer a new instance of the receiver for the specified typelib registration details."

	^self new
		description: dString guidString: gString versionString: vString
!

icon
	"Answers an <Icon> that can be used to represent this class"

	^AXTypeLibraryAnalyzer icon! !
!AXTypeLibRegistration class categoriesForMethods!
description:guidString:versionString:!instance creation!public! !
icon!constants!public! !
!

