"Filed out from Dolphin Smalltalk 7"!

Object subclass: #Category
	instanceVariableNames: 'name'
	classVariableNames: 'PermanentCategories'
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Category guid: (GUID fromString: '{87b4c45f-026e-11d3-9fd7-00a0cc3e4a32}')!
Category isAbstract: true!
Category comment: 'The abstract Category class is used to organize <Class> and <CompiledMethod> objects into subgroupings independent of the implementation hierarchy. This structuring is for the benefit of the user navigating through thousands of classes and methods in the Dolphin Smalltalk development system, and has no run-time significance.

Instance Variables:
	name	<String> name of the receiver, unique in the system.
	comment	<String> description of the category, for documentary purposes.

Class Variables:
	PermanentCategories		<Set> of all categories which are always available, even if empty
	'!
!Category categoriesForClass!System-Support! !
!Category methodsFor!

<= comperand
	"Answer whether the receiver is less than or equal to the <Category>,
	comperand."

	^self name <= comperand name!

= comperand
	"Answer whether the receiver is considered equal to the <Object>, comperand."

	^self species == comperand species and: [self name = comperand name]!

acceptsAdditions
	"Answer whether new members can be added to the receiver.
	Generally speaking pseudo categories do not accept additions, and
	ordinary categories do. Some types of non-pseudo virtual categories
	can have methods added to them."

	^self isPseud not!

addClass: class
	"Add the <Class>, class, to the collection of classes associated with the receiver."

	^self subclassResponsibility!

asString
	"Answer the string representation for the receiver."

	^self name!

contents
	#deprecated.
	^self subclassResponsibility!

displayOn: aStream
	"Append the receiver to aStream in a format that a user would want to see"

	aStream nextPutAll: self name!

hash
	"Answer the <integer> hash value for the receiver."

	^self name hash!

isEmpty
	"Answer whether the receiver is an empty category (with no members)"

	^self subclassResponsibility!

isIntermediate
	"Private - Answer whether the receiver is a temporary category used only as a 
	branch node in a category tree."

	^false!

isPermanent
	"Answer whether the receiver should be not removed from a CategoryManager
	when there are no references to it."

	^self permanentCategories includes: self!

isPermanent: aBoolean
	"Set whether the receiver should not be removed when there are
	no references to it."

	aBoolean
		ifTrue: [self permanentCategories add: self]
		ifFalse: [self permanentCategories remove: self ifAbsent: []]!

isPseud
	"Answer whether the receiver is a pseudo (i.e. not a 'real') category.
	Pseudo categories have dynamically calculated contents, and may not accept 
	additions."

	^self isVirtual!

isVirtual
	"Answer whether the receiver is a virtual category, i.e. one that
	has calculated contents. All pseudo-categories are virtual, but not vice versa."

	^false!

localName
	"Answer the local name of the receiver unique only within the parent category"

	^name copyFrom: (name lastIndexOf: self class separator)+1 to: name size!

name
	"Answer a unique, amongst Category objects, <readableString> name for the receiver."

	^name!

permanentCategories
	^PermanentCategories ifNil: [PermanentCategories := IdentitySet new]!

printOn: aStream
	"Append a representation of the receiver to aStream."

	aStream 
		basicPrint: self;
		nextPut: $(;
		print: name;
		nextPut: $)!

removeClass: class
	"Remove the <ClassDescription>, class, from the classes 'held' by the receiver."

	^self subclassResponsibility!

setName: aName
	"Private - Set the name of the receiver to aName.

	Restrict access because name has to be unique amongst all Categories and
	so we have to ensure that the Category categoryNames dictionary is kept
	up to date."

	name := aName!

subNames
	"Answer an OrderedCollection of the receivers name split
	on category separator."

	^self class separator split: self name! !
!Category categoriesFor: #<=!comparing!public! !
!Category categoriesFor: #=!comparing!public! !
!Category categoriesFor: #acceptsAdditions!public!testing! !
!Category categoriesFor: #addClass:!adding!public! !
!Category categoriesFor: #asString!converting!public! !
!Category categoriesFor: #contents!enumerating!public! !
!Category categoriesFor: #displayOn:!displaying!public! !
!Category categoriesFor: #hash!comparing!public! !
!Category categoriesFor: #isEmpty!public!testing! !
!Category categoriesFor: #isIntermediate!private!testing! !
!Category categoriesFor: #isPermanent!accessing!public! !
!Category categoriesFor: #isPermanent:!accessing!public! !
!Category categoriesFor: #isPseud!public!testing! !
!Category categoriesFor: #isVirtual!public!testing! !
!Category categoriesFor: #localName!accessing!public! !
!Category categoriesFor: #name!accessing!public! !
!Category categoriesFor: #permanentCategories!accessing!public! !
!Category categoriesFor: #printOn:!printing!public! !
!Category categoriesFor: #removeClass:!public!removing! !
!Category categoriesFor: #setName:!initializing!private! !
!Category categoriesFor: #subNames!accessing!public! !

!Category class methodsFor!

name: categoryName
	"Answer the subinstance of the receiver with the 
	<readableString> name, categoryName."

	^self subclassResponsibility!

new
	"Categories must be unique for any particular name, and must be instantiated with the #name:
	method."

	^self shouldNotImplement!

newNamed: categoryName
	"Private - Answer a new subinstance of the receiver with the 
	<readableString> name, categoryName."

	^self basicNew
		setName: categoryName asString;
		yourself!

separator
	"Private - Answer a Character used to split the individual names in a
	complete category."

	^ $-!

unclassified
	"Answer a Category used to mark an unclassified object."

	^self name: self unclassifiedName!

unclassifiedName
	"Private - Answer the String name used to mark a none existing category."

	^self subclassResponsibility!

uninitialize
	"Private - Uninitialize the receiver as it is about to be removed from the system."

	PermanentCategories := nil.! !
!Category class categoriesFor: #name:!instance creation!public! !
!Category class categoriesFor: #new!instance creation!public! !
!Category class categoriesFor: #newNamed:!instance creation!private! !
!Category class categoriesFor: #separator!constants!private! !
!Category class categoriesFor: #unclassified!instance creation!public! !
!Category class categoriesFor: #unclassifiedName!constants!private! !
!Category class categoriesFor: #uninitialize!class hierarchy-removing!private! !

