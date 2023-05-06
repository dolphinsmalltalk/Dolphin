"Filed out from Dolphin Smalltalk"!

Core.SequenceableCollection
	variableSubclass: #'Kernel.MethodAnnotations'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.MethodAnnotations guid: (Core.GUID fromString: '{0796b2f8-83f3-4c8e-a8b8-3002ef3189f1}')!
Kernel.MethodAnnotations comment: ''!
!Kernel.MethodAnnotations categoriesForClass!Kernel-Objects! !
!Kernel.MethodAnnotations methodsFor!

= anObject
	"Answer whether the receiver and the <Object> argument are considered equivalent - that is the argument is an equivalent <MethodAnnotations>"

	| size |
	self == anObject ifTrue: [^true].
	self class == anObject class ifFalse: [^false].
	size := self basicSize.
	size = anObject basicSize ifFalse: [^false].
	1 to: size do: [:i | (self basicAt: i) = (anObject basicAt: i) ifFalse: [^false]].
	^true!

add: newElement
	"MethodAnnotations are not extensible."

	^self shouldNotImplement!

at: anInteger
	"Answer the <Message> element of the receiver at the specified <integer> index."

	| offset |
	offset := anInteger * 2.
	^Message selector: (self basicAt: offset - 1) arguments: (self basicAt: offset)!

at: anInteger put: aMessage
	"MethodAnnotations are immutable."

	^self shouldNotImplement!

copyingClass
	^Array!

displayOn: aStream
	| startNext |
	startNext := '<'.
	1 to: self basicSize
		by: 2
		do: 
			[:i |
			| selector keywords |
			aStream nextPutAll: startNext.
			keywords := $: split: (selector := self basicAt: i).
			keywords size == 1
				ifTrue: [aStream nextPutAll: selector]
				ifFalse: 
					[| args |
					args := self basicAt: i + 1.
					1 to: keywords size - 1
						do: 
							[:k |
							k > 1 ifTrue: [aStream space].
							aStream
								nextPutAll: (keywords at: k);
								nextPutAll: ': ';
								print: (args at: k)]].
			aStream nextPut: $>.
			startNext := ' <']!

do: aMonadicValuable
	"Evaluate the <monadicValuable> argument for each of the annotation <Message>s in the receiver."

	1 to: self basicSize
		by: 2
		do: [:i | aMonadicValuable value: (Message selector: (self basicAt: i) arguments: (self basicAt: i + 1))]!

environment
	"Answer the value of the #namespace: annotation in the receiver, or nil if not present."

	| index |
	^(index := self
				basicIdentityIndexOf: #namespace:
				from: 1
				to: self basicSize) == 0
		ifFalse: [(self basicAt: index + 1) at: 1]!

first
	"Answer the first annotation <Message> in the receiver. The receiver should not be empty, but raise an error if it is."

	^Message selector: (self basicAt: 1) arguments: (self basicAt: 2)!

includesSelector: aSymbol
	"Answer whether any of the annotations in the receiver have the selector named by the <Symbol> argument."

	^(self
		basicIdentityIndexOf: aSymbol
		from: 1
		to: self basicSize) odd!

printOn: aStream
	aStream
		basicPrint: self;
		nextPut: $(;
		display: self;
		nextPut: $)!

refersTo: anObject asLiteralOf: aCompiledCode
	"Private - Answer whether the receiver is a reference to the literal argument."

	1 to: self basicSize
		do: [:i | ((self basicAt: i) refersTo: anObject asLiteralOf: aCompiledCode) ifTrue: [^true]].
	^false!

selectors
	"Answer an <Set> of <Symbol>, being the annotation selectors in this collection."

	| count selectors |
	count := self size.
	selectors := Set new: count.
	1 to: (count bitShift: 1)
		by: 2
		do: [:i | selectors add: (self basicAt: i)].
	^selectors!

size
	^self basicSize bitShift: -1!

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
				value: (Message selector: (self basicAt: offset - 1) arguments: (self basicAt: offset))]!

withSelector: aSymbol
	"Answer a <sequencedReadableCollection> of the <Message>s in the receiver with the selector specified by the <Symbol> argument."

	| stream |
	stream := WriteStream on: {}.
	self withSelector: aSymbol do: [:args | stream nextPut: (Message selector: aSymbol arguments: args)].
	^stream grabContents!

withSelector: aSymbol do: aMonadicValuable
	"Evaluate the <monadicValuable> second argument for each of the <Message>s in the receiver with the selector specified by the <Symbol> first argument."

	| i stop |
	stop := self basicSize.
	i := 0.
	
	[(i := self
				basicIdentityIndexOf: aSymbol
				from: i + 1
				to: stop) even
		ifFalse: [aMonadicValuable value: (self basicAt: i + 1)].
	i == 0]
			whileFalse! !
!Kernel.MethodAnnotations categoriesForMethods!
=!comparing!public! !
add:!adding!public! !
at:!enumerating!public! !
at:put:!accessing!public! !
copyingClass!copying!private! !
displayOn:!printing!public! !
do:!enumerating!public! !
environment!public!searching! !
first!enumerating!public! !
includesSelector:!public!searching! !
printOn:!printing!public! !
refersTo:asLiteralOf:!private!testing! !
selectors!accessing!public! !
size!accessing!public! !
uncheckedFrom:to:keysAndValuesDo:!enumerating!private! !
withSelector:!enumerating!public! !
withSelector:do:!enumerating!public! !
!

!Kernel.MethodAnnotations class methodsFor!

fromPairs: aSequencedReadableCollection
	| count instance |
	instance := self new: (count := aSequencedReadableCollection size) * 2.
	1 to: count
		do: 
			[:i |
			| pair |
			pair := aSequencedReadableCollection at: i.
			instance
				basicAt: i * 2 - 1 put: pair first;
				basicAt: i * 2 put: pair second].
	^instance
		beReadOnlyObject;
		yourself!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	VM registryAt: self name put: self.
	VM registryAtIndex: 152 put: (self fromPairs: {{#namespace:. {Smalltalk}}})!

uninitialize
	"Private - Tidy up the receiver in preparation for removal from the system."

	VM
		registryAt: self name put: nil;
		registryAtIndex: 152 put: nil! !
!Kernel.MethodAnnotations class categoriesForMethods!
fromPairs:!instance creation!public! !
initialize!development!initializing!private! !
uninitialize!class hierarchy-removing!private! !
!

