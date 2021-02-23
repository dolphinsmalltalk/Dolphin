"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTest subclass: #'Tools.Tests.LagoonTests'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.Tests.LagoonTests guid: (Core.GUID fromString: '{1d062465-a28b-438e-882d-da296eb78bfa}')!
Tools.Tests.LagoonTests comment: ''!
!Tools.Tests.LagoonTests categoriesForClass!Unclassified! !
!Tools.Tests.LagoonTests methodsFor!

nopMethod!

testExternalStructureAfterTemplateRemoval
	"Test the behavior of ExternalStructure after the removal of the ability to instantiate templates during image stripping (specifically its ability to handle canUnderstand:)
	Regression test for #1095"

	| externalStructureMethodDict externalStructureClassMethodDict basicImageStripperMethodDict |
	"Cache current and instantiate copy methodDictionaries to enable partial run of image stripper without destroying the system"
	externalStructureMethodDict := External.Structure methodDictionary copy.
	externalStructureClassMethodDict := External.Structure class methodDictionary copy.
	basicImageStripperMethodDict := Smalltalk.BasicImageStripper methodDictionary copy.
	
	[External.Structure
		methodDictionary: externalStructureMethodDict copy;
		flushMethodCache.
	External.Structure class
		methodDictionary: externalStructureClassMethodDict copy;
		flushMethodCache.
	Smalltalk.BasicImageStripper
		methodDictionary: (basicImageStripperMethodDict copy
					at: #uncheckedRemoveClass: put: ##(self) >> #nopMethod;
					yourself);
		flushMethodCache.	"We don't actually want to remove classes"
	Smalltalk.ImageStripper newForTests compileExternalStructuresNow: {External.Structure}.
	self assert: External.Structure template isNil.
	self shouldnt: [External.Structure canUnderstand: #anything] raise: MessageNotUnderstood.
	self assert: (External.Structure canUnderstand: #value).
	self deny: (External.Structure canUnderstand: #vAlUe)]
			ensure: 
				[External.Structure
					methodDictionary: externalStructureMethodDict;
					flushMethodCache.
				External.Structure class
					methodDictionary: externalStructureClassMethodDict;
					flushMethodCache.
				Smalltalk.BasicImageStripper
					methodDictionary: basicImageStripperMethodDict;
					flushMethodCache].

	"Ensure things are back to normal"
	self assert: External.Structure template notNil! !
!Tools.Tests.LagoonTests categoriesFor: #nopMethod!helpers!private! !
!Tools.Tests.LagoonTests categoriesFor: #testExternalStructureAfterTemplateRemoval!public!unit tests! !

