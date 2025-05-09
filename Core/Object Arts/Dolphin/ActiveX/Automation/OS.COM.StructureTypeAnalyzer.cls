﻿"Filed out from Dolphin Smalltalk"!

OS.COM.TypeInfoAnalyzer
	subclass: #'OS.COM.StructureTypeAnalyzer'
	instanceVariableNames: ''
	classVariableNames: 'BuiltIns'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.COM.StructureTypeAnalyzer guid: (Core.GUID fromString: '{17f3ff59-eb25-47b0-8831-7e0d0960d84d}')!

OS.COM.StructureTypeAnalyzer comment: ''!

!OS.COM.StructureTypeAnalyzer methodsFor!

baseClass
	"Private - Answer the Dolphin class used to represent superclass of the receiver."

	| firstVar |
	firstVar := self variables first.
	^(firstVar isAnonymous and: [firstVar tdesc isAnonymous not])
		ifTrue: [firstVar tdesc typeInfo binding value]
		ifFalse: [Structure]!

byteSize
	"Answer the size in bytes of the structure described by the receiver."

	^self attributes cbSizeInstance!

classDesc
	"Private - Answer an <association> between a Dolphin class suitable for representing
	the external type described by the receiver, and the number of indirections
	to the type."

	^self programObject -> 0!

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
	^(Structure classForGUID: id ifNone: nil)
		ifNil: [super suggestedBinding]
		ifNotNil: [:structClass | structClass binding]! !

!OS.COM.StructureTypeAnalyzer categoriesForMethods!
baseClass!constants!private! !
byteSize!accessing!public! !
classDesc!constants!private! !
isAnonymous!public!testing! !
isStructure!public!testing! !
members!enumerating!public! !
name!accessing!public! !
recordInfoIfNone:!accessing!public! !
suggestedBinding!accessing!private! !
!

!OS.COM.StructureTypeAnalyzer class methodsFor!

initialize
	BuiltIns := LookupTable new.
	{Handle} do: [:each | BuiltIns at: each guid put: each]! !

!OS.COM.StructureTypeAnalyzer class categoriesForMethods!
initialize!initializing!private! !
!

