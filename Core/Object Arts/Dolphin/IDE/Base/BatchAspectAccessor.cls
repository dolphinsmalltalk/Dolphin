"Filed out from Dolphin Smalltalk"!

AspectAccessor subclass: #BatchAspectAccessor
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

BatchAspectAccessor guid: (GUID fromString: '{3a00a038-5f65-4669-9966-cbdf3d444a7e}')!

BatchAspectAccessor isAbstract: true!

BatchAspectAccessor comment: ''!

!BatchAspectAccessor categoriesForClass!MVP-Models! !

!BatchAspectAccessor methodsFor!

aspectClass
	^self subclassResponsibility!

batchSize
	^self aspectDescriptor batchSize!

displayOn: aStream 
	"Append the receiver to aStream in a format that a user would want to see"

	self batchSize > 1 
		ifTrue: [aStream display: ('next <1d> items' expandMacrosWith: self batchSize)]
		ifFalse: [aStream display: 'next item']!

keys
	^self aspectDescriptor keys!

nextBatch: anInteger 
	"Private - Answer the <BatchAspectAccessor> that will follow the receiver or nil if there is none"

	^(self subjectIncludesKey: anInteger) 
		ifTrue: 
			[self class 
				subject: self subject
				keys: self keys
				startingAt: anInteger
				batchSize: self batchSize]!

selectIn: anInspector
	anInspector expandBatchAccessor: self!

startKey
	"Private - Answers the index of the key used to access the first element of the subject that
	the receiver is to treat as a value"

	^self aspectDescriptor key!

subjectIncludesKey: nextKey
	^nextKey <= self keys size!

value
	"Answers the <Object> value of the receiver, obtained by
	sending a message to the receiver's subject with the key."

	^nil!

valueIcon
	^self icon! !

!BatchAspectAccessor categoriesForMethods!
aspectClass!accessing!public! !
batchSize!accessing!public! !
displayOn:!displaying!public! !
keys!accessing!public! !
nextBatch:!private! !
selectIn:!event handling!private! !
startKey!accessing!public! !
subjectIncludesKey:!accessing!private! !
value!accessing!public! !
valueIcon!accessing!public! !
!

!BatchAspectAccessor class methodsFor!

aspectBatchClass
	^KeyedAspectBatch!

icon
	"Answers an Icon that can be used to represent this class"

	^##((TextTileIcon text: $… fontName: 'Segoe UI')
		textcolor: Color darkBlue;
		fontStyle: #bold;
		yourself)!

subject: anObject keys: aSequencedReadableCollection startingAt: startInteger batchSize: sizeInteger 
	"Answers an instance of the receiver that is an interface onto a range of
	keyed elements of the subject <Object>, anObject."

	^self subject: anObject
		aspect: (self aspectBatchClass 
				keys: aSequencedReadableCollection
				startingAt: startInteger
				batchSize: sizeInteger
				accessorClass: self)! !

!BatchAspectAccessor class categoriesForMethods!
aspectBatchClass!public! !
icon!constants!public! !
subject:keys:startingAt:batchSize:!instance creation!public! !
!

