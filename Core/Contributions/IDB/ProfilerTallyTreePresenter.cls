"Filed out from Dolphin Smalltalk X6"!

ProfilerTreesPresenter subclass: #ProfilerTallyTreePresenter
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ProfilerTallyTreePresenter guid: (GUID fromString: '{425D0EB9-542E-11D3-998B-D5CA2C3C1D61}')!
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

