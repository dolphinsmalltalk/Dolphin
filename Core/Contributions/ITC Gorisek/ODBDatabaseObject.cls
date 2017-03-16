"Filed out from Dolphin Smalltalk 7"!

Object subclass: #ODBDatabaseObject
	instanceVariableNames: 'objectHolder'
	classVariableNames: 'ClassIDs'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBDatabaseObject guid: (GUID fromString: '{8162edd5-0fb8-11d4-b091-000000000000}')!
ODBDatabaseObject comment: '"Evaluate ODDatabaseObject>>initialize to initialize the ClassIDs array. "'!
!ODBDatabaseObject categoriesForClass!No category! !
!ODBDatabaseObject methodsFor!

close
	"Implemented by subclasses."

	!

garbageCollectOn: anODBGarbageCollector 
	self close!

makeTransactionObject: aTransaction 
	"Make transaction object from receiver. "

	self subclassResponsibility!

objectHolder
	^objectHolder!

openOn: anObjectHolder 
	objectHolder := anObjectHolder!

referencesDo: aBlock!

remove! !
!ODBDatabaseObject categoriesFor: #close!public! !
!ODBDatabaseObject categoriesFor: #garbageCollectOn:!public! !
!ODBDatabaseObject categoriesFor: #makeTransactionObject:!public! !
!ODBDatabaseObject categoriesFor: #objectHolder!public! !
!ODBDatabaseObject categoriesFor: #openOn:!public! !
!ODBDatabaseObject categoriesFor: #referencesDo:!public!public/unclassified! !
!ODBDatabaseObject categoriesFor: #remove!public! !

!ODBDatabaseObject class methodsFor!

addClassIDsTo: aDictionary 
	"Private - Add classID of each subclass of receiver 
        to aDictionary. Answer class ID maximum."

	| maxID |
	maxID := 0.
	self subclasses do: 
			[:each | 
			aDictionary at: each classID put: each.
			maxID := (each classID max: maxID) max: (each addClassIDsTo: aDictionary)].
	^maxID!

hasBytes
	"Answer <true> if the object stores its contents as bytes."

	^false!

hasExternalFiles
	"Answer <true> if the object stores its contents into external files."

	^false!

initialize
	"Private - Initialize ClassIDs array used to convert classID to appropriate class."

	| dict maxID |
	dict := IdentityDictionary new.
	maxID := self addClassIDsTo: dict.
	ClassIDs := Array new: maxID.
	dict keysAndValuesDo: [:key :value | ClassIDs at: key put: value]!

persistentClassAt: anInteger 
	"Answer persistent class for a given class ID."

	^ClassIDs at: anInteger! !
!ODBDatabaseObject class categoriesFor: #addClassIDsTo:!private! !
!ODBDatabaseObject class categoriesFor: #hasBytes!accessing!public! !
!ODBDatabaseObject class categoriesFor: #hasExternalFiles!accessing!public! !
!ODBDatabaseObject class categoriesFor: #initialize!private! !
!ODBDatabaseObject class categoriesFor: #persistentClassAt:!accessing!public! !

