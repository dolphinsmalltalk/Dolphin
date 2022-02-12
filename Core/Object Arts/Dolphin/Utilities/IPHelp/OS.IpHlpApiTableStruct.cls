"Filed out from Dolphin Smalltalk"!

External.Structure subclass: #'OS.IpHlpApiTableStruct'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_IpHlpApiTableStruct_Size' -> 16r4.
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
!OS.IpHlpApiTableStruct categoriesForMethods!
dwNumEntries!**compiled accessors**!public! !
table!accessing!public! !
!

!OS.IpHlpApiTableStruct class methodsFor!

byteSize
	^_IpHlpApiTableStruct_Size!

defineFields
	"
	self compileDefinition
	"

	self defineField: #dwNumEntries type: DWORDField readOnly!

getFieldNames
	^#(#dwNumEntries)! !
!OS.IpHlpApiTableStruct class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!initializing!public! !
getFieldNames!**compiled accessors**!constants!private! !
!

