"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #CodeMentorTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CodeMentorTest guid: (GUID fromString: '{57ac07f6-6b32-42d2-a0cd-7488ae11ec92}')!
CodeMentorTest comment: ''!
!CodeMentorTest categoriesForClass!Unclassified! !
!CodeMentorTest methodsFor!

testLintRulesXml
	"Verify that there is an entry in the lint rules xml file for each of the lint rules."

	| xml rules name xpath node |
	xml := CodeMentorPlugin lintRulesDoc.
	rules := CodeMentorPlugin lintRules.
	rules allRules do: 
			[:each | 
			name := each name copyReplaceAll: '"' with: '\"'.
			xpath := './/LintRule[name="<1s>"]' expandMacrosWith: name.
			node := xml selectSingleNode: xpath.
			self deny: node isNil]! !
!CodeMentorTest categoriesFor: #testLintRulesXml!public!unit tests! !

