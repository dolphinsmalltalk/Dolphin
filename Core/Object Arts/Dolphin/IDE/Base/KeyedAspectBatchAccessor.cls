"Filed out from Dolphin Smalltalk 7"!

BatchAspectAccessor subclass: #KeyedAspectBatchAccessor
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
KeyedAspectBatchAccessor guid: (GUID fromString: '{1be03af7-5614-4c9c-832d-a3c368804e02}')!
KeyedAspectBatchAccessor comment: 'Part of the PublishedAspectorInspector framework. KeyedAspectBatchAccessors are used to give access to a group of <KeyedAspectAccessors> for elements of a keyed collection. Batching the accessors up in this way allows the PAI to only display a certain number of elements at a time. This can substantially improve performance when displaying large (or slow to access) collections.'!
!KeyedAspectBatchAccessor categoriesForClass!MVP-Models! !
!KeyedAspectBatchAccessor methodsFor!

aspectClass
	^KeyedAspect!

getBatchAccessors
	"Answer an <OrderedCollection> of the <AspectAccessors> on the batch of
	<KeyedAspect>s represented by the receiver"

	| accessors absentCookie start end subj keys |
	start := self startKey.
	keys := self keys.
	end := start + self batchSize - 1 min: keys size.
	accessors := OrderedCollection new: end - start + 1.
	absentCookie := Object new.
	subj := self subject.
	keys 
		from: start
		to: end
		do: 
			[:eachKey | 
			| item |
			item := subj at: eachKey ifAbsent: [absentCookie].
			item == absentCookie 
				ifFalse: [accessors add: ((item newAspect: eachKey class: self aspectClass) accessorFor: subj)]].
	(self nextBatch: end+1) ifNotNil: [:nextBatch | accessors add: nextBatch].
	^accessors!

publishedAspects
    	"Answer a <LookupTable> of the <Aspect>s published by the receiver.
	Implementation Note: Prevent the PublishedAspectInspector from displaying any sub-aspects
	for this node (without this one gets a + and can expand it)."

	^LookupTable new! !
!KeyedAspectBatchAccessor categoriesFor: #aspectClass!public! !
!KeyedAspectBatchAccessor categoriesFor: #getBatchAccessors!accessing!public! !
!KeyedAspectBatchAccessor categoriesFor: #publishedAspects!constants!public! !

!KeyedAspectBatchAccessor class methodsFor!

subject: anObject batchSize: sizeInteger
	"Answers an instance of the receiver that is an interface onto a range of
	keyed elements of the subject <Object>, anObject."

	^self 
		subject: anObject
		keys: anObject keys
		startingAt: 1
		batchSize: sizeInteger! !
!KeyedAspectBatchAccessor class categoriesFor: #subject:batchSize:!instance creation!public! !

