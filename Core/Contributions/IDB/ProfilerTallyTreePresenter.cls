"Filed out from Dolphin Smalltalk 7"!

ProfilerTreesPresenter subclass: #ProfilerTallyTreePresenter
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
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
!ProfilerTallyTreePresenter categoriesFor: #total!accessing!public! !
!ProfilerTallyTreePresenter categoriesFor: #treeValueFor:!accessing!public! !

