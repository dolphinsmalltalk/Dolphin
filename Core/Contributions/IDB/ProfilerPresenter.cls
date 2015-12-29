"Filed out from Dolphin Smalltalk X6"!

Presenter subclass: #ProfilerPresenter
	instanceVariableNames: 'percentageFilter dolphinFilter selectorFilter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ProfilerPresenter guid: (GUID fromString: '{425D0EB3-542E-11D3-998B-D5CA2C3C1D61}')!
ProfilerPresenter comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!ProfilerPresenter categoriesForClass!IDB Goodies! !
!ProfilerPresenter methodsFor!

filter: anObject 
	"Answer true if all the filters agree that anObject should be displayed"

	^(percentageFilter value: anObject) 
		and: [(dolphinFilter value: anObject) and: [selectorFilter value: anObject]]!

filterChanged
	"One of the filters has changed so update the models"

	self update!

filterDolphin: aBoolean 
	"Answers true if the item is not in the Dolphin package (so it should be displayed)"

	self subclassResponsibility!

filterPercentage: aFloat 
	"Set the filterBlock to answer true if any of the fileds ar > aFloat%"

	self subclassResponsibility!

filterSelector: aCompiledCodeOrNil 
	"Answer true if this node shold be displayed for the selector filter"

	self subclassResponsibility!

initialize
	"Initialize the reciver"

	super initialize.
	percentageFilter := [:o | true].
	dolphinFilter := [:o | true].
	selectorFilter := [:o | true].
	^self!

model: aProfilerSampleSet 
	"Set the model for the receiver"

	super model: aProfilerSampleSet.
	self filterChanged!

parseContext
	^self selectedMethod ifNotNil: [:method | method methodClass]! !
!ProfilerPresenter categoriesFor: #filter:!filtering!public! !
!ProfilerPresenter categoriesFor: #filterChanged!filtering!public! !
!ProfilerPresenter categoriesFor: #filterDolphin:!filtering!public! !
!ProfilerPresenter categoriesFor: #filterPercentage:!filtering!public! !
!ProfilerPresenter categoriesFor: #filterSelector:!filtering!public! !
!ProfilerPresenter categoriesFor: #initialize!initializing!public! !
!ProfilerPresenter categoriesFor: #model:!accessing!public! !
!ProfilerPresenter categoriesFor: #parseContext!public! !

!ProfilerPresenter class methodsFor!

defaultModel
	"Answer a default model to be used when the presenter is initialized"

	^ProfilerSampleSet name: 'None'! !
!ProfilerPresenter class categoriesFor: #defaultModel!models!public! !

