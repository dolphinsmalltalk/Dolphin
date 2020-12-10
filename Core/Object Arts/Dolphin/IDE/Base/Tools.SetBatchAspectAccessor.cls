"Filed out from Dolphin Smalltalk 7"!

Tools.IndexedInstVarBatchAccessor subclass: #'Tools.SetBatchAspectAccessor'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.SetBatchAspectAccessor guid: (Core.GUID fromString: '{cacfd817-4dcb-46be-bba9-bcb1585438f2}')!
Tools.SetBatchAspectAccessor comment: ''!
!Tools.SetBatchAspectAccessor categoriesForClass!MVP-Models! !
!Tools.SetBatchAspectAccessor methodsFor!

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
!Tools.SetBatchAspectAccessor categoriesFor: #aspectClass!public! !
!Tools.SetBatchAspectAccessor categoriesFor: #getBatchAccessors!public! !

