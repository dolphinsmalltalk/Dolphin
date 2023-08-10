"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Kernel.STxFiler'
	instanceVariableNames: 'stream context policy'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.STxFiler guid: (Core.GUID fromString: '{87b4c4c1-026e-11d3-9fd7-00a0cc3e4a32}')!
Kernel.STxFiler isNonInstantiable: true!
Kernel.STxFiler comment: ''!
!Kernel.STxFiler categoriesForClass!System-Binary storage! !
!Kernel.STxFiler methodsFor!

atEnd
	"Answer true if the receiver is positioned at end of its stream."

	^stream atEnd

!

context
	"Answers the context for objects read by the receiver"

	^context!

context: anObject
	"Sets the context for objects read by the receiver to anObject. This may be,
	for example, the parent window of a window being read."

	context := anObject!

initialize
	self reset.
	^self!

initializeObjectMap
	^self subclassResponsibility!

policy
	^policy!

position: anInteger
	"Position the receiver's stream to anInteger, read/write a header at this
	place and prepare it for a new input or output session."

	stream position: anInteger.
	self reset.!

register: anObject 
	"Register an object has having been seen before in the STB stream. Answer the unique object reference."

	^self subclassResponsibility!

registerAllClasses: anArray
	anArray do: [:each | self register: each]!

reset
	"Private - Reset the instance."

	self subclassResponsibility!

saveBoolean: aBoolean 
	policy saveBoolean: aBoolean!

setRefOffset: anInteger
	^self subclassResponsibility!

stream
	"Answer the stream to which the receiver is attached."

	^stream!

version
	"Answer the format version of the STB stream."

	^policy version! !
!Kernel.STxFiler categoriesForMethods!
atEnd!public!testing! !
context!accessing!public! !
context:!accessing!public! !
initialize!initializing!private! !
initializeObjectMap!initializing!private! !
policy!accessing!public! !
position:!operations!public! !
register:!helpers!public! !
registerAllClasses:!initializing!private! !
reset!initializing!private! !
saveBoolean:!public! !
setRefOffset:!initializing!private! !
stream!accessing!public! !
version!accessing!public! !
!

!Kernel.STxFiler class methodsFor!

formatName
	"Answer the format name."

	^self policyClass formatName!

on: aStream
	"Answer a new instance attached to the binary stream aStream."

	^self subclassResponsibility!

policyClass
	^self subclassResponsibility! !
!Kernel.STxFiler class categoriesForMethods!
formatName!constants!public! !
on:!instance creation!public! !
policyClass!constants!private! !
!

