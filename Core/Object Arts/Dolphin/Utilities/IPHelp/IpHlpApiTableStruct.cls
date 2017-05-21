"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #IpHlpApiTableStruct
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IpHlpApiTableStruct guid: (GUID fromString: '{4571e3b9-bbac-4c7c-a961-a048818d482b}')!
IpHlpApiTableStruct comment: ''!
!IpHlpApiTableStruct categoriesForClass!External-Data-Structured! !
!IpHlpApiTableStruct methodsFor!

dwNumEntries
	"Answer the receiver's dwNumEntries field as a Smalltalk object."

	^(bytes dwordAtOffset: 0)!

table
	^self subclassResponsibility! !
!IpHlpApiTableStruct categoriesFor: #dwNumEntries!**compiled accessors**!public! !
!IpHlpApiTableStruct categoriesFor: #table!accessing!public! !

!IpHlpApiTableStruct class methodsFor!

defineFields
	"
	self compileDefinition
	"

	self defineField: #dwNumEntries type: DWORDField readOnly! !
!IpHlpApiTableStruct class categoriesFor: #defineFields!initializing!public! !

