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
	^instance! !
	
VMLibrary default registryAtIndex: 152 put: (MethodAnnotations fromPairs: {{#namespace:. {Smalltalk}}})!
