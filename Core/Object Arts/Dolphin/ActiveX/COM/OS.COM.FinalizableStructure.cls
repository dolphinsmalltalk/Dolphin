"Filed out from Dolphin Smalltalk 7"!

OS.COM.OLEStructure subclass: #'OS.COM.FinalizableStructure'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.COM.FinalizableStructure guid: (Core.GUID fromString: '{87b4c5b9-026e-11d3-9fd7-00a0cc3e4a32}')!
OS.COM.FinalizableStructure isNonInstantiable: true!
OS.COM.FinalizableStructure comment: ''!
!OS.COM.FinalizableStructure categoriesForClass!External-Data-Structured-COM! !
!OS.COM.FinalizableStructure methodsFor!

initialize
	"Private - Initialize the receiver which is an internal [value] buffer.
	These objects are finalizable since they may reference owned external
	resources."

	self beFinalizable!

needsFree
	"Private - Answer whether the receiver requires freeing of any external resources.
	In most cases we don't want to free if this object is a reference to a structure
	embedded in an buffer, since that would damage the buffer.
	i.e. it is considered that 'reference' structs do not own the underlying structure as
	this is what is required, for example, in conjunction with StructureArray."

	^(self isNull or: [self isPointer]) not!

onStartup
	"Private - The system is starting. Modify the state of the receiver to account for the fact
	than any external memory allocated for the receiver during the previous session is no 
	longer accessible."

	self beUnfinalizable.
	self isPointer ifTrue: [
		bytes := nil]! !
!OS.COM.FinalizableStructure categoriesFor: #initialize!initializing!private! !
!OS.COM.FinalizableStructure categoriesFor: #needsFree!private!realizing/unrealizing! !
!OS.COM.FinalizableStructure categoriesFor: #onStartup!event handling!private! !

!OS.COM.FinalizableStructure class methodsFor!

clear: addressOrBytes
	"Free external resources referenced by the structure
	of the receiver's element type at the specified address."

	^self subclassResponsibility!

initialize
	"Private - Initialize the receiver.
	Register with session events to clean up sub-instances on startup.
	
		OLEFinalizableStructure initialize
	"

	SessionManager current 
		when: #sessionStarted send: #onStartup to: self
!

onStartup
	"Private - Notify all the receiver's sub-instances of system startup."

	self primAllSubinstances do: [:i | i onStartup].!

uninitialize
	SessionManager current removeEventsTriggeredFor: self! !
!OS.COM.FinalizableStructure class categoriesFor: #clear:!public!realizing/unrealizing! !
!OS.COM.FinalizableStructure class categoriesFor: #initialize!development!initializing!private! !
!OS.COM.FinalizableStructure class categoriesFor: #onStartup!event handling!private! !
!OS.COM.FinalizableStructure class categoriesFor: #uninitialize!class hierarchy-removing!private! !

