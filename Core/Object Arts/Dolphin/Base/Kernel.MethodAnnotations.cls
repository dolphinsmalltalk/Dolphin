"Filed out from Dolphin Smalltalk"!

Core.SequenceableCollection variableSubclass: #'Kernel.MethodAnnotations'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.MethodAnnotations guid: (Core.GUID fromString: '{0796b2f8-83f3-4c8e-a8b8-3002ef3189f1}')!
Kernel.MethodAnnotations comment: ''!
!Kernel.MethodAnnotations categoriesForClass!Kernel-Objects! !
!Kernel.MethodAnnotations methodsFor!

at: anInteger
	"Answer the <Message> element of the receiver at the specified <integer> index."

	| offset |
	offset := anInteger * 2.
	^Message selector: (self basicAt: offset - 1) arguments: (self basicAt: offset)!

at: anInteger put: aMessage
	"MethodAnnotations are immutable."

	^self shouldNotImplement!

basicNextIdentityIndexOf: anObject from: startInteger to: stopInteger
	<primitive: 59>
	startInteger to: stopInteger do: [:i | (self at: i) == anObject ifTrue: [^i]].
	^0!

copyingClass
	^Array!

do: aMonadicValuable
	"Evaluate the <monadicValuable> argument for each of the annotation <Message>s in the receiver."

	1 to: self basicSize
		by: 2
		do: [:i | aMonadicValuable value: (Message selector: (self basicAt: i) arguments: (self basicAt: i + 1))]!

environment
	"Answer the value of the #namespace: annotation in the receiver, or nil if not present."

	| index |
	^(index := self
				basicNextIdentityIndexOf: #namespace:
				from: 1
				to: self basicSize) == 0
		ifFalse: [(self basicAt: index + 1) at: 1]!

first
	"Answer the first annotation <Message> in the receiver. The receiver should not be empty, but raise an error if it is."

	^Message selector: (self basicAt: 1) arguments: (self basicAt: 2)!

nextIdentityIndexOf: anObject from: startInteger to: stopInteger
	<primitive: 59>
	startInteger to: stopInteger do: [:i | (self at: i) == anObject ifTrue: [^i]].
	^0!

printOn: aStream
	self basicPrintOn: aStream.
	aStream nextPut: $(.
	1 to: self basicSize
		by: 2
		do: 
			[:i |
			| selector keywords args |
			i > 1 ifTrue: [aStream space].
			selector := self basicAt: i.
			aStream nextPut: $<.
			keywords := $: split: selector.
			args := self basicAt: i + 1.
			keywords size = 1
				ifTrue: [aStream nextPutAll: selector]
				ifFalse: 
					[1 to: keywords size - 1
						do: 
							[:k |
							k > 1 ifTrue: [aStream space].
							aStream
								nextPutAll: (keywords at: k);
								nextPut: $:;
								space;
								print: (args at: k)]].
			aStream nextPut: $>].
	aStream nextPut: $)!

refersTo: anObject asLiteralOf: aCompiledCode
	"Private - Answer whether the receiver is a reference to the literal argument."

	1 to: self basicSize
		do: [:i | ((self basicAt: i) refersTo: anObject asLiteralOf: aCompiledCode) ifTrue: [^true]].
	^false!

uncheckedFrom: startInteger to: stopInteger keysAndValuesDo: aDyadicValuable
	"Private - Evaluate the <dyadicValuable> argument for each element of the receiver in the
	specified inclusive range, with the element and its index as respectively the second and
	first arguments. No bounds checks need be performed since the caller has established that
	the start and stop indices are in bounds."

	startInteger to: stopInteger
		do: 
			[:i |
			| offset |
			offset := i * 2.
			aDyadicValuable value: i
				value: (Message selector: (self basicAt: offset - 1) arguments: (self basicAt: offset))]! !
!Kernel.MethodAnnotations categoriesFor: #at:!enumerating!public! !
!Kernel.MethodAnnotations categoriesFor: #at:put:!accessing!public! !
!Kernel.MethodAnnotations categoriesFor: #basicNextIdentityIndexOf:from:to:!private!searching! !
!Kernel.MethodAnnotations categoriesFor: #copyingClass!copying!private! !
!Kernel.MethodAnnotations categoriesFor: #do:!enumerating!public! !
!Kernel.MethodAnnotations categoriesFor: #environment!public!searching! !
!Kernel.MethodAnnotations categoriesFor: #first!enumerating!public! !
!Kernel.MethodAnnotations categoriesFor: #nextIdentityIndexOf:from:to:!private!searching! !
!Kernel.MethodAnnotations categoriesFor: #printOn:!printing!public! !
!Kernel.MethodAnnotations categoriesFor: #refersTo:asLiteralOf:!private!testing! !
!Kernel.MethodAnnotations categoriesFor: #uncheckedFrom:to:keysAndValuesDo:!enumerating!private! !

!Kernel.MethodAnnotations class methodsFor!

fromPairs: aSequencedReadableCollection
	| count instance |
	count := aSequencedReadableCollection size.
	instance := self new: count * 2.
	1 to: count
		do: 
			[:i |
			| pair |
			pair := aSequencedReadableCollection at: i.
			instance
				basicAt: i * 2 - 1 put: pair first;
				basicAt: i * 2 put: pair second].
	instance isImmutable: true.
	^instance!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	VMLibrary default registryAt: self name put: self.
	VMLibrary default registryAtIndex: 152 put: (self fromPairs: {{#namespace:. {Smalltalk}}})!

uninitialize
	"Private - Tidy up the receiver in preparation for removal from the system."

	VMLibrary default
		registryAt: self name put: nil;
		registryAtIndex: 152 put: nil! !
!Kernel.MethodAnnotations class categoriesFor: #fromPairs:!instance creation!public! !
!Kernel.MethodAnnotations class categoriesFor: #initialize!development!initializing!private! !
!Kernel.MethodAnnotations class categoriesFor: #uninitialize!class hierarchy-removing!private! !

