"Filed out from Dolphin Smalltalk 7"!

Tools.BasicInspector subclass: #'Tools.StructureInspector'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.StructureInspector guid: (Core.GUID fromString: '{87b4c697-026e-11d3-9fd7-00a0cc3e4a32}')!
Tools.StructureInspector comment: 'StructureInspector is a <compositePresenter> that implements a specialised inspect facility onto a <ExternalStructure>. This allows the structure to be inspected via its name fields.'!
!Tools.StructureInspector categoriesForClass!MVP-Presenters! !
!Tools.StructureInspector methodsFor!

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
!Tools.StructureInspector categoriesFor: #fields!accessing!private! !
!Tools.StructureInspector categoriesFor: #getField:!accessing!private! !
!Tools.StructureInspector categoriesFor: #getFieldList!accessing!private! !
!Tools.StructureInspector categoriesFor: #setField:to:!accessing!private! !

