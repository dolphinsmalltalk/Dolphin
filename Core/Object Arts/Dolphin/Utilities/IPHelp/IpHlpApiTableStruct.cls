"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #IpHlpApiTableStruct
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_dwNumEntries'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IpHlpApiTableStruct guid: (GUID fromString: '{4571e3b9-bbac-4c7c-a961-a048818d482b}')!
IpHlpApiTableStruct addClassConstant: '_OffsetOf_dwNumEntries' value: 16r0!
IpHlpApiTableStruct comment: ''!
!IpHlpApiTableStruct categoriesForClass!External-Data-Structured! !
!IpHlpApiTableStruct methodsFor!

dwNumEntries
	"Answer the <Integer> value of the receiver's 'dwNumEntries' field."

	^bytes dwordAtOffset: _OffsetOf_dwNumEntries!

table
	^self subclassResponsibility! !
!IpHlpApiTableStruct categoriesFor: #dwNumEntries!**compiled accessors**!public! !
!IpHlpApiTableStruct categoriesFor: #table!accessing!public! !

!IpHlpApiTableStruct class methodsFor!

defineFields
	"
	self compileDefinition
	"

	self defineField: #dwNumEntries type: DWORDField readOnly!

getFieldNames
	^#(#dwNumEntries)! !
!IpHlpApiTableStruct class categoriesFor: #defineFields!initializing!public! !
!IpHlpApiTableStruct class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

