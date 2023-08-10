"Filed out from Dolphin Smalltalk"!

Kernel.STxOutFiler
	subclass: #'Kernel.STBOutFiler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.STBOutFiler guid: (Core.GUID fromString: '{87b4c6e8-026e-11d3-9fd7-00a0cc3e4a32}')!
Kernel.STBOutFiler comment: '<STBOutFiler> is the basic binary filer for serializing a tree of <Object>s to a byte stream.

Instance Variables:
	writeMap		<IdentityDictionary>. Map of <Object>s to their <SmallInteger> id in the binary output stream.
	globals		<IdentityDictionary>. Map of global <Object>s to their associated global name <Symbol>s.
	globalNils		<OrderedCollection> of <Symbol>s being the names of nil value global variables written to the stream.
	proxyOverrides	<IdentityDictionary>. Map of <Object>s to the <STBProxy>s (or special values) output in their place.

'!
!Kernel.STBOutFiler categoriesForClass!System-Binary storage! !
!Kernel.STBOutFiler class methodsFor!

newStream
	^WriteStream on: (ByteArray new: 256)!

policyClass
	"We deliberately reference the latest version to establish a dependency that prevents the latest version policy from being removed at app deployment time if the STBOutFiler is used."

	^STBVersion6Policy! !
!Kernel.STBOutFiler class categoriesForMethods!
newStream!helpers!private! !
policyClass!constants!private! !
!

