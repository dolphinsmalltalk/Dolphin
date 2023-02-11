"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest subclass: #'Tools.Tests.LagoonTests'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.Tests.LagoonTests guid: (Core.GUID fromString: '{1d062465-a28b-438e-882d-da296eb78bfa}')!
Tools.Tests.LagoonTests comment: ''!
!Tools.Tests.LagoonTests methodsFor!

testExternalStructureAfterTemplateRemoval
	"Test the behavior of ExternalStructure after the removal of the ability to instantiate templates during image stripping (specifically its ability to handle canUnderstand:)
	Regression test for #1095"

	| externalStructureMethodDict externalStructureClassMethodDict testSubjectClass |
	"Cache current and instantiate copy methodDictionaries to enable partial run of image stripper without destroying the system"
	externalStructureMethodDict := External.Structure methodDictionary copy.
	externalStructureClassMethodDict := External.Structure class methodDictionary copy.
	
	[External.Structure
		methodDictionary: externalStructureMethodDict copy;
		flushMethodCache.
	External.Structure class
		methodDictionary: externalStructureClassMethodDict copy;
		flushMethodCache.
	testSubjectClass := Smalltalk.ImageStripper newAnonymousSubclass.
	testSubjectClass compile: '_deleteFieldClasses'.
	testSubjectClass
		compile: 'initialize super initialize. deploymentContext := DeploymentContext new initialize'.
	testSubjectClass new _compileExternalStructuresNow: {External.Structure}.
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
					flushMethodCache].

	"Ensure things are back to normal and no damage is done"
	self assert: External.Structure template notNil.
	self assert: #{External.Field} isDefined.
	self assert: #{Smalltalk.ExternalField} isDefined! !
!Tools.Tests.LagoonTests categoriesForMethods!
testExternalStructureAfterTemplateRemoval!public!unit tests! !
!

