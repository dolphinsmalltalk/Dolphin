"Filed out from Dolphin Smalltalk 7"!

Core.Object variableSubclass: #'Kernel.MethodAnnotations'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.MethodAnnotations guid: (Core.GUID fromString: '{0796b2f8-83f3-4c8e-a8b8-3002ef3189f1}')!
Kernel.MethodAnnotations comment: ''!
!Kernel.MethodAnnotations categoriesForClass!Kernel-Objects! !
!Kernel.MethodAnnotations methodsFor!

environment
	"Answer the value of the #namespace: annotation in the receiver, or nil if not present."

	| index |
	^(index := self
				nextIdentityIndexOf: #namespace:
				from: 1
				to: self size) == 0
		ifFalse: [(self at: index + 1) at: 1]!

nextIdentityIndexOf: anObject from: startInteger to: stopInteger
	<primitive: 59>
	startInteger to: stopInteger do: [:i | (self at: i) == anObject ifTrue: [^i]].
	^0!

printOn: aStream
	super printOn: aStream.
	aStream nextPut: $(.
	1 to: self size
		by: 2
		do: 
			[:i |
			| selector keywords args |
			i > 1 ifTrue: [aStream space].
			selector := self at: i.
			aStream nextPut: $<.
			keywords := $: split: selector.
			args := self at: i + 1.
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

	1 to: self size
		do: [:i | ((self at: i) refersTo: anObject asLiteralOf: aCompiledCode) ifTrue: [^true]].
	^false! !
!Kernel.MethodAnnotations categoriesFor: #environment!public!searching! !
!Kernel.MethodAnnotations categoriesFor: #nextIdentityIndexOf:from:to:!private!searching! !
!Kernel.MethodAnnotations categoriesFor: #printOn:!printing!public! !
!Kernel.MethodAnnotations categoriesFor: #refersTo:asLiteralOf:!private!testing! !

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
				at: i * 2 - 1 put: pair first;
				at: i * 2 put: pair second].
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

