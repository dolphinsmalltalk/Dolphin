"Filed out from Dolphin Smalltalk 7"!

COMInterfaceImp subclass: #COMEnumerator
	instanceVariableNames: 'enumClass contents'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
COMEnumerator guid: (GUID fromString: '{e3913c43-9396-11d3-b376-0800460222f0}')!
COMEnumerator comment: 'COMEnumerator is Dolphin''s generic implementation of COM enumerators, i.e. IEnumXXXX. It can enumerate over any sequenceable collection of externally representable objects.

Instance Variables:
	enumClass	<IEnumXXXX>
	contents		<ReadStream>

'!
!COMEnumerator categoriesForClass!COM-Implementations! !
!COMEnumerator methodsFor!

arrayBufferAt: buf length: count
	"Private - Answer a suitable <ExternalArray> wrapping the buffer at <ExternalAddress>,
	buf, of <integer> length, count."

	^StructureArray fromAddress: buf length: count elementClass: enumClass elementClass.
!

Clone: ppEnum 
	"Implement the IEnumXXXX::Clone() interface function, i.e.
	answer a copy of the receiver, via the output IEnumXXXX**
	argument, ppEnum, that enumerates over the same collection
	but which has an independent stream position."

	| iEnum |
	iEnum := self class newEnumerator: enumClass on: contents contents.
	"We must detach the temporary interface to prevent automatic Release()
	of the new EnumRect on finalization of iEnum"
	ppEnum value: iEnum detach.
	^S_OK!

copyElements: buf length: count
	"Private - Copy up to <integer>, count, elements from the receiver's contents
	into the buffer at <ExternalAddress>, buf. Answer the number of elements
	copied."

	| array copied |
	array := self arrayBufferAt: buf length: count.

	copied := 0.
	[copied < count and: [contents atEnd not]] whileTrue: [
		array at: (copied := copied + 1) put: self nextElement].

	^copied!

Next: celt rgelt: rgelt pceltFetched: pceltFetched 
	"Implement the IEnumXXXX::Next() interface function,
	i.e. copy up to the next <integer>, celt, elements from the
	receiver's stream into the buffer at <ExternalAddress>,
	rgelt, answering the number of elements actually copied
	there via the DWORD* output argument, pceltFetched."

	| count |
	pceltFetched yourAddress isNull 
		ifTrue: [celt ~= 1 ifTrue: [^S_FALSE]]
		ifFalse: [pceltFetched value: 0].
	(rgelt isNull or: [contents atEnd]) ifTrue: [^S_FALSE].
	count := self copyElements: rgelt length: celt.
	pceltFetched yourAddress isNull ifFalse: [pceltFetched value: count].
	^S_OK!

nextElement
	"Private - Answer a copy of the next element of the receiver."

	^contents next.!

Reset
	"Implement the IEnumXXXX::Reset() interface function."
	
	contents reset.
	^S_OK!

setEnumClass: class contents: stm
	"Private - Initialize the receiver's instance variables."

	enumClass := class.
	contents := stm.!

Skip: cSkip 
	"Implement the IEnumXXXX::Skip() interface function,
	i.e. skip backwards or forwards over the stream of elements."

	^
	[contents skip: cSkip.
	S_OK] on: BoundsError do: [:e | S_FALSE]!

supportedInterfaces
	"Answer the set of interface classes supported by the receiver.
	This will vary on a per-instance basis."

	^{enumClass}! !
!COMEnumerator categoriesFor: #arrayBufferAt:length:!COM Interfaces-IEnumXXXX!private! !
!COMEnumerator categoriesFor: #Clone:!COM Interfaces-IEnumXXXX!public! !
!COMEnumerator categoriesFor: #copyElements:length:!COM Interfaces-IEnumXXXX!private! !
!COMEnumerator categoriesFor: #Next:rgelt:pceltFetched:!COM Interfaces-IEnumXXXX!public! !
!COMEnumerator categoriesFor: #nextElement!COM Interfaces-IEnumXXXX!private! !
!COMEnumerator categoriesFor: #Reset!COM Interfaces-IEnumXXXX!public! !
!COMEnumerator categoriesFor: #setEnumClass:contents:!accessing!private! !
!COMEnumerator categoriesFor: #Skip:!COM Interfaces-IEnumXXXX!public! !
!COMEnumerator categoriesFor: #supportedInterfaces!constants!public! !

COMEnumerator methodProtocol: #IEnumXXXX attributes: #() selectors: #(#Clone: #Next:rgelt:pceltFetched: #Reset #Skip:)!

!COMEnumerator class methodsFor!

newEnumerator: enumClass on: sequence
	"Answer a new COM interface which is an instance of the <IEnumXXXX> subclass, enumClass,
	onto a new instance of the receiver that enumerates over the contents of the 	<sequencedReadableCollection>, sequence."

	^self newEnumerator: enumClass onStream: sequence readStream!

newEnumerator: enumClass onStream: stream
	"Answer a new COM interface which is an instance of the <IEnumXXXX> subclass, enumClass,
	onto a new instance of the receiver that enumerates over the <gettableStream>, stream."

	^self new
		setEnumClass: enumClass contents: stream;
		queryInterface: enumClass! !
!COMEnumerator class categoriesFor: #newEnumerator:on:!instance creation!public! !
!COMEnumerator class categoriesFor: #newEnumerator:onStream:!instance creation!public! !

