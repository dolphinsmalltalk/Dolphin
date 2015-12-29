"Filed out from Dolphin Smalltalk X6"!

ProfilerTreesPresenter subclass: #ProfilerTimeTreePresenter
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ProfilerTimeTreePresenter guid: (GUID fromString: '{425D0EBA-542E-11D3-998B-D5CA2C3C1D61}')!
ProfilerTimeTreePresenter comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!ProfilerTimeTreePresenter categoriesForClass!IDB Goodies! !
!ProfilerTimeTreePresenter methodsFor!

total
	"Answer the total number of items for this type of tree"

	^self model samplesElapsedTime!

treeValueFor: aProfilerTreeNode 
	"Answers the value of the field for the receivers type of tree"

	^aProfilerTreeNode time! !
!ProfilerTimeTreePresenter categoriesFor: #total!accessing!public! !
!ProfilerTimeTreePresenter categoriesFor: #treeValueFor:!accessing!public! !

