"Filed out from Dolphin Smalltalk 7"!

Tools.KeyedAspect subclass: #'Tools.KeyedAspectBatch'
	instanceVariableNames: 'batchSize keys accessorClass'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.KeyedAspectBatch guid: (Core.GUID fromString: '{0f7d3efe-6f95-4de3-a5e1-2ec7a86eb8b2}')!
Tools.KeyedAspectBatch comment: 'Part of the PublishedAspectorInspector framework.<KeyedAspectBatch> instances are used to describe a group of <KeyedAspects> of a keyed collection. Batching the keyed aspects up in this way via a <KeyedAspectBatchAccessor> allows the PAI to only display a certain number of elements at a time. This can substantially improve performance when displaying large (or slow to access) collections.'!
!Tools.KeyedAspectBatch categoriesForClass!Attribute-Definition! !
!Tools.KeyedAspectBatch methodsFor!

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
!Tools.KeyedAspectBatch categoriesFor: #accessorClass!constants!public! !
!Tools.KeyedAspectBatch categoriesFor: #batchSize!accessing!public! !
!Tools.KeyedAspectBatch categoriesFor: #keys!accessing!public! !
!Tools.KeyedAspectBatch categoriesFor: #readFrom:!public! !
!Tools.KeyedAspectBatch categoriesFor: #setKeys:batchSize:accessorClass:!private! !

!Tools.KeyedAspectBatch class methodsFor!

keys: aSequencedReadableCollection startingAt: startInteger batchSize: sizeInteger accessorClass: aClass 
	"Answer an instance of the receiver created with aKey"

	^(super key: startInteger)
		setKeys: aSequencedReadableCollection
			batchSize: sizeInteger
			accessorClass: aClass;
		yourself! !
!Tools.KeyedAspectBatch class categoriesFor: #keys:startingAt:batchSize:accessorClass:!public! !

