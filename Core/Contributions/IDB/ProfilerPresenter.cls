"Filed out from Dolphin Smalltalk 7"!

Presenter subclass: #ProfilerPresenter
	instanceVariableNames: 'percentageFilter dolphinFilter selectorFilter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ProfilerPresenter guid: (GUID fromString: '{425d0eb3-542e-11d3-998b-d5ca2c3c1d61}')!
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

