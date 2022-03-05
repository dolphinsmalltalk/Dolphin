"Filed out from Dolphin Smalltalk"!

DolphinTest subclass: #LagoonTests
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
LagoonTests guid: (GUID fromString: '{1d062465-a28b-438e-882d-da296eb78bfa}')!
LagoonTests comment: ''!
!LagoonTests categoriesForClass!Unclassified! !
!LagoonTests methodsFor!

nopMethod!

testExternalStructureAfterTemplateRemoval

	"Test the behavior of ExternalStructure after the removal of the ability to instantiate templates during image stripping (specifically its ability to handle canUnderstand:)
	Regression test for #1095"

	| externalStructureMethodDict externalStructureClassMethodDict basicImageStripperMethodDict  |

	"Cache current and instantiate copy methodDictionaries to enable partial run of image stripper without destroying the system"
	externalStructureMethodDict := ExternalStructure methodDictionary copy.
	externalStructureClassMethodDict := ExternalStructure class methodDictionary copy.
	basicImageStripperMethodDict := BasicImageStripper methodDictionary copy.

	[ExternalStructure
		methodDictionary: externalStructureMethodDict copy;
		flushMethodCache.
	ExternalStructure class 
		methodDictionary: externalStructureClassMethodDict copy;
		flushMethodCache.
	BasicImageStripper 
		methodDictionary: 
			(basicImageStripperMethodDict copy
				at: #uncheckedRemoveClass: put: (##(self)>>#nopMethod); "We don't actually want to remove classes"
				yourself);
		flushMethodCache.

	ImageStripper newForTests compileExternalStructuresNow: {ExternalStructure}.

	self assert: ExternalStructure template isNil.
	self shouldnt: [ExternalStructure canUnderstand: #anything] raise: MessageNotUnderstood.
	self assert: (ExternalStructure canUnderstand: #value).
	self deny: (ExternalStructure canUnderstand: #vAlUe)] ensure: 
		[ExternalStructure methodDictionary: externalStructureMethodDict; flushMethodCache.
		ExternalStructure class methodDictionary: externalStructureClassMethodDict; flushMethodCache.
		BasicImageStripper methodDictionary: basicImageStripperMethodDict; flushMethodCache].

	"Ensure things are back to normal"
	self assert: ExternalStructure template notNil! !
!LagoonTests categoriesForMethods!
nopMethod!helpers!private! !
testExternalStructureAfterTemplateRemoval!public!unit tests! !
!

