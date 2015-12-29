"Filed out from Dolphin Smalltalk X6"!

IndexedInstVarBatchAccessor subclass: #SetBatchAspectAccessor
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SetBatchAspectAccessor guid: (GUID fromString: '{CACFD817-4DCB-46BE-BBA9-BCB1585438F2}')!
SetBatchAspectAccessor comment: ''!
!SetBatchAspectAccessor categoriesForClass!Unclassified! !
!SetBatchAspectAccessor methodsFor!

aspectClass
	^BasicKeyedAspect!

getBatchAccessors
	| accessors subj count size i |
	count := self batchSize.
	accessors := OrderedCollection new: count.
	subj := self subject.
	i := self startKey.
	size := subj basicSize.
	[count > 0 and: [i <= size]] whileTrue: 
			[(subj basicAt: i) 
				ifNotNil: 
					[:item | 
					count := count - 1.
					accessors add: ((item newAspect: i class: self aspectClass) accessorFor: self subject)].
			i := i + 1].
	(self nextBatch: i) ifNotNil: [:nextBatch | accessors add: nextBatch].
	^accessors! !
!SetBatchAspectAccessor categoriesFor: #aspectClass!public! !
!SetBatchAspectAccessor categoriesFor: #getBatchAccessors!public! !

