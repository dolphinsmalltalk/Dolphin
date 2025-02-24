﻿"Filed out from Dolphin Smalltalk"!

Core.Category
	subclass: #'Core.ClassCategory'
	instanceVariableNames: ''
	classVariableNames: 'Deprecated Table Unclassified'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { 'UnclassifiedName' -> 'Unclassified' }!

Core.ClassCategory guid: (Core.GUID fromString: '{87b4c500-026e-11d3-9fd7-00a0cc3e4a32}')!

Core.ClassCategory comment: ''!

!Core.ClassCategory categoriesForClass!System-Support! !

!Core.ClassCategory methodsFor!

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
		ifNil: [name = UnclassifiedName]
		ifNotNil: [:classCategories | classCategories identityIncludes: self]!

isEmpty
	"Answer whether the receiver is an empty category (with no members)"

	^(Smalltalk allClasses anySatisfy: [:aClass | self includesClass: aClass]) not!

removeClass: aClass
	"Remove aClass from the classes held by the reciver. Answer
	aMethod."

	aClass removeFromCategory: self.
	^aClass! !

!Core.ClassCategory categoriesForMethods!
addClass:!adding!public! !
classes!public! !
contents!enumerating!public! !
includesClass:!public!testing! !
isEmpty!public!testing! !
removeClass:!development!public!removing! !
!

!Core.ClassCategory class methodsFor!

allClassCategories
	"Answer the set of all <classCategory>s current registered in the system."

	^self table asArray!

deprecated
	"Answer a <ClassCategory> used to mark deprecated classes."

	^Deprecated!

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

	Unclassified := Table at: UnclassifiedName ifAbsentPut: [self newNamed: UnclassifiedName].
	Deprecated := Table at: 'Deprecated' ifAbsentPut: [self newNamed: 'Deprecated'].
	Table removeKey: 'No category' ifAbsent: nil"Private - Answer the String name used to mark a none existing category.""Private - Answer the String name used to mark a none existing category."!

name: cat
	"Answer a new or existing class category with the specified name."

	| nameString |
	nameString := cat asString.
	^nameString isEmpty 
		ifTrue: [self unclassified]
		ifFalse: [self table at: nameString ifAbsentPutClean: [self newNamed: nameString]]!

table
	^Table ifNil: [Table := WeakLookupTable new]!

unclassified
	"Answer a <ClassCategory> used to mark an unclassified classes."

	^Unclassified
		ifNil: 
			[Unclassified := self newNamed: UnclassifiedName.
			self table at: UnclassifiedName put: Unclassified]!

uninitialize
	"Private - Uninitialize the receiver as it is about to be removed from the system."

	Table := Unclassified := nil.
	Deprecated := DeafObject current! !

!Core.ClassCategory class categoriesForMethods!
allClassCategories!accessing!public! !
deprecated!instance creation!public! !
initialize!initializing!private! !
name:!instance creation!public! !
table!accessing!private! !
unclassified!instance creation!public! !
uninitialize!class hierarchy-removing!private! !
!

