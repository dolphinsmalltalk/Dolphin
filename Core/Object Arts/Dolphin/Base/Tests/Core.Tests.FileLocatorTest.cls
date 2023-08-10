"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'Core.Tests.FileLocatorTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Tests.FileLocatorTest guid: (Core.GUID fromString: '{635f7234-ba5a-4a72-97b1-40d81990cad7}')!
Core.Tests.FileLocatorTest comment: ''!
!Core.Tests.FileLocatorTest methodsFor!

testAbsoluteFileLocator
	| locator workingDir relative absolute |
	locator := FileLocator absolute.
	self assert: locator isSelfEvaluating.
	self assert: (Compiler evaluate: locator printString) equals: locator.
	workingDir := File workingDirectory.
	absolute := SessionManager current imageFileName.
	relative := File relativePathOf: absolute to: workingDir.
	"Rather counterintuitively from an API perspective, the absolute locator will convert a path relative to the working directory to an absolute path when sent #relativePathTo:, but this is because that API is misnamed. Really we are asking the locator to convert a path to the minimal form that it can reverse back to a full path, i.e. translate to locator namespace. For an absolute locator, the minimal form is always a full path."
	self assert: (locator relativePathTo: relative) equals: absolute.
	"Doesn't perform any translation to local file spec (which is really the request for the locator to map from a path in its minimal form back to the full path of the file, i.e. translate from locator namespace to global namespace)"
	self assert: (locator localFileSpecFor: absolute) equals: absolute!

testImageRelativeFileLocator
	| locator relative fullpath |
	locator := FileLocator imageRelative.
	self assert: locator isSelfEvaluating.
	self assert: (Compiler evaluate: locator printString) equals: locator.

	"File in base directory."
	fullpath := File composePath: SessionManager current imageBase subPath: 'dolphin.img'.
	relative := locator relativePathTo: fullpath.
	self assert: relative equals: 'dolphin.img'.
	self assert: (locator localFileSpecFor: relative) equals: fullpath.

	"File in sub-directory"
	fullpath := File composePath: SessionManager current imageBase subPath: 'backup\dolphin.img'.
	relative := locator relativePathTo: fullpath.
	self assert: relative equals: 'backup\dolphin.img'.
	self assert: (locator localFileSpecFor: relative) equals: fullpath.

	"File in parent directory"
	fullpath := File composePath: SessionManager current imageBase subPath: '..\dolphin.img'.
	relative := locator relativePathTo: fullpath.
	self assert: relative equals: fullpath.
	self assert: (locator localFileSpecFor: relative) equals: fullpath.

	"File in sibling directory"
	fullpath := File composePath: SessionManager current imageBase subPath: '..\dolphin4\dolphin.img'.
	relative := locator relativePathTo: fullpath.
	self assert: relative equals: fullpath.
	self assert: (locator localFileSpecFor: relative) equals: fullpath.

	"File in different hierarchy - should use absolute path"
	fullpath := 'd:\blah\blah.txt'.
	relative := locator relativePathTo: fullpath.
	self assert: relative equals: fullpath.
	self assert: (locator localFileSpecFor: relative) equals: fullpath.

	"File in different drive - should use absolute path"
	fullpath := 'c:\winnt\system32\user32.dll'.
	relative := locator relativePathTo: fullpath.
	self assert: relative equals: fullpath.
	self assert: (locator localFileSpecFor: relative) equals: fullpath!

testInstallRelativeFileLocator
	| locator relative fullpath base |
	locator := FileLocator installRelative.
	self assert: locator isSelfEvaluating.
	self assert: (Compiler evaluate: locator printString) equals: locator.

	"File in base directory."
	base := SessionManager current installationDirectory.
	fullpath := File composePath: base subPath: 'dolphin.img'.
	relative := locator relativePathTo: fullpath.
	self assert: relative equals: 'dolphin.img'.
	self assert: ((locator localFileSpecFor: relative) sameAs: fullpath).

	"File in sub-directory"
	fullpath := File composePath: base subPath: 'backup\dolphin.img'.
	relative := locator relativePathTo: fullpath.
	self assert: relative equals: 'backup\dolphin.img'.
	self assert: ((locator localFileSpecFor: relative) sameAs: fullpath).

	"File in parent directory"
	fullpath := File composePath: SessionManager current imageBase subPath: '..\dolphin.img'.
	relative := locator relativePathTo: fullpath.
	self assert: relative equals: fullpath.
	self assert: (locator localFileSpecFor: relative) equals: fullpath.

	"File in sibling directory"
	fullpath := File composePath: SessionManager current imageBase subPath: '..\dolphin4\dolphin.img'.
	relative := locator relativePathTo: fullpath.
	self assert: relative equals: fullpath.
	self assert: (locator localFileSpecFor: relative) equals: fullpath.

	"File in different hierarchy - should use absolute path"
	fullpath := 'd:\blah\blah.txt'.
	relative := locator relativePathTo: fullpath.
	self assert: relative equals: fullpath.
	self assert: (locator localFileSpecFor: relative) equals: fullpath.

	"File in different drive - should use absolute path"
	fullpath := 'c:\winnt\system32\user32.dll'.
	relative := locator relativePathTo: fullpath.
	self assert: relative equals: fullpath.
	self assert: (locator localFileSpecFor: relative) equals: fullpath! !
!Core.Tests.FileLocatorTest categoriesForMethods!
testAbsoluteFileLocator!public!unit tests! !
testImageRelativeFileLocator!public!unit tests! !
testInstallRelativeFileLocator!public!unit tests! !
!

