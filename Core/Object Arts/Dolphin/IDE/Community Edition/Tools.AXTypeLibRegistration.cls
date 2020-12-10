"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'Tools.AXTypeLibRegistration'
	instanceVariableNames: 'description guidString versionString minor major'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.AXTypeLibRegistration guid: (Core.GUID fromString: '{187aaa33-6992-4cfc-bac1-e8a4cb9ea0f9}')!
Tools.AXTypeLibRegistration comment: 'AXTypeLibRegistration is a simple class to hold registration information for a type library which might not yet be loaded.

Instance Variables:
	description		<String>
	guidString		<String>
	versionString	<String>

'!
!Tools.AXTypeLibRegistration categoriesForClass!Unclassified! !
!Tools.AXTypeLibRegistration methodsFor!

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
!Tools.AXTypeLibRegistration categoriesFor: #<!comparing!public! !
!Tools.AXTypeLibRegistration categoriesFor: #<=!comparing!public! !
!Tools.AXTypeLibRegistration categoriesFor: #=!comparing!public! !
!Tools.AXTypeLibRegistration categoriesFor: #buildVersionNumbers!accessing!helpers!private! !
!Tools.AXTypeLibRegistration categoriesFor: #description!accessing!public! !
!Tools.AXTypeLibRegistration categoriesFor: #description:guidString:versionString:!initializing!private! !
!Tools.AXTypeLibRegistration categoriesFor: #hash!comparing!public! !
!Tools.AXTypeLibRegistration categoriesFor: #libid!accessing!public! !
!Tools.AXTypeLibRegistration categoriesFor: #majorVersion!accessing!public! !
!Tools.AXTypeLibRegistration categoriesFor: #minorVersion!accessing!public! !
!Tools.AXTypeLibRegistration categoriesFor: #versionString!accessing!public! !

!Tools.AXTypeLibRegistration class methodsFor!

description: dString guidString: gString versionString: vString
	"Answer a new instance of the receiver for the specified typelib registration details."

	^self new
		description: dString guidString: gString versionString: vString
!

icon
	"Answers an <Icon> that can be used to represent this class"

	^Smalltalk.AXTypeLibraryAnalyzer icon! !
!Tools.AXTypeLibRegistration class categoriesFor: #description:guidString:versionString:!instance creation!public! !
!Tools.AXTypeLibRegistration class categoriesFor: #icon!constants!public! !

