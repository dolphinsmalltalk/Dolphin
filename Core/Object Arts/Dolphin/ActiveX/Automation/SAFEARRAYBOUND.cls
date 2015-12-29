"Filed out from Dolphin Smalltalk X6.1"!

OLEStructure subclass: #SAFEARRAYBOUND
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SAFEARRAYBOUND guid: (GUID fromString: '{C06F3B74-0868-11D3-93AF-00A024CA708A}')!
SAFEARRAYBOUND comment: '<SAFEARRAYBOUND> is an <ExternalStructure> class to wrap the struct ''''OAIDL.SAFEARRAYBOUND'''' from type information in the ''''Ole Automation Type Library'''' library.

A SAFEARRAYBOUND describes one dimension of a SAFEARRAY, or C array when used to describe a VT_CARRAY in a <TYPEDESC>.'!
!SAFEARRAYBOUND categoriesForClass!External-Data-Structured-COM! !
!SAFEARRAYBOUND methodsFor!

cElements
	"Answer the receiver's cElements field as a Smalltalk object."

	^bytes dwordAtOffset: 0!

cElements: anObject 
	"Set the receiver's cElements field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject!

lLbound
	"Answer the receiver's lLbound field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #lLbound)!

lLbound: anObject 
	"Set the receiver's lLbound field to the value of anObject."

	bytes sdwordAtOffset: ##(self offsetOf: #lLbound) put: anObject! !
!SAFEARRAYBOUND categoriesFor: #cElements!**compiled accessors**!public! !
!SAFEARRAYBOUND categoriesFor: #cElements:!**compiled accessors**!public! !
!SAFEARRAYBOUND categoriesFor: #lLbound!**compiled accessors**!public! !
!SAFEARRAYBOUND categoriesFor: #lLbound:!**compiled accessors**!public! !

!SAFEARRAYBOUND class methodsFor!

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
		defineField: #lLbound type: SDWORDField new! !
!SAFEARRAYBOUND class categoriesFor: #defineFields!**auto generated**!initializing!public! !

