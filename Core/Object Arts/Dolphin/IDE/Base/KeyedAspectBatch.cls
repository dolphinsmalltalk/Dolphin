"Filed out from Dolphin Smalltalk"!

KeyedAspect subclass: #KeyedAspectBatch
	instanceVariableNames: 'batchSize keys accessorClass'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
KeyedAspectBatch guid: (GUID fromString: '{0f7d3efe-6f95-4de3-a5e1-2ec7a86eb8b2}')!
KeyedAspectBatch comment: 'Part of the PublishedAspectorInspector framework.<KeyedAspectBatch> instances are used to describe a group of <KeyedAspects> of a keyed collection. Batching the keyed aspects up in this way via a <KeyedAspectBatchAccessor> allows the PAI to only display a certain number of elements at a time. This can substantially improve performance when displaying large (or slow to access) collections.'!
!KeyedAspectBatch categoriesForClass!Attribute-Definition! !
!KeyedAspectBatch methodsFor!

accessorClass
	^accessorClass!

batchSize
	"Answers the batch size of the receiver, i.e. the number of keyed elements to return at a time"

	^batchSize!

keys
	^keys!

readFrom: anObject

	^'next ', batchSize printString, ' items'!

setKeys: aSequencedReadableCollection batchSize: anInteger accessorClass: aClass 
	keys := aSequencedReadableCollection.
	batchSize := anInteger.
	accessorClass := aClass! !
!KeyedAspectBatch categoriesForMethods!
accessorClass!constants!public! !
batchSize!accessing!public! !
keys!accessing!public! !
readFrom:!public! !
setKeys:batchSize:accessorClass:!private! !
!

!KeyedAspectBatch class methodsFor!

keys: aSequencedReadableCollection startingAt: startInteger batchSize: sizeInteger accessorClass: aClass 
	"Answer an instance of the receiver created with aKey"

	^(super key: startInteger)
		setKeys: aSequencedReadableCollection
			batchSize: sizeInteger
			accessorClass: aClass;
		yourself! !
!KeyedAspectBatch class categoriesForMethods!
keys:startingAt:batchSize:accessorClass:!public! !
!

