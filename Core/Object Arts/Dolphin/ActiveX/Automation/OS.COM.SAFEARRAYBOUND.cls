"Filed out from Dolphin Smalltalk 7"!

OS.COM.OLEStructure subclass: #'OS.COM.SAFEARRAYBOUND'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_cElements' -> 16r0.
		'_OffsetOf_lLbound' -> 16r4
	}!
OS.COM.SAFEARRAYBOUND guid: (Core.GUID fromString: '{c06f3b74-0868-11d3-93af-00a024ca708a}')!
OS.COM.SAFEARRAYBOUND comment: '<SAFEARRAYBOUND> is an <ExternalStructure> class to wrap the struct ''''OAIDL.SAFEARRAYBOUND'''' from type information in the ''''Ole Automation Type Library'''' library.

A SAFEARRAYBOUND describes one dimension of a SAFEARRAY, or C array when used to describe a VT_CARRAY in a <TYPEDESC>.'!
!OS.COM.SAFEARRAYBOUND categoriesForClass!External-Data-Structured-COM! !
!OS.COM.SAFEARRAYBOUND methodsFor!

cElements
	"Answer the <Integer> value of the receiver's 'cElements' field."

	^bytes dwordAtOffset: _OffsetOf_cElements!

cElements: anInteger
	"Set the receiver's 'cElements' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_cElements put: anInteger!

lLbound
	"Answer the <Integer> value of the receiver's 'lLbound' field."

	^bytes sdwordAtOffset: _OffsetOf_lLbound!

lLbound: anInteger
	"Set the receiver's 'lLbound' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_lLbound put: anInteger! !
!OS.COM.SAFEARRAYBOUND categoriesFor: #cElements!**compiled accessors**!public! !
!OS.COM.SAFEARRAYBOUND categoriesFor: #cElements:!**compiled accessors**!public! !
!OS.COM.SAFEARRAYBOUND categoriesFor: #lLbound!**compiled accessors**!public! !
!OS.COM.SAFEARRAYBOUND categoriesFor: #lLbound:!**compiled accessors**!public! !

!OS.COM.SAFEARRAYBOUND class methodsFor!

defineFields
	"Define the fields of the SAFEARRAYBOUND structure.
		SAFEARRAYBOUND compileDefinition
	
		typedef 		struct tagSAFEARRAYBOUND {
			unsigned long cElements;
			long lLbound;
		} SAFEARRAYBOUND;

	"

	self
		defineField: #cElements type: DWORDField new;
		defineField: #lLbound type: SDWORDField new!

getFieldNames
	^#(#cElements #lLbound)! !
!OS.COM.SAFEARRAYBOUND class categoriesFor: #defineFields!**auto generated**!public!template definition! !
!OS.COM.SAFEARRAYBOUND class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

