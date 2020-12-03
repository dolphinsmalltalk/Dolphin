"Filed out from Dolphin Smalltalk 7"!

Core.WeakArray variableSubclass: #'Core.MourningWeakArray'
	instanceVariableNames: 'pathologist'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.MourningWeakArray guid: (Core.GUID fromString: '{87b4c520-026e-11d3-9fd7-00a0cc3e4a32}')!
Core.MourningWeakArray comment: ''!
!Core.MourningWeakArray categoriesForClass!Collections-Arrayed!Collections-Weak! !
!Core.MourningWeakArray methodsFor!

elementsExpired: anInteger
	"Grieve for the loss of anInteger elements. Only objects marked as weak (see #beWeak) 
	will receive this message, and only then when objects that they are weakly referencing
	have no remaining strong references from objects reachable from the root objects (e.g.
	Smalltalk). By the time this message is received, the weakly referenced
	elements of the receiver will have been lost and replaced by Corpses.
	WeakArrays have no default behaviour for this message, so they forward it to
	their 'pathologist' so that it may perform whatever post mortem actions are necessary - e.g.
	to identify new corpses, and act accordingly (nil them out, or maintain a tally).
	Objects handling this message need to be aware that it is sent asynchronously, so they
	must not modify their contents except in a critical section which protects all access
	to that data from simultaneous access from other processes."

	self pathologist elementsExpired: anInteger of: self!

initialize
	"Private - Initialize the receiver's instance variables."
	
	super initialize.
	pathologist := self class!

pathologist
	"Answer the receiver's 'pathologist'. #elementsExpired: messages sent
	to the receiver by the MemoryManager are forwarded to the pathologist for it to 
	do as it wishes with the receiver's Corpse elements. By default the pathologist 
	is the receiver's class, and the receiver does not expect to receiver any 
	#elementsExpired: messages."

	^pathologist!

pathologist: anObject
	"Set the receiver's 'pathologist' to anObject. See #pathologist."

	pathologist := anObject isNil ifTrue: [self class] ifFalse: [anObject]! !
!Core.MourningWeakArray categoriesFor: #elementsExpired:!finalizing!public! !
!Core.MourningWeakArray categoriesFor: #initialize!initializing!private! !
!Core.MourningWeakArray categoriesFor: #pathologist!accessing!public! !
!Core.MourningWeakArray categoriesFor: #pathologist:!initializing!public! !

!Core.MourningWeakArray class methodsFor!

elementsExpired: anInteger of: aWeakArray
	"Private - At least one of aWeakArray's elements has died, process the Corpses. The default is to
	do nothing but inform dependents. This message is sent to the aWeakArray's pathologist, 
	which is normally the receiver, but only if the receiver is marked as finalizable.
	The reason for making the default pathologist the receiver (i.e. the MourningWeakArray class)
	is to avoid creating a circular references in all MourningWeakArrays."

	aWeakArray trigger: #elementsExpired: with: anInteger!

initialize
	"Initialize the receiver."

	self makeMourner! !
!Core.MourningWeakArray class categoriesFor: #elementsExpired:of:!finalizing!private! !
!Core.MourningWeakArray class categoriesFor: #initialize!development!initializing!public! !

