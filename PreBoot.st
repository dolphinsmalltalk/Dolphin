!CompiledCode class methodsFor!

packByteCodes: anArray
	| bytes codes |
	bytes := anArray asByteArray.
	codes := (bytes size == 4
				ifTrue: [bytes sdwordAtOffset: 0]
				ifFalse: 
					[| packed |
					packed := 0.
					bytes reverseDo: [:each | packed := (packed bitShift: 8) + each].
					packed])
					bitShift: -1.
	^codes! !


