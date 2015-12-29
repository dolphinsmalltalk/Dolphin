"Filed out from Dolphin Smalltalk 2000 release 5.00"!

Inspector subclass: #DBRowInspector
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DBRowInspector guid: (GUID fromString: '{87B4C693-026E-11D3-9FD7-00A0CC3E4A32}')!
DBRowInspector comment: 'A DBRowInspector is a specialized inspector for viewing a <DBRow>. The field values are interrogated from the underlying data table and are displayed in the standard inspector two pane layout.'!
!DBRowInspector categoriesForClass!Development!MVP-Presenters!ODBC Interface! !
!DBRowInspector methodsFor!

getField: anInteger
	"Private - Answer the field of the receiver's object at index anInteger."

	^self selfField contents at: anInteger!

getFieldList
	"Private - Answer an OrderedCollection of field names for filling the inspector instance
	variable list."

	^self selfField columns collect: [:c | c name]!

setField: anInteger to: anObject
	"Private - Determine the field of the receiver's object which has the key at index
	anInteger in the field list, and set its value to anObject."

	self shouldNotImplement! !
!DBRowInspector categoriesFor: #getField:!accessing!private! !
!DBRowInspector categoriesFor: #getFieldList!accessing!private! !
!DBRowInspector categoriesFor: #setField:to:!*-should not implement!commands!private! !

