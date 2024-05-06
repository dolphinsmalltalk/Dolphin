"Filed out from Dolphin Smalltalk"!

ProfilerTreesPresenter subclass: #ProfilerTallyTreePresenter
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ProfilerTallyTreePresenter guid: (GUID fromString: '{425d0eb9-542e-11d3-998b-d5ca2c3c1d61}')!

ProfilerTallyTreePresenter comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!

!ProfilerTallyTreePresenter categoriesForClass!IDB Goodies! !

!ProfilerTallyTreePresenter methodsFor!

total
	"Answer the total number of items for this type of tree"

	^self model samplesSize!

treeValueFor: aProfilerTreeNode 
	"Answers the value of the field for the receivers type of tree"

	^aProfilerTreeNode tally! !

!ProfilerTallyTreePresenter categoriesForMethods!
total!accessing!public! !
treeValueFor:!accessing!public! !
!

