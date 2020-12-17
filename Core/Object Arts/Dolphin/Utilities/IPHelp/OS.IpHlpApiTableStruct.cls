"Filed out from Dolphin Smalltalk 7"!

External.Structure subclass: #'OS.IpHlpApiTableStruct'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_dwNumEntries' -> 16r0
	}!
OS.IpHlpApiTableStruct guid: (Core.GUID fromString: '{4571e3b9-bbac-4c7c-a961-a048818d482b}')!
OS.IpHlpApiTableStruct comment: ''!
!OS.IpHlpApiTableStruct categoriesForClass!External-Data-Structured! !
!OS.IpHlpApiTableStruct methodsFor!

dwNumEntries
	"Answer the <Integer> value of the receiver's 'dwNumEntries' field."

	^bytes dwordAtOffset: _OffsetOf_dwNumEntries!

table
	^self subclassResponsibility! !
!OS.IpHlpApiTableStruct categoriesFor: #dwNumEntries!**compiled accessors**!public! !
!OS.IpHlpApiTableStruct categoriesFor: #table!accessing!public! !

!OS.IpHlpApiTableStruct class methodsFor!

defineFields
	"
	self compileDefinition
	"

	self defineField: #dwNumEntries type: DWORDField readOnly!

getFieldNames
	^#(#dwNumEntries)! !
!OS.IpHlpApiTableStruct class categoriesFor: #defineFields!initializing!public! !
!OS.IpHlpApiTableStruct class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

