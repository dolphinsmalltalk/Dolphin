"Filed out from Dolphin Smalltalk"!

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

!IpHlpApiTableStruct categoriesForMethods!
dwNumEntries!**compiled accessors**!public! !
table!accessing!public! !
!

!IpHlpApiTableStruct class methodsFor!

defineFields
	"
	self compileDefinition
	"

	self defineField: #dwNumEntries type: DWORDField readOnly!

getFieldNames
	^#(#dwNumEntries)! !

!IpHlpApiTableStruct class categoriesForMethods!
defineFields!initializing!public! !
getFieldNames!**compiled accessors**!constants!private! !
!

