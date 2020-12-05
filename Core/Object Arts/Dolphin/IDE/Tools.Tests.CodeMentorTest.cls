"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTest subclass: #'Tools.Tests.CodeMentorTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.Tests.CodeMentorTest guid: (Core.GUID fromString: '{57ac07f6-6b32-42d2-a0cd-7488ae11ec92}')!
Tools.Tests.CodeMentorTest comment: ''!
!Tools.Tests.CodeMentorTest categoriesForClass!Unclassified! !
!Tools.Tests.CodeMentorTest methodsFor!

testLintRulesXml
	"Verify that there is an entry in the lint rules xml file for each of the lint rules."

	| xml rules name xpath node |
	rules := CodeMentorPlugin lintRules.
	"Escaping quotes in xpath's is notoriously complicated. To avoid that, use the older MSXML DOM version that supported C-style quoting"
	xml := MSXML.IXMLDOMDocument2 newDOMDocument30 loadURL: CodeMentorPlugin lintRulesDocURL.
	rules allRules do: 
			[:each |
			name := each name copyReplaceAll: '"' with: '\"'.
			xpath := './/LintRule[name="<1s>"]' expandMacrosWithArguments: {name} locale: Locale invariant.
			node := xml selectSingleNode: xpath.
			self deny: node isNil]! !
!Tools.Tests.CodeMentorTest categoriesFor: #testLintRulesXml!public!unit tests! !

