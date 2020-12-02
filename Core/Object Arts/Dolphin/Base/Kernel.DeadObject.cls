"Filed out from Dolphin Smalltalk 7"!

Object subclass: #DeadObject
	instanceVariableNames: ''
	classVariableNames: 'Current'
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
DeadObject guid: (GUID fromString: '{87b4c479-026e-11d3-9fd7-00a0cc3e4a32}')!
DeadObject comment: 'DeadObject is a singleton whose sole instance is used to mark the slots previously occuppied by dead objects in objects with weak references. This class serves no other purpose than to provide a unique ''Corpse'' object which prints in a recognisable form.

N.B. It is not a good idea to create a new current DeadObject as this may break existing weak collection and/or confuse the VM.

Class Variables:
	Current	<DeadObject>. Singleton instance.


'!
!DeadObject categoriesForClass!System-Support! !
!DeadObject class methodsFor!

current
	"Answer the singleton DeadObject."

	^Current!

initialize
	"Private - Initialize the receiver's class variables."

	Current isNil ifTrue: [Current := self new]!

removeFromSystem
	"Private - Remove the receiver completely from the system.
	This class is critical to system operation and must not be removed."

	^self shouldNotImplement! !
!DeadObject class categoriesFor: #current!accessing!booting!public! !
!DeadObject class categoriesFor: #initialize!booting!development!initializing!private! !
!DeadObject class categoriesFor: #removeFromSystem!class hierarchy-removing!private! !

