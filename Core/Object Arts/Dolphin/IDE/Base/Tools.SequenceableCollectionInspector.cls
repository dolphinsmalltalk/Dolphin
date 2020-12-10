"Filed out from Dolphin Smalltalk 7"!

Tools.BasicInspector subclass: #'Tools.SequenceableCollectionInspector'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.SequenceableCollectionInspector guid: (Core.GUID fromString: '{87b4c696-026e-11d3-9fd7-00a0cc3e4a32}')!
Tools.SequenceableCollectionInspector comment: 'SequenceableCollectionInspector is a <compositePresenter> that implements a specialised inspect facility onto a <SequenceableCollection>. This allows the collection to be inspected via its integer indices.'!
!Tools.SequenceableCollectionInspector categoriesForClass!MVP-Presenters! !
!Tools.SequenceableCollectionInspector methodsFor!

getField: anInteger
	"Private - Answer the field of the receiver's object which has the key at index
	anInteger in the field list (1 based)."

	| instSize |
	instSize := self selfField class instSize.
	^anInteger > instSize 
		ifTrue: [self selfField at: anInteger - instSize]
		ifFalse: [self selfField instVarAt: anInteger]!

getFieldList
	"Private - Answer the list of fields to be displayed in the instance variable list
	of the inspector. Numeric indices for the elements of the collection are answered."

	| size |
	size := [self selfField size] on: Error do: [:e | 0].
	^self selfField class allInstVarNames , (1 to: size)!

setField: anInteger to: anObject
	"Private - Determine the field of the receiver's object which has the key at index
	anInteger in the field list, and set its value to anObject."

	| instSize |
	instSize := self selfField class instSize.
	anInteger > instSize 
		ifTrue: [self selfField at: anInteger - instSize put: anObject]
		ifFalse: [self selfField instVarAt: anInteger put: anObject]! !
!Tools.SequenceableCollectionInspector categoriesFor: #getField:!accessing!private! !
!Tools.SequenceableCollectionInspector categoriesFor: #getFieldList!accessing!private! !
!Tools.SequenceableCollectionInspector categoriesFor: #setField:to:!accessing!private! !

