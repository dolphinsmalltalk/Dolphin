"Filed out from Dolphin Smalltalk 7"!

AXTypeInfoAnalyzer subclass: #AXStructureTypeAnalyzer
	instanceVariableNames: ''
	classVariableNames: 'BuiltIns'
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
AXStructureTypeAnalyzer guid: (GUID fromString: '{17f3ff59-eb25-47b0-8831-7e0d0960d84d}')!
AXStructureTypeAnalyzer comment: ''!
!AXStructureTypeAnalyzer categoriesForClass!Unclassified! !
!AXStructureTypeAnalyzer methodsFor!

baseClass
	"Private - Answer the Dolphin class used to represent superclass of the receiver."

	| firstVar |
	firstVar := self variables first.
	^(firstVar isAnonymous and: [firstVar tdesc isAnonymous not])
		ifTrue: [firstVar tdesc typeInfo globalBinding value]
		ifFalse: [ExternalStructure]!

byteSize
	"Answer the size in bytes of the structure described by the receiver."

	^self attributes cbSizeInstance!

classDesc
	"Private - Answer an <association> between a Dolphin class suitable for representing
	the external type described by the receiver, and the number of indirections
	to the type."

	^self global -> 0!

isAnonymous
	"Answer whether the receiver describes an anonymous (i.e. unnamed) structure or union."

	^self name beginsWith: '_MIDL_'!

isStructure
	"Answer whether the receiver describes a struct or union type."

	^true!

members
	"Answer <sequencedReadableCollection> of VARDESCs describing the 
	member variables of the receiver's structure (assumes it is a structure -
	if it isn't the collection will be empty)."

	^self variables!

name
	"Answer a <readableString> name for the receiver, retrieved from the
	documentation."
	
	^self nameSansTag!

recordInfoIfNone: exceptionHandler 
	"Answer an <IRecordInfo> on the receiver's type information (useful for wrapping
	user-defined types (UDTs) in <VARIANT>s and <SAFEARRAY>s).
	Note that the receiver's type library must have a uuid() attribute associated with 
	the receiver, and the library must have been generated in a certain way for the
	GUID to be associated with the structure rather than its typedef: 'The IDL file must 
	be compiled using MIDL /mktyplib203 to generate a type library with UUID set to the 
	UDT. Otherwise MIDL will create an alias and set UUID on that alias.'
	Also the structure must contain only variant compatible fields."

	^self tlbInterface recordInfoIfNone: exceptionHandler!

suggestedBinding
	"Private - Answer an <Association> for the global binding (or the proposed global binding) 
	for the receiver, on the assumption that it doesn't currently have a binding.
	Implementation Note: Override because there is a global table of structure classes which 
	we can use to look up any existing wrapper class, although in practice not many structures
	defined in type libraries actually have an associated GUID."

	| id |
	self isAnonymous ifTrue: [^nil].
	(id := self guid) isNull ifTrue: [^super suggestedBinding].
	^(ExternalStructure classForGUID: id ifNone: []) 
		ifNil: [super suggestedBinding]
		ifNotNil: [:structClass | structClass environment associationAt: structClass name]! !
!AXStructureTypeAnalyzer categoriesFor: #baseClass!constants!private! !
!AXStructureTypeAnalyzer categoriesFor: #byteSize!accessing!public! !
!AXStructureTypeAnalyzer categoriesFor: #classDesc!constants!private! !
!AXStructureTypeAnalyzer categoriesFor: #isAnonymous!public!testing! !
!AXStructureTypeAnalyzer categoriesFor: #isStructure!public!testing! !
!AXStructureTypeAnalyzer categoriesFor: #members!enumerating!public! !
!AXStructureTypeAnalyzer categoriesFor: #name!accessing!public! !
!AXStructureTypeAnalyzer categoriesFor: #recordInfoIfNone:!accessing!public! !
!AXStructureTypeAnalyzer categoriesFor: #suggestedBinding!accessing!private! !

!AXStructureTypeAnalyzer class methodsFor!

initialize
	BuiltIns := LookupTable new.
	{ExternalHandle} do: [:each | BuiltIns at: each guid put: each]! !
!AXStructureTypeAnalyzer class categoriesFor: #initialize!initializing!private! !

