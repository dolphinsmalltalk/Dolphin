"Filed out from Dolphin Smalltalk"!

External.Structure
	subclass: #'OS.AbstractCHARRANGE'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { '_CHARRANGE_Size' -> 16r8 }!
OS.AbstractCHARRANGE guid: (Core.GUID fromString: '{3595c0ec-31e8-4237-9857-8bc522529953}')!
OS.AbstractCHARRANGE isNonInstantiable: true!
OS.AbstractCHARRANGE comment: ''!
!OS.AbstractCHARRANGE methodsFor!

asObject
	"Answer the <Object> value represented by the receiver."

	^self cpMin to: self cpMax!

cpMax
	"Answer the <Integer> value of the receiver's 'cpMax' field."

	^self subclassResponsibility!

cpMin
	"Answer the <Integer> value of the receiver's 'cpMin' field."

	^self subclassResponsibility! !
!OS.AbstractCHARRANGE categoriesForMethods!
asObject!accessing!public! !
cpMax!**compiled accessors**!public! !
cpMin!**compiled accessors**!public! !
!

!OS.AbstractCHARRANGE class methodsFor!

getFieldNames
	^#(#cpMin #cpMax)! !
!OS.AbstractCHARRANGE class categoriesForMethods!
getFieldNames!constants!private! !
!

