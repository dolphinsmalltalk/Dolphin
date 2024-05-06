"Filed out from Dolphin Smalltalk"!

BasicInspector subclass: #StructureInspector
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

StructureInspector guid: (GUID fromString: '{87b4c697-026e-11d3-9fd7-00a0cc3e4a32}')!

StructureInspector comment: 'StructureInspector is a <compositePresenter> that implements a specialised inspect facility onto a <ExternalStructure>. This allows the structure to be inspected via its name fields.'!

!StructureInspector categoriesForClass!MVP-Presenters! !

!StructureInspector methodsFor!

fields
	"Private - Answer the of fields in the field list (named and indexable instance variables), which appear 
	after the inspectors header fields (accessors implemented by the inspector itself), and before
	any extra fields (accessors implemented by the inspected object). Overridden because structure
	inspectors do not include the raw data bytes."

	^self selfField class instSize!

getField: anInteger
	"Private - Answer the field of the receiver's object which has the key at index
	anInteger in the field list (0 based)."

	^self getFieldExtra: anInteger	!

getFieldList
	"Private - Answer the list of fields to be displayed in the instance variable list
	of the InspectorShell. Numeric indices for the elements of the 
	OrderedCollection are answered"

	^self selfField class allInstVarNames , self selfField getFieldNames!

setField: anInteger to: anObject
	"Private - Determine the field of the receiver's object which has the key at index
	anInteger in the field list, and set its value to anObject."

	anInteger > self selfField class instSize 
		ifTrue: 
			[self selfField 
				setField: (self variableNamesList at: anInteger + self headerSize)
				value: anObject]
		ifFalse: [super setField: anInteger to: anObject]! !

!StructureInspector categoriesForMethods!
fields!accessing!private! !
getField:!accessing!private! !
getFieldList!accessing!private! !
setField:to:!accessing!private! !
!

