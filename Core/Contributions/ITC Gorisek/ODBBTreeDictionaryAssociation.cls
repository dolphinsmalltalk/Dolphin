"Filed out from Dolphin Smalltalk X6.2"!

Object subclass: #ODBBTreeDictionaryAssociation
	instanceVariableNames: 'valueHolder key transaction'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBBTreeDictionaryAssociation guid: (GUID fromString: '{8162EDCC-0FB8-11D4-B091-000000000000}')!
ODBBTreeDictionaryAssociation comment: ''!
!ODBBTreeDictionaryAssociation categoriesForClass!No category! !
!ODBBTreeDictionaryAssociation methodsFor!

< aBTreeDictionaryAssociation 
	^key odbIsLessThan: aBTreeDictionaryAssociation key!

key
	^key!

keyAsInteger
		"Convert from BCD encoded byte array into integer."

	| value |
	value := 0.
	1 to: key size do: [:i | value := (value * 100) + ((key at: i) & 15) + (((key at: i) bitShift: -4) * 10) ].
	^value!

setKey: aKey value: aValue 
	key := aKey.
	valueHolder := aValue!

setTransaction: aTransaction key: aKey value: aValue 
	transaction := aTransaction.
	key := aKey.
	valueHolder := aValue!

value
	^valueHolder getObjectIn: transaction!

valueHolder
	"Private - Answer BTree valueHolder."

	^valueHolder!

valueObjectID
	^valueHolder objectID!

valueOrObjectID
	| obj |
	(obj := valueHolder object) isNil ifFalse: [^obj].
	^valueHolder objectID! !
!ODBBTreeDictionaryAssociation categoriesFor: #<!public! !
!ODBBTreeDictionaryAssociation categoriesFor: #key!public! !
!ODBBTreeDictionaryAssociation categoriesFor: #keyAsInteger!accessing!public! !
!ODBBTreeDictionaryAssociation categoriesFor: #setKey:value:!private! !
!ODBBTreeDictionaryAssociation categoriesFor: #setTransaction:key:value:!private! !
!ODBBTreeDictionaryAssociation categoriesFor: #value!public! !
!ODBBTreeDictionaryAssociation categoriesFor: #valueHolder!private! !
!ODBBTreeDictionaryAssociation categoriesFor: #valueObjectID!public! !
!ODBBTreeDictionaryAssociation categoriesFor: #valueOrObjectID!public! !

