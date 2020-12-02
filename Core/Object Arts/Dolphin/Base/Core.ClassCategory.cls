"Filed out from Dolphin Smalltalk 7"!

Category subclass: #ClassCategory
	instanceVariableNames: ''
	classVariableNames: 'Table Unclassified'
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ClassCategory guid: (GUID fromString: '{87b4c500-026e-11d3-9fd7-00a0cc3e4a32}')!
ClassCategory comment: ''!
!ClassCategory categoriesForClass!System-Support! !
!ClassCategory methodsFor!

addClass: class
	"Add the <Class>, class, to the collection of classes associated with the receiver."

	class includeInCategory: self!

classes
	"Answer a Collection of all Class objects which are held by the receiver."

	^Smalltalk allClasses select: [:aClass | self includesClass: aClass]!

contents
	Notification deprecated.
	^self classes!

includesClass: class
	"Answer whether the receiver includes the <ClassDescription>, class."

	^class classCategories
		ifNil: [self == self class unclassified]
		ifNotNil: [:classCategories | classCategories identityIncludes: self]!

isEmpty
	"Answer whether the receiver is an empty category (with no members)"

	^(Smalltalk allClasses anySatisfy: [:aClass | self includesClass: aClass]) not!

removeClass: aClass
	"Remove aClass from the classes held by the reciver. Answer
	aMethod."

	aClass removeFromCategory: self.
	^aClass! !
!ClassCategory categoriesFor: #addClass:!adding!public! !
!ClassCategory categoriesFor: #classes!public! !
!ClassCategory categoriesFor: #contents!enumerating!public! !
!ClassCategory categoriesFor: #includesClass:!public!testing! !
!ClassCategory categoriesFor: #isEmpty!public!testing! !
!ClassCategory categoriesFor: #removeClass:!public!removing! !

!ClassCategory class methodsFor!

allClassCategories
	"Answer the set of all <classCategory>s current registered in the system."

	^self table asArray!

initialize
	"Private - Initialize the receiver's class variables.

	This is a No-Op because we have to create the table
	during the booting process of Dolphin so all the methods
	categories can be set as they are loaded. Support for the booting
	of the system is unnecessary in the release version of Dolphin but
	it resolves the conundrom of creating the Smalltalk system, which
	relies on itself to work, from nothing using smalltalk. 

	It is unwise to clear down this table, as the development system
	expects methods and classes to be correctly categorized."
"	| newTable |

	newTable := WeakLookupTable new.
	newTable addAll: Table associations.
	Table := newTable"

	"During the boot, weakness doesn't work properly, so some repairs may be needed"
	Unclassified := self newNamed: self unclassifiedName.
	Table 
		at: self unclassifiedName put: Unclassified;
		removeKey: 'No category' ifAbsent: []!

name: cat
	"Answer a new or existing class category with the specified name."

	| nameString |
	nameString := cat asString.
	^nameString isEmpty 
		ifTrue: [self unclassified]
		ifFalse: [self table at: nameString ifAbsentPut: [self newNamed: nameString]]!

table
	^Table ifNil: [Table := WeakLookupTable new]!

unclassified
	"Answer a <ClassCategory> used to mark an unclassified classes."

	^Unclassified
		ifNil: 
			[Unclassified := self newNamed: self unclassifiedName.
			self table at: self unclassifiedName put: Unclassified.
			Unclassified]!

unclassifiedName
	"Private - Answer the String name used to mark a none existing category."

	^ 'Unclassified'!

uninitialize
	"Private - Uninitialize the receiver as it is about to be removed from the system."

	Table := nil.
	Unclassified := nil! !
!ClassCategory class categoriesFor: #allClassCategories!accessing!public! !
!ClassCategory class categoriesFor: #initialize!initializing!private! !
!ClassCategory class categoriesFor: #name:!instance creation!public! !
!ClassCategory class categoriesFor: #table!accessing!private! !
!ClassCategory class categoriesFor: #unclassified!instance creation!public! !
!ClassCategory class categoriesFor: #unclassifiedName!constants!private! !
!ClassCategory class categoriesFor: #uninitialize!class hierarchy-removing!private! !

