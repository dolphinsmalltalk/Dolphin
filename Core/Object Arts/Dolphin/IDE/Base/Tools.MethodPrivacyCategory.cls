"Filed out from Dolphin Smalltalk 7"!

Tools.VirtualMethodCategory subclass: #'Tools.MethodPrivacyCategory'
	instanceVariableNames: 'privacy'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.MethodPrivacyCategory guid: (Core.GUID fromString: '{87b4c505-026e-11d3-9fd7-00a0cc3e4a32}')!
Tools.MethodPrivacyCategory comment: 'MethodPrivacyCategory is a virtual method category class used to dynamically group private/public methods.

This class has two instances representing the ''private'' and ''public'' categories.

The "privacy" of a method is recorded in the method header flags, and it is those flags which instantiations of this class test against to identify methods with the corresponding privacy level. Every method in the system will be in one or other MethodPrivacyCategory.

Instance Variables:
	privacy	<Integer> bit mask used to compare against the bits of the method headers.

Class Variables:
	None'!
!Tools.MethodPrivacyCategory categoriesForClass!System-Support! !
!Tools.MethodPrivacyCategory methodsFor!

acceptsAdditions
	"Answer whether methods can be added to the receiver.
	Although this is a pseudo category, it can accept additions."

	^true!

addMethodSilently: aCompiledMethod 
	"Private - Add the <CompiledMethod> argument to the set of methods that are 
	members of the receiver."

	"Implementation Note: As this is a public/private pseudo category, we just 
	set/reset the private flag on the method"

	aCompiledMethod isPrivate: privacy!

includesMethod: method
	"Answer whether the receiver includes the <CompiledMethod>, method."

	^method isPrivate == privacy!

isPrivacy
	"Private - Answer whether the receiver is a method privacy category."

	^true!

isPseud
	"Answer whether the receiver is a pseudo category (it isn't even though it is virtual)"

	^false!

privacy: anInteger 
	"Private - Set the privacy level represented by the receiver."

	privacy := anInteger!

removeMethodSilently: aCompiledMethod 
	"Private - Remove the <CompiledMethod> argument from the set of 
	methods that are members of the receiver, and make no fuss about it."

	aCompiledMethod isPrivate: privacy not! !
!Tools.MethodPrivacyCategory categoriesFor: #acceptsAdditions!public!testing! !
!Tools.MethodPrivacyCategory categoriesFor: #addMethodSilently:!adding!private! !
!Tools.MethodPrivacyCategory categoriesFor: #includesMethod:!public!testing! !
!Tools.MethodPrivacyCategory categoriesFor: #isPrivacy!private!testing! !
!Tools.MethodPrivacyCategory categoriesFor: #isPseud!public!testing! !
!Tools.MethodPrivacyCategory categoriesFor: #privacy:!accessing!private! !
!Tools.MethodPrivacyCategory categoriesFor: #removeMethodSilently:!private!removing! !

!Tools.MethodPrivacyCategory class methodsFor!

initialize
	"Private - Initialize the receiver's class variables, etc.
	N.B. This is present to support the Dolphin boot process, it is
	not intended to be re-run subsequently."

	| hermits cave |
	cave := self private.
	hermits := cave methods.
	self removeCategory: 'private'; removeCategory: 'public'.
	Private:= (self newNamed: 'private') privacy: true; yourself.
	Public := (self newNamed: 'public') privacy: false; yourself.
	Table at: Public name put: Public; at: Private name put: Private.
	"N.B. private category now changed"
	cave := self private.
	hermits do: [:hermit | cave addMethodSilently: hermit]!

uninitialize
	"Private - Uninitialize the receiver as it is about to be removed from the system."

	Public := Private := nil! !
!Tools.MethodPrivacyCategory class categoriesFor: #initialize!initializing!private! !
!Tools.MethodPrivacyCategory class categoriesFor: #uninitialize!class hierarchy-removing!private! !

